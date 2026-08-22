#!/usr/bin/env python3
"""Generate the self-contained pack extracts that the requirements skills ship.

The requirements-documents pack is the single source of truth for every gate item,
outcome and threshold. The pack is held locally and is not in this repo, so a skill
that only referenced it by path would resolve nothing for anyone who cloned Forge.

This generator reads the pack and emits one extract per skill — the criteria the two
review skills apply, and the standard /write-brd authors against. The output is a
build artefact in exactly the sense build-forge-codex.ps1's output is: committed,
never hand-edited, regenerated from source. Editing an extract directly puts it out
of step with the pack, and --check exists to catch that.

Only someone holding the pack can regenerate. That is correct: the pack's custodian
owns the criteria, and everyone else consumes a stamped extract.

Usage:
    python3 tools/build-review-criteria.py            # regenerate
    python3 tools/build-review-criteria.py --check    # fail if stale; skip if no pack
"""

from __future__ import annotations

import datetime as _dt
import hashlib
import os
import re
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
SKILLS = REPO_ROOT / "global" / ".claude" / "skills"

# Sentinel meaning "run to the next horizontal rule".
TO_RULE = object()


def resolve_pack() -> Path | None:
    """Find reference/ in the requirements-documents pack, or None.

    Mirrors the resolution order the skills themselves publish, so a machine that
    can run a review can also regenerate the extract.
    """
    env = os.environ.get("FORGE_REQ_PACK")
    if env:
        candidate = Path(env).expanduser() / "reference"
        if candidate.is_dir():
            return candidate

    here = Path.cwd().resolve()
    for parent in [here, *here.parents]:
        candidate = parent / "requirements-documents" / "reference"
        if candidate.is_dir():
            return candidate

    fallback = Path.home() / "Documents" / "Forge" / "requirements-documents" / "reference"
    return fallback if fallback.is_dir() else None


def pack_version(reference: Path) -> str:
    """Read the newest version heading from the pack's own CHANGELOG."""
    changelog = reference.parent / "CHANGELOG.md"
    if not changelog.is_file():
        raise SystemExit(f"FAIL: pack CHANGELOG not found at {changelog}")
    for line in changelog.read_text(encoding="utf-8").splitlines():
        match = re.match(r"^## (v\d+\.\d+)", line)
        if match:
            return match.group(1)
    raise SystemExit(f"FAIL: no version heading found in {changelog}")


def pack_provenance(reference: Path) -> str:
    """Describe the exact pack state this extract came from.

    A version string alone is a claim; a commit is a state you can return to. Where
    the pack's working tree is dirty the extract came from something uncommitted, so
    it cannot be reproduced — say so rather than implying a clean provenance.
    """
    import subprocess

    root = reference.parent

    def git(*args: str) -> str | None:
        try:
            done = subprocess.run(
                ["git", "-C", str(root), *args],
                capture_output=True, text=True, check=True,
            )
        except (OSError, subprocess.CalledProcessError):
            return None
        return done.stdout.strip()

    if git("rev-parse", "--is-inside-work-tree") != "true":
        return (
            "**not version-controlled** — this extract cannot be traced to a pack state, "
            "and the state it came from may no longer exist"
        )

    sha = git("rev-parse", "--short=12", "HEAD") or "unknown"
    dirty = bool(git("status", "--porcelain"))
    described = git("describe", "--tags", "--exact-match", "HEAD")

    provenance = f"`{sha}`"
    if described:
        provenance += f" (tag `{described}`)"
    if dirty:
        provenance += (
            " — ⚠️ **generated from a dirty working tree.** Uncommitted pack changes were "
            "present, so this extract does not correspond to any committed state and cannot "
            "be reproduced. Commit the pack and regenerate."
        )
    return provenance


def slice_section(text: str, start: str, end) -> str:
    """Return the section from the line starting with `start` up to `end`.

    Raises rather than returning a partial extract. A silently truncated criterion
    is worse than a failed build: the review would still run and would apply a
    criterion that had lost half its text.
    """
    lines = text.splitlines()
    try:
        first = next(i for i, ln in enumerate(lines) if ln.startswith(start))
    except StopIteration:
        raise SystemExit(
            f"FAIL: section marker not found: {start!r}\n"
            "The pack has moved under the generator. Re-point the marker rather than "
            "loosening the match — a marker that matches the wrong heading is silent."
        )

    if end is TO_RULE:
        rest = lines[first + 1:]
        try:
            offset = next(i for i, ln in enumerate(rest) if ln.strip() == "---")
        except StopIteration:
            raise SystemExit(f"FAIL: no closing rule after {start!r}")
        last = first + 1 + offset
    elif end is None:
        last = len(lines)
    else:
        rest = lines[first + 1:]
        try:
            offset = next(i for i, ln in enumerate(rest) if ln.startswith(end))
        except StopIteration:
            raise SystemExit(f"FAIL: end marker not found: {end!r} (after {start!r})")
        last = first + 1 + offset

    return "\n".join(lines[first:last]).rstrip() + "\n"


# What each skill needs. (source file, start marker, end marker) or (file, None, None)
# for a whole file. Order is the order it appears in the output.
SPECS: dict[str, list[tuple[str, str | None, object]]] = {
    "review-brd": [
        ("brd-standard.md", "## The handoff gate — is this BRD ready", "## Worked example"),
        ("brd-standard.md", "### The handoff gate, applied to this document", TO_RULE),
        ("traceability-matrix.md", "## The five checks a matrix makes visible", None),
    ],
    "write-brd": [
        ("brd-standard.md", None, None),
        ("ord-intake-standard.md", "**Step 1 — size the change from the BRD.**",
         "**Step 2 — read the lead time.**"),
    ],
    "review-ord": [
        ("ord-intake-standard.md", "### 7.1 Must produce", "### 7.2 Referred"),
        ("ord-intake-standard.md", "### 7.3 Must refuse", "### 7.4 Acceptance criteria"),
        ("ord-intake-standard.md", "## 5. Requirement status taxonomy", "### 5.1 Approval"),
        ("ord-intake-standard.md", "### 5.2 KPPs", TO_RULE),
        ("ord-intake-standard.md", "### 2.1 Quantified in business terms", "### 2.2 Scope"),
        ("traceability-matrix.md", "## The five checks a matrix makes visible", None),
        ("nine-characteristics-quickref.md", None, None),
        ("kpp-identification-guide.md", None, None),
        ("requirement-to-section-map.md", None, None),
        ("example-ORD.md", None, None),
    ],
}

# What each skill ships: the filename, the noun for the heading, and what quoting the
# version buys. A generator that called the BRD standard a set of criteria would
# misdescribe the one skill that authors from the pack rather than judging against it.
OUTPUTS: dict[str, tuple[str, str, str]] = {
    "review-brd": ("CRITERIA.md", "criteria extract",
                   "Quote the version in every review this extract is used for."),
    "review-ord": ("CRITERIA.md", "criteria extract",
                   "Quote the version in every review this extract is used for."),
    "write-brd": ("STANDARD.md", "standard extract",
                  "Quote the version in every BRD authored from this extract."),
}

PREAMBLE = """\
# {skill} — {noun}

> **Generated file. Never hand-edit.** Produced by `tools/build-review-criteria.py`
> from the requirements-documents pack, which is the single source of truth for
> everything below. Editing this file puts it out of step with the pack; regenerate
> instead.

**Pack version:** {version} · **Pack commit:** {provenance}
**Generated:** {date} · **Content hash:** `{digest}`

**{usage}**
A reader needs to know which revision was applied — a verdict, and a document
authored to a bar, are only meaningful against a named one, and that is the pack's
own thesis applied to itself.

**Where the live pack is present, it wins.** This extract exists so the skill runs
for someone who does not hold the pack. It is a pinned copy, not an authority: where
it and the pack disagree, the pack is right and this file is stale.

---

"""


def build_body(reference: Path) -> dict[str, str]:
    """Assemble each skill's extract body (everything below the preamble)."""
    out: dict[str, str] = {}
    for skill, sections in SPECS.items():
        chunks: list[str] = []
        for filename, start, end in sections:
            source = reference / filename
            if not source.is_file():
                raise SystemExit(f"FAIL: source not found: {source}")
            text = source.read_text(encoding="utf-8")
            body = text.rstrip() + "\n" if start is None else slice_section(text, start, end)
            chunks.append(f"<!-- from reference/{filename} -->\n\n{body}")
        out[skill] = "\n---\n\n".join(chunks)
    return out


def render(skill: str, body: str, version: str, date: str, provenance: str) -> str:
    digest = hashlib.sha256(body.encode("utf-8")).hexdigest()[:16]
    _, noun, usage = OUTPUTS[skill]
    return PREAMBLE.format(
        skill=skill, noun=noun, usage=usage,
        version=version, date=date, digest=digest, provenance=provenance,
    ) + body


def main() -> int:
    check = "--check" in sys.argv

    reference = resolve_pack()
    if reference is None:
        message = (
            "requirements-documents pack not found "
            "($FORGE_REQ_PACK, upward from cwd, or ~/Documents/Forge/)."
        )
        if check:
            print(f"SKIP: {message}\n      Staleness is only checkable where the pack is held.")
            return 0
        print(f"FAIL: {message}", file=sys.stderr)
        return 1

    version = pack_version(reference)
    provenance = pack_provenance(reference)
    bodies = build_body(reference)
    today = _dt.date.today().isoformat()

    stale: list[str] = []
    for skill, body in bodies.items():
        filename = OUTPUTS[skill][0]
        target = SKILLS / skill / filename
        if not target.parent.is_dir():
            raise SystemExit(f"FAIL: skill directory missing: {target.parent}")

        if check:
            if not target.is_file():
                stale.append(f"{skill}: {filename} missing")
                continue
            current = target.read_text(encoding="utf-8")
            # Compare the body only — the date line moves on every run and is not
            # a change in criteria.
            marker = "\n---\n\n"
            existing_body = current.split(marker, 1)[1] if marker in current else ""
            if existing_body != body:
                stale.append(f"{skill}: extract differs from pack {version}")
            continue

        rendered = render(skill, body, version, today, provenance)
        target.write_text(rendered, encoding="utf-8")
        size = len(rendered.encode("utf-8")) / 1024
        print(f"  wrote {target.relative_to(REPO_ROOT)}  ({size:.1f} KB, pack {version})")

    if check:
        if stale:
            print("FAIL: review criteria are stale:", file=sys.stderr)
            for item in stale:
                print(f"  - {item}", file=sys.stderr)
            print(
                "\nRun: python3 tools/build-review-criteria.py  and commit the result.",
                file=sys.stderr,
            )
            return 1
        print(f"Review criteria are current against pack {version}.")
        return 0

    print(f"Generated review criteria from pack {version} {provenance.split(chr(10))[0][:60]}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
