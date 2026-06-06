---
name: "knowledge-onboard"
description: "Guided company knowledge setup for a new employer. Walks through style guide, acronyms, domain terms, and core systems in sequence — each stage HITL-gated before the next begins. Supports Confluence URLs, file paths (PDF/Word), manual paste (SharePoint), and verbal description. Use when installing Forge at a new employer, running initial knowledge base setup, or onboarding a new client context."
metadata:
  category: knowledge
  origin: Designed for Forge — informed by ECC knowledge patterns (github.com/affaan-m/ECC)
---

# Knowledge Onboard

Guided end-to-end setup of `~/.codex/forge/knowledge/` for a new employer. Runs four stages in strict sequence — each stage is HITL-gated before the next begins. Nothing is written without your confirmation.

## When to Use

- First time installing Forge at a new employer or client
- Resetting or rebuilding the company knowledge base
- Onboarding a new business unit with its own terminology and systems

## Source Routing

At every stage, ask which source type applies and route accordingly:

| Type | When to use | How it works |
|------|-------------|-------------|
| `URL` | Confluence or accessible web page | Fetch and extract content |
| `FILE` | PDF or Word document | Read from provided file path |
| `PASTE` | SharePoint, email, or auth-gated source | User pastes content directly |
| `DESCRIBE` | No document available | AI conducts guided interview |

Ask for source type before requesting content. Never assume.

---

## Stage 1 — Style Guide

1. Ask: "Do you have a company style guide to provide? If yes — URL, FILE, PASTE, or DESCRIBE?"
2. If `URL` or `FILE`: fetch/read and extract written style, fonts, colours, approved terms, banned phrases into the template sections.
3. If `PASTE`: accept pasted content and extract.
4. If `DESCRIBE`: ask targeted questions — tone, fonts, colours, key terminology, banned phrases.
5. If skipped: note that `~/.codex/forge/knowledge/company/style-guide.md` is a placeholder — remind user to fill it in before running `$style-check`.
6. Draft the completed `style-guide.md` and present for HITL review.
7. On confirmation, write to `~/.codex/forge/knowledge/company/style-guide.md`.
8. Confirm: "Style guide written. Type **NEXT** to continue to acronyms."

---

## Stage 2 — Acronyms

1. Ask: "Do you have a list of company acronyms? URL, FILE, PASTE, or DESCRIBE?"
2. Extract all acronyms with full names and optional one-line descriptions.
3. Present the full list for HITL review before writing.
4. On confirmation, append to `~/.codex/forge/knowledge/company/acronyms.md` in alphabetical order.
5. Confirm count: "Added N acronyms. Type **NEXT** to continue to domain terms."

---

## Stage 3 — Domain Terms

1. Ask: "Do you have company-specific terminology or a business glossary? URL, FILE, PASTE, or DESCRIBE?"
2. Extract domain concepts — what things are called, common aliases to avoid, flagged ambiguities.
3. Present proposed entries for HITL review.
4. On confirmation, append to `~/.codex/forge/knowledge/company/context.md`.
5. Confirm: "Added N terms. Type **NEXT** to continue to systems."

---

## Stage 4 — Core Systems

Repeat for each system the user wants to document.

1. Ask: "Which system would you like to document first? (Name it, then we'll work through it together.)"
2. Run source routing — ask for URL, FILE, PASTE, or DESCRIBE for this system.
3. Use `summarise-system` logic to draft `overview.md`:
   - What it is and its business role
   - How it works — key concepts and data flows
   - What an AI can and cannot do here
   - Key contacts / escalation
4. Present draft for HITL review. On confirmation, write `overview.md`.
5. Ask: "Do you have schema or data model information for [System]? URL, FILE, PASTE, DESCRIBE, or SKIP?"
6. If provided, draft `schema.md` and present for HITL review. On confirmation, write.
7. Ask: "Any known limitations, bugs, or hard stops for [System]? DESCRIBE or SKIP?"
8. If provided, draft `known-issues.md`. On confirmation, write.
9. Confirm: "System [Name] documented. Type **NEXT** for another system, or **DONE** to finish."

---

## Completion

When the user types `DONE`:

```
✓ Knowledge onboard complete

Written:
- ~/.codex/forge/knowledge/company/style-guide.md
- ~/.codex/forge/knowledge/company/acronyms.md (N entries)
- ~/.codex/forge/knowledge/company/context.md (N terms)
- ~/.codex/forge/knowledge/systems/[name]/ (N systems)

Next steps:
- Run knowledge-health to check coverage
- Add systems incrementally as you encounter them using add-system
- Fill in any placeholder sections left during this session
- Run style-check to validate any deliverable against the style guide
```

---

## Forge Integration Points

- `summarise-system` — Stage 4 uses its extraction logic for system overviews
- `add-term` — used for any terms discovered mid-session that need capturing immediately
- `knowledge-health` — run after completion to check coverage and flag gaps
- `style-check` — validates deliverables once `style-guide.md` is populated
- `AGENTS.md` (project-level) — remind user to reference newly documented systems in project AGENTS.md files

## Rules

- Never write any file without HITL confirmation — every stage has a review gate
- Never advance to the next stage without explicit `NEXT` from the user
- Never store live credentials, passwords, or API keys in any knowledge file
- If source material is ambiguous, note uncertainty in the draft rather than guessing
- Mark any section with insufficient source material as `_Needs enrichment_`
- Style guide is a placeholder if no source is provided — never block progress on it

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| URL cannot be fetched (auth-gated) | Switch to PASTE — "I can't access that URL directly. Please paste the relevant content." |
| FILE path not found | Ask user to check the path or switch to PASTE |
| User wants to skip a stage | Accept gracefully — note what was skipped in the completion summary |
| System already documented | "A knowledge folder for [system] already exists. Update it or skip?" |
| User provides conflicting terminology | Flag as Flagged Ambiguity in `context.md` — do not silently pick one |

## Never

- Never overwrite existing knowledge files without showing the current content and confirming
- Never fabricate system behaviour — only document what the source material confirms
- Never skip the HITL gate to save time
- Never store PII examples in knowledge files — sanitise all examples
