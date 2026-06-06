---
name: "forge-codex"
description: "Explain, initialize, and troubleshoot the Forge for Codex plugin. Use when the user asks how Forge maps to Codex, wants to start using the plugin, or needs help choosing the right Forge skill."
metadata:
  category: framework
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Forge for Codex

Orient the user to the Codex adaptation without modifying project files unless they ask to initialize or onboard.

## Process

1. Identify whether the user needs orientation, global initialization, project onboarding, or a specific workflow.
2. For orientation, summarize the Forge lifecycle and recommend the smallest relevant skill.
3. For global initialization, use `$forge-init`.
4. For an existing repository, use `$onboard`.
5. For a new initiative, start with `$idea` or `$front-gate`.
6. For the complete portfolio, use `$commands`.

## Codex Mapping

- Invoke workflows with `$skill-name`.
- Store Forge-owned global data under `~/.codex/forge/`.
- Store durable project instructions in `AGENTS.md`.
- Store project-specific reusable skills under `.agents/skills/`.
- Use plugins and MCP for external integrations.
- Use Codex Security for deep repository security scans when available.

## Rules

- Never claim a connector, MCP server, or plugin is available without checking.
- Never overwrite `AGENTS.md` without showing the proposed change first.
- Never bypass Forge production, approval, or rollback gates.
