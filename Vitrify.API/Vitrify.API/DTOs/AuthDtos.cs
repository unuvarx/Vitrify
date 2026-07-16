namespace Vitrify.API.DTOs;

// Flutter → Backend (giriş/kayıt isteği)
public class LoginRequest
{
    public string DeviceId { get; set; } = string.Empty;
    public string DevicePlatform { get; set; } = string.Empty; // "ios" / "android"
}

// Backend → Flutter (giriş cevabı)
public class LoginResponse
{
    public bool Success { get; set; }
    public string Message { get; set; } = string.Empty;
    public int Credits { get; set; }
    public bool IsNewUser { get; set; }
}