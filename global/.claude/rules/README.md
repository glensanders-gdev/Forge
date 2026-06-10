# Forge Rules

Language-agnostic coding standards and language-specific rule sets for AI-assisted development.

Origin: Adapted from Affaan Mustafa (ECC / github.com/affaan-m/ECC)

## Structure

```
rules/
├── common/                   # Language-agnostic baselines (always apply)
│   ├── coding-style.md       # KISS/DRY/YAGNI, file limits, naming, error handling
│   ├── model-selection.md    # Opus main thread, offload grunt work to cheap subagents
│   ├── quality-checklist.md  # Pre-ship checklist
│   ├── research-first.md     # Search-before-writing rule
│   └── security.md           # Pre-commit security checklist
├── typescript/               # TypeScript/JavaScript rules (install via /lang-rules)
├── python/                   # Python rules
├── golang/                   # Go rules
└── [other languages]/        # Added via /user:lang-rules
```

## How Rules Are Used

- `/user:review` — reads common + active language rules as review baseline
- `/user:build` — applies common + active language rules during TDD cycles
- `/user:push-standards` — uses active rules as baseline; only documents project-specific additions
- `/user:lang-rules` — installs and activates language rule sets per project

## Project Activation

Each project declares which rule sets apply via `.claude/rules/active.md`.
If no activation file exists, only common rules apply.

## Rules vs Skills

**Rules** define standards, conventions, and checklists that apply broadly — what the code must meet (e.g. "80% test coverage", "no hardcoded secrets", "functions under 50 lines"). They are reference documents the AI consults during `/review`, `/build`, and `/push-standards`.

**Skills** provide deep, actionable instruction for specific tasks — how to do something (e.g. `/tdd`, `/review`, `/security-review`). Skills may reference rules as the standard to enforce.

Language-specific rule files reference relevant Forge skills where appropriate. Rules tell you *what* to do; skills tell you *how* to do it.

## Rule Priority

Language-specific rules extend common rules and may override them where language idioms differ.
Common rules are never deactivated — they form the universal baseline.
