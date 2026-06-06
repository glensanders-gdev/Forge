<!-- Forge v2.3.2 — update from project template when upgrading Forge -->

# Security Checkpoints

Reference file — loaded on demand before any change touching data storage, external APIs, or authentication. Do not load at session start.

---

## Security Questions (Ask Before Every Relevant Change)

For any change touching data storage, external APIs, or authentication, explicitly ask:

- Does this expose data it shouldn't?
- Is any credential visible in client-side code that shouldn't be?
- Can one user access another user's data?
- What happens if this fails — does it fail safely?

Note all security decisions in `docs/adr/`.

---

## PII Awareness

Before writing any code that handles user data:

- Check `~/.codex/forge/knowledge/company/pii-categories.md` for the full list of PII categories
- Never log PII to the console or error output
- Never hardcode real user data in tests or fixtures — use synthetic data
- Run `pii-check` before QA if the feature handles any user-identifiable data

---

## Credential Rules

- Never store API keys, tokens, or secrets in source code
- Never commit `.env` files — ensure they are in `.gitignore`
- Environment variables must be documented in `.codex/forge/deploy.md` (variable names only — never values)
- If a secret is accidentally committed, rotate it immediately before anything else
