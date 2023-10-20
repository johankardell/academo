using Microsoft.AspNetCore.Mvc;

namespace apps.Controllers;

[ApiController]
[Route("[controller]")]
public class ErrorController : ControllerBase
{
    private readonly ILogger<ErrorController> _logger;

    public ErrorController(ILogger<ErrorController> logger)
    {
        _logger = logger;
    }

    [HttpGet(Name = "GetError")]
    public IActionResult Get()
    {
        try
        {
            throw new Exception("This is an exception");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "This is an exception");

            return StatusCode(500, ex.Message);
        }
    }
}