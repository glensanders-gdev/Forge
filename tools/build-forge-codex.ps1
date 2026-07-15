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
    $out = $out.Replace("global/.claude/", "__FORGE_SOURCE__/")
    $out = $out.Replace("global\.claude\", "__FORGE_SOURCE__\")
    # Repository-scoped skills use the cross-agent discovery directory. Keep
    # this conversion ahead of the generic .claude -> .codex/forge data rewrite.
    $out = $out -replace "(?<!~)/?\.claude/skills/", ".agents/skills/"
    $out = $out -replace "(?<!~)\\?\.claude\\skills\\", ".agents\skills\"
    $out = $out -replace "~/.claude", "~/.codex/forge"
    $out = $out -replace "~\\.claude", "~\.codex\forge"
    $out = $out -replace "(?<!~)/?\.claude/", ".codex/forge/"
    $out = $out -replace "(?<!~)\\?\.claude\\", ".codex\forge\"
    $out = $out -replace "\bCLAUDE\.md\b", "AGENTS.md"
    $out = $out -replace "\bClaude Code\b", "Codex"
    $out = $out -replace "\bClaude Desktop\b", "Codex app"
    $out = $out -replace "\bClaude\b", "Codex"
    $out = $out -replace "/user:", ""
    $out = $out.Replace("__FORGE_SOURCE__/", "global/.claude/")
    $out = $out.Replace("__FORGE_SOURCE__\", "global\.claude\")
    # Codex discovers SKILL.md directly and has no project command-stub tree.
    $out = $out.Replace(' and `.codex/forge/commands/`', '')
    $out = $out -replace "(?m)^.*\.codex/forge/commands/.*\r?\n", ""
    $out = $out -replace "(?m)^.*Project-level commands use.*\r?\n", ""

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

    return $out -replace "\r\n?", "`n"
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
    # -Force: on Unix, dotfiles (.gitignore, .gitkeep, .agents/) are hidden and skipped without it
    Get-ChildItem -LiteralPath $Source -Recurse -File -Force | ForEach-Object {
        $relative = $_.FullName.Substring($Source.Length).TrimStart("\", "/")
        $target = Join-Path $Destination $relative
        Ensure-Directory (Split-Path -Parent $target)
        $extension = [IO.Path]::GetExtension($_.Name).ToLowerInvariant()
        $relativePosix = $relative -replace "\\", "/"

        if ($relativePosix -eq "agents/openai.yaml") {
            $agentText = [IO.File]::ReadAllText($_.FullName, [Text.Encoding]::UTF8)
            if ($agentText -match "(?m)^interface:\s*$") {
                $adapted = Convert-ForgeText $agentText $SkillNames
            } else {
                $skillName = Split-Path -Leaf $Source
                $defaultPrompt = "Use `$$skillName to audit this codebase and provide severity-ranked findings with fixes."
                $adapted = @"
interface:
  display_name: "$skillName"
  short_description: "Audit codebases for common security vulnerabilities."
  default_prompt: "$defaultPrompt"
policy:
  allow_implicit_invocation: true
"@
            }
            [IO.File]::WriteAllText($target, ($adapted -replace "\r\n?", "`n"), [Text.UTF8Encoding]::new($false))
        } elseif ($_.Name -in @(".gitignore", ".gitattributes")) {
            $text = [IO.File]::ReadAllText($_.FullName, [Text.Encoding]::UTF8)
            $normalized = $text -replace "\r\n?", "`n"
            [IO.File]::WriteAllText($target, $normalized, [Text.UTF8Encoding]::new($false))
        } elseif ($extension -in @(".md", ".json", ".txt", ".sh", ".ps1", ".toml", ".yaml", ".yml")) {
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

# Project templates cannot link to files inside the installed plugin cache by a
# stable absolute path. Point users at the owning skill, which can resolve its
# bundled sibling references wherever Codex installed the plugin.
$templateReferenceRewrites = [ordered]@{
    'See `~/.codex/forge/skills/grill-with-docs/CONTEXT-FORMAT.md` for the full format guide.' = 'Run `$grill-with-docs` for the authoritative bundled CONTEXT format.'
    'See `~/.codex/forge/skills/grill-with-docs/ADR-FORMAT.md` for the full format guide and "when to create" rules.' = 'Run `$grill-with-docs` for the authoritative bundled ADR format and creation rules.'
    'see `~/.codex/forge/skills/token-report/TOKEN-RECORDING.md`' = 'use `$token-report` for the recording rules'
    'from ccusage actuals' = 'from exact Codex measurements when available'
    '**Source:** ccusage actuals' = '**Source:** [Codex export | user-provided measurement | unavailable]'
    '`forge/global/.claude/skills/manifest.json` — v2.3.7, 51 skills' = '`forge/global/.claude/skills/manifest.json` — shared Forge skill manifest'
}
Get-ChildItem -LiteralPath $projectTemplate -Recurse -File -Filter "*.md" | ForEach-Object {
    $text = [IO.File]::ReadAllText($_.FullName, [Text.Encoding]::UTF8)
    foreach ($entry in $templateReferenceRewrites.GetEnumerator()) {
        $text = $text.Replace($entry.Key, $entry.Value)
    }
    [IO.File]::WriteAllText($_.FullName, $text, [Text.UTF8Encoding]::new($false))
}

$manifestSource = Join-Path $sourceSkills "manifest.json"
if (Test-Path -LiteralPath $manifestSource) {
    $manifestText = [IO.File]::ReadAllText($manifestSource, [Text.Encoding]::UTF8) -replace "\r\n?", "`n"
    [IO.File]::WriteAllText(
        (Join-Path $references "upstream-manifest.json"),
        $manifestText,
        [Text.UTF8Encoding]::new($false)
    )
}

Get-ChildItem -LiteralPath $destinationSkills -Recurse -Filter "SKILL.md" -File |
    ForEach-Object { Normalize-CodexSkillFrontmatter $_.FullName }

$forgeManifest = Get-Content -LiteralPath $manifestSource -Raw | ConvertFrom-Json

# Stamp the shared framework version into the Codex plugin manifest so the build
# owns the version field. test-forge-parity.ps1 fails if plugin.json's version
# drifts from forge_version, and ConvertFrom/ConvertTo-Json would reflow the whole
# file — so patch only the version token, preserving formatting byte-for-byte.
$pluginManifestPath = Join-Path $PluginRoot ".codex-plugin\plugin.json"
if (Test-Path -LiteralPath $pluginManifestPath) {
    $pluginManifestText = [IO.File]::ReadAllText($pluginManifestPath, [Text.Encoding]::UTF8)
    $stampedManifest = [regex]::Replace(
        $pluginManifestText,
        '("name":\s*"forge-codex",\s*\r?\n\s*"version":\s*)"[^"]*"',
        ('${1}"' + $forgeManifest.forge_version + '"')
    )
    if ($stampedManifest -ne $pluginManifestText) {
        [IO.File]::WriteAllText($pluginManifestPath, ($stampedManifest -replace "\r\n?", "`n"), [Text.UTF8Encoding]::new($false))
    }
}

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
