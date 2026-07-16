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
            Credits = startingCredits
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
}