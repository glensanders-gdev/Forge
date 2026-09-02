# write-brd — standard extract

> **Generated file. Never hand-edit.** Produced by `tools/build-review-criteria.py`
> from the requirements-documents pack, which is the single source of truth for
> everything below. Editing this file puts it out of step with the pack; regenerate
> instead.

**Pack version:** v1.9 · **Pack commit:** `719eecb78e35`
**Generated:** 2026-09-02 · **Content hash:** `9d3e57310592cd19`

**Quote the version in every BRD authored from this extract.**
A reader needs to know which revision was applied — a verdict, and a document
authored to a bar, are only meaningful against a named one, and that is the pack's
own thesis applied to itself.

**Where the live pack is present, it wins.** This extract exists so the skill runs
for someone who does not hold the pack. It is a pinned copy, not an authority: where
it and the pack disagree, the pack is right and this file is stale.

---

<!-- from reference/brd-standard.md -->

# BRD Standard

**Standard of record:** BABOK v3 · **Audience:** Business Analysts, Product Owners, Product
Managers, Sponsors, Management

A Business Requirements Document states **why** money is being spent and **how it will be known
that it paid off** — before anyone decides what to build.

---

## Why this exists

Business Requirements Documents are written inconsistently, and the common failures are expensive:

- **No measurable business objective** — the BRD describes a desire ("improve checkout") but no
  target, so success can never be claimed or disproven.
- **Solution smuggled into the business case** — the BRD names a feature ("build saved cards")
  instead of an outcome, pre-empting the solution documents and biasing the design.
- **No stakeholder register** — the people who approve, fund, or are affected are not identified,
  so sign-off stalls.
- **No line of sight to delivery** — a built feature cannot be traced back to the business
  objective that justified it.

The BRD is also the **entry criterion** for the operational document that follows it. A BRD with no
quantified objective and no cost-of-failure case leaves the ORD with nothing to derive a tolerance
from — see [Entry criteria](#entry) and the E1–E9 list.

## The standard

The BRD has no single ISO. The authoritative anchor is the IIBA's **BABOK v3** (Business Analysis
Body of Knowledge). It defines a **requirements taxonomy** — Business, Stakeholder, Solution,
Transition — that determines which document owns which requirement. The BRD owns the **Business**
requirements and frames the **Stakeholder** ones. **Solution** requirements are handed down: the
operational half to the ORD, as quantified business tolerance.

**The functional half has no document in this chain.** The taxonomy names it, the
[PRD standard](#prd) defines its shape, and it is not adopted here — so functional detail is
inferred during Epic decomposition rather than elicited. That absence is not a gap in the BRD's
responsibilities, but it does change what happens to a business rule the BRD correctly declines to
carry: see [what leaves the chain](#traceability).

### What changes, concretely

| Today | Under the standard |
|---|---|
| Each author invents a structure | One fixed BRD template |
| "Improve checkout" with no target | SMART business objectives with baselines and targets |
| Solution named in the business case | Outcomes only; operational demand lives in the ORD, the design in the SOAP |
| Stakeholders unclear | Stakeholder register with approval roles |
| Delivered work cannot be justified | Objective → ORD → SOAP → Capability AC traceability |

### The ask

1. **Adopt BABOK v3** as the BRD anchor, using the template on this page.
2. **Require SMART business objectives** with baseline and target on every BRD.
3. **Require a cost-of-failure case** wherever the change carries operational exposure — this is
   what makes an operational tolerance derivable downstream.
4. **Keep solutions out of the BRD** — the BRD states outcomes; the ORD owns the operational
   demand detail, and the SOAP owns the technical answer.
5. **Name an owner** for the standard (recommended: Lead Business Analyst or Programme sponsor).

---

## BABOK v3 — the requirements taxonomy

BABOK v3 classifies every requirement into one of four types. This taxonomy is the most useful tool
for deciding **which document a requirement belongs in**.

| BABOK type | What it captures | Lives in |
|---|---|---|
| **Business** | Higher-level goals, objectives and outcomes of the enterprise. The "why" | BRD |
| **Stakeholder** | Needs of a specific stakeholder or group — the bridge from business goal to solution | BRD |
| **Solution — Functional** | What the solution must *do* (behaviour, capabilities) | **No document in this chain.** Inferred at Epic decomposition. Defined shape: [PRD standard](#prd), unadopted |
| **Solution — Non-functional** | How well the solution must *perform and run* (quality attributes) | ORD, as business tolerance |
| **Transition** | Temporary capabilities to move from current to future state (migration, training, cutover). Retired after go-live | BRD or implementation plan |

> **The split that matters is one line in this taxonomy.** A *Solution* requirement is either
> **functional** or **non-functional**. The BRD holds neither kind of detail — it holds the Business
> outcome they serve. Of the two, only the non-functional half has a document to land in, which is
> why an elicited business rule has to be **recorded and routed** rather than simply passed on.

### A good business objective is… (SMART)

| Letter | Means |
|---|---|
| **S**pecific | Names one concrete outcome, not a vague aspiration |
| **M**easurable | Has a metric, a baseline and a target number |
| **A**chievable | Realistic within budget, capability and time |
| **R**elevant | Ties to a strategic goal the sponsor cares about |
| **T**ime-bound | States by when it is achieved |

The most common BRD failure is **Measurable**: an objective with no baseline or target can never be
proven met. SMART objectives are how a BRD earns its sign-off — and they are what the ORD's
tolerances trace back to.

---

## The BRD anatomy — required sections

Every BRD carries these sections. Sections marked **★** are the ones most often missing and most
important to enforce.

| § | Section | Purpose |
|---|---|---|
| 1 | **Document control** | Version, author, sponsor, approval status, date |
| 2 | **Executive summary** | The business case in one paragraph, readable by an executive who reads nothing else |
| 3 | **Business need / problem** | The problem in business terms — cost, risk, lost revenue, compliance. No solution |
| 4 | **★ Business objectives and success measures** | SMART objectives with baseline and target. The BRD's measurability |
| 5 | **★ Stakeholders** | Stakeholder register — who approves, who funds, who is affected, and their role |
| 6 | **Current vs future state** | Where the business is now and the target operating state, in business terms |
| 7 | **Business scope (in / out)** | Which business areas, processes or segments are in and out. Not feature scope |
| 8 | **★ Business requirements** | High-level needs (BABOK Business and Stakeholder types) — what the enterprise needs, not how |
| 9 | **Constraints, assumptions and dependencies** | Budget, regulatory and time constraints; what must hold true; external dependencies |
| 10 | **Risks** | Business risks to the objective and their mitigations |
| 11 | **★ Cost–benefit and cost of failure** | Expected return against cost, **and the cost of the objective not being met** — the input every operational tolerance is derived from |
| 12 | **★ Traceability** | Business objective → ORD operational requirement, and onward to the SOAP and Capability AC. Proves every build traces to a justification |
| App. A | **Process and system scope** | The L1–L3 process areas and the systems in scope, each with a named owner. Seeds the ORD's impact register |

> **The five ★ sections close the gaps most BRDs miss**: SMART objectives, a real stakeholder
> register, business-level requirements kept free of solution detail, a cost-of-failure case, and
> traceability down to the ORD. Enforce these and the rest follows.

**Appendix A is what makes the ORD sizeable at assignment.** The impact counts that set S/M/L in the
lead-time standard are read off it. A BRD with no process or system scope leaves the size to be
guessed and re-sized later.

---

## Writing business objectives, not solutions

A business objective states the *outcome* the enterprise wants. The discipline that keeps a BRD
clean is: **describe the change in a business metric, never the feature that achieves it.**

**Objective form:**

```
Move [business metric] from [baseline] to [target] by [date], so that [strategic outcome].
```

### Solution vs outcome — the test

| Written as a solution (wrong for a BRD) | Written as an outcome (right) |
|---|---|
| "Build an automated rebate engine." | "Reduce complaints arising from missed appointments from 1,840 to below 900 per quarter by FY27 Q2." |
| "Add a self-service password reset page." | "Cut password-related support tickets by 30% within a year." |
| "Migrate to the new payments provider." | "Lower payment processing cost per transaction by 15% by FY-end." |

> **Rule:** if an objective names a screen, feature, system or technology, it has leaked solution
> detail. Rewrite it as the measurable outcome. The operational tolerance belongs in the ORD and
> the technical figure in the SOAP; functional detail has no document here and is registered rather
> than passed on.

### The cost-of-failure statement

An objective states what is gained. A **cost-of-failure statement** states what is lost, and it is
the input the ORD converts into a tolerance:

```
If [business metric] is not held, the consequence is [named consequence]
at [quantified cost], because [obligation, contract or mechanism].
```

Without it, an ORD tolerance is either traceable to nothing or invented. This is the single most
common upstream cause of a low-maturity ORD.

---

## Where the BRD sits in the chain

The BRD sits highest and holds **no requirement detail**. Everything below it is a transformation
performed by someone who did not author the input.

```
BRD  →  ORD  →  SOAP  →  Capability AC  →  Epic AC
why     what the      how it will      what will      what will
        business      be met           be accepted    be built
        requires
```

| Altitude | Artefact | Holds | Authored by |
|---|---|---|---|
| Why — the outcome | **BRD** | Business objectives, stakeholders, business case, cost of failure | Business analysis |
| How well it must serve the business — operational demand | **ORD** | Quantified business tolerance across the nine ISO/IEC 25010 characteristics, and the impact register | ORD convenor |
| How the demand is met — the technical answer | **SOAP** | Availability figures, RTO/RPO, latency budgets, capacity, infrastructure, support model | Solution architecture |
| What will be accepted | **Capability AC** | Acceptance criteria derived from the SOAP | Product Manager |
| What will be built | **Epic AC** | Build-level acceptance criteria | Technology BA |

**The ORD is a demand document, not a design one.** It states what the business can tolerate;
architecture's response — the Solution on a Page — derives the technical figure that satisfies it.
See [Roles at the boundary](#roles).

**One artefact is missing from this chain, and the BRD feels it first.** There is no functional
requirements document between the BRD and the Capability. A business rule the BRD correctly declines
to carry has nowhere to go, so it is inferred later during Epic decomposition — or, if elicited
during ORD work, held in the referred requirements register as an interim record.

### The decision that actually recurs: tolerance or figure?

Once a requirement is detailed, it is a *Solution* requirement, so the BRD is no longer a candidate.
For the operational half, the live question is whether the statement is a **business tolerance** —
the ORD's — or a **technical figure** — the SOAP's.

| Requirement detail | Classification | Lands in |
|---|---|---|
| "Authorisation delay beyond 3 seconds causes measurable cart abandonment, at $X per point" | Business tolerance, performance efficiency | **ORD** §3.1.1 |
| "Payment authorisation P99 ≤ 800 ms" | Technical target | **SOAP** — architecture's answer to the tolerance above |
| "Checkout unavailability in peak trading costs $X per hour and breaches merchant obligation Y" | Business tolerance, reliability | **ORD** §3.2.1 |
| "99.99% monthly availability" | Technical target | **SOAP** |
| "PCI-DSS applies; a breach carries penalty X and loss of acquiring" | Compliance obligation | **ORD** §3.3.6 |
| "Card data tokenised, no PAN at rest" | Technical control | **SOAP** |
| "Customer pays in one tap with a saved card" | Functional behaviour | **No document** — inferred at Epic decomposition, or registered as a referred requirement |
| "Refunds over $500 require supervisor approval" | Business rule | **No document** — as above |
| "Tier 2 support staffed at 4 FTE, follow-the-sun" | Staffing | **Referred requirements register** |

> **The test when a detail resists placement.** **Existence:** does architecture's answer to this
> document already exist? If not, a technical figure in the ORD is an antipattern regardless of how
> well it traces — a well-justified RTO is still architecture's to set.

> **Net:** the BRD deliberately holds no detail. The decision made day to day is **tolerance or
> figure** — and, for anything functional, **which register receives it**, since no document will.

---

## The handoff gate — is this BRD ready for ORD development? ★

The BRD's author owns this gate. It is the exit criterion for the BRD and the entry criterion for
the ORD, and it is stated here rather than in the ORD standard because a document's readiness is
its author's to establish, not its recipient's to adjudicate after the fact.

**Assessed before ORD development is assigned, not after.** The ORD's own entry criteria (E1–E9)
record what arrived; this gate establishes whether what arrived is enough to start.

**What puts an item on the bar, and what does not.** An item is on the bar where its absence makes
the next document **unwritable** — not merely less mature. Everything whose absence the maturity
tier can absorb is a supporting item. That rule is what keeps the two lists from being a matter of
taste, and it is the same rule [§7.1](#handoff) applies one hop downstream.

### How a `[TBD]` is treated — read this before the bar

The pack's rule against inventing a threshold means a BRD arrives with declared gaps, and a gate
that treats every gap as an absence refuses every real document. A gate that treats every gap as
satisfied refuses none. Neither is useful, so the treatment is stated rather than left to judgement:

| The item carries | Treatment |
|---|---|
| A value | **Met** |
| `[TBD]` with a **named owner and a date** | **Declared gap.** The item is met *for the bar*; the gap propagates — the objective it sits on carries no tolerance, and its traceability row stays visibly empty |
| `[TBD]` with no owner, or no date, or neither | **Absent.** Not a gap, a hole. It fails the bar |
| Nothing at all | **Absent** |

**Two limits, and without them the bar is unfailable.** A declared gap is not a free pass:

1. **At least one objective is fully quantified** — baseline, target and date, no `[TBD]`. It is
   what the ORD derives its first tolerances from. A BRD whose every objective is `[TBD]` fails
   BH-1 however well-owned the gaps are.
2. **The gap does not sit on the objective the change is funded against.** Where the business case
   rests on the objective that is unquantified, the case is unquantified, and no downstream document
   can repair that.

> **The point of the propagation rule.** A declared gap that passes the bar and then disappears is
> worse than a refusal, because it looks like a pass. Every gap admitted here **must** reappear as
> an empty traceability row and an unanswered objective downstream — see BO-4, which does exactly
> that at §12 of the worked example and again on the [traceability matrix](#traceability).

### The bar — four items, and their absence is a refusal

These four are what an ORD cannot be written without. Each maps to a load-bearing element the ORD
consumes immediately.

| # | Required | Consumed by | Absent means |
|---|---|---|---|
| **BH-1** | A named business objective carrying a **baseline, a target and a date**. Assessed per objective; the two limits above govern how many may be declared gaps | Every tolerance traces here. It is what establishes *why* two billing cycles rather than three | Every ORD requirement is orphan scope, and no tolerance is auditable |
| **BH-2** | Each objective stated as an **outcome, not a solution** — no feature, system, vendor or asserted figure | Leaves the ORD something to add | The BRD has pre-empted the ORD. The figure is asserted rather than derived, and the architecture review becomes ratification |
| **BH-3** | **Constraints and dependencies carrying operational weight** — regulatory obligations, contractual commitments, platform dependencies, named specifically | Seeds Security, Compatibility and Reliability | The ORD author invents them or misses them |
| **BH-4** | A **cost-of-failure case** for each objective carrying operational exposure | The input every tolerance is derived from | A tolerance traced to no consequence is an invented figure, however well it is written. The single most common upstream cause of a low-maturity ORD |

> **BH-1 to BH-3 are the three load-bearing elements at [§3.4](#entry); BH-4 is the fourth, and it
> is the one most often assumed to be optional.** A complete BRD is not the bar — these four are.
> A BRD carrying only these and nothing else is enough to start on.

### Supporting items — absent, these are recorded and drive the tier

Their absence does not stop ORD development. It determines the maturity tier committable on the
fixed date, and each is recorded under [§3.3](#entry) at assignment.

| # | Required | Absent means |
|---|---|---|
| **BH-5** | **Stakeholder register** naming who approves, who funds and who is affected | The author is least placed to compile it. A late list does not cost the days it was late — it costs the back half of the ORD |
| **BH-6** | The **approving GMs named**, one per business unit in scope | Unknown approvers surface at sign-off rather than at the start |
| **BH-7** | **Business scope, in and out**, with the out-list explicit | Silent scope growth, and the ORD extends the operational boundary beyond what was authorised |
| **BH-8** | **Appendix A — process and system scope**, each row carrying a named owner | The ORD is not sizeable at assignment, so it is sized on a guess and re-sized later. Half the impact register has to be reconstructed from stakeholder recall, at stakeholder cost |
| **BH-9** | A **traceability skeleton** — each objective against the tolerance expected to quantify it, or an explicit blank | A funded objective with no operational demand stated is invisible until nobody delivers it |
| **BH-10** | **Business requirements stated at business altitude** — no workflow, system or figure | Solution detail leaks downstream and the ORD inherits an answer instead of a question |

### The four outcomes

| Outcome | Condition | What follows |
|---|---|---|
| **Accepted** | BH-1 – BH-10 met, no declared gaps | ORD development starts. The entry position record carries no outstanding items |
| **Accepted with recorded gaps** | BH-1 – BH-4 met; one or more items outstanding, **each with a named owner and a date** — a declared gap on a bar item, a supporting item outstanding, or both | ORD development starts. The gaps are recorded at [§3.3](#entry) and determine the committed maturity tier where they reach a KPP-bearing requirement |
| **Accepted with an unowned gap** | BH-1 – BH-4 met; an outstanding item has **no owner to carry it** | ORD development starts. The item is recorded at [§3.3](#entry) and **raised with the approving GMs at sign-off rather than referred, because a referral needs a recipient.** It stays open until someone accepts it — and that it stayed open is the finding |
| **Not accepted for ORD development** | Any of BH-1 – BH-4 absent, per the `[TBD]` rule above | Returned to the author with the absent items named. **The ORD task is a BRD task in disguise** — see the antipatterns at [§3.4](#entry) |

**Where more than one row applies, the outcome is the most serious of them** — the refusal first,
then the unowned gap, then recorded gaps. The worked assessment below carries declared gaps at BH-1
and BH-4 *and* an unowned one at BH-8, and lands on the third outcome rather than the second.

**The second row covers a declared gap wherever it sits, including on the bar.** A bar item carrying
`[TBD]` with an owner and a date is met *for the bar* under the rule above, but the document is not
gap-free — so it is neither the first outcome nor a refusal. Reading the row as supporting-items-only
left that document matching no outcome at all.

**The third outcome is the one most documents land on, and it exists because the second could not
hold it.** An item outstanding *with* an owner is a scheduling problem. An item outstanding with
**nobody to own it** is a finding about the organisation rather than about the document, and
collapsing the two loses the more serious of them.

**Requesting the detail before ORD development proceeds is the correct response, not an
escalation.** An ORD written from a BRD missing its bar produces figures nobody can defend, and
the cost of that lands after architecture has designed against them.

> **This outcome depends on a right the standard says is currently absent, and that is worth
> stating plainly rather than glossing.** The [ORD Intake and Maturity Standard](#purpose) is a
> **declaring** standard, not a blocking one — every other mechanism in it produces a record rather
> than exercising a veto, precisely because a record is available to someone holding no authority.
> *Not accepted for ORD development* is the one outcome in this pack that requires authority: the
> Tier 1 control **"right to declare an ORD not-ready and refuse handoff"** at
> [§8](#controls), listed there as a control **to be established**.
>
> **Where that right is not yet held**, the outcome is *recorded* rather than exercised: the ORD
> proceeds, the absent bar items are recorded at [§3.3](#entry), and the committed tier reflects
> them. That record is the evidence for establishing the control — a refusal that was warranted,
> declared, and overridden is a stronger argument than the same right requested on day one.

---

## Worked example — BRD-2026-041, Missed Appointment Rebate (Acme Communications)

**Document:** BRD-2026-041 · **Status:** Approved · **Priority:** P1
**Executive sponsor:** Chief Customer Officer · **Author:** Business Analysis
**Horizon:** FY26 H2 – FY27 Q2 · **Standard:** BABOK v3

> **One worked example runs the pack's live chain.** This BRD is the upstream document for the
> [worked example ORD](#example) and for the [traceability matrix](#traceability). Its objectives,
> constraints and scope are the ones that ORD's tolerances trace back to, so the three can be read
> as one chain rather than three unrelated illustrations. Copy the shape, not the figures.
>
> **One page stands outside it, deliberately.** The [PRD standard](#prd) carries a self-contained
> example, because the chain documented here has no functional requirements column to run one
> through. That exception is the gap, not an inconsistency.

### 2 · Executive summary

Acme Communications is contractually obliged to credit a customer whose installation appointment is
missed. That credit is issued today only when the customer complains. The result is a complaint
volume of **1,840 per quarter** that exists largely to claim money already owed, and an unquantified
population of customers who are owed a credit and never received one. This programme makes the
rebate determination automatic, reducing complaints below 900 per quarter by FY27 Q2 and closing the
compliance exposure that the complaint-driven process conceals.

### 3 · Business need — the position today

| | Today | Consequence |
|---|---|---|
| Rebate trigger | Issued **only when a customer complains** | A customer who does not complain does not receive a credit clause 14.3 obliges Acme to pay |
| Complaint volume | 1,840 per quarter (FY25 Q4 baseline, INC-4471 theme analysis) | Contact-centre load generated by customers claiming money already owed |
| Attendance record | Attendance and non-attendance are **not recorded distinguishably** | A missed appointment cannot be determined from field data; the customer is the detection mechanism |
| Rebate determination | Manual, on receipt of a complaint | Determination depends on an agent reconstructing the appointment history within the call |
| Contract change | Clause 14.3 amended twice since 2023; each amendment required a software release | The rebate amount and qualifying window lag the contract they implement |
| Unclaimed exposure | Not measured | `[TBD — source: "that credit is issued only when a customer complains"]` — Regulatory Affairs to quantify |

**The last row is left open on purpose.** The exposure is real and its size is not known, and
inventing a figure to avoid an empty cell is the failure this standard exists to prevent. It is
carried as a visible gap with a named owner rather than as a number nobody can defend.

### 4 · Business objectives and success measures ★

| ID | Objective (SMART) | Baseline | Target | By |
|---|---|---|---|---|
| BO-1 | Reduce complaints arising from missed installation appointments | 1,840 / quarter (FY25 Q4) | < 900 / quarter | FY27 Q2 |
| BO-2 | Issue the rebate owed under clause 14.3 without the customer making contact | 0% issued unprompted | ≥ 95% of determined rebates | FY27 Q2 |
| BO-3 | Bring the rebate amount and qualifying window into effect within one billing cycle of a contract change | Release-dependent; two amendments since 2023 | ≤ 1 billing cycle, no release | FY27 Q2 |
| BO-4 | Close the unclaimed-rebate exposure carried under clause 14.3 | `[TBD — Regulatory Affairs, due 2026-08-15]` | `[TBD]` | FY27 Q2 |
| BO-5 | Answer a regulatory enquiry into any appointment's rebate position within one business day | Manual reconstruction, duration not measured | ≤ 1 business day | FY27 Q2 |

**BO-4 is unquantified and stays in the register.** An objective with a `[TBD]` and an owner is a
tracked gap; the same objective omitted is invisible. It is the objective most likely to change the
business case, which is why it is not deferred out of the document.

### 5 · Stakeholders ★

| Stakeholder | Interest | Role |
|---|---|---|
| Chief Customer Officer | Complaint volume and customer trust | Executive sponsor; approves spend |
| GM Customer Care | Complaint handling, customer channel | **Approves the ORD**; owns the operational consequence |
| GM Field Operations | Attendance capture and contractor data | **Approves the ORD** |
| GM Billing | Rebate application, billing-cycle boundary | **Approves the ORD** |
| Regulatory Affairs | Clause 14.3 interpretation, enquiry response | Consulted; owns BO-4's quantification and OQ-01 |
| Contract Manager, Field Services | Attendance-data timeliness under the field services agreement | Consulted; constrains scope |
| Solution Architecture | The design that answers the ORD | Authors the SOAP |
| Product Manager | What will be accepted | Authors the Capability acceptance criteria |
| Affected customers | Receiving the credit they are owed | Affected; not consulted directly |

**Three GMs approve the ORD, and none of them approves this document.** The obligation is
contractual and the consequence lands across three business units, so the operational tolerance is
committed by the units that carry it rather than by the sponsor who funds the change.

### 6 · Current vs future state

**Current:** the customer is the detection mechanism. A missed appointment is discovered when the
customer calls, determined by an agent reconstructing history mid-call, and credited manually.
Customers who do not call are not credited.

**Future:** a missed appointment is determined from data captured during the field job, the rebate
is applied within the contracted window without customer contact, and the complaint path carries
only genuine exceptions.

### 7 · Business scope

**In:** appointment completion, rebate determination, rebate application and customer notification,
across Field Operations, Customer Care and Billing. **At go-live: residential installation
appointments.**

**Out:** business and assurance appointments — **phased to a later release**, and the reason BO-1's
target is set against residential volume only. Also out: contact-centre staffing, hosting and
infrastructure, and commercial renegotiation of the field services agreement.

### 8 · Business requirements ★

- **BR-1:** A customer whose installation appointment is missed receives the contracted rebate
  without contacting Acme.
- **BR-2:** A customer establishes their own rebate position through a channel they already use.
- **BR-3:** The rebate amount and qualifying window track the consumer contract without a software
  release.

> Note the altitude. None of these names a workflow, a system or a figure. "Attendance capture in
> the workforce management platform" and "within two billing cycles" appear nowhere here — the first
> is the SOAP's answer, the second is the ORD's tolerance.

### 9 · Constraints, assumptions and dependencies

| | Statement | Operational weight |
|---|---|---|
| Constraint | Consumer contract cl. 14.3 — rebate payable within two billing cycles of the missed appointment | Sets the tolerance the ORD quantifies |
| Constraint | Consumer contract cl. 14.5 — no duplicate credit; cl. 14.6 — seven-year retention | Bound determination and auditability |
| Constraint | Field services agreement §9 — contractor attendance data supplied within 24 hours | Bounds how current any determination can be |
| Constraint | Billing cycle boundary — monthly, per customer | Fixed. Not a design choice, and it bounds every tolerance expressed in cycles |
| Assumption | Contractors submit attendance through the existing channel without process change | If wrong, a commercial variation lands on the critical path |
| Dependency | Contractor portal data-quality remediation (Field Systems programme) | **At risk.** Determination rests on attendance data of known imperfect quality |

### 10 · Risks

| Risk | Business consequence | Mitigation |
|---|---|---|
| Rebates determined from imperfect attendance data | A small number of credits issued where an operative did attend | Accepted — over-issue cost sits materially below the complaint cost BO-1 quantifies |
| Clause 14.3's "two billing cycles" is interpreted from confirmation rather than from the appointment | Every tolerance expressed in cycles moves | Regulatory Affairs interpretation due 2026-08-15 (OQ-01) |
| Rebate eligibility rules are inferred rather than elicited | Rules reach build unchecked with the business | **Unmitigated in this chain** — no functional requirements document exists to receive them |

### 11 · Cost–benefit and cost of failure ★

**Benefit.** Complaint volume falls by an estimated 940 per quarter at target, against the fully
loaded handling cost of a contact. Validated by Finance.

**Cost of failure**, and it is what the ORD's tolerances are derived from:

| If this is not held | Consequence | Source |
|---|---|---|
| The rebate is not applied within two billing cycles | Breach of consumer contract clause 14.3, per affected customer | Consumer contract v11 |
| Determination stops when an attendance source is interrupted | 2,300 jobs went unreconciled in a 19-hour contractor portal outage | INC-5012 |
| The rebate is issued only on complaint | Unquantified population owed a credit and never paid | `[TBD — Regulatory Affairs, due 2026-08-15]` |

**Without this section the ORD has nothing to quantify against.** A tolerance traced to no
consequence is an invented figure, however well it is written.

### 12 · Traceability ★

| Objective | Business req | Quantified as (ORD tolerance) |
|---|---|---|
| BO-1, BO-2 | BR-1 | ORD-03 **[KPP]** — rebate applied within two billing cycles |
| BO-1 | BR-1 | ORD-04 **[KPP]** — determination survives a 24-hour source interruption |
| BO-2 | BR-1 | ORD-15 — a missed appointment is determinable without re-keying |
| BO-2 | BR-2 | ORD-13 — rebate position established through an existing channel |
| BO-3 | BR-3 | ORD-10 — rebate parameters changed without a release |
| BO-5 | BR-2 | ORD-12 — rebate position reportable within one business day |
| BO-4 | — | **No tolerance yet.** Blocked on the `[TBD]` at §11 |

**BO-4's empty row is the useful one.** An objective with no operational tolerance is either not
operationally relevant or not yet quantified — and which of the two it is has to be recorded, not
inferred. The full chain onward to the SOAP and the acceptance criteria is on the
[traceability matrix](#traceability).

### Appendix A · Process and system scope ★

The L1–L3 process areas and the systems in scope, each with a named owner. **This is what makes the
ORD sizeable at assignment** — the impact counts that set S/M/L are read off it, and it seeds the
ORD's impact register.

| Kind | In scope | Owner |
|---|---|---|
| L1–L3 process | Order-to-Activate — appointment booking, field dispatch, attendance capture | Process owner, Field Operations |
| L1–L3 process | Bill-to-Cash — rebate determination and application | Process owner, Billing |
| L1–L3 process | Customer contact and complaint handling | Process owner, Customer Care |
| System | Workforce management platform | Application owner, Field Operations |
| System | Billing engine | Application owner, Billing |
| System | CRM / customer record | Application owner, Customer Care |
| System | Contractor portal | Application owner, Field Operations |
| System | Customer notification service | **Unowned — open** |

**The unowned system is recorded, not resolved.** The notification service appears in the estate
with its owning team vacant. That is a finding about Acme's ownership records rather than about this
change, and it is raised at sign-off — a referral needs a recipient, and there is not one.

**Sizing read from this appendix:** three business units, five objectives, **eight stakeholders** —
the §5 register's nine rows less the affected-customer group, which is not consulted directly — and
nine impacted workflows and systems once the ORD's register is populated
(three L1–L3 process areas resolving to four L4 workflows, plus five systems) — **Medium**.

### The handoff gate, applied to this document

Run against the [gate above](#brd). This is what a real assessment looks like — not a clean sheet.

| # | Verdict | Evidence |
|---|---|---|
| BH-1 | **Met, with one declared gap** | BO-1, BO-2, BO-3 and BO-5 each carry a baseline, a target and FY27 Q2. **BO-4 carries `[TBD]` with Regulatory Affairs and 2026-08-15** — a declared gap under the rule above: owned, dated, and not the objective the case rests on, with BO-1 fully quantified. It propagates rather than vanishing — §12 leaves its row empty, and so does the [traceability matrix](#traceability) |
| BH-2 | **Met** | No objective or business requirement names a system, workflow or figure. This BRD's §8 states three outcomes |
| BH-3 | **Met** | §9 — consumer contract cl. 14.3 / 14.5 / 14.6, field services agreement §9, and the billing-cycle boundary, each with its operational weight stated |
| BH-4 | **Met, with one declared gap** | §11 — three consequences, two sourced to the contract and INC-5012. The third is BO-4's, `[TBD]` with Regulatory Affairs and 2026-08-15; it is the same gap as BH-1's, propagating from the objective to its cost case |
| BH-5 | **Met** | §5, nine rows with interest and role |
| BH-6 | **Met** | Three GMs named — Customer Care, Field Operations, Billing |
| BH-7 | **Met** | §7, with the out-list explicit and the phasing reason stated |
| BH-8 | **Unowned gap** | Appendix A is complete **except the customer notification service, which has no owning team.** There is nobody to carry it, so it is neither met nor owned — the case the third outcome exists for |
| BH-9 | **Met** | §12, with BO-4's row explicitly blank rather than omitted |
| BH-10 | **Met** | BR-1 – BR-3 hold no workflow, system or figure |

> **Outcome: Accepted with an unowned gap.** The bar is met — BH-1 and BH-4 carry one declared gap
> between them, owned by Regulatory Affairs and dated. BH-8 is the unowned one: it is carried
> forward into the ORD as entry criterion **E9 — Partial** and as **IMP-07**, raised with the
> approving GMs at sign-off rather than referred, and it stays open until someone accepts it.
> **That it stayed open is the finding** — about Acme's ownership records, not about this change.
>
> **Note what neither gap did.** Neither moved the maturity tier. The
> [worked example ORD](#example) commits **Tier B** because both KPPs are Provisional — the tier is
> the weakest status carried by any KPP-bearing requirement, and an unowned system in the estate is
> not one. A recorded gap drives the tier only where it reaches a KPP. Recording it and tier-driving
> it are two different things, and conflating them is how a gate becomes theatre.

---

*Standard of record: BABOK v3. Companion pages: the [ORD Intake and Maturity Standard](#purpose)
for operational demand, the [worked example ORD](#example) for what BRD-2026-041's objectives become
as tolerances, the [traceability matrix](#traceability) for the chain end to end, and the
[PRD standard](#prd) for the functional half — defined, and not adopted in this chain.*

---

<!-- from reference/ord-intake-standard.md -->

**Step 1 — size the change from the BRD.**

| Size | Indicators | Effort |
|---|---|---|
| **S — Small** | One business unit; 1–3 business objectives; change to an existing service; ≤4 stakeholders; **≤5 impacted workflows and systems combined**; no cross-program dependency; rules already settled | ~4 effort days |
| **M — Medium** | 2–3 business units; 4–6 objectives; ≤8 stakeholders; **6–15 impacted workflows and systems**; one or two cross-program dependencies; some rules to resolve | ~6 effort days |
| **L — Large** | Multiple business units or programs; novel capability; material regulatory or contractual exposure; >8 stakeholders; **more than 15 impacted workflows and systems, or systems owned by different programs**; cross-program conflicts requiring adjudication | ~9 effort days |

**On the impact counts.** They are indicative bands in the same spirit as the stakeholder and objective counts, not measured thresholds. At assignment the count is an estimate read off the BRD's L1–L3 scope; it firms up during document analysis on effort days 2–3, which is the first point at which the register is populated rather than guessed. **A count that lands in a different band than the one assumed is a re-size trigger**, not a variance to absorb: re-read §4.1 and §4.7.3 from the days remaining, and record the change under §3.3. Owner count matters as much as item count — fifteen workflows under two process owners is a smaller elicitation than six under six.

These are **collection effort only** — the §4.5 sequence. Refinement is deducted separately (§4.3) rather than carried inside them, because it behaves differently and is present on some engagements and not others.
