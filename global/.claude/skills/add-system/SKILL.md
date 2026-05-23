---
name: add-system
description: Scaffold a new system knowledge folder with blank overview, schema, and known-issues files inside ~/.claude/knowledge/systems/. Use when user wants to add a system, runs /add-system, or mentions adding a new system to the knowledge base.
---

# Add System

Create the standard three-file knowledge structure for a new system under `~/.claude/knowledge/systems/`.

## Process

1. **Get the system name** — if not provided, ask. Convert to lowercase with hyphens (e.g. "Salesforce CRM" → `salesforce-crm`).
2. **Confirm the folder path** — state the full path before creating anything:
   `~/.claude/knowledge/systems/[system-name]/`
3. **Create the three files** — use the templates below, replacing `[System Name]` with the provided name.
4. **Confirm completion** — list the files created and remind the user to:
   - Fill in `overview.md` first
   - Add the system to the relevant project's `CLAUDE.md` Knowledge References table

## Files to Create

```
~/.claude/knowledge/systems/[system-name]/
  overview.md
  schema.md
  known-issues.md
```

## overview.md

```markdown
# System Overview: [System Name]

**Last updated:** YYYY-MM-DD
**Owner / Contact:**

---

## What This System Is



---

## How It Works



---

## Data Sources

| Source | What It Provides | How It's Used |
|--------|-----------------|---------------|
| | | |

---

## What an AI Can Do Here

-

---

## What an AI Cannot Do Here

-

---

## Intended Use

-

---

## Key Contacts / Escalation

| Role | Name / Team |
|------|------------|
| System Owner | |
| Technical Contact | |
| Escalation | |
```

## schema.md

```markdown
# Schema: [System Name]

**Last updated:** YYYY-MM-DD

---

## Core Objects / Tables

### [Object Name]

**Purpose:**

| Field | Type | Description |
|-------|------|-------------|
| | | |

---

## Relationships

---

## Field Conventions

| Convention | Example | Meaning |
|------------|---------|---------|
| | | |

---

## Data Quality Notes

-
```

## known-issues.md

```markdown
# Known Issues: [System Name]

**Last updated:** YYYY-MM-DD

Before proposing any solution involving this system, check this file.
If the proposed approach conflicts with an entry here, flag it before proceeding.

---

## Do Not Attempt

-

---

## Limitations

-

---

## Known Bugs / Quirks

| Issue | Behaviour | Workaround |
|-------|-----------|------------|
| | | |

---

## Workarounds

---

## Deferred Issues

| Issue | Reason Deferred | Revisit |
|-------|----------------|---------|
| | | |
```

## After Creating Files

Remind the user to add the system to their project's `CLAUDE.md` Knowledge References table:

```markdown
| [System Name] | `~/.claude/knowledge/systems/[system-name]/overview.md` |
|               | `~/.claude/knowledge/systems/[system-name]/known-issues.md` |
```
