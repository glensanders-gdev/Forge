Invoke the deploy skill. Deploy the current project to staging and/or production. Requires a confirmed Go/No Go. Executes deployment scripts from .claude/deploy.md directly, runbook fallback if not configured. Supports version tag for rollback. On failure: stop, alert, offer ROLLBACK / INVESTIGATE / STOP — never auto-rollback.

Skill: global/.claude/skills/deploy/SKILL.md
