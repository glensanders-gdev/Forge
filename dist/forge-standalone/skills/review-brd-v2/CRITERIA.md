# review-brd — criteria extract

> **Generated file. Never hand-edit.** Produced by `tools/build-review-criteria.py`
> from the requirements-documents pack, which is the single source of truth for
> everything below. Editing this file puts it out of step with the pack; regenerate
> instead.

**Pack version:** v1.19 · **Pack commit:** `070db87c4725`
**Generated:** 2026-10-26 · **Content hash:** `1bc70a068970eb25`

**Quote the version in every review this extract is used for.**
A reader needs to know which revision was applied — a verdict, and a document
authored to a bar, are only meaningful against a named one, and that is the pack's
own thesis applied to itself.

**Where the live pack is present, it wins.** This extract exists so the skill runs
for someone who does not hold the pack. It is a pinned copy, not an authority: where
it and the pack disagree, the pack is right and this file is stale.

---

<!-- from reference/brd-standard.md -->

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

---

<!-- from reference/brd-standard.md -->

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

---

<!-- from reference/brd-standard.md -->

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

---

<!-- from reference/brd-standard.md -->

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

---

<!-- from reference/brd-standard.md -->

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

<!-- from reference/traceability-matrix.md -->

## The five checks a matrix makes visible

The matrix is not documentation for its own sake — it is a **review instrument**. Each failure is a
specific, nameable defect.

| Scan | Question | A failure means… |
|---|---|---|
| **Baseline gap** | Does every tolerance state the position it improves on? | The tolerance cannot be sized or challenged — and is probably invented |
| **Coverage gap** | Does every business objective trace down to at least one tolerance? | A funded objective with no operational demand stated — it will not be bounded |
| **Conformance gap** | Does every ORD tolerance have a SOAP response answering it? | Demand documented and then not answered — the failure the ORD exists to prevent |
| **Translation gap** | Does every Capability AC carry the threshold *and* the objective from the tolerance it derives from? | Threshold/objective collapse — KPP intent lost silently downstream |
| **Verifiability gap** | Does every Epic AC map to a test? | "Done" is opinion — QA and engineering disagree late |

> **The conformance gap is the one this pack is built around.** An empty SOAP cell against a
> populated tolerance is demand stated and answer outstanding, and it is visible here and nowhere
> else. The translation gap is the second-most valuable: Capability ACs derive from the SOAP rather
> than from the ORD, so a criterion can be well-formed, testable, and still have quietly dropped the
> business threshold it exists to protect.

### Three more, where business rules carry the outcome

Where an outcome turns on eligibility, classification, calculation or another rule, the chain has a
link the five checks do not inspect: the rule between the objective and the demand that implements
it.

```
Business objective → business rule → operational requirement → solution response → acceptance criterion → scenario or test
```

**This chain has no document for the second link** (§ *The column that is not there*), so a rule
appears only where it has been routed — the referred requirements register — or as an unresolved
decision recorded by the BRD review (BRD standard). The three scans read what exists, and mark the rest
*not answerable at this hop*:

| Scan | Question | A failure means… |
|---|---|---|
| **Rule coverage gap** | Does every material business rule produce downstream demand? | Business policy exists that may never be implemented |
| **Decision preservation gap** | Does the downstream response and acceptance criterion preserve the business outcome the rule established? | A requirement technically valid that has silently changed the business intent |
| **Scenario coverage gap** | Does material decision logic have proving scenarios for its exclusions, boundaries and overlaps? | The combinations most likely to fail are the ones nobody tests |

> **The decision preservation gap is the translation gap, one level down.** The translation gap
> loses a threshold between tolerance and criterion; this one loses a rule. Both produce a criterion
> that is well-formed, testable and wrong, and neither is visible from the criterion alone.

> **Anti-pattern: duplicating a requirement across columns "to be safe".** A requirement is authored
> in exactly one document; the matrix *links* to it, never restates it. Two copies drift, and which
> one is authoritative can no longer be established.

---

## Keeping it alive

- **IDs are stable and never reused.** A retired requirement's number is retired with it — withdraw
  `ORD-21` and the next requirement is `ORD-22`, never `ORD-21` again. The matrix is only
  trustworthy if an ID always means the same thing.
- **A tolerance changes by version, not in place.** ORD-04 moved from 12 hours to 24 on evidence
  from INC-5012 and became v1.1 — and any Capability AC that had already consumed the original value
  requires review. The matrix is where that consequence is visible.
- **The SOAP column starts empty and stays empty until architecture responds.** An empty cell against
  a populated tolerance is the pack's most useful single indicator.
- **Tests start as `TBD`** and are back-filled when the test plan is written — an empty Test entry
  is a coverage signal, not an error.
- **Appendix A of the ORD carries the BRD-to-tolerance half** and appendix D the conformance half;
  this page is the teaching and whole-chain view. Where the convenor does not hold the pen
  downstream, the right-hand columns are observed rather than authored — and a divergence between
  the Capability AC and the criterion the ORD proposed is exactly what this view makes detectable.
- **Update on every scope change.** A new tolerance with no matrix row is the first sign of demand
  that will not be answered.

---

*Worked example continuous with BRD-2026-041 (BRD standard) and the worked example ORD. The
chain and its artefact owners are from ORD Intake and Maturity Standard §1 Purpose and the chain. Standards: BABOK v3 ·
ISO/IEC 25010:2023 · ISO/IEC/IEEE 29148:2018 (the unadopted functional half).*

---

<!-- from reference/ord-intake-standard.md -->

### 3.2 The scheduling arithmetic

E2 is required **at assignment**, not during the first week. This is arithmetic, not preference:

- The decision workshop (§4.5, effort day 5) requires 4–6 senior stakeholders in one room for two hours.
- Booking that many senior calendars across competing programs realistically needs **five or more working days of notice**.
- Therefore invitations must issue in the **first days of the engagement**, which requires the stakeholder list to exist **at assignment**.

A stakeholder list that arrives late does not delay the workshop by the days it was late — it delays it by those days *plus* the booking notice, and the review window, register close-out and sign-off then compress into whatever remains. **A late stakeholder list does not cost the days it was late. It costs the back half of the document.**

---

<!-- from reference/ord-intake-standard.md -->

### 4.1 Lead time — size and allocation

Two things set the lead time, and both are known at assignment: **how big the change is**, and **how much of a person is assigned to it.**

**Step 1 — size the change from the BRD.**

| Size | Indicators | Effort |
|---|---|---|
| **S — Small** | 1 business unit; 1–3 business objectives; change to an existing service; ≤4 stakeholders; **≤5 impacted workflows and systems combined**; no cross-program dependency; rules already settled | ~4 effort days |
| **M — Medium** | 2–3 business units; 4–6 objectives; ≤8 stakeholders; **6–15 impacted workflows and systems**; one or two cross-program dependencies; some rules to resolve | ~6 effort days |
| **L — Large** | Multiple business units or programs; novel capability; material regulatory or contractual exposure; >8 stakeholders; **more than 15 impacted workflows and systems, or systems owned by different programs**; cross-program conflicts requiring adjudication | ~9 effort days |

**On the impact counts.** They are indicative bands in the same spirit as the stakeholder and objective counts, not measured thresholds. At assignment the count is an estimate read off the BRD's L1–L3 scope; it firms up during document analysis on effort days 2–3, which is the first point at which the register is populated rather than guessed. **A count that lands in a different band than the one assumed is a re-size trigger**, not a variance to absorb: re-read §4.1 and §4.7.3 from the days remaining, and record the change under §3.3. Owner count matters as much as item count — fifteen workflows under two process owners is a smaller elicitation than six under six.

These are **collection effort only** — the §4.5 sequence. Refinement is deducted separately (§4.3) rather than carried inside them, because it behaves differently and is present on some engagements and not others.

**Step 2 — read the lead time.** Elapsed working days, by size and allocation. **Two tables, because a live contested rule set is not a variation on the normal case — it is a different cost structure** (§4.2, §4.3).

**Baseline — no contested rule set in refinement**

| | **100%** | **80%** | **60%** | **50%** | **40%** | **30%** | **20%** | **10%** |
|---|---|---|---|---|---|---|---|---|
| **S** | **20** | **20** | **20** | **20** | **28** | 44 | — | — |
| **M** | **25** | **25** | **25** | 31 | 42 | — | — | — |
| **L** | **30** | **30** | 36 | 46 | — | — | — | — |

**Contested refinement live** — an obligation-dependent or cross-unit rule set under active adjudication

| | **100%** | **80%** | **60%** | **50%** | **40%** | **30%** | **20%** | **10%** |
|---|---|---|---|---|---|---|---|---|
| **S** | **20** | **20** | **20** | **26** | 40 | — | — | — |
| **M** | **25** | **25** | **29** | 39 | 60 | — | — | — |
| **L** | **30** | **30** | 44 | 59 | — | — | — | — |

| Range | Reading |
|---|---|
| **≤30 days** (bold) | Normal. Plan on it |
| **31–60 days** | Extended. Viable, but requires explicit acceptance of the date at assignment |
| **—** | **Not viable at any date** — the computed figure exceeds 60 working days, the ceiling of the Extended band. The fixed overheads consume the allocation. Re-size or re-allocate; a lower maturity tier does not rescue it |

The `—` threshold is **>60 working days**, which is the top of the Extended band rather than an independent judgement: a quarter of elapsed time to produce one document is the point past which the assignment has stopped being an ORD engagement and become a standing obligation. The arithmetic continues below it — a Medium change at 30% computes to roughly 85 days — but the figure is not offered as a date, because quoting it would imply a commitment that the model does not support.

The second table is the one that applies to most complex changes, since obligation-dependent refinement is the dominant driver at the L end (§4.2). **Quoting the baseline figure for a change that carries a contested rule set understates the lead time by 20–40%.**

**How to read this as a manager.** Two inputs are yours to set — **size** and **allocation**. Two outputs follow — **date** and **maturity**. Fix any one and the others move:

- Want a Medium change in 25 days? Allocate 60% or more — and 80% or more if a rule set is in contested refinement.
- Can only allocate 30%? A Medium change is not deliverable at that allocation on any timeline. A Small change takes 44 days.
- Need a Large change in 30 days? That requires 80%+ allocation, and nothing else will do it.

The table is not a set of reasons to say no. It is the three levers, priced.

**Where the date is already fixed, read §4.7 instead.** This table produces a date from size and allocation. Where the date is given — which is the normal case — §4.7 takes it as a third input and produces the committed maturity tier, using this table as its denominator.

**Why the left of the table is flat.** At high allocation the constraint is not the analyst — it is stakeholder scheduling, review windows and adjudication. Adding allocation past that point buys nothing, which is why S at 100% is still 20 days. Below roughly 50–60% the analyst becomes the constraint and the numbers climb steeply (§4.3).

Assess size from the BRD, not from the assigned date. Where the assigned date is shorter than the table figure, that difference is recorded under §3.3 and drives the maturity tier — it does not compress the work, it reduces what the work can produce.

**Two qualifiers override the table entirely:**

- Where a rule set requires regulatory or legal interpretation, **§4.2** applies. Refinement of that kind is not estimable by effort and the table figure is not the lead time.
- Where more than one ORD is in active elicitation, **§4.6** applies.

### 4.2 Refinement is a separate activity, and it is not estimable by effort

The table in §4.1 covers **collection plus routine refinement**. They do not cover contested refinement, which follows different rules (§1.2).

**Refinement duration is set by how many parties must agree, and by their availability — not by analyst effort.** It cannot be compressed by working harder, prioritising better, or applying more analyst time. Adding effort to a rule awaiting a Legal interpretation changes nothing.

| Refinement class | Parties who must agree | Indicative duration |
|---|---|---|
| **Clarification** | A single business owner | Days |
| **Cross-unit rule** | 2–3 business units with differing practice | 2–4 weeks |
| **Obligation-dependent rule** | Business units **plus Legal and Regulatory**, sometimes external counterparties | **6+ weeks, open-ended** |

Business rules requiring regulatory or legal interpretation are the dominant driver. Nine weeks of discussion to settle a single rule set on a complex change is within observed range — it is the cost of that refinement class, not an overrun.

**Rule.** Contested refinement is tracked as a **separate open activity with its own named parties and status. It does not hold the ORD.** Consistent with §1, the ORD is delivered on its committed date carrying those rules at their actual status (§5) — stated, owned, and visibly unresolved — rather than being held open indefinitely while they settle.

**But it is not free, and this is where the model was previously wrong.** Contested refinement does not hold the *document*, and it does hold the *convenor's week*. A rule set under active adjudication consumes roughly **3 hours per week of facilitated discussion** for as long as it runs — and those hours come directly off the collection sequence, because they are the same hours. Refinement is not estimable by effort in its *duration*, which is what this section has always said; it plainly consumes effort while it lasts, which is what the model never deducted.

The consequence is in §4.3 as deduction D3 and in the second §4.1 table. At high allocation it costs 20–40% of the lead time. At low allocation it is the difference between viable and not: a Medium change at 40% allocation is deliverable in 42 days with no contested rule set, and with one it takes 60 — the last day of the Extended band, and viable only with the date explicitly accepted.

**This is also why a rule set in obligation-dependent refinement must be identified at assignment** (below). It is not only a lead-time driver in its own right — it selects which of the two §4.1 tables applies.

**Rule.** Where a rule set is in obligation-dependent refinement, say so at assignment. It is the one lead-time driver that can be identified on day one from the BRD's constraints (§3.4, B3), and it is the difference between an L-sized lead time and an open-ended one.

**The functional problem this exposes.** Business rules are *functional* requirements. In a chain with no functional requirements document (§7.1), extended refinement produces a large body of hard-won, multi-party-agreed detail with **no artefact to live in**. Weeks of Legal and Regulatory adjudication then survive only in the referred requirements register (§7.2), in an ORD section where it does not belong, or in the memory of whoever attended. This is the strongest available argument for a companion functional requirements document: the absence is not a documentation gap, it is the missing home for the single most expensive activity in the process.

### 4.3 The allocation model behind the table

This section shows the arithmetic behind §4.1. It matters because the relationship is **not linear**, and the non-linearity is what makes low allocations fail in a way that surprises people.

**Collection effort by size**, at 7.6 hours per day: S ≈ 30 hours · M ≈ 46 hours · L ≈ 68 hours. The worked example below uses M.

**Productive hours per week** = (allocation % × 38 hours) − (line overhead × allocation %) − program ceremony − refinement load, all multiplied by a focus factor.

**Leave comes off capacity before any of this.** The hours available over the window are the business days in it, less the person's own leave, at 7.6 hours a day. The deductions apply to the weeks actually worked — a week on leave carries no ceremony and no 1:1s — so leave removes its gross hours from capacity and slightly less than that from productive time. Leave falling on the decision workshop or sign-off also moves the date, because those steps need the convenor present (§4.7.1).

### Three deductions, not one

Each is named and independently adjustable. This is deliberate: a single blended "productivity" percentage cannot be diagnosed, argued with, or improved, because nothing in it is attributable. Every figure below is a separate claim that can be measured or disputed on its own.

| # | Deduction | Figure | Behaviour | Scales with allocation? |
|---|---|---|---|---|
| D1 | **Line overhead** — team meetings, 1:1s, ordinary operational meetings within the reporting line | **~2.0 hrs/wk** | Fixed **per person**, so it is shared across that person's programs in proportion to allocation. Assigned to three programs, you still have one set of 1:1s, and each program carries its share | **Split by allocation** |
| D2 | **Program ceremony** — status updates, delivery-readiness updates, planning, coordination for the program | **~4.5 hrs/wk** | Fixed **per program**. Assigned to two programs, you attend two sets | **No** |
| D3 | **Refinement load** — facilitated business-rule discussions while a rule set is in contested refinement (§4.2) | **~3.0 hrs/wk** | Present only while a contested rule set is live. Productive ORD work, but it is not collection and does not advance the §4.5 sequence | **No** |

**Fixed deduction at full allocation: 6.5 hrs/wk baseline · 9.5 hrs/wk with contested refinement live.** Below full allocation, D2 and D3 are charged whole and D1 at its share.

**D1 was charged whole to every program until v1.17.** That treated a per-person overhead as a per-program one: a person at 30% on this program carried all of their 1:1s against it, and the remaining 70% elsewhere carried them again. §4.6 always added D1 once across two programs; the per-program table now agrees with it.

Then apply the **focus factor of 0.55** to what remains — email, admin, context switching, interruption recovery, and re-acquiring context after a gap.

### On the focus factor

**0.55 is assembled from adjacent evidence, not measured here, and the standard does not claim otherwise.** The two usable sources — RescueTime telemetry (~56% of non-meeting time productive) and Microsoft's creating-versus-communicating split (43%) — are the only large-sample figures found that explicitly state their meeting treatment, which is what makes them usable in a model that deducts meetings separately. Both are vendor-published with real limitations.

**The 80% figure this replaces was inherited, not derived.** It descends from the agile "focus factor", which descends from Extreme Programming's load factor — where the prescribed method was always to *measure it locally and recompute it*, never to adopt a constant. No primary source publishes 80% with a study behind it. Applying it here would also have double-counted, since the folklore factor's implicit job is to absorb meetings, and meetings are deducted above by name.

**Calibrate locally and replace this figure.** Divide focused hours delivered by elapsed hours over a completed engagement. That is what the concept was built for, and a local figure is defensible in a way that no borrowed one is.

### The arithmetic

| Allocation | Allocated hrs/wk | Less D1 share + D2 | × 0.55 | Throughput (M) | With D3 live |
|---|---|---|---|---|---|
| 100% | 38.0 | 31.5 | 17.3 | ~13 working days | ~15 |
| 80% | 30.4 | 24.3 | 13.4 | ~17 working days | ~19 |
| 60% | 22.8 | 17.1 | 9.4 | ~24 working days | ~29 |
| 50% | 19.0 | 13.5 | 7.4 | ~31 working days | ~39 |
| 40% | 15.2 | 9.9 | 5.4 | ~42 working days | ~60 — at the ceiling |
| 30% | 11.4 | 6.3 | 3.5 | **not deliverable** | **not deliverable** |
| 20% | 7.6 | 2.7 | 1.5 | **not deliverable** | **none — overheads exceed the allocation** |
| 12.5% | 4.75 | **0.0** | **none** | **not deliverable** | **not deliverable** |
| 10% | 3.8 | **negative** | **none** | **not deliverable** | **not deliverable** |

**Halving allocation more than doubles elapsed time**, because the fixed deductions come out first and are not halved with it.

**Note what this is and is not.** The non-linearity is a **consequence of the fixed-overhead premise, not an empirical finding.** No study measures throughput against fractional allocation for this kind of work; the widely-quoted figures that appear to (Weinberg's 20%-per-project, the 23-minute refocus cost) are folklore with real authors' names attached and should not be cited. What *is* supported is that the overheads are fixed — framework time-boxes, practitioner consensus, and the field's convergence on a hard cap of two teams per product owner all point the same way. Given a fixed overhead, the curve follows by arithmetic. Stated that way the finding is unassailable; stated as measured, it collapses on the first request for a source.

**Below ~30% the allocation is largely consumed by attending the program rather than working on it.** At 20% the residue is an hour and a half a week. At 12.5% the fixed overheads equal the entire allocation — about 21% with a contested rule set live — and below that the arithmetic returns a negative: the assignment is not a small allocation, it is no allocation with meetings attached. A 10% allocation is in that range for every size and either table.

**Rule.** Lead time is **the greater of** two figures:

1. **The latency floor** — the floor for the size (S 20 / M 25 / L 30 working days). Driven by stakeholder scheduling, review windows and adjudication. Independent of allocation.
2. **Effort throughput** — from the table above, at the assigned allocation.

At high allocation an ORD is *latency-bound*: the constraint is waiting for stakeholders, and the floor applies. At low allocation it becomes *effort-bound*, and the floor is irrelevant — quoting it would be misleading.

**Rule.** An allocation below approximately 30% cannot deliver a Medium or Large ORD on any defensible timeline — a Small one takes 44 working days at 30% — and below ~20% cannot deliver one at all. Where one is assigned, record it at assignment (§3.3) as a finding, not as a target to attempt.

**Rule.** State which deductions were applied when quoting a lead time. D3 is present on some engagements and absent on others, and the difference is 20–40% of the elapsed figure. A lead time quoted without saying whether contested refinement was counted is not reproducible.

### Three known weaknesses in these figures

- **D1 and D2 rest on a single week's count on one complex initiative.** Four weeks of the same count would move them from indicative to defensible, and it costs nothing but the counting. A week leading into a target date runs materially higher.
- **The disaggregation matters more than the total.** Counting all meetings together and deducting the lot would have double-counted D3 against the collection effort days, since refinement is productive ORD work rather than overhead on it. Any local recount must preserve the split.
- **Standing load from previously delivered ORDs is not deducted at all, and it is not zero.** Every delivered ORD leaves a tail of refinement, clarification, acceptance queries and defect triage that never fully closes (§4.6), and that tail grows with each one shipped. **The figures above therefore describe a convenor at the start of a cycle, and overstate throughput for one carrying a standing backlog** — which is the normal condition after the first year.

**Why it is named rather than deducted.** A working estimate puts standing load at 20–40% of capacity, but it is a model constructed from the shape of the work rather than a measurement, and deducting it would recompute every cell in §4.1 and §4.7.3 off an unmeasured figure. That is the same defect as the inherited 80% focus factor this section replaced. **The omission is stated instead, and it is measurable by a mechanism this standard already requires:** §6.1 logs post-handoff queries as change items. A month of that log gives the hours, and the hours give D4. Until then, read the tables as a ceiling rather than a forecast where a standing backlog exists.

---

<!-- from reference/ord-intake-standard.md -->

## 4.7 Maturity against a fixed date

§4.1 answers *when will it be ready*. That is not the question a program manager asks, because the date is already set — normally by a downstream milestone in the delivery pipeline rather than by the ORD itself. The question actually asked is:

> **I have this many days and this much of a person. What will I get, and how sure are you?**

This section inverts §4.1 to answer it. **Nothing in §4.1 changes.** The lead-time table becomes the denominator rather than the answer.

### 4.7.1 The three inputs

| Input | Source | Entry criterion |
|---|---|---|
| **Size** (S / M / L) | Assessed from the BRD | §4.1 step 1 |
| **Allocation %** | Assigning manager / resource owner | E6 |
| **Available working days (D)** | Assignment date to the fixed date, counted as business days below | E5 |

**D is counted in business days on the calendar of the jurisdiction where the work is done** —
weekends, public holidays and any declared shutdown excluded. Read the holidays from that
jurisdiction's published calendar for the year, never from memory, because some are proclaimed
annually and some apply to part of a jurisdiction only, such as a metropolitan-only day with
regional substitutes. Use the day that applies where the convenor and the key stakeholders work.
Where they work in different jurisdictions, a day lost in either is lost to the ORD, because the
workshop needs both. Where a holiday inside the window is proclaimed after assignment, recount D.

**The convenor's own leave is not taken out of D. It comes off capacity** (§4.3), because the
calendar keeps running while they are away: booking notice and review windows elapse whether or not
the convenor is at their desk. Leave reduces the hours available to do the work, and moves the date
only where it falls on a step that needs the convenor present — the decision workshop or sign-off.
Leave that is not yet known at assignment is a slip, S5, rather than a deduction.

**Where nobody is allocated yet, D has no start date, and the method runs the other way.** A BRD
endorsed on a resourcing condition reaches assignment with E6 unknown. Read the §4.1 row for the size
and the table, and state the lead time **from the day of allocation** at each allocation in it; then,
for a stated allocation day, count D from that day to the fixed date and give **the lowest allocation
whose lead time fits inside D**. Where none does, say so, and name what would have to move instead —
the size, the date or the tier. This is the same arithmetic as §4.7.2, solved for allocation, and it
turns a missing input into the price of supplying it.

All three are known at assignment *when E1 is present*. None requires stakeholder input to establish. The output is the **maturity tier committed on the date** (§5), and the confidence in it.

**Where size cannot be assessed, because the BRD elements in §3.4 are absent.** This is not an edge case — §3.4 names it as the largest single tier-drop cause, so the model's own entry condition is the input most often missing. The matrix cannot be read, and guessing a size to produce a tier would manufacture a commitment out of an unknown.

**Rule.** Where B1–B3 are absent, do not read the matrix. Record under §3.3 that size is unassessable and why, state **Tier D as the committed position** until the objective, the outcome statement and the operational constraints exist, and name reconstructing them as the first activity. This is honest rather than pessimistic: without a business objective carrying a baseline and a target, every threshold in the document would be unauditable regardless of how much time were available (§3.4), so Tier D is the accurate reading and not a penalty. Re-read the matrix once the elements arrive, from the remaining days.

### 4.7.2 The method

**Step 1 — read the required lead time.** Take L from the §4.1 table for the size and allocation.

**Step 2 — compute the time ratio.** `R = D ÷ L`

**Step 3 — identify the binding constraint.** §4.3 establishes that an ORD is *latency-bound* at high allocation and *effort-bound* at low. The boundary is the point at which the §4.1 row stops being flat:

| Size | Latency-bound at | Effort-bound at |
|---|---|---|
| **S** | ≥ 60% | ≤ 50% |
| **M** | ≥ 60% | ≤ 50% |
| **L** | ≥ 80% | ≤ 60% |

**Step 4 — read the tier.**

| R | Latency-bound | Effort-bound | What fits inside D |
|---|---|---|---|
| **≥ 1.00** | **A** | **A** | The full §4.5 sequence — workshop, review window, register close-out, sign-off |
| **0.80 – 0.99** | **B** | **B** | Workshop held and incorporated. Review window compressed to a single pass; assumption register closed to the wire |
| **0.60 – 0.79** | **B** | **C** | Workshop held and incorporated, no review window. Corrections arrive after handoff as rework |
| **0.40 – 0.59** | **C** | **D** | Workshop held on minimum notice; output not incorporated before issue |
| **< 0.40** | **D** | **D** | No workshop. Document analysis and straw-man only |

**Why the same ratio costs more when effort-bound.** At high allocation the shortfall is *waiting* — booking notice, review turnaround, adjudication. Some of that is recoverable by running stages concurrently and accepting a thinner review. At low allocation the compressible slack has already been squeezed out by §4.3's arithmetic, and the shortfall falls on the work itself: the document analysis is partial, and the straw-man that makes the workshop a decision session rather than a blank-page session may not exist. **A compressed date at full allocation is survivable. The same compression at 40% is not, and the reason is not that there is less time — it is that there is no waiting left to cut.**

**Rule.** Absolute floor. A workshop needs five working days' booking notice, a straw-man issued as pre-read two working days before it, and its output incorporated afterwards. **Below approximately eight available working days no workshop is bookable at all, and Tier D is the ceiling regardless of size or allocation.** This one cannot be bought with allocation.

### 4.7.3 The matrix

Committed maturity tier by available working days and allocation. `†` marks a cell whose R sits less than 0.05 above its band floor — the tier holds only if nothing slips (§4.7.4). Tier D carries no `†`, because there is no lower tier to slip to.

**Every cell is computed, not set by hand.** Until v1.17 the `†` marks were applied by hand, and twelve of them disagreed with the rule above — including a cell marked at R = 0.91, nowhere near a boundary, and three left unmarked at exactly R = 0.80. They are now applied by the rule. The change is listed in the pack's CHANGELOG.

**Two sets of matrices, matching the two §4.1 tables.** Read the baseline set where no rule set is in contested refinement, and the contested set where one is. Each cell is computed by the §4.7.2 method against the corresponding §4.1 lead time — there is no shortcut between them.

### Baseline — no contested rule set in refinement

**S — Small**

| Available days | 100% | 80% | 60% | 50% | 40% | 30% |
|---|---|---|---|---|---|---|
| **10** | C | C | C | D | D | D |
| **15** | B | B | B | C | D | D |
| **20** | A† | A† | A† | A† | C | D |
| **25** | A | A | A | A | B | D |
| **30** | A | A | A | A | A | C |
| **40** | A | A | A | A | A | B |

**M — Medium**

| Available days | 100% | 80% | 60% | 50% | 40% | 30% |
|---|---|---|---|---|---|---|
| **10** | C† | C† | C† | D | D | D |
| **15** | B† | B† | B† | D | D | D |
| **20** | B† | B† | B† | C† | D | D |
| **25** | A† | A† | A† | B† | D | D |
| **30** | A | A | A | B | C | D |
| **40** | A | A | A | A | B | D |

**L — Large**

| Available days | 100% | 80% | 60% | 50% | 40% | 30% |
|---|---|---|---|---|---|---|
| **10** | D | D | D | D | D | D |
| **15** | C | C | D | D | D | D |
| **20** | B | B | D | D | D | D |
| **25** | B† | B† | C | D | D | D |
| **30** | A† | A† | B† | C | D | D |
| **40** | A | A | A | B | D | D |

### Contested refinement live — an obligation-dependent or cross-unit rule set under active adjudication

Computed identically, against the contested §4.1 table. A column reading `—` in that table produces `R = 0` and therefore Tier D throughout: document analysis is still possible at any allocation, which is what Tier D is.

**S — Small**

| Available days | 100% | 80% | 60% | 50% | 40% | 30% |
|---|---|---|---|---|---|---|
| **10** | C | C | C | D | D | D |
| **15** | B | B | B | D | D | D |
| **20** | A† | A† | A† | C | D | D |
| **25** | A | A | A | B | C† | D |
| **30** | A | A | A | A | C | D |
| **40** | A | A | A | A | A† | D |

**M — Medium**

| Available days | 100% | 80% | 60% | 50% | 40% | 30% |
|---|---|---|---|---|---|---|
| **10** | C† | C† | D | D | D | D |
| **15** | B† | B† | C | D | D | D |
| **20** | B† | B† | B | D | D | D |
| **25** | A† | A† | B | C† | D | D |
| **30** | A | A | A† | C | D | D |
| **40** | A | A | A | A† | C | D |

**L — Large**

| Available days | 100% | 80% | 60% | 50% | 40% | 30% |
|---|---|---|---|---|---|---|
| **10** | D | D | D | D | D | D |
| **15** | C | C | D | D | D | D |
| **20** | B | B | D | D | D | D |
| **25** | B† | B† | D | D | D | D |
| **30** | A† | A† | C | D | D | D |
| **40** | A | A | B | C | D | D |

**Rule.** Where a rule set is in obligation-dependent refinement at assignment, read the contested set. The driver is identifiable on day one from the BRD's constraints (§4.2), so the choice of matrix is made at assignment rather than discovered later.

**A superseded shortcut, recorded because it was wrong in a specific way.** An earlier version of this section published the baseline matrices only, and instructed the reader to **drop one tier** where refinement was contested — on the reasoning that the contested lead times run 20–40% longer, which is approximately one band of R. The reasoning holds on average and fails at the top of a band: a 24% longer lead time reduces R by about 19%, and bands are 0.20 wide, so it crosses a boundary only where R already sat in the lower part of its band. On the figures published at the time, at M / 20 days / 60% the shortcut gave C where the computation gave B†; at S / 15 / 60% it gave C against B; at L / 30 / 60% it gave D against C. **A shortcut that is right on average and wrong at the boundaries is worse than no shortcut, because the boundary is where the tier is contested.**

**The two-week deadline, priced.** A Medium change on a ten-day deadline at *full* allocation delivers Tier C, and conditionally — one slip and it is D. Even a Small change at full allocation cannot reach Tier B in ten days. This is not a statement about effort: ten effort days fit in ten elapsed days at 100%. It is a statement about what minimum-notice booking selects for. **A workshop convened on the shortest possible notice is attended by whoever is free, not by whoever holds the demand** — and KPP owners not attending is the named B→C driver in this standard. The two-week ORD does not fail because the work is too large. It fails because the calendar cannot deliver the right people inside it.

### 4.7.4 Confidence

Confidence is not expressed as a percentage. A probability figure here would be traceable only to author judgement, and §5 rejects exactly that class of number in the document this standard governs; it cannot be admitted into the standard itself.

Confidence is instead **the amount of slack the ratio carries against the seven things that can slip**:

| # | Slip | Effect |
|---|---|---|
| S1 | Decision workshop reschedules | Resets the five-day booking clock (§3.2) |
| S2 | Business stakeholder list arrives after assignment | Costs the delay *plus* the booking notice (§3.2) |
| S3 | Contested refinement **emerges after assignment** | Not visible on day one, so the tier was read from the baseline matrix rather than the contested one (§4.7.3). The affected KPPs may not reach Committed in any window (§4.2) |
| S4 | A second ORD enters active elicitation | Refinement quality degrades before elicitation quality does (§4.6) |
| S5 | **An SME or resource the critical path depends on has limited or unknown availability** inside the window — leave, a competing reporting period, a part allocation, or one person carrying several open decisions | Decisions and workshop attendance wait on that person's calendar, and nothing else in the model can buy the time back (§4.4) |
| S6 | **Stakeholders named at assignment have not yet been engaged** — the BRD records them as *Not yet engaged* | Their demand is the author's reading until they are, and engaging them adds a booking cycle the lead time did not count (§3.2) |
| S7 | **The allocation is contended** — the convenor is named at a stated allocation that another program also claims | If the competing claim wins, the allocation drops and the lead time moves to the next column down, where the fixed overheads take a larger share (§4.3, §4.6) |

| Confidence | Condition | How to state it |
|---|---|---|
| **High** | R sits clear of its band floor and none of S1–S7 is present | The tier is committed |
| **Conditional** | R is within 0.05 of its band floor (`†`), **or** exactly one of S1–S7 is present | The tier is committed; one named slip drops it one tier |
| **Low** | R is at a band floor (`†`) **and** one or more of S1–S7 is present, **or** two or more are present | The tier below is the planning figure; the stated tier is the optimistic case |

**Rule.** Where confidence is Low, the tier recorded under §3.3 is the lower one. A tier stated at its optimistic value is the same defect as an unsourced threshold — it reads as a commitment and is not one.

**Rule.** Where confidence is Low, the position recorded under §3.3 is not complete until the RAID
entries behind it are drafted: a Decision for each unresolved business decision, with its owner and
the date it is needed by; a Risk for each slip present; an Action for each SME not yet nominated and for an allocation not yet made; and a Risk for each business unit with no design support committed (OH-16). The convenor drafts them and the owner of
the RAID log raises them. **This completes the record; it does not hold up progression.** ORD
development proceeds at any confidence, and the entries are how a Low confidence reaches the people
able to change it. The BRD review drafts them first where it projects Low confidence, per the BRD
standard's § *The readiness projection*.

### 4.7.5 The milestone the date serves

E5 requires the confirmed target date **and the milestone it serves**, because a fixed date is almost never arbitrary — it lands on a gate in the delivery pipeline. That milestone determines which tier is *sufficient*, and a tier is only meaningful against it.

| Deadline serves | What that gate consumes | Sufficient tier | Why |
|---|---|---|---|
| **Target date / release scoping** | The shape and scale of the demand | **C** | Estimation needs scope, not confirmed thresholds. A C-tier ORD is adequate input |
| **Funding or investment gate** | A defensible traceability chain | **B** | The gate tests whether figures are derivable, not whether they are final |
| **Architecture engagement / SOAP drafting** | KPP thresholds with cited sources | **B** | Architecture can begin against sourced figures; it cannot commit against assumed ones |
| **Architecture commitment / design sign-off** | KPP thresholds owner-committed | **A** | This is the point past which a figure change becomes redesign rather than adjustment |
| **Vendor or contract commitment** | Owner-committed thresholds | **A** | Externally binding. A moved figure is a contract variation |

*Substitute the local gate names.* The rows above are the generic pipeline milestones; the sufficient-tier column is what transfers.

**The output is a gap, not a tier.** Read the achievable tier from §4.7.3 and the sufficient tier from the row above, and record the difference under §3.3:

> *Medium change, 15 available working days, 60% allocation. Achievable: Tier B, conditional. The date serves architecture commitment, which requires Tier A. The gap is one tier. It closes with five further working days, or with the stakeholder list supplied at assignment — not with additional allocation, which buys nothing at 60% for a Medium change (§4.1).*

That sentence is the entire purpose of this section. It states the position, prices both remedies, and rules out the remedy a manager reaches for first.

**Rule.** Where the achievable tier meets the sufficient tier, say so and stop. This model exists to identify gaps, not to argue for more time on dates that are already adequate. A C-tier ORD delivered for release scoping against a target date is a correct outcome, and treating it as a shortfall discredits the model on the occasions when the gap is real.
