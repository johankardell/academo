using Microsoft.AspNetCore.Mvc;
using Dapr.Client;
using apps.Contracts;

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
        Console.WriteLine($"Calling backend service");

        var result = await _daprClient.InvokeMethodAsync<IEnumerable<GetIdResponse>>(HttpMethod.Get, "internalapi", "id");
        var resultArray = result.ToArray();

        Console.WriteLine($"Backend service returned {resultArray.Length} results");

        Console.WriteLine($"First element: {resultArray[0].Date} {resultArray[0].Guid} {resultArray[0].Secret}");

        return Enumerable.Range(1, resultArray.Length).Select(index =>
        new Id()
        {
            Date = resultArray[index - 1].Date,
            Guid = resultArray[index - 1].Guid,
            Secret = resultArray[index - 1].Secret
        }).ToArray();
    }
}
