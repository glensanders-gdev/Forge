<!-- Forge project template — update this file from the Forge repo when upgrading -->

# Coding Standards

Reference file — loaded on demand before any code change. Do not load at session start.

---

## Pre-Change Protocol

Before making any significant change, explicitly state:

1. **What** file and function is being changed
2. **Exact string** to be replaced (and occurrence count — must be exactly 1)
3. **Expected outcome** after the change
4. **Rollback plan** if the change fails

> If the occurrence count is not exactly 1, stop and investigate before proceeding.

---

## Change Scope Discipline

- Handle **one logical change at a time**.
- Verify the change works before moving to the next.
- Do not bundle multiple unrelated changes in a single patch.
- Changes that touch more than one layer are high risk — flag before proceeding.
- If a patch requires changes in more than 3 places, consider whether the approach is right.

### Layer Tags

Tag every change with the layer(s) it touches:

- `[UI]` — HTML structure, CSS, visual output
- `[DATA]` — localStorage, database schema, data structures
- `[LOGIC]` — business rules, calculations, state management
- `[SYNC]` — external API calls, database sync, network
- `[INFRA]` — error handling, init, routing, PWA

---

## Rollback Policy

| Situation | Action |
|-----------|--------|
| Patch string not found (0 or 2+ matches) | Stop. Investigate before proceeding. |
| Syntax error after patch | Fix immediately — do not move on. |
| Two consecutive fix attempts fail | Restore from last versioned save. |
| File size changes unexpectedly (>10%) | Verify — likely a splice error. |
| Features disappear after a patch | Restore from last versioned save. |

Restoring is not failure — it is correct engineering practice.

---

## Dependency Awareness

- Before changing HTML structure, check all JS references to that element.
- Before changing a function signature, check all call sites.
- Before changing a data format, check all read and write paths.
- Note dependencies explicitly: "This change requires X to also be updated."

---

## Assumption Logging

- State all assumptions explicitly before acting on them.
- Do not proceed on an assumption without user confirmation.
- Log confirmed assumptions in DEVLOG under "Assumptions Made."
- If an assumption turns out wrong, log the correction.

---

## Advisory vs Implementation

- Clearly distinguish between recommendation and code.
- Prefix advisory responses with **"Advisory only — no changes made."**
- Log advisory discussions in DEVLOG even if not implemented.
- Do not implement something discussed as advisory without explicit instruction.

---

## Versioning Rules

**Single-file projects** (e.g. a standalone HTML app, a script):
- Every session produces at minimum one versioned file save.
- Version format: `vX_XX` incrementing per meaningful change.
- Save to both the working file AND a versioned copy.
- **Never overwrite a versioned file.**
- Bump version after every verified working change — not just at session end.

**Multi-file projects** (e.g. a web app, API, or any project with a `src/` directory):
- Git is the version of record. Commit after every verified working change.
- Use git tags for significant milestones: `git tag v1.3 -m "Feature: auth complete"`
- Never rely on file copies as version saves — use `git stash` or branches for safety nets.
- Commit messages should state what changed and why, not just what file was touched.
- The `vX_XX` file-save convention does **not** apply to multi-file projects.

---

## What Good Looks Like

A well-run session:
- Starts with agreed goals and current version stated
- Makes one change at a time, verified before the next
- Has a versioned save after each verified change
- Ends with documentation updated and backlog current

A session going wrong:
- Multiple changes bundled into one patch
- Syntax errors not fixed before moving on
- File restored from version but cause not investigated
- Session ends without documentation update
- "It should work" without verification

---

## Project-Specific Patterns

*This section is populated by `push-standards`. Forge defaults above are never modified.*

_No project-specific patterns documented yet._
