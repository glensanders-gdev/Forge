# write-ord — ORD Template

The eighteen-section template Phase 2 writes, the supporting views it permits, and the worked
register extract every row is checked against. Scope, status and KPP rules are in
[REFERENCE.md](REFERENCE.md).

---

## Supporting views

`standards/tables.md` § *View Tables* governs every view: it cites IDs, restates
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

Six rows showing the form. **The shape is the point** — an author who copies it gets `standards/language.md`
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
| ORD-004 | 1.0 | Evidence every eligibility determination | Every eligibility determination is auditable and reproducible for eighteen months, under the `BRL-002` eligibility rule and the `BRL-011` evidence-retention rule | | Must | Provisional | Regulatory Reporting Manager | [TBD — source: "we need to be able to explain a decision if asked"] |
| ORD-005 | 1.0 | Segregate contractor attendance data | Attendance data is visible only to the contracting party that submitted it | | Must | Committed | GM Field Operations | Field services agreement §12 |
| ORD-006 | 1.0 | Restore service capacity at peak volume | Order capture sustains the December peak without a customer-visible wait, measured against the volume recorded in December 2025 | | Should | Assumed | [TBD — Head of Capacity Planning to confirm by 2026-10-15, ASM-004] | ASM-004 |

**What each row demonstrates**

| Row | Shows |
|---|---|
| ORD-001 | KPP carrying threshold **and** objective as two labelled values, and a tolerance naming the obligation it breaches |
| ORD-002 | Calendar basis inside the tolerance — the period is useless without its timezone |
| ORD-003 | The business-visible outcome of a failure, with no mechanism named. Bulk stated explicitly, because the individual case does not carry |
| ORD-004 | **Executive altitude.** The outcome — auditable, reproducible, for how long — stays in the row; how a determination is reconstructed (record, rule version, inputs) is the `BRL-011` governance rule it cites. And a `[TBD]` quoting the vague source verbatim |
| ORD-005 | Active voice where the actor is load-bearing — the second recorded deviation in `standards/language.md` |
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
| `Each determination retains a stable identifier linking the outcome to its originating record and the rule decision applied` | A control, not an outcome. No executive can read it; state *auditable and reproducible* and move the mechanism to a §13 governance rule |

---

## ORD Template

Save output to `docs/ord/[system-name]-ORD.md`.

**The register schema, and the objective, scenario, business-rule, decision, related-initiative,
impact, referred-requirement, assumption and dependency schemas are defined once** in
`standards/tables.md`; the reporting consumer, measure definition and data
element schemas in `standards/reporting.md`. They are authoritative there. This template shows where each
lands and what each section is for — it does not restate a column set.

**Numbering is fixed.** Every section from §1 to §18 appears in every ORD, in this order. A section
with nothing to state says so in one line — it is never dropped, and nothing closes up around it.

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
ISO/IEC 25010:2023 quality characteristics at §7. Structure deviates from the requirements-documents
pack — section map in write-ord REFERENCE.md § *Deviations from the requirements-documents pack*.

---

### Document Control

| Version | Date | Author | Changes |
|---|---|---|---|
| 1.0 | YYYY-MM-DD | [Name] | Initial draft |

---

## 1. Executive Summary

> *Narrative. Introduces no commitment that is not a row elsewhere, and restates no value a row
> already carries — cite `ORD-NNN`, `OBJ-NNN` and `D-NNN` instead of repeating the figure.*

**Mandatory, and written last** — from the register that exists, never from the brief, which is how
a summary comes to promise what the register does not contain. Five short paragraphs, in order:

1. **The problem** — in one or two sentences, citing §3.
2. **The outcome required** — what is true once the change is in service, citing `OBJ-NNN`.
3. **What is changing** — the processes, systems and reporting touched (`IMP-NNN` with
   `Treatment: Addressed`).
4. **What is not changing** — the deliberate exclusions, citing §4.2.
5. **Major unresolved decisions** — each open `D-NNN` that affects a KPP-bearing requirement or the
   scope, with its owner, and the document tier.

For a reader who reads nothing else. **It never describes the operating state in detail** — that is
§2.4's job.

---

## 2. Objective

### 2.1 Purpose
What this document defines and for whom.

### 2.2 Business objectives
The BRD objective(s) this ORD serves, by `BO-N`. Where no BRD exists, say so and name the proximate
source.

### 2.3 Business context
The operational mission this change serves. Prose by design.

### 2.4 Target operational state

> *View of §6. Cites `OBJ-NNN`; states no value of its own and introduces no commitment.*

The operating picture once the change is in service — how the work runs, who does what, and what a
normal day looks like. Prose, and the only place in this document a reader sees the end state whole.

**Outcomes only. No mechanism.** No component, product, platform, protocol, integration pattern or
technical recovery approach. The test: if a sentence would change when architecture picks a
different option, it does not belong. **Never call this "solution vision"** — the name draws
solution content from every author who reads it.

---

## 3. Problem Statement

The specific operational problems this change addresses, **each stated as a problem whose solution
is unknown**. Prose. Each traces to a `BO-N`; each `OBJ-NNN` at §6 names the problem it closes.

The BRD's problem is enterprise-level; this is the operational drill-down, and it is what lens 1
(operational purpose) resolves to. **A problem carries no ID and no threshold** — `OBJ-NNN` holds
the measurable form, and a problem register would be the same content inverted into a second
editable place. A problem naming a mechanism, product or component has become a solution and is
rewritten.

---

## 4. Scope

### 4.1 In scope
What this document covers — processes, populations, channels, geographies, timeframes.

### 4.2 Out of scope
The out-list, stated, never implied. **Always includes** staffing and organisational requirements,
infrastructure and facilities, and the support model — see REFERENCE.md § *Demand-side scope*. For a named
impact, `IMP-NNN.Treatment` is authoritative and this section cites the ID; prose keeps the
exclusions that have no row.

An out-of-scope item is excluded and delivered by nobody as a result of this document. Something
another owner will deliver is a referred requirement (§10.3); adjacent work is a related initiative
(§10.2). A deferred item still in scope is a `Won't` register row, not an exclusion.

**A descoped item** — in scope at an earlier version, removed since — is an exclusion here marked
`Descoped in v[N]`, with the §18 entry recording when, by whom and why.

### 4.3 Impact register
What the change touches, who owns it, and whether this document addresses it — identification and
accountability, never target state. `IMP-NNN` schema in `standards/tables.md`, including the closed
`Treatment` enum.

### 4.4 Operational actors
Who and what the operational process runs through. Schema in `standards/tables.md` § *Operational actor*.
**No ID: the actor name is the key.** Governance roles are not actors — they go in the header and
at §12 (E2, E3). Reporting consumers are listed at §14.1, not here, unless they also act in the
process.

### 4.5 Related documents
BRD, contracts, obligations, incident records, existing SLAs.

---

## 5. Glossary

### 5.1 Terms
Terms and acronyms used here, one table. Adopt ISO/IEC/IEEE 24765 and, for AI, ISO/IEC 22989:2022
terms rather than coining local ones.

| Term | Definition |
|---|---|

### 5.2 Prioritisation and status definitions
The `MoSCoW`, `KPP` and `Status` definitions, copied **verbatim** from `standards/tables.md`
§ *Prioritisation and status definitions*, including its note distinguishing `Won't` from out of
scope and descoped. Never reworded per document.

---

## 6. Operational Objectives

The outcome layer. `OBJ-NNN` schema in `standards/tables.md` — objective, baseline, target, target date,
traceability. **Every §7 register row traces to one.** Where baseline or target is unavailable,
carry `[TBD — source: "…"]`; never invent a baseline. Each objective names the §3 problem it closes.

---

## 7. Operational Requirements

Organised by ISO/IEC 25010:2023 characteristic. **All nine appear, every time.** Register schema in
`standards/tables.md` § *Requirement register — the demand-side ORD*.

> **Executive altitude.** Every `Business Tolerance` passes the test in `standards/tables.md`: an executive
> understands it without understanding reporting, governance, architecture or implementation.
> Classification, cut-off, reconciliation and evidence detail is cited from §13 or §14, never
> written into the row.
> **[AI]** prefixes a `Business Tolerance` governed by `standards/ai.md`.
> **KPP** is its own column and carries threshold and objective as two labelled values.
> **`Ver`** is the requirement's own version. **Traceability is not a register column** — it lives
> once, at §11. No row states a technical target.

**Sub-characteristics with no requirement are omitted from the body** and listed once in §7.10.
**Characteristics are never omitted** — one with nothing to state says so explicitly.

A supporting view is permitted inside the subsection it serves — see § *Supporting views*.

| § | Characteristic | Sub-characteristics carrying requirements |
|---|---|---|
| 7.1 | Performance Efficiency | Time Behavior · Resource Utilization · Capacity |
| 7.2 | Reliability | Availability · Fault Tolerance · Recoverability · Faultlessness · **Robustness** *(AI)* |
| 7.3 | Security | Confidentiality · Integrity · Non-repudiation and Accountability · Authenticity · Resistance · Compliance Frameworks · **Prompt Injection and Model Attack Surface** *(AI)* |
| 7.4 | Compatibility | Interoperability *(detail → §16)* · Coexistence |
| 7.5 | Flexibility | Scalability · Adaptability · Installability · Replaceability |
| 7.6 | Maintainability | Modifiability · Analyzability · Supportability · **Record-Keeping and Inference Logging** *(AI)* |
| 7.7 | Interaction Capability | Accessibility · Learnability · Self-Descriptiveness · **User Controllability and Intervenability** *(AI)* · **Transparency and Explainability** *(AI)* |
| 7.8 | Functional Suitability | Functional Completeness · Functional Correctness · **Functional Adaptability** *(AI)* |
| 7.9 | Safety *(if applicable)* | Fail Safe · Hazard Warning · **Prohibited Outputs** *(AI)* |

**Numbers are fixed by position in this table** — 7.8.2 is Functional Correctness in every ORD —
and do not close up when a subsection is omitted. *(AI)* subsections always follow the 25010 ones,
so the trigger firing or not never moves a 25010 number.

Subsections marked *(AI)* are live only where the trigger test in `standards/ai.md`
fires. Where it does not, they are omitted from the body **and** from §7.10, and §7.10 states once
that the trigger did not fire.

**Functional Correctness is not an *(AI)* subsection.** A deterministic tolerance on a correct result
belongs there, and so do accuracy and fairness thresholds on a learned or generated component, as
`[AI]` rows — one sub-characteristic measured two ways.

**Functional Appropriateness carries no subsection.** It is functional content, owned by the product
side; it is referred via `REF-NNN`, never a §7.10 gap.

Where `standards/reporting.md` fires, its class map routes reporting requirements into
the subsections above. **It adds no subsection**; the detail behind them lands at §14.

### 7.10 Coverage Gaps

Every sub-characteristic with no requirement, listed once.

| Absent subsection | Reason | Action |
|---|---|---|

A requirement that exists but is unquantified is **not** a gap — it stays in its table as a
`[TBD — source: "…"]` row.

### 7.11 Operating Environment and Constraints

Regulatory, contractual and policy constraints carrying operational weight, as register rows. Data
residency and jurisdiction belong here as business constraints; hosting model does not.

### 7.12 Operational Hours and Escalation Tolerance

The business tolerance for availability of support — **the tolerance, never the roster.** Register
rows. Severity definitions are context; the response and resolution tolerances are rows.

### 7.13 Service Level Requirements

> *View of §7.1–§7.12. Values are authoritative in the referenced rows; this table adds no new
> commitments.*

| ORD# | Section | Tolerance | Agreed value | Measurement period |
|---|---|---|---|---|

---

## 8. Decisions

### 8.1 Open and resolved decisions
`D-NNN` schema in `standards/tables.md` § *Decision* — identifier, decision required, affected requirements,
options, owner, required by, status, resolution. **`$raid` owns the namespace; this document never
mints a decision ID** — where no RAID log exists, `[D-TBD]` with the owner and what must be decided.
Every unresolved matter affecting scope, methodology, classification, regulatory interpretation,
thresholds, population, ownership or historical comparability appears here. **An unresolved
decision is never left as an assumption inside a requirement.** Resolved rows stay, with their
resolution.

### 8.2 Accepted trade-offs and risks
Risks are owned by the RAID log — cite `R-NNN`, never duplicate the record. State the business
consequence of each accepted trade-off.

---

## 9. Assumptions

`ASM-NNN` schema in `standards/tables.md` § *Assumption*. Every assumption the document rests on, stated once
here — **never embedded in a requirement's wording**. Owner and confirm-by are mandatory for any
assumption a register row cites as its `Source`. State the expected trajectory — when these are
expected to reach `Committed`. A falsified assumption is raised as a risk (`$raid add risk`).

---

## 10. Dependencies

Three registers, kept apart — the tests are in `standards/tables.md` § *Related initiative*.

### 10.1 Dependencies
`DEP-NNN` schema in `standards/tables.md`. Model and provider dependencies (`MDL-NNN`) where `standards/ai.md` fires.

### 10.2 Related initiatives
Schema in `standards/tables.md` § *Related initiative*. No ID.

### 10.3 Referred requirements
`REF-NNN` schema in `standards/tables.md`. Content raised during elicitation that this ORD will not deliver,
each with a resolver group and a named recipient. No row is classified against a 25010
characteristic and no row becomes a requirement here.

---

## 11. Traceability

Every requirement to its operational objective, business requirement and business objective — or
an explicit orphan flag. `Capability`, `Epic` and the PRD cross-link are written back, not authored
here.

| ORD# | OBJ | BR | BO | Orphan? | Business rules | Proposed AC | Capability | Epic | PRD# |
|---|---|---|---|---|---|---|---|---|---|

**Every row resolves to a BRD *objective*, not only to a business requirement** — a tolerance
tracing only as far as a `BR-` has no funded outcome behind it. `Business rules` lists the
`BRL-NNN` rows the requirement relies on; the rule's own `Affects` column is the reverse view and
must agree.

**`Proposed AC` is proposed, not assigned.** `$write-ac` owns `AC-NNN` and mints it.

---

## 12. Entry Position Assessment

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

---

## 13. Business Rules Appendix

> Business rules are functional content, carried here by design: the core ORD states **what must
> happen**, and this register states **how decisions are made**. Every rule names its owner, its
> status and the requirements it affects.

`BRL-NNN` schema in `standards/tables.md` § *Business rule*. **Present in every ORD.** Where a PRD in the
chain already states a rule, the row cites the PRD's ID and restates nothing. A group with no rule
says so in one line.

### 13.1 Classification rules
Inclusion · exclusion · cohort assignment · eligibility.

### 13.2 Reporting rules
Reporting periods · cut-offs · late-arriving data · calculations · restatements.

### 13.3 Governance rules
Reconciliation · exception handling · evidence retention · rule versioning.

---

## 14. Reporting Requirements Appendix

**Present where `standards/reporting.md` fires** — the change creates, alters or retires a measure, KPI, SLA,
performance metric or compliance figure somebody reports. Where it does not fire, the section
carries one line saying so. Schemas in `standards/reporting.md`. Every binding statement here cites an
`ORD#`; this appendix holds detail, never a second register.

### 14.1 Reporting consumers
Regulatory · contractual · operational · management · executive · audit — each consumer the source
evidences, its need, the measures it uses, and what this change moves for it.

### 14.2 Reporting measures
One measure definition per reported measure — population, clock, rule set, lineage, correction
path, dimensions — keyed by the register row it details.

### 14.3 Reporting data — attributes, dimensions and data elements
`DAT-NNN`. `Availability` is `Unconfirmed` until the source confirms an element already exists —
never assume an existing reporting platform holds it.

### 14.4 Transparency and audit
What a consumer or auditor is shown about how a figure was produced, and what is retained for
audit — each citing the register row and the §13 governance rule that carries it.

### 14.5 Reporting acceptance criteria
Proposed criteria for the reporting requirements, in the `Proposed AC` form §11 uses — proposed,
never assigned.

---

## 15. Scenario Catalogue

`SCN-NNN` schema in `standards/tables.md`. Requirement-level scenarios and the consolidated catalogue are one
table. Every requirement carries at least a Sunny Day row; a determination, measurement or
eligibility requirement carries both a Favourable and an Adverse Sunny Day row.

## 16. Interface Detail

Per-interface technical attributes keyed to §7.4.1 rows by `ORD#`. Specification, not commitment.

## 17. Conformance — ORD to Design Response

**Completed when the design response is issued.** One row per requirement: **Met**, **Met at
threshold but not objective**, **Not met — trade-off proposed**, or **Unanswered**.

| ORD# | Tolerance stated | Response | Conformance |
|---|---|---|---|

**An unanswered KPP is escalated rather than recorded.** Where a tolerance governs generated output,
the response is the **evaluation instrument**: the ORD names the population, the response draws the
set, picks the scorer and sets the pass mark. `standards/ai.md`'s `EVL-NNN` schema governs its form.

## 18. Change History

Every version, and every descoping: what was removed from scope, when, by whom, and why.
```
