namespace Vitrify.API.DTOs;

// Satın alma sonrası kredi ekleme isteği (Flutter → Backend)
public class AddCreditsRequest
{
    // App Store / Play Store işlem kimliği (mükerrer önleme)
    public string StoreTransactionId { get; set; } = string.Empty;

    // Kaç kredi eklenecek (satın alınan pakete göre)
    public int Credits { get; set; }

    // "ios" / "android"
    public string Platform { get; set; } = string.Empty;
}

// Kredi bilgisi cevabı
public class CreditBalanceResponse
{
    public int Credits { get; set; }
}