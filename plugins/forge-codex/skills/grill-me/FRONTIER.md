# Frontier Rounds

The traversal protocol shared by `$grill-me` and `$grill-with-docs`. Both skills reference this file rather than restating it — one definition, no drift.

> Adapted from Matt Pocock's `grilling` skill (AIHero.dev / github.com/mattpocock/skills). The frontier model, the question format, and the empty-frontier stop condition are his; the round cap and the subagent routing are Forge additions.

---

## The Tree and the Frontier

Map the plan as a **design tree** — every decision branches into the decisions that hang off it.

The **frontier** is every decision whose prerequisites are already settled: the questions answerable *now*, without guessing at answers you haven't heard yet. A question whose answer depends on another open question is not on the frontier — it is downstream of it.

The frontier is dependency-driven, not order-driven. Working it in rounds means a constraint discovered late cannot invalidate a branch already walked, which depth-first traversal allows.

## The Round

1. Compute the frontier.
2. Ask **up to 5** frontier questions in one round, numbered, each carrying your recommended answer.
3. If the frontier is wider than 5, ask the highest-leverage subset — the questions that settle the most downstream decisions — and state at the end how many are held back and what they cover. Never silently truncate.
4. Wait for the human's answers. A round is a HITL gate.
5. Answers reshape the tree: settled decisions push the frontier outward and unblock what depended on them. Recompute the frontier and ask the next round.

Unanswered questions from a round stay on the frontier. Carry them into the next round — never read silence as agreement with your recommendation.

## Question Format

```
❓ **Q1** — **[short title]**: [body — state the options where there are options]

➡️ [your recommended answer, and the one-line reason for it]
```

The `➡️` line is mandatory on every question. A question with no recommendation makes the human do your thinking.

## Facts vs Decisions

**Facts you find. Decisions the human makes.**

- When a frontier question needs a fact from the environment — codebase, filesystem, docs, tooling — dispatch a subagent to find it rather than asking the human. Route lookups to a Haiku subagent per `~/.codex/forge/rules/common/model-selection.md`; do it inline when the lookup is smaller than the spawn round-trip.
- A running exploration is an unsettled prerequisite. Only the questions downstream of it wait — ask the rest of the round now rather than blocking the session on a subagent.
- A decision is the human's even when the answer looks obvious. Put it to them and wait.

## Stop Condition

The session is complete when **the frontier is empty** — every branch of the tree visited, nothing left silently assumed. An empty frontier is what triggers the Shared Understanding Summary; a satisfied-sounding human is not.

Questions that cannot be settled in-session are recorded under **Open Questions** in the summary. An unsettled question is carried forward, never dropped to reach an empty frontier.

## Never

- Never ask more than 5 questions in a single round.
- Never place a question in the same round as the question its answer depends on.
- Never ask the human for a fact you can look up.
- Never proceed past a round on your own recommendations because the human didn't answer.
- Never begin implementation, or write any file the session is about, while the frontier is non-empty.
