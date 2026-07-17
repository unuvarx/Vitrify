using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using Vitrify.API.Data;
using Vitrify.API.Hubs;

namespace Vitrify.API.Services;

public class JobProcessingService
{
    private readonly AppDbContext _db;
    private readonly GeminiService _gemini;
    private readonly IHubContext<JobHub> _hub;
    private readonly NotificationService _notification;

    // Gemini rate limit'i çok daha yüksek, paralel artırabiliriz
    private static readonly SemaphoreSlim _semaphore = new SemaphoreSlim(5);

    public JobProcessingService(
        AppDbContext db,
        GeminiService gemini,
        IHubContext<JobHub> hub,
        NotificationService notification)
    {
        _db = db;
        _gemini = gemini;
        _hub = hub;
        _notification = notification;
    }
    // Tek bir JobItem'ı işler (Hangfire bunu arka planda çağırır)
    public async Task ProcessJobItemAsync(Guid jobItemId)
    {
        var item = await _db.JobItems
            .Include(i => i.Job)
            .FirstOrDefaultAsync(i => i.Id == jobItemId);

        if (item == null) return;
        if (item.Status == "done") return; // zaten bitmiş

        await _semaphore.WaitAsync(); // sıraya gir (max 20 eşzamanlı)
        try
        {
            item.Status = "processing";
            // Hangfire bu kalemi daha önce başarısız olup tekrar deniyor olabilir —
            // job "done" işaretlenmişse yeniden "processing"e al (aşağıda tekrar değerlendirilecek)
            if (item.Job!.Status == "done")
                item.Job.Status = "processing";
            await _db.SaveChangesAsync();

            // Görseli üret (Gemini base64 döndürür)
            // ReplicateFileUrl = saf base64 (data: öneki olmadan) saklıyoruz
            var outputBase64 = await _gemini.GenerateImageAsync(
                item.Scenario,           // prompt (mekan+senaryo)
                item.ReplicateFileUrl!,  // görselin base64'ü
                "1:1"                    // aspect ratio (şimdilik sabit, sonra dinamik)
            );

            // Başarılı — çıktı base64, data URI formatında sakla
            item.OutputUrl = $"data:image/jpeg;base64,{outputBase64}";
            item.Status = "done";

            // SADECE başarılıysa kredi düş
            if (!item.CreditDeducted)
            {
                var user = await _db.Users.FirstOrDefaultAsync(u => u.Id == item.Job!.UserId);
                if (user != null && user.Credits > 0)
                {
                    user.Credits -= 1;
                    item.CreditDeducted = true;
                }
            }

            // Job ilerleme sayacı (sadece başarılı sayımı - progress bar için)
            item.Job!.CompletedItems += 1;
            await _db.SaveChangesAsync();

            // Bu kalemle birlikte job'daki tüm kalemler terminal duruma ulaştıysa
            // (done/failed) job'ı bitir ve item.Job.Status'ü güncelle
            await FinalizeJobIfCompleteAsync(item.JobId);

            // Flutter'a ANINDA haber ver: "bu görsel hazır!"
            await _hub.Clients.Group(item.JobId.ToString()).SendAsync(
                "ImageReady",
                new
                {
                    jobId = item.JobId,
                    jobItemId = item.Id,
                    outputUrl = item.OutputUrl,
                    completedItems = item.Job!.CompletedItems,
                    totalItems = item.Job.TotalItems,
                    jobStatus = item.Job.Status
                });
        }
        catch (Exception)
        {
            // Başarısız → kredi DÜŞMEZ
            item.Status = "failed";
            await _db.SaveChangesAsync();

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
    private async Task FinalizeJobIfCompleteAsync(Guid jobId)
    {
        var stillPending = await _db.JobItems.AnyAsync(i =>
            i.JobId == jobId && (i.Status == "pending" || i.Status == "processing"));

        if (stillPending) return;

        var job = await _db.Jobs.FirstOrDefaultAsync(j => j.Id == jobId);
        if (job == null || job.Status == "done") return;

        job.Status = "done";
        await _db.SaveChangesAsync();

        var jobUser = await _db.Users.FirstOrDefaultAsync(u => u.Id == job.UserId);
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
    }
}