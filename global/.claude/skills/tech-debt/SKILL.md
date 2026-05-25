---
name: tech-debt
description: Track and manage technical debt in the current project. Add entries with priority and location, list by priority, and resolve items when addressed. /sprint-start surfaces High items as candidates. Per-project register at docs/tech-debt.md. Use when user runs /tech-debt, identifies debt during a session, or /sprint-start surfaces High items for the sprint.
---

# Tech Debt

Per-project technical debt register. Separate from the backlog — debt has a priority tier
that reflects accumulated interest and surfaces automatically at sprint planning.

---

## Usage

```
/tech-debt add                     ← capture a new debt item
/tech-debt list                    ← show all items, grouped by priority
/tech-debt list --high             ← show High priority only
/tech-debt resolve TD-NNN          ← mark an item as resolved
/tech-debt review                  ← re-prioritise all open items
```

---

## Register Format

`docs/tech-debt.md`:

```markdown
# Tech Debt Register — [Project Name]

## Priority Tiers

- **High** — actively slowing current work right now
- **Medium** — will become High within 2–3 sprints if unaddressed
- **Low** — acknowledged, not blocking

---

## Open

| ID | Description | Priority | Location | Added | Notes |
|----|-------------|----------|----------|-------|-------|
| TD-001 | ORM queries not using eager loading — N+1 on every list view | High | src/db/queries.ts | 2026-05-24 | Impacts all paginated endpoints |

## Resolved

| ID | Description | Priority | Resolved | How |
|----|-------------|----------|---------|-----|
```

---

## `/tech-debt add`

Ask in sequence:

1. **Description** — what is the debt? Be specific about the code concern.
2. **Location** — file path or module (e.g. `src/auth/session.ts`, `all API handlers`)
3. **Priority** — High / Medium / Low. Present the definitions:
   ```
   High   — actively slowing current work right now
   Medium — will become High within 2–3 sprints
   Low    — acknowledged, not blocking
   ```
4. **Notes** — optional context, links, or impact description

Assign the next TD-NNN ID. Show the entry for confirmation before writing:

```
Ready to add:

  TD-004 | Missing database indexes on user lookups | High
  Location: src/db/schema.ts
  Notes: Every search query does a full table scan — visible in staging load tests

Add to docs/tech-debt.md? (yes/no)
```

If confirmed, append to the Open table.

---

## `/tech-debt list`

Display all open items grouped by priority:

```
## Tech Debt — [Project Name]

### 🔴 High (N items)
TD-001 | ORM N+1 on list views | src/db/queries.ts | Added 2026-05-01
TD-004 | Missing DB indexes on user lookups | src/db/schema.ts | Added 2026-05-24

### 🟡 Medium (N items)
TD-002 | Auth middleware duplicated across 3 routes | src/middleware/ | Added 2026-04-15

### 🔵 Low (N items)
TD-003 | Deprecated crypto algorithm in token signing | src/auth/tokens.ts | Added 2026-03-10

Resolved: N items (run /tech-debt list --resolved to view)
```

---

## `/tech-debt resolve TD-NNN`

Ask:
> "How was TD-NNN resolved? (brief note for the record)"

Move the entry from Open to Resolved, recording the date and fix note.

```
✅ TD-NNN marked resolved.

   Description: [original description]
   Resolved: YYYY-MM-DD
   How: [note]
```

---

## `/tech-debt review`

Present all open items and ask for a priority re-assessment on each:

```
Reviewing open tech debt for [Project Name].

TD-001 | ORM N+1 on list views | Currently: High
New priority? (High / Medium / Low / unchanged)
```

Work through each item. Update any changed priorities. Show a summary at the end:
```
Review complete. Changes: N items re-prioritised.
  TD-002: Medium → High (escalated)
  TD-003: Low → resolved (fixed in sprint)
```

---

## `/sprint-start` Integration

`/sprint-start` reads `docs/tech-debt.md` after sprint goals are confirmed.
If any High priority items exist:

```
⚠️ High priority tech debt in this project:

  TD-001 | ORM N+1 on list views | src/db/queries.ts | Added 2026-05-01
  TD-004 | Missing DB indexes on user lookups | src/db/schema.ts | Added 2026-05-24

Should any of these be scheduled as tickets in this sprint?
```

Human confirms — items are never added automatically.

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| `docs/tech-debt.md` missing | Create it with the standard header on first `/tech-debt add` |
| ID not found for resolve | List open IDs and ask to confirm |
| No High items | Note "No High priority tech debt" in sprint-start — do not warn |
| Empty register | Note "No tech debt registered" on list |

---

## Rules

- Priority definitions are fixed — never invent new tiers
- Descriptions must be specific enough to be actionable: file path or module required
- Never auto-add items — always confirm before writing
- Resolved items are retained in the register for historical reference
- `/sprint-start` surfaces High items only — Medium and Low are not surfaced unless user runs `/tech-debt list`
