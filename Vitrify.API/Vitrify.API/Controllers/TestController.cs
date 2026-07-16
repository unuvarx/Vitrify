using Microsoft.AspNetCore.Mvc;
using Vitrify.API.Services;

namespace Vitrify.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class TestController : ControllerBase
{
    private readonly ReplicateService _replicate;

    public TestController(ReplicateService replicate)
    {
        _replicate = replicate;
    }

    // Test: bir görsel URL'si + prompt ver, AI görsel üret
    [HttpPost("generate")]
    public async Task<IActionResult> Generate([FromBody] TestGenerateRequest request)
    {
        try
        {
            var outputUrl = await _replicate.GenerateImageAsync(
                request.Prompt,
                request.ImageUrl);

            return Ok(new
            {
                success = true,
                outputUrl = outputUrl
            });
        }
        catch (Exception ex)
        {
            return StatusCode(500, new
            {
                success = false,
                error = ex.Message
            });
        }
    }
    
    [HttpPost("upload-and-generate")]
    public async Task<IActionResult> UploadAndGenerate(IFormFile file, [FromForm] string prompt)
    {
        try
        {
            // 1. Görseli byte dizisine oku
            using var ms = new MemoryStream();
            await file.CopyToAsync(ms);
            var fileBytes = ms.ToArray();

            // 2. Base64 data URI'ye çevir (upload yok!)
            var dataUri = _replicate.ConvertToDataUri(fileBytes, file.ContentType);

            // 3. Direkt nano-banana'ya ver, görsel üret
            var outputUrl = await _replicate.GenerateImageAsync(prompt, dataUri);

            return Ok(new
            {
                success = true,
                outputUrl
            });
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { success = false, error = ex.Message });
        }
    }
}

public class TestGenerateRequest
{
    public string Prompt { get; set; } = string.Empty;
    public string ImageUrl { get; set; } = string.Empty;
}