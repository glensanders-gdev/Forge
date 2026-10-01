# Fix One Thing — Reference

Read from `/fix-one-thing` steps 2, 6 and 10.

## Checkable rules

A rule is **checkable** when two reviewers looking at the same line would agree, without
discussion, whether it violates the rule.

| Checkable — candidate | Judgement call — never a candidate |
|---|---|
| No magic numbers — a bare literal with meaning | KISS, DRY, YAGNI |
| Every promise awaited, returned or `void`ed | "Readable", "clear", "clean" |
| Catch clause narrows `unknown` before use | Naming quality beyond a stated convention |
| Throw `Error` subclasses, never strings | Whether an abstraction is worth it |
| `import type` for type-only imports | File split points below the hard cap |
| No `any` | Comment density |
| No debug print/log in production paths | |
| Constant naming convention (e.g. `UPPER_SNAKE_CASE`) | |
| Function over the hard line cap — **only** if extraction fits the blast radius | |
| Nesting over the hard depth cap — early return fixes it inside the blast radius | |

A file over the hard **length** cap almost never fits the blast radius; log it to tech-debt.

## Selection ranking

Rank qualified candidates by these keys, in order; the first key that separates two
candidates decides.

1. **Severity of the rule** — security and secrets › error handling › type safety › naming and
   style.
2. **Already covered by a test** — covered › needs a characterisation test.
3. **Smaller diff** — fewer changed lines wins.
4. **Came from `docs/tech-debt.md`** — a registered item beats a fresh find at equal rank.
5. **Least recently touched file** — lowest chance of colliding with active work
   (`git log -1 --format=%ci -- [file]`).

## PR body

Fill every section. Keep it short and identical in shape every run — the reviewer learns where
to look.

```markdown
## Rule

> [rule text, quoted verbatim]

Source: `[path to the standards file]`

Standards read: [each source, and any that contributed no checkable rules — e.g. "CODING-STANDARDS.md: process guidance only"]

## Violation

`[file]:[line]` — [one sentence: what the code did that broke the rule]

## Why this one

[one sentence, naming the ranking key that decided it]

Runners-up: [file:line — rule], [file:line — rule] (or "none")

## Not changed

- [what was deliberately left alone — neighbouring violations, callers, public surface]
- Tech-debt rows written this run, uncommitted: [TD-NNN — rule, N instances, …] (or "none")

## Evidence

| | Tests | Result |
|---|---|---|
| Before | [command] | [N passed, 0 failed] |
| After | [command] | [N passed, 0 failed] |

Characterisation test added: [path] (or "no — existing tests cover the change")
Diff: [N files, +A −R lines; size = max(A, R) of the 50-line limit]
```
