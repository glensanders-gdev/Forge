---
name: commands
description: Display all available Forge commands with a short description of what each does. Use when user runs /commands, wants to see available commands, or asks what skills are available.
---

# Commands

Display the full Forge command reference. No input required.

## Output

Print the following reference exactly:

---

## Forge Command Reference

### Ideation
| Command | What it does |
|---------|-------------|
| `/user:idea` | Capture and stress-test an idea — problem, baseline, targets, journey, impact vs effort |
| `/user:create-project` | Progress an accepted idea into a new repo — grills before scaffolding |
| `/user:onboard` | Bootstrap Forge onto an existing project — explores codebase, scaffolds docs, migrates decisions |

### Pipeline
| Command | What it does |
|---------|-------------|
| `/user:grill-with-docs` | Planning phase entry point — grill against domain model, codebase, and CONTEXT.md |
| `/user:grill-me` | Ad-hoc stress-test only — one question at a time, no domain model context |
| `/user:research` | Cache findings in topic-specific files under docs/research/ |
| `/user:prototype` | Spike ideas in throwaway code under /prototype |
| `/user:write-prd` | Synthesise session into a PRD — AFK explores and scopes, HITL confirms and writes |
| `/user:testplan` | Design the testing strategy — automated vs manual, critical path, what's not tested |
| `/user:estimate` | Estimate token cost bands and story points — table of estimates, human confirms, XL flags /break-down |
| `/user:break-down` | Split a large ticket into smaller smart-zone tickets |
| `/user:build` | Execute sprint AFK tickets in sequence with TDD — pauses at HITL and blockers, resumable |
| `/user:tdd` | Run a single TDD cycle manually — red-green-refactor, one test at a time |
| `/user:qa-plan` | Generate a human QA checklist from the active PRD and testplan |
| `/user:pii-check` | Scan for PII — AFK scans codebase and docs, HITL reviews findings and confirms remediation |
| `/user:approve` | QA passed — archive PRD, seal session, close feature cycle |

### Session Management
| Command | What it does |
|---------|-------------|
| `/user:continue` | Resume a session exactly where it left off — reads HANDOFF.md, loads referenced artifacts, presents exact next action |
| `/user:standup` | Summarise last session, confirm today's goals, surface blockers |
| `/user:handoff` | Compact session into a structured handoff for the next agent or human — references artifacts, suggests next skills |
| `/user:debrief` | Close a partial session — update kanban, write DEVLOG, reorder backlog |
| `/user:save-state` | Save state immediately — HANDOFF.md → kanban.md → DEVLOG. Use to pause or on context exhaustion |
| `/user:scope-check` | Flag scope creep and force a decision on each unplanned item |
| `/user:backlog-list` | Display global backlog grouped by priority |
| `/user:backlog-proj` | Display a project's backlog — select from known projects, grouped by priority |
| `/user:backlog-add` | Add an item to global or project backlog — grills lightly before writing |

### Code Quality
| Command | What it does |
|---------|-------------|
| `/user:write-article` | Write long-form content in a concrete voice — Confluence pages, README, stakeholder summaries, Go/No Go briefs, release notes |
| `/user:ai-first-engineering` | Operating principles for AI-assisted delivery — process shifts, architecture, review focus, testing standards |
| `/user:accessibility` | Design, implement, and audit WCAG 2.2 Level AA compliance — Web/iOS/Android, QA checklist, anti-patterns |
| `/user:diagnose` | Systematically debug a failing ticket — hypothesis before fix |
| `/user:review` | Structured code review against ADRs, CONTEXT.md, and standards |
| `/user:critic` | Honest prioritised critique of a framework, PRD, plan, or design |
| `/user:lang-rules` | Install and activate language-specific coding rule sets for the current project |
| `/user:push-standards` | Extract codebase patterns into .claude/CODING-STANDARDS.md project-specific section |
| `/user:write-adr` | Create an Architecture Decision Record for a hard design decision |
| `/user:security-assessment` | Structured security audit — OWASP Top 10, AI threat model, optional tool scan (semgrep/bandit/trivy), gitignored report |
| `/user:security-resolve` | Mark a security finding resolved — records fix in the report and closes the kanban ticket |
| `/user:performance-review` | Performance audit — AI-led static analysis and optional tool scan (Lighthouse, bundle analyser), gitignored report |
| `/user:update-readme` | Propose README updates for new features, changed behaviour, version history |

### Knowledge Base
| Command | What it does |
|---------|-------------|
| `/user:knowledge-onboard` | Guided company knowledge setup — style guide, acronyms, domain terms, and core systems in sequence |
| `/user:style-check` | Review any deliverable against the company style guide — CRITICAL/HIGH/LOW findings, pass/fail gate |
| `/user:knowledge-health` | Read-only diagnostic across all knowledge layers — coverage scorecard, stale files, cross-reference conflicts, interesting connections |
| `/user:add-term` | Add a term to the company-level glossary — acronyms or domain concepts, lightweight quick-add |
| `/user:add-system` | Scaffold a new system folder in ~/.claude/knowledge/systems/ |
| `/user:add-project` | Scaffold a new project knowledge folder under ~/.claude/knowledge/projects/ with Raw/Wiki/Outputs tiers |
| `/user:summarise-system` | Draft overview.md for a system from docs or description |
| `/user:update-context` | Flush session discoveries into CONTEXT.md and knowledge files |
| `/user:ingest` | Compile Raw/ items into Wiki articles — handles files in Raw/, uploaded files, and pasted text |
| `/user:publish` | Publish wiki articles to Confluence — pushes changed articles since last run or all with --all |
| `/user:setup-confluence` | Configure Confluence publishing — connection details, auth, and validation before writing config |

### Metrics & Reporting
| Command | What it does |
|---------|-------------|
| `/user:token-report` | Program-level token usage report — by feature, sprint, PI, or calibration analysis |
| `/user:dashboard-tokens` | Generate a comprehensive project health dashboard — Token & Cost, Quality, Pipeline, Knowledge, Health sections |
| `/user:context-health` | Audit the token load profile of context files — sizes, growth flags, trimming recommendations |
| `/user:fy-review` | Generate a financial year or mid-year review — delivered value, token spend, year-on-year comparison |

### PI & Release Management
| Command | What it does |
|---------|-------------|
| `/user:piplan` | Create or update a PI plan — releases, sprints, features, stakeholder view |
| `/user:pi-end` | Formally close a PI — delivery summary, retro, carry-forwards, stakeholder update, archive |
| `/user:sprintplan` | Display sprint timeline with tickets, deployments, buffers, and Go/No Go dates |
| `/user:go-nogo` | Prepare Go/No Go brief for a release — reads company config for cadence and freeze periods; human types GO or NO-GO |
| `/user:changelog` | Generate release notes from completed kanban tickets, DEVLOG entries, ADRs, and git log |
| `/user:deploy` | Deploy current project — staged or direct, runbook fallback, rollback validation |
| `/user:deploy-pi` | Deploy all PI projects in sequence — stops on failure, updates PI plan on full success |
| `/user:rollback` | Roll back current project — presents last good version, requires reason + ROLLBACK [version] |
| `/user:rollback-pi` | Roll back all PI projects in reverse order — one reason, per-project confirmation, stops on failure |
| `/user:standalone-release` | Deploy an urgent change outside the monthly cycle — lighter gate, still HITL |
| `/user:sprint-replan` | Inject unplanned work mid-sprint — absorb or swap, displaced tickets flagged in backlog |
| `/user:pi-replan` | Inject new project mid-PI — assesses remaining releases, Fixed Deadline risks, two-gate confirmation |
| `/user:incident` | Manage a production incident lifecycle — declare, investigate, resolve, post-mortem, stakeholder comms |

### Sprint Management
| Command | What it does |
|---------|-------------|
| `/user:sprint-start` | Open a new sprint — pull calendar dates, carry-in, capture goals and deadlines |
| `/user:sprint-end` | Close the sprint — AFK drafts from kanban, HITL finalises retro and carry-over |
| `/user:pir` | Post Implementation Review — did features achieve stated goals? Reads PRDs, collects outcomes, writes private PIR to company directory |

### Maintenance
| Command | What it does |
|---------|-------------|
| `/user:feature-flag` | Track feature flags from creation to removal — register, surface overdue flags, create cleanup tickets |
| `/user:tech-debt` | Track and manage technical debt — add entries, list by priority, resolve when addressed; /sprint-start surfaces High items |
| `/user:dependency-update` | Update dependencies safely — patch/minor by default, --all for major bumps with per-package confirmation |

### Company Configuration
| Command | What it does |
|---------|-------------|
| `/user:company-add` | Set up a company-specific config — grills on sprint cadence, team locations, freeze periods, compliance, and AI policy |
| `/user:company-git` | Connect the company knowledge directory to a company-approved GitHub remote |
| `/user:company-sync` | Sync company knowledge directory with the team GitHub remote — pull, push, or selective |

### Framework
| Command | What it does |
|---------|-------------|
| `/user:write-a-skill` | Create a new Forge skill with correct structure and manifest entry |
| `/user:assimilate` | Adapt an external idea into Forge — evaluates fit, adapts with Forge conventions, credits source |
| `/user:learn` | Capture a session pattern as a Forge instinct — checks duplicates, increments count, one behaviour question |
| `/user:evolve` | Review High confidence instincts — PROMOTE to skill, DEFER, or RETIRE. Never auto-promotes. |
| `/user:link-jira` | Link a Forge ID (IDEA-NNN or PROJ-NNN) to a Jira ticket, epic, or capability |
| `/user:lookup` | Find any entity by ID — IDEA-NNN, PROJ-NNN, TC-NNN, SEC-NNN, PERF-NNN, INC-NNN — returns summary and file path |
| `/user:commands` | Show this reference |

---

**Tip:** Project-level commands use `/project:command-name` instead of `/user:command-name`.

> **Maintainer note:** Update this reference whenever a new skill is added to `global/.claude/skills/manifest.json`. Skills not listed here are not discoverable via `/commands`.
