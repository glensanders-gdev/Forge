---
name: pi-replan
category: pi-release
description: Replan the current PI when a new project or significant scope change is injected mid-PI. Assesses remaining releases only, flags Fixed Deadline risks as P1 before confirmation, updates PI plan in place, and prepares a stakeholder draft requiring separate confirmation. Use when user runs /pi-replan or a new project is injected into an active PI.
---

# PI Replan

Handle the injection of a new project or significant scope change into an active PI. Assesses impact on remaining releases only, surfaces deadline risks before any changes are made, and keeps stakeholder communication under human control.

## When to Use

- A new project is injected mid-PI
- Significant scope change affects release assignments
- User explicitly runs `/user:pi-replan`
- `/create-project` prompts a PI replan after a new project is added
- `/sprint-replan` surfaces PI-level impact

## Process

### 1. Assess Current PI State

Read `~/.claude/pi/[current-pi]/plan.md`:
- Identify remaining releases (closed releases are never touched)
- List features assigned to each remaining release
- Note any Fixed Deadline features and their external due dates

Read `~/.claude/priorities.md` — current feature priority ranking.

### 2. Assess the Injection

Ask the user:
- What is being injected? (project name, feature, or scope change)
- Which release is it targeting?
- What is its priority — P1 Critical / P2 High / P3 Normal / P4 Low?
- Is there an external deadline?
- Estimated sprint effort — how many sprints does it need?

### 3. Fixed Deadline Risk Check (Mandatory)

Before presenting any options, check every Fixed Deadline feature in remaining releases:

- Does the injection displace or delay any Fixed Deadline feature?
- Does the injection consume sprint capacity needed for a Fixed Deadline feature?
- Would any Fixed Deadline feature miss its external due date as a result?

If yes → surface as P1 risk before proceeding:

```
⛔ P1 RISK — Fixed Deadline Impact

[Feature name] has an external deadline of [date].
This replan would push it to [release], which deploys on [date] — 
[N days] after its external deadline.

You must acknowledge this risk before proceeding.
Type ACKNOWLEDGE to continue, or adjust the injection scope.
```

Do not proceed until the risk is explicitly acknowledged.

### 4. Present Replan Options

Assess remaining release capacity and present options:

```markdown
## PI Replan — [PI-N]

**Injection:** [Project/feature name]
**Priority:** P[N]
**Target:** [Release]
**Effort:** ~[N] sprints

**Remaining releases:**
| Release | Date | Current load | Available capacity |
|---------|------|-------------|-------------------|
| R[N] | [date] | [N features] | [slack/full] |
| R[N] | [date] | [N features] | [slack/full] |

**Options:**

**Option A — Add to R[N]:** [impact on existing features]
**Option B — Defer [existing feature] to R[N+1]:** [impact]
**Option C — Split across R[N] and R[N+1]:** [impact]

**Recommended:** [Option] — [reason]

⚠️ Fixed Deadline features affected: [none / list]

Type CONFIRM to apply Option [N], or specify a different option.
```

### 5. On CONFIRM (Gate 1 — PI Plan)

1. Update `~/.claude/pi/[current-pi]/plan.md` in place:
   - Add injected project/feature to target release
   - Move any displaced features to next release
   - Update release capacity notes
2. Update `~/.claude/sprints/calendar.md` if sprint assignments change
3. Append to `docs/DEVLOG.md`:

```markdown
### ⚠️ PI Replan — YYYY-MM-DD

**Injected:** [project/feature name] (P[N])
**Assigned to:** PI-N-R[N] ([date])
**Displaced:** [feature] → R[N+1] (if any)
**Fixed Deadline risk:** [none / acknowledged — [feature] now [N days] past deadline]
**PI plan updated:** Yes
**Stakeholder view:** Pending human review
**Confirmed by:** Human
```

### 6. Stakeholder Update (Gate 2 — Separate Confirmation)

Draft the stakeholder update and present for review:

```markdown
## Proposed Stakeholder Update

The following change has been made to the [PI-N] delivery plan:

**Added:** [Stakeholder label] — now planned for [Month] release
**Moved:** [Stakeholder label] — moved from [Month] to [Month] release
  Reason: [plain language reason — e.g. "to accommodate a higher priority delivery"]

No previously committed features have been removed from this PI.
[Or: The following feature has been deferred to the next PI: [label]]
```

Ask: "Does this stakeholder message accurately represent the change? Type CONFIRM to update stakeholder.md, or provide edits."

On second `CONFIRM`:
- Update `~/.claude/pi/[current-pi]/stakeholder.md` in place
- Note in DEVLOG: "Stakeholder view updated — [date]"

## Rules

- Never touch closed releases — remaining releases only
- Fixed Deadline risk check is mandatory — never skip it
- Two confirmation gates: PI plan first, stakeholder view second
- Never update `stakeholder.md` without the second explicit `CONFIRM`
- Displaced features go to the next release — never silently dropped
- If no remaining capacity exists in any release, surface this clearly and ask the human to choose: defer to next PI, or explicitly remove a feature from this PI
- Append a clearly labelled replan entry to DEVLOG after Gate 1, update it after Gate 2
