# Pre-Ship Quality Checklist

Run before marking any ticket complete. Referenced by `review` and `qa-plan`.

Origin: Adapted from Affaan Mustafa (ECC / github.com/affaan-m/ECC)

## Code Quality

- [ ] Code is readable without comments explaining what it does
- [ ] Functions are focused — one responsibility, <50 lines
- [ ] Files are cohesive — <800 lines; extract if larger
- [ ] Nesting depth ≤4 levels — use early returns instead of nesting
- [ ] No mutation of shared state
- [ ] Errors handled explicitly at every level
- [ ] No hardcoded secrets or credentials
- [ ] No debug print/log statements in production paths

## Testing

- [ ] Tests exist for all new logic
- [ ] Tests are named to describe behaviour, not implementation
- [ ] Coverage meets project minimum (Forge default: 80%)
- [ ] Tests pass clean — no skipped tests without a documented reason

## Security

- [ ] No hardcoded secrets (API keys, passwords, tokens)
- [ ] All user input validated at the entry point
- [ ] Query parameters are parameterised — never concatenated into queries
- [ ] No sensitive data in logs or error messages

## Integration

- [ ] CI/CD checks pass
- [ ] No unresolved merge conflicts
- [ ] Branch is up to date with target

## Rules

- Never mark a ticket complete if any CRITICAL or HIGH item above is unchecked.
- MEDIUM and LOW items: document the reason if skipping.
- This checklist is the minimum — language-specific rules may add items.
