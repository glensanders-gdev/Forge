---
name: "company-update"
description: "Update an existing company Forge install — re-run grilling topics to reconfigure operational settings, or refresh bundled skills from the global install. Use when company config needs updating after $company-add, or after a Forge upgrade to push new skill versions to the company repo."
metadata:
  category: company
  version: 1.0.0
  argument_hint: --reconfigure | --update-skills | --all
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Company Update

Post-install maintenance for a company Forge repo. Two modes, usable separately or together.

---

## Usage

```
$company-update --reconfigure    ← re-run selected grilling topics from $company-add
$company-update --update-skills  ← refresh 17 bundled skills from ~/.codex/forge/
$company-update --all            ← both, in order: reconfigure first, then refresh skills
```

---

## Pre-checks

Read `~/.codex/forge/preferences.md`. If `active_company` is not set:
```
❌ No company configured. Run $company-add [name] first.
```
Exit.

Confirm target directory exists: `~/.codex/forge/companies/[active_company]/config.md`.
If missing:
```
❌ Company config not found at ~/.codex/forge/companies/[active_company]/config.md.
   Directory may have been moved or deleted. Re-run $company-add [name] to rebuild.
```
Exit.

---

## Mode: --reconfigure

Re-run any of the 8 grilling topics from `$company-add` against the existing `config.md`.
Answers are merged into the current config — fields not covered in this session are left unchanged.

### Step 1 — Present current config summary

```
Current config for [Company Name]:

  Sprint length:     [N weeks / Kanban]
  Release cadence:   [value]
  Team locations:    [N configured]
  Freeze periods:    [N configured]
  Compliance tier:   [value]
  External approval: [value]
  Deploy chain:      [value]
  AI policy:         [active / none]
  Tools policy:      [N prohibited / N required / N approved]
  Git remote:        [git_remote] / [git_branch]

Which topics do you want to reconfigure?
Enter numbers separated by commas (e.g. "1,3,6") or ALL to re-run everything.

  1. Sprint & Delivery Cadence
  2. Team Locations & Public Holidays
  3. Change Freeze Periods
  4. Compliance & Regulatory Environment
  5. External Approval Gate
  6. Deployment Environment Chain
  7. AI Usage Policy
  8. Tools Policy
```

Wait for topic selection before proceeding.

### Step 2 — Re-run selected topics

For each selected topic, present the same grilling questions as in `$company-add`.
Pre-fill the current value as the default — make it easy to accept or change:

```
Topic 1 — Sprint & Delivery Cadence
Current: 2-week sprints, end-of-sprint release

[Questions from $company-add Topic 1]
```

Collect answers for all selected topics before writing.

### Step 3 — Preview changes

Present a diff of what will change in `config.md`:

```
Changes to config.md:

  sprint_length_weeks:  2  →  3
  release_cadence:      end-of-sprint  →  monthly
  release_day:          (blank)  →  "last Friday of the month"

Write these changes? (yes/no)
```

Wait for confirmation before writing.

### Step 4 — Write and confirm

Update `config.md` with the new values. Fields from non-selected topics are untouched.

```
✅ Config updated — ~/.codex/forge/companies/[active_company]/config.md

   Topics updated: [list]
   Fields changed: N

   Skills that read this config:
   $standup, $sprint-start, $go-nogo, $deploy, $pii-check, $build, $dashboard-tokens

   Run $company-sync to share the updated config with the team.
```

---

## Mode: --update-skills

Refresh the 17 bundled company knowledge skills in the company repo from the live
`~/.codex/forge/skills/` install. Use after a Forge upgrade to propagate fixes and
new skill versions to the company repo.

### Step 1 — Inventory current vs available

For each of the 17 bundled skills, compare the `version:` field in:
- `~/.codex/forge/companies/[active_company].codex/forge/skills/[skill]/SKILL.md` (current)
- `~/.codex/forge/skills/[skill]/SKILL.md` (available)

Present a summary:

```
Skill version check — 17 bundled skills

  Skill              Current    Available  Status
  ─────────────────────────────────────────────────
  ingest             1.0.0      1.2.0      ⬆ update available
  knowledge-health   1.0.0      1.0.0      ✓ current
  pii-check          1.0.0      1.1.0      ⬆ update available
  ...

Updates available: N skills
Already current:   N skills
Missing from ~/.codex/forge/ (cannot update): N skills

Refresh all available updates? (yes/no)
```

Wait for confirmation before copying any files.

### Step 2 — Copy updated skills

For each skill with an update available:
1. Copy `~/.codex/forge/skills/[skill]/SKILL.md` → `~/.codex/forge/companies/[active_company].codex/forge/skills/[skill]/SKILL.md`
2. Copy `~/.codex/forge/commands/[skill].md` → `~/.codex/forge/companies/[active_company].codex/forge/commands/[skill].md`

For skills missing from `~/.codex/forge/` (not installed): note and skip — do not remove the existing bundled copy.

### Step 3 — Confirm

```
✅ Skills refreshed — ~/.codex/forge/companies/[active_company].codex/forge/

   Updated: [N skills — list]
   Skipped (already current): N skills
   Skipped (not in ~/.codex/forge/): [list if any]

   Run $company-sync to push updated skills to the team repo.
```

---

## Mode: --all

Run `--reconfigure` first (full session), then `--update-skills` automatically on completion.

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| `active_company` not set | Exit with $company-add message |
| Config file missing | Exit with rebuild instruction |
| Skill missing from `~/.codex/forge/` | Skip it, note in output — do not block |
| No version field in SKILL.md | Treat as `0.0.0` — always offer update |
| User cancels mid-reconfigure | Write only topics that were completed and confirmed |

---

## Rules

- Never overwrite config fields that weren't covered in the selected topics
- Never write config changes without presenting a diff and receiving confirmation
- Never remove skills from the company repo — only update or skip
- Reconfigure and update-skills are independent — either can run without the other
