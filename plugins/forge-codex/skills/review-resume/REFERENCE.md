# Resume Review — Reference

Criteria, conventions and evidence for `review-resume`. Vendors don't publish their screening
models or rubrics. The criteria below combine academic studies with consistent practitioner
guidance, and § *Evidence base* records which is which.

Verdict vocabulary for every item: **Strong** · **Adequate** · **Fix (High / Medium / Low)** ·
**Not assessable** (state why).

---

## Parser read: P-items

| ID | Check | Fix when |
|---|---|---|
| P-1 | Text layer exists | Image-only or scanned PDF; text inside images |
| P-2 | Reading order survives extraction | Columns built from tables or text boxes make extracted text run across rows |
| P-3 | Contact details are in the body | Name, email or phone only in the page header/footer, which some parsers drop |
| P-4 | Standard section headings | Creative headings ("My Journey") instead of Experience / Education / Skills |
| P-5 | No content in graphics | Skill bars, icons, logos or charts carry information |
| P-6 | Dates parse | Month + year on every role; no ambiguous ranges; overlaps explained |
| P-7 | No hidden text | White or background-coloured text, tiny fonts, off-page text, metadata, zero-width characters. **Always High** |
| P-8 | File type suits the channel | The posting asks for DOCX and a PDF was supplied, or vice versa |

Native word-processor columns usually parse; table- or text-box-built columns are riskier. Most
ATSs **rank** rather than auto-reject, so a garbled parse sinks a candidate silently instead of
rejecting them outright.

## Model read: M-items

| ID | Check | Strong when |
|---|---|---|
| M-1 | Headline matches the target | A target-title headline that matches the role ("Senior Data Engineer") |
| M-2 | Summary is extractable | 2–4 lines giving scope, domain and strongest evidence, with no adjective lists |
| M-3 | Skills are evidenced in context | Key skills appear inside achievements, not only in a skills list |
| M-4 | Impact is quantified | Results carry numbers (%, $, time, volume, users, team size) where honest |
| M-5 | Seniority and scope are explicit | Titles, team size, budget and scale stated, so seniority isn't left to inference |
| M-6 | Recency of key skills | The target's must-haves appear in the most recent roles, not only old ones |
| M-7 | Job ad terminology | Real skills use the ad's exact terms; acronym and full form both appear once |
| M-8 | No keyword stuffing | No context-free term dumps; stuffing helps keyword filters briefly and hurts with models and humans |

**Summary test.** Write the summary an LLM screener would produce. If it misses the candidate's
strongest evidence, that evidence is badly placed. Move it into the headline, the summary or the
first bullets of the latest role.

**Requirement table** (only with a job ad):

| Requirement (from ad) | Must / Nice | Status | Read from |
|---|---|---|---|
| … | Must | Evidenced / Listed / Missing | Role, bullet |

## Human read: H-items (resume/CV)

| ID | Check | Fix when |
|---|---|---|
| H-1 | Bullet pattern | Bullets are duties ("Responsible for…") rather than verb + action + scope + result |
| H-2 | Specific language | Generic phrasing: *results-driven, spearheaded, leveraged, passionate about, dynamic, synergy, proven track record* |
| H-3 | Length suits market and seniority | See § *Markets* |
| H-4 | Section order | Not: contact → headline → summary → skills → experience (reverse-chronological) → education/certifications → optional |
| H-5 | Market conventions | Photo, date of birth or marital status where the market excludes them; wrong spelling variant |
| H-6 | Tailoring | Order and emphasis don't follow the target's must-haves |
| H-7 | Gaps and transitions | Unexplained gaps or a career change with no framing (the cover letter can carry this) |
| H-8 | Claims are defensible | A metric or claim the candidate couldn't explain in an interview or referee check |

## Cover letter: C-items

| ID | Check | Strong when |
|---|---|---|
| C-1 | Opening | Names the role exactly as advertised plus a one-line reason for fit; no "I am excited to apply" |
| C-2 | Evidence mapping | The ad's top 2–3 requirements, each matched to a concrete example with a result |
| C-3 | Why this organisation | Says something true only of this employer: product, team, mission or problem |
| C-4 | Adds what the resume can't | Motivation, career change, relocation, work rights, a gap, availability |
| C-5 | Consistent with the resume | Every claim matches the resume |
| C-6 | Length and voice | About 250–400 words, one page, in the candidate's own voice |
| C-7 | Selection criteria (where required) | Each numbered criterion answered under its own heading in STAR form (Situation, Task, Action, Result), within the word limit |

## Markets

| Market | Name | Length | Notes |
|---|---|---|---|
| Australia | "Resume" and "CV" used interchangeably | 2–3 pages experienced; 1 page graduate | A4, AU spelling, no photo or DOB. Referees named, or "available on request" (both accepted). Government roles need a separate selection-criteria statement |
| UK / NZ / Ireland | "CV" | 2 pages typical | No photo or DOB; UK spelling |
| US / Canada | "Resume" (CV = academic) | 1 page early career, 2 pages experienced | Letter size; no photo, DOB or referees |
| Academic (any) | "CV" | As long as the record needs | Publications, grants, teaching and service sections expected |
| Continental Europe | "CV" | 1–2 pages | Photo and DOB customs vary by country; follow the posting |

These are practitioner conventions, not standards. When unsure, follow the posting, or ask
the employer.

## Report format

```markdown
# Resume Review — [document type], [date]
**Target:** [role / ad title, or "general — no target supplied"] · **Market:** [country, stated or inferred]

## 1. Parser read
| ID | Verdict | Evidence |
## 2. Model read
**Summary test (as written):** > …
| ID | Verdict | Evidence |
[Requirement table, if a job ad was given]
## 3. Human read
| ID | Verdict | Evidence |
## Top fixes
1. **High** — [fix] — [why: which reader it fails]
…
## Before → after
| Before (your words) | After |
## Next step
Apply these fixes and write the revised version? (yes / no / adjust)
```

## Statistics to distrust

Never cite these as fact in a report:

| Claim | Status |
|---|---|
| "75% of resumes are rejected by ATS" | No primary source found |
| "Recruiters scan a resume in 6–7 seconds" | Vendor eye-tracking; not independently replicated |
| "X% of companies use AI for screening" | Vendor surveys and secondary compilations |
| An "ATS match score" | A vendor construct; no standard behind it |

## Evidence base (as researched 2026-10)

- **Screening pipeline:** knockout questions → parsing → keyword/rules → LLM summarise-and-rank →
  human decision. Practitioners report that knockouts and parse failures cause most fast
  rejections, and that full automation without human review is rare. A multi-agent LLM screening
  design is described in arXiv 2504.02870.
- **Hidden text:** about 1% of ~196,682 resumes on one platform contained hidden prompt injections,
  rising from 2024 (arXiv 2605.28999). Detection is effective: ResumeShield (arXiv 2609.20188) reports
  ~0.94 recall with no false positives.
- **Cover letters:** after an AI letter tool launched on Freelancer.com, the link between a tailored
  letter and a callback fell by ~51% (arXiv 2509.25054). Recruiters in a Tilburg study identified
  AI-written letters no better than chance (GPT-3.5, Dutch recruiters).
- **Bias:** LLMs ranking resumes favoured White- and male-associated names (Wilson & Caliskan, arXiv
  2407.20371). The candidate can't control this; the review should not imply otherwise.
- **Validity:** LLM screening "accuracy" is usually measured as agreement with past human decisions,
  which can carry historical bias forward (arXiv 2602.18550).
