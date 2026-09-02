# review-brd — criteria extract

> **Generated file. Never hand-edit.** Produced by `tools/build-review-criteria.py`
> from the requirements-documents pack, which is the single source of truth for
> everything below. Editing this file puts it out of step with the pack; regenerate
> instead.

**Pack version:** v1.9 · **Pack commit:** `719eecb78e35`
**Generated:** 2026-09-02 · **Content hash:** `397b4a4489d959ef`

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

---

<!-- from reference/brd-standard.md -->

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

*Worked example continuous with [BRD-2026-041](#brd) and the [worked example ORD](#example). The
chain and its artefact owners are from [§1 Purpose and the chain](#purpose). Standards: BABOK v3 ·
ISO/IEC 25010:2023 · ISO/IEC/IEEE 29148:2018 (the unadopted functional half).*
