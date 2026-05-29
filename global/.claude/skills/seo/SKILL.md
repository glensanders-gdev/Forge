---
name: seo
category: code-quality
description: SEO audit and remediation planning — technical SEO (crawlability, canonical, redirects), on-page (titles, meta, headings), structured data (JSON-LD), Core Web Vitals, and content quality. Reads source files directly, ranks findings by severity, confirms remediation scope, writes a dated report, and optionally creates kanban tickets. Use when user runs /seo, before a major release, or when SEO regressions are suspected.
origin: Adapted from Affaan Mustafa (ECC / github.com/affaan-m/ECC)
---

# SEO

Structured SEO audit for the current project. Reads source files and deployment-facing assets directly — no external crawl tool required. Findings are ranked by severity and likely ranking impact, then confirmed with the human before any remediation tickets are created.

---

## Usage

```
/seo                        ← scope selection prompt
/seo --audit                ← full site audit
/seo --page <path>          ← single page or route
/seo --schema               ← structured data (JSON-LD) only
/seo --vitals               ← Core Web Vitals focus
/seo --content              ← content and keyword issues only
/seo --analyze-only         ← produce report, do not offer tickets
```

---

## Phase 1 [AFK] — Orient and Scope

1. Read `CLAUDE.md` (project root) — identify tech stack, key page types, any known SEO constraints or redirects already in place.
2. Locate deployment-facing assets: `robots.txt`, `sitemap.xml`, HTML template layer (e.g. `_app.tsx`, `_document.tsx`, `layout.tsx`, Jinja base templates).
3. If no flag was passed, present scope options and wait for explicit selection:
   ```
   SEO audit scope:
     [1] Full site       (--audit)
     [2] Single page     (--page <path>)
     [3] Structured data (--schema)
     [4] Core Web Vitals (--vitals)
     [5] Content/keyword (--content)
   ```

Do not produce output during this phase.

---

## Phase 2 [AFK] — Audit

Systematically check the agreed scope against the priority taxonomy below. Record findings as they are identified — consolidate in Phase 3.

### Audit Priority Taxonomy

**Critical — crawlability and indexability**
- `robots.txt` or `meta robots` blocking important pages
- Canonical loops or broken canonical targets
- Redirect chains longer than two hops
- Missing or broken sitemap entries for key page types
- Broken internal links on primary navigation paths

**High — on-page fundamentals**
- Missing or duplicate `<title>` tags
- Missing or duplicate `<meta name="description">` tags
- Invalid heading hierarchy (multiple `<h1>`, skipped levels)
- Malformed or missing JSON-LD on key page types (Product, Article, BreadcrumbList, etc.)
- Core Web Vitals regressions on high-traffic routes (LCP, CLS, INP)

**Medium — quality and depth**
- Thin content (pages with minimal substantive text)
- Missing `alt` text on meaningful images
- Weak or generic anchor text on internal links
- Orphan pages (not reachable from any internal link)
- Keyword cannibalization (multiple pages targeting the same intent)

Assign a `SEO-YYYYMMDD-NNN` ID to each finding (date = audit date, NNN sequential within the run).

---

## Phase 3 [HITL] — Review Findings and Confirm Scope

Present ranked findings and ask which to address:

```
SEO Audit — [Project Name]
Scope: [scope]

🔴 Critical: N findings
🟠 High:     N findings
🟡 Medium:   N findings

Which would you like to address?
  [1] All findings
  [2] Critical only
  [3] Critical + High
  [4] Specific IDs — list them
  [5] Report only — do not create tickets

Choice:
```

Wait for explicit response. If `--analyze-only` was passed, skip this gate and go directly to Phase 4.

---

## Phase 4 [AFK] — Write Report

Write `docs/seo/audit-YYYY-MM-DD.md` (create `docs/seo/` if it does not exist).

Use the format defined in `FORMATS.md` in this skill directory.

---

## Phase 5 [HITL] — Kanban Promotion (optional)

If the human did not choose "Report only", present the confirmed findings and ask:

```
Create kanban tickets for N confirmed findings?
Tickets will reference SEO-NNN IDs — full detail stays in the report.

[List SEO-NNN IDs with one-line summaries]

Create tickets? (yes / no / select)
```

If yes (or select), create one ticket per finding:

```markdown
- [ ] SEO-YYYYMMDD-001 — [Issue title] | [Critical/High/Medium] | seo
```

Full finding detail stays in `docs/seo/audit-YYYY-MM-DD.md` only — do not reproduce implementation detail in kanban.

---

## Forge Integration Points

| Skill | Relationship |
|-------|-------------|
| `/review` | Run `/review` on HTML/template changes made during SEO remediation |
| `/build` | SEO remediation tickets flow through the standard build loop |
| `/qa-plan` | Add SEO regressions to the QA checklist before release |
| `/go-nogo` | Critical SEO findings should be noted in the Go/No Go risk assessment |
| `docs/known-issues.md` | Persistent SEO issues (e.g. CMS-imposed canonical limitations) belong here |

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No HTML template or routing layer found | Note "No identifiable template layer — analysis limited to available static files." Proceed with what is available. |
| `robots.txt` missing | Flag as High finding — absence may cause unintended crawl behaviour |
| No `sitemap.xml` found | Flag as High finding — note it may be server-generated; ask if a URL is available |
| JSON-LD validation fails | Report the specific schema error verbatim — do not attempt to auto-correct |
| Single page not found at `--page <path>` | Report "Page not found at [path] — confirm the route or file path" and stop |
| `docs/seo/` cannot be created | Report the error; output the report inline instead |
| No findings | Write report with "No findings identified" — still record the audit date |

---

## Rules

- Never recommend SEO folklore — every recommendation must be grounded in a specific finding in the actual source files
- Never recommend manipulative patterns (hidden text, keyword stuffing, cloaking, link schemes)
- Never give advice detached from the actual site structure — read first, recommend second
- Never auto-create kanban tickets — always confirm scope in Phase 3 first
- Findings must be specific enough to hand directly to an engineer: file path, line number or element, exact change
- Severity must reflect actual ranking and crawlability impact — do not inflate Medium issues to High for emphasis
- Always note when a finding cannot be verified from source files alone (e.g. server-side redirects, CDN config) — mark as "requires manual verification"

---

## Attribution

Adapted from Affaan Mustafa (ECC / [github.com/affaan-m/ECC](https://github.com/affaan-m/ECC/blob/main/agents/seo-specialist.md))
