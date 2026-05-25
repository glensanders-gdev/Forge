---
name: learn
version: 1.0.0
description: Capture a pattern observed during a session as a Forge instinct. Accepts an optional inline description. Checks for duplicates and increments observation count if a match exists. Use when a recurring pattern, failure mode, or useful heuristic is noticed during any session phase.
argument-hint: What pattern was observed? (optional — will ask if not provided)
---

# Learn

Capture a pattern from the current session into `~/.claude/instincts/` so it accumulates over time and can eventually be promoted into a formal Forge skill.

**The difference between an instinct and an ADR:** An ADR records a one-time decision. An instinct records a recurring pattern — something worth changing how the agent behaves across all future sessions.

---

## Process

### 1. Capture the Observation

If the user provided an inline description (e.g. `/learn "XL DB tickets consistently land at 2× actual"`), use it as the starting observation.

If no description provided, ask: "What pattern or recurring behaviour did you notice this session?"

### 2. Ask the Behaviour Question

One clarifying question — always:

```
How should the agent behave differently next time this situation arises?
```

This is the most important question. An observation without a behaviour change is a note, not an instinct. Wait for the answer before proceeding.

### 3. Check for Duplicates

Read `~/.claude/instincts/registry.md` and all existing instinct files. Look for:
- Similar patterns (same phase, similar observation)
- Matching behaviour changes

If a likely match is found, surface it:

```
This looks similar to instinct-NNN — "[existing instinct title]"

Pattern: [existing pattern description]
Behaviour: [existing behaviour change]

Is this the same pattern (increment observation count) or a new one (create separately)?
Type SAME or NEW.
```

**If SAME:** increment `observations` in the existing instinct file, update `last-observed`, add a row to the Observation Log, update registry confidence if threshold crossed. Done.

**If NEW:** proceed to create a new instinct.

### 4. Determine Confidence Level

New instincts always start at Low (1 observation). The human can override:

```
Starting confidence: Low (1 observation)
Override to High if you're confident this is a well-established pattern? (Y/N)
```

### 5. Assign ID and Create File

1. Read `~/.claude/instincts/registry.md` — get next instinct number
2. Generate a slug from the observation (3–5 words, hyphenated, lowercase)
3. Create `~/.claude/instincts/instinct-NNN-[slug].md` from `_template.md`
4. Fill in all frontmatter and body fields
5. Update registry — add row and update counter

### 6. Confirm

```
✓ Instinct captured: instinct-NNN — [slug]

Phase: [phase]
Confidence: Low | High (overridden)
Behaviour change: [behaviour change in one sentence]

File: ~/.claude/instincts/instinct-NNN-[slug].md

This instinct will reach Medium confidence after 2 more observations
and High confidence after 4 more. Run /user:evolve when ready to
consider promoting it to a skill.
```

---

## Confidence Thresholds

| Observations | Confidence |
|-------------|-----------|
| 1 | Low |
| 3+ | Medium |
| 5+ | High |
| Human override | High (immediate) |

When an instinct crosses a threshold, update `confidence` in the frontmatter and the registry. When it reaches High, add it to the "High Confidence — Promotion Candidates" section of the registry.

---

## Session End Prompt

At the end of any session (when `/debrief` or `/handoff` runs), include:

```
💡 Did anything this session produce a pattern worth capturing?
   Run /user:learn to capture it before it's forgotten.
```

This is a suggestion only — never mandatory.

---

## Rules

- The behaviour change question is mandatory — never create an instinct without it
- Always check for duplicates before creating — increment, don't fragment
- New instincts start at Low unless human overrides
- Never auto-promote an instinct to a skill — that requires `/evolve` and human decision
- Slug should be descriptive enough to recognise in the registry without reading the file

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| Registry missing | Create it from scratch with the new instinct as the first entry |
| Template missing | Create instinct file manually using the standard format |
| Human provides no behaviour change | Prompt once more: "What should the agent do differently?" — if still none, note "Behaviour change pending" in the file and flag for later enrichment |
| Duplicate check inconclusive | Present the 2 most similar instincts and ask the human to confirm |
