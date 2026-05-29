---
name: onboard
category: ideation
description: Bootstrap Forge onto an existing project that was not started with Forge. Explores the codebase, generates CONTEXT.md, DEVLOG.md, kanban.md, and other Forge documents from what already exists. Use when user runs /onboard or wants to adopt Forge on an in-flight project.
---

# Onboard

Adopt Forge on an existing project without starting from scratch. Explores the codebase and existing documentation to bootstrap the required Forge structure, then confirms everything with the human before writing.

## When to Use

- An existing project wants to adopt the Forge workflow
- User runs `/user:onboard`
- A project is being migrated from another workflow

## Pre-Flight

Check what already exists in the project root:
- `CLAUDE.md` — if present, Forge may already be set up. Confirm with user before proceeding.
- `docs/` — if present, check for existing documentation to preserve
- Any existing `README.md`, `REQUIREMENTS.md`, `DECISIONS.md` — these will inform the bootstrap

## Process

### Phase 1 — AFK Exploration

Runs unattended. Explore the project to understand its current state.

1. **Explore the codebase** — identify:
   - Primary language and framework
   - Project structure and key files
   - Existing tests
   - Deployment configuration

2. **Read existing documentation** — extract from any existing docs:
   - Domain terms and definitions
   - Decisions already made
   - Known issues or constraints
   - Requirements or feature lists

3. **Infer current state** — from git history if available:
   - Recent changes
   - Active branches
   - Last meaningful commit message

4. **Produce Phase 1 Summary** — present findings and ask for confirmation before writing anything:

```markdown
## Onboard Exploration Summary

### Project Detected
- Language/Framework: [detected]
- Structure: [summary]
- Tests: [present / absent]
- Deployment: [detected or unknown]

### Existing Documentation Found
- [file]: [what it contains]

### Domain Terms Extracted
- [term]: [inferred definition]

### Decisions Identified
- [decision]: [from code or docs]

### Suggested Kanban State
- In Progress: [inferred from git/code]
- Backlog: [inferred from docs/requirements]

Confirm to proceed with Forge scaffold, or provide corrections.
```

### Phase 2 — HITL Scaffold

After human confirms Phase 1 summary:

1. **Copy Forge project template files** — only files that don't already exist:
   - `CLAUDE.md` — fill in project context from Phase 1 findings
   - `docs/CONTEXT.md` — populate with extracted domain terms
   - `docs/DEVLOG.md` — create first entry: "Forge onboarded — YYYY-MM-DD"
   - `docs/kanban.md` — populate with inferred tickets from Phase 1
   - `docs/kanban-archive.md` — empty, ready for future use
   - `docs/adr/README.md`
   - `docs/prd/active/` and `docs/prd/archived/`
   - `docs/research/`, `docs/sprints/`, `docs/releases/`
   - `.claude/skills/` and `.claude/commands/`
   - `.gitignore` — add `/prototype` if not already present

2. **Migrate existing decisions** — if `DECISIONS.md` exists, convert entries to ADR format in `docs/adr/`

3. **Migrate existing requirements** — if `REQUIREMENTS.md` exists, convert to kanban tickets in `docs/kanban.md`

4. **Preserve existing files** — never overwrite `README.md` or any existing documentation

5. **Fill `CLAUDE.md`** — from Phase 1 findings:
   - Project name, type, stack, hosting, repo URL
   - Key files table
   - Version (infer from git tags or set to `v0_01`)

6. **Present final inventory** — list every file created or modified before confirming

7. **Initial git commit** — ask: "Commit the Forge scaffold? (Recommended — creates a clean rollback point)"

## Post-Onboard Prompts

```
✓ Forge onboarded onto [project name].

Recommended next steps:
1. Review docs/CONTEXT.md — add any missing domain terms
2. Review docs/kanban.md — confirm ticket state is accurate
3. Run /user:grill-with-docs to validate domain model against codebase
4. Add this project to ~/.claude/priorities.md
5. Add to sprint calendar via /user:sprint-start
```

## Rules

- Phase 1 is AFK — never write files during exploration
- Phase 2 requires human confirmation of Phase 1 summary before writing anything
- Never overwrite existing files — only create missing ones
- If `CLAUDE.md` already exists, stop and ask: "Forge appears to already be set up. Do you want to re-onboard or update the existing setup?"
- Migrated ADRs must be confirmed by human before writing — inferred decisions may be wrong
- Inferred kanban tickets are drafts — clearly labelled as such for human review

## Project ID Assignment

During Phase 2 scaffolding, assign a PROJ ID:
1. Read `~/.claude/registry.md` — get next PROJ number, increment counter
2. Add to `CLAUDE.md`:
   ```markdown
   **Project ID:** PROJ-NNN
   **Origin:** None (onboarded existing project)
   ```
3. Add to `~/.claude/registry.md` Project Registry:
   ```markdown
   | PROJ-NNN | [project name] | [repo URL] | None | Active |
   ```
