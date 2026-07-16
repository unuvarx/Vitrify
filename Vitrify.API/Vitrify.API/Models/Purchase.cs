namespace Vitrify.API.Models;

public class Purchase
{
    public Guid Id { get; set; } = Guid.NewGuid();

    public Guid UserId { get; set; }
    public User? User { get; set; }

    // Satın alınan kredi miktarı
    public int CreditsAdded { get; set; }

    // App Store / Play Store işlem kimliği (tekrarı önler)
    public string StoreTransactionId { get; set; } = string.Empty;

    // "ios" / "android"
    public string Platform { get; set; } = string.Empty;

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}