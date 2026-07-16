using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Vitrify.API.Data;
using Vitrify.API.DTOs;
using Vitrify.API.Models;

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
    // // Bu endpoint şu an ödemeyi DOĞRULAMIYOR (geliştirme aşaması).
    // // Production'da RevenueCat webhook'u ile değiştirilecek (Adım 20).
    // // O zaman ödeme RevenueCat tarafında doğrulanacak, Flutter'a güvenilmeyecek.
   
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

        // Doğrulama
        if (string.IsNullOrEmpty(request.StoreTransactionId))
            return BadRequest(new { message = "İşlem kimliği gerekli." });
        if (request.Credits <= 0)
            return BadRequest(new { message = "Geçersiz kredi miktarı." });

        // MÜKERRER KONTROL: bu işlem daha önce işlendi mi?
        var alreadyProcessed = await _db.Purchases
            .AnyAsync(p => p.StoreTransactionId == request.StoreTransactionId);

        if (alreadyProcessed)
        {
            // Bu satın alım zaten işlenmiş → tekrar kredi ekleme
            return Ok(new
            {
                message = "Bu işlem daha önce işlendi.",
                credits = user.Credits,
                alreadyProcessed = true
            });
        }

        // Satın alım kaydı oluştur
        var purchase = new Purchase
        {
            UserId = user.Id,
            CreditsAdded = request.Credits,
            StoreTransactionId = request.StoreTransactionId,
            Platform = request.Platform
        };
        _db.Purchases.Add(purchase);

        // Krediyi ekle
        user.Credits += request.Credits;

        await _db.SaveChangesAsync();

        return Ok(new
        {
            message = "Kredi eklendi.",
            credits = user.Credits,
            addedCredits = request.Credits,
            alreadyProcessed = false
        });
    }
}