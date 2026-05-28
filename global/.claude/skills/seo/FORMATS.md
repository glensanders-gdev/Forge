# SEO Audit Report Format

Write `docs/seo/audit-YYYY-MM-DD.md` using this template:

```markdown
# SEO Audit — [Project Name]

**Date:** YYYY-MM-DD
**Scope:** [Full site / --page <path> / --schema / --vitals / --content]
**Assessor:** Claude (AI-led SEO audit)

---

## Summary

[2–3 sentences: overall SEO posture, most significant findings, immediate priorities]

**Finding counts:** 🔴 N Critical | 🟠 N High | 🟡 N Medium

---

## Findings

### 🔴 Critical

**SEO-YYYYMMDD-001 — [Issue title]**
Location: `path/to/file:line` or `/route`
Issue: [What is wrong and why it matters for crawlability or ranking]
Fix: [Exact change to make]

---

### 🟠 High

**SEO-YYYYMMDD-NNN — [Issue title]**
Location: `path/to/file:line`
Issue: [What is wrong and why it matters]
Fix: [Exact change to make]

---

### 🟡 Medium

**SEO-YYYYMMDD-NNN — [Issue title]**
Location: `path/to/file:line`
Issue: [What is wrong]
Fix: [Exact change to make]

---

## Recommended Actions

[Numbered, Critical first. Each cites the SEO-NNN ID and names the responsible file.]

1. SEO-YYYYMMDD-001 (`path/to/file`) — [one-line action]. Estimated fix: N min.
```

Omit severity sections with no findings. Add a "requires manual verification" note to any finding that cannot be confirmed from source files alone.
