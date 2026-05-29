---
name: write-adr
category: code-quality
description: Create a structured Architecture Decision Record for a significant hard-to-reverse design decision. Use when user runs /write-adr, a major architectural choice is being made, or a decision needs to be formally documented.
---

# Write ADR

Create a new Architecture Decision Record in `docs/adr/`. Only create ADRs for decisions that are hard to reverse, surprising without context, and involve a real trade-off between alternatives.

## When to Create an ADR

Create one when ALL THREE are true:
1. **Hard to reverse** — changing this later has meaningful cost
2. **Surprising without context** — a future reader would wonder "why?"
3. **A real trade-off** — there were genuine alternatives and one was chosen for specific reasons

Do NOT create ADRs for routine implementation choices.

## Process

1. Check `docs/adr/` for existing ADRs — determine the next number.
2. Ask the user if needed: what was decided, what alternatives were considered, why this one was chosen.
3. Write the ADR using the template below.
4. Save to `docs/adr/NNNN-[slug].md` (e.g. `0003-silent-device-id.md`).
5. Note the ADR filename in the current session's DEVLOG entry under "Decisions Made."

## ADR Template

```markdown
# ADR-NNNN: [Title]

**Date:** YYYY-MM-DD
**Status:** Active

## Context
Why this decision was needed. What problem or situation prompted it.

## Options Considered

1. **[Option A]** — [brief description, pros/cons]
2. **[Option B]** — [brief description, pros/cons]
3. **[Option C]** — [brief description, pros/cons]

## Decision
What was chosen.

## Reason
Why this option over the others.

## Consequences
What this means going forward. What becomes easier or harder as a result.
```

## Rules

- Never delete an ADR — mark superseded ones with `**Status:** Superseded by ADR-NNNN`.
- Keep the title short and specific — it will be referenced from DEVLOG and kanban tickets.
- The Consequences section is mandatory — it forces honest thinking about trade-offs.
- Reference relevant research files or prototype notes if they informed the decision.
