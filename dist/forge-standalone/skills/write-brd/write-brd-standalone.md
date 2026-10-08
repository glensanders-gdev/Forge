# /write-brd — standalone single file

Paste this whole file into a chat assistant as one message, or attach it as one file, then
give it your source material. It is the complete `/write-brd` skill: `SKILL.md` first, then every
file it cites, each under a heading carrying that file's name. A citation such as
`TEMPLATE.md` or `tables.md` means that part of this file, not a file to go and find.

A step that runs a script (`scripts/...`) cannot run in a chat. Skip that step and state in
the output that it was skipped; never produce the script's output by hand.

**Generated — do not edit.** Regenerated from the skill on every release.

## Contents

- `SKILL.md`
- `REFERENCE.md`
- `STANDARDS.md`

---

# `SKILL.md`

---
name: write-brd
category: pipeline
description: Author a Business Requirements Document to the pack's BABOK v3 standard — SMART objectives carrying baseline, target and date, outcomes rather than solutions, and a cost-of-failure case for each objective carrying operational exposure — then self-assess it against the BH-1 – BH-10 handoff gate that decides whether ORD development can start. Runs AFK ingest, HITL write, then the gate. The standard is read at authoring time, never recalled. Use when a BRD is needed from a request brief, idea, transcript or notes, when /write-brd is run, or when an ORD task turns out to be a BRD task in disguise.
---

# Write BRD

Author the document that states **why** money is being spent and how it will be known that it paid
off — then establish whether it clears **the bar** for ORD development.

Execution mode: Phase 1 **[AFK]** · Phase 2 **[HITL]** behind a confirmation gate · Phase 3 **[AFK]**.
`--llm-only` is **[AFK]**: it regenerates the companion and writes nothing else.
The standard owns the anatomy, both forms and the gate; this skill locates it and applies it.

**Authoring standards** — `language.md` and
`tables.md`, shared with `/write-prd`, `/write-ord` and `/write-ac`,
never restated here. **Where they meet the pack, the pack wins on BRD-specific forms:** the SMART
objective is verb-first by the pack's own form, and a `[TBD]` carries **a named owner and a date**
rather than `language.md`'s source quote — the gate reads both, and a `[TBD]` missing either is a
hole that fails the bar.

`ai.md` applies **conditionally** — where a delivered component's
behaviour is learned or generated rather than specified, this document records the **risk
classification decision** once, per that ruleset's class map, and every downstream document reads it
from here.

**Two files are written, one reviewed.** The BRD is for its human reviewer; beside it goes an **LLM
companion**, `docs/brd/[change-name]-BRD.llm.md`, generated from the saved BRD for a language model
to consume, to the form in `llm-companion.md`. Run with
`--llm-only [BRD path]` to regenerate the companion from an existing BRD without running any phase.

Each standard named above is a part of `STANDARDS.md`, beside this file — a citation such as
`tables.md` means the part of that document carrying that name, not a separate file to find.

**If an authoring standard above cannot be read, stop and name it.** The register and criteria
schemas, the modal ban and the scenario values live there and nowhere else. Drafting them from
memory produces a document that looks conformant and is not, and no reviewer can see the
difference. An unreadable standard is a blocked run, never a degraded one.

---

## Phase 1 — Ingest and classify [AFK]

1. **Source the standard, never recall it.** Per `GATE-PROTOCOL.md`
   § *Sourcing the criteria* — the live pack's `reference/brd-standard.md` where held, otherwise the
   stamped extract in `STANDARD.md`. Name the pack version in the summary. Read the
   anatomy and its five **★** sections, both forms, the solution-vs-outcome test, the gate, and
   **BRD-2026-041** as the reference implementation — it carries a declared gap, an unowned one and
   an empty traceability row, which is what a real BRD looks like.
2. **Read every source in full** — a Request Brief, `~/.claude/ideas/active/*/idea.md`,
   transcripts, notes, existing documents, conversation context.
3. **Classify every statement by the BABOK v3 taxonomy.** Business and Stakeholder statements are
   this document's. A Solution statement is not, and is **routed rather than dropped** — the
   standard's *tolerance or figure* table names each destination, and §9's routing register is where
   the routing is recorded. Functional detail has no document in this chain, so it is registered or
   it is lost.
4. **Draft each objective to the objective form, then run the solution-vs-outcome test.** An
   objective naming a feature, system, vendor or asserted figure has pre-empted the ORD; rewrite it
   as the measurable outcome the enterprise wants.
5. **Pair each objective carrying operational exposure with a cost-of-failure statement**, sourced to
   a contract clause, an incident, or a named obligation. Every downstream tolerance derives from it,
   and it is the item most often assumed optional.
6. **Elicit constraints against all six categories** in the standard's *Constraints, assumptions and
   dependencies* form — regulatory, contractual, time, financial, organisational, prior commitment —
   and record the answer for each, **including *none found***. A category never asked is
   indistinguishable from one answered empty unless the empty answer is written down.
7. **Ask whether the change is phased.** Where it is, establish which phase this document covers, and
   raise the standard's recommendation — for a large change, a BRD per phase, because one objective
   row carries one target and one date.
8. **Read the size off Appendix A's inputs** — business units, objectives, stakeholders, and impacted
   workflows and systems combined — against the size table. This is what makes the ORD sizeable at
   assignment.
9. **Present the Phase 1 summary** in [REFERENCE.md](REFERENCE.md) and pause. Extract and classify
   first; ask nothing before the summary.

**Completion:** every extracted statement is placed in a BRD section or routed with its destination
named; every objective carries a baseline, a target and a date, or a `[TBD]` with a named owner and a
date; and every figure the source did not state is an open question at the gate rather than a number.

## Phase 2 — Write [HITL]

1. Incorporate the corrections and gap-fills from the Phase 1 confirmation.
2. **Write every section of the anatomy**, in the standard's order, to
   `docs/brd/[change-name]-BRD.md`. **Assign the Doc ID now, not at approval** — `BRD-YYYY-NNN`, in
   the front matter's first field. Objectives are `BO-N`, stakeholder requirements `BR-N`,
   assumptions and dependencies `ASM-NNN` / `DEP-NNN` per `tables.md`. Constraints carry **no local
   ID**; the source clause identifies them.
3. **State every fact once.** Before saving, check each figure appears in exactly one section — the
   standard's *State it once* table names where each belongs. A repeated figure is a copy that will
   go stale, and a BRD that reads as repetitive is almost always this rather than thoroughness.
4. **Carry assumptions and dependencies with their Status.** Assumptions are
   `Unvalidated / Validated / Falsified`, each with `If false`, an owner and a confirm-by date;
   dependencies are `Open / Met / At risk`. Carry `/idea` assumptions forward with their Status
   rather than as prose. **Move a `Validated` assumption to the constraint table** — it is a
   constraint now, and leaving it at `Validated` keeps a confirmed given looking provisional
   downstream.
5. **Write no risk table.** Risks go to the RAID log via `/raid add risk`, and the BRD cites the
   `R-NNN` — on a `Falsified` assumption's `If false`, on an `At risk` dependency, or on the
   objective the exposure threatens.
6. **Keep an unquantified objective in the register.** One carrying `[TBD]` with an owner and a date
   is a tracked gap; the same objective omitted is invisible. The same treatment covers an
   unconfirmed constraint, an unknown stakeholder and an unnamed approving GM — there is no second
   mechanism for not-yet-known.
7. **Write §12 as a traceability skeleton in both directions** — each stakeholder requirement against
   the objective it serves, and each objective against the tolerance expected to quantify it, with an
   **explicit blank** where there is none. A blank row is the useful one; an omitted row is a gap
   nobody can see, and tracing one direction finds only half of them.
8. **Write §2 last, from the sections that exist.** Five labelled lines — Problem · What will be
   true · Cost of not acting · Open · Decision sought — each citing a `BO-N`, a clause or a section, and
   carrying **no figure of its own**. A label you cannot fill is a finding: no *Decision sought* means no
   decision was ever established, and no *Cost of not acting* is BH-4 absent. Write `Open: None`
   rather than deleting the line.
9. **Give every Appendix A row a named owner.** Where the estate has none, write **Unowned — open**;
   recording it is the finding, and resolving it is not this document's to do.
10. **Write Appendix B from the citations that exist.** One row for every source cited anywhere in
   the BRD, in the form `language.md` § *Citing Sources* sets, and no row that nothing cites. With
   no source cited, write a single `None cited` row.
11. **Generate the LLM companion** from the saved BRD by running
   `python3 ../write-ord/scripts/llm_companion.py docs/brd/[change-name]-BRD.md --generator "/write-brd 1.3.0"`,
   per `llm-companion.md`. It writes `docs/brd/[change-name]-BRD.llm.md` only when every row
   reconciles and every value arrived verbatim. On a refusal, report the reason; never write the
   companion by hand instead.
12. Present the coverage summary — objectives quantified against declared gaps, cost-of-failure
   statements against objectives carrying exposure, routed statements and their destinations, the
   size read, and the companion line with its row and record counts.

**Completion:** the document is saved, every ★ section is populated or carries a declared gap, no
cell holds a figure the source did not supply, and the companion reconciles row-for-row with it.

## Phase 3 — Run the gate [AFK]

Assess the document just written against **BH-1 – BH-10**, applying the verdict vocabulary, the
evidence rule and the outcome derivation in `GATE-PROTOCOL.md`, and
emit the protocol's report format adapted per [REFERENCE.md](REFERENCE.md).

**The standard puts this gate in the author's hands** — a document's readiness is its author's to
establish, not its recipient's to adjudicate afterwards. It is **not** the independent review: §8
names a reviewer who did not author the document as its highest-value Tier 1 control, and a
self-assessment cannot be one. Name `/review-brd` as the pass this one does not replace.

**Completion:** all ten items carry a verdict citing the section it was read from or naming what is
absent, one of the four outcomes is derived by precedence, and every declared gap names where it must
reappear downstream.

---

## Rules

- **Never invent a figure, a consequence, an owner or a date to fill a cell.** A `[TBD]` with a named
  owner and a date is a declared gap and passes the bar; a value nobody can defend is the failure the
  standard exists to prevent, and a `[TBD]` missing either half is a hole that fails it.
- **Never carry a risk table, a cost–benefit table, or a second copy of any figure.** The first two
  were removed from the anatomy at pack v1.12; the third is the failure that removal was diagnosing.
- **Never restate the standard in this skill's prose.** The pack is the source of truth, and
  `STANDARD.md` is a generated extract — hand-editing it is how the pack stops being authoritative.
- **Never drop a Solution requirement because no document receives it** — route and register it.
- Objectives and business requirements state outcomes. Anything naming a workflow, system, vendor or
  figure belongs to the ORD, the SOAP, or the referred register, and is routed there.
- Never write Phase 2 without the Phase 1 confirmation, and never ask a question during Phase 1.
- Never hand the companion to review or sign-off in place of the BRD, and never edit it by hand —
  when the BRD changes, regenerate it with `--llm-only`.
- Never emit a score or a percentage at Phase 3 — ten verdicts and one of four outcomes.
- Never present the Phase 3 assessment as an independent review, or let it stand in for one.
- Where the standard and this skill disagree, the standard wins — say so, because a disagreement is a
  defect in this skill.

## Failure Modes

| Condition | Behaviour |
|---|---|
| Neither the live pack nor `STANDARD.md` is readable | Stop. Authoring from a recalled standard drifts silently, and the drift is invisible in the output |
| Source is a solution pitch — a vendor, a feature, a design | Extract the outcome behind it. Where the source states no business outcome at all, stop and report there is no business case to document |
| No cost-of-failure derivable for an objective carrying exposure | Raise it at the Phase 1 gate as an open question. Never invent a consequence, and never quietly drop the objective |
| Every objective carries `[TBD]`, or the gap sits on the objective the change is funded against | Report at the Phase 1 gate before writing. The two limits fail BH-1 however well-owned the gaps are, and no downstream document repairs an unquantified business case |
| No approving GM identifiable for a business unit in scope | Write the §6 row with `[TBD]`, its confirming owner and a date. A unit in scope with no row at all is BH-6 absent — never infer an approver from an org chart |
| §2 drafted before the register it summarises | Rewrite it last. A summary written from the brief promises what the document does not contain, and nobody re-reads it to find out |
| An executive summary label cannot be filled | Report it as a finding, not a formatting problem — the standard's table names what each empty label means. Never pad the line to make the section look complete |
| Source carries risks | Route them to `/raid add risk` and cite the `R-NNN`. Never write a risk table into the BRD |
| Source carries a cost–benefit case | Check the benefit is stated as an objective's baseline-to-target movement at §4. Never restate it as a return figure at §11 |
| Change spans phases and the source wants one document | Raise the standard's recommendation — a BRD per phase — and say why: one objective row carries one target and one date. Where the user keeps one document, record which phase each objective's target belongs to |
| A statement is elicited that the BRD declines to carry | Record it in §9's routing register with its BABOK type and destination. Never drop it — no functional requirements document exists in this chain to catch it |
| An Appendix A row has no owning team | Write **Unowned — open**. It is the unowned-gap outcome at Phase 3, not a blank cell |
| Phase 3 derives *Not accepted for ORD development* | Name the absent bar items and offer to return to Phase 2. No authority question arises — refusing your own document needs no right |
| A BRD already exists at the target path | Stop. "A BRD already exists at docs/brd/. Confirm overwrite or provide a new name." |
| The companion script refuses | Nothing is written. Report the reason it names — a value that did not arrive verbatim, or rows that did not reconcile — and fix the BRD, never the companion |
| No Python is available to run the script | Write the companion by hand to `llm-companion.md`, run its integrity check by hand, and say in the coverage summary that the check was manual |
| `--llm-only` given a path with no BRD | Stop and say so. The companion is generated from a saved BRD and nothing else |
| `/write-ord` is asked for and no BRD exists | Say so and offer this skill — an ORD task against a missing BRD is a BRD task in disguise |

---

# `REFERENCE.md`

---
name: write-brd-reference
description: Output formats for /write-brd — the Phase 1 ingest summary, the document header, and the Phase 3 self-assessment report. Read when emitting either gate.
---

# Write BRD — output formats

The three formats this skill presents. The fourth thing it writes, the LLM companion, takes its form
from `llm-companion.md` and is not restated here. This file holds
**no criterion and no section template**: the BRD
anatomy, the objective form, the cost-of-failure form and the ten gate items are the standard's, read
at authoring time from the live pack or from `STANDARD.md`.

---

## Phase 1 — ingest summary

```markdown
## BRD Ingest Summary — [change name]

**Standard:** BABOK v3 · **Pack version:** [vN.N, from the source that supplied it]
**Sources read:** [each, by path or description]

### Objectives drafted
| ID | Objective | Baseline | Target | By | Solution-vs-outcome |
|---|---|---|---|---|---|
| BO-1 | [outcome form] | [value or `[TBD — Owner, due YYYY-MM-DD]`] | [value or `[TBD]`] | [date] | Clean / rewritten from "[quoted source]" |

### Cost of failure
| Objective | Consequence | Source | 
|---|---|---|
| BO-1 | [what is lost] | [contract clause / incident ID / obligation, or **none found**] |

### Statements routed out of the BRD — §9's routing register
| Statement | BABOK type | Routed to | ID there |
|---|---|---|---|
| "[quote as elicited]" | Solution — non-functional | ORD, as business tolerance | `[ORD-TBD]`, written back |
| "[quote as elicited]" | Solution — functional | Referred requirements register | `[REF-TBD]`, written back |

### Constraints — every category asked, every answer recorded
| Category | Found |
|---|---|
| Regulatory and statutory | [the constraint, or **none found**] |
| Contractual | [the constraint, or **none found**] |
| Time | [the constraint, or **none found**] |
| Financial | [the constraint, or **none found**] |
| Organisational | [the constraint, or **none found**] |
| Prior commitment | [the constraint, or **none found**] |

**A category answered *none found* is a record; a category left blank is a hole.** The two are
indistinguishable in the finished document, which is why this table has no empty cells.

### Phasing
[**Single release** — no phasing section — or: this document covers Phase n of m, with the deferred
scope named and whether the later phases are separate BRDs.]

### Sizing read
[business units] · [objectives] · [stakeholders] · [impacted workflows and systems] → **S / M / L**

### Open questions — figures the source did not supply
| # | Question | Why it cannot be answered here |
|---|---|---|
| 1 | [question] | [the standard forbids inventing it, and nobody named has stated it] |

### Gate exposure, provisional
[Which of BH-1 – BH-10 the material as it stands does not yet reach, and which are declared gaps.]

---
Confirm to proceed to Phase 2, or supply corrections and gap-fills first.
```

**Every open question is a figure, an owner or a date the source did not state.** A question that is
really a drafting preference belongs in the draft, not at the gate.

---

## Phase 2 — document header

```markdown
# BRD-YYYY-NNN — [change name]

**Doc ID:** BRD-YYYY-NNN · **Version:** N.N · **Status:** Draft · **Priority:** [P1–P4]
**Executive sponsor:** [role] · **Author:** [name or role]
**Horizon:** [FYnn Hn – FYnn Qn] · **Phase:** [n of m, or "single release"] · **Standard:** BABOK v3
**Assessed against:** [standard path] · **Pack version:** [vN.N]
```

**The Doc ID is assigned here, at first draft, not at approval.** The RAID entries and referred
requirements raised while the document is being written cite it, and that is when they are raised.

Sections follow the anatomy in the standard, in its order, with the six **★** sections populated or
carrying a declared gap.

---

## Phase 3 — self-assessment report

The report format in `GATE-PROTOCOL.md`, with three changes that
follow from the reviewer being the author:

1. **The reviewer line says so.** `**Reviewer:** /write-brd — the author's own assessment, not an
   independent review.`
2. **A refusal is not recorded and overridden.** Name the absent bar items and offer to return to
   Phase 2. The protocol's authority note covers declaring *someone else's* document not-ready; it
   does not apply to your own.
3. **The closing line names the independent pass.** `Run /review-brd for the independent assessment —
   §8 names a reviewer who did not author the document as the highest-value Tier 1 control, and this
   assessment is not one.`

Everything else is the protocol's: four verdicts and no fifth, an evidence citation on every one, the
outcome derived by precedence rather than judged, and each declared gap named where it must reappear
downstream.

---

# `STANDARDS.md`

# Authoring Standards

The standards `/write-brd` cites, gathered into one document so the skill works where
there is no filesystem to read them from. Each part keeps the name of the file it came
from: a citation such as `tables.md` means the part below with that name.

- **`README.md`** — Requirements Rules
- **`language.md`** — Requirements Language
- **`tables.md`** — Requirements Tables
- **`ai.md`** — Requirements — AI Solutions *(conditional)*
- **`reporting.md`** — Requirements — Reporting and Data *(conditional)*
- **`llm-companion.md`** — Requirements — LLM Companion
- **`GATE-PROTOCOL.md`** — Gate Review Protocol
- **`STANDARD.md`** — write-brd — standard extract

---

## `README.md`

Authoring standards for requirements documents — how a requirement is *worded* and how it is
*presented*. Consumed by `/write-brd`, `/write-prd`, `/write-ord`, `/write-reqs`, and `/write-ac`.

```
standards/requirements/
├── README.md      ← this file
├── language.md    ← voice and tone, sentences and word choice, numbers and dates, citing sources, modality, banned constructions
├── tables.md      ← table-first presentation, document structure, reference list, canonical schemas, ID namespaces
├── ai.md          ← conditional: learned or generated behaviour (see trigger test)
├── reporting.md   ← conditional: a measure that is reported (see trigger test)
└── llm-companion.md ← the machine-readable companion /write-brd and /write-ord write beside the document
```

`language.md` and `tables.md` are unconditional — every requirements document obeys both.

`ai.md` and `reporting.md` are **conditional**: each applies on top of the unconditional two, and
neither relaxes either. They are independent — a change can fire both, one, or neither.

| File | Fires when | Adds |
|---|---|---|
| `ai.md` | a delivered component's behaviour is learned or generated rather than specified | the evaluative criterion, `EVL-NNN` / `MDL-NNN`, the ISO/IEC 25059 class map |
| `reporting.md` | the change creates, alters or retires a measure somebody reports | the measure definition, `DAT-NNN`, the ISO/IEC 25012 data-quality anchor |

`llm-companion.md` governs no requirement. It defines the `.llm.md` view `/write-brd` and
`/write-ord` generate from the saved document for a language model to consume — a view that adds,
drops and rewords nothing, and is never the reviewed artefact.

See ADR-0003 for why AI requirements extend the pack rather than forming a fourth document;
`reporting.md` follows the same precedent rather than adding a reporting document.

### Why this lives in `standards/`, not `rules/`

`rules/common/` is the always-applied baseline for **code**. `rules/[lang]/` is activated
per-project via `/lang-rules`. Neither fits: these rules govern **documents**, and they apply
whenever a requirements document is authored regardless of the project's language or whether
any code exists yet.

This ruleset is not auto-loaded. The requirement skills cite it by path, per PRINCIPLE 6
(reference, don't duplicate). It exists so the sibling documents share one definition of a
requirement's form — neither `/write-prd` nor `/write-ord` can own it without the other
drifting, and `/write-reqs` is barred from owning templates.

It cannot sit under `rules/`. Claude Code and VS Code load every file under
`~/.claude/rules/` without `paths:` frontmatter into every session, so a ruleset kept there is
paid for in every session whether or not a requirements document is in play. Neither loads
`~/.claude/standards/`. A path-scoped pointer in `~/.claude/rules/`, named `requirements`, covers
the gap: it loads only when a session reads a document under `docs/brd/`, `docs/prd/`, `docs/ord/`
or `docs/ac/`, and names these files, so a requirements document edited outside a skill still
meets them.

### Scope boundary — read this first

These rules govern **generated document content only**.

They do **not** apply to the skills' own instruction prose. A skill instruction such as
"at least one KPP must be identified" is correct and stays. Applying the language rules to the
skill files themselves would strip the directives that make the skills work.

| Text | Governed? |
|---|---|
| A requirement, criterion, assumption or commitment written into a PRD/ORD/AC document | Yes |
| A skill's instructions to Claude, its rules, its failure-mode table | No |
| Template placeholder text and worked examples inside a template | Yes — examples teach the form |
| Narrative context sections (background, mission, operational scenarios) | Partially — see `language.md` § Narrative sections |

`ai.md` adds one boundary of its own: it governs AI as the **subject** of a requirement. AI as the
**author** of the solution is `ai-first-engineering`, which is not a requirements ruleset and is not
governed here.

### Enforcement

`/review-language` checks a document against `language.md`, and `/review-ord` and `/review-brd`
run it as an advisory pass after the gate. It reports findings and never changes a gate verdict.

`/check-style` reads `~/.claude/knowledge/company/style-guide.md`, not this ruleset — a company
style guide may add to these rules but never relaxes them. Where the two conflict, the stricter
requirement wins and the conflict is flagged rather than silently resolved.

**One exception: locale.** A company style guide's `Locale` section *replaces* the Australian
defaults in `language.md` § *Locale Conventions* (spelling, dictionary, prose dates, times,
financial year). Replacing them is not a relaxation, so the stricter-wins rule does not apply to
them. With no `Locale` section, or an incomplete one, the Australian defaults stay in force.


---

## `language.md`

> Governs the wording of requirements, acceptance criteria, and commitments in generated
> documents. Read the scope boundary in `README.md` first — these rules do **not**
> apply to skill instruction prose.

### The Principle

**Describe the delivered world as a fact, not the project's intentions about it.**

A requirement states how things *are* once the solution is in place. Written that way it is
either true or false at verification time, and there is no hedge to argue about.

| Instead of | Write |
|---|---|
| The system should respond within 3 seconds | Search results are returned within 3 seconds |
| We will encrypt data in transit | Data in transit is encrypted using TLS 1.3 |
| Users may be notified of despatch | Customer despatch notification is issued within 5 minutes |
| The service shall be available 99.9% of the time | Service availability is 99.9% per calendar month |

### Voice and Tone

Adopted from the Australian Government Style Manual, *Voice and tone*
(stylemanual.gov.au, page updated 21 October 2025). Here, **voice** means who the document speaks
as. That is a different thing from the grammatical active or passive voice covered in
§ *Voice by Altitude* below.

**Voice: the definitive source.** A requirements document uses the Style Manual's basic government
voice. It is respectful, clear and direct, and objective and impartial. A company style guide may
set a house voice on top of this (see `README.md` § *Enforcement*), but it never
replaces it.

**Tone: formal.** The Style Manual puts policies, reports and legal writing in formal tone, and a
document that carries commitments belongs in that group. Formal tone does not excuse unclear
writing: plain language applies at every level of formality.

| Element of tone | In a generated requirements document |
|---|---|
| Word choice | Everyday words. No contractions, metaphor, idiom or slang, and words keep their dictionary meaning. Every acronym and piece of internal shorthand is defined on first use and in the Glossary |
| Viewpoint | Third person and impersonal. No `I`, `we`, `our` or `you`, because a requirements document has many readers and `you` names none of them. Name the party instead, as the "the system" ban already requires for components |
| Grammar | Short sentences, one idea each. § *Voice by Altitude* sets the form for each element |
| Formality | Formal throughout, executive summary included |

**Clear and direct.** Narrative prose uses the active voice with a named actor. An unfavourable
position is stated plainly: an exclusion, a `Won't`, an Adverse outcome or a refused request leads
with the answer, not with the process that produced it.

| Instead of | Write |
|---|---|
| Items not meeting first-round criteria are deemed unsuccessful subject to FMC review | Bulk reassignment is out of scope for this release |
| Unfortunately the legacy platform is a mess and constantly falls over | The current dispatch service had 14 unplanned outages in the 12 months to June 2026 |

**Objective and impartial.** State facts with a benchmark, not opinion. An evaluative adjective or
adverb (`just`, `significantly`, `dramatically`, `unfortunately`, `obviously`, `simply`,
`seamless`, `world-class`) carries a judgement the source did not make. `only` is evaluative when
it judges an amount (`only 15 outages`). It is not evaluative when it limits a scope (`visible only
to the submitting party`), which is a precise restriction and stays. Replace it with the
baseline, the comparison or the source that supports it. A problem statement presents the
evidence and does not assign blame to a team, a vendor or an earlier decision.

**Respectful.** Inclusive language. The document neither talks down to its reader nor addresses
them familiarly.

**Exempt from this section:** verbatim source quotations, such as the text inside
`[TBD — source: "…"]` or a quoted stakeholder statement, which keep the speaker's own words, and
controlled vocabulary such as the MoSCoW value `Won't`.

### Voice by Altitude

Two registers. Applying the wrong one at the wrong level is the most common error.

| Element | Form | Example |
|---|---|---|
| Capability / feature name | **Noun phrase** | `Customer despatch notification` |
| Requirement or story title | **Active, verb-first** | `Notify customer of despatch` |
| "I want" clause | **Active, verb-first**, solution-agnostic | `Notify the customer when despatch occurs` |
| Acceptance criterion | **Noun-first, passive, declarative** | `Despatch notification is issued within 5 minutes of consignment scan` |
| ORD register row | **Active, verb-first** `Requirement Title`; **noun-first, passive** `Business Tolerance` carrying its own value | `Notify customer of despatch` / `Despatch notification is issued within 1 business hour of consignment scan, beyond which the delivery promise is breached` |

Titles command. Criteria state. The criterion form is deliberate: leading with the noun and
using the passive leaves **no grammatical slot for a modal verb**, so the failure this ruleset
exists to prevent becomes hard to write rather than merely discouraged.

### Banned in Generated Requirements

**Modals — never appear in a requirement, criterion, or commitment:**
`could` · `should` · `would` · `may` · `might`

They make the statement unfalsifiable: a criterion that *may* be met cannot fail a test.

**`shall` — permitted but avoided.** It is not ambiguous, but the declarative present is
shorter and reads as a fact rather than an obligation. Prefer the rewrite; do not treat an
existing correct `shall` as a defect.

**Constructions — never:**
`allow me to` · `allows the user to` · `enables` · `is able to` · `can [verb]`

These describe a capability the solution grants rather than an outcome that is true. `can` is
the most common offender and the easiest to miss:

> ✗ `Then they can complete the purchase without re-entering card details`
> ✓ `Purchase completion is available to a returning customer without card re-entry`

**Never write "the system"** — or "the platform", "the application", "the solution". Name the
product, service, or component. Where no name exists yet, use the `[SYSTEM-NAME-TBD]`
placeholder the skill already defines, and resolve it before the document is approved.

### Demand, not design

**Quantify the business tolerance, not the engineering figure that satisfies it.**

A requirement can be fully quantified and testable — as ISO/IEC/IEEE 29148:2018 requires — without
presupposing a design. The discipline is one level down from the rule that a BRD never names a
solution.

| Business demand (belongs in the requirement) | Technical target (the design response, downstream) |
|---|---|
| An agent retrieves a customer's account without the customer noticing a wait | Sub-200ms API response at the 99th percentile |
| Service is restorable within 1 business day; beyond that, obligation X is breached at cost Y | RTO 4h, active-active across two zones |
| No more than 1 working day of transactions is lost in any failure | RPO 1h |
| A field technician completes a job through a 30-minute connectivity gap | Offline cache with conflict resolution on reconnect |

Every left-hand statement is quantified, testable and traceable to a business source — a contract, a
regulatory obligation, an incident cost, a named stakeholder. **None requires an architect to
write.** That is what makes a requirements document producible by a business-side role.

**Where a document states a technical target, it pre-empts the review it exists to inform.** The
figure is asserted rather than derived, and the design review becomes ratification of a number an
analyst chose. Supply the demand; let the design response supply the target.

**This is not a ban on numbers.** A tolerance without a number is a vagueness defect under the next
section. The test is not *is there a figure* but *whose figure is it* — the business's tolerance, or
the engineer's answer to it.

### Vagueness

Unquantified adjectives are not requirements: `fast`, `reliable`, `intuitive`, `robust`,
`scalable`, `secure`, `user-friendly`. Either give a threshold and a measurement method, or
write `[TBD — source: "quoted vague statement"]` and leave the gap visible. Never quantify by
invention.

Quantification alone is **not** sufficient — "The system should respond within 3 seconds" is
quantified and still fails this ruleset. Both the number and the form are required.

### Sentences and Word Choice

Adopted from the Australian Government Style Manual: *Sentences*, *Plain language and word
choice* and *Clear language and writing style*.

**Length.** Sentences average 15 words, and none is longer than 25. This applies to narrative
prose and to every register cell. A longer statement is split into separate sentences or a list,
and a tolerance that needs more is carrying mechanism, which belongs in a cited `BRL-NNN`. An ID
or a cited reference counts as one word.

**Structure.**
- Subject, verb, object, in that order. A modifier goes after the main clause, never inside it.
  Write `Notification is issued within 1 hour of scan`, not `Notification is, within 1 hour of
  scan, issued`.
- Positive statements. State what is true, not what is not, and never use a double negative
  (`not unacceptable`). A prohibition is written as one, plainly.
- Never use `if` and `unless` in the same sentence. Split the conditions, or put them in a
  business rule.
- `other than` goes directly after the term it qualifies, so the exception is unambiguous.
- No `such … as` (`such steps as are appropriate`) and no `being` as a joining word. Use `and`.
- No `there is` or `there are` when they add words but no meaning.
- No more than 3 nouns or adjectives in a row. `Customer despatch notification` is the limit.
  `Customer despatch notification exception reporting` is a noun train, so rewrite it as a clause.

**Verbs over hidden verbs.** Write `decide`, not `make a decision`, and `consider`, not `give
consideration to`. This does not conflict with § *Voice by Altitude*: a criterion starts with a
noun *subject*. What this rule bans is a verb turned into a noun inside the sentence.

**Cut unnecessary words.** Each word has a job. Adverbs and adjectives go first. Then check that
the sentence still means the same and is still grammatical.

**Everyday words.** Use the plain alternative unless a term is defined in the Glossary or taken
from a standard this ruleset cites (ISO/IEC/IEEE 24765, ISO/IEC 25010). A defined term keeps its
defined form: `impact` names an `IMP-NNN` row and stays.

| Instead of | Write |
|---|---|
| in order to | to |
| prior to / subsequent to | before / after |
| commence / cease | start / stop |
| utilise | use |
| in the event that | if |
| due to the fact that / as a consequence of | because |
| in relation to / with regard to / in respect of | about |
| pursuant to | under |
| until such time as | until |
| ascertain | find out |
| approximately | about |
| a number of | the number itself, or `some` |
| at a later date | the date, or the timeframe |
| leverage | use, build on |
| deliver / drive (an outcome) | the actual verb: `reduce`, `increase`, `replace` |
| impact (verb) | affect |
| require (verb) | state the end state that is needed |

**Shortened forms.**
- Write the full term first, with the acronym in brackets after it: `Network Operations Centre
  (NOC)`. A shortened form that is better known than its full form goes first, with the expansion
  after it.
- Every acronym goes in the Glossary. A register row is read on its own, so an acronym in a row
  is also defined in the Glossary, not only in an earlier paragraph.
- A term used only once or twice is written in full and not shortened.
- No plural or possessive form at the point of definition, and no full stops inside or after an
  acronym.

**Reading level.** The executive summary and the narrative sections aim for a lower-secondary
reading level (WCAG 2.2 success criterion 3.1.5). Specialist content is supported with the
Glossary and a short summary in plain terms. It is never written down to.

### Numbers, Dates and Units

Adopted from the Style Manual, *Grammar, punctuation and conventions* § *Numbers and
measurements*.

**Numerals.**
- In prose, numbers from 2 up are numerals, and `zero` and `one` are words.
- **Every number in a register cell is a numeral**, `0` and `1` included. So is every number with
  a unit, every comparison, decimal, percentage, date, time and series. A tolerance is a
  measurement, so `1 business hour` and `4 business days` are correct.
- Never start a sentence with a numeral. Reword it: `Rates made up 55% of revenue`, not `55% of
  revenue came from rates`.
- Numbers of 4 or more digits use commas, never spaces: `2,500`. Large rounded numbers use a
  numeral and a word: `2.5 million`, `$50 million`.

**Percentages.** A numeral with no space before `%`: `99.5%`. Use decimals, not fractions. Write
the noun as `percentage`, and `per cent` as 2 words. **Never describe a change as a percentage
alone.** State the baseline and the new value, as the BRD objective schema already requires. A
percentage can sit next to them but never replaces them.

**Dates and times in prose** (locale default, see § *Locale Conventions*).
- Day, month, year, with no comma or ordinal: `15 October 2026`, `Thursday 15 October 2026`.
- Spans: `from 3 to 21 December`. Financial years use an en dash: `the 2026–27 financial year`.
- Times use a colon and a lower-case `am`/`pm`: `9:30 am`, `2 pm`. Use `noon` and `midnight`,
  never `12 am` or `12 pm`. The 24-hour clock is used where the operation already runs on it.
- A tolerance that depends on a time zone names it.

**Dates in register cells** use `yyyy-mm-dd` (see § *Recorded Deviations from the Australian
Government Style Manual*).

**Units.** Numerals with the SI symbol and a non-breaking space: `30 km`, `500 kg`. A symbol the
reader may not know is spelt out at first use, with the symbol in brackets after it. Symbols take
no full stop and no plural form.

### Punctuation, Capitalisation and Spelling

Adopted from the Style Manual, *Grammar, punctuation and conventions* § *Punctuation* and
§ *Spelling*.

**Minimal punctuation.**
- No full stop at the end of a heading, a caption or a list item that is not a full sentence.
- No semicolons at the end of list items.
- One space after a full stop, never two.
- A sentence that needs a lot of punctuation is too long. Split it.

**Capitals.** Sentence case in all free text. Capitals go on proper nouns only. A role or position
named in prose is lower case (`the regulatory reporting manager`) unless it is a title the
organisation sets in legislation or policy. Fixed labels keep their form (see deviations below).

**Spelling** (locale default, see § *Locale Conventions*). Australian English, from one Australian
dictionary used consistently: the Macquarie Dictionary, unless the company style guide names the
Australian Oxford. Where a word has more than one spelling, use the first one listed. `-ise`
endings, `per cent`, and `judgement` (but `judgment` in legal material).

### Locale Conventions

**The Australian locale is on by default.** The rules marked *locale default* above are the only
ones in this file that depend on where the document is written and read:

| Convention | Australian default |
|---|---|
| Spelling and dictionary | Australian English, Macquarie Dictionary, first listed spelling |
| Dates in prose | `15 October 2026`, with no comma or ordinal |
| Times | `9:30 am`, `2 pm`, `noon`, `midnight` |
| Financial year | `2026–27`, running 1 July to 30 June |
| Percentage in words | `per cent` |

**Before drafting, read `~/.claude/knowledge/company/style-guide.md`.** If the file is missing,
is a placeholder or has no `Locale` section, the Australian defaults apply and nothing is
reported.

**A company style guide can replace this whole table.** It does so with a `Locale` section that
states a value for every row, for example US English with Merriam-Webster and `October 15, 2026`.
A partial `Locale` section replaces nothing: the rows it leaves out would fall back to Australian
values and the document would mix 2 conventions. A partial section is reported as a finding and
the Australian defaults stay in force.

**Nothing else in this file is a locale rule.** Plain language, sentence length, numerals,
objective tone, acronym handling and every deviation apply whatever the locale. A `Locale`
section that tries to change them is a relaxation, and § *Enforcement* in `README.md`
refuses it.

Register cells date as `yyyy-mm-dd` in every locale.

### Citing Sources

Adopted from the Australian Government Style Manual, *Referencing and attribution*
(stylemanual.gov.au). Every source a document relies on is cited in a form a reader can find, and
every citation resolves to a row in the reference list (`tables.md` § *Reference list*).

**The system is author–date.** The Style Manual prefers it to footnotes for accessibility, and it
survives the move into tables and the `.llm.md` companion. No footnotes or endnotes are used.

| Source | In text and in `Source` cells | Notes |
|---|---|---|
| Act of parliament | *Privacy Act 1988* (Cth) at first mention, then Privacy Act | Title case, with the year and the jurisdiction. Italic at first mention only |
| Pinpoint in an Act | Privacy Act s 6, subs 6(1), para 6(1)(a), Pt 3, Sch 1 | No full stops. In running prose, write `section 6` in full |
| Delegated legislation or a code | The same pattern as an Act | Use the authorised title from the jurisdiction's legislation register |
| Standard | ISO/IEC 25010:2023 | The designation and year. Cite the AS or AS/NZS adoption where one exists (`ai.md` § *Standards of record*) |
| Contract or agreement | Retail service agreement cl 14 | `cl` for a clause and `Sch` for a schedule, from the contract's own numbering |
| Report, webpage or dataset | (Acme Communications 2026) | Author and year with no comma. `n.d.` with no date, and `et al.` for 3 or more authors |
| Internal record | Incident record INC-2291 | The record's own identifier, so the owning system can find it |

**First mention, then the short form.** An Act takes its full short title in italics at first
mention, and the short form after that. A shortened form that does more than drop the year goes
in brackets at first mention: *Work Health and Safety Act 2011* (Cth) (WHS Act). The `Cited as`
column of the reference list holds the short form.

**Shortened forms.** `s`, `ss`, `subs`, `para`, `cl`, `Pt`, `Div`, `Sch`, `p` and `pp` take no full
stop. `n.d.` and `et al.` keep theirs. Never use `ibid.`, `op. cit.`, `loc. cit.` or `id.`: repeat
the short form instead.

**Quote exactly.** A quoted source keeps its own words, spelling and acronyms. An unexplained
acronym in a quote gets its expansion in square brackets.

### Narrative Sections

Background, mission context, operational scenarios and day-in-the-life narratives are prose by
design and are exempt from the noun-first criterion form. They remain subject to the modal ban
and the "the system" ban, and they must never introduce a commitment that does not also appear
as a row (see `tables.md`).

### Recorded Deviations from ISO/IEC/IEEE 29148:2018

`/write-prd` cites 29148. This ruleset deviates from it twice, deliberately:

1. **Declarative present is preferred over `shall`.** 29148 makes `shall` the canonical binding
   verb. We prefer the end-state form because it is shorter and verifiable as a statement of
   fact. `shall` remains valid, so this is a preference, not a conflict.

   **The same deviation applies to the INCOSE *Guide to Writing Requirements*,** which is more
   prescriptive than the ISO text on this point and is the practitioner authority most likely to be
   cited against a document authored under these rules. Recording the deviation once, against both
   sources, is deliberate: a deviation noted against 29148 alone silently extends to INCOSE, which
   is how a documented choice becomes an apparent defect in review.
2. **Passive voice is mandated for acceptance criteria.** 29148 recommends active voice on the
   grounds that passive hides the actor. Accepted and mitigated: where the actor is
   load-bearing — authorisation, non-repudiation, audit, and anything in ORD §7.3 Security —
   name the actor explicitly and use the active voice. Elsewhere the passive is what makes
   noun-first possible once "the system" is banned.

Neither deviation is silent: any document claiming 29148 conformance cites this file.

### Recorded Deviations from the Australian Government Style Manual

The Style Manual is written for content that tells a reader what to do. A requirements document
states what is true once a change is delivered, and it is verified against that statement. Four
deviations follow from the difference. Each is deliberate:

1. **Passive voice in acceptance criteria and Business Tolerance cells.** The Style Manual's own
   counter-example, `Applications are assessed within 30 days`, is the exact form this ruleset
   requires of a criterion. It names no actor because the actor belongs to the design response,
   not the demand. The mitigation is the one in the 29148 deviation 2: where the actor is
   load-bearing, name it and use the active voice. Titles and narrative prose use the active voice,
   as the Style Manual says.
2. **No second person.** The Style Manual recommends `we` and `you` where they suit the voice and
   tone. Its tone guidance puts reports and policies in formal tone, which uses the third person,
   and a requirements document is one of those.
3. **Fixed labels keep title case.** Section headings, column names, controlled values (`Sunny
   Day`, `Must`, `Provisional`) and role names in `Owner` cells are labels that reviewers, other
   skills and tooling match on exactly. They keep the form their schema gives them. Sentence case
   applies to all other text.
4. **Register cells date as `yyyy-mm-dd`.** The Style Manual uses `15/10/2026` in tables. Register
   dates are sorted, compared and read outside Australia, and the Style Manual accepts
   international standards for data. Prose uses `15 October 2026`.

**Not aligned to ASD-STE100.** Simplified Technical English mandates active voice and the
imperative, and governs technical *documentation* (procedures, manuals), not requirements.
Downstream operational artefacts — runbooks, operator and field procedures — may adopt STE
independently; requirements documents do not.

### Never

- Never use `could`, `should`, `would`, `may`, or `might` in a requirement, criterion, or commitment.
- Never state a technical target where a business tolerance belongs — no RTO, RPO, latency figure,
  availability percentage, instance count or protocol choice in a demand-side requirement.
- Never coin a term where ISO/IEC/IEEE 24765 (systems and software vocabulary) or, for AI,
  ISO/IEC 22989:2022 supplies one. Record the adopted term in the project glossary.
- Never write `enables`, `is able to`, `allows … to`, or `can [verb]` in a criterion.
- Never refer to "the system", "the platform", "the application", or "the solution".
- Never treat quantification as sufficient — a hedged number is still a hedge.
- Never invent a threshold to avoid writing `[TBD]`.
- Never use a contraction, metaphor, idiom or slang in a generated document, except as controlled
  vocabulary or inside a verbatim quotation.
- Never write in the first or second person (`I`, `we`, `our`, `you`) outside a verbatim quotation.
- Never use an evaluative adjective or adverb that has no benchmark, and never assign blame in a
  problem statement.
- Never use an acronym or internal shorthand that is not defined on first use.
- Never bury an unfavourable position under the process that produced it.
- Never write a sentence longer than 25 words, in prose or in a register cell.
- Never use a double negative, or `if` and `unless` in the same sentence.
- Never string more than 3 nouns or adjectives together.
- Never write a number in a register cell as a word, and never start a sentence with a numeral.
- Never describe a change as a percentage alone. State the baseline and the new value.
- Never mix spellings or date formats. Use the active locale, which is Australian unless a
  complete company `Locale` section replaces it.
- Never cite a source in a form the reference list does not hold, and never use a footnote.
- Never use `ibid.`, `op. cit.`, `loc. cit.` or `id.`.
- Never apply these rules to the skills' own instruction prose (see `README.md`).


---

## `tables.md`

> Governs how requirements are *presented* in generated documents. Pairs with
> `language.md`, which governs how they are worded.

### The Rule

**Every binding statement is a row in a table with a stable ID. Prose carries narrative only.**

A statement is **binding** if someone could later be held to it. The test: *could this be
cited in a review, an audit, an SLA dispute, or an acceptance test?* If yes, it is a row.

This is deliberately narrower than "tabularise everything". Prose sections earn their place and
are made worse by tabulation — background, mission context, system overview, and day-in-the-life
operational scenarios stay as prose. What they must never do is introduce a commitment that does
not also appear as a row somewhere.

### Canonical Schemas

Use these exactly. A document that invents a column set drifts from its sibling, which is the
failure this file exists to prevent.

#### Requirement register — the demand-side ORD

Every operational requirement, in every section. The subsection heading supplies the ISO/IEC 25010
characteristic, so there is no characteristic column.

| ORD# | Ver | Requirement Title | Business Tolerance | KPP | MoSCoW | Status | Owner | Source |
|---|---|---|---|---|---|---|---|---|
| ORD-NNN | 1.0 | [active, verb-first] | [declarative end state, carrying its own quantified value] | [KPP] or blank | Must | Committed | [named business owner] | [contract, obligation, incident record, or BU/Function/Name] |

**Column-name equivalence.** The requirements-documents pack writes the first column `Ref` and uses
sentence case (`Requirement title`, `Business tolerance`). They are the same columns; `ORD#` is used
here for consistency with `PRD#` and `BRD#` elsewhere in this file. `MoSCoW` is an extension the
pack does not require — see below.

**The register states business demand, never the technical target that satisfies it.** *"Service is
restorable within one business day, beyond which obligation X is breached"* is a requirement;
*"RTO 4h"* is the design response to it. See `language.md` § *Demand, not design*.

- **`Requirement Title` is active and verb-first** — `Restore service within one business day` —
  while `Business Tolerance` is noun-first and passive. That split is the existing rule in
  `language.md` § *Voice by Altitude*, applied at one altitude: titles command,
  criteria state. It is not a summary of the tolerance and never carries a value of its own.
- **`Business Tolerance` is written at executive altitude.** The test: *could an executive
  understand it without understanding reporting, governance, architecture or implementation?* If
  not, it states the outcome and the breach consequence, and the detail moves to a `BRL-NNN` rule
  (§13) or a §14 reporting definition the row cites — *"published results are auditable and
  reproducible"*, not *"each included, excluded and exception record retains a stable identifier
  linking …"*. Moving detail never drops it.
- **`Business Tolerance` carries its own quantified value.** No separate threshold column — under
  `language.md` the requirement is a declarative end state, so the number is part of
  the sentence. Prefix **[AI]** where `ai.md` governs the row.
- **`KPP` is a column, not a prefix.** A KPP carries **threshold** (minimum acceptable) and
  **objective** (desired) as two labelled values inside `Business Tolerance`; collapsing them to one
  figure is how KPP intent is lost downstream. `[AI]` remains a prefix — it records which ruleset
  governs the row's form, which is not a property a column should imply is severity.
- **`Status` is `Committed` / `Provisional` / `Assumed`** — the maturity of the demand statement, not
  of a technical threshold. An `Assumed` row without a named owner and a confirm-by date in the
  assumption register is an invented number, not an assumption.
- **`Owner` is the named business owner of the tolerance.** Not the delivery team and not the
  operating team — both are response-side and neither is knowable at ORD time.
- **`Ver` is the requirement's own version**, not the document's. It rises when the tolerance
  changes after first issue, and it is what makes inline provenance work: a proposed acceptance
  criterion carries `[ORD-003 · v1.0 · Provisional · owner: … · confirm by …]` so the criterion's
  standing travels with it to whoever writes the Capability AC. Without it a downstream reader
  cannot tell an agreed tolerance from a revised one.
- **Traceability is not a register column.** The up-link — the `OBJ-NNN` objective and the BRD
  objective it serves via its business requirement — lives once, in §11 Traceability. Carrying it in both
  places is the restatement the § *View Tables* rule forbids. A row tracing only as far as a `BR-N`
  has no funded outcome behind it, which is what §11's `via` makes visible.
- **`Source` is the evidence, not the speaker alone.** A contract clause, a regulatory obligation, an
  incident record or an `ASM-NNN`. Where the only source is a stakeholder, name Business Unit,
  Function and Name.
- **There is no `Verification` column.** The measurement *population* belongs inside the tolerance
  sentence; the *instrument* that measures it is the design response, recorded at §17 when
  the SOAP is issued. A demand-side ORD that names its own instrument has pre-empted the review it
  exists to inform.

**MoSCoW, `KPP` and `Status` are three orthogonal axes and all three are kept.** A KPP is a
business-failure threshold; a Must is required for this release; a Status is how well evidenced the
statement is. Most KPPs are Musts; most Musts are not KPPs; a KPP may sit at any status, and one at
`Assumed` is the single item that warrants escalation.

**`Should` and `Could` as MoSCoW values are not a `language.md` violation.** That rule bans hedging
verbs inside requirement *text*; a controlled enum in a priority column is unambiguous. Do not
"correct" it. **MoSCoW is DSDM, and KPP is US DoD JCIDS** — neither is ISO-backed. Both are retained
as house convention; neither is cited as a standards obligation.

#### Prioritisation and status definitions

**Emitted verbatim into every ORD at §5.2**, so a reader meets the three axes defined before meeting
the register. In the ORD the table is headed as a **view** of this section, so the LLM companion
omits it — the companion's own Vocabulary already carries these definitions. Never reworded per document — the definitions are what make one ORD's `Must` mean the
same as another's.

| Column | Value | Definition | Assigned by |
|---|---|---|---|
| MoSCoW | **Must** | Required for this release. The release is not accepted without it. | Product Manager |
| MoSCoW | **Should** | Important and of significant value. The release is accepted without it. | Product Manager |
| MoSCoW | **Could** | Desirable. Delivered where capacity allows. | Product Manager |
| MoSCoW | **Won't (this release)** | Raised, recorded and deliberately deferred. It stays in the register for a later release and carries no acceptance criterion. | Product Manager |
| KPP | **[KPP]** | A business-failure threshold: failure means the capability is unfit for purpose, not merely degraded. Carries a threshold (minimum acceptable) and an objective (desired). Independent of MoSCoW — most KPPs are Musts, most Musts are not KPPs. | Business owner, at the Phase 1 gate |
| Status | **Committed** | The business owner has stated and agreed the tolerance, and it traces to an obligation, contract, incident record or business decision. | Evidence |
| Status | **Provisional** | The tolerance derives from a real source — an SLA, contract, incident history, analogous service — not yet confirmed by the owner for this change. | Evidence |
| Status | **Assumed** | No owner confirmation and no documentary source; rests on an `ASM-NNN` with a named owner and a confirm-by date. | Evidence |
| Rule status | **Confirmed** | The rule owner has agreed the business rule as written in §13. | Rule owner |
| Rule status | **Provisional** | A source states the rule, but its owner has not confirmed it for this change. The same word as the requirement status, applied to a rule. | Evidence |
| Rule status | **Unresolved** | The rule is not decided. `Rule` carries a `[TBD]`, and the row cites the decision item that settles it. | Evidence |

**`Won't` is not out of scope.** A `Won't` item is in this document's scope and deferred; an
out-of-scope item is never delivered by this document (ORD §4.2). **An item removed from scope after
agreement is descoped, and descoping is a scope change, not a priority** — it is recorded as a §4.2
exclusion with a §18 change-history entry stating when, by whom and why, never as a `Won't`.

**Delivery Agent, Operational Owner, Timing and Verification are deliberately absent.** Each names
something the demand side does not know and cannot commit: who will build it, who will run it, when
it will be scheduled, and what instrument will prove it. Timing lives at the objective
(`OBJ-NNN` § *Target Date*), which the requirement inherits through §11. Traceability and the
written-back downstream links both live in §11 Traceability, not in the register.

**`MoSCoW` is an extension to the demand-side standard.** The standard does not require it; these
rules keep it because `/write-ac` gates AC altitude on it. It is business prioritisation, so it sits
on the demand side legitimately — but an ORD authored to the pack alone carrying no `MoSCoW` column
is conforming, not defective.

#### Operational objective

The outcome layer between a BRD objective and an operational requirement. Every register row traces
to one.

| ID | Objective | Baseline | Target | Target Date | Traces to |
|---|---|---|---|---|---|
| OBJ-NNN | [operational outcome, never the solution] | [current measurable position] | [required outcome] | [date or milestone] | [BO-N via BR-N] · [ORD-NNN, …] |

`Baseline`, `Target` and `Target Date` are measures under ISO/IEC 25022 / 25023. Where any of the
three is unavailable, write `[TBD — source: "quoted vague statement"]` and leave the gap visible.
**Never invent a baseline** — an objective whose baseline is guessed cannot show improvement.

#### Scenario

Requirement-level scenarios and the consolidated scenario catalogue are **one table**, keyed by
`ORD#`. Building a second catalogue would restate every row.

| ID | ORD# | Scenario | Outcome | Condition | Expected end state |
|---|---|---|---|---|---|
| SCN-NNN | ORD-NNN | Sunny Day | Favourable | [in-distribution, everything available] | [declarative end state] |
| SCN-NNN | ORD-NNN | Sunny Day | Adverse | [processing succeeds, result is unfavourable] | [declarative end state] |
| SCN-NNN | ORD-NNN | Rainy Day | — | [dependency down, data unavailable, retrieval failed] | [declarative end state] |
| SCN-NNN | ORD-NNN | Edge Case | — | [empty, maximum, expired, first, last] | [declarative end state] |

**`Scenario` and `Outcome` are two axes, not one.** `Scenario` is the condition the *capability* is
put through — the three values in this file, unchanged. `Outcome` is whether the *subject being
measured* passes or fails, and it applies only on a Sunny Day: a determination that runs correctly
and returns bad news is not a capability failure. That is why a fourth `Scenario` value was not
added — it would conflate the two axes.

- **`Outcome` is `Favourable` / `Adverse`, and `—` where the axis does not apply.** A Rainy Day has
  no outcome because nothing was determined.
- **A determination, measurement or eligibility requirement carrying only a Favourable Sunny Day row
  is incomplete.** What must be true when the answer is unfavourable is a separate obligation, and
  it is the one most often left unstated.
- Each row stays a declarative statement under `language.md`. A Rainy Day row states
  what *is* true when the dependency fails, never what might happen.
- A story or requirement whose scenarios are all `Sunny Day` has been specified for the demo, not
  for production.

#### Business rule

**The ORD states what must happen; the business rule register states how decisions are made.**
Every ORD carries the register at §13, grouped into three, whether or not a functional requirements
document follows — a requirement that embeds its classification, cut-off or reconciliation logic has
been written at the wrong altitude, and the register is where that detail goes instead. Where a PRD
in the chain already states a rule, the row cites the PRD criterion (`PRD-NNN.N`) and restates
nothing — the PRD states rules as criteria and never mints `BRL-NNN`.

| ID | Group | Rule Type | Required Decision | Rule | Status | Owner | Effective Date | Affects |
|---|---|---|---|---|---|---|---|---|
| BRL-NNN | Classification / Reporting / Governance | [from the group's types below] | [what must be determined] | [the rule as the business states it, or `[TBD — source: "…"]` while unresolved] | Confirmed / Provisional / Unresolved | [named, or TBD with confirm-by] | [where supplied] | [ORD-NNN, …] |

| Group | Rule types |
|---|---|
| **Classification** | Inclusion · Exclusion · Cohort assignment · Eligibility |
| **Reporting** | Reporting period · Cut-off · Late-arriving data · Calculation · Restatement |
| **Governance** | Reconciliation · Exception handling · Evidence retention · Rule versioning |

- **`Owner`, `Status` and `Affects` are mandatory on every row** — a rule with no affected
  requirement governs nothing, and one with no owner has nobody to change it.
- **Business rules are functional content carried by the ORD by design.** State that in the §13
  lead so a reviewer reading against a scope that excludes them sees a declaration, not an absorption.

- **`Required Decision` and `Rule` are OMG DMN's two levels, kept in two columns.** The decision
  is what must be determined — *whether a complaint counts in the measure*. The rule is the decision
  logic in the business's own words — *a complaint withdrawn by the customer is excluded*. The ORD
  carries both: the executive-altitude test moves this logic out of the requirement, and this column
  is where it lands.
- **`Rule` is business policy, never implementation design.** No query, field name, system
  behaviour, decision-table encoding or algorithm — those are how the delivered solution applies the
  rule, and belong to the design response. The test: a business owner reads it and agrees or
  disagrees without asking how it is built.
- **An `Unresolved` row carries `[TBD — source: "…"]` in `Rule`**, never a drafted answer. Where two
  documented positions compete, both go in the decision item the row cites, not in `Rule`.
- An `Unresolved` rule affecting a KPP-bearing requirement is raised via `/raid add decision`.

#### Decision

Every unresolved business decision is a first-class row — never an assumption embedded in a
requirement. ORD §8.1.

| ID | Decision required | Affects | Options | Owner | Required by | Status | Resolution |
|---|---|---|---|---|---|---|---|
| D-NNN | [what must be decided] | [ORD-NNN, BRL-NNN, …] | [the documented positions] | [named] | [date] | Open / Resolved / Superseded | [the decision taken, by whom and when — blank only while Open] |

`/raid` owns `D-NNN`. Where no RAID log exists, the ID cell carries a **numbered placeholder** —
`[D-TBD-1]`, `[D-TBD-2]`, flat and sequential in order of first appearance — and the row is kept.
The number is what lets a `BRL-NNN` or `ORD-NNN` row cite *which* open decision governs it; it is
local to the document and is replaced, everywhere it is cited, when `/raid` mints the real ID.
A `Resolved` row is kept, not deleted — the resolution is the record the affected requirements
were changed against.

#### Related initiative

Adjacent work this document neither depends on nor delivers. ORD §10.2. **No ID — the initiative
name is the key**, on the operational-actor reasoning: it identifies, and commits nothing.

| Initiative | Relationship | Owner | Routed items | Status |
|---|---|---|---|---|
| [named programme, project or change] | Overlaps / Feeds / Consumes / Supersedes | [named] | [REF-NNN, …, or —] | [as reported by its owner] |

**Four registers, four tests — never one table:**

| It is a… | When |
|---|---|
| **Dependency** (`DEP-NNN`) | This document's outcome cannot be delivered until it is |
| **Related initiative** | It touches the same scope, but this document's outcome does not wait for it |
| **Referred requirement** (`REF-NNN`) | Content raised here that another owner delivers |
| **Out-of-scope item** (§4.2, `IMP.Treatment`) | Deliberately excluded, and delivered by nobody as a result of this document |

#### Impact register

What the change touches and who owns it. Identification and accountability — never target state.

| ID | Impact | Kind | Treatment | Owner | Referred |
|---|---|---|---|---|---|
| IMP-NNN | [named L4 workflow or system in the current estate] | Process / System | Addressed / No change required / Out of scope | [named owner] | [REF-NNN or —] |

Naming the as-is estate is identification; naming the to-be estate is design. A row says what is
touched, who owns it, and whether **this document** addresses it — and says nothing about what
becomes of it. **Where tier numbers are cited, name the scheme they belong to** — an unqualified
"L4" resolves differently in APQC, eTOM and a house scheme.

**`Treatment` is a scope disposition, and the enum is closed.** Three values, no others:

| Value | Means |
|---|---|
| `Addressed` | This document carries requirements for the impact |
| `No change required` | The impact was identified and assessed as needing nothing |
| `Out of scope` | Identified, and deliberately excluded from this document |

**A design disposition is not a treatment.** *Migrated*, *decommissioned*, *extended*, *replaced*,
*rebuilt* — each names what becomes of the impact, which is the response's answer and not the
demand's. A row carrying one has crossed the line this register exists to hold.

**`Referred` is the pointer, `Treatment` is the disposition, and neither substitutes for the
other.** A referred impact still carries a treatment — usually `Out of scope`, because referral is
what happens *after* this document excludes it. Reading a populated `Referred` cell as a treatment
loses the distinction between an exclusion that went somewhere and one that did not.

**Where a document states an exclusion for a named impact, this cell is the authoritative value**
and any prose scope statement is a view of it. Prose keeps the exclusions that are not impacts —
populations, geographies, timeframes — which have no row to be authoritative in.

`Treatment` is additive. A register predating it reads `[TBD]` in that cell and is not retrofitted;
the value is written when the document is next reissued.

#### Operational actor

Who and what the operational process runs through. **Identification, like the impact register** —
never authority the source did not state, and never a target operating model.

| Actor | Kind | Operational role | Owner |
|---|---|---|---|
| [named person-role, system or organisation] | User / System / Party | [what it does in the operational process] | [named owner, or TBD with confirm-by] |

- **`Kind` is `User` / `System` / `Party`.** `Party` is an external organisation — a retail service
  provider, a contractor, a regulator. Without it a cross-party consequence has no subject to name,
  and cross-party consequence is the class most often left derived and unconfirmed.
- **This table carries no ID, and that is deliberate.** The actor name is the key. An actor row
  identifies a subject; it commits nothing, so nothing traces *to* it — which is the test the
  § *Statements that carry no ID* rule applies, and this row sits outside that list rather than
  extending it. A prefix here would buy reference precision and cost a namespace every sibling
  skill must avoid colliding with.
- **Governance roles are not actors.** The SME who informed the document, the business owner who
  approves it and the convenor who wrote it belong in the document header and the entry-position
  record. A table mixing *the billing platform* with *the SME who reviewed this* serves neither
  purpose.
- **Notification is a view, not a column.** Who is told what, and when, cites the requirement rows
  that carry it.
- `Owner` accepts `[TBD]` with a confirm-by date. Where no stakeholder list arrives at assignment,
  a `[TBD]` per actor is what makes the absence countable; one entry-position row is not.

#### Referred requirement

Content raised during elicitation that this document will not deliver. No row is classified against
a 25010 characteristic and no row becomes a requirement of this document.

| ID | Requirement | Raised by | Kind | Related impact | Resolver group | Referred to | Date | Status |
|---|---|---|---|---|---|---|---|---|
| REF-NNN | [what was raised] | [name] | Functional / Wrong resolver / Out of scope | [IMP-NNN] | [group, or **None in chain**] | [named recipient] | [date] | Referred / Accepted / **Referred, not accepted** |

An omitted requirement is indistinguishable from one nobody had; a referred requirement with a named
recipient is a handoff. **`Resolver group: None in chain` is a real answer** and the row stays open —
it is the visible form of a gap in the delivery chain, not a defect in the document.

#### PRD story criteria

A PRD story is deliberately narrative — "As a … I want … so that …" carries intent and the business
outcome, which a register row cannot. Its **acceptance criteria** are rows:

| ID | Acceptance Criterion | Scenario |
|---|---|---|
| PRD-NNN.N | [declarative statement of what is true once delivered] | Sunny Day / Rainy Day / Edge Case |

- Criterion IDs are `PRD-NNN.N` within their story, so `/write-ac` maps each `AC-NNN` to a precise
  criterion rather than a whole story.
- A criterion over learned or generated behaviour is prefixed **[AI]** in the `Acceptance Criterion`
  cell and follows `ai.md` as well as this file.
- The story carries a `MoSCoW` priority; `/write-ac` gates altitude on it exactly as it does for
  ORD register rows.
- **`Scenario` names the weather the requirement is being put through**, not a category of criterion.
  The three values are the same requirement examined under three conditions, which is why the column
  is `Scenario` and not `Type` — a reader who sees `Type` asks what kind of criterion this is, and
  the answer is always "an acceptance criterion".

| Value | The requirement under | Answers |
|---|---|---|
| **Sunny Day** | Everything available and behaving | What is true when it works |
| **Rainy Day** | Something failing — dependency down, timeout, refusal | What is true when it breaks |
| **Edge Case** | A valid but boundary condition — empty, maximum, expired, first, last | What is true at the limits |

- `Scenario` makes the Sunny-Day-only coverage warning mechanically checkable: a story whose criteria
  are all `Sunny Day` has been specified for the demo, not for production.
- **These are labels for the condition, not a licence to hedge.** Each row stays a declarative
  statement under `language.md` — a Rainy Day criterion states what *is* true when the
  dependency fails, never what *might* happen.
- **A determination or eligibility story carries two Sunny Day criteria** — one where the answer is
  favourable and one where it is adverse. The capability succeeding and returning bad news is not a
  Rainy Day, and stating only the favourable case leaves the larger obligation unwritten. See
  § *Scenario* above for the `Outcome` axis; a PRD story may carry the column or say it in the
  criterion, but it states both cases either way.

#### Reference list

One table holds every source the document cites: the ORD's §4.5, the BRD's Appendix B and the
PRD's § *References*. The citation forms are in `language.md` § *Citing Sources*.

| Cited as | Full citation | Type |
|---|---|---|
| Privacy Act | Privacy Act 1988 (Cth) | Legislation |
| ISO/IEC 25010:2023 | ISO/IEC (2023) *ISO/IEC 25010:2023 Systems and software engineering — Systems and software Quality Requirements and Evaluation (SQuaRE) — Product quality model*, International Organization for Standardization, Geneva | Standard |
| Retail service agreement | Acme Communications and Retailer Pty Ltd (2025) *Retail service agreement*, version 4.2, unpublished | Contract |
| Acme Communications (2026) | Acme Communications (2026) *Missed appointment rebate review*, unpublished internal report | Report |

- **`Cited as` is the exact form used in `Source` cells and in prose.** A reader who finds the
  short form anywhere in the document finds it in this column.
- **Every cited source has a row, and every row is cited.** A source with no row is an
  untraceable claim. A row that nothing cites is padding.
- Rows are in alphabetical order of `Cited as`. `Type` is one of `Legislation`, `Standard`,
  `Contract`, `Report`, `Webpage`, `Dataset` or `Internal record`.
- `Full citation` follows the Style Manual's author–date form for its type. Act titles are roman
  in this table, although they are italic at first mention in text. A source with no date
  takes `n.d.`, and a webpage carries its accessed date.
- **A document that cites no source says so** with a single row: `None cited`. A list left out
  hides whether anything was cited.
- `ASM-NNN`, `D-NNN` and other register IDs are not listed. They already resolve inside the
  document or the RAID log.

#### Statements that carry no ID

Two kinds of binding row are deliberately ID-less, because nothing ever traces *to* them:

- **Exclusions** (PRD § Out of Scope) — cited in scope disputes, never referenced by another row.
- **Coverage gaps** (ORD § 7.10) — a record of absence; the ID would belong to a requirement that
  does not exist.

Everything else that binds carries an ID. Do not extend this list to avoid assigning one.

#### Interface detail

Per-interface technical attributes, keyed to a register row by `ORD#`. Specification, not
commitment — the binding statement is the register row, so this carries no priority or timing.

| ORD# | Integrated System | Interface Type | Protocol | Data Exchanged | Direction | Failure Behavior |
|---|---|---|---|---|---|---|

#### Assumption

Carries forward the table `/idea` already produces, so an assumption tracked at idea stage keeps
its identity and lifecycle into the requirements documents rather than collapsing back to prose.

| ID | Assumption | Status | If false | Owner | Confirm by |
|---|---|---|---|---|---|
| ASM-NNN | [declarative statement] | Unvalidated / Validated / Falsified | [consequence] | [named role] | [date] |

`If false` is mandatory — an assumption with no stated consequence is a note, not an assumption.

**`Owner` and `Confirm by` are mandatory wherever a register row cites the assumption as its
`Source`.** A requirement at `Status: Assumed` resting on an assumption with no named owner and no
date is an invented number, and it is the largest audit exposure a requirements document carries.
ISO/IEC/IEEE 29148:2018 requires traceability, not finality: a TBD with an owner and a date
conforms; a silent gap does not.

**Escalation:** The RAID log is Risks, Actions, Issues, Decisions — it has **no Assumptions
quadrant**. A falsified assumption therefore has no home in RAID and must be raised as a risk:
set `Status: Falsified`, run `/raid add risk`, and record the `R-NNN` in the `If false` cell.

#### Dependency

| ID | Depends on | Type | Owner | Needed by | Status |
|---|---|---|---|---|---|
| DEP-NNN | [named system, team, or deliverable] | Internal / External / Vendor | [role] | [date or milestone] | Open / Met / At risk |

### ID Namespaces

Authorised prefixes. See ADR-0001 for the requirement prefixes and their extension.

| Prefix | Owns | Assigned by |
|---|---|---|
| `BO-N` | Business objectives | `/write-brd` |
| `BR-N` | Business requirements | `/write-brd` |
| `PRD-NNN` | Functional requirements / user stories | `/write-prd` |
| `CON-NNN` | Solution constraints — demand-side givens (regulatory, contractual, mandated integration) | `/write-prd` |
| `ORD-NNN` | Operational requirements | `/write-ord` |
| `AC-NNN` | Acceptance criteria | `/write-ac` |
| `OBJ-NNN` | Operational objectives — the outcome layer every ORD row traces to | `/write-ord` |
| `BRL-NNN` | Business rules — every ORD, see § *Business rule* | `/write-ord` |
| `SCN-NNN` | Scenarios — requirement-level and catalogue, one namespace | `/write-ord` |
| `IMP-NNN` | Impacts — workflows and systems touched, with named owners | `/write-ord` |
| `REF-NNN` | Referred requirements — raised here, delivered elsewhere | `/write-ord` |
| `DAT-NNN` | Data elements — conditional, schema in `reporting.md` | `/write-ord` |
| `ASM-NNN` | Assumptions | whichever document records it |
| `DEP-NNN` | Dependencies | whichever document records it |
| `EVL-NNN` | Evaluation sets — schema in `ai.md` | `/write-ord` (the PRD cites, never mints — see below) |
| `MDL-NNN` | Model / provider dependencies — schema in `ai.md` | `/write-ord` (as above) |

`EVL-NNN` and `MDL-NNN` were added by ADR-0003 and apply only where `ai.md` is triggered.
**Both have exactly one assigning skill, like every other prefix here.** `/write-reqs` authors the
PRD before the ORD, so a PRD needing a set that does not exist yet writes `[EVL-TBD — <what must be
measured>]` and `/write-ord` writes the real ID back — the same mechanism as `Capability` and `Epic`.
Where no ORD is produced at all, the PRD holds the registers and assigns the IDs, and says so.

All are flat and sequential in order of first appearance, never encode a theme or characteristic,
and are never reused once retired. `BO-N` and `BR-N` are single-digit-sequential per BRD, matching
the form `/write-brd` emits — do not re-pad them to three digits.

**Do not use single-letter prefixes.** `/raid` owns `R-`, `A-`, `I-`, `D-` for Risks, Actions,
Issues and Decisions — `A-NNN` for assumptions would collide with Actions.

### Coverage Gaps — the collapse rule

A gap must stay visible, but a stub table per absent subsection buries the document. A
requirements document authored from thin source material can easily have more empty tables than
populated ones.

**Do not scaffold an empty table per absent subsection.** Instead:

- A subsection with **at least one** requirement gets its table, populated.
- A sub-characteristic with **no** requirement is omitted from the body entirely, and listed as one
  row in a single **Coverage Gaps** table at the end of the section.

**The collapse applies at sub-characteristic level only. All nine ISO/IEC 25010:2023 characteristics
appear in every ORD, without exception** — §7.1 through §7.9, each present even where it carries
nothing. A characteristic with nothing to state carries an explicit statement of that fact and its
status, never an omission. The two rules are not in tension: a characteristic is a heading a
reviewer checks for, and its absence is invisible; a sub-characteristic is a table, and thirty empty
ones bury the document.

| Absent subsection | Reason | Action |
|---|---|---|
| [e.g. 3.5.4 Replaceability] | No source material | Stakeholder workshop |

A requirement known to exist but unquantified is **not** a coverage gap — it is a populated row
carrying `[TBD — source: "quoted vague statement"]`.

### View Tables

Where a commitment is genuinely needed in two places — an SLA summary restating availability, an
incident-response table restating recovery targets — the second occurrence is a **view**, not a
second source of truth.

A view table restates the `ID` and the agreed value by reference and introduces **no new
numbers**. Head it explicitly:

> *View of Section 7. Values are authoritative in the referenced rows; this table adds no new commitments.*

Two tables carrying the same commitment at independently editable values is the defect this
prevents.

### Document Structure

Adopted from the Australian Government Style Manual, *Structuring content* (stylemanual.gov.au).
§ *The Rule* above decides *whether* something is a table. This section governs how headings,
paragraphs, lists and tables are put together.

**Order: most important first.** Each document leads with its executive summary or problem
statement, and each section leads with its main point. Supporting detail, mechanism and evidence
follow, and the appendices take what an executive does not need to read.

**Headings.**
- Under 70 characters, starting with the keyword. Never a question, and never an empty heading
  such as `Other` or `More information`.
- No more than 4 levels, and no level skipped. Section numbers go no deeper than 3 levels
  (`7.4.1`).
- A level used once is a stranded heading. Use at least 2 headings at that level, or none.
- At least 1 sentence between a heading and the next heading.
- Headings at the same level share a grammatical form, either all noun phrases or all verb
  phrases.

**Paragraphs.**
- One topic per paragraph. A new topic starts a new paragraph.
- The first sentence says what the paragraph is about. The first paragraph of a section
  summarises the section.
- No more than 6 sentences. A longer paragraph becomes 2 paragraphs or a list.
- A paragraph never starts with a pronoun whose noun is in an earlier paragraph.

**Lists.**
- A lead-in introduces every list. A lead-in phrase ends with a colon.
- Items share a grammatical form, and words repeated in every item move to the lead-in.
- **Fragment list:** items complete the lead-in. They start lower case, take no end punctuation,
  and only the last item takes a full stop. Lead-in and item together stay within 25 words.
- **Sentence list:** each item is 1 full sentence, with a capital and a full stop.
- Never end an item with `;`, `,`, `and` or `or`. Never end a list with `etc.`: write `for
  example` or `including` in the lead-in instead.
- Numbered lists only where the order matters. No more than 2 levels.

**Tables.**
- The text introduces every table and says what it shows. The text interprets the table and
  never repeats its data.
- Each column holds one kind of content in one grammatical form. Headings sit in the first row,
  and row labels in the first column.
- No merged cells and no tables inside tables. Meaning is never carried by colour, bold or
  position alone.
- No empty cells: `None`, `—` (for an axis that does not apply, as § *Scenario* defines), or the
  declared-gap markers this file defines.

**Links.**
- Link text names the destination and makes sense on its own. Never `click here` or `this
  page`.
- A link to a file names its type and size: `Annual report 2025–26 [PDF 1.9 MB]`. Link to the
  landing page where there is one.

**Callouts.** A `>` callout carries a view note, a rule statement or a test. It is used
sparingly and never holds a binding statement, because a callout is not a row.

#### Recorded deviations from the Style Manual

1. **Numbered headings.** The Style Manual numbers headings only for sequences. Requirements
   documents number their sections because a section number is a stable address that other
   documents, reviews and the `.llm.md` companion cite. Numbering stops at 3 levels, which is
   the Style Manual's own limit. A template's fixed sections are kept as the template gives them,
   even where one level holds a single heading.
2. **A table for 1 item.** The Style Manual puts 1 or 2 items in text rather than a table. A
   binding statement is a row with an ID however few there are, because § *The Rule* is about
   citability, not volume. The Style Manual's rule applies to everything that does not bind.
3. **One reference list.** The Style Manual lists legislation and legal cases under their own
   headings. A requirements document keeps one table and sorts it with the `Type` column.

### Never

- Never cite a source without a row in the reference list, or keep a row that nothing cites.
- Never write a heading as a question, or skip a heading level.
- Never let a paragraph run past 6 sentences or cover 2 topics.
- Never end a list item with `;`, `,`, `and` or `or`, and never end a list with `etc.`.
- Never merge table cells, or carry meaning by colour, bold or position alone.
- Never write link text that only makes sense in its sentence.
- Never add a fourth `Scenario` value. A capability that runs correctly and returns an unfavourable
  answer is a Sunny Day with `Outcome: Adverse` — condition and outcome are two axes, and collapsing
  them into one column is what a fourth value would do.
- Never leave a determination, measurement or eligibility requirement with only a Favourable Sunny
  Day scenario. What is true when the answer is adverse is a separate obligation.
- Never write a design disposition into `Treatment` — *migrated*, *decommissioned*, *extended* and
  *replaced* each name what becomes of an impact, which is the response's answer and not the
  demand's. The enum is three values and it is closed.
- Never read a populated `Referred` cell as a treatment, and never leave a referred impact without
  one — referral is what happens after an exclusion, not the exclusion itself.
- Never give the operational actor table an ID prefix, and never put a governance role in it.
- Never put `Delivery Agent`, `Operational Owner`, `Timing` or `Verification` in the ORD register —
  each is response-side, and stating one pre-empts the design review the document exists to inform.
- Never state a technical target where a business tolerance belongs (see `language.md`).
- Never collapse a KPP's threshold and objective into a single figure.
- Never carry an `Assumed` row whose assumption has no named owner and no confirm-by date.
- Never omit one of the nine ISO/IEC 25010 characteristics from an ORD — collapse sub-characteristics
  to the Coverage Gaps table, never the characteristic itself.
- Never embed classification, cut-off, calculation, reconciliation or retention logic in a register
  row — state the outcome and cite the `BRL-NNN` rule.
- Never carry a business rule without an owner, a status and the requirements it affects.
- Never record a dependency, a related initiative, a referred requirement and an out-of-scope item
  in one table — each has its own register and its own test.
- Never leave an unresolved business decision as an assumption inside a requirement — it is a
  decision row with an owner.
- Never write `Happy path`, `Happy Path`, `Error`, `Error Case` or `Edge` as a scenario value, and
  never head the column `Type`. The three values are `Sunny Day`, `Rainy Day` and `Edge Case`, and
  the column is `Scenario` — written exactly so, capitalised so, in every document and in every
  sentence of prose that names them. These are the words a stakeholder reads aloud; reverting one
  of them mid-document is the failure this rule exists to prevent.
- Never write a binding statement as free-text prose, in any section.
- Never give a table row a commitment without a stable ID.
- Never invent a column set where a canonical schema exists.
- Never restate a value in a second table — reference the ID and mark the table as a view.
- Never scaffold an empty table per absent subsection — use the Coverage Gaps table.
- Never use a single-letter ID prefix (collides with `/raid`).
- Never mint an ID from a prefix this table assigns to a different skill — write the `[TBD]` form and
  let the owning skill write it back.
- Never silently drop a gap to keep a document looking complete.


---

Everything below this line is **conditional**. Each part fires only where its own trigger
test does, and the tests are independent -- a change can fire both, one, or neither. Where
you have answered both and neither fired, the parts above are the whole of the standard.

---

## `ai.md`

> Applies **in addition to** `language.md` and `tables.md` whenever a
> delivered component's behaviour is learned or generated rather than specified. Neither sibling is
> relaxed here. Read the scope boundary in `README.md` first — these rules govern
> generated document content, not skill instruction prose.

### When this file applies

**Trigger test:** a delivered component whose output for a given input is not fully determined by
written logic — a trained model, an LLM call, a retrieval-augmented pipeline, an agent, or a
third-party AI service consumed as an API. One such component anywhere in scope triggers the file
for the requirements that touch it; deterministic requirements in the same document are unaffected.

**Not triggered by AI used to build the solution.** `ai-first-engineering` governs AI as the
*author* of code. This file governs AI as the *subject* of the requirement. The requirement subject
is always the delivered system, never the toolchain that produced it.

Per ADR-0003 there is **no separate AI requirements document**. Everything below lands in the
existing BRD, PRD and ORD, in the section the class map assigns.

### The Rule

**Non-determinism changes the evidence a requirement needs. It never changes the grammar it is
written in.**

The declarative end-state form, the modal ban, the "the system" ban and the vagueness ban all apply
unchanged. Probabilistic behaviour is the most plausible excuse yet available for writing `may` into
a criterion — which is exactly why it is refused here. **Variability belongs in the threshold, never
in the verb.**

### The evaluative criterion

A requirement over learned or generated behaviour is a declarative end state carrying four parts.
Missing any one of them, the statement is unfalsifiable at verification time.

| Part | Supplies | Never written as |
|---|---|---|
| **Behaviour** | the end state, stated so that variability is expected | "the output is correct" |
| **Threshold on a named set** | the scorer, the number that passes, and the `EVL-NNN` set it is measured on | "high quality", "a representative sample" |
| **Floor** | the worst *single case* tolerated on the scored scale, alongside the mean | omitted because the mean passes |
| **Review hook** | what happens to a case below threshold — who or what handles it | omitted because the mean passes |

**The floor is scalar. A categorical prohibition is a different obligation and does not live here.**
An output that is unacceptable *at any rate* — a leaked secret, a medical instruction from a
component not cleared to give one, a protected-attribute inference — is not a low score to be
averaged against. Scoring it at all implies a rate at which it passes. It is a **separate register
row** in ORD § 7.9.3 Prohibited Outputs — or § 7.3 Security where the prohibition is a disclosure
rather than a hazard, in one place and not both — stating the prohibited output, a tolerance of zero,
and its own verification method; the `EVL-NNN` row references that row's ID in `Prohibited outputs` and
restates no value. Conflating the two is how a prohibition becomes a percentage.

> ✗ `The model should rarely hallucinate`
> ✗ `Summarisation accuracy is acceptable under normal load`
> ✗ `Answer quality scores ≥ 4.0 of 5` *(no named set — unmeasurable at verification)*
> ✓ `Meeting-summary quality scores ≥ 4.0 of 5 mean on evaluation set EVL-004, with no individual case below 2.5 and an unsupported-claim rate below 3%. A case scoring below 2.5 is routed to human review before release.`

**A threshold measured on training data is not a threshold.** Every `EVL-NNN` set is held out from
whatever tuned the component.

**The ORD owns both registers; the PRD cites and never mints.** `EVL-NNN` and `MDL-NNN` are assigned
by `/write-ord` alone, exactly as `ORD-NNN` is — two skills allocating from one flat sequential
namespace with no coordination is how IDs collide, and `/write-reqs` authors the PRD *before* the
ORD, so a PRD minting its own would guarantee it. A PRD criterion needing a set it cannot yet name
writes **`[EVL-TBD — <what must be measured, and on what>]`**, and `/write-ord` resolves it to a real
ID when it builds the register — the same write-back the `Capability` and `Epic` columns already use
in `tables.md`. An unresolved `[EVL-TBD]` at the PRD gate is a visible hole, which is the
point; an invented `EVL-007` is not.

**Where no ORD is produced**, the PRD holds both registers itself and assigns the IDs — the rule
above prevents *concurrent* allocation, not allocation. Say so in the document rather than leaving a
reader to infer which skill owns the namespace.

**Where no evaluation set exists yet**, the `[TBD — source: "quoted vague statement"]` rule from
`language.md` applies unchanged. Never invent a threshold, a set size, or a scorer to
avoid writing TBD.

**The two TBD forms mark different holes; do not substitute one for the other.**

| Form | Means | Resolved by |
|---|---|---|
| `[TBD — source: "quoted vague statement"]` | the source never gave a threshold — there is nothing to measure yet | a stakeholder decision |
| `[EVL-TBD — <what must be measured, and on what>]` | the threshold is known, the **set** that proves it is not built or not yet numbered | `/write-ord`, writing the real `EVL-NNN` back |

Writing the first where the second is true hides a known measurement behind a stakeholder question
and it never gets built.

### Marking an AI-governed row

**Prefix `Business Tolerance` with `[AI]`** on every ORD register row this file governs, and
prefix the `Acceptance Criterion` cell the same way on a PRD criteria row. The trigger is
per-component, so an ORD holds governed and ungoverned rows side by side and a finished register
otherwise gives a reviewer no way to tell which is which — this ruleset becomes uncheckable at
exactly the point someone tries to check it.

- **`[AI]` stays a prefix; `KPP` is a column.** The two were once both prefixes, written
  `[KPP][AI]`. Under the demand-side register in `tables.md`, `KPP` has its own column
  because a KPP carries threshold and objective as two labelled values and a prefix cannot hold
  them. `[AI]` remains a prefix deliberately: it records which *ruleset governs the row's form*,
  which is not a property a column should imply is severity. **A row can be both** — the `KPP`
  column reads `[KPP]` and the tolerance begins `[AI]`.
- **An ORD authored before that change carries `[KPP][AI]` inline.** Read it as the same marking;
  do not rewrite the source document.
- **`[AI]` is not a priority and not a MoSCoW value.** It records which ruleset governs the row's
  form. A `[AI]` row is still `Must` / `Should` / `Could` / `Won't` like any other.
- **A row carrying `[AI]` and no `EVL-NNN` reference is incomplete** — that is precisely what the
  marker makes visible, and a reviewer is entitled to reject it on sight.

### Where AI requirement classes live

The class map. A row that does not appear here has no AI-specific home and follows the normal rules.

| Requirement class | Home | Origin |
|---|---|---|
| Risk classification decision | BRD | AI Act Art. 6 |
| Intended purpose | PRD § Scope boundary | AI Act Art. 11 / Annex IV |
| Prohibited uses | PRD § Out of Scope | AI Act Art. 11 |
| User-facing quality or accuracy outcome | PRD story criteria | 29148 |
| Functional adaptability | ORD § 7.8.3 Functional Adaptability | 25059 |
| Accuracy and fairness thresholds (operational) | ORD § 7.8.2 Functional Correctness, as `[AI]` rows | 25059, AI Act Art. 15 |
| Robustness — out-of-distribution and adversarial input | ORD § 7.2.5 Robustness | 25059, AI Act Art. 15 |
| User controllability and intervenability | ORD § 7.7.4 User Controllability and Intervenability | 25059 |
| Transparency, explainability, output labelling | ORD § 7.7.5 Transparency and Explainability | 25059, AI Act Arts. 13, 50 |
| Human oversight — who intervenes, when, with what authority | ORD § 7.7.4 and § 7.12 Operational Hours and Escalation Tolerance | AI Act Art. 14 |
| Record-keeping and inference logging | ORD § 7.6.4 Record-Keeping and Inference Logging, § 7.6.2 Analyzability | AI Act Art. 12 |
| Data governance, provenance, labelling method | ORD § 7.11 Operating Environment and Constraints | AI Act Art. 10, ISO/IEC 5259 |
| Drift detection and re-verification cadence | ORD § 7.8.3, § 7.6.2 Analyzability, § 7.13 Service Level Requirements | ISO/IEC 5338 |
| Model and provider dependency | ORD § 10.1 Dependencies, keyed to `MDL-NNN` | — |
| Prompt-injection and model-specific attack surface | ORD § 7.3.7 Prompt Injection and Model Attack Surface | AI Act Art. 15 |
| Prohibited output — unacceptable at any rate, zero tolerance | ORD § 7.9.3 Prohibited Outputs, or § 7.3 Security where it is a disclosure | AI Act Art. 15 |
| Evaluation sets and model dependencies (registers) | ORD § 10.1 Dependencies, keyed to `EVL-NNN` / `MDL-NNN` | — |

**The ORD subsections named above are defined in** `skills/write-ord/TAXONOMY.md` § *ISO/IEC
25059:2023 — AI Extension* and are scaffolded in its §7 template marked *(AI — 25059)*. They are
conditional on this file's trigger test: where it does not fire they do not apply, and are omitted
from the body *and* from the §7.10 Coverage Gaps table — an inapplicable subsection is not a gap.

**§7.8.2 Functional Correctness is the exception** — a 25010 subsection present in every ORD. Accuracy
and fairness land there as `[AI]` rows beside any deterministic correctness tolerance, so the trigger
not firing removes those rows and never the subsection.

**Where no PRD is produced**, intended purpose and prohibited uses are held in the ORD's scope
section rather than dropped. The class map assigns a *home*, not a document that must exist.

**Where the actor is load-bearing — human oversight, intervention authority, record-keeping — name
the actor and use the active voice**, per the second recorded deviation in
`language.md`. "Oversight is provided" names nobody and binds nobody.

### Canonical schemas

Both are registers. A requirement row still carries its own value in its own sentence and
references the register by ID — the § View Tables rule in `tables.md` applies, so a
threshold is never restated in two independently editable places.

#### Evaluation set register

| ID | Evaluation set | Size | Held out from | Scorer | Threshold | Floor | Prohibited outputs | Re-run trigger | Owner |
|---|---|---|---|---|---|---|---|---|---|
| EVL-NNN | [named set] | [n cases] | [what it is held out from] | [deterministic check / embedding similarity / LLM-judge with its calibration set, statistic and minimum] | [pass value] | [worst single case tolerated] | [ORD-NNN row IDs, or —] | [what forces a re-run] | [role] |

- **`Scorer` names the method, not the intent.** An LLM-judge row states what it was calibrated
  against; an uncalibrated judge is a `[TBD]`, not a scorer.
- **"Calibrated" is an unquantified adjective unless it carries a number.** This file bans
  "explainable" and "monitored" for exactly this reason and takes no exemption for its own vocabulary.
  A judge-based `Scorer` cell names three things: the **human-annotated calibration subset**, the
  **agreement statistic** used against it, and the **value achieved with the minimum required** —
  for example *"LLM-judge, calibrated on 120 human-annotated cases, Krippendorff's α = 0.81 against
  two annotators, minimum 0.80"*. Krippendorff's own convention — α ≥ 0.800 to rely on a variable,
  0.667 ≤ α < 0.800 for tentative conclusions only — is a reasonable default where the project has
  not set its own; record the choice rather than assuming the reader shares it. A judge whose
  agreement is asserted but not measured is a `[TBD]`, the same as an uncalibrated one.
- **`Re-run trigger` is mandatory** — an evaluation with no trigger is a launch gate, not a
  requirement. At minimum: any model version change, any prompt change, any change to an upstream
  data source.
- **`Prohibited outputs` holds row IDs, never values.** It points at the ORD § 7.9 / § 7.3 rows
  carrying the categorical prohibitions this set is scored alongside, per the § View Tables rule in
  `tables.md`. `—` is a real answer meaning *considered, none apply* — it is not the same
  as leaving the cell blank, and the column exists so the question is asked rather than assumed.

#### Model dependency

| ID | Component | Provider | Model / version | Pinned | Deprecation notice | Fallback behaviour | Re-evaluation trigger |
|---|---|---|---|---|---|---|---|
| MDL-NNN | [what depends on it] | [provider] | [model id and version] | Yes / No | [notice period, or "none contracted"] | [what happens when unavailable] | [EVL-NNN re-run] |

A model version named inside a requirement row without a matching `MDL-NNN` row is an
untracked dependency. `Pinned: No` with `Deprecation notice: none contracted` is a risk — raise it
via `/raid add risk` rather than leaving it in the table alone.

### Shelf life

A requirement over learned behaviour degrades with no change to the code — data drift, model
deprecation, a provider's silent update. **Acceptance at go-live is not final acceptance.**

- Every `EVL-NNN` row carries its re-run trigger, and the re-verification cadence is an ORD register
  row in its own right, not a note in the support model.
- A drift threshold is quantified like any other requirement, with its measure named
  (for example a population-stability index band), never as "drift is monitored".
- **Every drift or quality alert names its runbook.** An alert with no documented response is
  observability, not an operational requirement.

### The scenario triad for AI

The three values in `tables.md` are unchanged — `Sunny Day`, `Rainy Day`, `Edge Case`.
For a generated-behaviour requirement they read as:

| Value | The component under |
|---|---|
| **Sunny Day** | In-distribution input, component available, confidence above threshold |
| **Rainy Day** | Component unavailable or timed out, confidence below threshold, refusal, fallback path taken |
| **Edge Case** | Out-of-distribution or adversarial input, prompt injection, unrepresented cohort, empty or maximum-length context |

A story whose criteria are all Sunny Day has been specified for the demo. For a generated-behaviour
component that warning is sharper than usual: the Sunny Day path is the one the vendor already
demonstrated.

### Standards of record

| Standard | Status here |
|---|---|
| ISO/IEC 25010:2023 | The ORD §7 taxonomy this file extends. Australian adoption: **AS/NZS ISO/IEC 25010:2025**. |
| ISO/IEC 25059:2023 | Extends the ORD's ISO/IEC 25010:2023 taxonomy — adds functional adaptability, robustness, user controllability, transparency, intervenability. Does not replace it. Second edition under member-body vote. Australian adoption: **AS ISO/IEC 25059:2024**. |
| ISO/IEC/IEEE 29148:2018 | Unchanged for the PRD. The good-requirement characteristics hold; only the evidence satisfying *verifiable* changes. |
| ISO/IEC 22989:2022 | Vocabulary. Adopt its terms rather than coining local ones — record them in the project glossary. |
| ISO/IEC 23894 | AI risk management. Feeds ORD § 8.2 and `/raid`. |
| ISO/IEC 5338 | AI system life-cycle processes. Feeds ORD § 7.12 and § 7.13. |
| EU AI Act — Regulation (EU) 2024/1689, as amended by (EU) 2026/1744 | Supplies requirement classes (Arts. 9–15, Annex IV), not document structure. Application dates are in the stamp below, verified 2026-08-24. |
| ISO/IEC 42001:2023 | Organisational management system, above the document layer. Out of scope for this file. |
| ISO/IEC 5259 series | Data quality for ML. A data-as-subject schema is deferred per ADR-0003. |

#### Regulatory dates — verification stamp

**Dates move; a rules file does not notice.** These are recorded once, here, with their provenance,
so no requirement document restates them and no author cites them believing they were checked today.

The research behind this file is **deliberately not published with these rules.** The workspace
`docs/` holds company-internal material and is not published with the framework, as the
`requirements-documents` pack is not. Its findings are restated here and in ADR-0003, which are
tracked; the source is not, by choice.

| Obligation | Date as recorded | Status |
|---|---|---|
| AI Act Art. 5 prohibitions, GPAI obligations, Art. 50 transparency duties | in force | cited |
| Annex III high-risk obligations | 2 December 2027 | cited — deferred from the original date by the amending regulation below |
| Annex I high-risk obligations | 2 August 2028 | cited — deferred as above |

- **Last verified:** 2026-08-24, by **Glen Sanders**, against the European Commission's own
  announcement of the amending regulation entering into force —
  <https://digital-strategy.ec.europa.eu/en/news/ai-omnibus-enters-force> — which states the
  2 December 2027 and 2 August 2028 dates directly.
- **Amending instrument:** Regulation (EU) 2026/1744 (Digital Omnibus on AI), adopted 8 July 2026,
  published OJ 24 July 2026, in force 27 July 2026. CELEX `32026R1744`, ELI
  <https://eur-lex.europa.eu/eli/reg/2026/1744/oj/eng>. It amends Regulation (EU) 2024/1689 (the AI
  Act), ELI <https://eur-lex.europa.eu/eli/reg/2024/1689/oj/eng>.
- **What was not done:** the consolidated **Article 113** text was not read. EUR-Lex returned its
  Official Journal navigation page rather than the document on three URL forms, so the dates above
  rest on the Commission's announcement plus consistent independent legal analyses, not on the
  article itself. That is a strong chain and it is not the primary text. **Read Article 113 before
  certifying conformity**, and record it here.
- **Owner:** **Glen Sanders**, as maintainer of this ruleset. Re-verify on any amending regulation,
  and at minimum annually.
- **Deferral changes the deadline, not the content.** A register already carrying data governance,
  logging, human oversight and accuracy rows needs no retrofit in 2027; one that does not, does. The
  dates govern *when* evidence is demanded, never whether the classes above apply.

#### Australian adoptions and instruments

Recorded because this pack is authored in an Australian context. **Cite the AS designation where one
exists** — it is the same text, and it is the one an Australian auditor asks for.

| Instrument | Status here |
|---|---|
| **AS/NZS ISO/IEC 25010:2025** | Identical adoption of ISO/IEC 25010:2023 — the taxonomy the ORD's §7 is keyed to. Cite this designation in an Australian document. |
| **AS ISO/IEC 25059:2024** | Australian adoption of ISO/IEC 25059:2023 — the AI extension this file applies. Cite alongside the ISO designation. |
| **AS ISO/IEC 42001:2023** | Identical adoption, February 2024. Organisational management system, above the document layer — out of scope for this file, as its ISO parent is. |
| ISO/IEC/IEEE 29148:2018 | **No Australian adoption identified.** Cite the ISO/IEC/IEEE designation. |
| **Voluntary AI Safety Standard (VAISS)** — DISR, 10 guardrails | **Voluntary. Binds nothing.** Useful as a checklist against the class map; never cite a guardrail as the authority for a requirement. |
| **Guidance for AI Adoption (GfAA)** — October 2025, six practices | Voluntary; supersedes VAISS in practice. Same treatment. |
| Proposed mandatory guardrails for high-risk AI, September 2024 | **Shelved.** Do not author against them. |
| **Policy for the responsible use of AI in government v2.0** — DTA, effective 15 December 2025 | **Mandatory for non-corporate Commonwealth entities only** — departments and agencies. Binds no corporate Commonwealth entity, government business enterprise or private organisation, and is not law. An in-scope use case is screened at design, impact-assessed with the Australian Government AI impact assessment tool before deployment, registered with an accountable use case owner, and re-validated on material change. Its Appendix C scope criteria are applied as a screen, for anyone, in `/idea-ai` Stage 11. |
| **National AI Plan**, 2 December 2025 | Policy direction, not law: existing legislation and sector regulators, supported by voluntary guidance and the Australian AI Safety Institute. **There is no Australian AI Act.** |

**Watch item — an Australian AI standard to be legislated.** An Office of AI was established in the
Department of the Prime Minister and Cabinet, and on 15 July 2026 the Prime Minister announced an
intent to legislate an Australian AI standard — for consideration by National Cabinet in August 2026,
with legislation expected early 2027. Published scope centres on **large AI data centres** — energy,
water, and copyright protections for Australian creators — not on requirement classes for an AI
system generally. **None of it is law yet**, and nothing in this file's class map derives from it.
Re-check before the next document cycle; the owner named above owns this too.

**The practical consequence for an Australian project.** The binding classes in the map above come
from the **EU AI Act**, and apply only where a system falls within its scope. A purely domestic
Australian system currently has **no mandatory AI-specific requirement classes**: it is governed by
existing law — privacy, consumer, anti-discrimination, sector regulation — plus whatever the
organisation adopts voluntarily. The one mandatory AI instrument, the DTA policy above, binds only
non-corporate Commonwealth entities, and it adds governance actions, not requirement classes. Name which regime applies in the document rather than importing the
AI Act by default. The evaluative criterion, the evaluation-set discipline and the shelf-life rule in
this file are **engineering practice, not regulation**, and apply either way.

### Never

- Never create a separate AI requirements document — the classes above have homes (ADR-0003).
- Never let non-determinism justify a modal. `may`, `might`, `should`, `could` and `would` stay
  banned, and the excuse for reaching for them is stronger here than anywhere else.
- Never state a threshold without naming the evaluation set it is measured on.
- Never measure a threshold on data the component was tuned against.
- Never write a mean with no floor — an average that passes hides the case that harms someone.
- Never score a categorical prohibition — an output unacceptable at any rate is a zero-tolerance
  register row of its own, never a floor on a scale that implies a passing rate.
- Never mint an `EVL-NNN` or `MDL-NNN` outside the ORD where an ORD exists — write `[EVL-TBD — …]`
  and let `/write-ord` write it back.
- Never call a judge "calibrated" without naming the calibration set, the agreement statistic and
  the minimum required.
- Never leave an AI-governed row unmarked — `[AI]` is what makes this ruleset checkable by someone
  who was not in the room.
- Never move `[AI]` into the `KPP` column, and never collapse the two markings into one — they
  record different things: severity, and which ruleset governs the row's form.
- Never cite an AI Act application date for a conformity certification without reading the
  consolidated Article 113 — the stamp above records exactly what was and was not checked.
- Never cite a VAISS or GfAA guardrail as the authority for a requirement. Both are voluntary; a
  requirement naming one as its source names no obligation.
- Never cite the DTA *Policy for the responsible use of AI in government* as an obligation on an
  organisation that is not a non-corporate Commonwealth entity — elsewhere it is practice, not duty.
- Never import the EU AI Act's classes into a purely domestic Australian system by default — name
  the regime that applies and why.
- Never cite an ISO designation alone where an AS adoption exists — an Australian auditor asks for
  the AS number.
- Never record an evaluation set with no re-run trigger.
- Never name a model version in a requirement without a matching `MDL-NNN` row.
- Never treat go-live acceptance as final for a component whose behaviour is learned or generated.
- Never write "drift is monitored", "the model is explainable", or "human oversight is in place" —
  each is an unquantified adjective in disguise. Give the measure and the actor, or write `[TBD]`.
- Never apply this file to AI-assisted *authoring* of the solution — that is `ai-first-engineering`.


---

## `reporting.md`

> Applies **in addition to** `language.md` and `tables.md` whenever a change
> introduces, alters or retires a **measure that is reported** — to a regulator, a counterparty, an
> auditor, or internally where a decision or an obligation turns on the figure. Neither sibling is
> relaxed here. Read the scope boundary in `README.md` first — these rules govern
> generated document content, not skill instruction prose.

### When this file applies

**Trigger test:** does the change create, change or remove a **number somebody reports**? One such
measure anywhere in scope triggers the file for the requirements that touch it; requirements that
carry no reported measure are unaffected.

It does **not** fire for a system that merely stores or displays data. The trigger is the reported
measure and the obligation behind it — the thing that must still be defensible when someone asks how
the figure was produced eighteen months later.

Per the same reasoning as ADR-0003 there is **no separate reporting requirements document**.
Requirements land in the existing register, in the section the class map assigns; the detail that
makes them reproducible lands in the ORD's **§14 Reporting Requirements Appendix** — see
§ *Altitude — outcome in the register, detail in the appendix*.

### The Rule

**A reported measure is not specified until its population, its clock, its rules, its lineage and
its correction path are stated. The figure alone is a display; the five together are a measure.**

The failure this file exists to prevent is a requirement that names an output — *"a monthly
compliance report is produced"* — and leaves unstated which records it counts, which it excludes,
when its clock starts and stops, which version of the rules produced it, and what happens when it is
later found wrong. Every one of those is discovered during an audit rather than during design.

### The measure definition

A requirement over a reported measure is a declarative end state carrying five parts. Missing any
one, the figure is unreproducible.

| Part | Supplies | Never written as |
|---|---|---|
| **Population** | which records are in, which are out, and on what evidence | "all relevant records" |
| **Clock** | the measurement period, and for an elapsed measure the start event, the stop event and any duration excluded from it | "monthly", with no period boundary and no stop event |
| **Rule set and version** | the `BRL-NNN` rules that classify and calculate, and which version was in force | "as per the business rules" |
| **Lineage** | the source of each input and the identifier that survives to the output | "sourced from the data warehouse" |
| **Correction path** | what happens when a published figure is later found wrong | omitted, because it has not happened yet |

**The clock is the part most often assumed and least often written.** For a period measure it states
the period boundary, the cut-off, and how a record arriving after the cut-off is treated. For an
elapsed measure it states what starts the clock, what stops it, and every interval excluded — a
pause, a hold, a suspension, a wait on a third party — because an elapsed figure with an unstated
exclusion cannot be reproduced by anyone who did not compute it. A period expressed in business days
carries its calendar basis: the timezone, and the holiday jurisdiction — state, territory, national
or contractual — that determines which days count.

> ✗ `A monthly compliance report is produced`
> ✗ `The monthly compliance figure counts every service order closed in the calendar month in the reporting entity's local time, excluding orders cancelled by the customer, classified under the BRL-004 rule set version in force at closure, counted to a cut-off five business days after month end …` — complete, but written at the wrong altitude: no executive can read it, and the register row has become the rule set
> ✓ Register row: `The monthly compliance figure is published within five business days of month end and is reproducible from its source records, beyond which obligation X §4 is breached` · §14.2 measure definition for that `ORD#`: population, clock, cut-off, lineage and correction path · §13 rules `BRL-004` (classification) and `BRL-009` (late-arriving closures and restatement)

### Altitude — outcome in the register, detail in the appendix

**The five parts are mandatory; where they are written is not the register.** A register row states
the business outcome a reporting consumer needs — published, on time, reproducible, auditable — and
the consequence of breach. The five-part measure definition is written once in the ORD's **§14.2**,
keyed by the `ORD#` it details, and the classification, cut-off, restatement and reconciliation
logic is written once as `BRL-NNN` rows in **§13**.

**The test for a register row:** *could an executive understand it without understanding reporting,
governance, architecture or implementation?* If not, the row states the outcome and cites the
§14.2 definition or the `BRL-NNN` that carries the detail. A measure missing any of its five parts
across row, definition and rules is still unspecified — moving detail to the appendix is never a
licence to drop it.

### Reporting consumers

**Reporting consumers are stakeholders even where no process changes for them.** A change to a
population, a clock or a rule changes every figure built on it, and the consumer of that figure
finds out when it moves. Identify each consumer class the source evidences:

| Class | Typically |
|---|---|
| Regulatory | A regulator, or an obligation reported to one |
| Contractual | A counterparty reported to under an agreement |
| Operational | Teams running the process from the figure |
| Management | Line management deciding from the figure |
| Executive | Executive and board reporting |
| Audit | Internal and external audit |

Each consumer is a row in §14.1 (schema below). Where a consumer's need is a commitment, it is also
a register row in the section the class map assigns, and the §14.1 row cites it. **A consumer class
with no evidence in the source is a question for the gate, never an inferred row.**

### New reporting data

**Never assume a reporting platform already holds what a new or changed measure needs.** Where a
measure needs an attribute, a dimension or a data element, its `DAT-NNN` row carries `Availability`:
`Existing — confirmed` only where the source confirms it, otherwise `New` or `Unconfirmed`. Where
any element is `New` or `Unconfirmed`, raise a candidate register row at the Phase 1 gate stating
that the data the reporting consumers need is captured and available for the measure — it becomes
a row only on the business owner's confirmation, under the usual status rules.

**Do not nominate a system or dataset as authoritative unless the source material confirms that
status.** Which system is the book of record is a governance fact, not a drafting choice.

### Data quality — the anchor

**ISO/IEC 25012** (data quality model) is the taxonomy for data requirements, and it sits in the same
SQuaRE series as the ISO/IEC 25010:2023 characteristics the ORD's §7 is already keyed to.
**ISO/IEC 25024** supplies the measurement side. Use their characteristic names rather than coining
local ones, exactly as `ai.md` defers to ISO/IEC 22989:2022 for AI vocabulary.

A data requirement states a quality characteristic **of a named data element**, quantified, with the
consequence of breach — not a general aspiration that data is good.

### Where reporting and data requirement classes live

The class map. A row that does not appear here has no reporting-specific home and follows the normal
rules.

| Requirement class | Home |
|---|---|
| The reported measure itself — population, threshold, obligation behind it | ORD § 7.8.1 Functional Completeness |
| The measurement clock — period boundary, start event, stop event, excluded duration | ORD § 7.8.1 |
| Cut-off, and treatment of data arriving after it | ORD § 7.8.1 |
| Granularity and the dimensions the measure is disaggregated by | ORD § 7.8.1 |
| Accuracy, completeness, currentness of a named data element | ORD § 7.8.1, keyed to a `DAT-NNN` row |
| Reproduction of a historical figure under the rules in force at the time | ORD § 7.6.2 Analyzability |
| Lineage — source of each input, identifier surviving to the output | ORD § 7.6.2 Analyzability |
| Reconciliation — source, included, excluded, exception populations | ORD § 7.8.1 |
| Duplicate and omission control | ORD § 7.3.2 Integrity |
| Restatement and correction of a published figure | ORD § 7.6.1 Modifiability |
| Who may read the report, and at what granularity | ORD § 7.3.1 Confidentiality |
| Report availability and timeliness against the obligation | ORD § 7.1.1 Time Behavior |
| Retention of the figure and its supporting records | ORD § 7.3.3 Non-repudiation and Accountability |
| Definition and rule ownership, effective dating | ORD § 7.6.1, with the rules themselves as `BRL-NNN` |
| Exception visibility — what could not be determined, and why | ORD § 7.8.1 |

**Nothing here adds a §7 subsection.** Reporting requirements are ordinary operational requirements
whose *content* this file governs; they land in the 25010 subsections that already exist. A parallel
reporting section in the body would restate the register. **The §14 appendix is not that section** —
it holds consumers, measure definitions, data elements, and transparency, audit and acceptance
evidence, and every binding statement in it cites an `ORD#`. Proposed acceptance criteria stay in
§11.

### Canonical schema

#### Data element register

Lands at ORD §14.3.

| ID | Data element | Kind | Used by | Quality characteristic | Tolerance | Availability | Source | Lineage | Owner |
|---|---|---|---|---|---|---|---|---|---|
| DAT-NNN | [named element] | Attribute / Dimension / Measure input | [ORD-NNN, …] | [ISO/IEC 25012 characteristic] | [declarative, quantified] | Existing — confirmed / New / Unconfirmed | [system or process of origin, where confirmed] | [how it reaches the output] | [named, or TBD with confirm-by] |

- **`Availability` defaults to `Unconfirmed`, never to `Existing`.** See § *New reporting data*.

- **`Quality characteristic` uses ISO/IEC 25012's names.** There are fifteen and this is all of
  them — **accuracy, completeness, consistency, credibility, currentness, accessibility,
  compliance, confidentiality, efficiency, precision, traceability, understandability,
  availability, portability, recoverability**. A characteristic outside this list is a coined term;
  see the *Never* list. The standard splits them into inherent, system-dependent, and both — that
  split is **not** reproduced here, because the sources consulted disagree on where
  understandability sits and the standard text was not read. The split does not affect which name a
  `DAT-NNN` row carries; see the stamp below before citing conformance.
- **`Tolerance` is a business tolerance**, not a technical one: *"a closure timestamp is accurate to
  the calendar day, beyond which the monthly boundary is wrong"* — never *"timestamp precision
  ≤ 1s"*. `language.md` § *Demand, not design* applies unchanged.
- **`Source` is `[TBD]` until confirmed.** Nominating a system as the book of record on drafting
  authority is the most common way this register becomes wrong.

#### Reporting consumer register

Lands at ORD §14.1. **No ID — the consumer name is the key**, on the same reasoning as the
operational actor register in `tables.md`: a consumer row identifies a subject and
commits nothing.

| Consumer | Class | Need | Measures used | Impact of this change | Owner |
|---|---|---|---|---|---|
| [named body, team or role] | Regulatory / Contractual / Operational / Management / Executive / Audit | [what they use the figure for] | [ORD-NNN, …] | [what moves for them, or "none — confirmed"] | [named, or TBD with confirm-by] |

#### Measure definition

Lands at ORD §14.2, one row per reported measure, keyed by the register row it details. **A
definition, not a commitment** — the binding statement is the `ORD#` row, so this carries no
priority, status or owner of its own.

| ORD# | Measure | Population | Clock | Rule set | Lineage | Correction path | Dimensions |
|---|---|---|---|---|---|---|---|

### Reconciliation

Where a measure is reported against an obligation, the document establishes — as `BRL-NNN` rules in
§13 (governance and classification groups), cited by the register row that states the outcome:
the **source population**; the **included**, **excluded** and **exception** populations; **duplicate
and omission control**; **record-level** and **aggregate** reconciliation; **variance treatment**;
and **restatement treatment**.

**A report is not represented as reconciled while unresolved variances remain**, unless an approved
tolerance explicitly permits it — and that tolerance is itself a register row with a named approver,
never an assumption.

### Competing methodologies

Where current operational practice differs from contractual, regulatory or documented reporting
practice, **both methodologies are preserved**. The document does not choose.

- Record each method and the decision criteria that distinguish them.
- Raise a decision item via `/raid add decision` and cite the `D-NNN` — this document never mints a
  decision ID.
- Identify the requirements and reported outcomes each method affects.
- Where interim direction has been given, record the approved interim method **and** the fact that
  it is interim.
- State the migration and historical-comparability consequence of each option.
- Where the difference is material to a reported figure, carry a comparison scenario under
  `tables.md` § *Scenario*.

**A methodology conflict is never recorded as an assumption.** An assumption is a thing believed
true pending confirmation; a live disagreement between two documented practices is a decision
somebody owns, and filing it as an assumption removes the owner.

### Standards of record

| Standard | Status here |
|---|---|
| **ISO/IEC 25012:2008** | Data quality model — fifteen characteristics. The taxonomy for `DAT-NNN` rows. Same SQuaRE series as ISO/IEC 25010:2023. Australian adoption: **AS/NZS ISO/IEC 25012:2013**, identical, reconfirmed 2024. |
| **ISO/IEC 25024:2015** | Data quality measurement. The measurement side of 25012. Australian adoption: **AS ISO/IEC 25024:2019** — **AS**, not AS/NZS. The series is not uniform; check each designation rather than pattern-matching off its sibling. |
| **ISO/IEC 20000-1:2018** | IT service management, third edition. **Clause 9.4 Service reporting** is the source of the service-reporting obligations behind report timeliness and availability rows — but the 2018 edition deliberately moved the detailed reporting requirements out of that clause and into the clauses where the reports are produced, so 9.4 is the hook and not the whole obligation. Amended by **ISO/IEC 20000-1:2018/Amd 1:2024**. Australian adoption: **AS/NZS ISO/IEC 20000.1:2019** — note the **dot** in the part number — reissued November 2024 incorporating Amendment No. 1. |
| **ISO/IEC/IEEE 29148:2018** | Unchanged. Only the evidence satisfying *verifiable* is elaborated here. |
| **OMG DMN 1.5** | Decision model and notation. §5.3.1 and clause 7 supply the decision / decision-logic separation the `BRL-NNN` register uses. 1.5 (August 2024) is the current formal version; 1.6 and 1.7 are beta and are not cited. |
| **OMG SBVR** | Semantics of business vocabulary and business rules. The vocabulary source where a rule needs one. |
| ISAE 3402 / ASAE 3402 | Assurance over service-organisation controls. **Not a requirements standard.** The reconciliation discipline above is drawn from control practice and is cited as practice, never as an obligation this file imposes. |
| DAMA-DMBOK, BABOK v3 | Practitioner bodies of knowledge. Useful as checklists; neither is cited as the authority for a requirement. |

#### Verification stamp

**Verified 2026-09-07 by Glen Sanders.** The four claims below were previously recorded as adopted
from knowledge and unchecked. Two are now confirmed against the publisher's own text; two rest on
national-body and distributor records because the ISO texts are paywalled and were not purchased.
Following `ai.md`'s convention, **what was not read is recorded as plainly as what was** —
this stamp narrows the gap and does not close it.

| Claim | Status | Checked against |
|---|---|---|
| ISO/IEC 25012 defines the data quality characteristic names used by `DAT-NNN` | **Verified — secondary sources only.** Fifteen characteristics; all names used in this file are among them | ISO catalogue abstract; a peer-reviewed application of 25012; the OMG DIDO wiki entry; iso25000.com |
| An AS/NZS adoption of ISO/IEC 25012 exists | **Verified — it does.** `ai.md`'s rule bites: **AS/NZS ISO/IEC 25012:2013**, identical adoption, current and reconfirmed 2024 | Standards Australia distributor record; corroborated by the scope statement of AS ISO/IEC 25024:2019, which names AS/NZS ISO/IEC 25012 as the source of the characteristics it measures |
| ISO/IEC 20000-1:2018 carries the service-reporting clauses attributed to it | **Verified — primary text.** Clause **9.4 Service reporting**, under clause 9 Performance evaluation. The foreword's change item (j) records that detailed reporting requirements were moved out of the service reporting clause into the clauses where the reports are produced | ISO's own redline preview of ISO/IEC 20000-1:2018 — table of contents and foreword |
| DMN's decision / decision-logic separation matches the `BRL-NNN` `Required Decision` and `Rule` columns | **Verified — primary text.** DMN §5.3.1 defines a decision as *the act of determining an output value from a number of input values, using logic defining how the output is determined*; clause 7 defines how the decision requirements level and the decision logic level relate. `Required Decision` states the first; `Rule` states the second in business terms, and implementation of the logic stays with the design response | OMG DMN 1.5 specification, §5.3.1 and clause 7 |

**What was not read.** ISO/IEC 25012:2008, ISO/IEC 25024:2015 and the body of ISO/IEC 20000-1:2018
are paywalled and were not purchased. Three consequences, none of them cosmetic:

1. **25012's normative definitions were not read** — only the characteristic *names* are
   corroborated. A `DAT-NNN` row naming a characteristic is safe from coining; a row asserting what
   that characteristic *means* is not yet grounded.
2. **The inherent / system-dependent / both split is unresolved.** Sources consulted disagree on
   whether *understandability* falls in the system-dependent group or the both group. The split is
   not reproduced in the `DAT-NNN` schema, so nothing in this file depends on it — but a document
   that reproduces the split is asserting something this stamp does not cover.
3. **Only 20000-1's front matter was read**, not clause 9.4's requirements. That the clause exists
   and is named *Service reporting* is confirmed; what it demands, in terms, is not.

**Still true, unchanged:** read the 25012 characteristic list before a document claims conformance
to 25012 or 25024.

**Two findings that were not claims and are recorded because they change what a document cites:**

- **ISO/IEC 20000-1:2018 has been amended** — `/Amd 1:2024`. A document citing the 2018 edition bare
  is citing a superseded state of the text.
- **The Australian designations are not uniform.** `AS/NZS ISO/IEC 25012:2013` and
  `AS/NZS ISO/IEC 20000.1:2019` are joint; `AS ISO/IEC 25024:2019` is Australian only. The
  20000 series uses a **dot** before the part number where the ISO original uses a hyphen. Each
  designation is checked, never inferred from its sibling.

- **Owner:** **Glen Sanders**, as maintainer of this ruleset.
- **Re-verify:** on any amendment or new edition of 25012, 25024, 20000-1 or DMN; before any
  document authored under this file claims conformance to 25012, 25024 or 20000-1; and at minimum
  annually. **Next due 2027-09-07.**

### Never

- Never state a reported measure without its population — "all relevant records" specifies nothing.
- Never state a measure without naming the rule set version that produced it.
- Never state an elapsed measure without its start event, its stop event and its excluded durations —
  an unstated exclusion makes the figure unreproducible by anyone who did not compute it.
- Never state a period measure without its cut-off and the treatment of data arriving after it.
- Never express a period in business days without its timezone and its holiday jurisdiction.
- Never nominate a system or dataset as authoritative unless the source material confirms it.
- Never represent a report as reconciled while unresolved variances remain, absent an approved
  tolerance carried as its own row with a named approver.
- Never omit the correction path because the figure has not yet been wrong.
- Never record a methodology conflict as an assumption — it is a decision, and it has an owner.
- Never choose between competing methodologies without decision authority.
- Never mint a `D-NNN` here — `/raid` owns the decision namespace.
- Never coin a data quality term where ISO/IEC 25012 supplies one — there are fifteen names and
  the register bullet lists all fifteen.
- Never cite an ISO designation alone where an AS or AS/NZS adoption exists — an Australian auditor
  asks for the AS number, and the designations in this series are not uniform.
- Never cite ISO/IEC 20000-1:2018 without its Amendment 1:2024.
- Never state a technical data tolerance where a business one belongs (see `language.md`).
- Never add a §7 subsection for reporting — these are ordinary requirements in existing subsections.
- Never write the five-part measure definition into a register row — the row states the outcome and
  the §14.2 definition carries the five parts.
- Never mark a data element `Existing — confirmed` without source confirmation.
- Never infer a reporting consumer the source does not evidence — raise the class at the gate.
- Never cite ISAE/ASAE 3402, DAMA-DMBOK or BABOK as the authority for a requirement.


---

## `llm-companion.md`

> Governs the **machine-readable companion** a requirements skill writes beside the document it
> authors. Applies to `/write-brd` and `/write-ord`. Pairs with `language.md` and
> `tables.md`, neither of which is relaxed here. Read the scope boundary in
> `README.md` first.

### What it is

The document a skill writes — `docs/brd/[change-name]-BRD.md`, `docs/ord/[system-name]-ORD.md` — is
written for a human reviewer. The companion is the **same content restructured for a language model**
to consume: pasted into a prompt, attached to an agent, or chunked into a retrieval index.

It is written to the same folder, with `.llm` before the extension:

| Document | Companion |
|---|---|
| `docs/brd/[change-name]-BRD.md` | `docs/brd/[change-name]-BRD.llm.md` |
| `docs/ord/[system-name]-ORD.md` | `docs/ord/[system-name]-ORD.llm.md` |

**The document is reviewed; the companion is not.** Review, sign-off and every gate read the
document. The companion is regenerated from it and carries no standing of its own.

### The Rule

**The companion is a view of the saved document. It adds no value, drops no row, and rewords
nothing.**

Everything a reviewer approved must reach the model unaltered, and nothing the reviewer did not see
may reach it at all. A companion that summarises is a second author; one that fills a gap is an
invented figure delivered to the reader least able to spot it.

Three things follow:

1. **Generate from the saved document alone** — never from the source material, the Phase 1 summary
   or the conversation. Anything true of the change but absent from the document is absent from the
   companion.
2. **Copy values verbatim.** Restructuring is permitted; rewording, summarising, merging and
   correcting are not. A defect in a value is fixed in the document and the companion regenerated.
3. **Every row survives.** Each table row in the document appears in the companion exactly once, and
   the count is reported.

The only text the companion carries that the document does not is the fixed **How to read** block
and the **Vocabulary** definitions below — both addressed to the consuming model, both defined here,
and neither carrying a requirement.

### Generating it

**The companion is generated by script, not written by hand.** `/write-ord` ships
`scripts/llm_companion.py`, which implements this file; `/write-brd` runs the same script from
`../write-ord/scripts/`. Standard-library Python 3.8 or later:

```bash
python3 scripts/llm_companion.py docs/ord/[system-name]-ORD.md --generator "/write-ord [version]"
```

A model asked to copy a thousand lines verbatim will reword some of them, and neither the model nor
its reader can see which. The script copies by construction and then proves it — the integrity check
below — so a companion that exists is a companion that passed.

**Exit 1 means refused, and nothing is written.** The reason names the first value that failed to
arrive or the row count that did not reconcile. Fix the document, or report the refusal; never
replace a refused companion with a hand-written one.

**Where no Python is available**, write the companion by hand to this file, run the integrity check
by hand, and say in the closing summary that the check was manual. A hand-written companion is the
fallback, never the default.

### Why a separate file

A requirements document is optimised for a reviewer: wide tables, cross-references by section
number, traceability in an appendix, and gaps recorded where they arise. Each of these costs a model
accuracy:

| Reviewer form | What a model loses | Companion form |
|---|---|---|
| A nine-column table | Which header a cell belongs to, once the row is far from the header | One record per row, each value labelled with its column |
| Traceability held once, in an appendix | The link, when the record and the appendix land in different chunks | The trace folded into the record it describes |
| `[TBD]` scattered through the body | That a gap exists — the model fills it from its own knowledge | Every gap indexed up front, and an instruction not to fill it |
| House vocabulary — `Assumed`, `[AI]`, KPP, `Sunny Day` | Its meaning; the model guesses | The terms this document uses, defined once |
| Section numbers as the only address | A stable citation | Every record keyed by its ID |

### Structure

Five sections, in this order, after YAML front matter.

#### Front matter

```yaml
---
doc_id: ORD-NNN or BRD-YYYY-NNN
doc_type: ORD | BRD
title: [document title, verbatim]
version: [document version]
status: [document status, verbatim]
tier: [ORD only — the document tier from the header]
companion_of: [file name of the document, relative to this file]
source_sha256: [SHA-256 of the saved document, or "unavailable"]
generated: YYYY-MM-DD
generator: [/write-brd or /write-ord, with the skill version]
authoritative: false
---
```

`source_sha256` is computed from the saved file — the script does it; by hand, `shasum -a 256` or
`sha256sum`. Where neither is available, write `unavailable`; never estimate or invent one. It is
how a later reader detects a companion gone stale against an edited document.

A field the document does not state — an ORD carries no Doc ID — reads `"[not stated in document]"`.

#### 1. How to read this document

Copy this block verbatim, substituting only `[BRD|ORD]`, the document file name and the doc ID —
or the document's title, where it carries no Doc ID.

```markdown
## 1. How to read this document

This file is a machine-readable view of [BRD|ORD] [doc_id], generated from `[file name]`. It is
not authoritative. Where this file and that document differ, the document is correct and this file
is stale; `source_sha256` in the front matter identifies the exact document version it was
generated from.

- Every record is keyed by a stable ID. Cite IDs, never section numbers or paraphrase.
- Values are copied verbatim from the document. Treat each value as a statement of fact about the
  delivered end state, exactly as worded.
- `[TBD]`, `Unowned — open` and every item listed in section 3 are unanswered questions. Do not
  fill, estimate, infer or default them. Where a task depends on one, name the item and stop.
- A value marked `Assumed` or `Provisional` is not yet agreed. Do not present it as committed.
- This document states business demand. It does not state, and must not be read as implying, a
  technical design, architecture, product, vendor or engineering target.
- Section 4 is narrative context. Section 5 holds the binding statements.
```

The block is instruction prose addressed to a model, not requirement content — the modal and
construction bans in `language.md` govern the records, not this block.

#### 2. Vocabulary

**Only the terms this document uses.** For each ID prefix, `Status` value, scenario value, marker
(`[AI]`, `[KPP]`, `[TBD]`, `[EVL-TBD]`, `[D-TBD]`) and enum that occurs in the records, one line
giving its meaning, taken from `tables.md`, `ai.md` or `reporting.md`.
A term that does not occur is not listed.

#### 3. Open items

One line per unanswered item, in document order, each naming the record or section it sits in:

- every `[TBD]`, `[EVL-TBD]`, `[D-TBD]` and `[SYSTEM-NAME-TBD]`, with its owner and date where the
  document gives them
- every `Unowned — open` row
- every `Assumed` or `Provisional` requirement, and every `Unvalidated` or `Falsified` assumption
- every coverage gap and every referred requirement with `Resolver group: None in chain`
- every open question, every dependency not `Met`, and every conformance still `pending`
- every prose sentence declaring a gap, carrying a `[TBD]` or leaving a placeholder such as
  `[name]` — **quoted whole**, never paraphrased

A BRD with no Doc ID lists that too; an ORD does not, because the ORD standard defines none.

Where there are none, write `None.` — never omit the section. An empty index and a missing one are
different claims.

#### 4. Context

Every prose section of the document, **copied verbatim** under its original number and heading, in
document order. Prose is not condensed: a summary is a reworded source.

#### 5. Records

One block per table row, grouped under a `### Table:` heading per table in document order. From the
pack's worked ORD:

```markdown
#### ORD-03 — Apply an owed rebate within two billing cycles

- table: 3.2 Reliability
- ref: ORD-03
- ver: 1.0
- requirement_title: Apply an owed rebate within two billing cycles
- business_tolerance: A rebate owed under clause 14.3 is applied within two billing cycles of the missed appointment. Threshold: two cycles. Objective: one cycle
- kpp: [KPP]
- status: Provisional
- owner: GM Billing
- source: Consumer contract cl. 14.3
- referenced_by: OBJ-01, SCN-01, SCN-02, SCN-03, SCN-04
- traceability:
  - ord_ref: ORD-03 [KPP]
  - business_tolerance: Rebate applied within two billing cycles
  - traces_to_brd_objective_via_business_requirement: §4 BO-1, via §8 BR-1
  - orphan: No
```

- **The key is the row's ID.** An ID-less row — an actor, a constraint, a coverage gap, an
  exclusion — is keyed by its table's first column, prefixed with the section number.
- **Field names are the document's column names** in lower snake case. Every column is written,
  including one the document leaves blank: `(blank in document)`. A missing field reads as a
  column that does not exist.
- **A table keyed by another record's ID is folded into that record**, never emitted as a second
  record under the same ID — traceability (ORD §11), interface detail and SOAP conformance
  each become a sub-list named for their table, every column included. A record with no row in a
  folded table says so: `traceability: (no row in document)`. A fold adds structure, never a value.
- **Every ID-keyed record carries `referenced_by`** — the IDs of other records whose cells name it:
  the objective it serves, the scenarios that examine it, the assumption it rests on. A link read
  from the document, never a value.
- **View tables are not emitted.** A table whose lead-in declares it a view — *"View of …"*,
  *"adds no new commitments"* — restates IDs it does not own. Name each omitted view in one line at
  the head of section 5.
- **Plain text only.** No HTML, no emoji, no decorative glyphs, no merged or multi-line cells. A
  glyph the document uses to mark meaning becomes words: ★ on a BRD section becomes
  `[often-missing section]`, which is what the BRD standard marks it for.

### Integrity check

Two checks, both before the companion is saved:

1. **Rows reconcile.** Table rows in the document equal records, plus rows folded into another
   record, plus rows of omitted views.
2. **Everything arrived.** Every prose line, and every data cell outside an omitted view, appears in
   the companion.

Either failing, the companion is not saved. Report the script's line in the skill's closing summary:

> `Companion: docs/ord/[name]-ORD.llm.md — 84 rows, 74 records, 7 folded, 1 view(s) omitted (3 rows), 25 open items.`

### Regeneration

**The companion is regenerated every time the document changes** — never edited by hand. Both
skills accept `--llm-only [document path]`, which reads an existing document and rewrites its
companion without running any phase. A companion whose `source_sha256` does not match its document is
stale, and the fix is regeneration, not an edit.

### Never

- Never generate the companion before the document is saved, or from anything but the saved file.
- Never hand-write a companion where the script can run, and never replace a refused one by hand.
- Never reword, summarise, merge, correct or reorder a value's content — restructure only.
- Never fill a `[TBD]`, an owner, a date or a blank cell in the companion. A gap is carried and indexed.
- Never add a value, a requirement, a link or a claim the document does not carry.
- Never drop a row. Rows and records reconcile, or the companion is not saved.
- Never carry gate verdicts, review findings or the Phase 1 summary — they are not in the document.
- Never hand-edit a companion, and never treat one as the reviewed artefact.
- Never estimate `source_sha256` — compute it, or write `unavailable`.
- Never emit a view table as records — name it and omit it.


---

## `GATE-PROTOCOL.md`

---
name: review-brd-gate-protocol
description: Shared review protocol for the two handoff gates in the requirements-documents pack — verdict vocabulary, evidence rule, outcome derivation and precedence, refusal-and-authority handling, the advisory language pass, and the report format. Read when running /review-brd or /review-ord.
---

## Gate Review Protocol

The machinery both gates share. `review-brd` and `review-ord` cite this file rather than carrying
two copies that drift.

**What this file is not.** It holds no criterion. Every BH and OH item, the `[TBD]` treatment table
and the four outcomes are defined in the pack and read from it at review time. This file states only
how a review is *conducted and reported* — which is tooling, and has no home in the pack.

---

### Sourcing the criteria

Two sources, in this order. The skill names which files it needs; this is where they come from.

1. **The live pack, where it is held** — `$FORGE_REQ_PACK/reference/…`, else
   `requirements-documents/reference/…` searching up from the working directory. **Authoritative.**
2. **`CRITERIA.md` beside the skill** — the same criteria, extracted from the pack by
   `tools/build-review-criteria.py` and shipped with the skill so a review runs on a machine that
   does not hold the pack. It is a **generated file**: pinned, stamped with the pack version, and
   never hand-edited.

**Name the pack version in every report**, from whichever source supplied it. A verdict is only
meaningful against a named bar — that is the pack's own thesis applied to the review of it.

**Where both are present and disagree, the pack wins and the extract is stale.** Say so in the
report and regenerate; a silent divergence between them is precisely the defect this pairing exists
to prevent.

**Never review from recollection.** A gate applied from memory drifts from the published one
silently, and the drift is invisible in the output. Where neither source is readable, stop.

### Verdict vocabulary

Four verdicts, from the pack's `[TBD]` treatment table and the verdicts its worked assessment
actually uses. Use these words exactly; a fifth verdict is a sign the treatment table was not read.

| Verdict | The item carries |
|---|---|
| **Met** | A value |
| **Met, with a declared gap** | `[TBD]` with a named owner **and** a date. Met for the bar — and the gap propagates |
| **Unowned gap** | Outstanding, with **nobody to carry it**. Neither met nor owned |
| **Absent** | Nothing at all, or `[TBD]` missing the owner, the date, or both. A hole, not a gap |

**The propagation rule is part of the verdict, not a footnote.** A declared gap that passes the bar
and then disappears is worse than a refusal, because it looks like a pass. Every *Met, with a
declared gap* verdict names where the gap must reappear downstream — the empty traceability row, the
unanswered objective — and a review that cannot name that has not finished the verdict.

**The two limits, wherever declared gaps are counted.** The pack states both at the BRD gate, in
objective terms: at least one objective is fully quantified, and the gap does not sit on the
objective the change is funded against. Without them the bar is unfailable, because every absence
converts to `[TBD] + owner + date`. Apply them where the pack scopes them; where a downstream item
is not an objective, say the limits are stated upstream rather than asserting they bind here.

### Evidence rule

**Every verdict cites where it was read** — the section, the row, the requirement ID — or names
precisely what is absent. A verdict with no citation is an assertion, and an assertion is what an
independent reviewer exists to replace.

### Outcome derivation

The outcome follows from the verdicts. Test in this order and stop at the first that fires:

| Order | Condition | Outcome |
|---|---|---|
| 1 | Any **bar** item is *Absent* | The refusal outcome — *Not accepted for ORD development* / *Not ready for handoff* |
| 2 | Any item, bar or supporting, is an *Unowned gap* | The unowned-gap outcome |
| 3 | Any item is outstanding with an owner and a date, or carries a declared gap | The recorded-gaps outcome |
| 4 | Otherwise | The clean outcome — *Accepted* / *Ready for handoff* |

**This order is the pack's, not this file's.** Both gates state the precedence — the refusal first,
then the unowned gap, then recorded gaps — and both state that the recorded-gaps outcome covers a
declared gap wherever it sits, **including on the bar**. Read those two statements at the gate rather
than trusting this table; where they disagree with it, they win and this file is the defect.

### Refusal and authority

The refusal outcome is the one outcome in the pack that requires authority: the Tier 1 control
*"right to declare an ORD not-ready and refuse handoff"* at §8, which the standard states is **not
currently held**.

Where that right is not held, report the refusal as **recorded rather than exercised**: name the
absent bar items, state that the document proceeds, and state that the accumulation of these records
across cycles is the evidence for establishing the control. A gate that implies an authority nobody
holds is theatre; a refusal that was warranted, declared and overridden is the argument for the
control.

### Report format

```markdown
## [BRD|ORD] Review — [document ID and title]

**Assessed against:** [standard path] · **Reviewer:** [named, and whether they authored it]

### Verdicts

| # | Verdict | Evidence |
|---|---|---|
| BH-1 | **Met, with one declared gap** | [section or row, and what makes it that verdict] |

### Outcome

> **[Outcome name].** [The verdicts that forced it, by the derivation order above.]
> [Where a declared gap passed the bar: where it must reappear downstream.]
> [Where the outcome is a refusal: the authority note above.]

### The five checks

| Check | Finding |
|---|---|
| Baseline gap | [answered, or *not answerable at this hop* with the reason] |

### Language (advisory)

[The `/review-language` report from its Summary down, per § *The language pass*. Outside the gate.]

### What this review does not cover

[Anything the gate does not reach — content quality, altitude beyond the items, downstream fit.]
```

**Report what the verdicts did not do, where it matters.** A recorded gap drives the maturity tier
only where it reaches a KPP-bearing requirement. Recording a gap and tier-driving it are two
different things, and the pack names conflating them as how a gate becomes theatre.

### The language pass

Every gate review ends with a language pass: the `/review-language` skill's procedure, run over the
same document. It checks wording against the requirements language standard, which is not part of
either gate.

**It is advisory and sits outside the gate.** Its findings never change a verdict, the outcome or the
tier. A Defect that also falls under a gate item, such as a technical target under OH-4, is judged
for the gate by that item. The language pass only names it.

**It never blocks the gate.** Where the language standard cannot be read, emit the gate report and
write under *Language (advisory)* that the pass did not run, and why.

### The five checks

Read from `reference/traceability-matrix.md` at review time — baseline, coverage, conformance,
translation and verifiability gaps. Answer each, or mark it not-yet-answerable at this hop with the
reason. A check reported clean because it could not be run is worse than one reported unanswerable.

---

### Never

- Never carry a criterion in this file. It holds protocol; the pack holds the bar.
- Never emit a score, a percentage or a pass rate — four outcomes and a verdict per item.
- Never report a check clean that could not be run at this hop.
- Never let a language finding change a verdict, the outcome or the tier.
- Never let a declared gap pass without naming where it reappears downstream.


---

## `STANDARD.md`

> **Generated file. Never hand-edit.** Produced by `tools/build-review-criteria.py`
> from the requirements-documents pack, which is the single source of truth for
> everything below. Editing this file puts it out of step with the pack; regenerate
> instead.

**Pack version:** v1.16 · **Pack commit:** `e5b1e1da0acc`
**Generated:** 2026-10-08 · **Content hash:** `d0078b39e2ea3e9c`

**Quote the version in every BRD authored from this extract.**
A reader needs to know which revision was applied — a verdict, and a document
authored to a bar, are only meaningful against a named one, and that is the pack's
own thesis applied to itself.

**Where the live pack is present, it wins.** This extract exists so the skill runs
for someone who does not hold the pack. It is a pinned copy, not an authority: where
it and the pack disagree, the pack is right and this file is stale.

---

<!-- from reference/brd-standard.md -->

## BRD Standard

**Version:** 1.16 · **Last updated:** 2026-10-08 · **Status:** Approved
**Standard of record:** BABOK v3 · **Audience:** Business Analysts, Product Owners, Product
Managers, Sponsors, Management

A Business Requirements Document states **why** money is being spent and **how it will be known
that it paid off** — before anyone decides what to build.

---

### Why this exists

Business Requirements Documents are written inconsistently, and the common failures are expensive:

- **No measurable business objective** — the BRD describes a desire ("improve checkout") but no
  target, so success can never be claimed or disproven.
- **Solution smuggled into the business case** — the BRD names a feature ("build saved cards")
  instead of an outcome, pre-empting the solution documents and biasing the design.
- **No stakeholder register** — the people who approve, fund, or are affected are not identified,
  so sign-off stalls.
- **No line of sight to delivery** — a built feature cannot be traced back to the business
  objective that justified it.

The BRD is also the **entry criterion** for the operational document that follows it. A BRD with no
quantified objective and no cost-of-failure case leaves the ORD with nothing to derive a tolerance
from — see [Entry criteria](#entry) and the E1–E9 list.

### The standard

The BRD has no single ISO. The authoritative anchor is the IIBA's **BABOK v3** (Business Analysis
Body of Knowledge). It defines a **requirements taxonomy** — Business, Stakeholder, Solution,
Transition — that determines which document owns which requirement. The BRD owns the **Business**
requirements and frames the **Stakeholder** ones. **Solution** requirements are handed down: the
operational half to the ORD, as quantified business tolerance.

**The functional half has no document in this chain.** The taxonomy names it, the
[PRD standard](#prd) defines its shape, and it is not adopted here — so functional detail is
inferred during Epic decomposition rather than elicited. That absence is not a gap in the BRD's
responsibilities, but it does change what happens to a business rule the BRD correctly declines to
carry: see [what leaves the chain](#traceability).

#### What changes, concretely

| Today | Under the standard |
|---|---|
| Each author invents a structure | One fixed BRD template |
| "Improve checkout" with no target | SMART business objectives with baselines and targets |
| Solution named in the business case | Outcomes only; operational demand lives in the ORD, the design in the SOAP |
| Stakeholders unclear | Stakeholder register with approval roles |
| Delivered work cannot be justified | Objective → ORD → SOAP → Capability AC traceability |

#### The ask

1. **Adopt BABOK v3** as the BRD anchor, using the template on this page.
2. **Require SMART business objectives** with baseline and target on every BRD.
3. **Require a cost-of-failure case** wherever the change carries operational exposure — this is
   what makes an operational tolerance derivable downstream.
4. **Keep solutions out of the BRD** — the BRD states outcomes; the ORD owns the operational
   demand detail, and the SOAP owns the technical answer.
5. **Name an owner** for the standard (recommended: Lead Business Analyst or Programme sponsor).

---

### BABOK v3 — the requirements taxonomy

BABOK v3 classifies every requirement into one of four types. This taxonomy is the most useful tool
for deciding **which document a requirement belongs in**.

| BABOK type | What it captures | Lives in |
|---|---|---|
| **Business** | Higher-level goals, objectives and outcomes of the enterprise. The "why" | BRD |
| **Stakeholder** | Needs of a specific stakeholder or group — the bridge from business goal to solution | BRD |
| **Solution — Functional** | What the solution must *do* (behaviour, capabilities) | **No document in this chain.** Inferred at Epic decomposition. Defined shape: [PRD standard](#prd), unadopted |
| **Solution — Non-functional** | How well the solution must *perform and run* (quality attributes) | ORD, as business tolerance |
| **Transition** | Temporary capabilities to move from current to future state (migration, training, cutover). Retired after go-live | BRD or implementation plan |

> **The split that matters is one line in this taxonomy.** A *Solution* requirement is either
> **functional** or **non-functional**. The BRD holds neither kind of detail — it holds the Business
> outcome they serve. Of the two, only the non-functional half has a document to land in, which is
> why an elicited business rule has to be **recorded and routed** rather than simply passed on.

#### A good business objective is… (SMART)

| Letter | Means |
|---|---|
| **S**pecific | Names one concrete outcome, not a vague aspiration |
| **M**easurable | Has a metric, a baseline and a target number |
| **A**chievable | Realistic within budget, capability and time |
| **R**elevant | Ties to a strategic goal the sponsor cares about |
| **T**ime-bound | States by when it is achieved |

The most common BRD failure is **Measurable**: an objective with no baseline or target can never be
proven met. SMART objectives are how a BRD earns its sign-off — and they are what the ORD's
tolerances trace back to.

---

### The BRD anatomy — required sections

Every BRD carries these sections. Sections marked **★** are the ones most often missing and most
important to enforce.

| § | Section | Purpose |
|---|---|---|
| 1 | **Document control** | **Doc ID**, version, author, sponsor, approval status, date |
| 2 | **Executive summary** | Five labelled lines — the problem, what will be true, the cost of not acting, what is open, and what is being asked. Restates no value |
| 3 | **Business need / problem** | One **problem statement** at business altitude, then the position that evidences it. No solution |
| 4 | **★ Business objectives and success measures** | SMART objectives with baseline and target. The BRD's measurability |
| 5 | **★ Stakeholders** | Stakeholder register — who is interested, who funds, who is affected, and their role |
| 6 | **★ Approving GM register** | Who approves the ORD, one row per business unit in scope. Approval, not interest |
| 7 | **Current vs future state** | Where the business is now and the target operating state, in business terms |
| 8 | **Business scope (in / out)** | Which business areas, processes or segments are in and out, and — where the change is phased — which phase this document covers. Not feature scope |
| 9 | **★ Business requirements** | Stakeholder requirements — a named stakeholder's need stated as an outcome — and the register of what was routed out |
| 10 | **Constraints, assumptions and dependencies** | Regulatory, contractual and time constraints; assumptions with a status; dependencies with a status |
| 11 | **★ Cost of failure** | What is lost when the objective is not met — the input every operational tolerance is derived from |
| 12 | **★ Traceability** | Stakeholder requirement → business objective, and each objective onward to the ORD tolerance expected to quantify it. Proves every build traces to a justification |
| App. A | **Process and system scope** | The L1–L3 process areas and the systems in scope, each with a named owner. Seeds the ORD's impact register |
| App. B | **References** | Every source the BRD cites, in the reference-list form `tables.md` § *Reference list* defines. `None cited` where there is none |

> **The six ★ sections close the gaps most BRDs miss**: SMART objectives, a real stakeholder
> register, a named approver per business unit, stakeholder requirements kept free of solution
> detail, a cost-of-failure case, and traceability up to the objective and down to the ORD. Enforce
> these and the rest follows.

**Appendix A is what makes the ORD sizeable at assignment.** The impact counts that set S/M/L in the
lead-time standard are read off it. A BRD with no process or system scope leaves the size to be
guessed and re-sized later.

#### Two sections this standard used to carry, and no longer does

Both were removed because the BRD was the wrong home, not because the content stopped mattering.

| Removed | Where it goes now | Why |
|---|---|---|
| **Risks** | The **RAID log**, and the BRD cites the `R-NNN` where an objective depends on one | A risk has an owner, a status and a review cadence, and it outlives the document that first noticed it. A risk table inside a BRD is a snapshot that is wrong by sign-off, and it is maintained nowhere |
| **Cost–benefit** | Nowhere — it was restating §4 | An objective already carries a baseline, a target and a date. The benefit *is* the movement between baseline and target, quantified, and restating it as a return figure creates a second number to keep in step with the first. **Cost of failure stays**, at §11, because nothing else states it |

**Deleting cost–benefit is not deleting the business case.** The case is §2, §3 and §4 read together:
the problem, the objectives that close it, and the cost of not closing them. What was deleted is the
restatement.

#### State it once

**A statement belongs in exactly one section, and every other section that needs it refers to it by
ID.** A second occurrence is a *view* of the first: it restates the ID and adds no new number. This
is the single largest source of length in a real BRD.

| The temptation | Where it belongs | What the other sections carry |
|---|---|---|
| Repeat the baseline figure in the executive summary, the business need and the objective | §4, in the objective row | §2 and §3 name the problem; the number is read from §4 |
| Restate a declared gap in every section it touches | §4, on the objective carrying it | An empty cell or an explicit blank row, which is what makes the gap visible |
| Restate a constraint's figure in the objective it bounds | §10, in the constraint row | The objective names the constraint, not its value |
| Restate a cost-of-failure consequence in the business need | §11 | §3 states the problem; §11 states what it costs |

> **The test.** If a figure appears twice, one of the two is a copy that will not be updated when the
> other changes. Cite the section and the ID instead. A BRD that reads as repetitive is usually a BRD
> that has put the same fact in four places, and it is *longer* rather than more thorough.

#### Phasing — optional, and one BRD per phase where the change is large

Where the change is delivered in phases, §8 states **which phase this document covers** and what is
deferred to a later one. The phasing subsection is optional: a change delivered in one release omits
it, and its absence is not a gap.

| | Form |
|---|---|
| Phase table | `Phase` · `Business scope of this phase` · `Deferred to` · `Why the split` |
| In an out-list | An item deferred to a later phase is **out of scope of this document**, with the phase named — not silently absent |

**For a large change, the recommendation is a BRD per phase rather than one BRD carrying every
phase.** The reason is the objective, not the length: a SMART objective carries one target and one
date, and a change spanning three phases either states three targets in one row — which nothing can
be assessed against — or states the final target only, leaving the first two phases funded against a
number they were never going to reach. One document per phase gives each phase an objective that can
be met or missed on its own date.

- **Each phase's BRD carries its own Doc ID**, and names the others in §1.
- **The objective is set against the scope of its own phase.** Where a target is set against a
  population only a later phase reaches, say so in the objective row — the worked example's BO-1 is
  set against residential volume for exactly this reason.
- **Where one BRD does carry every phase**, that is a choice, not a default: state why, and state
  which phase each objective's target belongs to.

**One problem statement still governs.** Phasing splits *delivery*, not the problem — three BRDs for
three phases of one change carry the same problem statement at §3 and differ at §4 and §8. Where the
phases have genuinely different problems, they are different changes.

---

### Writing the BRD — the forms

#### Document control and the Doc ID

Every BRD carries a **Doc ID** in its front matter, and it is the first field rather than an
afterthought at the foot of the page. Everything downstream cites the document by it — the ORD's
entry position record, the traceability matrix, the RAID entries raised from it, and the sibling BRD
where the change is phased.

```
**Doc ID:** BRD-YYYY-NNN · **Version:** N.N · **Status:** Draft / In review / Approved · **Priority:** P1–P4
**Executive sponsor:** [role] · **Author:** [name or role]
**Horizon:** [FYnn Hn – FYnn Qn] · **Phase:** [n of m, or "single release"] · **Standard:** BABOK v3
```

- **`BRD-YYYY-NNN`** — the year the document was raised, and a sequence within it. Flat, never
  encoding a business unit or a programme, and never reused once retired.
- **A phased change carries one Doc ID per phase**, and each names the others in §1. A reader holding
  Phase 2 has to be able to find Phase 1 without knowing it exists.
- **The ID is assigned at first draft, not at approval.** A document that acquires its identity only
  when it is signed cannot be cited by the RAID entries and the referred requirements raised while it
  was being written — which is exactly when they are raised.

#### The executive summary

§2 answers the five questions an executive asks, one line each, in this order. It is **an answer set,
not a paragraph** — a summary that has to be read as prose to find the ask has stopped being a
summary.

| Label | Answers | Reads from |
|---|---|---|
| **Problem.** | What is wrong, in one sentence at business altitude | §3's problem statement |
| **What will be true.** | Which objectives close it, and by when | §4, by `BO-N` and horizon |
| **Cost of not acting.** | What is lost if they are not met | §11 |
| **Open.** | What is unresolved at issue, with its owner and date | §4, §6, §10 and Appendix A |
| **Decision sought.** | The decision this document wants, and over what scope | §8, and the phase |

**§2 carries no number of its own.** Every figure sits behind a `BO-N`, a clause reference or a
section pointer — the reader who wants the baseline reads §4's row, where it is maintained. This is
§ *State it once* at the section that breaks it most often: an executive summary is written from the
brief, early, by someone summarising what they hope the document will say, and it then disagrees with
the document quietly for the rest of its life.

**Written last, from the sections that exist.** Never from the brief. A summary drafted first
promises what the register does not contain, and nobody re-reads it afterwards to find out.

**A label that cannot be filled is a finding, not a formatting problem.** Each empty line names
something specific:

| Cannot fill | What that means |
|---|---|
| **Decision sought** | The document has not established what decision it wants. It is a briefing paper, not a BRD |
| **Cost of not acting** | BH-4 is absent, and the gate will refuse the document. §2 found it first |
| **What will be true** | No objective is quantified — BH-1, and the two limits at § *How a `[TBD]` is treated* |
| **Problem** | §3 has described where a problem was noticed rather than what the enterprise loses |

**`Open: None` is written out, never deleted.** A missing line reads as *not considered*; the word
*None* reads as *considered, and there is nothing*. The difference is invisible unless it is written.

**§2 introduces no commitment that is not stated elsewhere.** It is narrative, and narrative that
originates an obligation puts it in the one place nothing traces to.

#### The problem statement

§3 opens with **one problem statement**: the high-level problem being solved for the business, in a
form a reader who knows nothing about the estate can hold in their head. Everything else in §3 is
evidence for it.

**Problem statement form:**

```
[Named business population or process] [what is happening, or failing to happen],
costing [the enterprise consequence], because [the business mechanism that causes it].
```

| Written too low (wrong for §3) | Written at business altitude (right) |
|---|---|
| "Attendance is not recorded distinguishably in the workforce management platform, so the rebate job cannot determine eligibility." | "Customers owed a contractual credit receive it only if they complain. The enterprise pays the customers who ask, and carries an unmeasured liability to those who do not." |
| "Complaint handling time averages 11 minutes against a 6-minute target." | "Contact-centre capacity is consumed by customers claiming money the enterprise already owes them." |

> **The altitude test.** A problem statement that names a system, a screen, a team's tooling or an
> internal process step has described a *symptom at the point it was noticed*, not the problem. Ask
> what the enterprise loses. That answer is the problem statement; where it was noticed is evidence.

**One problem statement per BRD.** Where the source describes several problems, either they are
symptoms of one — say which, and state that one — or the change is two changes. Two unrelated
problems in one BRD produce objectives that compete for the same funding decision without the
decision ever being put.

**§3 carries the problem and the evidence for it, and nothing else.** It does not restate §4's
targets, §10's constraints or §11's consequences — see § *State it once*.

#### The objective form

A business objective states the *outcome* the enterprise wants. The discipline that keeps a BRD
clean is: **describe the change in a business metric, never the feature that achieves it.**

**Objective form:**

```
Move [business metric] from [baseline] to [target] by [date], so that [strategic outcome].
```

#### Solution vs outcome — the test

| Written as a solution (wrong for a BRD) | Written as an outcome (right) |
|---|---|
| "Build an automated rebate engine." | "Reduce complaints arising from missed appointments from 1,840 to below 900 per quarter by FY27 Q2." |
| "Add a self-service password reset page." | "Cut password-related support tickets by 30% within a year." |
| "Migrate to the new payments provider." | "Lower payment processing cost per transaction by 15% by FY-end." |

> **Rule:** if an objective names a screen, feature, system or technology, it has leaked solution
> detail. Rewrite it as the measurable outcome. The operational tolerance belongs in the ORD and
> the technical figure in the SOAP; functional detail has no document here and is registered rather
> than passed on.

#### The stakeholder register, and the approving GM register

**Two registers, because interest and approval are different things.** §5 records who cares about the
change and how. §6 records who signs the operational demand it produces. Collapsing them puts an
approver's authority in a table that also holds people who are merely informed, and the approver
becomes hard to find at exactly the moment sign-off is chased.

**§5 — the stakeholder register.**

| Stakeholder | Interest | Role |
|---|---|---|
| [named role, or group where the group is the stakeholder] | [what they stand to gain or lose] | Sponsor / Consulted / Affected / Authors [downstream document] |

**§6 — the approving GM register.** One row per business unit in scope, and the count of rows is
checkable against §8's scope and Appendix A's owners.

| Business unit in scope | Approving GM | Approves | Status |
|---|---|---|---|
| [unit, matching a §8 scope area] | [named GM] | The ORD's operational tolerance for this unit | Confirmed, or `[TBD]` carrying the owner who will confirm it and a date |

- **The BRD's sponsor is not automatically an approving GM, and often is not one.** The sponsor funds
  the change; the approving GM commits the unit that carries the operational consequence. Where the
  consequence lands across three units, three GMs approve and the sponsor approves none of it.
- **A business unit in §8's in-scope list with no row here is the finding**, not an omission to tidy
  up. It is the case BH-6 exists to surface.
- **Never infer an approver from an org chart.** An unconfirmed GM is `[TBD]` with the owner who will
  confirm it and a date, exactly as an unquantified objective is.

**Both registers are routinely incomplete at first draft, and that is expected.** The stakeholder the
author is least placed to identify is the one whose absence costs the most later. There is no second
mechanism for it: an unknown stakeholder or an unknown approver is a `[TBD]` carrying a named owner
and a date — see § *How a `[TBD]` is treated* — and it reaches the gate as a declared gap rather than
as a complete-looking list that happens to be wrong.

> **Few rows is not evidence of a simple change.** It is more often evidence of a short elicitation.
> Where §6 names fewer business units than Appendix A names process owners, one of the two is
> incomplete, and the gate reads both.

#### The stakeholder requirement form

§9 holds **Stakeholder** requirements in the BABOK sense — the need of a named stakeholder or group,
which is the bridge between the business objective above it and the solution documents below. It
does **not** hold Business requirements restated at a lower altitude, and it does not hold functional
detail.

**Stakeholder requirement form:**

```
[Named stakeholder or group] requires [the outcome they need], stated without
naming a workflow, a system, a vendor or a figure.
```

| ID | Stakeholder | Stakeholder requirement |
|---|---|---|
| BR-N | [named role or group, traceable to a §5 row] | [the outcome that stakeholder requires] |

- **`Stakeholder` names a row in §5.** A requirement whose stakeholder is not in the register is
  either a stakeholder the register missed or a requirement nobody asked for, and which of the two
  it is has to be established rather than assumed.
- **The objective a requirement serves is not a column here.** It is §12's row — carrying it in both
  places is the restatement § *State it once* forbids, and §12 is where a requirement serving *no*
  objective becomes visible.
- **Writing at stakeholder altitude is what removes the need for a further document** to record a
  stakeholder's need. It is not licence to carry the functional detail that need implies: that
  detail is routed, below.

**What §9 declined to carry is recorded, not dropped.** A BRD that silently discards the functional
detail elicited alongside a stakeholder need loses it — there is no functional requirements document
in this chain to catch it. §9 therefore carries a second table:

| Statement raised | BABOK type | Routed to | ID there |
|---|---|---|---|
| "[quoted as elicited]" | Solution — non-functional | ORD, as business tolerance | `[ORD-TBD]`, written back |
| "[quoted as elicited]" | Solution — functional | Referred requirements register | `[REF-TBD]`, written back |
| "[quoted as elicited]" | Business rule | Referred requirements register | `[REF-TBD]`, written back |

**This table mints no IDs.** The register that receives a statement owns its own namespace and
writes the real ID back — the same mechanism the traceability skeleton uses for a tolerance that does not exist yet. A
row that never receives an ID is a routing that never happened, and that is the finding.

#### The cost-of-failure statement

An objective states what is gained. A **cost-of-failure statement** states what is lost, and it is
the input the ORD converts into a tolerance:

```
If [business metric] is not held, the consequence is [named consequence]
at [quantified cost], because [obligation, contract or mechanism].
```

Without it, an ORD tolerance is either traceable to nothing or invented. This is the single most
common upstream cause of a low-maturity ORD.

#### Constraints, assumptions and dependencies

Three different kinds of statement, and the difference is what is known about them. §10 carries each
in its own table rather than one merged list, because they have different lifecycles and only one of
them is fixed.

**Constraint — a given the change cannot move.** Regulatory obligation, contractual commitment,
statutory deadline, a boundary set outside the change. Not a design choice, and not a preference.

| Constraint | Source | Operational weight |
|---|---|---|
| [the given, with its value] | [contract clause, regulation, agreement] | [what it bounds downstream] |

**A constraint is identified by its source, not by a local ID.** "Consumer contract cl. 14.3" is
already unique, already citable downstream, and already the thing a reader has to go and read. A
BRD-local number in front of it adds a second identifier for the same obligation and nothing else —
and it is how two documents come to hold different numbers for one clause.

**Constraints are elicited, not recalled, and they are routinely not known at first draft.** Ask
against each of these, and record the answer — including *none found* — rather than leaving the
category unasked:

| Ask | Looks like |
|---|---|
| Regulatory and statutory | A licence condition, a reporting obligation, a retention period, a privacy rule |
| Contractual | A clause the enterprise is already bound by, in a customer, supplier or partner agreement |
| Time | A date set outside the change — a regulatory commencement, a contract expiry, a season |
| Financial | An approved envelope, a funding boundary, a capitalisation rule |
| Organisational | A change freeze, a mandated platform or supplier, an operating-model boundary |
| Prior commitment | Something already stated to a customer, a regulator or a market |

> **A category asked and answered *none found* is a record. A category never asked is a hole.** The
> difference is invisible in the finished document unless the empty answer is written down, which is
> why it is written down.

**A constraint nobody has confirmed yet is a `[TBD]` with a named owner and a date**, treated exactly
as an unquantified objective is — see § *How a `[TBD]` is treated*. There is no second mechanism for
not-yet-known: it is the same one, and inventing a constraint to avoid an empty row is the failure
the whole standard exists to prevent.

**Assumption — something believed true, pending confirmation.** It carries a status, and it carries
the consequence of being wrong.

| ID | Assumption | Status | If false | Owner | Confirm by |
|---|---|---|---|---|---|
| ASM-NNN | [declarative statement] | Unvalidated / Validated / Falsified | [consequence] | [named role] | [date] |

- **`If false` is mandatory.** An assumption with no stated consequence is a note.
- **A `Validated` assumption is no longer an assumption — it is a constraint**, and it moves to the
  constraint table with its source recorded as the validation. Leaving it in the assumption register
  at `Validated` is how a confirmed given goes on being treated as provisional by everyone
  downstream. The row is moved, not copied.
- **A `Falsified` assumption has no home in the RAID log** — RAID is Risks, Actions, Issues and
  Decisions, and has no assumptions quadrant. Set the status, raise the exposure as a risk in the
  RAID log, and record the `R-NNN` in the `If false` cell.
- **`Owner` and `Confirm by` are mandatory** wherever an objective, a constraint or a cost-of-failure
  statement rests on the assumption. An unowned, undated assumption underneath a funded objective is
  an invented number wearing a different label.

**Dependency — something outside the change that the change needs.** It carries a status, because a
dependency's whole risk is that its status changes without the BRD noticing.

| ID | Depends on | Type | Owner | Needed by | Status |
|---|---|---|---|---|---|
| DEP-NNN | [named system, team, programme or deliverable] | Internal / External / Vendor | [role] | [date or milestone] | Open / Met / At risk |

**`At risk` is a dependency status, not a risk in its own right.** Where the exposure needs managing
it is raised in the RAID log and the `R-NNN` cited here — the BRD carries no risk table of its own.

---

### Where the BRD sits in the chain

The BRD sits highest and holds **no requirement detail**. Everything below it is a transformation
performed by someone who did not author the input.

```
BRD  →  ORD  →  SOAP  →  Capability AC  →  Epic AC
why     what the      how it will      what will      what will
        business      be met           be accepted    be built
        requires
```

| Altitude | Artefact | Holds | Authored by |
|---|---|---|---|
| Why — the outcome | **BRD** | Business objectives, stakeholders, business case, cost of failure | Business analysis |
| How well it must serve the business — operational demand | **ORD** | Quantified business tolerance across the nine ISO/IEC 25010 characteristics, and the impact register | ORD convenor |
| How the demand is met — the technical answer | **SOAP** | Availability figures, RTO/RPO, latency budgets, capacity, infrastructure, support model | Solution architecture |
| What will be accepted | **Capability AC** | Acceptance criteria derived from the SOAP | Product Manager |
| What will be built | **Epic AC** | Build-level acceptance criteria | Technology BA |

**The ORD is a demand document, not a design one.** It states what the business can tolerate;
architecture's response — the Solution on a Page — derives the technical figure that satisfies it.
See [Roles at the boundary](#roles).

**One artefact is missing from this chain, and the BRD feels it first.** There is no functional
requirements document between the BRD and the Capability. A business rule the BRD correctly declines
to carry has nowhere to go, so it is inferred later during Epic decomposition — or, if elicited
during ORD work, held in the referred requirements register as an interim record.

#### The decision that actually recurs: tolerance or figure?

Once a requirement is detailed, it is a *Solution* requirement, so the BRD is no longer a candidate.
For the operational half, the live question is whether the statement is a **business tolerance** —
the ORD's — or a **technical figure** — the SOAP's.

| Requirement detail | Classification | Lands in |
|---|---|---|
| "Authorisation delay beyond 3 seconds causes measurable cart abandonment, at $X per point" | Business tolerance, performance efficiency | **ORD** §7.1.1 |
| "Payment authorisation P99 ≤ 800 ms" | Technical target | **SOAP** — architecture's answer to the tolerance above |
| "Checkout unavailability in peak trading costs $X per hour and breaches merchant obligation Y" | Business tolerance, reliability | **ORD** §7.2.1 |
| "99.99% monthly availability" | Technical target | **SOAP** |
| "PCI-DSS applies; a breach carries penalty X and loss of acquiring" | Compliance obligation | **ORD** §7.3.6 |
| "Card data tokenised, no PAN at rest" | Technical control | **SOAP** |
| "A customer acting on a generated summary that misstates their entitlement breaches obligation Y, at $X per occurrence" | Business tolerance, accuracy of generated output | **ORD** §7.8 |
| "Summary quality scores ≥ 4.0 of 5 mean on a held-out evaluation set, no single case below 2.5" | Technical target — the evaluation instrument | **SOAP** |
| "Customer pays in one tap with a saved card" | Functional behaviour | **No document** — inferred at Epic decomposition, or registered as a referred requirement |
| "Refunds over $500 require supervisor approval" | Business rule | **No document** — as above |
| "Tier 2 support staffed at 4 FTE, follow-the-sun" | Staffing | **Referred requirements register** |

> **The test when a detail resists placement.** **Existence:** does architecture's answer to this
> document already exist? If not, a technical figure in the ORD is an antipattern regardless of how
> well it traces — a well-justified RTO is still architecture's to set. **The test reaches an evaluation
> instrument unchanged:** a set that does not yet exist cannot carry a pass mark here, because the
> pass mark *is* the answer. The population the measure is taken over, and the consequence of
> breaching it, are the demand side and belong in the ORD.

> **Net:** the BRD deliberately holds no detail. The decision made day to day is **tolerance or
> figure** — and, for anything functional, **which register receives it**, since no document will.

---

### The handoff gate — is this BRD ready for ORD development? ★

The BRD's author owns this gate. It is the exit criterion for the BRD and the entry criterion for
the ORD, and it is stated here rather than in the ORD standard because a document's readiness is
its author's to establish, not its recipient's to adjudicate after the fact.

**Assessed before ORD development is assigned, not after.** The ORD's own entry criteria (E1–E9)
record what arrived; this gate establishes whether what arrived is enough to start.

**What puts an item on the bar, and what does not.** An item is on the bar where its absence makes
the next document **unwritable** — not merely less mature. Everything whose absence the maturity
tier can absorb is a supporting item. That rule is what keeps the two lists from being a matter of
taste, and it is the same rule [§7.1](#handoff) applies one hop downstream.

#### How a `[TBD]` is treated — read this before the bar

The pack's rule against inventing a threshold means a BRD arrives with declared gaps, and a gate
that treats every gap as an absence refuses every real document. A gate that treats every gap as
satisfied refuses none. Neither is useful, so the treatment is stated rather than left to judgement:

| The item carries | Treatment |
|---|---|
| A value | **Met** |
| `[TBD]` with a **named owner and a date** | **Declared gap.** The item is met *for the bar*; the gap propagates — the objective it sits on carries no tolerance, and its traceability row stays visibly empty |
| `[TBD]` with no owner, or no date, or neither | **Absent.** Not a gap, a hole. It fails the bar |
| Nothing at all | **Absent** |

**Two limits, and without them the bar is unfailable.** A declared gap is not a free pass:

1. **At least one objective is fully quantified** — baseline, target and date, no `[TBD]`. It is
   what the ORD derives its first tolerances from. A BRD whose every objective is `[TBD]` fails
   BH-1 however well-owned the gaps are.
2. **The gap does not sit on the objective the change is funded against.** Where the business case
   rests on the objective that is unquantified, the case is unquantified, and no downstream document
   can repair that.

> **The point of the propagation rule.** A declared gap that passes the bar and then disappears is
> worse than a refusal, because it looks like a pass. Every gap admitted here **must** reappear as
> an empty traceability row and an unanswered objective downstream — see BO-4, which does exactly
> that at §12 of the worked example and again on the [traceability matrix](#traceability).

#### The bar — four items, and their absence is a refusal

These four are what an ORD cannot be written without. Each maps to a load-bearing element the ORD
consumes immediately.

| # | Required | Consumed by | Absent means |
|---|---|---|---|
| **BH-1** | A named business objective carrying a **baseline, a target and a date**. Assessed per objective; the two limits above govern how many may be declared gaps | Every tolerance traces here. It is what establishes *why* two billing cycles rather than three | Every ORD requirement is orphan scope, and no tolerance is auditable |
| **BH-2** | Each objective stated as an **outcome, not a solution** — no feature, system, vendor or asserted figure | Leaves the ORD something to add | The BRD has pre-empted the ORD. The figure is asserted rather than derived, and the architecture review becomes ratification |
| **BH-3** | **Constraints and dependencies carrying operational weight** — regulatory obligations, contractual commitments, platform dependencies, named specifically, each elicited against the categories at § *Constraints, assumptions and dependencies* rather than recalled | Seeds Security, Compatibility and Reliability | The ORD author invents them or misses them |
| **BH-4** | A **cost-of-failure case** for each objective carrying operational exposure | The input every tolerance is derived from | A tolerance traced to no consequence is an invented figure, however well it is written. The single most common upstream cause of a low-maturity ORD |

> **BH-1 to BH-3 are the three load-bearing elements at [§3.4](#entry); BH-4 is the fourth, and it
> is the one most often assumed to be optional.** A complete BRD is not the bar — these four are.
> A BRD carrying only these and nothing else is enough to start on.

#### Supporting items — absent, these are recorded and drive the tier

Their absence does not stop ORD development. It determines the maturity tier committable on the
fixed date, and each is recorded under [§3.3](#entry) at assignment.

| # | Required | Absent means |
|---|---|---|
| **BH-5** | **Stakeholder register** naming who is interested, who funds and who is affected, each with their role | The author is least placed to compile it. A late list does not cost the days it was late — it costs the back half of the ORD |
| **BH-6** | An **approving GM register** — one row per business unit in scope, each naming the GM who approves the ORD for that unit | Unknown approvers surface at sign-off rather than at the start. A unit in scope with no row is the case this item exists to find |
| **BH-7** | **Business scope, in and out**, with the out-list explicit, and — where the change is phased — the phase this document covers | Silent scope growth, and the ORD extends the operational boundary beyond what was authorised |
| **BH-8** | **Appendix A — process and system scope**, each row carrying a named owner | The ORD is not sizeable at assignment, so it is sized on a guess and re-sized later. Half the impact register has to be reconstructed from stakeholder recall, at stakeholder cost |
| **BH-9** | A **traceability skeleton**, both directions — each stakeholder requirement against the objective it serves, and each objective against the tolerance expected to quantify it, or an explicit blank | A requirement serving no objective is unfunded scope; a funded objective with no operational demand stated is invisible until nobody delivers it. Tracing one direction only finds one of the two |
| **BH-10** | **Stakeholder requirements stated at stakeholder altitude** — a named stakeholder's outcome, no workflow, system or figure — with everything declined recorded in the routing register rather than dropped | Solution detail leaks downstream and the ORD inherits an answer instead of a question. Functional detail elicited and not routed is simply lost, because no document in this chain catches it |

#### The four outcomes

| Outcome | Condition | What follows |
|---|---|---|
| **Accepted** | BH-1 – BH-10 met, no declared gaps | ORD development starts. The entry position record carries no outstanding items |
| **Accepted with recorded gaps** | BH-1 – BH-4 met; one or more items outstanding, **each with a named owner and a date** — a declared gap on a bar item, a supporting item outstanding, or both | ORD development starts. The gaps are recorded at [§3.3](#entry) and determine the committed maturity tier where they reach a KPP-bearing requirement |
| **Accepted with an unowned gap** | BH-1 – BH-4 met; an outstanding item has **no owner to carry it** | ORD development starts. The item is recorded at [§3.3](#entry) and **raised with the approving GMs at sign-off rather than referred, because a referral needs a recipient.** It stays open until someone accepts it — and that it stayed open is the finding |
| **Not accepted for ORD development** | Any of BH-1 – BH-4 absent, per the `[TBD]` rule above | Returned to the author with the absent items named. **The ORD task is a BRD task in disguise** — see the antipatterns at [§3.4](#entry) |

**Where more than one row applies, the outcome is the most serious of them** — the refusal first,
then the unowned gap, then recorded gaps. The worked assessment below carries declared gaps at BH-1,
BH-3 and BH-4 *and* an unowned one at BH-8, and lands on the third outcome rather than the second.

**The second row covers a declared gap wherever it sits, including on the bar.** A bar item carrying
`[TBD]` with an owner and a date is met *for the bar* under the rule above, but the document is not
gap-free — so it is neither the first outcome nor a refusal. Reading the row as supporting-items-only
left that document matching no outcome at all.

**The third outcome is the one most documents land on, and it exists because the second could not
hold it.** An item outstanding *with* an owner is a scheduling problem. An item outstanding with
**nobody to own it** is a finding about the organisation rather than about the document, and
collapsing the two loses the more serious of them.

**Requesting the detail before ORD development proceeds is the correct response, not an
escalation.** An ORD written from a BRD missing its bar produces figures nobody can defend, and
the cost of that lands after architecture has designed against them.

> **This outcome depends on a right the standard says is currently absent, and that is worth
> stating plainly rather than glossing.** The [ORD Intake and Maturity Standard](#purpose) is a
> **declaring** standard, not a blocking one — every other mechanism in it produces a record rather
> than exercising a veto, precisely because a record is available to someone holding no authority.
> *Not accepted for ORD development* is the one outcome in this pack that requires authority: the
> Tier 1 control **"right to declare an ORD not-ready and refuse handoff"** at
> [§8](#controls), listed there as a control **to be established**.
>
> **Where that right is not yet held**, the outcome is *recorded* rather than exercised: the ORD
> proceeds, the absent bar items are recorded at [§3.3](#entry), and the committed tier reflects
> them. That record is the evidence for establishing the control — a refusal that was warranted,
> declared, and overridden is a stronger argument than the same right requested on day one.

---

### Worked example — BRD-2026-041, Missed Appointment Rebate (Acme Communications)

**Doc ID:** BRD-2026-041 · **Version:** 2.0 · **Status:** Approved · **Priority:** P1
**Executive sponsor:** Chief Customer Officer · **Author:** Business Analysis
**Horizon:** FY26 H2 – FY27 Q2 · **Phase:** 1 of 2 (Phase 2 — BRD-2026-058) · **Standard:** BABOK v3

> **One worked example runs the pack's live chain.** This BRD is the upstream document for the
> [worked example ORD](#example) and for the [traceability matrix](#traceability). Its objectives,
> constraints and scope are the ones that ORD's tolerances trace back to, so the three can be read
> as one chain rather than three unrelated illustrations. Copy the shape, not the figures.
>
> **One page stands outside it, deliberately.** The [PRD standard](#prd) carries a self-contained
> example, because the chain documented here has no functional requirements column to run one
> through. That exception is the gap, not an inconsistency.

#### 2 · Executive summary

**Problem.** Customers owed a contractual credit for a missed installation appointment receive it
only if they complain (§3).

**What will be true.** BO-1 – BO-3 and BO-5, on the FY27 Q2 horizon (§4).

**Cost of not acting.** Breach of consumer contract cl. 14.3 per affected customer, and an unmeasured
population never credited (§11).

**Open.** BO-4 unquantified — Regulatory Affairs, 2026-08-15. One system in scope with no owning team
(Appendix A).

**Decision sought.** Approval to proceed to ORD development, Phase 1 — residential installation
appointments (§8).

**Not one figure appears here, and the section is stronger for it.** The earlier draft of this
summary carried 1,840, 900, FY27 Q2, clause 14.3 and the unclaimed population — five values owned by
§4, §10 and §11, each of which would have gone on disagreeing with its owner after the first
revision. **Open** carries a date because a date is not a commitment: it is the gap's own property,
and it is the line an executive acts on.

#### 3 · Business need — the problem, and the position that evidences it

**Problem statement.** Customers owed a contractual credit for a missed installation appointment
receive it only if they complain — so Acme pays the customers who ask, carries an unmeasured
liability to those who do not, and funds a complaint channel that exists to claim money already owed.

**The position that evidences it:**

| | Today |
|---|---|
| Rebate trigger | Issued **only when a customer complains**. A customer who does not complain does not receive a credit clause 14.3 obliges Acme to pay |
| Complaint volume | 1,840 per quarter (FY25 Q4 baseline, INC-4471 theme analysis) — contact-centre load generated by customers claiming money already owed |
| Attendance record | Attendance and non-attendance are **not recorded distinguishably**, so the customer is the detection mechanism |
| Rebate determination | Manual, on receipt of a complaint, reconstructed by an agent within the call |
| Contract change | Clause 14.3 amended twice since 2023, each amendment requiring a software release |
| Unclaimed exposure | **Not measured** — `[TBD — Regulatory Affairs, due 2026-08-15]` |

**Three things this section does not do.** It does not restate BO-1's target — that is §4's row. It
does not restate clause 14.3's two-billing-cycle obligation — that is §10's constraint. It does not
restate what the exposure costs — that is §11. Each appears once, and §3 cites rather than copies.

**The last row is left open on purpose.** The exposure is real and its size is not known, and
inventing a figure to avoid an empty cell is the failure this standard exists to prevent. It is
carried as a visible gap with a named owner rather than as a number nobody can defend.

#### 4 · Business objectives and success measures ★

| ID | Objective (SMART) | Baseline | Target | By |
|---|---|---|---|---|
| BO-1 | Reduce complaints arising from missed installation appointments | 1,840 / quarter (FY25 Q4) | < 900 / quarter | FY27 Q2 |
| BO-2 | Issue the rebate owed under clause 14.3 without the customer making contact | 0% issued unprompted | ≥ 95% of determined rebates | FY27 Q2 |
| BO-3 | Bring the rebate amount and qualifying window into effect within one billing cycle of a contract change | Release-dependent; two amendments since 2023 | ≤ 1 billing cycle, no release | FY27 Q2 |
| BO-4 | Close the unclaimed-rebate exposure carried under clause 14.3 | `[TBD — Regulatory Affairs, due 2026-08-15]` | `[TBD]` | FY27 Q2 |
| BO-5 | Answer a regulatory enquiry into any appointment's rebate position within 1 business day | Manual reconstruction, duration not measured | ≤ 1 business day | FY27 Q2 |

**BO-1's target is set against residential volume**, which is Phase 1's scope at §8. A target set
against the population a later phase reaches would be unmeetable on this document's date.

**BO-4 is unquantified and stays in the register.** An objective with a `[TBD]` and an owner is a
tracked gap; the same objective omitted is invisible. It is the objective most likely to change the
business case, which is why it is not deferred out of the document.

#### 5 · Stakeholders ★

| Stakeholder | Interest | Role |
|---|---|---|
| Chief Customer Officer | Complaint volume and customer trust | Executive sponsor; approves spend |
| GM Customer Care | Complaint handling, customer channel | Approver — §6 |
| GM Field Operations | Attendance capture and contractor data | Approver — §6 |
| GM Billing | Rebate application, billing-cycle boundary | Approver — §6 |
| Regulatory Affairs | Clause 14.3 interpretation, enquiry response | Consulted; owns BO-4's quantification and OQ-01 |
| Contract Manager, Field Services | Attendance-data timeliness under the field services agreement | Consulted; constrains scope |
| Solution Architecture | The design that answers the ORD | Authors the SOAP |
| Product Manager | What will be accepted | Authors the Capability acceptance criteria |
| Affected customers | Receiving the credit they are owed | Affected; not consulted directly |

**§5 records interest and role, and stops there. What each GM approves is §6's** — holding it in
both places is how the two come to disagree.

#### 6 · Approving GM register ★

| Business unit in scope | Approving GM | Approves | Status |
|---|---|---|---|
| Field Operations | GM Field Operations | The ORD's operational tolerance for this unit | Confirmed |
| Customer Care | GM Customer Care | The ORD's operational tolerance for this unit | Confirmed |
| Billing | GM Billing | The ORD's operational tolerance for this unit | Confirmed |

**Three GMs approve the ORD, and none of them approves this document.** The obligation is
contractual and the consequence lands across 3 business units, so the operational tolerance is
committed by the units that carry it rather than by the sponsor who funds the change.

**Three rows against three in-scope business units at §8, and three process owners at Appendix A.**
That the three counts agree is the check this register exists to make possible.

#### 7 · Current vs future state

**Current:** the customer is the detection mechanism. A missed appointment is discovered when the
customer calls, determined by an agent reconstructing history mid-call, and credited manually.
Customers who do not call are not credited.

**Future:** a missed appointment is determined from data captured during the field job, the rebate
is applied within the contracted window without customer contact, and the complaint path carries
only genuine exceptions.

#### 8 · Business scope

**In:** appointment completion, rebate determination, rebate application and customer notification,
across Field Operations, Customer Care and Billing.

**Out:** contact-centre staffing, hosting and infrastructure, and commercial renegotiation of the
field services agreement. Also out of *this document*: everything at Phase 2 below.

**Phasing.** This BRD covers **Phase 1**.

| Phase | Business scope | Deferred to | Why the split |
|---|---|---|---|
| **Phase 1 — this document** | Residential installation appointments | — | Clause 14.3 exposure is concentrated in residential volume, and residential attendance data is the only source currently captured |
| Phase 2 | Business and assurance appointments | **A separate BRD** | The business appointment obligation sits under a different contract schedule, so it carries a different problem statement and a different approving unit |

**Phase 2 is a separate BRD rather than a later section of this one**, per the recommendation at
§ *Phasing*. It is not a larger version of this change: the obligation, the evidence and the
approving unit all differ, and one objective row cannot carry two targets on two dates.

#### 9 · Business requirements ★

| ID | Stakeholder | Stakeholder requirement |
|---|---|---|
| BR-1 | Affected customers | A customer whose installation appointment is missed receives the contracted rebate without contacting Acme |
| BR-2 | Affected customers | A customer establishes their own rebate position through a channel they already use |
| BR-3 | Regulatory Affairs | The rebate amount and qualifying window track the consumer contract without a software release |
| BR-4 | GM Customer Care | Complaint handling receives only appointments where the rebate position is genuinely disputed |

> Note the altitude. None of these names a workflow, a system or a figure. "Attendance capture in
> the workforce management platform" and "within two billing cycles" appear nowhere here — the first
> is the SOAP's answer, the second is the ORD's tolerance. **Nor does any row name the objective it
> serves:** that is §12's, and it is where BO-4 having no stakeholder requirement becomes visible.

**Routed out of this document, and recorded rather than dropped:**

| Statement raised | BABOK type | Routed to | ID there |
|---|---|---|---|
| "Rebates over $500 are approved by a supervisor before issue" | Business rule | Referred requirements register | `[REF-TBD]`, written back |
| "The customer is notified in the channel they last used" | Solution — functional | Referred requirements register | `[REF-TBD]`, written back |
| "Determination survives a contractor portal interruption" | Solution — non-functional | ORD, as business tolerance | ORD-04 |
| "Tier 2 rebate disputes are staffed to the existing follow-the-sun roster" | Staffing | Referred requirements register | `[REF-TBD]`, written back |

**Three rows carry `[REF-TBD]` and one carries a real ID.** ORD-04 was written back when the ORD was
authored; the three referred rows are still awaiting a register that will accept them. That is the
routing gap this table exists to make visible — the alternative is that all four statements were
elicited, none was carried, and nobody can say so.

#### 10 · Constraints, assumptions and dependencies

**Constraints.**

| Constraint | Source | Operational weight |
|---|---|---|
| Rebate payable within 2 billing cycles of the missed appointment | Consumer contract cl 14.3 | Sets the tolerance the ORD quantifies |
| No duplicate credit for one appointment | Consumer contract cl 14.5 | Bounds determination |
| Rebate determinations retained for 7 years | Consumer contract cl 14.6 | Bounds auditability |
| Contractor attendance data supplied within 24 hours | Field services agreement cl 9 | Bounds how current any determination can be |
| Billing cycle boundary — monthly, per customer | Billing operating model | Fixed. Not a design choice, and it bounds every tolerance expressed in cycles |
| Privacy: rebate position is customer personal information | *Privacy Act 1988* (Cth), Legal to confirm scope | `[TBD — Legal Counsel, due 2026-08-29]` |

**Elicited and answered *none found*:** financial envelope constraints beyond the approved programme
funding, organisational change-freeze windows, and prior public commitments. Recorded so the
categories read as asked rather than as missed.

**Assumptions.**

| ID | Assumption | Status | If false | Owner | Confirm by |
|---|---|---|---|---|---|
| ASM-001 | Contractors submit attendance through the existing channel without process change | Unvalidated | A commercial variation to the field services agreement lands on the critical path | Contract Manager, Field Services | 2026-09-12 |
| ASM-002 | Clause 14.3's "two billing cycles" runs from the appointment, not from confirmation | Unvalidated | Every tolerance expressed in cycles moves, and BO-2's target with them. Raised as **R-114** | Regulatory Affairs | 2026-08-15 |
| ASM-003 | Residential appointment volume is a stable base for BO-1's target | **Validated** — Commercial Analytics (2026), confirmed 2026-07-30 | — moved to the constraint table as a given | Commercial Analytics | Closed |

**ASM-003 shows the transition.** A validated assumption is no longer an assumption: it is a
constraint, and the row moves rather than sitting at `Validated` in a register everyone downstream
reads as provisional. The row is kept here with its status only until the move is made.

**Dependencies.**

| ID | Depends on | Type | Owner | Needed by | Status |
|---|---|---|---|---|---|
| DEP-001 | Contractor portal data-quality remediation | Internal (Field Systems programme) | Programme Manager, Field Systems | FY26 Q4 | **At risk** — determination rests on attendance data of known imperfect quality. Raised as **R-115** |
| DEP-002 | Consumer contract v12 execution, carrying the clause 14.3 amendment | External | Contract Manager, Consumer | FY27 Q1 | Open |

**No risk table.** ASM-002's and DEP-001's exposures are `R-114` and `R-115` in the RAID log, which
is where a risk has an owner, a status and a review cadence. A risk table in this document would be
a snapshot that is wrong by sign-off and maintained nowhere.

#### 11 · Cost of failure ★

What is lost when an objective is not met, and it is what the ORD's tolerances are derived from:

| If this is not held | Consequence | Source |
|---|---|---|
| The rebate is not applied within two billing cycles | Breach of consumer contract clause 14.3, per affected customer | Consumer contract v11 |
| Determination stops when an attendance source is interrupted | 2,300 jobs went unreconciled in a 19-hour contractor portal outage | INC-5012 |
| The rebate is issued only on complaint | Unquantified population owed a credit and never paid | `[TBD — Regulatory Affairs, due 2026-08-15]` |

**Without this section the ORD has nothing to quantify against.** A tolerance traced to no
consequence is an invented figure, however well it is written.

**There is no cost–benefit table, and its absence is deliberate.** The benefit is BO-1's movement
from 1,840 to below 900 per quarter, already stated once at §4. A return figure here would be a
second number derived from the first, kept in step with it by hand, and disagreeing with it within
two revisions.

#### 12 · Traceability ★

**Stakeholder requirement → business objective.** Every requirement earns its place by serving one.

| Stakeholder req | Serves objective |
|---|---|
| BR-1 | BO-1, BO-2 |
| BR-2 | BO-2, BO-5 |
| BR-3 | BO-3 |
| BR-4 | BO-1 |
| — | **BO-4 — no stakeholder requirement.** The objective is real and unquantified; nobody has yet stated what they need in order to meet it |

**Business objective → ORD tolerance.** Every objective either produces operational demand or is
recorded as producing none.

| Objective | Via | Quantified as (ORD tolerance) |
|---|---|---|
| BO-1, BO-2 | BR-1 | ORD-03 **[KPP]** — rebate applied within two billing cycles |
| BO-1 | BR-1 | ORD-04 **[KPP]** — determination survives a 24-hour source interruption |
| BO-2 | BR-1 | ORD-15 — a missed appointment is determinable without re-keying |
| BO-2 | BR-2 | ORD-13 — rebate position established through an existing channel |
| BO-3 | BR-3 | ORD-10 — rebate parameters changed without a release |
| BO-5 | BR-2 | ORD-12 — rebate position reportable within 1 business day |
| BO-1 | BR-4 | **No tolerance yet.** Complaint-path exception handling not yet quantified |
| BO-4 | — | **No tolerance yet.** Blocked on the `[TBD]` at §11 |

**BO-4's blank appears in both tables, and that is the point.** Tracing only downward would show an
objective with no tolerance. Tracing only upward would show an objective nobody has stated a need
against. Both are true, and each is a different conversation with a different person. The full chain
onward to the SOAP and the acceptance criteria is on the [traceability matrix](#traceability).

#### Appendix A · Process and system scope ★

The L1–L3 process areas and the systems in scope, each with a named owner. **This is what makes the
ORD sizeable at assignment** — the impact counts that set S/M/L are read off it, and it seeds the
ORD's impact register.

| Kind | In scope | Owner |
|---|---|---|
| L1–L3 process | Order-to-Activate — appointment booking, field dispatch, attendance capture | Process owner, Field Operations |
| L1–L3 process | Bill-to-Cash — rebate determination and application | Process owner, Billing |
| L1–L3 process | Customer contact and complaint handling | Process owner, Customer Care |
| System | Workforce management platform | Application owner, Field Operations |
| System | Billing engine | Application owner, Billing |
| System | CRM / customer record | Application owner, Customer Care |
| System | Contractor portal | Application owner, Field Operations |
| System | Customer notification service | **Unowned — open** |

**The unowned system is recorded, not resolved.** The notification service appears in the estate
with its owning team vacant. That is a finding about Acme's ownership records rather than about this
change, and it is raised at sign-off — a referral needs a recipient, and there is not one.

**Sizing read from this appendix:** 3 business units, 5 objectives, **8 stakeholders** —
the §5 register's 9 rows less the affected-customer group, which is not consulted directly — and
9 impacted workflows and systems once the ORD's register is populated
(3 L1–L3 process areas resolving to 4 L4 workflows, plus 5 systems) — **Medium**.

#### Appendix B · References

Every source this BRD cites, in alphabetical order of the form it is cited as.

| Cited as | Full citation | Type |
|---|---|---|
| Billing operating model | Acme Communications (n.d.) *Billing operating model*, unpublished internal document | Internal record |
| Commercial Analytics (2026) | Acme Communications Commercial Analytics (2026) *Residential appointment volume analysis, 2023–24 to 2024–25*, unpublished internal report | Report |
| Consumer contract | Acme Communications (2025) *Consumer contract: standard terms*, version 7, unpublished | Contract |
| Field services agreement | Acme Communications and its field contractors (2024) *Field services agreement*, unpublished | Contract |
| INC-5012 | Acme Communications (2026) Incident record INC-5012, internal service management system | Internal record |
| Privacy Act | Privacy Act 1988 (Cth) | Legislation |

#### The handoff gate, applied to this document

Run against the [gate above](#brd). This is what a real assessment looks like — not a clean sheet.

| # | Verdict | Evidence |
|---|---|---|
| BH-1 | **Met, with one declared gap** | BO-1, BO-2, BO-3 and BO-5 each carry a baseline, a target and FY27 Q2. **BO-4 carries `[TBD]` with Regulatory Affairs and 2026-08-15** — a declared gap under the rule above: owned, dated, and not the objective the case rests on, with BO-1 fully quantified. It propagates rather than vanishing — §12 leaves its row empty, and so does the [traceability matrix](#traceability) |
| BH-2 | **Met** | No objective or stakeholder requirement names a system, workflow or figure. This BRD's §9 states four outcomes, and the four statements that would have breached the altitude are in its routing register instead |
| BH-3 | **Met, with one declared gap** | §10 — consumer contract cl 14.3, 14.5 and 14.6, field services agreement cl 9 and the billing-cycle boundary, each with its operational weight stated, and three categories recorded as *none found*. The privacy constraint is `[TBD]` with Legal Counsel and 2026-08-29; it propagates as an unquantified confidentiality tolerance in the ORD. DEP-001 and DEP-002 carry statuses, and DEP-001's exposure is `R-115` in the RAID log rather than a risk table here |
| BH-4 | **Met, with one declared gap** | §11 — three consequences, two sourced to the contract and INC-5012. The third is BO-4's, `[TBD]` with Regulatory Affairs and 2026-08-15; it is the same gap as BH-1's, propagating from the objective to its cost case |
| BH-5 | **Met** | §5, 9 rows with interest and role. Approval is not among them, by design — it is §6's |
| BH-6 | **Met** | §6, 3 rows against the 3 business units §8 puts in scope, each naming its GM and each Confirmed. The row count agrees with §8's scope and Appendix A's process owners |
| BH-7 | **Met** | §8, with the out-list explicit, Phase 1 named as this document's scope, and Phase 2 carrying its own Doc ID rather than a deferred section here |
| BH-8 | **Unowned gap** | Appendix A is complete **except the customer notification service, which has no owning team.** There is nobody to carry it, so it is neither met nor owned — the case the third outcome exists for |
| BH-9 | **Met** | §12, both directions. Upward: BR-1 – BR-4 each against the objective they serve, with BO-4's row explicitly blank rather than omitted. Downward: 6 objectives against ORD tolerances, with two explicit blanks — BO-4's, and BR-4's unquantified complaint-path demand. Tracing one direction would have found one of them |
| BH-10 | **Met** | §9, BR-1 – BR-4 at stakeholder altitude, each naming a stakeholder present at §5 and none naming a workflow, system or figure. The routing register carries four statements declined, one written back as ORD-04 and three awaiting a register — recorded, which is what this item asks, rather than resolved, which it does not |

> **Outcome: Accepted with an unowned gap.** The bar is met — BH-1 and BH-4 carry one declared gap
> between them, owned by Regulatory Affairs and dated, and BH-3 carries a second, owned by Legal
> Counsel and dated. BH-8 is the unowned one: it is carried
> forward into the ORD as entry criterion **E9 — Partial** and as **IMP-07**, raised with the
> approving GMs at sign-off rather than referred, and it stays open until someone accepts it.
> **That it stayed open is the finding** — about Acme's ownership records, not about this change.
>
> **Note what neither gap did.** Neither moved the maturity tier. The
> [worked example ORD](#example) commits **Tier B** because both KPPs are Provisional — the tier is
> the weakest status carried by any KPP-bearing requirement, and an unowned system in the estate is
> not one. A recorded gap drives the tier only where it reaches a KPP. Recording it and tier-driving
> it are two different things, and conflating them is how a gate becomes theatre.

---

*Standard of record: BABOK v3. Companion pages: the [ORD Intake and Maturity Standard](#purpose)
for operational demand, the [worked example ORD](#example) for what BRD-2026-041's objectives become
as tolerances, the [traceability matrix](#traceability) for the chain end to end, and the
[PRD standard](#prd) for the functional half — defined, and not adopted in this chain.*

---

<!-- from reference/ord-intake-standard.md -->

**Step 1 — size the change from the BRD.**

| Size | Indicators | Effort |
|---|---|---|
| **S — Small** | 1 business unit; 1–3 business objectives; change to an existing service; ≤4 stakeholders; **≤5 impacted workflows and systems combined**; no cross-program dependency; rules already settled | ~4 effort days |
| **M — Medium** | 2–3 business units; 4–6 objectives; ≤8 stakeholders; **6–15 impacted workflows and systems**; one or two cross-program dependencies; some rules to resolve | ~6 effort days |
| **L — Large** | Multiple business units or programs; novel capability; material regulatory or contractual exposure; >8 stakeholders; **more than 15 impacted workflows and systems, or systems owned by different programs**; cross-program conflicts requiring adjudication | ~9 effort days |

**On the impact counts.** They are indicative bands in the same spirit as the stakeholder and objective counts, not measured thresholds. At assignment the count is an estimate read off the BRD's L1–L3 scope; it firms up during document analysis on effort days 2–3, which is the first point at which the register is populated rather than guessed. **A count that lands in a different band than the one assumed is a re-size trigger**, not a variance to absorb: re-read §4.1 and §4.7.3 from the days remaining, and record the change under §3.3. Owner count matters as much as item count — fifteen workflows under two process owners is a smaller elicitation than six under six.

These are **collection effort only** — the §4.5 sequence. Refinement is deducted separately (§4.3) rather than carried inside them, because it behaves differently and is present on some engagements and not others.
