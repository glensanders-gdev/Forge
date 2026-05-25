---
name: add-project
description: Scaffold a new project knowledge folder with Raw/Wiki/Outputs tiers and stub files inside ~/.claude/knowledge/projects/. Use when user wants to add a project to the knowledge base, runs /add-project, or starts a new project that needs a knowledge presence alongside its docs/ directory.
---

# Add Project

> **Company-aware:** When `active_company` is set in `~/.claude/preferences.md` (configured by `/company-add`), projects are scaffolded under `~/.claude/companies/[active_company]/knowledge/projects/` instead of `~/.claude/knowledge/projects/`.

Scaffold the full three-tier knowledge structure for a new project under `~/.claude/knowledge/projects/`.

Note: this is distinct from a project's `docs/` directory. `docs/` holds session state
(handoffs, devlogs, kanban). `knowledge/projects/[name]/` holds compiled, durable domain
knowledge about the project — concepts, decisions, research, and outputs worth preserving
beyond any single session.

## Process

1. **Get the project name** — if not provided, ask. Convert to lowercase with hyphens (e.g. "Customer Portal" → `customer-portal`).
2. **Confirm the folder path** — state the full path before creating anything:
   `~/.claude/knowledge/projects/[project-name]/`
3. **Create the folder structure and files** — use the templates below, replacing `[Project Name]` with the provided name.
4. **Confirm completion** — list the files created and remind the user to:
   - Fill in `Wiki/overview.md` first
   - Run `/ingest` after dropping source material into `Raw/`
   - Add a reference in the project's `CLAUDE.md` Knowledge References table

## Folder Structure to Create

```
~/.claude/knowledge/projects/[project-name]/
  Raw/
    _compiled.log
  Wiki/
    _index.md
    _changelog.md
    overview.md
    decisions.md
    known-issues.md
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
**Forge ID:** (assign via /create-project)

external_ids:
  jira: (populated by /link-jira — omit until linked)

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
use /write-adr to create a full ADR in docs/adr/.

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

## After Creating Files

Remind the user to add the project to their project's `CLAUDE.md` Knowledge References table:

```markdown
| [Project Name] | `~/.claude/knowledge/projects/[project-name]/Wiki/overview.md` |
|                | `~/.claude/knowledge/projects/[project-name]/Wiki/known-issues.md` |
```
