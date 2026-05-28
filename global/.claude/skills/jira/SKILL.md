---
name: jira
description: Interact with Jira tickets — fetch and analyse, post comments, transition status, or run JQL searches. Run /jira setup on first use. Requires Jira MCP server or JIRA_URL/JIRA_EMAIL/JIRA_API_TOKEN env vars.
origin: Adapted from Affaan Mustafa (ECC / github.com/affaan-m/ECC)
---

# Jira

Live Jira API integration — fetch, analyse, comment, transition, and search Jira tickets without leaving Claude Code.

Companion: `/link-jira` records the Forge→Jira ID mapping locally. For first-time credential setup, run `/jira setup`.

---

## Authentication

**Auth check — runs before every subcommand:**

1. If MCP server `jira` is configured and responding → use it.
2. Else if `JIRA_URL`, `JIRA_EMAIL`, and `JIRA_API_TOKEN` are all set → use REST API.
3. Else → stop and direct the user to run `/jira setup`.

**Option A — MCP server (recommended):** Add a Jira MCP server to Claude Code's MCP config. Run `/jira setup` for guided setup.

**Option B — Environment variables:**
```
JIRA_URL=https://yourorg.atlassian.net
JIRA_EMAIL=your.email@example.com
JIRA_API_TOKEN=your-api-token
```
Never hardcode credentials — use env vars or a secrets manager.

---

## Subcommand Routing

Run the auth check above. Then, based on the subcommand, read the corresponding file in `~/.claude/skills/jira/` and follow its instructions:

| Subcommand | File | Mode |
|------------|------|------|
| `/jira get <KEY>` | `get.md` | AFK |
| `/jira comment <KEY>` | `comment.md` | HITL |
| `/jira transition <KEY>` | `transition.md` | HITL |
| `/jira search <JQL>` | `search.md` | AFK |
| `/jira setup` | `setup.md` | HITL |

---

## Forge Integration Points

| Skill | How `/jira` integrates |
|-------|------------------------|
| `/link-jira` | Companion — record the Forge→Jira ID mapping after `/jira get` |
| `/sprintplan` | Feed `/jira get` output (requirements, AC) into sprint planning |
| `/sprint-start` | Call `/jira transition` to move tickets to In Progress when sprint begins |
| `/sprint-end` | Call `/jira transition` to move completed tickets to Done; `/jira comment` to post a summary |
| `/standup` | Call `/jira comment` to post standup notes back to the active ticket |
| `/tdd` | After `/jira get`, the structured AC and test scenarios feed directly into TDD |
| `/review` | Run `/review` before `/jira comment` — post the review outcome to the ticket |

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No credentials configured | Stop and direct user to `/jira setup` — never guess or skip |
| MCP server not responding | Fall back to env var REST API if set; otherwise stop with clear error |
| Rate limited (429) | Wait and report — do not retry in a tight loop |

---

## Rules

- Never store credentials in source files, kanban, or DEVLOG — env vars or MCP only
- Never auto-update `docs/kanban.md` after a transition — always ask first
- Never retry a failed API call automatically — report the error and wait for guidance
- The `get` analysis is a reading aid, not a commitment — the human decides what to build

---

## Attribution

Adapted from Affaan Mustafa (ECC / [github.com/affaan-m/ECC](https://github.com/affaan-m/ECC/blob/main/commands/jira.md))
