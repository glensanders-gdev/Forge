---
name: add-term
category: knowledge
version: 1.0.0
description: Add a new term to the company-level glossary. Acronyms go to ~/.claude/knowledge/company/acronyms.md. Domain concepts go to ~/.claude/knowledge/company/context.md. Lightweight — captures term + definition + avoid aliases immediately, flags for enrichment later. Use when a new company or domain term is coined or discovered during any session.
---

# Add Term

Add a new term to the company-level knowledge base. Lightweight and ad-hoc — designed to be run in the middle of any session when a term needs capturing before it's forgotten. No grill, no ceremony.

**Scope:** Company-level — terms that apply across all projects. For project-specific terms use `/user:update-context` or update `docs/CONTEXT.md` directly during `/user:grill-with-docs`.

---

## Term Type Detection

The agent chooses the target file based on the term:

| Term type | Target file | Signal |
|-----------|------------|--------|
| Acronym or abbreviation | `~/.claude/knowledge/company/acronyms.md` | Short uppercase letters, e.g. "OSS", "BSS", "CAPEX" |
| Domain concept with a definition | `~/.claude/knowledge/company/context.md` | A noun or phrase that describes a business concept, process, or entity |
| Ambiguous | Ask the user | Can't be determined from the term alone |

If the term appears in both files already, flag it: "This term already exists — want to update it instead?"

---

## Process

### 1. Capture the Term

If the user provided the term inline (e.g. `/add-term OSS — Operational Support System`), extract it directly.

If no term provided, ask: "What's the term?"

### 2. Detect Term Type

Apply the detection logic above. State which file it will be added to before proceeding.

### 3. Gather Minimum Definition

Ask only what's needed for a useful entry:

**For acronyms:**
```
What does [ACRONYM] stand for? (And optionally — what is it in one sentence?)
```

**For domain concepts:**
```
What is [term] in one sentence? (What it IS, not what it does.)
Are there any aliases or synonyms the team should avoid — words that mean the same thing but create confusion?
```

If the user is in a hurry, accept a rough definition and flag it as `_Needs enrichment_`.

### 4. Check for Conflicts

Before writing:
- Scan `~/.claude/knowledge/company/acronyms.md` and `context.md` for the term
- Scan `~/.claude/knowledge/company/context.md` Flagged Ambiguities
- If a similar term exists, surface it: "The term 'X' already exists — is this the same concept or a distinct one?"

### 5. Present Entry for Confirmation

Show the formatted entry before writing:

**Acronym entry:**
```
Adding to acronyms.md:

**[ACRONYM]** — [Full form]. [Optional one-sentence description.]

Type CONFIRM to add, or provide corrections.
```

**Context entry:**
```
Adding to context.md:

**[Term]**:
[Definition — one sentence.]
_Avoid_: [aliases, if any]
_Needs enrichment_: Yes (add Example Dialogue and relationships when time allows)

Type CONFIRM to add, or provide corrections.
```

### 6. Write to File

On `CONFIRM`:

**Acronyms:** Append to `~/.claude/knowledge/company/acronyms.md` in alphabetical order.

**Context:** Append to the `## Language` section of `~/.claude/knowledge/company/context.md`. If this is the first term, replace the `_No terms defined yet_` placeholder.

Update `Last updated` date in the file header.

### 7. Confirm and Optionally Link to Project

After writing:
```
✓ Added [term] to [filename].

If this term also applies to the current project, add it to docs/CONTEXT.md too?
Type YES to add it there as well, or anything else to skip.
```

If YES, append to the project's `docs/CONTEXT.md` Language section with the same entry.

---

## Enrichment Flag

Entries marked `_Needs enrichment_` should be revisited during the next `/user:grill-with-docs` session to add:
- Relationships to other terms
- Example Dialogue showing natural usage
- Flagged Ambiguities if the term has been used inconsistently

The flag is optional — not every term needs enrichment, but flagging it surfaces the opportunity.

---

## Rules

- Capture now, enrich later — never block on completeness
- Never overwrite an existing entry without confirmation
- Acronyms in alphabetical order in `acronyms.md`
- Domain concepts appended in order of addition to `context.md`
- Company-level terms take precedence over project-level entries — if a project has a conflicting definition, flag it as a Flagged Ambiguity
- Always update the `Last updated` date in the file header
- If the user provides the term inline as an argument, skip the "What's the term?" question

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| `acronyms.md` missing | Create it with the entry as the first item |
| `context.md` missing | Create it from the template and add the entry |
| Term already exists | Flag it. Ask: "Update the existing entry or add as a variant?" |
| Definition is very rough | Accept it, mark `_Needs enrichment_`, note: "This can be refined during the next /grill-with-docs session." |
