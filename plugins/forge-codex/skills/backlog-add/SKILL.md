---
name: "backlog-add"
description: "Add a well-defined item to the global or a project backlog. Grills the item lightly before adding — what it is, why it matters, priority. Recognises three types — task/fix, discussion, and opportunity (a spotted gap or enhancement worth considering later). Suggests $idea or $write-prd if the item appears feature-sized. Use when user runs $backlog-add or wants to capture something for later."
metadata:
  category: session
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Backlog Add

Add a new item to the global or project backlog. Grills it lightly first to ensure it's well-defined before it's written. Prevents vague entries from accumulating.

## Process

### 1. Determine Destination

Ask: "Add to **global** backlog or a **project** backlog?"

- **Global** → `~/.codex/forge/backlog.md`
- **Project** → build project list from `~/.codex/forge/priorities.md` and PI plan, human selects

### 2. Capture Initial Description

If the user provided a description inline (e.g. `$backlog-add Fix the login redirect`), confirm it:
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
- **Opportunity** — a spotted gap or enhancement a developer noticed; worth holding for consideration but not yet ready for full `$idea` scoping
- **Feature-sized** — substantial enough to warrant `$idea` or `$write-prd`

If **opportunity**, ask one additional question before writing:

**Q4: What's the risk of not addressing this?**
One sentence — helps with future triage. Examples: "Technical debt will compound", "Users will keep hitting this friction", "No known risk — just a nice-to-have."

Then ask:
> "Should this also be logged as a RAID risk (risk of inaction)? (yes/no)"
- If yes and `docs/raid/` exists: run `$raid add risk` pre-populated with the opportunity description and Source `MANUAL`.
- If yes and no RAID log exists: note "No RAID log found — run `$raid init` to set one up. Skipping RAID entry."

If **feature-sized**, suggest before adding:
> "This sounds like it could be a full feature. Want to run `idea` to properly scope it, or add it to the backlog as a placeholder for now?"

Human chooses — never force the promotion.

### 5. Confirm and Write

Present the finalised entry for confirmation:

```
Ready to add:

Backlog: [Global / Project name]
Type: [Task/fix | Discussion | Opportunity]
Item: [description]
Why: [reason]
Risk of inaction: [one sentence — opportunities only, omit for task/fix and discussion]
Priority: P[N]
Date: YYYY-MM-DD

Type CONFIRM to add, or provide corrections.
```

On CONFIRM, write to the appropriate file.

## Global Backlog Entry Format

Append to `~/.codex/forge/backlog.md` under the correct priority section:

**Task/fix or Discussion:**
```markdown
- [ ] [P[N]] [Description] — [Why it matters] · Added YYYY-MM-DD
```

**Opportunity:**
```markdown
- [ ] [P[N]] 💡 [Description] — [Why it matters] · Risk: [risk of inaction] · Added YYYY-MM-DD
```

## Project Backlog Entry Format

Append to the project's `docs/kanban.md` Backlog section:

**Task/fix or Discussion:**
```markdown
- [ ] [AFK] #N [Description] · P[N] · Added YYYY-MM-DD
```

**Opportunity:**
```markdown
- [ ] [AFK] #N 💡 [Description] · P[N] · Risk: [risk of inaction] · Added YYYY-MM-DD
```

Assign the next available ticket number. Tag as `[AFK]` by default — the human can change to `[HITL]` if needed.

The `💡` prefix makes opportunities visually distinct and greppable in both the global backlog and project kanban.

## Rules

- Always grill before writing — never add without at minimum Q1 and Q3 answered
- For opportunities, Q4 (risk of inaction) is required — do not skip it
- Never write without CONFIRM
- If the global `backlog.md` doesn't exist, create it with the entry as the first item
- If the project kanban doesn't exist, stop and suggest `onboard` first
- Suggest promotion to `$idea` or `$write-prd` only when the item is clearly feature-sized — not for every item
- Opportunities are holding entries — they are not commitments. Promote to `$idea` when the team is ready to scope them properly.

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No active projects found | "No active projects found. Add one via `create-project` or `onboard`." |
| Project kanban not found | "kanban.md not found for [project]. Run `onboard` to scaffold Forge first." |
| Global backlog missing | Create `~/.codex/forge/backlog.md` and add the entry as the first item. |
| User provides no meaningful answer to Q1 | "I need a clearer description to add this — what specifically needs to happen?" Prompt once more, then stop if still unclear. |
| Opportunity with no RAID log and user wants RAID entry | Note: "No RAID log found for this context. Run `$raid init` to set one up, then `$raid add risk` manually." |
