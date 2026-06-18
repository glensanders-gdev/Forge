---
name: "add-system"
description: "Scaffold a new system knowledge folder with Raw/Wiki/Outputs tiers and stub files inside ~/.codex/forge/knowledge/systems/. Use when user wants to add a system, runs $add-system, or mentions adding a new system to the knowledge base."
metadata:
  category: knowledge
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Add System

> **Company-aware:** When `active_company` is set in `~/.codex/forge/preferences.md` (configured by `$company-add`), systems are scaffolded under `~/.codex/forge/companies/[active_company]/knowledge/systems/` instead of `~/.codex/forge/knowledge/systems/`.

Scaffold the full three-tier knowledge structure for a new system under `~/.codex/forge/knowledge/systems/`.

## Process

1. **Get the system name** — if not provided, ask. Convert to lowercase with hyphens (e.g. "Salesforce CRM" → `salesforce-crm`).
2. **Confirm the folder path** — state the full path before creating anything:
   `~/.codex/forge/knowledge/systems/[system-name]/`
3. **Create the folder structure and files** — use the templates below, replacing `[System Name]` with the provided name.
4. **Scaffold RAID log** — run `$raid init` to create `docs/raid/` within the system folder (no separate CONFIRM needed — it follows from the system creation CONFIRM).
5. **Confirm completion** — list the files created and remind the user to:
   - Fill in `Wiki/overview.md` first
   - Run `$ingest` after dropping source material into `Raw/`
   - Add the system to the relevant project's `AGENTS.md` Knowledge References table

## Folder Structure to Create

```
~/.codex/forge/knowledge/systems/[system-name]/
  Raw/
    _compiled.log
  Wiki/
    _index.md
    _changelog.md
    overview.md
    schema.md
    known-issues.md
    customer-feedback.md
    stakeholder-feedback.md
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

## Feedback
- [Customer Feedback](customer-feedback.md) — distilled pain points, requests, and sentiment (read before proposing user-facing changes)
- [Stakeholder Feedback](stakeholder-feedback.md) — requirements, constraints, and open asks from stakeholders (read before designing solutions)
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

## Wiki/customer-feedback.md

```markdown
# Customer Feedback: [System Name]

**Last updated:** YYYY-MM-DD

Distilled from raw feedback (emails, surveys, support tickets, user interviews) in `Raw/`.
Read this file before proposing any user-facing changes to this system.

---

## Key Pain Points

| Theme | Frequency | Severity | Source |
|-------|-----------|----------|--------|
| | | | |

---

## Feature Requests

| Request | Count | Priority |
|---------|-------|----------|
| | | |

---

## What's Working Well

-

---

## Sentiment Summary

**Overall:** [Positive / Mixed / Negative]
**Last assessed:** YYYY-MM-DD
**Source count:** N items compiled
```

---

## Wiki/stakeholder-feedback.md

```markdown
# Stakeholder Feedback: [System Name]

**Last updated:** YYYY-MM-DD

Distilled from stakeholder communications (position papers, memos, emails, meeting notes) in `Raw/`.
Read this file before designing solutions or making commitments about this system.

---

## Requirements & Expectations

| Stakeholder | Requirement | Priority | Status |
|-------------|-------------|----------|--------|
| | | | |

---

## Constraints Imposed

| Constraint | Source | Non-negotiable? |
|-----------|--------|----------------|
| | | |

---

## Open Asks / Pending Decisions

| Ask | Stakeholder | Due | Status |
|-----|-------------|-----|--------|
| | | | |

---

## Key Concerns Raised

-
```

---

## After Creating Files

Remind the user to add the system to their project's `AGENTS.md` Knowledge References table:

```markdown
| [System Name] | `~/.codex/forge/knowledge/systems/[system-name]/Wiki/overview.md` |
|               | `~/.codex/forge/knowledge/systems/[system-name]/Wiki/known-issues.md` |
```

## Rules

- Never overwrite an existing system knowledge folder — if `[system-name]/` already exists, stop and ask.
- Confirm the full folder path before creating anything.
- Scaffold stubs only — never fabricate system content; the user fills `overview.md` and `schema.md`.
- When `active_company` is set, scaffold under the company knowledge path, not the personal one.

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| `[system-name]/` already exists | Stop and ask before touching it — never overwrite an existing knowledge folder. |
| System name not provided | Ask for it; normalise to lowercase-hyphenated before creating. |
| `active_company` is set | Scaffold under `~/.codex/forge/companies/[active_company]/knowledge/systems/` instead. |
| Tempted to pre-fill schema or domain content | Scaffold stubs only — the user fills them and runs `$ingest`. |
| `$raid init` fails or `docs/raid/` already exists | Note it and continue — don't block system creation on the RAID scaffold. |
