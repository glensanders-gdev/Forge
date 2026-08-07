---
name: "ord-review"
description: "Assess a submitted ORD against the published §7.1 handoff gate — OH-1 to OH-13, the four outcomes, the §7.3 refuse-to-produce scan and the §5 tier rule — returning a per-item verdict table with evidence and a mechanically derived outcome. Criteria are read from the requirements-documents pack at review time, never recalled. Use when an ORD is ready for solution architecture, when $ord-review is run, or before handoff is declared."
metadata:
  category: pipeline
  version: 1.0.0
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# ORD Review

Assess whether an ORD clears **the bar** for handoff to solution architecture — a conformance review
against a published Definition of Ready, not open critique. The criteria live in the
requirements-documents pack; this skill locates them, applies them, and records verdicts. Reach for
`$critic` when the question is whether a document is *good*; reach for this one when it is *ready*.

Execution mode: **[AFK]** advisory — the review runs autonomously and produces a report; it changes
no document and declares no handoff. The one human gate is the standard's own: the convenor assesses
and the General Managers approve, and this skill supplies the assessment they act on.

**Why this exists.** §8 names *"a named independent reviewer on every ORD, who did not author it"* as
its highest-value Tier 1 control, and states that its absence causes **silent defect survival**.
Every pass over that pack to date has been its own author's. This skill is that control, mechanised.

---

## Step 1 — Read the standard, never recall it

Resolve `reference/ord-intake-standard.md` in the requirements-documents pack, in order:

1. `$FORGE_REQ_PACK/reference/ord-intake-standard.md`
2. `requirements-documents/reference/ord-intake-standard.md`, searching up from the working directory
3. `~/Documents/Forge/requirements-documents/reference/ord-intake-standard.md`

**Where none resolves, stop and ask for the path.** A gate applied from recollection drifts from the
published one silently, and the drift is invisible in the output.

Read in full: **§7.1** (the bar OH-1 – OH-7, the supporting items OH-8 – OH-13, the four outcomes,
and *What the ORD does not supply*), **§7.3**, **§5** with its tier rule, **§5.2** on KPPs, and
**§2.1**. Read `reference/example-ORD.md` as the **worked reference implementation**.

Three desk references answer specific questions — read each when its question arises:
`requirement-to-section-map.md` (is this requirement in the right place),
`nine-characteristics-quickref.md` (the ISO/IEC 25010 set), `kpp-identification-guide.md` (is this
genuinely a KPP).

**Completion:** the standard and the ORD under review are both read end to end, and the thirteen
item definitions are in hand as written rather than as remembered.

## Step 2 — Verdict every item, with evidence

Apply the verdict vocabulary and the evidence rule in
[GATE-PROTOCOL.md](../brd-review/GATE-PROTOCOL.md) to each of OH-1 – OH-13.

ORD-specific criteria to apply while doing so, each defined in the standard rather than here:

- **OH-1** — all nine ISO/IEC 25010 characteristics present, each carrying a §5 status. A
  characteristic with nothing to state carries an **explicit statement**; an omission fails this
  item rather than passing it quietly.
- **OH-4 and §2.1** — operational demand stated as **business tolerance**. A technical target — an
  availability percentage, a latency figure, an RTO/RPO value, a capacity number — is an antipattern
  **regardless of how well it traces**: it pre-empts the review the document exists to inform.
- **OH-5 and §5.2** — KPPs carry **threshold and objective as two labelled values**, at every
  altitude. A single collapsed figure is the failure this item exists to catch.
- **OH-13** — its absence is **normal today**, recorded rather than treated as an authoring failure;
  the standard lists it as a Tier 1 control to be established.

**Completion:** all thirteen carry a verdict, and every verdict cites the section or requirement ID
it was read from, or names precisely what is absent.

## Step 3 — Scan §7.3 for defects, and check the tier

**§7.3 content present in the ORD is a defect, not a gap.** Gaps drive the maturity tier; defects
are content that does not belong in the document at all, and the two are reported separately.
Scan all seven — solution design, Epic or story decomposition, technical targets, interface and data
mapping, estimates and sequencing, written Epics, and sole acceptance of delivered work.

Then check the declared tier against **§5's tier rule**: the tier is the **weakest status carried by
any KPP-bearing requirement** — the KPPs and the recovery, availability and capacity demands they
depend on. Not the average, and not the weakest status anywhere. A minor attribute at Assumed does
not set the tier; a KPP at Assumed does.

**Completion:** each of the seven §7.3 items is reported present-as-a-defect or absent, and the
declared tier is confirmed against the actual KPP statuses or the disagreement is named.

## Step 4 — Derive the outcome, run the five checks, report

Derive one of the four outcomes mechanically by the precedence rule in
[GATE-PROTOCOL.md](../brd-review/GATE-PROTOCOL.md), apply the **five checks** from
`reference/traceability-matrix.md`, and emit the protocol's report format with a **Defects (§7.3)**
section added above the five checks. Where the outcome is *Not ready for handoff*, apply the
protocol's refusal-and-authority handling first.

**Completion:** the outcome is stated with the verdicts that forced it, defects are listed separately
from gaps, and each of the five checks is answered or explicitly marked not-yet-answerable.

---

## Rules

- **Never restate a criterion inside this skill.** The pack is the source of truth.
- **Never review from memory of the gate.** Where the standard is unreadable, stop.
- **Never emit a score or a percentage** — thirteen verdicts and one of four outcomes.
- **Never report a §7.3 item as a gap.** It is a defect, and folding it into the tier hides it.
- Report an assessment; approval is the General Managers'. This skill declares.
- Where the standard and this skill disagree, the standard wins — and say so in the report.
