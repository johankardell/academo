using Microsoft.AspNetCore.Mvc;

namespace apps.Controllers;

[ApiController]
[Route("/")]
public class HomeController : ControllerBase
{
    private readonly ILogger<HomeController> _logger;

    public HomeController(ILogger<HomeController> logger)
    {
        _logger = logger;
    }

    [HttpGet(Name = "Get")]
    public string Get()
    {
        return "Hello world";
    }
}
