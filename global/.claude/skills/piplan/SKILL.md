---
name: piplan
description: Create or update a Product Iteration plan spanning 3 monthly releases and 6 sprints. Generates consolidated cross-project and stakeholder-facing views. Use when user runs /piplan, a new PI is starting, or features need to be assigned to releases.
---

# PI Plan

Create or update a Product Iteration (PI) plan. A PI spans one quarter — 3 monthly releases, 6 sprints, with Go/No Go gates and deployment dates derived from the 3rd Sunday convention.

## When to Use

- Starting a new PI — generate the full plan
- Adding a feature to an existing PI — update incrementally
- Reviewing what's planned across all projects this PI
- Producing a stakeholder update

## Process

### Creating a New PI

1. Ask the user:
   - PI name and number (e.g. `PI-1 Q1 2026`)
   - Start date (derive sprint and release dates automatically)
   - Which projects are active this PI
   - PI objectives (1–3 high-level goals)

2. **Derive dates automatically:**
   - Release dates: 3rd Sunday of each month in the PI
   - Go/No Go: Friday 5pm before each release Sunday
   - Buffer: last 3 days of Sprint 2, 4, 6 before each release
   - Sprints: 2-week blocks, aligned to release cycle

3. **Assign features** — read `~/.claude/priorities.md` and active PRDs across all projects:
   - Map each feature to a target release based on priority and due dates
   - Flag any Fixed Deadline features at risk of missing their target release
   - Present the proposed feature-to-release mapping for confirmation

4. **Write files:**
   - `~/.claude/pi/PI-N-[name]/plan.md` — full PI plan
   - `~/.claude/pi/PI-N-[name]/stakeholder.md` — external-facing view
   - Update `~/.claude/sprints/calendar.md` with sprint dates

5. **Update sprint-start** — add PI reference to the sprint calendar entries.

### Updating an Existing PI

1. Read `~/.claude/pi/[current-pi]/plan.md`
2. Identify what has changed — new features, carry-forwards, date changes
3. Present proposed updates for confirmation
4. Update `plan.md` and `stakeholder.md` in place
5. Never overwrite a Go/No Go record or carry-forward history

## Deployment Date Convention

```
3rd Monday of each month = deployment date
Friday before = Go/No Go (5pm cutoff)
Friday–Sunday before = buffer window (no new features after Friday)
Sprint start = Tuesday of each sprint
```

Auto-calculate from PI start month:
- R1: 3rd Monday of Month 1
- R2: 3rd Monday of Month 2
- R3: 3rd Monday of Month 3

## Standalone Releases

When adding a standalone release to the PI:
- Verify it is not within 1 week of a monthly release (unless marked Critical)
- Verify it falls on a weekday (flag if weekend, ask for confirmation)
- Add to the Standalone Releases section of `plan.md`
- Add to the Express Releases section of `stakeholder.md`

## Risk Flags

At any PI plan update, surface:
- Features with Fixed Deadline delivery type where deadline < release date
- Releases with more features than typical sprint capacity
- Carry-forwards that push a feature past its external due date

## Rules

- Never regenerate the full PI plan after initial creation — update in place
- Always confirm feature-to-release mapping before writing
- Stakeholder view uses Stakeholder Labels only — never internal PRD names
- Go/No Go dates are fixed once set — flag if anything would require changing them
