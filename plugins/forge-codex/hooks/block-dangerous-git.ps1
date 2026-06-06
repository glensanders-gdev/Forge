$ErrorActionPreference = "Stop"
$inputText = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($inputText)) { exit 0 }

try {
    $payload = $inputText | ConvertFrom-Json -ErrorAction Stop
    $command = [string]$payload.tool_input.command
} catch {
    exit 0
}

$blockedPatterns = @(
    "git\s+push\b",
    "git\s+reset\s+--hard\b",
    "git\s+clean\s+-f[d]?\b",
    "git\s+branch\s+-D\b",
    "git\s+checkout\s+\.",
    "git\s+restore\s+\."
)

foreach ($pattern in $blockedPatterns) {
    if ($command -match $pattern) {
        @{
            hookSpecificOutput = @{
                hookEventName = "PreToolUse"
                permissionDecision = "deny"
                permissionDecisionReason = "Destructive git command blocked by Forge: $command"
            }
        } | ConvertTo-Json -Depth 8 -Compress
        exit 0
    }
}
