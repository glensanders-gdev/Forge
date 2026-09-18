"""Tests for write-ord/scripts/llm_companion.py.

Run: python3 -m unittest discover -s tools/tests -v

The fixtures are synthetic on purpose. The requirements pack the script was first run against
is held locally and is not in this repo, so CI can only exercise what lives here. Each fixture
row exists to hit one clause of rules/requirements/llm-companion.md.
"""
import contextlib
import hashlib
import importlib.util
import io
import sys
import tempfile
import unittest
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
SCRIPT = REPO / "global" / ".claude" / "skills" / "write-ord" / "scripts" / "llm_companion.py"

# Importing the script would write __pycache__/ into the skill folder, and the Codex and standalone
# builds copy a skill folder whole — CI then fails on untracked generated output.
sys.dont_write_bytecode = True
_spec = importlib.util.spec_from_file_location("llm_companion", SCRIPT)
llm = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(llm)

ORD = """# Operational Requirements Document

## Widget Returns — Example Co

**Document version:** 1.2 · **Date:** 2026-09-01 · **Status:** Draft
**ORD convenor:** [name]

> ### Maturity tier: B — Provisional

Must-have items are listed below.

### 1.2 Objectives

| ID | Objective | Baseline | Target | Target date | Traces to |
|---|---|---|---|---|---|
| OBJ-01 | A returned widget is refunded without contact | [TBD — GM Returns, due 2026-10-01] | 90% | FY27 Q1 | ORD-01, ORD-02 |

The baseline is a declared gap carrying an owner
and a confirm-by date.

### 2.2 Impact register

| Ref | Kind | Impacted item | Owner |
|---|---|---|---|
| IMP-01 | System | Returns portal | **Unowned — open** |

### 3.2 Reliability

| Ref | Ver | Requirement title | Business tolerance | KPP | Status | Owner | Source |
|---|---|---|---|---|---|---|---|
| ORD-01 | 1.0 | Refund a return within one cycle | A refund is applied within one billing cycle. **Threshold:** one cycle. **Objective:** five days | **[KPP]** | Provisional | GM Returns | Contract cl. 4 \\| schedule B |
| ORD-02 | 1.0 | Prevent a duplicate refund | No customer receives a duplicate refund | | Committed | GM Returns | Contract cl. 5 |

### Requirement status summary

| Status | Count |
|---|---|
| Provisional | 1 |
| Committed | 1 |

### 4. ★ Constraints

| Constraint | Type |
|---|---|
| Contract cl. 4<br>Contract cl. 5 | Contractual |

## 7. Service level requirements

*View of §3. Values are authoritative in the referenced rows; this table adds no new commitments.*

| Ref | Tolerance | Obligation |
|---|---|---|
| ORD-01 | Refund within one cycle, view only | Contract cl. 4 |

## 9. Open questions

| ID | Question | Owner | Due |
|---|---|---|---|
| OQ-01 | Does the cycle run from receipt? | Legal | 2026-09-30 |

## Appendix A — Traceability

| ORD ref | Traces to | Orphan? |
|---|---|---|
| ORD-01 [KPP] | BO-1 via BR-1 | No |

## Appendix C — Referred requirements

| Ref | Requirement | Resolver group | Status |
|---|---|---|---|
| REF-01 | Refund eligibility rules | **None in chain** | **Referred, not accepted** |

## Appendix E — Scenarios

| ID | Ref | Condition | Outcome | Situation | Expected end state |
|---|---|---|---|---|---|
| SCN-01 | ORD-01 | Sunny Day | Favourable | Return received | Refund applied |

```text
| not | a table |
```
"""

BRD = """# BRD-2026-007 — Widget returns

**Doc ID:** BRD-2026-007 · **Version:** 1.0 · **Status:** Draft

## 4. Business objectives

| ID | Objective | Baseline | Target | By |
|---|---|---|---|---|
| BO-1 | Returns are refunded without contact | 0% | 90% | FY27 Q2 |
"""

DATE = "2026-09-18"


class CompanionTestCase(unittest.TestCase):
    def setUp(self):
        self._tmp = tempfile.TemporaryDirectory()
        self.dir = Path(self._tmp.name)

    def tearDown(self):
        self._tmp.cleanup()

    def write_doc(self, name, text):
        path = self.dir / name
        path.write_bytes(text.encode("utf-8"))
        return path

    def run_script(self, *args):
        out, err = io.StringIO(), io.StringIO()
        with contextlib.redirect_stdout(out), contextlib.redirect_stderr(err):
            code = llm.main([str(a) for a in args])
        return code, out.getvalue(), err.getvalue()

    def generate(self, name="Widget-ORD.md", text=ORD):
        doc = self.write_doc(name, text)
        code, out, err = self.run_script(doc, "--date", DATE, "--generator", "/write-ord test")
        self.assertEqual(code, 0, err)
        companion = doc.with_name(doc.stem + ".llm.md")
        return doc, companion.read_text(encoding="utf-8"), out

    def record(self, companion, heading):
        start = companion.index(f"#### {heading}\n")
        end = companion.find("\n#### ", start + 1)
        return companion[start:end if end != -1 else None]

    def section(self, companion, title):
        start = companion.index(f"## {title}")
        end = companion.find("\n## ", start + 1)
        return companion[start:end if end != -1 else None]


class WritesTheCompanion(CompanionTestCase):
    def test_writes_beside_the_document_with_llm_before_the_extension(self):
        doc, _, out = self.generate()
        self.assertTrue((self.dir / "Widget-ORD.llm.md").is_file())
        self.assertIn("Companion:", out)
        self.assertIn(str(doc.with_name("Widget-ORD.llm.md")), out)

    def test_honours_an_explicit_output_path(self):
        doc = self.write_doc("Widget-ORD.md", ORD)
        target = self.dir / "elsewhere" / "view.llm.md"
        target.parent.mkdir()
        code, _, err = self.run_script(doc, "--out", target, "--date", DATE)
        self.assertEqual(code, 0, err)
        self.assertIn("companion_of: ../Widget-ORD.md", target.read_text(encoding="utf-8"))

    def test_output_uses_lf_line_endings_on_every_platform(self):
        self.generate()
        raw = (self.dir / "Widget-ORD.llm.md").read_bytes()
        self.assertNotIn(b"\r\n", raw)

    def test_same_document_and_date_give_identical_output(self):
        _, first, _ = self.generate()
        _, second, _ = self.generate()
        self.assertEqual(first, second)

    def test_reports_rows_records_folds_views_and_open_items(self):
        _, _, out = self.generate()
        # 12 rows = 10 records (OBJ, IMP, 2 ORD, 2 summary, constraint, OQ, REF, SCN)
        #         + 1 folded (Appendix A) + 1 view row (§7)
        self.assertIn("12 rows, 10 records, 1 folded, 1 view(s) omitted (1 rows)", out)


class FrontMatter(CompanionTestCase):
    def test_carries_metadata_read_from_the_document_header(self):
        _, companion, _ = self.generate()
        front = companion.split("---\n", 2)[1]
        self.assertIn("doc_type: ORD", front)
        self.assertIn('title: "Widget Returns — Example Co"', front)
        self.assertIn('version: "1.2"', front)
        self.assertIn('status: "Draft"', front)
        self.assertIn('tier: "B — Provisional"', front)
        self.assertIn("generated: 2026-09-18", front)
        self.assertIn("generator: /write-ord test", front)
        self.assertIn("authoritative: false", front)

    def test_hash_is_the_sha256_of_the_saved_document(self):
        doc, companion, _ = self.generate()
        digest = hashlib.sha256(doc.read_bytes()).hexdigest()
        self.assertIn(f"source_sha256: {digest}", companion)

    def test_an_unstated_field_is_marked_rather_than_invented(self):
        _, companion, _ = self.generate()
        self.assertIn('doc_id: "[not stated in document]"', companion)

    def test_a_brd_is_recognised_and_its_doc_id_read(self):
        _, companion, _ = self.generate("Widget-BRD.md", BRD)
        self.assertIn("doc_type: BRD", companion)
        self.assertIn('doc_id: "BRD-2026-007"', companion)
        self.assertNotIn("tier:", companion.split("---\n", 2)[1])
        self.assertIn("machine-readable view of BRD BRD-2026-007", companion)


class Records(CompanionTestCase):
    def test_a_register_row_is_keyed_by_its_id_and_titled(self):
        _, companion, _ = self.generate()
        rec = self.record(companion, "ORD-01 — Refund a return within one cycle")
        self.assertIn("- table: 3.2 Reliability", rec)
        self.assertIn("- requirement_title: Refund a return within one cycle", rec)
        self.assertIn("- status: Provisional", rec)

    def test_values_are_copied_with_emphasis_stripped_and_words_unchanged(self):
        _, companion, _ = self.generate()
        rec = self.record(companion, "ORD-01 — Refund a return within one cycle")
        self.assertIn("- business_tolerance: A refund is applied within one billing cycle. "
                      "Threshold: one cycle. Objective: five days", rec)
        self.assertIn("- kpp: [KPP]", rec)

    def test_an_escaped_pipe_stays_inside_its_cell(self):
        _, companion, _ = self.generate()
        rec = self.record(companion, "ORD-01 — Refund a return within one cycle")
        self.assertIn("- source: Contract cl. 4 | schedule B", rec)

    def test_a_blank_cell_is_written_rather_than_dropped(self):
        _, companion, _ = self.generate()
        rec = self.record(companion, "ORD-02 — Prevent a duplicate refund")
        self.assertIn("- kpp: (blank in document)", rec)

    def test_an_id_less_row_is_keyed_by_section_and_first_column(self):
        _, companion, _ = self.generate()
        self.assertIn("#### §4 — Contract cl. 4; Contract cl. 5\n", companion)

    def test_decorative_glyphs_and_html_become_plain_text(self):
        _, companion, _ = self.generate()
        self.assertNotIn("★", companion)
        self.assertIn("### Table: 4. [often-missing section] Constraints", companion)
        self.assertNotIn("<br>", self.section(companion, "5. Records"))

    def test_a_record_lists_the_records_that_reference_it(self):
        _, companion, _ = self.generate()
        rec = self.record(companion, "ORD-01 — Refund a return within one cycle")
        self.assertIn("- referenced_by: OBJ-01, SCN-01", rec)
        unreferenced = self.record(companion, "IMP-01")
        self.assertIn("- referenced_by: (none in document)", unreferenced)


class FoldsAndViews(CompanionTestCase):
    def test_a_table_keyed_to_existing_records_is_folded_with_every_column(self):
        _, companion, _ = self.generate()
        rec = self.record(companion, "ORD-01 — Refund a return within one cycle")
        self.assertIn("- traceability:\n  - ord_ref: ORD-01 [KPP]\n  - traces_to: BO-1 via BR-1\n"
                      "  - orphan: No", rec)
        self.assertNotIn("#### ORD-01 [KPP]", companion)

    def test_a_record_with_no_row_in_a_folded_table_says_so(self):
        _, companion, _ = self.generate()
        rec = self.record(companion, "ORD-02 — Prevent a duplicate refund")
        self.assertIn("- traceability: (no row in document)", rec)

    def test_a_declared_view_is_named_and_not_emitted(self):
        _, companion, _ = self.generate()
        self.assertIn("Views omitted: 7. Service level requirements (1 rows).", companion)
        self.assertNotIn("Refund within one cycle, view only", self.section(companion, "5. Records"))


class OpenItems(CompanionTestCase):
    def open_items(self):
        _, companion, _ = self.generate()
        return self.section(companion, "3. Open items")

    def test_declared_gaps_and_unowned_rows_are_indexed(self):
        items = self.open_items()
        self.assertIn("- OBJ-01 — baseline: [TBD — GM Returns, due 2026-10-01]", items)
        self.assertIn("- IMP-01 — owner: Unowned — open", items)

    def test_unagreed_statuses_open_questions_and_unresolved_referrals_are_indexed(self):
        items = self.open_items()
        self.assertIn("- ORD-01 — status: Provisional", items)
        self.assertIn("- OQ-01 — open question", items)
        self.assertIn("- REF-01 — resolver_group: None in chain · status: Referred, not accepted", items)

    def test_committed_rows_and_status_counts_are_not_open(self):
        items = self.open_items()
        self.assertNotIn("ORD-02", items)
        self.assertNotIn("Requirement status summary", items)

    def test_a_prose_gap_is_quoted_as_one_whole_sentence_across_wrapped_lines(self):
        items = self.open_items()
        self.assertIn('"The baseline is a declared gap carrying an owner and a confirm-by date."', items)

    def test_a_placeholder_in_prose_is_indexed(self):
        self.assertIn("[name]", self.open_items())

    def test_an_ord_without_a_doc_id_is_not_a_gap_but_a_brd_without_one_is(self):
        self.assertNotIn("Doc ID", self.open_items())
        _, companion, _ = self.generate("Widget-BRD.md", BRD.replace("**Doc ID:** BRD-2026-007 · ", ""))
        self.assertIn("- Doc ID — the document states none.", self.section(companion, "3. Open items"))

    def test_a_document_with_nothing_open_says_none(self):
        _, companion, _ = self.generate("Widget-BRD.md", BRD)
        self.assertIn("## 3. Open items\n\nUnanswered in the document. Do not fill any of these.\n\nNone.",
                      companion)


class VocabularyAndContext(CompanionTestCase):
    def test_vocabulary_lists_only_terms_the_document_uses(self):
        _, companion, _ = self.generate()
        vocab = self.section(companion, "2. Vocabulary")
        for present in ("`ORD-N`", "`SCN-N`", "`Sunny Day`", "`[KPP]`", "`None in chain`"):
            self.assertIn(present, vocab)
        for absent in ("`EVL-N`", "`Rainy Day`", "`[AI]`"):
            self.assertNotIn(absent, vocab)

    def test_an_unknown_prefix_is_named_as_local_to_the_document(self):
        _, companion, _ = self.generate()
        self.assertIn("- `OQ-N` — ID prefix used by this document; not in the shared ID namespace.",
                      companion)

    def test_must_is_defined_only_where_a_moscow_column_exists(self):
        _, companion, _ = self.generate()
        self.assertNotIn("`Must`", self.section(companion, "2. Vocabulary"))
        with_moscow = ORD.replace("| Ref | Kind | Impacted item | Owner |\n|---|---|---|---|",
                                  "| Ref | Kind | Impacted item | Owner | MoSCoW |\n|---|---|---|---|---|")
        with_moscow = with_moscow.replace("| **Unowned — open** |", "| **Unowned — open** | Must |")
        _, companion, _ = self.generate(text=with_moscow)
        self.assertIn("`Must`", self.section(companion, "2. Vocabulary"))

    def test_prose_is_copied_verbatim_under_its_heading(self):
        _, companion, _ = self.generate()
        context = self.section(companion, "4. Context")
        self.assertIn("### 1.2 Objectives\n\nThe baseline is a declared gap carrying an owner\n"
                      "and a confirm-by date.", context)
        self.assertIn("> ### Maturity tier: B — Provisional", context)

    def test_a_pipe_line_inside_a_code_fence_is_prose_not_a_table(self):
        _, companion, _ = self.generate()
        self.assertIn("```text\n| not | a table |\n```", self.section(companion, "4. Context"))
        self.assertNotIn("- not: a table", companion)


class Refusals(CompanionTestCase):
    def test_a_missing_document_is_refused(self):
        code, _, err = self.run_script(self.dir / "absent-ORD.md")
        self.assertEqual(code, 1)
        self.assertIn("REFUSED: no document", err)

    def test_a_table_without_a_separator_row_is_refused_and_nothing_written(self):
        doc = self.write_doc("Broken-ORD.md", "# ORD\n\n## 3.1 X\n\n| Ref | Tolerance |\n| ORD-01 | y |\n")
        code, _, err = self.run_script(doc)
        self.assertEqual(code, 1)
        self.assertIn("no header separator row", err)
        self.assertFalse((self.dir / "Broken-ORD.llm.md").exists())

    def test_a_value_that_did_not_arrive_is_refused(self):
        doc = self.write_doc("Widget-ORD.md", ORD)
        companion, stats, blocks, tables = llm.assemble(str(doc), str(doc) + ".out", ORD, "t", DATE)
        tampered = companion.replace("No customer receives a duplicate refund", "No duplicate refunds")
        with self.assertRaisesRegex(llm.Refusal, "did not reach the companion verbatim"):
            llm.verify(tampered, stats, blocks, tables)

    def test_rows_that_do_not_reconcile_are_refused(self):
        doc = self.write_doc("Widget-ORD.md", ORD)
        companion, stats, blocks, tables = llm.assemble(str(doc), str(doc) + ".out", ORD, "t", DATE)
        with self.assertRaisesRegex(llm.Refusal, "rows 12 ≠ records 9"):
            llm.verify(companion, dict(stats, records=stats["records"] - 1), blocks, tables)

    def test_a_refusal_leaves_an_existing_companion_untouched(self):
        doc = self.write_doc("Broken-ORD.md", "# ORD\n\n| Ref | Tolerance |\n| ORD-01 | y |\n")
        existing = self.dir / "Broken-ORD.llm.md"
        existing.write_text("previous companion", encoding="utf-8")
        code, _, _ = self.run_script(doc)
        self.assertEqual(code, 1)
        self.assertEqual(existing.read_text(encoding="utf-8"), "previous companion")


if __name__ == "__main__":
    unittest.main()
