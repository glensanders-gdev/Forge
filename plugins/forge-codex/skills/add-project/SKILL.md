---
name: "add-project"
description: "Scaffold a new project knowledge folder with Raw/Wiki/Outputs tiers and stub files inside ~/.codex/forge/knowledge/projects/. Use when user wants to add a project to the knowledge base, runs $add-project, or starts a new project that needs a knowledge presence alongside its docs/ directory."
metadata:
  category: knowledge
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Add Project

> **Company-aware:** When `active_company` is set in `~/.codex/forge/preferences.md` (configured by `$company-add`), projects are scaffolded under `~/.codex/forge/companies/[active_company]/knowledge/projects/` instead of `~/.codex/forge/knowledge/projects/`.

Scaffold the full three-tier knowledge structure for a new project under `~/.codex/forge/knowledge/projects/`.

Note: this is distinct from a project's `docs/` directory. `docs/` holds session state
(handoffs, devlogs, kanban). `knowledge/projects/[name]/` holds compiled, durable domain
knowledge about the project — concepts, decisions, research, and outputs worth preserving
beyond any single session.

## Process

1. **Get the project name** — if not provided, ask. Convert to lowercase with hyphens (e.g. "Customer Portal" → `customer-portal`).
2. **Confirm the folder path** — state the full path before creating anything:
   `~/.codex/forge/knowledge/projects/[project-name]/`
3. **Create the folder structure and files** — use the templates below, replacing `[Project Name]` with the provided name.
4. **Confirm completion** — list the files created and remind the user to:
   - Fill in `Wiki/overview.md` first
   - Run `$ingest` after dropping source material into `Raw/`
   - Add a reference in the project's `AGENTS.md` Knowledge References table

## Folder Structure to Create

```
~/.codex/forge/knowledge/projects/[project-name]/
  Raw/
    _compiled.log
  Wiki/
    _index.md
    _changelog.md
    overview.md
    decisions.md
    known-issues.md
    customer-feedback.md
    stakeholder-feedback.md
  Outputs/
```

## Raw/_compiled.log

```
# Compiled Log — [Project Name]
# Format: YYYY-MM-DD | filename | compiled | articles updated
#          YYYY-MM-DD | filename | failed   | reason
```

## Wiki/_index.md

```markdown
# [Project Name] — Wiki Index

## Recently Updated
| Date | Article | Summary |
|------|---------|---------|
| | | |

## Overview
- [Overview](overview.md) — what the project is and its current state
- [Decisions](decisions.md) — key decisions and their rationale
- [Known Issues](known-issues.md) — constraints, blockers, hard stops

## Feedback
- [Customer Feedback](customer-feedback.md) — distilled pain points, requests, and sentiment (read before proposing user-facing changes)
- [Stakeholder Feedback](stakeholder-feedback.md) — requirements, constraints, and open asks from stakeholders (read before designing solutions)
```

## Wiki/_changelog.md

```markdown
# Wiki Changelog — [Project Name]

| Date | Type | Article | Notes |
|------|------|---------|-------|
| | | | |
```

## Wiki/overview.md

```markdown
# Project Overview: [Project Name]

**Last updated:** YYYY-MM-DD
**Status:**
**Owner / Contact:**
**Forge ID:** (assign via $create-project)

external_ids:
  jira: (populated by $link-jira — omit until linked)

---

## What This Project Is



---

## Goals



---

## Systems Involved

| System | Role | Knowledge Ref |
|--------|------|---------------|
| | | |

---

## What an AI Can Do Here

-

---

## What an AI Cannot Do Here

-

---

## Key Contacts

| Role | Name / Team |
|------|------------|
| Project Owner | |
| Technical Lead | |
```

## Wiki/decisions.md

```markdown
# Decisions: [Project Name]

**Last updated:** YYYY-MM-DD

Key decisions made during this project. For hard-to-reverse architectural decisions,
use $write-adr to create a full ADR in docs/adr/.

---

| Date | Decision | Rationale | Made By |
|------|----------|-----------|---------|
| | | | |
```

## Wiki/known-issues.md

```markdown
# Known Issues: [Project Name]

**Last updated:** YYYY-MM-DD

Before proposing any solution involving this project, check this file.
If the proposed approach conflicts with an entry here, flag it before proceeding.

---

## Do Not Attempt

-

---

## Blockers

-

---

## Constraints

-

---

## Deferred Issues

| Issue | Reason Deferred | Revisit |
|-------|----------------|---------|
| | | |
```

## Wiki/customer-feedback.md

```markdown
# Customer Feedback: [Project Name]

**Last updated:** YYYY-MM-DD

Distilled from raw feedback (emails, surveys, support tickets, user interviews) in `Raw/`.
Read this file before proposing any user-facing changes to this project.

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
# Stakeholder Feedback: [Project Name]

**Last updated:** YYYY-MM-DD

Distilled from stakeholder communications (position papers, memos, emails, meeting notes) in `Raw/`.
Read this file before designing solutions or making commitments about this project.

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

## Related

- `$knowledge-health` — audits the **Three-Tier Knowledge Structure** (Raw/Wiki/Outputs) created here
- `$add-system` — sister skill for adding system-level (not project-level) knowledge
- `$add-term` — adds entries to the company glossary referenced from project Wiki files
- `$update-context` — updates an existing project's context after `$add-project` scaffolded it

## After Creating Files

Remind the user to add the project to their project's `AGENTS.md` Knowledge References table:

```markdown
| [Project Name] | `~/.codex/forge/knowledge/projects/[project-name]/Wiki/overview.md` |
|                | `~/.codex/forge/knowledge/projects/[project-name]/Wiki/known-issues.md` |
```
