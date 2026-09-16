---
name: idea-ai-stages
description: Stage detail, registers and enums for idea-ai — the twenty-three stages behind the six phases, plus the failure-mode table and final consistency check. Read when running a Full Review, or when a phase's completion criterion needs its stage-level definition.
---

# Stage Detail

The twenty-three stages behind the six phases in [SKILL.md](SKILL.md). Each phase's completion criterion is met when its stages are worked; this file holds the registers, enums and challenges each one uses.

---

## Phase 1 — Frame

### Stage 1: Capture and Normalise

Capture the idea title, proposer, business area, affected users and recipients, current process, proposed AI capability, proposed platform, evidence supplied, review mode and review date.

Register the idea in the idea registry via `/idea` where one is configured. Where none is available, use `AI-IDEA-UNREGISTERED`. Never claim registration unless the registry was successfully updated.

Rewrite the submission into four distinct statements:

```text
Problem     [User or stakeholder] experiences [observable problem] when [situation],
            resulting in [evidenced consequence].

Outcome     The desired outcome is [business or operational result], measured by
            [measure], without [important constraint or unacceptable consequence].

Hypothesis  If [proposed AI capability] uses [identified information] to perform
            [bounded task], then [user] achieves [outcome], subject to
            [material conditions].
```

Classify the **AI role** as one or more of: Retrieve · Extract · Summarise · Generate · Classify · Recommend · Predict · Detect anomalies · Orchestrate workflow · Take action · Make or materially influence a decision.

### Stage 2: Existing Capability Review

Check whether the requirement is already met by an approved enterprise capability, a current business-unit capability, an active or completed pilot, an existing AI register or governance record, a reusable platform service or evaluation asset, conventional automation, or related work in another business area.

Assess material overlap in problem, users, inputs, processing, output, integration and intended benefit. Assign one finding:

**Reuse Candidate** · **Extension Candidate** · **Capability Gap** · **Potential Duplicate** · **No Match Identified** · **Unknown**

Never call an idea a duplicate merely because another use case runs on the same product.

---

## Phase 2 — Evidence

### Stage 3: Evidence Register

Build the register before any finding or score.

| Evidence ID | Claim | Supplied Evidence | Source | Status |
|---|---|---|---|---|
| EVD-01 | | | | Confirmed / Partially Supported / Unvalidated / Contradicted |

Acceptable evidence includes approved process documentation, operational reports, system records, case samples, volume data, time observations, quality reviews, stakeholder feedback, audit findings, platform documentation, architecture confirmation, SME confirmation and pilot results.

Challenge every unqualified claim — *time-consuming, manual, inconsistent, inaccurate, delayed, high volume, costly, complex, poor customer experience, increased handling time, improved productivity, reduced risk.*

### Stage 4: Problem and Current-State Validation

Establish **problem specificity** (what happens today, at which workflow step, under what trigger, which service or transaction is affected, where the boundary sits), **affected parties** (who performs the work, who receives the outcome, who absorbs delay or error, whether customers, partners, employees, suppliers or field workers are affected), and the **current process** (trigger, inputs, manual steps, decisions, systems, output, approver, exception routes, rework loops, escalations).

Separate current pain into active effort, elapsed time, delay, variability, rework, defects, avoidable contacts, operational risk, customer impact and regulatory or contractual exposure.

Apply the challenge: **would the problem still exist if the proposed AI product were removed from the idea statement?**

Assign one problem finding: **Demonstrated** · **Partially demonstrated** · **Plausible but unvalidated** · **Not demonstrated** · **Requires reframing**

### Stage 5: Baseline and Volumetrics

Capture the smallest useful baseline.

| Measure | Current Value | Scope | Period | Source | Confidence |
|---|---:|---|---|---|---|
| Case or transaction volume | | | | | |
| Eligible volume | | | | | |
| Average active effort | | | | | |
| Average elapsed time | | | | | |
| First-pass quality | | | | | |
| Rework rate | | | | | |
| Exception rate | | | | | |
| Error, complaint or escalation rate | | | | | |

For drafting and summarisation, count time spent locating information, reading, drafting, checking, materially rewriting and handling exceptions. For each metric, determine whether it is observable from existing data or needs a measurement exercise.

### Stage 6: Outcome and Benefit Realisation

Assess benefits by category: operational efficiency · cycle-time reduction · quality and consistency · customer or partner experience · employee experience · compliance · risk reduction · decision support · knowledge reuse · reduced rework · released capacity.

| Benefit | Measure | Baseline | Target | Basis | Benefit Owner |
|---|---|---:|---:|---|---|

Test whether the benefit is observable; the baseline is known; the target has a basis; the AI contribution is separable from other changes; work is removed rather than shifted downstream; review effort offsets generation savings; eligible volume makes the benefit material; an accountable owner tracks realisation; and double counting with other initiatives is avoided.

Assign benefit confidence: **High** · **Medium** · **Low** · **Not established** · **Not measurable in current form**

---

## Phase 3 — Fit

### Stage 7: AI Suitability and Alternatives

Compare at least these patterns:

| Option | Description |
|---|---|
| No change | Retain the current process |
| Process or template improvement | Simplify work without automation |
| Structured data or knowledge improvement | Improve capture, search or guidance |
| Rules or workflow automation | Use deterministic logic |
| AI-assisted workflow | Generate or analyse with human review |
| Hybrid | Combine rules, retrieval and AI |

**Supporting AI:** dispersed unstructured information, variable case context, natural-language synthesis, bounded judgement support, output that can be independently evaluated.

**Limiting AI:** deterministic requirements, unreliable source data, a need for perfect reproducibility, unsupported inference, unavailable reviewers, unacceptable error consequences, unstable processes, and AI used to mask poor data capture.

Assign AI suitability: **Strong** · **Moderate** · **Weak** · **Not established** · **AI not recommended**

### Stage 8: Scope and Boundaries

**In scope** — users, channels, case or transaction types, triggers, source data, output, language, approval step, initial cohort.

**Out of scope** — consider complaints, compensation, liability, safety events, security or privacy incidents, regulatory correspondence, legal disputes, contradictory status, missing mandatory information, high-risk impact, unsupported products, autonomous sending or closure.

**Entry conditions** — what must be true before the AI runs. **Exit conditions** — when output is complete, reviewed, approved, discarded or escalated. **Stop conditions** — when the AI refuses, defers, warns or routes to the manual process.

---

## Phase 4 — Feasibility

### Stage 9: Data Readiness and Source Authority

| Data Source | Required Information | Structured? | Owner | Access Confirmed? | Quality Known? | Classification | Freshness Need | Evidence |
|---|---|---|---|---|---|---|---|---|

Assess availability, history, access, role restrictions, integration, completeness, consistency, timestamps, duplicates, superseded content, quality, ownership, classification, minimisation, retention and lineage.

Build a source authority model:

| Business Fact | Primary Source | Secondary Source | Conflict Rule |
|---|---|---|---|
| Status | | | |
| Resolution outcome | | | |
| Cause | | | |
| Customer impact | | | |
| Action completed | | | |
| Timestamp | | | |

For conflicts, choose one approved behaviour: refuse generation · flag the conflict · present both values · apply an approved precedence rule · route to manual assessment. **Never let the generative model invent source precedence.**

Assign data readiness: **Ready** · **Partially ready** · **Unknown** · **Not ready** · **Blocked**

### Stage 10: Platform, Architecture and Prompt Governance

| Question | Status | Evidence or Required Owner |
|---|---|---|
| Is the platform approved? | | |
| Is the capability licensed and enabled? | | |
| Can it access every required source? | | |
| Can it honour existing access controls? | | |
| Can it run at the required workflow point? | | |
| Can instructions and templates be governed? | | |
| Can output, edits and approval be logged? | | |
| Can performance and defects be monitored? | | |
| Can the capability be disabled or rolled back? | | |
| Are integration changes required? | | |
| Is non-production testing available? | | |
| Is operational support defined? | | |

For generative AI, also define the prompt owner, approved purpose, versioning, test and approval process, change and release control, rollback, **separation of trusted instructions from untrusted source text**, prompt and response logging, and review cadence.

Where a specific model or provider is named, record it as `[MDL-TBD — <component, provider, model and version>]` for `/write-ord` to resolve into an `MDL-NNN` row. See `~/.claude/rules/requirements/ai.md` § *Model dependency* for the register's columns — pinning, deprecation notice, fallback behaviour and re-evaluation trigger.

Assign platform feasibility: **Confirmed** · **Plausible** · **Unknown** · **Material constraint identified** · **Not supported by current evidence**

### Stage 11: Governance and AI Register Triage

Assess the **use case** separately from the underlying **AI system or model**. Capture any existing AI register or governance record, existing use-case assessment, existing system or model assessment, whether this is a new use case on an existing platform or a new agent, model, assistant or automation, use of business, customer, employee or operational data, support for decisions, external-facing content, consequences of error, transparency and explainability needs, human accountability, and privacy, security, legal, regulatory and data-governance relevance.

| Area | Screen | Notes |
|---|---|---|
| Accountability | Clear / Gap / Unknown | |
| Transparency | Clear / Gap / Unknown | |
| Explainability | Clear / Gap / Unknown | |
| Fairness or bias | Relevant / Low relevance / Unknown | |
| Privacy | Relevant / Low relevance / Unknown | |
| Security | Relevant / Low relevance / Unknown | |
| Customer impact | Relevant / Low relevance / Unknown | |
| Operational impact | Relevant / Low relevance / Unknown | |
| Auditability | Clear / Gap / Unknown | |
| Human oversight | Clear / Gap / Unknown | |
| Monitoring | Clear / Gap / Unknown | |

Assign one governance finding: **Formal governance engagement indicated** · **Governance applicability requires confirmation** · **Existing approval may apply, subject to confirmation** · **Insufficient information to determine**

Where a regulatory regime is in play, name which one applies and why. `~/.claude/rules/requirements/ai.md` § *Australian adoptions and instruments* records that a purely domestic Australian system carries no mandatory AI-specific requirement classes — never import the EU AI Act's classes by default.

### Stage 12: Operational Ownership

| Area | Accountable Role | Status | Evidence or Gap |
|---|---|---|---|
| Business outcome | | | |
| Use-case or product ownership | | | |
| Platform | | | |
| Data | | | |
| Prompt or configuration | | | |
| Operational process | | | |
| Quality monitoring | | | |
| Defect triage | | | |
| User feedback | | | |
| Incident management | | | |
| Reporting | | | |
| Access management | | | |
| Change control | | | |
| Support | | | |
| Suspension | | | |
| Retirement and decommissioning | | | |

Prefer roles to individual names. Mark unknown ownership as a readiness gap. Assign ownership maturity: **Defined** · **Partially defined** · **Undefined**

---

## Phase 5 — Control

### Stage 13: Pilot and Confidence Controls

Assess whether a bounded pilot can be established with eligible users and volume, representative cases, historical or live evaluation, a comparison method, success measures, stop criteria, rollback, incident handling, audit access, feedback capture and an exit decision.

Treat confidence as an operational control only where it is meaningful, calibrated, understandable and tied to an approved behaviour:

```text
Invalid or ineligible case      -> Do not generate; continue through the existing process.
Mandatory information missing   -> Identify the gap; do not produce a complete outcome.
Sources conflict                -> Flag the conflict; require manual assessment.
Draft produced                  -> Present with supporting context for human review.
Validated confidence threshold  -> Apply only the approved confidence-dependent behaviour.
```

**Never invent a confidence threshold.** Where confidence cannot be calibrated, design controls around observable eligibility, missing data, source conflicts and human verification instead.

Assign pilot readiness: **Ready for pilot design** · **Partially ready** · **Not ready** · **Not applicable at current stage**

### Stage 14: Output Contract

Define output type and audience, required structure, mandatory fields, permitted and prohibited content, approved terminology and tone, maximum length, source attribution, uncertainty handling, missing-data handling, contradiction handling, escalation wording, editing and approval requirements, and release or send control.

```text
The AI must:
- use only approved sources available in the current case context;
- distinguish confirmed facts from pending or uncertain information;
- include mandatory identifiers and approved status wording;
- identify missing or conflicting information;
- produce only the approved type of output;
- require the defined review and approval before release.

The AI must not:
- invent causes, actions, outcomes, identities, commitments or timestamps;
- state an outcome that is not confirmed by the authoritative source;
- expose internal-only content to an external recipient;
- make contractual, compensation, liability or regulatory commitments;
- autonomously send, close or act unless that action is separately assessed and approved.
```

A tester judges an output against this contract without relying on subjective preference.

### Stage 15: Quality Evaluation and Monitoring

Specify an evaluation set covering representative standard cases, complex and long histories, missing-data cases, contradictory-data cases, reopened or superseded cases, incorrect structured codes, sensitive or internal-only notes, and cases where generation must be refused or escalated.

**The evaluation-set schema lives in `~/.claude/rules/requirements/ai.md` § *Evaluation set register*.** Read it rather than restating it — it mandates the scorer (including the calibration set, agreement statistic and minimum for an LLM-judge), the threshold, the **floor** on the worst single case, the prohibited-output row IDs, the re-run trigger and the owner. Two of its rules bind every review:

- **A threshold measured on training data is not a threshold** — every set is held out from whatever tuned the component.
- **A categorical prohibition is never scored.** An output unacceptable at *any* rate — a leaked secret, an unauthorised commitment, a protected-attribute inference — is a zero-tolerance row of its own, not a low score to be averaged.

Write `[EVL-TBD — <what must be measured, and on what>]`; `/write-ord` mints the `EVL-NNN`.

Evaluate the relevant dimensions: factual accuracy · source faithfulness · completeness · currency · consistency · relevance · clarity · approved terminology · tone · safe uncertainty handling · privacy and policy compliance · edit effort · user usefulness.

Classify defects:

- **Critical** — could cause material customer, operational, safety, legal, privacy, contractual or regulatory harm.
- **Major** — materially incorrect, incomplete or misleading, requiring significant correction.
- **Minor** — wording or formatting that does not alter material meaning.
- **Cosmetic** — presentation preference only.

| Measure | Definition | Baseline | Target | Method |
|---|---|---:|---:|---|
| Draft acceptance rate | Approved without material edit | | | |
| Major defect rate | Outputs with at least one major defect | | | |
| Critical defect rate | Outputs with at least one critical defect | | | |
| Review effort | Active time checking and editing | | | |
| Total handling time | End-to-end active effort | | | |
| Coverage | Eligible cases where output can be produced | | | |
| Escalation precision | Correct identification of manual cases | | | |

Define ongoing monitoring for user overrides, refusals, defects, escalations, source changes, prompt or configuration changes, performance degradation and benefit realisation. **Every alert names its runbook** — an alert with no documented response is observability, not a control.

### Stage 16: Failure Modes and Controls

| ID | Failure Mode | Cause | Potential Outcome | Preventive Control | Detective Control | Fallback | Owner |
|---|---|---|---|---|---|---|---|
| FM-01 | | | | | | | |

Consider only the relevant modes: missing or stale data · conflicting sources · incorrect structured status · unsupported conclusion · internal-only or sensitive information disclosed · superseded notes used · wrong audience or case context · hallucination · mandatory wording omitted · excluded case processed · escalation not triggered · automation bias · platform outage · integration failure · source-schema change · performance degradation · prompt injection through untrusted source text.

**Human review alone is not a control description.** State what the reviewer verifies, what evidence is visible to them, and what happens when the check fails.

---

## Phase 6 — Decide

### Stage 17: Delivery, Change and Reuse Readiness

**Process readiness** — the current process is documented, the target process agreed, exceptions known, the process stable, and procedures updatable.

**Delivery readiness** — business ownership, platform ownership, SMEs, test environment, representative dataset, testable acceptance criteria, integration path, governance gates, delivery dependencies.

**Change readiness** — user impact, training, retained accountability, trust calibration, feedback, adoption, procedure changes, operational knowledge retention.

**Reuse potential** — classify as a reusable pattern, shared integration, common evaluation asset, specialised use case or point solution. Never force reuse where specialised controls are justified.

### Stage 18: Dependencies

Classify as business, process, data, platform, architecture, integration, security, privacy, Responsible AI, legal, regulatory, operational, workforce, procurement, licensing, vendor, change or measurement.

| Dependency | Why Required | Owner | Status | Blocking? | Evidence |
|---|---|---|---|---|---|
| DEP-01 | | | Confirmed / Unvalidated / Blocked | Yes / No | |

### Stage 19: Findings and Assumptions

Number findings so an insertion never forces renumbering — `FND-01`, `FND-02`, `FND-02A`, `FND-02B`.

| Field | Required Content |
|---|---|
| Finding ID | FND-NN |
| Type | Strength / Gap / Constraint / Risk / Duplication / Opportunity |
| Finding | Neutral statement |
| Evidence | `EVD-NN` IDs or supplied artefacts |
| Significance | Why it matters |
| Confidence | High / Medium / Low |

Record assumptions separately, using the `ASM-NNN` prefix from `~/.claude/rules/requirements/tables.md`:

| ID | Assumption | Area | Status | Validation Method | Owner | Decision Impact |
|---|---|---|---|---|---|---|
| ASM-01 | | | Unvalidated / Confirmed / Invalidated | | | |

Areas: problem · baseline · benefit · scope · data · platform · integration · output quality · user behaviour · governance · delivery · adoption.

A falsified assumption has no home in RAID's four quadrants — raise it via `/raid add risk` and record the `R-NNN` in its decision-impact cell.

### Stage 20: Acceptance-Criteria Review

Review supplied criteria across functional behaviour · eligibility and scope · data availability and authority · source conflicts · output quality · human review and approval · safety and exception handling · security and privacy · auditability · operational monitoring · benefit validation · rollback and suspension.

Convert vague statements into testable **proposed** criteria in the declarative present with no modals, per `~/.claude/rules/requirements/language.md`. `/write-ac` owns the `AC-NNN` namespace, so write `[AC-TBD — <behaviour>]`:

```text
[AC-TBD — eligible case generation]

Given a case meets the approved eligibility conditions
And all mandatory source fields are available
When an authorised user requests a draft
Then the approved output is generated using only permitted sources
And the output and its supporting context are presented for review
And the outcome is neither sent nor applied automatically.
```

Cover the happy path, exclusions, evidence, quality, control, failure, monitoring and benefit validation. A proposal whose criteria are all sunny-day has been specified for the demo — and for a generated-behaviour component, the sunny day is the path the vendor already demonstrated.

### Stage 21: Assessment and Maturity

Assess each dimension separately. **Never hide a blocker inside an average.**

| Dimension | Values |
|---|---|
| Impact | High / Medium / Low |
| Effort | High / Medium / Low / Not estimable |
| Risk | High / Medium / Low / Requires specialist assessment |
| Evidence confidence | High / Medium / Low |
| Benefit confidence | High / Medium / Low / Not established |
| AI suitability | Strong / Moderate / Weak / Not established / Not recommended |
| Process readiness | High / Medium / Low |
| Data readiness | Ready / Partially ready / Unknown / Not ready / Blocked |
| Platform fit | Confirmed / Plausible / Unknown / Constrained / Unsupported |
| Governance readiness | High / Medium / Low / Requires triage |
| Operational readiness | High / Medium / Low |
| Pilot readiness | Ready / Partial / Not ready / Not applicable |

**Maturity** — **Exploratory** (initial concept, substantial unknowns) · **Emerging** (problem plausible, becoming defined) · **Discovery Ready** (sufficient problem evidence for structured discovery) · **PoC Ready** (a bounded technical, data or quality hypothesis can be tested) · **Pilot Ready** (controlled live validation sufficiently defined) · **Production Candidate** (ownership, controls, monitoring and support established for formal approval consideration).

**Maturity is not approval.**

Optional scoring uses 0–3 — 0 absent, contradicted or materially unsuitable; 1 weak or largely unvalidated; 2 plausible with manageable gaps; 3 supported and sufficiently defined for the current stage. Score only where it helps, report the evidence beside each score, and never convert totals to percentages.

### Stage 22: Disposition and Next Gates

Recommend **one** primary disposition, plus any mandatory gates alongside it.

| Disposition | Use when |
|---|---|
| **Progress to Discovery** | The problem is credible, AI suitability plausible, no known blocker makes it untenable, and bounded discovery resolves the material questions |
| **Progress to Controlled Proof of Concept** | The use case is bounded, representative data available, evaluation criteria definable, and controlled testing best resolves the uncertainty |
| **Progress to Pilot Assessment** | PoC evidence is sufficient and the live cohort, controls, monitoring, ownership, stop criteria and rollback can be assessed |
| **Needs Problem Validation** | Problem, volume or impact is insufficiently evidenced |
| **Needs Existing Capability Review** | Reuse or duplication is unresolved |
| **Needs Data Feasibility Assessment** | Source availability, access, authority, quality, ownership or lineage is uncertain |
| **Needs Platform or Architecture Confirmation** | Capability, licensing, integration or runtime design is unconfirmed |
| **Needs Governance Triage** | Formal Responsible AI, privacy, security, legal or data review may be required before progression |
| **Needs Operational Ownership** | BAU accountability, monitoring, support, suspension or retirement is undefined |
| **Redirect to Non-AI Solution** | Process improvement, structured capture, rules, search or conventional automation fits better |
| **Hold** | The idea has potential but a material dependency must resolve first |
| **Do Not Progress in Current Form** | The problem is not demonstrated, the use case is materially unsafe without credible controls, required data is unavailable, AI is unsuitable, duplication is unresolved, or the proposal is too broad to assess |

Then stop at the HITL disposition gate in [SKILL.md](SKILL.md). The disposition is a recommendation; only the authorised decision-maker records a portfolio decision.

### Stage 23: Prioritised Discovery Actions

| Priority | Action | Question Resolved | Required Evidence | Suggested Owner |
|---:|---|---|---|---|
| 1 | | | | |

Order by decision value, not by review-section order: the first five are those most likely to change disposition, scope, benefit confidence or risk. Secondary questions come after them.

---

## Failure Modes

| Condition | Required behaviour |
|---|---|
| Idea contains only a technology | Reconstruct the underlying problem and mark it unvalidated |
| Benefit is vague | Propose an observable measure and retain the benefit as unvalidated |
| Existing capability check is incomplete | Use `Unknown` or `Needs Existing Capability Review` |
| Platform is named without evidence | Mark platform fit `Unknown` |
| Data sources are named but access is unknown | Mark access unvalidated |
| Sources may disagree | Require a source authority model and a conflict fallback |
| Output is external-facing | Require an output contract, explicit review, release control and quality evaluation |
| AI sends, closes or acts autonomously | Elevate risk and require explicit governance and control assessment |
| Human review lacks a defined task | Mark oversight as insufficiently specified |
| Baseline is unavailable | Define a measurement action before any benefit commitment |
| Representative cases are unavailable | Require an evaluation set before PoC or pilot readiness |
| Deterministic rules appear sufficient | Assess a rules-based or hybrid option |
| Acceptance criteria cover only the happy path | Add eligibility, source, exception, control, monitoring and rollback criteria |
| Confidence thresholds proposed without calibration | Remove the number and define validation first |
| Cost, schedule or effort lacks design evidence | Use `Not estimable` |
| Governance applicability is uncertain | Recommend governance triage without implying its outcome |
| Ownership is incomplete | Set a mandatory ownership gate before pilot or production progression |
| Idea is too broad | Define a bounded first use case, its exclusions and its stop conditions |
| Critical evidence is missing | Issue a conditional assessment with a prioritised validation plan |

## Final Consistency Check

Verify before completing any review:

1. The original submission is preserved.
2. The problem does not depend on solution wording.
3. Existing capability and non-AI alternatives were tested.
4. Every material claim is evidenced or marked unvalidated.
5. Benefits connect baseline, target, basis and owner.
6. Required facts have source authority and conflict handling.
7. Platform capability is not overstated.
8. Governance status is not presented as approval.
9. Human accountability is operationally defined.
10. Pilot scope, measures, stop criteria and rollback are visible where relevant.
11. Findings are traceable and assumptions carry validation methods.
12. Maturity matches the available evidence.
13. The disposition follows from evidence, blockers and readiness.
14. The top five discovery actions are those most likely to change the decision.
15. No ID was minted from a namespace `~/.claude/rules/requirements/tables.md` assigns to another skill.
