---
name: push-standards
description: Extract coding patterns from the current codebase and append them to .claude/CODING-STANDARDS.md under a Project-Specific Patterns section. Use when user runs /push-standards, patterns have emerged that should be enforced, or after /approve when new conventions were established.
---

# Push Standards

Extract coding patterns and conventions from the current codebase and document them in the project-specific section of `.claude/CODING-STANDARDS.md`. The Forge defaults at the top of the file are never modified — patterns are appended to the "Project-Specific Patterns" section at the bottom.

## When to Use

- After `/approve` when the user opts to document standards
- When a pattern has been repeated enough to be worth formalising
- After a `/review` surfaces a recurring issue worth preventing

## Process

1. Read `.claude/CODING-STANDARDS.md` — check the "Project-Specific Patterns" section to avoid duplicating existing standards.
2. If `.claude/rules/active.md` exists, read it and the referenced language rules — these form the baseline. Only extract patterns that extend or specialise beyond what the global rules already define.
3. Explore the codebase for repeated patterns, conventions, and established approaches.
4. Read `docs/adr/` — ADRs often imply coding standards worth making explicit.
5. Draft new standards and present for confirmation.
6. On confirmation, append to the "Project-Specific Patterns" section of `.claude/CODING-STANDARDS.md`.

## Output Format

Append under `## Project-Specific Patterns` at the bottom of `.claude/CODING-STANDARDS.md`. Create the section if it doesn't exist. Never modify the Forge defaults above it.

```markdown
## Project-Specific Patterns

*Extracted from codebase by /push-standards — YYYY-MM-DD*

### [Pattern Name]
**Rule:** [What must be done]
**Reason:** [Why this matters for this project]
**Example:**
\`\`\`[language]
[concrete example]
\`\`\`
```

## Categories to Consider

- Error handling patterns specific to this stack
- DOM manipulation conventions
- Data access patterns
- Naming conventions (variables, functions, files)
- State management approaches
- API / sync patterns
- Testing conventions

## Rules

- Standards must be grounded in the actual codebase — not generic best practices.
- If `.claude/rules/active.md` exists, treat the referenced language rules as the baseline — never re-document what is already covered there.
- Each standard needs a "Reason" — if you can't explain why, it's not a standard yet.
- Never remove or modify the Forge defaults at the top of `CODING-STANDARDS.md`.
- Never remove existing project standards — mark superseded ones with `~~strikethrough~~` and a note.
- Keep standards concise — a standard needing a long explanation needs simplifying.
- After writing, confirm the file location and list what was added.
- If `.claude/CODING-STANDARDS.md` doesn't exist, create it with just the Project-Specific Patterns section and warn: "Forge defaults not found — reinstall from project template."
