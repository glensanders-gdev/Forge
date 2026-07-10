---
name: "grill-me"
description: "Ad-hoc stress-test of a plan or design outside the standard planning phase. Use when user wants to pressure-test an idea, approach, or decision without domain model context. For project planning, use $grill-with-docs instead — it checks CONTEXT.md and the codebase during grilling."
metadata:
  category: pipeline
  version: 1.1.0
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Grill Me

Ad-hoc stress-test of a plan or design. For the standard project planning phase, use `grill-with-docs` — it checks `CONTEXT.md` and the codebase while grilling. Use this skill for framework design, new ideas without an existing codebase, or any scenario where domain model context is not yet established.

Interview the user relentlessly about every aspect of their plan until a shared understanding is reached. Walk down each branch of the design tree, resolving dependencies between decisions one by one.

> Adapted from techniques and skills by Matt Pocock (AIHero.dev / github.com/mattpocock/skills).

## Rules

- Ask questions **one at a time**. Never batch questions — asking several at once is bewildering and buries the decision.
- For each question, provide your **recommended answer** before waiting for the user's response.
- **Facts you look up; decisions you put to the human.** If a question can be answered by exploring the codebase, explore it and answer it yourself — never make the user look up what you can. But a *decision* is theirs: put each one to them and wait for the answer. Never decide on the human's behalf to keep the session moving.
- If a term conflicts with `docs/CONTEXT.md`, call it out immediately before continuing.
- No coding or file creation occurs until the user explicitly confirms shared understanding.

## Process

1. Read `docs/CONTEXT.md` and `docs/DEVLOG.md` if they exist, to understand prior context.
2. Ask the user what plan or design they want grilled. If already provided, begin immediately.
3. Identify the top-level branches of the design (architecture, data, auth, UX, infra, etc.).
4. Walk each branch depth-first, resolving dependencies before moving to siblings.
5. After all branches are resolved, produce a **Shared Understanding Summary** and ask for confirmation.

## Shared Understanding Summary Format

```markdown
## Shared Understanding — [Feature/Plan Name]

### Decisions Made
- [Decision 1]
- [Decision 2]

### Open Questions (if any)
- [Anything unresolved]

### Recommended Next Stage
Research | Prototype | $write-prd
```

## After Confirmation

Suggest the next stage:
- If implementation involves expensive exploration → recommend Research stage
- If the design is uncertain and benefits from early code feedback → recommend Prototype stage
- If understanding is clear and scope is defined → recommend `$write-prd`

Wait for human confirmation before proceeding.

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| `CONTEXT.md` missing | Note "No domain glossary found." Proceed — flag any terms that should be added as session progresses. |
| No plan or design provided | Ask once: "What would you like to be grilled on?" If no response, stop gracefully. |
| User confirms understanding immediately without engaging | Accept but note: "Shared understanding confirmed quickly — consider running `$critic` to stress-test before proceeding." |
| Idea diagram referenced but not found | Note it is missing. Offer to create a draft diagram from the conversation so far. |

## Idea Diagram Update

If an idea in `~/.codex/forge/ideas/active/` is linked to this grill session:

After confirming shared understanding, update the idea diagram:
1. Read `~/.codex/forge/ideas/active/[idea-name]/diagram.mmd`
2. Update to reflect the refined understanding from the grill
3. Save updated version as `diagram.mmd` (current)
4. Save snapshot as `diagram-v2-design.mmd`
5. Update the diagram version history table in `idea.md`
