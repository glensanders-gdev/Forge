# Copilot prompts

Standalone prompts for **Microsoft 365 Copilot Chat**. Each file is one skill rewritten for a chat that can't read your repo, run commands or save files.

## How to use

1. Open the file and copy **everything below the `---` line**.
2. Paste it as the first message in a new Copilot Chat.
3. Paste or attach your source material, then follow the prompts.

Copilot works only from what you give it. Anything it would have saved comes back as markdown, with a suggested filename for you to save. Records that carry over between chats, such as handoffs, RAID logs, learner records and incident records, persist only if you paste them back in next time.

Long outputs arrive in numbered parts. Type **CONTINUE** to get the next one.

**Size.** Every prompt fits in one Copilot message. Two are over Agent Builder's 20,000-character skill limit: `review-ord` (23k) and `write-prd` (21k). The rest are under it.

## Typical chains

- **Planning:** idea → grill-me or grill-with-docs → research / prototype → write-prd → testplan → to-tickets → qa-plan → qa-report
- **Requirements review:** review-brd, review-ord
- **Session continuity:** handoff → (new chat) pickup · standup · update-context

## Prompts

| Prompt | What it does |
|---|---|
| accessibility | Design, implement and audit interfaces against WCAG 2.2 Level AA |
| add-backlog-item | Light grill, then a well-formed backlog entry |
| ai-first-engineering | Operating lens for teams where AI writes much of the code |
| break-down | Split one large ticket into smaller, well-scoped tickets |
| caveman | Terse reply style; full clarity kept at gates and warnings |
| changelog | Release notes: stakeholder summary plus technical changelog |
| check-scope | Mid-session check of progress against agreed goals; Keep / Defer / Drop |
| check-style | Review a document against your pasted company style guide |
| critic | Honest, prioritised critical evaluation |
| diagnose | Systematic investigation of a bug or repeated failure |
| estimate | Token-cost bands and story points |
| grill-me | Stress-test a plan in rounds of up to 5 questions, each with a recommendation |
| grill-with-docs | As grill-me, checked against your glossary and ADRs |
| handoff | Compact a chat into a handoff document for a new chat |
| ia | Impact assessment of a proposed change |
| idea | Capture and stress-test a new idea |
| incident | Incident lifecycle: declare, investigate, resolve, post-mortem |
| ingest | Compile raw material into linked wiki pages (good for a Copilot Notebook) |
| pickup | Resume from a pasted handoff |
| prototype | Plan and build a throwaway spike to answer one design question |
| qa-plan | Human QA checklist from a PRD |
| qa-report | Dated QA evidence record |
| raid | Maintain a RAID log (Risks, Actions, Issues, Decisions) |
| research | Cache exploration findings into a topic file |
| review-brd | BRD conformance review against the handoff gate (BH-1 to BH-10) |
| review-diff | Two-axis code review (spec and standards) of a pasted diff |
| review-ord | ORD conformance review against the handoff gate (OH-1 to OH-15) |
| review-performance | Performance audit of pasted code |
| security-assessment | Threat model and OWASP Top 10 review of pasted code |
| seo | Technical, on-page and content SEO audit |
| standup | Start-of-session summary, goals and blockers |
| teach | Multi-session teaching tied to a real goal |
| testplan | Testing strategy for a feature or release |
| to-tickets | Plan or PRD into vertical-slice tickets |
| update-context | Turn a session's new terms and decisions into glossary updates |
| update-readme | Propose README updates from current project state |
| vibe-security | Security audit tuned to AI-generated code |
| write-adr | Architecture Decision Record |
| write-article | Long-form content: wiki pages, summaries, briefs |
| write-prd | PRD in two phases with three confirmation gates |

**Other requirements skills.** `write-ord`, `write-brd`, `write-ac`, `write-reqs` and `review-language` have no prompt here. Use their single-file bundles instead: [`write-ord`](../skills/write-ord/write-ord-standalone.md), [`write-brd`](../skills/write-brd/write-brd-standalone.md), [`write-ac`](../skills/write-ac/write-ac-standalone.md), [`write-reqs`](../skills/write-reqs/write-reqs-standalone.md) and [`review-language`](../skills/review-language/review-language-standalone.md). They are large, so attach them as files rather than pasting them.

## Not converted

These need a repo, terminal, git or the agent's own state, so they have no useful chat version.

| Skill | Why |
|---|---|
| approve | Archives files and seals the project log in the repo |
| backlog-list | Reads a backlog file; paste your backlog into add-backlog-item instead |
| build | Runs tickets and tests in the repo |
| check-pii | Scanning for personal information means pasting it into Copilot, which the data rules forbid |
| context-health, intent-layers | Measure an agent's context files |
| debrief, save-state | Covered by handoff (end-of-day and emergency-save cases) |
| feature-flag, tech-debt | Code-side registers that live in the repo |
| git-guardrails | Installs a git hook |
| graphify | Builds a code knowledge graph with tooling |
| grill-with-peer | Needs a second AI model in the loop |
| lang-rules, push-standards | Install rule files into the repo |
| learn | Records behaviour for the agent itself |
| resolve-findings | Updates a security report file; ask security-assessment to update a pasted report instead |
| rollback, update-dependencies | Run deployment or package commands |
| scan-first, test-coverage | Need the live source and a coverage tool |
| setup-brain | Scaffolds folders |
| tdd | Needs a test runner in the loop |
| token-report | Reads AI usage logs |
| write-a-skill | Writes and registers skill folders |

## Maintenance

These prompts are adapted by hand from the skills in [`skills/`](../skills), not generated from them, so a change to a skill reaches its prompt only when the prompt is updated too. `review-brd` and `review-ord` embed a fixed copy of the gate criteria from requirements pack v1.16.
