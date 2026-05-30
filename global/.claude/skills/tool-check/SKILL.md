---
name: tool-check
category: company
description: Verify which registered Forge tools are installed on this machine. Shows a full matrix by category — tool name, availability, and company classification. Required-but-missing tools are flagged prominently. Use when user runs /tool-check or to diagnose missing tool errors before a build.
---

# Tool Check

Verify which registered tools are installed and how they are classified for the active
company. This is the definitive answer to "what tools does Forge see on this machine?"

Run this after installing a new tool, after switching companies, or when `/build` pre-flight
reports a missing required tool.

---

## Usage

```
/tool-check                     ← check all categories
/tool-check security-scanner    ← check one category only
/tool-check --company [name]    ← check against a specific company (overrides active_company)
```

---

## Process

### Step 1 — Load registries

1. Read `~/.claude/tools/global.md` — the global tool list
2. If `active_company` is set in `~/.claude/preferences.md` (or `--company` flag provided):
   - Read `~/.claude/companies/[name]/tools.md`
   - Merge: company entries override global for status; company-only tools are added to the list
3. If a category filter was provided, discard tools outside that category.

### Step 2 — Check each tool

For every tool in the merged list, run its `check-command` silently:

```bash
[check-command] 2>/dev/null && echo "installed" || echo "missing"
```

Record: tool name, category, installed (yes/no), company status (required / approved / prohibited / global-only).

### Step 3 — Present matrix

Group by category. Sort: required tools first within each group.

```
🔧 Tool Check — [Machine / Company: name if set]

## security-scanner

| Tool     | Installed | Company status |
|----------|-----------|----------------|
| semgrep  | ✅ yes    | approved       |
| bandit   | ✅ yes    | global-only    |
| trivy    | ❌ no     | required ⚠️    |

## performance-analyser

| Tool       | Installed | Company status |
|------------|-----------|----------------|
| lighthouse | ❌ no     | global-only    |

## dependency-auditor

| Tool      | Installed | Company status |
|-----------|-----------|----------------|
| npm audit | ✅ yes    | global-only    |
| pip-audit | ❌ no     | global-only    |
```

### Step 4 — Surface required-but-missing tools

If any `required` tools are not installed, lead with a warning block:

```
⚠️ Required tools missing — /build pre-flight will fail until these are installed:

  trivy (security-scanner)
    Install: brew install trivy

  [tool] ([category])
    Install: [install-hint]
```

### Step 5 — Summary line

```
[N] tools checked · [N] installed · [N] missing · [N] required missing
```

If zero required tools are missing:
```
✅ All required tools installed. /build pre-flight will pass the tool check.
```

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| `~/.claude/tools/global.md` missing | Note "Global tools registry not found. Run `bash install.sh` to scaffold it." Stop. |
| Company tools file missing | Note "No company tools configured for [name]. Run `/tool-add --company [name]` to set up." Proceed with global registry only. |
| check-command times out | Record as "unknown" — note in output |
| No tools registered | Note "No tools registered in the global registry." Suggest `/tool-add`. |

---

## Rules

- Never modify any registry during a check — this skill is read-only
- Always show the full matrix even when a category filter is applied to another category — filter only, don't hide the section header
- Required tools are always surfaced at the top of the warning block, never buried in the table
- `global-only` status means no company override is set — the tool is available but not classified by the company
