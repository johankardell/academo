using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace apps.Contracts;

public class GetIdResponse
{
    [JsonPropertyName("Date")]
    public DateOnly Date { get; set; }

    [JsonPropertyName("Guid")]
    public string? Guid { get; set; }

    [JsonPropertyName("Secret")]
    public string? Secret { get; set; }
}