---
name: security-assessment
description: Structured security audit of project code. AI-led threat modelling and OWASP Top 10 review, layered with optional external tool invocation (semgrep, npm audit, bandit, trivy). Writes a gitignored report to docs/security/. Critical and High findings can be promoted to kanban tickets as SEC-NNN references. Use when user runs /security-assessment, before a major release, or when /go-nogo flags the last assessment is overdue.
---

# Security Assessment

Structured security audit of the current project codebase. Goes beyond the pre-commit
checklist in `security.md` — covers threat modelling, attack surface mapping, trust
boundaries, and OWASP Top 10 systematically across the full codebase or a targeted scope.

This skill produces a sensitive report. `docs/security/` is gitignored on first run —
vulnerability details never enter version control.

---

## Usage

```
/security-assessment                     ← full codebase scan
/security-assessment --scope auth        ← authentication and authorisation only
/security-assessment --scope api         ← API layer and request handling
/security-assessment --scope data        ← data validation, queries, serialisation
/security-assessment --scope deps        ← dependency scan only (tool-driven)
/security-assessment src/payments/       ← specific path
```

---

## Compliance Tier

Read `~/.claude/companies/[active_company]/config.md` (if set) for `compliance_tier`
and `compliance_frameworks`. This affects assessment behaviour:

| Tier | Mandatory before release? | Critical finding rule | Scheduled audits |
|------|--------------------------|----------------------|-----------------|
| none | No | Advisory | None required |
| standard | Recommended | Advisory | None required |
| regulated | Yes — /go-nogo will flag if overdue (>30 days) | Must be resolved or formally accepted before GO | None required |
| highly-regulated | Yes — /go-nogo will flag if overdue (>14 days) | Must be resolved before GO — no acceptance without documented justification | Periodic (frequency per framework) |

If frameworks are listed, note them at the top of the report:
```
Compliance context: [APRA / SOX / etc.] — [tier]
```

If no company config, default to `standard` behaviour.

---

## Pre-flight

### 1 — Gitignore setup

Check if `docs/security/` appears in `.gitignore`. If not, add it:

```
# Security assessment reports — never commit vulnerability details
docs/security/
```

Create `docs/security/` if it does not exist.

### 2 — Detect available tools

Check silently for each tool. Note availability for Phase 4 — do not error if absent.

```bash
command -v semgrep   # general pattern scanner
command -v npm       # for npm audit (Node projects)
command -v bandit    # Python static analysis
command -v trivy     # container and dependency CVE scanner
```

### 3 — Announce scope

State what will be assessed and which tools will run before starting:

```
🔍 Security Assessment — [Project Name]
   Scope: [Full codebase / --scope X / path]
   AI analysis: ✅
   semgrep:     ✅ / ⚠️ not installed
   npm audit:   ✅ / ⚠️ not installed / ➖ not a Node project
   bandit:      ✅ / ⚠️ not installed / ➖ not a Python project
   trivy:       ✅ / ⚠️ not installed

Running assessment — this may take a few minutes...
```

---

## Phase 1 — Orient

Read the following to understand the project before assessing:

- `CLAUDE.md` (project root) — architecture overview, tech stack, known constraints
- `docs/CONTEXT.md` — domain glossary, key system boundaries
- Package manifest (`package.json`, `requirements.txt`, `go.mod`, `Gemfile`, etc.)
- Directory structure — identify entry points and key modules

Do not produce output during this phase.

---

## Phase 2 — AI-Led Threat Model

Systematically map the attack surface before reviewing code. Do not produce output during
this phase — findings are consolidated in the report.

### Entry Points
Identify every place external input enters the system:
- HTTP endpoints (REST, GraphQL, webhooks)
- CLI arguments and environment variables
- File uploads and file system reads
- Message queues and event streams
- Scheduled jobs and background workers
- Third-party callbacks and OAuth redirects

### Trust Boundaries
Map where trust levels change:
- Public vs authenticated zones
- User roles and permission levels
- Internal vs external services
- Client-supplied data vs server-generated data

### Data Flows
Trace sensitive data through the system:
- Where does user input go? What transforms it before storage or rendering?
- Where is PII, credentials, or financial data stored and transmitted?
- What gets logged? Could logs contain sensitive data?

---

## Phase 3 — OWASP Top 10 Review (2021)

Review code against each category for the assessed scope. Record findings as they are
identified — consolidate in Phase 5.

| # | Category | Key checks |
|---|----------|-----------|
| A01 | Broken Access Control | Missing auth checks, IDOR, path traversal, privilege escalation |
| A02 | Cryptographic Failures | Hardcoded secrets, weak algorithms, unencrypted sensitive data in transit/at rest |
| A03 | Injection | SQL, NoSQL, command, LDAP, template injection; unsanitised input in queries |
| A04 | Insecure Design | Missing threat controls, insecure design patterns, absent rate limiting |
| A05 | Security Misconfiguration | Debug mode in production, default credentials, verbose errors, open CORS |
| A06 | Vulnerable Components | Outdated dependencies with known CVEs (flagged by tools in Phase 4) |
| A07 | Auth & Session Failures | Weak passwords, missing MFA hooks, insecure session tokens, credential exposure |
| A08 | Data Integrity Failures | Unsigned deserialisation, insecure CI/CD pipeline, auto-update without verification |
| A09 | Logging & Monitoring | Missing security event logging, no alerting on auth failures, sensitive data in logs |
| A10 | SSRF | User-controlled URLs fetched server-side, internal network exposure |

---

## Phase 4 — Tool Invocation (if available)

If `--scope deps` was specified, skip Phases 2 and 3 entirely and begin here.

`[scope-path]` resolves as follows:
- No `--scope` flag or `--scope auth|api|data`: use `.` (project root) for full or category scans
- `--scope deps`: use `.` (project root — tools scan manifests and lock files)
- Path argument (e.g. `src/payments/`): use that path

Run each available tool against the resolved scope. Write output to `docs/security/tmp/`
(already gitignored as a subdirectory of `docs/security/`). Clean up tmp files after
Phase 5 consolidation.

### semgrep
```bash
semgrep --config=auto [scope-path] --json --output docs/security/tmp/semgrep-results.json
```

### npm audit (Node projects only — run from project root regardless of scope-path)
```bash
npm audit --json > docs/security/tmp/npm-audit-results.json
```

### bandit (Python projects only)
```bash
bandit -r [scope-path] -f json -o docs/security/tmp/bandit-results.json
```

### trivy (if Dockerfile or lock files present)
```bash
trivy fs [scope-path] --format json --output docs/security/tmp/trivy-results.json
```

For any tool that is not installed, add a note in the report's Tool Output section:
```
⚠️ [tool] not installed — install for [what it covers]. Run: [install command]
```

---

## Phase 5 — Consolidate Findings

Deduplicate and merge AI findings with tool findings. Assign a `SEC-YYYYMMDD-NNN` ID to
each unique finding (date = report date, NNN sequential within the report). This prevents
ID collisions when multiple reports exist in kanban simultaneously.

Classify severity and confidence:

| Severity | Criteria |
|----------|----------|
| 🔴 Critical | Exploitable now with direct impact — RCE, SQLi, hardcoded production credentials, auth bypass |
| 🟠 High | Significant risk requiring prompt action — XSS, missing auth on sensitive routes, insecure deserialisation |
| 🟡 Medium | Risk that should be addressed — missing input validation, weak crypto, verbose error messages |
| 🔵 Low | Best practice gaps — missing security headers, overly permissive CORS, deprecated functions |
| ℹ️ Info | Observations worth noting — outdated deps with no known CVE, defence-in-depth suggestions |

Assign a confidence level to every AI-generated finding:

| Confidence | Meaning |
|------------|---------|
| High | Directly observed in code — specific file and line, no inference required |
| Medium | Inferred from patterns — likely but requires manual verification |
| Low | Architectural concern — possible risk based on design, not confirmed in code |

**Rule:** Critical severity requires High confidence. A Medium or Low confidence finding
cannot be classified Critical — downgrade to High and mark "requires manual verification."
Tool-generated findings inherit High confidence by default.

After Phase 5, delete `docs/security/tmp/` to remove raw tool output.

---

## Phase 6 — Write Report

Write `docs/security/assessment-YYYY-MM-DD.md`:

```markdown
# Security Assessment — [Project Name]

**Date:** YYYY-MM-DD
**Scope:** [Full codebase / --scope X / path]
**Tools run:** [list or "AI-only"]
**Assessor:** Claude (AI-led security assessment)

---

## Executive Summary

[2–4 sentences: overall posture, most significant findings, immediate priorities]

**Finding counts:** 🔴 N Critical | 🟠 N High | 🟡 N Medium | 🔵 N Low | ℹ️ N Info

---

## Threat Model

### Entry Points
[Bullet list of identified entry points]

### Trust Boundaries
[Boundary map — what is public vs authenticated vs internal]

### Key Data Flows
[Where sensitive data moves and what protects it]

---

## Findings

### 🔴 Critical

| ID | Location | Description | Confidence | Recommendation |
|----|----------|-------------|------------|----------------|
| SEC-20260524-001 | src/auth/login.ts:42 | SQL query built from unsanitised user input | High | Use parameterised queries |

### 🟠 High

| ID | Location | Description | Confidence | Recommendation |
|----|----------|-------------|------------|----------------|

### 🟡 Medium

| ID | Location | Description | Confidence | Recommendation |
|----|----------|-------------|------------|----------------|

### 🔵 Low

| ID | Location | Description | Confidence | Recommendation |
|----|----------|-------------|------------|----------------|

### ℹ️ Info

| ID | Observation | Confidence | Suggestion |
|----|-------------|------------|------------|

---

## Tool Output Summary

### semgrep
[Summary of findings — counts by severity, top patterns]

### npm audit / bandit / trivy
[Summary of findings — counts, highest severity CVEs]

⚠️ [tool] not installed — [what it covers, install command]

---

## Recommended Actions

[Numbered list, Critical first. Each item: SEC-NNN, file/line, specific fix.]

1. SEC-20260524-001 (`src/auth/login.ts:42`) — replace string-concatenated query with parameterised statement. Estimated fix: 30 min.

---

*This report is gitignored. Do not share vulnerability details in tickets or chat — use SEC-NNN reference IDs only.*
```

---

## Phase 7 — Kanban Promotion (optional)

After writing the report, present Critical and High findings and ask:

```
Found N Critical and N High findings.

Would you like to create kanban tickets for these findings?
Tickets will use SEC-NNN reference IDs — no vulnerability details will be committed.

[List SEC-001 through SEC-N with one-line summaries]

Create tickets? (yes / no / select)
```

If yes (or select), create a ticket per confirmed finding using the format:

```markdown
- [ ] SEC-20260524-001 — Security finding (see docs/security/assessment-2026-05-24.md) | High | security
```

The full finding detail stays in `docs/security/assessment-YYYY-MM-DD.md` only.

If `docs/known-issues.md` exists and the finding is a persistent issue rather than a
one-off fix, offer to add a reference there too — ID and severity only.

To mark a finding resolved after fixing, note: a future `/security-resolve [ID]` skill
will handle closure tracking. Until then, re-running `/security-assessment` and finding
the issue absent is sufficient confirmation of resolution.

---

## Phase 8 — Update Preferences and Confirm

Update `~/.claude/preferences.md`:
```
security-assessment-last-run: YYYY-MM-DD
```

Confirm to the user:

```
✅ Security assessment complete.

   Report: docs/security/assessment-YYYY-MM-DD.md  (gitignored)
   Findings: 🔴 N Critical | 🟠 N High | 🟡 N Medium | 🔵 N Low | ℹ️ N Info
   Kanban tickets created: N (SEC-YYYYMMDD-001 … SEC-YYYYMMDD-N)

   Next assessment due: YYYY-MM-DD (+30 days)
   /go-nogo will warn if overdue before a release.
```

---

## `/go-nogo` Integration

`/go-nogo` reads `security-assessment-last-run` from `preferences.md`.
If more than 30 days ago (or missing):

```
⚠️ No security assessment in the last 30 days (last run: N days ago / never).
   Consider running /security-assessment before shipping.
```

This is advisory — `/go-nogo` does not block on it.

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No source code found | Note "No source files found for [scope]" — skip AI analysis, run tools if available |
| Tool exits non-zero | Capture stderr, note in report as "tool error: [message]" — do not block |
| `docs/security/` gitignore add fails | Warn prominently — do not write report until confirmed gitignored |
| No findings | Write report with "No findings identified" — still record run date in preferences |
| `CLAUDE.md` missing | Note missing — proceed with directory structure inference only |

---

## Rules

- Never write the report before confirming `docs/security/` is gitignored
- Never include exploitable details in kanban tickets or `known-issues.md` — SEC-NNN IDs only
- Severity classification must be consistent — Critical requires exploitability, not just theoretical risk
- AI analysis and tool output are both included — never suppress tool findings that contradict AI assessment
- The report is always dated — never overwrite a previous report, always write a new file
- This skill is read-only for all source files — never modify project code during assessment
