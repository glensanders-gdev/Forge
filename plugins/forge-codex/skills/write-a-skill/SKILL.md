---
name: "write-a-skill"
description: "Create new Forge skills with proper structure, correct file locations, and updated manifest. Use when user wants to create, write, or add a new skill to Forge, or mentions $write-a-skill."
metadata:
  category: framework
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Write a Skill

Create or update a skill without confusing Forge's canonical source, its generated Codex plugin, and normal Codex discovery locations.

- **Forge framework skill:** author `global/.claude/skills/[name]/`, then generate `plugins/forge-codex/skills/[name]/`. Keep a separate reviewed Codex copy when runtime behavior differs.
- **Repository Codex skill:** use `.agents/skills/[name]/SKILL.md`.
- **User Codex skill:** use `~/.agents/skills/[name]/SKILL.md`.

> **Writing well** — this file covers *structure* (which files, what to update). For the
> *craft* of the prose inside them — **leading words**, checkable **completion criteria**,
> information hierarchy, and pruning out **no-ops** — read [CRAFT.md](CRAFT.md) before
> drafting a description or step. Predictability (same process every run) is the goal.

## Process

1. **Gather requirements** — ask the user:
   - What does this skill do?
   - What triggers it? (keywords, slash command, context)
   - Is it global (all projects) or project-specific?
   - Does it need supporting files (REFERENCE.md, EXAMPLES.md, scripts)?

2. **Draft the skill** — create:
   - `SKILL.md` with concise instructions — target under 100 lines; if workflow logic exceeds this, extract supporting content (reference tables, templates, examples, scripts) to additional files (`REFERENCE.md`, `FORMATS.md`, `scripts/`, etc.)
   - Additional files for any content that would push `SKILL.md` over 100 lines or has a distinct domain
   - No Codex command stub; Codex discovers `SKILL.md` directly

3. **Review with user** — present the draft and ask:
   - Does this cover your use cases?
   - Anything missing or unclear?
   - Should any section be more or less detailed?

4. **Write the files** — once confirmed, create all files and update the manifest.

## File Structure

```
global/.claude/skills/[skill-name]/
  SKILL.md           ← required
  REFERENCE.md       ← if content exceeds 100 lines
  EXAMPLES.md        ← if examples would clutter SKILL.md

plugins/forge-codex/skills/[skill-name]/  ← generated or reviewed Codex adaptation
.agents/skills/[skill-name]/              ← repository-only Codex skill
~/.agents/skills/[skill-name]/            ← user-only Codex skill
```

## SKILL.md Template

```markdown
---
name: skill-name
category: [pipeline|ideation|session|code-quality|knowledge|metrics|pi-release|sprint|maintenance|company|framework]
description: What this skill does. Use when [specific triggers].
---

# Skill Name

Brief description of what this skill does and when to use it.

## Process

1. Step one
2. Step two
3. Step three

## Rules

- Rule one
- Rule two

## Output Format

[Describe what the skill produces]
```

## Description Requirements

The description is the primary signal the agent uses to select the right skill. Write it carefully:

- Max 1024 characters
- First sentence: what it does — front-load the skill's **leading word** (see [CRAFT.md](CRAFT.md))
- Second sentence: "Use when [specific triggers]" — one trigger per genuine branch; collapse synonyms that just rename the same branch
- Be specific — vague descriptions cause the wrong skill to be selected
- Prune harder than the body: a description is paid for on every turn, so cut any identity already stated in the skill body

**Good:**
```
Scaffold a new system knowledge folder with blank overview, schema, and known-issues files. Use when user wants to add a system, runs $add-system, or mentions adding a new system to the knowledge base.
```

**Bad:**
```
Helps with systems.
```

## Codex Invocation

Codex registers skills from `SKILL.md`; users invoke them as `$skill-name`. Do not create a Codex command stub. Keep the description concise and trigger-focused because it drives implicit selection.

## After Writing Files

1. For a Forge framework skill, update `global/.claude/skills/manifest.json`:
   - New skill: add entry with version `"1.0.0"`
   - Updated skill: bump the existing version (`1.0.0` → `1.1.0`, `1.1.0` → `1.2.0`, etc.). Never leave the manifest at the old version after a meaningful change — a frozen version number is the same as no version number.
2. Update `global/.claude/CHANGELOG.md` and the repository README.
3. Run `tools/build-forge-codex.ps1` and review the generated Codex copy.
4. If Codex behavior differs, add the skill to both override lists, retain the tailored plugin copy, refresh `compatibility.json`, and run parity validation.
5. Confirm the source and Codex paths created or updated.

## When to Split Files

Split into separate files when:
- `SKILL.md` exceeds 100 lines — extract supporting content to `REFERENCE.md`, `FORMATS.md`, or other named files
- Content has distinct domains (e.g. workflow logic vs output templates vs scripts)
- Advanced reference material (reference tables, stub templates, config schemas) is rarely needed during normal use — keeping it out of `SKILL.md` keeps the workflow scannable

## Review Checklist

Before finalising, verify:
- [ ] Read `global/.claude/PRINCIPLES.md` — does this skill follow the 8 design principles?
- [ ] Read [CRAFT.md](CRAFT.md) — description front-loads a **leading word**, every step has a **checkable completion criterion**, and the prose survives the **no-op test** (no line that changes nothing versus the agent's default)
- [ ] `category:` field set — valid values: `pipeline`, `ideation`, `session`, `code-quality`, `knowledge`, `metrics`, `pi-release`, `sprint`, `maintenance`, `company`, `framework`
- [ ] Description includes "Use when [triggers]"
- [ ] **If adapting from an external source** — use `assimilate` instead. It handles attribution, fit evaluation, and adaptation automatically.
- [ ] `SKILL.md` is under 100 lines — dense reference tables, stub templates, and rarely-needed config extracted to `REFERENCE.md` or additional named files
- [ ] No time-sensitive information included
- [ ] Terminology consistent with `docs/CONTEXT.md`
- [ ] `manifest.json` updated with new skill and version `"1.0.0"`
- [ ] Claude command stub updated for the shared runtime; no Codex command stub created
- [ ] **`global/.claude/skills/commands/SKILL.md` updated** — add the skill to the command reference.
- [ ] **`global/.claude/CHANGELOG.md` updated** — add the skill under the current `forge_version` entry.
- [ ] **`README.md` updated** — increment the skill count in the "What's Included" intro line (e.g. "**94 skills**"), add the new skill to the correct category row in the table, and update any other inline counts (e.g. the file structure section).
- [ ] **Git tag and GitHub Release created** — after merging to `main`: (1) push the tag: `git tag v[forge_version] <main-sha> && git push origin v[forge_version]`; (2) create a GitHub Release at `github.com/glensanders-gdev/Forge/releases/new` using that tag, pasting the relevant CHANGELOG section as the release body. Tags anchor version strings to specific commits; Releases surface them in the repo UI and enable future API-based version checks in `$forge-update`.
- [ ] **Diagrams reviewed** — if a new pipeline phase was added, or the delivery lifecycle changed materially, update: `~/.codex/forge/forge-sequence.mmd` (installed single-file) and `docs/diagrams/framework-complete.mmd` + the relevant `docs/diagrams/phase-NN-*.mmd` file in the Forge repo. Not required for every skill — only when a diagram would be materially wrong without the update.

## Failure Modes

When the skill you just wrote misbehaves, the cause is usually one of these. Full diagnosis and cures in [CRAFT.md](CRAFT.md#failure-modes-of-skill-prose).

| Condition | Behaviour |
|-----------|-----------|
| Agent stops a step before it's genuinely done | **Premature completion** — sharpen the step's completion criterion first; only split by sequence if it stays fuzzy in practice |
| Same instruction restated in two places, now drifting | **Duplication** — keep one authoritative copy, reference it from the other |
| Skill keeps growing; nobody dares delete | **Sediment** — run the relevance test on every edit and cut dead lines |
| Skill is too long though every line is live | **Sprawl** — disclose tier-3 reference behind context pointers in a sibling file |
| A line that changes nothing versus the agent's default | **No-op** — delete it, or replace a weak leading word with a stronger one |
| A "never" rule that's really steering the happy path | **Negation** — reframe as a positive leading word; keep "never" only for guardrails on consequential/irreversible actions |
| Source is an external skill/article | Stop — use `assimilate`, which handles fit evaluation and attribution |
