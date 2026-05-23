---
name: rollback
description: Roll back the current project to the last known good version or a specified version tag. No Go/No Go gate — emergency recovery action. Requires explicit ROLLBACK [version] confirmation and a mandatory reason. Use when user runs /rollback, a deployment has failed, or production needs immediate recovery.
---

# Rollback

Roll back the current project to a previously known good state. Designed for emergency recovery — no ceremony, no Go/No Go gate. Explicit confirmation and a mandatory reason are still required.

## When to Use

- A deployment has failed and production is degraded
- A bug was introduced in the latest release
- User explicitly runs `/user:rollback`
- `/deploy` failure handling offers `ROLLBACK` as an option

## Pre-Flight Checks

### 1. Read Deploy Config

Read `.claude/deploy.md` — extract rollback command.

If no rollback command defined:
```
⛔ No rollback command configured in .claude/deploy.md.

Manual rollback required. Refer to your hosting platform's documentation.

Platform detected: [platform from deploy.md]
Last known good version: [version from deploy-log.md]
```
Stop — provide platform-specific manual guidance and do not proceed.

### 2. Identify Last Known Good Version

Read `docs/releases/deploy-log.md` — find the most recent entry with status `✅ Success`.

```
## Rollback — [Project Name]

Current production version: [latest deployed version or unknown]
Last known good version:    [version] — deployed [date] at [time]

Available versions (last 5 deployments):
  ✅ [version] — [date] — Success
  ❌ [version] — [date] — Failed
  ✅ [version] — [date] — Success
  ...
```

### 3. Confirm Rollback Target

Ask the human to confirm:
```
Roll back to [last known good version]?
Or specify a different version tag (e.g. v1.2.0).

Type the version to confirm target, or press Enter to use [last known good version].
```

### 4. Capture Reason

```
Reason for rollback (required — one sentence):
```

Do not proceed until a reason is provided. Record it in the deploy log.

### 5. Final Confirmation

```
⚠️  Rollback Confirmation

Project:  [project name]
Rolling back to: [version]
Reason: [reason]

This will replace the current production deployment.

Type ROLLBACK [version] to confirm, or anything else to cancel.
```

Wait for exact `ROLLBACK [version]` match before executing.

---

## Execution

1. Run rollback command from `.claude/deploy.md`
2. Wait for completion
3. Run health check if URL configured in `.claude/deploy.md`

---

## Success

```
✅ Rollback Complete — [Project Name]

Now live: [version]
Health check: ✅ Healthy | ⚠️ Not configured
Time: YYYY-MM-DD HH:MM
Reason recorded: [reason]

Next steps:
1. Run /user:diagnose to investigate the failed deployment
   (I can pass the failure details as context — type DIAGNOSE to begin)
2. Fix the issue and re-run /user:deploy when ready
```

If human types `DIAGNOSE`, pre-populate the diagnose session with:
- Failed version: [version]
- Error from deploy log: [error message]
- Health check result: [status]
- Deployment timestamp: [time]

---

## Failure

If rollback command fails or health check fails:

```
❌ Rollback Failed — [Project Name]

Version attempted: [version]
Error: [error or health check status]

Do NOT attempt another automated rollback — you may compound the issue.
Manual intervention required.

Platform: [platform]
Manual rollback steps: [platform-specific guidance from deploy.md]
```

Stop. Never chain rollbacks automatically.

---

## Deploy Log Entry

Append to `docs/releases/deploy-log.md`:

```markdown
## ⏪ Rollback — YYYY-MM-DD HH:MM

**Rolled back to:** [version]
**From version:** [failed version]
**Triggered by:** /rollback
**PI Release:** PI-N-RN
**Status:** ✅ Success | ❌ Failed

**Health check:** ✅ Healthy (200) | ❌ Failed ([status]) | ⚠️ Not configured
**Reason:** [mandatory reason]
**Duration:** Xs
```

---

## PI Plan Update

Update `~/.claude/pi/[current-pi]/plan.md` — mark the affected release:

```markdown
| R[N] | [Month] | [date] | [Go/No Go date] | ⚠️ Rolled back — YYYY-MM-DD |
```

---

## Rules

- Never execute without explicit `ROLLBACK [version]` confirmation
- Reason is mandatory — do not proceed without it
- No Go/No Go gate — this is emergency recovery
- Never chain rollbacks — one attempt, then stop and escalate to manual
- Always run health check after rollback if configured
- Log every rollback attempt — success and failure
- If rollback command is missing, stop and provide manual guidance — never guess

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No rollback command in deploy.md | Stop. Provide manual platform-specific steps. |
| No deploy-log.md found | "No deployment history found. You will need to specify a version manually." Ask for version tag. |
| No successful deployment in log | "No successful deployment found to roll back to." Provide manual guidance. |
| Health check fails after rollback | Alert. State what version is now live (may be broken). Do not auto-retry. |
| Human provides no reason | Prompt once more. If still blank, ask: "A reason is required for audit purposes. Please provide one sentence." |
