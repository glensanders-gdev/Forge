# write-brd — standard extract

> **Generated file. Never hand-edit.** Produced by `tools/build-review-criteria.py`
> from the requirements-documents pack, which is the single source of truth for
> everything below. Editing this file puts it out of step with the pack; regenerate
> instead.

**Pack version:** v1.13 · **Pack commit:** `ac32d882c846`
**Generated:** 2026-09-08 · **Content hash:** `85f178e0e4b29a84`

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

**Version:** 1.13 · **Last updated:** 2026-09-08 · **Status:** Approved
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
| 1 | **Document control** | **Doc ID**, version, author, sponsor, approval status, date |
| 2 | **Executive summary** | Five labelled lines — the problem, what will be true, the cost of not acting, what is open, and what is being asked. Restates no value |
| 3 | **Business need / problem** | One **problem statement** at business altitude, then the position that evidences it. No solution |
| 4 | **★ Business objectives and success measures** | SMART objectives with baseline and target. The BRD's measurability |
| 5 | **★ Stakeholders** | Stakeholder register — who is interested, who funds, who is affected, and their role |
| 6 | **★ Approving GM register** | Who approves the ORD, one row per business unit in scope. Approval, not interest |
| 7 | **Current vs future state** | Where the business is now and the target operating state, in business terms |
| 8 | **Business scope (in / out)** | Which business areas, processes or segments are in and out, and — where the change is phased — which phase this document covers. Not feature scope |
| 9 | **★ Business requirements** | Stakeholder requirements — a named stakeholder's need stated as an outcome — and the register of what was routed out |
| 10 | **Constraints, assumptions and dependencies** | Regulatory, contractual and time constraints; assumptions with a status; dependencies with a status |
| 11 | **★ Cost of failure** | What is lost when the objective is not met — the input every operational tolerance is derived from |
| 12 | **★ Traceability** | Stakeholder requirement → business objective, and each objective onward to the ORD tolerance expected to quantify it. Proves every build traces to a justification |
| App. A | **Process and system scope** | The L1–L3 process areas and the systems in scope, each with a named owner. Seeds the ORD's impact register |

> **The six ★ sections close the gaps most BRDs miss**: SMART objectives, a real stakeholder
> register, a named approver per business unit, stakeholder requirements kept free of solution
> detail, a cost-of-failure case, and traceability up to the objective and down to the ORD. Enforce
> these and the rest follows.

**Appendix A is what makes the ORD sizeable at assignment.** The impact counts that set S/M/L in the
lead-time standard are read off it. A BRD with no process or system scope leaves the size to be
guessed and re-sized later.

### Two sections this standard used to carry, and no longer does

Both were removed because the BRD was the wrong home, not because the content stopped mattering.

| Removed | Where it goes now | Why |
|---|---|---|
| **Risks** | The **RAID log**, and the BRD cites the `R-NNN` where an objective depends on one | A risk has an owner, a status and a review cadence, and it outlives the document that first noticed it. A risk table inside a BRD is a snapshot that is wrong by sign-off, and it is maintained nowhere |
| **Cost–benefit** | Nowhere — it was restating §4 | An objective already carries a baseline, a target and a date. The benefit *is* the movement between baseline and target, quantified, and restating it as a return figure creates a second number to keep in step with the first. **Cost of failure stays**, at §11, because nothing else states it |

**Deleting cost–benefit is not deleting the business case.** The case is §2, §3 and §4 read together:
the problem, the objectives that close it, and the cost of not closing them. What was deleted is the
restatement.

### State it once

**A statement belongs in exactly one section, and every other section that needs it refers to it by
ID.** A second occurrence is a *view* of the first: it restates the ID and adds no new number. This
is the single largest source of length in a real BRD.

| The temptation | Where it belongs | What the other sections carry |
|---|---|---|
| Repeat the baseline figure in the executive summary, the business need and the objective | §4, in the objective row | §2 and §3 name the problem; the number is read from §4 |
| Restate a declared gap in every section it touches | §4, on the objective carrying it | An empty cell or an explicit blank row, which is what makes the gap visible |
| Restate a constraint's figure in the objective it bounds | §10, in the constraint row | The objective names the constraint, not its value |
| Restate a cost-of-failure consequence in the business need | §11 | §3 states the problem; §11 states what it costs |

> **The test.** If a figure appears twice, one of the two is a copy that will not be updated when the
> other changes. Cite the section and the ID instead. A BRD that reads as repetitive is usually a BRD
> that has put the same fact in four places, and it is *longer* rather than more thorough.

### Phasing — optional, and one BRD per phase where the change is large

Where the change is delivered in phases, §8 states **which phase this document covers** and what is
deferred to a later one. The phasing subsection is optional: a change delivered in one release omits
it, and its absence is not a gap.

| | Form |
|---|---|
| Phase table | `Phase` · `Business scope of this phase` · `Deferred to` · `Why the split` |
| In an out-list | An item deferred to a later phase is **out of scope of this document**, with the phase named — not silently absent |

**For a large change, the recommendation is a BRD per phase rather than one BRD carrying every
phase.** The reason is the objective, not the length: a SMART objective carries one target and one
date, and a change spanning three phases either states three targets in one row — which nothing can
be assessed against — or states the final target only, leaving the first two phases funded against a
number they were never going to reach. One document per phase gives each phase an objective that can
be met or missed on its own date.

- **Each phase's BRD carries its own Doc ID**, and names the others in §1.
- **The objective is set against the scope of its own phase.** Where a target is set against a
  population only a later phase reaches, say so in the objective row — the worked example's BO-1 is
  set against residential volume for exactly this reason.
- **Where one BRD does carry every phase**, that is a choice, not a default: state why, and state
  which phase each objective's target belongs to.

**One problem statement still governs.** Phasing splits *delivery*, not the problem — three BRDs for
three phases of one change carry the same problem statement at §3 and differ at §4 and §8. Where the
phases have genuinely different problems, they are different changes.

---

## Writing the BRD — the forms

### Document control and the Doc ID

Every BRD carries a **Doc ID** in its front matter, and it is the first field rather than an
afterthought at the foot of the page. Everything downstream cites the document by it — the ORD's
entry position record, the traceability matrix, the RAID entries raised from it, and the sibling BRD
where the change is phased.

```
**Doc ID:** BRD-YYYY-NNN · **Version:** N.N · **Status:** Draft / In review / Approved · **Priority:** P1–P4
**Executive sponsor:** [role] · **Author:** [name or role]
**Horizon:** [FYnn Hn – FYnn Qn] · **Phase:** [n of m, or "single release"] · **Standard:** BABOK v3
```

- **`BRD-YYYY-NNN`** — the year the document was raised, and a sequence within it. Flat, never
  encoding a business unit or a programme, and never reused once retired.
- **A phased change carries one Doc ID per phase**, and each names the others in §1. A reader holding
  Phase 2 has to be able to find Phase 1 without knowing it exists.
- **The ID is assigned at first draft, not at approval.** A document that acquires its identity only
  when it is signed cannot be cited by the RAID entries and the referred requirements raised while it
  was being written — which is exactly when they are raised.

### The executive summary

§2 answers the five questions an executive asks, one line each, in this order. It is **an answer set,
not a paragraph** — a summary that has to be read as prose to find the ask has stopped being a
summary.

| Label | Answers | Reads from |
|---|---|---|
| **Problem.** | What is wrong, in one sentence at business altitude | §3's problem statement |
| **What will be true.** | Which objectives close it, and by when | §4, by `BO-N` and horizon |
| **Cost of not acting.** | What is lost if they are not met | §11 |
| **Open.** | What is unresolved at issue, with its owner and date | §4, §6, §10 and Appendix A |
| **Asked of you.** | The decision this document wants, and over what scope | §8, and the phase |

**§2 carries no number of its own.** Every figure sits behind a `BO-N`, a clause reference or a
section pointer — the reader who wants the baseline reads §4's row, where it is maintained. This is
§ *State it once* at the section that breaks it most often: an executive summary is written from the
brief, early, by someone summarising what they hope the document will say, and it then disagrees with
the document quietly for the rest of its life.

**Written last, from the sections that exist.** Never from the brief. A summary drafted first
promises what the register does not contain, and nobody re-reads it afterwards to find out.

**A label that cannot be filled is a finding, not a formatting problem.** Each empty line names
something specific:

| Cannot fill | What that means |
|---|---|
| **Asked of you** | The document has not established what decision it wants. It is a briefing paper, not a BRD |
| **Cost of not acting** | BH-4 is absent, and the gate will refuse the document. §2 found it first |
| **What will be true** | No objective is quantified — BH-1, and the two limits at § *How a `[TBD]` is treated* |
| **Problem** | §3 has described where a problem was noticed rather than what the enterprise loses |

**`Open: None` is written out, never deleted.** A missing line reads as *not considered*; the word
*None* reads as *considered, and there is nothing*. The difference is invisible unless it is written.

**§2 introduces no commitment that is not stated elsewhere.** It is narrative, and narrative that
originates an obligation puts it in the one place nothing traces to.

### The problem statement

§3 opens with **one problem statement**: the high-level problem being solved for the business, in a
form a reader who knows nothing about the estate can hold in their head. Everything else in §3 is
evidence for it.

**Problem statement form:**

```
[Named business population or process] [what is happening, or failing to happen],
costing [the enterprise consequence], because [the business mechanism that causes it].
```

| Written too low (wrong for §3) | Written at business altitude (right) |
|---|---|
| "Attendance is not recorded distinguishably in the workforce management platform, so the rebate job cannot determine eligibility." | "Customers owed a contractual credit receive it only if they complain, so the enterprise pays the customers who ask and carries an unmeasured liability to those who do not." |
| "Complaint handling time averages 11 minutes against a 6-minute target." | "Contact-centre capacity is consumed by customers claiming money the enterprise already owes them." |

> **The altitude test.** A problem statement that names a system, a screen, a team's tooling or an
> internal process step has described a *symptom at the point it was noticed*, not the problem. Ask
> what the enterprise loses. That answer is the problem statement; where it was noticed is evidence.

**One problem statement per BRD.** Where the source describes several problems, either they are
symptoms of one — say which, and state that one — or the change is two changes. Two unrelated
problems in one BRD produce objectives that compete for the same funding decision without the
decision ever being put.

**§3 carries the problem and the evidence for it, and nothing else.** It does not restate §4's
targets, §10's constraints or §11's consequences — see § *State it once*.

### The objective form

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

### The stakeholder register, and the approving GM register

**Two registers, because interest and approval are different things.** §5 records who cares about the
change and how. §6 records who signs the operational demand it produces. Collapsing them puts an
approver's authority in a table that also holds people who are merely informed, and the approver
becomes hard to find at exactly the moment sign-off is chased.

**§5 — the stakeholder register.**

| Stakeholder | Interest | Role |
|---|---|---|
| [named role, or group where the group is the stakeholder] | [what they stand to gain or lose] | Sponsor / Consulted / Affected / Authors [downstream document] |

**§6 — the approving GM register.** One row per business unit in scope, and the count of rows is
checkable against §8's scope and Appendix A's owners.

| Business unit in scope | Approving GM | Approves | Status |
|---|---|---|---|
| [unit, matching a §8 scope area] | [named GM] | The ORD's operational tolerance for this unit | Confirmed, or `[TBD]` carrying the owner who will confirm it and a date |

- **The BRD's sponsor is not automatically an approving GM, and often is not one.** The sponsor funds
  the change; the approving GM commits the unit that carries the operational consequence. Where the
  consequence lands across three units, three GMs approve and the sponsor approves none of it.
- **A business unit in §8's in-scope list with no row here is the finding**, not an omission to tidy
  up. It is the case BH-6 exists to surface.
- **Never infer an approver from an org chart.** An unconfirmed GM is `[TBD]` with the owner who will
  confirm it and a date, exactly as an unquantified objective is.

**Both registers are routinely incomplete at first draft, and that is expected.** The stakeholder the
author is least placed to identify is the one whose absence costs the most later. There is no second
mechanism for it: an unknown stakeholder or an unknown approver is a `[TBD]` carrying a named owner
and a date — see § *How a `[TBD]` is treated* — and it reaches the gate as a declared gap rather than
as a complete-looking list that happens to be wrong.

> **Few rows is not evidence of a simple change.** It is more often evidence of a short elicitation.
> Where §6 names fewer business units than Appendix A names process owners, one of the two is
> incomplete, and the gate reads both.

### The stakeholder requirement form

§9 holds **Stakeholder** requirements in the BABOK sense — the need of a named stakeholder or group,
which is the bridge between the business objective above it and the solution documents below. It
does **not** hold Business requirements restated at a lower altitude, and it does not hold functional
detail.

**Stakeholder requirement form:**

```
[Named stakeholder or group] requires [the outcome they need], stated without
naming a workflow, a system, a vendor or a figure.
```

| ID | Stakeholder | Stakeholder requirement |
|---|---|---|
| BR-N | [named role or group, traceable to a §5 row] | [the outcome that stakeholder requires] |

- **`Stakeholder` names a row in §5.** A requirement whose stakeholder is not in the register is
  either a stakeholder the register missed or a requirement nobody asked for, and which of the two
  it is has to be established rather than assumed.
- **The objective a requirement serves is not a column here.** It is §12's row — carrying it in both
  places is the restatement § *State it once* forbids, and §12 is where a requirement serving *no*
  objective becomes visible.
- **Writing at stakeholder altitude is what removes the need for a further document** to record a
  stakeholder's need. It is not licence to carry the functional detail that need implies: that
  detail is routed, below.

**What §9 declined to carry is recorded, not dropped.** A BRD that silently discards the functional
detail elicited alongside a stakeholder need loses it — there is no functional requirements document
in this chain to catch it. §9 therefore carries a second table:

| Statement raised | BABOK type | Routed to | ID there |
|---|---|---|---|
| "[quoted as elicited]" | Solution — non-functional | ORD, as business tolerance | `[ORD-TBD]`, written back |
| "[quoted as elicited]" | Solution — functional | Referred requirements register | `[REF-TBD]`, written back |
| "[quoted as elicited]" | Business rule | Referred requirements register | `[REF-TBD]`, written back |

**This table mints no IDs.** The register that receives a statement owns its own namespace and
writes the real ID back — the same mechanism the traceability skeleton uses for a tolerance that does not exist yet. A
row that never receives an ID is a routing that never happened, and that is the finding.

### The cost-of-failure statement

An objective states what is gained. A **cost-of-failure statement** states what is lost, and it is
the input the ORD converts into a tolerance:

```
If [business metric] is not held, the consequence is [named consequence]
at [quantified cost], because [obligation, contract or mechanism].
```

Without it, an ORD tolerance is either traceable to nothing or invented. This is the single most
common upstream cause of a low-maturity ORD.

### Constraints, assumptions and dependencies

Three different kinds of statement, and the difference is what is known about them. §10 carries each
in its own table rather than one merged list, because they have different lifecycles and only one of
them is fixed.

**Constraint — a given the change cannot move.** Regulatory obligation, contractual commitment,
statutory deadline, a boundary set outside the change. Not a design choice, and not a preference.

| Constraint | Source | Operational weight |
|---|---|---|
| [the given, with its value] | [contract clause, regulation, agreement] | [what it bounds downstream] |

**A constraint is identified by its source, not by a local ID.** "Consumer contract cl. 14.3" is
already unique, already citable downstream, and already the thing a reader has to go and read. A
BRD-local number in front of it adds a second identifier for the same obligation and nothing else —
and it is how two documents come to hold different numbers for one clause.

**Constraints are elicited, not recalled, and they are routinely not known at first draft.** Ask
against each of these, and record the answer — including *none found* — rather than leaving the
category unasked:

| Ask | Looks like |
|---|---|
| Regulatory and statutory | A licence condition, a reporting obligation, a retention period, a privacy rule |
| Contractual | A clause the enterprise is already bound by, in a customer, supplier or partner agreement |
| Time | A date set outside the change — a regulatory commencement, a contract expiry, a season |
| Financial | An approved envelope, a funding boundary, a capitalisation rule |
| Organisational | A change freeze, a mandated platform or supplier, an operating-model boundary |
| Prior commitment | Something already stated to a customer, a regulator or a market |

> **A category asked and answered *none found* is a record. A category never asked is a hole.** The
> difference is invisible in the finished document unless the empty answer is written down, which is
> why it is written down.

**A constraint nobody has confirmed yet is a `[TBD]` with a named owner and a date**, treated exactly
as an unquantified objective is — see § *How a `[TBD]` is treated*. There is no second mechanism for
not-yet-known: it is the same one, and inventing a constraint to avoid an empty row is the failure
the whole standard exists to prevent.

**Assumption — something believed true, pending confirmation.** It carries a status, and it carries
the consequence of being wrong.

| ID | Assumption | Status | If false | Owner | Confirm by |
|---|---|---|---|---|---|
| ASM-NNN | [declarative statement] | Unvalidated / Validated / Falsified | [consequence] | [named role] | [date] |

- **`If false` is mandatory.** An assumption with no stated consequence is a note.
- **A `Validated` assumption is no longer an assumption — it is a constraint**, and it moves to the
  constraint table with its source recorded as the validation. Leaving it in the assumption register
  at `Validated` is how a confirmed given goes on being treated as provisional by everyone
  downstream. The row is moved, not copied.
- **A `Falsified` assumption has no home in the RAID log** — RAID is Risks, Actions, Issues and
  Decisions, and has no assumptions quadrant. Set the status, raise the exposure as a risk in the
  RAID log, and record the `R-NNN` in the `If false` cell.
- **`Owner` and `Confirm by` are mandatory** wherever an objective, a constraint or a cost-of-failure
  statement rests on the assumption. An unowned, undated assumption underneath a funded objective is
  an invented number wearing a different label.

**Dependency — something outside the change that the change needs.** It carries a status, because a
dependency's whole risk is that its status changes without the BRD noticing.

| ID | Depends on | Type | Owner | Needed by | Status |
|---|---|---|---|---|---|
| DEP-NNN | [named system, team, programme or deliverable] | Internal / External / Vendor | [role] | [date or milestone] | Open / Met / At risk |

**`At risk` is a dependency status, not a risk in its own right.** Where the exposure needs managing
it is raised in the RAID log and the `R-NNN` cited here — the BRD carries no risk table of its own.

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
| "A customer acting on a generated summary that misstates their entitlement breaches obligation Y, at $X per occurrence" | Business tolerance, accuracy of generated output | **ORD** §3.8 |
| "Summary quality scores ≥ 4.0 of 5 mean on a held-out evaluation set, no single case below 2.5" | Technical target — the evaluation instrument | **SOAP** |
| "Customer pays in one tap with a saved card" | Functional behaviour | **No document** — inferred at Epic decomposition, or registered as a referred requirement |
| "Refunds over $500 require supervisor approval" | Business rule | **No document** — as above |
| "Tier 2 support staffed at 4 FTE, follow-the-sun" | Staffing | **Referred requirements register** |

> **The test when a detail resists placement.** **Existence:** does architecture's answer to this
> document already exist? If not, a technical figure in the ORD is an antipattern regardless of how
> well it traces — a well-justified RTO is still architecture's to set. **The test reaches an evaluation
> instrument unchanged:** a set that does not yet exist cannot carry a pass mark here, because the
> pass mark *is* the answer. The population the measure is taken over, and the consequence of
> breaching it, are the demand side and belong in the ORD.

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
| **BH-3** | **Constraints and dependencies carrying operational weight** — regulatory obligations, contractual commitments, platform dependencies, named specifically, each elicited against the categories at § *Constraints, assumptions and dependencies* rather than recalled | Seeds Security, Compatibility and Reliability | The ORD author invents them or misses them |
| **BH-4** | A **cost-of-failure case** for each objective carrying operational exposure | The input every tolerance is derived from | A tolerance traced to no consequence is an invented figure, however well it is written. The single most common upstream cause of a low-maturity ORD |

> **BH-1 to BH-3 are the three load-bearing elements at [§3.4](#entry); BH-4 is the fourth, and it
> is the one most often assumed to be optional.** A complete BRD is not the bar — these four are.
> A BRD carrying only these and nothing else is enough to start on.

### Supporting items — absent, these are recorded and drive the tier

Their absence does not stop ORD development. It determines the maturity tier committable on the
fixed date, and each is recorded under [§3.3](#entry) at assignment.

| # | Required | Absent means |
|---|---|---|
| **BH-5** | **Stakeholder register** naming who is interested, who funds and who is affected, each with their role | The author is least placed to compile it. A late list does not cost the days it was late — it costs the back half of the ORD |
| **BH-6** | An **approving GM register** — one row per business unit in scope, each naming the GM who approves the ORD for that unit | Unknown approvers surface at sign-off rather than at the start. A unit in scope with no row is the case this item exists to find |
| **BH-7** | **Business scope, in and out**, with the out-list explicit, and — where the change is phased — the phase this document covers | Silent scope growth, and the ORD extends the operational boundary beyond what was authorised |
| **BH-8** | **Appendix A — process and system scope**, each row carrying a named owner | The ORD is not sizeable at assignment, so it is sized on a guess and re-sized later. Half the impact register has to be reconstructed from stakeholder recall, at stakeholder cost |
| **BH-9** | A **traceability skeleton**, both directions — each stakeholder requirement against the objective it serves, and each objective against the tolerance expected to quantify it, or an explicit blank | A requirement serving no objective is unfunded scope; a funded objective with no operational demand stated is invisible until nobody delivers it. Tracing one direction only finds one of the two |
| **BH-10** | **Stakeholder requirements stated at stakeholder altitude** — a named stakeholder's outcome, no workflow, system or figure — with everything declined recorded in the routing register rather than dropped | Solution detail leaks downstream and the ORD inherits an answer instead of a question. Functional detail elicited and not routed is simply lost, because no document in this chain catches it |

### The four outcomes

| Outcome | Condition | What follows |
|---|---|---|
| **Accepted** | BH-1 – BH-10 met, no declared gaps | ORD development starts. The entry position record carries no outstanding items |
| **Accepted with recorded gaps** | BH-1 – BH-4 met; one or more items outstanding, **each with a named owner and a date** — a declared gap on a bar item, a supporting item outstanding, or both | ORD development starts. The gaps are recorded at [§3.3](#entry) and determine the committed maturity tier where they reach a KPP-bearing requirement |
| **Accepted with an unowned gap** | BH-1 – BH-4 met; an outstanding item has **no owner to carry it** | ORD development starts. The item is recorded at [§3.3](#entry) and **raised with the approving GMs at sign-off rather than referred, because a referral needs a recipient.** It stays open until someone accepts it — and that it stayed open is the finding |
| **Not accepted for ORD development** | Any of BH-1 – BH-4 absent, per the `[TBD]` rule above | Returned to the author with the absent items named. **The ORD task is a BRD task in disguise** — see the antipatterns at [§3.4](#entry) |

**Where more than one row applies, the outcome is the most serious of them** — the refusal first,
then the unowned gap, then recorded gaps. The worked assessment below carries declared gaps at BH-1,
BH-3 and BH-4 *and* an unowned one at BH-8, and lands on the third outcome rather than the second.

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

**Doc ID:** BRD-2026-041 · **Version:** 2.0 · **Status:** Approved · **Priority:** P1
**Executive sponsor:** Chief Customer Officer · **Author:** Business Analysis
**Horizon:** FY26 H2 – FY27 Q2 · **Phase:** 1 of 2 (Phase 2 — BRD-2026-058) · **Standard:** BABOK v3

> **One worked example runs the pack's live chain.** This BRD is the upstream document for the
> [worked example ORD](#example) and for the [traceability matrix](#traceability). Its objectives,
> constraints and scope are the ones that ORD's tolerances trace back to, so the three can be read
> as one chain rather than three unrelated illustrations. Copy the shape, not the figures.
>
> **One page stands outside it, deliberately.** The [PRD standard](#prd) carries a self-contained
> example, because the chain documented here has no functional requirements column to run one
> through. That exception is the gap, not an inconsistency.

### 2 · Executive summary

**Problem.** Customers owed a contractual credit for a missed installation appointment receive it
only if they complain (§3).

**What will be true.** BO-1 – BO-3 and BO-5, on the FY27 Q2 horizon (§4).

**Cost of not acting.** Breach of consumer contract cl. 14.3 per affected customer, and an unmeasured
population never credited (§11).

**Open.** BO-4 unquantified — Regulatory Affairs, 2026-08-15. One system in scope with no owning team
(Appendix A).

**Asked of you.** Approval to proceed to ORD development, Phase 1 — residential installation
appointments (§8).

**Not one figure appears here, and the section is stronger for it.** The earlier draft of this
summary carried 1,840, 900, FY27 Q2, clause 14.3 and the unclaimed population — five values owned by
§4, §10 and §11, each of which would have gone on disagreeing with its owner after the first
revision. **Open** carries a date because a date is not a commitment: it is the gap's own property,
and it is the line an executive acts on.

### 3 · Business need — the problem, and the position that evidences it

**Problem statement.** Customers owed a contractual credit for a missed installation appointment
receive it only if they complain — so Acme pays the customers who ask, carries an unmeasured
liability to those who do not, and funds a complaint channel that exists to claim money already owed.

**The position that evidences it:**

| | Today |
|---|---|
| Rebate trigger | Issued **only when a customer complains**. A customer who does not complain does not receive a credit clause 14.3 obliges Acme to pay |
| Complaint volume | 1,840 per quarter (FY25 Q4 baseline, INC-4471 theme analysis) — contact-centre load generated by customers claiming money already owed |
| Attendance record | Attendance and non-attendance are **not recorded distinguishably**, so the customer is the detection mechanism |
| Rebate determination | Manual, on receipt of a complaint, reconstructed by an agent within the call |
| Contract change | Clause 14.3 amended twice since 2023, each amendment requiring a software release |
| Unclaimed exposure | **Not measured** — `[TBD — Regulatory Affairs, due 2026-08-15]` |

**Three things this section does not do.** It does not restate BO-1's target — that is §4's row. It
does not restate clause 14.3's two-billing-cycle obligation — that is §10's constraint. It does not
restate what the exposure costs — that is §11. Each appears once, and §3 cites rather than copies.

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

**BO-1's target is set against residential volume**, which is Phase 1's scope at §8. A target set
against the population a later phase reaches would be unmeetable on this document's date.

**BO-4 is unquantified and stays in the register.** An objective with a `[TBD]` and an owner is a
tracked gap; the same objective omitted is invisible. It is the objective most likely to change the
business case, which is why it is not deferred out of the document.

### 5 · Stakeholders ★

| Stakeholder | Interest | Role |
|---|---|---|
| Chief Customer Officer | Complaint volume and customer trust | Executive sponsor; approves spend |
| GM Customer Care | Complaint handling, customer channel | Approver — §6 |
| GM Field Operations | Attendance capture and contractor data | Approver — §6 |
| GM Billing | Rebate application, billing-cycle boundary | Approver — §6 |
| Regulatory Affairs | Clause 14.3 interpretation, enquiry response | Consulted; owns BO-4's quantification and OQ-01 |
| Contract Manager, Field Services | Attendance-data timeliness under the field services agreement | Consulted; constrains scope |
| Solution Architecture | The design that answers the ORD | Authors the SOAP |
| Product Manager | What will be accepted | Authors the Capability acceptance criteria |
| Affected customers | Receiving the credit they are owed | Affected; not consulted directly |

**§5 records interest and role, and stops there. What each GM approves is §6's** — holding it in
both places is how the two come to disagree.

### 6 · Approving GM register ★

| Business unit in scope | Approving GM | Approves | Status |
|---|---|---|---|
| Field Operations | GM Field Operations | The ORD's operational tolerance for this unit | Confirmed |
| Customer Care | GM Customer Care | The ORD's operational tolerance for this unit | Confirmed |
| Billing | GM Billing | The ORD's operational tolerance for this unit | Confirmed |

**Three GMs approve the ORD, and none of them approves this document.** The obligation is
contractual and the consequence lands across three business units, so the operational tolerance is
committed by the units that carry it rather than by the sponsor who funds the change.

**Three rows against three in-scope business units at §8, and three process owners at Appendix A.**
That the three counts agree is the check this register exists to make possible.

### 7 · Current vs future state

**Current:** the customer is the detection mechanism. A missed appointment is discovered when the
customer calls, determined by an agent reconstructing history mid-call, and credited manually.
Customers who do not call are not credited.

**Future:** a missed appointment is determined from data captured during the field job, the rebate
is applied within the contracted window without customer contact, and the complaint path carries
only genuine exceptions.

### 8 · Business scope

**In:** appointment completion, rebate determination, rebate application and customer notification,
across Field Operations, Customer Care and Billing.

**Out:** contact-centre staffing, hosting and infrastructure, and commercial renegotiation of the
field services agreement. Also out of *this document*: everything at Phase 2 below.

**Phasing.** This BRD covers **Phase 1**.

| Phase | Business scope | Deferred to | Why the split |
|---|---|---|---|
| **Phase 1 — this document** | Residential installation appointments | — | Clause 14.3 exposure is concentrated in residential volume, and residential attendance data is the only source currently captured |
| Phase 2 | Business and assurance appointments | **A separate BRD** | The business appointment obligation sits under a different contract schedule, so it carries a different problem statement and a different approving unit |

**Phase 2 is a separate BRD rather than a later section of this one**, per the recommendation at
§ *Phasing*. It is not a larger version of this change: the obligation, the evidence and the
approving unit all differ, and one objective row cannot carry two targets on two dates.

### 9 · Business requirements ★

| ID | Stakeholder | Stakeholder requirement |
|---|---|---|
| BR-1 | Affected customers | A customer whose installation appointment is missed receives the contracted rebate without contacting Acme |
| BR-2 | Affected customers | A customer establishes their own rebate position through a channel they already use |
| BR-3 | Regulatory Affairs | The rebate amount and qualifying window track the consumer contract without a software release |
| BR-4 | GM Customer Care | Complaint handling receives only appointments where the rebate position is genuinely disputed |

> Note the altitude. None of these names a workflow, a system or a figure. "Attendance capture in
> the workforce management platform" and "within two billing cycles" appear nowhere here — the first
> is the SOAP's answer, the second is the ORD's tolerance. **Nor does any row name the objective it
> serves:** that is §12's, and it is where BO-4 having no stakeholder requirement becomes visible.

**Routed out of this document, and recorded rather than dropped:**

| Statement raised | BABOK type | Routed to | ID there |
|---|---|---|---|
| "Rebates over $500 are approved by a supervisor before issue" | Business rule | Referred requirements register | `[REF-TBD]`, written back |
| "The customer is notified in the channel they last used" | Solution — functional | Referred requirements register | `[REF-TBD]`, written back |
| "Determination survives a contractor portal interruption" | Solution — non-functional | ORD, as business tolerance | ORD-04 |
| "Tier 2 rebate disputes are staffed to the existing follow-the-sun roster" | Staffing | Referred requirements register | `[REF-TBD]`, written back |

**Three rows carry `[REF-TBD]` and one carries a real ID.** ORD-04 was written back when the ORD was
authored; the three referred rows are still awaiting a register that will accept them. That is the
routing gap this table exists to make visible — the alternative is that all four statements were
elicited, none was carried, and nobody can say so.

### 10 · Constraints, assumptions and dependencies

**Constraints.**

| Constraint | Source | Operational weight |
|---|---|---|
| Rebate payable within two billing cycles of the missed appointment | Consumer contract cl. 14.3 | Sets the tolerance the ORD quantifies |
| No duplicate credit for one appointment | Consumer contract cl. 14.5 | Bounds determination |
| Seven-year retention of rebate determinations | Consumer contract cl. 14.6 | Bounds auditability |
| Contractor attendance data supplied within 24 hours | Field services agreement §9 | Bounds how current any determination can be |
| Billing cycle boundary — monthly, per customer | Billing operating model | Fixed. Not a design choice, and it bounds every tolerance expressed in cycles |
| Privacy: rebate position is customer personal information | Privacy Act obligations, Legal to confirm scope | `[TBD — Legal Counsel, due 2026-08-29]` |

**Elicited and answered *none found*:** financial envelope constraints beyond the approved programme
funding, organisational change-freeze windows, and prior public commitments. Recorded so the
categories read as asked rather than as missed.

**Assumptions.**

| ID | Assumption | Status | If false | Owner | Confirm by |
|---|---|---|---|---|---|
| ASM-001 | Contractors submit attendance through the existing channel without process change | Unvalidated | A commercial variation to the field services agreement lands on the critical path | Contract Manager, Field Services | 2026-09-12 |
| ASM-002 | Clause 14.3's "two billing cycles" runs from the appointment, not from confirmation | Unvalidated | Every tolerance expressed in cycles moves, and BO-2's target with them. Raised as **R-114** | Regulatory Affairs | 2026-08-15 |
| ASM-003 | Residential appointment volume is a stable base for BO-1's target | **Validated** — FY24–FY25 volume analysis, Commercial Analytics, 2026-07-30 | — moved to the constraint table as a given | Commercial Analytics | Closed |

**ASM-003 shows the transition.** A validated assumption is no longer an assumption: it is a
constraint, and the row moves rather than sitting at `Validated` in a register everyone downstream
reads as provisional. The row is kept here with its status only until the move is made.

**Dependencies.**

| ID | Depends on | Type | Owner | Needed by | Status |
|---|---|---|---|---|---|
| DEP-001 | Contractor portal data-quality remediation | Internal (Field Systems programme) | Programme Manager, Field Systems | FY26 Q4 | **At risk** — determination rests on attendance data of known imperfect quality. Raised as **R-115** |
| DEP-002 | Consumer contract v12 execution, carrying the clause 14.3 amendment | External | Contract Manager, Consumer | FY27 Q1 | Open |

**No risk table.** ASM-002's and DEP-001's exposures are `R-114` and `R-115` in the RAID log, which
is where a risk has an owner, a status and a review cadence. A risk table in this document would be
a snapshot that is wrong by sign-off and maintained nowhere.

### 11 · Cost of failure ★

What is lost when an objective is not met, and it is what the ORD's tolerances are derived from:

| If this is not held | Consequence | Source |
|---|---|---|
| The rebate is not applied within two billing cycles | Breach of consumer contract clause 14.3, per affected customer | Consumer contract v11 |
| Determination stops when an attendance source is interrupted | 2,300 jobs went unreconciled in a 19-hour contractor portal outage | INC-5012 |
| The rebate is issued only on complaint | Unquantified population owed a credit and never paid | `[TBD — Regulatory Affairs, due 2026-08-15]` |

**Without this section the ORD has nothing to quantify against.** A tolerance traced to no
consequence is an invented figure, however well it is written.

**There is no cost–benefit table, and its absence is deliberate.** The benefit is BO-1's movement
from 1,840 to below 900 per quarter, already stated once at §4. A return figure here would be a
second number derived from the first, kept in step with it by hand, and disagreeing with it within
two revisions.

### 12 · Traceability ★

**Stakeholder requirement → business objective.** Every requirement earns its place by serving one.

| Stakeholder req | Serves objective |
|---|---|
| BR-1 | BO-1, BO-2 |
| BR-2 | BO-2, BO-5 |
| BR-3 | BO-3 |
| BR-4 | BO-1 |
| — | **BO-4 — no stakeholder requirement.** The objective is real and unquantified; nobody has yet stated what they need in order to meet it |

**Business objective → ORD tolerance.** Every objective either produces operational demand or is
recorded as producing none.

| Objective | Via | Quantified as (ORD tolerance) |
|---|---|---|
| BO-1, BO-2 | BR-1 | ORD-03 **[KPP]** — rebate applied within two billing cycles |
| BO-1 | BR-1 | ORD-04 **[KPP]** — determination survives a 24-hour source interruption |
| BO-2 | BR-1 | ORD-15 — a missed appointment is determinable without re-keying |
| BO-2 | BR-2 | ORD-13 — rebate position established through an existing channel |
| BO-3 | BR-3 | ORD-10 — rebate parameters changed without a release |
| BO-5 | BR-2 | ORD-12 — rebate position reportable within one business day |
| BO-1 | BR-4 | **No tolerance yet.** Complaint-path exception handling not yet quantified |
| BO-4 | — | **No tolerance yet.** Blocked on the `[TBD]` at §11 |

**BO-4's blank appears in both tables, and that is the point.** Tracing only downward would show an
objective with no tolerance. Tracing only upward would show an objective nobody has stated a need
against. Both are true, and each is a different conversation with a different person. The full chain
onward to the SOAP and the acceptance criteria is on the [traceability matrix](#traceability).

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
| BH-2 | **Met** | No objective or stakeholder requirement names a system, workflow or figure. This BRD's §9 states four outcomes, and the four statements that would have breached the altitude are in its routing register instead |
| BH-3 | **Met, with one declared gap** | §10 — consumer contract cl. 14.3 / 14.5 / 14.6, field services agreement §9 and the billing-cycle boundary, each with its operational weight stated, and three categories recorded as *none found*. The privacy constraint is `[TBD]` with Legal Counsel and 2026-08-29; it propagates as an unquantified confidentiality tolerance in the ORD. DEP-001 and DEP-002 carry statuses, and DEP-001's exposure is `R-115` in the RAID log rather than a risk table here |
| BH-4 | **Met, with one declared gap** | §11 — three consequences, two sourced to the contract and INC-5012. The third is BO-4's, `[TBD]` with Regulatory Affairs and 2026-08-15; it is the same gap as BH-1's, propagating from the objective to its cost case |
| BH-5 | **Met** | §5, nine rows with interest and role. Approval is not among them, by design — it is §6's |
| BH-6 | **Met** | §6, three rows against the three business units §8 puts in scope, each naming its GM and each Confirmed. The row count agrees with §8's scope and Appendix A's process owners |
| BH-7 | **Met** | §8, with the out-list explicit, Phase 1 named as this document's scope, and Phase 2 carrying its own Doc ID rather than a deferred section here |
| BH-8 | **Unowned gap** | Appendix A is complete **except the customer notification service, which has no owning team.** There is nobody to carry it, so it is neither met nor owned — the case the third outcome exists for |
| BH-9 | **Met** | §12, both directions. Upward: BR-1 – BR-4 each against the objective they serve, with BO-4's row explicitly blank rather than omitted. Downward: six objectives against ORD tolerances, with two explicit blanks — BO-4's, and BR-4's unquantified complaint-path demand. Tracing one direction would have found one of them |
| BH-10 | **Met** | §9, BR-1 – BR-4 at stakeholder altitude, each naming a stakeholder present at §5 and none naming a workflow, system or figure. The routing register carries four statements declined, one written back as ORD-04 and three awaiting a register — recorded, which is what this item asks, rather than resolved, which it does not |

> **Outcome: Accepted with an unowned gap.** The bar is met — BH-1 and BH-4 carry one declared gap
> between them, owned by Regulatory Affairs and dated, and BH-3 carries a second, owned by Legal
> Counsel and dated. BH-8 is the unowned one: it is carried
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
