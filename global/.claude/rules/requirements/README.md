# Requirements Rules

Authoring standards for requirements documents — how a requirement is *worded* and how it is
*presented*. Consumed by `/write-prd`, `/write-ord`, `/write-reqs`, and `/write-ac`.

```
rules/requirements/
├── README.md      ← this file
├── language.md    ← voice, modality, banned constructions
├── tables.md      ← table-first presentation, canonical schemas, ID namespaces
└── ai.md          ← conditional: learned or generated behaviour (see trigger test)
```

`language.md` and `tables.md` are unconditional — every requirements document obeys both.
`ai.md` is **conditional**: it applies on top of the other two when a delivered component's
behaviour is learned or generated rather than specified, and it never relaxes either. See
ADR-0003 for why AI requirements extend the pack rather than forming a fourth document.

## Why this is a separate rules category

`rules/common/` is the always-applied baseline for **code**. `rules/[lang]/` is activated
per-project via `/lang-rules`. Neither fits: these rules govern **documents**, and they apply
whenever a requirements document is authored regardless of the project's language or whether
any code exists yet.

This ruleset is not auto-loaded. The requirement skills cite it by path, per PRINCIPLE 6
(reference, don't duplicate). It exists so the sibling documents share one definition of a
requirement's form — neither `/write-prd` nor `/write-ord` can own it without the other
drifting, and `/write-reqs` is barred from owning templates.

## Scope boundary — read this first

These rules govern **generated document content only**.

They do **not** apply to the skills' own instruction prose. A skill instruction such as
"at least one KPP must be identified" is correct and stays. Applying the language rules to the
skill files themselves would strip the directives that make the skills work.

| Text | Governed? |
|---|---|
| A requirement, criterion, assumption or commitment written into a PRD/ORD/AC document | Yes |
| A skill's instructions to Claude, its rules, its failure-mode table | No |
| Template placeholder text and worked examples inside a template | Yes — examples teach the form |
| Narrative context sections (background, mission, operational scenarios) | Partially — see `language.md` § Narrative sections |

`ai.md` adds one boundary of its own: it governs AI as the **subject** of a requirement. AI as the
**author** of the solution is `ai-first-engineering`, which is not a requirements ruleset and is not
governed here.

## Enforcement

`/check-style` reads `~/.claude/knowledge/company/style-guide.md`, not this ruleset — a company
style guide may add to these rules but never relaxes them. Where the two conflict, the stricter
requirement wins and the conflict is flagged rather than silently resolved.
