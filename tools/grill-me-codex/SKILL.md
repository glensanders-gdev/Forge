---
name: grill-me-codex
category: standalone-tool
version: 1.0.0
description: Two-act plan hardening. Act 1 — Claude grills you about the plan until intent is locked. Act 2 — Codex adversarially reviews the locked plan in a read-only sandbox until approved or MAX_ROUNDS is hit. Human signs off before any code. Use before high-stakes implementation (auth, schema, concurrency, migrations, payments). Requires Codex CLI — not part of the Forge framework.
origin: Adapted from chaseai-yt (grill-me-codex / https://github.com/chaseai-yt/grill-me-codex). Act 1 builds on Matt Pocock's grill-me (MIT).
---

# Grill-Me-Codex — Get Grilled, Then Get Reviewed

Two acts, two different failure modes addressed:

- **Act 1 fixes building the wrong thing.** Claude interrogates you until intent is locked — no guessing at ambiguity. One question at a time, with a recommended answer for each.
- **Act 2 fixes a plan that sounds right but breaks.** A different model (Codex) adversarially attacks the locked plan. Cross-model means no echo chamber.

You enter at two points only: answering the grill, and signing off the converged plan.

*Adapted from chaseai-yt's `grill-me-codex` skill. Act 1 builds on Matt Pocock's grill-me (MIT).*

---

## Prerequisites

- Codex CLI installed and recent: `codex --version` ≥ 0.130
- Codex authenticated: `codex login` (ChatGPT account is sufficient)
- Do NOT pin a `-m` model flag — use whatever is in `~/.codex/config.toml`

If a run returns an auth or model error, surface it to the user and stop. Do not silently retry.

---

## Tunables

Read from skill args; fall back to defaults. Echo resolved values before Act 2 starts.

| Variable | Default | Meaning |
|----------|---------|---------|
| `MAX_ROUNDS` | `5` | Hard cap on Act 2 review rounds — always terminates here |
| `PLAN_FILE` | `PLAN.md` | Where Act 1 writes the locked plan |
| `LOG_FILE` | `PLAN-REVIEW-LOG.md` | Append-only transcript of Act 2 argument |

---

## [HITL] Act 1 — Grill (you ↔ Claude)

Interview the user relentlessly about every aspect of the plan. Walk down each branch of the design tree, resolving dependencies between decisions one at a time. For each question, provide a recommended answer before waiting for the user's response. If a question can be answered by exploring the codebase, explore it instead of asking.

Continue until every branch is resolved and shared understanding is reached. **Do not write `PLAN.md` until the grill has actually resolved the decision tree** — the plan must reflect what the conversation settled, not what Claude assumed going in.

When the decision tree is fully resolved, write the locked plan to `PLAN_FILE`:

```markdown
# Plan: <task>
_Locked via grill — by Claude + <user>_

## Goal
<one paragraph — reflects what the grilling actually settled>

## Approach
<numbered, concrete steps>

## Key decisions and tradeoffs
<the contestable choices the grill resolved — name them so Codex has something to bite>

## Risks and open questions
<anything still genuinely open>

## Out of scope
<bounds the grill established>
```

Initialise `LOG_FILE`:

```markdown
# Plan Review Log: <task>
Act 1 (grill) complete — plan locked with the user. MAX_ROUNDS=<n>.
```

Show the user the locked plan and confirm you are moving to Act 2.

---

## [AFK] Act 2 — Review (Claude ↔ Codex)

**Critical sandbox note:** `codex exec` accepts `-s read-only`. `codex exec resume` does NOT — it rejects `-s`. On resume, force read-only via `-c sandbox_mode="read-only"` instead, because `config.toml` may default to `danger-full-access`. Codex must never write files.

**The review prompt** sent to Codex each round:

> You are an adversarial reviewer for an implementation plan. Be sceptical and specific — your job is to find what breaks, not to be agreeable. Read the plan at `PLAN.md` and any repo files you need (you are read-only). Identify concrete flaws: security holes, race conditions, missing edge cases, schema conflicts, wrong assumptions, observability gaps, simpler alternatives. For each, give a one-line fix. Do NOT modify any files. End your reply with EXACTLY one line: `VERDICT: APPROVED` if the plan is sound enough to implement, or `VERDICT: REVISE` if it still has material problems.

**Round 1** — creates the session, captures `THREAD_ID`:

```bash
codex exec -s read-only --json \
  -o /tmp/codex-verdict.txt \
  "<review prompt>" \
  2>/dev/null | grep '"type":"thread.started"'
```

Parse `thread_id` from the `{"type":"thread.started","thread_id":"..."}` line. The critique lands in `/tmp/codex-verdict.txt`. If neither appears, the run failed — stop and report the error.

**Rounds 2..MAX** — resume the same session (Codex remembers prior critiques, won't re-litigate settled points):

```bash
# resume rejects -s; force read-only via -c or Codex may inherit danger-full-access
codex exec resume "$THREAD_ID" -c sandbox_mode="read-only" --json \
  -o /tmp/codex-verdict.txt \
  "I revised the plan. Re-review PLAN.md — check whether your prior findings are addressed and flag anything new. End with VERDICT: APPROVED or VERDICT: REVISE." \
  2>/dev/null >/dev/null
```

**Each round after Codex returns:**

1. Read `/tmp/codex-verdict.txt`. Append to `LOG_FILE`: `## Round <n> — Codex` + full critique.
2. Grep the last line for the verdict:
   - `VERDICT: APPROVED` → exit loop, go to Resolution (converged).
   - `VERDICT: REVISE` → Claude reads the critique and decides what is worth acting on. **Claude is the final arbiter — Codex advises, it does not command.** Revise `PLAN_FILE`. Append `### Claude's response` to `LOG_FILE`: what changed, what was rejected, why. Increment round.
3. If round > `MAX_ROUNDS` → exit loop, go to Resolution (deadlock).

---

## [HITL] Resolution — Sign-Off

**If APPROVED:** Present the final `PLAN_FILE`, a 3-bullet summary of what both acts improved, and the round count. Ask: *"Grilled + survived N rounds of Codex review. Implement it now?"* Write code only on an explicit yes.

**If deadlock (MAX_ROUNDS without APPROVED):** Do not fake convergence. List each unresolved point — Codex's position and Claude's counter-position — and hand it to the user to break the tie. A flagged disagreement beats a false approval.

---

## Forge Integration Points

| Skill | Relationship |
|-------|-------------|
| `/grill-me` | Act 1 uses the same mechanics. Use `/grill-me` alone when Codex is not available. |
| `tools/codex-review` | Act 2 uses the same loop. Use `codex-review` alone when you already have a locked plan. |
| `/write-prd` | PRD may precede this skill. Grill-me-codex sits between requirements and `/build`. |
| `/build` | Only triggered after the user's final sign-off. No code is written during either act. |

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| Codex CLI not installed | Stop immediately. Instruct user to install Codex CLI and `codex login` before retrying. |
| Auth or model error on first run | Stop and report. Do not retry silently. |
| `VERDICT` line missing from output | Treat as `VERDICT: REVISE`. Log the anomaly in `LOG_FILE`. |
| Deadlock at MAX\_ROUNDS | Surface all unresolved disagreements. Hand to human. Do not auto-approve. |
| User skips Act 1 ("just review my existing plan") | Redirect to `tools/codex-review` — this skill requires Act 1 to be run first. |
| Codex writes a file (sandbox failure) | Stop the loop. Report the sandbox breach. Do not continue. |

---

## Never

- Never skip Act 1 — the grill is half the value. A plan written without it is an assumption, not a decision.
- Never write `PLAN.md` until the decision tree is genuinely resolved.
- Never give Codex write access — `-s read-only` on exec, `-c sandbox_mode="read-only"` on every resume.
- Never let the loop exceed `MAX_ROUNDS`.
- Never auto-approve after deadlock — present the disagreement and wait for the human.
- Never write code during either act — only after the user's final sign-off.
- Never use this to review already-written code — use `/code-review` for that.
- Never pin a `-codex` model variant on ChatGPT-account auth — it returns a 400.
