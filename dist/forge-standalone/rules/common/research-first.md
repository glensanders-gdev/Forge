# Research Before Writing

Before writing new implementation code, always search for existing solutions.

Origin: Adapted from Affaan Mustafa (ECC / github.com/affaan-m/ECC)

## Search Order

1. **Codebase first** — search the project. The solution may already exist.
2. **Package registry** — npm, PyPI, crates.io, etc. Prefer a battle-tested library over hand-rolling.
3. **GitHub code search** — `gh search code` or `gh search repos` for open-source implementations.
4. **Primary vendor docs** — confirm API behaviour and version-specific details before implementing.
5. **Web search** — only after the above are exhausted.

## Apply This When

- Starting a new feature or utility function
- Choosing a library or framework
- Implementing an algorithm or data structure
- Picking a test framework or assertion style

## Decision Rule

If an existing solution covers ≥80% of the requirement and can be adopted, ported, or wrapped — prefer it over net-new code. Document the decision in the commit message if the choice is non-obvious.

## Never

- Never write utility code without first checking if a library covers it.
- Never skip the codebase search — duplication is the most common cause of drift.
- Never implement from memory of an API without checking current docs.
- Never choose a library without checking its maintenance status and licence.
