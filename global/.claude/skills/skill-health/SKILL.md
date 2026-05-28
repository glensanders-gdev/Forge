---
name: skill-health
description: Read-only structural audit of the Forge skill portfolio. Checks every skill in manifest.json for a matching SKILL.md directory, command stub, required sections (failure modes, rules), and CHANGELOG coverage. Flags orphaned directories, missing commands, and attribution gaps. Saves a report to ~/.claude/knowledge/skill-health-report.md. Use when user runs /skill-health, or run monthly as portfolio maintenance.
origin: Adapted from Affaan Mustafa (ECC / github.com/affaan-m/ECC)
---

# Skill Health

Read-only structural audit of the Forge skill portfolio. Answers: "Is every skill in
`manifest.json` complete, reachable, and recorded?" Complements `/context-health`
(token load) and `/knowledge-health` (knowledge articles) with a third health layer
covering the skills themselves.

---

## Usage

```
/skill-health              ← full audit
/skill-health --critical   ← Red findings only
/skill-health --skill <name>  ← audit a single skill
```

---

## What Gets Checked

| Check | Severity if failing |
|-------|-------------------|
| Skill in `manifest.json` has no `skills/<name>/SKILL.md` | 🔴 Critical |
| `SKILL.md` missing required frontmatter (`name:`, `description:`) | 🔴 Critical |
| `SKILL.md` missing **Failure Modes** section | ⚠️ Amber |
| `SKILL.md` missing **Rules** section | ⚠️ Amber |
| Skill in `manifest.json` has no `commands/<name>.md` stub | ⚠️ Amber |
| Version in `manifest.json` > `1.0.0` but no CHANGELOG entry for that version | ⚠️ Amber |
| `SKILL.md` has `origin:` field but body has no attribution credit line | ⚠️ Amber |
| `skills/<name>/` directory exists but not in `manifest.json` | ℹ️ Info |
| `commands/<name>.md` exists but not in `manifest.json` | ℹ️ Info |
| `SKILL.md` has `version:` in frontmatter that doesn't match `manifest.json` | ℹ️ Info |

---

## Process

### Phase 1 [AFK] — Inventory

Do not produce output during this phase.

1. Read `~/.claude/skills/manifest.json` — extract every skill name and version.
2. List all directories in `~/.claude/skills/` — collect directory names.
3. List all files in `~/.claude/commands/` — collect command stub names (strip `.md`).
4. Read `~/.claude/CHANGELOG.md` — extract all version headings and the skills they mention.
5. For each skill in the manifest, read its `~/.claude/skills/<name>/SKILL.md`
   (if it exists) and extract:
   - Frontmatter fields present (`name:`, `description:`, `version:`, `origin:`)
   - Whether a `## Failure Modes` section is present (any variant of that heading)
   - Whether a `## Rules` section is present (any variant)
   - Whether a body credit line exists (search for the origin URL or author name
     outside the frontmatter block)

---

### Phase 2 [AFK] — Audit

Classify every finding against the checks table above. Tally totals:

```
total_skills        = count of entries in manifest.json
complete            = skills with SKILL.md + command stub + failure modes + rules sections
manifest_orphans    = skills in manifest with no SKILL.md directory
dir_orphans         = skill directories with no manifest entry
missing_commands    = manifest skills with no command stub
missing_sections    = SKILL.md files missing failure modes or rules
changelog_drift     = skills at version > 1.0.0 with no matching CHANGELOG entry
attribution_gaps    = skills with origin: in frontmatter but no body credit line
orphaned_commands   = command stubs with no manifest entry
version_mismatches  = SKILL.md version field != manifest version
```

---

### Phase 3 [AFK] — Report

Output the report using the format defined in `FORMATS.md` in this skill directory, then save it (Phase 4).

---

### Phase 4 [AFK] — Save and Notify

Write the full report to `~/.claude/knowledge/skill-health-report.md` (overwrite previous).

Update `~/.claude/preferences.md`:
```
skill-health-last-run: YYYY-MM-DD
```

If any 🔴 Critical findings exist, surface a prominent warning:
```
🔴 Skill portfolio has critical gaps — N skill(s) in manifest.json have no SKILL.md.
   Top action: [first critical recommendation]
   Full report: ~/.claude/knowledge/skill-health-report.md
```

---

## Forge Integration Points

| Skill / File | Relationship |
|---|---|
| `/write-a-skill` | Defines the structural checklist this skill enforces — the canonical definition of a "complete" skill |
| `/evolve` | Recommended action for Amber skills missing sections — evolve instincts into proper skills |
| `/context-health` | Family sibling — token load audit. Run together for a complete framework health picture. |
| `/knowledge-health` | Family sibling — knowledge article audit. Third panel of the same health picture. |
| `/sprint-start` | Checks `skill-health-last-run` in `preferences.md` — warns if overdue (>30 days) |
| `manifest.json` | Primary inventory source — ground truth for what skills should exist |
| `CHANGELOG.md` | Checked for version coverage — every version bump should have a corresponding entry |

---

## Sprint-Start Integration

`/sprint-start` checks `skill-health-last-run` in `preferences.md`. If more than 30 days ago:

```
⚠️ Skill health check overdue (last run: N days ago).
Consider running /skill-health before this sprint begins.
```

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| `manifest.json` missing or unparseable | Stop and report — cannot audit without the inventory |
| `~/.claude/skills/` directory is empty | Report "No skill directories found — manifest entries are all orphans" |
| `~/.claude/commands/` directory missing | Note "No commands directory — all skills missing command stubs" and continue |
| `CHANGELOG.md` missing | Skip CHANGELOG drift check, note "CHANGELOG.md not found" |
| Single SKILL.md is unreadable | Note the file as unreadable, count it as missing required sections, continue |
| `~/.claude/knowledge/` directory missing | Create it before writing the report |
| `preferences.md` missing | Create it with `skill-health-last-run: YYYY-MM-DD` |
| `--skill <name>` not found in manifest | Report "Skill '<name>' not found in manifest.json" — do not search directories |

---

## Rules

- Read-only throughout — never modify any skill file, manifest, or CHANGELOG during the audit
- Ground every finding in a specific file path — no general observations
- If a section exists under any reasonable heading variant (e.g. "Never", "Failure Modes", "Failure Mode") count it as present — do not penalize naming variations
- Never flag `~/.claude/SOUL.md`, `~/.claude/PRINCIPLES.md`, or framework files as missing skills
- A skill is "complete" only when it passes all checks — partial passes show in the scorecard but not as "complete"
- Always include the Trend line (overall completeness vs previous report) — single snapshots are less useful than direction
- Recommended actions must name the exact file or command — never generic guidance
- If all checks pass, say "✅ All N skills pass all checks" — do not omit the result

---

## Attribution

Concept adapted from Affaan Mustafa (ECC / [github.com/affaan-m/ECC](https://github.com/affaan-m/ECC/blob/main/commands/skill-health.md)). Forge-native implementation — no runtime telemetry required.
