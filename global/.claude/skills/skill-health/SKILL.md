---
name: skill-health
category: framework
description: Read-only structural audit of the Forge skill portfolio. Checks every skill in manifest.json for a matching SKILL.md directory, command stub, required sections (failure modes, rules), CHANGELOG coverage, a frontmatter name that disagrees with its directory, and a name shadowed by a Claude Code built-in. Flags orphaned directories, missing commands, and attribution gaps. Saves a report to ~/.claude/knowledge/skill-health-report.md. Use when user runs /skill-health, or run monthly as portfolio maintenance.
origin: Adapted from Affaan Mustafa (ECC / github.com/affaan-m/ECC)
---

# Skill Health

Read-only structural audit of the Forge skill portfolio. Answers: "Is every skill in
`manifest.json` complete, reachable, and recorded?" **Reachable** carries two name checks, both
silent failures. A skill whose name Claude Code has claimed never loads — the shadowed skill
looks perfectly healthy on disk. Reserved names live in
`skills/write-a-skill/RESERVED-NAMES.md`. A skill whose frontmatter `name:` disagrees with its
directory registers under the declared name or not at all, so the directory, the manifest key
and the command stub all point at something that is not there — and every one of those three
agreeing with each other hides it. Complements `/context-health`
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
| Skill name matches a Reserved row in `write-a-skill/RESERVED-NAMES.md` | 🔴 Critical |
| `SKILL.md` frontmatter `name:` does not equal its directory name | 🔴 Critical |
| Skill in `manifest.json` has no `skills/<name>/SKILL.md` | 🔴 Critical |
| `SKILL.md` missing required frontmatter (`name:`, `description:`) | 🔴 Critical |
| `SKILL.md` missing **Failure Modes** section | ⚠️ Amber |
| `SKILL.md` missing **Rules** section | ⚠️ Amber |
| Skill in `manifest.json` has no `commands/<name>.md` stub | ⚠️ Amber |
| `commands/<name>.md` opens `Invoke the <other> skill` — a name that is not `<name>` | ⚠️ Amber |
| Version in `manifest.json` > `1.0.0` but no CHANGELOG entry for that version | ⚠️ Amber |
| `SKILL.md` has `origin:` field but body has no attribution credit line | ⚠️ Amber |
| `skills/<name>/` directory exists but not in `manifest.json` | ℹ️ Info |
| `commands/<name>.md` exists but not in `manifest.json` | ℹ️ Info |
| `SKILL.md` carries a `version:` field in its frontmatter block (not its body) | ⚠️ Amber |
| Skill name matches an At Risk row in `RESERVED-NAMES.md` | ℹ️ Info |
| `RESERVED-NAMES.md` verification stamp exceeds `Forge staleness warning (days)` from `preferences.md` (default 30), or carries no version | ℹ️ Info |
| `~/.claude/forge-version` missing or `updated:` date exceeds `Forge staleness warning (days)` from `preferences.md` (default 30) | ℹ️ Info |

---

## Process

### Phase 1 [AFK] — Inventory

Do not produce output during this phase.

1. Read `~/.claude/skills/manifest.json` — extract every skill name and version.
2. List all directories in `~/.claude/skills/` — collect directory names.
3. List all files in `~/.claude/commands/` — collect command stub names (strip `.md`).
4. Read `~/.claude/CHANGELOG.md` — extract all version headings and the skills they mention.
5. Read `~/.claude/skills/write-a-skill/RESERVED-NAMES.md` — extract the Reserved names (both
   tables), the At Risk names, and the verification stamp's date and version. Compare every
   manifest name against the Reserved set; a match is a shadowed skill. Report the stamp's age
   alongside every finding it produced — a collision found against a six-month-old list is a
   different claim from one found against last week's.
6. Read `~/.claude/forge-version` (if it exists) — extract `version:`, `installed:` date, and `commit:` SHA. Calculate days since install.
7. For each skill in the manifest, read its `~/.claude/skills/<name>/SKILL.md`
   (if it exists) and extract:
   - Frontmatter fields present (`name:`, `description:`, `origin:`) — and that `version:`
     is **absent**: `manifest.json` is the sole source of a skill's version, so a copy in
     frontmatter is a second source that can only ever drift out of agreement with it.
     Read the frontmatter block only — the leading `---` fence to its closing `---` — and
     never the body. `update-forge` documents the `forge-version` file format inside a fenced
     code block containing a literal `version:` line, so a whole-file scan reports a skill
     that is in fact clean
   - The **value** of `name:`, compared against the directory name it was read from — they
     must be identical. Compare the raw string: strip surrounding quotes and trailing
     whitespace, but never normalise case, hyphens or underscores, because the loader does not
   - The manifest key and the `commands/<name>.md` stub for the same skill, so a mismatch is
     reported with all four identifiers side by side
   - The **skill named in the stub's opening clause** (`Invoke the <name> skill`), compared
     against the stub's own filename. A rename that updates the filename but not the sentence
     leaves the stub describing a skill that no longer exists, and nothing errors — the stub
     still resolves, so only reading it reveals the stale name. Stubs that open `Alias for
     /<other>` are deliberate and are not findings
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
shadowed_skills     = manifest names matching a Reserved row in RESERVED-NAMES.md
name_mismatches     = skills whose SKILL.md name: != its directory name
at_risk_skills      = manifest names matching an At Risk row
reserved_stamp_age  = days since the RESERVED-NAMES.md verification date
reserved_stamp_ver  = Claude Code version in the stamp, or "not recorded"
manifest_orphans    = skills in manifest with no SKILL.md directory
dir_orphans         = skill directories with no manifest entry
missing_commands    = manifest skills with no command stub
stale_stub_names    = command stubs whose opening clause names a skill other than their filename
missing_sections    = SKILL.md files missing failure modes or rules
changelog_drift     = skills at version > 1.0.0 with no matching CHANGELOG entry
attribution_gaps    = skills with origin: in frontmatter but no body credit line
orphaned_commands   = command stubs with no manifest entry
frontmatter_versions = SKILL.md files carrying a version: field (manifest owns the version)
forge_version_stale = forge-version file missing, or updated date exceeds staleness threshold from preferences.md
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

A shadowed name leads that warning ahead of any other Critical finding. A skill with no SKILL.md
is visibly broken; a shadowed skill is invisibly broken, and the reader has no other way to find
out:
```
🔴 N skill(s) are shadowed by a Claude Code name — they never load, and produce no error.
   Shadowed: [names]
   Reserved list last verified YYYY-MM-DD (Claude Code [version or "version not recorded"]).
   Renaming is a major version — see /write-a-skill.
```

A name mismatch is the same silent-failure class and follows the shadowed names in the warning,
ahead of every visibly-broken finding:
```
🔴 N skill(s) declare a name that is not their directory — they register under the declared
   name or not at all, and produce no error.
   Mismatched: <dir> declares <name>
```

---

## Forge Integration Points

| Skill / File | Relationship |
|---|---|
| `/write-a-skill` | Defines the structural checklist this skill enforces — the canonical definition of a "complete" skill. Owns `RESERVED-NAMES.md`, which both skills read and neither restates |
| `RESERVED-NAMES.md` | The reserved-name inventory. `/write-a-skill` gates on it at authoring time; this skill re-checks the whole portfolio as the list grows |
| `/evolve` | Recommended action for Amber skills missing sections — evolve instincts into proper skills |
| `/context-health` | Family sibling — token load audit. Run together for a complete framework health picture. |
| `/knowledge-health` | Family sibling — knowledge article audit. Third panel of the same health picture. |
| `/start-sprint` | Checks `skill-health-last-run` in `preferences.md` — warns if overdue (>30 days) |
| `manifest.json` | Primary inventory source — ground truth for what skills should exist |
| `CHANGELOG.md` | Checked for version coverage — every version bump should have a corresponding entry |

---

## Sprint-Start Integration

`/start-sprint` checks `skill-health-last-run` in `preferences.md`. If more than 30 days ago:

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
| A `version:` or `name:` line is found in a fenced code block | Not a finding — frontmatter is the block between the opening `---` and its closing `---`, and nothing after it counts |
| `~/.claude/knowledge/` directory missing | Create it before writing the report |
| `preferences.md` missing | Create it with `skill-health-last-run: YYYY-MM-DD` |
| `RESERVED-NAMES.md` missing | Report 🔴 Critical — the authoring gate in `/write-a-skill` has nothing to check against. Skip the collision checks, name the absence, continue the rest of the audit |
| `RESERVED-NAMES.md` stamp has no version | Report ℹ️ Info and repeat it on every collision finding — an undated clearance is worth less than it looks |
| A command stub names a different skill than its filename | Report ⚠️ Amber and correct the opening clause to the stub's own name. Check the rest of the stub body for other references to the retired name before closing it |
| A `SKILL.md` carries a `version:` field | Report ⚠️ Amber and recommend deleting the line, whatever its value — never recommend correcting it to match the manifest, which restores the second source of truth this check exists to remove |
| A shadowed skill is found | Report 🔴 Critical and lead the warning with it. Recommend the rename with its major version; never recommend a deprecation stub — the old name is shadowed, so the stub is unreachable too |
| `SKILL.md` frontmatter `name:` does not equal its directory name | Report 🔴 Critical. Name all four identifiers — directory, frontmatter, manifest key, command stub — and recommend correcting whichever is in the minority. Never assume the frontmatter is authoritative |
| A name mismatch and a shadowed name are found on the same skill | Report both. Resolving the mismatch toward a shadowed name would trade a silent failure for a different one — say so, and recommend a name that is clear of the reserved list |
| `--skill <name>` not found in manifest | Report "Skill '<name>' not found in manifest.json" — do not search directories |

---

## Related

- `global/.claude/skills/manifest.json` — the **Forge Skills Manifest** this skill audits
- `/update-forge` — applies fixes identified by skill-health
- `/commands` — lists all skills; skill-health validates they match what's in the manifest
- `/evolve` — promotes instincts to new skills; skill-health verifies the promotion landed correctly

## Rules

- Read-only throughout — never modify any skill file, manifest, or CHANGELOG during the audit
- Ground every finding in a specific file path — no general observations
- If a section exists under any reasonable heading variant (e.g. "Never", "Failure Modes", "Failure Mode") count it as present — do not penalize naming variations
- Never flag `~/.claude/SOUL.md`, `~/.claude/PRINCIPLES.md`, or framework files as missing skills
- Never compare a frontmatter `name:` to its directory case-insensitively, or after normalising hyphens or underscores — the loader matches the literal string, so a "close enough" name is still a mismatch
- Never resolve a name mismatch by assuming the frontmatter is correct — check which identifier the directory, manifest and command stub agree on, and check whether a variant of the skill ever existed under the declared name before recommending either an edit or a rename
- Never treat a name's absence from `RESERVED-NAMES.md` as proof it is free — report it as unchecked against a list stamped YYYY-MM-DD, which is what it is
- Never edit `RESERVED-NAMES.md` during the audit — a stale stamp is reported, never quietly refreshed (the audit is read-only, and a refresh needs the live session this skill does not have)
- A skill is "complete" only when it passes all checks — partial passes show in the scorecard but not as "complete"
- Always include the Trend line (overall completeness vs previous report) — single snapshots are less useful than direction
- Recommended actions must name the exact file or command — never generic guidance
- If all checks pass, say "✅ All N skills pass all checks" — do not omit the result

---

## Attribution

Concept adapted from Affaan Mustafa (ECC / [github.com/affaan-m/ECC](https://github.com/affaan-m/ECC/blob/main/commands/skill-health.md)). Forge-native implementation — no runtime telemetry required.
