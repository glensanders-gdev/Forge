param(
    [string]$ForgeRoot = (Join-Path $PSScriptRoot "..")
)

$ErrorActionPreference = "Stop"
$root = (Resolve-Path -LiteralPath $ForgeRoot).Path
$manifestPath = Join-Path $root "global\.claude\skills\manifest.json"
$pluginRoot = Join-Path $root "plugins\forge-codex"
$pluginManifestPath = Join-Path $pluginRoot ".codex-plugin\plugin.json"
$adaptationPath = Join-Path $pluginRoot "references\adaptation-build.json"
$marketplacePath = Join-Path $root ".agents\plugins\marketplace.json"
$compatibilityPath = Join-Path $pluginRoot "compatibility.json"
$errors = New-Object System.Collections.Generic.List[string]

$forgeManifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
$pluginManifest = Get-Content -LiteralPath $pluginManifestPath -Raw | ConvertFrom-Json
$adaptation = Get-Content -LiteralPath $adaptationPath -Raw | ConvertFrom-Json
$marketplace = Get-Content -LiteralPath $marketplacePath -Raw | ConvertFrom-Json
$compatibility = Get-Content -LiteralPath $compatibilityPath -Raw | ConvertFrom-Json

$sourceSkills = Get-ChildItem -LiteralPath (Join-Path $root "global\.claude\skills") -Directory |
    Select-Object -ExpandProperty Name |
    Sort-Object
$claudeCommands = Get-ChildItem -LiteralPath (Join-Path $root "global\.claude\commands") -File -Filter "*.md" |
    Select-Object -ExpandProperty BaseName |
    Sort-Object
$codexSkills = Get-ChildItem -LiteralPath (Join-Path $pluginRoot "skills") -Directory |
    Select-Object -ExpandProperty Name |
    Sort-Object
$declaredNames = New-Object System.Collections.Generic.List[string]

foreach ($skill in $sourceSkills) {
    if ($claudeCommands -notcontains $skill) {
        $errors.Add("Claude Code command stub is missing for shared skill: $skill")
    }
    if ($codexSkills -notcontains $skill) {
        $errors.Add("Codex plugin is missing shared skill: $skill")
    }
}
foreach ($command in $claudeCommands) {
    if ($sourceSkills -notcontains $command) {
        $errors.Add("Claude Code command has no shared skill: $command")
    }
}

$allowedCodexOnly = @("forge-codex")
foreach ($skill in $codexSkills) {
    if (($sourceSkills -notcontains $skill) -and ($allowedCodexOnly -notcontains $skill)) {
        $errors.Add("Unreviewed Codex-only skill: $skill")
    }
    $skillPath = Join-Path $pluginRoot "skills\$skill\SKILL.md"
    if (-not (Test-Path -LiteralPath $skillPath)) {
        $errors.Add("Codex skill is missing SKILL.md: $skill")
        continue
    }
    $skillText = [IO.File]::ReadAllText($skillPath)
    if ($skillText -notmatch "(?s)^---\r?\n.*?\r?\n---") {
        $errors.Add("Codex skill has invalid frontmatter boundaries: $skill")
    }
    if ($skillText -notmatch "(?m)^name:\s*`"?([^`"\r\n]+)`"?\s*$") {
        $errors.Add("Codex skill has no valid name: $skill")
    } else {
        $declaredNames.Add($Matches[1])
    }
    if ($skillText -notmatch "(?m)^description:\s*.+$") {
        $errors.Add("Codex skill has no description: $skill")
    }
}

$duplicates = $declaredNames | Group-Object | Where-Object Count -gt 1
foreach ($duplicate in $duplicates) {
    $errors.Add("Duplicate Codex skill name: $($duplicate.Name)")
}

if ($pluginManifest.version -ne $forgeManifest.forge_version) {
    $errors.Add("Version mismatch: Forge=$($forgeManifest.forge_version), Codex plugin=$($pluginManifest.version)")
}
if ($pluginManifest.name -ne "forge-codex") {
    $errors.Add("Codex plugin manifest name must be forge-codex")
}
$marketplaceEntry = @($marketplace.plugins | Where-Object { $_.name -eq "forge-codex" })
if ($marketplaceEntry.Count -ne 1 -or $marketplaceEntry[0].source.path -ne "./plugins/forge-codex") {
    $errors.Add("Marketplace must contain exactly one forge-codex entry pointing to ./plugins/forge-codex")
}
if (-not (Test-Path -LiteralPath (Join-Path $pluginRoot "references\project-template\AGENTS.md"))) {
    $errors.Add("Codex project template is missing AGENTS.md")
}
if (-not (Test-Path -LiteralPath (Join-Path $pluginRoot "references\project-template\.agents\skills"))) {
    $errors.Add("Codex project template is missing .agents/skills")
}
if (Test-Path -LiteralPath (Join-Path $pluginRoot "references\project-template\.claude")) {
    $errors.Add("Codex project template must not contain .claude")
}
$projectGitignore = Join-Path $pluginRoot "references\project-template\.gitignore"
if (
    -not (Test-Path -LiteralPath $projectGitignore) -or
    (Get-Content -LiteralPath $projectGitignore -Raw) -notmatch "(?m)^/prototype$"
) {
    $errors.Add("Codex project template .gitignore must preserve the /prototype rule")
}

try {
    Get-Content -LiteralPath (Join-Path $pluginRoot "hooks\hooks.json") -Raw | ConvertFrom-Json | Out-Null
} catch {
    $errors.Add("Codex hook configuration is not valid JSON")
}

Get-ChildItem -LiteralPath (Join-Path $pluginRoot "skills") -Recurse -Filter "openai.yaml" -File |
    ForEach-Object {
        $agentText = Get-Content -LiteralPath $_.FullName -Raw
        if ($agentText -notmatch "(?m)^interface:\s*$") {
            $errors.Add("Codex agent manifest must use the accepted interface contract: $($_.FullName)")
        }
    }

foreach ($property in $compatibility.nativeOverrides.PSObject.Properties) {
    $name = $property.Name
    $entry = $property.Value
    $sourcePath = Join-Path $root ($entry.source -replace "/", "\")
    $codexPath = Join-Path $root ($entry.codex -replace "/", "\")
    if (-not (Test-Path -LiteralPath $sourcePath)) {
        $errors.Add("Reviewed override source is missing: $name")
        continue
    }
    if (-not (Test-Path -LiteralPath $codexPath)) {
        $errors.Add("Reviewed Codex override is missing: $name")
        continue
    }
    $actualHash = (Get-FileHash -LiteralPath $sourcePath -Algorithm SHA256).Hash
    if ($actualHash -ne $entry.reviewedSourceSha256) {
        $errors.Add("Codex-native override requires review because shared source changed: $name")
    }
}
if ($adaptation.forgeVersion -ne $forgeManifest.forge_version) {
    $errors.Add("Adaptation metadata version mismatch: Forge=$($forgeManifest.forge_version), adaptation=$($adaptation.forgeVersion)")
}
if ([int]$adaptation.skillsAdapted -ne $sourceSkills.Count) {
    $errors.Add("Adaptation skill count mismatch: source=$($sourceSkills.Count), adaptation=$($adaptation.skillsAdapted)")
}

$forbidden = @(
    "C:\Users\",
    "C:/Users/",
    "/Users/",
    "/home/",
    "Learning LLM",
    ".upstream-forge-review"
)
Get-ChildItem -LiteralPath $pluginRoot -Recurse -File | ForEach-Object {
    $textExtensions = @(".md", ".json", ".ps1", ".sh", ".txt", ".toml", ".yaml", ".yml")
    if ($textExtensions -notcontains $_.Extension.ToLowerInvariant()) { return }
    $text = [IO.File]::ReadAllText($_.FullName)
    foreach ($pattern in $forbidden) {
        if ($text.Contains($pattern)) {
            $errors.Add("Machine-specific path '$pattern' found in $($_.FullName.Substring($root.Length + 1))")
        }
    }
}

if ($errors.Count -gt 0) {
    $errors | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Output "Forge parity passed: $($sourceSkills.Count) shared skills, $($claudeCommands.Count) Claude commands, $($codexSkills.Count) Codex skills, version $($forgeManifest.forge_version)."
