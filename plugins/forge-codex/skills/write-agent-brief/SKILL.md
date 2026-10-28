---
name: "write-agent-brief"
description: "Turn an existing PRD, ticket, set of requirements, or the decisions agreed in a conversation or notes, into an agent brief — a self-sufficient instruction an AI agent acts on cold, carrying the goal, the definition of done, testable criteria, constraints with their reasons, scope bounds, a verification check and the questions to ask rather than assume. Use when the user runs $write-agent-brief, or is about to hand requirements to a coding agent, sub-agent or chat assistant such as Microsoft 365 Copilot."
metadata:
  category: pipeline
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Write Agent Brief

Turn requirements that already exist into a **brief**: one document an AI agent can act on
**cold**, with no access to the conversation, the meeting or the author's head. The agent is the
reader. A stakeholder is not.

This skill **consumes** requirements: it asks for nothing beyond one Goal and Done round on a
conversation source, and it never splits work into tickets. One brief, one unit of work.

**Before drafting, read [REFERENCE.md](REFERENCE.md)** — the brief template for each target, the
cold-reader checks, and the worked ✗/✓ pairs. The practices behind each section, and the vendor
guidance that supports them, are in REFERENCE.md § Why each section exists.

**Authoring standards** — `standards/language.md` governs the wording of
every acceptance criterion in the brief. A hedged source criterion is rewritten to the declarative
end-state form, never copied through. Where a criterion is over learned or generated behaviour,
`standards/ai.md` applies on top. **If a standard cannot be read, stop and
name it** — a brief drafted from memory of the rules looks conformant and is not.

---

## Phase 1 — Read [AFK]

1. **Name the source and the target.** The source is a **document** (file path, ticket,
   requirement rows) or a **conversation** (this session, or pasted notes or a transcript), which
   also follows REFERENCE.md § Conversation source. The target is a **repo agent** (it can read
   files and run commands) or a **chat assistant** (it sees only what is pasted). Done when both
   are named; where either is missing, ask once.
2. **Run the data check.** Where an AI-use policy is installed (`rules/common/ai-use.md`), it governs.
   Otherwise: treat a target of unknown tier as public, and remove personal information,
   customer data and credentials from anything the brief carries. Check a conversation source
   line by line, because pasted keys and records turn up in chat. Done when every excerpt the
   brief will carry has been checked, and any item above the target's ceiling is named to the
   user rather than silently dropped.
3. **Fill the slots.** Map the source onto the slots in REFERENCE.md § Brief template. Done when
   every slot holds either content traced to the source or the marker `GAP`. A slot is never
   filled from inference. A conversation source fills slots by the provenance rules in
   REFERENCE.md § Conversation source: an unconfirmed assistant proposal is a `GAP`.

**Thin-source stop.** If **Goal** or **Done** is `GAP` after step 3, a document source stops:
tell the user it is not ready for a brief and recommend a grill (`$grill-me`). A conversation
source asks for the missing Goal and Done once, each with a recommended answer, then stops and
recommends a grill if either is still open or more than half the nine slots are `GAP`.

---

## Phase 2 — Gap Gate [HITL]

4. **Put every remaining `GAP` to the user** as a numbered question, at most five per round,
   each with a recommended answer. A reversed decision in a conversation source goes in the first
   round, so the user confirms which one stands. Wait for a reply to every round.
5. **Carry unresolved gaps into the brief** under **Ask before acting**, never as an assumption.
   Done when no `GAP` marker remains: each is answered, moved to Ask before acting, or recorded
   as out of scope by the user.

---

## Phase 3 — Write [AFK]

6. **Assemble the brief** for the target, using REFERENCE.md § Brief template.
   - **Repo agent:** point to files by path rather than pasting them, because the agent can read
     them and every pasted line costs its attention.
   - **Chat assistant:** paste the minimum excerpt each criterion needs, with the source named,
     and put the excerpts before the instructions.
   - **Conversation source:** the Source slot carries the agreed decisions as numbered
     statements, because the agent cannot read the conversation.
7. **Run the cold-reader checks** in REFERENCE.md § Cold-reader checks. Done when every check
   passes or its failure is fixed. A failing check is a fix, never a footnote.
8. **Save or return the brief.** For a repo agent, write it to `docs/briefs/[slug].md`. For a chat
   assistant, return it in a fenced block ready to paste. Done when the user has the brief and
   the list of anything step 2 removed.

---

## Phase 4 — Hand-over [HITL]

9. **Present the brief for approval.** The user hands it to the agent. This skill never launches,
   messages or instructs an agent itself.

## Rules

- Every line of the brief changes what the agent does. A line restating what the agent can read
  from the code, or would do anyway, is cut.
- Each constraint carries its reason, stated as what to do. Keep a "never" only for a
  consequential or irreversible action, such as a push, a deletion or a production change.
- One goal per brief. A source holding several independent goals produces several briefs, and the
  user is told the source would split.
- A brief instructs one agent on one task, cold. Carrying a stream of work into the next session
  is `$handoff`. Where the user wants the session continued rather than a task handed off, say so.

## Failure Modes

| Condition | Behaviour |
|---|---|
| Goal or Done missing from the source | Thin-source stop. Recommend a grill; write no brief |
| Assistant proposal in a conversation, never confirmed | `GAP`. A suggestion the user let pass is not a requirement |
| Gap tempting to fill from inference | Mark it `GAP` and put it to the user. An inferred requirement is a fabricated one |
| Source criterion hedged (`should`, `may`, `as appropriate`) | Rewrite it per `standards/language.md`, and show the user the rewrite |
| Restricted data in the source | Remove it and name what was removed. Never pass it to a target above its ceiling |
| Brief growing past what the agent needs | Cut to non-inferable facts. Point to files rather than pasting them for a repo agent |
| Two instructions conflict | Resolve the conflict with the user before writing. A contradictory brief makes the agent guess which one wins |
| Source holds several goals | One brief per goal; tell the user |
| A standard cannot be read | Stop and name it |
