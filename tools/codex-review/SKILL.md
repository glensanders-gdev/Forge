---
name: codex-review
category: plan-quality
version: 1.0.0
description: Adversarial two-model plan review loop. Claude (builder) and OpenAI Codex CLI (read-only critic) argue over PLAN.md in bounded rounds until the plan is approved or deadlock is surfaced to the human. Use before any high-stakes implementation — auth, schema, concurrency, migrations, payments. NOT for reviewing existing code (use /code-review for that). NOT for trivial changes.
origin: Adapted from chaseai-yt (grill-me-codex / https://github.com/chaseai-yt/grill-me-codex)
---

# Codex-Review — Adversarial Plan-Review Loop

Two models, one plan, a bounded argument.

**Claude is the builder and orchestrator.** Codex CLI is a read-only critic — it reads the repo and the plan, it cannot touch a file. They communicate through `PLAN.md` and a Codex session that persists across rounds (Codex remembers its earlier critiques and won't re-litigate settled points). The human enters at exactly two points: kickoff and final sign-off.

Reach for this skill on auth, data models, concurrency, migrations, payments — anything expensive to get wrong. Skip it for obvious or cheap work.

*Adapted from chaseai-yt's `codex-review` skill in the grill-me-codex repository.*

---

## Prerequisites

Verify once before starting:

- Codex CLI installed and recent: `codex --version` (≥ 0.130 required — older CLIs error on the default model)
- Codex authenticated: run `codex login` if not already done (ChatGPT account is sufficient)
- Do NOT pin a `-m` model flag unless the user asks — use whatever is in `~/.codex/config.toml`

If a run returns an auth or model error, surface it to the user. Do not silently retry.

**Critical sandbox note:** `codex exec` accepts `-s read-only`. `codex exec resume` does NOT — it rejects `-s`. On resume, force read-only via `-c sandbox_mode="read-only"` instead, because `config.toml` may default to `danger-full-access`. Codex must never write files during this loop.

---

## Tunable Variables

Read from skill args; fall back to defaults.

| Variable | Default | Meaning |
|----------|---------|---------|
| `MAX_ROUNDS` | `5` | Hard cap on review rounds — the loop always terminates here |
| `PLAN_FILE` | `PLAN.md` | Where the evolving plan lives (repo root) |
| `LOG_FILE` | `PLAN-REVIEW-LOG.md` | Append-only transcript of every round's critique and Claude's response |

Echo resolved values to the user before starting.

---

## Flow

### [HITL] Step 0 — Kickoff (human gate #1)

The invocation is the kickoff. Confirm scope in one line: what is being planned. If no task was given, ask for it (one question only). Echo resolved `MAX_ROUNDS`, `PLAN_FILE`, `LOG_FILE`. Then proceed — do not ask for round-by-round approval. The next human gate is at the end.

### [AFK] Step 1 — Claude Drafts the Plan

Read the relevant code and context. Think through the approach; surface decisions and tradeoffs explicitly — give Codex something to bite on. Write the plan to `PLAN_FILE`:

```markdown
# Plan: <task>
_Round 0 — initial draft by Claude_

## Goal
<one paragraph>

## Approach
<numbered steps, concrete>

## Key decisions and tradeoffs
<the contestable choices — name them explicitly>

## Risks and open questions
<what you are uncertain about>

## Out of scope
<explicit bounds>
```

Initialise `LOG_FILE`:

```markdown
# Plan Review Log: <task>
Started <timestamp if known, else "session start">. MAX_ROUNDS=<n>.
```

Show the plan to the user inline and confirm you are sending it to Codex.

### [AFK] Step 2 — The Review Loop

Maintain `ROUND` (starts at 1) and `THREAD_ID` (empty until round 1 returns).

**The review prompt** sent to Codex each round:

> You are an adversarial reviewer for an implementation plan. Be sceptical and specific — your job is to find what breaks, not to be agreeable. Read the plan at `PLAN.md` (and any repo files you need; you are read-only). Identify concrete flaws: security holes, race conditions, missing edge cases, schema conflicts, wrong assumptions, observability gaps, simpler alternatives. For each, give a one-line fix. Do NOT modify any files. End your reply with EXACTLY one line: `VERDICT: APPROVED` if the plan is sound enough to implement, or `VERDICT: REVISE` if it still has material problems.

**Round 1** — creates the Codex session and captures `THREAD_ID`:

```bash
codex exec -s read-only --json \
  -o /tmp/codex-verdict.txt \
  "<review prompt>" \
  2>/dev/null | grep '"type":"thread.started"'
```

Parse `thread_id` from the `{"type":"thread.started","thread_id":"..."}` line. The critique lands in `/tmp/codex-verdict.txt`. If neither appears, the run failed — stop and report the error to the user (do not retry silently).

**Rounds 2..MAX** — resume the same session:

```bash
# resume rejects -s; force read-only via -c or Codex may inherit danger-full-access
codex exec resume "$THREAD_ID" -c sandbox_mode="read-only" --json \
  -o /tmp/codex-verdict.txt \
  "I revised the plan. Re-review PLAN.md. Same rules. End with VERDICT: APPROVED or VERDICT: REVISE." \
  2>/dev/null >/dev/null
```

**Each round after Codex returns:**

1. Read `/tmp/codex-verdict.txt`. Append to `LOG_FILE`: `## Round <n> — Codex` + full critique.
2. Grep the last line for the verdict token:
   - `VERDICT: APPROVED` → exit loop, go to Step 3 (converged).
   - `VERDICT: REVISE` → Claude reads the critique and decides what is worth acting on. **Claude is the final arbiter — Codex advises, it does not command.** Revise `PLAN_FILE`. Append to `LOG_FILE`: `### Claude's response` + what changed and what was rejected with reasons. Increment `ROUND`.
3. If `ROUND > MAX_ROUNDS` → exit loop, go to Step 3 (deadlock).

### [HITL] Step 3 — Resolution (human gate #2)

**If APPROVED:** Present the final `PLAN_FILE`, a 3-bullet summary of what the argument improved, and the round count. Ask: *"Plan survived N rounds of Codex review. Implement it now?"* Only write code after an explicit yes.

**If deadlock (MAX\_ROUNDS reached without APPROVED):** Do not pretend it converged. Surface each unresolved point: Codex's position and Claude's counter-position. Hand it to the human to break the tie. This is a legitimate, useful outcome — a flagged disagreement beats a false approval.

---

## Forge Integration Points

| Stage | Relationship |
|-------|-------------|
| `/grill-me` / `/grill-with-docs` | Run before `/codex-review` to stress-test requirements. Codex-review targets the *plan*, not the idea. |
| `/write-prd` | PRD precedes the plan. Codex-review sits between PRD and `/build`. |
| `/build` | Only triggered after human gate #2 approves the converged plan. |
| `/critic` | Single-model critique of Forge framework, PRDs, or designs. Codex-review is two-model, plan-only. |
| `PLAN-REVIEW-LOG.md` | Stored alongside `PLAN.md` in the repo root. Reference it in ADRs for contested decisions. |

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| Codex CLI not installed | Stop immediately. Instruct user to install Codex CLI and run `codex login` before retrying. |
| Auth or model error on first run | Stop and report. Do not retry. Surface the exact error. |
| `VERDICT` line missing from output | Treat as `VERDICT: REVISE`. Log the anomaly in `LOG_FILE` and note the missing verdict. |
| Deadlock at MAX\_ROUNDS | Surface all unresolved disagreements explicitly. Hand to human. Do not auto-approve. |
| User provides a `PLAN.md` that already exists | Confirm before overwriting: "PLAN.md already exists — overwrite with a new draft, or review the existing plan?" |
| Codex writes a file (sandbox failure) | Stop the loop. Report the sandbox breach. Do not continue until the user resets the Codex session. |

---

## Never

- Never give Codex write access — `-s read-only` on exec, `-c sandbox_mode="read-only"` on every resume.
- Never let the loop run past `MAX_ROUNDS` — the hard cap is non-negotiable.
- Never auto-approve after deadlock — present the disagreement, wait for the human.
- Never write implementation code during the review loop — code only after human gate #2.
- Never pin a `-codex` model variant on ChatGPT-account auth — it returns a 400.
- Never use this skill to review already-written code — that is `/code-review`.
- Never skip `LOG_FILE` — the argument transcript is the primary deliverable.
