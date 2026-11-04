---
name: "review-brd-v2"
description: "Review a two-file BRD — the BRD from $write-brd-v2 and its -SR.md stakeholder requirements from $write-stakeholder. Works out which stage the work has reached, then checks what that stage allows. BRD only — is it ready for stakeholder requirements? Both files — are they consistent with each other, and ready together for ORD development? The second stage applies the BH-1 – BH-10 handoff gate, business definition readiness, acceptance derivability and the readiness projection, all read from the requirements pack via $review-brd's criteria and protocol. It does not penalise v2's lean layout as defects. Advisory: per-item verdicts with evidence and outcomes derived from them, never a score. Use when $review-brd-v2 is run, or a v2 BRD needs a readiness check before stakeholder requirements or before ORD work is assigned."
metadata:
  category: pipeline
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Review BRD v2

Assess a two-file BRD — `[change-name]-BRD.md` and `[change-name]-SR.md` — for readiness to proceed:
to stakeholder requirements when only the BRD exists, and to ORD development when both do.

Execution mode: **[AFK]** advisory — the review runs autonomously and produces a report. It changes
no document, raises no RAID entry and declares no sign-off. Acceptance belongs to the BRD's author
and the approving GMs.

**What this skill adds to `$review-brd`, and what it borrows.** The gate, the verdict vocabulary,
the evidence rule, the outcome derivation, business definition readiness, the projection and the
path to readiness are `$review-brd`'s, read from the same pack and applied by its steps. This skill
adds three things only: **stage detection**, the **v2 section map** that tells those steps where each
item lives across two files, and **cross-document consistency**. It restates no criterion.

| Source | Supplies |
|---|---|
| [GATE-PROTOCOL.md](../review-brd/GATE-PROTOCOL.md) | Sourcing, the four verdicts, evidence rule, outcome derivation, language pass, report format |
| [review-brd/SKILL.md](../review-brd/SKILL.md) | Steps 2 – 7 — gate verdicts, checks, business definition, derivability, projection, path |
| [CRITERIA.md](../review-brd/CRITERIA.md), or the live pack | BH-1 – BH-10, BD-1 – BD-10, the `[TBD]` rule, the four outcomes |
| [write-brd-v2/SKILL.md](../write-brd-v2/SKILL.md) § *Verification gate* | The BRD's own authoring checks |
| [write-stakeholder/SKILL.md](../write-stakeholder/SKILL.md) § *Verification gate* | The SR file's own authoring checks |

---

## Step 1 — Find the documents and name the stage

Locate the BRD — the path given, else `docs/brd/*-BRD.md`, asking which where there are several.
Then find its stakeholder file: the path its §8 points to, else a `docs/brd/*-SR.md` whose `brd`
field carries the BRD's `doc_id`.

| Stage | Found | The question this review answers |
|---|---|---|
| **0** | No BRD | None. Say so and offer `$write-brd-v2` |
| **1** | The BRD, and no SR file | Is the BRD ready for `$write-stakeholder`? |
| **2** | The BRD and a matching SR file | Are the two consistent, and together ready for ORD development? |

State the stage, both paths and both Doc IDs at the head of the report.

**Completion:** the stage is named, with the evidence that set it — the files found and the `brd`
match, or what was looked for and not found.

## Step 2 — Read the criteria, never recall them

Source them per [GATE-PROTOCOL.md](../review-brd/GATE-PROTOCOL.md) § *Sourcing the criteria*, and
read what [review-brd/SKILL.md](../review-brd/SKILL.md) Step 1 lists. Read both authoring skills'
verification gates. Read the BRD in full, and at Stage 2 the SR file in full. Name the pack version
in the report.

**Completion:** every criterion applied is in hand as written, and every document is read end to end.

## Step 3 — Check each document against its authoring gate

Run [write-brd-v2](../write-brd-v2/SKILL.md)'s verification gate over the BRD, and at Stage 2
[write-stakeholder](../write-stakeholder/SKILL.md)'s over the SR file. Report each line as
**Pass** or **Fail**, citing the section or row.

These are **conformance to the v2 forms**, not gate verdicts. A failure here is reported in its own
table and never changes a BH verdict by itself — where it also defeats a gate item, that item's
verdict carries it.

**Completion:** every line of each applicable verification gate carries Pass or Fail with a citation.

## Step 4 — Check the two documents agree (Stage 2 only)

| # | Check | Fails when |
|---|---|---|
| X-1 | **Same BRD** | The SR file's `brd` is not the BRD's `doc_id` |
| X-2 | **Current BRD** | The SR file's `brd_version` is older than the BRD's `Version` — name both, and list what changed where it can be seen |
| X-3 | **Objectives exist** | An SR §3.1 row cites a `BO-N` the BRD does not carry |
| X-4 | **Every objective traced** | A BRD `BO-N` has no SR §3.2 row |
| X-5 | **Stakeholders exist** | An SR §3.1 stakeholder is not a BRD §3.2 row |
| X-6 | **Inside scope** | A requirement covers an area in BRD §4.2, or one absent from §4.1 |
| X-7 | **No restatement** | A requirement restates a BRD objective, principle or constraint |
| X-8 | **Pointers resolve** | BRD §8 or §9 names a file or section that does not exist |

**Completion:** each check carries Pass or Fail with the rows that set it.

## Step 5 — Apply the gate, through the v2 section map

Apply [review-brd/SKILL.md](../review-brd/SKILL.md) Steps 2 and 3 — verdicts, outcome derivation,
checks and scans — reading each item from where v2 holds it:

| Item | Read from |
|---|---|
| BH-1, BH-2 | BRD §2.1 |
| BH-3 | BRD §5.2 constraints, §7 dependencies, and §6 where an assumption carries operational weight |
| BH-4 | BRD §2.2 |
| BH-5 | BRD §3.2 |
| BH-6 | BRD §3.1, counted against the units in §4.1 |
| BH-7 | BRD §4, and `Phase` in the front matter |
| BH-8 | BRD §4.1 `Owner` column. v2 carries no `Impact basis` — read every impact as *basis not recorded*, per `$review-brd`'s pre-v1.17 failure mode |
| BH-9 | SR §3.1 and §3.2 |
| BH-10 | SR §1 and §2 |

**At Stage 1** verdict BH-1 – BH-8 only. BH-9 and BH-10 are **not assessed** — the file that carries
them is the next step, not a gap — and no ORD outcome is derived. Derive the Stage 1 outcome instead:

| Outcome | Condition |
|---|---|
| **Ready for stakeholder requirements** | BH-1 – BH-4 are not *Absent* |
| **Not yet ready for stakeholder requirements** | Any of BH-1 – BH-4 is *Absent*. Stakeholder requirements traced to objectives that do not yet stand are written against nothing |

**At Stage 2** verdict all ten and derive the gate outcome by the protocol's precedence. An X-1 or X-3
failure makes BH-9 *Absent*: traceability to the wrong BRD, or to objectives it does not hold, traces
to nothing.

**Completion:** every item for the stage carries a verdict citing file and section, and the outcome
is stated with the verdicts that forced it.

## Step 6 — Business definition, derivability, projection and path (Stage 2 only)

Apply [review-brd/SKILL.md](../review-brd/SKILL.md) Steps 4 – 7 over both files. The SR file is where
most business logic lives — its requirements, versioned anchors and appendix tables — so BD-1 – BD-10
are read there first. An appendix table at *Working draft* authority is a rule declared but not yet
approved, and an anchor carrying `[TBD]` is a source not yet identified: treat both as `$review-brd`
treats an assumption-backed rule.

At Stage 1, say these are assessed once the SR file exists, and stop the step there.

**Completion:** as `$review-brd` Steps 4 – 7 define it, or the Stage 1 line.

## Step 7 — Run the language pass

Run [GATE-PROTOCOL.md](../review-brd/GATE-PROTOCOL.md) § *The language pass* over the BRD, and at
Stage 2 over the SR file. `write-stakeholder` bans more words than the language standard does — report
its extra bans under Step 3, not here.

**Completion:** a language report for each document, or the reason it could not run.

## Step 8 — Report

Emit the protocol's report format, with three additions above *Verdicts*:

```markdown
**Stage:** [0 / 1 / 2] — [the question answered]
**Documents:** [BRD path, Doc ID, Version] · [SR path, Doc ID, brd, brd_version — or "not yet written"]
**Profile:** v2 two-file BRD

### Authoring conformance
| Document | Check | Result | Evidence |
|---|---|---|---|

### Cross-document consistency — Stage 2
| # | Result | Evidence |
|---|---|---|
```

At Stage 1, the outcome block carries the Stage 1 outcome and names `$write-stakeholder` as the next
step. At Stage 2, it carries the gate outcome. Then ask whether to work through the findings.

---

## The v2 profile — what is not a finding

v2 is lean by design. Report these once, under *What this review does not cover*, and never as
defects:

- No Appendix A or Appendix B, no separate current-vs-future-state section, and no LLM companion.
- Executive summary labels differ from the pack's five.
- Stakeholder requirements carry `SR-[DOMAIN]-[PROCESS]-NNN` IDs in place of `BR-N`, and the
  stakeholder sits in traceability rather than in the requirement row.
- Stakeholder requirements and traceability live in a separate file.

Where one of these leaves a gate item unmet — BH-8 with no impact basis — the item's verdict says so.
The layout itself is not the finding.

---

## Failure Modes

| Condition | Behaviour |
|---|---|
| Neither the live pack nor `review-brd/CRITERIA.md` is readable | Stop, per the protocol. Never review from recollection |
| No BRD found | Stage 0. Offer `$write-brd-v2` and stop |
| Several BRDs in `docs/brd/` and none named | List them and ask which. Never pick the newest |
| Several SR files carry the same `brd` | Name them and ask which is current. Never merge them |
| An SR file exists whose `brd` matches no BRD | Report it as orphaned and review the BRD at Stage 1 |
| BRD §8 points to a file that does not exist | X-8 fails, the review runs at Stage 1, and the report says the pointer is broken |
| The SR file is older than the BRD | X-2 fails. Assess both as they stand, and recommend re-running `$write-stakeholder` before the gate outcome is relied on |
| The BRD was written by `$write-brd`, not `$write-brd-v2` | Say so and hand over to `$review-brd`. The v2 section map does not fit the pack's anatomy |
| An ORD, PRD or other document is submitted | Stop and name the mismatch |
| The reviewer authored either document | Run the review and record the non-independence in the *Reviewer* line |
| A Stage 1 review is asked for an ORD outcome | Decline it. BH-9 and BH-10 cannot be assessed until the SR file exists — offer `$write-stakeholder` |
| A requirement could be read two ways | Record the hidden decision and its owner, per `$review-brd`. Never choose the reading |

---

## Rules

- **Never restate a criterion.** BH, BD, the `[TBD]` rule and the outcomes are the pack's; the
  authoring checks are the two authoring skills'. Cite them.
- **Never emit a score or a percentage.** Verdicts per item, and named outcomes.
- **Never derive an ORD outcome at Stage 1.** The SR file is the next step, not a gap.
- **Never use a fifth verdict.** At Stage 1, BH-9 and BH-10 are *not assessed*, not given a verdict.
- **Never treat the v2 layout as a defect** — only an unmet item.
- **Never let an authoring-conformance or language finding change a gate verdict by itself.**
- **Never edit either document, raise a RAID entry, or resolve a business decision.** Recommend; the
  author and approving GMs decide.
- Where `$review-brd`, the protocol or the pack disagrees with this skill, they win — say so in the
  report, because the disagreement is a defect in this skill.
