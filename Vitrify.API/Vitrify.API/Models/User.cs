namespace Vitrify.API.Models;

public class User
{
    public Guid Id { get; set; } = Guid.NewGuid();

    // Firebase'den gelen benzersiz kullanıcı kimliği
    public string FirebaseUid { get; set; } = string.Empty;

    // Cihaz kilidi için
    public string DeviceId { get; set; } = string.Empty;
    public string DevicePlatform { get; set; } = string.Empty; // "ios" / "android"

    // İlk indirmede verilecek ücretsiz kredi
    public int Credits { get; set; } = 5;

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    // İlişkiler
    public List<Job> Jobs { get; set; } = new();
    public List<Purchase> Purchases { get; set; } = new();
    // Firebase Cloud Messaging cihaz token'ı (push bildirim için)
    public string? FcmToken { get; set; }
}