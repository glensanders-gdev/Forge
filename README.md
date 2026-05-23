# Forge v2.0.0

An AI-assisted development workflow framework for Claude Code.

---

## What is Forge?

Forge is a structured dev workflow built around composable Claude Code skills. It guides you through a repeatable pipeline from idea to deployed feature — with sprint planning, PI management, TDD, QA, PII checking, and production deployment all covered.

```
/idea → /create-project → /grill-with-docs → /write-prd → /testplan
     → /sprint-start → /build → /qa-plan → /pii-check → /approve
     → /go-nogo → /deploy → production
```

Each stage produces an artifact that feeds the next. The AI agent orients itself at the start of every session, tracks progress on a Kanban board, and closes cleanly on `/approve`.

---

## What's Included

**50 skills** covering the full software delivery lifecycle:

| Category | Skills |
|----------|--------|
| Ideation | `/idea`, `/create-project`, `/onboard` |
| Planning | `/grill-with-docs`, `/grill-me`, `/research`, `/prototype`, `/write-prd`, `/testplan`, `/estimate`, `/break-down` |
| Build | `/build`, `/tdd`, `/diagnose`, `/scope-check` |
| QA | `/qa-plan`, `/pii-check`, `/approve` |
| Sprint | `/sprint-start`, `/sprint-end`, `/standup`, `/debrief`, `/save-state` |
| PI & Release | `/piplan`, `/pi-end`, `/sprintplan`, `/go-nogo`, `/deploy`, `/deploy-pi`, `/rollback`, `/rollback-pi`, `/standalone-release`, `/sprint-replan`, `/pi-replan` |
| Session | `/backlog-list`, `/backlog-proj`, `/backlog-add` |
| Code Quality | `/review`, `/critic`, `/write-adr`, `/push-standards`, `/update-readme` |
| Knowledge | `/add-system`, `/summarise-system`, `/update-context` |
| Token Tracking | `/token-report` — per-phase recording across all 11 pipeline stages, global ledger, calibration analysis |
| Framework | `/write-a-skill`, `/commands` |

---

## Installation

See `QUICKSTART.md` for a 5-minute path to your first feature.

### One-command install

```bash
git clone https://github.com/glensanders-gdev/Forge.git ~/forge
bash ~/forge/install.sh
```

### Update to latest

```bash
cd ~/forge && git pull && bash update.sh
```

### Manual install

See `INSTALL.md` for step-by-step instructions including hidden file visibility and Windows paths.

### 1. Install Global Skills (One-Time)

Copy the global skills to your Claude config directory:

- **Windows:** Copy `global/.claude/` to `C:\Users\YourName\`
- **Mac:** Copy `global/.claude/` to `/Users/YourName/`

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
  skills/              ← 50 global skills
  commands/            ← 51 slash commands
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
| Buffer window | Friday–Sunday before release Monday. Friday EOD is the last working day for features. |
| Release day | 3rd Monday of each month |
| Sprint start | Tuesdays |
| `IDEA-NNN` | Unique idea ID — assigned at `/idea`, tracked in `~/.claude/registry.md` |
| `PROJ-NNN` | Unique project ID — assigned at `/create-project` or `/onboard` |
| `TC-NNN` | Unique test case ID — assigned at `/testplan`, tracked in `docs/tests/registry.md` |
| `/lookup` | Find any entity by ID — returns summary, status, cross-references, file path |
| `/approve` | Closes feature cycle — requires `APPROVE` typed |
| `/deploy` | Deploys to production — requires Go/No Go gate |
| `/rollback` | Emergency recovery — no Go/No Go gate, requires reason |

---

## Skill Versioning

Skills are versioned in `~/.claude/skills/manifest.json`. The current framework version is `2.0.0`. Project-level skill overrides in `.claude/skills/[skill-name]/SKILL.md` take precedence over global skills.

---

## Sequence Diagram

The full framework lifecycle is documented in `~/.claude/forge-sequence.mmd`. Render it at [mermaid.live](https://mermaid.live) or in any Mermaid-compatible tool.

---

## Framework Version History

| Version | Changes |
|---------|---------|
| 2.2.2 | Token recording housekeeping — `_template.md`, feature name convention, multi-PI handling |
| 2.2.1 | Token recording completeness — all 11 phases, session counter, approve failure mode |
| 2.2.0 | Token recording and program-level reporting — `/token-report`, global ledger, per-phase records |
| 2.1.3 | Richer domain modelling — `ADR-FORMAT.md`, `CONTEXT-FORMAT.md`, Avoid aliases, example dialogue |
| 2.1.2 | Commands cleanup — `/grill-with-docs` as planning entry point, buffer window clarified |
| 2.1.1 | Convention updates — deployment Monday, sprint start Tuesday, planning phase → `/grill-with-docs` |
| 2.1.0 | Token and complexity estimation — `/estimate`, story points, sprint capacity check, actuals tracking |
| 2.0.0 | Full lifecycle — build, deploy, rollback, PI planning, PII check, TDD, 48 skills |
| 1.0.0 | Initial release — planning pipeline, sprint management, knowledge base, 7 skills |
