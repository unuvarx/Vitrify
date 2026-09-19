using Microsoft.EntityFrameworkCore;
using Vitrify.API.Data;

namespace Vitrify.API.Services;

// JobImage satırları normalde bir job başarıyla bitince hemen siliniyor
// (JobProcessingService.FinalizeJobIfCompleteAsync). Ama bir kalem kalıcı
// olarak "failed" kalırsa (Hangfire'ın tüm tekrar denemeleri tükendiğinde)
// ya da bir job herhangi bir nedenle "pending"/"processing" durumunda takılı
// kalırsa, o job'un görsel verisi hiç silinmeden veritabanında birikir.
// Bu servis, artık hiçbir işleme yaramayacak kadar eski (7+ gün) bu tür
// kalıntıları günlük olarak temizler.
public class DatabaseCleanupService
{
    private readonly AppDbContext _db;
    private readonly ILogger<DatabaseCleanupService> _logger;

    public DatabaseCleanupService(AppDbContext db, ILogger<DatabaseCleanupService> logger)
    {
        _db = db;
        _logger = logger;
    }

    public async Task CleanupStaleJobImagesAsync()
    {
        var cutoff = DateTime.UtcNow.AddDays(-7);

        var deleted = await _db.JobImages
            .Where(img => _db.Jobs.Any(j => j.Id == img.JobId && j.CreatedAt < cutoff))
            .ExecuteDeleteAsync();

        if (deleted > 0)
        {
            _logger.LogInformation(
                "DatabaseCleanupService: {Count} adet 7+ gün eski JobImage satırı silindi.", deleted);
        }
    }
}
