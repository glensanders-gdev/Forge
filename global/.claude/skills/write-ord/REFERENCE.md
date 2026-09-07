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

**Applies only where the trigger test in `~/.claude/rules/requirements/ai.md` fires** — a delivered
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
a floor, and a review hook — see `rules/requirements/ai.md` § *The evaluative criterion*. Accuracy
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
it.** See `~/.claude/rules/requirements/language.md` § *Demand, not design*. The ORD precedes
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
`~/.claude/rules/requirements/tables.md`. A KPP that cannot reach at least `Provisional` inside the
window is the one item warranting escalation rather than quiet degradation.

---

## ORD Template

Save output to `docs/ord/[system-name]-ORD.md`.

**The register schema, the objective, scenario, business-rule, impact, referred-requirement,
assumption and dependency schemas are defined once** in
`~/.claude/rules/requirements/tables.md` and are authoritative there. This template shows where each
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
`rules/requirements/language.md`.

---

### Document Control

| Version | Date | Author | Changes |
|---|---|---|---|
| 1.0 | YYYY-MM-DD | [Name] | Initial draft |

---

## 1. Introduction

### 1.1 Purpose
What this document defines and for whom.

### 1.2 The business objective this traces to
The BRD objective(s) this ORD serves, by `BO-N`.

### 1.3 Operational scope
What is in scope and — explicitly — what is out. The out-list is stated, never implied.

### 1.4 Related documents
BRD, contracts, obligations, incident records, existing SLAs.

### 1.5 Definitions
Terms used here. Adopt ISO/IEC/IEEE 24765 and, for AI, ISO/IEC 22989:2022 terms rather than
coining local ones.

---

## 2. Operational Concept and Impact

### 2.1 Business context
The operational mission this change serves. Prose by design.

### 2.2 Impact register
What the change touches and who owns it — identification and accountability, never target state.
`IMP-NNN` schema in `tables.md`. Naming the as-is estate is identification; naming the to-be estate
is design and belongs to the response.

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
carry `[TBD — source: "…"]`; never invent a baseline.

---

## 3. Operational Requirements

Organised by ISO/IEC 25010:2023 characteristic. **All nine appear, every time.** Register schema in
`tables.md` § *Requirement register — the demand-side ORD*.

> **[AI]** prefixes a `Business Tolerance` governed by `rules/requirements/ai.md`.
> **KPP** is its own column and carries threshold and objective as two labelled values.
> **`Ver`** is the requirement's own version, and it travels with the proposed acceptance criterion
> as inline provenance. **Traceability is not a register column** — it lives once, at Appendix A.
> Every requirement is a **business tolerance** — quantified, testable, traced to a contract, an
> obligation or an incident record. None states a technical target.

**Sub-characteristics with no requirement are omitted from the body** and listed once in §3.10.
**Characteristics are never omitted** — one with nothing to state says so explicitly.

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

Subsections marked *(AI)* are live only where the trigger test in `rules/requirements/ai.md` fires.
Where it does not, they are omitted from the body **and** from §3.10 — an inapplicable subsection is
not a gap — and §3.10 states once that the trigger did not fire.

Where `rules/requirements/reporting.md` fires, its class map routes reporting and data requirements
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
`DAT-NNN` schema in `rules/requirements/reporting.md`. Present only where that file's trigger fires.

### I. Acronyms and abbreviations
### J. Change history
```
