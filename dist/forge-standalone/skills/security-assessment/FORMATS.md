# Security Assessment Report Format

Write `docs/security/assessment-YYYY-MM-DD.md` using this template:

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

### [tool-name]
[Summary of findings — counts by severity, top patterns]

⚠️ [tool] not installed — [what it covers, install command]

---

## Recommended Actions

[Numbered list, Critical first. Each item: SEC-NNN, file/line, specific fix.]

1. SEC-YYYYMMDD-001 (`src/path/file.ts:42`) — [description of fix]. Estimated fix: N min.

---

*This report is gitignored. Do not share vulnerability details in tickets or chat — use SEC-NNN reference IDs only.*
```
