---
name: changelog
category: pi-release
description: Generate release notes from completed kanban tickets, DEVLOG entries, ADRs, and git log. Produces a user-facing release summary and a technical CHANGELOG.md entry. Natural trigger between /go-nogo approval and /deploy. Use when user runs /changelog or before deploying a release.
---

# Changelog

Generate release notes for the current release. Two outputs: a user-facing summary for
stakeholders and a technical entry for the root `CHANGELOG.md`. Synthesises from kanban,
DEVLOG, ADRs, and git log — no single source is treated as definitive.

---

## Usage

```
/changelog           ← generate for current release (reads PI plan for release ID)
/changelog PI-2-R1   ← generate for a specific release
```

---

## Phase 1 — Orient (AFK)

Read the following silently:

1. `~/.claude/pi/[current-pi]/plan.md` — identify the release name, date, and included features
2. `docs/kanban.md` — extract all tickets marked complete in this release
3. `docs/DEVLOG.md` — extract entries since the previous release date
4. `docs/adr/` — identify ADRs created or updated this sprint
5. `git log [previous-tag]..HEAD --oneline` — commits since last release tag
6. Previous entry in root `CHANGELOG.md` — establish the version baseline

If no PI plan exists, ask:
> "What is the release name and date? (e.g. PI-2-R1, 2026-06-02)"

---

## Phase 2 — Synthesise

Build two drafts from the gathered sources.

### User-facing release notes

Plain language. What changed, why it matters, who it affects. No ticket IDs, no technical
jargon. Grouped by theme (new features, improvements, fixes). Audience: stakeholders,
product, end users.

Structure:
```markdown
## [Release Name] — [Date]

### What's New
- [Feature or improvement in plain language]

### Improvements
- [Enhancement that makes something better]

### Fixes
- [Bug or issue resolved]

### Notes
- [Breaking changes, deprecations, or important callouts]
```

### Technical changelog entry

For developers. Ticket IDs, ADR references, breaking changes flagged explicitly.
Follows [Keep a Changelog](https://keepachangelog.com) format.

Structure:
```markdown
## [Version] — [Date]

### Added
- [PROJ-NNN] Feature name — brief technical description

### Changed
- [PROJ-NNN] What changed and why

### Fixed
- [PROJ-NNN] Bug fixed

### Deprecated
- [anything deprecated this release]

### Breaking Changes
- [Explicit breaking changes with migration notes]

### ADRs
- [ADR-NNN] Decision title — one-line summary
```

---

## Phase 3 — Present and Confirm (HITL)

Show both drafts side by side. Ask:

```
Here are the two changelog drafts for [Release Name].

[User-facing draft]
---
[Technical draft]

Edit either before writing? (yes to edit / no to write as-is)
```

If yes: accept edits to either or both before proceeding.

---

## Phase 4 — Write

### User-facing: `docs/releases/CHANGELOG-[release-id].md`

Write the user-facing draft as a standalone file.

### Technical: root `CHANGELOG.md`

Prepend the technical entry to `CHANGELOG.md`. If `CHANGELOG.md` does not exist,
create it with a standard header:

```markdown
# Changelog

All notable changes to this project are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com).

---
```

---

## Phase 5 — Confirm

```
✅ Changelog generated for [Release Name].

   User-facing: docs/releases/CHANGELOG-[release-id].md
   Technical:   CHANGELOG.md (prepended)

   Suggested next step: /deploy
```

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No PI plan found | Ask for release name and date manually |
| No completed tickets in kanban | Note "no tickets found" — generate from DEVLOG and git log only |
| No DEVLOG entries since last release | Note and proceed with remaining sources |
| No previous git tag found | Use full git log, note that previous tag was not found |
| `docs/releases/` missing | Create it before writing |

---

## Rules

- Always present both drafts for confirmation before writing — never write silently
- User-facing notes must be plain language — no ticket IDs or technical terms
- Technical entry must follow Keep a Changelog format
- Never overwrite a previous release's changelog file — always write a new dated file
- The technical CHANGELOG.md prepend must not delete existing entries
