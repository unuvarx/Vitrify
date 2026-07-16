namespace Vitrify.API.DTOs;

// Flutter → Backend (toplu üretim isteği)
public class CreateJobRequest
{
    // Tema sayfasından: ana mekan promptu
    public string ScenePrompt { get; set; } = string.Empty;

    // Senaryolar: ["bilekte", "şezlongda", "masada"]
    public List<string> Scenarios { get; set; } = new();

    // Aspect ratio (şimdilik prompt'a ekleyeceğiz)
    public string AspectRatio { get; set; } = "1:1";

    // Ürün görselleri: base64 data URI listesi
    public List<string> Images { get; set; } = new();
}

// Backend → Flutter (job oluşturuldu cevabı)
public class CreateJobResponse
{
    public bool Success { get; set; }
    public string Message { get; set; } = string.Empty;
    public Guid JobId { get; set; }
    public int TotalItems { get; set; }
    public int RemainingCredits { get; set; }
}