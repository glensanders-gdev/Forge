---
name: "summarise-system"
description: "Generate a first-draft overview.md for a system from provided documentation, codebase exploration, or description. Use when user runs $summarise-system, is onboarding a new system into the knowledge base, or has documentation to process into structured knowledge."
metadata:
  category: knowledge
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Summarise System

Generate a first-draft `overview.md` for a system by synthesising provided documentation, codebase exploration, or the user's description. Speeds up onboarding a new system into the knowledge base.

## Process

1. Ask the user for the system name if not provided.
2. Check if `~/.codex/forge/knowledge/systems/[name]/` already exists — if not, suggest running `add-system` first.
3. Gather source material — one or more of:
   - Documentation or URLs provided by the user
   - Codebase exploration (if accessible)
   - User's verbal description
4. Draft `overview.md` using the template.
5. Present the draft to the user for review.
6. On confirmation, write to `~/.codex/forge/knowledge/systems/[name]/overview.md`.
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

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| `~/.codex/forge/knowledge/systems/[name]/` doesn't exist | Suggest `$add-system` first — don't write into a missing folder. |
| `overview.md` already exists | Don't overwrite without user confirmation. |
| No source material available | Ask for docs, a description, or codebase access before drafting. |
| Source material is ambiguous | Note the uncertainty in the draft rather than guessing. |
| Drafting the AI-cannot / Do-Not-Attempt sections | Be explicit and conservative — these are the most important sections. |
| Draft not yet confirmed | Mark it `Status: Draft — needs review` until the user confirms. |
