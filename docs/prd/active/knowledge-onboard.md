# PRD: Knowledge Onboard

**Date:** 2026-05-23
**Status:** Active
**Sprint:** Not sprint-tracked (Forge framework build)
**PI:** Not PI-tracked
**Target Release:** Standalone
**Author:** Forge

**Stakeholder Label:** Company Knowledge Setup
**Delivery Type:** Fixed Scope
**Priority:** P2 High
**Due Date (Internal):** None
**Due Date (External):** None
**Estimate (AI Token Cost):** M (20–80k)
**Estimate (Story Points):** 16pts
**Estimate Status:** Current
**Last estimated:** 2026-05-23

---

## Problem Statement

When a developer installs Forge at a new employer, the knowledge layer (`~/.claude/knowledge/`) is empty. Forge has no understanding of company terminology, brand standards, systems, or APIs. The developer must manually run `/add-system`, `/summarise-system`, and `/add-term` for each piece of knowledge — with no guidance on sequence, no multi-source ingestion routing, and no coverage of brand style or API contracts. The cold-start friction is high and coverage is inconsistent.

Additionally, the current system knowledge structure (`overview.md`, `schema.md`, `known-issues.md`) has no slot for API knowledge. Endpoint contracts, authentication patterns, and request/response shapes have nowhere to live.

---

## Solution

Three things built in sequence:

1. **Common templates** — `style-guide.md` (company brand standards) and `api.md` (system API contracts) added as first-class knowledge artefacts
2. **Extended skills** — `/add-system`, `/summarise-system`, `/write-article`, `/write-prd`, and `/knowledge-health` updated to include the new slots
3. **New skills** — `/knowledge-onboard` (guided end-to-end company setup) and `/style-check` (brand compliance review)

When complete, a developer onboarding to a new employer runs `/knowledge-onboard` once and is walked through the full setup in order, feeding source material in any format — Confluence URLs, SharePoint pastes, PDFs, Word docs, or verbal description.

---

## User Stories

1. As a developer onboarding to a new employer, I want a single guided skill that walks me through company knowledge setup in the right sequence, so that Forge is context-aware before project work begins.
2. As a developer, I want to feed source material in any format (Confluence URL, file path, manual paste, verbal description), so that I don't need to manually transcribe documents.
3. As a developer, I want the AI to consult my company's written style guide when producing documents and PRDs, so that outputs reflect company brand standards.
4. As a developer, I want a `/style-check` skill that reviews any deliverable against the style guide, so that off-brand content is caught before sharing.
5. As a developer, I want each system's knowledge folder to include an `api.md` file, so that API endpoint knowledge is captured alongside schemas and overviews.
6. As a developer, I want `/knowledge-health` to flag missing `api.md` files and a missing `style-guide.md`, so that knowledge gaps surface automatically during sprint start.
7. As a developer, I want `/add-system` to scaffold `api.md` automatically alongside the existing three files, so that the structure is complete from the start.

---

## Implementation Decisions

- **Sequence in `/knowledge-onboard`:** style-guide.md → acronyms → company domain terms → core systems (overview → schema → api → known-issues per system). Each stage is HITL-gated before the next begins.
- **Multi-source routing:** `/knowledge-onboard` and the extended `/summarise-system` detect source type at each step — URL (Confluence), file path (PDF/Word), or paste (SharePoint, other). The AI cannot access auth-gated URLs; paste is the fallback for SharePoint.
- **`style-guide.md` location:** `~/.claude/knowledge/company/style-guide.md` — global, applies across all projects.
- **`api.md` location:** `~/.claude/knowledge/systems/[name]/api.md` — per-system, alongside existing files.
- **Style guide consumption:** `/write-article` and `/write-prd` read `style-guide.md` if present — soft dependency, both skills degrade gracefully if the file is absent.
- **`/style-check` severity model:** mirrors `/pii-check` — CRITICAL (violates mandatory brand standard), HIGH (strong brand preference), LOW (suggestion).
- **`/knowledge-health` additions:** checks for `api.md` in every system folder; checks for `style-guide.md` presence; reports both as P1 structural health findings if missing.
- **Estimate (16pts / M band):** all modules are markdown skill files — token cost is driven by skill complexity, not deployment infrastructure.

---

## Task List

### HITL Tasks

- [ ] [HITL] #1 Review and confirm `style-guide.md` template structure before writing
- [ ] [HITL] #2 Review and confirm `api.md` template structure before writing
- [ ] [HITL] #3 Review and confirm `/knowledge-onboard` SKILL.md draft before finalising
- [ ] [HITL] #4 Review and confirm `/style-check` SKILL.md draft before finalising
- [ ] [HITL] #5 Confirm manifest, commands reference, and CHANGELOG updates before push

### AFK Tasks

- [ ] [AFK] #6 Create `~/.claude/knowledge/company/style-guide.md` template `blocked-by: #1`
- [ ] [AFK] #7 Create `~/.claude/knowledge/systems/[name]/api.md` template `blocked-by: #2`
- [ ] [AFK] #8 Write `/knowledge-onboard` SKILL.md and command file `blocked-by: #3`
- [ ] [AFK] #9 Write `/style-check` SKILL.md and command file `blocked-by: #4`
- [ ] [AFK] #10 Extend `/add-system` — scaffold `api.md` alongside existing three files `blocked-by: #7`
- [ ] [AFK] #11 Extend `/summarise-system` — add API ingestion path and multi-source routing `blocked-by: #7`
- [ ] [AFK] #12 Extend `/write-article` — consult `style-guide.md` when present `blocked-by: #6`
- [ ] [AFK] #13 Extend `/write-prd` — consult `style-guide.md` when present `blocked-by: #6`
- [ ] [AFK] #14 Extend `/knowledge-health` — check `api.md` coverage and `style-guide.md` presence `blocked-by: #6, #7`
- [ ] [AFK] #15 Update `manifest.json`, `commands/SKILL.md`, and `CHANGELOG.md` `blocked-by: #5`
- [ ] [AFK] #16 Sync changes to `~/forge/global/.claude/` and commit `blocked-by: #15`

---

## Testing Decisions

- Test `/knowledge-onboard` with each source type in isolation: URL, file path, paste, verbal
- Test `/style-check` with a deliberately off-brand document — verify CRITICAL and HIGH findings are surfaced
- Test `/add-system` — confirm `api.md` is scaffolded alongside the existing three files
- Test `/knowledge-health` with a system folder missing `api.md` — confirm P1 finding is raised
- Test `/write-article` with and without `style-guide.md` present — confirm graceful degradation
- No automated test infrastructure — all tests are manual review of AI output quality

---

## Definition of Done

- [ ] All 16 tasks marked complete
- [ ] All HITL tasks signed off
- [ ] `/knowledge-onboard` walks through full sequence without errors on a clean `~/.claude/knowledge/`
- [ ] `/style-check` surfaces at least one finding on a test document
- [ ] `/add-system` scaffolds 4 files (not 3)
- [ ] `/knowledge-health` flags missing `api.md` and `style-guide.md`
- [ ] `manifest.json` version bumped, CHANGELOG updated
- [ ] Changes pushed to GitHub (with confirmation gate before push)
- [ ] `/approve` issued after QA

---

## Out of Scope

- Coding style guides (covered by `lang-rules` + `CODING-STANDARDS.md`)
- SharePoint MCP connector or authenticated Confluence access (external dependency)
- Populating actual company content — skills scaffold and guide; content is the user's responsibility
- Project-level `CONTEXT.md` management (covered by `/update-context`)
- Multi-client isolation (single employer confirmed in scope)

---

## Further Notes

- Grill session conducted 2026-05-23 — all scope decisions documented in that conversation
- Build sequence recommendation: templates first (#6, #7) → extensions (#10–14) → new skills (#8, #9) → wiring (#15, #16)
- `/knowledge-onboard` is the capstone — build it last so all the files it orchestrates already exist
