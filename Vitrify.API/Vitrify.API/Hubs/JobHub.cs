using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using Vitrify.API.Data;

namespace Vitrify.API.Hubs;

// [Authorize] olmadan önce herkes (Firebase token'ı olmadan bile) rastgele/
// tahmin edilmiş bir jobId ile SubscribeToJob çağırıp başka bir kullanıcının
// üretim sonuçlarını (görsel URL'leri dahil) dinleyebiliyordu.
[Authorize]
public class JobHub : Hub
{
    private readonly AppDbContext _db;

    public JobHub(AppDbContext db)
    {
        _db = db;
    }

    // Flutter bir job'u dinlemek istediğinde bu gruba katılır — ama sadece
    // job gerçekten bu bağlantının sahibine aitse
    public async Task SubscribeToJob(string jobId)
    {
        var firebaseUid = Context.User?.FindFirst("user_id")?.Value
                           ?? Context.User?.FindFirst(ClaimTypes.NameIdentifier)?.Value
                           ?? Context.User?.FindFirst("sub")?.Value;

        if (string.IsNullOrEmpty(firebaseUid) || !Guid.TryParse(jobId, out var jobGuid))
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
