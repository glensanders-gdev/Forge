---
name: grill-with-docs
version: 2.0.0
description: Planning phase grilling session that challenges a plan against the existing domain model, sharpens terminology, and updates CONTEXT.md and ADRs inline as decisions crystallise. The standard entry point for project planning in Forge. Use when stress-testing a plan against the project's language, codebase, and documented decisions.
---

# Grill With Docs

The planning phase entry point. Like `/grill-me` but domain-aware — challenges the plan against `docs/CONTEXT.md`, the codebase, and existing ADRs. Updates living documents inline as decisions are made.

See [CONTEXT-FORMAT.md](CONTEXT-FORMAT.md) for how to write and structure `CONTEXT.md`.
See [ADR-FORMAT.md](ADR-FORMAT.md) for when and how to write ADRs.

> Adapted from techniques and skills by Matt Pocock (AIHero.dev / github.com/mattpocock/skills).

## Rules

- Ask questions **one at a time**.
- Provide your recommended answer before waiting for the user's response.
- If a question can be answered by exploring the codebase, explore it instead.
- Never use a term that conflicts with `docs/CONTEXT.md` without flagging it first.

## Domain Awareness

Before beginning, explore the repo for:
- `docs/CONTEXT-MAP.md` — if it exists, read it to find all contexts and how they relate
- `docs/CONTEXT.md` — project domain glossary (single context)
- `docs/adr/` — existing architectural decisions
- `~/.claude/knowledge/systems/` — any relevant system overviews and known issues
- Existing code patterns relevant to the plan

If neither `CONTEXT-MAP.md` nor `CONTEXT.md` exists, create `docs/CONTEXT.md` lazily when the first term is resolved.

---

## During the Session

### Challenge Against the Glossary

When the user uses a term that conflicts with `docs/CONTEXT.md`, call it out immediately:
> "Your glossary defines 'X' as Y, but you seem to mean Z — which is it?"

### Sharpen Fuzzy Language

When the user uses vague or overloaded terms, propose a precise canonical term with an _Avoid_ alias:
> "You're saying 'account' — do you mean Customer or User? Those are different things in this codebase. I'll add 'account' as an alias to avoid."

### Cross-Reference With Code

When the user states how something works, check whether the code agrees. Surface contradictions:
> "Your code does X, but you just said Y — which is right?"

### Discuss Concrete Scenarios

Stress-test domain relationships with specific edge-case scenarios. Force precision about boundaries between related concepts.

---

## Updating CONTEXT.md Inline

When a term is resolved, update `docs/CONTEXT.md` immediately — never batch updates.

Follow [CONTEXT-FORMAT.md](CONTEXT-FORMAT.md). Key points:

- One sentence definition — what it IS, not what it does
- Include `_Avoid_` aliases for rejected synonyms
- Add to "Flagged Ambiguities" if a term was used inconsistently
- Write or update "Example Dialogue" when enough terms exist to show natural usage
- Only include domain-specific terms — not general programming concepts

```markdown
**[Term]**:
[Plain language definition. One sentence.]
_Avoid_: [synonym1, synonym2]
```

For multi-context repos, infer which `CONTEXT.md` to update based on the topic. Ask if unclear.

---

## Offering ADRs

Only offer an ADR when ALL THREE are true (see [ADR-FORMAT.md](ADR-FORMAT.md)):

1. **Hard to reverse** — changing this later has meaningful cost
2. **Surprising without context** — a future reader would wonder "why?"
3. **A real trade-off** — there were genuine alternatives and one was chosen for specific reasons

ADR filename format: `docs/adr/NNNN-[slug].md`

Keep ADRs minimal — the template is a title and 1-3 sentences. Add optional sections only when they add genuine value:

```markdown
# [Short title of the decision]

[1-3 sentences: what's the context, what did we decide, and why.]
```

Reference the ADR filename in the session's DEVLOG "Decisions Made" entry.

---

## After Session

Produce a Shared Understanding Summary:

```markdown
## Shared Understanding — [Feature/Plan Name]

### Decisions Made
- [Decision 1]
- [Decision 2]

### CONTEXT.md Updates
- Added: [Term] — [definition]
- Flagged: [ambiguity and resolution]

### ADRs Written
- [NNNN-slug.md] — [one sentence summary]

### Open Questions (if any)
- [Anything unresolved]

### Recommended Next Stage
Research | Prototype | /write-prd
```

Suggest next stage and wait for human confirmation before proceeding.

---

## Token Recording (Automatic)

At the end of the session (before writing DEVLOG), record token usage in `docs/tokens/[feature-name].md`:

```markdown
### Grill (/grill-with-docs)
**Date range:** [start date] → [end date]
**Sessions:** N
**Input:** ~Nk tokens — Read: [files read this session]
**Output:** ~Nk tokens — [N questions, CONTEXT.md updates, N ADRs]
**Total:** ~Nk ([band])
**Notes:** [anything notable]
```

See `~/.claude/skills/token-report/TOKEN-RECORDING.md` for estimation guidance.
