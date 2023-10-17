using Microsoft.AspNetCore.Mvc;
using Dapr.Client;

namespace apps.Controllers;

[ApiController]
[Route("[controller]")]
public class IdController : ControllerBase
{
    private readonly ILogger<IdController> _logger;
    private readonly DaprClient _daprClient;

    public IdController(ILogger<IdController> logger, DaprClient daprClient)
    {
        _logger = logger;
        _daprClient = daprClient;
    }

    [HttpGet(Name = "GetId")]
    public async Task<IEnumerable<Id>> Get()
    {
        var id = Guid.NewGuid().ToString();
        Console.WriteLine($"Generating Id: {id} at {DateTime.Now}");

        var secret = await GetSecret();

        return Enumerable.Range(1, 5).Select(index => new Id
        {
            Date = DateOnly.FromDateTime(DateTime.Now.AddDays(index)),
            Guid = id,
            Secret = secret
        })
        .ToArray();
    }

    private async Task<string> GetSecret()
    {
        // var metadata = new Dictionary<string, string> { ["version_id"] = "1" };
        Dictionary<string, string> secrets = await _daprClient.GetSecretAsync("keyvault", "mysecret");
        return secrets["mysecret"];
    }
}
