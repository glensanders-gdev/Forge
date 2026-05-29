---
name: summarise-system
category: knowledge
description: Generate a first-draft overview.md for a system from provided documentation, codebase exploration, or description. Use when user runs /summarise-system, is onboarding a new system into the knowledge base, or has documentation to process into structured knowledge.
---

# Summarise System

Generate a first-draft `overview.md` for a system by synthesising provided documentation, codebase exploration, or the user's description. Speeds up onboarding a new system into the knowledge base.

## Process

1. Ask the user for the system name if not provided.
2. Check if `~/.claude/knowledge/systems/[name]/` already exists — if not, suggest running `/user:add-system` first.
3. Gather source material — one or more of:
   - Documentation or URLs provided by the user
   - Codebase exploration (if accessible)
   - User's verbal description
4. Draft `overview.md` using the template.
5. Present the draft to the user for review.
6. On confirmation, write to `~/.claude/knowledge/systems/[name]/overview.md`.
7. Ask: "Want me to also draft `schema.md` or `known-issues.md` from the same material?"

## Extraction Guidelines

From the source material, extract:

- **What it is** — purpose and business role in plain language
- **How it works** — key concepts, data flows, mental models
- **Data sources** — where data comes from, transformations applied
- **AI capabilities** — what tasks an AI can reliably assist with
- **AI limitations** — what the AI cannot or should not do
- **Intended use** — guard rails, human escalation points
- **Key contacts** — owners and escalation paths

## Rules

- Write in plain language — not technical jargon unless it's domain-essential.
- The "What an AI Cannot Do Here" and "Do Not Attempt" sections are the most important — be explicit and conservative.
- If source material is ambiguous, note the uncertainty in the draft rather than guessing.
- Do not overwrite an existing `overview.md` without user confirmation.
- Mark the draft with `**Status: Draft — needs review**` at the top until the user confirms it.
