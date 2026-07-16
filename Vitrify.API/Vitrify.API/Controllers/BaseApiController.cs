using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace Vitrify.API.Controllers;

public class BaseApiController : ControllerBase
{
    // Token'dan Firebase kullanıcı ID'sini okur
    protected string? GetFirebaseUid()
    {
        return User.FindFirst("user_id")?.Value
               ?? User.FindFirst(ClaimTypes.NameIdentifier)?.Value
               ?? User.FindFirst("sub")?.Value;
    }
}