using System.Text;
using System.Text.Json;
using SixLabors.ImageSharp.Processing;

namespace Vitrify.API.Services;

public class ReplicateService
{
    private readonly HttpClient _http;
    private readonly string _apiToken;

    public ReplicateService(IHttpClientFactory httpFactory, IConfiguration config)
    {
        _http = httpFactory.CreateClient();
        _apiToken = config["Replicate:ApiToken"]
                    ?? throw new InvalidOperationException("Replicate API token bulunamadı.");
    }

    
    // Görseli Base64 data URI'ye çevirir. Upload gerekmez, direkt kullanılır.
    public string ConvertToDataUri(byte[] fileBytes, string contentType)
    {
        var mime = string.IsNullOrWhiteSpace(contentType) ? "image/jpeg" : contentType;
        var base64 = Convert.ToBase64String(fileBytes);
        return $"data:{mime};base64,{base64}";
    }
    // nano-banana ile görsel üretir. Görsel URL'sini döndürür.
    public async Task<string> GenerateImageAsync(string prompt, string imageUrl)
    {
        const int maxRetries = 5;

        for (int attempt = 0; attempt < maxRetries; attempt++)
        {
            var requestBody = new
            {
                input = new
                {
                    prompt = prompt,
                    image_input = new[] { imageUrl }
                }
            };

            var json = JsonSerializer.Serialize(requestBody);

            var request = new HttpRequestMessage(
                HttpMethod.Post,
                "https://api.replicate.com/v1/models/google/nano-banana/predictions");

            request.Headers.Add("Authorization", $"Bearer {_apiToken}");
            request.Headers.Add("Prefer", "wait");
            request.Content = new StringContent(json, Encoding.UTF8, "application/json");

            var response = await _http.SendAsync(request);
            var responseBody = await response.Content.ReadAsStringAsync();

            // Rate limit → bekle ve tekrar dene
            if ((int)response.StatusCode == 429)
            {
                int waitSeconds = 12; // varsayılan
                try
                {
                    using var errDoc = JsonDocument.Parse(responseBody);
                    if (errDoc.RootElement.TryGetProperty("retry_after", out var retryAfter))
                        waitSeconds = retryAfter.GetInt32() + 2; // biraz pay bırak
                }
                catch { }

                Console.WriteLine($"[RATE LIMIT] {waitSeconds}sn bekleniyor... (deneme {attempt + 1}/{maxRetries})");
                await Task.Delay(TimeSpan.FromSeconds(waitSeconds));
                continue; // tekrar dene
            }

            if (!response.IsSuccessStatusCode)
                throw new Exception($"Replicate hatası ({response.StatusCode}): {responseBody}");

            using var doc = JsonDocument.Parse(responseBody);
            var root = doc.RootElement;

            if (root.TryGetProperty("output", out var output))
            {
                if (output.ValueKind == JsonValueKind.String)
                    return output.GetString()!;

                if (output.ValueKind == JsonValueKind.Array && output.GetArrayLength() > 0)
                    return output[0].GetString()!;
            }

            throw new Exception($"Beklenmeyen Replicate cevabı: {responseBody}");
        }

        throw new Exception("Rate limit aşıldı, maksimum deneme sayısına ulaşıldı.");
    }
    public byte[] CompressImage(byte[] originalBytes)
    {
        using var image = SixLabors.ImageSharp.Image.Load(originalBytes);

        int maxSize = 1024;
        if (image.Width > maxSize || image.Height > maxSize)
        {
            var ratio = Math.Min(
                (double)maxSize / image.Width,
                (double)maxSize / image.Height);
            int newWidth = (int)(image.Width * ratio);
            int newHeight = (int)(image.Height * ratio);
            image.Mutate(x => x.Resize(newWidth, newHeight));
        }

        using var ms = new MemoryStream();
        var encoder = new SixLabors.ImageSharp.Formats.Jpeg.JpegEncoder
        {
            Quality = 85
        };
        image.Save(ms, encoder);
        return ms.ToArray();
    }
}