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

            // Job ilerleme sayacı
            item.Job!.CompletedItems += 1;
            bool jobJustCompleted = false;
            if (item.Job.CompletedItems >= item.Job.TotalItems)
            {
                item.Job.Status = "done";
                jobJustCompleted = true;
            }

            await _db.SaveChangesAsync();

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

            // Tüm görseller bitti → kullanıcıya push bildirimi gönder
            if (jobJustCompleted)
            {
                var jobUser = await _db.Users
                    .FirstOrDefaultAsync(u => u.Id == item.Job.UserId);

                if (jobUser?.FcmToken != null)
                {
                    await _notification.SendNotificationAsync(
                        jobUser.FcmToken,
                        "Vitrify",
                        $"🎉 {item.Job.TotalItems} görseliniz hazır!",
                        new Dictionary<string, string>
                        {
                            { "jobId", item.Job.Id.ToString() },
                            { "type", "job_completed" }
                        });
                }
            }
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

            throw; // Hangfire retry için
        }
        finally
        {
            _semaphore.Release(); // slot serbest
        }
    }
}