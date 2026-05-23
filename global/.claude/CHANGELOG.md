# Forge Changelog

Version history for the Forge framework. Update when bumping `forge_version` in `manifest.json`.

## Conventions

- Update this file whenever a skill is added, changed, or removed
- Update `~/.claude/forge-sequence.mmd` when the pipeline sections change — new phases added, phase order changed, or major skills added to the lifecycle flow. Not required for every version bump — only when the diagram would be materially wrong without an update.
- Use `/write-a-skill` checklist item as the trigger — it now includes a `CHANGELOG.md` update step
- Version format: `MAJOR.MINOR.PATCH` — major for lifecycle changes, minor for new skills, patch for skill fixes

---

## v2.5.5 — 2026-05-23

**New skill: /lang-rules + common coding rules layer + rules/README enrichment**

### Added
- `/lang-rules` — install and activate language-specific coding rule sets for the current project. Detects languages from project files, copies matching rule sets from `~/.claude/rules/<lang>/` into `.claude/rules/`, and writes `.claude/rules/active.md` so `/review`, `/build`, and `/push-standards` know which baselines apply. HITL gate before writing. Adapted from Affaan Mustafa (ECC / github.com/affaan-m/ECC) via /assimilate.
- `~/.claude/rules/common/coding-style.md` — universal baseline: immutability, KISS/DRY/YAGNI, file/function size limits (800-line cap, 50-line function cap, 4-level nesting cap), error handling, input validation, naming conventions.
- `~/.claude/rules/common/quality-checklist.md` — pre-ship checklist covering code quality, testing, security, and CI integration. Referenced by `/review` and `/qa-plan`.
- `~/.claude/rules/common/research-first.md` — search-before-writing rule: codebase → package registry → GitHub → docs → web. Explicit never rules.
- `~/.claude/rules/common/security.md` — pre-commit security checklist and escalation triggers for `/security-review`.
- `~/.claude/rules/README.md` — documents the layered rules architecture and how skills consume it.

### Changed
- `/push-standards` — now reads `.claude/rules/active.md` before exploring the codebase. Uses installed language rules as the baseline; only documents patterns that extend beyond what global rules already define.
- `~/.claude/rules/README.md` — added "Rules vs Skills" distinction (rules = what to meet; skills = how to do it) and "Scaffold a new language" file spec with required opening line format. Adapted from Affaan Mustafa (ECC / github.com/affaan-m/ECC).
- `/lang-rules` — added scaffolding spec: exact file set for a new language directory (`coding-style.md`, `testing.md`, `patterns.md`, `hooks.md`, `security.md`) and required `> This file extends...` opening line convention.

---

## v2.5.4 — 2026-05-22

**New skill: /write-article**

### Added
- `/write-article` — write long-form content in a concrete, human voice. Covers Confluence pages, README, stakeholder summaries, Go/No Go briefs, research outputs, and release notes. Core rules: lead with concrete thing, use proof over adjectives, banned patterns list (AI filler), format guidance per document type, quality gate checklist. Adapted from Affaan Mustafa (ECC / github.com/affaan-m/ECC) via /assimilate.

---

## v2.5.3 — 2026-05-22

**New skill: /assimilate**

### Added
- `/assimilate` — adapt external ideas into Forge with proper attribution. Phase 1 (AFK) fetches source and evaluates fit (what maps, what adds value, what doesn't apply). Phase 2 (HITL) adapts with Forge conventions and writes the skill. Mandatory `origin:` frontmatter field and body credit. Checks against PRINCIPLES.md for conflicts. Attribution standard: "Adapted from [Author] ([Source] / [URL])".

### Changed
- `/write-a-skill` checklist — note added: if adapting from an external source, use `/assimilate` instead

---

## v2.5.2 — 2026-05-22

**New skill: /ai-first-engineering**

### Added
- `/ai-first-engineering` — operating model for AI-assisted delivery teams. Five core process shifts, agent-friendly architecture requirements, AI-first code review focus (behaviour/security/integrity over syntax), testing standards for generated code, anti-patterns, and Forge pipeline alignment table showing which phase embodies which principle. Adapted from ECC (github.com/affaan-m/ECC) by Affaan Mustafa.

### Changed
- `PRINCIPLES.md` — reference to `/ai-first-engineering` added as Further Reading

---

## v2.5.1 — 2026-05-22

**New skill: /accessibility**

### Added
- `/accessibility` — WCAG 2.2 Level AA compliance skill. Covers Web (ARIA/HTML5), iOS (SwiftUI), and Android (Compose). Implementation steps (POUR), cross-platform attribute mapping, code examples, anti-patterns, and a QA checklist for /qa-plan integration. Adapted from ECC (github.com/affaan-m/ECC) by Affaan Mustafa.

### Changed
- `/qa-plan` — rules updated: for any feature with a UI component, the accessibility QA checklist from /accessibility is included in the plan

---

## v2.5.0 — 2026-05-22

**Continuous learning — instincts system. Inspired by ECC.**

### Added
- `/learn` — capture a session pattern as a Forge instinct. Accepts inline description, asks one behaviour question, checks for duplicates, increments observation count if match found. Low/Medium/High confidence based on observation count (1/3+/5+). Human override to High available.
- `/evolve` — review High confidence instincts and promote to formal skills. PROMOTE/DEFER/RETIRE per instinct. Never auto-promotes. Shows Medium instincts approaching High.
- `~/.claude/instincts/registry.md` — instinct counter and index with confidence scores
- `~/.claude/instincts/_template.md` — instinct file template
- `~/.claude/SOUL.md` — agent-facing identity document (core principles, behavioural rules, what the agent is not)

### Changed
- `/debrief` — instinct prompt added at session end: "Did anything this session produce a pattern worth capturing?"
- `/handoff` — instinct prompt added at handoff

### Inspired by
ECC (github.com/affaan-m/ECC) continuous-learning-v2 pattern: instinct-based learning with confidence scoring and cluster promotion.

---

## v2.4.0 — 2026-05-22

**Knowledge base health checking and research promotion.**

### Added
- `/knowledge-health` — read-only diagnostic across all knowledge layers. Coverage scorecard with change tracking. P1 structural health (stale files, missing fields, unresolved ambiguities, undocumented systems, undefined terms). P2 cross-reference findings (Do Not Attempt conflicts with active PRDs, cross-system risk patterns). P3 interesting connections (promotion candidates, new article suggestions, knowledge gaps). Saves to `~/.claude/knowledge/health-report.md`. Suggested at sprint-start if last check > 30 days ago.
- `preferences.md` — `knowledge-health-last-run` field added

### Changed
- `/research` — knowledge base promotion step added at session end: asks whether findings should be promoted to system knowledge, company terms, or company context
- `/commands` — `/knowledge-health` added to Knowledge Base section

### Inspired by
LLM knowledge base pattern: raw data → compiled wiki → health checks → connections surfaced. Applied to Forge's knowledge layer: research files → knowledge base → `/knowledge-health` → promotion via `/research`.

---

## v2.3.7 — 2026-05-21

**New skill: /add-term**

### Added
- `/add-term` — lightweight company-level glossary maintenance. Acronyms → `acronyms.md`, domain concepts → `context.md`. Minimum definition captured immediately, marked `_Needs enrichment_` for later. Conflict detection against existing entries. Optional inline argument. Offers to also add to project `docs/CONTEXT.md` after writing.
- `~/.claude/knowledge/company/context.md` — new company-level domain concept file (companion to `acronyms.md`)

---

## v2.3.6 — 2026-05-21

**Documentation cleanup and design principles.**

### Added
- `~/.claude/PRINCIPLES.md` — 8 Forge design principles: AI executes/human decides, negative space programming, HITL/AFK explicit, smart zone thinking, structure as default, reference don't duplicate, estimates as signals, every decision recorded. Referenced in `/write-a-skill` checklist.

### Changed
- `/commands` — `push-standards` description updated to reference `CODING-STANDARDS.md`
- `push-standards` command file — updated to reference `CODING-STANDARDS.md`
- `/handoff` — description clarified: use for passing work to another agent/person vs `/debrief` for thorough session close
- `/debrief` — description and intro updated with `/handoff` vs `/debrief` distinction
- `/write-a-skill` — checklist now requires reading `PRINCIPLES.md` before finalising
- `README.md` — skill count updated to 50, command count to 51; `PRINCIPLES.md` added to global structure; skill/command counts in global structure updated
- Attribution standardised across handoff skill, grill-with-docs skill, and Confluence page: "Matt Pocock (AIHero.dev / github.com/mattpocock/skills)"
- Confluence page — attribution and Further Reading updated

---

## v2.3.5 — 2026-05-21

**New skill: /handoff**

### Added
- `/handoff` — compact the current session into a structured handoff for the next agent or human. References Forge artifacts by path rather than reproducing content. Suggests which skills the next session should use based on pipeline position. Optional argument: next session focus. Optional `--archive` flag saves a timestamped copy to `docs/handoffs/`. Adapted from AIHero.dev / Matt Pocock's handoff skill.

---

## v2.3.4 — 2026-05-21

**Project-level known issues tracking.**

### Added
- `docs/known-issues.md` — project template file for tracking Active, Deferred, and Resolved issues, plus Known Limitations. Entries use `KI-NNN` sequential IDs.
- `KI-NNN` counter added to `docs/tests/registry.md`

### Changed
- `/qa-plan` — reads `docs/known-issues.md` before generating checklist; "Known Issues to Verify" section added to QA plan output with KI-NNN references
- `/standup` — surfaces active known issues count in daily brief
- `/go-nogo` — reads `docs/known-issues.md` for each project; Active issues included in brief; Critical active issues can block Go/No Go
- `/sprint-start` — surfaces High/Critical active known issues and asks whether any should be scheduled as sprint tickets
- `CLAUDE.md` — `docs/known-issues.md` added to key files table
- `INSTALL.md` — `docs/known-issues.md` listed in project scaffold

---

## v2.3.3 — 2026-05-21

**Post-split cleanup and documentation.**

### Changed
- `/push-standards` — now appends to `CODING-STANDARDS.md` "Project-Specific Patterns" section instead of a separate `STANDARDS.md`. Forge defaults never modified. Single file, two sources.
- `CODING-STANDARDS.md` — "Project-Specific Patterns" placeholder section added at bottom
- `CLAUDE.md` — on-demand table note added: "agent loads these automatically — no manual action needed"
- `TESTING.md` — "Diagnose Before Fixing" section removed (duplicate of CLAUDE.md — single source of truth)
- `README.md` — global file structure updated with `tokens/ledger.md` and `registry.md`; key concepts table updated with correct buffer window, ID types, and `/lookup`
- `registry-README.md` — new file explaining the ID registry, how IDs work, lookup usage, conflict resolution
- Reference files — Forge version comment added to top of each (CODING-STANDARDS, ERROR-HANDLING, SECURITY, TESTING)

---

## v2.3.2 — 2026-05-21

**CLAUDE.md split — 427 lines → 186 lines.**

### Added
- `.claude/CODING-STANDARDS.md` — pre-change protocol, layer tags, rollback policy, dependency awareness, versioning rules, advisory discipline, what good looks like
- `.claude/ERROR-HANDLING.md` — error infrastructure, display rules, iOS Safari notes, silent failure discipline, logging standards, common bug patterns
- `.claude/SECURITY.md` — security checkpoints, PII awareness, credential rules
- `.claude/TESTING.md` — test scenarios, platform/compatibility checklist, TDD discipline, test coverage rules, diagnose rule

### Changed
- `CLAUDE.md` — rewritten to ~186 lines (session instructions only). On-demand reference table added pointing to 4 extracted files. All extracted content removed from main file.
- `INSTALL.md` — reference files listed in project scaffold; `docs/tests/registry.md` added to docs listing

---

## v2.3.1 — 2026-05-21

**ID system fixes.**

### Changed
- `~/.claude/registry.md` — conflict resolution rule added (never reuse, skip on conflict)
- `/lookup` — ID assignment conflict rule added; stale path recovery: searches for moved files, offers registry update
- `docs/tests/registry.md` — TC status lifecycle documented (Defined → Implemented → Passing | Failing | Waived | Skipped)
- `/qa-plan` — TC-NNN IDs carried from testplan into QA checklist and results table; status values aligned with TC registry
- `CLAUDE.md` project template — `← set automatically by /create-project or /onboard` comments added to ID fields

---

## v2.3.0 — 2026-05-21

**Unique entity IDs across ideas, projects, and test cases.**

### Added
- `~/.claude/registry.md` — global ID registry for IDEA-NNN and PROJ-NNN counters, cross-reference links
- `docs/tests/registry.md` — per-project TC-NNN counter and test case index (project template)
- `/lookup` skill — find any entity by ID (IDEA-NNN, PROJ-NNN, TC-NNN), returns summary + file path

### Changed
- `/idea` — assigns IDEA-NNN at pitch time, adds to `idea.md` header and global registry
- `/create-project` — assigns PROJ-NNN, adds to `CLAUDE.md`, updates cross-references in `idea.md` and registry
- `/onboard` — assigns PROJ-NNN for existing projects, adds to `CLAUDE.md` and registry
- `/testplan` — assigns TC-NNN per test case when testplan is confirmed, updates `docs/tests/registry.md`; testplan format updated with TC column and range in header
- `idea.md` template — `**ID:** IDEA-NNN` and `**Project:** PROJ-NNN` fields added
- `CLAUDE.md` project template — `**Project ID:** PROJ-NNN` and `**Origin:** IDEA-NNN` fields added

### ID conventions
- `IDEA-NNN` — assigned at `/idea` start, global counter
- `PROJ-NNN` — assigned at `/create-project` or `/onboard`, global counter
- `TC-NNN` — assigned when testplan is confirmed, project-wide counter
- Bidirectional cross-references: idea.md ↔ CLAUDE.md ↔ registry.md

---

## v2.2.3 — 2026-05-21

**Documentation cleanup.**

### Changed
- `README.md` — removed `/update-readme` duplicate from QA category; version history updated through v2.2.2; token tracking category corrected
- `INSTALL.md` — hardcoded skill/command counts replaced with "see manifest.json" reference
- `forge-sequence.mmd` — token recording note added at bottom
- `~/.claude/tokens/README.md` — new file explaining the global ledger, how to read it, reporting, data quality, and correction procedure

---

## v2.2.2 — 2026-05-21

**Token recording housekeeping and documentation.**

### Changed
- `docs/tokens/template.md` → renamed to `_template.md` (underscore prefix distinguishes template from data files)
- `INSTALL.md` — global install listing replaced with full directory tree including `~/.claude/tokens/ledger.md`; `_template.md` referenced correctly
- `TOKEN-RECORDING.md` — feature name derivation convention added ("PRD filename without .md, lowercase, hyphens"); multi-PI feature handling documented; manual correction procedure documented
- `README.md` — skill count updated to 48; token tracking category added; planning category updated with `/grill-with-docs` first and `/estimate` included

---

## v2.2.1 — 2026-05-21

**Token recording completeness fixes.**

### Changed
- `/research`, `/prototype`, `/testplan`, `/estimate`, `/deploy` — token recording steps added (5 missing phases now complete — all 11 phases recorded)
- `INSTALL.md` — `docs/tokens/` folder listed with description
- `HANDOFF.md` template — "Current phase: [name] — Session N of this phase" field added; example comment updated
- `CLAUDE.md` — session start now increments phase session counter in token record when same phase continues
- `/approve` — token rollup failure mode added (missing token file doesn't block approval); ledger summary recalculated from all entries (not just incremented) to prevent drift
- `/token-report` calibration report — in-progress features can be included with ⚠️ partial label

---

## v2.2.0 — 2026-05-21

**Token recording and program-level reporting.**

### Added
- `/token-report` — program-level token usage analysis by feature, sprint, PI, or calibration. Reads from per-project token files and global ledger.
- `~/.claude/tokens/ledger.md` — global cross-project token ledger, updated at `/approve`
- `docs/tokens/template.md` — per-feature token record template (project template)
- `~/.claude/skills/token-report/TOKEN-RECORDING.md` — estimation guide and phase recording format reference

### Changed
- `/idea` — records token usage after decision gate
- `/grill-with-docs` — records token usage at session end
- `/write-prd` — records token usage after Phase 2
- `/build` — records token usage at completion with per-ticket breakdown
- `/qa-plan` — records token usage after QA phases complete
- `/approve` — rolls up feature token record to `~/.claude/tokens/ledger.md` at feature close
- `/standup` — shows current feature token spend line
- `/sprint-end` — shows sprint token total line
- `/pi-end` — shows PI token total line, suggests `/token-report`

### Token recording approach
- AFK automatic at phase end — agent estimates, not exact counts
- Input tokens: based on files loaded, estimated by type and size
- Output tokens: based on content generated
- Both separately recorded, band derived from combined total
- Session count tracked per phase

---

## v2.1.3 — 2026-05-21

**Richer domain modelling in /grill-with-docs.**

### Added
- `grill-with-docs/ADR-FORMAT.md` — full guide: minimal ADR template, "when to create" rules, what qualifies, Forge-specific notes
- `grill-with-docs/CONTEXT-FORMAT.md` — full guide: Avoid aliases, example dialogue, flagged ambiguities, single vs multi-context repos, Forge-specific notes

### Changed
- `/grill-with-docs` SKILL.md (v2.0.0) — references new format files, adopts Avoid aliases in term updates, adds Flagged Ambiguities and Example Dialogue guidance, lighter ADR format (1-3 sentences), multi-context repo support, richer Shared Understanding Summary
- `docs/CONTEXT.md` project template — updated to richer format with Avoid aliases, Relationships, Example Dialogue, Flagged Ambiguities sections
- `docs/adr/README.md` project template — updated to lighter ADR format with correct template

---

## v2.1.2 — 2026-05-21

**Commands reference cleanup and convention clarifications.**

### Changed
- `/commands` — `/grill-with-docs` now listed first in Pipeline as planning phase entry point; `/grill-me` labelled "Ad-hoc stress-test only"
- `/grill-me` — description and intro updated to clarify ad-hoc use; directs project planning to `/grill-with-docs`
- `forge-sequence.mmd` — planning phase updated to `/grill-with-docs`; deploy day updated to Monday
- `QUICKSTART.md` — essential commands table annotated: `create-project` labelled "after idea accepted", `/grill-with-docs` vs `/grill-me` distinction added
- `README.md` — pipeline block updated to show `/grill-with-docs`
- `preferences.md` — buffer window clarified: Friday EOD is last working day for feature tickets
- `CLAUDE.md` — buffer window clarified in core concepts
- `/build` — buffer window check updated to Friday–Sunday language with Friday EOD callout

---

## v2.1.1 — 2026-05-21

**Convention updates — deployment day and planning phase.**

### Changed
- Release day: Sunday → **Monday** (3rd Monday of each month)
- Sprint start day: Sunday → **Tuesday**
- Buffer window: Thursday → **Friday–Sunday** before release Monday
- Go/No Go cutoff: unchanged — Friday 5pm
- Planning phase pipeline: `/grill-me` → **`/grill-with-docs`** — uses domain model and codebase context
- Updated: `preferences.md`, `/piplan`, `/sprintplan`, `/go-nogo`, `CLAUDE.md`, `INSTALL.md`, `QUICKSTART.md`, PI plan template

---

## v2.1.0 — 2026-05-21

**Token and complexity estimation across the full planning pipeline.**

### Added
- `/estimate` — on-demand token cost band (S/M/L/XL) and story point (1/2/3/5/8/13) estimation. Table-based, human confirms in aggregate. XL flags `/break-down` requirement.
- `/save-state` — emergency state save: HANDOFF.md → kanban.md → DEVLOG in priority order. Manual or auto-triggered on context exhaustion.
- `QUICKSTART.md` — 5-minute path from idea to first feature

### Changed
- `/idea` — feature-level estimate generated before decision gate, added to `idea.md`
- `/write-prd` — per-module estimates generated in Phase 2, added to PRD header and Implementation Decisions. PRD header now includes `Estimate (AI Token Cost)`, `Estimate (Story Points)`, `Estimate Status`, `Last estimated`
- `/sprint-start` — sprint capacity check against `preferences.md` limits (story points + token budget). XL tickets flagged. Warning not block.
- `/build` — actuals tracked per ticket. Estimated vs actual band recorded in `kanban-archive.md`. Over-band actuals flagged ⚠️
- `/scope-check` — stale estimate detection. Marks PRD estimate as Stale when scope changes, prompts `/estimate`
- `preferences.md` — `sprint-capacity-points` and `sprint-capacity-tokens` fields added
- `kanban.md` template — `S|M|L|XL | Npts` and `XL ⚠️` tags added
- `kanban-archive.md` template — `estimated: M | actual: L` actuals format added
- `CLAUDE.md` — stale estimate detection instruction, context exhaustion protocol
- `CHANGELOG.md` — conventions section added with version bump guidance and diagram update trigger
- `README.md` — CHANGELOG and QUICKSTART referenced

---

## v2.0.0 — 2026-05-21

**Full lifecycle — idea to production.**

### Added
- `/build` — executes sprint AFK tickets in sequence with TDD, buffer window check, context checkpoints, lightweight PII scan
- `/deploy` — staged or direct deployment with Go/No Go gate, health check, rollback validation, deploy log
- `/deploy-pi` — full PI release in configured sequence, per-project status tracking, partial success handling
- `/rollback` — emergency project rollback with mandatory reason, diagnose handoff, deploy log entry
- `/rollback-pi` — full PI rollback in reverse deploy order, stops on failure, PI plan reflects exact state
- `/piplan` — PI creation with auto-derived release dates, Go/No Go gates, buffer windows
- `/pi-end` — formal PI closure with delivery summary, retrospective, stakeholder view
- `/go-nogo` — release gate with AI-prepared brief, GO/NO-GO human decision, NO-GO next step suggestions
- `/standalone-release` — urgent deploy outside monthly cycle, deploy log integration
- `/sprint-replan` — mid-sprint injection with absorb/swap options
- `/pi-replan` — mid-PI scope change with Fixed Deadline risk check and two-gate confirmation
- `/pii-check` — AFK codebase scan + HITL review, Necessary vs Incidental classification, living report
- `/tdd` — red-green-refactor with deep-modules, interface-design, mocking, refactoring reference files
- `/testplan` — testing strategy design before implementation
- `/idea` — structured idea capture with grill, diagrams, impact/effort, ACCEPT/DECLINE/HOLD
- `/create-project` — progress accepted idea to git repo with Forge scaffold
- `/onboard` — bootstrap Forge onto existing project
- `/backlog-list`, `/backlog-proj`, `/backlog-add` — backlog management with priority grouping
- `/critic` — honest prioritised critique across correctness, completeness, consistency, risk
- `/update-readme` — diff-style README proposal against PRD and DEVLOG
- `/write-adr` — explicit ADR creation skill
- `docs/HANDOFF.md` — always-overwritten session handoff, read at session start
- `.claude/deploy.md` — per-project deployment config with build-check, environment variable section
- `docs/releases/deploy-log.md` — deployment audit log with archiving convention
- `~/.claude/priorities.md` — cross-project feature priority list
- `~/.claude/backlog.md` — framework-level backlog with priority grouping
- `~/.claude/forge-sequence.mmd` — framework sequence diagram

### Changed
- `CLAUDE.md` — session start now reads `HANDOFF.md` first, staleness warning for knowledge files, session end writes `HANDOFF.md`
- `/approve` — PII gate added, HANDOFF reset on feature close, README update suggestion, fixed step numbering
- `/write-prd` — two-phase AFK explore + HITL write, Sprint and PI fields in PRD template
- `/sprint-end` — kanban archiving to `kanban-archive.md`, HANDOFF update
- `/debrief` — HANDOFF update added as step 2
- `/standup` — reads priorities, flags deadline risk, Go/No Go proximity, auto scope-check for Fixed Deadline features
- `manifest.json` — `forge_version` field added

### Removed
- Nothing removed — all v1.0.0 skills retained

---

## v1.0.0 — 2026-05-20

**Initial release — planning pipeline and sprint management.**

### Skills
`/grill-me`, `/grill-with-docs`, `/research`, `/prototype`, `/write-prd`, `/diagnose`, `/approve`, `/standup`, `/debrief`, `/scope-check`, `/write-adr`, `/break-down`, `/qa-plan`, `/review`, `/push-standards`, `/add-system`, `/summarise-system`, `/update-context`, `/sprint-start`, `/sprint-end`, `/piplan`, `/sprintplan`, `/write-a-skill`, `/commands`
