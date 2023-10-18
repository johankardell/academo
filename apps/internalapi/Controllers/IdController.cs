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
        var secret = await GetSecret();
        Console.WriteLine($"Secret: {secret}");

        var result = Enumerable.Range(1, 5).Select(index => new Id
        {
            Date = DateOnly.FromDateTime(DateTime.Now.AddDays(index)),
            Guid = Guid.NewGuid().ToString(),
            Secret = secret
        })
        .ToArray();

        Console.WriteLine($"Generating Id: {result.First().Guid} at {DateTime.Now}");

        await LogToStorage(result);

        return result;
    }

    private async Task<string> GetSecret()
    {
        Dictionary<string, string> secrets = await _daprClient.GetSecretAsync("mysecretstore", "mysecret");
        return secrets["mysecret"];
    }

    private async Task LogToStorage(IEnumerable<Id> ids)
    {
        await _daprClient.SaveStateAsync("mystorage", DateTime.Now.ToString("yyyyMMddHHmm"), ids);
    }
}
