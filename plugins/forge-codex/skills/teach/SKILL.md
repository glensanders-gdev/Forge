---
name: "teach"
description: "Teach a subject across multiple sessions, grounded in the learner's real mission. Curates trusted resources, delivers short HTML lessons pitched at the learner's zone of proximal development, builds long-term retention through desirable difficulty, and records what was learned as it goes. Use when the user wants to learn or be upskilled in a topic, runs $teach, or resumes a learning workspace."
metadata:
  category: knowledge
  origin: Adapted from Matt Pocock (AIHero.dev / github.com/mattpocock/skills — productivity/teach)
---

# Teach

Stateful, multi-session teaching. Every lesson is **mission-grounded** — tied to a concrete real-world goal — and pitched in the learner's **zone of proximal development**: hard enough to stretch, not so hard it overwhelms. The aim is *storage strength* (durable retention), not *fluency* (the illusion of mastery that fades).

Adapted from Matt Pocock's "teach" skill (github.com/mattpocock/skills), translated into Forge conventions and wired into the knowledge base.

**Execution mode:** `[HITL]` — mission clarification, assessment, and feedback are interactive. Lesson and reference authoring between checkpoints is `[AFK]`.

## Workspace

One mission per workspace, under the knowledge base:

```
~/.codex/forge/knowledge/learning/[topic-slug]/
  MISSION.md          ← why the learner cares (grounds everything)
  RESOURCES.md        ← curated high-trust sources
  GLOSSARY.md         ← compressed validated terms (Forge $add-term format)
  NOTES.md            ← learner preferences: pacing, format, style
  lessons/            ← 0001-<slug>.html  (sequential, self-contained)
  reference/          ← cheat sheets, syntax, flowcharts — for later lookup
  learning-records/   ← 0001-<slug>.md   (pedagogical ADRs)
  assets/             ← shared stylesheet, quiz/simulator components
```

Formats for each artefact are in [FORMATS.md](FORMATS.md). When `active_company` is set, scaffold under `~/.codex/forge/companies/[active_company]/knowledge/learning/` instead.

## Process

1. **Mission gate `[HITL]`** — read `MISSION.md`. If it is missing or vague, interview the learner about their real-world goal *before drafting anything*, then write `MISSION.md`. **Completion criterion:** the mission names a concrete, observable outcome (e.g. "ship a Rust CLI to my team"), not "understand Rust". Confirm the path before scaffolding a new workspace.
2. **Assess the zone `[HITL]`** — read every file in `learning-records/` to map current capability. Pick the most mission-relevant topic that sits just past what the learner already knows. **Completion criterion:** the chosen topic is neither already-known nor unreachable.
3. **Curate resources** — find high-trust external sources and record them in `RESOURCES.md`. Cite them in lessons. **Never teach from parametric memory** — verify against sources first (Forge's research-first rule).
4. **Design the lesson** — one tightly-scoped win tied to the mission, completable in one sitting. Reuse `assets/` (create the shared stylesheet first); author new reusable components into `assets/`, never inline. **Completion criterion:** lesson is a self-contained `lessons/NNNN-<slug>.html`, cites a primary source, links related lessons/reference, and ends by inviting follow-up questions.
5. **Practice & feedback** — for skills-heavy topics, add effortful retrieval with tight, immediate feedback (quizzes, in-browser simulators). For knowledge-heavy topics, curate and reduce load instead. Build retention with spacing, interleaving, and retrieval practice.
6. **Record `[HITL→AFK]`** — when the learner demonstrates real understanding, write a `learning-records/NNNN-<slug>.md` and promote validated terms into `GLOSSARY.md`. Update `MISSION.md` only with the learner's confirmation if their goal shifts; note preferences in `NOTES.md`.
7. **Wisdom hand-off** — when a question needs real-world wisdom rather than documented knowledge, answer as best you can, then point the learner to a high-reputation community. Respect any opt-out recorded in `RESOURCES.md`/`NOTES.md`.

## Pedagogy

- **Zone of proximal development** — the band between what the learner can do alone and what they cannot yet do. Teach there.
- **Storage strength over fluency** — ease is the enemy of retention. Desirable difficulty (spacing, interleaving, retrieval) builds durable memory; smooth re-reading does not.
- **Knowledge vs skills** — knowledge-heavy topics need curated sources and reduced cognitive load; skills-heavy topics need practice and feedback loops.
- **Beautiful, durable lessons** — lessons get revisited; invest in clean, print-ready typography (think Tufte).

## Forge Integration

- **`$research`** sources `RESOURCES.md`; the research-first rule ("never trust parametric knowledge, cite everything") is the same discipline.
- **`$add-term`** owns the glossary format — `GLOSSARY.md` follows it; do not re-specify it.
- **Learning records ≈ ADRs** (`$write-adr`) and **instincts** (`$learn`) — same record-everything spirit as PRINCIPLE 8. Supersede, don't delete (`superseded by LR-NNNN`).
- **`$idea`** and a PRD's problem statement are cousins of `MISSION.md` (Why / Success / Constraints / Out of scope).

## Rules

- Never teach anything not grounded in the documented mission — ungrounded knowledge is the failure this skill exists to prevent.
- Never trust parametric memory over a curated source; cite everything.
- Never pitch outside the zone of proximal development — boredom and overwhelm both kill retention.
- Never optimise for fluency (smooth recall now) at the cost of storage strength (recall later).
- Never inline a reusable component — it belongs in `assets/`; reuse is the default.
- Never admit a term to `GLOSSARY.md` before the learner demonstrates functional understanding of it.
- Never change `MISSION.md` without the learner's confirmation; never run more than one mission per workspace.

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| `MISSION.md` missing or vague | Stop. Interview the learner for a concrete observable outcome before scaffolding or teaching. |
| No `learning-records/` yet | Treat as a fresh start; assess via a short diagnostic before picking the first topic. |
| Learner feels fluent but fails later | Fluency–storage gap — add spacing, interleaving, and retrieval practice; stop re-reading. |
| Topic too easy / too hard | Out of the ZPD — re-pick using `learning-records/`; adjust difficulty band. |
| Question needs real-world wisdom | Answer as best you can, then hand off to a high-reputation community (respect opt-outs). |
| Mission appears to have shifted | Confirm with the learner, then update `MISSION.md` and write a learning record noting the shift. |
