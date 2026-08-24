# Skills

65 skills for [Claude Code](https://claude.com/claude-code) — practical, self-contained
workflows for getting real work done with an AI assistant.

They cover the parts of software delivery that benefit most from structure: writing
requirements, stress-testing a plan before you build it, test-driven implementation,
code and security review, accessibility, and keeping context under control across
long sessions. Each one stands on its own — install the whole set or a single skill.

## Install

Everything:

```bash
git clone https://github.com/glensanders-gdev/skills.git && cd skills && ./install.sh
```

Or a single skill — copy the folder into `~/.claude/skills/`:

```bash
cp -r skills/tdd ~/.claude/skills/
```

Restart your session, then invoke a skill by name — `/tdd`, `/review-diff`, `/write-prd`.

Some skills cite the shared standards in `rules/`. `install.sh` copies those to
`~/.claude/rules/` alongside the skills.

## Skills

### Specification and delivery

| Skill | What it does |
|---|---|
| [`/approve`](skills/approve/SKILL.md) | Close a completed feature by archiving the PRD, sealing the DEVLOG session, and optionally pushing coding standards. Use when human runs /approve afte… |
| [`/break-down`](skills/break-down/SKILL.md) | Split a large ticket or feature into smaller tickets within the smart zone limit, with HITL/AFK tags and blocking relationships. Use when user runs /b… |
| [`/build`](skills/build/SKILL.md) | Execute the current sprint's AFK tickets in sequence, running /tdd for each. Pauses at HITL tickets and blockers with clear prompts. Updates kanban in… |
| [`/check-pii`](skills/check-pii/SKILL.md) | Scan the codebase and project documents for Personal Identifying Information (PII). Classifies findings as Necessary or Incidental, assesses handling… |
| [`/estimate`](skills/estimate/SKILL.md) | Estimate AI token cost and development complexity for a feature, module, or ticket. Produces token cost bands (S/M/L/XL) and story points (1/2/3/5/8/1… |
| [`/grill-me`](skills/grill-me/SKILL.md) | Ad-hoc stress-test of a plan or design outside the standard planning phase. Use when user wants to pressure-test an idea, approach, or decision withou… |
| [`/grill-with-docs`](skills/grill-with-docs/SKILL.md) | Planning phase grilling session that challenges a plan against the existing domain model, sharpens terminology, and updates CONTEXT.md and ADRs inline… |
| [`/grill-with-peer`](skills/grill-with-peer/SKILL.md) | Stress-test a plan or design with an independent peer model, then reconcile its critique with the host model. Use when the user asks for cross-model r… |
| [`/prototype`](skills/prototype/SKILL.md) | Spike throwaway code to answer a specific design question before writing the PRD. Pick a branch first — a logic/state question builds an interactive L… |
| [`/qa-plan`](skills/qa-plan/SKILL.md) | Generate a human QA checklist from the active PRD's user stories and definition of done. Use when user runs /qa-plan, implementation is complete, or t… |
| [`/qa-report`](skills/qa-report/SKILL.md) | Record the results of a completed QA session as a datestamped evidence artefact. Reads the qa-plan and TC registry, captures pass/fail per test case,… |
| [`/research`](skills/research/SKILL.md) | Cache findings from expensive exploration phases into topic-specific markdown files. Use when implementation would require repeated or costly explorat… |
| [`/review-brd`](skills/review-brd/SKILL.md) | Assess a submitted BRD against the published handoff gate — BH-1 to BH-10, the [TBD] treatment rule and the four outcomes — returning a per-item verdi… |
| [`/review-ord`](skills/review-ord/SKILL.md) | Assess a submitted ORD against the published §7.1 handoff gate — OH-1 to OH-13, the four outcomes, the §7.3 refuse-to-produce scan and the §5 tier rul… |
| [`/tdd`](skills/tdd/SKILL.md) | Test-driven development with red-green-refactor loop. Use when user wants to build features or fix bugs using TDD, mentions "red-green-refactor", want… |
| [`/test-coverage`](skills/test-coverage/SKILL.md) | Analyze test coverage gaps in an existing codebase, identify under-covered files and functions, then generate missing tests to reach the project cover… |
| [`/testplan`](skills/testplan/SKILL.md) | Design the testing strategy for a feature or a release — what to test, at what level, automated vs manual, and which behaviours are critical. Runs in… |
| [`/to-tickets`](skills/to-tickets/SKILL.md) | Convert a plan, PRD, spec, or conversation into a set of vertical-slice kanban tickets — each a tracer bullet sized to the smart zone, with genuine bl… |
| [`/write-ac`](skills/write-ac/SKILL.md) | Transform a PRD and ORD into Jira acceptance criteria — promote KPPs and headline outcomes to Capability-level AC, flow story detail to child Epics/St… |
| [`/write-brd`](skills/write-brd/SKILL.md) | Author a Business Requirements Document to the pack's BABOK v3 standard — SMART objectives carrying baseline, target and date, outcomes rather than so… |
| [`/write-ord`](skills/write-ord/SKILL.md) | Synthesize a call transcript, document, conversation context, or structured notes into a compliant Operational Requirements Document (ORD) organised b… |
| [`/write-prd`](skills/write-prd/SKILL.md) | Synthesize the current conversation, grill session, research, and prototype findings into a structured PRD aligned with ISO/IEC/IEEE 29148:2018 — the… |
| [`/write-reqs`](skills/write-reqs/SKILL.md) | Author a PRD and an ORD together from one source — classify needs into functional (PRD) and operational (ORD), delegate each document end-to-end to /w… |

### Code quality and review

| Skill | What it does |
|---|---|
| [`/accessibility`](skills/accessibility/SKILL.md) | Design, implement, and audit inclusive digital products using WCAG 2.2 Level AA standards. Generates semantic ARIA for Web and accessibility attribute… |
| [`/ai-first-engineering`](skills/ai-first-engineering/SKILL.md) | Operating principles for teams delivering software with AI-assisted code generation. Shapes how planning, review, architecture, and testing work when… |
| [`/critic`](skills/critic/SKILL.md) | Critically evaluate the current framework, plan, PRD, skill, or design. Surfaces weaknesses, risks, inconsistencies, and gaps with honest prioritised… |
| [`/diagnose`](skills/diagnose/SKILL.md) | Systematically diagnose a failing ticket, bug, or repeated error. Use when /diagnose is invoked manually, or when the AI has failed the same ticket tw… |
| [`/git-guardrails`](skills/git-guardrails/SKILL.md) | Set up a PreToolUse hook that hard-blocks dangerous git commands (push, reset --hard, clean -f, branch -D, checkout ., restore .) before Claude can ex… |
| [`/lang-rules`](skills/lang-rules/SKILL.md) | Install and activate language-specific coding rule sets for the current project. Detects project languages, checks ~/.claude/rules/<lang>/ for availab… |
| [`/push-standards`](skills/push-standards/SKILL.md) | Extract coding patterns from the current codebase and append them to .claude/CODING-STANDARDS.md under a Project-Specific Patterns section. Use when u… |
| [`/resolve-findings`](skills/resolve-findings/SKILL.md) | Mark a security finding as resolved. Records resolution date, resolver, and fix description in the assessment report. Closes the kanban ticket if one… |
| [`/review-diff`](skills/review-diff/SKILL.md) | Two-axis structured code review of a pinned diff — a Spec axis (does the change fulfil its originating requirement) and a Standards axis (project docs… |
| [`/review-performance`](skills/review-performance/SKILL.md) | Structured performance audit of project code. AI-led static analysis and architectural review, layered with optional tool invocation (Lighthouse, webp… |
| [`/scan-first`](skills/scan-first/SKILL.md) | Verify a ticket or task brief against live source before building or spawning agents on it — treat examples, counts, and "this is open" claims as hypo… |
| [`/security-assessment`](skills/security-assessment/SKILL.md) | Structured security audit of project code. AI-led threat modelling and OWASP Top 10 review, layered with optional external tool invocation (semgrep, n… |
| [`/seo`](skills/seo/SKILL.md) | SEO audit and remediation planning — technical SEO (crawlability, canonical, redirects), on-page (titles, meta, headings), structured data (JSON-LD),… |
| [`/update-readme`](skills/update-readme/SKILL.md) | Review the current README.md against the active PRD, DEVLOG, and codebase, then propose updates for new features, changed behaviour, or version histor… |
| [`/write-adr`](skills/write-adr/SKILL.md) | Create a structured Architecture Decision Record for a significant hard-to-reverse design decision. Use when user runs /write-adr, a major architectur… |
| [`/write-article`](skills/write-article/SKILL.md) | Write long-form content — Confluence pages, README sections, stakeholder summaries, Go/No Go briefs, release notes, guides, and reports — in a clear,… |

### Security

| Skill | What it does |
|---|---|
| [`/vibe-security`](skills/vibe-security/SKILL.md) | Active security auditor for AI-generated ("vibe-coded") codebases. Loads technology-specific reference files and produces severity-ranked findings wit… |

### Session continuity

| Skill | What it does |
|---|---|
| [`/add-backlog-item`](skills/add-backlog-item/SKILL.md) | Add a well-defined item to the global or a project backlog. Grills the item lightly before adding — what it is, why it matters, priority. Recognises t… |
| [`/backlog-list`](skills/backlog-list/SKILL.md) | Display the global backlog grouped by priority. Use when user runs /backlog-list, wants to see pending framework items, discussion topics, or cross-pr… |
| [`/caveman`](skills/caveman/SKILL.md) | Toggle caveman communication mode — strips articles, filler, pleasantries, and hedging to reduce output token usage by ~75%. Technical accuracy fully… |
| [`/check-scope`](skills/check-scope/SKILL.md) | Mid-session gut check that compares current progress against agreed goals and flags scope creep. Use when user runs /check-scope, the session feels li… |
| [`/debrief`](skills/debrief/SKILL.md) | Thorough session close — updates the stream handoff, sweeps the stream register, and updates kanban, DEVLOG, and the backlog. Use at the end of any pa… |
| [`/handoff`](skills/handoff/SKILL.md) | Compact the current session into a structured handoff so the next session can continue without re-reading the conversation. Writes one handoff per str… |
| [`/pickup`](skills/pickup/SKILL.md) | Resume a session exactly where it left off. Reads the stream register at docs/HANDOFF.md, picks a stream, loads its handoff and referenced artifacts,… |
| [`/save-state`](skills/save-state/SKILL.md) | Save current session state immediately — stream handoff first, register second, kanban third, DEVLOG last. Use when user runs /save-state, wants to pa… |
| [`/standup`](skills/standup/SKILL.md) | Summarise the last session, state today's goals, and surface any blockers. Use when user wants a session summary, runs /standup, or wants to orient th… |

### Maintenance

| Skill | What it does |
|---|---|
| [`/feature-flag`](skills/feature-flag/SKILL.md) | Track feature flags from creation to planned removal. Register flags, monitor for overdue removal dates, and create kanban tickets for cleanup. /stand… |
| [`/tech-debt`](skills/tech-debt/SKILL.md) | Track and manage technical debt in the current project. Add entries with priority and location, list by priority, and resolve items when addressed. Sp… |
| [`/update-dependencies`](skills/update-dependencies/SKILL.md) | Update project dependencies safely. --safe (default) handles patch and minor updates; --all includes major version bumps with per-package confirmation… |

### Release

| Skill | What it does |
|---|---|
| [`/changelog`](skills/changelog/SKILL.md) | Generate release notes from completed kanban tickets, DEVLOG entries, ADRs, and git log. Produces a user-facing release summary and a technical CHANGE… |
| [`/incident`](skills/incident/SKILL.md) | Manage the full lifecycle of a production incident — declare, investigate, resolve, and write a post-mortem. Coordinates /diagnose and /rollback as su… |
| [`/rollback`](skills/rollback/SKILL.md) | Roll back the current project to the last known good version or a specified version tag. No Go/No Go gate — emergency recovery action. Requires explic… |

### Context and cost

| Skill | What it does |
|---|---|
| [`/context-health`](skills/context-health/SKILL.md) | Audit the token load profile of the current project's context files. Measures every file loaded into a session, estimates token cost, flags files that… |
| [`/token-report`](skills/token-report/SKILL.md) | Generate a program-level token usage report across features, sprints, and PIs. Shows phase breakdowns, estimate vs actual calibration, and session cou… |

### Knowledge and learning

| Skill | What it does |
|---|---|
| [`/check-style`](skills/check-style/SKILL.md) | Review any deliverable against the company style guide in ~/.claude/knowledge/company/style-guide.md. Produces a findings report with CRITICAL, HIGH,… |
| [`/ia`](skills/ia/SKILL.md) | Impact assessment for a proposed change — searches all knowledge sources, conducts a full grill-with-docs session to sharpen the change, then produces… |
| [`/teach`](skills/teach/SKILL.md) | Teach a subject across multiple sessions, grounded in the learner's real mission. Curates trusted resources, delivers short HTML lessons pitched at th… |
| [`/update-context`](skills/update-context/SKILL.md) | Review the current session and flush new terms, decisions, and system behaviour into CONTEXT.md and relevant knowledge files. Use when user runs /upda… |

### Ideation

| Skill | What it does |
|---|---|
| [`/idea`](skills/idea/SKILL.md) | Capture and stress-test a new idea through structured grilling — problem statement, baseline measurements, destination targets, journey, impact vs eff… |

### Delivery governance

| Skill | What it does |
|---|---|
| [`/raid`](skills/raid/SKILL.md) | Manage a RAID log (Risks, Actions, Issues, Decisions) for a project, system, or process. Supports add, update, close, status, and init sub-commands. U… |

### Working with skills

| Skill | What it does |
|---|---|
| [`/intent-layers`](skills/intent-layers/SKILL.md) | Alias for /context-health. Audits token load and recommends directory-scoped AGENTS.md child nodes. Use when thinking about context structure in terms… |

### Other

| Skill | What it does |
|---|---|
| [`/graphify`](skills/graphify/SKILL.md) | Use for any question about a codebase, its architecture, file relationships, or project content — especially when graphify-out/ exists, where the ques… |

## Conventions

Every skill declares its execution mode — **[HITL]** pauses for a human, **[AFK]** runs
through. Anything consequential asks for a typed confirmation (`CONFIRM`, `APPROVE`,
`GO`). Every skill also carries explicit "never" rules, not just instructions.

## Generated — do not edit in place

These files are generated, so edits made directly here are overwritten on the next
release. Open an issue describing what needs changing and it will be fixed upstream
and republished.

Release 4.6.2.

## Credits

Individual skills credit their origins in their own files — several are adapted from
[Matt Pocock's skills](https://github.com/mattpocock/skills) and from Affaan Mustafa's ECC.
