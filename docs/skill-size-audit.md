# Skill Size Audit — 2026-06-11

Context-health-style audit of the skill files themselves. A skill's `SKILL.md` is loaded in full every time it is invoked, so its size is a recurring token tax — weighted by how often the skill runs.

**Method:** tokens estimated as `bytes ÷ 4`. Full corpus: ~172k tokens across 97 SKILL.md files (only the invoked skill loads per session, so corpus total is context for maintenance, not a per-session cost).

---

## Done This Session

- **Token Recording sections removed** from 11 pipeline skills (build, deploy, estimate, grill-with-docs, idea, prototype, qa-plan, qa-report, research, testplan, write-prd) — recording moved to `/debrief` and `/sprint-end` via ccusage actuals. ~16 lines saved per skill, and removes a per-phase write ritual that cost far more than the lines themselves.
- **build/SKILL.md slimmed** 353 → 262 lines (~26%). Pre-flight numbering bug fixed (two overlapping numbered sequences); all typed gates (`CONFIRM`, `BUILD-FEATURES`/`BUILD-FIXES`/`STOP`, `APPROVED`, `CONTINUE`/`PAUSE`) and prompt templates preserved verbatim.

---

## Findings — Top Skills by Size

| Skill | ~Tokens | Lines | Invocation frequency | Assessment |
|-------|---------|-------|---------------------|------------|
| company-add | 8.8k | 873 | Once per employer | Oversized but rare — low priority |
| graphify | 8.5k | 650 | Occasional | Already has `references/`; more of SKILL.md could move there |
| dashboard-tokens | 8.4k | 804 | Weekly+ | **Worst offender** — embedded HTML/Chart.js template dominates the file |
| fy-review | 5.1k | 618 | Twice a year | Report templates could move to `references/` — low priority |
| security-assessment | 3.3k | 323 | Per release | Acceptable |
| pir | 3.2k | 382 | Per incident | Acceptable |
| commands | 3.1k | 169 | Frequent | The file *is* its output (command table) — no action |
| knowledge-health | 2.9k | 281 | Monthly | Acceptable |
| build | 2.6k | 262 | Daily during sprints | Slimmed this session — acceptable |

Pipeline skills now sit at ≤2.6k tokens each after the token-section removal — within reason for files that execute multi-gate workflows.

## Recommendations

1. **dashboard-tokens — extract the HTML template** (highest value). Move the embedded HTML/JS/Chart.js scaffold to `references/dashboard-template.html`; SKILL.md keeps the process and data-extraction instructions and references the template by path. Follows the established `graphify`/`vibe-security` pattern (SKILL.md + `references/` loaded on demand) and Forge's own "Reference, Don't Duplicate" principle. Saves ~5–6k tokens per invocation of a frequently-run skill.
2. **graphify — continue the references/ migration.** 650 lines in SKILL.md despite having a `references/` folder; query/path/explain details could move out.
3. **company-add and fy-review — defer.** Both are oversized but run rarely; extract templates to `references/` only when next touched.
4. **Adopt a soft cap for new skills:** SKILL.md ≤ ~300 lines / ~3k tokens; anything beyond that moves templates and reference material to a `references/` folder. Candidate addition to `PRINCIPLES.md` § Applying These Principles or the `/write-a-skill` checklist.

## Re-run

Re-run this audit after any release that adds or substantially edits skills:

```bash
for f in global/.claude/skills/*/SKILL.md; do
  echo "$(( $(wc -c < $f) / 4 )) $(wc -l < $f | tr -d ' ') $(basename $(dirname $f))"
done | sort -rn | head -20
```
