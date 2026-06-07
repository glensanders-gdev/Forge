---
name: update-readme
category: code-quality
description: Review the current README.md against the active PRD, DEVLOG, and codebase, then propose updates for new features, changed behaviour, or version history. Advisory only until confirmed. Use when user runs /update-readme, a feature is approved, or README appears out of date.
---

# Update README

Keep `README.md` current with the project's actual state. Reads the current README, compares against what has been built and approved, and proposes specific updates. Advisory only — nothing is written without confirmation.

## Pipeline Position

Post-approval documentation step, typically run after `/approve` or `/changelog`.

```
/approve  →  /changelog  →  /update-readme
```

Follows: `/approve` (feature shipped), `/changelog` (version documented)
Related: `/push-standards` (keeps CODING-STANDARDS.md current), `/write-prd` (source of truth for what was built)

## When to Use

- A feature has been approved via `/approve`
- User explicitly runs `/user:update-readme`
- Session start reveals README hasn't been updated in several sessions
- New functionality is live that isn't reflected in the README

## Process

1. Read `README.md` — understand current content and structure.
2. Read `docs/prd/active/` and recently archived PRDs — identify features approved since the last README update.
3. Read recent `docs/DEVLOG.md` entries — identify behaviour changes, new features, and version bumps.
4. Read `docs/CONTEXT.md` — ensure README uses canonical domain terminology.
5. Identify gaps between what README says and what the project actually does.
6. Produce a diff-style proposal — show exactly what to add, change, or remove.
7. Present for confirmation before writing anything.
8. On confirmation, update `README.md`.

## What to Check

| README section | What to verify |
|----------------|---------------|
| What it is | Still accurate description of the project's purpose? |
| Features / what it does | All approved features listed? Removed features removed? |
| How to use | Instructions still match current UI/API behaviour? |
| How to deploy | Deploy instructions match `.claude/deploy.md`? |
| Version history | Latest version and release date present? |
| Privacy / data | PII handling notes current and accurate? |

## Proposal Format

```markdown
## README Update Proposal

**Last updated:** [date from README or "unknown"]
**PRDs approved since last update:** [list]

### Additions
- [Section]: Add "[proposed text]"
- [Section]: Add new section "[section name]" for [feature]

### Changes
- [Section]: Change "[current text]" → "[proposed text]"

### Removals
- [Section]: Remove "[text]" — [reason: no longer accurate]

### Version History Entry
Add: `| [version] | [date] | [one-line summary of changes] |`

Type CONFIRM to apply, or provide edits.
```

## Rules

- Advisory only — never write to README without explicit CONFIRM
- Preserve the README's existing structure and tone — don't rewrite sections that are accurate
- Use domain terminology from `docs/CONTEXT.md`
- Never add implementation details (file paths, internal function names) to README — it's user-facing
- If README structure is fundamentally outdated, propose a restructure as a separate step rather than bundling it with content updates
- Keep version history entries brief — one line per version

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No README found | "No README.md found. Create one first — a template was generated at project creation." |
| No PRD or DEVLOG to compare against | Note it. Review README against codebase directly instead. |
| README appears fully current | "README appears up to date — no changes proposed." |
