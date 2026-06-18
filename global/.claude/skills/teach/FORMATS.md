---
name: teach-formats
origin: Adapted from Matt Pocock (AIHero.dev / github.com/mattpocock/skills — productivity/teach)
description: Artefact formats for the /teach workspace — MISSION, RESOURCES, learning records, lessons, reference, and quizzes. Read when writing or updating any teach workspace file.
---

# Teach Workspace Formats

Skeletons and rules for every artefact `/teach` writes. Glossary is intentionally absent —
`GLOSSARY.md` uses Forge's existing `/add-term` convention (`**Term**: definition` + `_Avoid_:`
aliases); do not re-specify it here.

---

## MISSION.md

The compass. One mission per workspace; keep it to a single screen.

```markdown
# Mission: {Topic Name}

## Why
{1–3 sentences. The concrete real-world outcome. Observable change in life/work.
"Ship a Rust CLI to my team" — not "learn Rust".}

## Success Looks Like
- {Specific, demonstrable capability}
- {"Run a half marathon by October" — not "get fitter"}

## Constraints
- {Time, budget, prior commitments, preferred learning style — anything bounding scope}

## Out of Scope
- {Adjacent topics explicitly deferred to protect focus}
```

**Rules:** concrete observable outcomes over abstract "understand X"; if the goal is vague,
interview the learner before drafting; revise when the goal shifts (with confirmation).

---

## RESOURCES.md

Curated, high-trust sources — the reference layer that keeps teaching off parametric guesses.

```markdown
# {Topic} Resources

## Knowledge
- [Book: _Title_ — Author](url) — what it covers and when to reach for it
- [Paper: _Title_ — Author](url) — coverage + retrieval timing

## Wisdom (Communities)
- {Community / forum / local class} — expertise area and when to consult

## Gaps
- {Topic areas still lacking a good source — drives future research}
```

**Rules:** only peer-reviewed work, primary sources, recognised experts, well-moderated
communities — exclude marketing-as-instruction. Every entry annotated. Prune wrong/off-mission
sources, don't archive them. **Five sharp sources beat thirty mediocre ones.** Record any
community opt-out here so it is never re-suggested.

---

## learning-records/NNNN-slug.md

Pedagogical ADRs. Sequentially numbered (scan existing, increment highest). Directory created
lazily on first record.

```markdown
---
status: active            # or: superseded by LR-0007
---

# {What was learned or established}

{1–3 sentences: the insight, why it matters, and what it unlocks for future sessions.}

## Evidence        (optional)
{How understanding was demonstrated — exercise completed, question answered, prior experience disclosed.}

## Implications    (optional)
{What this unlocks or constrains for subsequent lessons.}
```

**Write a record when:** the learner demonstrated real understanding of a non-trivial concept;
disclosed existing knowledge (record the depth claimed); a misconception was corrected; or the
mission shifted. **Don't record:** coverage without demonstrated understanding, glossary
duplicates, or session activity logs. **Supersede, don't delete** — set `status: superseded by
LR-NNNN` so the evolution of understanding stays as signal. The whole format can be a single
paragraph.

---

## lessons/NNNN-slug.html

Self-contained HTML teaching units — the primary delivery mechanism. Sequentially numbered.

**Rules:**
- Short — completable in one sitting; respect working-memory limits.
- One tightly-scoped win tied to the mission.
- Beautiful, print-ready, clean typography (think Tufte).
- Cite a primary source; litter the lesson with citations.
- Link internally to related lessons and `reference/` docs via anchors.
- End by inviting the learner to ask follow-up questions.
- Reuse `assets/` first; never inline a component that belongs in `assets/`.

## reference/*.html

Compressed cheat sheets for *later lookup* (unlike lessons, which teach once): glossaries,
syntax/snippets, algorithms/flowcharts, sequences/poses. Optimise for quick scanning.

## assets/

Shared, reusable components — stylesheet (create first), quiz widgets, simulators. Reuse is the
default, not the exception. Check here before authoring anything new.

### Quiz rules
- Every answer option is the **same number of words** (and characters where possible).
- No formatting tells that reveal the correct answer.
- Feedback as tight as possible — immediate, ideally automatic.
