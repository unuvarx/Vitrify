namespace Vitrify.API.Models;

public class JobItem
{
    public Guid Id { get; set; } = Guid.NewGuid();

    public Guid JobId { get; set; }
    public Job? Job { get; set; }

    // Replicate'e yüklenen orijinal görselin URL'si
    public string? ReplicateFileUrl { get; set; }

    // Replicate prediction kimliği
    public string? ReplicatePredictionId { get; set; }

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