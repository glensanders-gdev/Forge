---
name: grill-with-docs-codex
category: standalone-tool
version: 1.0.0
description: Two-act plan hardening with domain awareness. Act 1 — Claude grills you against the project's domain model (CONTEXT.md, ADRs, codebase), updating living docs inline as decisions crystallise. Act 2 — Codex adversarially reviews the locked plan in a read-only sandbox, with CONTEXT.md and ADRs as context so it can catch domain-language mismatches, not just structural flaws. Human signs off before any code. Requires Codex CLI — not part of the Forge framework.
origin: Adapted from chaseai-yt (grill-with-docs-codex / https://github.com/chaseai-yt/grill-me-codex). Act 1 builds on Matt Pocock's grill-with-docs (MIT).
---

# Grill-with-Docs-Codex — Grill Against Your Domain, Then Get Reviewed

Two acts, both domain-aware:

- **Act 1** aligns intent *and* keeps living docs honest — challenging your plan against `CONTEXT.md`, ADRs, and the codebase, updating them inline as decisions crystallise.
- **Act 2** has a different model adversarially attack the locked plan — and unlike plain `codex-review`, Codex is given `CONTEXT.md` and ADRs as context so it can catch domain-language mismatches, not just structural flaws.

You enter at two points only: answering the grill, and signing off the converged plan.

*Adapted from chaseai-yt's `grill-with-docs-codex` skill. Act 1 builds on Matt Pocock's grill-with-docs (MIT).*

---

## Prerequisites

- Codex CLI installed and recent: `codex --version` ≥ 0.130
- Codex authenticated: `codex login` (ChatGPT account is sufficient)
- Do NOT pin a `-m` model flag — use whatever is in `~/.codex/config.toml`

On auth or model error, surface it and stop. Do not retry silently.

---

## Tunables

Read from skill args; fall back to defaults. Echo resolved values before Act 2 starts.

| Variable | Default | Meaning |
|----------|---------|---------|
| `MAX_ROUNDS` | `5` | Hard cap on Act 2 review rounds — always terminates here |
| `PLAN_FILE` | `PLAN.md` | Where Act 1 writes the locked plan |
| `LOG_FILE` | `PLAN-REVIEW-LOG.md` | Append-only transcript of Act 2 argument |

---

## [HITL] Act 1 — Grill with Docs (you ↔ Claude)

Run Forge's `/grill-with-docs` skill in full — domain awareness, inline CONTEXT.md and ADR updates, one question at a time with recommended answers, codebase cross-referencing. All the rules from that skill apply here without exception.

**Do not write `PLAN.md` until the decision tree is genuinely resolved.** The plan must reflect what the grilling settled, not assumptions going in.

When the decision tree is resolved and the glossary/ADRs are current, write the locked plan to `PLAN_FILE` using canonical terms from `CONTEXT.md`:

```markdown
# Plan: <task>
_Locked via grill-with-docs — by Claude + <user>. Terms per CONTEXT.md._

## Goal
<one paragraph, in the project's ubiquitous language>

## Approach
<numbered, concrete steps>

## Key decisions and tradeoffs
<the contestable choices the grill resolved — link any ADRs created>

## Risks and open questions
<anything still genuinely open>

## Out of scope
<bounds the grill established>
```

Initialise `LOG_FILE`:

```markdown
# Plan Review Log: <task>
Act 1 (grill-with-docs) complete — plan locked, CONTEXT.md/ADRs updated. MAX_ROUNDS=<n>.
```

Show the user the locked plan and confirm you are moving to Act 2.

---

## [AFK] Act 2 — Domain-Aware Review (Claude ↔ Codex)

**Critical sandbox note:** `codex exec` accepts `-s read-only`. `codex exec resume` does NOT — it rejects `-s`. On resume, force read-only via `-c sandbox_mode="read-only"` instead, because `config.toml` may default to `danger-full-access`. Codex must never write files.

**The review prompt** — note that Codex is explicitly given `CONTEXT.md` and ADRs as context, which plain `codex-review` does not do:

> You are an adversarial reviewer for an implementation plan. Be sceptical and specific — your job is to find what breaks, not to be agreeable. Read the plan at `PLAN.md`, the domain glossary at `CONTEXT.md` (or the relevant context file if `CONTEXT-MAP.md` exists), and any ADRs in `docs/adr/` — plus any other repo files you need. You are read-only. Identify concrete flaws: security holes, race conditions, missing edge cases, schema conflicts, domain-language mismatches between the plan and the glossary, wrong assumptions, observability gaps, simpler alternatives. For each, give a one-line fix. Do NOT modify any files. End your reply with EXACTLY one line: `VERDICT: APPROVED` if the plan is sound enough to implement, or `VERDICT: REVISE` if it still has material problems.

**Round 1** — creates the session, captures `THREAD_ID`:

```bash
codex exec -s read-only --json \
  -o /tmp/codex-verdict.txt \
  "<review prompt>" \
  2>/dev/null | grep '"type":"thread.started"'
```

Parse `thread_id` from the `{"type":"thread.started","thread_id":"..."}` line. The critique lands in `/tmp/codex-verdict.txt`. If neither appears, the run failed — stop and report the error.

**Rounds 2..MAX** — resume the same session:

```bash
# resume rejects -s; force read-only via -c or Codex may inherit danger-full-access
codex exec resume "$THREAD_ID" -c sandbox_mode="read-only" --json \
  -o /tmp/codex-verdict.txt \
  "I revised the plan. Re-review PLAN.md against CONTEXT.md and ADRs — check whether your prior findings are addressed and flag anything new. End with VERDICT: APPROVED or VERDICT: REVISE." \
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

**If APPROVED:** Present the final `PLAN_FILE`, a 3-bullet summary of what both acts improved, and the round count. Ask: *"Grilled against the domain model + survived N rounds of Codex review. Implement it now?"* Write code only on an explicit yes.

**If deadlock (MAX_ROUNDS without APPROVED):** Do not fake convergence. List each unresolved point — Codex's position and Claude's counter-position — and hand it to the user to break the tie. A flagged disagreement beats a false approval.

---

## Forge Integration Points

| Skill | Relationship |
|-------|-------------|
| `/grill-with-docs` | Act 1 — runs this skill in full. All its rules apply. |
| `tools/codex-review` | Act 2 uses the same loop mechanics with a domain-aware review prompt. |
| `tools/grill-me-codex` | Same two-act structure without domain awareness — use when no CONTEXT.md exists. |
| `/write-prd` | PRD may precede this skill. Grill-with-docs-codex sits between requirements and `/build`. |
| `/build` | Only triggered after the user's final sign-off. No code is written during either act. |

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| Codex CLI not installed | Stop immediately. Instruct user to install Codex CLI and `codex login` before retrying. |
| Auth or model error on first run | Stop and report. Do not retry silently. |
| No `CONTEXT.md` found | Proceed with Act 1 as `/grill-with-docs` would — create `docs/CONTEXT.md` lazily when the first term is resolved. Codex will find it in Act 2. |
| `VERDICT` line missing from output | Treat as `VERDICT: REVISE`. Log the anomaly in `LOG_FILE`. |
| Deadlock at MAX\_ROUNDS | Surface all unresolved disagreements. Hand to human. Do not auto-approve. |
| User wants to skip Act 1 | Redirect to `tools/codex-review` — this skill requires Act 1 to be run first. |
| Codex writes a file (sandbox failure) | Stop the loop. Report the sandbox breach. Do not continue. |

---

## Never

- Never skip Act 1 — the domain-aware grill is half the value.
- Never write `PLAN.md` until the decision tree is genuinely resolved and CONTEXT.md is current.
- Never use implementation details in `CONTEXT.md` — it is a glossary only.
- Never give Codex write access — `-s read-only` on exec, `-c sandbox_mode="read-only"` on every resume.
- Never let the loop exceed `MAX_ROUNDS`.
- Never auto-approve after deadlock — present the disagreement and wait for the human.
- Never write code during either act — only after the user's final sign-off.
- Never use this to review already-written code — use `/code-review` for that.
- Never pin a `-codex` model variant on ChatGPT-account auth — it returns a 400.
