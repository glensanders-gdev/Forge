---
name: "review-brd"
description: "Assess a submitted BRD against the requirements-documents pack on three independent questions — the handoff gate (BH-1 to BH-10, the [TBD] rule, four outcomes), business definition readiness (BD-1 to BD-10, four outcomes) and acceptance derivability (the criteria that cannot yet be derived) — then project the ORD's lead time, tier and confidence from the BRD's condition. Returns per-item verdicts with evidence and mechanically derived outcomes, never resolving a business decision on the business's behalf. Criteria are read from the pack at review time, never recalled. Use when a BRD arrives for ORD development, when $review-brd is run, or before ORD work is assigned against a BRD."
metadata:
  category: pipeline
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# BRD Review

Assess whether a BRD is ready for ORD development, and what its condition means for the ORD that
follows.

Execution mode: **[AFK]** advisory — the review runs autonomously and produces a report; it changes
no document, raises no RAID entry and declares no sign-off. The one human gate is the standard's own:
acceptance belongs to the BRD's author and the approving GMs, and this skill supplies the assessment
they act on.

This is a conformance review against a published standard, not open critique. The criteria live in
the requirements-documents pack; this skill locates them, applies them, and records verdicts. Reach
for `$critic` when the question is whether a document is *good* — reach for this one when the
question is whether it is *ready*.

**Three questions, reported separately.** The pack's BRD standard asks whether ORD development can
begin (the handoff gate), whether requirements can be derived without a downstream team inventing
business policy (business definition readiness), and which acceptance criteria cannot yet be
derived. **The second and third never change the first** — a BRD can be accepted for ORD development
and still carry decisions that keep particular requirements from being baselined.

**Why this exists.** §8 of the ORD Intake and Maturity Standard names *"a named independent
reviewer on every ORD, who did not author it"* as its highest-value Tier 1 control, and states that
its absence causes **silent defect survival**. This skill is that control, mechanised at the
upstream hop.

---

## Step 1 — Read the criteria, never recall them

Source them per [GATE-PROTOCOL.md](GATE-PROTOCOL.md) § *Sourcing the criteria* — the live pack's
`reference/brd-standard.md`, `reference/traceability-matrix.md` and `reference/ord-intake-standard.md`
where held, otherwise the stamped extract in [CRITERIA.md](CRITERIA.md). Name the pack version in the
report.

Read in full, from the BRD standard: § *The handoff gate* with its `[TBD]` treatment, bar, supporting
items and four outcomes; § *Business definition readiness* with every subsection; § *The stakeholder
register, and the approving GM register*, which carries the department list; and both worked
assessments — § *The handoff gate, applied to this document* and § *Business definition readiness,
applied to this document*. From the ORD Intake Standard: §3.2, §4.1 – §4.3 and §4.7, which the
readiness projection reads its figures from.

The worked assessments are the **reference implementation** — real assessments carrying declared
gaps, an unowned gap, owned decisions and a Low-confidence projection, not clean sheets. This skill's
output looks like them.

**Completion:** the standard and the BRD under review are both read end to end, and every item
definition is in hand as written rather than as remembered.

## Step 2 — Verdict every gate item, with evidence

Apply the verdict vocabulary, the evidence rule and the two limits in
[GATE-PROTOCOL.md](GATE-PROTOCOL.md) to each of BH-1 – BH-10.

BRD-specific criteria to apply while doing so, each defined in the standard rather than here:

- **BH-1** — assessed **per objective**, not once for the set. The two limits govern how many
  objectives may be declared gaps.
- **BH-2** — the **solution-vs-outcome test**. An objective naming a feature, system, vendor or an
  asserted figure has pre-empted the ORD.
- **BH-4** — the **cost-of-failure form**. A tolerance traced to no consequence is an invented
  figure however well written.
- **BH-10** — business altitude: no workflow, system or figure.
- The **★ sections** carry the load; an unstarred section that is thin is not a gate finding.

**Completion:** all ten carry a verdict, and every verdict cites the section or row it was read
from, or names precisely what is absent.

## Step 3 — Derive the gate outcome, then run the checks

Derive one of the four outcomes mechanically by the precedence rule in
[GATE-PROTOCOL.md](GATE-PROTOCOL.md) — the outcome follows from the verdicts rather than from
judgement about the document's overall quality.

Then apply the **five checks** and the **three rule-level scans** from
`reference/traceability-matrix.md`, reporting only those a BRD can answer at this hop. Where a check
is unanswerable upstream of the ORD, say so rather than reporting it clean.

**Completion:** the outcome is stated with the verdicts that forced it, and each check and scan is
answered or explicitly marked not answerable at this hop.

## Step 4 — Assess business definition readiness

Apply § *Business definition readiness* from the BRD standard:

1. **Name the kind of change** — enhancement, new capability or new measure — and, for a new measure,
   apply the standard's answer on whether ORD development can proceed while it is undefined.
2. **Decide whether BD-1 – BD-10 apply.** Where no outcome turns on material business logic, say so
   once, and the outcome is *Ready*.
3. **Apply BD-1 – BD-10**, running the two-reader test over each material stakeholder requirement to
   find hidden decisions. Classify every gap by the standard's six kinds, and record the source
   authority each rule rests on.
4. **State what each material gap reaches**, in the standard's form, only as far as the traceability
   shows.
5. **Derive the business definition outcome** mechanically, by the standard's precedence.

**Never resolve what the review finds.** Name the decision, who should make it and what it blocks;
never pick an interpretation, supply a threshold or infer an order of precedence.

**Completion:** every BD item carries a finding, *Met*, or *not applicable* with the reason; every
unresolved decision has an owner or is marked *Unowned*; and the outcome is stated with what forced it.

## Step 5 — List what cannot yet be derived

For each criterion an unresolved decision blocks, write the standard's *Not safely derivable* record:
the requirement, the reason, the decision required — stated as a question, never as an answer — its
owner, and the proving scenario. Name the requirements that are derivable in one line.

This is a list, not an outcome: no acceptance criterion exists at the BRD hop, and the full
acceptance judgement belongs to `$review-ord`.

**Completion:** every blocked criterion has a record, and none is made more specific than its source.

## Step 6 — Project the lead time, tier and confidence

Apply § *The readiness projection* from the BRD standard, reading every figure from the ORD Intake
Standard rather than estimating:

1. **BRD readiness rating** — from the gate outcome and the business definition outcome together.
   *Not ready* ends the projection at Tier D.
2. **Size** — the highest band any §4.1 indicator reaches. Count the stakeholders after checking the
   BRD's answers against the department list, and report any department not asked.
3. **Allocation** — ask for it if the BRD or the request does not state it. **Never assume full
   allocation.** Take the convenor's leave in the window off capacity.
4. **Modifiers** — apply each that is present, with its source.
5. **Available business days** — count from assignment to the fixed date on the jurisdiction's
   calendar: the `lead_time_team` in the active company's `config.md`, and the
   `holidays` file that team names. Where no calendar is held, ask the user for the
   jurisdiction's published holidays in the window. **Never recall a holiday date.**
6. **Tier and confidence** — R, the tier and its `†` by §4.7.2, and confidence by §4.7.4.

**At Low confidence, draft the RAID entries** the standard requires — a Decision for each unresolved
business decision and a Risk for each slip present. Draft them; never raise them. At High or
Conditional confidence, say drafting them is recommended.

**Completion:** the projection block is filled, or the report states which input is missing and
stops the projection there.

## Step 7 — Run the language pass

Run the language pass in [GATE-PROTOCOL.md](GATE-PROTOCOL.md) § *The language pass* over the BRD.

**Completion:** the `$review-language` report is in hand, or the reason it could not run is
recorded.

## Step 8 — Report

Emit the report in [GATE-PROTOCOL.md](GATE-PROTOCOL.md)'s output format, then ask whether to work
through the findings. Where the gate outcome is *Not yet ready for ORD development*, apply the
protocol's § *Not yet ready, and authority* before emitting it. State every recommendation as
*Recommended:* or *Consider:* — the review recommends, and the author and approving GMs decide.

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| Neither the live pack nor `CRITERIA.md` is readable | Stop, per [GATE-PROTOCOL.md](GATE-PROTOCOL.md) § *Sourcing the criteria*. Never substitute recollection — a gate applied from memory drifts from the published one silently, and the drift is invisible in the output |
| `CRITERIA.md` carries the ⚠️ **dirty working tree** warning in its provenance line | The extract was generated from uncommitted pack state, corresponds to no committed version, and cannot be reproduced. Prefer the live pack and say the extract was bypassed; where it is the only source, run the review and record in *Assessed against* that the bar itself is unreproducible |
| The live pack and `CRITERIA.md` disagree | The pack wins and the extract is stale — say so in the report and regenerate with `tools/build-review-criteria.py`. Never prefer the extract because it is closer to hand |
| The pack defines an item this skill does not name — a BH-11, a BD-11, or a renumbered bar | Verdict every item the pack defines, and report the ones this skill does not name. The skill is the defect, not the document: where the standard and this skill disagree, the standard wins |
| The reviewer authored the BRD | Run the review and record the non-independence in the *Reviewer* line. An unmarked self-review is exactly the condition the record exists to make countable |
| An ORD, PRD or other document is submitted | Stop and name the mismatch. BH-1 – BH-10 and BD-1 – BD-10 are the BRD's bar; applying them to a document written to a different one produces verdicts against a bar it was never authored to |
| The BRD names a pack version other than the one being applied | Name both in the report. A verdict is meaningful only against a named bar |
| The BRD declares no business objectives at all | BH-1 is *Absent*, not unassessable. Say the two limits cannot be applied, and that the readiness rating is *Not ready* |
| Every absence in the BRD is declared with an owner and a date | Apply the two limits as the pack scopes them, and say so. Without them the bar is unfailable |
| An unstarred section is thin | Record it as an observation outside the verdicts, never as a gate finding |
| A traceability check or scan cannot be answered at the BRD hop | Mark it *not answerable at this hop* with the reason. A check reported clean because it could not be run is worse than one reported unanswerable |
| A requirement could be read two ways | Record the hidden decision, its owner or *Unowned*, and what it reaches. **Never choose the reading** — the cleanest interpretation is the one most likely to be wrong and least likely to be questioned |
| A rule rests only on an assumption or a working interpretation | Record it as undecided, whatever its wording. Never treat it as an approved rule because it is phrased as one |
| Two authoritative sources conflict | Surface the conflict with both sources cited. Never select one |
| An acceptance criterion would need a rule the sources do not state | Record it as *Not safely derivable*. Never write a plausible rule to make the criterion testable |
| No business logic is at stake | Say so once; the business definition outcome is *Ready*. Never apply BD-1 – BD-10 item by item to a document they do not reach |
| The allocation or the fixed date is not known | Report the readiness rating and the size, state that the projection cannot be made, and name the missing input. Never assume full allocation or a date |
| No holiday calendar is held for the jurisdiction | Ask the user for the published holidays in the window. Where none is supplied, count weekdays only and say in the projection that public holidays are not excluded. Never recall a holiday date |
| The BRD's §5 has no `Engagement` column, or Appendix A no `Impact basis`, because it predates pack v1.17 | Read every stakeholder as *engagement not recorded* and every impact as *basis not recorded*, and say so. Never infer that a stakeholder was engaged |
| Departments were not asked | Report them, and project a range up to the next size's row. Never assume *none found* |
| Confidence is Low | Draft the RAID entries before the report is complete. Never raise them, and never present them as a block on progression |
| The language standard cannot be read | Emit the report anyway, and record under *Language (advisory)* that the pass did not run. The language pass never blocks the gate |
| The gate outcome is *Not yet ready for ORD development* | Apply [GATE-PROTOCOL.md](GATE-PROTOCOL.md) § *Not yet ready, and authority* before emitting. The right to refuse handoff is not currently held, so the finding is recorded rather than exercised |

---

## Rules

- **Never restate a criterion in this skill's own prose.** The pack is the source of truth.
  `CRITERIA.md` is a generated extract of it, not a second copy to edit.
- **Never emit a score or a percentage.** Each question's currency is a per-item verdict and a named
  outcome; confidence is High, Conditional or Low.
- **Never resolve a business decision on the business's behalf** — no chosen interpretation, no
  supplied threshold, no inferred precedence, no assumption promoted to a requirement.
- **Never let the business definition outcome or the projection change the gate outcome.** The three
  questions are independent.
- **Never assume full allocation, and never recall a holiday date.**
- **Never raise a RAID entry.** Draft it; the author or convenor raises it.
- Report an assessment; the sign-off is the author's and the approvers'. This skill declares.
- Where the standard and this skill disagree, the standard wins — and say so in the report, because
  a disagreement is a defect in this skill.
