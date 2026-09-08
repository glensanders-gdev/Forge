# write-ord Reference

ISO/IEC 25010:2023 taxonomy and ORD template used by SKILL.md, plus the **ISO/IEC 25059:2023**
sub-characteristics that extend it where a delivered component's behaviour is learned or generated
rather than specified.

---

## ISO/IEC 25010:2023 Quality Characteristics

Nine top-level characteristics. Map every non-functional requirement to one sub-characteristic before writing the ORD.

### 1. Functional Suitability
Does the system do the right things?
- **Functional Completeness** — all specified tasks covered
- **Functional Correctness** — accurate results with required precision
- **Functional Appropriateness** — functions align with user goals

*ORD relevance:* operational scope, what the system must do in production (not how it is built).

### 2. Performance Efficiency
Does the system perform its functions within required time, throughput, and resource constraints?
- **Time Behavior** — response and processing times, throughput rates *(highest ORD priority)*
- **Resource Utilization** — CPU, memory, storage, network, energy usage
- **Capacity** — maximum concurrent users, peak transaction volumes, data volume limits

*ORD relevance:* quantified thresholds required. "Fast" is not a requirement.

### 3. Compatibility
Can the system exchange information and coexist with other systems?
- **Coexistence** — operates without harming other systems sharing the environment
- **Interoperability** — exchanges information with specified external systems per defined protocols

*ORD relevance:* interface table, protocol standards, failure behavior on integration errors.

### 4. Interaction Capability *(formerly Usability — 2011)*
Can specified users operate the system to achieve their goals?
- **Appropriateness Recognizability** — users can identify if the system fits their needs
- **Learnability** — users can learn to operate it within a specified timeframe
- **Operability** — easy to operate and control
- **User Engagement** — features encourage continued use *(replaced UI Aesthetics)*
- **Accessibility** — usable by people with the widest range of characteristics
- **Inclusivity** — designed for diverse abilities and backgrounds *(NEW in 2023)*
- **Self-Descriptiveness** — system communicates how to use it correctly *(NEW in 2023)*

*ORD relevance:* operator training requirements, accessibility compliance (WCAG 2.2 AA), self-service capability.

### 5. Reliability
Does the system perform its functions without failure over a specified period under specified conditions?
- **Faultlessness** — degree to which the system is free from faults *(replaced Maturity — 2023)*
- **Availability** — system is operational and accessible when required
- **Fault Tolerance** — maintains operation despite hardware or software faults
- **Recoverability** — restores data and operations following interruption or failure

*ORD relevance:* uptime targets, MTBF, MTTR, RTO, RPO, degraded-mode requirements. KPP candidates live here.

### 6. Security
Does the system protect information and data with appropriate access controls?
- **Confidentiality** — data accessible only to authorized parties
- **Integrity** — state and data protected from unauthorized modification or deletion
- **Non-repudiation** — actions can be proven to have taken place
- **Accountability** — actions traceable to the entity that performed them
- **Authenticity** — identity of subjects and resources can be verified
- **Resistance** — system sustains operations under attack *(NEW in 2023)*

*ORD relevance:* compliance frameworks (FedRAMP, HIPAA, ISO 27001, PCI-DSS), encryption standards, penetration test thresholds, access control model.

### 7. Maintainability
Can the system be effectively and efficiently modified without degrading quality?
- **Modularity** — change to one component has minimal impact on others
- **Reusability** — components can be used across products or contexts
- **Analyzability** — impact of intended changes can be assessed
- **Modifiability** — changes can be made without introducing defects

*ORD relevance:* patch management cadence, configuration management, change window requirements, version control obligations.

### 8. Flexibility *(formerly Portability — 2011)*
Can the system operate effectively in contexts not originally specified?
- **Adaptability** — adapts to different or evolving hardware, software, and usage environments
- **Installability** — can be successfully installed/uninstalled in specified environments
- **Replaceability** — can replace another specified product for the same purpose
- **Scalability** — handles growing or shrinking workloads; elastic capacity *(NEW in 2023)*

*ORD relevance:* cloud hosting model, elasticity requirements, multi-region or multi-tenancy, upgrade and rollback procedures.

### 9. Safety *(NEW top-level characteristic — 2023)*
Does the system protect against risk of injury or harm to people, property, or the environment?
- **Operational Constraint** — operational constraints prevent hazardous situations
- **Risk Identification** — hazardous situations and conditions are identified
- **Fail Safe** — system reaches a safe state on failure
- **Hazard Warning** — timely, effective warnings about hazards are provided
- **Safe Integration** — safe integration with other systems

*ORD relevance:* applicable to safety-critical systems (healthcare, infrastructure, industrial control). If not applicable, note explicitly.

---

## ISO/IEC 25059:2023 — AI Extension *(conditional)*

**Applies only where the trigger test in `ai.md` fires** — a delivered
component whose output for a given input is not fully determined by written logic. 25059 sits inside
the same SQuaRE series as 25010 and **extends it**: it adds the sub-characteristics below and
inherits everything above unchanged. It is not a replacement taxonomy and does not restructure §3.

| Added sub-characteristic | Extends | Covers |
|---|---|---|
| **Functional Adaptability** | 1. Functional Suitability | Behaviour holding as data, context or usage shifts from what the component was tuned on |
| **Robustness** | 5. Reliability | Behaviour under out-of-distribution, adversarial or malformed input |
| **User Controllability** | 6. Interaction Capability | The operator's ability to direct, constrain or halt the component |
| **Intervenability** | 6. Interaction Capability | A named human's authority to override an output, and the point at which they can |
| **Transparency** | 6. Interaction Capability | Output labelling, explanation of a decision, disclosure that a component is AI |

*ORD relevance:* every one of these needs a threshold on a named held-out `EVL-NNN` evaluation set,
a floor, and a review hook — see `ai.md` § *The evaluative criterion*. Accuracy
and fairness are **not** new sub-characteristics: they are Functional Correctness measured the AI
way, which is why they sit under §3.8 in the template below rather than here.

**Watch item (ADR-0003):** the 25059 second edition awaits member-body vote. Its AI *service*
quality model — traceability, service adaptability, customizability — is the part most relevant to
AI consumed as a service. Re-check before treating this patch as stable.

---

## 2011 vs 2023 Quick Reference

| Changed | 2011 | 2023 |
|---|---|---|
| Top-level count | 8 | 9 |
| New characteristic | — | Safety |
| Renamed | Usability | Interaction Capability |
| Renamed | Portability | Flexibility |
| New sub-characteristics | — | Inclusivity, Self-Descriptiveness, Resistance, Scalability |
| Replaced sub-characteristic | Maturity | Faultlessness |
| Replaced sub-characteristic | UI Aesthetics | User Engagement |

---

## Demand-side scope — what this ORD is, and is not

**The ORD states quantified business demand. It never states the technical target that satisfies
it.** See `language.md` § *Demand, not design*. The ORD precedes
solutioning: architecture, security, operations and service management sit **downstream** and
answer this document. They do not contribute to it.

This has a direct structural consequence. Sections inherited from the DoD/DHS acquisition ORD —
where the document covered an entire physical system entering service — are not part of a
25010-anchored ORD covering process and system change.

| Classic section | Treatment |
|---|---|
| Staffing and organisational requirements | **Out of scope** — §6 is numbered and left empty |
| Infrastructure and facilities | **Out of scope** — §8 is numbered and left empty |
| Support model (tiers, FTE, rosters) | **Out of scope.** The operating model is the design response's to specify |
| Supportability of the system | **In scope**, under Maintainability — what must be observable, diagnosable and recoverable, and what a support function resolves without engineering |
| Operational hours and escalation expectations | **In scope**, as business demand — the tolerance, never the roster |

**§6 and §8 are numbered and left empty on purpose.** Renumbering around them would break every
existing §-reference, and a declared gap is visible where a silent omission is not — the same rule
applied to the nine characteristics. Content that genuinely falls there goes to the referred
requirements register (Appendix C), never to silent omission.

---

## Requirement status taxonomy

**Scope never varies. Maturity does.** All nine ISO/IEC 25010:2023 characteristics appear in every
ORD. A characteristic with nothing to state carries an explicit statement of that fact, never an
omission. Status describes the maturity of a **business demand statement**, not of a technical
threshold — the ORD carries no technical thresholds.

| Status | Definition | Evidence required |
|---|---|---|
| **Committed** | The business owner has stated and agreed the tolerance, and it traces to an obligation, contract, incident record or explicit business decision | Owner name, date, forum, and the underlying source |
| **Provisional** | The tolerance derives from something real — an existing SLA, contract, incident history, an analogous service — but no business owner has confirmed it applies here | Source citation |
| **Assumed** | No business owner and no documentary source; the figure is a stated assumption | An `ASM-NNN` row that is testable, with a named owner, a confirm-by date, and the consequence if wrong |

**The document tier is the weakest status carried by any KPP-bearing requirement** — the KPPs
themselves, and the recovery, availability and capacity demands they depend on. A minor attribute at
`Assumed` does not set the tier; a KPP at `Assumed` does.

**An `Assumed` entry without an owner and a confirm-by date is not an assumption — it is an invented
number**, and it is the largest audit exposure an ORD carries. ISO/IEC/IEEE 29148:2018 requires
traceability, not finality: a TBD with an owner and a date conforms; a silent gap does not.

---

## Key Performance Parameters

A KPP is a requirement whose failure means the capability is **unfit for purpose**, not merely
degraded. State it as a **business-failure threshold** — the point at which the business consequence
becomes unacceptable, and what makes it unacceptable: a breached obligation, a contractual penalty,
an unrecoverable customer impact. That is what makes a KPP sourceable from contracts and incident
history rather than requiring an engineer.

**Every KPP carries threshold and objective as two labelled values** — the minimum acceptable and
the desired — inside its `Business Tolerance`. Collapsing *"restorable within one business day /
within four hours"* to a single figure is the most common way KPP intent is lost, and it happens
silently downstream after the author's involvement has ended.

Typical KPP candidates:

- The core business outcome cannot be produced at all.
- Populations cannot be reconciled.
- Results cannot be reproduced or audited.
- Records are duplicated or silently omitted.
- The change produces an unauthorised effect on existing customer, SLA or financial treatment.

**Not every Must is a KPP.** MoSCoW, `KPP` and `Status` are three orthogonal axes — see
`tables.md`. A KPP that cannot reach at least `Provisional` inside the
window is the one item warranting escalation rather than quiet degradation.

---

## Elicitation lenses

Phase 1 analysis aids. **A lens finds a question, never an answer.** Every lens output is one of the
six governed forms below and nothing else — a lens that surfaces an unanswered question has done its
job, and closing that question by inference is the failure this section exists to prevent.

| A lens may produce | Conditions |
|---|---|
| A register row | Only where the source carries the tolerance and its evidence |
| `[TBD — source: "…"]` on an existing row | The requirement is real, the value is not stated |
| A §3.10 coverage gap | The sub-characteristic has no source material at all |
| An `ASM-NNN` | The assumption is explicit in the source, with an owner and a confirm-by date |
| A decision item (`D-NNN`, or `[D-TBD]`) | Two documented positions compete, or authority is unresolved |
| A `REF-NNN` | The question is real and another document or resolver group owns the answer |

**A lens that finds nothing is reported as *not evidenced*, never as satisfied.** The two are
different findings and only one of them is safe to act on.

### Conditional relevance

Run only the lenses whose trigger is present in the source. A lens with no trigger is not run, is
not reported, and is not a gap — the same rule the *(AI)* subsections follow at §3. Lens 1 and
lens 14 are unconditional; every other lens is gated by its trigger.

| # | Lens | Fires when | Probe | Findings land in |
|---|---|---|---|---|
| 1 | **Operational purpose** | Always | The operational outcome served; the problem prevented or reduced; the business consequence if unmet; the actor, team, customer, counterparty or process that benefits | `OBJ-NNN`; the breach clause inside the `Business Tolerance`; `Source` |
| 2 | **Lifecycle and state transition** | The source names statuses, states, lifecycle events or transitions | Starting state; triggering event; eligibility condition; authorised initiator; permitted transition; prohibited transition; resulting state; downstream, notification, reporting and billing consequence; rollback after failed processing; reversal after successful processing; audit evidence | §3.3.2 Integrity; §3.8.1; `BRL-NNN`; `SCN-NNN`; `IMP-NNN` |
| 3 | **Failure, degradation, retry, reconciliation** | The capability has a dependency, a queue, or a downstream consumer | Complete failure; partial failure; stale or unavailable data; dependency failure; timeout; duplicate processing; omitted processing; downstream rejection; partial propagation; inconsistent state; retry; retry exhaustion; escalation; reconciliation; last valid state preserved; exception visibility; degraded operation; recovery | §3.2 Reliability; §3.3.2 Integrity; §3.6.2 Analyzability; Rainy Day `SCN-NNN` |
| 4 | **Non-interference and concurrency** | The change shares records, locations, services or processes with other activity | Concurrent orders or transactions; shared record or location; race condition stated as a business consequence; unintended triggering of another workflow; inflight work blocked or delayed; unrelated attributes overwritten; isolation from the neighbouring processes the source names | §3.4.2 Coexistence; §3.3.2 Integrity; Edge Case `SCN-NNN` |
| 5 | **Operational workflow and service management** | People or teams perform operational work | Initiating actor; submission channel; receiving team; queue or assignment group; resolver group; reassignment; escalation; ageing; backlog visibility; SLA or OLA implication; pending or suspended treatment; manual hand-off; swivel-chair activity; operational notification; closure; rejection; rework; support evidence | §5; §3.6.3 Supportability; `IMP-NNN`; `REF-NNN` |
| 6 | **Processing mode** | More than one mode is in scope or implied — individual and bulk, or manual and automated | Individual processing; bulk processing; manual processing; automated processing; mode switching and who authorises it; human review; override; approval; reprocessing; bulk validation; partial bulk failure; bulk summary reporting; manual fallback | §3.8.1; §3.2.2 Fault Tolerance; `BRL-NNN`; `SCN-NNN` |
| 7 | **Role, authority and cross-party consequence** | More than one party, team or organisation touches the same record or service | Submitter; initiator; viewer; editor; approver; executor; reviewer; override authority; owner of the affected service or record; party notified; party financially or operationally affected | §3.3 Security; §3.7; `BRL-NNN`; decision item |
| 8 | **Access and entitlement** | The source states who may do what | Read; create; update; delete; approve; execute; override; administer; audit; bulk authority distinct from individual authority | §3.3.1 Confidentiality rows, with an optional entitlement view |
| 9 | **Reported measure** | The `reporting.md` trigger fires | That file's class map in full, including the clock | Per `reporting.md`; `DAT-NNN` at Appendix H |
| 10 | **Data governance and auditability** | Data drives an operational decision or a reported figure | Confirmed source; ownership; definition; lineage; transformation; rule version; effective date; the ISO/IEC 25012 characteristic and its tolerance; duplicate and omission control; attribution; retention; audit reconstruction; reconciliation between operational and reported views | `DAT-NNN`; §3.6.2 Analyzability; §3.3.3 |
| 11 | **Diagnostics and observability** | Monitoring, service health, assurance, testing or fault detection is in scope | How the condition is detected; diagnostic inputs; test outcomes; the evidence supporting a determination; isolated versus common-cause behaviour; correlation across related services, devices, locations or events; neighbouring-service comparison; false-positive and false-negative consequence; threshold consistency across channels; cross-channel outcome consistency; manual test availability; automated test use; operator visibility; escalation on diagnostic outcome; visibility of failed or inconclusive tests | §3.6.2 Analyzability; §3.2; §3.7; `BRL-NNN` |
| 12 | **Commercial and charging consequence** | A lifecycle, performance, eligibility or reporting change can affect what is charged, credited or rebated | Charge commencement; charge cessation; rebate eligibility; fee treatment; credit or adjustment; effective date; billing stop and restart; downstream billing notification; invoice representation; dispute and enquiry handling; reconciliation from source event through calculation to applied amount; effect on another party | `IMP-NNN`; `BRL-NNN`; §3.3.2 Integrity; §3.8.1; `REF-NNN` where commercial owns the answer |
| 13 | **Calendar and timing basis** | Any period, deadline, window, blackout or notification interval appears | Calendar basis; timezone; the holiday jurisdiction — state, territory, national or contractual; business-hour definition; commencement event; completion event; whether the starting day counts; cut-off time; weekend treatment; after-hours treatment; blackout dates; pause and resume | The `Business Tolerance` sentence itself, or a `[TBD]` on it |
| 14 | **Cross-requirement consistency** | Always — run last, before the summary is presented | See § *The consistency sweep* below | Consolidation, or a decision item |
| 15 | **Delivery and portfolio context** | The source explicitly names a programme, capability, epic or delivery item | Only what is explicit: BRD source; stakeholder source; business owner; programme or initiative; capability; epic; related delivery item; milestone; current scope decision; superseded or duplicate relationship | Appendix A's write-back columns only |

### Six traps these lenses exist to catch

**Rollback is not reversal.** Rollback is what is true after processing *failed* — the last valid
record is unchanged. Reversal is what is true after processing *succeeded* and is later undone — a
new state, with its own trigger, authority, notification and billing consequence. A source that
states one has not stated the other, and a lifecycle carrying only rollback has an unwritten
obligation.

**A correctly processed rejection is not a failure.** An adverse determination, a "Not Met", a
failure to qualify — each is a Sunny Day with `Outcome: Adverse`, and what must be true then is a
separate obligation. Where the source supports it, also state the inconclusive or insufficient-data
behaviour and who reviews it. Scenarios do not discharge this: where the business requires a failed
update to leave the last valid record unchanged, that is a register row *and* a Rainy Day scenario.

**Bulk is not individual repeated.** Behaviour valid for one transaction does not carry to a batch,
and automation does not remove exception handling, attribution or human intervention. Where the
source states only the individual case, the bulk case is a gap, not an inference.

**A cross-party consequence is derived, and derived is not stated.** Where one party's action
changes another party's service, data, reporting, billing or rights, name the derived consequence
and take it to the gate for the business owner's explicit confirmation. Authority, attendance,
participation and ownership are never inferred from a role name.

**An engineering threshold is not a business tolerance.** Where the source gives a technical figure
and not the demand behind it, preserve the technical wording as `Source` evidence and raise the
missing tolerance at the gate. The same figure quoted in two channels is a consistency finding, not
a confirmation.

**"Real time", "near real time", "as soon as possible", "promptly", "always", "anytime", "x days"
and "agreed SLA" are unquantified** unless the source defines them, and a defined period is still
incomplete without its calendar basis. Preserve the rule the source actually states: a source that
lists Friday among prohibited dates has not made Friday a non-business day — record the rule and
flag the terminology.

### The consistency sweep

Run across all extracted statements before the Phase 1 Summary is presented. Check for: duplicate
requirements; overlapping requirements; conflicting thresholds; conflicting methodologies;
inconsistent status or state names and capitalisation; different triggers stated for the same
outcome; contradictory eligibility conditions; inconsistent populations; one actor affecting another
party without stated authority; a report definition that differs from the operational definition;
statements superseded or marked duplicate; statements already satisfied by existing capability; and
statements marked out of scope but still written as active commitments.

**Consolidate duplicates. Never silently resolve a conflict.** Consolidation loses nothing — it is
one commitment stated once. Resolution picks a winner, and that is a decision with an owner:
preserve both documented positions, name the affected requirements, and raise a decision item.

---

## Extraction — splitting, consolidating and transforming

Wording is governed by `language.md` and is not restated here. What
follows is the extraction judgement that precedes it.

**Transforming a source statement.** Preserve the operational intent and the business rationale.
Drop the wrapper — *"the solution shall ensure"*, *"the system must"*, *"I want the ability to"*,
*"users can"* — and lead with the governed object, event, population, process or outcome, stated as
a delivered fact. Remove the technical mechanism wherever the business-visible outcome stands
without it; retain the mechanism as `Source` evidence, interface detail (Appendix E), a dependency,
a constraint (§4), or referred response-side content (Appendix C).

> ✗ `The solution shall ensure the transaction uses database rollback on failure`
> ✓ `A failed update leaves the last valid record unchanged`

**Split a source statement only where its clauses differ in** actor, trigger, outcome, owner,
priority, source, verification condition, status, or business consequence. **Never split because
the sentence is long** — one commitment stated at length is still one commitment, and splitting it
manufactures rows that trace to nothing.

**Consolidate duplicates into one authoritative row**, without losing a materially different actor,
trigger, outcome, population or failure condition. Where any of those differ, the statements are not
duplicates.

---

## Supporting views

`tables.md` § *View Tables* governs every view: it cites IDs, restates
no value, introduces no new commitment, and is headed as a view. These are the views this document
permits, each placed in the section it serves:

role-to-capability (entitlement) · lifecycle transition · actor and notification · impacted
system · impacted report.

**An entitlement matrix carries its own legend.** Define every decision value used, and distinguish
confirmed, denied, conditional and unresolved access. A cell reading `Yes*`, `No*` or a bare
asterisk is not a decision value — it is an unwritten condition, and it belongs in the `BRL-NNN` or
`ORD-NNN` row the cell cites.

**A view is added only where it improves comprehension.** More lenses checked is not more document:
the lenses exist to reduce overlooked operational consequences, not to raise page count.

---

## Worked register extract

Six rows showing the form. **The shape is the point** — an author who copies it gets `language.md`
§ *Voice by Altitude* right without having read it, and that is what a rule alone has never
achieved across multiple authors. Values are illustrative and belong to no real change.

A full worked ORD, continuous with a worked BRD, is in `review-ord`'s criteria extract under
§ *Worked examples*. **This extract cites it and reproduces none of its values** — two copies of one
example is the drift this document warns about everywhere else.

| ORD# | Ver | Requirement Title | Business Tolerance | KPP | MoSCoW | Status | Owner | Source |
|---|---|---|---|---|---|---|---|---|
| ORD-001 | 1.0 | Restore order capture within one business day | Order capture is restored within one business day of an outage, beyond which the retail service agreement §14 service credit is triggered. Threshold: one business day. Objective: four business hours | [KPP] | Must | Committed | GM Order Management | Retail service agreement §14 |
| ORD-002 | 1.0 | Notify the affected party on status change | A status change to `Suspended` is notified to the service-owning party within one business day of the change taking effect, in the reporting entity's local time | | Must | Provisional | Head of Service Assurance | Incident 2026-0417 |
| ORD-003 | 1.1 | Preserve the last valid record on failed update | A failed bulk update leaves every record in the batch at its last valid value, and the records that could not be processed are visible to the operator who submitted them | | Must | Committed | GM Order Management | Incident 2026-0392 |
| ORD-004 | 1.0 | Evidence every eligibility determination | An eligibility determination is reconstructable eighteen months later from the record, the `BRL-002` rule set version in force at determination, and the inputs it used | | Must | Provisional | Regulatory Reporting Manager | [TBD — source: "we need to be able to explain a decision if asked"] |
| ORD-005 | 1.0 | Segregate contractor attendance data | Attendance data is visible only to the contracting party that submitted it | | Must | Committed | GM Field Operations | Field services agreement §12 |
| ORD-006 | 1.0 | Restore service capacity at peak volume | Order capture sustains the December peak without a customer-visible wait, measured against the volume recorded in December 2025 | | Should | Assumed | [TBD — Head of Capacity Planning to confirm by 2026-10-15, ASM-004] | ASM-004 |

**What each row demonstrates**

| Row | Shows |
|---|---|
| ORD-001 | KPP carrying threshold **and** objective as two labelled values, and a tolerance naming the obligation it breaches |
| ORD-002 | Calendar basis inside the tolerance — the period is useless without its timezone |
| ORD-003 | The business-visible outcome of a failure, with no mechanism named. Bulk stated explicitly, because the individual case does not carry |
| ORD-004 | Reproducibility with its rule-set version and its retention period, and a `[TBD]` quoting the vague source verbatim |
| ORD-005 | Active voice where the actor is load-bearing — the second recorded deviation in `language.md` |
| ORD-006 | `Assumed` status pointing at the `ASM-NNN` that owns it. **A `[TBD]` names an owner and a date** — an unowned one is an invented number. The tolerance quantifies the business's demand ("no customer-visible wait") and leaves the latency figure to the response |

**The same requirements written wrong**

| ✗ | Why it fails |
|---|---|
| `The system should restore order capture quickly` | Modal, unquantified, and "the system" names nobody |
| `RTO 4 hours, RPO 1 hour` | Technical target. The design response's answer, not the demand |
| `Users can see which records failed` | `can [verb]` describes a granted capability, not a delivered state |
| `Notify affected parties promptly` | Verb-first is correct for a *title*; a tolerance is noun-first and passive, and "promptly" is unquantified |
| `Order capture is restored within 4 hours` (title cell) | A title commands and carries no value — this is a tolerance in the wrong column |
| `Attendance data is appropriately segregated` | Unquantified adjective. Name the population that may see it |

---

## Deviations from the requirements-documents pack

`review-ord`'s criteria extract carries the pack's § *The demand-side ORD section template*, which
declares the ORD structure fixed. **This document extends it, and the extensions are declared here
rather than discovered by a reviewer.** A document authored under this skill conforms to the pack
plus the rows below; one authored to the pack alone is conforming, not defective.

| Extension | What the pack has | Why |
|---|---|---|
| §1.6 Operational problem statement | Nothing at this altitude | The BRD's problem is enterprise-level. Without the operational drill-down, lens 1 resolves to nothing and a requirement's purpose survives only in its breach clause |
| §2.5 Target operational state | §2 is named *Operational concept and impact* and contains no operational concept | A reader never sees the end state whole. Prose, view of `OBJ-NNN`, no new value |
| §2.6 Operational actor register | Nothing | Lens 7 findings and every cross-party consequence need a named subject. `Party` is the value the pack has no place for |
| `IMP-NNN.Treatment` | `ID · Impact · Kind · Owner · Referred` | "Targeting vs not targeting" per impact had no home. Scope disposition only; the design-disposition ban is in `tables.md` |
| Executive Summary | Not listed | Authors wrote one anyway, free-hand, and it restated §1.1 and §2.1 |
| Appendices F–J | App A–E | Scenario catalogue, business rules, data elements, acronyms, change history |
| `MoSCoW` in the register | Not required | Pre-existing. `/write-ac` gates AC altitude on it |

**All are additive, and none renumbers anything.** §1.1–1.5, §2.1–2.4, §3.1–3.10, §4–§9 and
Appendices A–E keep their numbers, so every `§`-reference in the pack, in `review-ord`'s pinned
extract and in existing ORDs continues to resolve. **That is why §1.6, §2.5 and §2.6 append rather
than insert**, and why they read out of narrative order — the alternative desynchronises a generated
file this skill does not own.

**Raise these to the pack separately.** A deviation declared is a deviation visible; a deviation
carried silently becomes an apparent defect the first time someone reviews against the pack alone.

---

## ORD Template

Save output to `docs/ord/[system-name]-ORD.md`.

**The register schema, the objective, scenario, business-rule, impact, referred-requirement,
assumption and dependency schemas are defined once** in
`tables.md` and are authoritative there. This template shows where each
lands and what each section is for — it does not restate a column set.

```markdown
# Operational Requirements Document
## [System / Service Name]

**Version:** 1.0
**Date:** YYYY-MM-DD
**Status:** Draft | Under Review | Approved
**Document tier:** [weakest status carried by any KPP-bearing requirement]
**Owner (convenor):** [Role / Name]
**Approvers:** [named business owners — endorsement is not approval]
**Classification:** [Internal / Confidential / Restricted]
**Conformance:** ISO/IEC/IEEE 29148:2018 (stakeholder and system requirements), organised by
ISO/IEC 25010:2023 quality characteristics at §3. Deviations recorded in
`language.md`.

---

### Document Control

| Version | Date | Author | Changes |
|---|---|---|---|
| 1.0 | YYYY-MM-DD | [Name] | Initial draft |

---

## Executive Summary *(optional)*

> *Narrative. Introduces no commitment that is not a row elsewhere, and restates no value that a row
> already carries — cite `ORD-NNN` and `OBJ-NNN` instead of repeating the figure.*

One paragraph: the operational change, the outcome it serves, the tier the document reached, and
what remains open. **Written last, from the register that exists** — never from the brief, which is
how a summary comes to promise what the register does not contain.

**It never describes the operating state.** That is §2.5's job, and this is the division that keeps
the two from becoming one paragraph written twice: the summary says why the change exists, how
mature the document is and what is still open — for a reader who reads nothing else; §2.5 paints the
operating picture, for the reader who continues.

**Omit it where §1.1 and §2.1 already carry the narrative.** A summary that re-tells purpose and
business context is the most common source of repetition in an ORD, and the duplication is silent:
the two copies drift, and no reviewer can tell which one the business agreed.

---

## 1. Introduction

### 1.1 Purpose
What this document defines and for whom.

### 1.2 The business objective this traces to
The BRD objective(s) this ORD serves, by `BO-N`.

### 1.3 Operational scope
What is in scope and — explicitly — what is out. The out-list is stated, never implied.

**For a named impact, `IMP-NNN.Treatment` is the authoritative exclusion** and this section is a
view of it — cite the ID, restate no value. Prose here keeps the exclusions that have no row to be
authoritative in: populations, geographies, timeframes, and channels.

### 1.4 Related documents
BRD, contracts, obligations, incident records, existing SLAs.

### 1.5 Definitions
Terms used here. Adopt ISO/IEC/IEEE 24765 and, for AI, ISO/IEC 22989:2022 terms rather than
coining local ones.

### 1.6 Operational problem statement
The specific operational problems this change addresses, **each stated as a problem whose solution
is unknown**. Prose. Each traces to a `BO-N`; each `OBJ-NNN` at §2.4 names the problem it closes.

The BRD's §3 problem is enterprise-level; this is the operational drill-down, and it is what lens 1
(operational purpose) resolves to. **A problem carries no ID and no threshold.** An `OBJ-NNN`
already holds the measurable form — objective, baseline, target — and a problem register would be
the same content stated as its negative, in a second editable place. Where a problem statement
names a mechanism, a product or a component, it has become a solution and is rewritten.

Where no BRD exists, this section is the ORD's own origin record and traces to its proximate
source instead.

---

## 2. Operational Concept and Impact

### 2.1 Business context
The operational mission this change serves. Prose by design.

### 2.2 Impact register
What the change touches, who owns it, and whether this document addresses it — identification and
accountability, never target state. `IMP-NNN` schema in `tables.md`, including the closed
`Treatment` enum. Naming the as-is estate is identification; naming the to-be estate is design and
belongs to the response.

### 2.3 Entry position
Recorded at assignment. **A record, not an escalation.**

| # | Input | Status at assignment |
|---|---|---|
| E1 | BRD, or the three load-bearing elements | Received / Partial / Absent |
| E2 | Business stakeholder list | |
| E3 | Named approving business owners | |
| E4 | Contracts, obligations, SLAs, incident history | |
| E5 | Confirmed date and the milestone it serves | |
| E6 | Confirmed allocation percentage | |
| E7 | Notification when the design response is issued | |
| E8 | As-is process inventory with named owners | |
| E9 | System estate with named owners | |

State size, allocation, available working days, and the tier those inputs support.

### 2.4 Operational objectives
The outcome layer. `OBJ-NNN` schema in `tables.md` — objective, baseline, target, target date,
traceability. **Every §3 register row traces to one.** Where baseline or target is unavailable,
carry `[TBD — source: "…"]`; never invent a baseline. Each objective names the §1.6 problem it
closes.

### 2.5 Target operational state

> *View of §2.4. Cites `OBJ-NNN`; states no value of its own and introduces no commitment.*

The operating picture once the change is in service — how the work runs, who does what, and what a
normal day looks like. Prose, and the only place in this document a reader sees the end state whole.

**Outcomes only. No mechanism.** No component, product, platform, protocol, integration pattern or
technical recovery approach — those are the design response's, and stating one here pre-empts the
review this document exists to inform. The test: if a sentence would change when architecture picks
a different option, it does not belong.

**This section is not called "solution vision", deliberately.** The name draws solution content from
every author who reads it, whatever the guidance underneath says.

### 2.6 Operational actor register

Who and what the operational process runs through. Schema in `tables.md` § *Operational actor* —
actor, kind (`User` / `System` / `Party`), operational role, owner. **No ID: the actor name is the
key.**

Identification only, on the same rule as §2.2 — never authority the source did not state, and never
a target operating model. `Party` carries the external organisation, and it is what a cross-party
consequence names as its subject.

**Governance roles are not actors.** The SME who informed this document, the business owner who
approves it and the convenor who wrote it belong in the header and at §2.3 — E2 and E3. Where the
stakeholder list is absent at assignment, `Owner` carries `[TBD]` with a confirm-by date per actor,
which makes the absence countable where a single entry-position row does not.

---

## 3. Operational Requirements

Organised by ISO/IEC 25010:2023 characteristic. **All nine appear, every time.** Register schema in
`tables.md` § *Requirement register — the demand-side ORD*.

> **[AI]** prefixes a `Business Tolerance` governed by `ai.md`.
> **KPP** is its own column and carries threshold and objective as two labelled values.
> **`Ver`** is the requirement's own version, and it travels with the proposed acceptance criterion
> as inline provenance. **Traceability is not a register column** — it lives once, at Appendix A.
> Every requirement is a **business tolerance** — quantified, testable, traced to a contract, an
> obligation or an incident record. None states a technical target.

**Sub-characteristics with no requirement are omitted from the body** and listed once in §3.10.
**Characteristics are never omitted** — one with nothing to state says so explicitly.

A supporting view is permitted inside the subsection it serves — see § *Supporting views*. It cites
IDs and adds no value of its own.

| § | Characteristic | Sub-characteristics carrying requirements |
|---|---|---|
| 3.1 | Performance Efficiency | Time Behavior · Resource Utilization · Capacity |
| 3.2 | Reliability | Availability · Fault Tolerance · Recoverability · Faultlessness · **Robustness** *(AI)* |
| 3.3 | Security | Confidentiality · Integrity · Non-repudiation and Accountability · Authenticity · Resistance · Compliance Frameworks · **Prompt Injection and Model Attack Surface** *(AI)* |
| 3.4 | Compatibility | Interoperability *(detail → Appendix E)* · Coexistence |
| 3.5 | Flexibility | Scalability · Adaptability · Installability · Replaceability |
| 3.6 | Maintainability | Modifiability · Analyzability · Supportability · **Record-Keeping and Inference Logging** *(AI)* |
| 3.7 | Interaction Capability | Accessibility · Learnability · Self-Descriptiveness · **User Controllability and Intervenability** *(AI)* · **Transparency and Explainability** *(AI)* |
| 3.8 | Functional Suitability | Functional Completeness · **Functional Adaptability** *(AI)* · **Accuracy and Fairness Thresholds** *(AI)* |
| 3.9 | Safety *(if applicable)* | Fail Safe · Hazard Warning · **Prohibited Outputs** *(AI)* |

Subsections marked *(AI)* are live only where the trigger test in `ai.md` fires.
Where it does not, they are omitted from the body **and** from §3.10 — an inapplicable subsection is
not a gap — and §3.10 states once that the trigger did not fire.

Where `reporting.md` fires, its class map routes reporting and data requirements
into the subsections above. **It adds no subsection**; its `DAT-NNN` register lands at Appendix H.

### 3.10 Coverage Gaps

Every sub-characteristic with no requirement, listed once.

| Absent subsection | Reason | Action |
|---|---|---|

A requirement that exists but is unquantified is **not** a gap — it stays in its table as a
`[TBD — source: "…"]` row.

---

## 4. Operating Environment and Constraints

Regulatory, contractual and policy constraints carrying operational weight, as register rows.
Data residency and jurisdiction belong here as business constraints; hosting model does not — that
is the response's.

---

## 5. Operational Hours and Escalation Tolerance

The business tolerance for availability of support — **the tolerance, never the roster.** Register
rows. Severity definitions are context; the response and resolution tolerances are rows.

---

## 6. Staffing and Organisational Requirements

**Not used. Out of scope** — see § *Demand-side scope*. Staffing content raised during elicitation
is recorded in the referred requirements register (Appendix C), never omitted silently.

---

## 7. Service Level Requirements

> *View of Sections 3 and 5. Values are authoritative in the referenced rows; this table adds no
> new commitments.*

| ORD# | Section | Tolerance | Agreed value | Measurement period |
|---|---|---|---|---|

---

## 8. Infrastructure and Facilities

**Not used. Out of scope** — see § *Demand-side scope*. Answered in the design response.

---

## 9. Trade-offs, Risk, Assumptions and Dependencies

### 9.1 Accepted trade-offs and risks
Risks are owned by the RAID log — cite `R-NNN`, never duplicate the record.

### 9.2 Open decisions
Decisions are owned by the RAID log — cite `D-NNN`. **This document never mints a decision ID.**
Every unresolved matter materially affecting scope, methodology, classification, regulatory
interpretation, thresholds, population, ownership or historical comparability appears here.

| D-NNN | Decision required | Affects | Options | Owner | Required by | Status |
|---|---|---|---|---|---|---|

### 9.3 Dependencies
`DEP-NNN` schema in `tables.md`. Model and provider dependencies (`MDL-NNN`) where `ai.md` fires.

---

## Appendices

### A. Traceability

Every requirement to an operational objective and a BRD objective, or an explicit orphan flag.
`Capability`, `Epic` and the PRD cross-link are written back — not authored here.

| ORD# | Traces to — OBJ, and BO via BR | Orphan? | Proposed AC | Capability | Epic | PRD# |
|---|---|---|---|---|---|---|

**Every row resolves to a BRD *objective*, not to a business requirement** — a tolerance tracing only
as far as a `BR-` has no funded outcome behind it, and the `via` is what makes that visible.

**`Proposed AC` is proposed, not assigned.** `/write-ac` owns `AC-NNN` and mints it. A proposed
criterion here is the author's input to a handoff performed by someone else; presenting it as an
assigned AC misrepresents whose decision it was.

### B. Assumption register
`ASM-NNN` schema in `tables.md`. Owner and confirm-by are mandatory for any assumption a register
row cites as its `Source`. State the expected trajectory — when these are expected to reach
`Committed`.

### C. Referred requirements register
`REF-NNN` schema in `tables.md`. Content raised during elicitation that this ORD will not deliver.
No row is classified against a 25010 characteristic and no row becomes a requirement here.

### D. Conformance — ORD to design response
**Completed when the design response is issued.** One row per requirement, recording whether it was
answered: **Met**, **Met at threshold but not objective**, **Not met — trade-off proposed**, or
**Unanswered**.

| ORD# | Tolerance stated | Response | Conformance |
|---|---|---|---|

**An unanswered KPP is escalated rather than recorded.** Nothing downstream reads this document — a
demand not carried into the response is absent from every artefact anyone downstream will read.

Where a tolerance governs generated output, the response is the **evaluation instrument**: the ORD
names the population, the response draws the set, picks the scorer and sets the pass mark. Recorded
here; `ai.md`'s `EVL-NNN` schema governs its form.

### E. Interface detail
Per-interface technical attributes keyed to §3.4.1 rows by `ORD#`. Specification, not commitment.

### F. Scenario catalogue
`SCN-NNN` schema in `tables.md`. Requirement-level scenarios and the consolidated catalogue are one
table. Every requirement carries at least a Sunny Day row; a determination, measurement or
eligibility requirement carries both a Favourable and an Adverse Sunny Day row.

### G. Business rule register *(conditional)*
`BRL-NNN` schema in `tables.md`. **Present only where no functional requirements document is
produced in the chain.** Where present, state that plainly:

> Business rules are functional content. They are carried here because no functional requirements
> document exists between this ORD and delivery; unrecorded, they are inferred during
> decomposition rather than elicited. This is a declared deviation from this document's scope, not
> an extension of it.

Where a PRD is produced, the rules live there and this appendix is omitted.

### H. Data element register *(conditional)*
`DAT-NNN` schema in `reporting.md`. Present only where that file's trigger fires.

### I. Acronyms and abbreviations
### J. Change history
```
