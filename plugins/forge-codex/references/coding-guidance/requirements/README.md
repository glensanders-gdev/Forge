# Requirements Rules

Authoring standards for requirements documents — how a requirement is *worded* and how it is
*presented*. Consumed by `$write-prd`, `$write-ord`, `$write-reqs`, and `$write-ac`.

```
rules/requirements/
├── README.md      ← this file
├── language.md    ← voice, modality, banned constructions
└── tables.md      ← table-first presentation, canonical schemas, ID namespaces
```

## Why this is a separate rules category

`rules/common/` is the always-applied baseline for **code**. `rules/[lang]/` is activated
per-project via `$lang-rules`. Neither fits: these rules govern **documents**, and they apply
whenever a requirements document is authored regardless of the project's language or whether
any code exists yet.

This ruleset is not auto-loaded. The four requirement skills cite it by path, per PRINCIPLE 6
(reference, don't duplicate). It exists so the sibling documents share one definition of a
requirement's form — neither `$write-prd` nor `$write-ord` can own it without the other
drifting, and `$write-reqs` is barred from owning templates.

## Scope boundary — read this first

These rules govern **generated document content only**.

They do **not** apply to the skills' own instruction prose. A skill instruction such as
"at least one KPP must be identified" is correct and stays. Applying the language rules to the
skill files themselves would strip the directives that make the skills work.

| Text | Governed? |
|---|---|
| A requirement, criterion, assumption or commitment written into a PRD/ORD/AC document | Yes |
| A skill's instructions to Codex, its rules, its failure-mode table | No |
| Template placeholder text and worked examples inside a template | Yes — examples teach the form |
| Narrative context sections (background, mission, operational scenarios) | Partially — see `language.md` § Narrative sections |

## Enforcement

`$style-check` reads `~/.codex/forge/knowledge/company/style-guide.md`, not this ruleset — a company
style guide may add to these rules but never relaxes them. Where the two conflict, the stricter
requirement wins and the conflict is flagged rather than silently resolved.
