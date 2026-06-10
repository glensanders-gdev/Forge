---
name: "company-add"
description: "Configure company-specific Forge data, policies, cadence, compliance, and external integrations under ~/.codex/forge/companies. Use when setting up Forge for an organization."
metadata:
  category: company
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Company Add

Create company configuration as user-owned Forge data. Do not copy plugin skills or create Claude-oriented command stubs.

## Quick Mode

When invoked with `--quick`, propose defaults for sprint length, release cadence, compliance tier, approval gates, AI policy, and tools policy. Show the complete proposal and wait for confirmation before writing.

## Full Process

1. Normalize the company name and check `~/.codex/forge/companies/[name]/`.
2. If it exists, stop and ask whether to update it.
3. Grill one topic at a time:
   - sprint and release cadence
   - team locations and public holidays
   - freeze periods
   - compliance tier and frameworks
   - external approval gates
   - deployment environments
   - AI usage and data restrictions
   - approved tools and integrations
4. Present a consolidated configuration draft.
5. On confirmation, create:
   - `~/.codex/forge/companies/[name]/config.md`
   - `knowledge/`, `projects/`, `rules/`, and `tools.md`
6. Set `active_company` in `~/.codex/forge/preferences.md` after confirmation.
7. Use `$forge-init` to propose any global `AGENTS.md` policy overlay.

## External Systems

Use installed MCP servers or app connectors for Jira, Confluence, GitHub, and other live systems. Record configuration references, never secrets.

## Rules

- Never store company secrets or credentials in Forge files.
- Never copy plugin skills into company data directories.
- Never modify `~/.codex/AGENTS.md` without showing the exact proposed change.
- Never commit company data to the upstream Forge repository.
