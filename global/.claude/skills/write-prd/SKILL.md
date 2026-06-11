---
name: write-prd
category: pipeline
version: 2.0.0
description: Synthesize the current conversation, grill session, research, and prototype findings into a structured PRD. Executes in two phases — AFK explore then HITL write — with a confirmation gate between them. Use when user runs /write-prd or when grill-me confirms shared understanding is reached.
---

# Write PRD

Synthesize everything known into a structured PRD. Runs in two phases with a mandatory confirmation gate. The user runs `/user:write-prd` once — the skill manages both phases internally.

---

## Phase 1 — AFK Explore

Runs unattended. Gathers all context needed to write the PRD without asking the user anything.

### Phase 1 Process

1. Read `docs/CONTEXT.md` — domain glossary and terminology.
2. Read grill session summary from the current conversation or `docs/DEVLOG.md`.
3. Read any `docs/research/*.md` files relevant to this feature.
4. Read `/prototype/LOGIC.md` and `/prototype/UI.md` if they exist.
5. Explore the codebase — understand current structure, existing patterns, and what will need to change.
6. Identify the major modules to build or modify. Look for:
   - Deep modules: simple interfaces, rich internals, independently testable
   - Existing modules that need extension vs new modules to create
   - Layer boundaries: what is UI, DATA, LOGIC, SYNC, INFRA
7. Produce a **Phase 1 Summary** and pause for human confirmation.

### Phase 1 Summary Format

```markdown
## PRD Explore Summary — [Feature Name]

### Source Material Read
- [List of files read]

### Codebase State
[Brief description of relevant existing code]

### Proposed Modules
| Module | Type | Action |
|--------|------|--------|
| [name] | [UI/DATA/LOGIC/SYNC/INFRA] | New / Extend / Modify |

### Scope Boundary
**In:** [What will be built]
**Out:** [What will not be built]

### Open Questions
[Anything that needs human input before writing the PRD]

---
Confirm this scope to proceed to Phase 2, or provide corrections.
```

---

## Phase 2 — HITL Write

Runs after human confirms Phase 1 summary. Writes the PRD and cleans up.

### Phase 2 Process

1. Incorporate any corrections from the human's Phase 1 confirmation.
2. Check `~/.claude/knowledge/company/style-guide.md` — if populated, apply its tone, terminology, and formatting standards when writing the PRD. If it is a placeholder, proceed without it.
3. Write the PRD using the template below.
3. **Generate per-module estimates** — for each module identified in Phase 1:
   - Estimate AI token cost band (S/M/L/XL) and story points (1/2/3/5/8/13)
   - Present as a table for human confirmation before writing to the PRD:
     ```
     ## Module Estimates — [Feature Name]

     | Module | Token Cost | Story Points | Reasoning |
     |--------|-----------|-------------|-----------|
     | [Module A] | M (20–80k) | 5 | [one sentence] |
     | [Module B] | S (<20k) | 2 | [one sentence] |
     | [Module C] | L (80–200k) | 8 | [one sentence] |
     | **Total** | **L** | **15pts** | |

     ⚠️ XL items: [none / Module X requires /break-down before /build]

     Confirm or adjust before I write the PRD.
     ```
   - On confirmation, add estimates to Implementation Decisions section and PRD header
   - Add story points to stakeholder label for PI planning (token bands internal only)
   - Flag any XL modules — they require `/break-down` before `/build` can execute them
4. Save to `docs/prd/active/[feature-name].md`.
5. Add Phase 2 kanban tickets to `docs/kanban.md` with estimate tags:
   ```
   - [ ] [AFK]  #N   Explore codebase for PRD — write-prd phase 1
   - [x] [HITL] #N+1 Confirm module list and write PRD — write-prd phase 2
   ```
6. Clean up `/prototype` folder if it exists.
7. Suggest next steps in order:
   - Run `/testplan` to design the testing strategy before implementation begins
   - Then move to the Kanban stage to convert the PRD task list into tracked tickets

---

## PRD Template

```markdown
# PRD: [Feature Name]

**Date:** YYYY-MM-DD
**Status:** Active
**Sprint:** Sprint-NN (or "Not sprint-tracked")
**PI:** PI-N [Name] (or "Not PI-tracked")
**Target Release:** PI-N-RN (or "Standalone" or "Not assigned")
**Author:** [Human name or "Forge"]

**Stakeholder Label:** [External-facing feature name for stakeholder communication]
**Delivery Type:** Iterative | Fixed Scope | Fixed Deadline | Fixed Both
**Priority:** P1 Critical | P2 High | P3 Normal | P4 Low
**Due Date (Internal):** YYYY-MM-DD (or "None")
**Due Date (External):** YYYY-MM-DD (or "None")
**Estimate (AI Token Cost):** S | M | L | XL (or "Not estimated")
**Estimate (Story Points):** N pts (or "Not estimated")
**Estimate Status:** Current | Stale | Not estimated
**Last estimated:** YYYY-MM-DD

---

## Problem Statement

[The problem from the user's perspective. What pain exists today?]

## Solution

[The solution from the user's perspective. What will exist when this is done?]

## User Stories

1. As a [role], I want [capability], so that [outcome].
2. As a [role], I want [capability], so that [outcome].
[Be exhaustive. Cover happy paths, edge cases, error states, and admin flows.]

## Implementation Decisions

- [Module or architectural decision]
- [Interface contract or API shape]
- [Schema changes]
- [Technical clarifications]

Do NOT include specific file paths or code snippets — these go stale quickly.

## Task List

### HITL Tasks (Human-in-the-Loop)
Tasks that require a human to be present.

- [ ] [HITL] #1 [Task description]

### AFK Tasks (Away from Keyboard)
Tasks the AI agent can execute autonomously.

- [ ] [AFK] #2 [Task description] `blocked-by: #1`

## Testing Decisions

- What makes a good test for this feature (test external behaviour, not implementation details)
- Which modules will have tests written
- Any prior art in the codebase to reference

## Definition of Done

- [ ] All tasks on the Kanban board marked complete
- [ ] All HITL tasks signed off by human
- [ ] Tests passing
- [ ] README updated if user-facing behaviour changed
- [ ] `/approve` issued by human after QA

## Out of Scope

[Explicitly list what is NOT being built in this PRD.]

## Further Notes

[Anything else relevant — links, references, open questions for later.]
```

---

## Rules

- Never write the PRD without Phase 1 confirmation — the gate is mandatory.
- Never ask the user questions during Phase 1 — gather, then present.
- If Phase 1 uncovers a significant unknown that blocks scoping, surface it in Open Questions and wait.
- Do not clean up `/prototype` until Phase 2 is complete and confirmed.
- The `Sprint:` field in the PRD must be filled — check `~/.claude/sprints/calendar.md` for the current sprint.

## Idea Diagram Update

If an idea in `~/.claude/ideas/active/` is linked to this project:

After Phase 2 is complete and PRD is written:
1. Read `~/.claude/ideas/active/[idea-name]/diagram.mmd`
2. Update to reflect the confirmed scope, modules, and implementation decisions from the PRD
3. Save updated version as `diagram.mmd` (current)
4. Save snapshot as `diagram-v3-prd.mmd`
5. Update the diagram version history table in `idea.md`

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No grill session summary found | Note it. Proceed using current conversation context only. Flag in PRD: "No prior grill session — scope may need validation via `/critic`." |
| `CONTEXT.md` missing | Note it. Proceed — flag any terms used in PRD that should be added to CONTEXT.md. |
| Active PRD already exists | Stop. "An active PRD already exists at docs/prd/active/. Complete or archive it before writing a new one." |
| Phase 1 exploration finds no relevant codebase | Note "Codebase appears empty or not yet scaffolded." Proceed with a greenfield assumption — state it explicitly. |
| Sprint field cannot be determined | Set to "Not sprint-tracked" and flag for human to update. |
| Estimate confirmation not given | Do not write PRD until estimates are confirmed — prompt once more. |
