---
name: brd-review-gate-protocol
description: Shared review protocol for the two handoff gates in the requirements-documents pack — verdict vocabulary, evidence rule, outcome derivation and precedence, refusal-and-authority handling, and the report format. Read when running $brd-review or $ord-review.
origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Gate Review Protocol

The machinery both gates share. `brd-review` and `ord-review` cite this file rather than carrying
two copies that drift.

**What this file is not.** It holds no criterion. Every BH and OH item, the `[TBD]` treatment table
and the four outcomes are defined in the pack and read from it at review time. This file states only
how a review is *conducted and reported* — which is tooling, and has no home in the pack.

---

## Verdict vocabulary

Four verdicts, from the pack's `[TBD]` treatment table and the verdicts its worked assessment
actually uses. Use these words exactly; a fifth verdict is a sign the treatment table was not read.

| Verdict | The item carries |
|---|---|
| **Met** | A value |
| **Met, with a declared gap** | `[TBD]` with a named owner **and** a date. Met for the bar — and the gap propagates |
| **Unowned gap** | Outstanding, with **nobody to carry it**. Neither met nor owned |
| **Absent** | Nothing at all, or `[TBD]` missing the owner, the date, or both. A hole, not a gap |

**The propagation rule is part of the verdict, not a footnote.** A declared gap that passes the bar
and then disappears is worse than a refusal, because it looks like a pass. Every *Met, with a
declared gap* verdict names where the gap must reappear downstream — the empty traceability row, the
unanswered objective — and a review that cannot name that has not finished the verdict.

**The two limits, wherever declared gaps are counted.** The pack states both at the BRD gate, in
objective terms: at least one objective is fully quantified, and the gap does not sit on the
objective the change is funded against. Without them the bar is unfailable, because every absence
converts to `[TBD] + owner + date`. Apply them where the pack scopes them; where a downstream item
is not an objective, say the limits are stated upstream rather than asserting they bind here.

## Evidence rule

**Every verdict cites where it was read** — the section, the row, the requirement ID — or names
precisely what is absent. A verdict with no citation is an assertion, and an assertion is what an
independent reviewer exists to replace.

## Outcome derivation

The outcome follows from the verdicts. Test in this order and stop at the first that fires:

| Order | Condition | Outcome |
|---|---|---|
| 1 | Any **bar** item is *Absent* | The refusal outcome — *Not accepted for ORD development* / *Not ready for handoff* |
| 2 | Any item, bar or supporting, is an *Unowned gap* | The unowned-gap outcome |
| 3 | Any item is outstanding with an owner and a date, or carries a declared gap | The recorded-gaps outcome |
| 4 | Otherwise | The clean outcome — *Accepted* / *Ready for handoff* |

**This order is the pack's, not this file's.** Both gates state the precedence — the refusal first,
then the unowned gap, then recorded gaps — and both state that the recorded-gaps outcome covers a
declared gap wherever it sits, **including on the bar**. Read those two statements at the gate rather
than trusting this table; where they disagree with it, they win and this file is the defect.

## Refusal and authority

The refusal outcome is the one outcome in the pack that requires authority: the Tier 1 control
*"right to declare an ORD not-ready and refuse handoff"* at §8, which the standard states is **not
currently held**.

Where that right is not held, report the refusal as **recorded rather than exercised**: name the
absent bar items, state that the document proceeds, and state that the accumulation of these records
across cycles is the evidence for establishing the control. A gate that implies an authority nobody
holds is theatre; a refusal that was warranted, declared and overridden is the argument for the
control.

## Report format

```markdown
## [BRD|ORD] Review — [document ID and title]

**Assessed against:** [standard path] · **Reviewer:** [named, and whether they authored it]

### Verdicts

| # | Verdict | Evidence |
|---|---|---|
| BH-1 | **Met, with one declared gap** | [section or row, and what makes it that verdict] |

### Outcome

> **[Outcome name].** [The verdicts that forced it, by the derivation order above.]
> [Where a declared gap passed the bar: where it must reappear downstream.]
> [Where the outcome is a refusal: the authority note above.]

### The five checks

| Check | Finding |
|---|---|
| Baseline gap | [answered, or *not answerable at this hop* with the reason] |

### What this review does not cover

[Anything the gate does not reach — content quality, altitude beyond the items, downstream fit.]
```

**Report what the verdicts did not do, where it matters.** A recorded gap drives the maturity tier
only where it reaches a KPP-bearing requirement. Recording a gap and tier-driving it are two
different things, and the pack names conflating them as how a gate becomes theatre.

## The five checks

Read from `reference/traceability-matrix.md` at review time — baseline, coverage, conformance,
translation and verifiability gaps. Answer each, or mark it not-yet-answerable at this hop with the
reason. A check reported clean because it could not be run is worse than one reported unanswerable.

---

## Never

- Never carry a criterion in this file. It holds protocol; the pack holds the bar.
- Never emit a score, a percentage or a pass rate — four outcomes and a verdict per item.
- Never report a check clean that could not be run at this hop.
- Never let a declared gap pass without naming where it reappears downstream.
