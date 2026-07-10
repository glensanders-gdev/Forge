---
name: "prototype"
description: "Spike throwaway code to answer a specific design question before writing the PRD. Pick a branch first — a logic/state question builds an interactive Logic Prototype (see logic-prototype.md); a visual/UX question builds structurally different UI variants behind a switcher (see ui-prototype.md). Findings feed $write-prd; the spike is preserved on a throwaway branch, then cleaned from the working tree. Use when a design question is cheaper to answer in code than in discussion."
metadata:
  category: pipeline
  version: 2.0.0
  origin: Adapted from Matt Pocock (AIHero.dev / github.com/mattpocock/skills)
---

# Prototype

A prototype is **throwaway code built to answer one design question** — not a first draft of production. The question you are answering decides everything about the shape of the spike, so name it before you write a line of code.

Spike code lives under `$prototype`, informs the PRD, is preserved on a throwaway branch as primary-source evidence, and is then removed from the working tree when `$write-prd` completes.

> Adapted from Matt Pocock's `prototype` skill and its `LOGIC.md` and `UI.md` (github.com/mattpocock/skills). Forge keeps the question-first framing, the pick-a-branch decision, the Logic Prototype method (pure liftable logic module behind a throwaway interactive harness) and the UI Prototype method (structurally different variants behind a dev-only switcher); it keeps Forge's own `$prototype` folder convention, `LOGIC.md`/`UI.md` notes, and `$write-prd` handoff, and adds throwaway-branch preservation so the spike survives as recorded evidence (Principle 8) rather than being deleted outright.

## When to Use

Use the Prototype stage when a design question is genuinely open and code would settle it faster than discussion:
- A technical approach, integration, or architecture pattern is uncertain.
- A state machine, reducer, or data model needs scenarios pushed through it before its shape is trusted.
- A UI/UX pattern needs to be seen before it can be specified.

Skip Prototype if the approach is already well understood from `$research` or prior experience — go straight to `$write-prd`.

## Step 0 — Name the question

Before anything else, write the open question down in one sentence (it goes into `LOGIC.md` or `UI.md`). A spike with no stated question answers the wrong thing. Example: *"Does the booking state machine handle a cancellation that arrives after a reschedule request?"*

## Pick a Branch

The **shape** of the question decides the **shape** of the spike:

| The question is about… | Branch | Build |
|------------------------|--------|-------|
| **State / logic / data model** — "does this behave correctly", "what's the right API shape", "does this state machine handle X then Y" | **Logic Prototype** | A pure, liftable logic module behind an interactive throwaway harness — full method in [logic-prototype.md](logic-prototype.md). |
| **Visual / UX** — "what should this look like", "which layout reads better" | **UI Prototype** | Structurally different variants behind a dev-only switcher — full method in [ui-prototype.md](ui-prototype.md). |

If genuinely ambiguous: backend/logic-oriented code defaults to the Logic branch, frontend/visual code to the UI branch. If the question is really two questions, split it — one spike each, one stated question each.

## Rules That Apply to Both Branches

- All prototype code lives in `$prototype` — **never in `src/`**. Forge keeps the spike in one folder for clean separation and cleanup, rather than scattering it adjacent to target code.
- Prototype code is explicitly **not production quality** — no tests, minimal error handling, no abstractions built for reuse.
- **One command to run**, wired into the project's existing task runner (`pnpm run <name>`, `make <name>`, etc.) — no new bespoke tooling.
- **No persistence** — hold state in memory, unless persistence behaviour is itself the question.
- **Surface the state after every action** so the human can inspect what changed — inspection is the point.
- **Nothing carries over silently** from `$prototype` to `src/`. Any validated code is moved *explicitly* during Implementation.

## Structure

```
$prototype
  LOGIC.md       ← notes on the logic/state question and what the spike showed
  UI.md          ← notes on the UI/UX question and what the spike showed
  [spike files]  ← the actual throwaway code (Logic Prototype harness and/or UI variations)
```

> `$prototype/LOGIC.md` and `$prototype/UI.md` are **findings notes** for a specific feature's spike (templates below). The skill's own [logic-prototype.md](logic-prototype.md) and [ui-prototype.md](ui-prototype.md) are the **reusable methods** for building each kind of prototype — don't confuse the same-named files.

## LOGIC.md Format (findings note)

```markdown
# Prototype Logic Notes

## Question
[The one-sentence open question this spike answered]

## What We Tried
...

## What Worked
...

## What Didn't Work
...

## Recommendation for Implementation
[The distilled answer — this is what carries into the PRD]
```

## UI.md Format (findings note)

```markdown
# Prototype UI Notes

## Question
[The one-sentence open question this spike answered]

## Variants Explored
- **A** — [structural approach: layout / hierarchy / primary action]
- **B** — [structural approach]
- **C** — [structural approach]

## User Feedback / Observations
[Which read best, and any cross-variant combination — e.g. "B's header with C's sidebar"]

## Winning Variant + Rationale
[Which variant (or combination) won and why]

## Recommendation for Implementation
[The distilled answer — rebuild the winner under real constraints; this is what carries into the PRD]
```

## Process

1. Name the question (Step 0) and pick a branch (above).
2. Create `$prototype` if it doesn't exist.
3. Build the spike:
   - **Logic branch:** follow [logic-prototype.md](logic-prototype.md) — pure logic module behind a throwaway interactive harness.
   - **UI branch:** follow [ui-prototype.md](ui-prototype.md) — 3–5 structurally different variants behind a dev-only switcher, read-only.
4. Write spike code freely — speed over quality, but keep the logic module pure (Logic branch).
5. Wire a single run command into the project's task runner and hand it to the human to drive.
6. Document findings in `LOGIC.md` and/or `UI.md` — always fill the **Recommendation for Implementation**.
7. Present findings to the human. Iterate if new scenarios or variations are needed.
8. Summarise what carries forward into the PRD.

## After Prototype is Complete

Suggest moving to `$write-prd`. The prototype's **Recommendation for Implementation** feeds the PRD's Implementation Decisions section.

**Preservation (handled at `$write-prd` completion):** before `$prototype` is removed from the working tree, the spike is committed to a **throwaway branch** (`prototype/[feature-name]`) and a pointer to that branch is recorded in the PRD, so the exploration survives as primary-source evidence. The working tree is only cleaned after the PRD is written and confirmed. Never delete the spike without preserving it first.

Wait for human confirmation before proceeding.

## Rules

- Never write spike code in `src/` — all prototype code lives in `$prototype`.
- Never start coding before the question is written down — an unstated question produces the wrong spike.
- Never add tests to a prototype — a spike that needs tests is no longer a prototype.
- Never build for reuse or a future case — answer this one question, nothing more.
- Never let anything carry from `$prototype` to `src/` silently — promotion is always explicit, during Implementation.
- Never delete `$prototype` before it is preserved on its throwaway branch and the PRD is confirmed.
- Never wire a prototype to a real database unless persistence behaviour is the question.
- Never build UI variants that differ only in colour or copy — variants must differ structurally, stay read-only, and the switcher must be gated out of production (see [ui-prototype.md](ui-prototype.md)).

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| Approach already well understood | Skip Prototype — go straight to `$write-prd`. |
| Question not yet articulated | Stop — write the one-sentence question into `LOGIC.md`/`UI.md` before coding. |
| Ambiguous whether logic or UI | Default by code orientation (backend → Logic, frontend → UI); if it's two questions, split into two spikes. |
| Tempted to write spike code in `src/` | Stop — all prototype code lives in `$prototype`, never `src/`. |
| Spike code looks production-ready | It still doesn't carry over silently — any promoted code is moved explicitly during Implementation. |
| Adding tests/polish to spike code | Don't — a prototype that needs tests is no longer a prototype. |
| Logic and harness blurring together | Keep the logic module pure and liftable; the harness imports it, nothing flows back (see logic-prototype.md). |
| UI variants differ only in colour/copy | Not real choices — make each variant structurally distinct (layout, hierarchy, primary action), 3–5 max (see ui-prototype.md). |
| UI switcher could reach production | Gate it to dev/non-production; it exists only to drive the decision. |
| `$write-prd` not yet complete | Don't clean `$prototype` — preserve on branch and remove only after the PRD is written and confirmed. |
| Findings unclear after the spike | Present what was learned and the open question before recommending a next stage. |
