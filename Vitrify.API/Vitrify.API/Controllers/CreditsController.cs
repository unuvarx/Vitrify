using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Vitrify.API.Data;
using Vitrify.API.DTOs;

namespace Vitrify.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class CreditsController : BaseApiController
{
    private readonly AppDbContext _db;

    public CreditsController(AppDbContext db)
    {
        _db = db;
    }

    // Kredi bakiyesini sorgula
    [Authorize]
    [HttpGet("balance")]
    public async Task<IActionResult> GetBalance()
    {
        var firebaseUid = GetFirebaseUid();
        if (string.IsNullOrEmpty(firebaseUid))
            return Unauthorized();

        var user = await _db.Users.FirstOrDefaultAsync(u => u.FirebaseUid == firebaseUid);
        if (user == null)
            return NotFound(new { message = "Kullanıcı bulunamadı." });

        return Ok(new CreditBalanceResponse { Credits = user.Credits });
    }

    // ⚠️ GÜVENLİK NOTU:
    // Gerçek kredi ekleme artık burada DEĞİL, RevenueCatWebhookController'da
    // yapılıyor — RevenueCat'in kendisinin doğruladığı satın alma bildirimiyle.
    // Bu endpoint sadece Flutter'ın "satın alma tamamlandı, webhook işlemeyi
    // bitirdi mi?" diye sorup ekranı güncelleyebilmesi için var. Client'tan
    // gelen hiçbir veri (kredi miktarı dahil) krediyi artırmak için kullanılmıyor.
    [Authorize]
    [HttpPost("add")]
    public async Task<IActionResult> AddCredits([FromBody] AddCreditsRequest request)
    {
        var firebaseUid = GetFirebaseUid();
        if (string.IsNullOrEmpty(firebaseUid))
            return Unauthorized();

        var user = await _db.Users.FirstOrDefaultAsync(u => u.FirebaseUid == firebaseUid);
        if (user == null)
            return NotFound(new { message = "Kullanıcı bulunamadı." });

        if (string.IsNullOrEmpty(request.StoreTransactionId))
            return BadRequest(new { message = "İşlem kimliği gerekli." });

        // RevenueCat webhook'u genelde saniyeler içinde işler ama satın alma
        // callback'iyle eşzamanlı garanti değil — kısa bir süre bekleyip
        // (toplam ~6sn) webhook'un işleyip işlemediğini birkaç kez kontrol ediyoruz.
        for (var attempt = 0; attempt < 6; attempt++)
        {
            var processed = await _db.Purchases
                .AsNoTracking()
                .AnyAsync(p => p.StoreTransactionId == request.StoreTransactionId);

            if (processed)
            {
                var currentCredits = await _db.Users
                    .Where(u => u.Id == user.Id)
                    .Select(u => u.Credits)
                    .FirstAsync();

                return Ok(new { credits = currentCredits, processed = true });
            }

            await Task.Delay(1000);
        }

        // Webhook henüz gelmedi — satın alma muhtemelen geçerli ama kredi
        // birazdan görünecek, kullanıcıyı bekletmeden mevcut bakiyeyi dön
        return Ok(new { credits = user.Credits, processed = false });
    }
}