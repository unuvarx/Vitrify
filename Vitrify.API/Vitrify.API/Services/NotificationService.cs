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
            var messageId = await FirebaseMessaging.DefaultInstance.SendAsync(message);
            Console.WriteLine($"[FCM] Bildirim gönderildi: {messageId}");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"[FCM] Bildirim gönderilemedi: {ex.Message}");
        }
    }
}