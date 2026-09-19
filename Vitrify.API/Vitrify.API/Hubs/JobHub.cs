using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using Vitrify.API.Data;

namespace Vitrify.API.Hubs;

// NOT [Authorize] DEĞİL — kasıtlı. App Store'da hâlâ eski bir build
// (token göndermeyen SignalR client'ı) incelemede/kullanımda olabilir;
// hub'ı zorunlu yetkilendirmeye çevirmek o build için bağlantıyı anında
// reddedip 5 dakikalık polling fallback'ine düşürürdü (görünür bir kopukluk).
// Bunun yerine: token GELDİYSE (yeni client) sahiplik doğrulanıyor, gelmediyse
// (eski client) eski davranış korunuyor. Yeni client tamamen yayıldıktan
// sonra [Authorize] zorunlu hale getirilip bu geriye dönük uyumluluk kaldırılabilir.
public class JobHub : Hub
{
    private readonly AppDbContext _db;

    public JobHub(AppDbContext db)
    {
        _db = db;
    }

    public async Task SubscribeToJob(string jobId)
    {
        var firebaseUid = Context.User?.FindFirst("user_id")?.Value
                           ?? Context.User?.FindFirst(ClaimTypes.NameIdentifier)?.Value
                           ?? Context.User?.FindFirst("sub")?.Value;

        // Eski client (token yok) → sahiplik doğrulanamaz, eski davranışı koru
        if (string.IsNullOrEmpty(firebaseUid))
        {
            await Groups.AddToGroupAsync(Context.ConnectionId, jobId);
            return;
        }

        if (!Guid.TryParse(jobId, out var jobGuid))
            return;

        var owns = await _db.Jobs
            .AnyAsync(j => j.Id == jobGuid && j.User!.FirebaseUid == firebaseUid);

        if (!owns) return;

        await Groups.AddToGroupAsync(Context.ConnectionId, jobId);
    }

    // Dinlemeyi bırakma
    public async Task UnsubscribeFromJob(string jobId)
    {
        await Groups.RemoveFromGroupAsync(Context.ConnectionId, jobId);
    }
}
