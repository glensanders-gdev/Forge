# Model & Effort Selection — Universal Baseline

> Applies to all sessions. Governs which model handles which work, to stretch
> weekly usage limits without sacrificing reasoning quality.

Origin: IDEA-002 (accepted 2026-06-10). Architecture C — Opus on the main thread,
grunt work offloaded to cheap subagents.

## Principle

Keep the **main reasoning thread on Opus 4.8.** Offload *delegatable grunt work*
to the cheapest subagent that can reliably deliver it. Do not downgrade the main
session — quality before efficiency.

Weekly limits are the constraint. Opus burns quota ~5× a Sonnet token and ~15–20×
a Haiku token, so routing grunt work to cheaper models buys more productive headroom.

## Delegation Decision Table

When delegating via the `Agent` tool, `Explore` agent type, or workflow `agent()`,
set the cheapest viable `model:` for the subtask shape:

| Subtask shape | Route to |
|---|---|
| Lookup, grep, "where is X", read-and-summarise | **Haiku** subagent |
| Bulk mechanical edit, boilerplate, test scaffolds, rename-across-files | **Sonnet** subagent |
| Hard sub-reasoning that is parallelisable | **Opus** subagent |
| Reasoning, planning, synthesis, final decisions | **Opus** main (never delegated) |

Subagents inherit the main-loop model unless overridden — so the `model:` override
is mandatory to capture the saving. An un-overridden subagent runs on Opus.

## Minimum-Size Guardrail

Spawning a subagent re-derives context cold (it reads files; the main thread pays to
write the prompt and digest the result). **If a subtask is smaller than that round-trip,
do it inline on Opus.** Delegation pays off only when the offloaded work is larger than
the spawn overhead — a one-line lookup is cheaper inline.

## Target & Verification

- **Target:** Opus ≤ 70% of weekly quota burn (Conservative).
- **Verify:** run `npx ccusage weekly --breakdown` periodically; watch the Opus share trend.
- **Escalation:** if a cheap subagent returns insufficient quality, re-run the subtask on
  the next tier up — do not silently accept a weak result, and do not pre-emptively default
  back to Opus "to be safe" (that collapses the strategy).

## Never

- Never delegate final decisions, synthesis, or ambiguous design reasoning to a cheap model.
- Never spawn a subagent for work smaller than the spawn round-trip.
- Never leave a delegated subagent on the inherited Opus model when a cheaper tier suffices.
- Never downgrade the main session model to chase savings — offload instead.
