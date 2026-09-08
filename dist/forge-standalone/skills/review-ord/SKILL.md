---
name: review-ord
category: pipeline
description: Assess a submitted ORD against the published §7.1 handoff gate — OH-1 to OH-15, the four outcomes, the §7.3 refuse-to-produce scan and the §5 tier rule — returning a per-item verdict table with evidence and a mechanically derived outcome. Criteria are read from the requirements-documents pack at review time, never recalled. Use when an ORD is ready for solution architecture, when /review-ord is run, or before handoff is declared.
---

# ORD Review

Assess whether an ORD clears **the bar** for handoff to solution architecture — a conformance review
against a published Definition of Ready, not open critique. The criteria live in the
requirements-documents pack; this skill locates them, applies them, and records verdicts. Reach for
`/critic` when the question is whether a document is *good*; reach for this one when it is *ready*.

Execution mode: **[AFK]** advisory — the review runs autonomously and produces a report; it changes
no document and declares no handoff. The one human gate is the standard's own: the convenor assesses
and the General Managers approve, and this skill supplies the assessment they act on.

**Why this exists.** §8 names *"a named independent reviewer on every ORD, who did not author it"* as
its highest-value Tier 1 control, and states that its absence causes **silent defect survival**.
Every pass over that pack to date has been its own author's. This skill is that control, mechanised.

---

## Step 1 — Read the criteria, never recall them

Source them per [GATE-PROTOCOL.md](../review-brd/GATE-PROTOCOL.md) § *Sourcing the criteria* — the
live pack's `reference/` where held, otherwise the stamped extract in [CRITERIA.md](CRITERIA.md),
which carries every file named below. Name the pack version in the report.

Read in full: **§7.1** (the bar OH-1 – OH-7, the supporting items OH-8 – OH-15, the four outcomes,
and *What the ORD does not supply*), **§7.3**, **§5** with its tier rule, **§5.2** on KPPs, and
**§2.1**. Read `reference/example-ORD.md` as the **worked reference implementation**.

Three desk references answer specific questions — read each when its question arises:
`requirement-to-section-map.md` (is this requirement in the right place),
`nine-characteristics-quickref.md` (the ISO/IEC 25010 set), `kpp-identification-guide.md` (is this
genuinely a KPP).

**Completion:** the standard and the ORD under review are both read end to end, and the fifteen
item definitions are in hand as written rather than as remembered.

## Step 2 — Verdict every item, with evidence

Apply the verdict vocabulary and the evidence rule in
[GATE-PROTOCOL.md](../review-brd/GATE-PROTOCOL.md) to each of OH-1 – OH-15.

ORD-specific criteria to apply while doing so, each defined in the standard rather than here:

- **OH-1** — all nine ISO/IEC 25010 characteristics present, each carrying a §5 status. A
  characteristic with nothing to state carries an **explicit statement**; an omission fails this
  item rather than passing it quietly.
- **OH-4 and §2.1** — operational demand stated as **business tolerance**. A technical target — an
  availability percentage, a latency figure, an RTO/RPO value, a capacity number — is an antipattern
  **regardless of how well it traces**: it pre-empts the review the document exists to inform.
- **OH-5 and §5.2** — KPPs carry **threshold and objective as two labelled values**, at every
  altitude. A single collapsed figure is the failure this item exists to catch.
- **OH-12** — a proposed acceptance criterion carries **inline provenance** (§6.2): the requirement's
  `Ver`, its status, its owner and its confirm-by date travel with the criterion. A criterion
  supplied without them fails the item — the provenance is the whole point of supplying it.
- **OH-13** — its absence is **normal today**, recorded rather than treated as an authoring failure;
  the standard lists it as a Tier 1 control to be established.
- **OH-14** — each operational objective carries a **baseline**, a target and a target date. A
  target with no baseline is the failure this item catches: improvement cannot be demonstrated from
  a starting position nobody recorded. A baseline marked `[TBD]` **with a named owner and a date**
  is a declared gap and is met for this item; an invented baseline is worse than either.
- **OH-15** — a *determination, measurement or eligibility* requirement carries the **adverse
  outcome** as well as the favourable one. Check the substance, not the label: the question is
  whether the document states what is true when the capability runs correctly and returns an
  unwelcome answer. A catalogue covering only some requirements is met where the remainder are
  **declared** as a gap with an owner and a date, and failed where partial coverage is presented as
  coverage.
- **Business rules present in the ORD** — assess the **declaration**, not the presence. §7.1
  *What the ORD does not supply* permits a carried rule register where the carry is declared as a
  deviation. Undeclared functional content fails; declared content passes and is recorded as
  evidence that the chain lacks a functional requirements document. Data entities and functional
  acceptance criteria are not covered by that permission and stay referred.

**Completion:** all fifteen carry a verdict, and every verdict cites the section or requirement ID
it was read from, or names precisely what is absent.

## Step 3 — Scan §7.3 for defects, and check the tier

**§7.3 content present in the ORD is a defect, not a gap.** Gaps drive the maturity tier; defects
are content that does not belong in the document at all, and the two are reported separately.
Scan all seven — solution design, Epic or story decomposition, technical targets, interface and data
mapping, estimates and sequencing, written Epics, and sole acceptance of delivered work.

**Also scan the assumption register for a competing methodology filed as an assumption** (§5). Two
defensible ways to count the same thing is a decision with an owner, not something believed true
pending confirmation. Filed as an assumption it has no owner and a side has been picked by omission
— report it as a defect, and name the requirements and reported outcomes it reaches.

Then check the declared tier against **§5's tier rule**: the tier is the **weakest status carried by
any KPP-bearing requirement** — the KPPs and the recovery, availability and capacity demands they
depend on. Not the average, and not the weakest status anywhere. A minor attribute at Assumed does
not set the tier; a KPP at Assumed does.

**Completion:** each of the seven §7.3 items is reported present-as-a-defect or absent, and the
declared tier is confirmed against the actual KPP statuses or the disagreement is named.

## Step 4 — Derive the outcome, run the five checks, report

Derive one of the four outcomes mechanically by the precedence rule in
[GATE-PROTOCOL.md](../review-brd/GATE-PROTOCOL.md), apply the **five checks** from
`reference/traceability-matrix.md`, and emit the protocol's report format with a **Defects (§7.3)**
section added above the five checks. Where the outcome is *Not ready for handoff*, apply the
protocol's refusal-and-authority handling first.

**Completion:** the outcome is stated with the verdicts that forced it, defects are listed separately
from gaps, and each of the five checks is answered or explicitly marked not-yet-answerable.

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| Neither the live pack nor `CRITERIA.md` is readable | Stop, per [GATE-PROTOCOL.md](../review-brd/GATE-PROTOCOL.md) § *Sourcing the criteria*. Never substitute recollection — a gate applied from memory drifts from the published one silently, and the drift is invisible in the output |
| `CRITERIA.md` carries the ⚠️ **dirty working tree** warning in its provenance line | The extract was generated from uncommitted pack state, corresponds to no committed version, and cannot be reproduced. Prefer the live pack and say the extract was bypassed; where it is the only source, run the review and record in *Assessed against* that the bar itself is unreproducible |
| The live pack and `CRITERIA.md` disagree | The pack wins and the extract is stale — say so in the report and regenerate with `tools/build-review-criteria.py`. Never prefer the extract because it is closer to hand |
| The pack defines an item this skill does not name — an OH-16, or a renumbered §7.1 | Verdict every item the pack defines, and report the ones this skill does not name. The skill is the defect, not the document: where the standard and this skill disagree, the standard wins |
| The reviewer authored the ORD | Run the review and record the non-independence in the *Reviewer* line. §8 names a reviewer *"who did not author it"* as its highest-value Tier 1 control and its absence as the cause of silent defect survival — an unmarked self-review is exactly the condition the record exists to make countable |
| A BRD, PRD or SOAP is submitted to this gate | Stop and name the mismatch. OH-1 – OH-15 are the ORD's bar; applying them to a document written to a different one produces verdicts against a bar it was never authored to |
| The ORD names a pack version other than the one being applied | Name both in the report. A verdict is meaningful only against a named bar, and an ORD authored to one revision assessed against another is a finding about the pair, not about the document |
| The ORD carries no KPP-bearing requirement | §5's tier rule has no input. Report the declared tier as underivable and name the absence — never accept a declared tier by default, and never substitute the weakest status anywhere in the register, which is the substitution the rule exists to refuse |
| A §7.3 item is present **and** the demand it displaced is absent | Report the defect under *Defects (§7.3)* and the absence under its own item's verdict. A §7.3 item is never a gap; folding it into the tier hides it |
| A characteristic is missing from §3 with no explicit statement | OH-1 fails — an omission fails the item rather than passing it quietly. Never read a §3.10 Coverage Gaps row as that explicit statement: the gap table collapses **sub**-characteristics, and all nine characteristics appear regardless |
| `reference/example-ORD.md` is unavailable from both sources | Run the review and say so. The worked reference is the calibration for what a conforming register looks like — without it the verdicts stand, but the reviewer's sense of the bar does not |
| One of the three desk references is unavailable | Answer its question from the standard itself and record which reference was missing. Never leave the question unanswered because its shortcut was absent |
| A check from `reference/traceability-matrix.md` cannot be answered at this hop | Mark it *not answerable at this hop* with the reason. A check reported clean because it could not be run is worse than one reported unanswerable |
| The outcome is the refusal | Apply [GATE-PROTOCOL.md](../review-brd/GATE-PROTOCOL.md) § *Refusal and authority* before emitting. The right to declare an ORD not-ready and refuse handoff is not currently held, so the refusal is recorded rather than exercised — and the accumulation of those records is the argument for establishing the control |

---

## Rules

- **Never restate a criterion in this skill's own prose.** The pack is the source of truth, and
  `CRITERIA.md` is a generated extract of it — never a second copy to hand-edit.
- **Never emit a score or a percentage** — fifteen verdicts and one of four outcomes.
- **Never report a §7.3 item as a gap.** It is a defect, and folding it into the tier hides it.
- Report an assessment; approval is the General Managers'. This skill declares.
- Where the standard and this skill disagree, the standard wins — and say so in the report.
