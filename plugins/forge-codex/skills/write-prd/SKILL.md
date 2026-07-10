---
name: "write-prd"
description: "Synthesize the current conversation, grill session, research, and prototype findings into a structured PRD aligned with ISO/IEC/IEEE 29148:2018. Executes in two phases — AFK explore then HITL write — with a confirmation gate between them. Use when user runs $write-prd or when grill-me confirms shared understanding is reached."
metadata:
  category: pipeline
  version: 2.1.1
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Write PRD

Synthesize everything known into a structured PRD. Runs in two phases with a mandatory confirmation gate. The user runs `write-prd` once — the skill manages both phases internally.

---

## Phase 1 — AFK Explore

Runs unattended. Gathers all context needed to write the PRD without asking the user anything.

### Phase 1 Process

1. Read `docs/CONTEXT.md` — domain glossary and terminology.
2. Read grill session summary from the current conversation or `docs/DEVLOG.md`.
3. Read any `docs/research/*.md` files relevant to this feature.
4. Read `$prototype/LOGIC.md` and `$prototype/UI.md` if they exist.
5. Read the BRD if one exists (`docs/brd/`) — capture the business objectives this feature must trace up to. If absent, note it; PRD requirements will trace to their proximate input (grill / research / prototype) instead.
6. **Tag provenance as you extract.** For every need or capability you identify, record its source (BRD objective ID, grill-session decision, `docs/research/*.md §`, prototype finding, or named stakeholder). This feeds the upstream Origin column of the traceability matrix in Phase 2 — capture it now rather than reconstructing it later.
7. Explore the codebase — understand current structure, existing patterns, and what will need to change.
8. Identify the major modules to build or modify. Look for:
   - Deep modules: simple interfaces, rich internals, independently testable
   - Existing modules that need extension vs new modules to create
   - Layer boundaries: what is UI, DATA, LOGIC, SYNC, INFRA
9. Produce a **Phase 1 Summary** and pause for human confirmation.

### Phase 1 Summary Format

```markdown
## PRD Explore Summary — [Feature Name]

### Source Material Read
- [List of files read, including the BRD if found]

### BRD Objectives (origin of scope)
| BRD Objective ID | Business need | Covered by this PRD? |
|------------------|---------------|----------------------|
| [BRD-NN or "no BRD found"] | [need] | Yes / Partial / N/A |

### Extracted Needs by Source (provenance)
| Need / capability | Source | Proposed story |
|-------------------|--------|----------------|
| [need] | [BRD-NN / grill / research § / prototype / stakeholder] | [PRD-NNN] |

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
2. Check `~/.codex/forge/knowledge/company/style-guide.md` — if populated, apply its tone, terminology, and formatting standards when writing the PRD. If it is a placeholder, proceed without it.
3. Write the PRD using the template below. **Enforce the requirements-quality gates before finalising:**
   - **Success Metrics present** — at least one measurable metric (Metric / Baseline / Target / Measurement), with one marked **primary**. If none genuinely apply, write `Success Metrics: none — [reason]` explicitly; never omit the section.
   - **Every user story has ≥1 acceptance criterion** — block finalisation if any story has none. Warn (do not block) if a story has only a happy-path criterion with no edge or error case.
   - **Every story has a stable ID** (`PRD-NNN`) and traces to a source in the matrix.
   Each requirement should meet the ISO/IEC/IEEE 29148:2018 characteristics — necessary, unambiguous, singular, verifiable, feasible. Rewrite vague requirements ("fast", "intuitive") into testable form or flag them.
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

     ⚠️ XL items: [none / Module X requires $break-down before $build]

     Confirm or adjust before I write the PRD.
     ```
   - On confirmation, add estimates to Implementation Decisions section and PRD header
   - Add story points to stakeholder label for PI planning (token bands internal only)
   - Flag any XL modules — they require `$break-down` before `$build` can execute them
4. Save to `docs/prd/active/[feature-name].md`.
5. Add Phase 2 kanban tickets to `docs/kanban.md` with estimate tags:
   ```
   - [ ] [AFK]  #N   Explore codebase for PRD — write-prd phase 1
   - [x] [HITL] #N+1 Confirm module list and write PRD — write-prd phase 2
   ```
6. Preserve, then clean up `$prototype` if it exists. Do **not** delete the spike outright — first commit it to a throwaway branch `prototype/[feature-name]` so the exploration survives as primary-source evidence (Principle 8), and record a pointer to that branch in the PRD's Implementation Decisions section. Only then remove `$prototype` from the working tree. If a git branch can't be created (e.g. not a git repo), leave `$prototype` in place and note it — never destroy the only copy.
7. Suggest next steps in order:
   - Run `$testplan` to design the testing strategy before implementation begins — this also **back-fills the `TBD` Test column** in the PRD's Traceability Matrix.
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

## Success Metrics

[Measurable targets that define success. Mark one as primary; others are secondary/guardrail (must not regress). If none genuinely apply, write "none — [reason]".]

| Metric | Baseline | Target | Measurement method | Type |
|--------|----------|--------|--------------------|------|
| [e.g. checkout abandonment] | [23%] | [≤ 14%] | [funnel analytics, 30-day] | Primary |
| [e.g. checkout errors] | [0.4%] | [no regression] | [error telemetry] | Guardrail |

## Users & Stakeholders

[Each actor referenced in a story below. May be a user segment, job title/role, or stakeholder.]

| Actor | Description | Type |
|-------|-------------|------|
| [e.g. Returning shopper] | [one line: who they are, what they need] | Primary |
| [e.g. Compliance officer] | [one line] | Stakeholder |

## User Stories & Acceptance Criteria

Each story keeps the canonical form and carries a stable ID and at least one acceptance criterion. Keep stories at capability granularity; push detail into the criteria. Cover happy path + key edge case + error state.

**PRD-001 — [short title]**
As a [role], I want [capability], so that [outcome].
- **Given** [context] **When** [action] **Then** [observable, testable outcome]
- **Given** [edge/error context] **When** [action] **Then** [outcome]

**PRD-002 — [short title]**
As a [role], I want [capability], so that [outcome].
- **Given** … **When** … **Then** …

[IDs are flat and sequential — `PRD-001`, `PRD-002`, … assigned in order of first appearance; they do not encode the story's theme. A bulleted testable checklist is an accepted lighter alternative to Given/When/Then, provided each item is observable and testable. IDs are retired when a story is dropped — never reused.]

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
- [ ] `$approve` issued by human after QA

## Out of Scope

[Explicitly list what is NOT being built in this PRD.]

## Assumptions & Dependencies

**Assumptions:** [What must hold true for this PRD to be valid. "None" if empty.]

**Dependencies:** [What this depends on. Cite the companion ORD for non-functional behaviour rather than restating it — e.g. "availability, encryption, PCI scope defined in [System] ORD §3.3". "None" if empty.]

## Further Notes

[Anything else relevant — links, references, open questions for later.]

## Appendix: Traceability Matrix

Full-chain, bidirectional. Spans BRD → PRD → ORD. The Test column is scaffolded `TBD` and back-filled when `$testplan` runs.

| BRD Objective | Proximate Source | PRD Req ID | Acceptance Criteria (summary) | Test | ORD NFR Ref |
|---------------|------------------|------------|-------------------------------|------|-------------|
| [BRD-NN or —] | [grill / research § / prototype / stakeholder] | [PRD-NNN] | [one line] | [TBD / T-NN] | [ORD-NNN / —] |

- A story with no BRD objective and no proximate source is **orphan scope** — flag it.
- A BRD objective with no resulting story is a **coverage gap** — flag it.
```

---

## Rules

- Never write the PRD without Phase 1 confirmation — the gate is mandatory.
- Never ask the user questions during Phase 1 — gather, then present.
- Never finalise a PRD with an empty Success Metrics section — require at least one measurable metric, or an explicit `none — [reason]`.
- Never finalise a PRD with a user story that has no acceptance criterion.
- Never write a requirement in unverifiable form ("fast", "intuitive", "robust") — quantify it or flag it as `[TBD — needs measurable criterion]`.
- Never reuse a retired story ID — retire and move on.
- Never restate non-functional requirements that belong in the ORD — cite the ORD section instead (reference, don't duplicate).
- If Phase 1 uncovers a significant unknown that blocks scoping, surface it in Open Questions and wait.
- Do not clean up `$prototype` until Phase 2 is complete and confirmed — and never before it is preserved on its `prototype/[feature-name]` throwaway branch with a pointer recorded in the PRD.
- The `Sprint:` field in the PRD must be filled — check `~/.codex/forge/sprints/calendar.md` for the current sprint.

## Idea Diagram Update

If an idea in `~/.codex/forge/ideas/active/` is linked to this project:

After Phase 2 is complete and PRD is written:
1. Read `~/.codex/forge/ideas/active/[idea-name]/diagram.mmd`
2. Update to reflect the confirmed scope, modules, and implementation decisions from the PRD
3. Save updated version as `diagram.mmd` (current)
4. Save snapshot as `diagram-v3-prd.mmd`
5. Update the diagram version history table in `idea.md`

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No grill session summary found | Note it. Proceed using current conversation context only. Flag in PRD: "No prior grill session — scope may need validation via `$critic`." |
| `CONTEXT.md` missing | Note it. Proceed — flag any terms used in PRD that should be added to CONTEXT.md. |
| No BRD found | Note "No BRD found." Proceed — trace each story to its proximate source (grill / research / prototype / stakeholder) in the matrix instead of a BRD objective. |
| Feature has no measurable success metric | Do not silently omit. Write `Success Metrics: none — [reason]` and flag for the human to confirm the feature is genuinely unmeasurable. |
| A user story has no acceptance criterion | Block finalisation. Prompt for criteria; do not write the PRD until every story has at least one. |
| A BRD objective produces no story, or a story has no source | Flag in the Traceability Matrix as a coverage gap (orphaned objective) or orphan scope (sourceless story). Do not silently resolve. |
| Active PRD already exists | Stop. "An active PRD already exists at docs/prd/active/. Complete or archive it before writing a new one." |
| Phase 1 exploration finds no relevant codebase | Note "Codebase appears empty or not yet scaffolded." Proceed with a greenfield assumption — state it explicitly. |
| Sprint field cannot be determined | Set to "Not sprint-tracked" and flag for human to update. |
| Estimate confirmation not given | Do not write PRD until estimates are confirmed — prompt once more. |
