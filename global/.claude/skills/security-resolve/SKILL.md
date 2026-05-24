---
name: security-resolve
description: Mark a security finding as resolved. Records resolution date, resolver, and fix description in the assessment report. Closes the kanban ticket if one exists. Use when user runs /security-resolve [SEC-YYYYMMDD-NNN] after fixing a security finding.
---

# Security Resolve

Mark a `SEC-YYYYMMDD-NNN` finding as resolved. Manual assertion — the developer confirms
the fix. The next `/security-assessment` run serves as independent verification.

---

## Usage

```
/security-resolve SEC-20260524-001
/security-resolve SEC-20260524-001 --note "Replaced string concat with parameterised query"
```

---

## Process

### 1 — Find the finding

Search `docs/security/` for assessment reports containing the specified ID.
If multiple reports reference the ID, use the most recent.

If no report found:
```
❌ Finding SEC-YYYYMMDD-NNN not found in any report under docs/security/.
   Check the ID and try again.
```
Exit.

### 2 — Check status

If the finding is already marked resolved:
```
ℹ️ SEC-YYYYMMDD-NNN is already marked resolved on YYYY-MM-DD.
   Resolution note: [existing note]

   Re-resolve with an updated note? (yes/no)
```

### 3 — Get resolution note

If `--note` was not provided, ask:
> "How was this finding fixed? (brief description for the record)"

### 4 — Update the report

Append a resolution block to the finding's row in the report:

```markdown
**Resolved:** YYYY-MM-DD
**Fix:** [resolution note]
**Verified by:** Next /security-assessment run
```

Add a Resolution Log section at the bottom of the report if not present:

```markdown
## Resolution Log

| ID | Resolved | Fix Summary |
|----|----------|-------------|
| SEC-YYYYMMDD-NNN | YYYY-MM-DD | [note] |
```

### 5 — Close kanban ticket

Search `docs/kanban.md` for a ticket referencing the finding ID.
If found, mark it complete:
```markdown
- [x] SEC-YYYYMMDD-NNN — Security finding (see docs/security/assessment-YYYY-MM-DD.md) | High | security
```

If not found, note it silently — the finding may not have been promoted to kanban.

### 6 — Confirm

```
✅ SEC-YYYYMMDD-NNN marked resolved.

   Report: docs/security/assessment-YYYY-MM-DD.md
   Fix: [note]
   Kanban ticket: closed / not found

   Independent verification: next /security-assessment run will confirm
   the fix is effective. If the issue reappears it will be assigned a new ID.
```

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| ID not found in any report | Exit with clear message |
| Already resolved | Show existing resolution, ask to re-resolve |
| No `--note` provided | Prompt for one — never resolve without a note |
| `docs/security/` missing | Note that no reports exist |
| Kanban ticket not found | Resolve the report entry regardless — kanban is optional |

---

## Rules

- Never modify the finding's original row — only append the resolution block
- A resolution note is always required — do not allow empty notes
- This skill is advisory confirmation only — it does not re-run or verify the fix
- The report file is gitignored — this skill modifies a local-only file
