# Forge Changelog

Version history for the Forge framework. Update when bumping `forge_version` in `manifest.json`.

## Conventions

- Update this file whenever a skill is added, changed, or removed
- Update `~/.claude/forge-sequence.mmd` (installed single-file) and `docs/diagrams/framework-complete.mmd` + the relevant `docs/diagrams/phase-NN-*.mmd` file when the pipeline changes — new phases added, phase order changed, or major skills added to the lifecycle flow. Not required for every version bump — only when the diagram would be materially wrong without an update.
- Use `/write-a-skill` checklist item as the trigger — it now includes a `CHANGELOG.md` update step
- Version format: `MAJOR.MINOR.PATCH` — major for lifecycle changes, minor for new skills, patch for skill fixes

---

## v3.8.2 — 2026-06-06

**New skill: /vibe-security**

### Added
- `/vibe-security` v1.0.0 — active security auditor for AI-generated codebases. Produces severity-ranked findings (Critical → High → Medium → Low) with before/after fixes. Loads technology-specific reference files on demand (Supabase RLS, Stripe, mobile, AI/LLM, deployment, data access). Activates proactively when writing or reviewing auth, payment, database, or API key code. Compatible with both Claude Code (`/vibe-security`) and OpenAI Codex (`$vibe-security`).
- 9 reference files covering: secrets & env vars, database security, authentication, rate limiting, payments, mobile, AI/LLM integration, deployment, and data access.
- `agents/openai.yaml` for Codex compatibility.
- Adapted from [Chris Raroque / Aloa](https://github.com/raroque/vibe-security-skill) — MIT licensed.

---

## v3.7.1 — 2026-06-01

**Critic fixes — correctness, completeness, consistency**

### Fixed
- `/forge-install` v2.0.1 — scenario detection script now uses PowerShell ReparsePoint check for Windows junctions; `[ -L ]` alone returns false for NTFS junctions and would misidentify an already-linked machine as needing migration
- `forge-sequence.mmd` — added `/qa-report` step to Phase 6 pipeline (was missing since v3.6.0); fixed `qa-plan.md` filename reference to `qa-plan-[feature].md`
- `/build` v1.1.0 — testplan pre-flight check upgraded from passive read to active warning gate; prompts to run `/testplan` first if no testplan file found
- `/qa-report` v1.1.0 — added step 0: identify active feature from `docs/prd/active/` and validate report filename matches; confirms save path before writing
- `/write-a-skill` v1.1.0 — "After Writing Files" now requires manifest version bump on skill updates and CHANGELOG entry; frozen version numbers explicitly called out as an error
- `manifest.json` — corrected stale versions: `context-health` 1.0.0→1.1.0, `write-prd` 1.0.0→1.1.0, `write-article` 1.0.0→1.1.0, `knowledge-health` 1.0.0→1.1.0

---

## v3.7.0 — 2026-06-01

**Junction-based sync — install.sh, /forge-install, /forge-update rewritten**

### Changed
- `install.sh` v2.0.0 — rewritten to create junctions (Windows: `mklink /J`) and symlinks (Mac/Linux: `ln -s`) for `skills/`, `commands/`, `rules/` dirs and 4 loose framework files (`CHANGELOG.md`, `PRINCIPLES.md`, `SOUL.md`, `forge-sequence.mmd`). Removes copy and backup steps entirely. Idempotent — skips already-linked targets. User-owned dirs (`knowledge/`, `instincts/`, `tokens/`, etc.) are never touched. Platform auto-detected via `$OSTYPE`/`uname`.
- `/forge-install` v2.0.0 — auto-detects scenario: fresh install, legacy migration, already linked (no-op), re-link, or iOS. Migration flow moves repo from any detected location (incl. `OneDrive/Forge`) to `~/forge`, then runs `install.sh`. iOS branch provides PR-only contributor guidance. HITL confirmation required before any file system changes.
- `/forge-update` v2.0.0 — simplified to `git pull` + version check + CHANGELOG display. Drops `update.sh` dependency entirely. Checks junctions are in place before pulling; redirects to `/forge-install` if not. Updates `forge-version` stamp preserving original `installed:` date.
- `update.sh` — deprecated with notice at top of file. Retained for backwards compatibility with legacy copy-based installs. Not called by any skill or `install.sh` going forward.

---

## v3.6.0 — 2026-06-01

**New skill: /qa-report — QA execution evidence artefact**

### Added
- `/qa-report` v1.0.0 — formalises QA session results into a datestamped evidence artefact at `docs/tests/results/[feature]-YYYY-MM-DD.md`. Prompts for structured evidence (CI run link, automated test output file, screenshot folder), records pass/fail/waived per TC-NNN item, computes a summary verdict, and sets an approve gate status. Pipeline: `/testplan` → `/tdd` → `/qa-plan` → *human tests* → `/qa-report` → `/approve`.

### Changed
- `/approve` v1.1.0 — QA report hard-block gate added as step 2 (before PII check). Hard-stops if no `docs/tests/results/[feature]-*.md` exists, or if the report's approve gate status is `Blocked` (unresolved P1 failures). All subsequent steps renumbered (3–14). Two new Failure Mode rows added.
- `/qa-plan` v1.1.0 — output renamed from `docs/qa-plan.md` to `docs/qa-plan-[feature-name].md` for naming consistency with `/testplan`. Closing prompt updated to direct user to `/qa-report` before `/approve`.

---

## v3.5.0 — 2026-05-29

**New skills: /forge-init, /forge-update + /ingest scope prompt + /context-health Intent Layer + category fields**

### Added
- `/forge-init` v1.0.0 — generates `~/.claude/CLAUDE.md` and `~/.claude/AGENTS.md` from a single source of truth. Writes skill-loading instruction and standing instructions (git safety, push confirmation, HITL gates, context limit) for Claude Code. Overlays company config (ai_human_signoff_required, ai_data_restrictions, ai_monthly_spend_cap_usd) when `active_company` is set. Called automatically by `/company-add` as its final write step; runnable standalone after config changes or Forge upgrades. `compatibility: codex: unsupported` (writes to `~/.claude/` which is Claude Code's directory).
- `/forge-update` v1.0.0 — self-update skill for Forge. Ensures `~/forge` clone exists, pulls latest, version-checks current vs incoming, surfaces the CHANGELOG section for the new version, confirms before running `update.sh`. Warns to start a new session after install.

### Changed
- `/company-add` v1.3.0 — runs `/forge-init` silently as its final write step, regenerating `~/.claude/CLAUDE.md` with company config overlays applied immediately after setup
- `/ingest` v1.2.0 — structured scope prompt replaces open-ended "which Raw/ folder?" question for all three modes. Reads active projects from `registry.md`, presents a numbered list, pre-highlights any project matching the current working directory, falls back silently to global when no projects registered. Frontmatter description corrected to reflect actual scope behaviour.
- `/context-health` v1.1.0 — Intent Layer child node recommendations added (adapted from Railly Hugo / Crafter Station, Tyler Brandt's Intent Layer framework). Phase 1 now scans first-level source directories (`src/`, `app/`, `lib/`, `packages/`, `services/`, `api/`, `components/`), flags subdirectories exceeding 20k tokens without an `AGENTS.md`, and adds a Child Node Recommendations section to the report with an inline `AGENTS.md` template. 3 new failure modes, 4 new rules.

### Housekeeping
- `category:` frontmatter field added to all 94 skill `SKILL.md` files — aligns with the README skill table groupings: `pipeline`, `ideation`, `session`, `code-quality`, `knowledge`, `metrics`, `pi-release`, `sprint`, `maintenance`, `company`, `framework`

---

## v3.4.0 — 2026-05-28

**Front-gate Phase 5 decision gate + sequence diagram documentation + install.sh auto-pull**

### Changed
- `/front-gate` v1.1.0 — Phase 5 revised from AFK write to HITL submission decision gate:
  - Option 1: **Submit to Jira** — saves brief with `status: pending-jira` to `docs/requests/YYYY-MM-DD-[slug].md`; flagged for company Jira integration to pick up
  - Option 2: **Save as draft** — saves brief with `status: draft` to `docs/requests/YYYY-MM-DD-[slug].md`
  - Option 3: **Discard** — exits without writing anything to disk
  - Rule added: nothing is written to disk until a Phase 5 selection is made — Phase 4 approval alone is not sufficient
  - FORMATS.md updated: YAML frontmatter added to Request Brief template (`status: draft | pending-jira`); `status` field rule added
  - Phase 4 cancel intent clarified: use when the brief itself is wrong; Discard in Phase 5 for a change of mind after approval
  - Failure mode added: re-prompt on invalid Phase 5 input
- `~/.claude/forge-sequence.mmd` — rewritten to 12-phase pipeline; Phase 0 (/front-gate) added; all phases numbered; company, framework, and new skills added to bottom notes

### Added
- `docs/diagrams/` — 13 Mermaid sequence diagrams added to the repo: individual phase diagrams for Phases 0–11 plus `framework-complete.mmd` (full pipeline). Render at [mermaid.live](https://mermaid.live) or any Mermaid-compatible tool.

### Fixed
- `install.sh` — auto-pulls latest from GitHub before installing when run inside a git clone; re-reads `forge_version` after pull so the installer banner shows the updated version; correct usage comments added

---

## v3.3.0 — 2026-05-28

**New skill: /front-gate**

### Added
- `/front-gate` v1.0.0 — structured intake for non-technical users submitting an idea or request for team consideration. Middle ground between `/grill-me` (no doc context) and `/grill-with-docs` (full codebase). Grills the requestor one question at a time using plain language and example answers. Checks `knowledge/systems/` for constraints on any mentioned systems and surfaces conflicts inline before continuing. Produces a Request Brief saved to `docs/requests/YYYY-MM-DD-[slug].md`.
  - Phase 1 [AFK]: interpret — restates idea in plain language, confirms with requestor, reads knowledge base for mentioned systems (silent)
  - Phase 2 [HITL]: grill — 7 questions one at a time: Problem Statement, Objective, Metrics (optional — baseline + goal), What Is Needed, Risk of Doing Nothing, Negative Impacts, Brief Summary
  - Phase 3 [AFK]: compile answers into Request Brief using `FORMATS.md` template
  - Phase 4 [HITL]: review gate — "yes / edit / cancel" before writing to disk
  - Phase 5 [AFK]: write to `docs/requests/YYYY-MM-DD-[slug].md`, confirm with next-step suggestions *(revised to HITL decision gate in v3.4.0 — see above)*
  - Integration: `/idea`, `/grill-with-docs`, `/write-prd`, `/ingest`, `knowledge/systems/*/Wiki/`

---

## v3.2.0 — 2026-05-28

**New skill: /caveman (assimilated from Matt Pocock / AIHero.dev)**

### Added
- `/caveman` v1.0.0 — behavioral toggle that strips articles, filler, pleasantries, and hedging from AI responses to reduce output token usage by ~75%. Technical accuracy fully preserved. State persisted in `preferences.md` (`caveman-mode: on/off`). Safety exception auto-pauses for all HITL gate confirmations and destructive action prompts. Deactivate with `/caveman --off` or "normal mode".
  - Origin: Adapted from Matt Pocock (AIHero.dev / github.com/mattpocock/skills)

---

## v3.1.0 — 2026-05-28

**New skill: /seo (assimilated from Affaan Mustafa / ECC)**

### Added
- `/seo` v1.0.0 — SEO audit and remediation planning. Reads source files directly (no external crawl tool required), ranks findings by severity, and produces a dated report to `docs/seo/`.
  - Phase 1 [AFK]: orient scope — reads `CLAUDE.md`, locates `robots.txt`, `sitemap.xml`, and HTML template layer; prompts for scope if no flag passed
  - Phase 2 [AFK]: audit against three-tier taxonomy — Critical (crawlability: robots, canonicals, redirects, broken sitemaps), High (on-page: titles, metas, headings, JSON-LD, Core Web Vitals), Medium (content: thin pages, alt text, orphans, cannibalization)
  - Phase 3 [HITL]: presents ranked findings, confirms which severity tiers to address before creating any tickets
  - Phase 4 [AFK]: writes `docs/seo/audit-YYYY-MM-DD.md` using `FORMATS.md` template; assigns `SEO-YYYYMMDD-NNN` IDs
  - Phase 5 [HITL]: optional kanban ticket creation for confirmed findings — detail stays in report, kanban holds ID + one-liner only
  - Flags: `--audit`, `--page <path>`, `--schema`, `--vitals`, `--content`, `--analyze-only`
  - Integration: `/review` (template changes), `/build` (remediation tickets), `/qa-plan`, `/go-nogo`
  - Origin: Adapted from Affaan Mustafa (ECC / github.com/affaan-m/ECC)

---

## v3.0.0 — 2026-05-28

**New skill: /test-coverage (assimilated from Affaan Mustafa / ECC)**

### Added
- `/test-coverage` v1.0.0 — reactive coverage gap remediation for existing codebases. Distinct from `/tdd` (proactive, test-first): this skill analyzes what's already written and closes the gaps.
  - Phase 1 [AFK]: detect framework via `tools/global.md` `test-runner` category, fall back to file-based detection (jest, vitest, pytest, cargo, maven/jacoco, go)
  - Phase 2 [AFK]: run coverage command, capture output
  - Phase 3 [AFK]: rank files below threshold worst-first; identify untested functions, missing branches, dead code
  - Phase 4 [HITL]: show gap analysis, confirm which files to address before writing anything
  - Phase 5 [AFK]: generate missing tests (happy path → error handling → edge cases → branch coverage); assigns TC IDs via `docs/tests/registry.md`; matches existing project test style
  - Phase 6 [AFK]: verify full test suite passes; re-run coverage
  - Phase 7 [AFK]: before/after comparison table; updates `preferences.md` for `/go-nogo` integration
  - Flags: `--analyze-only`, `--file <path>`, `--threshold <N>`
  - Threshold: reads from `CLAUDE.md`; defaults to 80% (quality-checklist.md standard)
  - Origin: Adapted from Affaan Mustafa (ECC / github.com/affaan-m/ECC)

### Version note
Bumped to v3.0.0 — four skills added in one session (git-guardrails, jira, skill-health, test-coverage) completes a significant capability expansion.

---

## v2.9.0 — 2026-05-28

**New skill: /skill-health (assimilated from Affaan Mustafa / ECC)**

### Added
- `/skill-health` v1.0.0 — read-only structural audit of the Forge skill portfolio. Checks every manifest.json entry for: SKILL.md directory, command stub, required sections (Failure Modes, Rules), frontmatter completeness, CHANGELOG coverage for version bumps, and attribution credit lines in assimilated skills. Saves report to `~/.claude/knowledge/skill-health-report.md`.
  - 🔴 Critical: manifest orphans (no SKILL.md), missing frontmatter
  - ⚠️ Amber: missing sections, missing command stubs, CHANGELOG drift, attribution gaps
  - ℹ️ Info: directory orphans, orphaned command stubs, version mismatches
  - Flags: `--critical`, `--skill <name>`
  - Sprint-start integration: warns if overdue (>30 days)
  - Completes the Forge health triad: context-health (tokens) + knowledge-health (articles) + skill-health (skills)
  - Concept adapted from Affaan Mustafa (ECC / github.com/affaan-m/ECC); Forge-native implementation — no runtime telemetry or Node.js scripts required

---

## v2.8.0 — 2026-05-28

**New skill: /jira (assimilated from Affaan Mustafa / ECC)**

### Added
- `/jira` v1.0.0 — live Jira API integration with four subcommands:
  - `get <TICKET-KEY>` [AFK] — fetch ticket and produce structured analysis: requirements, acceptance criteria, test scenarios (happy/error/edge), dependencies, and recommended next steps
  - `comment <TICKET-KEY>` [HITL] — gather session progress from DEVLOG + kanban, preview comment, post on confirmation
  - `transition <TICKET-KEY>` [HITL] — fetch available transitions, present options, execute on selection; offers to sync `docs/kanban.md`
  - `search <JQL>` [AFK] — run JQL query and return a summary table (max 20 results)
  - `setup` [HITL] — guided credential configuration: MCP server (preferred) or env vars
  - Auth: MCP server → env vars fallback; never stores credentials in source files
  - Complements `/link-jira` (static ID mapping) with live API interaction
  - Origin: Adapted from Affaan Mustafa (ECC / github.com/affaan-m/ECC)

---

## v2.7.0 — 2026-05-28

**New skill: /git-guardrails (assimilated from Matt Pocock)**

### Added
- `/git-guardrails` v1.0.0 — hard-blocks dangerous git commands via a `PreToolUse` hook, enforced at the Claude Code tool level rather than the AI instruction level. Complements `rules/common/git-safety.md` (soft rules) with OS-level enforcement. Guided setup for project or global scope, with Windows/Git Bash compatibility notes. Includes deployable `block-dangerous-git.sh` hook script.
  - Blocks: `git push`, `git reset --hard`, `git clean -f/fd`, `git branch -D`, `git checkout .`, `git restore .`
  - Flags: `--project`, `--global`, `--verify`, `--remove`
  - Origin: Adapted from Matt Pocock (AIHero.dev / github.com/mattpocock/skills)

---

## v2.6.0 — 2026-05-25

**New skill: /company-update + critic resolution (16 issues)**

### Added
- `/company-update` v1.0.0 — post-install maintenance for company repos. Two modes:
  - `--reconfigure`: re-run any of the 8 grilling topics from `/company-add` against the existing config; shows a diff of changes before writing; fields from unselected topics are untouched
  - `--update-skills`: compare version fields of the 17 bundled skills against `~/.claude/skills/`; show an update inventory; copy newer versions on confirmation
  - `--all`: reconfigure then update-skills in sequence
- `decisions/ADR-001-one-company-per-install.md` — formal ADR documenting the one-company-per-install constraint: rationale (unambiguous path resolution, knowledge contamination risk, config conflicts), alternatives considered, and revisit criteria

### Changed
- `/company-add` v1.2.0 — multiple correctness and completeness fixes:
  - `setup.sh` template: replaced `sed -i` (broken on macOS — requires backup suffix) with portable `awk` equivalent
  - Frontmatter description: removed stale "instincts" reference
  - Confirm block and CLAUDE.md template: corrected bundled skill count from 18 to 17 (learn was removed last patch)
  - Embedded CLAUDE.md template: removed `instincts/` from repository structure section
  - Company Skills section header: corrected "18 skills" to "17 skills"
  - `config.md` template: added `git_remote` / `git_branch` fields (default `origin` / `main`) — read by `/company-sync`
  - Next steps: added step 10 — rename `technology1–technology8` to actual domain names with example `mv` command and follow-up note
- `/company-sync` v1.1.0 — safety and portability improvements:
  - Push phase now reads `git_remote` and `git_branch` from `config.md` (defaults to `origin` / `main`)
  - Added HITL gate before committing: shows a `git status --short`-style file list and requires `SYNC` before staging or committing
  - Merge conflict guidance expanded: explains that knowledge article conflicts should be merged (combining content), not overwritten; provides step-by-step resolution commands
  - Failure modes: added branch protection rejection and missing git config fields
- `/ingest` v1.1.0 — technology sub-category routing:
  - When processing items from `technology/Raw/`, after classifying, lists available sub-categories and asks the user which domain each item belongs to (HITL per item)
  - `top` option available to route to `technology/Wiki/` without a sub-category; flagged in compile log for later review
  - Step numbering corrected (10 and 11, not 9 and 10)
- `/build` — fixed duplicate `### Step 5` label in execution loop; second Step 5 renamed to Step 6 — Context Checkpoint
- `/write-a-skill` — two checklist corrections:
  - "SKILL.md under 100 lines" replaced with realistic guidance (~400 lines for workflow logic; dense reference material extracted to REFERENCE.md)
  - Added `forge-sequence.mmd` review item: update diagram when a new pipeline phase is added or phase order changes
- `SOUL.md` — added AFK exception to the file-writing rule: during `/build` AFK execution, writing code, tests, and kanban updates is the expected autonomous output (not a HITL violation)
- `install.sh` — FORGE_VERSION now read dynamically from `manifest.json` instead of hardcoded; never drifts on version bumps
- `update.sh` — added `decisions/` directory to framework file sync; ADRs are now updated alongside PRINCIPLES.md and SOUL.md on `bash update.sh`

### Fixed
- P1-1 `setup.sh` macOS portability — `sed -i` → `awk`
- P1-2 Stale "instincts" in company-add frontmatter description
- P1-3 Wrong bundled skill count (18 → 17) in three locations
- P1-4 `/company-sync` blind commit — HITL gate added
- P1-5 `/build` duplicate Step 5 numbering
- P2-7/P2-8 No post-install update path — resolved by `/company-update`
- P2-9 `/ingest` had no technology sub-category routing
- P2-10 `/write-a-skill` 100-line rule was fiction in practice
- P2-11 `/company-sync` hard-coded `origin main` — now reads from config
- P3-12 One-company constraint undocumented — ADR-001 written
- P3-13 No rename-domain guidance — step 10 added to /company-add next steps
- P3-14 SOUL.md contradiction with AFK mode — exception clause added
- P3-15 forge-sequence.mmd update criterion vague — checklist item added to /write-a-skill
- P3-16 Merge conflict guidance for prose knowledge files was absent

---

## v2.5.8 — 2026-05-25

**Company structure mirrors global: Raw/Wiki/Outputs, rules, projects, tools, legal, technology**

### Changed
- `/company-add` v1.1.0 — scaffold now mirrors global `~/.claude/` structure:
  - Added `knowledge/Raw/`, `knowledge/Wiki/`, `knowledge/Outputs/` — three-tier knowledge pipeline lands in company repo; `/ingest` already routes here when `active_company` is set
  - Added `knowledge/legal/` with full three-tier structure (Raw/Wiki/Outputs) — contracts and legal advice are ingested via Raw/ first; Wiki index stub notes legal privilege sensitivity and suggests `/pii-check` before sharing
  - Added `knowledge/technology/` with Raw/Wiki/Outputs at the domain level; 8 placeholder sub-categories (`technology1/`–`technology8/`) with Wiki/Outputs only — Raw/ lives at `technology/` level, `/ingest` classifies and routes articles into the correct sub-category Wiki/; each sub-category also has a `hardware/` folder (Wiki/Outputs, no Raw/); sub-categories renamed to actual domains at company install
  - Added `projects/` with `registry.md` stub — company-level project index; populated by `/add-project` and `/create-project`. Distinct from `knowledge/projects/` (which holds knowledge content per project)
  - Added `tools.md` — required/approved/prohibited tools registry; scaffolded by `/company-add` and populated via `/tool-add --company [name]`
  - Added Topic 8 — Tools Policy grilling: captures prohibited tools (compliance/licensing), required tools (security scanners, test runners), and approved standard tools; writes skeleton entries to `tools.md` with TODO comments
  - Added `rules/` with `README.md` stub — company rule extensions layer on top of global `~/.claude/rules/common/` baseline
  - Fixed `ideas/archive/` → `ideas/archived/` to match global naming
  - Added `.claude/` scaffold to company repo: 17 company knowledge skills bundled verbatim from `~/.claude/` at install time (commands + SKILL.md files); teammates who clone the repo run `setup.sh` — no full Forge install required
  - Added `setup.sh` — symlinks `~/.claude/companies/[name]` → repo root, sets `active_company` in preferences.md, installs bundled skills to `~/.claude/`; works on macOS/Linux (Git Bash/WSL for Windows)
  - Added `.claude/CLAUDE.md` — repo-level onboarding context: explains structure, lists available commands, documents setup process
  - Bundled skills (17): `ingest`, `knowledge-health`, `add-system`, `add-term`, `summarise-system`, `update-context`, `lookup`, `style-check`, `pii-check`, `company-sync`, `add-project`, `incident`, `pir`, `idea`, `tool-add`, `tool-check`, `knowledge-onboard`
  - **Instincts intentionally excluded from company repo** — instincts are personal (tailored to individual way of working) and stay in global `~/.claude/instincts/` only; not a shared team artefact
  - Updated confirm summary, skills list, and next steps to reflect full structure
- `/learn` v1.0.0 — reverted to global-only; no company routing
  - Instincts always write to `~/.claude/instincts/` regardless of `active_company` setting
  - Removed Step 0 scope selection that was added in v1.1.0

### Fixed
- `rules/common/git-safety.md` — present in `forge/global/` but missing from installed `~/.claude/rules/common/`; added to live install

---

## v2.5.6 — 2026-05-23

**New skills: /knowledge-onboard, /style-check + company knowledge layer**

### Added
- `/knowledge-onboard` — guided company knowledge setup for a new employer. Four-stage sequence: style guide → acronyms → domain terms → core systems. HITL gate between every stage. Multi-source ingestion: Confluence URL, file path (PDF/Word), manual paste (SharePoint), or verbal description. Produces `style-guide.md`, populates `acronyms.md` and `context.md`, and scaffolds system knowledge via `/summarise-system` logic.
- `/style-check` — reviews any document against `~/.claude/knowledge/company/style-guide.md`. CRITICAL/HIGH/LOW severity model (mirrors `/pii-check`). Pass/fail gate: APPROVED or NEEDS REVISION. Gracefully degrades if style guide is a placeholder.
- `~/.claude/knowledge/company/style-guide.md` — placeholder template covering written style, formatting, fonts, colour scheme, approved/banned terminology, logo usage, and document types. Populated via `/knowledge-onboard` or manually at the company.

### Changed
- `/write-article` — reads `style-guide.md` before writing (step 0 of writing process); quality gate now includes a `/style-check` reminder for external deliverables
- `/write-prd` — reads `style-guide.md` in Phase 2 before writing
- `/knowledge-health` — company knowledge scan now checks for `style-guide.md`: missing = P1, all-placeholder = P1, partially populated = P2

### Deferred
- `api.md` template and `/add-system` extension — deferred for future build
- `/summarise-system` API ingestion path — deferred for future build

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
