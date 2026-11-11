# PRD: Skill Security Audit

**Date:** 2026-11-10
**Status:** Active
**Standard:** ISO/IEC/IEEE 29148:2018 · **Pack version:** v1.19
**Chain position:** Business Requirements Document (BRD) → **Product Requirements Document (PRD)** → Solution on a Page (SOAP) → Operational Requirements Document (ORD) → Solution Architecture Review (SAR)
**Sprint:** Not sprint-tracked
<!--forge-only-->**PI:** Not PI-tracked<!--/forge-only-->
**Target Release:** Not assigned
**Author:** Claude Code (authoring agent), for the Forge maintainer

**Stakeholder Label:** Skill Security Audit
**Delivery Type:** Iterative
**Delivery Mode:** AI-assisted
**Priority:** P3 Normal
**Due Date (Internal):** None
**Due Date (External):** None
**Estimate (AI Token Cost):** XL
**Estimate (Story Points):** 38 pts
**Estimate Status:** Current
**Last estimated:** 2026-11-10

---

## Problem Statement

An agent skill is a set of instructions, and sometimes code, that an AI agent loads and follows with the user's own privileges. No exploit is needed to misuse one. Plain English in a skill file is enough to direct the agent to read credentials and send them out.

Public skill registries already carry malicious skills. An independent study of 98,380 registry skills confirmed 157 malicious skills carrying 632 vulnerabilities (Liu et al. 2026). A vendor audit reported critical issues in 13.4% of 3,984 skills (Snyk 2026).

Forge brings outside skills in through `/assimilate` and runs 124 skills of its own. Today neither path has a security check. Pattern-matching scanners exist, but published tests show they miss rephrased instructions and flag security skills that quote attack patterns (Snyk 2026).

## Solution

`skill-security` is a skill that audits other skills before installation and across an installed portfolio. It reads a skill's files without running them. It compares what the skill says it does with the access its files and tools give it, and it obtains an intent judgement from an isolated reviewer. Each finding maps to the Open Worldwide Application Security Project (OWASP) Agentic Skills Top 10. The output is a recommendation, and the human decides.

It ships in three versions: Forge, the standalone distribution, and a pasted prompt for Microsoft 365 Copilot Chat.

## Success Metrics ★

These metrics measure whether the audit finds malicious skills without burying the maintainer in false alarms.

| Metric | Baseline | Target | Measurement method | Type |
|--------|----------|--------|--------------------|------|
| Malicious samples in held-out set EVL-001 rated High or Critical | 0% (no audit exists) | 100% | EVL-001 run, compared with each sample's label | Primary |
| Malicious samples in EVL-001 given an Allow recommendation | No audit exists | 0 | EVL-001 run | Guardrail |
| Forge skills carrying a High or Critical finding that no exception explains | No audit exists | 5% or fewer of the portfolio | First full portfolio audit after release | Guardrail |
| Installed skills with a current trust record | 0% | 100% within 30 days of release | Trust register compared with the installed skill list | Secondary |

The 5% guardrail is a starting value. It is reviewed after the first full portfolio audit.

## Users & Stakeholders

These are the actors named in the stories below.

| Actor | Description | Type |
|-------|-------------|------|
| Forge maintainer | Maintains the Forge skill portfolio and brings in outside skills through `/assimilate` | Primary |
| Standalone skill user | Installs Forge skills from the standalone distribution, without the rest of Forge | Primary |
| Copilot user | Runs Forge prompts by pasting them into Microsoft 365 Copilot Chat, with no file or tool access | Primary |
| Skill author | Writes or edits a skill, and receives the audit findings to act on | Secondary |

## Scope Boundary

**In:** Read-only security audits of agent skills, covering single skills before installation and the installed portfolio. The audit checks capability against stated purpose and obtains an isolated AI intent review. Findings are mapped to OWASP AST10 risks. The scope also covers trust and exception registers, the `/assimilate` gate, report handling, the sample corpus, and the standalone and Copilot versions.

**Intended purpose of the AI intent review:** an advisory judgement on whether a skill's instructions and code show malicious or deceptive intent. The judgement supports a human decision about installing or keeping a skill.

**Out:** see § Out of Scope.

## User Stories & Acceptance Criteria ★

**PRD-001 — Audit a single skill before installation**
**MoSCoW:** Must
As a Forge maintainer, I want to audit one skill from a local path, a URL or `/assimilate` before I install it, so that a malicious skill is stopped before it runs.

*Each criterion below states what is true for PRD-001 under one condition: normal operation, a failure, or a boundary.*

| ID | Acceptance Criterion | Scenario |
|----|---------------------|----------|
| PRD-001.1 | A completed audit returns one recommendation: Block, Allow or Allow with exception, with every finding listed. | Sunny Day |
| PRD-001.2 | No script, command or link inside the audited skill is executed or followed during the audit. | Sunny Day |
| PRD-001.3 | A URL source is downloaded only after the maintainer approves the named source and size. | Sunny Day |
| PRD-001.4 | A downloaded skill is placed in a new, empty directory that holds no other files. | Sunny Day |
| PRD-001.5 | Content already fetched by `/assimilate` is audited as supplied, without a second download. | Sunny Day |
| PRD-001.6 | A failed, refused or malformed intent review produces an Incomplete verdict, which never carries an Allow recommendation. | Rainy Day |
| PRD-001.7 | A declined download ends the audit with no file written. | Rainy Day |
| PRD-001.8 | A skill folder with no `SKILL.md` file is reported as not a skill, with no recommendation issued. | Edge Case |

**PRD-002 — Audit the installed skill portfolio**
**MoSCoW:** Must
As a Forge maintainer, I want to audit every installed skill in one run, so that over-privilege and unreviewed changes are found in skills already in use.

*Each criterion below states what is true for PRD-002 under one condition: normal operation, a failure, or a boundary.*

| ID | Acceptance Criterion | Scenario |
|----|---------------------|----------|
| PRD-002.1 | A portfolio audit lists every installed skill with its recommendation and finding count. | Sunny Day |
| PRD-002.2 | The intent review runs on new, changed and flagged skills only, with each unchanged skill shown as current. | Sunny Day |
| PRD-002.3 | An unreadable skill folder is listed as Incomplete, and the audit continues with the remaining skills. | Rainy Day |
| PRD-002.4 | A portfolio with no trust records runs the intent review on every skill and records each result. | Edge Case |

**PRD-003 — Flag capability that exceeds stated purpose**
**MoSCoW:** Must
As a skill author, I want to see where a skill is able to do more than it claims, so that hidden or excessive capability is visible.

*Each criterion below states what is true for PRD-003 under one condition: normal operation, a failure, or a boundary.*

| ID | Acceptance Criterion | Scenario |
|----|---------------------|----------|
| PRD-003.1 | Each finding names the stated purpose and the capability found: tool access, bundled script, network use, file access or credential path. | Sunny Day |
| PRD-003.2 | A skill combining untrusted input, private data access and an outbound channel is rated at least High. | Sunny Day |
| PRD-003.3 | An instruction to write agent configuration or memory files without a stated reason is reported as a finding. | Sunny Day |
| PRD-003.4 | An instruction to add a hook or a Model Context Protocol (MCP) server is reported as a configuration-write finding. | Sunny Day |
| PRD-003.5 | Obfuscated content is reported as a finding in its own right: encoded blocks, hidden Unicode characters, or concealed comments. | Rainy Day |
| PRD-003.6 | A skill declaring no tools and holding no scripts still has its instruction text checked for capability. | Edge Case |

**PRD-004 — Obtain an isolated AI intent review**
**MoSCoW:** Must
As a Forge maintainer, I want an AI reviewer to judge a skill's intent without acting on its instructions, so that rephrased attacks are caught safely.

*Each criterion below states what is true for PRD-004 under one condition: normal operation, a failure, or a boundary.*

| ID | Acceptance Criterion | Scenario |
|----|---------------------|----------|
| PRD-004.1 | [AI] The intent reviewer holds no tools and receives the skill only as delimited text inside its instructions. | Sunny Day |
| PRD-004.2 | [AI] Every intent verdict conforms to the fixed verdict format, giving a rating, AST10 references and quoted evidence. | Sunny Day |
| PRD-004.3 | [AI] A single-skill audit uses the Opus model tier for the intent review. | Sunny Day |
| PRD-004.4 | [AI] A portfolio audit uses the Sonnet model tier, and a Critical or High verdict is repeated on the Opus tier. | Sunny Day |
| PRD-004.5 | [AI] Detection on EVL-001 meets the thresholds recorded in § Evaluation Set and Model Registers. | Sunny Day |
| PRD-004.6 | [AI] A verdict outside the fixed format is discarded, and the audit result is recorded as Incomplete. | Rainy Day |
| PRD-004.7 | [AI] A skill instructing the reviewer to change its verdict is rated at least High, with the instruction quoted as evidence. | Edge Case |

**PRD-005 — Map findings to OWASP Agentic Skills Top 10**
**MoSCoW:** Must
As a skill author, I want each finding mapped to a published risk, so that its severity rests on a shared standard.

*Each criterion below states what is true for PRD-005 under one condition: normal operation, a failure, or a boundary.*

| ID | Acceptance Criterion | Scenario |
|----|---------------------|----------|
| PRD-005.1 | Each finding carries one AST10 risk identifier and the severity that the standard assigns to it. | Sunny Day |
| PRD-005.2 | A secondary OWASP Agentic Applications or Large Language Model (LLM) identifier is added where one applies. | Sunny Day |
| PRD-005.3 | A finding matching no AST10 risk is reported as Unmapped, with its severity set by the maintainer. | Rainy Day |
| PRD-005.4 | Each report names the AST10 version that its mappings use. | Edge Case |

**PRD-006 — Record reviewed skills in a trust register**
**MoSCoW:** Should
As a Forge maintainer, I want each reviewed skill recorded with its content fingerprint, so that any later change triggers a fresh review.

*Each criterion below states what is true for PRD-006 under one condition: normal operation, a failure, or a boundary.*

| ID | Acceptance Criterion | Scenario |
|----|---------------------|----------|
| PRD-006.1 | Each trust record holds the skill name, source, content fingerprint, recommendation, reviewer and review date. | Sunny Day |
| PRD-006.2 | A skill whose fingerprint differs from its trust record is reported as changed and is reviewed again. | Sunny Day |
| PRD-006.3 | Each `CONFIRM` override is recorded with the date, the skill fingerprint and the overridden findings. | Sunny Day |
| PRD-006.4 | Trust register writes are refused when the register location sits inside a git working tree. | Rainy Day |
| PRD-006.5 | A first audit with no trust register present creates an empty register before recording results. | Edge Case |

**PRD-007 — Honour declared exceptions for security content**
**MoSCoW:** Should
As a Forge maintainer, I want legitimate security skills to carry declared exceptions, so that quoted attack patterns do not raise false alarms.

*Each criterion below states what is true for PRD-007 under one condition: normal operation, a failure, or a boundary.*

| ID | Acceptance Criterion | Scenario |
|----|---------------------|----------|
| PRD-007.1 | A finding covered by an exception is shown at a lowered severity with the exception cited, and is never hidden. | Sunny Day |
| PRD-007.2 | The shipped baseline exceptions cover `vibe-security`, `security-assessment` and `skill-security`, each keyed by fingerprint. | Sunny Day |
| PRD-007.3 | User exceptions are added to the baseline, and no user exception removes a baseline entry. | Sunny Day |
| PRD-007.4 | An exception whose fingerprint no longer matches its skill is ignored and reported as stale. | Rainy Day |

**PRD-008 — Gate `/assimilate` on audit results**
**MoSCoW:** Should
As a Forge maintainer, I want `/assimilate` to stop on serious findings, so that no outside skill is adapted into Forge unreviewed.

*Each criterion below states what is true for PRD-008 under one condition: normal operation, a failure, or a boundary.*

| ID | Acceptance Criterion | Scenario |
|----|---------------------|----------|
| PRD-008.1 | `/assimilate` audits every fetched outside skill before its evaluation step starts. | Sunny Day |
| PRD-008.2 | A Critical or High finding halts `/assimilate` until the maintainer types `CONFIRM`. | Sunny Day |
| PRD-008.3 | Medium and Low findings are shown to the maintainer, and `/assimilate` continues. | Sunny Day |
| PRD-008.4 | An Incomplete verdict halts `/assimilate` until the maintainer types `CONFIRM`. | Rainy Day |
| PRD-008.5 | A source described in prose, with no fetched skill files, is reported as not auditable before `/assimilate` continues. | Edge Case |

**PRD-009 — Keep audit reports out of version control**
**MoSCoW:** Could
As a Forge maintainer, I want audit reports kept out of version control, so that vulnerability details are never published by a commit.

*Each criterion below states what is true for PRD-009 under one condition: normal operation, a failure, or a boundary.*

| ID | Acceptance Criterion | Scenario |
|----|---------------------|----------|
| PRD-009.1 | Each audit report is saved, dated, in a location outside every git working tree. | Sunny Day |
| PRD-009.2 | Critical and High findings are offered for promotion to SEC-NNN tickets, and each promotion waits for maintainer approval. | Sunny Day |
| PRD-009.3 | Report writes are refused when the report location sits inside a git working tree. | Rainy Day |
| PRD-009.4 | An audit with no findings still produces a dated report stating that none were found. | Edge Case |

**PRD-010 — Prove detection on a sample corpus**
**MoSCoW:** Must
As a Forge maintainer, I want a labelled set of safe and malicious sample skills, so that detection is shown rather than assumed.

*Each criterion below states what is true for PRD-010 under one condition: normal operation, a failure, or a boundary.*

| ID | Acceptance Criterion | Scenario |
|----|---------------------|----------|
| PRD-010.1 | The corpus is split into a tuning half and a held-out half, and only the held-out half forms EVL-001. | Sunny Day |
| PRD-010.2 | [AI] No malicious sample in EVL-001 receives an Allow recommendation. | Sunny Day |
| PRD-010.3 | No sample is stored as a loadable skill file, and none is included in any of the three builds. | Sunny Day |
| PRD-010.4 | The malicious samples include an obfuscated download command, a rephrased exfiltration request, a hidden Unicode instruction and an unexplained configuration write. | Sunny Day |
| PRD-010.5 | [AI] A malicious sample rated below High is recorded as a detection failure, and release is withheld until it is resolved. | Rainy Day |
| PRD-010.6 | [AI] A safe sample that quotes attack patterns, as security guidance does, receives no High or Critical finding. | Edge Case |

**PRD-011 — Run a skill audit in Microsoft 365 Copilot Chat**
**MoSCoW:** Should
As a Copilot user, I want to paste a skill into Copilot Chat and receive an audit, so that a skill is checked where no file tools exist.

*Each criterion below states what is true for PRD-011 under one condition: normal operation, a failure, or a boundary.*

| ID | Acceptance Criterion | Scenario |
|----|---------------------|----------|
| PRD-011.1 | [AI] The Copilot prompt returns a recommendation and findings in the fixed format for a pasted skill. | Sunny Day |
| PRD-011.2 | [AI] Every Copilot verdict carries the label "Indicative — not an isolated review". | Sunny Day |
| PRD-011.3 | The Copilot prompt holds 15,000 characters or fewer, including its condensed AST10 checklist. | Sunny Day |
| PRD-011.4 | [AI] Copilot output contains no rendered link or image taken from the pasted skill. | Rainy Day |
| PRD-011.5 | [AI] The prompt directs Copilot to run no work-data or web search for the rest of the chat. | Rainy Day |
| PRD-011.6 | [AI] A pasted skill instructing Copilot to search work data is rated at least High, with the instruction quoted. | Edge Case |

## Evaluation Set and Model Registers

No ORD follows this PRD, so under `ai.md` this document holds both registers and assigns their IDs.

| ID | Evaluation set | Size | Held out from | Scorer | Threshold | Floor | Prohibited outputs | Re-run trigger | Owner |
|---|---|---|---|---|---|---|---|---|---|
| EVL-001 | Held-out half of the sample skill corpus | [TBD — source: "a small corpus of benign and malicious sample skills"] | The tuning half used during reviewer prompt work | Deterministic check: recommendation and severity compared with each sample's label | 100% of malicious samples rated High or Critical | No safe security-content sample rated High or Critical | PRD-010.2 | Any change to the reviewer prompt, model tier or AST10 version | Forge maintainer |

| ID | Component | Provider | Model / version | Pinned | Deprecation notice | Fallback behaviour | Re-evaluation trigger |
|---|---|---|---|---|---|---|---|
| MDL-001 | Intent review for single-skill audits and escalations | Anthropic | Opus tier, by alias | No | None contracted | Incomplete verdict (PRD-001.6) | EVL-001 re-run |
| MDL-002 | Intent review for portfolio audits | Anthropic | Sonnet tier, by alias | No | None contracted | Incomplete verdict (PRD-001.6) | EVL-001 re-run |

Both model rows are unpinned with no contracted notice. A model alias change re-runs EVL-001, and the risk is raised as `[R-TBD]` because Forge keeps no RAID log.

## Solution Constraints & SOAP References

These givens bind any design for `skill-security`.

| ID | Constraint or reference | Type | Why it binds the solution |
|----|-------------------------|------|---------------------------|
| CON-001 | Downloaded content is untrusted, stored in a new empty directory, and never executed | Demand-side given | Forge security ruleset, and the maintainer's standing download policy |
| CON-002 | Each change ships in all three builds: Forge, Codex plugin and standalone distribution, with the parity check passing | Demand-side given | Forge build and continuous integration rules (Forge CLAUDE.md) |
| CON-003 | Every audit result is a recommendation, and the install or keep decision rests with a human | Demand-side given | Forge AI use ruleset § 3, "Own the decision" |
| CON-004 | Every consequential override uses a typed `CONFIRM` | Demand-side given | Forge skill authoring rules (Forge PRINCIPLES.md) |
| CON-005 | The skill name collides with no host built-in command name | Demand-side given | Forge reserved names register |
| — | None | SOAP reference | No SOAP exists for this feature |

## Task List

The tasks below follow the build order. Each HITL task needs the maintainer present.

### HITL Tasks (Human-in-the-Loop)

- [ ] [HITL] #1 Confirm the verdict format and severity rules before build
- [ ] [HITL] #7 Review the sample corpus labels and the tuning and held-out split `blocked-by: #6`
- [ ] [HITL] #12 Sign off the EVL-001 results and the first portfolio audit `blocked-by: #11`

### AFK Tasks (Away from Keyboard)

- [ ] [AFK] #2 Build single-skill intake: path, URL with approval, and handed-over content (PRD-001) `blocked-by: #1`
- [ ] [AFK] #3 Build the capability check (PRD-003) and AST10 mapping (PRD-005) `blocked-by: #2`
- [ ] [AFK] #4 Build the isolated intent review and tier routing (PRD-004) `blocked-by: #3`
- [ ] [AFK] #5 Build the trust register, the exceptions register and its shipped baseline (PRD-006, PRD-007) `blocked-by: #4`
- [ ] [AFK] #6 Write the sample corpus outside the skills tree, excluded from all builds (PRD-010) `blocked-by: #1`
- [ ] [AFK] #8 Build the portfolio audit (PRD-002) and report handling (PRD-009) `blocked-by: #5`
- [ ] [AFK] #9 Add the audit gate to `/assimilate` (PRD-008) `blocked-by: #8`
- [ ] [AFK] #10 Write the Copilot prompt (PRD-011) `blocked-by: #4`
- [ ] [AFK] #11 Run EVL-001 and the first portfolio audit, and rebuild all three targets `blocked-by: #7, #9, #10`

## Testing Decisions

- Tests check the recommendations and findings an audit produces, not how it reaches them
- EVL-001 is the main automated check of PRD-004 and PRD-010, and is re-run on each trigger in its register row
- No-execution criteria (PRD-001.2, PRD-010.3) are verified by inspection and by samples carrying harmless marker commands
- Git working tree refusals (PRD-006.4, PRD-009.3) are verified by demonstration in a temporary repository
- The Copilot prompt (PRD-011) is verified by demonstration in Copilot Chat, against samples drawn from the tuning half
- Existing patterns followed: the registers and severity handling in `skill-health`, and the report handling in `security-assessment`

## Definition of Done

Always:

- [ ] Every story's acceptance criteria verified
- [ ] Success-metric instrumentation live before launch, or waived
- [ ] All human sign-offs obtained

Under AI-assisted delivery:

- [ ] All tasks on the Kanban board marked complete
- [ ] All HITL tasks signed off by human
- [ ] Tests passing, including an EVL-001 run meeting its threshold
- [ ] Codex plugin and standalone distribution rebuilt and committed, with the parity check passing
- [ ] README updated if user-facing behaviour changed
- [ ] `/approve` issued by a human after quality assurance (QA) review

## Out of Scope

Each exclusion below is deliberate, and the last column states when it is reconsidered.

| Excluded | Reason | Revisit when |
|----------|--------|--------------|
| Certifying a skill as safe, or making the install decision | Prohibited use of the AI intent review: its output is advisory under CON-003 | Not planned |
| Assessing or ranking skill authors | Prohibited use: the audit judges content, never people | Not planned |
| Direct audit of hooks, MCP server configuration and plugin manifests | A separate attack surface, covered by other tools | A later PRD |
| Runtime sandboxing and monitoring of skill behaviour | Outside a static audit's reach | Not planned |
| Editing the host's permission or deny settings | Advisory only, since settings changes are the maintainer's | Not planned |
| Skill signing infrastructure | No registry enforces signatures yet | A registry adopts signed skills |
| Automatic fixing of audited skills | Findings go to the skill author | Not planned |
| Portfolio audit, trust register and corpus in the Copilot version | Copilot Chat holds no files and produces no reliable fingerprint | Copilot gains file tools |
| `/assimilate` gate, SEC tickets and corpus in the standalone version | `/assimilate` and the kanban do not ship standalone | Not planned |
| A single-file bundle of the skill | The skill reads separate checklist and baseline files | Not planned |

## Assumptions & Dependencies

These assumptions and dependencies carry forward from the research note and the grill session.

| ID | Assumption | Status | If false | Owner |
|----|-----------|--------|----------|-------|
| ASM-001 | A tool-less subagent receiving delimited text resists instruction hijack well enough for an advisory verdict | Unvalidated | EVL-001 fails PRD-004.7 samples, and the isolation design is revisited | Forge maintainer |
| ASM-002 | OWASP AST10 keeps its 10 risk identifiers stable through its v1.0 release | Unvalidated | Mappings are reissued and EVL-001 is re-run under PRD-005.4 | Forge maintainer |
| ASM-003 | Copilot Chat honours a prompt directing it not to search work data | Unvalidated | PRD-011.5 fails, and the Copilot version is withdrawn or relabelled | Forge maintainer |

| ID | Depends on | Type | Owner | Needed by | Status |
|----|-----------|------|-------|-----------|--------|
| DEP-001 | OWASP Agentic Skills Top 10 published risk list | External | OWASP project | Task #3 | Met (draft) |
| DEP-002 | Host support for subagents with no tools and a chosen model tier | External | Anthropic | Task #4 | Open |

## Further Notes

The grill session on 2026-11-10 settled 15 design decisions, recorded in the session transcript. Registers and reports are planned for a user-level folder outside every git repository, shared by the Forge and standalone versions.

The `Priority` value of P3 Normal is a placeholder for the maintainer to confirm. No BRD exists, so every story traces to the research note and the grill session. No operational tolerance was found that needed routing to a BRD.

New terms for the glossary: trust register, lethal trifecta, capability mismatch and fail-closed verdict. No `/prototype` exists for this feature.

## References

Each source cited in this PRD is listed below.

| Cited as | Full citation | Type |
|---|---|---|
| ISO/IEC/IEEE 29148:2018 | ISO/IEC/IEEE (2018) *ISO/IEC/IEEE 29148:2018 Systems and software engineering — Life cycle processes — Requirements engineering*, International Organization for Standardization, Geneva | Standard |
| Liu et al. 2026 | Liu et al. (2026) *Empirical study of malicious agent skills*, arXiv 2602.06547v2, accessed 10 November 2026 | Report |
| OWASP AST10 | OWASP (2026) *OWASP Agentic Skills Top 10*, incubator project, owasp.org/www-project-agentic-skills-top-10, accessed 10 November 2026 | Webpage |
| OWASP Agentic Applications 2026 | OWASP GenAI Security Project (2025) *OWASP Top 10 for Agentic Applications for 2026*, genai.owasp.org, accessed 10 November 2026 | Webpage |
| Skill security research note | Forge (2026) *Research: Security Auditing of Agent Skills*, docs/research/skill-security-audit.md | Internal record |
| Snyk 2026 | Tal L (2026) *Why your "skill scanner" is just false security (and maybe malware)*, Snyk, snyk.io/blog/skill-scanner-false-security, accessed 10 November 2026 | Webpage |

## Appendix: Traceability Matrix ★

The matrix links each story to its source. No BRD exists, so every story traces to a proximate source.

| BRD Objective | Business Req | Proximate Source | PRD Req ID | Acceptance Criteria (summary) | Test | SOAP Ref |
|---------------|--------------|------------------|------------|-------------------------------|------|----------|
| — | — | Research note § Recommendation 1, 4 · grill Q1, Q8, Q9 | PRD-001 | One recommendation, no execution, approved download, fail-closed result | TC-011–TC-017 | TBD |
| — | — | Research note § Recommendation 1 · grill Q1, Q10 | PRD-002 | Every skill listed, intent review on changed skills only | TC-018–TC-021 | TBD |
| — | — | Research note § Findings 3B · grill Q4 | PRD-003 | Purpose compared with capability, trifecta and config writes flagged | TC-022–TC-024 | TBD |
| — | — | Research note § Findings 3C · grill Q3, Q10 | PRD-004 | Tool-less reviewer, fixed format, tier routing, injection flagged | TC-025–TC-030 | TBD |
| — | — | Research note § Findings 2 | PRD-005 | AST10 identifier and severity on every finding | TC-031–TC-033 | TBD |
| — | — | Research note § Findings 3D · grill Q2, Q11 | PRD-006 | Fingerprint records, re-review on change, overrides logged | TC-034–TC-038 | TBD |
| — | — | Research note § Findings 3A · grill Q11 | PRD-007 | Exceptions lower severity, never hide, baseline kept | TC-039–TC-042 | TBD |
| — | — | Research note § Findings 4 · grill Q2 | PRD-008 | `/assimilate` halts on Critical, High or Incomplete without `CONFIRM` | TC-043–TC-046 | TBD |
| — | — | Research note § Recommendation 6 · grill Q11 | PRD-009 | Reports outside git, SEC tickets on approval | TC-047–TC-049, TC-055 | TBD |
| — | — | Research note § Recommendation 8 · grill Q5, Q14 | PRD-010 | Held-out EVL-001, no Allow on malicious samples, never loadable | TC-050–TC-054 | TBD |
| — | — | Grill Q6, Q7, Q15 | PRD-011 | Fixed format, "Indicative" label, no links, no work search | TC-056–TC-057 | TBD |
