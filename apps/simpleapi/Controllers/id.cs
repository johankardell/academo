using Microsoft.AspNetCore.Mvc;

namespace simpleApi.Controllers;

[ApiController]
[Route("[controller]")]
public class IDController : ControllerBase
{
    private readonly ILogger<IDController> _logger;

    public IDController(ILogger<IDController> logger)
    {
        _logger = logger;
    }

    [HttpGet(Name = "GetID")]
    public IEnumerable<string> Get()
    {
        string id = Guid.NewGuid().ToString();
        return Enumerable.Range(1, 1).Select(index => $"ID: {id}").ToArray();
    }
}
