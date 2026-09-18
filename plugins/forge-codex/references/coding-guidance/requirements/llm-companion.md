# Requirements — LLM Companion

> Governs the **machine-readable companion** a requirements skill writes beside the document it
> authors. Applies to `$write-brd` and `$write-ord`. Pairs with [language.md](language.md) and
> [tables.md](tables.md), neither of which is relaxed here. Read the scope boundary in
> [README.md](README.md) first.

## What it is

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

## The Rule

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

## Why a separate file

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

## Structure

Five sections, in this order, after YAML front matter.

### Front matter

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
generator: [$write-brd or $write-ord, with the skill version]
authoritative: false
---
```

`source_sha256` is computed from the saved file with a shell hash — `shasum -a 256` or
`sha256sum`. Where no shell is available, write `unavailable`; never estimate or invent one. It is
how a later reader detects a companion gone stale against an edited document.

### 1. How to read this document

Copy this block verbatim, substituting only `[BRD|ORD]`, the document file name and the doc ID.

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
construction bans in [language.md](language.md) govern the records, not this block.

### 2. Vocabulary

**Only the terms this document uses.** For each ID prefix, `Status` value, scenario value, marker
(`[AI]`, `[KPP]`, `[TBD]`, `[EVL-TBD]`, `[D-TBD]`) and enum that occurs in the records, one line
giving its meaning, taken from [tables.md](tables.md), [ai.md](ai.md) or [reporting.md](reporting.md).
A term that does not occur is not listed.

### 3. Open items

One line per unanswered item, in ID order, each naming the record or section it sits in:

- every `[TBD]`, `[EVL-TBD]`, `[D-TBD]` and `[SYSTEM-NAME-TBD]`, with its owner and date where the
  document gives them
- every `Unowned — open` row
- every `Assumed` or `Provisional` requirement, and every `Unvalidated` or `Falsified` assumption
- every coverage gap and every referred requirement with `Resolver group: None in chain`

Where there are none, write `None.` — never omit the section. An empty index and a missing one are
different claims.

### 4. Context

Every prose section of the document, **copied verbatim** under its original number and heading, in
document order. Prose is not condensed: a summary is a reworded source.

### 5. Records

One block per table row, grouped under a heading per table in document order.

```markdown
### ORD-003 — Restore service within one business day

- table: 3.2 Reliability — requirement register
- ver: 1.0
- business_tolerance: Service is restorable within one business day, beyond which …
- kpp: [KPP] — threshold: … · objective: …
- moscow: Must
- status: Committed
- owner: …
- source: …
- traces_to: OBJ-002 → BO-1 via BR-2
- scenarios: SCN-004, SCN-005, SCN-006
```

- **The key is the row's ID.** An ID-less row — an actor, a constraint, a coverage gap, an
  exclusion — is keyed by its table's first column, prefixed with the section number.
- **Field names are the document's column names** in lower snake case. Every column is written,
  including one the document leaves blank: `(blank in document)`. A missing field reads as a
  column that does not exist.
- **A table keyed by another record's ID is folded into that record**, never emitted as a second
  record under the same ID — traceability (BRD §12, ORD Appendix A) becomes `traces_to`, interface
  detail becomes an `interface` sub-list, scenarios are listed on the requirement they examine and
  also stand as their own `SCN-NNN` records. A fold adds a link, never a value.
- **View tables are not emitted.** A table the document declares a view — ORD §7, §2.5 — restates
  IDs it does not own. Name each omitted view in one line at the head of section 5.
- **Plain text only.** No HTML, no emoji, no decorative glyphs, no merged or multi-line cells. A
  glyph the document uses to mark meaning — ★ on a BRD section — becomes the word it stands for.

## Integrity check

Before saving the companion, count the table rows in the document and the records in section 5, less
the rows folded into another record. The two agree, or the companion is not saved. Report both counts
in the skill's closing summary:

> `Companion: docs/ord/[name]-ORD.llm.md — 47 rows, 47 records, 12 open items, 2 views omitted.`

## Regeneration

**The companion is regenerated every time the document changes** — never edited by hand. Both
skills accept `--llm-only [document path]`, which reads an existing document and rewrites its
companion without running any phase. A companion whose `source_sha256` does not match its document is
stale, and the fix is regeneration, not an edit.

## Never

- Never generate the companion before the document is saved, or from anything but the saved file.
- Never reword, summarise, merge, correct or reorder a value's content — restructure only.
- Never fill a `[TBD]`, an owner, a date or a blank cell in the companion. A gap is carried and indexed.
- Never add a value, a requirement, a link or a claim the document does not carry.
- Never drop a row. Rows and records reconcile, or the companion is not saved.
- Never carry gate verdicts, review findings or the Phase 1 summary — they are not in the document.
- Never hand-edit a companion, and never treat one as the reviewed artefact.
- Never estimate `source_sha256` — compute it, or write `unavailable`.
- Never emit a view table as records — name it and omit it.
