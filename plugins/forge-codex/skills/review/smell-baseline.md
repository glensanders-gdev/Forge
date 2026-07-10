# Standards Axis — Code Smell Baseline

The immutable floor for the Standards axis of `$review`. Adapted from Martin Fowler's _Refactoring_ smell catalogue, via Matt Pocock's `code-review` skill (github.com/mattpocock/skills).

## How to use this baseline

- **The repo overrides.** A project's documented standards (`docs/CONTEXT.md`, `docs/adr/`, `.codex/forge/CODING-STANDARDS.md`, active language rules) always win. If a project doc endorses a pattern listed here, that is not a finding.
- **Skip tooling-enforced rules.** If a linter or formatter already catches it, do not flag it — that is noise.
- **Every smell is a judgment call.** Nothing here is a hard violation on its own. Baseline smells cap at P2 unless they cause an actual correctness or ADR problem. Only documented-standard breaches and Spec misses reach P1.

## The twelve smells

| Smell | Diagnosis | Remedy |
|-------|-----------|--------|
| **Mysterious Name** | An identifier that doesn't say what it is or does. | Rename until the name explains itself. |
| **Duplicated Code** | The same structure appears in more than one place. | Extract the shared logic to one home. |
| **Feature Envy** | A function is more interested in another object's data than its own. | Move the function to the data it envies. |
| **Data Clumps** | The same cluster of fields travels together across signatures. | Bundle them into their own type. |
| **Primitive Obsession** | A primitive stands in for a domain concept (money as a number, id as a bare string). | Introduce a type for the concept. |
| **Repeated Switches** | The same `switch`/`if`-ladder on the same value recurs across the code. | Replace with polymorphism or a shared lookup. |
| **Shotgun Surgery** | One conceptual change forces edits scattered across many files. | Consolidate the affected logic into one module. |
| **Divergent Change** | One module is edited for several unrelated reasons. | Split it so each reason has its own module. |
| **Speculative Generality** | Abstraction, hooks, or params added for a need the spec doesn't have. | Delete it — YAGNI. |
| **Message Chains** | Long navigations like `a.b().c().d()` couple callers to deep structure. | Hide the navigation behind one method. |
| **Middle Man** | A class that mostly just delegates to another. | Talk to the real target directly. |
| **Refused Bequest** | A subclass ignores or rejects much of what it inherits. | Prefer composition over the inheritance. |

Cite the smell by name in the Standards axis report, with `file:line`, why it applies here, and the remedy.
