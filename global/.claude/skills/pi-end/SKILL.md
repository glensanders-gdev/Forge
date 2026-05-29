---
name: pi-end
category: pi-release
description: Formally close a Product Iteration. Summarises what was delivered, what carried forward, lessons learned, and archives the PI plan. Produces a stakeholder-facing delivery summary. Use when user runs /pi-end or a PI period is closing.
---

# PI End

Formally close a Product Iteration. Produces a delivery summary, captures lessons learned, updates carry-forwards, and archives the PI plan. Mirrors the `/sprint-end` pattern at PI scale.

## When to Use

- The final release of the PI has been approved via `/go-nogo`
- User explicitly runs `/user:pi-end`
- A new PI is about to start — close the current one first

## Process

### 1. Assess PI State

Read `~/.claude/pi/[current-pi]/plan.md`:
- Confirm all three releases have been closed (Go/No Go completed)
- If any release is still open, warn: "Release R[N] has not been closed. Run `/user:go-nogo` before closing the PI."
- Identify carry-forward features

Read `~/.claude/sprints/calendar.md` — confirm all PI sprints are marked Closed.

Read all `docs/releases/PI-N-RN-gono.md` files — extract decisions and outcomes.

### 2. Compile PI Summary

Aggregate across all three releases:
- Features delivered
- Features carried forward (with reasons)
- Standalone releases deployed
- Go/No Go outcomes (any NO-GO decisions and why)
- Sprint velocity (tickets completed per sprint, from sprint records)

### 3. Ask for Retrospective Input

Three questions, one at a time:
- "What went well across this PI?"
- "What didn't go well?"
- "One process improvement to carry into the next PI?"

### 4. Present Full Draft for Confirmation

Present the complete PI end document before writing anything.

### 5. Write PI End Record

Append to `~/.claude/pi/[current-pi]/plan.md`:

```markdown
---

## PI End

**Date closed:** YYYY-MM-DD
**Status:** Closed

### Delivery Summary

| Release | Date | Features Delivered | Outcome |
|---------|------|--------------------|---------|
| R1 | DD MMM | [feature], [feature] | ✅ On time / ⚠️ Partial / ❌ NO-GO |
| R2 | DD MMM | [feature], [feature] | ✅ On time / ⚠️ Partial / ❌ NO-GO |
| R3 | DD MMM | [feature], [feature] | ✅ On time / ⚠️ Partial / ❌ NO-GO |

### Standalone Releases
- [Date]: [feature] — [outcome]

### Carry Forward to Next PI
| Feature | Reason | Priority for PI-N+1 |
|---------|--------|---------------------|
| | | |

### PI Velocity
| Sprint | Tickets Completed | Notes |
|--------|------------------|-------|
| Sprint-NN | N | |

### Retrospective
**Went well:**
[Response]

**Didn't go well:**
[Response]

**One improvement for PI-N+1:**
[Response]
```

### 6. Update Stakeholder View

Append a delivery summary to `~/.claude/pi/[current-pi]/stakeholder.md`:

```markdown
---

## PI Delivery Summary

**PI closed:** YYYY-MM-DD

### Delivered This PI
| Feature | Release | Status |
|---------|---------|--------|
| [Stakeholder label] | [Month] | ✅ Delivered |
| [Stakeholder label] | [Month] | ⚠️ Partially delivered |

### Carried Forward
| Feature | New Target |
|---------|-----------|
| [Stakeholder label] | [Next PI / TBC] |

*Thank you for your patience. Features carried forward will be prioritised in the next delivery period.*
```

Ask: "Does this stakeholder summary accurately represent the PI outcome? Type CONFIRM to save, or provide edits."

### 7. Archive the PI Plan

Mark the PI as Closed in the plan header. Update `~/.claude/sprints/calendar.md` — mark all PI sprints as archived.

### 8. Update Priorities

Read `~/.claude/priorities.md` — remove delivered features, flag carried-forward features for re-ranking in the next PI.

Present proposed changes for confirmation before writing.

### 9. Post-Closure Prompt

```
✓ PI-N closed. 

Delivered: N features
Carried forward: N features
Standalone releases: N

Next steps:
- Run /piplan to open PI-N+1
- Update ~/.claude/priorities.md ranking for carried-forward features
```

## Rules

- Never close a PI with open Go/No Go records
- Always produce the stakeholder summary — it is not optional
- Stakeholder summary requires explicit CONFIRM before writing
- Carry-forward features must be re-ranked in priorities — do not silently inherit old ranking
- The retrospective must have all three fields completed — prompt once if skipped
- Archived PI plans are never deleted — they are historical records

## Token Summary (PI)

At PI end, read `~/.claude/tokens/ledger.md` and filter for features in this PI:

```markdown
### PI Token Summary
**PI total:** ~Nk tokens (N features, N projects, N sessions)
**Input:** ~Nk (N%) | **Output:** ~Nk (N%)
**By project:**
- [repo1]: ~Nk (N features)
- [repo2]: ~Nk (N features)
**Top phase by cost:** Build (~Nk, N%)
```

Suggest running `/user:token-report` for full calibration analysis.
