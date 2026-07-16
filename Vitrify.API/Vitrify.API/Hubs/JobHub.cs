using Microsoft.AspNetCore.SignalR;

namespace Vitrify.API.Hubs;

public class JobHub : Hub
{
    // Flutter bir job'u dinlemek istediğinde bu gruba katılır
    public async Task SubscribeToJob(string jobId)
    {
        await Groups.AddToGroupAsync(Context.ConnectionId, jobId);
    }

    // Dinlemeyi bırakma
    public async Task UnsubscribeFromJob(string jobId)
    {
        await Groups.RemoveFromGroupAsync(Context.ConnectionId, jobId);
    }
}