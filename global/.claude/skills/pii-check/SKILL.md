---
name: pii-check
category: pipeline
description: Scan the codebase and Forge documents for Personal Identifying Information (PII). Classifies findings as Necessary or Incidental, assesses handling of Necessary PII, suggests remediation, and saves a living compliance report. AFK scan, HITL review. Use when user runs /pii-check, during QA before /approve, or when /approve detects unresolved PII findings.
---

# PII Check

Scan the solution and its documentation for Personal Identifying Information. Produce a structured report, classify findings, and guide the human through remediation decisions. The AI scans and suggests — the human decides.

## Pipeline Position

```
/tdd → /qa-plan → /pii-check → /approve
```

`/approve` checks for unresolved PII findings before proceeding. Unresolved findings trigger a warning — the human may override with `OVERRIDE` + mandatory reason, recorded in the report.

---

## Phase 1 — AFK Scan

Runs unattended. Never modifies any file during this phase.

### 1. Load Company AI Policy

Read `~/.claude/companies/[active_company]/config.md` (if set) for `ai_data_restrictions`. If set, surface at the top of the report:

```
## Company AI Data Policy

ai_data_restrictions: [value from config]

Note: This policy governs what data may appear in AI prompts during development.
Review findings below against this restriction as part of the PII assessment.
```

If no company config or no restriction set, skip this section silently.

### 2. Load PII Categories

**Default categories:**
- Names (first, last, full, usernames that map to real people)
- Email addresses
- Phone numbers
- Physical addresses (street, city, postcode, country combinations)
- Government IDs (passport, national ID, tax file number, social security)
- Financial data (card numbers, account numbers, BSB, sort codes, IBAN)
- Health data (medical record numbers, diagnoses, prescriptions, health identifiers)
- Dates of birth

**Custom categories:** Read `~/.claude/knowledge/company/pii-categories.md` if it exists. Merge with defaults.

### 3. Load System Context

Read relevant `~/.claude/knowledge/systems/*/overview.md` and `known-issues.md` — note any system-level encryption, access control, or known PII handling gaps. This informs the handling assessment for Necessary PII findings.

### 4. Load Existing Report

Read `docs/pii-report.md` if it exists — load previously Accepted and Deferred findings to avoid re-flagging them.

### 5. Scan Codebase

Scan all source files, test fixtures, config files, and environment templates:
- Hardcoded PII values (real names, emails, phone numbers in code or tests)
- PII fields in schemas, models, and data structures
- PII in log statements
- PII passed to third-party APIs or external services
- PII in comments or documentation strings

### 6. Scan Forge Documents

Scan `docs/` folder:
- PRDs — example data, user stories with real names
- `CONTEXT.md` — domain terms with real identifiers
- `DEVLOG.md` — session notes mentioning real people or data
- `docs/research/` — research files with real data examples
- `docs/kanban.md` — ticket descriptions with PII

### 7. Classify Findings

For each finding, classify as:

**Necessary** — PII the solution requires to function:
- User profile fields (email, name, phone)
- Authentication identifiers
- Legally required data retention

**Incidental** — PII that should not be there:
- Real data in test fixtures
- Hardcoded values that should be env vars or faker data
- Real names in code comments or example data
- PII inadvertently captured in planning documents

### 8. Assess Handling (Necessary PII only)

For each Necessary PII finding, assess:
- **Encryption at rest** — is it encrypted? Does the system support it? (reference system knowledge)
- **Access control** — is access restricted? Who can read it?
- **Logging** — is it appearing in logs or error messages?
- **Third-party exposure** — is it passed to external APIs or services?
- **Data minimisation** — is only the minimum necessary data collected?
- **Retention** — is there a retention policy?

Flag handling gaps as sub-findings under the Necessary PII item.

---

## Phase 2 — HITL Review

Present findings to the human one at a time. Do not present all findings at once — this is a deliberate review, not a list to skim.

### Review Format Per Finding

```
## PII Finding #N

**Type:** [PII category]
**Classification:** Necessary | Incidental
**Location:** [file:line or document:section]
**Finding:** [what was found — paraphrased, never reproduce the actual PII value]

**Handling Assessment** (Necessary only):
- Encryption at rest: ✅ Yes / ❌ No / ⚠️ Unknown — [system context note]
- Access control: ✅ Yes / ❌ No / ⚠️ Unknown
- Logging risk: ✅ Safe / ❌ Logged / ⚠️ Unknown
- Third-party exposure: ✅ None / ❌ Exposed to [service] / ⚠️ Unknown
- Data minimisation: ✅ Minimal / ⚠️ Review needed

**Suggested Remediation:**
[Specific, actionable suggestion based on finding type and context]

Examples by type:
- Incidental real email in test → "Replace with faker.email() or a clearly fake domain like user@example.com"
- Incidental name in fixture → "Replace with a synthetic name (e.g. 'Test User')"
- Hardcoded value → "Move to environment variable — reference as process.env.TEST_EMAIL"
- PII in logs → "Remove from log statement or replace with a non-identifying reference (e.g. user ID)"
- Necessary PII not encrypted → "Add encryption at rest — [system-specific guidance from knowledge base]"
- PII passed to third party → "Confirm consent and data processing agreement covers this transfer"

**Decision required:**
Type one of:
- REMOVE — proceed with suggested remediation (AI will not implement — human action required)
- ACCEPT [reason] — Necessary PII, handling confirmed adequate
- DEFER [reason] — known issue, addressed later
- SKIP — not actually PII, false positive
```

### After Each Decision

Record the decision in `docs/pii-report.md` and move to the next finding.

---

## PII Report Format

```markdown
# PII Report: [Project Name]

**Last scan:** YYYY-MM-DD
**Scanned by:** Forge /pii-check
**Status:** Clean | Findings Unresolved | All Reviewed

---

## Summary

| Category | Necessary | Incidental | Unresolved |
|----------|-----------|------------|-----------|
| Names | N | N | N |
| Emails | N | N | N |
| [etc] | | | |
| **Total** | **N** | **N** | **N** |

---

## Active Findings

### Finding #N — [PII Type] — [Status: Unreviewed]

**Classification:** Necessary | Incidental
**Location:** [file:line]
**Finding:** [description — never the actual PII value]
**Handling gaps:** [if Necessary]
**Suggested remediation:** [action]
**Decision:** Unreviewed
**Date:** YYYY-MM-DD

---

## Resolved Findings

### Finding #N — [PII Type] — [Status: Removed | Accepted | Deferred | Skipped]

**Classification:** Necessary | Incidental
**Location:** [file:line]
**Finding:** [description]
**Decision:** Removed | Accepted | Deferred | Skipped
**Reason:** [mandatory for Accepted and Deferred]
**Resolved:** YYYY-MM-DD

---

## Approve Override Log

| Date | Override reason | Unresolved findings at time of override |
|------|----------------|----------------------------------------|
| | | |
```

---

## Integration with `/approve`

When `/approve` runs, it reads `docs/pii-report.md`:

- **No report found** → warn: "No PII report found. Run `/user:pii-check` before approving."
- **All findings resolved** → proceed normally
- **Unresolved findings exist** → warn:

```
⚠️ Unresolved PII findings

The following findings have not been reviewed:
- Finding #N: [type] at [location]
- Finding #N: [type] at [location]

Type OVERRIDE [reason] to approve despite unresolved findings.
The reason will be recorded in the PII report and approval record.
Or type CANCEL to run /pii-check first.
```

---

## Custom PII Categories

Create `~/.claude/knowledge/company/pii-categories.md` to extend the default categories:

```markdown
# Custom PII Categories

## [Category Name]
**Description:** What this category covers
**Examples:** [pattern or example — never real data]
**Handling requirements:** [company-specific requirements]
```

---

## Rules

- Never reproduce actual PII values in the report or session — describe the finding in general terms only
- Never modify any file during Phase 1 — scan only
- Present findings one at a time during HITL review — never dump the full list
- Accepted and Deferred findings carry forward to future scans — not re-flagged
- Skipped findings (false positives) are recorded but not re-flagged
- Suggested remediation is advisory only — the human takes action
- Override at `/approve` requires a written reason — never accept blank override
- System knowledge base must be consulted before assessing handling of Necessary PII

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No source files found | Note "No source files detected." Scan Forge documents only. |
| `pii-categories.md` not found | Use default categories only. Note custom categories file is missing. |
| System knowledge not available for a finding | Mark handling assessment as "⚠️ Unknown — no system knowledge available" |
| `docs/pii-report.md` corrupted or unreadable | Create a fresh report. Note prior history may be lost. |
| All findings already resolved in prior run | Report "✅ No new PII findings. All prior findings resolved." |
