---
name: "commands"
description: "Display all available Forge commands with a short description of what each does. Use when user runs $commands, wants to see available commands, or asks what skills are available."
metadata:
  category: framework
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Commands

Display the full Forge command reference. No input required.

## Pipeline Position

Standalone reference utility — no pipeline position. User-invoked any time.

```
$commands     ← list all available Forge skills
```

Related: `$skill-health` (validates skills are functioning), `$forge-update` (installs new skills)

## Output

Print the following reference exactly:

---

## Forge Command Reference

### Ideation
| Command | What it does |
|---------|-------------|
| `idea` | Capture and stress-test an idea — problem, baseline, targets, journey, impact vs effort |
| `create-project` | Progress an accepted idea into a new repo — grills before scaffolding |
| `onboard` | Bootstrap Forge onto an existing project — explores codebase, scaffolds docs, migrates decisions |

### Pipeline
| Command | What it does |
|---------|-------------|
| `grill-with-docs` | Planning phase entry point — grill against domain model, codebase, and CONTEXT.md |
| `grill-me` | Ad-hoc stress-test only — one question at a time, no domain model context |
| `grill-with-peer` | Challenge a plan with an independent peer model, then reconcile both models' conclusions |
| `research` | Cache findings in topic-specific files under docs/research/ |
| `prototype` | Spike ideas in throwaway code under $prototype |
| `write-prd` | Synthesise session into a PRD — AFK explores and scopes, HITL confirms and writes |
| `write-ord` | Synthesise a transcript/document into an Operational Requirements Document (ISO/IEC 25010:2023) — AFK ingests and classifies, HITL writes |
| `write-reqs` | Author a PRD and ORD together from one source — AFK classifies functional vs operational, delegates each to $write-prd and $write-ord, then cross-links the BRD↔PRD↔ORD traceability |
| `write-ac` | Transform a PRD and ORD into Jira acceptance criteria — AFK sorts KPPs/headline outcomes to Capability AC and detail to child issues, HITL writes docs/ac/ and optionally pushes to the linked Jira Capability behind a PUSH gate |
| `testplan` | Design the testing strategy — automated vs manual, critical path, what's not tested |
| `estimate` | Estimate token cost bands and story points — table of estimates, human confirms, XL flags $break-down |
| `break-down` | Split a large ticket into smaller smart-zone tickets |
| `to-tickets` | Convert a plan/PRD into vertical-slice kanban tickets — tracer bullets sized to the smart zone with genuine blocking edges, quiz-before-publish |
| `build` | Execute sprint AFK tickets in sequence with TDD — pauses at HITL and blockers, resumable |
| `tdd` | Run a single TDD cycle manually — red-green-refactor, one test at a time |
| `qa-plan` | Generate a human QA checklist from the active PRD and testplan |
| `qa-report` | Record QA results as a datestamped evidence artefact — CI link, test output, per-TC pass/fail, approve gate verdict |
| `pii-check` | Scan for PII — AFK scans codebase and docs, HITL reviews findings and confirms remediation |
| `approve` | QA passed — archive PRD, seal session, close feature cycle |

### Session Management
| Command | What it does |
|---------|-------------|
| `continue` | Resume a session exactly where it left off — reads HANDOFF.md, loads referenced artifacts, presents exact next action |
| `standup` | Summarise last session, confirm today's goals, surface blockers |
| `handoff` | Compact session into a structured handoff for the next agent or human — references artifacts, suggests next skills |
| `debrief` | Close a partial session — update kanban, write DEVLOG, reorder backlog |
| `save-state` | Save state immediately — HANDOFF.md → kanban.md → DEVLOG. Use to pause or on context exhaustion |
| `scope-check` | Flag scope creep and force a decision on each unplanned item |
| `backlog-list` | Display global backlog grouped by priority |
| `backlog-proj` | Display a project's backlog — select from known projects, grouped by priority |
| `backlog-add` | Add an item to global or project backlog — grills lightly before writing |

### Code Quality
| Command | What it does |
|---------|-------------|
| `scan-first` | Verify a ticket or task brief against live source before building or spawning agents — examples/counts/"this is open" are hypotheses until checked; classifies each item OPEN/GHOST/PARTIAL |
| `write-article` | Write long-form content in a concrete voice — Confluence pages, README, stakeholder summaries, Go/No Go briefs, release notes |
| `ai-first-engineering` | Operating principles for AI-assisted delivery — process shifts, architecture, review focus, testing standards |
| `accessibility` | Design, implement, and audit WCAG 2.2 Level AA compliance — Web/iOS/Android, QA checklist, anti-patterns |
| `diagnose` | Systematically debug a failing ticket — hypothesis before fix |
| `review` | Structured code review against ADRs, CONTEXT.md, and standards |
| `critic` | Honest prioritised critique of a framework, PRD, plan, or design |
| `lang-rules` | Install and activate language-specific coding rule sets for the current project |
| `push-standards` | Extract codebase patterns into .codex/forge/CODING-STANDARDS.md project-specific section |
| `write-adr` | Create an Architecture Decision Record for a hard design decision |
| `security-assessment` | Structured security audit — OWASP Top 10, AI threat model, optional tool scan (semgrep/bandit/trivy), gitignored report |
| `security-resolve` | Mark a security finding resolved — records fix in the report and closes the kanban ticket |
| `performance-review` | Performance audit — AI-led static analysis and optional tool scan (Lighthouse, bundle analyser), gitignored report |
| `update-readme` | Propose README updates for new features, changed behaviour, version history |
| `graphify` | Build or query a persistent knowledge graph for a codebase or mixed content |

### Knowledge Base
| Command | What it does |
|---------|-------------|
| `ia` | Impact assessment — sharpen a proposed change, search all knowledge sources, produce a severity-tagged summary, change brief or PRD, and draft artefacts in an isolated IA folder |
| `knowledge-onboard` | Guided company knowledge setup — style guide, acronyms, domain terms, and core systems in sequence |
| `style-check` | Review any deliverable against the company style guide — CRITICAL/HIGH/LOW findings, pass/fail gate |
| `knowledge-health` | Read-only diagnostic across all knowledge layers — coverage scorecard, stale files, cross-reference conflicts, interesting connections |
| `add-term` | Add a term to the company-level glossary — acronyms or domain concepts, lightweight quick-add |
| `add-system` | Scaffold a new system folder in ~/.codex/forge/knowledge/systems/ |
| `teach` | Teach a subject across sessions — mission-grounded, ZPD-pitched HTML lessons with curated resources, spaced practice, and learning records under ~/.codex/forge/knowledge/learning/ |
| `add-project` | Scaffold a new project knowledge folder under ~/.codex/forge/knowledge/projects/ with Raw/Wiki/Outputs tiers |
| `brain-setup` | Scaffold or audit the three-tier second-brain model (global/company/project Raw+Wiki) — enforce per-project personal-or-company scope, establish the company pending-changes record |
| `summarise-system` | Draft overview.md for a system from docs or description |
| `update-context` | Flush session discoveries into CONTEXT.md and knowledge files |
| `ingest` | Compile Raw/ items into Wiki articles — handles files in Raw/, uploaded files, and pasted text |
| `publish` | Publish wiki articles to Confluence — pushes changed articles since last run or all with --all |
| `setup-confluence` | Configure Confluence publishing — connection details, auth, and validation before writing config |

### Metrics & Reporting
| Command | What it does |
|---------|-------------|
| `token-report` | Program-level token usage report — by feature, sprint, PI, or calibration analysis |
| `dashboard-tokens` | Generate a comprehensive project health dashboard — Token & Cost, Quality, Pipeline, Knowledge, Health sections |
| `context-health` | Audit the token load profile of context files — sizes, growth flags, trimming recommendations |
| `intent-layers` | Alias for `$context-health` — use if you think in terms of Tyler Brandt's Intent Layer pattern (directory-scoped AGENTS.md nodes) |
| `fy-review` | Generate a financial year or mid-year review — delivered value, token spend, year-on-year comparison |

### PI & Release Management
| Command | What it does |
|---------|-------------|
| `piplan` | Create or update a PI plan — releases, sprints, features, stakeholder view |
| `pi-end` | Formally close a PI — delivery summary, retro, carry-forwards, stakeholder update, archive |
| `sprintplan` | Display sprint timeline with tickets, deployments, buffers, and Go/No Go dates |
| `go-nogo` | Prepare Go/No Go brief for a release — reads company config for cadence and freeze periods; human types GO or NO-GO |
| `changelog` | Generate release notes from completed kanban tickets, DEVLOG entries, ADRs, and git log |
| `deploy` | Deploy current project — staged or direct, runbook fallback, rollback validation |
| `deploy-pi` | Deploy all PI projects in sequence — stops on failure, updates PI plan on full success |
| `rollback` | Roll back current project — presents last good version, requires reason + ROLLBACK [version] |
| `rollback-pi` | Roll back all PI projects in reverse order — one reason, per-project confirmation, stops on failure |
| `standalone-release` | Deploy an urgent change outside the monthly cycle — lighter gate, still HITL |
| `sprint-replan` | Inject unplanned work mid-sprint — absorb or swap, displaced tickets flagged in backlog |
| `pi-replan` | Inject new project mid-PI — assesses remaining releases, Fixed Deadline risks, two-gate confirmation |
| `incident` | Manage a production incident lifecycle — declare, investigate, resolve, post-mortem, stakeholder comms |

### Sprint Management
| Command | What it does |
|---------|-------------|
| `sprint-start` | Open a new sprint — pull calendar dates, carry-in, capture goals and deadlines |
| `sprint-end` | Close the sprint — AFK drafts from kanban, HITL finalises retro and carry-over |
| `pir` | Post Implementation Review — did features achieve stated goals? Reads PRDs, collects outcomes, writes private PIR to company directory |

### Maintenance
| Command | What it does |
|---------|-------------|
| `feature-flag` | Track feature flags from creation to removal — register, surface overdue flags, create cleanup tickets |
| `tech-debt` | Track and manage technical debt — add entries, list by priority, resolve when addressed; $sprint-start surfaces High items |
| `dependency-update` | Update dependencies safely — patch/minor by default, --all for major bumps with per-package confirmation |

### Company Configuration
| Command | What it does |
|---------|-------------|
| `company-add` | Set up a company-specific config — grills on sprint cadence, team locations, freeze periods, compliance, and AI policy |
| `company-git` | Connect the company knowledge directory to a company-approved GitHub remote |
| `company-sync` | Sync company knowledge directory with the team GitHub remote — pull, push, or selective |
| `company-update` | Post-install maintenance — re-run grilling topics to update config (--reconfigure) or refresh bundled skills after a Forge upgrade (--update-skills) |
| `tool-add` | Register a tool in the global or company tools registry — grills on category, usage, and anti-patterns |
| `tool-check` | Verify which registered tools are installed — full matrix by category with company classifications |

### Framework
| Command | What it does |
|---------|-------------|
| `write-a-skill` | Create a new Forge skill with correct structure and manifest entry |
| `assimilate` | Adapt an external idea into Forge — evaluates fit, adapts with Forge conventions, credits source |
| `learn` | Capture a session pattern as a Forge instinct — checks duplicates, increments count, one behaviour question |
| `evolve` | Review High confidence instincts — PROMOTE to skill, DEFER, or RETIRE. Never auto-promotes. |
| `link-jira` | Link a Forge ID (IDEA-NNN or PROJ-NNN) to a Jira ticket, epic, or capability |
| `lookup` | Find any entity by ID — IDEA-NNN, PROJ-NNN, TC-NNN, SEC-NNN, PERF-NNN, INC-NNN — returns summary and file path |
| `forge-init` | Regenerate ~/.codex/forge/AGENTS.md and ~/.codex/forge/AGENTS.md — run after config changes or Forge upgrade |
| `forge-update` | Pull the latest Forge from GitHub and install updated skills, commands, and framework files |
| `commands` | Show this reference |

---

> **Maintainer note:** Update this reference whenever a new skill is added to `global/.claude/skills/manifest.json`. Skills not listed here are not discoverable via `$commands`.

## Rules

- Print the reference exactly — never paraphrase, reorder, or summarise entries.
- Never invent commands — list only skills present in `manifest.json`.
- Keep this reference in sync with the manifest; a skill missing here is not discoverable via `$commands`.

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| A skill in `manifest.json` is missing from this reference | Surface the gap — it won't be discoverable; flag the reference for update rather than silently omitting it. |
| A listed command no longer exists in the manifest | Flag it as stale rather than printing a dead entry. |
| User asks what a specific command does | Answer from this reference — never fabricate behaviour for an unlisted command. |
| User asks about a project-level command | Note that project commands use `/project:` rather than ``. |
