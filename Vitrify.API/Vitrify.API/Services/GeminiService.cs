using System.Text;
using System.Text.Json;
using SixLabors.ImageSharp;
using SixLabors.ImageSharp.Processing;

namespace Vitrify.API.Services;

public class GeminiService
{
    private readonly HttpClient _http;
    private readonly string _apiKey;

    public GeminiService(IHttpClientFactory httpFactory, IConfiguration config)
    {
        _http = httpFactory.CreateClient();
        _apiKey = config["Gemini:ApiKey"]
                  ?? throw new InvalidOperationException("Gemini API key bulunamadı.");
    }

    // Görseli JPEG'e yeniden kodlar (PNG dahil, ImageSharp formatı kendisi
    // algılar). Gemini çoğunlukla PNG (kayıpsız) döndürüyor — bunu kaliteli
    // JPEG'e çevirmek görünür kalite kaybı yaratmadan dosya boyutunu ciddi
    // küçültüyor. maxSize verilirse o boyutu aşan görseller orantılı
    // küçültülür; null ise çözünürlüğe dokunulmaz.
    public byte[] EncodeAsJpeg(byte[] originalBytes, int? maxSize = null, int quality = 90)
    {
        using var image = Image.Load(originalBytes);
        if (maxSize.HasValue && (image.Width > maxSize.Value || image.Height > maxSize.Value))
        {
            var ratio = Math.Min((double)maxSize.Value / image.Width, (double)maxSize.Value / image.Height);
            image.Mutate(x => x.Resize((int)(image.Width * ratio), (int)(image.Height * ratio)));
        }
        using var ms = new MemoryStream();
        image.Save(ms, new SixLabors.ImageSharp.Formats.Jpeg.JpegEncoder { Quality = quality });
        return ms.ToArray();
    }

    // Base64 data URI'ye çevir
    public string ToBase64(byte[] fileBytes)
    {
        return Convert.ToBase64String(fileBytes);
    }

    // nano-banana (Gemini 2.5 Flash Image) ile görsel üret. Base64 döndürür.
    // imageBase64: SAF base64 (data: öneki OLMADAN)
    public async Task<string> GenerateImageAsync(
        string prompt,
        string imageBase64,
        string aspectRatio)
    {
        var requestBody = new
        {
            contents = new[]
            {
                new
                {
                    parts = new object[]
                    {
                        new { text = prompt },
                        new
                        {
                            inline_data = new
                            {
                                mime_type = "image/jpeg",
                                data = imageBase64
                            }
                        }
                    }
                }
            }
        };

        var json = JsonSerializer.Serialize(requestBody);

        var request = new HttpRequestMessage(
            HttpMethod.Post,
            "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-image:generateContent");
        request.Headers.Add("x-goog-api-key", _apiKey);
        request.Content = new StringContent(json, Encoding.UTF8, "application/json");

        var response = await _http.SendAsync(request);
        var responseBody = await response.Content.ReadAsStringAsync();

        if (!response.IsSuccessStatusCode)
            throw new Exception($"Gemini hatası ({response.StatusCode}): {responseBody}");

        // Cevaptan görsel base64'ünü çıkar
        // candidates[0].content.parts[].inline_data.data
        using var doc = JsonDocument.Parse(responseBody);
        var root = doc.RootElement;

        if (root.TryGetProperty("candidates", out var candidates) &&
            candidates.GetArrayLength() > 0)
        {
            var content = candidates[0].GetProperty("content");
            if (content.TryGetProperty("parts", out var parts))
            {
                foreach (var part in parts.EnumerateArray())
                {
                    // inlineData veya inline_data olabilir
                    if (part.TryGetProperty("inlineData", out var inlineData) &&
                        inlineData.TryGetProperty("data", out var d1))
                    {
                        return d1.GetString()!;
                    }
                    if (part.TryGetProperty("inline_data", out var inlineData2) &&
                        inlineData2.TryGetProperty("data", out var d2))
                    {
                        return d2.GetString()!;
                    }
                }
            }
        }

        throw new Exception($"Gemini cevabında görsel bulunamadı: {responseBody}");
    }
}