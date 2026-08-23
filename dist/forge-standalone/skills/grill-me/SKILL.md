---
name: grill-me
category: pipeline
origin: Adapted from Matt Pocock (grilling / github.com/mattpocock/skills)
description: Ad-hoc stress-test of a plan or design outside the standard planning phase. Use when user wants to pressure-test an idea, approach, or decision without domain model context. For project planning, use /grill-with-docs instead — it checks CONTEXT.md and the codebase during grilling.
---

# Grill Me

Ad-hoc stress-test of a plan or design. For the standard project planning phase, use `/user:grill-with-docs` — it checks `CONTEXT.md` and the codebase while grilling. Use this skill for framework design, new ideas without an existing codebase, or any scenario where domain model context is not yet established.

Interview the user relentlessly about every aspect of their plan until a shared understanding is reached. Map the plan as a **design tree** and work it in bounded frontier rounds — see [FRONTIER.md](FRONTIER.md) for the round protocol, question format, and stop condition.

**Execution mode:** `[HITL]` throughout. Every round is a gate; the session cannot advance on the AI's own answers.

> Adapted from Matt Pocock's `grilling` skill (AIHero.dev / github.com/mattpocock/skills).

## Rules

- Work the design tree in **bounded frontier rounds** — up to 5 numbered questions per round, each carrying your recommended answer, then wait. Protocol, question format, and stop condition: [FRONTIER.md](FRONTIER.md).
- **Facts you look up; decisions you put to the human.** Dispatch a subagent for environment facts rather than asking the user for what you can find. A *decision* is theirs — put each one to them and wait. Never decide on the human's behalf to keep the session moving.
- If a term conflicts with `docs/CONTEXT.md`, call it out immediately before continuing.
- No coding or file creation occurs until the frontier is empty **and** the user explicitly confirms shared understanding.

## Process

1. Read `docs/CONTEXT.md` and `docs/DEVLOG.md` if they exist, to understand prior context.
2. Ask the user what plan or design they want grilled. If already provided, begin immediately.
3. Sketch the top-level branches of the design tree (architecture, data, auth, UX, infra, etc.).
4. Run frontier rounds per [FRONTIER.md](FRONTIER.md), recomputing the frontier after each set of answers, until the frontier is empty.
5. On an empty frontier, produce a **Shared Understanding Summary** and ask for confirmation.

## Shared Understanding Summary Format

```markdown
## Shared Understanding — [Feature/Plan Name]

### Decisions Made
- [Decision 1]
- [Decision 2]

### Open Questions (if any)
- [Anything unresolved]

### Recommended Next Stage
Research | Prototype | /write-prd
```

## After Confirmation

Suggest the next stage:
- If implementation involves expensive exploration → recommend Research stage
- If the design is uncertain and benefits from early code feedback → recommend Prototype stage
- If understanding is clear and scope is defined → recommend `/write-prd`

Wait for human confirmation before proceeding.

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| `CONTEXT.md` missing | Note "No domain glossary found." Proceed — flag any terms that should be added as session progresses. |
| No plan or design provided | Ask once: "What would you like to be grilled on?" If no response, stop gracefully. |
| Round presented with no closing prompt | The human cannot tell a gate from a report and the session stalls. Close it: name **change / discuss / accept**, and say how many questions are held back. |
| Frontier is wider than 5 questions | Ask the highest-leverage subset and state how many are held back and what they cover — never dump the whole frontier, never truncate silently. |
| A frontier question needs an environment fact | Dispatch a subagent for it and ask the rest of the round now — only the questions downstream of that fact wait. |
| User answers some questions in a round but not others | The unanswered ones stay on the frontier and go into the next round — never read silence as agreement with your recommendation. |
| User confirms understanding while the frontier is non-empty | Name what is still open and ask whether to settle it or record it under Open Questions — never let a confirmation empty the frontier for you. |
| User confirms understanding immediately without engaging | Accept but note: "Shared understanding confirmed quickly — consider running `/critic` to stress-test before proceeding." |
| Idea diagram referenced but not found | Note it is missing. Offer to create a draft diagram from the conversation so far. |

## Idea Diagram Update

If an idea in `~/.claude/ideas/active/` is linked to this grill session:

After confirming shared understanding, update the idea diagram:
1. Read `~/.claude/ideas/active/[idea-name]/diagram.mmd`
2. Update to reflect the refined understanding from the grill
3. Save updated version as `diagram.mmd` (current)
4. Save snapshot as `diagram-v2-design.mmd`
5. Update the diagram version history table in `idea.md`
