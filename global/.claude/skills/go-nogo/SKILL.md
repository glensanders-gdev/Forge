---
name: go-nogo
category: pi-release
description: Prepare and execute the Go/No Go release gate for a monthly release. AI prepares the brief, human decides, result is saved formally. Use when user runs /go-nogo, a Go/No Go date is approaching, or standup flags a Go/No Go is due within 5 days.
---

# Go / No Go

Prepare the Go/No Go brief for an upcoming monthly release. The AI assembles all relevant information — the human makes the call.

## Trigger Conditions

- User runs `/user:go-nogo` explicitly
- `/standup` flags a Go/No Go is due within 5 days
- The configured release day is approaching (typically 2 days before the deployment date — read from PI plan and company config `release_day`)

## Process

**Step 0 — Resolve active company:** Read `~/.claude/preferences.md`. If `active-company:` is set, use that value in place of `[active_company]` throughout this run. If not set, skip all company-config reads and apply defaults.

1. **Read company config** — read `~/.claude/companies/[active_company]/config.md` (if set) for:
   - `freeze_periods` — check if the deployment date falls within or near a freeze window
   - `compliance_tier` — determines whether security assessment is advisory or required
   - `external_approval_required` / `external_approval_name` — adds an approval gate step if set
   - `freeze_warning_days_ahead` — how early to start warning (default 14 days)
   - `release_cadence` — determines expected release timing (end-of-sprint / monthly / quarterly / on-demand)
   - `release_day` — the configured release day for monthly/quarterly cadences (e.g. "last Friday of the month")
2. **Identify the release** — read `~/.claude/pi/[current-pi]/plan.md` to confirm which release is gating.
2. **Read each active project's kanban** — identify:
   - Tickets completed for this release
   - Tickets incomplete (still In Progress or Blocked)
   - Any P1 bugs or critical issues open
3. **Read sprint records** — `docs/sprints/sprint-NN.md` for sessions in this release cycle.
3a. **Read RAID risks** — read `docs/raid/RISKS.md` for each active project (if the file exists):
   - Surface any `Open` or `In Progress` risks with `Impact: High` under **Open High Risks** in the brief.
   - A risk with `Impact: High` AND `Probability: High` and status `Open` is a soft block — note it and require explicit human acknowledgment before recording GO.
4. **Read `docs/known-issues.md` for each project** — include Active issues in the brief. Deferred issues are noted but don't block Go/No Go unless their impact is Critical.
5. **Assess deployment readiness** — check buffer window has been respected (no new features after buffer start).
6. **Produce the Go/No Go brief.**
7. **Save to** `docs/releases/PI-N-RN-gono.md`.
8. **Present to human** and ask: "Type GO to approve this release, or NO-GO to defer."
9. **Record the decision** in the brief and update `~/.claude/pi/[current-pi]/plan.md`.

## Go/No Go Brief Format

See `FORMATS.md` in this skill directory for the brief template.

Save to `docs/releases/PI-N-RN-gono.md`.

## If NO-GO

When human types `NO-GO`:
1. Ask: "Which features should be carried forward to the next release?"
2. Update `~/.claude/pi/[current-pi]/plan.md` — move deferred features to next release
3. Update `stakeholder.md` — reflect the change
4. Update each project's `docs/kanban.md` — flag carry-forward tickets
5. Note in DEVLOG: "Release PI-N-RN deferred — [reason]"
6. Suggest next steps:
   ```
   Release PI-N-RN — NO-GO recorded.

   Suggested next steps:
   - Run /user:diagnose to investigate any blocking bugs
   - Run /user:sprint-replan to adjust scope for the remaining buffer window
   - Run /user:go-nogo again when issues are resolved
   ```

## If GO

When human types `GO`:
1. Record decision in brief
2. Update release status in `~/.claude/pi/[current-pi]/plan.md` to `Approved`
3. Remind human:
   ```
   Deployment is [deployment date from PI plan].

   Suggested pre-deploy steps:
   - Run /changelog to generate release notes before /deploy
   - Run /user:standalone-release if any urgent fixes are needed before then.
   ```

## Freeze Period Check

After identifying the deployment date, check company config `freeze_periods`:

- If the deployment date falls **within** a `no-deploy` freeze window:
  ```
  🚫 FREEZE PERIOD: [reason] — [window]
     This deployment falls within a no-deploy window.
     Proceeding to GO would violate company policy.
     Recommend NO-GO and rescheduling after [end date].
  ```
  Include as a P1 risk. AI recommendation must be NO-GO.

- If the deployment date falls **within** a `warn-only` freeze window:
  ```
  ⚠️ FREEZE PERIOD (advisory): [reason] — [window]
     Deployment is within a restricted window. Human decision required.
  ```
  Include as High risk. Does not force NO-GO recommendation.

- If within `freeze_warning_days_ahead` days of a freeze window start:
  ```
  ⚠️ Upcoming freeze: [reason] begins [date] ([N days away]).
     Consider whether this release timeline is appropriate.
  ```

If no company config or no freeze periods configured, skip this check silently.

---

## External Approval Gate

If `external_approval_required: true` in company config, add the following
section to the brief after Risk Assessment:

```markdown
## External Approval

**Approval type:** [external_approval_name]
**Scope:** [external_approval_scope]
**System:** [external_approval_url — or "Not recorded"]

- [ ] [external_approval_name] approval obtained before deployment

```

When the human types GO, ask: "Has [external_approval_name] approval been obtained?
Record the approval reference or confirm verbally. (reference / confirmed)"
Capture the response and append to the brief's Decision section.

---

## Security Assessment Check

Before producing the brief, read `security-assessment-last-run` from `~/.claude/preferences.md`
and `compliance_tier` from company config.

| Compliance tier | Overdue threshold | Behaviour |
|----------------|------------------|-----------|
| none / standard | 30 days | Advisory warning — does not force NO-GO |
| regulated | 30 days | Required — recommend NO-GO if overdue |
| highly-regulated | 14 days | Required — recommend NO-GO if overdue; must be formally accepted |

If overdue, include in the Risk Assessment table and surface at the top of the brief:
```
⚠️ Security assessment overdue (last run: N days ago / never).
   [Compliance tier: regulated/highly-regulated → this is required, not advisory.]
```

---

## Rules

- Never recommend GO if there are incomplete P1 tickets
- Never auto-decide — the human must type GO or NO-GO explicitly
- The brief must be saved before the decision is recorded
- A NO-GO does not cancel the release date — it defers features, not the deployment window

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No active PI plan found | Stop. "No active PI plan found at ~/.claude/pi/. Run `/piplan` to create one before running Go/No Go." |
| No release date found for current sprint | Stop. "Cannot determine release date. Check ~/.claude/pi/[pi]/plan.md and confirm the release calendar." |
| release_cadence = end-of-sprint and no sprint calendar found | Stop. "Release cadence is end-of-sprint but no sprint calendar found at ~/.claude/sprints/calendar.md. Run /sprint-start to set up the sprint calendar before running Go/No Go." |
| `kanban.md` missing for a project | Note the project as "kanban unavailable — status unknown" in the brief. Flag as risk. |
| No active PRD for a feature | Note feature as "PRD unavailable — cannot assess completion" in the brief. Flag as risk. |
| Brief cannot be saved (no `docs/releases/` folder) | Create the folder and save. Note it was created. |
