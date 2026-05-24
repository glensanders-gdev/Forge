---
name: add-system
description: Scaffold a new system knowledge folder with Raw/Wiki/Outputs tiers and stub files inside ~/.claude/knowledge/systems/. Use when user wants to add a system, runs /add-system, or mentions adding a new system to the knowledge base.
---

# Add System

Scaffold the full three-tier knowledge structure for a new system under `~/.claude/knowledge/systems/`.

## Process

1. **Get the system name** — if not provided, ask. Convert to lowercase with hyphens (e.g. "Salesforce CRM" → `salesforce-crm`).
2. **Confirm the folder path** — state the full path before creating anything:
   `~/.claude/knowledge/systems/[system-name]/`
3. **Create the folder structure and files** — use the templates below, replacing `[System Name]` with the provided name.
4. **Confirm completion** — list the files created and remind the user to:
   - Fill in `Wiki/overview.md` first
   - Run `/ingest` after dropping source material into `Raw/`
   - Add the system to the relevant project's `CLAUDE.md` Knowledge References table

## Folder Structure to Create

```
~/.claude/knowledge/systems/[system-name]/
  Raw/
    _compiled.log
  Wiki/
    _index.md
    _changelog.md
    overview.md
    schema.md
    known-issues.md
  Outputs/
```

## Raw/_compiled.log

```
# Compiled Log — [System Name]
# Format: YYYY-MM-DD | filename | compiled | articles updated
#          YYYY-MM-DD | filename | failed   | reason
```

## Wiki/_index.md

```markdown
# [System Name] — Wiki Index

## Recently Updated
| Date | Article | Summary |
|------|---------|---------|
| | | |

## Overview
- [Overview](overview.md) — what the system is and what AI can/can't do
- [Schema](schema.md) — data structures and field definitions
- [Known Issues](known-issues.md) — constraints, limitations, hard stops
```

## Wiki/_changelog.md

```markdown
# Wiki Changelog — [System Name]

| Date | Type | Article | Notes |
|------|------|---------|-------|
| | | | |
```

## Wiki/overview.md

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

## Wiki/schema.md

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

## Wiki/known-issues.md

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
| [System Name] | `~/.claude/knowledge/systems/[system-name]/Wiki/overview.md` |
|               | `~/.claude/knowledge/systems/[system-name]/Wiki/known-issues.md` |
```
