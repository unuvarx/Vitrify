namespace Vitrify.API.Models;

public class JobItem
{
    public Guid Id { get; set; } = Guid.NewGuid();

    public Guid JobId { get; set; }
    public Job? Job { get; set; }

    // Girdi görselinin saf base64'ü (Gemini'ye gönderilir).
    // Başarılı üretimden sonra null'lanır — tekrar gerekmiyor, yer kaplamasın.
    public string? ReplicateFileUrl { get; set; }

    // Hangi senaryo ile üretildi
    public string Scenario { get; set; } = string.Empty;

    // Üretilen görselin URL'si (Replicate çıktısı)
    public string? OutputUrl { get; set; }

    // pending / processing / done / failed
    public string Status { get; set; } = "pending";

    // Kredi düşüldü mü? (sadece başarılı üretimde true)
    public bool CreditDeducted { get; set; } = false;

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}