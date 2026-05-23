---
name: backlog-add
description: Add a well-defined item to the global or a project backlog. Grills the item lightly before adding — what it is, why it matters, priority. Suggests /idea or /write-prd if the item appears feature-sized. Use when user runs /backlog-add or wants to capture something for later.
---

# Backlog Add

Add a new item to the global or project backlog. Grills it lightly first to ensure it's well-defined before it's written. Prevents vague entries from accumulating.

## Process

### 1. Determine Destination

Ask: "Add to **global** backlog or a **project** backlog?"

- **Global** → `~/.claude/backlog.md`
- **Project** → build project list from `~/.claude/priorities.md` and PI plan, human selects

### 2. Capture Initial Description

If the user provided a description inline (e.g. `/backlog-add Fix the login redirect`), confirm it:
> "Got it — '{description}'. Let me ask a couple of quick questions before adding it."

If no description provided, ask: "What's the item?"

### 3. Lightweight Grill

Three questions only, one at a time:

**Q1: What exactly needs to happen?**
Prompt for a clear, actionable description. Push back on vague answers:
- "Fix stuff" → "What specifically needs fixing?"
- "Improve performance" → "Which part, and what does improvement look like?"

**Q2: Why does this matter?**
One sentence on the impact or reason. Helps with future prioritisation.

**Q3: What priority is this — P1 Critical, P2 High, P3 Normal, or P4 Low?**
Recommend a priority based on the answers so far. Human confirms or overrides.

### 4. Size Assessment

After the grill, assess whether the item is:

- **Task/fix** — small, self-contained, belongs in backlog as-is
- **Discussion** — a topic to revisit, belongs in backlog as-is
- **Feature-sized** — substantial enough to warrant `/idea` or `/write-prd`

If feature-sized, suggest before adding:
> "This sounds like it could be a full feature. Want to run `/user:idea` to properly scope it, or add it to the backlog as a placeholder for now?"

Human chooses — never force the promotion.

### 5. Confirm and Write

Present the finalised entry for confirmation:

```
Ready to add:

Backlog: [Global / Project name]
Item: [description]
Why: [reason]
Priority: P[N]
Date: YYYY-MM-DD

Type CONFIRM to add, or provide corrections.
```

On CONFIRM, write to the appropriate file.

## Global Backlog Entry Format

Append to `~/.claude/backlog.md` under the correct priority section:

```markdown
- [ ] [P[N]] [Description] — [Why it matters] · Added YYYY-MM-DD
```

## Project Backlog Entry Format

Append to the project's `docs/kanban.md` Backlog section:

```markdown
- [ ] [AFK] #N [Description] · P[N] · Added YYYY-MM-DD
```

Assign the next available ticket number. Tag as `[AFK]` by default — the human can change to `[HITL]` if needed.

## Rules

- Always grill before writing — never add without at minimum Q1 and Q3 answered
- Never write without CONFIRM
- If the global `backlog.md` doesn't exist, create it with the entry as the first item
- If the project kanban doesn't exist, stop and suggest `/user:onboard` first
- Suggest promotion to `/idea` or `/write-prd` only when the item is clearly feature-sized — not for every item

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No active projects found | "No active projects found. Add one via `/user:create-project` or `/user:onboard`." |
| Project kanban not found | "kanban.md not found for [project]. Run `/user:onboard` to scaffold Forge first." |
| Global backlog missing | Create `~/.claude/backlog.md` and add the entry as the first item. |
| User provides no meaningful answer to Q1 | "I need a clearer description to add this — what specifically needs to happen?" Prompt once more, then stop if still unclear. |
