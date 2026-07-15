---
name: "assimilate"
description: "Adapt an idea, skill, or pattern from an external source into Forge. Fetches the source, evaluates what maps to Forge and what doesn't, adapts the relevant parts with Forge conventions, credits the original author, and produces a new skill or reference file. Use when user provides a URL or describes an external idea worth integrating."
metadata:
  category: framework
  version: 1.0.0
  argument_hint: URL or description of the external idea to assimilate
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Assimilate

Bring an idea from outside Forge into the framework — adapted, not just copied. Evaluates what's worth keeping, what needs changing to fit Forge conventions, and what doesn't apply. Always credits the original source.

Inspired by how ECC's accessibility and ai-first-engineering skills were adapted: take what's genuinely useful, translate it into Forge's language, and acknowledge where it came from.

---

## When to Use

- User provides a URL to an external skill, article, or framework
- User describes an idea from another tool or methodology worth integrating
- User says "can we adapt X from Y" or "can we use this in Forge"

---

## Process

### Phase 1 — AFK: Fetch and Evaluate

1. **Fetch the source** — if a URL is provided, read the content. If a description is provided, work from what was described.

2. **Evaluate fit** — analyse the source against Forge's existing structure:

```
## Assimilation Evaluation — [Source Name]

### What maps directly to Forge
- [Concept/pattern] → already exists as [Forge skill/file]
- [Concept/pattern] → maps to [Forge skill/file] with minor adaptation

### What adds genuine value
- [Concept/pattern] — not in Forge, worth adding because [reason]

### What doesn't apply
- [Concept/pattern] — not relevant because [reason]
- [Concept/pattern] — Forge already handles this differently: [how]

### Proposed Forge artefact
Type: New skill | Extension to existing skill | Reference file | PRINCIPLES addition
Name: /[skill-name] or [filename]
```

3. Present evaluation to human. Wait for confirmation before writing anything.

### Phase 2 — HITL: Adapt and Write

After human confirms the evaluation:

1. **Adapt the content** — translate into Forge conventions:
   - Use Forge terminology (HITL/AFK, smart zone, kanban, PRD, etc.)
   - Map to existing Forge pipeline stages where applicable
   - Add Forge integration points (which skills interact with this one)
   - Apply negative space programming — explicit "never" rules
   - Add failure modes

2. **Write the skill file** — follow `write-a-skill` structure:
   - `SKILL.md` with frontmatter including `origin:` field
   - Supporting reference files if needed
   - Command file for slash command access

3. **Credit the source** — every assimilated skill must include in its frontmatter:
   ```yaml
   origin: Adapted from [Author/Source] ([URL or repo])
   ```
   And in the skill body, a note crediting the original.

4. **Update the Forge manifest, commands reference, and CHANGELOG** — follow the `$write-a-skill` checklist.

---

## Adaptation Rules

**Keep:**
- Core concepts that solve a real problem Forge doesn't address
- Patterns that are well-reasoned and battle-tested
- Concrete examples and anti-patterns — these transfer well

**Change:**
- Terminology — translate into Forge's language
- Structure — apply Forge's SKILL.md format
- Integration points — wire into Forge pipeline stages explicitly
- Human gates — ensure HITL/AFK boundaries are explicit

**Drop:**
- Concepts already covered by existing Forge skills
- Framework-specific details that don't generalise (e.g. Cursor-specific config)
- Implicit conventions — make them explicit or drop them

**Always add:**
- Forge integration points section
- Failure modes table
- Negative space rules ("never...")
- Attribution in frontmatter `origin:` field

---

## Attribution Standard

All assimilated content uses this attribution format:

```yaml
origin: Adapted from [Author Name] ([Source Name] / [URL])
```

Examples:
```yaml
origin: Adapted from Affaan Mustafa (ECC / github.com/affaan-m/ECC)
origin: Adapted from Matt Pocock (AIHero.dev / github.com/mattpocock/skills)
origin: Adapted from [Article title] ([Publication] / [URL])
```

The body of the skill also includes a brief credit line — not buried in frontmatter only.

---

## Output

When assimilation is complete:

```
✓ Assimilation complete: /[skill-name]

Source: [URL or description]
Credit: [Author / Source]
Added to the Forge source: global/.claude/skills/[skill-name]/SKILL.md
Codex adaptation: plugins/forge-codex/skills/[skill-name]/SKILL.md (generated or reviewed override)

Forge integration points:
- [Which existing skills reference or are affected]

What was kept: [N concepts]
What was changed: [N adaptations]
What was dropped: [N items — briefly why]

Manifest, commands reference, and CHANGELOG updated.
```

---

## Rules

- Never copy verbatim without adaptation — assimilate, don't paste
- Always evaluate fit before writing — Phase 1 is mandatory
- Always credit the source — no exceptions
- Follow the `$write-a-skill` checklist after writing the skill
- Read `~/.codex/forge/PRINCIPLES.md` before adapting — does the source align with Forge's design principles?
- If the source conflicts with a Forge principle (e.g. auto-deploys without human gate), adapt it to remove the conflict or don't assimilate it

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| URL cannot be fetched | Ask user to paste the relevant content directly |
| Source is entirely covered by existing Forge skills | "This is already covered by [skill] — no new skill needed." Offer to update the existing skill instead |
| Source conflicts with Forge principles | Flag the conflict explicitly. Ask: "This conflicts with [principle] — adapt it to remove the conflict, or skip it?" |
| Source requires external tooling Forge doesn't have | Note the dependency. Offer to create a stub skill with a clear "requires [tool]" note |
| No clear Forge artefact type | Present options (skill, reference file, PRINCIPLES addition, CHANGELOG note) and ask human to choose |
