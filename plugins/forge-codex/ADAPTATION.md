# Codex Adaptation

## Source And Parity

- Canonical shared source: `global/.claude/`
- Codex generated output: `plugins/forge-codex/`
- Shared framework version: `3.9.0`
- Adapted skills: `99`

Forge remains credited to Glen Sanders. Skills with an earlier upstream origin retain that attribution.

Claude and Codex share one Forge release line and changelog. Runtime-specific behavior is recorded here and in Codex-native override skills. Run `tools/build-forge-codex.ps1` after shared skill changes and `tools/test-forge-parity.ps1` before committing.

Codex-native overrides are tracked in `compatibility.json`. When a corresponding shared skill changes, parity fails until the override is reviewed and `tools/update-forge-codex-overrides.ps1 -ConfirmReview` is run explicitly.

## Codex Conventions

| Upstream Forge | Codex adaptation |
|---|---|
| `~/.claude/` framework and user data | `~/.codex/forge/` |
| `CLAUDE.md` | `AGENTS.md` |
| `.claude/skills/` | `.agents/skills/` or plugin skills |
| slash command `/skill` | explicit skill mention `$skill` |
| Claude command stubs | omitted |
| Claude hooks | Codex `hooks/hooks.json` |

## Compatibility Classes

### Directly adapted

The planning, delivery, QA, release, knowledge, reporting, and maintenance skills are instruction-driven and portable. This includes `raid`, `ia`, `qa-report`, `front-gate`, `continue`, `test-coverage`, `seo`, `incident`, `pir`, and the original Forge lifecycle.

### Codex-native overrides

- `forge-install`: install the plugin from a marketplace; do not create Claude junctions.
- `forge-update`: update the marketplace/plugin source; do not run upstream `install.sh`.
- `forge-init`: generate concise `~/.codex/AGENTS.md` guidance and keep Forge data separate.
- `skill-health`: audit plugin skills and Codex metadata instead of Claude command stubs.
- `lang-rules`: use nested `AGENTS.md` files for coding guidance; Codex rules are command policies.

### Delegation preferred

- `security-assessment` and `security-resolve` remain Forge governance workflows, but should delegate repository scanning and finding validation to the Codex Security plugin when available.
- Jira, Confluence, GitHub, and other live systems should use installed MCP servers or app connectors. Never invent an unavailable integration.

## Known Limitations

- Bulk-adapted prose may still describe upstream operating assumptions that require human judgment.
- The bundled hook is path-independent. Its hook commands are self-contained so the plugin can be installed at different paths on different devices.
- Upstream standalone `codex-review`, `grill-me-codex`, and `grill-with-docs-codex` tools are not bundled. In Codex, prefer explicit parallel read-only subagents for adversarial review.
- Forge data is not automatically initialized. Run `$forge-init` or `$onboard`.
