---
name: write-a-skill
category: framework
standalone: false
description: Create new Forge skills with proper structure, correct file locations, and updated manifest. Use when user wants to create, write, or add a new skill to Forge, or mentions /write-a-skill.
---

# Write a Skill

Create a new skill for Forge following the standard structure. Skills live in `~/.claude/skills/` (global) or `.claude/skills/` (project-level override).

> **Writing well** — this file covers *structure* (which files, what to update). For the
> *craft* of the prose inside them — **leading words**, checkable **completion criteria**,
> information hierarchy, and pruning out **no-ops** — read [CRAFT.md](CRAFT.md) before
> drafting a description or step. Predictability (same process every run) is the goal.
>
> **Names** — [RESERVED-NAMES.md](RESERVED-NAMES.md) holds the names Claude Code already claims,
> and step 2 below gates on it. A shadowed skill never loads and says nothing about why.

## Process

1. **Gather requirements** — ask the user:
   - What does this skill do?
   - What triggers it? (keywords, slash command, context)
   - Is it global (all projects) or project-specific?
   - Does it need supporting files (REFERENCE.md, EXAMPLES.md, scripts)?

2. **Check the name against [RESERVED-NAMES.md](RESERVED-NAMES.md)** — compare the proposed
   name to every Reserved row before anything is scaffolded. Report the result either way:
   "`<name>` is not on the reserved list (last verified YYYY-MM-DD)" is the pass, and it names
   the date so the author knows what the clearance is worth.

   **On a match, stop and gate.** Name the collision, quote the row's source and the stamp date,
   and offer two paths: a different name, or proceeding under the existing one. Proceeding
   requires the human to type `CONFIRM` — the list is stale by construction, so an author who
   knows the name has since been released may override it. Never scaffold through a match on
   your own judgement.

   Check the At Risk table too. A hit there is not a block — say so, and move on.

3. **Draft the skill** — create:
   - `SKILL.md` with concise instructions — target under 100 lines; if workflow logic exceeds this, extract supporting content (reference tables, templates, examples, scripts) to additional files (`REFERENCE.md`, `FORMATS.md`, `scripts/`, etc.)
   - Additional files for any content that would push `SKILL.md` over 100 lines or has a distinct domain
   - A command file if a `/user:skill-name` trigger is needed

4. **Review with user** — present the draft and ask:
   - Does this cover your use cases?
   - Anything missing or unclear?
   - Should any section be more or less detailed?

5. **Write the files** — once confirmed, create all files and update the manifest.

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
Scaffold a new system knowledge folder with blank overview, schema, and known-issues files. Use when user wants to add a system, runs /add-system, or mentions adding a new system to the knowledge base.
```

**Bad:**
```
Helps with systems.
```

## Command File Template

If the skill needs a `/user:skill-name` trigger, create `global/.claude/commands/[skill-name].md` containing plain text only — **not** a SKILL.md frontmatter file. The format is one short paragraph:

```
Invoke the [skill-name] skill. [What it does and what it produces.] [Key arguments or flags if any.] Use when [trigger conditions].
```

**Example** (`global/.claude/commands/handoff.md`):
```
Invoke the handoff skill. Compact the current session into a structured handoff for one stream of work, written to docs/handoffs/[stream].md and indexed in the register at docs/HANDOFF.md. References Forge artifacts by path rather than reproducing them. Suggests which skills the next session should use first. Optional arguments: the stream slug, and a description of what the next session will focus on (e.g. /handoff login-flow "next session: implement the login flow"). Add --archive to also save a timestamped copy, or --close to retire the stream.
```

<!--no-adapt-->The command file is what registers `/user:skill-name` in Claude Code.<!--/no-adapt--> Without it, the skill exists but cannot be invoked as a slash command.

## After Writing Files

1. Update `~/.claude/skills/manifest.json`:
   - New skill: add entry with version `"1.0.0"`
   - Updated skill: bump the existing version (`1.0.0` → `1.1.0`, `1.1.0` → `1.2.0`, etc.). Never leave the manifest at the old version after a meaningful change — a frozen version number is the same as no version number.
   - **`manifest.json` is the only place a skill's version lives.** Never add a `version:` field to `SKILL.md` frontmatter — the template above has none. A version in both files is two sources of truth for one number, and the copy in frontmatter is the one that goes stale, silently, because nothing reads it. `/skill-health` reports one as ⚠️ Amber.
2. Update `~/.claude/CHANGELOG.md` — add an entry for the new or changed skill under the current framework version.
3. Confirm the files created/updated and their locations.
4. Remind the user: project-level skills go in `.claude/skills/[skill-name]/SKILL.md` and override global skills of the same name.
5. Fence any host-product claim. The Codex build rewrites <!--no-adapt-->`Claude Code` → `Codex` and `~/.claude/` → `~/.codex/forge/`<!--/no-adapt--> on every adapted file, so a sentence naming one host as a *distinct product* ships as a false statement. See <!--no-adapt-->`CLAUDE.md`<!--/no-adapt--> § Naming a host product.

## When to Split Files

Split into separate files when:
- `SKILL.md` exceeds 100 lines — extract supporting content to `REFERENCE.md`, `FORMATS.md`, or other named files
- Content has distinct domains (e.g. workflow logic vs output templates vs scripts)
- Advanced reference material (reference tables, stub templates, config schemas) is rarely needed during normal use — keeping it out of `SKILL.md` keeps the workflow scannable

## Review Checklist

Before finalising, verify:
- [ ] Read `~/.claude/PRINCIPLES.md` — does this skill follow the 8 design principles?
- [ ] Read [CRAFT.md](CRAFT.md) — description front-loads a **leading word**, every step has a **checkable completion criterion**, and the prose survives the **no-op test** (no line that changes nothing versus the agent's default)
- [ ] **Name checked against [RESERVED-NAMES.md](RESERVED-NAMES.md)** — no Reserved row matches, or a match was overridden by a typed `CONFIRM` and the reason recorded in the CHANGELOG entry
- [ ] `category:` field set — valid values: `pipeline`, `ideation`, `session`, `code-quality`, `knowledge`, `metrics`, `pi-release`, `sprint`, `maintenance`, `company`, `framework`
- [ ] Description includes "Use when [triggers]"
- [ ] **If adapting from an external source** — use `/user:assimilate` instead. It handles attribution, fit evaluation, and adaptation automatically.
- [ ] `SKILL.md` is under 100 lines — dense reference tables, stub templates, and rarely-needed config extracted to `REFERENCE.md` or additional named files
- [ ] No time-sensitive information included
- [ ] Terminology consistent with `docs/CONTEXT.md`
- [ ] `manifest.json` updated with new skill and version `"1.0.0"`
- [ ] `SKILL.md` frontmatter carries **no** `version:` field — the manifest owns the version
- [ ] Command file created if slash command needed
- [ ] **Host names fenced** — every sentence that names <!--no-adapt-->Claude Code, Claude Desktop, or a `~/.claude/` path<!--/no-adapt--> as a specific product, rather than meaning "the host you are running on", is wrapped in a `no-adapt` fence. Ask which host the sentence is *about*, not which host will read it
- [ ] **`~/.claude/skills/commands/SKILL.md` updated** — add the new command to the correct section in the command reference table. This is mandatory — never skip it.
- [ ] **`~/.claude/CHANGELOG.md` updated** — add the new skill under the current `forge_version` entry (or create a new version entry if bumping the version). Version bump guidance: patch (x.x.N) for skill fixes, minor (x.N.0) for new skills, major (N.0.0) for lifecycle changes (new pipeline phases, fundamental workflow changes). Never let the changelog drift from the actual skill set.
- [ ] **`README.md` updated** — increment the skill count in the "What's Included" intro line (e.g. "**94 skills**"), add the new skill to the correct category row in the table, and update any other inline counts (e.g. the file structure section).
- [ ] **Git tag and GitHub Release created** — after merging to `main`: (1) push the tag: `git tag v[forge_version] <main-sha> && git push origin v[forge_version]`; (2) create a GitHub Release at `github.com/glensanders-gdev/Forge/releases/new` using that tag, pasting the relevant CHANGELOG section as the release body. Tags anchor version strings to specific commits; Releases surface them in the repo UI and enable future API-based version checks in `/update-forge`.
- [ ] **Diagrams reviewed** — if a new pipeline phase was added, or the delivery lifecycle changed materially, update: `~/.claude/forge-sequence.mmd` (installed single-file) and `docs/diagrams/framework-complete.mmd` + the relevant `docs/diagrams/phase-NN-*.mmd` file in the Forge repo. Not required for every skill — only when a diagram would be materially wrong without the update.

## Failure Modes

When the skill you just wrote misbehaves, the cause is usually one of these. Full diagnosis and cures in [CRAFT.md](CRAFT.md#failure-modes-of-skill-prose).

| Condition | Behaviour |
|-----------|-----------|
| Agent stops a step before it's genuinely done | **Premature completion** — sharpen the step's completion criterion first; only split by sequence if it stays fuzzy in practice |
| Same instruction restated in two places, now drifting | **Duplication** — keep one authoritative copy, reference it from the other |
| Skill keeps growing; nobody dares delete | **Sediment** — run the relevance test on every edit and cut dead lines |
| Skill is too long though every line is live | **Sprawl** — disclose tier-3 reference behind context pointers in a sibling file |
| A line that changes nothing versus the agent's default | **No-op** — delete it, or replace a weak leading word with a stronger one |
| A "never" rule that's really steering intended behaviour | **Negation** — reframe as a positive leading word; keep "never" only for guardrails on consequential/irreversible actions |
| Skill was authored and never loads, with no error | **Shadowed name** — a vendor command won it. Check [RESERVED-NAMES.md](RESERVED-NAMES.md); a rename is a major version, and no stub or alias survives at the old name |
| `SKILL.md` frontmatter has a `version:` field | Delete the line, whatever it says. Never reconcile it against the manifest instead — that keeps the second source of truth alive |
| Proposed name matches a Reserved row | Stop and gate — offer a rename, or a typed `CONFIRM` to proceed. Never decide it alone |
| Reserved list stamp is older than the staleness threshold | Say so at the point of the check, run the refresh procedure in [RESERVED-NAMES.md](RESERVED-NAMES.md), then check the name |
| Source is an external skill/article | Stop — use `/user:assimilate`, which handles fit evaluation and attribution |
| Generated Codex copy states something untrue about its host | **Host-name falsification** — an unfenced product name was rewritten by the build; fence the span and rerun `tools/build-forge-codex.ps1` |
