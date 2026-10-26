# write-brd — standard extract

> **Generated file. Never hand-edit.** Produced by `tools/build-review-criteria.py`
> from the requirements-documents pack, which is the single source of truth for
> everything below. Editing this file puts it out of step with the pack; regenerate
> instead.

**Pack version:** v1.18 · **Pack commit:** `abeeb26a9ad4`
**Generated:** 2026-10-26 · **Content hash:** `a4a683006b31bc80`

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

**Version:** 1.18 · **Last updated:** 2026-10-26 · **Status:** Approved at v1.13; the v1.17 and v1.18 additions are draft for review
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
from — see Entry criteria (ORD Intake and Maturity Standard) and the E1–E9 list.

## The standard

The BRD has no single ISO. The authoritative anchor is the IIBA's **BABOK v3** (Business Analysis
Body of Knowledge). It defines a **requirements taxonomy** — Business, Stakeholder, Solution,
Transition — that determines which document owns which requirement. The BRD owns the **Business**
requirements and frames the **Stakeholder** ones. **Solution** requirements are handed down: the
operational half to the ORD, as quantified business tolerance.

**The functional half has no document in this chain.** The taxonomy names it, the
PRD standard defines its shape, and it is not adopted here — so functional detail is
inferred during Epic decomposition rather than elicited. That absence is not a gap in the BRD's
responsibilities, but it does change what happens to a business rule the BRD correctly declines to
carry: see what leaves the chain (traceability matrix).

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
| **Solution — Functional** | What the solution must *do* (behaviour, capabilities) | **No document in this chain.** Inferred at Epic decomposition. Defined shape: PRD standard, unadopted |
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
| App. A | **Process and system scope** | The L1–L3 process areas and the systems in scope, each with a named owner and whether its impact is confirmed by that owner or assumed. Seeds the ORD's impact register |
| App. B | **References** | Every source the BRD cites, in the reference-list form `standards/tables.md` § *Reference list* defines. `None cited` where there is none |

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
**Doc ID:** BRD-YYYY-NNN · **Version:** N.N · **Status:** Draft / In review / Conditionally endorsed / Approved · **Priority:** P1–P4
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

**A BRD can be endorsed before it is resourced, and then its conditions are part of it.** *Conditionally
endorsed* means the sponsor has endorsed the document subject to stated conditions — most often that
people are found to do the work. §1 lists each condition, with its kind, because the two kinds go to
different places in the review:

| Condition | Kind | Owner | Due |
|---|---|---|---|
| [the condition, as endorsed] | Content / Resourcing | [named role] | [date] |

- **Content** — scope to settle, a rule to agree, funding tied to a decision. A content condition is
  an unresolved business decision, and the review treats it as one under § *Business definition
  readiness*.
- **Resourcing** — people to be allocated or nominated. A resourcing condition sets the resourcing
  status at § *The readiness projection*, and it never makes a rule contested: nobody being allocated
  is not a dispute about the rules.
- **A condition with no owner or no date is an absence**, under the same rule as any other `[TBD]`.

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
| **Decision sought.** | The decision this document wants, and over what scope | §8, and the phase |

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
| **Decision sought** | The document has not established what decision it wants. It is a briefing paper, not a BRD |
| **Cost of not acting** | BH-4 is absent, and the gate will find the document not yet ready. §2 found it first |
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
| "Attendance is not recorded distinguishably in the workforce management platform, so the rebate job cannot determine eligibility." | "Customers owed a contractual credit receive it only if they complain. The enterprise pays the customers who ask, and carries an unmeasured liability to those who do not." |
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

| Stakeholder | Interest | Role | Engagement |
|---|---|---|---|
| [named role, or group where the group is the stakeholder] | [what they stand to gain or lose] | Sponsor / Consulted / Affected / Authors [downstream document] | Engaged / Not yet engaged / Unavailable until [date] / No SME nominated |

**§6 — the approving GM register.** One row per business unit in scope, and the count of rows is
checkable against §8's scope and Appendix A's owners.

| Business unit in scope | Approving GM | Approves | Status | Design support |
|---|---|---|---|---|
| [unit, matching a §8 scope area] | [named GM] | The ORD's operational tolerance for this unit | Confirmed, or `[TBD]` carrying the owner who will confirm it and a date | [named role who answers this unit's business questions while the SOAP is drafted], or `[TBD]` with an owner and a date |

- **The BRD's sponsor is not automatically an approving GM, and often is not one.** The sponsor funds
  the change; the approving GM commits the unit that carries the operational consequence. Where the
  consequence lands across three units, three GMs approve and the sponsor approves none of it.
- **A business unit in §8's in-scope list with no row here is the finding**, not an omission to tidy
  up. It is the case BH-6 exists to surface.
- **Never infer an approver from an org chart.** An unconfirmed GM is `[TBD]` with the owner who will
  confirm it and a date, exactly as an unquantified objective is.
- **`Design support` names who answers the unit's business questions after the ORD is handed off.**
  Architecture drafts the SOAP against the ORD, and it will ask what a rule means, what an exception
  is for, or which of two readings the business intends. A unit fully engaged for the ORD can be
  absent at design time, and nothing upstream shows it until the questions go unanswered. The
  commitment is the GM's to make, because it is their unit's time. Its absence does not change the
  BRD gate; it is carried forward to the ORD's handoff gate as OH-16, and into the path to readiness.

**`Engagement` records whether the stakeholder has actually been spoken to.** A BRD can be written
from a brief before anyone in §5 has been engaged, and a register that lists a stakeholder reads the
same whether they were consulted or merely named. *Not yet engaged* is a valid entry; a blank is not.
A stakeholder who is engaged but has limited availability before the fixed date says so, with the
date, because it is a lead-time input at ORD Intake and Maturity Standard §4.7.4. Where a group is affected and is not
consulted directly, say that in this column rather than leaving it empty.

**`No SME nominated` is the case where a department is affected and nobody has been named for it.**
It is not *Not yet engaged*, which implies someone to engage, and not *Unavailable until*, which needs
a date. It is treated by the `[TBD]` rule like any other missing name: a row reading *No SME
nominated* with the role who will nominate and a date is a **declared gap** at BH-5, and one with
nobody to nominate is an **unowned gap**. Either way the department is counted toward size, because
the demand it holds is real whether or not anyone is yet named to state it.

**Stakeholders are elicited, not recalled — ask against each department.** The register is built by
asking whether the change reaches each department below, and recording the answer, including *none
found*. It is the same discipline as the constraint categories at § *Constraints, assumptions and
dependencies*, for the same reason: a department asked and answered *none found* is a record, and a
department never asked is a hole. The count the answers produce sets the ORD's size at
ORD Intake and Maturity Standard §4.1, so a register that undercounts is an undersized change — and a lead time quoted short
from the first day.

| Group | Department | Likely affected when the change… |
|---|---|---|
| Customer-facing | Sales and account management | changes what is sold, how it is ordered, or what a customer is promised |
| | Marketing, brand and customer communications | changes a customer-facing message, notice or channel |
| | Customer service and contact centre | changes why customers call, or what an agent can see or do |
| | Complaints, disputes and customer advocacy | changes eligibility, credits, outcomes a customer can challenge, or the complaint path |
| | Digital channels — web, app and self-service | lets customers see or do something new themselves |
| | Partner, channel and wholesale management | reaches resellers, wholesale customers or third parties who sell for the enterprise |
| Operations | Service delivery, fulfilment and provisioning | changes how an order becomes a working service |
| | Field operations and workforce management | changes scheduling, dispatch, attendance or on-site work |
| | Service assurance and fault management | changes how a problem is detected, reported or restored |
| | Supply chain, procurement and logistics | changes what is bought, stocked or delivered |
| | Facilities and property | changes a physical site — usually outside an ORD's logical scope, and still a stakeholder |
| Product and change | Product and pricing | changes a product's features, rules or roadmap, or a price, discount, rebate or credit |
| | Business transformation and change management | changes how people work, or needs adoption support |
| Finance | Billing and revenue assurance | changes a charge, a credit, a billing cycle or revenue leakage |
| | Finance operations — receivable and payable | changes payments, refunds or reconciliation |
| Legal, regulatory and security | Legal | interprets or changes a contract clause, or creates a liability |
| | Regulatory affairs | touches a licence condition, regulator reporting or an industry code |
| | Privacy | collects, uses, shares or keeps personal information differently |
| | Information and cyber security | changes access, data flows or exposure |
| Technology and data | Application owners | touches a system they own — Appendix A's `Owner` column |
| | Data, analytics and reporting | creates or changes a measure, a report or a data feed. **Always ask where an objective is a new measure** |

- **A department is a prompt, not a stakeholder.** An affected department becomes a §5 row naming the
  role who holds its interest. Never add a row because the list names a department, and never infer
  the person from an org chart.
- **A department affected and not yet engaged is still counted**, as *Not yet engaged* — or as *No
  SME nominated* where nobody has been named for it. Leaving it out
  until someone has spoken to it undersizes the change by exactly the stakeholders most likely to be
  late.
- **Departments not asked are reported** at the gate review, and they widen the lead-time projection
  to a range — see § *The readiness projection*.
- **Tailor the list to the enterprise, once, and keep the asking.** The departments are generic. The
  rule that each is asked and answered is not.

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
See Roles at the boundary (ORD Intake and Maturity Standard).

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
| "Authorisation delay beyond 3 seconds causes measurable cart abandonment, at $X per point" | Business tolerance, performance efficiency | **ORD** §7.1.1 |
| "Payment authorisation P99 ≤ 800 ms" | Technical target | **SOAP** — architecture's answer to the tolerance above |
| "Checkout unavailability in peak trading costs $X per hour and breaches merchant obligation Y" | Business tolerance, reliability | **ORD** §7.2.1 |
| "99.99% monthly availability" | Technical target | **SOAP** |
| "PCI-DSS applies; a breach carries penalty X and loss of acquiring" | Compliance obligation | **ORD** §7.3.6 |
| "Card data tokenised, no PAN at rest" | Technical control | **SOAP** |
| "A customer acting on a generated summary that misstates their entitlement breaches obligation Y, at $X per occurrence" | Business tolerance, accuracy of generated output | **ORD** §7.8 |
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
taste, and it is the same rule ORD Intake and Maturity Standard §7.1 applies one hop downstream.

### How a `[TBD]` is treated — read this before the bar

The pack's rule against inventing a threshold means a BRD arrives with declared gaps, and a gate
that treats every gap as an absence finds every real document not ready. A gate that treats every gap
as satisfied finds none. Neither is useful, so the treatment is stated rather than left to judgement:

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
> worse than a not-ready outcome, because it looks like a pass. Every gap admitted here **must** reappear as
> an empty traceability row and an unanswered objective downstream — see BO-4, which does exactly
> that at §12 of the worked example and again on the traceability matrix.

### The bar — four items, and without them the BRD is not yet ready

These four are what an ORD cannot be written without. Each maps to a load-bearing element the ORD
consumes immediately.

| # | Required | Consumed by | Absent means |
|---|---|---|---|
| **BH-1** | A named business objective carrying a **baseline, a target and a date**. Assessed per objective; the two limits above govern how many may be declared gaps | Every tolerance traces here. It is what establishes *why* two billing cycles rather than three | Every ORD requirement is orphan scope, and no tolerance is auditable |
| **BH-2** | Each objective stated as an **outcome, not a solution** — no feature, system, vendor or asserted figure | Leaves the ORD something to add | The BRD has pre-empted the ORD. The figure is asserted rather than derived, and the architecture review becomes ratification |
| **BH-3** | **Constraints and dependencies carrying operational weight** — regulatory obligations, contractual commitments, platform dependencies, named specifically, each elicited against the categories at § *Constraints, assumptions and dependencies* rather than recalled | Seeds Security, Compatibility and Reliability | The ORD author invents them or misses them |
| **BH-4** | A **cost-of-failure case** for each objective carrying operational exposure | The input every tolerance is derived from | A tolerance traced to no consequence is an invented figure, however well it is written. The single most common upstream cause of a low-maturity ORD |

> **BH-1 to BH-3 are the three load-bearing elements at ORD Intake and Maturity Standard §3.4; BH-4 is the fourth, and it
> is the one most often assumed to be optional.** A complete BRD is not the bar — these four are.
> A BRD carrying only these and nothing else is enough to start on.

### Supporting items — absent, these are recorded and drive the tier

Their absence does not stop ORD development. It determines the maturity tier committable on the
fixed date, and each is recorded under ORD Intake and Maturity Standard §3.3 at assignment.

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
| **Accepted with recorded gaps** | BH-1 – BH-4 met; one or more items outstanding, **each with a named owner and a date** — a declared gap on a bar item, a supporting item outstanding, or both | ORD development starts. The gaps are recorded at ORD Intake and Maturity Standard §3.3 and determine the committed maturity tier where they reach a KPP-bearing requirement |
| **Accepted with an unowned gap** | BH-1 – BH-4 met; an outstanding item has **no owner to carry it** | ORD development starts. The item is recorded at ORD Intake and Maturity Standard §3.3 and **raised with the approving GMs at sign-off rather than referred, because a referral needs a recipient.** It stays open until someone accepts it — and that it stayed open is the finding |
| **Not yet ready for ORD development** | Any of BH-1 – BH-4 absent, per the `[TBD]` rule above | *Recommended:* complete the absent items before ORD development is assigned. The review names each one and what it would unblock. **Without them, the ORD task is a BRD task in disguise** — see the antipatterns at ORD Intake and Maturity Standard §3.4 |

**Where more than one row applies, the outcome is the most serious of them** — not yet ready first,
then the unowned gap, then recorded gaps. The worked assessment below carries declared gaps at BH-1,
BH-3 and BH-4 *and* an unowned one at BH-8, and lands on the third outcome rather than the second.

**The second row covers a declared gap wherever it sits, including on the bar.** A bar item carrying
`[TBD]` with an owner and a date is met *for the bar* under the rule above, but the document is not
gap-free — so it is neither the first outcome nor the last. Reading the row as supporting-items-only
left that document matching no outcome at all.

**The third outcome is the one most documents land on, and it exists because the second could not
hold it.** An item outstanding *with* an owner is a scheduling problem. An item outstanding with
**nobody to own it** is a finding about the organisation rather than about the document, and
collapsing the two loses the more serious of them.

**Requesting the detail before ORD development proceeds is the correct response, not an
escalation.** An ORD written from a BRD missing its bar produces figures nobody can defend, and
the cost of that lands after architecture has designed against them.

> **This outcome depends on a right the standard says is currently absent, and that is worth
> stating plainly rather than glossing.** The ORD Intake and Maturity Standard is a
> **declaring** standard, not a blocking one — every other mechanism in it produces a record rather
> than exercising a veto, precisely because a record is available to someone holding no authority.
> *Not yet ready for ORD development* is the one outcome in this pack that requires authority: the
> Tier 1 control **"right to declare an ORD not-ready and refuse handoff"** at
> ORD Intake and Maturity Standard §8, listed there as a control **to be established**.
>
> **Where that right is not yet held**, the outcome is *recorded* rather than exercised: the ORD
> proceeds, the absent bar items are recorded at ORD Intake and Maturity Standard §3.3, and the committed tier reflects
> them. That record is the evidence for establishing the control — a not-ready finding that was
> warranted, declared, and overridden is a stronger argument than the same right requested on day one.

---

## Business definition readiness — the question the gate does not ask ★

The handoff gate answers one question: **can ORD development begin?** It does not establish that the
business decisions the downstream documents depend on have been made. A BRD can clear the bar while a
rule it relies on is still undecided, and when it does, someone downstream makes the decision
instead — without the authority to make it, and usually without knowing they made it.

A BRD review therefore asks three questions and reports each one separately:

| # | Question | Answered by | Reported as |
|---|---|---|---|
| 1 | **Structural readiness.** Can ORD development begin? | The handoff gate, BH-1 – BH-10 | One of the gate's four outcomes |
| 2 | **Business definition readiness.** Can requirements be derived without a downstream team inventing business policy? | BD-1 – BD-10, below | One of the four business definition outcomes |
| 3 | **Acceptance derivability.** Which acceptance criteria cannot yet be derived without an unsupported business decision? | § *Acceptance derivability, before the ORD exists* | A list of the blocked criteria, not an outcome |

**The three are independent, and the second and third never change the first.** A BRD accepted for
ORD development can still carry decisions that keep particular requirements from being baselined.
The review states that combination rather than averaging it into one verdict, and the gate outcome
is derived exactly as before.

> **The principle.** A BRD is mature when downstream teams can translate business intent without
> becoming the business decision-maker.

### Six kinds of gap, and where each goes

A review that calls everything a gap loses the distinction that matters. Each kind has a different
owner and a different destination.

| Kind | Looks like | Where it goes |
|---|---|---|
| **Missing information** | A fact that exists and has not been supplied — a baseline, a volume, an owner | `[TBD]` with a named owner and a date, per § *How a `[TBD]` is treated* |
| **Unresolved business decision** | A choice nobody has made — what counts as eligible, which rule wins, where a window starts | Declared with an owner and a date, and drafted as a Decision for the RAID log |
| **Implementation constraint** | A given the change cannot move — a platform boundary, a data feed's timing | §10's constraint table |
| **Implementation proxy** | What current capability can measure, standing in for what the business means | Recorded under BD-9, never rewritten as the intent |
| **Assumption** | Something believed true, pending confirmation | §10's assumption table, with `If false` |
| **Solution detail** | A design answer the BRD has no business holding | §9's routing table |

**The most common misfiling is an unresolved decision recorded as an assumption.** "The window runs
from the appointment" is not a belief awaiting evidence. It is a choice that someone with authority
has to make, and filing it as an assumption implies that waiting will resolve it.

**A review never resolves a business question.** It names the decision, who should make it and what
it blocks. It does not pick the answer that makes the requirement cleanest.

### The kind of change shapes what can be defined

| Kind of change | What usually exists | What usually does not |
|---|---|---|
| **Enhancement** of an existing process or measure | A baseline, a current rule set, a source of truth | A record of which current rules are intended and which are accidents of the current system — BD-9 |
| **New capability** | The intent | Rules, boundaries and an authoritative source. Every BD item is in play |
| **New measure** — an objective whose metric does not yet exist | The target, sometimes | The metric's definition, its measurement rule and its baseline |

**Can ORD development proceed while a new measure is undefined?** At the gate, yes, within both
limits: the undefined measure is a declared gap with an owner and a date, it is not on the objective
the change is funded against, and another objective is fully quantified. **Where the new measure is
the funded objective, the second limit applies and the gate outcome is *Not yet ready for ORD
development*.** In both cases the review records an unresolved business decision under BD-1 — how
the measure is defined and calculated — and lists any acceptance criterion resting on it as blocked.
ORD development proceeds, and a tolerance traced to the undefined measure carries no status above
Assumed until the measure is defined.

### The business definition checks

Apply these where an outcome depends on material business logic. Where a BRD carries none — every
objective measured on an existing, defined metric, with no eligibility, calculation or
classification at stake — say so once rather than applying them item by item.

| # | Check | A finding looks like |
|---|---|---|
| **BD-1** | **Decision completeness.** Every material business decision needed to determine an outcome is defined, referenced to an authoritative source, or declared unresolved with an owner and a date | A requirement that can only be met once somebody decides something the BRD does not mention |
| **BD-2** | **Business rule sufficiency.** Where an outcome depends on eligibility, qualification, classification, inclusion, exclusion, calculation, attribution, a threshold, sequencing or timing, the rule is defined, referenced or explicitly outstanding. It need not be written in the BRD | "Eligible customers receive…" with eligibility defined nowhere |
| **BD-3** | **Boundary conditions.** Commencement, cessation, effective dates, time windows, and population, threshold and lifecycle boundaries are stated wherever they change an outcome | A window with no stated start. A rule change with no stated effective date for cases already in flight |
| **BD-4** | **Source of truth.** Each material term, value, rule and decision input has an identifiable authoritative source. Being traceable to a source does not make the source authoritative | A threshold traced to a meeting note. Two systems that each hold the customer's status |
| **BD-5** | **Precedence and overrides.** Where several rules can apply to one outcome — eligibility, exclusion, exception, override, attribution — the order between them is defined | Two valid readings of the rules produce different outcomes for the same case |
| **BD-6** | **Scenario completeness.** A complex rule set has representative scenarios showing the intended behaviour: positive, negative, exclusion, boundary, lifecycle or sequence, and overlapping conditions. Scenarios validate rules and never substitute for a missing one | A rule set illustrated by its happy path alone |
| **BD-7** | **Outcome determinism — the two-reader test.** Could two competent readers apply the documented definition to the same case and reasonably reach different outcomes? | They could. Record the underlying decision gap, and never choose an interpretation |
| **BD-8** | **Decision evidence.** Where an outcome has material customer, financial, contractual, regulatory or operational consequence, enough can be known afterwards to explain which rule applied, which version of it, what inputs it used and why the outcome followed. Never invent a logging requirement the sources do not support | A retained determination with no record of which version of a twice-amended clause it applied |
| **BD-9** | **Intent and implementation proxy.** Where current capability approximates the business intent rather than expressing it, both are recorded: the intent, the proxy, why the proxy is used, its known limitation, its owner, and what would trigger a review of it | "Missed" defined as "no attendance record", when the intent is "the customer was not attended" |
| **BD-10** | **Change survivability.** Each material rule, threshold and classification is stated once and identifiable, so that changing it makes every affected downstream requirement discoverable | One threshold stated in three sections, each free to drift — § *State it once*, applied to rules |

**BD-7 is the check most findings come from, and it is also how ambiguity is told apart from solution
freedom.** Ask of each material stakeholder requirement: *could a downstream team implement this two
different ways and both claim conformance?* Where the two ways produce different business outcomes,
a decision is hidden in the requirement. Name it, check whether an authoritative rule already
resolves it, and where none does, declare it unresolved with the requirements it reaches. Where only the
means differ and the outcome is the same, that is solution freedom, and the BRD is right to leave it
open.

### Source authority

Where provenance can be established, the review records which kind of source a rule or value rests
on, because they do not carry equal weight:

1. An external obligation or binding source — legislation, regulation, an executed contract
2. An approved business policy or rule
3. A baselined requirement
4. An approved decision, with its decision-maker named
5. An SME clarification
6. An assumption
7. A working interpretation

**Where two authoritative sources conflict, the review surfaces the conflict.** It never selects the
reading that produces the cleanest requirement. A rule resting only on the sixth or seventh kind has
not been decided, however it is worded.

### What a gap reaches

Recording that a gap exists is half a finding. For each material gap or unresolved decision, the
review states what it reaches downstream — **only as far as the traceability shows**, never by
inferring dependencies the documents do not show.

```
Gap:                        [the decision or missing information]
Kind:                       [from § Six kinds of gap]
Owner · Target date:        [named role] · [date], or Unowned
Objectives affected:        [BO-n]
Rules affected:             [the rule, or its REF-n where one exists]
Downstream requirements:    [BR-n, and ORD-n where the ORD exists]
Acceptance criteria:        [blocked, or none known]
Testing:                    [the proving scenario that cannot yet be written]
Other known impact:         [only where a source records it]
```

This is the propagation rule at § *How a `[TBD]` is treated*, applied to decisions as well as to
quantities. A declared decision that does not reappear downstream is as invisible as a declared gap
that does not.

### Acceptance derivability, before the ORD exists

Before the ORD exists, no acceptance criterion does either: Capability ACs derive from the SOAP, and the ORD
proposes criteria rather than writing them (ORD Intake and Maturity Standard §7.4). So the review does not grade acceptance
readiness here. It lists each criterion that **cannot be derived** without an unresolved decision:

```
AC status:            Not safely derivable
Requirement:          [BR-n, or the objective]
Reason:               [the unresolved decision]
Decision required:    [stated as a question, never as an answer]
Owner:                [named role, or Unowned]
Proving scenario:     [the case that will show the decision was implemented]
```

**An explicit inability to derive a criterion is a valid finding, and a valuable one.** The failure
it prevents is a criterion made more specific than its sources allow — a plausible rule written in to
make the criterion testable, which then reads as though the business decided it. The full acceptance
judgement belongs to the ORD review, where proposed criteria exist to be assessed.

### The four business definition outcomes

| Outcome | Condition |
|---|---|
| **Ready** | Every material business decision is defined or referenced to an authoritative source, and no BD item carries a finding |
| **Ready with declared gaps** | What is outstanding is missing information, each item with an owner and a date. No business decision is unresolved |
| **Conditionally ready — unresolved business decisions** | One or more material business decisions are unresolved, **each with an owner and a date** |
| **Not ready** | A material business decision, or missing information a business rule depends on, has **no owner** — including a hidden decision the review surfaced and nobody has yet accepted |

**Where more than one row applies, the outcome is the most serious of them**, by the gate's
precedence and for the gate's reason: a decision with an owner is a scheduling problem, and a
decision nobody owns is a finding about the organisation.

**Most real BRDs land on the third outcome, and that is not a criticism of them.** The BRD correctly
declines to carry business rules (§ *Where the BRD sits in the chain*), and no document in this chain
receives them, so a rule that has been identified has usually not been decided anywhere. The outcome
records that structural fact against the requirements it affects, and its accumulation across BRDs is
the argument for the functional requirements document the chain lacks.

### The readiness projection — from the BRD's condition to a lead time

The review also states what the BRD's condition means for the ORD that follows it: how long it will
take, and how sure that figure is. It reads the ORD Intake and Maturity Standard to do
so and estimates nothing separately. **Every figure comes from the §4.1 tables and the §4.7 method;
this section says only which row, which table and which column the BRD selects, and what moves the
result afterwards.**

**Step 1 — the BRD readiness rating selects the table.** It follows mechanically from the gate
outcome and the business definition outcome:

| BRD readiness | Condition | Lead-time table |
|---|---|---|
| **Ready** | Gate accepted, in any of its three accepted outcomes; business definition *Ready* or *Ready with declared gaps* | Baseline |
| **Decisions open** | Gate accepted; business definition *Conditionally ready*, with every decision owned and none needing an obligation interpreted or agreement across business units | Baseline — routine refinement resolves inside the window (ORD Intake and Maturity Standard §4.5) |
| **Contested** | Gate accepted; business definition *Conditionally ready*, with at least one decision that interprets an obligation or needs agreement across business units | Contested (ORD Intake and Maturity Standard §4.2) |
| **Not ready** | Gate *Not yet ready for ORD development*, or business definition *Not ready* | **None.** The committed position is Tier D until the BRD is reconstructed or the decision owned (ORD Intake and Maturity Standard §4.7.1) |

The rating is not the confidence. It is an input to the projection, and confidence is its output.

**Step 2 — the stakeholder count and the other indicators select the row.** Count the §5 rows whose
stakeholders are consulted — every row except a group affected and not consulted directly — after
asking against the departments at § *The stakeholder register, and the approving GM register*. The
size is **the highest band any §4.1 indicator reaches**: business units, objectives, stakeholders,
and impacted workflows and systems from Appendix A. A change with few stakeholders and many systems
is not small.

**Step 3 — the resourcing status and the allocation select the column.** The allocation is E6, and
the review asks for it rather than assuming full time. The person's leave in the window comes off
capacity first (ORD Intake and Maturity Standard §4.3). What can be read depends on whether anyone is allocated at all:

| Resourcing status | Condition | What the projection reads |
|---|---|---|
| **Allocated** | A named convenor at a confirmed allocation | The cell from the §4.1 table selected at step 1 |
| **Contended** | A named convenor at a stated allocation that another program also claims | The cell at the stated allocation, **and** the cell at the next allocation down, with slip S7 counted (ORD Intake and Maturity Standard §4.7.4). The second figure is what the first becomes if the competing claim wins |
| **Unallocated** | Nobody allocated yet — typically a BRD endorsed on a resourcing condition | **No date.** Instead, the lead time **from the day of allocation** at each allocation in the §4.1 row, and the **lowest allocation that meets the fixed date** if allocation happens by a stated day |

**An *Unallocated* BRD still gets an answer.** "The projection cannot be made" is true and useless to
a sponsor deciding what the condition is worth. The answer is the price of meeting it: *"Allocated by
1 December, a Medium contested change needs at least 60% to meet the gate date; at 50% it takes 39
business days and misses it."* Where no allocation in the row meets the date, say that, and say which
of size, date or tier would have to move instead.

**Step 4 — the modifiers move the result:**

| Modifier | Effect | Source |
|---|---|---|
| Any consulted stakeholder not yet engaged (S6) | **+5 business days**, once — one booking cycle covers everyone invited together | §3.2 |
| An SME is unavailable until a date (S5) | The decision workshop is no earlier than that date plus five business days' notice. A shift on the calendar, not added days | §3.2, §4.5 |
| The convenor's leave falls on the workshop or sign-off | The date moves past the leave | §4.3, §4.7.1 |
| A department not asked | The lead time is reported as a range, up to the next size's row | §4.1, re-size trigger |
| An unowned system or process in Appendix A | The impact count is uncertain: the range widens by one size | §4.1 |
| A decision depends on legal or regulatory interpretation | **No upper bound.** "*29 business days; upper bound open*" | §4.2 |
| A department with **No SME nominated** whose demand is on the critical path — it owns a decision, holds KPP-bearing demand, or owns a process in Appendix A | **No upper bound until someone is nominated**; then treat as S6 | §3.2 |
| A department with **No SME nominated** off the critical path | S6 — **+5 business days** once someone is nominated, and the same booking cycle covers it | §3.2 |
| The allocation is **Contended** (S7) | Report the next allocation down beside the stated one | §4.6 |
| The person carries delivered ORDs | The figure is reported as a **ceiling**, because standing load is not yet deducted | §4.3 |

**Step 5 — the date, the tier and the confidence.** Count the available business days from
assignment to the fixed date on the jurisdiction's calendar (ORD Intake and Maturity Standard §4.7.1). Then R, the tier
and its `†` follow from §4.7.2, and confidence — **High, Conditional or Low** — from
ORD Intake and Maturity Standard §4.7.4, with its slips for SME availability (S5), stakeholders not yet engaged (S6) and
contended allocation (S7). Never a percentage.

**Where an input is missing, say so.** Without the fixed date, the review reports the readiness
rating, the size and the lead time, and states that no tier can be read. Without an allocation, the
resourcing status is *Unallocated* and the review gives its answer rather than none.

**The projection is reported in one block:**

```
BRD readiness   [rating] — [the decisions or gate items that set it]
Stakeholders    [n counted, n not yet engaged, n with no SME nominated, n departments not asked] → [size, or range]
Resourcing      [Allocated / Contended / Unallocated] — [E6, or the competing claim, or the condition]
Allocation      [E6], leave [days in window] — or, if Unallocated, [days from allocation at each %; lowest % meeting the date]
Lead time       [cell or range from §4.1], after modifiers · upper bound [stated, or open]
Against date    [n] available business days → R = [n] → Tier [x]
Confidence      [High / Conditional / Low] — [what sets it] → planning tier [x]
```

**Stakeholder engagement may not have happened, and the register says so.** §5's `Engagement` column
records whether each stakeholder has been engaged, has not yet been, or is unavailable until a date.
A requirement whose only source is a stakeholder not yet engaged rests on the author's reading of that
stakeholder, and the review treats it as an assumption.

**Process and system impacts can be assumed too.** Appendix A's `Impact basis` column records whether
each impact has been confirmed by its owner or is assumed, and an assumed impact cites its `ASM-NNN`.

**At Low confidence, the review is not complete until it has drafted the RAID entries:** a Decision for
each unresolved business decision, with its owner and the date it is needed by; a Risk for each slip
present; an Action for each SME not nominated and, where the BRD is *Unallocated*, for the allocation;
and a Risk for each business unit with no design support committed. They are the rows of the path to
readiness, below, that RAID can hold. They are drafted, not raised — the author or convenor raises them. **This is a
completion rule, not a block on progression.** ORD development proceeds at any confidence, and the
entries are what make a Low confidence visible to the people able to change it. At High or
Conditional confidence, drafting them is recommended rather than required.

### The path to readiness

A review that lists findings leaves the reader to work out what to do about them, in what order,
and what each would buy. The path does that, and it is where the review's recommendations live.

| # | Activity | Owner | Needed by | Moves |
|---|---|---|---|---|
| [n] | [an action to **obtain** something] | [named role] | [the date, tied to the step it unblocks] | [the rating, outcome, lead time, slip or tier it changes, and by how much] |

**Ordered by when the activity has to happen:**

1. **Before ORD assignment** — anything that sets the readiness rating, the resourcing status or the
   size: business decisions, a resourcing condition, nominations for departments on the critical path,
   departments not asked.
2. **Inside the ORD window** — anything that only raises confidence or the tier: engaging stakeholders
   not yet engaged, owning an unowned system, confirming an assumed impact.
3. **Before the SOAP is drafted** — each unit's design support.

**Every activity is stated as obtaining something, never as the answer.** *Obtain Regulatory Affairs'
decision on what counts as a missed appointment* — never *Define a missed appointment as…*. A path
that states the answer has made the business decision the review exists not to make.

**Every activity says what it moves, and where two activities move the same thing, both are shown
with their price.** Resolving a contested rule before assignment and raising the allocation can buy
the same lead time; one costs a decision brought forward, the other costs a person's time, and the
reader chooses. **Name what does not help**, where it is the remedy most likely to be reached for —
more allocation buys nothing for a change already at its latency floor.

**Stop at the sufficient tier.** The target is the tier the fixed date's milestone needs
(ORD Intake and Maturity Standard §4.7.5), not Tier A. Where the achievable tier already meets it, the path says so and
lists only what the BRD gate or business definition still requires. A path to a tier nobody needs
discredits the paths that matter.

**The path and the RAID drafts are one list.** Each RAID draft is a row of the path, so the two can
never disagree. At Low confidence the rows the RAID log can hold must be drafted before the review is
complete; at High or Conditional, drafting them is recommended.

### What the reviewer does not do

- Resolve an ambiguity, choose between two readings, or infer an order of precedence
- Supply a threshold, a boundary or a rule the sources do not state
- Turn an assumption into a requirement, or an implementation limitation into the business intent
- Treat a scenario as the rule it illustrates
- Write an acceptance criterion more precise than the requirement it derives from
- Let a well-formed acceptance criterion hide the decision it depends on

**Recommendations are stated as recommendations.** The review recommends, and the BRD's author and
the approving GMs decide. *Recommended:* names the action the findings support; *Consider:* names one
worth weighing. A review that instructs, rejects or returns a document has claimed an authority that
ORD Intake and Maturity Standard §8 says is not held.

---

## Worked example — BRD-2026-041, Missed Appointment Rebate (Acme Communications)

**Doc ID:** BRD-2026-041 · **Version:** 2.0 · **Status:** Approved · **Priority:** P1
**Executive sponsor:** Chief Customer Officer · **Author:** Business Analysis
**Horizon:** FY26 H2 – FY27 Q2 · **Phase:** 1 of 2 (Phase 2 — BRD-2026-058) · **Standard:** BABOK v3

> **One worked example runs the pack's live chain.** This BRD is the upstream document for the
> worked example ORD and for the traceability matrix. Its objectives,
> constraints and scope are the ones that ORD's tolerances trace back to, so the three can be read
> as one chain rather than three unrelated illustrations. Copy the shape, not the figures.
>
> **One page stands outside it, deliberately.** The PRD standard carries a self-contained
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

**Decision sought.** Approval to proceed to ORD development, Phase 1 — residential installation
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
| BO-5 | Answer a regulatory enquiry into any appointment's rebate position within 1 business day | Manual reconstruction, duration not measured | ≤ 1 business day | FY27 Q2 |

**BO-1's target is set against residential volume**, which is Phase 1's scope at §8. A target set
against the population a later phase reaches would be unmeetable on this document's date.

**BO-4 is unquantified and stays in the register.** An objective with a `[TBD]` and an owner is a
tracked gap; the same objective omitted is invisible. It is the objective most likely to change the
business case, which is why it is not deferred out of the document.

### 5 · Stakeholders ★

| Stakeholder | Interest | Role | Engagement |
|---|---|---|---|
| Chief Customer Officer | Complaint volume and customer trust | Executive sponsor; approves spend | Engaged |
| GM Customer Care | Complaint handling, customer channel | Approver — §6 | Engaged |
| GM Field Operations | Attendance capture and contractor data | Approver — §6 | Engaged |
| GM Billing | Rebate application, billing-cycle boundary | Approver — §6 | Engaged |
| Regulatory Affairs | Clause 14.3 interpretation, enquiry response | Consulted; owns BO-4's quantification and OQ-01 | Engaged — limited availability until 2026-08-14, quarterly regulatory reporting |
| Contract Manager, Field Services | Attendance-data timeliness under the field services agreement | Consulted; constrains scope | Engaged |
| Solution Architecture | The design that answers the ORD | Authors the SOAP | Engaged — briefed; authors the SOAP after the ORD |
| Product Manager | What will be accepted | Authors the Capability acceptance criteria | Engaged |
| Affected customers | Receiving the credit they are owed | Affected | Not consulted directly — represented by GM Customer Care |

**All 21 departments were asked.** Ten are affected and eleven answered *none found*:

| Department | Answer |
|---|---|
| Customer service and contact centre · Complaints, disputes and customer advocacy · Digital channels | Affected — GM Customer Care |
| Field operations and workforce management | Affected — GM Field Operations; Contract Manager, Field Services |
| Billing and revenue assurance | Affected — GM Billing |
| Regulatory affairs | Affected — Regulatory Affairs |
| Product and pricing | Affected — the rebate amount is a contract term. Contract Manager, Consumer, through DEP-002 |
| Legal · Privacy | Affected through the privacy constraint — Legal Counsel owns its `[TBD]` at §10 |
| Application owners | Affected — Appendix A, with one system unowned |
| Data, analytics and reporting | Affected — BO-4 is a new measure. Commercial Analytics, through ASM-003 |
| The remaining eleven | None found |

**Three of the roles the answers name have no row above:** Legal Counsel, Contract Manager, Consumer,
and Commercial Analytics. Each appears once elsewhere in this document, as the owner of one item, and
none was added to the register. That is left as found rather than tidied, because it is the case the
department list exists to catch — see the readiness projection at the end of this example.

**§5 records interest and role, and stops there. What each GM approves is §6's** — holding it in
both places is how the two come to disagree.

### 6 · Approving GM register ★

| Business unit in scope | Approving GM | Approves | Status | Design support |
|---|---|---|---|---|
| Field Operations | GM Field Operations | The ORD's operational tolerance for this unit | Confirmed | Process owner, Field Operations |
| Customer Care | GM Customer Care | The ORD's operational tolerance for this unit | Confirmed | `[TBD — GM Customer Care, due 2026-09-30]` |
| Billing | GM Billing | The ORD's operational tolerance for this unit | Confirmed | Process owner, Billing |

**Three GMs approve the ORD, and none of them approves this document.** The obligation is
contractual and the consequence lands across 3 business units, so the operational tolerance is
committed by the units that carry it rather than by the sponsor who funds the change.

**Three rows against three in-scope business units at §8, and three process owners at Appendix A.**
That the three counts agree is the check this register exists to make possible.

**Customer Care's design support is a declared gap.** Its GM approves the unit's tolerance and has
not yet named who will answer architecture's questions about the complaint path while the SOAP is
drafted. It is owned and dated, so it changes nothing at the BRD gate. It reaches the ORD's handoff
gate as OH-16, and the readiness projection's path carries it to the date that matters.

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
| Rebate payable within 2 billing cycles of the missed appointment | Consumer contract cl 14.3 | Sets the tolerance the ORD quantifies |
| No duplicate credit for one appointment | Consumer contract cl 14.5 | Bounds determination |
| Rebate determinations retained for 7 years | Consumer contract cl 14.6 | Bounds auditability |
| Contractor attendance data supplied within 24 hours | Field services agreement cl 9 | Bounds how current any determination can be |
| Billing cycle boundary — monthly, per customer | Billing operating model | Fixed. Not a design choice, and it bounds every tolerance expressed in cycles |
| Privacy: rebate position is customer personal information | *Privacy Act 1988* (Cth), Legal to confirm scope | `[TBD — Legal Counsel, due 2026-08-29]` |

**Elicited and answered *none found*:** financial envelope constraints beyond the approved programme
funding, organisational change-freeze windows, and prior public commitments. Recorded so the
categories read as asked rather than as missed.

**Assumptions.**

| ID | Assumption | Status | If false | Owner | Confirm by |
|---|---|---|---|---|---|
| ASM-001 | Contractors submit attendance through the existing channel without process change | Unvalidated | A commercial variation to the field services agreement lands on the critical path | Contract Manager, Field Services | 2026-09-12 |
| ASM-002 | Clause 14.3's "two billing cycles" runs from the appointment, not from confirmation | Unvalidated | Every tolerance expressed in cycles moves, and BO-2's target with them. Raised as **R-114** | Regulatory Affairs | 2026-08-15 |
| ASM-003 | Residential appointment volume is a stable base for BO-1's target | **Validated** — Commercial Analytics (2026), confirmed 2026-07-30 | — moved to the constraint table as a given | Commercial Analytics | Closed |

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
| BO-5 | BR-2 | ORD-12 — rebate position reportable within 1 business day |
| BO-1 | BR-4 | **No tolerance yet.** Complaint-path exception handling not yet quantified |
| BO-4 | — | **No tolerance yet.** Blocked on the `[TBD]` at §11 |

**BO-4's blank appears in both tables, and that is the point.** Tracing only downward would show an
objective with no tolerance. Tracing only upward would show an objective nobody has stated a need
against. Both are true, and each is a different conversation with a different person. The full chain
onward to the SOAP and the acceptance criteria is on the traceability matrix.

### Appendix A · Process and system scope ★

The L1–L3 process areas and the systems in scope, each with a named owner. **This is what makes the
ORD sizeable at assignment** — the impact counts that set S/M/L are read off it, and it seeds the
ORD's impact register.

| Kind | In scope | Owner | Impact basis |
|---|---|---|---|
| L1–L3 process | Order-to-Activate — appointment booking, field dispatch, attendance capture | Process owner, Field Operations | Confirmed by owner |
| L1–L3 process | Bill-to-Cash — rebate determination and application | Process owner, Billing | Confirmed by owner |
| L1–L3 process | Customer contact and complaint handling | Process owner, Customer Care | Confirmed by owner |
| System | Workforce management platform | Application owner, Field Operations | Confirmed by owner |
| System | Billing engine | Application owner, Billing | Confirmed by owner |
| System | CRM / customer record | Application owner, Customer Care | Confirmed by owner |
| System | Contractor portal | Application owner, Field Operations | **Assumed — ASM-001** |
| System | Customer notification service | **Unowned — open** | **Assumed** — no owner to confirm it |

**`Impact basis` says who has agreed the row is true.** An impact the author inferred and nobody owning
the process or system has confirmed is an assumption, and it is filed as one: the contractor portal
row rests on ASM-001, and if that assumption is false the portal carries a process change the size
of this appendix does not count. The notification service cannot be confirmed by anyone, because
nobody owns it.

**The unowned system is recorded, not resolved.** The notification service appears in the estate
with its owning team vacant. That is a finding about Acme's ownership records rather than about this
change, and it is raised at sign-off — a referral needs a recipient, and there is not one.

**Sizing read from this appendix:** 3 business units, 5 objectives, **8 stakeholders** —
the §5 register's 9 rows less the affected-customer group, which is not consulted directly — and
9 impacted workflows and systems once the ORD's register is populated
(3 L1–L3 process areas resolving to 4 L4 workflows, plus 5 systems) — **Medium**.

### Appendix B · References

Every source this BRD cites, in alphabetical order of the form it is cited as.

| Cited as | Full citation | Type |
|---|---|---|
| Billing operating model | Acme Communications (n.d.) *Billing operating model*, unpublished internal document | Internal record |
| Commercial Analytics (2026) | Acme Communications Commercial Analytics (2026) *Residential appointment volume analysis, 2023–24 to 2024–25*, unpublished internal report | Report |
| Consumer contract | Acme Communications (2025) *Consumer contract: standard terms*, version 7, unpublished | Contract |
| Field services agreement | Acme Communications and its field contractors (2024) *Field services agreement*, unpublished | Contract |
| INC-5012 | Acme Communications (2026) Incident record INC-5012, internal service management system | Internal record |
| Privacy Act | Privacy Act 1988 (Cth) | Legislation |

### The handoff gate, applied to this document

Run against the gate above (BRD standard). This is what a real assessment looks like — not a clean sheet.

| # | Verdict | Evidence |
|---|---|---|
| BH-1 | **Met, with one declared gap** | BO-1, BO-2, BO-3 and BO-5 each carry a baseline, a target and FY27 Q2. **BO-4 carries `[TBD]` with Regulatory Affairs and 2026-08-15** — a declared gap under the rule above: owned, dated, and not the objective the case rests on, with BO-1 fully quantified. It propagates rather than vanishing — §12 leaves its row empty, and so does the traceability matrix |
| BH-2 | **Met** | No objective or stakeholder requirement names a system, workflow or figure. This BRD's §9 states four outcomes, and the four statements that would have breached the altitude are in its routing register instead |
| BH-3 | **Met, with one declared gap** | §10 — consumer contract cl 14.3, 14.5 and 14.6, field services agreement cl 9 and the billing-cycle boundary, each with its operational weight stated, and three categories recorded as *none found*. The privacy constraint is `[TBD]` with Legal Counsel and 2026-08-29; it propagates as an unquantified confidentiality tolerance in the ORD. DEP-001 and DEP-002 carry statuses, and DEP-001's exposure is `R-115` in the RAID log rather than a risk table here |
| BH-4 | **Met, with one declared gap** | §11 — three consequences, two sourced to the contract and INC-5012. The third is BO-4's, `[TBD]` with Regulatory Affairs and 2026-08-15; it is the same gap as BH-1's, propagating from the objective to its cost case |
| BH-5 | **Met** | §5, 9 rows with interest and role. Approval is not among them, by design — it is §6's |
| BH-6 | **Met** | §6, 3 rows against the 3 business units §8 puts in scope, each naming its GM and each Confirmed. The row count agrees with §8's scope and Appendix A's process owners |
| BH-7 | **Met** | §8, with the out-list explicit, Phase 1 named as this document's scope, and Phase 2 carrying its own Doc ID rather than a deferred section here |
| BH-8 | **Unowned gap** | Appendix A is complete **except the customer notification service, which has no owning team.** There is nobody to carry it, so it is neither met nor owned — the case the third outcome exists for |
| BH-9 | **Met** | §12, both directions. Upward: BR-1 – BR-4 each against the objective they serve, with BO-4's row explicitly blank rather than omitted. Downward: 6 objectives against ORD tolerances, with two explicit blanks — BO-4's, and BR-4's unquantified complaint-path demand. Tracing one direction would have found one of them |
| BH-10 | **Met** | §9, BR-1 – BR-4 at stakeholder altitude, each naming a stakeholder present at §5 and none naming a workflow, system or figure. The routing register carries four statements declined, one written back as ORD-04 and three awaiting a register — recorded, which is what this item asks, rather than resolved, which it does not |

> **Outcome: Accepted with an unowned gap.** The bar is met — BH-1 and BH-4 carry one declared gap
> between them, owned by Regulatory Affairs and dated, and BH-3 carries a second, owned by Legal
> Counsel and dated. BH-8 is the unowned one: it is carried
> forward into the ORD as entry criterion **E9 — Partial** and as **IMP-07**, raised with the
> approving GMs at sign-off rather than referred, and it stays open until someone accepts it.
> **That it stayed open is the finding** — about Acme's ownership records, not about this change.
>
> **Note what neither gap did.** Neither moved the maturity tier. The
> worked example ORD commits **Tier B** because both KPPs are Provisional — the tier is
> the weakest status carried by any KPP-bearing requirement, and an unowned system in the estate is
> not one. A recorded gap drives the tier only where it reaches a KPP. Recording it and tier-driving
> it are two different things, and conflating them is how a gate becomes theatre.

### Business definition readiness, applied to this document

Assessed at the same point as the gate, before ORD development was assigned. Nothing here changes the
gate outcome above.

**The kind of change.** BO-1, BO-2, BO-3 and BO-5 are an enhancement, each measured on a metric that
already exists. **BO-4 is a new measure**: the unclaimed exposure has no definition, no measurement rule
and no baseline. It is not the objective the case is funded against, and BO-1 is fully quantified, so
the gate admits it as a declared gap. How the measure is defined is also an unresolved decision under
BD-1, owned with the gap by Regulatory Affairs.

| # | Finding | Evidence |
|---|---|---|
| BD-1, BD-2, BD-7 | **Unresolved decision — what counts as a missed appointment.** BR-1 and BO-2 both turn on it, and neither this BRD nor the contract defines it. A technician arriving outside the window, a technician who arrives and cannot complete, and a customer not at home are three cases two readers would classify differently. Raised at review; **Regulatory Affairs accepted it, due 2026-08-28** | §9 BR-1; §4 BO-2; cl. 14.3 says "missed" without defining it |
| BD-3 | **Unresolved decision, filed as an assumption.** Whether the two-billing-cycle window runs from the appointment or from its confirmation is an interpretation of a binding source, not a belief awaiting evidence. ASM-002 is recorded as a decision with the same owner and date, and R-114 stands | §10 ASM-002 — Regulatory Affairs, 2026-08-15 |
| BD-5 | **Unresolved decision — precedence between cl. 14.3 and cl. 14.5.** Where a rebooked appointment is also missed, the customer is owed one credit or two depending on whether a rebooking is a new appointment. Raised at review; **Regulatory Affairs, due 2026-08-28** | §10 constraints, cl. 14.3 and 14.5 |
| BD-3, BD-8 | **Missing information — which version of cl. 14.3 applies to an appointment in flight across an amendment.** Determinations are retained under cl. 14.6, but nothing states which version of the clause each one applied. Contract Manager, Consumer, through DEP-002 | §10 cl. 14.6 and DEP-002; §3, two amendments since 2023 |
| BD-4 | **Source not authoritative.** The supervisor-approval rule for rebates over $500 rests on an elicited statement, the fifth kind of source, and is routed with `[REF-TBD]`. Raised at review; **GM Billing to confirm whether it is approved policy, due 2026-08-28** | §9 routing table |
| BD-9 | **Implementation proxy.** *Intent:* the customer was not attended. *Proxy:* no attendance record from the contractor. *Reason:* attendance is the only source captured today. *Limitation:* data of known imperfect quality. *Owner:* GM Field Operations. *Review trigger:* DEP-001 reaching Met | §8 phasing; §10 DEP-001 and R-115 |
| BD-6 | **Not yet applicable.** There are no scenarios, and the rules they would validate are undecided. *Consider:* requesting them with the decisions above, since scenarios written after the build tend to describe what was built | — |
| BD-10 | **Met.** Each constraint is stated once, in §10, and cited elsewhere by its source | §10; § *State it once* |

**Acceptance derivability.** BR-2, BR-3 and BO-5 are derivable from what this document and its
sources state. Three are not:

| Requirement | Decision required | Owner | Proving scenario |
|---|---|---|---|
| BR-1, BO-2 | Which events constitute a missed appointment, and from which event does the two-cycle window run? | Regulatory Affairs | A technician arrives 40 minutes after the window closes and completes the job |
| BR-1 | Does a missed rebooking attract a second credit? | Regulatory Affairs | An appointment is missed, rebooked, and missed again |
| BR-4 | What makes a rebate position "genuinely disputed" rather than a request for an owed credit? It depends on the first decision | Regulatory Affairs | A customer contacts Acme about a rebate the determination has not yet issued |
| BO-4 | How is unclaimed exposure defined and measured? | Regulatory Affairs | — none can be written until the measure exists |

**What the first decision reaches**, as an example of the form:

```
Gap:                        What counts as a missed appointment
Kind:                       Unresolved business decision
Owner · Target date:        Regulatory Affairs · 2026-08-28
Objectives affected:        BO-1, BO-2
Rules affected:             Rebate eligibility, referred at ORD development as REF-01
Downstream requirements:    BR-1, BR-4; ORD-03 and ORD-15 once written
Acceptance criteria:        Blocked for BR-1 and BR-4
Testing:                    The partial-attendance and late-arrival scenarios
Other known impact:         None recorded
```

> **Outcome: Conditionally ready — unresolved business decisions.** Four decisions — the missed-appointment
> definition, the window's start, the rebooking precedence and BO-4's measure — each with Regulatory
> Affairs and a date, and two items of missing information, each owned. Nothing material is unowned.
>
> **The readiness projection.**
>
> ```
> BRD readiness   Contested — the cl. 14.3 and 14.5 decisions interpret a binding contract
> Stakeholders    8 counted, all engaged, none with no SME nominated · 21 departments asked
>                 3 roles named elsewhere and absent from §5 → M, or L if they are added
> Resourcing      Allocated — the convenor at a confirmed 60%
> Allocation      60%, no convenor leave in the window
> Lead time       29 (M) – 44 (L) business days · upper bound open: regulatory interpretation
> Modifiers       S5 — Regulatory Affairs limited until 2026-08-14 → workshop no earlier than 2026-08-21
>                 Unowned notification service → range widens one size, already M–L
> Against date    24 available business days → R = 0.83 → Tier B† (M) · R = 0.55 → Tier D (L)
> Confidence      Low — B† with S5 → planning tier C
> Sufficient      Tier B — the date serves architecture engagement (§4.7.5) → gap: one tier
> ```
>
> **Read it from the top.** The three clause decisions make the rule set contested, so the contested
> §4.1 table applies, and at 60% a Medium change takes 29 business days. Every indicator in
> Appendix A reads Medium; the three roles missing from §5 would take the stakeholder count to 11,
> which is Large, and so does the unowned system, so the lead time is a range rather than a figure.
> The 24 available days are counted on the jurisdiction's calendar with public holidays excluded.
> Against 29, R sits less than 0.05 above the B floor, and every decision rests on one stakeholder
> whose availability is limited: a `†` with a slip is **Low** confidence, so the planning tier is
> **C** and B is the optimistic case.
>
> At Low confidence the review drafts the RAID entries before it is complete:
>
> | Draft | Type | Entry | Owner | Needed by |
> |---|---|---|---|---|
> | 1 | Decision | What constitutes a missed appointment under cl. 14.3 | Regulatory Affairs | 2026-08-28 |
> | 2 | Decision | Whether the cl. 14.3 window runs from the appointment or its confirmation — ASM-002, with R-114 | Regulatory Affairs | 2026-08-15 |
> | 3 | Decision | Whether a missed rebooking attracts a second credit under cl. 14.3 and 14.5 | Regulatory Affairs | 2026-08-28 |
> | 4 | Decision | How the unclaimed-rebate exposure under BO-4 is defined and measured | Regulatory Affairs | 2026-08-15 |
> | 5 | Risk | All four decisions, and the contested lead time, rest on one stakeholder with limited availability until 2026-08-14 | Chief Customer Officer | At assignment |
> | 6 | Risk | Customer Care has no design support committed: architecture's questions about the complaint path have nobody to answer them | GM Customer Care | 2026-09-30 — before SOAP drafting |
>
> **The path to readiness.** The gap is one tier, and two activities close it on their own:
>
> | # | Activity | Owner | Needed by | Moves |
> |---|---|---|---|---|
> | 1 | Obtain the three clause 14.3 and 14.5 decisions | Regulatory Affairs | Before assignment | Readiness *Contested* → *Decisions open*: the baseline table applies, and a Medium change at 60% takes **25** business days, not 29. R = 0.96, Tier B with no `†`, and the decisions no longer put Regulatory Affairs on the critical path, so S5 falls away. **Confidence High; planning tier B** |
> | 1a | *Or* obtain an allocation of 80% rather than 60% | Assigning manager | At assignment | Medium contested at 80% also takes **25** days, so R = 0.96 and Tier B. S5 remains, so **confidence Conditional; planning tier B**. It costs a person's time instead of an early decision, and the rules reach the ORD still undecided |
> | 2 | Obtain an answer on the three roles missing from §5 — added, or recorded as consulted on one item only | BRD author | Before assignment | With row 3, collapses the size from M–L to one figure |
> | 3 | Obtain an owner for the customer notification service | Approving GMs | Before assignment | Clears the unowned gap at BH-8 and, with row 2, the range |
> | 4 | Obtain the definition of BO-4's measure | Regulatory Affairs | 2026-08-15 | BO-4's criterion becomes derivable, and its tolerance can rise above Assumed. No change to the tier |
> | 5 | Obtain Customer Care's design support commitment | GM Customer Care | 2026-09-30 — before SOAP drafting | Clears OH-16 at the ORD's handoff gate |
>
> **What does not help:** allocation above 80%. A Medium change reads 25 days at both 80% and 100%;
> the latency floor governs, and the extra time buys nothing. **The path stops at Tier B**, because
> that is what architecture engagement needs; nothing here is offered for Tier A.
>
> The decision dates the review found (2026-08-15 and 2026-08-28) fall after assignment, so row 1
> as dated cannot close the gap in time — which is exactly what the path is for showing. Bringing
> the decisions forward, or taking row 1a, are the two ways to Tier B; leaving both is the planning
> tier C the confidence already states.
>
> **What happened next.** The worked example ORD reached Tier B, the optimistic case.
> The three missing roles were each consulted on their one item and the change was run as
> Medium. The decisions did not close by their dates: they became REF-01 on the
> traceability matrix, still open after nine weeks with four of seven rule areas
> agreed. That is the contested rule set this review identified on day one, running past handoff as
> ORD Intake and Maturity Standard §4.8 expects.

---

*Standard of record: BABOK v3. Companion pages: the ORD Intake and Maturity Standard
for operational demand, the worked example ORD for what BRD-2026-041's objectives become
as tolerances, the traceability matrix for the chain end to end, and the
PRD standard for the functional half — defined, and not adopted in this chain.*

---

<!-- from reference/ord-intake-standard.md -->

**Step 1 — size the change from the BRD.**

| Size | Indicators | Effort |
|---|---|---|
| **S — Small** | 1 business unit; 1–3 business objectives; change to an existing service; ≤4 stakeholders; **≤5 impacted workflows and systems combined**; no cross-program dependency; rules already settled | ~4 effort days |
| **M — Medium** | 2–3 business units; 4–6 objectives; ≤8 stakeholders; **6–15 impacted workflows and systems**; one or two cross-program dependencies; some rules to resolve | ~6 effort days |
| **L — Large** | Multiple business units or programs; novel capability; material regulatory or contractual exposure; >8 stakeholders; **more than 15 impacted workflows and systems, or systems owned by different programs**; cross-program conflicts requiring adjudication | ~9 effort days |

**On the impact counts.** They are indicative bands in the same spirit as the stakeholder and objective counts, not measured thresholds. At assignment the count is an estimate read off the BRD's L1–L3 scope; it firms up during document analysis on effort days 2–3, which is the first point at which the register is populated rather than guessed. **A count that lands in a different band than the one assumed is a re-size trigger**, not a variance to absorb: re-read §4.1 and §4.7.3 from the days remaining, and record the change under §3.3. Owner count matters as much as item count — fifteen workflows under two process owners is a smaller elicitation than six under six.

These are **collection effort only** — the §4.5 sequence. Refinement is deducted separately (§4.3) rather than carried inside them, because it behaves differently and is present on some engagements and not others.
