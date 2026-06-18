---
name: research
category: pipeline
version: 1.0.0
description: Cache findings from expensive exploration phases into topic-specific markdown files. Use when implementation would require repeated or costly exploration of external APIs, libraries, schemas, or unfamiliar codebases.
---

# Research

Create topic-specific research files under `docs/research/` to cache findings that would otherwise need to be rediscovered in each session or each ticket.

## When to Use

Use the Research stage when:
- Implementation depends on understanding an external API, SDK, or library
- The codebase has unfamiliar or complex existing patterns that need mapping
- Multiple tickets will depend on the same domain knowledge
- A decision requires comparing multiple options before the PRD is written

Skip Research if the implementation is straightforward and the domain is already well understood.

## Process

1. Identify the topics that need research (from the Grill Me summary or PRD draft).
2. For each topic, create a separate file: `docs/research/[topic-name].md`
3. Populate each file with findings, code examples, trade-offs, and a recommendation.
4. Reference research files in the PRD and in relevant kanban tickets.

## File Format

```markdown
# Research: [Topic Name]

**Date:** YYYY-MM-DD
**Status:** Draft | Complete

## Question
What are we trying to understand?

## Findings

### Option A
...

### Option B
...

## Trade-offs
| | Option A | Option B |
|---|---|---|
| Performance | | |
| DX | | |
| Complexity | | |

## Recommendation
[Chosen option and reasoning]

## References
- [Link or file path]
```

## Rules

- One file per topic. Do not combine unrelated topics.
- Keep findings factual. Save opinions for the Recommendation section.
- If a finding contradicts something in `docs/CONTEXT.md`, flag it immediately.
- Research files are never archived — they remain as living reference material.

## After Research is Complete

Suggest the next stage:
- If design needs early code validation → recommend Prototype stage
- If scope is clear → recommend `/write-prd`

Wait for human confirmation before proceeding.

## Knowledge Base Promotion

At the end of a research session, ask:

```
Research complete. Should any of these findings be promoted to the knowledge base?

- Findings about external systems → /user:add-system or update ~/.claude/knowledge/systems/[system]/
- New domain terms → /user:add-term
- Company-wide patterns → ~/.claude/knowledge/company/context.md

Type YES to review promotion candidates, or anything else to skip.
```

Promotion is always advisory — the human confirms each entry before it is written. This ensures session findings accumulate into the knowledge base over time rather than staying isolated in docs/research/.

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| Implementation is straightforward / domain already understood | Skip Research — don't manufacture files for known territory. |
| A finding contradicts `docs/CONTEXT.md` | Flag it immediately rather than recording the contradiction silently. |
| Tempted to combine unrelated topics in one file | Keep one file per topic. |
| Findings drift into opinion | Keep findings factual; confine judgement to the Recommendation section. |
| Research is inconclusive | Record what's known and the open question — don't force a recommendation. |
| Findings belong in the knowledge base | Offer promotion via `/add-system` / `/add-term` — advisory, human confirms each entry. |
