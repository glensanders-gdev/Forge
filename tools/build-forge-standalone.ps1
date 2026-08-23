<#
.SYNOPSIS
    Generates the standalone skills distribution from global/.claude/skills.

.DESCRIPTION
    Third build target off the single source of truth, alongside build-forge-codex.ps1.
    Emits only skills whose frontmatter carries `standalone: true`, with Forge-specific
    scaffolding removed, so the result is usable by someone who has never installed Forge.

    Source of truth stays global/.claude/skills. Never hand-edit the output tree.
#>
param(
    [string]$ForgeRoot = (Join-Path $PSScriptRoot ".."),
    [string]$OutRoot   = (Join-Path $PSScriptRoot ".." "dist" "forge-standalone"),
    [switch]$Strict
)

$ErrorActionPreference = "Stop"

# Conventional headings that exist only to locate a skill inside the Forge pipeline.
# Removed wholesale, along with everything under them until the next heading of equal
# or shallower depth.
$ForgeOnlyHeadings = @(
    'Pipeline Position',
    'Forge Integration Points',
    'Forge Integration',
    'Integration with Forge',
    'Forge Layer Model',
    'Forge Pipeline Alignment',
    'Forge-Specific Notes',
    'Mock Boundaries in Forge Projects',
    'Refactoring and the Forge Layer Model',
    'Scan Forge Documents'
)

function Ensure-Directory([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
}

function Get-Frontmatter([string]$Text) {
    $m = [regex]::Match($Text, "(?s)^---\r?\n(.*?)\r?\n---\r?\n")
    if (-not $m.Success) { return $null }
    $map = [ordered]@{}
    foreach ($line in ($m.Groups[1].Value -split "\r?\n")) {
        if ($line -match "^([A-Za-z0-9_-]+):\s*(.*)$") { $map[$Matches[1]] = $Matches[2].Trim() }
    }
    return @{ Raw = $m.Value; Body = $m.Groups[1].Value; Map = $map }
}

function Remove-ForgeOnlySections([string]$Text, [string[]]$Held) {
    $lines = $Text -split "\r?\n"
    $out = New-Object System.Collections.Generic.List[string]
    $skipDepth = 0
    foreach ($line in $lines) {
        $h = [regex]::Match($line, '^(#{2,6})\s+(.*?)\s*$')
        if ($h.Success) {
            $depth = $h.Groups[1].Value.Length
            $title = $h.Groups[2].Value.Trim('`', ' ')
            if ($skipDepth -gt 0 -and $depth -le $skipDepth) { $skipDepth = 0 }

            $isForgeOnly = $ForgeOnlyHeadings -contains $title
            if (-not $isForgeOnly) {
                # A section whose heading names a skill we do not ship is about that
                # skill. Shipping it leaves the reader chasing a command that does not
                # exist, so the whole section goes.
                foreach ($heldName in $Held) {
                    if ($title -match "(?<![A-Za-z0-9_./-])/$([regex]::Escape($heldName))(?![A-Za-z0-9_-])") {
                        $isForgeOnly = $true
                        break
                    }
                }
            }
            if ($isForgeOnly) { $skipDepth = $depth; continue }
        }
        if ($skipDepth -eq 0) { $out.Add($line) }
    }
    # Collapse the blank-line runs left behind by an excised section.
    return ($out -join "`n") -replace "\n{3,}", "`n`n"
}

function Convert-StandaloneText([string]$Text, [string]$SourcePath, [string[]]$Held) {
    $out = $Text -replace "\r\n?", "`n"

    # <!--forge-only--> ... <!--/forge-only--> is dropped entirely. An unbalanced fence
    # would ship Forge-internal text to a public repo silently, so it fails the build --
    # same contract as the <!--no-adapt--> fence in build-forge-codex.ps1.
    $out = [regex]::Replace($out, "(?s)<!--forge-only-->.*?<!--/forge-only-->", "")
    if ($out -match "<!--/?forge-only-->") {
        throw "Unbalanced <!--forge-only--> fence in $SourcePath"
    }

    # The no-adapt fence guards against the Codex substitution table, which does not run
    # here. Keep the content, drop the markers.
    $out = $out -replace "<!--/?no-adapt-->", ""

    $out = Remove-ForgeOnlySections $out $Held

    # `standalone:` is a build directive, not skill metadata.
    $out = $out -replace "(?m)^standalone:.*\r?\n", ""

    return ($out.TrimEnd() + "`n")
}

# ---------------------------------------------------------------- discover

$skillsRoot = Join-Path $ForgeRoot "global" ".claude" "skills"
if (-not (Test-Path -LiteralPath $skillsRoot)) { throw "Skills root not found: $skillsRoot" }

$all = @{}
foreach ($dir in (Get-ChildItem -LiteralPath $skillsRoot -Directory | Sort-Object Name)) {
    $skillFile = Join-Path $dir.FullName "SKILL.md"
    if (-not (Test-Path -LiteralPath $skillFile)) { continue }
    $text = [IO.File]::ReadAllText($skillFile, [Text.Encoding]::UTF8)
    $fm = Get-Frontmatter $text
    if ($null -eq $fm) { throw "No frontmatter: $skillFile" }
    if (-not $fm.Map.Contains('standalone')) {
        throw "Skill '$($dir.Name)' has no `standalone:` key. Every skill must declare one."
    }
    $all[$dir.Name] = @{
        Dir         = $dir.FullName
        Ship        = ($fm.Map['standalone'] -eq 'true')
        Category    = if ($fm.Map.Contains('category')) { $fm.Map['category'] } else { 'uncategorised' }
        Description = ($fm.Map['description'] -replace '^"|"$', '')
    }
}

$shipped = @($all.Keys | Where-Object { $all[$_].Ship } | Sort-Object)
$held    = @($all.Keys | Where-Object { -not $all[$_].Ship } | Sort-Object)
Write-Host "Source: $($all.Count) skills -> shipping $($shipped.Count), holding $($held.Count)"

# ---------------------------------------------------------------- emit

if (Test-Path -LiteralPath $OutRoot) { Remove-Item -LiteralPath $OutRoot -Recurse -Force }
Ensure-Directory $OutRoot

$skillsOut = Join-Path $OutRoot "skills"
Ensure-Directory $skillsOut

$residual = New-Object System.Collections.Generic.List[object]
$forgeWord = New-Object System.Collections.Generic.List[object]

foreach ($name in $shipped) {
    $src = $all[$name].Dir
    $dst = Join-Path $skillsOut $name
    Ensure-Directory $dst

    Get-ChildItem -LiteralPath $src -Recurse -File -Force | ForEach-Object {
        $relative = $_.FullName.Substring($src.Length).TrimStart("\", "/")
        $target = Join-Path $dst $relative
        Ensure-Directory (Split-Path -Parent $target)
        $ext = [IO.Path]::GetExtension($_.Name).ToLowerInvariant()

        if ($ext -in @(".md", ".json", ".txt", ".yaml", ".yml")) {
            $text = [IO.File]::ReadAllText($_.FullName, [Text.Encoding]::UTF8)
            $adapted = Convert-StandaloneText $text $_.FullName $held
            [IO.File]::WriteAllText($target, $adapted, [Text.UTF8Encoding]::new($false))

            $lineNo = 0
            foreach ($line in ($adapted -split "`n")) {
                $lineNo++
                foreach ($h in $held) {
                    if ($line -match "(?<![A-Za-z0-9_./-])/$([regex]::Escape($h))(?![A-Za-z0-9_-])") {
                        $residual.Add([pscustomobject]@{
                            Skill = $name; File = ($relative -replace '\\', '/')
                            Line = $lineNo; Target = $h; Text = $line.Trim()
                        })
                    }
                }
                if ($line -cmatch "\bForge\b") {
                    $forgeWord.Add([pscustomobject]@{
                        Skill = $name; File = ($relative -replace '\\', '/')
                        Line = $lineNo; Text = $line.Trim()
                    })
                }
            }
        } else {
            Copy-Item -LiteralPath $_.FullName -Destination $target -Force
        }
    }
}

# Rules packs the shipped skills cite by path.
foreach ($pack in @("common", "requirements")) {
    $srcPack = Join-Path $ForgeRoot "global" ".claude" "rules" $pack
    if (-not (Test-Path -LiteralPath $srcPack)) { continue }
    $srcPack = (Resolve-Path -LiteralPath $srcPack).Path
    $dstPack = Join-Path $OutRoot "rules" $pack
    Ensure-Directory $dstPack
    Get-ChildItem -LiteralPath $srcPack -Recurse -File -Force | ForEach-Object {
        $relative = $_.FullName.Substring($srcPack.Length).TrimStart("\", "/")
        $target = Join-Path $dstPack $relative
        Ensure-Directory (Split-Path -Parent $target)
        $text = [IO.File]::ReadAllText($_.FullName, [Text.Encoding]::UTF8)
        [IO.File]::WriteAllText($target, (Convert-StandaloneText $text $_.FullName $held), [Text.UTF8Encoding]::new($false))
    }
}

# ---------------------------------------------------------------- manifest + report

$sourceManifest = Get-Content -LiteralPath (Join-Path $skillsRoot "manifest.json") -Raw | ConvertFrom-Json
$forgeVersion = $sourceManifest.forge_version

# Per-skill versions come from the source registry, so a consumer of the published
# manifest can tell which revision of a given skill they have -- the release number
# alone cannot answer that.
$skillVersions = @{}
foreach ($entry in $sourceManifest.skills.PSObject.Properties) { $skillVersions[$entry.Name] = $entry.Value }

$unversioned = @($shipped | Where-Object { -not $skillVersions.ContainsKey($_) })
if ($unversioned.Count -gt 0) {
    throw "Shipped skill(s) absent from the source registry, so no version can be published: $($unversioned -join ', ')"
}

$manifest = [ordered]@{
    repository  = "https://github.com/glensanders-gdev/skills"
    version     = $forgeVersion
    skill_count = $shipped.Count
    skills        = @($shipped | ForEach-Object {
        [ordered]@{
            name        = $_
            version     = $skillVersions[$_]
            category    = $all[$_].Category
            description = $all[$_].Description
        }
    })
}
$json = ($manifest | ConvertTo-Json -Depth 20) `
    -replace "\\u0026", "&" -replace "\\u0027", "'" -replace "\\u003c", "<" -replace "\\u003e", ">"
[IO.File]::WriteAllText((Join-Path $OutRoot "manifest.json"), ($json -replace "\r\n?", "`n") + "`n", [Text.UTF8Encoding]::new($false))

$reportPath = "$OutRoot-BUILD-REPORT.md"
$report = New-Object System.Collections.Generic.List[string]
$report.Add("# Build Report")
$report.Add("")
$report.Add("Generated by ``tools/build-forge-standalone.ps1`` from Forge $forgeVersion.")
$report.Add("")
$report.Add("- Shipped: $($shipped.Count)")
$report.Add("- Held: $($held.Count)")
$report.Add("- Dangling skill references: $($residual.Count)")
$report.Add("- Surviving ``Forge`` mentions: $($forgeWord.Count)")
$report.Add("")
if ($residual.Count -gt 0) {
    $report.Add("## Dangling references")
    $report.Add("")
    $report.Add("A shipped skill names a skill that is not shipped. Fence the span in the source with")
    $report.Add("``<!--forge-only-->…<!--/forge-only-->``, reword it, or ship the target.")
    $report.Add("")
    $report.Add("| Skill | File | Line | Target | Text |")
    $report.Add("|---|---|---|---|---|")
    foreach ($r in ($residual | Sort-Object Skill, File, Line)) {
        $t = $r.Text -replace '\|', '\|'
        if ($t.Length -gt 90) { $t = $t.Substring(0, 90) + "…" }
        $report.Add("| $($r.Skill) | $($r.File) | $($r.Line) | /$($r.Target) | $t |")
    }
    $report.Add("")
}
if ($forgeWord.Count -gt 0) {
    $report.Add("## Surviving ``Forge`` mentions")
    $report.Add("")
    $report.Add("| Skill | File | Line | Text |")
    $report.Add("|---|---|---|---|")
    foreach ($r in ($forgeWord | Sort-Object Skill, File, Line)) {
        $t = $r.Text -replace '\|', '\|'
        if ($t.Length -gt 90) { $t = $t.Substring(0, 90) + "…" }
        $report.Add("| $($r.Skill) | $($r.File) | $($r.Line) | $t |")
    }
}
[IO.File]::WriteAllText($reportPath, (($report -join "`n") + "`n"), [Text.UTF8Encoding]::new($false))

# ---------------------------------------------------------------- README + installer

$categoryTitles = @{
    'code-quality' = 'Code quality and review'
    'pipeline'     = 'Specification and delivery'
    'session'      = 'Session continuity'
    'knowledge'    = 'Knowledge and learning'
    'metrics'      = 'Context and cost'
    'maintenance'  = 'Maintenance'
    'pi-release'   = 'Release'
    'ideation'     = 'Ideation'
    'security'     = 'Security'
    'delivery'     = 'Delivery governance'
    'framework'    = 'Working with skills'
    'uncategorised' = 'Other'
}
$categoryOrder = @('pipeline','code-quality','security','session','maintenance','pi-release','metrics','knowledge','ideation','delivery','framework','uncategorised')
# Anything with a category the order does not name still gets its own section rather than
# orphaning a table row at the end of the file.
$categoryOrder += @($shipped | ForEach-Object { $all[$_].Category } | Where-Object { $categoryOrder -notcontains $_ } | Sort-Object -Unique)

$readme = New-Object System.Collections.Generic.List[string]
$readme.Add("# Skills")
$readme.Add("")
$readme.Add("$($shipped.Count) skills for [Claude Code](https://claude.com/claude-code) — practical, self-contained")
$readme.Add("workflows for getting real work done with an AI assistant.")
$readme.Add("")
$readme.Add("They cover the parts of software delivery that benefit most from structure: writing")
$readme.Add("requirements, stress-testing a plan before you build it, test-driven implementation,")
$readme.Add("code and security review, accessibility, and keeping context under control across")
$readme.Add("long sessions. Each one stands on its own — install the whole set or a single skill.")
$readme.Add("")
$readme.Add("## Install")
$readme.Add("")
$readme.Add('Everything:')
$readme.Add("")
$readme.Add('```bash')
$readme.Add('git clone https://github.com/glensanders-gdev/skills.git && cd skills && ./install.sh')
$readme.Add('```')
$readme.Add("")
$readme.Add('Or a single skill — copy the folder into `~/.claude/skills/`:')
$readme.Add("")
$readme.Add('```bash')
$readme.Add('cp -r skills/tdd ~/.claude/skills/')
$readme.Add('```')
$readme.Add("")
$readme.Add('Restart your session, then invoke a skill by name — `/tdd`, `/review-diff`, `/write-prd`.')
$readme.Add("")
$readme.Add('Some skills cite the shared standards in `rules/`. `install.sh` copies those to')
$readme.Add('`~/.claude/rules/` alongside the skills.')
$readme.Add("")
$readme.Add("## Skills")
$readme.Add("")
foreach ($cat in $categoryOrder) {
    $inCat = @($shipped | Where-Object { $all[$_].Category -eq $cat })
    if ($inCat.Count -eq 0) { continue }
    $title = if ($categoryTitles.ContainsKey($cat)) { $categoryTitles[$cat] } else { $cat }
    $readme.Add("### $title")
    $readme.Add("")
    $readme.Add("| Skill | What it does |")
    $readme.Add("|---|---|")
    foreach ($n in $inCat) {
        $d = $all[$n].Description -replace '\|', '\|'
        if ($d.Length -gt 150) { $d = $d.Substring(0, 150).TrimEnd() + "…" }
        $readme.Add("| [``/$n``](skills/$n/SKILL.md) | $d |")
    }
    $readme.Add("")
}
$unlisted = @($shipped | Where-Object { $categoryOrder -notcontains $all[$_].Category })
if ($unlisted.Count -gt 0) { throw "Skills fell outside every README section: $($unlisted -join ', ')" }

$readme.Add("## Conventions")
$readme.Add("")
$readme.Add('Every skill declares its execution mode — **[HITL]** pauses for a human, **[AFK]** runs')
$readme.Add('through. Anything consequential asks for a typed confirmation (`CONFIRM`, `APPROVE`,')
$readme.Add('`GO`). Every skill also carries explicit "never" rules, not just instructions.')
$readme.Add("")
$readme.Add("## Generated — do not edit in place")
$readme.Add("")
$readme.Add("These files are generated, so edits made directly here are overwritten on the next")
$readme.Add("release. Open an issue describing what needs changing and it will be fixed upstream")
$readme.Add("and republished.")
$readme.Add("")
$readme.Add("Release $forgeVersion.")
$readme.Add("")
$readme.Add("## Credits")
$readme.Add("")
$readme.Add("Individual skills credit their origins in their own files — several are adapted from")
$readme.Add("[Matt Pocock's skills](https://github.com/mattpocock/skills) and from Affaan Mustafa's ECC.")
[IO.File]::WriteAllText((Join-Path $OutRoot "README.md"), (($readme -join "`n") + "`n"), [Text.UTF8Encoding]::new($false))

$installer = @'
#!/usr/bin/env bash
# Installs these skills into ~/.claude/skills/ (and the rules they cite into ~/.claude/rules/).
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
skills_dst="${HOME}/.claude/skills"
rules_dst="${HOME}/.claude/rules"

mkdir -p "$skills_dst" "$rules_dst"

installed=0
for dir in "$here"/skills/*/; do
    name="$(basename "$dir")"
    if [ -e "$skills_dst/$name" ] && [ ! -d "$skills_dst/$name" ]; then
        echo "skip $name — ~/.claude/skills/$name exists and is not a directory" >&2
        continue
    fi
    rm -rf "${skills_dst:?}/$name"
    cp -R "$dir" "$skills_dst/$name"
    installed=$((installed + 1))
done

for dir in "$here"/rules/*/; do
    name="$(basename "$dir")"
    rm -rf "${rules_dst:?}/$name"
    cp -R "$dir" "$rules_dst/$name"
done

echo "Installed $installed skills to $skills_dst"
echo "Installed rules to $rules_dst"
echo "Restart your Claude Code session to pick them up."
'@
# The published repository is cloned on Windows too, where core.autocrlf rewrites
# checkouts to CRLF. Markdown survives that; install.sh does not -- bash rejects a
# script whose shebang line ends in CR.
$gitattributes = "* text=auto eol=lf`n"
[IO.File]::WriteAllText((Join-Path $OutRoot ".gitattributes"), $gitattributes, [Text.UTF8Encoding]::new($false))

$installPath = Join-Path $OutRoot "install.sh"
[IO.File]::WriteAllText($installPath, ($installer -replace "\r\n?", "`n"), [Text.UTF8Encoding]::new($false))
if ($IsLinux -or $IsMacOS) { chmod +x $installPath }

Write-Host "Dangling references: $($residual.Count)"
Write-Host "Surviving 'Forge' mentions: $($forgeWord.Count)"
Write-Host "Output: $OutRoot"

# The published tree is a standalone product and must not name the framework it is
# generated from. `forge` lowercase is left alone -- it is an ordinary English verb
# ("cannot forge a signature") and appears legitimately in the security references.
$leaks = @(Get-ChildItem -LiteralPath $OutRoot -Recurse -File |
    Where-Object { $_.Extension -in @(".md", ".json", ".txt", ".sh", ".yaml", ".yml") } |
    ForEach-Object {
        $rel = $_.FullName.Substring($OutRoot.Length).TrimStart("\", "/") -replace "\\", "/"
        $i = 0
        foreach ($line in ([IO.File]::ReadAllText($_.FullName, [Text.Encoding]::UTF8) -split "`n")) {
            $i++
            if ($line -cmatch "\bForge\b" -or $line -cmatch "forge[-_](version|standalone|codex|confluence)") {
                "  ${rel}:${i}: $($line.Trim())"
            }
        }
    })
if ($leaks.Count -gt 0) {
    Write-Host "Upstream name leaked into the distribution:"
    $leaks | ForEach-Object { Write-Host $_ }
    throw "$($leaks.Count) reference(s) to the upstream framework in the published tree."
}

if ($Strict -and $residual.Count -gt 0) {
    throw "$($residual.Count) dangling skill reference(s). See $reportPath"
}
