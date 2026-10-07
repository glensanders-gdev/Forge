---
name: review-language
category: pipeline
description: Check the wording of a requirements document — BRD, PRD, ORD or AC — against the requirements language standard, including the modal and construction bans and the rules adopted from the Australian Government Style Manual. Returns every finding graded Defect or Advisory, with its location, the rule it breaks and a suggested rewrite. Use when /review-language is run, before a requirements document is shared or handed off, or as the advisory language pass inside /review-ord and /review-brd.
---

# Language Review

Check how a requirements document is **worded**. This is a conformance check against one published
standard. It reports findings with a suggested rewrite and changes nothing in the document.

Execution mode: **[AFK]** advisory — the check runs through and produces a report.

Three checks answer three different questions, and a document can pass any one and fail the others.
`/review-ord` and `/review-brd` ask whether a document is *ready* for handoff. `/check-style` asks
whether it meets the company's house style. This skill asks whether every statement is *worded* to
the requirements standard.

**Authoring standards** — `language.md` defines every rule this
skill applies. `tables.md` § *Reference list* defines what a
citation resolves to. Read both at review time. Never restate a rule here, and never check from
memory.

Each standard named above is a part of `STANDARDS.md`, beside this file — a citation such as
`tables.md` means the part of that document carrying that name, not a separate file to find.

**If an authoring standard above cannot be read, stop and name it.** A language check run from
memory applies a remembered rule set, which drifts from the published one silently, and the report
looks just as authoritative either way. An unreadable standard is a blocked run, never a degraded
one.

---

## Step 1 — Read the standard and set the locale

Read `language.md` end to end, including both *Recorded Deviations* sections, and `tables.md`
§ *Reference list*.

Then set the locale per `language.md` § *Locale Conventions*: read
`~/.claude/knowledge/company/style-guide.md` where it exists. Only its `Locale` section matters to
this skill — every other house-style rule is `/check-style`'s.

**Completion:** the standard is read as written, and the active locale is named — Australian
default, or the company `Locale` section that replaced it.

## Step 2 — Classify the text before checking it

The standard applies differently to different kinds of text, and checking a statement against the
wrong class is the main source of false findings. Give every section of the document one class:

| Class | What applies |
|---|---|
| Requirement, criterion, register cell or other commitment | The whole of `language.md` |
| Narrative section — background, mission, scenarios | All of it except the criterion form, per § *Narrative Sections* |
| Verbatim quotation, including `[TBD — source: "…"]` | Only the *Quote exactly* rule in § *Citing Sources* |
| Controlled vocabulary and fixed labels | Exempt as § *Recorded Deviations from the Australian Government Style Manual* sets |

**Completion:** every section carries a class, and every quotation and fixed label is marked so no
finding lands on it.

## Step 3 — Check every statement, and grade each finding

Apply every rule to every statement its class covers. Work section by section through the whole
document — never sample.

Grade by the strength the standard itself gives the rule:

- **Advisory** — a preference or an aim: `shall` (permitted but avoided), a swap from the
  *Everyday words* table, *Verbs over hidden verbs*, *Cut unnecessary words*, the 15-word sentence
  average, and the reading-level aim.
- **Defect** — every other rule. Anything in § *Never* is always a Defect.

A statement that follows a recorded deviation is **not a finding**. Read both deviation sections
before flagging a passive criterion, a title-case label or a `yyyy-mm-dd` date.

Each finding carries its location (section, and row ID where there is one), the `language.md`
section it breaks, the offending text quoted briefly, and a suggested rewrite. **A rewrite never
invents a value.** Where the fix needs a figure the document does not hold, the rewrite is
`[TBD — source: "…"]` per § *Vagueness*.

**Completion:** every classified section has been checked, and every finding carries a grade,
location, rule, quote and rewrite.

## Step 4 — Report

```markdown
## Language Review — [document ID and title]

**Checked against:** `language.md` · **Locale:** [Australian default | company Locale section] · **Document:** [BRD | PRD | ORD | AC]

### Summary

| `language.md` section | Defects | Advisory |
|---|---|---|

### Defects

| # | Location | Rule | Text | Suggested rewrite |
|---|---|---|---|---|

### Advisory

[The same table. Group repeats of one rule into a single row listing every location.]

### Not checked

[Sections exempted in Step 2, and why. Any standard the document cites that this check does not reach.]
```

**One row per statement.** A statement that breaks several rules gets one row, naming every rule
in the *Rule* cell, with one rewrite that fixes them all. The Summary still counts each rule. Every
statement with a Defect gets its own row. There is no score, percentage or pass mark.

*Not checked* names exempt text and standards out of reach. It never carries findings against
another standard, such as a register schema or a missing section. Those belong to the gate review.

**Completion:** the report is emitted, and every Defect found in Step 3 appears in it.

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| `language.md` cannot be read | Stop and name it. Never check from memory |
| The document is not a requirements document — an article, a skill file, a slide | Stop and name the mismatch, and point to `/check-style`. Skill instruction prose is outside the standard's scope by design |
| The company `Locale` section is partial | Report it once, above the findings, as a finding about the style guide rather than the document. Check against the Australian defaults, per § *Locale Conventions* |
| A company style-guide rule is stricter than `language.md` | Not this check's to apply. Name `/check-style` under *Not checked* |
| A passive criterion is about to be flagged | Check it against both deviation sections first. Where the actor is load-bearing (authorisation, audit, non-repudiation, security), the passive is a Defect. Elsewhere it is no finding |
| A finding also falls under a gate item, such as a technical target under OH-4 | Report it here and name the gate item. The gate's verdict belongs to the gate review |
| Run inside `/review-ord` or `/review-brd` | The report becomes that review's *Language (advisory)* section. It never changes a verdict or the outcome |
| The document is too large for one pass | Check it in sections, and name each section in the finding's location. Never sample |

## Rules

- Never edit the document. Report findings and rewrites only.
- Never restate a rule in this skill or in the report. Cite the `language.md` section by name.
- Never flag a statement that follows a recorded deviation.
- Never invent a value in a suggested rewrite.
- Never emit a score, a percentage or a pass/fail gate.
- Never apply the standard to a skill's own instruction prose.
