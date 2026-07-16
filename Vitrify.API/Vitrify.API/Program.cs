using Microsoft.EntityFrameworkCore;
using Vitrify.API.Data;
using FirebaseAdmin;
using Google.Apis.Auth.OAuth2;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using Hangfire;
using Hangfire.PostgreSql;
using Vitrify.API.Hubs;

var builder = WebApplication.CreateBuilder(args);

// ========================================
// SERVİSLER (builder.Build()'den ÖNCE)
// ========================================

// Firebase Admin SDK başlat
FirebaseApp.Create(new AppOptions
{
    Credential = GoogleCredential.FromFile("firebase-key.json")
});

// Controllers + Swagger
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// PostgreSQL veritabanı bağlantısı
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseNpgsql(
        builder.Configuration.GetConnectionString("DefaultConnection")
    )
);

// Firebase JWT Authentication
var firebaseProjectId = "vitrify-c68b0";

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.Authority = $"https://securetoken.google.com/{firebaseProjectId}";
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidIssuer = $"https://securetoken.google.com/{firebaseProjectId}",
            ValidateAudience = true,
            ValidAudience = firebaseProjectId,
            ValidateLifetime = true
        };
    });

builder.Services.AddAuthorization();

// Hangfire STORAGE yapılandırması (işleri PostgreSQL'de saklar)
builder.Services.AddHangfire(config =>
    config.UsePostgreSqlStorage(options =>
        options.UseNpgsqlConnection(
            builder.Configuration.GetConnectionString("DefaultConnection"))
    )
);

// Hangfire WORKER (arka plan işçisi — DB pool limitini aşmasın diye 3)
builder.Services.AddHangfireServer(options =>
{
    options.WorkerCount = 3;
});

// SignalR (gerçek zamanlı bildirim)
builder.Services.AddSignalR();

// HttpClient (Replicate API çağrıları için)
builder.Services.AddHttpClient();

// Servisler
builder.Services.AddScoped<Vitrify.API.Services.ReplicateService>();
builder.Services.AddScoped<Vitrify.API.Services.JobProcessingService>();
builder.Services.AddScoped<Vitrify.API.Services.NotificationService>();
builder.Services.AddScoped<Vitrify.API.Services.GeminiService>();

// ========================================
// UYGULAMA (builder.Build()'den SONRA)
// ========================================

var app = builder.Build();

// Swagger (sadece geliştirmede)
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// Hangfire dashboard (işleri görsel izlemek için)
app.UseHangfireDashboard("/hangfire");

// HTTPS yönlendirmesi (geliştirmede kapalı — Flutter HTTP kullanıyor)
// app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

// SignalR hub endpoint'i
app.MapHub<JobHub>("/jobhub");

app.Run();