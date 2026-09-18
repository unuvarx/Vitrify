using System.Text;
using System.Text.Json;
using SixLabors.ImageSharp;
using SixLabors.ImageSharp.Processing;

namespace Vitrify.API.Services;

// Gemini bazen (özellikle gerçekçi insan içeren isteklerde) görsel yerine
// boş metin döndürüyor — güvenlik ihlali değil, modelin kendi tutarsızlığı.
// Bu, anında tekrar denemeye değer bir durum (network hatasından farklı).
public class GeminiNoImageException : Exception
{
    public GeminiNoImageException(string message) : base(message) { }
}

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

    // Nano Banana 2 (Gemini 3.1 Flash Image) ile görsel üret. Base64 döndürür.
    // imageBase64: SAF base64 (data: öneki OLMADAN)
    // Herhangi bir geçici hatada (görsel dönmemesi, ağ/HTTP hatası vb.)
    // Hangfire'ın yavaş (dakikalarca sürebilen) retry backoff'unu beklemeden
    // anında tekrar dener — böylece kullanıcı arayüzü açıkken çoğu geçici
    // hata bu seviyede kendi kendine düzelir.
    public async Task<string> GenerateImageAsync(
        string prompt,
        string imageBase64,
        string aspectRatio,
        int maxAttempts = 3)
    {
        return await WithRetryAsync(
            () => GenerateOnceAsync(prompt, aspectRatio, imageBase64),
            maxAttempts);
    }

    // Compositing akışı için: ürünü hiç göstermeden SADECE sahneyi/arka
    // planı ürettirir — ürün fotoğrafı üzerine biz yapıştıracağımız için
    // Gemini'nin marka/logo bozma riski bu adımda hiç devreye girmiyor.
    public async Task<string> GenerateSceneOnlyAsync(
        string prompt,
        string aspectRatio,
        int maxAttempts = 3)
    {
        return await WithRetryAsync(
            () => GenerateOnceAsync(prompt, aspectRatio, imageBase64: null),
            maxAttempts);
    }

    private async Task<string> WithRetryAsync(Func<Task<string>> action, int maxAttempts)
    {
        for (int attempt = 1; attempt <= maxAttempts; attempt++)
        {
            try
            {
                return await action();
            }
            catch (Exception) when (attempt < maxAttempts)
            {
                await Task.Delay(1000 * attempt);
            }
        }

        // Buraya asla ulaşılmaz — son deneme kendi exception'ını fırlatır
        throw new InvalidOperationException("Unreachable");
    }

    private async Task<string> GenerateOnceAsync(
        string prompt,
        string aspectRatio,
        string? imageBase64)
    {
        var requestParts = new List<object> { new { text = prompt } };
        if (imageBase64 != null)
        {
            requestParts.Add(new
            {
                inline_data = new
                {
                    mime_type = "image/jpeg",
                    data = imageBase64
                }
            });
        }

        var requestBody = new
        {
            contents = new[] { new { parts = requestParts } },
            generationConfig = new
            {
                imageConfig = new
                {
                    aspectRatio,
                    imageSize = "1k"
                }
            }
        };

        var json = JsonSerializer.Serialize(requestBody);

        var request = new HttpRequestMessage(
            HttpMethod.Post,
            "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-flash-image:generateContent");
        request.Headers.Add("x-goog-api-key", _apiKey);
        request.Content = new StringContent(json, Encoding.UTF8, "application/json");

        using var response = await _http.SendAsync(request);
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

        throw new GeminiNoImageException($"Gemini cevabında görsel bulunamadı: {responseBody}");
    }
}