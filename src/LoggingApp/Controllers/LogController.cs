using Microsoft.AspNetCore.Mvc;

namespace LoggingApp.Controllers;

[ApiController]
[Route("api/[controller]")]
public class LogController : ControllerBase
{
    private readonly ILogger<LogController> _logger;
    private static readonly Random Random = new();

    public LogController(ILogger<LogController> logger)
    {
        _logger = logger;
    }

    [HttpPost("info")]
    public IActionResult LogInfo([FromBody] string message)
    {
        _logger.LogInformation("Info log: {Message} from {Source}", message, "API");
        return Ok(new { level = "Info", message, timestamp = DateTime.UtcNow });
    }

    [HttpPost("warning")]
    public IActionResult LogWarning([FromBody] string message)
    {
        _logger.LogWarning("Warning log: {Message} from {Source}", message, "API");
        return Ok(new { level = "Warning", message, timestamp = DateTime.UtcNow });
    }

    [HttpPost("error")]
    public IActionResult LogError([FromBody] string message)
    {
        var exception = new InvalidOperationException($"Simulated error: {message}");
        _logger.LogError(exception, "Error log: {Message} from {Source}", message, "API");
        return Ok(new { level = "Error", message, timestamp = DateTime.UtcNow });
    }

    [HttpPost("critical")]
    public IActionResult LogCritical([FromBody] string message)
    {
        var exception = new SystemException($"Critical error: {message}");
        _logger.LogCritical(exception, "Critical log: {Message} from {Source}", message, "API");
        return Ok(new { level = "Critical", message, timestamp = DateTime.UtcNow });
    }

    [HttpGet("generate/{count}")]
    public IActionResult GenerateRandomLogs(int count = 10)
    {
        var logTypes = new[] { "Info", "Warning", "Error", "Debug" };
        var messages = new[] 
        { 
            "Processing user request", 
            "Database connection timeout", 
            "Cache miss occurred", 
            "Authentication successful",
            "File processing completed",
            "Network latency detected",
            "Memory usage threshold exceeded",
            "Background job started"
        };

        for (var i = 0; i < count; i++)
        {
            var logType = logTypes[Random.Next(logTypes.Length)];
            var message = messages[Random.Next(messages.Length)];
            var userId = Random.Next(1000, 9999);
            var requestId = Guid.NewGuid().ToString("N")[..8];

            switch (logType)
            {
                case "Info":
                    _logger.LogInformation("Generated log {Index}: {Message} for User:{UserId} Request:{RequestId}", 
                        i + 1, message, userId, requestId);
                    break;
                case "Warning":
                    _logger.LogWarning("Generated warning {Index}: {Message} for User:{UserId} Request:{RequestId}", 
                        i + 1, message, userId, requestId);
                    break;
                case "Error":
                    _logger.LogError("Generated error {Index}: {Message} for User:{UserId} Request:{RequestId}", 
                        i + 1, message, userId, requestId);
                    break;
                case "Debug":
                    _logger.LogDebug("Generated debug {Index}: {Message} for User:{UserId} Request:{RequestId}", 
                        i + 1, message, userId, requestId);
                    break;
            }

            Thread.Sleep(50); // Small delay to spread timestamps
        }

        return Ok(new { generated = count, timestamp = DateTime.UtcNow });
    }
}