---
name: "prototype"
description: "Hash out ideas in code to get early feedback before committing to a full implementation. Use when design is uncertain and early code validation would reduce risk before writing the PRD."
metadata:
  category: pipeline
  version: 1.0.0
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Prototype

Spike ideas in code under the `$prototype` folder to get early feedback. Prototype code is throwaway — it informs the PRD and is cleaned up when `$write-prd` completes.

## When to Use

Use the Prototype stage when:
- The design involves an unfamiliar integration or architecture pattern
- UI/UX needs to be seen before it can be properly specified
- A technical approach is uncertain and a quick spike would resolve it faster than discussion

Skip Prototype if the approach is already well understood from Research or prior experience.

## Rules

- All prototype code lives in `$prototype`. Never in `src/`.
- Prototype code is explicitly **not production quality** — no need for tests, error handling, or polish.
- Nothing carries over silently from `$prototype` to `src/`. Any promoted code must be explicitly moved during Implementation.
- The `$prototype` folder is cleaned up (deleted) as part of the `$write-prd` completion step.

## Structure

```
$prototype
  LOGIC.md       ← notes on logic decisions explored in the spike
  UI.md          ← notes on UI/UX patterns explored in the spike
  [spike files]  ← actual throwaway code
```

## LOGIC.md Format

```markdown
# Prototype Logic Notes

## What We Tried
...

## What Worked
...

## What Didn't Work
...

## Recommendation for Implementation
...
```

## UI.md Format

```markdown
# Prototype UI Notes

## Patterns Explored
...

## User Feedback / Observations
...

## Recommendation for Implementation
...
```

## Process

1. Create `$prototype` if it doesn't exist.
2. Write spike code freely — speed over quality.
3. Document findings in `LOGIC.md` and/or `UI.md`.
4. Present findings to the human and get feedback.
5. Summarize what should carry forward into the PRD.

## After Prototype is Complete

Suggest moving to `$write-prd`. The prototype findings should be referenced in the PRD's Implementation Decisions section.

Wait for human confirmation before proceeding. Clean up `$prototype` only after PRD is written and confirmed.
