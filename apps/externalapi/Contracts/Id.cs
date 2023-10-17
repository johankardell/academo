namespace apps.Contracts;

public class Id
{
    public DateOnly Date { get; set; }

    public string? Guid { get; set; }
    public string Secret { get; set; }
}
