---
name: roap
category: company
standalone: false
description: Grill a hiring manager into a complete Role on a Page — title, team, reports to, purpose, accountabilities, success measures, activities with % allocation, development focus, and key relationships — then write it to docs/roles/[role-slug]-roap.md. Use when a new role is being designed, an existing role needs documenting, or user runs /roap.
---

# ROAP — Role on a Page

One role, one page. **The page is the constraint**: an accountability, measure, or activity that cannot earn its space on the page is not core to the role, and saying so out loud is the point of the exercise.

Fully HITL. The human supplies every answer; this skill supplies the pressure.

---

## Usage

```
/roap                              ← start from scratch
/roap "Senior Business Analyst"    ← start with the role title stated
```

---

## Phase 1 [HITL] — Set the branch

1. Ask which branch applies:
   - **design** — the role does not exist yet; answers are intent
   - **document** — someone does this job today; answers are evidence
2. Ask what already exists to read first — position description, job ad, org chart, prior ROAP, capability framework. Read anything offered. It is raw material to confirm question by question, never a substitute for an answer.
3. Restate the branch and the inputs in one line and get a yes before grilling.

---

## Phase 2 [HITL] — Grill

Read `GRILL.md` in this skill directory and ask its nine questions **in order, one at a time**. Wait for a full answer before moving on.

Each question carries a form requirement and a probe. When an answer misses the form — a task offered as an accountability, a measure with no metric, allocation that overruns 100% — probe once, showing the specific gap. If the second answer still misses, record what was given and flag it in the draft rather than arguing a third time.

**Completion criterion:** all nine sections hold a human-confirmed answer that meets its cap and form in `FORMATS.md` — allocation totals exactly 100%, every success measure carries a metric or named evidence, and every accountability is an outcome owned rather than a task performed. Anything short of that is not done.

---

## Phase 3 [AFK] — Draft to the page

Assemble the answers into the template in `FORMATS.md`.

**Page-fit check** before presenting — Role Purpose ≤ 60 words, each accountability ≤ 25 words, whole document ≤ 600 words, every section within its cap. Over budget means cutting content with the human in Phase 4, not shrinking the page.

---

## Phase 4 [HITL] — Review

Present the full draft, then:

```
Does this ROAP represent the role? (approve / edit / cancel)
```

- **edit** — ask which section, apply, re-present the whole page.
- **cancel** — exit without writing.

---

## Phase 5 [AFK] — Write

Write to `docs/roles/[role-slug]-roap.md`, creating `docs/roles/` if absent. Slug is the role title, lowercased and hyphenated. Confirm the path and offer `/check-style` against the company style guide.

---

## Rules

- Ask one question at a time and wait — a batch of nine questions returns nine thin answers.
- Accountabilities are outcomes the role owns; activities are how time is spent. Route every answer to the right one.
- Success measures follow `~/.claude/rules/requirements/language.md` — declarative present, no modals, no "the system".
- Development focus areas describe the growth edge of the **role**, not the shortcomings of a person.
- A ROAP describes a position. The reporting line and every relationship is a position title.
- Never name an individual, and never record performance history, salary, or any other personal data on the page.
- Never write the file before Phase 4 approval.
- Never invent a percentage, metric, accountability, or relationship the human has not stated.
- Never finish with allocation totalling anything other than 100%.

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| Answers describe a person, not a role | "Set aside who does it today — if they left tomorrow, what would the next person own?" |
| Accountabilities list tasks | Move them to Q7 Activities and re-ask: "What outcome do those tasks add up to?" |
| More than 6 accountabilities offered | Ask which are core: "Which of these survive if the role loses a day a week?" Record the cut ones under Comments, not on the page. |
| Allocation exceeds 100% | Show the running total and the overrun, then ask which activity gives up the difference |
| Allocation under 100% at the end | Ask what fills the gap — unnamed time is usually the most interesting answer |
| Success measure is an adjective ("effective stakeholder management") | Probe for the metric or observable evidence; if none exists, record `[TBD — source: "quoted answer"]` |
| Human cannot answer a section | Record `[TBD]` on the page and continue — a visible gap beats an invented answer |
| Design branch, no comparable role exists | Ask what breaks today without the role; the answer usually is the purpose |
| Existing PD contradicts the human's answer | Surface both, ask which is current, record the answer given |
| `docs/roles/` cannot be created | Output the page inline and say it was not written |
