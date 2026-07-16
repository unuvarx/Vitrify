using Microsoft.EntityFrameworkCore;
using Vitrify.API.Models;

namespace Vitrify.API.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options)
        : base(options)
    {
    }

    // Her DbSet bir tabloya karşılık gelir
    public DbSet<User> Users => Set<User>();
    public DbSet<Job> Jobs => Set<Job>();
    public DbSet<JobItem> JobItems => Set<JobItem>();
    public DbSet<Purchase> Purchases => Set<Purchase>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // FirebaseUid benzersiz olmalı (aynı kullanıcı iki kez kaydolamaz)
        modelBuilder.Entity<User>()
            .HasIndex(u => u.FirebaseUid)
            .IsUnique();

        // StoreTransactionId benzersiz olmalı (aynı satın alım iki kez işlenemez)
        modelBuilder.Entity<Purchase>()
            .HasIndex(p => p.StoreTransactionId)
            .IsUnique();

        // Bir Job silinince ona bağlı JobItem'lar da silinsin
        modelBuilder.Entity<Job>()
            .HasMany(j => j.Items)
            .WithOne(i => i.Job)
            .HasForeignKey(i => i.JobId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}