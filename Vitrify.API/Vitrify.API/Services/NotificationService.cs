using FirebaseAdmin.Messaging;

namespace Vitrify.API.Services;

public class NotificationService
{
    // Belirli bir cihaza push bildirimi gönderir
    public async Task SendNotificationAsync(
        string fcmToken,
        string title,
        string body,
        Dictionary<string, string>? data = null)
    {
        if (string.IsNullOrEmpty(fcmToken))
            return; // token yoksa gönderme

        var message = new Message
        {
            Token = fcmToken,
            Notification = new Notification
            {
                Title = title,
                Body = body
            },
            Data = data ?? new Dictionary<string, string>()
        };

        try
        {
            await FirebaseMessaging.DefaultInstance.SendAsync(message);
        }
        catch (Exception ex)
        {
            Console.WriteLine($"[FCM] Bildirim gönderilemedi: {ex.Message}");
        }
    }
}