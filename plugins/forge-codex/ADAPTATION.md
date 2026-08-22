# Codex Adaptation

## Source And Parity

- Canonical shared source: `global/.claude/`
- Codex generated output: `plugins/forge-codex/`
- Shared framework version: `3.18.0`
- Adapted shared skills: `109` (plus 2 Codex-only routing skills)

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
| Text fenced `no-adapt` | left exactly as upstream wrote it |
| Claude hooks | Codex `hooks/hooks.json` |

## Substitution Exemptions

The conversions above run unconditionally over every adapted file. They are correct where the source means *the host* generically, and wrong where it names Claude Code as a distinct product — a sentence such as "Claude Code ships a built-in `/review`" is true upstream and false here once rewritten.

Source text may therefore be fenced with a `no-adapt` marker pair (`<!--` `no-adapt` `-->` … `<!--` `/no-adapt` `-->`). A fenced span is withheld from every substitution and restored verbatim, and the markers themselves are stripped, so the generated file carries the upstream wording with no marker left behind. Fences wrap a phrase or a block.

This is why `references/CHANGELOG.md` still names Claude Code, Claude Desktop, and `~/.claude/` paths in places. Those entries are a historical record of what shipped on a named host; adapting them would misattribute Claude Code's built-in command namespace and data directory to Codex.

`tools/build-forge-codex.ps1` fails on an unbalanced fence, and `tools/test-forge-parity.ps1` fails if a marker survives into `skills/` or `references/` — either means the file was not adapted and its host-specific claims are unverified.

## Compatibility Classes

### Directly adapted

The planning, delivery, QA, release, knowledge, reporting, and maintenance skills are instruction-driven and portable. This includes `raid`, `ia`, `qa-report`, `front-gate`, `continue`, `test-coverage`, `seo`, `incident`, `pir`, and the original Forge lifecycle.

### Codex-native overrides

- `install-forge`: install the plugin from a marketplace; do not create Claude junctions.
- `update-forge`: update the marketplace/plugin source; do not run upstream `install.sh`.
- `init-forge`: generate concise `~/.codex/AGENTS.md` guidance and keep Forge data separate.
- `skill-health`: audit plugin skills and Codex metadata instead of Claude command stubs.
- `lang-rules`: use nested `AGENTS.md` files for coding guidance; Codex rules are command policies.
- `write-a-skill` and `assimilate`: author Forge source under `global/.claude/`, generate the plugin, and use `.agents/skills/` for Codex-only skills.
- `update-company`: update the Codex marketplace/plugin instead of copying skills into Forge data directories.
- `jira`: resolve bundled subcommand references relative to the installed skill.
- `debrief`, `end-sprint`, and `token-report`: never use Claude-only `ccusage`; accept exact Codex evidence or mark usage unavailable.

### Delegation preferred

- `security-assessment` and `resolve-findings` remain Forge governance workflows, but should delegate repository scanning and finding validation to the Codex Security plugin when available.
- Jira, Confluence, GitHub, and other live systems should use installed MCP servers or app connectors. Never invent an unavailable integration.

## Known Limitations

- Bulk-adapted prose may still describe upstream operating assumptions that require human judgment.
- The bundled hook is path-independent. Its hook commands are self-contained so the plugin can be installed at different paths on different devices.
- Upstream standalone `codex-review`, `grill-me-codex`, and `grill-with-docs-codex` tools are not bundled. In Codex, prefer explicit parallel read-only subagents for adversarial review.
- Forge data is not automatically initialized. Run `$init-forge` or `$onboard`.
