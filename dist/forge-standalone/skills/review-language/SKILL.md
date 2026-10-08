---
name: review-language
category: pipeline
description: Check the wording of a requirements document — BRD, PRD, ORD or AC — against the requirements language standard, including the modal and construction bans and the rules adopted from the Australian Government Style Manual. With --skill, checks only the templates and worked examples inside a requirements skill, never its instruction prose. Returns every finding graded Defect or Advisory, with its location, the rule it breaks and a suggested rewrite. Use when /review-language is run, before a requirements document is shared or handed off, as the advisory language pass inside /review-ord and /review-brd, or after language.md changes to find skill templates that teach an outdated form.
---

# Language Review

Check how a requirements document is **worded**. This is a conformance check against one published
standard. It reports findings with a suggested rewrite and changes nothing in the document.

Execution mode: **[AFK]** advisory — the check runs through and produces a report.

Three checks answer three different questions, and a document can pass any one and fail the others.
`/review-ord` and `/review-brd` ask whether a document is *ready* for handoff. `/check-style` asks
whether it meets the company's house style. This skill asks whether every statement is *worded* to
the requirements standard.

## Usage

```
/review-language <document>        ← a BRD, PRD, ORD or AC, by path or in the conversation
/review-language --skill <name>    ← the templates and worked examples inside one skill
```

**Skill mode** exists because templates drift. A skill that writes requirements documents carries
templates, placeholder text and worked examples, and every document it produces copies their form.
When `language.md` changes, those examples keep teaching the old form, and nothing else flags them.
`README.md` § *Scope boundary* brings exactly that text into scope ("examples teach the form") and
leaves the skill's instructions out. Skill mode follows that line and nothing more.

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

**In skill mode, skip the company `Locale` section** and check against the Australian defaults. A
skill is shared across companies, so its templates are written to the published defaults, and a
company locale applied to them would report the company's choice as the skill's defect.

**Completion:** the standard is read as written, and the active locale is named — Australian
default, or the company `Locale` section that replaced it.

## Step 1a — Collect the skill's text (skill mode only)

Read the skill's folder: `SKILL.md` and every file beside it, such as a `TEMPLATE.md`,
`REFERENCE.md` or `TAXONOMY.md`. Skip `scripts/` and any generated extract the skill names as built
from elsewhere — check that text at its source.

**Completion:** every file in the folder is read or named as skipped, with the reason.

## Step 2 — Classify the text before checking it

The standard applies differently to different kinds of text, and checking a statement against the
wrong class is the main source of false findings. Give every section of the document one class:

| Class | What applies |
|---|---|
| Requirement, criterion, register cell or other commitment | The whole of `language.md` |
| Narrative section — background, mission, scenarios | All of it except the criterion form, per § *Narrative Sections* |
| Verbatim quotation, including `[TBD — source: "…"]` | Only the *Quote exactly* rule in § *Citing Sources* |
| Controlled vocabulary and fixed labels | Exempt as § *Recorded Deviations from the Australian Government Style Manual* sets |
| Template, placeholder text or worked example inside a skill | Whatever its own class would be once it is in a document — a requirement row in a template is a requirement |
| Counter-example — text a skill or standard shows as what *not* to write, such as an *Instead of* column or a quoted banned phrase | Exempt. It breaks the rule on purpose |
| A skill's instructions to Claude, its rules and its failure-mode table | Exempt, per `README.md` § *Scope boundary* |
| A template for the skill's own conversational output — a selection summary, a confirmation prompt, a proposed change set | Exempt. It never reaches a requirements document |

In skill mode most of the text is exempt. Classify by what the text *does*, not where it sits. The
test is whether the text lands in a requirements document the skill writes. A worked example
inside a step is governed. A line inside a document template that is addressed to Claude, such as
"flag it" or "an AC with no source is invalid", is an instruction. A line addressed to the
document's reader is governed.
A bracketed placeholder such as `[SYSTEM-NAME-TBD]` or `[TBD — source: "…"]` is the form the
standard prescribes and is never a finding. The words around it are checked.

A template cannot meet a rule that depends on the finished document, such as an acronym's Glossary
entry. Check the part the template controls, such as expansion on first use, and name the rest
under *Not checked*.

**Completion:** every section carries a class, and every quotation, fixed label, counter-example
and instruction is marked so no finding lands on it.

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

**Checked against:** `language.md` · **Locale:** [Australian default | company Locale section] · **Document:** [BRD | PRD | ORD | AC | Skill: name and version]

[In skill mode, take the version from `manifest.json` where one exists, and say so.]

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

In skill mode the *Location* cell names the file and the heading, and *Not checked* lists the
instruction sections by heading, in one line, rather than repeating the whole skill.

*Not checked* names exempt text and standards out of reach. It never carries findings against
another standard, such as a register schema or a missing section. Those belong to the gate review.

**Completion:** the report is emitted, and every Defect found in Step 3 appears in it.

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| `language.md` cannot be read | Stop and name it. Never check from memory |
| The document is not a requirements document — an article, a slide | Stop and name the mismatch, and point to `/check-style` |
| A `SKILL.md` is passed as the document | Run in skill mode, and say so above the findings |
| `--skill <name>` names no folder that can be read | Stop and name the path tried. Never fall back to a remembered copy of the skill |
| The skill holds no template or worked example of requirements content | Report "No governed text", with every section under *Not checked*. Never report it as passing, and never check its instructions instead |
| An instruction and an example share one sentence or block | Check the quoted example only. If the two cannot be separated, name the text under *Not checked* rather than flagging the instruction |
| A template line breaks a `language.md` rule that the skill's own instructions require | Report it, and name the instruction in the finding. The conflict is the skill's to resolve, and the fix may belong in the instruction or in `language.md`. A template that breaks a non-language instruction, such as a missing field, is not this check's finding |
| The company `Locale` section is partial | Report it once, above the findings, as a finding about the style guide rather than the document. Check against the Australian defaults, per § *Locale Conventions* |
| A company style-guide rule is stricter than `language.md` | Not this check's to apply. Name `/check-style` under *Not checked* |
| A passive criterion is about to be flagged | Check it against both deviation sections first. Where the actor is load-bearing (authorisation, audit, non-repudiation, security), the passive is a Defect. Elsewhere it is no finding |
| A finding also falls under a gate item, such as a technical target under OH-4 | Report it here and name the gate item. The gate's verdict belongs to the gate review |
| Run inside `/review-ord` or `/review-brd` | The report becomes that review's *Language (advisory)* section. It never changes a verdict or the outcome |
| The document is too large for one pass | Check it in sections, and name each section in the finding's location. Never sample |

## Rules

- Never edit the document or the skill. Report findings and rewrites only.
- Never restate a rule in this skill or in the report. Cite the `language.md` section by name.
- Never flag a statement that follows a recorded deviation.
- Never invent a value in a suggested rewrite.
- Never emit a score, a percentage or a pass/fail gate.
- Never apply the standard to a skill's own instruction prose. In skill mode, check only its
  templates, placeholder text and worked examples.
- Never flag a counter-example. Text shown as what not to write breaks the rule on purpose.
