# Logic Prototype — Method

The method for the **Logic branch** of `/prototype`. Adapted from Matt Pocock's `prototype/LOGIC.md` (github.com/mattpocock/skills).

A Logic Prototype validates **behaviour and structure** — a state machine, reducer, or data model — by letting a human interactively push scenarios through it before implementation. The trick: the **logic module is the lasting artifact** (it lifts into production unchanged); the interactive harness around it is **pure waste**, built only to drive the question and then discarded.

## When this is the right shape

Use a Logic Prototype when the open question is behavioural or structural, e.g.:
- "I'm not sure this state machine handles edge case X then Y."
- "What's the right API/event shape before I commit to it?"
- "Does this data model represent the case where …?"
- "Given these actions, does the state end up correct?"

**Do not** use this shape when the question is *"what should this look like"* — that's the UI branch. And don't use it to build a generalised solution "in case we need X later" — a Logic Prototype answers exactly one question.

## Choose the module shape by the question

| The logic is really a… | Use when | Shape |
|------------------------|----------|-------|
| **Pure reducer** | discrete events drive a single state value | `(state, event) → state` |
| **State machine** | the *legality* of an action depends on the current state | explicit states + guarded transitions |
| **Pure function set** | there is no implicit "current" state to carry | standalone pure functions |
| **Class / module with internal state** | the logic genuinely owns internal state across calls | encapsulated object exposing methods |

Fit the shape to the question, not to whatever is convenient to wire up.

## Process

1. **Write the question** — one paragraph in `/prototype/LOGIC.md` before coding. This prevents answering the wrong question.
2. **Match the host project** — use the project's runtime, language, and conventions so the logic module is liftable without translation.
3. **Isolate the logic behind a pure interface** — build the logic module first. The interactive harness is a separate throwaway wrapper that *imports* the logic. Nothing flows backward from harness to logic.
4. **Build a lightweight interactive harness** (a terminal TUI is the default). Each frame has two parts:
   - **Current state** — pretty-printed (bold headers, dimmed context) so a change is obvious at a glance.
   - **Keyboard shortcuts** — the actions the human can dispatch, with labels.
   - **Loop:** initialise state → read a keystroke → dispatch the action → re-render the whole frame → repeat.
5. **One command to run** — wire it into the project's task runner (`pnpm run <name>`, `make <name>`, etc.).
6. **Hand it to the human** to drive scenarios. Add actions and iterate as new cases surface.
7. **Capture the answer** in `/prototype/LOGIC.md` (Recommendation for Implementation) per the `/prototype` `SKILL.md` process.

## Purity rules (the load-bearing constraint)

- **Keep the logic pure** — no I/O, no terminal code, no `console.log` used for control flow inside the logic module.
- The logic module must be **liftable into production unchanged** — that is the whole point of keeping it pure.
- **The harness imports the logic; nothing flows backward.** No harness type, terminal concern, or render detail leaks into the logic.
- **The harness is disposable** — it never ships to production. Only the validated logic module (and its stated answer) migrate to `src/` during Implementation, explicitly.

## Harness frame requirements

- **Clear the screen every tick** — one stable view per frame, no scrollback accumulation.
- The frame **fits on a single screen**.
- **Full re-render after each action** — replace the frame, don't append.
- Single in-memory state object/struct initialised at start (no persistence unless persistence is the question).
- Raw ANSI escapes are fine for emphasis (`\x1b[1m` bold, `\x1b[2m` dim, `\x1b[0m` reset). **Do not** add a styling library unless one is already in the project.

## Anti-patterns — never

- **Never add tests.** A prototype that needs tests is no longer a prototype.
- **Never wire to a real database** unless persistence behaviour is the question itself.
- **Never generalise** for a future/other case — answer the one question.
- **Never blur logic and harness** — keep the logic pure; the moment terminal code leaks in, the module stops being liftable.
- **Never ship the harness** to production — it is pure waste by design; the logic module is what survives.
