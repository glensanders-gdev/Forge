---
name: write-a-skill
description: Create new Forge skills with proper structure, correct file locations, and updated manifest. Use when user wants to create, write, or add a new skill to Forge, or mentions /write-a-skill.
---

# Write a Skill

Create a new skill for Forge following the standard structure. Skills live in `~/.claude/skills/` (global) or `.claude/skills/` (project-level override).

## Process

1. **Gather requirements** — ask the user:
   - What does this skill do?
   - What triggers it? (keywords, slash command, context)
   - Is it global (all projects) or project-specific?
   - Does it need supporting files (REFERENCE.md, EXAMPLES.md, scripts)?

2. **Draft the skill** — create:
   - `SKILL.md` with concise instructions (under 100 lines)
   - Additional files if content exceeds 100 lines or has distinct domains
   - A command file if a `/user:skill-name` trigger is needed

3. **Review with user** — present the draft and ask:
   - Does this cover your use cases?
   - Anything missing or unclear?
   - Should any section be more or less detailed?

4. **Write the files** — once confirmed, create all files and update the manifest.

## File Structure

```
~/.claude/skills/[skill-name]/
  SKILL.md           ← required
  REFERENCE.md       ← if content exceeds 100 lines
  EXAMPLES.md        ← if examples would clutter SKILL.md

~/.claude/commands/[skill-name].md   ← if slash command needed
```

## SKILL.md Template

```markdown
---
name: skill-name
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
- First sentence: what it does
- Second sentence: "Use when [specific triggers]"
- Be specific — vague descriptions cause the wrong skill to be selected

**Good:**
```
Scaffold a new system knowledge folder with blank overview, schema, and known-issues files. Use when user wants to add a system, runs /add-system, or mentions adding a new system to the knowledge base.
```

**Bad:**
```
Helps with systems.
```

## Command File Template

If the skill needs a `/user:skill-name` trigger, create a command file:

```markdown
Invoke the [skill-name] skill. [One sentence describing what it does and what it produces.]
```

## After Writing Files

1. Update `~/.claude/skills/manifest.json` — add the new skill with version `"1.0.0"`
2. Confirm the files created and their locations
3. Remind the user: project-level skills go in `.claude/skills/[skill-name]/SKILL.md` and override global skills of the same name

## When to Split Files

Split into separate files when:
- `SKILL.md` exceeds 100 lines
- Content has distinct domains (e.g. logic vs UI)
- Advanced reference material is rarely needed during normal use

## Review Checklist

Before finalising, verify:
- [ ] Read `~/.claude/PRINCIPLES.md` — does this skill follow the 8 design principles?
- [ ] Description includes "Use when [triggers]"
- [ ] **If adapting from an external source** — use `/user:assimilate` instead. It handles attribution, fit evaluation, and adaptation automatically.
- [ ] `SKILL.md` is under 100 lines
- [ ] No time-sensitive information included
- [ ] Terminology consistent with `docs/CONTEXT.md`
- [ ] `manifest.json` updated with new skill and version `"1.0.0"`
- [ ] Command file created if slash command needed
- [ ] **`~/.claude/skills/commands/SKILL.md` updated** — add the new command to the correct section in the command reference table. This is mandatory — never skip it.
- [ ] **`~/.claude/CHANGELOG.md` updated** — add the new skill under the current `forge_version` entry (or create a new version entry if bumping the version). Version bump guidance: patch (x.x.N) for skill fixes, minor (x.N.0) for new skills, major (N.0.0) for lifecycle changes (new pipeline phases, fundamental workflow changes). Never let the changelog drift from the actual skill set.
