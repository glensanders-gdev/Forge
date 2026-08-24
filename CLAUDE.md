# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

Forge is a skill/workflow framework for Claude Code and Codex. It ships as:
- **Claude Code** — skills in `global/.claude/skills/`, commands in `global/.claude/commands/`
- **Codex plugin** — generated output committed to `plugins/forge-codex/`

`install.sh` symlinks `~/.claude/skills/`, `~/.claude/commands/`, and `~/.claude/rules/` directly into `global/.claude/`. Edits in `~/.claude/` are edits to this repo — no copy step.

## Key Commands

```bash
# Install (creates symlinks from ~/.claude/ into this repo)
bash install.sh

# Update after git pull
bash update.sh

# Regenerate Codex plugin after changing shared skills
./tools/build-forge-codex.ps1          # PowerShell / Windows

# Verify Codex plugin is not stale and Claude/Codex are in parity
./tools/test-forge-parity.ps1          # PowerShell / Windows

# Regenerate the standalone skills distribution (see below)
./tools/build-forge-standalone.ps1 -Strict   # PowerShell / Windows
```

**There are three build targets, and CI checks all three.** After changing a shared skill, run
the Codex build *and* the standalone build, and commit both `plugins/forge-codex/` and
`dist/forge-standalone/` alongside your change. A version bump alone is enough to make `dist/`
stale, because the release version is stamped into its README and manifest.

CI (`forge-parity.yml`) runs on every push/PR and fails if:
1. The Codex plugin output is stale (not committed after a shared skill change)
2. Claude and Codex skill parity checks fail
3. The standalone distribution is stale — CI runs `build-forge-standalone.ps1 -Strict` and fails
   if `dist/forge-standalone/` differs from the committed tree
4. The review-criteria extracts are stale — this one is expected to skip in CI, because the
   `requirements-documents` pack is held locally and is not in this repo. It runs for whoever
   holds the pack, who is the only party able to regenerate it.

## Architecture

```
global/.claude/         ← source of truth for all shared skills
  skills/               ← one folder per skill; each contains SKILL.md + assets
  commands/             ← one .md per skill, command entry points
  rules/common/         ← language-agnostic coding standards (always active)
  rules/[lang]/         ← language-specific rule sets, installed via /lang-rules
  manifest.json         ← version registry for all 113 skills
  SOUL.md               ← agent identity and behavioural constraints
  PRINCIPLES.md         ← design philosophy; read before writing a new skill

plugins/forge-codex/    ← generated Codex plugin (committed, do not edit manually)
dist/forge-standalone/  ← generated standalone distribution (committed, do not edit manually)
tools/
  build-forge-codex.ps1           ← generates plugins/forge-codex/ from global/.claude/
  build-forge-standalone.ps1      ← generates dist/forge-standalone/ from global/.claude/
  test-forge-parity.ps1           ← enforces Claude/Codex skill parity
  update-forge-codex-overrides.ps1 ← reviews Codex-native overrides when shared source changes
  build-review-criteria.py        ← regenerates review criteria from the local requirements pack

project-template/       ← scaffold copied into consumer projects (not used by Forge itself)
docs/                   ← Forge's own DEVLOG, kanban, and PRD history
```

## Skill Authoring Rules

Each skill lives at `global/.claude/skills/[skill-name]/SKILL.md`. Before writing or editing a skill, read `global/.claude/PRINCIPLES.md`. Key constraints:

- Every skill must declare a human gate (`[HITL]`) or autonomous mode (`[AFK]`) — never leave execution mode implicit
- Every skill must have explicit "never" rules (negative space), not just positive instructions
- Consequential or irreversible actions require a typed confirmation (`CONFIRM`, `APPROVE`, `GO`, or `ROLLBACK [version]`)
- Skills must reference artifacts by path — never reproduce content that lives elsewhere
- Size each skill to fit in a single context window (~100k tokens smart zone); if it can't, it needs a `/break-down` path

After changing any shared skill, run `build-forge-codex.ps1` and commit the output before pushing. If the changed skill has a Codex-native override, run `update-forge-codex-overrides.ps1 -ConfirmReview` after reviewing the diff.

### Standalone skills distribution

A third build target publishes a subset of skills to
[glensanders-gdev/skills](https://github.com/glensanders-gdev/skills) for people using them
outside Forge. Source of truth is still `global/.claude/skills/` — never edit `dist/` by hand.

```bash
./tools/build-forge-standalone.ps1 -Strict
```

Every skill declares `standalone: true|false` in its frontmatter. `true` ships; `false` means
the skill depends on Forge's sprint, company or knowledge-base scaffolding and is meaningless
without it. A new skill with no `standalone:` key fails the build — the decision is not
allowed to default.

The build removes Forge-only material three ways:

1. **Conventional sections** — `## Pipeline Position`, `## Forge Integration Points`,
   `## Integration with Forge` and friends are dropped whole.
2. **Sections naming a held skill** — a heading like `## /go-nogo Integration` is dropped
   whole when `/go-nogo` is not shipped.
3. **Explicit fences** — `<!--forge-only-->…<!--/forge-only-->` for anything else.

**The fence removes; it never substitutes.** Forge and Codex read the fenced span as ordinary
text, so the sentence must read correctly both with the span and without it. Put the
punctuation that joins the clause *inside* the fence:

```markdown
- Never deploy — build produces tested code only<!--forge-only-->; deployment is handled by `/go-nogo`<!--/forge-only-->
```

An unbalanced fence fails both builds. Frontmatter `description:` cannot be fenced — a YAML
value carries the markers verbatim into the live skill — so reword the description instead.

`-Strict` fails on any surviving reference to an unshipped skill; CI runs it. The build also
writes `dist/forge-standalone-BUILD-REPORT.md`, an advisory list of remaining `Forge` mentions
to work down over time. After changing a shared skill, rebuild and commit `dist/` alongside
`plugins/forge-codex/`.

### Naming a host product

The Codex build rewrites `Claude Code` → `Codex`, `Claude` → `Codex`, `CLAUDE.md` → `AGENTS.md`, and `~/.claude/` → `~/.codex/forge/` unconditionally. That is right when the text means *the host you are running on*, and wrong when it names **Claude Code specifically** — the rewrite turns a true sentence into a false one with no error.

When a sentence is a claim about one named product — which host reserves a command name, where that host stores its data, which host a tool reads logs from — fence it:

```markdown
<!--no-adapt-->Claude Code ships built-in commands called `/continue` and `/review`.<!--/no-adapt-->
```

The fence wraps a phrase or a block, survives no substitution, and is stripped from the generated output. An unbalanced fence fails the build; a fence that reaches `plugins/forge-codex/skills/` or `references/` fails parity. Fence only the host-specific span — leave surrounding paths and skill names free to adapt.

Ask which host the sentence is *about*, not which host will read it. "Restart your session to load new skills" is about the host and adapts correctly. "That name is shadowed by a Claude Code built-in" is about Claude Code and must be fenced.

## Windows Shell Convention

When `install.sh` or any script needs Windows-specific operations, use `powershell -NoProfile -Command "..."` not `cmd.exe /c`. To detect whether a path is a junction (not a real directory), check for the `ReparsePoint` attribute — `test -d` returns true for both real dirs and junctions on Windows.

## Versioning

Framework version is in `global/.claude/skills/manifest.json` under `forge_version`. Bump this on any release. Both Claude Code and Codex share the same version line.
