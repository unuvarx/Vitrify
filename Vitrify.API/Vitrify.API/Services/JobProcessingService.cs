using System.Diagnostics;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using Vitrify.API.Data;
using Vitrify.API.Hubs;

namespace Vitrify.API.Services;

public class JobProcessingService
{
    private readonly AppDbContext _db;
    private readonly GeminiService _gemini;
    private readonly SupabaseStorageService _storage;
    private readonly IHubContext<JobHub> _hub;
    private readonly NotificationService _notification;
    private readonly ILogger<JobProcessingService> _logger;

    // Gemini rate limit'i çok daha yüksek, paralel artırabiliriz
    private static readonly SemaphoreSlim _semaphore = new SemaphoreSlim(5);

    public JobProcessingService(
        AppDbContext db,
        GeminiService gemini,
        SupabaseStorageService storage,
        IHubContext<JobHub> hub,
        NotificationService notification,
        ILogger<JobProcessingService> logger)
    {
        _db = db;
        _gemini = gemini;
        _storage = storage;
        _hub = hub;
        _notification = notification;
        _logger = logger;
    }

    // NOT: Bu serviste kasıtlı olarak hiçbir yerde SaveChangesAsync() kullanmıyoruz.
    // İlk denemede JobItems+Jobs'u aynı SaveChangesAsync() içinde (ya da hatta ayrı
    // ExecuteUpdateAsync çağrılarından SONRA tracked entity'lere elle atama yapıp
    // başka bir yerdeki SaveChangesAsync'in onları da sürüklemesiyle) birlikte
    // güncellemek, Supabase pooler'ında 40-50 saniyeye varan gecikmelere yol açtı.
    // Kökeni: entity'ler tracked kalınca, elle yapılan property atamaları EF'i
    // "kirli" (dirty) işaretliyor ve context'teki HERHANGİ bir SaveChangesAsync
    // çağrısı bunları da sürüklüyor. Çözüm: ilk sorguyu AsNoTracking yap, tüm
    // yazmaları bağımsız atomic ExecuteUpdateAsync ile yap — hiçbir entity asla
    // tracked olmasın.

    // Tek bir JobItem'ı işler (Hangfire bunu arka planda çağırır)
    public async Task ProcessJobItemAsync(Guid jobItemId)
    {
        var item = await _db.JobItems
            .AsNoTracking()
            .Include(i => i.Job)
            .FirstOrDefaultAsync(i => i.Id == jobItemId);

        if (item == null) return;
        if (item.Status == "done") return; // zaten bitmiş

        await _semaphore.WaitAsync(); // sıraya gir (max 20 eşzamanlı)
        try
        {
            var stopwatch = Stopwatch.StartNew();

            await _db.JobItems
                .Where(i => i.Id == item.Id)
                .ExecuteUpdateAsync(s => s.SetProperty(i => i.Status, "processing"));

            // Hangfire bu kalemi daha önce başarısız olup tekrar deniyor olabilir —
            // job "done" işaretlenmişse yeniden "processing"e al (aşağıda tekrar değerlendirilecek)
            if (item.Job!.Status == "done")
            {
                await _db.Jobs
                    .Where(j => j.Id == item.JobId)
                    .ExecuteUpdateAsync(s => s.SetProperty(j => j.Status, "processing"));
            }
            _logger.LogInformation(
                "[timing] {JobItemId}: ilk durum guncellemesi {ElapsedMs}ms",
                item.Id, stopwatch.ElapsedMilliseconds);

            // Görseli üret (Gemini base64 döndürür)
            // ReplicateFileUrl = saf base64 (data: öneki olmadan) saklıyoruz
            stopwatch.Restart();
            var outputBase64 = await _gemini.GenerateImageAsync(
                item.Scenario,           // prompt (mekan+senaryo)
                item.ReplicateFileUrl!,  // görselin base64'ü
                "1:1"                    // aspect ratio (şimdilik sabit, sonra dinamik)
            );
            _logger.LogInformation(
                "[timing] {JobItemId}: Gemini cagrisi {ElapsedMs}ms",
                item.Id, stopwatch.ElapsedMilliseconds);

            // Gemini genelde PNG (kayıpsız) döndürüyor — Storage'a yüklemeden
            // önce kaliteli JPEG'e çeviriyoruz (çözünürlüğe dokunmadan).
            // Görünür kalite kaybı yaratmadan dosya boyutunu ~%80 küçültüyor.
            var jpegBytes = _gemini.EncodeAsJpeg(Convert.FromBase64String(outputBase64));

            // Başarılı — çıktıyı Supabase Storage'a yükle, Postgres'e sadece
            // kısa bir public URL yazacağız (büyük base64 blob yazmak yerine)
            stopwatch.Restart();
            var newOutputUrl = await _storage.UploadImageAsync(
                jpegBytes,
                $"{item.Id}.jpg");
            _logger.LogInformation(
                "[timing] {JobItemId}: Storage yuklemesi {ElapsedMs}ms",
                item.Id, stopwatch.ElapsedMilliseconds);

            stopwatch.Restart();

            // SADECE başarılıysa kredi düş — aynı Job'un kalemleri eşzamanlı
            // işlendiği için oku-değiştir-yaz yerine atomic UPDATE kullanıyoruz
            // (aksi halde eşzamanlı kalemler birbirinin kredi düşüşünü ezer)
            var creditDeducted = item.CreditDeducted;
            if (!creditDeducted)
            {
                var rowsAffected = await _db.Users
                    .Where(u => u.Id == item.Job!.UserId && u.Credits > 0)
                    .ExecuteUpdateAsync(s => s.SetProperty(u => u.Credits, u => u.Credits - 1));

                creditDeducted = rowsAffected > 0;
            }

            // JobItem'ı bağımsız atomic UPDATE ile güncelle. Girdi görseli
            // (ReplicateFileUrl) artık gerekmiyor — Supabase'de gereksiz yer
            // kaplamasın diye null'luyoruz (yalnızca başarı durumunda; "failed"
            // kalemlerde Hangfire tekrar deneyeceği için dokunmuyoruz).
            await _db.JobItems
                .Where(i => i.Id == item.Id)
                .ExecuteUpdateAsync(s => s
                    .SetProperty(i => i.OutputUrl, newOutputUrl)
                    .SetProperty(i => i.Status, "done")
                    .SetProperty(i => i.CreditDeducted, creditDeducted)
                    .SetProperty(i => i.ReplicateFileUrl, (string?)null));

            // Job ilerleme sayacı (sadece başarılı sayımı - progress bar için)
            await _db.Jobs
                .Where(j => j.Id == item.JobId)
                .ExecuteUpdateAsync(s => s.SetProperty(j => j.CompletedItems, j => j.CompletedItems + 1));

            _logger.LogInformation(
                "[timing] {JobItemId}: kredi dusme + JobItem/Job atomic update {ElapsedMs}ms",
                item.Id, stopwatch.ElapsedMilliseconds);

            stopwatch.Restart();
            // Bu kalemle birlikte job'daki tüm kalemler terminal duruma ulaştıysa
            // (done/failed) job'ı bitir ve item.Job.Status'ü güncelle
            var jobStatus = await FinalizeJobIfCompleteAsync(item.JobId) ?? item.Job.Status;
            _logger.LogInformation(
                "[timing] {JobItemId}: FinalizeJobIfCompleteAsync {ElapsedMs}ms",
                item.Id, stopwatch.ElapsedMilliseconds);

            // Flutter'a ANINDA haber ver: "bu görsel hazır!"
            await _hub.Clients.Group(item.JobId.ToString()).SendAsync(
                "ImageReady",
                new
                {
                    jobId = item.JobId,
                    jobItemId = item.Id,
                    outputUrl = newOutputUrl,
                    completedItems = item.Job.CompletedItems + 1,
                    totalItems = item.Job.TotalItems,
                    jobStatus
                });
        }
        catch (Exception)
        {
            // Başarısız → kredi DÜŞMEZ
            await _db.JobItems
                .Where(i => i.Id == item.Id)
                .ExecuteUpdateAsync(s => s.SetProperty(i => i.Status, "failed"));

            // Flutter'a haber ver: "bu görsel başarısız oldu"
            await _hub.Clients.Group(item.JobId.ToString()).SendAsync(
                "ImageFailed",
                new
                {
                    jobId = item.JobId,
                    jobItemId = item.Id
                });

            // Bu kalem kalıcı olarak başarısız oldu — diğer tüm kalemler de
            // terminal durumdaysa job'ı yine de bitir ve bildirim gönder
            // (aksi halde bir kalem hiç bitmemiş gibi Job sonsuza dek "processing" kalırdı)
            await FinalizeJobIfCompleteAsync(item.JobId);

            throw; // Hangfire retry için
        }
        finally
        {
            _semaphore.Release(); // slot serbest
        }
    }

    // Job'a ait bekleyen/işlenen kalem kalmadıysa job'ı "done" işaretler ve
    // tamamlanma push bildirimini gönderir. Hangfire bir kalemi sonradan tekrar
    // denerse job en tepede otomatik olarak "processing"e döner ve bir sonraki
    // çağrıda burada yeniden değerlendirilir — bu yüzden sayaç yerine canlı
    // sorgu kullanıyoruz (çift sayım riski olmadan).
    // Dönüş değeri: job'ın güncel Status'ü (finalize edildiyse "done", edilmediyse null).
    private async Task<string?> FinalizeJobIfCompleteAsync(Guid jobId)
    {
        var stillPending = await _db.JobItems.AnyAsync(i =>
            i.JobId == jobId && (i.Status == "pending" || i.Status == "processing"));

        if (stillPending) return null;

        var rowsAffected = await _db.Jobs
            .Where(j => j.Id == jobId && j.Status != "done")
            .ExecuteUpdateAsync(s => s.SetProperty(j => j.Status, "done"));

        if (rowsAffected == 0) return null; // zaten "done" idi ya da bulunamadı

        var job = await _db.Jobs.AsNoTracking().FirstOrDefaultAsync(j => j.Id == jobId);
        if (job == null) return "done";

        var jobUser = await _db.Users.AsNoTracking().FirstOrDefaultAsync(u => u.Id == job.UserId);
        if (jobUser?.FcmToken != null)
        {
            await _notification.SendNotificationAsync(
                jobUser.FcmToken,
                "Vitrify",
                $"{job.TotalItems} görseliniz işlendi.",
                new Dictionary<string, string>
                {
                    { "jobId", job.Id.ToString() },
                    { "type", "job_completed" }
                });
        }

        return "done";
    }
}
