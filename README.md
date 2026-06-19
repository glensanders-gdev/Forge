# Forge v3.9.0

An AI-assisted development workflow framework for Claude Code and Codex.

---

## What is Forge?

Forge is a structured dev workflow built around composable skills for Claude Code and Codex. It guides you through a repeatable pipeline from idea to deployed feature — with sprint planning, PI management, TDD, QA, PII checking, and production deployment all covered.

```
/idea → /create-project → /grill-with-docs → /write-prd → /testplan
     → /sprint-start → /build → /qa-plan → /pii-check → /approve
     → /go-nogo → /deploy → production
```

Each stage produces an artifact that feeds the next. The AI agent orients itself at the start of every session, tracks progress on a Kanban board, and closes cleanly on `/approve`.

---

## What's Included

**107 shared skills** covering the full software delivery lifecycle, adapted for Claude Code and Codex:

| Category | Skills |
|----------|--------|
| Ideation | `/idea`, `/create-project`, `/front-gate`, `/onboard` |
| Pipeline | `/grill-with-docs`, `/grill-me`, `/grill-with-peer`, `/research`, `/prototype`, `/write-prd`, `/write-ord`, `/write-reqs`, `/write-ac`, `/testplan`, `/estimate`, `/break-down`, `/build`, `/tdd`, `/test-coverage`, `/qa-plan`, `/qa-report`, `/pii-check`, `/approve` |
| Session Management | `/continue`, `/standup`, `/handoff`, `/debrief`, `/save-state`, `/scope-check`, `/caveman`, `/backlog-list`, `/backlog-proj`, `/backlog-add`, `/lookup`, `/ia` |
| Code Quality | `/scan-first`, `/review`, `/critic`, `/diagnose`, `/write-adr`, `/push-standards`, `/lang-rules`, `/update-readme`, `/git-guardrails`, `/accessibility`, `/ai-first-engineering`, `/write-article`, `/seo`, `/security-assessment`, `/security-resolve`, `/performance-review`, `/vibe-security`, `/codex-review` |
| Knowledge Base | `/ia`, `/add-system`, `/add-project`, `/teach`, `/summarise-system`, `/update-context`, `/add-term`, `/knowledge-health`, `/knowledge-onboard`, `/style-check`, `/ingest`, `/publish`, `/setup-confluence` |
| Metrics & Reporting | `/token-report`, `/dashboard-tokens`, `/context-health`, `/fy-review` |
| PI & Release | `/piplan`, `/pi-end`, `/sprintplan`, `/go-nogo`, `/changelog`, `/deploy`, `/deploy-pi`, `/rollback`, `/rollback-pi`, `/standalone-release`, `/sprint-replan`, `/pi-replan`, `/incident`, `/raid` |
| Sprint Management | `/sprint-start`, `/sprint-end`, `/pir` |
| Maintenance | `/feature-flag`, `/tech-debt`, `/dependency-update` |
| Company Config | `/company-add`, `/company-git`, `/company-sync`, `/company-update`, `/jira`, `/tool-add`, `/tool-check` |
| Framework | `/write-a-skill`, `/assimilate`, `/learn`, `/evolve`, `/forge-init`, `/forge-install`, `/forge-update`, `/skill-health`, `/intent-layers`, `/link-jira`, `/commands` |

---

## Installation

See `QUICKSTART.md` for a 5-minute path to your first feature.

### One-command install

```bash
git clone https://github.com/glensanders-gdev/Forge.git ~/forge
bash ~/forge/install.sh
```

`install.sh` creates **junctions** (Windows) or **symlinks** (Mac/Linux) from `~/.claude/skills/`, `~/.claude/commands/`, and `~/.claude/rules/` directly into the cloned repo. Edits to skills in `~/.claude/` are immediately visible in `git status` — no copy step required. User-owned directories (`knowledge/`, `instincts/`, `tokens/`, etc.) are never touched.

### Codex Plugin

Forge also ships as a Codex plugin from this repository:

```text
plugins/forge-codex/
.agents/plugins/marketplace.json
```

Codex invokes workflows with `$skill-name`. The committed plugin is generated from `global/.claude/`, with reviewed runtime-specific overrides where Claude Code and Codex differ. Run `tools/build-forge-codex.ps1` after shared workflow changes and `tools/test-forge-parity.ps1` before committing.

Codex-native overrides are guarded by reviewed source hashes. When their shared source changes, parity fails until the override is reviewed and `tools/update-forge-codex-overrides.ps1 -ConfirmReview` is run.

### Update to latest

```bash
cd ~/forge && git pull
```

Or from any Claude Code session:

```
/forge-update
```

### Remote / Web Sessions (Claude Code on Web)

Each remote session runs in a fresh container — `~/.claude/skills/` resets on every new session. Re-run the installer at the start of each session to re-create junctions:

```bash
# From the Forge repo root (non-interactive — detects no TTY automatically)
bash install.sh
```

Skills are fully functional after this. Any data in `~/.claude/knowledge/`, `~/.claude/companies/`, and `~/.claude/tokens/` is preserved between sessions if the container retains state (check your environment's persistence policy).

### Manual install

See `INSTALL.md` for step-by-step instructions including hidden file visibility and Windows paths.

### 1. Install Global Skills (One-Time)

Run `install.sh` to create junctions/symlinks from `~/.claude/` into the cloned repo:

```bash
bash ~/forge/install.sh
```

See `INSTALL.md` for full instructions including hidden file visibility and manual steps.

### 2. Scaffold a New Project

Copy the project template into your repo root:

```
my-project/
  CLAUDE.md          ← session instructions for the AI agent
  .gitignore
  .claude/
    deploy.md        ← deployment configuration
    skills/          ← project-specific skill overrides
    commands/
  docs/
    CONTEXT.md       ← domain glossary
    DEVLOG.md        ← session history
    HANDOFF.md       ← always-current session handoff
    kanban.md        ← ticket board
    kanban-archive.md
    adr/             ← Architecture Decision Records
    prd/             ← PRDs (active and archived)
    research/        ← research cache
    sprints/         ← sprint records
    releases/        ← Go/No Go briefs and deploy log
```

### 3. Configure

Fill in `CLAUDE.md` project details and `.claude/deploy.md` deployment config. See `INSTALL.md` for guidance.

### 4. Start

Open Claude Code in your project and type:

```
/user:idea
```

Or if you have an existing project:

```
/user:onboard
```

---

## Global File Structure

```
~/.claude/
  skills/              ← 107 shared skills
  commands/            ← 104 shared workflow commands + /grill-with-codex alias
  tools/
    global.md          ← global tools registry (security scanners, perf analysers, etc.)
  knowledge/
    company/
      acronyms.md
      pii-categories.md
      framework/       ← business process templates
    systems/           ← per-system knowledge (overview, schema, known-issues)
  sprints/
    calendar.md        ← global sprint schedule
  pi/                  ← PI plans and stakeholder views
  ideas/
    active/            ← accepted and holding ideas
    archived/          ← declined ideas
  tokens/
    ledger.md          ← global cross-project token usage ledger
  registry.md          ← global ID registry (IDEA-NNN, PROJ-NNN counters + cross-refs)
  priorities.md        ← cross-project feature priority list
  backlog.md           ← framework-level backlog
  preferences.md       ← global preferences
  PRINCIPLES.md        ← Forge design philosophy — read before writing new skills
  CHANGELOG.md         ← Forge version history
  forge-sequence.mmd   ← framework sequence diagram
  rules/
    common/            ← language-agnostic coding standards (always active)
    [lang]/            ← language-specific rule sets, installed via /lang-rules
```

---

## Key Concepts

| Term | Meaning |
|------|---------|
| `[HITL]` | Human-in-the-Loop — task requires human present |
| `[AFK]` | Away from Keyboard — AI executes autonomously |
| `[BUG]` | Bug fix — safe to execute during buffer window |
| `[PREP]` | Deployment prep — safe to execute during buffer window |
| `blocked-by: #N` | Cannot start until ticket #N is complete |
| Smart Zone | Keep each task under 100k tokens |
| Buffer window | Days before the release date (default: Friday–Sunday). Configured via `/company-add` |
| Release day | Configured via `/company-add` (default: 3rd Monday of each month) |
| Sprint start | Configured via `/company-add` (default: Tuesdays) |
| `IDEA-NNN` | Unique idea ID — assigned at `/idea`, tracked in `~/.claude/registry.md` |
| `PROJ-NNN` | Unique project ID — assigned at `/create-project` or `/onboard` |
| `TC-NNN` | Unique test case ID — assigned at `/testplan`, tracked in `docs/tests/registry.md` |
| `/lookup` | Find any entity by ID — returns summary, status, cross-references, file path |
| `/approve` | Closes feature cycle — requires `APPROVE` typed |
| `/deploy` | Deploys to production — requires Go/No Go gate |
| `/rollback` | Emergency recovery — no Go/No Go gate, requires reason |

---

## Skill Versioning

Skills are versioned in `global/.claude/skills/manifest.json`. The current framework version is `3.10.0` across Claude Code and Codex. Claude project overrides live in `.claude/skills/`; Codex project overrides live in `.agents/skills/`.

---

## Sequence Diagram

The full framework lifecycle is documented in `~/.claude/forge-sequence.mmd`. Render it at [mermaid.live](https://mermaid.live) or in any Mermaid-compatible tool.

---

## Framework Version History

| Version | Changes |
|---------|---------|
| 3.9.0 | Dual-runtime Forge — committed Codex plugin, shared release line, deterministic generation, parity enforcement, peer-model grilling, Codex-native overrides, and repository marketplace |
| 3.8.0 | `/vibe-security` — AI-generated codebase security auditor; `/codex-review` — adversarial two-model plan review (opt-in tool); `/raid` — RAID log management; `/ia` — Impact Assessment skill |
| 3.7.1 | Critic audit fixes (6 issues); `/write-prd` routing fix (→ `/testplan` before Kanban) |
| 3.7.0 | Junction-based sync — `install.sh` rewritten to create junctions (Windows) / symlinks (Mac/Linux) for `skills/`, `commands/`, `rules/`; `/forge-install` v2.0.0 with auto-detect, migration flow, and iOS guidance; `/forge-update` v2.0.0 simplified to `git pull`; `update.sh` deprecated |
| 3.6.0 | `/qa-report` v1.0.0 — QA evidence artefact; `/approve` v1.1.0 — QA report hard-block gate; `/qa-plan` v1.1.0 — output renamed to feature-scoped filename |
| 3.5.0 | `/forge-init`, `/forge-update` — self-maintenance skills; `/ingest` structured scope prompt; `/context-health` Intent Layer child node recommendations; `category:` field added to all 94 skill frontmatter files |
| 3.4.0 | `/front-gate` Phase 5 revised to HITL decision gate (submit / draft / discard); 13 Mermaid sequence diagrams added to `docs/diagrams/`; `install.sh` auto-pulls latest before installing |
| 3.3.0 | `/front-gate` — structured intake for non-technical stakeholders; 7-question grill; Request Brief output to `docs/requests/` |
| 3.2.0 | `/caveman` — token-saving response mode (~75% output reduction); state persisted in `preferences.md`; HITL safety exception |
| 3.1.0 | `/seo` — SEO audit and remediation; three-tier taxonomy (Critical / High / Medium); dated reports to `docs/seo/` |
| 3.0.0 | `/test-coverage` — test coverage audit and gap analysis (assimilated from Affaan Mustafa / ECC) |
| 2.5.7 | Tools registry — `~/.claude/tools/global.md` + company `tools.md`; `/tool-add`, `/tool-check`; `/security-assessment` and `/performance-review` use registry; `/build` pre-flight checks required tools |
| 2.5.6 | 19 new skills added (company config, knowledge, maintenance, metrics); company-config wired into `/build`, `/pii-check`, `/deploy`; `/approve` and `/deploy` suggest `/pir`; install.sh non-interactive fix; sequence diagram rewritten |
| 2.5.5 | Language rules layer — `/lang-rules`, `~/.claude/rules/common/` (coding-style, quality-checklist, research-first, security), `/push-standards` baseline awareness |
| 2.5.4 | `/write-article` — long-form content in a concrete voice |
| 2.5.3 | `/assimilate` — structured process for adapting external ideas into Forge with attribution |
| 2.5.2 | `/ai-first-engineering` — operating principles for AI-assisted delivery teams |
| 2.5.1 | `/accessibility` — WCAG 2.2 Level AA compliance skill for Web, iOS, and Android |
| 2.5.0 | Instincts system — `/learn` and `/evolve` for continuous framework improvement |
| 2.4.0 | Knowledge base health checking and research promotion |
| 2.3.7 | `/add-term`, `/knowledge-health`, `/handoff`, `/lookup`, `/save-state` |
| 2.3.0 | Unique entity IDs — `IDEA-NNN`, `PROJ-NNN`, `TC-NNN` with global registry |
| 2.2.2 | Token recording housekeeping — `_template.md`, feature name convention, multi-PI handling |
| 2.2.1 | Token recording completeness — all 11 phases, session counter, approve failure mode |
| 2.2.0 | Token recording and program-level reporting — `/token-report`, global ledger, per-phase records |
| 2.1.3 | Richer domain modelling — `ADR-FORMAT.md`, `CONTEXT-FORMAT.md`, Avoid aliases, example dialogue |
| 2.1.2 | Commands cleanup — `/grill-with-docs` as planning entry point, buffer window clarified |
| 2.1.1 | Convention updates — deployment Monday, sprint start Tuesday, planning phase → `/grill-with-docs` |
| 2.1.0 | Token and complexity estimation — `/estimate`, story points, sprint capacity check, actuals tracking |
| 2.0.0 | Full lifecycle — build, deploy, rollback, PI planning, PII check, TDD, 48 skills |
| 1.0.0 | Initial release — planning pipeline, sprint management, knowledge base, 7 skills |

---

## Acknowledgements

Forge draws on ideas, patterns, and techniques from several excellent open-source projects. Many skills have been adapted — not copied — with Forge conventions applied and original sources credited.

| Source | Author | What was adapted |
|--------|--------|-----------------|
| [ECC](https://github.com/affaan-m/ECC) | Affaan Mustafa | Accessibility (WCAG 2.2), AI-first engineering principles, write-article style rules, lang-rules system, common coding rules layer (coding-style, quality-checklist, research-first, security), instincts concept |
| [skills](https://github.com/mattpocock/skills) | Matt Pocock | Foundational skill structure and composable workflow design that shaped Forge's overall architecture; `write-a-skill` craft guidance (`CRAFT.md` — leading words, completion criteria, pruning); `/teach` — stateful, mission-grounded multi-session learning |
| [vibe-security-skill](https://github.com/raroque/vibe-security-skill) | Chris Raroque | `/vibe-security` — AI-generated codebase security auditor |

Every adapted skill includes an `origin:` field in its frontmatter and a credit line in the skill body. If you adapt Forge skills for your own framework, please carry the credits forward.
