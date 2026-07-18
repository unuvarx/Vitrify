using System.Net.Http.Headers;

namespace Vitrify.API.Services;

// Üretilen görselleri Supabase Storage'a (S3 destekli, ayrı bir servis)
// yükler — Postgres'e büyük base64 blob'lar yazmak yerine sadece kısa
// bir public URL saklarız.
public class SupabaseStorageService
{
    private const string BucketName = "generated-images";

    private readonly HttpClient _http;
    private readonly string _url;
    private readonly string _serviceRoleKey;

    public SupabaseStorageService(IHttpClientFactory httpFactory, IConfiguration config)
    {
        _http = httpFactory.CreateClient();
        _url = config["Supabase:Url"]
               ?? throw new InvalidOperationException("Supabase:Url bulunamadı.");
        _serviceRoleKey = config["Supabase:ServiceRoleKey"]
                          ?? throw new InvalidOperationException("Supabase:ServiceRoleKey bulunamadı.");
    }

    // Görseli yükler, herkese açık (public) URL döndürür
    public async Task<string> UploadImageAsync(byte[] bytes, string objectPath)
    {
        var request = new HttpRequestMessage(
            HttpMethod.Post,
            $"{_url}/storage/v1/object/{BucketName}/{objectPath}");

        request.Headers.Add("Authorization", $"Bearer {_serviceRoleKey}");
        request.Headers.Add("apikey", _serviceRoleKey);
        request.Headers.Add("x-upsert", "true");
        request.Content = new ByteArrayContent(bytes);
        request.Content.Headers.ContentType = new MediaTypeHeaderValue("image/jpeg");

        var response = await _http.SendAsync(request);

        if (!response.IsSuccessStatusCode)
        {
            var body = await response.Content.ReadAsStringAsync();
            throw new Exception($"Supabase Storage yükleme hatası ({response.StatusCode}): {body}");
        }

        return $"{_url}/storage/v1/object/public/{BucketName}/{objectPath}";
    }
}
