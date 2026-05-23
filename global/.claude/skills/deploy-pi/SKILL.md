---
name: deploy-pi
description: Deploy all projects in the current PI release in configured sequence. Requires a confirmed Go/No Go. Confirms each project succeeds before proceeding to the next. Updates PI plan and stakeholder view on full success. Use when user runs /deploy-pi for a full PI release deployment.
---

# Deploy PI

Deploy all projects in the current PI release in the order defined by their `deploy-order` field in `.claude/deploy.md`. A single project failure stops the entire sequence — the human decides how to proceed.

## Pre-Flight Checks

### 1. Identify Current PI Release

Read `~/.claude/pi/[current-pi]/plan.md` — identify the release being deployed (R1, R2, or R3).

### 2. Build Deployment Sequence

For each active project in the PI:
- Read `.claude/deploy.md`
- Extract `deploy-order` field
- Sort projects by `deploy-order` (ascending — lowest first)

If any project has no `.claude/deploy.md`:
```
⚠️ Missing deploy configuration

The following projects have no deploy.md:
- [project-name]

Resolve before running /deploy-pi, or exclude them from this release.
Type EXCLUDE to skip them, or STOP to cancel.
```

### 3. Verify Go/No Go Gate (All Projects)

Read `docs/releases/PI-N-RN-gono.md` — must show `GO`.
If missing or `NO-GO` for any project: stop entirely.

### 4. Present Deployment Plan

```
## PI Deployment Plan — PI-N-RN

Release: PI-N Release N
Go/No Go: ✅ Confirmed [date]

Deployment sequence:
1. [project-name] — [platform] — [staging → production | production only]
2. [project-name] — [platform] — [production only]
3. [project-name] — [platform] — [staging → production]

Health checks: [configured / not configured] per project

Type CONFIRM to begin the deployment sequence.
```

---

## Execution Loop

For each project in sequence:

### Project Deployment

```
## Deploying [N/Total] — [project-name]

Version: [version]
Platform: [platform]
```

Run the same staged deployment as `/deploy`:
1. Staging (if configured) → health check → `PROMOTE`
2. Production → health check
3. Log to `docs/releases/deploy-log.md`

On success:
```
✅ [project-name] — Deployed successfully
Health: ✅ Healthy
Proceeding to next project...
```

### On Any Failure

Stop the sequence immediately:

```
❌ Deployment Sequence Halted — [project-name] failed

Stage: [Staging | Production]
Error: [error or health check status]
Projects deployed successfully: [list]
Projects not yet deployed: [list]

Options:
- Type ROLLBACK [project-name] to rollback this project
- Type INVESTIGATE to diagnose before acting
- Type RESUME to retry this project and continue (after manual fix)
- Type STOP to halt and handle manually

Do NOT proceed to remaining projects until this is resolved.
```

Wait for human decision. Never auto-proceed after failure.

---

## Full Success

When all projects deploy successfully:

```
✅ PI Deployment Complete — PI-N-RN

Projects deployed:
1. ✅ [project-name] — [version] — [HH:MM]
2. ✅ [project-name] — [version] — [HH:MM]
3. ✅ [project-name] — [version] — [HH:MM]

Total duration: Xm Xs
```

### Automatic PI Plan Update

Update each project's entry in `~/.claude/pi/[current-pi]/plan.md` individually, regardless of outcome:

- Successfully deployed: `✅ Deployed — YYYY-MM-DD HH:MM`
- Failed deployment: `❌ Deployment failed — manual intervention required`
- Not yet attempted (if sequence stopped early): `⏳ Deployment pending`

Then update the release-level status:

**All projects successful:**
```markdown
| R[N] | ... | ✅ Deployed — YYYY-MM-DD |
```

**Partial success (some failed or pending):**
```markdown
| R[N] | ... | ⚠️ Partially deployed — YYYY-MM-DD — manual intervention required |
```

Never mark a release as fully deployed if any project failed or was not attempted. The PI plan must reflect the exact production state at all times.

---

## Deploy Log

Each project appends to its own `docs/releases/deploy-log.md`:

```markdown
## Deployment — YYYY-MM-DD HH:MM

**Version:** [version]
**Environment:** Production
**Triggered by:** /deploy-pi (PI-N-RN sequence)
**PI Release:** PI-N-RN
**Sequence position:** N of N
**Status:** ✅ Success | ❌ Failed

**Health check:** ✅ Healthy (200) | ❌ Failed ([status]) | ⚠️ Not configured
**Duration:** Xs
```

---

### Stakeholder View Update

**Full success only:** Update `~/.claude/pi/[current-pi]/stakeholder.md` — mark all deployed features as `✅ Delivered — [date]`.

**Partial success:** Do NOT update `stakeholder.md` automatically. Present a draft to the human:
```
⚠️ Partial deployment — stakeholder view requires review.

Some projects deployed successfully, others did not.
Here is a proposed stakeholder update — confirm before writing:

[draft showing delivered and pending features]

Type CONFIRM to update stakeholder.md, or SKIP to leave unchanged.
```

---

## Rules

- Never deploy without a confirmed Go/No Go for the release
- Never auto-proceed after any project failure — human decides
- Never auto-rollback — always alert and wait
- Staging must succeed before production if configured
- On full success, update PI plan entries and stakeholder view automatically
- On partial success, update PI plan entries individually — never mark release as fully deployed
- On partial success, present stakeholder draft for human confirmation before writing
- Log every project's deployment attempt individually

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No active PI plan | Stop. "No active PI plan found. Run `/user:piplan` first." |
| No projects with deploy.md | Stop. "No projects have deploy configuration." |
| deploy-order conflicts (two projects same number) | Alert. Ask human to resolve before proceeding. |
| Go/No Go missing for release | Stop. Direct to `/user:go-nogo`. |
| Partial failure mid-sequence | Stop sequence. Surface succeeded/failed/pending lists clearly. |
| PI plan update fails after success | Note the failure. Provide manual update instructions. |
