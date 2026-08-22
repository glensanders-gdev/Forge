---
name: "skill-health"
description: "Audit the Forge for Codex plugin's skills, manifest, metadata, hooks, attribution, and upstream compatibility. Use for plugin maintenance or after an update."
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
- Every skill's `name` frontmatter equals the directory it sits in, compared as a literal string with no case, hyphen, or underscore normalisation. A skill that declares a different name registers under the declared name or not at all, and reports nothing, so report a mismatch as critical. Name the directory, the frontmatter and the manifest entry together — whichever one is in the minority is the one to correct.
- Skill names are unique.
- No skill name matches a Reserved row in `skills/write-a-skill/RESERVED-NAMES.md`. A shadowed name never loads and reports nothing, so report a match as critical and lead with it. The list covers Claude Code; Codex's own reserved surface has no equivalent list, so report a clear name as unchecked there rather than clear.
- The `RESERVED-NAMES.md` verification stamp carries a date and a version, and the date is within the staleness threshold.
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
- Never resolve a name mismatch by assuming the frontmatter is right — check what the directory and manifest agree on first.
- Never treat Forge's upstream manifest as the Codex plugin manifest.
