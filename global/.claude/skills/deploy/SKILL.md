---
name: deploy
category: pi-release
description: Deploy the current project to staging and/or production. Requires a confirmed Go/No Go. Executes deployment scripts directly if available, runbook fallback if not. Supports version tag override for rollback. Use when user runs /deploy or /deploy [version-tag].
---

# Deploy

Deploy the current project. Executes the deployment pipeline defined in `.claude/deploy.md`. Requires a confirmed Go/No Go before proceeding. Single project only — for full PI releases use `/user:deploy-pi`.

## Pre-Flight Checks

### 1. Read Deploy Config

Read `.claude/deploy.md` — extract:
- Staging config (if present)
- Production config
- Health check URL
- Rollback command

**Cross-check with company config** — read `~/.claude/companies/[active_company]/config.md` (if set):
- `deployment_chain` — compare to the environments in `.claude/deploy.md`. If the chains differ, flag:
  ```
  ⚠️ Deployment chain mismatch
  Company config: [deployment_chain]
  deploy.md:      [configured environments]
  Proceeding with deploy.md as the authoritative source. Update one to match the other.
  ```
- `deployment_manual_gates` — if set, add each gate as a mandatory HITL pause before the next environment (in addition to any gates already in deploy.md).

If no company config, skip cross-check silently.

If `.claude/deploy.md` is missing:
```
⛔ No deploy configuration found.

Create .claude/deploy.md before deploying. A template is available in the Forge project template.
```
Stop.

**Rollback command validation:** If no rollback command is defined in `.claude/deploy.md`, warn before proceeding:
```
⚠️ No rollback command configured.

If this deployment fails, rollback will require manual intervention.
It is strongly recommended to configure a rollback command in .claude/deploy.md before deploying.

Type PROCEED to continue without rollback capability, or STOP to configure it first.
```
Wait for `PROCEED` or `STOP` before continuing.

### 2. Determine Version

- **Default:** latest approved release (read from `docs/releases/PI-N-RN-gono.md`)
- **Override:** if user provided a version tag (`/deploy v1.2.0`), use that — treat as rollback

If rollback, confirm explicitly:
```
⏪ Rollback requested

You are about to deploy version [tag] — not the latest approved release.
Current production version: [version]
Rollback target: [tag]

Type ROLLBACK to confirm, or anything else to cancel.
```

### 3. Verify Go/No Go Gate

Read `docs/releases/PI-N-RN-gono.md`:
- If file missing → stop:
  ```
  ⛔ No Go/No Go record found for PI-N-RN.

  /user:go-nogo is a mandatory gate before deployment.
  Run it now to prepare the brief and record the GO decision,
  then re-run /user:deploy.
  ```
- If decision is `NO-GO` → stop: "Go/No Go decision was NO-GO on [date]. Deployment blocked. Run `/user:go-nogo` again to re-evaluate."
- If decision is `GO` → proceed

### 4. Present Deployment Plan

```
## Deployment Plan — [Project Name]

Version: [version / tag]
PI Release: PI-N-RN
Go/No Go: ✅ Confirmed [date]

Environments:
[Staging → Production] (if staging configured)
[Production only] (if no staging)

Health check: [URL or "not configured"]

Type CONFIRM to begin deployment.
```

---

## Execution

### Stage 1 — Staging (if configured)

1. Run staging deployment command
2. Wait for completion
3. Run health check if URL configured:
   - ✅ Healthy → continue
   - ❌ Unhealthy → alert and stop (see Failure Handling)
4. Present staging result:
   ```
   ✅ Staging deployment successful
   URL: [staging URL]
   Health: ✅ 200 OK

   Type PROMOTE to deploy to production, or STOP to leave on staging.
   ```
5. Wait for `PROMOTE` before continuing

### Stage 2 — Production

1. Run production deployment command
2. Wait for completion
3. Run health check if URL configured
4. Log to `docs/releases/deploy-log.md`

---

## Success

```
✅ Deployment Complete — [Project Name]

Version: [version]
Environment: Production
Health check: ✅ Healthy
Time: YYYY-MM-DD HH:MM

Deploy log updated: docs/releases/deploy-log.md
```

### PIR Prompt

Suggest: "Now that this feature is deployed, consider a Post Implementation Review: `/user:pir [PROJ-NNN]`. Did it achieve its stated goals in production?"

### Idea Diagram Update

If an idea in `~/.claude/ideas/active/` is linked to this project:
1. Read `~/.claude/ideas/active/[idea-name]/diagram.mmd`
2. Update to reflect the deployed state
3. Save as `diagram.mmd` (current) and `diagram-v5-deployed.mmd` (snapshot)
4. Update the diagram version history table in `idea.md`:
   ```
   | v5-deployed | Post deploy | YYYY-MM-DD | Production deployment confirmed |
   ```

---

## Failure Handling

On any deployment failure or failed health check:

```
❌ Deployment Failed — [Project Name]

Stage: [Staging | Production]
Error: [exact error message or health check status]
Last known good version: [version]

Options:
- Type ROLLBACK to deploy [last good version]
- Type INVESTIGATE to diagnose before acting
- Type STOP to leave as-is and handle manually
```

Wait for human decision. Never auto-rollback.

If `ROLLBACK`:
- Run rollback command from `.claude/deploy.md`
- Verify health check
- Log rollback to `docs/releases/deploy-log.md`

---

## Deploy Log Entry Format

Append to `docs/releases/deploy-log.md`:

```markdown
## Deployment — YYYY-MM-DD HH:MM

**Version:** [version]
**Environment:** Staging | Production
**Triggered by:** /deploy
**PI Release:** PI-N-RN
**Status:** ✅ Success | ❌ Failed | ⏪ Rollback

**Health check:** ✅ Healthy (200) | ❌ Failed ([status]) | ⚠️ Not configured
**Duration:** Xs

**Notes:** [any relevant notes]
```

---

## Runbook Fallback

If no deployment command is defined in `.claude/deploy.md`:

```
⚠️ No deployment command configured.

Here is the manual deployment runbook for [platform]:

[Platform-specific steps based on deploy.md platform field]

Confirm each step as you complete it:
- [ ] Step 1: [action]
- [ ] Step 2: [action]
- [ ] Step 3: [action]

Type DONE when all steps are complete.
```

After `DONE`, run health check if configured and log the deployment.

---

## Related

- `/go-nogo` — produces the **Go/No Go Gate** record this skill requires before deploying
- `/deploy-pi` — extends this skill for full PI releases (multiple projects)
- `/rollback` — reversal path if deployment fails
- `/sprintplan` — also references the Go/No Go Gate as a sprint planning check

## Rules

- Never deploy without a confirmed Go/No Go (`GO` decision in release record)
- Never auto-rollback — always alert and wait for human decision
- Staging must succeed before production if staging is configured
- Log every deployment attempt — success, failure, and rollback
- Health check failure is treated the same as deployment failure
- Rollback requires explicit `ROLLBACK` confirmation — never triggered automatically

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| `.claude/deploy.md` missing | Stop. Provide template instructions. |
| Go/No Go record missing | Stop. Direct to `/user:go-nogo`. |
| Go/No Go shows NO-GO | Stop. State decision and date. |
| Deployment command fails | Alert with error, offer ROLLBACK / INVESTIGATE / STOP |
| Health check fails | Alert, offer ROLLBACK / INVESTIGATE / STOP |
| Rollback command missing | Alert. Provide platform-specific manual rollback steps. |
| `deploy-log.md` missing | Create it and append the entry. |
