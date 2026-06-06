param(
    [string]$ForgeRoot = (Join-Path $PSScriptRoot ".."),
    [string]$PluginRoot = (Join-Path $PSScriptRoot "..\plugins\forge-codex")
)

$ErrorActionPreference = "Stop"

function Ensure-Directory([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
}

function ConvertTo-StableJson([object]$Value, [switch]$Compress) {
    $json = if ($Compress) {
        $Value | ConvertTo-Json -Depth 20 -Compress
    } else {
        $Value | ConvertTo-Json -Depth 20
    }

    # Windows PowerShell escapes HTML-sensitive characters while PowerShell 7 does not.
    return $json `
        -replace "\\u0026", "&" `
        -replace "\\u0027", "'" `
        -replace "\\u003c", "<" `
        -replace "\\u003e", ">"
}

function Convert-ForgeText([string]$Text, [string[]]$SkillNames) {
    $out = $Text
    $out = $out -replace "~/.claude", "~/.codex/forge"
    $out = $out -replace "~\\.claude", "~\.codex\forge"
    $out = $out -replace "(?<!~)/?\.claude/", ".codex/forge/"
    $out = $out -replace "(?<!~)\\?\.claude\\", ".codex\forge\"
    $out = $out -replace "\bCLAUDE\.md\b", "AGENTS.md"
    $out = $out -replace "\bClaude Code\b", "Codex"
    $out = $out -replace "\bClaude Desktop\b", "Codex app"
    $out = $out -replace "\bClaude\b", "Codex"
    $out = $out -replace "/user:", ""

    foreach ($name in $SkillNames) {
        $escaped = [regex]::Escape($name)
        $out = $out -replace "(?<![A-Za-z0-9_.:`$~-])/$escaped\b", ('$$' + $name)
    }

    if ($out -match "(?s)^---\r?\n(.*?)\r?\n---") {
        $frontmatter = $Matches[1]
        if ($frontmatter -notmatch "(?m)^origin:") {
            $replacement = "---`n$frontmatter`norigin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)`n---"
            $out = [regex]::Replace($out, "(?s)^---\r?\n.*?\r?\n---", $replacement, 1)
        }
    }

    return $out
}

function Normalize-CodexSkillFrontmatter([string]$Path) {
    $text = [IO.File]::ReadAllText($Path, [Text.Encoding]::UTF8)
    $match = [regex]::Match($text, "(?s)^---\r?\n(.*?)\r?\n---")
    if (-not $match.Success) { return }

    $allowed = @("name", "description", "license", "allowed-tools", "metadata")
    $kept = New-Object System.Collections.Generic.List[string]
    $metadata = [ordered]@{}
    $keepIndented = $false

    foreach ($line in ($match.Groups[1].Value -split "\r?\n")) {
        if ($line -match "^([A-Za-z0-9_-]+):\s*(.*)$") {
            $key = $Matches[1]
            $value = $Matches[2]
            if ($allowed -contains $key) {
                if ($key -in @("name", "description")) {
                    $plainValue = $value.Trim()
                    while ($plainValue.StartsWith('"') -and $plainValue.EndsWith('"')) {
                        try {
                            $decoded = $plainValue | ConvertFrom-Json
                            if ($decoded -isnot [string] -or $decoded -eq $plainValue) { break }
                            $plainValue = $decoded
                        } catch {
                            break
                        }
                    }
                    $quotedValue = ConvertTo-StableJson $plainValue -Compress
                    $kept.Add("${key}: $quotedValue")
                } else {
                    $kept.Add($line)
                }
                $keepIndented = $true
            } else {
                $metadataKey = $key -replace "-", "_"
                $metadata[$metadataKey] = $value
                $keepIndented = $false
            }
        } elseif (($line -match "^\s+") -and $keepIndented) {
            $kept.Add($line)
        } elseif ($line -notmatch "^\s+") {
            $kept.Add($line)
            $keepIndented = $false
        }
    }

    if ($metadata.Count -gt 0) {
        $kept.Add("metadata:")
        foreach ($entry in $metadata.GetEnumerator()) {
            $kept.Add("  $($entry.Key): $($entry.Value)")
        }
    }

    $frontmatter = "---`n" + ($kept -join "`n") + "`n---"
    $normalized = $frontmatter + $text.Substring($match.Length)
    [IO.File]::WriteAllText($Path, $normalized, [Text.UTF8Encoding]::new($false))
}

function Copy-AdaptedTree([string]$Source, [string]$Destination, [string[]]$SkillNames) {
    $Source = (Resolve-Path -LiteralPath $Source).Path
    Ensure-Directory $Destination
    Get-ChildItem -LiteralPath $Source -Recurse -File | ForEach-Object {
        $relative = $_.FullName.Substring($Source.Length).TrimStart("\", "/")
        $target = Join-Path $Destination $relative
        Ensure-Directory (Split-Path -Parent $target)
        $extension = [IO.Path]::GetExtension($_.Name).ToLowerInvariant()

        if ($extension -in @(".md", ".json", ".txt", ".sh", ".ps1", ".toml", ".yaml", ".yml")) {
            $text = [IO.File]::ReadAllText($_.FullName, [Text.Encoding]::UTF8)
            $adapted = Convert-ForgeText $text $SkillNames
            [IO.File]::WriteAllText($target, $adapted, [Text.UTF8Encoding]::new($false))
        } else {
            Copy-Item -LiteralPath $_.FullName -Destination $target -Force
        }
    }
}

function Convert-ProjectTemplate([string]$TemplateRoot) {
    $claudeInstructions = Join-Path $TemplateRoot "CLAUDE.md"
    $agentsInstructions = Join-Path $TemplateRoot "AGENTS.md"
    if (Test-Path -LiteralPath $claudeInstructions) {
        Move-Item -LiteralPath $claudeInstructions -Destination $agentsInstructions -Force
    }

    $claudeDir = Join-Path $TemplateRoot ".claude"
    if (-not (Test-Path -LiteralPath $claudeDir)) { return }

    $agentsSkills = Join-Path $TemplateRoot ".agents\skills"
    $sourceSkills = Join-Path $claudeDir "skills"
    if (Test-Path -LiteralPath $sourceSkills) {
        Ensure-Directory (Split-Path -Parent $agentsSkills)
        Move-Item -LiteralPath $sourceSkills -Destination $agentsSkills -Force
    }

    $commands = Join-Path $claudeDir "commands"
    if (Test-Path -LiteralPath $commands) {
        Remove-Item -LiteralPath $commands -Recurse -Force
    }

    $codexForgeDir = Join-Path $TemplateRoot ".codex\forge"
    Ensure-Directory (Split-Path -Parent $codexForgeDir)
    Move-Item -LiteralPath $claudeDir -Destination $codexForgeDir -Force
}

$sourceSkills = Join-Path $ForgeRoot "global\.claude\skills"
$destinationSkills = Join-Path $PluginRoot "skills"
$references = Join-Path $PluginRoot "references"

if (-not (Test-Path -LiteralPath $sourceSkills)) {
    throw "Upstream Forge skills not found at $sourceSkills"
}

$skillNames = Get-ChildItem -LiteralPath $sourceSkills -Directory |
    Select-Object -ExpandProperty Name |
    Sort-Object
$codexNativeOverrides = @(
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

Ensure-Directory $destinationSkills
Ensure-Directory $references

foreach ($skillName in $skillNames) {
    if (($codexNativeOverrides -contains $skillName) -and (Test-Path -LiteralPath (Join-Path $destinationSkills "$skillName\SKILL.md"))) {
        continue
    }
    $skillDestination = Join-Path $destinationSkills $skillName
    if (Test-Path -LiteralPath $skillDestination) {
        Remove-Item -LiteralPath $skillDestination -Recurse -Force
    }
    Copy-AdaptedTree (Join-Path $sourceSkills $skillName) $skillDestination $skillNames
}

$frameworkFiles = @("CHANGELOG.md", "PRINCIPLES.md", "SOUL.md", "forge-sequence.mmd", "preferences.md", "registry-README.md")
foreach ($file in $frameworkFiles) {
    $source = Join-Path $ForgeRoot "global\.claude\$file"
    if (Test-Path -LiteralPath $source) {
        $text = [IO.File]::ReadAllText($source, [Text.Encoding]::UTF8)
        [IO.File]::WriteAllText((Join-Path $references $file), (Convert-ForgeText $text $skillNames), [Text.UTF8Encoding]::new($false))
    }
}

$codingGuidance = Join-Path $references "coding-guidance"
$projectTemplate = Join-Path $references "project-template"
foreach ($generatedReference in @($codingGuidance, $projectTemplate)) {
    if (Test-Path -LiteralPath $generatedReference) {
        Remove-Item -LiteralPath $generatedReference -Recurse -Force
    }
}
Copy-AdaptedTree (Join-Path $ForgeRoot "global\.claude\rules") $codingGuidance $skillNames
Copy-AdaptedTree (Join-Path $ForgeRoot "project-template") $projectTemplate $skillNames
Convert-ProjectTemplate $projectTemplate

$manifestSource = Join-Path $sourceSkills "manifest.json"
if (Test-Path -LiteralPath $manifestSource) {
    Copy-Item -LiteralPath $manifestSource -Destination (Join-Path $references "upstream-manifest.json") -Force
}

Get-ChildItem -LiteralPath $destinationSkills -Recurse -Filter "SKILL.md" -File |
    ForEach-Object { Normalize-CodexSkillFrontmatter $_.FullName }

$forgeManifest = Get-Content -LiteralPath $manifestSource -Raw | ConvertFrom-Json
$summary = [ordered]@{
    source = "global/.claude/"
    forgeVersion = $forgeManifest.forge_version
    skillsAdapted = $skillNames.Count
    dataRoot = "~/.codex/forge/"
    projectInstructions = "AGENTS.md"
}
$summaryJson = ConvertTo-StableJson $summary -Compress
[IO.File]::WriteAllText(
    (Join-Path $references "adaptation-build.json"),
    $summaryJson + "`n",
    [Text.UTF8Encoding]::new($false)
)

$summaryJson
