param(
    [switch]$ConfirmReview,
    [string]$ForgeRoot = (Join-Path $PSScriptRoot "..")
)

$ErrorActionPreference = "Stop"
if (-not $ConfirmReview) {
    throw "Refusing to update override hashes without -ConfirmReview. Review every Codex-native override against its shared source first."
}

$root = (Resolve-Path -LiteralPath $ForgeRoot).Path
$outputPath = Join-Path $root "plugins\forge-codex\compatibility.json"

function Get-NormalizedTextSha256([string]$Path) {
    $text = [IO.File]::ReadAllText($Path, [Text.Encoding]::UTF8) -replace "\r\n?", "`n"
    $bytes = [Text.UTF8Encoding]::new($false).GetBytes($text)
    $sha256 = [Security.Cryptography.SHA256]::Create()
    try {
        return ([BitConverter]::ToString($sha256.ComputeHash($bytes))).Replace("-", "")
    } finally {
        $sha256.Dispose()
    }
}

$overrideNames = @(
    "company-add",
    "forge-init",
    "forge-install",
    "forge-update",
    "git-guardrails",
    "lang-rules",
    "security-assessment",
    "security-resolve",
    "skill-health"
)

$overrides = [ordered]@{}
foreach ($name in $overrideNames) {
    $sourcePath = Join-Path $root "global\.claude\skills\$name\SKILL.md"
    $codexPath = Join-Path $root "plugins\forge-codex\skills\$name\SKILL.md"
    if (-not (Test-Path -LiteralPath $sourcePath)) { throw "Missing shared source skill: $name" }
    if (-not (Test-Path -LiteralPath $codexPath)) { throw "Missing Codex override skill: $name" }
    $overrides[$name] = [ordered]@{
        source = "global/.claude/skills/$name/SKILL.md"
        codex = "plugins/forge-codex/skills/$name/SKILL.md"
        reviewedSourceSha256 = Get-NormalizedTextSha256 $sourcePath
    }
}

$payload = [ordered]@{
    policy = "Codex-native overrides require explicit review when their shared source changes."
    nativeOverrides = $overrides
}
$payload | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $outputPath -Encoding UTF8
Write-Output "Updated reviewed override hashes for $($overrideNames.Count) skills."
