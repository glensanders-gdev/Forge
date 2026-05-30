---
name: lang-rules
category: code-quality
description: Install and activate language-specific coding rule sets for the current project. Detects project languages, checks ~/.claude/rules/<lang>/ for available rule sets, copies them into .claude/rules/, and writes an active.md activation file so /review, /build, and /push-standards know which baselines apply. Use when starting a project, running /onboard, or when /push-standards should reference a language baseline rather than starting from scratch.
origin: Adapted from Affaan Mustafa (ECC / github.com/affaan-m/ECC)
---

# Lang Rules

Install and activate language-specific coding rule sets for the current project.

Credit: Adapted from the ECC rules system by Affaan Mustafa (github.com/affaan-m/ECC).

## When to Use

- When starting a new project or running `/onboard`
- When `/push-standards` should skip rules already covered by a global language baseline
- When `/review` or `/build` should apply language-specific coding standards

## Process

### Phase 1 — AFK: Detect and assess

1. Scan the project for primary languages: file extensions, `package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`, `*.csproj`, etc.
2. For each detected language, check if `~/.claude/rules/<lang>/` exists.
3. Check if `.claude/rules/active.md` already exists — do not overwrite without HITL confirmation.

Present findings:
```
Detected: typescript, python
Global rules available: typescript ✓ | python ✗ (not installed)
Project activation: .claude/rules/active.md not found
```

### Phase 2 — HITL: Confirm

Show exactly what will be written. Wait for confirmation before proceeding.

For each language with no global rule set, offer:
- **A** — Scaffold a starter rule set from Forge's common rules adapted for that language
- **B** — Skip that language (common rules apply only)

### Phase 3 — AFK: Write

1. Copy `~/.claude/rules/<lang>/` into `.claude/rules/<lang>/` for each confirmed language.
2. Write `.claude/rules/active.md`:

```markdown
# Active Language Rules

Languages: [detected list]
Common rules: ~/.claude/rules/common/ (always active)

## Language rule sets
- typescript: .claude/rules/typescript/
- python: not installed — common rules only

*Updated by /lang-rules — YYYY-MM-DD*
```

3. Report what was written and where.

## Scaffolding a New Language Rule Set

When a detected language has no global rule set, offer to scaffold one. A new language directory must contain:

```
~/.claude/rules/<lang>/
├── coding-style.md   # Formatting, idioms, type usage, error handling patterns
├── testing.md        # Test framework, coverage tools, test organisation
├── patterns.md       # Language-specific design patterns and conventions
├── hooks.md          # PostToolUse hooks for formatters, linters, type checkers
└── security.md       # Secret management, security scanning tools
```

Every file must open with:
```
> This file extends [common/xxx.md](../common/xxx.md) with <Language> specific content.
```

When scaffolding, generate minimal stubs — one or two concrete rules per section — and flag them for the human to review and extend. Never generate fabricated rules; only include what is verifiably idiomatic for that language.

## Forge Integration Points

- `/user:onboard` — call `/lang-rules` as part of project bootstrapping
- `/user:push-standards` — reads `active.md` to use language rules as baseline; only documents extensions
- `/user:review` — reads `active.md` and applies language rules alongside ADRs and CODING-STANDARDS.md
- `/user:build` — consults active language rules during TDD cycles

## Rules

- Never overwrite `.claude/rules/active.md` without HITL confirmation.
- Never fabricate language rules — only install from `~/.claude/rules/<lang>/` or scaffold from common.
- Common rules (`~/.claude/rules/common/`) always apply — they are never deactivated.
- Language rules extend common rules; they do not replace them.
- If the project mixes languages, activate all detected rule sets.

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| Language detected but no global rule set | Offer to scaffold a starter or skip |
| `.claude/rules/active.md` already exists | Show current content, ask before overwriting |
| Language cannot be confidently detected | Ask the human to specify |
| `~/.claude/rules/` missing | Warn: "Forge rules not installed — re-run Forge installer or check ~/forge/install.sh" |

## Never

- Never assume a language without clear file-level evidence.
- Never activate rule sets for languages not present in the project.
- Never skip the HITL confirmation before writing.
