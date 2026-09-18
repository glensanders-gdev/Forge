#!/usr/bin/env python3
"""Generate the LLM companion for a saved BRD or ORD.

Implements rules/requirements/llm-companion.md mechanically, so every value reaches the
companion by copy rather than by retyping:

    python3 llm_companion.py docs/ord/Rebate-ORD.md --generator "/write-ord 2.2.0"

Writes <doc>.llm.md beside the document (or --out). Before writing, it proves the result:
every table row is a record, a fold or a declared view row, and every prose line and data
cell of the document appears in the companion. Exit 0 = written; exit 1 = refused, with
the reason. Nothing is written on a refusal.

Standard library only. Python 3.8+.
"""
import argparse
import datetime
import hashlib
import os
import re
import sys

ID_RE = re.compile(r"\b(?:[A-Z]{2,4}-\d{1,4}|BRD-\d{4}-\d{3})\b")
KEY_ID_RE = re.compile(r"^(?:[A-Z]{2,4}-\d{1,4}|BRD-\d{4}-\d{3})$")
HEADING_RE = re.compile(r"^(#{1,6}) (.*)$")
SEPARATOR_RE = re.compile(r"^\|[\s:|-]+\|\s*$")
VIEW_RE = re.compile(r"view of|adds no new commitments", re.IGNORECASE)
STAR = "★"
STAR_WORD = "[often-missing section]"

HOW_TO_READ = """## 1. How to read this document

This file is a machine-readable view of {doc_type} {doc_ref}, generated from `{file_name}`. It is
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
"""

# Vocabulary: emitted only where the term occurs. Definitions follow rules/requirements.
PREFIXES = {
    "BO": "business objective in a BRD — the outcome the money is spent for, with baseline, target and date",
    "BR": "business requirement in a BRD — a named stakeholder's need stated as an outcome",
    "PRD": "functional requirement or user story in a PRD",
    "CON": "solution constraint — a demand-side given (regulatory, contractual, mandated integration)",
    "ORD": "operational requirement — a quantified business tolerance; the binding statements of an ORD",
    "AC": "acceptance criterion",
    "OBJ": "operational objective — the outcome layer between a BRD objective and a requirement",
    "BRL": "business rule — the business decision a rule makes, not its logic",
    "SCN": "scenario — one requirement examined under one condition",
    "IMP": "impact — a workflow or system the change touches, with its owner; identification only",
    "REF": "referred requirement — raised here, not delivered by this document, handed to a named recipient",
    "DAT": "data element over a reported measure, with its ISO/IEC 25012 quality characteristic",
    "ASM": "assumption — with its consequence if false, an owner and a confirm-by date",
    "DEP": "dependency — with owner, needed-by and status",
    "EVL": "evaluation set for learned or generated behaviour",
    "MDL": "model or provider dependency",
    "R": "risk in the RAID log",
    "D": "decision in the RAID log",
}
TERMS = [
    ("Committed", "the business owner has agreed the tolerance and it traces to a source"),
    ("Provisional", "sourced from evidence; no owner has yet confirmed it applies here — not agreed"),
    ("Assumed", "rests on a stated assumption with an owner and a confirm-by date — not agreed"),
    ("[KPP]", "Key Performance Parameter: failure is failure of the change, not degradation. Carries threshold (minimum acceptable) and objective (desired)"),
    ("[AI]", "the row governs learned or generated behaviour and follows the AI requirements ruleset"),
    ("[TBD", "a declared gap: the value is not known. Never fill it"),
    ("[EVL-TBD", "the threshold is known; the evaluation set that proves it is not yet numbered"),
    ("[D-TBD", "a decision raised but not yet numbered in the RAID log"),
    ("Unowned — open", "no owner exists in the records. A finding, not a blank"),
    ("Sunny Day", "scenario condition: everything available and behaving"),
    ("Rainy Day", "scenario condition: something failing — dependency down, timeout, refusal"),
    ("Edge Case", "scenario condition: a valid boundary — empty, maximum, expired, first, last"),
    ("Favourable", "outcome on a Sunny Day: the thing measured passes"),
    ("Adverse", "outcome on a Sunny Day: the capability worked and the answer is unfavourable — not a failure"),
    ("None in chain", "no resolver group exists to receive the referred requirement; the row stays open"),
    ("Referred, not accepted", "referred to a named recipient who has not accepted it"),
    ("No change required", "impact treatment: identified and assessed as needing nothing"),
    ("Out of scope", "excluded from this document, deliberately"),
    ("Unvalidated", "assumption status: not yet confirmed"),
    ("Falsified", "assumption status: shown untrue; carried to the RAID log as a risk"),
    ("At risk", "dependency status: may not be met by its needed-by date"),
    ("Must", "MoSCoW priority value — a controlled priority, not a hedge"),
    ("SOAP", "Solution on a Page — solution architecture's response to the ORD"),
    ("pending", "not yet answered; completed at a later stage"),
    ("Tier", "the weakest Status carried by any KPP-bearing requirement"),
]
OPEN_VALUES = ("assumed", "provisional", "unvalidated", "falsified", "open", "at risk",
               "partial", "absent", "referred, not accepted", "pending", "unresolved")
OPEN_COLUMNS = ("status", "conformance", "soap response")
OPEN_MARKERS = ("[TBD", "[EVL-TBD", "[D-TBD", "[R-TBD", "[SYSTEM-NAME-TBD]", "Unowned — open",
                "None in chain")
PROSE_GAP_RE = re.compile(r"declared gap|remain open", re.IGNORECASE)
PLACEHOLDER_RE = re.compile(r"\[(?:name|owner|date|role|system name)\]", re.IGNORECASE)


class Refusal(Exception):
    """The companion cannot be proven faithful; nothing is written."""


# ------------------------------------------------------------------ parsing --

def split_cells(row):
    body = row.strip()
    body = body[1:] if body.startswith("|") else body
    body = body[:-1] if body.endswith("|") and not body.endswith("\\|") else body
    return [c.strip().replace("\\|", "|") for c in re.split(r"(?<!\\)\|", body)]


def parse_blocks(lines):
    """Split into (heading, kind, lines). Fenced code and blockquotes are prose."""
    blocks, heading, buf, kind, fenced = [], "(document header)", [], None, False

    def flush():
        if buf:
            blocks.append((heading, kind, list(buf)))
        buf.clear()

    for ln in lines:
        if ln.lstrip().startswith("```"):
            fenced = not fenced
        m = None if fenced else HEADING_RE.match(ln)
        if m:
            flush()
            kind, heading = None, m.group(2).strip()
            continue
        k = "table" if (not fenced and ln.startswith("|")) else "prose"
        if kind and k != kind:
            flush()
        kind = k
        buf.append(ln)
    flush()
    return blocks


def build_tables(blocks):
    tables, prev_prose = [], {}
    for heading, kind, body in blocks:
        if kind == "prose":
            prev_prose[heading] = "\n".join(body)
            continue
        if len(body) < 2 or not SEPARATOR_RE.match(body[1]):
            raise Refusal(f"table under '{heading}' has no header separator row")
        tables.append({
            "heading": heading,
            "hdr": split_cells(body[0]),
            "rows": [split_cells(r) for r in body[2:]],
            "lead": prev_prose.get(heading, ""),
        })
        prev_prose[heading] = ""
    return tables


# ------------------------------------------------------------------ helpers --

def clean(value):
    value = value.replace("**", "").replace("<br>", "; ").replace(STAR, STAR_WORD)
    value = re.sub(r"(?<![\w*])\*([^*]+)\*(?![\w*])", r"\1", value).strip()
    return value or "(blank in document)"


def snake(header):
    header = clean(header) if header.strip() else ""
    if not header or header == "(blank in document)":
        return "ref"
    if header == "#":
        return "entry"
    return re.sub(r"[^a-z0-9]+", "_", header.lower()).strip("_") or "ref"


def row_key(row):
    first = clean(row[0]) if row else ""
    token = first.split()[0] if first.split() else ""
    return token if KEY_ID_RE.match(token) else None


def section_prefix(heading):
    m = re.match(r"^(\d+(?:\.\d+)*)\.?\s", heading)
    if m:
        return "§" + m.group(1)
    m = re.match(r"^(Appendix [A-Z])\b", heading)
    return m.group(1) if m else clean(heading)


def fold_name(heading):
    tail = heading.split("—", 1)[1] if "—" in heading else re.sub(r"^[\d.]+\s*", "", heading)
    return snake(tail)


# ------------------------------------------------------------------- roles --

def assign_roles(tables):
    defined = set()
    for t in tables:
        keys = [row_key(r) for r in t["rows"]]
        if VIEW_RE.search(t["lead"].splitlines()[-1] if t["lead"].strip() else ""):
            t["role"] = "view"
        elif t["rows"] and all(k and k in defined for k in keys):
            t["role"] = "fold"
        else:
            t["role"] = "records"
            defined.update(k for k in keys if k)
    return defined


def title_column(hdr):
    for i, h in enumerate(hdr):
        if i and re.search(r"title|^objective$", clean(h), re.IGNORECASE):
            return i
    return None


def label_tables(tables):
    seen = {}
    for t in tables:
        seen.setdefault(t["heading"], []).append(t)
    for heading, group in seen.items():
        for t in group:
            label = clean(heading)
            if len(group) > 1:
                label += " — " + clean(t["hdr"][0]) + " table"
            t["label"] = label


# ----------------------------------------------------------------- records --

def build_records(tables):
    records, folds = [], {}
    for t in tables:
        if t["role"] == "fold":
            name = fold_name(t["heading"])
            for r in t["rows"]:
                folds.setdefault(row_key(r), []).append((name, t["hdr"], r))
    for t in tables:
        if t["role"] != "records":
            continue
        tcol = title_column(t["hdr"])
        for r in t["rows"]:
            key = row_key(r)
            if key:
                title = f" — {clean(r[tcol])}" if tcol is not None and tcol < len(r) else ""
                heading = key + title
            else:
                heading = f"{section_prefix(t['heading'])} — {clean(r[0]) if r else '—'}"
            records.append({"key": key, "heading": heading, "table": t, "row": r})
    return records, folds


def backlinks(records):
    keyed = {r["key"] for r in records if r["key"]}
    refs = {}
    for rec in records:
        if not rec["key"]:
            continue
        for cell in rec["row"][1:]:
            for target in set(ID_RE.findall(cell)):
                if target in keyed and target != rec["key"]:
                    refs.setdefault(target, []).append(rec["key"])
    return refs


def render_record(rec, folds, refs, fold_names_by_prefix):
    t, r = rec["table"], rec["row"]
    out = [f"#### {rec['heading']}", "", f"- table: {t['label']}"]
    cells = r + [""] * (len(t["hdr"]) - len(r))
    out += [f"- {snake(h)}: {clean(v)}" for h, v in zip(t["hdr"], cells)]
    key = rec["key"]
    if key:
        linked = sorted(set(refs.get(key, [])), key=natural)
        out.append(f"- referenced_by: {', '.join(linked) if linked else '(none in document)'}")
        present = set()
        for name, hdr, fr in folds.get(key, []):
            present.add(name)
            out.append(f"- {name}:")
            out += [f"  - {snake(h)}: {clean(v)}" for h, v in zip(hdr, fr)]
        for name in fold_names_by_prefix.get(key.split("-")[0], []):
            if name not in present:
                out.append(f"- {name}: (no row in document)")
    return out + [""]


def natural(key):
    return [int(p) if p.isdigit() else p for p in re.split(r"(\d+)", key)]


# -------------------------------------------------------------- open items --

def open_items(records, blocks, meta):
    items = []
    if meta["doc_id"] is None and meta["doc_type"] == "BRD":
        items.append("Doc ID — the document states none.")
    for rec in records:
        hdr, row = rec["table"]["hdr"], rec["row"]
        name = rec["key"] or rec["heading"]
        found = []
        for h, v in list(zip(hdr, row))[1:]:
            value = clean(v)
            if any(m in value for m in OPEN_MARKERS):
                found.append(f"{snake(h)}: {value}")
            elif any(c in clean(h).lower() for c in OPEN_COLUMNS) and value.lower().startswith(OPEN_VALUES):
                found.append(f"{snake(h)}: {value}")
        if not found and any("question" == clean(h).lower() for h in hdr):
            found.append("open question")
        if found:
            items.append(f"{name} — " + " · ".join(found))
    for heading, kind, body in blocks:
        if kind != "prose":
            continue
        for sentence in prose_sentences(body):
            if PROSE_GAP_RE.search(sentence) or "[TBD" in sentence or PLACEHOLDER_RE.search(sentence):
                items.append(f"{section_prefix(heading)} (prose) — \"{sentence}\"")
    return items


def prose_sentences(body):
    """Paragraphs rejoined across hard wraps, then split into sentences. Quoted, not reworded."""
    paragraphs, current = [], []
    for ln in body:
        text = ln.strip().lstrip(">").strip()
        if not text or text.startswith(("- ", "* ")) or text == "---":
            if current:
                paragraphs.append(" ".join(current))
            current = [text[2:]] if text.startswith(("- ", "* ")) else []
            continue
        current.append(text)
    if current:
        paragraphs.append(" ".join(current))
    for para in paragraphs:
        for sentence in re.split(r"(?<=[.!?])\s+(?=[A-Z*])", para):
            if sentence.strip():
                yield sentence.strip()


# --------------------------------------------------------------- metadata --

def first_match(pattern, text):
    m = re.search(pattern, text)
    return clean(m.group(1)).strip(" ·") if m else None


def read_meta(text, path):
    head = "\n".join(text.splitlines()[:40])
    doc_type = "BRD" if re.search(r"\bBRD\b", os.path.basename(path)) or re.search(
        r"Business Requirements Document|\*\*Doc ID:\*\*\s*BRD-", head) else "ORD"
    titles = [m.group(2).strip() for m in map(HEADING_RE.match, head.splitlines()) if m]
    generic = re.compile(r"^(Operational|Business) Requirements Document$", re.IGNORECASE)
    title = next((clean(t) for t in titles if not generic.match(t)), clean(titles[0]) if titles else "")
    return {
        "doc_type": doc_type,
        "doc_id": first_match(r"\*\*Doc ID:\*\*\s*([A-Z]+-\d{4}-\d{3})", head),
        "title": title,
        "version": first_match(r"\*\*(?:Document )?[Vv]ersion:\*\*\s*([\d.]+)", head),
        "status": first_match(r"\*\*Status:\*\*\s*([^·\n]+)", head),
        "tier": first_match(r"(?:Maturity|Document) tier:\**\s*([^\n]+)", head),
    }


def vocabulary(text):
    lines = []
    used = sorted({m.split("-")[0] for m in ID_RE.findall(text) if not m.startswith("BRD-")})
    for prefix in used:
        meaning = PREFIXES.get(prefix, "ID prefix used by this document; not in the shared ID namespace")
        lines.append(f"- `{prefix}-N` — {meaning}.")
    for term, meaning in TERMS:
        if term == "Must" and not re.search(r"\|\s*MoSCoW\s*\|", text):
            continue
        if term in text:
            shown = term + " …]" if term.startswith("[") and not term.endswith("]") else term
            lines.append(f"- `{shown}` — {meaning}.")
    return lines


# ----------------------------------------------------------------- output --

def yaml_value(value):
    if value is None:
        return '"[not stated in document]"'
    return '"' + value.replace('"', '\\"') + '"'


def assemble(path, out_path, text, generator, date):
    blocks = parse_blocks(text.split("\n"))
    tables = build_tables(blocks)
    assign_roles(tables)
    label_tables(tables)
    records, folds = build_records(tables)
    refs = backlinks(records)
    meta = read_meta(text, path)

    fold_names_by_prefix = {}
    for t in tables:
        if t["role"] == "fold":
            prefixes = {row_key(r).split("-")[0] for r in t["rows"]}
            for p in prefixes:
                fold_names_by_prefix.setdefault(p, []).append(fold_name(t["heading"]))

    rel = os.path.relpath(path, os.path.dirname(os.path.abspath(out_path))).replace(os.sep, "/")
    digest = hashlib.sha256(open(path, "rb").read()).hexdigest()
    doc_ref = meta["doc_id"] or meta["title"]
    front = ["---", f"doc_id: {yaml_value(meta['doc_id'])}", f"doc_type: {meta['doc_type']}",
             f"title: {yaml_value(meta['title'])}", f"version: {yaml_value(meta['version'])}",
             f"status: {yaml_value(meta['status'])}"]
    if meta["doc_type"] == "ORD":
        front.append(f"tier: {yaml_value(meta['tier'])}")
    front += [f"companion_of: {rel}", f"source_sha256: {digest}", f"generated: {date}",
              f"generator: {generator}", "authoritative: false", "---", ""]

    body = front + [HOW_TO_READ.format(doc_type=meta["doc_type"], doc_ref=doc_ref,
                                       file_name=os.path.basename(path))]
    body += ["## 2. Vocabulary", "", "Only the terms this document uses.", ""] + vocabulary(text) + [""]
    opens = open_items(records, blocks, meta)
    body += ["## 3. Open items", "", "Unanswered in the document. Do not fill any of these.", ""]
    body += [f"- {i}" for i in opens] if opens else ["None."]
    body += ["", "## 4. Context", "",
             "Prose sections of the document, copied verbatim under their original headings.", ""]
    body += context(blocks)
    body += ["## 5. Records", ""] + records_preamble(tables)
    current = None
    for rec in records:
        if rec["table"] is not current:
            current = rec["table"]
            body += [f"### Table: {current['label']}", ""]
        body += render_record(rec, folds, refs, fold_names_by_prefix)
    stats = {
        "rows": sum(len(t["rows"]) for t in tables),
        "records": len(records),
        "folded": sum(len(t["rows"]) for t in tables if t["role"] == "fold"),
        "view_rows": sum(len(t["rows"]) for t in tables if t["role"] == "view"),
        "views": sum(1 for t in tables if t["role"] == "view"),
        "open": len(opens),
    }
    return "\n".join(body).rstrip() + "\n", stats, blocks, tables


def context(blocks):
    out, last = [], None
    for heading, kind, body in blocks:
        if kind != "prose":
            continue
        lines = [ln for ln in body if ln.strip() != "---"]
        while lines and not lines[0].strip():
            lines.pop(0)
        while lines and not lines[-1].strip():
            lines.pop()
        if not lines:
            continue
        if heading != last:
            out += [f"### {clean(heading)}", ""]
            last = heading
        out += lines + [""]
    return out


def records_preamble(tables):
    views = [t for t in tables if t["role"] == "view"]
    folded = [t for t in tables if t["role"] == "fold"]
    lines = []
    lines.append("Views omitted: " + ("; ".join(f"{t['label']} ({len(t['rows'])} rows)" for t in views)
                                      if views else "none") + ".")
    lines.append("")
    lines.append("Folded into the record they describe: " + ("; ".join(
        f"{t['label']} → `{fold_name(t['heading'])}`" for t in folded) if folded else "none") + ".")
    lines += ["", "`referenced_by` lists the IDs of other records whose cells name this one.", ""]
    return lines


# ------------------------------------------------------------- integrity --

def verify(companion, stats, blocks, tables):
    if stats["rows"] != stats["records"] + stats["folded"] + stats["view_rows"]:
        raise Refusal(f"rows {stats['rows']} ≠ records {stats['records']} + folded "
                      f"{stats['folded']} + view rows {stats['view_rows']}")
    missing = []
    for heading, kind, body in blocks:
        if kind == "prose":
            missing += [ln for ln in body if ln.strip() and ln.strip() != "---" and ln not in companion]
    for t in tables:
        if t["role"] == "view":
            continue
        for r in t["rows"]:
            missing += [c for c in r if c and clean(c) not in companion]
    if missing:
        raise Refusal(f"{len(missing)} value(s) did not reach the companion verbatim, first: {missing[0]!r}")


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("document", help="the saved BRD or ORD")
    ap.add_argument("--out", help="companion path (default: <document>.llm.md beside it)")
    ap.add_argument("--generator", default="llm_companion.py", help="skill name and version")
    ap.add_argument("--date", default=datetime.date.today().isoformat())
    args = ap.parse_args(argv)
    for stream in (sys.stdout, sys.stderr):
        if hasattr(stream, "reconfigure"):  # a Windows console defaults to a code page without "—"
            stream.reconfigure(encoding="utf-8", errors="replace")

    if not os.path.isfile(args.document):
        print(f"REFUSED: no document at {args.document}", file=sys.stderr)
        return 1
    out = args.out or re.sub(r"\.md$", "", args.document) + ".llm.md"
    text = open(args.document, encoding="utf-8").read()
    try:
        companion, stats, blocks, tables = assemble(args.document, out, text, args.generator, args.date)
        verify(companion, stats, blocks, tables)
    except Refusal as err:
        print(f"REFUSED: {err}. No companion written.", file=sys.stderr)
        return 1
    with open(out, "w", encoding="utf-8", newline="\n") as fh:
        fh.write(companion)
    print(f"Companion: {out} — {stats['rows']} rows, {stats['records']} records, "
          f"{stats['folded']} folded, {stats['views']} view(s) omitted ({stats['view_rows']} rows), "
          f"{stats['open']} open items.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
