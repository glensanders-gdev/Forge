---
name: raid
category: delivery
description: Manage a RAID log (Risks, Actions, Issues, Decisions) for a project, system, or process. Supports add, update, close, status, and init sub-commands. Use when the user runs /raid or wants to capture a risk, action, issue, or decision.
---

# RAID

Manage a RAID log for a project, system, or process. Each domain gets its own `docs/raid/` folder with an index and one file per quadrant.

---

## Usage

```
/raid init                    ← scaffold docs/raid/ for the current context
/raid add risk                ← add a new risk entry
/raid add action              ← add a new action entry
/raid add issue               ← add a new issue entry
/raid add decision            ← add a new decision entry
/raid update R-001            ← update an existing entry by ID
/raid close R-001             ← mark an entry closed and archive it
/raid status                  ← print open entry counts per quadrant
```

---

## Context Resolution

Before any operation, resolve which RAID log to use:

1. Read the current working directory.
2. Look for `docs/raid/RAID.md` in or below the current directory.
3. If found, use it. If ambiguous (multiple matches), list them and ask the user to confirm which context they mean.
4. If not found and the command is not `init`, offer to run `/raid init` first.

---

## `/raid init`

Scaffold `docs/raid/` for the current context (project, system, or process).

1. Confirm the path with the user before creating anything:
   ```
   This will create docs/raid/ at: [resolved path]
   Type CONFIRM to proceed.
   ```
2. Create the folder and files using the templates below.
3. Confirm completion and list files created.

**Called automatically by:** `/create-project`, `/add-system`, and any future `/add-process` skill.

### Folder Structure

```
docs/raid/
  RAID.md
  RISKS.md
  RISKS_ARCHIVE.md
  ACTIONS.md
  ACTIONS_ARCHIVE.md
  ISSUES.md
  ISSUES_ARCHIVE.md
  DECISIONS.md
  DECISIONS_ARCHIVE.md
```

### RAID.md (index)

```markdown
# RAID Log

**Context:** [project / system / process name]
**Last updated:** YYYY-MM-DD

## Summary

| Quadrant  | Open | In Progress | Closed (archived) |
|-----------|------|-------------|-------------------|
| Risks     | 0    | 0           | 0                 |
| Actions   | 0    | 0           | 0                 |
| Issues    | 0    | 0           | 0                 |
| Decisions | 0    | 0           | 0                 |

## Files

- [Risks](RISKS.md) · [Archive](RISKS_ARCHIVE.md)
- [Actions](ACTIONS.md) · [Archive](ACTIONS_ARCHIVE.md)
- [Issues](ISSUES.md) · [Archive](ISSUES_ARCHIVE.md)
- [Decisions](DECISIONS.md) · [Archive](DECISIONS_ARCHIVE.md)
```

### RISKS.md

```markdown
# Risks

| ID | Title | Description | Probability | Impact | Owner | Status | Source | Raised | Updated | Links |
|----|-------|-------------|-------------|--------|-------|--------|--------|--------|---------|-------|
```

### RISKS_ARCHIVE.md

```markdown
# Risks — Archive

| ID | Title | Description | Probability | Impact | Owner | Source | Raised | Closed | Links |
|----|-------|-------------|-------------|--------|-------|--------|--------|--------|-------|
```

### ACTIONS.md

```markdown
# Actions

| ID | Title | Description | Owner | Status | Source | Raised | Updated | Links |
|----|-------|-------------|-------|--------|--------|--------|---------|-------|
```

### ACTIONS_ARCHIVE.md

```markdown
# Actions — Archive

| ID | Title | Description | Owner | Source | Raised | Closed | Links |
|----|-------|-------------|-------|--------|--------|--------|-------|
```

### ISSUES.md

```markdown
# Issues

| ID | Title | Description | Owner | Status | Source | Raised | Updated | Links |
|----|-------|-------------|-------|--------|--------|--------|---------|-------|
```

### ISSUES_ARCHIVE.md

```markdown
# Issues — Archive

| ID | Title | Description | Owner | Source | Raised | Closed | Links |
|----|-------|-------------|-------|--------|--------|--------|-------|
```

### DECISIONS.md

```markdown
# Decisions

| ID | Title | Description | Owner | Status | Source | Raised | Updated | Links |
|----|-------|-------------|-------|--------|--------|--------|---------|-------|
```

### DECISIONS_ARCHIVE.md

```markdown
# Decisions — Archive

| ID | Title | Description | Owner | Source | Raised | Closed | Links |
|----|-------|-------------|-------|--------|--------|--------|-------|
```

---

## Entry Schema

All quadrants share this base schema:

| Field | Notes |
|-------|-------|
| `ID` | Quadrant-prefixed sequential ID: `R-001`, `A-001`, `I-001`, `D-001` |
| `Title` | One-line summary |
| `Description` | Detail, impact, or context |
| `Owner` | Person or role responsible |
| `Status` | `Open` / `In Progress` / `Closed` |
| `Source` | Structured reference — see Source Prefixes below |
| `Raised` | Date added (YYYY-MM-DD) |
| `Updated` | Date last changed (YYYY-MM-DD) |
| `Links` | Optional cross-refs: other RAID IDs, ADR filenames, ticket IDs, or `[context] ID` for cross-context links |

**Risks additionally have:**
- `Probability` — `High` / `Medium` / `Low`
- `Impact` — `High` / `Medium` / `Low`

**Decisions additionally support:**
- `Links` — include ADR filename if a `/write-adr` entry exists (e.g. `ADR-003`)

### Source Prefixes

| Prefix | Meaning | Example |
|--------|---------|---------|
| `TC-NNN` | Ticket | `TC-042` |
| `SPRINT-N` | Sprint event | `SPRINT-3` |
| `PI-N` | PI planning | `PI-4` |
| `GONOGO-PI-N-RN` | Go/No Go gate | `GONOGO-PI-4-R2` |
| `GATE-NNN` | Front gate submission | `GATE-001` |
| `INCIDENT-NNN` | Incident record | `INCIDENT-003` |
| `IDEA-NNN` | Idea record | `IDEA-007` |
| `GRILL-YYYY-MM-DD` | Grill session | `GRILL-2026-06-01` |
| `MANUAL` | Entered directly | `MANUAL` |

---

## `/raid add [quadrant]`

Collect entry details interactively, one field at a time.

1. Assign the next sequential ID by reading the quadrant file (count existing rows).
2. Ask for each required field. Provide a prompt and an example for each.
3. For Risks: also ask Probability and Impact.
4. For Decisions: ask if an ADR exists and should be linked.
5. Append the new row to the quadrant file.
6. Update the `RAID.md` index summary (increment Open count).
7. Confirm:
   ```
   ✓ R-004 added to RISKS.md
   ```

---

## `/raid update [ID]`

Update an existing entry.

1. Resolve quadrant from the ID prefix (`R-` → RISKS, `A-` → ACTIONS, `I-` → ISSUES, `D-` → DECISIONS).
2. Read the current row and display it.
3. Ask: "Which field(s) do you want to update?"
4. Apply changes and set `Updated` to today's date.
5. Confirm the updated row.

---

## `/raid close [ID]`

Mark an entry closed and move it to the archive in one step.

1. Resolve quadrant from ID prefix.
2. Read the current row from the live file.
3. Confirm:
   ```
   Closing R-003 — [title]. Move to RISKS_ARCHIVE.md? (yes/no)
   ```
4. On confirmation:
   - Remove the row from the live file.
   - Append to the archive file (replace `Updated` column with `Closed`, set value to today's date).
   - Update `RAID.md` index: decrement Open/In Progress count, increment Closed count.
5. Confirm:
   ```
   ✓ R-003 closed and archived.
   ```

---

## `/raid status`

Print the current index summary from `RAID.md`.

```
## RAID Status — [context name]

| Quadrant  | Open | In Progress |
|-----------|------|-------------|
| Risks     | 2    | 1           |
| Actions   | 4    | 2           |
| Issues    | 1    | 0           |
| Decisions | 3    | 0           |

Run /raid add [risk|action|issue|decision] to log a new entry.
Run /raid close [ID] to archive a resolved entry.
```

---

## Integration Points

### `/go-nogo`

Before assembling the Go/No Go brief, read `docs/raid/RISKS.md` for the active project:
- Surface any `Open` or `In Progress` risks with `Impact: High` as blockers.
- Include in the brief under a **Open High Risks** section.
- A High Impact + High Probability risk with status `Open` is a soft block — note it and ask for explicit acknowledgment before recording GO.

### `/sprint-start`

After pulling carry-in from the previous sprint, read `docs/raid/ACTIONS.md`:
- List `Open` and `In Progress` actions.
- Ask: "These RAID actions are open — should any become sprint tickets?"
- Do not add automatically — human confirms.

### `/sprint-end`

After writing the sprint-end record, prompt:
- "Review open RAID entries for this sprint. Any risks mitigated, actions completed, or issues resolved?"
- For each confirmed resolution, offer to run `/raid close [ID]`.

### `/write-adr`

After writing an ADR, ask:
- "Should this decision be logged in the RAID log? (yes/no)"
- If yes, run `/raid add decision` pre-populated with the ADR title and filename in Links.

### `/incident`

After declaring an incident (`/incident declare`), create a linked RAID issue:
- Run `/raid add issue` pre-populated with the incident ID in Source (e.g. `INCIDENT-001`) and title from the incident record.

### `/approve`

Before recording approval, read `docs/raid/RISKS.md`:
- Flag any `Open` risks with `Impact: High` — surface them in the approval gate summary.
- These are advisory, not hard blocks, unless the approve skill is configured otherwise.

### `/idea`

When an idea is accepted or progressed to a project:
- Ask: "Log this as a decision in the RAID log? (yes/no)"
- If yes, run `/raid add decision` pre-populated with the idea name and `IDEA-NNN` in Source.

### `/front-gate`

After producing a Request Brief:
- If the brief surfaces risks or constraints (from system knowledge or stakeholder constraints), ask:
  "Log these as RAID risks? (yes/no / select)"
- Pre-populate each selected risk with Source `GATE-NNN`.

---

## Cross-Context Linking

Entries may link to RAID entries in other contexts via the Links field using the convention:

```
[context-path] ID
```

Example: `systems/auth R-005` in the Links column of `projects/my-app/docs/raid/RISKS.md`.

No enforcement — convention only in v1.

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| `docs/raid/` not found | Offer to run `/raid init`. Do not proceed without it. |
| ID not found in quadrant file | List known IDs in that file. Suggest `/raid status`. |
| Quadrant file missing (after init) | Recreate it from template with a warning. |
| Ambiguous context (multiple RAID logs found) | List all found paths. Ask user to confirm which to use. |
| Archive file missing | Create it from template before archiving the entry. |

---

## Rules

- Never create files without explicit CONFIRM from the user (except during auto-init from another skill).
- Never auto-close entries — always confirm before archiving.
- IDs are immutable once assigned — never renumber or reuse a closed ID.
- The index (`RAID.md`) must be updated every time an entry is added, updated, or closed.
- Cross-context links are convention only — do not attempt to resolve or validate them.
