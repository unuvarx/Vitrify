namespace Vitrify.API.DTOs;

// Satın alma sonrası durum sorgusu (Flutter → Backend). Kredi miktarı
// KASITLI OLARAK burada yok — gerçek kredi ekleme RevenueCatWebhookController
// üzerinden, RevenueCat'in doğruladığı satın almayla yapılıyor. Bu istek
// sadece "webhook işlemeyi bitirdi mi?" diye soruyor.
public class AddCreditsRequest
{
    // App Store / Play Store işlem kimliği
    public string StoreTransactionId { get; set; } = string.Empty;
}

// Kredi bilgisi cevabı
public class CreditBalanceResponse
{
    public int Credits { get; set; }
}