namespace Vitrify.API.Models;

public class Job
{
    public Guid Id { get; set; } = Guid.NewGuid();

    public Guid UserId { get; set; }
    public User? User { get; set; }

    // pending / processing / done / failed
    public string Status { get; set; } = "pending";

    public int TotalItems { get; set; }
    public int CompletedItems { get; set; } = 0;

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    // İlişki
    public List<JobItem> Items { get; set; } = new();
}