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
    "assimilate",
    "company-add",
    "company-update",
    "debrief",
    "forge-init",
    "forge-install",
    "forge-update",
    "git-guardrails",
    "grill-with-peer",
    "jira",
    "lang-rules",
    "security-assessment",
    "security-resolve",
    "skill-health",
    "sprint-end",
    "token-report",
    "write-a-skill"
)

$overrides = [ordered]@{}
$errors = New-Object System.Collections.Generic.List[string]
foreach ($name in $overrideNames) {
    $sourcePath = Join-Path $root "global\.claude\skills\$name\SKILL.md"
    $codexPath = Join-Path $root "plugins\forge-codex\skills\$name\SKILL.md"
    $missing = $false
    if (-not (Test-Path -LiteralPath $sourcePath)) {
        $errors.Add("Missing shared source skill: $name")
        $missing = $true
    }
    if (-not (Test-Path -LiteralPath $codexPath)) {
        $errors.Add("Missing Codex override skill: $name")
        $missing = $true
    }
    if ($missing) { continue }
    $overrides[$name] = [ordered]@{
        source = "global/.claude/skills/$name/SKILL.md"
        codex = "plugins/forge-codex/skills/$name/SKILL.md"
        reviewedSourceSha256 = Get-NormalizedTextSha256 $sourcePath
    }
}

if ($errors.Count -gt 0) {
    # Report every missing override, not just the first: a per-item throw under
    # $ErrorActionPreference = Stop hides the rest and forces a fix-one-rerun loop.
    # -ErrorAction Continue keeps the list intact; the exit below still fails CI.
    Write-Error "Refusing to update override hashes: $($errors.Count) error(s):" -ErrorAction Continue
    foreach ($message in $errors) {
        Write-Error $message -ErrorAction Continue
    }
    exit 1
}

$payload = [ordered]@{
    policy = "Codex-native overrides require explicit review when their shared source changes."
    nativeOverrides = $overrides
}
$payload | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $outputPath -Encoding UTF8
Write-Output "Updated reviewed override hashes for $($overrideNames.Count) skills."
