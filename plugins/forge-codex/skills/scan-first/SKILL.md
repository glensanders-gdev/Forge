---
name: "scan-first"
description: "Verify a ticket or task brief against live source before building or spawning agents on it — treat examples, counts, and \"this is open\" claims as hypotheses until checked. Use before starting a coverage/effect/behaviour ticket, before spawning worktree agents or subagents on a wave, when a backlog or audit table looks stale, or whenever a brief asserts facts about code that exist to be checked."
metadata:
  category: code-quality
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Scan First

A ticket's examples, an audit row, a backlog count, a "still open" status, or a premise
written into a subagent brief — each is a *hypothesis* until verified against live source.
Codebases outpace their backlogs; building straight from ticket text hits ghosts
(already-implemented work) or misses the real blocker. Scanning first is cheap; a wasted
build — or a cold agent rebuilding existing infra — is not.

## When to Use

- Before starting a coverage/effect/behaviour ticket.
- **Before spawning** a worktree agent or subagent on a ticket — scan-first gates *spawning*, not just sizing.
- When a backlog or audit table looks stale.
- Whenever a task brief asserts facts about the code (file locations, "X is missing", volumes).

## Process

1. **List the claims.** Pull every checkable assertion from the ticket/brief: examples, counts, "this is open", file/function locations, sizing.
2. **Baseline.** Run or read the project's current-state metric (coverage audit, test count, the relevant handler table). Know where the code stands now.
3. **Extract from source.** Grep/script the actual data the claim rests on — fixtures/catalog for volume and shape variants, the dispatch tables for what's already wired. Count reality.
4. **Trace one real case end-to-end** to the exact line where it stops. That line is the real gap — often not the one named.
5. **Verdict per item: OPEN / GHOST / PARTIAL.** A GHOST closes by verification, no code. PARTIAL → size only the missing shape. OPEN → size from real volume.
6. **Only then build or spawn.** Spawn on scan-verified-open, correctly-scoped lanes. If a running lane's premise breaks under the scan, stop it (`TaskStop`).

## Orchestrating subagents

- Mark unverified claims in the brief as **hypotheses**; make step 1 a *verify-against-source* gate **with permission to reject the premise** — a gate works only when the agent may return "the premise is false."
- The orchestrator scans *before* spawning; the in-brief gate is the second line of defence.
- When the whole backlog is suspect, one **read-only reconciliation sweep** (cheap model) ghost-auditing every family at once beats discovering ghosts one spawn at a time; its output becomes the build-ordering source of truth.

## Rules

- Never write code or spawn an agent on an unverified premise.
- A ghost closes by verification — record where it's already handled, write no new code.
- Stop a mis-scoped lane the moment the scan reveals it.
- Scan-first gates spawning, not just sizing.

## Output

A verdict line per item: `#N — OPEN|GHOST|PARTIAL — <evidence: file:line / real count> — <real size>`. For a wave: a ranked, file-disjoint set of scan-verified-open lanes.

## Worked example (PROJ-003 FFTCG)

5 observations: #156/#170/#164/#175/#157/#168 were ghosts already in `targeting.ts` APPLY_HANDLERS / `stack.ts` EFFECT_HANDLER; #153's real gap was multi-line text bundling, not the apply clause; #169's was a guard regex; a spawn-then-scan wave had to `TaskStop` a lane rebuilding the existing Break-Zone picker. Recipe: run `abilityCoverage.audit.test.ts` for baseline → classify the family from `shared/src/data/cards/*.json` → trace a text through `extractEffectText → executeEffect` and grep the handler tables.

---

*Promoted from instinct-003 (scan-engine-before-coverage-tickets) — 5 observations, 2026-06-12 → 2026-06-14, across solo TDD builds and multi-agent waves.*
