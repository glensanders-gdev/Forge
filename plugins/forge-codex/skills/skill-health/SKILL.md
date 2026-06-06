---
name: "skill-health"
description: "Audit the Forge for Codex plugin\u0027s skills, manifest, metadata, hooks, attribution, and upstream compatibility. Use for plugin maintenance or after an update."
metadata:
  category: framework
  origin: Adapted from Affaan Mustafa (ECC / github.com/affaan-m/ECC) and Glen Sanders (Forge)
---

# Skill Health

Run a read-only structural audit of the installed Forge plugin.

## Checks

- `.codex-plugin/plugin.json` is valid.
- Every directory under `skills/` has a `SKILL.md`.
- Every skill has `name`, `description`, and `origin` frontmatter.
- Skill names are unique.
- `hooks/hooks.json` and referenced scripts exist.
- Bundled hook commands contain no machine-specific absolute paths.
- `references/adaptation-build.json` records an upstream commit.
- No adapted file contains active `.claude/`, `CLAUDE.md`, or `/user:` instructions.
- Compatibility-sensitive skills document their Codex behavior.
- The upstream manifest has no unreviewed additions or removals.

Save the report to `~/.codex/forge/knowledge/skill-health-report.md` only after confirming the destination. Otherwise report inline.

## Rules

- Never modify files during the audit.
- Never require Claude command stubs.
- Never treat Forge's upstream manifest as the Codex plugin manifest.
