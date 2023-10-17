using Microsoft.AspNetCore.Mvc;

namespace apps.Controllers;

[ApiController]
[Route("[controller]")]
public class IdController : ControllerBase
{
    private readonly ILogger<IdController> _logger;

    public IdController(ILogger<IdController> logger)
    {
        _logger = logger;
    }

    [HttpGet(Name = "GetId")]
    public IEnumerable<Id> Get()
    {
        var id = Guid.NewGuid().ToString();
        Console.WriteLine($"Generating Id: {id}");

        return Enumerable.Range(1, 5).Select(index => new Id
        {
            Date = DateOnly.FromDateTime(DateTime.Now.AddDays(index)),
            Guid = id
        })
        .ToArray();
    }
}
