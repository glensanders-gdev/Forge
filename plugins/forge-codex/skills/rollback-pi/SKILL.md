---
name: "rollback-pi"
description: "Roll back all projects in the current PI release in reverse deploy order (last deployed first). Stops on any project rollback failure. Each project requires individual ROLLBACK [version] confirmation. Use when user runs $rollback-pi or a full PI deployment needs to be reversed."
metadata:
  category: pi-release
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Rollback PI

Roll back all projects in the current PI release in reverse deploy order. Designed for emergency recovery of a full PI deployment. Stops on any failure — partial rollbacks are potentially more dangerous than the original failed deployment.

## When to Use

- A full PI deployment (`$deploy-pi`) has failed or introduced critical bugs
- Multiple projects need to be rolled back in a coordinated way
- User explicitly runs `rollback-pi`
- `$deploy-pi` failure handling offers `ROLLBACK` as an option

## Pre-Flight Checks

### 1. Identify Current PI Release

Read `~/.codex/forge/pi/[current-pi]/plan.md` — confirm which release is being rolled back.

### 2. Build Reverse Deployment Sequence

Read each project's `.codex/forge/deploy.md` — extract `deploy-order`. Sort in **descending** order (highest deploy-order first = last deployed first).

```
Rollback sequence (reverse deploy order):
3. [project-name] — last deployed
2. [project-name]
1. [project-name] — first deployed, last to roll back
```

### 3. Validate Rollback Commands

Check each project's `.codex/forge/deploy.md` for a rollback command. If any project is missing one:
```
⚠️ Missing rollback command

The following projects have no rollback command configured:
- [project-name]

Without a rollback command, these projects cannot be rolled back automatically.
Manual intervention will be required for them.

Type CONTINUE to proceed with the projects that have rollback commands.
Type STOP to cancel and configure rollback commands first.
```

### 4. Capture Reason (Once)

```
Reason for rollback (required — one sentence, applies to all projects):
```

Record this reason in every project's deploy log entry.

### 5. Present Full Rollback Plan

```
## PI Rollback Plan — PI-N-RN

Reason: [reason]

Rollback sequence (reverse deploy order):
1. [project-name] → rolling back to [last good version] — deployed [date]
2. [project-name] → rolling back to [last good version] — deployed [date]
3. [project-name] → rolling back to [last good version] — deployed [date]

Each project requires individual ROLLBACK [version] confirmation.
Type BEGIN to start the rollback sequence, or STOP to cancel.
```

---

## Execution Loop

For each project in reverse deploy order:

### Per-Project Rollback

Present last known good version from that project's `docs/releases/deploy-log.md`:

```
## Rolling Back [N/Total] — [project-name]

Current version: [latest deployed]
Last known good: [version] — deployed [date]

Type ROLLBACK [version] to confirm, or specify a different version.
```

Wait for `ROLLBACK [version]` before executing.

1. Run rollback command from `.codex/forge/deploy.md`
2. Run health check if configured
3. Log to `docs/releases/deploy-log.md`

On success:
```
✅ [project-name] — Rolled back to [version]
Health: ✅ Healthy | ⚠️ Not configured
Proceeding to next project...
```

### On Any Failure

Stop the entire sequence immediately:

```
❌ Rollback Sequence Halted — [project-name] failed

Error: [error or health check status]
Projects rolled back successfully: [list]
Projects NOT yet rolled back: [list]

⚠️ Production is in a mixed state.
Do NOT attempt further automated rollbacks.

Manual intervention required for remaining projects:
- [project-name]: version [X] still live
- [project-name]: version [X] still live

Type DIAGNOSE to investigate this project's rollback failure.
```

Wait for human. Never auto-proceed.

---

## Full Success

```
✅ PI Rollback Complete — PI-N-RN

Projects rolled back:
1. ✅ [project-name] → [version] — [HH:MM]
2. ✅ [project-name] → [version] — [HH:MM]
3. ✅ [project-name] → [version] — [HH:MM]

All health checks: ✅ Healthy
Reason: [reason]

Next steps:
1. Run diagnose to investigate the failed deployment
2. Fix the issue and re-run deploy-pi when ready
3. Consider running update-readme to note the rollback in version history
```

---

## Deploy Log Entry (Per Project)

Append to each project's `docs/releases/deploy-log.md`:

```markdown
## ⏪ Rollback — YYYY-MM-DD HH:MM

**Rolled back to:** [version]
**From version:** [failed version]
**Triggered by:** $rollback-pi (PI-N-RN sequence)
**Sequence position:** N of N (reverse order)
**Status:** ✅ Success | ❌ Failed

**Health check:** ✅ Healthy (200) | ❌ Failed ([status]) | ⚠️ Not configured
**Reason:** [reason]
**Duration:** Xs
```

---

## PI Plan Update

Update `~/.codex/forge/pi/[current-pi]/plan.md`:

**Full success** — all projects rolled back:
```markdown
| R[N] | ... | ⚠️ Rolled back — YYYY-MM-DD |
```

**Partial success** — some projects rolled back, some not:
```markdown
| R[N] | ... | ⚠️ Partially rolled back — YYYY-MM-DD |
```

Update each project's release entry individually:
- Rolled back: `⏪ Rolled back to [version] — [date]`
- Still on failed version: `❌ Rollback failed — manual intervention required`
- Not yet attempted: `⏳ Rollback pending`

---

## Rules

- Execute in reverse deploy order — never forward order
- Reason is mandatory and captured once — applies to all projects
- Each project requires individual `ROLLBACK [version]` confirmation
- Stop entirely on any failure — never skip and continue
- Never chain automated rollbacks — one attempt per project, then escalate
- Log every rollback attempt individually per project
- PI plan must reflect actual state accurately — never mark as fully rolled back if partial
- If a project has no rollback command, exclude it from the sequence and flag for manual intervention

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No active PI plan | Stop. "No active PI plan found. Cannot determine rollback sequence." |
| No projects with deploy.md | Stop. "No projects have deploy configuration." |
| deploy-order conflicts | Alert. Cannot determine reverse sequence. Ask human to resolve. |
| No deploy-log.md for a project | Note it. Ask human to specify version manually for that project. |
| Mixed rollback success/failure | Stop sequence. Update PI plan to reflect mixed state accurately. |
| All projects missing rollback commands | Stop. Provide manual rollback guidance for each platform. |
