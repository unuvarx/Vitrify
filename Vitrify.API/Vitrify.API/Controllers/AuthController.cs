using FirebaseAdmin.Auth;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using Vitrify.API.Data;
using Vitrify.API.DTOs;
using Vitrify.API.Models;

namespace Vitrify.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController : BaseApiController
{
    private readonly AppDbContext _db;

    public AuthController(AppDbContext db)
    {
        _db = db;
    }

    // Herkese açık - test için
    [HttpGet("public")]
    public IActionResult Public()
    {
        return Ok(new { message = "Backend çalışıyor!" });
    }

    // Giriş / Kayıt + Cihaz Bazlı Kredi İstismarı Koruması
    [Authorize]
    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] LoginRequest request)
    {
        var firebaseUid = GetFirebaseUid();
        if (string.IsNullOrEmpty(firebaseUid))
            return Unauthorized(new { message = "Geçersiz token." });

        if (string.IsNullOrEmpty(request.DeviceId))
            return BadRequest(new { message = "Cihaz kimliği gerekli." });

        // 1. Bu kullanıcı zaten kayıtlı mı? (firebaseUid ile)
        var user = await _db.Users
            .FirstOrDefaultAsync(u => u.FirebaseUid == firebaseUid);

        if (user != null)
        {
            // FCM token değişmiş olabilir (yeniden yükleme, cihaz değişikliği vb.)
            if (!string.IsNullOrEmpty(request.FcmToken) && user.FcmToken != request.FcmToken)
            {
                user.FcmToken = request.FcmToken;
                await _db.SaveChangesAsync();
            }

            // Mevcut kullanıcı → normal giriş
            return Ok(new LoginResponse
            {
                Success = true,
                Message = "Giriş başarılı.",
                Credits = user.Credits,
                IsNewUser = false
            });
        }

        // 2. YENİ kullanıcı → bu cihazda daha önce hesap açılmış mı?
        var deviceUsedBefore = await _db.Users
            .AnyAsync(u => u.DeviceId == request.DeviceId);

        // Cihaz ilk kez kullanılıyorsa 5 kredi, değilse 0 kredi
        int startingCredits = deviceUsedBefore ? 0 : 5;

        user = new User
        {
            FirebaseUid = firebaseUid,
            DeviceId = request.DeviceId,
            DevicePlatform = request.DevicePlatform,
            Credits = startingCredits,
            FcmToken = request.FcmToken
        };
        _db.Users.Add(user);
        await _db.SaveChangesAsync();

        return Ok(new LoginResponse
        {
            Success = true,
            Message = deviceUsedBefore
                ? "Hesap oluşturuldu. Bu cihaz ücretsiz krediyi daha önce kullandığı için 0 kredi ile başlıyorsunuz."
                : "Hesap oluşturuldu. 5 ücretsiz krediniz hazır!",
            Credits = user.Credits,
            IsNewUser = true
        });
    }
    // Mevcut kullanıcı bilgisi
    [Authorize]
    [HttpGet("me")]
    public async Task<IActionResult> Me()
    {
        var firebaseUid = GetFirebaseUid();
        if (string.IsNullOrEmpty(firebaseUid))
            return Unauthorized();

        var user = await _db.Users
            .FirstOrDefaultAsync(u => u.FirebaseUid == firebaseUid);

        if (user == null)
            return NotFound(new { message = "Kullanıcı bulunamadı." });

        return Ok(new
        {
            firebaseUid = user.FirebaseUid,
            credits = user.Credits,
            platform = user.DevicePlatform
        });
    }

    // Hesabı kalıcı olarak sil (Apple/Google mağaza kurallarının hesap
    // oluşturma özelliği olan uygulamalarda zorunlu tuttuğu hesap silme akışı).
    // User satırı silinince Jobs/JobItems/JobImages/Purchases cascade ile
    // (AppDbContext'teki ilişkiler + EF'in zorunlu FK'ler için varsayılan
    // Cascade davranışı) otomatik silinir. Firebase Auth hesabı da Admin SDK
    // ile ayrıca siliniyor — aksi halde kullanıcı aynı bilgilerle tekrar
    // giriş yapıp "silinmemiş" bir hesaba sahip gibi davranabilirdi.
    [Authorize]
    [HttpDelete("account")]
    public async Task<IActionResult> DeleteAccount()
    {
        var firebaseUid = GetFirebaseUid();
        if (string.IsNullOrEmpty(firebaseUid))
            return Unauthorized();

        var user = await _db.Users.FirstOrDefaultAsync(u => u.FirebaseUid == firebaseUid);
        if (user != null)
        {
            _db.Users.Remove(user);
            await _db.SaveChangesAsync();
        }

        try
        {
            await FirebaseAuth.DefaultInstance.DeleteUserAsync(firebaseUid);
        }
        catch (FirebaseAuthException)
        {
            // Firebase hesabı zaten yoksa/silinmişse sorun değil
        }

        return Ok(new { message = "Hesabınız silindi." });
    }
}