---
name: to-tickets
category: pipeline
version: 1.0.0
description: Convert a plan, PRD, spec, or conversation into a set of vertical-slice kanban tickets — each a tracer bullet sized to the smart zone, with genuine blocking edges and HITL/AFK tags. Quizzes the human on granularity before writing to docs/kanban.md. Use when a plan is agreed and needs turning into tracked, buildable tickets.
origin: Adapted from Matt Pocock (AIHero.dev / github.com/mattpocock/skills)
---

# To Tickets

Turn an agreed plan into a set of **vertical-slice tickets** ready for `/build`. Each ticket is a *tracer bullet* — a narrow but complete path through every layer, sized to one focused agent run, independently demoable once its blockers clear. This is the "Kanban stage" that `/write-prd` hands off to.

Execution mode: **[HITL]** — drafting is autonomous, but the human confirms the breakdown before anything is written to `docs/kanban.md`.

> Adapted from Matt Pocock's `to-tickets` skill (github.com/mattpocock/skills). Forge keeps the vertical-slice/tracer-bullet discipline, the quiz-before-publish loop, minimal genuine blocking edges, and expand–contract for wide refactors; it swaps the `.scratch/`-file and GitHub-issue trackers for Forge's `docs/kanban.md`, maps "one context window" to the **smart zone (<100k tokens)**, and delegates oversized slices to `/break-down` and external export to `/jira`.

## Pipeline Position

```
/write-prd → /to-tickets → /build
```

Input: a PRD (`docs/prd/active/`), a plan, a spec, a conversation thread, or an issue reference. Output: dependency-ordered tickets in `docs/kanban.md`.

## Process

1. **Gather context** — read the active PRD and its task/module list, the conversation, and any referenced spec or issue. Read `docs/CONTEXT.md` (domain glossary) and `docs/adr/` so ticket language and structure respect the project's vocabulary and decisions.
2. **Explore the codebase** (if unfamiliar) — map the current state to size slices realistically. Spot *prefactoring*: if a refactor makes the feature simpler, ticket it first — "make the change easy, then make the easy change."
3. **Draft vertical slices** — break the work into tracer bullets (see Ticket Shape). Each cuts a narrow, **complete** path through all layers and is independently demoable. Add **genuine** blocking edges only — a ticket depends on another solely when it truly gates it. Tag each `[HITL]`/`[AFK]`. Layer tags (`[UI]`/`[DATA]`/`[LOGIC]`/`[SYNC]`/`[INFRA]`) are **annotations, not split axes** — never carve the work into horizontal layers.
4. **Handle wide refactors with expand–contract** — never force a broad refactor into one tracer bullet. Add the new form (expand), migrate call sites in batches (one ticket each, CI green after each), then delete the old form (contract). Share an integration branch only if the batches can't each stay green alone.
5. **Quiz the human** — present the numbered draft (title · blocked-by · deliverable per ticket) and ask: right granularity? any false or missing blocking edges? merge or split anything? Iterate until confirmed. **Never write to kanban before approval.**
6. **Publish to `docs/kanban.md`** — write the tickets in dependency order (blockers first), one discrete kanban entry each, with `blocked-by: #N` notation. Assign sequential ticket numbers continuing the board.
7. **Hand off** — suggest `/build`. If a slice still exceeds the smart zone, run `/break-down` on it; for sizing bands use `/estimate`; to export the set to an external tracker use `/jira`.

## Ticket Shape

A good ticket has:

- **Title** — short, in the project's domain vocabulary.
- **What to build** — the end-to-end, user-facing behaviour. **Never** a layer-by-layer implementation list.
- **Blocked by** — `#N` (or "None — can start immediately"). Minimal, genuine edges; prefer linear chains.
- **Acceptance criteria** — 2–5 checkboxes, behavioural.
- **Tags** — `[HITL]`/`[AFK]`, optional layer annotation, sized to fit **one focused agent run** (<100k tokens).
- **Independently demoable** — verifiable on its own once blockers complete.

## Output Format

Present the draft for approval first, then write to `docs/kanban.md`:

```markdown
## To Tickets: [Feature] — draft for approval

1. [AFK] Persist a booking to the store  — blocked-by: none — deliverable: a booking survives a reload
2. [AFK] Show bookings on the calendar    — blocked-by: #1 — deliverable: saved bookings render
3. [HITL] Confirm the cancellation policy — blocked-by: #2 — deliverable: policy copy signed off

Granularity ok? Any blocking edges wrong? Merge/split anything?
```

On confirmation, each becomes a kanban entry:

```markdown
- [ ] [AFK] #N Persist a booking to the store `[DATA]`
      What: a booking a user creates survives a page reload.
      - [ ] Booking is written to the store on submit
      - [ ] Reloading the page shows the booking
- [ ] [AFK] #N+1 Show bookings on the calendar `[UI]` `blocked-by: #N`
      ...
```

## Forge Integration Points

- **`/write-prd`** hands off here — its task/module list is this skill's primary input (fills the "Kanban stage" it points to).
- **`/build`** consumes the tickets in dependency order; **`/tdd`** already enforces the same vertical-slice rule at build time.
- **`/break-down`** is the fallback when a single slice still exceeds the smart zone.
- **`/estimate`** provides the S/M/L/XL bands; **`/jira`** / **`/link-jira`** export to an external tracker.

## Rules

- Never write to `docs/kanban.md` before the human approves the breakdown.
- Never produce horizontal/layer slices as the unit of work — vertical tracer bullets only; layer tags are annotations.
- Never invent false blocking edges — a ticket blocks another only when it genuinely gates it.
- Never write "What to build" as a layer-by-layer list — describe end-to-end user behaviour.
- Never force a wide refactor into a tracer bullet — use expand–contract, one batch per ticket, CI green after each.
- Never bundle multiple tickets into one entry — each is a discrete, independently demoable kanban ticket.
- Never embed stale file paths in a ticket description — the exception is a decision-rich prototype snippet (state machine, reducer, schema, type shape).
- Never modify the source PRD, plan, or issue — this skill reads it and produces tickets, nothing more.

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No PRD/plan/spec found | Ask the human to point to the source (PRD path, issue, or a described plan) — never invent scope. |
| No `docs/kanban.md` | Say a board is needed first — run `/sprint-start` to open one, then re-run. |
| A drafted slice exceeds the smart zone | Split it further or run `/break-down` before publishing — every ticket must fit one focused run. |
| The work is a wide refactor | Sequence it as expand–contract batches, not a single tracer bullet. |
| Blocking edges form a deep/tangled graph | Flag it, prefer linear chains, and re-check each edge is genuine before publishing. |
| Human hasn't approved the draft | Do not write to kanban — iterate on the quiz until confirmed. |
| No domain glossary or ADRs exist | Proceed from the plan and codebase; note that ticket vocabulary wasn't checked against CONTEXT.md/ADRs. |
