using Hangfire;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Vitrify.API.Data;
using Vitrify.API.DTOs;
using Vitrify.API.Models;
using Vitrify.API.Services;

namespace Vitrify.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class JobsController : BaseApiController
{
    private readonly AppDbContext _db;

    public JobsController(AppDbContext db)
    {
        _db = db;
    }

    // Toplu görsel üretimi başlat
    [Authorize]
    [HttpPost("create")]
    public async Task<IActionResult> Create([FromBody] CreateJobRequest request)
    {
        var firebaseUid = GetFirebaseUid();
        if (string.IsNullOrEmpty(firebaseUid))
            return Unauthorized();

        var user = await _db.Users.FirstOrDefaultAsync(u => u.FirebaseUid == firebaseUid);
        if (user == null)
            return NotFound(new { message = "Kullanıcı bulunamadı." });

        if (request.Images.Count == 0)
            return BadRequest(new { message = "En az bir görsel gerekli." });
        if (request.Scenarios.Count == 0)
            return BadRequest(new { message = "En az bir senaryo gerekli." });

        int totalItems = request.Images.Count * request.Scenarios.Count;

        if (user.Credits < totalItems)
        {
            return BadRequest(new
            {
                message = $"Yetersiz kredi. Gerekli: {totalItems}, Mevcut: {user.Credits}",
                requiredCredits = totalItems,
                availableCredits = user.Credits
            });
        }

        var job = new Job
        {
            UserId = user.Id,
            Status = "processing",
            TotalItems = totalItems,
            CompletedItems = 0
        };
        _db.Jobs.Add(job);

        var jobItems = new List<JobItem>();
        foreach (var imageBase64 in request.Images)
        {
            foreach (var scenario in request.Scenarios)
            {
                var fullPrompt = BuildPrompt(request.ScenePrompt, scenario);
                jobItems.Add(new JobItem
                {
                    JobId = job.Id,
                    ReplicateFileUrl = imageBase64, // saf base64 (Gemini için)
                    Scenario = fullPrompt,
                    Status = "pending",
                    CreditDeducted = false
                });
            }
        }
        _db.JobItems.AddRange(jobItems);
        await _db.SaveChangesAsync();

        foreach (var item in jobItems)
        {
            BackgroundJob.Enqueue<JobProcessingService>(
                svc => svc.ProcessJobItemAsync(item.Id));
        }

        return Ok(new CreateJobResponse
        {
            Success = true,
            Message = "Görselleriniz işleme alındı.",
            JobId = job.Id,
            TotalItems = totalItems,
            RemainingCredits = user.Credits
        });
    }

    // Job durumunu sorgula
    [Authorize]
    [HttpGet("{jobId}/status")]
    public async Task<IActionResult> GetStatus(Guid jobId)
    {
        var firebaseUid = GetFirebaseUid();
        var user = await _db.Users.FirstOrDefaultAsync(u => u.FirebaseUid == firebaseUid);
        if (user == null) return Unauthorized();

        var job = await _db.Jobs
            .Include(j => j.Items)
            .FirstOrDefaultAsync(j => j.Id == jobId && j.UserId == user.Id);

        if (job == null)
            return NotFound(new { message = "İş bulunamadı." });

        var completedImages = job.Items
            .Where(i => i.Status == "done" && i.OutputUrl != null)
            .Select(i => i.OutputUrl)
            .ToList();

        return Ok(new
        {
            jobId = job.Id,
            status = job.Status,
            totalItems = job.TotalItems,
            completedItems = job.CompletedItems,
            images = completedImages
        });
    }

    // Prompt oluşturucu: senaryo + mekan + kalite
    private string BuildPrompt(string scenePrompt, string scenario)
    {
        return $"{scenario}, {scenePrompt}, " +
               "ultra-realistic commercial product photography, " +
               "professional studio lighting, high resolution, sharp focus, photorealistic. " +
               "Keep the product identical to the original image, do not change the product itself.";
    }
}