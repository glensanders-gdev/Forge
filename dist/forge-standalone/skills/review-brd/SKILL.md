---
name: review-brd
category: pipeline
description: Assess a submitted BRD against the published handoff gate — BH-1 to BH-10, the [TBD] treatment rule and the four outcomes — returning a per-item verdict table with evidence and a mechanically derived outcome. Criteria are read from the requirements-documents pack at review time, never recalled. Use when a BRD arrives for ORD development, when /review-brd is run, or before ORD work is assigned against a BRD.
---

# BRD Review

Assess whether a BRD clears **the bar** for ORD development.

Execution mode: **[AFK]** advisory — the review runs autonomously and produces a report; it changes
no document and declares no sign-off. The one human gate is the standard's own: acceptance belongs
to the BRD's author and the approving GMs, and this skill supplies the assessment they act on.

This is a conformance review against a published gate, not open critique. The criteria live in the
requirements-documents pack; this skill locates them, applies them, and records verdicts. Reach for
`/critic` when the question is whether a document is *good* — reach for this one when the question
is whether it is *ready*.

**Why this exists.** §8 of the ORD Intake and Maturity Standard names *"a named independent
reviewer on every ORD, who did not author it"* as its highest-value Tier 1 control, and states that
its absence causes **silent defect survival**. Every pass over that pack to date has been its own
author's. This skill is that control, mechanised at the upstream hop.

---

## Step 1 — Read the criteria, never recall them

Source them per [GATE-PROTOCOL.md](GATE-PROTOCOL.md) § *Sourcing the criteria* — the live pack's
`reference/brd-standard.md` and `reference/traceability-matrix.md` where held, otherwise the
stamped extract in [CRITERIA.md](CRITERIA.md). Name the pack version in the report.

Read in full: § *The handoff gate*, § *How a `[TBD]` is treated*, the bar (BH-1 – BH-4), the
supporting items (BH-5 – BH-10), § *The four outcomes*, and § *The handoff gate, applied to this
document*.

That last section is the **worked reference implementation** — a real assessment carrying declared
gaps and one unowned gap, not a clean sheet. This skill's output looks like that table.

**Completion:** the standard and the BRD under review are both read end to end, and the ten item
definitions are in hand as written rather than as remembered.

## Step 2 — Verdict every item, with evidence

Apply the verdict vocabulary, the evidence rule and the two limits in
[GATE-PROTOCOL.md](GATE-PROTOCOL.md) to each of BH-1 – BH-10.

BRD-specific criteria to apply while doing so, each defined in the standard rather than here:

- **BH-1** — assessed **per objective**, not once for the set. The two limits govern how many
  objectives may be declared gaps.
- **BH-2** — the **solution-vs-outcome test**. An objective naming a feature, system, vendor or an
  asserted figure has pre-empted the ORD.
- **BH-4** — the **cost-of-failure form**. A tolerance traced to no consequence is an invented
  figure however well written, and the standard names this the most common upstream cause of a
  low-maturity ORD.
- **BH-10** — business altitude: no workflow, system or figure.
- The five **★ sections** carry the load; an unstarred section that is thin is not a gate finding.

**Completion:** all ten carry a verdict, and every verdict cites the section or row it was read
from, or names precisely what is absent.

## Step 3 — Derive the outcome, then run the five checks

Derive one of the four outcomes mechanically by the precedence rule in
[GATE-PROTOCOL.md](GATE-PROTOCOL.md) — the outcome follows from the verdicts rather than from
judgement about the document's overall quality.

Then apply the **five checks** from `reference/traceability-matrix.md` — baseline, coverage,
conformance, translation and verifiability gaps — reporting only those a BRD can answer at this
hop. Where a check is unanswerable upstream of the ORD, say so rather than reporting it clean.

**Completion:** the outcome is stated with the verdicts that forced it, and each of the five checks
is answered or explicitly marked not-yet-answerable.

## Step 4 — Report

Emit the report in [GATE-PROTOCOL.md](GATE-PROTOCOL.md)'s output format, then ask whether to work
through the findings. Where the outcome is *Not accepted for ORD development*, apply the
protocol's refusal-and-authority handling before emitting it.

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| Neither the live pack nor `CRITERIA.md` is readable | Stop, per [GATE-PROTOCOL.md](GATE-PROTOCOL.md) § *Sourcing the criteria*. Never substitute recollection — a gate applied from memory drifts from the published one silently, and the drift is invisible in the output |
| `CRITERIA.md` carries the ⚠️ **dirty working tree** warning in its provenance line | The extract was generated from uncommitted pack state, corresponds to no committed version, and cannot be reproduced. Prefer the live pack and say the extract was bypassed; where it is the only source, run the review and record in *Assessed against* that the bar itself is unreproducible |
| The live pack and `CRITERIA.md` disagree | The pack wins and the extract is stale — say so in the report and regenerate with `tools/build-review-criteria.py`. Never prefer the extract because it is closer to hand |
| The pack defines an item this skill does not name — a BH-11, or a renumbered bar | Verdict every item the pack defines, and report the ones this skill does not name. The skill is the defect, not the document: where the standard and this skill disagree, the standard wins |
| The reviewer authored the BRD | Run the review and record the non-independence in the *Reviewer* line. §8 names a reviewer *"who did not author it"* as its highest-value control and its absence as the cause of silent defect survival — an unmarked self-review is exactly the condition the record exists to make countable |
| An ORD, PRD or other document is submitted to this gate | Stop and name the mismatch. BH-1 – BH-10 are the BRD's bar; applying them to a document written to a different one produces verdicts against a bar it was never authored to |
| The BRD names a pack version other than the one being applied | Name both in the report. A verdict is meaningful only against a named bar, and a BRD authored to one revision assessed against another is a finding about the pair, not about the document |
| The BRD declares no business objectives at all | BH-1 is *Absent*, not unassessable. Say the two limits cannot be applied — both are scoped to objectives, and without them the bar has no floor |
| Every absence in the BRD is declared with an owner and a date | Apply the two limits as the pack scopes them, and say so. Without them every absence converts to `[TBD]` + owner + date and the bar becomes unfailable, which is a gate that cannot fail rather than a document that passed |
| An unstarred section is thin | Record it as an observation outside the verdicts, never as a gate finding. The five ★ sections carry the load, and inflating the gate to cover the rest is how a conformance review turns into critique |
| A check from `reference/traceability-matrix.md` cannot be answered at the BRD hop | Mark it *not answerable at this hop* with the reason. Most are not answerable upstream of the ORD, and a check reported clean because it could not be run is worse than one reported unanswerable |
| The outcome is the refusal | Apply [GATE-PROTOCOL.md](GATE-PROTOCOL.md) § *Refusal and authority* before emitting. The right to refuse handoff is not currently held, so the refusal is recorded rather than exercised — and the accumulation of those records is the argument for establishing the control |

---

## Rules

- **Never restate a criterion in this skill's own prose.** The pack is the source of truth.
  `CRITERIA.md` is a generated extract of it, not a second copy to edit — hand-editing that file is
  how the pack stops being authoritative.
- **Never emit a score or a percentage.** The gate's currency is a per-item verdict and one of four
  outcomes. A number invites more trust than a conformance review earns.
- Report an assessment; the sign-off is the author's and the approvers'. This skill declares.
- Where the standard and this skill disagree, the standard wins — and say so in the report, because
  a disagreement is a defect in this skill.
