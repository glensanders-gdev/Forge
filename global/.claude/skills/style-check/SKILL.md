---
name: style-check
description: Review any deliverable against the company style guide in ~/.claude/knowledge/company/style-guide.md. Produces a findings report with CRITICAL, HIGH, and LOW severity levels. Use when user runs /style-check, before sharing any document externally, or when /write-article or /write-prd flags a style review is recommended.
---

# Style Check

Review a document, PRD, report, or any written output against `~/.claude/knowledge/company/style-guide.md`. Produces a findings report and a pass/fail gate.

## When to Use

- Before sharing any document, report, or presentation externally
- After `/write-article` or `/write-prd` produces a deliverable
- When a document needs brand compliance verification
- Periodically on living documents (status reports, wiki pages)

## Pre-Check

Before reviewing, read `~/.claude/knowledge/company/style-guide.md`.

If the file is a placeholder (no sections filled in):
```
⚠️ Style guide not yet populated.

Fill in ~/.claude/knowledge/company/style-guide.md before running /style-check.
Run /user:knowledge-onboard to set it up guided, or edit the file directly.
```
Stop here — do not proceed with an empty style guide.

## Input

Ask the user how to provide the document:
- **PASTE** — paste content directly into the session
- **FILE** — provide a file path for the AI to read
- **SESSION** — review the most recent document produced in this session

## Process

1. Read `style-guide.md` in full.
2. Read the document to review.
3. Check against every populated section of the style guide:
   - Written style (tone, person, sentence length, jargon, active/passive)
   - Document formatting (headings, dates, numbers, currency, footer)
   - Fonts and colours (flag if specified in doc format and mismatched)
   - Approved terminology (check for preferred vs avoided terms)
   - Banned terms/phrases (flag every instance)
4. Produce findings table — see output format below.
5. Issue pass/fail gate.

## Output Format

```markdown
## Style Check — [Document name or description]
**Reviewed against:** ~/.claude/knowledge/company/style-guide.md
**Date:** YYYY-MM-DD

### Findings

| # | Severity | Location | Issue | Suggested fix |
|---|----------|----------|-------|--------------|
| 1 | CRITICAL | Para 2 | Banned term: "leverage" | Replace with "use" |
| 2 | HIGH | Heading 1 | Passive voice: "The report was written" | "We wrote the report" |
| 3 | LOW | Footer | Date format "05/23/2026" | Use "23 May 2026" |

### Summary
- CRITICAL: N
- HIGH: N
- LOW: N

### Gate
✅ APPROVED — No CRITICAL or HIGH findings. Ready to share.
— or —
❌ NEEDS REVISION — N CRITICAL / N HIGH findings must be resolved before sharing.
```

## Severity Levels

| Level | Meaning | Action required |
|-------|---------|----------------|
| CRITICAL | Mandatory brand standard violated — banned term, wrong logo usage, confidentiality footer missing | Must fix before sharing |
| HIGH | Strong brand preference violated — wrong tone, passive voice where active required, unapproved term | Should fix before sharing |
| LOW | Minor formatting or style suggestion | Optional — fix when convenient |

## Forge Integration Points

- `/user:write-article` — recommends `/style-check` on completion
- `/user:write-prd` — recommends `/style-check` on completion
- `/user:knowledge-onboard` — populates `style-guide.md` that this skill reads
- `/user:qa-plan` — include a style-check step for any externally shared deliverable

## Rules

- Never approve a document with unresolved CRITICAL findings
- Only check against sections that are populated — skip placeholder sections silently
- If a section of the style guide is ambiguous, flag it rather than guessing
- Review the full document — never sample
- Do not rewrite the document — findings and suggestions only; the human makes changes

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| `style-guide.md` is a placeholder | Stop with guidance to populate it first |
| `style-guide.md` missing entirely | "Style guide not found at expected path. Run /user:knowledge-onboard to set it up." |
| Document too large to review in one pass | Review in sections, noting which section each finding is in |
| No findings | "✅ No issues found — document meets all populated style guide standards." |

## Never

- Never store the reviewed document content in knowledge files
- Never fabricate style guide rules that aren't in the file
- Never approve a document with CRITICAL findings regardless of time pressure
