#!/usr/bin/env python3
"""Build a self-contained paste bundle for joint PRD/ORD authoring.

`/write-reqs` holds no schemas by design — it references `rules/requirements/*.md`
and delegates to `/write-prd` and `/write-ord`. Pasted alone onto a machine with no
Forge install it carries no scenario naming, no criteria schema and no templates,
and the model invents them. This concatenates the minimum set that authors correctly
standalone.

    python3 tools/build-reqs-bundle.py [-o OUTPUT]

Output defaults to ../reqs-authoring-bundle.md — outside both git repos, because the
pack half lives in the local-only requirements-documents repo and is not published
with the framework.
"""
import argparse
from datetime import date
from pathlib import Path

FORGE = Path(__file__).resolve().parent.parent
PACK = FORGE.parent / "requirements-documents"

# Dependency order: orchestration, then the documents it delegates to, then the
# standards they cite. tables.md carries the scenario naming — dropping it is what
# reproduces the Happy Path bug.
PARTS = [
    ("Orchestration", FORGE / "global/.claude/skills/write-reqs/SKILL.md"),
    ("PRD authoring", FORGE / "global/.claude/skills/write-prd/SKILL.md"),
    ("ORD authoring", FORGE / "global/.claude/skills/write-ord/SKILL.md"),
    ("ORD template and ISO/IEC 25010 taxonomy", FORGE / "global/.claude/skills/write-ord/REFERENCE.md"),
    ("Table schemas — carries the Sunny Day / Rainy Day / Edge Case naming",
     FORGE / "global/.claude/rules/requirements/tables.md"),
    ("Requirement language rules", FORGE / "global/.claude/rules/requirements/language.md"),
    ("PRD standard of record (pack)", PACK / "reference/prd-standard.md"),
]

HEADER = """# Joint PRD/ORD authoring — self-contained bundle

Generated {stamp} from Forge {version}. **Generated file — do not edit.**
Regenerate with `python3 tools/build-reqs-bundle.py`.

Paste this whole file. It replaces a Forge install for one task: authoring a PRD and
an ORD together. Every path reference below (`~/.claude/rules/...`, `/write-prd`,
`/write-ord`) resolves to a section *of this file*, not to a file on disk.

Omitting any part changes the output. The table schemas section is where the
`Sunny Day` / `Rainy Day` / `Edge Case` naming is defined — without it, acceptance
criteria revert to `Happy path` / `Error` / `Edge`.

## Contents

{toc}

---
"""


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("-o", "--output", type=Path,
                    default=FORGE.parent / "reqs-authoring-bundle.md")
    args = ap.parse_args()

    missing = [p for _, p in PARTS if not p.exists()]
    if missing:
        for p in missing:
            print(f"missing: {p}")
        return 1

    manifest = FORGE / "global/.claude/skills/manifest.json"
    import json
    version = json.loads(manifest.read_text())["forge_version"]

    def source_of(path: Path) -> str:
        return str(path.relative_to(FORGE)) if FORGE in path.parents else f"(pack) {path.name}"

    toc = "\n".join(
        f"{i}. **{label}** — `{source_of(path)}`" for i, (label, path) in enumerate(PARTS, 1)
    )
    out = [HEADER.format(stamp=date.today().isoformat(), version=f"v{version}", toc=toc)]

    for i, (label, path) in enumerate(PARTS, 1):
        out.append(
            f"\n# {i}. {label}\n\n*Source: `{source_of(path)}`*\n\n"
            f"{path.read_text().strip()}\n\n---\n"
        )

    args.output.write_text("".join(out))
    words = len("".join(out).split())
    print(f"wrote {args.output} ({args.output.stat().st_size:,} bytes, "
          f"~{words:,} words, ~{words * 4 // 3:,} tokens)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
