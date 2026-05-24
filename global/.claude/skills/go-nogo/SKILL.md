---
name: go-nogo
description: Prepare and execute the Go/No Go release gate for a monthly release. AI prepares the brief, human decides, result is saved formally. Use when user runs /go-nogo, a Go/No Go date is approaching, or standup flags a Go/No Go is due within 5 days.
---

# Go / No Go

Prepare the Go/No Go brief for an upcoming monthly release. The AI assembles all relevant information — the human makes the call.

## Trigger Conditions

- User runs `/user:go-nogo` explicitly
- `/standup` flags a Go/No Go is due within 5 days
- It is Friday and a release is scheduled for Sunday

## Process

1. **Identify the release** — read `~/.claude/pi/[current-pi]/plan.md` to confirm which release is gating.
2. **Read each active project's kanban** — identify:
   - Tickets completed for this release
   - Tickets incomplete (still In Progress or Blocked)
   - Any P1 bugs or critical issues open
3. **Read sprint records** — `docs/sprints/sprint-NN.md` for sessions in this release cycle.
4. **Read `docs/known-issues.md` for each project** — include Active issues in the brief. Deferred issues are noted but don't block Go/No Go unless their impact is Critical.
5. **Assess deployment readiness** — check buffer window has been respected (no new features after buffer start).
6. **Produce the Go/No Go brief.**
7. **Save to** `docs/releases/PI-N-RN-gono.md`.
8. **Present to human** and ask: "Type GO to approve this release, or NO-GO to defer."
9. **Record the decision** in the brief and update `~/.claude/pi/[current-pi]/plan.md`.

## Go/No Go Brief Format

```markdown
# Go/No Go Brief: PI-N Release N

**Release:** PI-N-RN
**Deployment Date:** Monday DD MMM YYYY
**Brief Prepared:** Friday DD MMM YYYY
**Decision Required By:** 5:00pm today

---

## Release Summary

**Features included:**
| Feature | Stakeholder Label | Project | Status |
|---------|------------------|---------|--------|
| [name] | [label] | [repo] | ✅ Complete / ⚠️ Partial / ❌ Incomplete |

---

## Ticket Status

**Completed:** #N, #N, #N
**Incomplete:** #N [reason], #N [reason]
**Blocked:** #N [blocker]

---

## Risk Assessment

| Risk | Severity | Mitigation |
|------|----------|-----------|
| [risk] | High / Medium / Low | [mitigation] |

---

## Open Issues

| Issue | Severity | Recommendation |
|-------|----------|---------------|
| | | |

---

## Recommendation

**AI Recommendation:** GO / NO-GO
**Reason:** [one sentence]

---

## Decision

**Decision:** GO / NO-GO
**Decided by:** [Human name]
**Time:** HH:MM DD MMM YYYY
**Notes:** [any conditions or carry-forwards]
```

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
3. Remind human: "Deployment is Sunday DD MMM. Run `/user:standalone-release` if any urgent fixes are needed before then."

## Security Assessment Check

Before producing the brief, read `security-assessment-last-run` from `~/.claude/preferences.md`.
If more than 30 days ago (or missing), include in the Risk Assessment table:

```
| No recent security assessment | Medium | Run /security-assessment before deploying |
```

And surface an advisory note at the top of the brief:
```
⚠️ Security assessment overdue (last run: N days ago / never).
   Consider running /security-assessment before approving GO.
```

This is advisory — it does not force a NO-GO recommendation.

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
| `kanban.md` missing for a project | Note the project as "kanban unavailable — status unknown" in the brief. Flag as risk. |
| No active PRD for a feature | Note feature as "PRD unavailable — cannot assess completion" in the brief. Flag as risk. |
| Brief cannot be saved (no `docs/releases/` folder) | Create the folder and save. Note it was created. |
