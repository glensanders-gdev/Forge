# Coding Style — Universal Baseline

> Applies to all projects. Language-specific rules in `../<lang>/coding-style.md` extend and may override these.

Origin: Adapted from Affaan Mustafa (ECC / github.com/affaan-m/ECC)

## Immutability

Always return new values — never mutate existing data structures in-place.
Immutable patterns prevent hidden side effects and make debugging deterministic.

**Language note:** This rule may be overridden by language-specific rules where mutation is idiomatic (e.g. Go pointer receivers, Rust ownership patterns).

## Core Principles

**KISS** — prefer the simplest solution that works. Optimise for clarity, not cleverness.
**DRY** — extract repeated logic when repetition is real, not speculative.
**YAGNI** — do not build features or abstractions before they are needed.

## File and Function Limits

| Measure | Target | Hard cap |
|---------|--------|----------|
| File length | 200–400 lines | 800 lines |
| Function length | <30 lines | 50 lines |
| Nesting depth | ≤3 levels | 4 levels |

When a file or function hits the cap, extract — do not leave it.

## Error Handling

- Handle errors explicitly at every level. Never swallow silently.
- User-facing code: provide human-readable messages.
- Server/backend: log full context (error type, relevant inputs).
- Fail fast at system boundaries (user input, external APIs, file I/O).

## Input Validation

- Validate all input at system boundaries before processing.
- Use schema-based validation where available (Zod, Pydantic, etc.).
- Never trust external data: API responses, user input, file content.

## Naming

- Functions and variables: descriptive, action-oriented, in language idiom
- Booleans: `is`, `has`, `should`, or `can` prefixes
- Constants: UPPER_SNAKE_CASE
- Never abbreviate unless the abbreviation is universally understood (e.g. `id`, `url`, `api`)

## Never

- Never leave debug print/log statements in production code
- Never hardcode secrets, API keys, or passwords
- Never use magic numbers — name your constants
- Never suppress errors to make tests pass
- Never write code that only the original author can understand
