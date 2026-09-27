---
name: push-standards
category: code-quality
description: Record coding standards in .claude/CODING-STANDARDS.md under a Project-Specific Patterns section — either extracted from codebase patterns, or written immediately from a single correction (--correction) when the agent gets something wrong. Use when user runs /push-standards, after /approve when new conventions were established, or the moment the human corrects a meaningful mistake in agent-written code.
argument-hint: "[--correction \"what was wrong\"]"
---

# Push Standards

Record coding standards in the project-specific section of `.claude/CODING-STANDARDS.md`. The baseline defaults at the top of the file are never modified — standards are appended to the "Project-Specific Patterns" section at the bottom.

Two modes:

| Mode | Source of the standard | Confirmation |
|------|------------------------|--------------|
| **Extract** (default) | Repeated patterns in the codebase and ADRs | Drafts presented; written on confirmation |
| **Correction** (`--correction`) | One mistake the human just corrected | **Write, then tell** — written immediately, reported in one line |

The file is only useful if it grows from real mistakes. Extract mode runs at feature close; correction mode runs the moment the agent gets something wrong, so the next change in the same session already benefits.

## When to Use

- After `/approve` when the user opts to document standards — Extract
- When a pattern has been repeated enough to be worth formalising — Extract
- The human corrects a meaningful mistake in agent-written code — Correction (the project `CLAUDE.md` makes this automatic)
- `/diagnose` finds a root cause of `Missing context` — Correction
- `/review-diff` finding fixed on instruction that no documented standard covered — Correction

## Correction Mode

Invoked as `/push-standards --correction "what was wrong"`, or by the agent itself under the project `CLAUDE.md` rule *Corrections Become Standards*.

1. **Qualify it.** Record only a mistake likely to recur in this project that a written rule would have prevented. Skip typos, one-off slips, and a change of mind about requirements — a requirement change belongs in the PRD, not a coding standard. A habit that applies across every project is an instinct — hand it to `/learn` instead and stop.
2. **Check for an existing standard.** Read the Project-Specific Patterns section and the active language rules (`.claude/rules/active.md`).
   - **Already covered by a language rule:** write nothing — the agent broke a rule it had. Say so in one line.
   - **Already covered by a project standard:** do not add a duplicate. Append today's date to that entry's `Source:` line, so a repeat is visible, and sharpen its wording if the miss shows the rule was ambiguous.
3. **Write it.** Append one entry in the Output Format below, with `Source: correction YYYY-MM-DD`. Phrase the rule as what to do, not what went wrong — "Every new component ships light and dark variants", not "Forgot dark mode". Include an Example only when a snippet makes the rule clearer.
4. **Tell.** One line, after writing, never a question:

   ```
   Standard added → .claude/CODING-STANDARDS.md: "[Rule]" — reply to reword or remove.
   ```

   If the human rewords or rejects it, edit or delete that entry — correction-sourced entries are the one kind this skill removes, and only on the human's word.

5. Continue the interrupted task. Correction mode is a side-step, not a context switch.

## Extract Mode

1. Read `.claude/CODING-STANDARDS.md` — check the "Project-Specific Patterns" section to avoid duplicating existing standards.
2. If `.claude/rules/active.md` exists, read it and the referenced language rules — these form the baseline. Only extract patterns that extend or specialise beyond what the global rules already define.
3. Explore the codebase for repeated patterns, conventions, and established approaches.
4. Read `docs/adr/` — ADRs often imply coding standards worth making explicit.
5. Draft new standards and present for confirmation.
6. On confirmation, append to the "Project-Specific Patterns" section of `.claude/CODING-STANDARDS.md`.

## Output Format

Append under `## Project-Specific Patterns` at the bottom of `.claude/CODING-STANDARDS.md`. Create the section if it doesn't exist. Never modify the baseline defaults above it.

```markdown
## Project-Specific Patterns

*Extracted from codebase by /push-standards — YYYY-MM-DD*

### [Pattern Name]
**Rule:** [What must be done]
**Reason:** [Why this matters for this project]
**Source:** [extracted YYYY-MM-DD | correction YYYY-MM-DD[, YYYY-MM-DD …]]
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

## Related

- `.claude/CODING-STANDARDS.md` — canonical standards file this skill reads and updates
- `global/.claude/rules/common/coding-style.md` — universal baseline rules that inform the standards
- `/lang-rules` — installs language-specific rules that push-standards incorporates
- `/review-diff` — applies the standards produced here during code review
- `/check-style` — sister skill for prose/documentation standards (push-standards handles code)

## Rules

- Standards must be grounded in the actual codebase or an actual correction — not generic best practices.
- Correction mode never asks before writing. It writes, then tells in one line.
- If `.claude/rules/active.md` exists, treat the referenced language rules as the baseline — never re-document what is already covered there.
- Each standard needs a "Reason" — if you can't explain why, it's not a standard yet.
- Never remove or modify the baseline defaults at the top of `CODING-STANDARDS.md`.
- Never remove existing project standards — mark superseded ones with `~~strikethrough~~` and a note. Sole exception: a correction entry the human rejects in reply to the one-line notice.
- Keep standards concise — a standard needing a long explanation needs simplifying.
- After writing, confirm the file location and list what was added.
- If `.claude/CODING-STANDARDS.md` doesn't exist, create it with just the Project-Specific Patterns section and warn: "Baseline defaults not found — reinstall from project template."

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| `.claude/CODING-STANDARDS.md` doesn't exist | Create it with just the Project-Specific Patterns section and warn that the baseline defaults are missing. |
| A pattern is already covered by active language rules | Don't re-document it — extract only what extends the baseline. |
| Pattern is generic best practice, not codebase-grounded | Don't add it — standards must come from the actual code. |
| A proposed standard has no "Reason" | It's not a standard yet — drop it or sharpen it. |
| A standard is being superseded | Mark the old one `~~strikethrough~~` with a note — never delete project standards. |
| Tempted to edit the baseline defaults | Never — append only to the Project-Specific Patterns section. |
| Correction mode tempted to ask "should I add this?" | Don't — write it, then report it in one line. The asking is what stops capture. |
| Correction is a typo, one-off slip, or requirement change | Record nothing. Requirement changes go to the PRD. |
| Correction repeats an existing project standard | Don't duplicate — add today's date to its `Source:` line, and sharpen the wording if it was ambiguous. |
| Correction is already covered by an active language rule | Write nothing; say in one line that the rule existed and was missed. |
| Correction applies across all projects | Route to `/learn` instead — this file is project-specific. |
| Human rejects or rewords a correction entry | Delete or edit that entry as instructed. |
