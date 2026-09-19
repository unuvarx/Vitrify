using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Text.Json;
using System.Text.Json.Serialization;
using Vitrify.API.Data;
using Vitrify.API.Models;

namespace Vitrify.API.Controllers;

// RevenueCat'in gönderdiği sunucu-sunucu satın alma bildirimleri.
// Gerçek para kaynağı BURASI — CreditsController.AddCredits artık kredi
// eklemiyor, sadece bu webhook'un işleyip işlemediğini kontrol ediyor.
// Flutter'dan gelen hiçbir veriye (kredi miktarı dahil) güvenilmiyor.
[ApiController]
[Route("api/webhooks/revenuecat")]
public class RevenueCatWebhookController : ControllerBase
{
    private readonly AppDbContext _db;
    private readonly IConfiguration _config;
    private readonly ILogger<RevenueCatWebhookController> _logger;

    // Ürün kimliği → kredi miktarı. App Store Connect / Play Console'daki
    // gerçek ürün kimlikleriyle birebir eşleşmeli.
    private static readonly Dictionary<string, int> ProductCredits = new()
    {
        { "credits_50", 50 },
        { "credits_120", 120 },
        { "credits_250", 250 },
    };

    // RevenueCat'in bir satın almayı gerçekten tamamlandı sayan event tipleri
    // (abonelik olaylarını -RENEWAL, CANCELLATION vb.- kasıtlı olarak
    // yok sayıyoruz, tüketilebilir kredi paketlerimiz için geçerli değiller)
    private static readonly HashSet<string> PurchaseEventTypes = new()
    {
        "INITIAL_PURCHASE",
        "NON_RENEWING_PURCHASE",
    };

    public RevenueCatWebhookController(
        AppDbContext db, IConfiguration config, ILogger<RevenueCatWebhookController> logger)
    {
        _db = db;
        _config = config;
        _logger = logger;
    }

    [HttpPost]
    public async Task<IActionResult> HandleWebhook()
    {
        // RevenueCat, dashboard'da tanımladığımız sabit değeri her istekte
        // Authorization header'ında geri gönderir — bu bizim paylaşılan sırrımız.
        var expectedAuth = _config["RevenueCat:WebhookAuthHeader"];
        if (string.IsNullOrEmpty(expectedAuth) ||
            Request.Headers.Authorization.ToString() != expectedAuth)
        {
            return Unauthorized();
        }

        RevenueCatWebhookPayload? payload;
        using (var reader = new StreamReader(Request.Body))
        {
            var body = await reader.ReadToEndAsync();
            try
            {
                payload = JsonSerializer.Deserialize<RevenueCatWebhookPayload>(body);
            }
            catch (JsonException ex)
            {
                _logger.LogWarning(ex, "RevenueCat webhook: geçersiz JSON.");
                return Ok(); // Tekrar denemesi işe yaramaz, RevenueCat'i retry döngüsüne sokma
            }
        }

        var evt = payload?.Event;
        if (evt == null || string.IsNullOrEmpty(evt.AppUserId) ||
            string.IsNullOrEmpty(evt.TransactionId) || string.IsNullOrEmpty(evt.ProductId))
        {
            return Ok();
        }

        if (!PurchaseEventTypes.Contains(evt.Type ?? string.Empty))
        {
            return Ok(); // Bizi ilgilendirmeyen event (RENEWAL, CANCELLATION, vb.)
        }

        if (!ProductCredits.TryGetValue(evt.ProductId, out var credits))
        {
            _logger.LogWarning("RevenueCat webhook: bilinmeyen ürün kimliği {ProductId}", evt.ProductId);
            return Ok();
        }

        // MÜKERRER KONTROL: RevenueCat aynı event'i birden fazla kez
        // gönderebilir (retry) — transaction id zaten işlendiyse tekrar ekleme
        var alreadyProcessed = await _db.Purchases
            .AnyAsync(p => p.StoreTransactionId == evt.TransactionId);
        if (alreadyProcessed)
        {
            return Ok();
        }

        var user = await _db.Users.FirstOrDefaultAsync(u => u.FirebaseUid == evt.AppUserId);
        if (user == null)
        {
            _logger.LogWarning("RevenueCat webhook: kullanıcı bulunamadı (FirebaseUid={AppUserId})", evt.AppUserId);
            return Ok();
        }

        // Önce Purchase satırını KENDİ BAŞINA commit ediyoruz — StoreTransactionId
        // üzerindeki unique index, RevenueCat'in aynı event'i eşzamanlı iki kez
        // göndermesi durumunda ikinci isteği burada elesin diye. Krediyi ancak
        // bu insert kesin başarılı olduysa ekliyoruz; aksi sırada iki eşzamanlı
        // istek insert'ten ÖNCE ikisi de krediyi eklemiş olabilirdi (çifte kredi).
        _db.Purchases.Add(new Purchase
        {
            UserId = user.Id,
            CreditsAdded = credits,
            StoreTransactionId = evt.TransactionId,
            Platform = evt.Store == "PLAY_STORE" ? "android" : "ios",
        });

        try
        {
            await _db.SaveChangesAsync();
        }
        catch (DbUpdateException)
        {
            // Unique constraint ihlali → bu transaction id'yi eşzamanlı başka
            // bir istek zaten işledi, kredi ekleme
            return Ok();
        }

        await _db.Users
            .Where(u => u.Id == user.Id)
            .ExecuteUpdateAsync(s => s.SetProperty(u => u.Credits, u => u.Credits + credits));

        return Ok();
    }
}

public class RevenueCatWebhookPayload
{
    [JsonPropertyName("event")]
    public RevenueCatEvent? Event { get; set; }
}

public class RevenueCatEvent
{
    [JsonPropertyName("type")]
    public string? Type { get; set; }

    [JsonPropertyName("app_user_id")]
    public string? AppUserId { get; set; }

    [JsonPropertyName("product_id")]
    public string? ProductId { get; set; }

    [JsonPropertyName("transaction_id")]
    public string? TransactionId { get; set; }

    [JsonPropertyName("store")]
    public string? Store { get; set; }
}
