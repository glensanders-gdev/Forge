# Forge Changelog

Version history for the Forge framework. Update when bumping `forge_version` in `manifest.json`.

## Conventions

- Update this file whenever a skill is added, changed, or removed
- Update `~/.codex/forge/forge-sequence.mmd` (installed single-file) and `docs/diagrams/framework-complete.mmd` + the relevant `docs/diagrams/phase-NN-*.mmd` file when the pipeline changes — new phases added, phase order changed, or major skills added to the lifecycle flow. Not required for every version bump — only when the diagram would be materially wrong without an update.
- Use `$write-a-skill` checklist item as the trigger — it now includes a `CHANGELOG.md` update step
- Version format: `MAJOR.MINOR.PATCH` — major for lifecycle changes, minor for new skills, patch for skill fixes

---

## v4.3.0 — 2026-08-24

**The `$critic` P2s on the requirements pack.** v4.2.1 made `ai.md` reachable; this makes it
checkable. Five findings, each a way a requirement written under it could pass review and still be
unverifiable.

### Changed

- **`EVL-NNN` and `MDL-NNN` now have one assigning skill — `$write-ord`.** `tables.md` previously
  assigned both to "whichever document records it" while `ai.md`'s class map deliberately places AI
  requirements in *both* the PRD and the ORD, and `$write-reqs` authors the PRD **first** — two
  skills allocating from one flat sequential namespace, with the PRD guaranteed to go first. A PRD
  criterion needing a set that does not exist yet now writes `[EVL-TBD — <what must be measured>]`
  and `$write-ord` writes the real ID back, reusing the `Capability` / `Epic` write-back the pack
  already had. Where no ORD is produced, the PRD holds the registers and says so. The two TBD forms
  are now distinguished in a table — `[TBD — source: …]` is a missing *decision*, `[EVL-TBD]` is a
  missing *set*, and writing the first where the second is true buries a known measurement.
- **"Calibrated to human annotation" now carries a number.** `ai.md` banned "the model is
  explainable" as an unquantified adjective while accepting "calibrated" as a scorer. A judge-based
  `Scorer` cell now names the human-annotated calibration subset, the agreement statistic, and the
  value achieved with the minimum required; Krippendorff's α ≥ 0.800 convention is offered as a
  default to record, not to assume. An asserted-but-unmeasured judge is a `[TBD]`, as an
  uncalibrated one already was.
- **`Floor` split into two obligations.** The criterion defined it as "unacceptable at any rate, **or**
  the worst single case tolerated" — a categorical prohibition and a scalar minimum — while the
  register carried only the scalar, leaving the safety-relevant half homeless. `Floor` is now scalar
  only; a categorical prohibition is a zero-tolerance register row in new **ORD § 3.9.3 Prohibited
  Outputs** (or § 3.3 Security where it is a disclosure), and the `EVL-NNN` register gains a
  `Prohibited outputs` column holding those row **IDs and no values**, per the view-table rule. `—`
  means *considered, none apply*. Scoring a prohibition implies a rate at which it passes.
- **AI-governed rows are marked `[AI]`.** The trigger is per-component, so an ORD holds governed and
  ungoverned rows side by side with nothing to tell them apart — the ruleset became uncheckable at
  the moment someone tried to check it. Mirrors **[KPP]**: same column, same bracket form,
  **[KPP][AI]** where both. Orthogonal to MoSCoW and to KPP — it records which ruleset governs the
  row's form, not its priority. A `[AI]` row naming no `EVL-NNN` is rejectable on sight.
- **AI Act dates carry a verification stamp — and it reads "never".** Tracing them found that
  `docs/research/requirements-for-ai-solutions.md`, cited by ADR-0003 twice, by `ai.md` and by the
  v4.2.0 entry below, **is not in the repository and is not in its history**. The chain of evidence
  for the 2 December 2027 / 2 August 2028 deferrals therefore ends at an ADR paragraph. Rather than
  restate the dates as fact, `ai.md` now records them in a stamped table with `Last verified: never,
  within this repository`, an unassigned owner, and an instruction to verify against the
  consolidated text of Regulation (EU) 2024/1689 on EUR-Lex before any conformity claim. **The
  requirement classes are unaffected** — Arts. 9–15 and Annex IV supply them whatever the deadlines
  prove to be.

### Skills

`$write-prd` 2.7.2 · `$write-ord` 1.5.2 · `$write-ac` 1.5.2 — namespace ownership, the `[AI]` marker,
and `[EVL-TBD]` resolution. `$write-brd` and `$write-reqs` unchanged since 4.2.1.

### Open

The missing research document is **not** reconstructed here — it is either recoverable from wherever
it was authored or it never existed, and inventing a replacement would fabricate the provenance the
stamp exists to flag.

---

## v4.2.1 — 2026-08-24

**`ai.md` was unreachable.** v4.2.0 shipped the ruleset and bumped five skills to cite it. The
rebase that landed it carried the version numbers across but dropped the edits they were numbering:
the merge touched **no `SKILL.md` file**, so no skill referenced `ai.md` and nothing ever asked the
trigger question. The ruleset was live in `rules/` and dead in practice — reachable only through
`tools/build-reqs-bundle.py`, which is the standalone-machine escape hatch, not the normal path.
Found by `$critic`.

The v4.2.0 entry below described the intended state. This release makes it the actual state.

### Fixed

- **`$write-prd` 2.7.1, `$write-ord` 1.5.1, `$write-ac` 1.5.1, `$write-reqs` 1.3.1,
  `$write-brd` 1.1.1** now cite `rules/requirements/ai.md` in their authoring-standards blocks,
  marked conditional on the trigger test.
- **The trigger is now asked, not assumed.** `$write-prd` and `$write-ord` each carry an explicit
  Phase 1 step and a named block in the Phase 1 Summary, so the answer reaches the human gate
  either way. `$write-reqs` settles it **once** during classification and passes it in both briefs,
  so the siblings cannot disagree about whether the ruleset is in force. Each states that the test
  judges the *delivered solution*, never the toolchain — a run in AI-assisted delivery mode is not
  itself a trigger, and the two questions are independent.
- **ISO/IEC 25059 sub-characteristics are in `write-ord/REFERENCE.md`.** ADR-0003 required the §3
  patch; v4.2.0 did not apply it, so the class map routed requirements to subsections that did not
  exist. Added as an *AI Extension* block in the taxonomy and scaffolded in the §3 template, marked
  *(AI — 25059)*: **3.2.5** Robustness · **3.3.7** Prompt Injection and Model Attack Surface ·
  **3.6.3** Record-Keeping and Inference Logging · **3.7.4** User Controllability and
  Intervenability · **3.7.5** Transparency and Explainability · **3.8.2** Functional Adaptability ·
  **3.8.3** Accuracy and Fairness Thresholds. §3 is not restructured; every existing §3.x reference
  still resolves, and the numbering only extends.
- **`ai.md`'s class map names the subsections** rather than the parent characteristics, and states
  that they are conditional: where the trigger does not fire they are omitted from the body *and*
  from §3.10 — an inapplicable subsection is not a coverage gap.

### Known gaps — not addressed here

Raised by the same `$critic` pass, deliberately left open: `EVL-NNN` / `MDL-NNN` have no single
assigning skill; "calibrated to human annotation" names no agreement statistic; `Floor` is defined
two ways in the criterion but has one column in the register; no marker distinguishes an
AI-governed register row; the AI Act dates carry no verification stamp.

---

## v4.2.0 — 2026-08-23

**AI as the *subject* of a requirement** — not AI as the author of the code

`ai-first-engineering` governs AI writing the solution. Nothing governed AI *being* the solution:
no coverage of non-determinism, drift, evaluation sets, model dependency, or the EU AI Act anywhere
in the requirements pack or the rules. Researched in
`docs/research/requirements-for-ai-solutions.md`; decided in **ADR-0003**.

### Added

- **`rules/requirements/ai.md`** — the third shared ruleset, and the first **conditional** one. It
  applies on top of `language.md` and `tables.md` when a delivered component's behaviour is learned
  or generated rather than specified, and relaxes neither. Carries the trigger test, the evaluative
  criterion form, the class map assigning all 15 AI requirement classes to existing BRD/PRD/ORD
  sections, the `EVL-NNN` and `MDL-NNN` schemas, the shelf-life rule, and the scenario triad read
  for AI.
- **ID namespace extended** to `EVL-NNN` (evaluation sets) and `MDL-NNN` (model / provider
  dependencies), under ADR-0001's rules — flat, sequential, never reused, never theme-encoding, no
  single-letter prefixes.
- **`tools/build-reqs-bundle.py`** carries `ai.md` in its PARTS list. The bundle's own thesis is that
  omitting a part makes the model invent the missing rule; the new file is subject to that thesis.

### Changed

- **`$write-prd` 2.7.0** cites `ai.md`, and owns the **intended purpose** and **prohibited uses** of
  an AI component — intended purpose in the scope boundary, prohibited uses in Out of Scope.
- **`$write-ord` 1.5.0** cites `ai.md`. Where triggered, §3 carries the ISO/IEC 25059:2023
  sub-characteristics on top of the ISO/IEC 25010:2023 nine. **§3 is not restructured and nothing is
  renumbered** — every existing §3.x reference still resolves.
- **`$write-ac` 1.5.0** — an eval threshold tagged **[KPP]** promotes to Capability AC with its
  `EVL-NNN` set named in the criterion.
- **`$write-reqs` 1.3.0** and **`$write-brd` 1.1.0** cite `ai.md`; the BRD records the risk
  classification decision once, for the chain below it.
- **`rules/requirements/README.md`** states the conditional-vs-unconditional split, and the boundary
  `ai.md` adds: AI as the *subject* of a requirement here, AI as the *author* in
  `ai-first-engineering`.

### Notes

- **No new document type, deliberately.** ISO/IEC 25059:2023 extends ISO/IEC 25010:2023 rather than
  replacing it — the body that could have defined a separate AI quality model chose not to. A peer
  "AI requirements document" would have duplicated most of the ORD template to carry a small delta
  and fragmented the ID namespace. Reasoning in ADR-0003.
- **Non-determinism is not licence to hedge.** The modal ban applies to evaluative criteria
  unchanged, and `ai.md` says so explicitly: variability belongs in the threshold, never in the verb.
- **Version drift note superseded.** This work was authored before v4.1.0 and originally corrected
  `SKILL.md` frontmatter versions by hand. v4.1.0 removed that field entirely — every skill version
  here is set in `manifest.json` alone. README carried `v4.0.0` in its title and `4.0.0` under Skill
  Versioning against a manifest of 4.1.2; both now read 4.2.0.
- **ISO/IEC 25059 second edition is under member-body vote** after its DIS enquiry closed March 2026.
  Its AI *service* quality model is the part most relevant to AI consumed as a third-party API.
  Recorded as a watch item in ADR-0003 — re-check before the §3 guidance is treated as stable.
- **Deferred:** a data-as-subject schema per the ISO/IEC 5259 series. Dead weight for inference-only
  work against a consumed service, and the series warrants proper reading first.

---

## v4.1.2 — 2026-08-23

**`$skill-health` reads frontmatter, not the whole file** — scoping the version check

v4.1.0 made `manifest.json` the sole source of a skill's version and had `$skill-health` flag any
`version:` field in a `SKILL.md`. The check did not say where to look, and the portfolio contains
a live trap: `update-forge` documents the `~/.codex/forge/forge-version` file format inside a fenced
code block, and that block contains a literal `version:` line. A whole-file scan reports a clean
skill as a finding.

### Changed

- **`$skill-health` 1.4.1** — the `version:` and `name:` checks read the frontmatter block only:
  the opening `---` to its closing `---`, and nothing after it. A new failure-mode row states
  that a `version:` or `name:` inside a fenced code block is not a finding, and names
  `update-forge` as the case that proves it.

### Note

Found by running the v4.1.0 checks across all 113 skills rather than trusting them. Everything
else passed: no frontmatter name mismatches, no stale stub opening clauses, no orphaned commands.
Both deliberate alias stubs — `grill-with-codex` and `intent-layers` — were correctly exempted.

---

## v4.1.1 — 2026-08-23

**`$tdd` gains seams — and the exemption becomes a human decision** — assimilated from Matt Pocock's `implement` skill (github.com/mattpocock/skills)

Re-running `$assimilate` against the same source found v3.17.1 had taken its test-execution cadence
but left one clause behind: *"use $tdd where possible, at pre-agreed seams"*. Forge had neither half.
`$tdd` never named the seam — the boundary a test attaches to — and `$build` Step 3 read as *run the
TDD cycle for every AFK ticket*, unconditionally. Tickets that genuinely have no seam (dependency
bumps, config, one-shot migrations, scaffolding, pure visual work, spikes) were left to agents to
improvise around, silently.

"Where possible" is an escape hatch the moment an agent decides what was possible, so the exemption
is defined as a recorded human decision that swaps the test for named evidence — never a licence to
skip verification.

### Changed

- `$tdd` 1.0.0 → 1.1.0 — new **Where TDD Applies — Seams** section. Defines a seam as the boundary at
  which behaviour becomes observable through a public interface, makes naming the seams part of Step 1
  Plan, and tables the six ticket shapes that have none of their own against **the evidence required
  instead** — the exemption changes what the evidence is, never the obligation to produce it. A ticket
  is exempt only on a human decision recorded as `no-seam: [reason] — verified by [evidence]`, so the
  gap is visible at `$qa-plan` rather than in production. Three new negative-space rules and four new
  Failure Modes rows, including the one that matters most: *"where possible" invoked on a ticket that
  does have a seam* — the work is being avoided, not exempted.
- `$build` 1.2.1 → 1.3.0 — Step 3 gains a **seam check** before the RED/GREEN cycle, with a typed
  `NO-SEAM` / `TDD` gate. An agent that thinks a ticket is untestable now pauses and proposes the
  replacement evidence rather than deciding alone — an agent holding that judgement is how a sprint
  quietly loses its coverage. Two new rules and two new Failure Modes rows; a `NO-SEAM` ticket stays In
  Progress until the evidence exists.

### Assimilation notes

- **Kept:** the seam concept, and the pre-agreement — TDD attaches somewhere specific, agreed before
  the tracer bullet rather than discovered mid-cycle.
- **Changed:** "where possible" is Forge-hardened into a HITL gate (Principle 1) with recorded evidence
  and explicit negative space (Principle 2); the ticket shapes and their evidence are enumerated rather
  than left to judgement.
- **Dropped:** nothing new — the rest of the source remains covered by `$build`, `$tdd` and
  `$review-diff`, and "commit to the current branch" stays out of `$build`'s scope per the v3.17.1
  decision. No new skill created.

---

## v4.1.0 — 2026-08-23

**`manifest.json` becomes the single source of a skill's version** — 32 frontmatter copies removed

Chasing the `$review-diff` version drift found the drift was not the defect. Seven skills carried a
`version:` in `SKILL.md` frontmatter that disagreed with `manifest.json`; 25 more carried one that
happened to agree; **81 carried none at all**. The canonical `SKILL.md` template in `$write-a-skill`
has never had a `version:` field, so the 32 that carried one had drifted *away* from the documented
convention, and nothing read the value — which is exactly why seven of them went stale unnoticed.

Correcting the seven numbers would have restored a second source of truth. Removing the field
instead makes the drift unrepresentable.

### Changed

- **`version:` removed from 32 `SKILL.md` frontmatters.** `manifest.json` is now the only place a
  skill's version lives, matching the 81 skills that already worked that way and the template that
  always specified it. No version values were lost: every one is recorded in the manifest and in this
  changelog. Affected: `accessibility`, `add-term`, `ai-first-engineering`, `approve`, `assimilate`,
  `break-down`, `critic`, `diagnose`, `evolve`, `grill-me`, `grill-with-docs`, `grill-with-peer`,
  `handoff`, `ia`, `install-forge`, `intent-layers`, `knowledge-health`, `learn`, `pickup`,
  `prototype`, `research`, `review-brd`, `review-diff`, `review-ord`, `to-tickets`, `update-company`,
  `write-ac`, `write-article`, `write-brd`, `write-ord`, `write-prd`, `write-reqs`.
- `$skill-health` 1.2.0 → 1.4.0 — two checks. The version check **inverts**: It reported ℹ️ Info when a
  frontmatter `version:` disagreed with the manifest; it now reports ⚠️ Amber when a `version:` is
  present *at all*, regardless of value. The Phase 1 inventory asserts the field's absence, the
  `version_mismatches` tally becomes `frontmatter_versions`, and a new Failure Modes row directs the
  fix to **delete** the line rather than reconcile it — reconciling is what re-creates the second
  source of truth.
- `$skill-health` also gains a **stale stub name** check. It verified that a command stub *exists*
  but never read it, so a stub whose opening clause named a skill that no longer exists passed the
  audit — the stub still resolves, and nothing errors, so only reading it reveals the stale name.
  Now ⚠️ Amber, with an inventory step, a `stale_stub_names` tally, and a Failure Modes row that
  also directs a check of the rest of the stub body for the retired name. Stubs opening `Alias for
  /<other>` are deliberate and exempt.
- `$pickup` 3.0.1 → 3.0.2 and `$review-diff` 4.0.1 → 4.0.2 — **stub openings corrected.**
  `pickup.md` opened "Invoke the continue skill" and `review-diff.md` "Invoke the review skill",
  both naming the pre-v3.25.0 name. Those two renames updated the filenames and the skill bodies but
  not the sentence inside the stub. A sweep of all 114 stubs found no others, and a sweep for the 28
  retired command names across every stub and skill body found only two references, both correct
  historical citations rather than live pointers: the rename note in `pickup/SKILL.md` (deliberately
  `no-adapt` fenced, because it is a claim about a Codex built-in) and the `code-review` row in
  `RESERVED-NAMES.md`. The v4.0.0 verb-first renames updated all 26 of their stubs correctly.
- `$write-a-skill` 1.4.0 → 1.5.0 — states the convention its template already implied: never add
  `version:` to `SKILL.md`, because the copy in frontmatter is the one that goes stale silently,
  since nothing reads it. Added as a manifest-step rule, a Review Checklist gate, and a Failure
  Modes row.
- **`forge_version` 4.0.1 → 4.1.0.**

### Fixed

- **Seven version drifts resolved** by removal rather than correction: `write-prd` (2.5.1≠2.6.1),
  `approve` (1.1.0≠1.2.0), `install-forge` (2.0.1≠3.0.0), `write-ac` (1.4.0≠1.4.2), `review-brd`
  (1.0.0≠2.0.0), `review-ord` (1.0.0≠2.0.0), `update-company` (1.0.0≠2.0.0). In all seven the
  manifest held the correct value, confirmed against this changelog: the three non-renamed skills
  match their last recorded bump, and the four renamed at v4.0.0 took the major that rename required
  while their files kept the pre-rename number.
- **`update-forge` was never drifted.** It was reported as `[NEW_VERSION]≠3.0.0` in the v4.0.1 note;
  that string is a template literal inside a fenced example block the skill emits, and the detection
  pass matched it by reading the first `version:` anywhere in the file instead of parsing frontmatter.
  The v4.0.1 count of nine should have read seven.

---

## v4.0.1 — 2026-08-23

**`$review-diff` recovers two elements dropped at assimilation** — from Matt Pocock's `code-review` skill (github.com/mattpocock/skills)

A re-run of `$assimilate` against the upstream source found no methodology change since Forge took
it at v3.16.0 — the nine intervening upstream commits are all housekeeping (em-dash removal, YAML
quoting, harness-neutral sub-agent dispatch that Forge had already made independently, and an
invocation-type fix for a setup skill Forge does not have). The comparison did surface two small
elements present in the original at assimilation time that were dropped without a recorded reason.

### Changed

- `$review-diff` 4.0.0 → 4.0.1 — **a 400-word cap on each sub-agent's report**, stated in the brief:
  the main thread pays to read whatever comes back, and an unbounded Standards report on a large diff
  buries its own P1s. And a **per-axis closing summary** in the output format — total findings and the
  single worst finding *within each axis*. Forge stated the no-re-ranking rule three times in prose but
  never rendered it in the report, which is the one place a reader sees it. Two matching negative-space
  rules and two Failure Modes rows added (over-long sub-agent report; the clean-on-both summary reading).
  Attribution line updated to name both recovered elements.
- **`forge_version` 4.0.0 → 4.0.1.**

### Fixed

- **`$review-diff` declared `version: 3.0.0` while `manifest.json` said `4.0.0`.** The v4.0.0 verb-first
  rename bumped the manifest but not the skill file. Corrected as part of this bump. Eight further skills
  carry the same drift and are not fixed here — see the note below.

### Known

- **Seven skills disagree with the manifest on their own version.** Resolved in v4.1.0 — see below.

---

## v4.0.0 — 2026-08-22

**Action skills are verb-first** — 26 renames, decided in [ADR-0002](../../docs/adr/0002-verb-first-action-skill-names.md)

Forge had 113 skill names and no naming convention. The result was not untidy so much as
unpredictable: the same verb appeared in both positions, so `add-project` sat beside `tool-add`
and `update-readme` beside `forge-update`. A reader could not derive a skill's name from what it
did.

### Breaking

- **26 action skills renamed.** A skill that performs an operation now takes verb-first.

| `/backlog-add` | `$add-backlog-item` |
| `/company-add` | `$add-company` |
| `/tool-add` | `$add-tool` |
| `/pii-check` | `$check-pii` |
| `/scope-check` | `$check-scope` |
| `/style-check` | `$check-style` |
| `/tool-check` | `$check-tools` |
| `/pi-end` | `$end-pi` |
| `/sprint-end` | `$end-sprint` |
| `/forge-init` | `$init-forge` |
| `/forge-install` | `$install-forge` |
| `/knowledge-onboard` | `$onboard-knowledge` |
| `/pi-replan` | `$replan-pi` |
| `/sprint-replan` | `$replan-sprint` |
| `/security-resolve` | `$resolve-findings` |
| `/brd-review` | `$review-brd` |
| `/diff-review` | `$review-diff` |
| `/fy-review` | `$review-fy` |
| `/ord-review` | `$review-ord` |
| `/performance-review` | `$review-performance` |
| `/brain-setup` | `$setup-brain` |
| `/sprint-start` | `$start-sprint` |
| `/company-sync` | `$sync-company` |
| `/company-update` | `$update-company` |
| `/dependency-update` | `$update-dependencies` |
| `/forge-update` | `$update-forge` |

- **Every renamed skill takes a major version.** As established in v3.25.0, there is no soft
  landing: the old name stops resolving the day the rename lands, and a deprecation stub is not
  available as a mitigation. `$review-diff` reaches 4.0.0 — its second major in two releases,
  accepted deliberately and reasoned in ADR-0002.
- **`forge_version` 3.27.0 → 4.0.0.** A lifecycle change across a quarter of the portfolio.

### Fixed

- **`$graphify` declared the wrong name.** Its `SKILL.md` frontmatter read
  `name: graphify-windows` while its directory, its manifest key, its command stub and its own
  `trigger:` all read `graphify`. No Windows-specific variant ever existed — the name arrived
  wrong in 8c54d2f, the commit that added the skill, and survived every audit since. Frontmatter
  corrected to `graphify`; skill version 1.0.1 → 1.0.2.
- **`$skill-health` now checks that a skill's declared name is its directory name.** It checked
  that `name:` was *present*, and separately that a `version:` matched the manifest, but never
  that `name:` matched the folder it sat in — which is why the `graphify` mismatch survived. A
  skill that declares a different name registers under the declared name or not at all, and
  reports nothing: the same silent-failure class as the shadowed names in v3.27.0, so it carries
  the same 🔴 Critical severity and leads the summary warning alongside them. The comparison is
  literal — no case, hyphen or underscore normalisation, because the loader does not normalise
  either. Mirrored into the Codex-native override. Skill version 1.1.0 → 1.2.0.

Running the new check across all 113 skills found `graphify` and nothing else. The count was
unknown rather than one until it ran: the check had never existed, and it was verified against
the post-rename directory names above, not remembered ones.

### Unchanged

- **Seven state skills keep their noun shape** — `skill-health`, `context-health`,
  `knowledge-health`, `qa-plan`, `qa-report`, `token-report`, `security-assessment`. Their names
  are used as nouns in prose and as artefact references ("read the skill-health report"), not as
  imperatives; forcing `report-tokens` would split the skill name from the artefact name.
- **Single-word names are outside the convention** — there is no order to get wrong.
- **Historical records are not rewritten.** Old names inside past CHANGELOG entries, README
  version-history rows, prior ADRs, DEVLOG entries and handoffs record what shipped at the time
  and stand as they are — the rule set in v3.25.0. `graphify-out/` is likewise left alone: it is
  a dated generated snapshot, and rewriting it would falsify a record rather than update a
  reference.

### Note

Every one of the 26 new names was run through the v3.27.0 collision gate before adoption: none is
shadowed, none is on the At Risk list, and none collides with an existing skill. Three targets
depart from a literal word-order flip — `add-backlog-item`, `onboard-knowledge` and
`resolve-findings` — because verb-first requires naming the object acted on rather than the
register it sits in.

The `*-review` family carried an independent justification. Claude Code
occupies three names in the `*-review` shape — `review`, `code-review`, `security-review` — and
none in `review-*`, so Forge's five names sat in the demonstrated expansion path. Moving them out
is collision avoidance, not tidiness.

---

## v3.27.0 — 2026-08-22

**Name-collision policy** — a shadowed skill name is caught at authoring time, not in use

> Version 3.26.0 is reserved for the in-flight `rules/requirements/ai.md` work on its own branch,
> which is already renumbered to it. This release takes 3.27.0 so neither has to move again.

v3.25.0 renamed two skills that Claude Code built-ins were shadowing and noted that a check at
authoring time was the durable fix. This is that check. The failure it prevents is silent: a
shadowed skill loads nothing and reports nothing, so the only signal is a skill that mysteriously
never runs.

### Added

- **`skills/write-a-skill/RESERVED-NAMES.md`** — the names Claude Code claims, in one file read by
  two skills and restated by neither (PRINCIPLE 6). Carries the bundled-skill names, the built-in
  slash commands, an **At Risk** watch list (`build`, `deploy`, `publish`, `research`, `commands`,
  `learn`, `teach`), a **Deliberately Avoided** register so a later tidy-up cannot walk back into a
  collision Forge already steers around, and a **Withdrawn** section for names the vendor releases.
- **A verification stamp and a written refresh procedure.** There is no API that emits the vendor's
  reserved names, so the list is hand-maintained and stale by construction. The stamp records the
  date, the Claude Code version, and whether each row was *confirmed* in a live session or
  *recalled* — the two carry different weight, and collapsing them would be the whole defect. The
  procedure says how to move the date rather than leaving it to age quietly.
- **The Claude Code version is recorded as not determined.** `claude` is not on `PATH` on the
  authoring machine, so the stamp says so instead of guessing. The next refresh fills it in.

### Changed

- **`$write-a-skill` 1.4.0** — a new step 2 checks the proposed name before anything is scaffolded,
  and reports the result either way, naming the stamp date so the author knows what a pass is
  worth. A match **stops and gates**: rename, or type `CONFIRM` to proceed. The block is
  overridable because the list is stale in both directions — a name on it may since have been
  released, and an author who knows that should not be stuck. New failure-mode rows cover the
  shadowed-name symptom, the gate, and a stamp that has aged past the threshold.
- **`$skill-health` 1.1.0** — audits the whole portfolio against the same list, so a name that
  becomes reserved *after* the skill was written is caught rather than discovered in use. A
  shadowed name is 🔴 Critical and leads the critical warning ahead of a missing `SKILL.md`: a
  skill with no file is visibly broken, a shadowed skill is invisibly broken. An At Risk match and
  a stale stamp are ℹ️ Info. The audit stays read-only — a stale stamp is reported, never
  refreshed, because refreshing it needs a live session this skill does not have.
- **`$skill-health` never reports a name as clear.** It reports it as unchecked against a list
  stamped on a given date, which is what absence from a hand-maintained list actually means.

### Note

Zero of Forge's 113 skill names are reserved today — the two known collisions were fixed in
v3.25.0. Recommending no rename is the correct output of this release, and the check exists for
the names the vendor claims next.

---

## v3.25.2 — 2026-08-22

**`$write-a-skill` teaches the `no-adapt` fence** — the rule reaches the author who needs it

v3.25.1 added the fence and documented it in `CLAUDE.md` and
`ADAPTATION.md`. Neither is where a skill author is looking while writing a skill, so the rule was
discoverable only by someone already hunting for it.

### Changed

- **`write-a-skill` 1.4.0** — a fifth "After Writing Files" step, a Review Checklist item, and a
  Failure Modes row for host-name falsification. The checklist item carries the decision rule
  rather than restating the mechanism (PRINCIPLE 6): *ask which host the sentence is about, not
  which host will read it.*
- **The Codex-native override** gains the matching guidance on its own step 3 — "review the
  generated Codex copy" now says to read it for host names, not just structure, since that is the
  moment a falsification is visible. It also carries the inverse rule: **never write a fence marker
  into a file under `plugins/forge-codex/`**. Those files are hand-maintained and never adapted, so
  a marker there is not an exemption — it is a leak, and parity fails on it.
- **`write-a-skill` now practises the rule.** Its own line about `/user:skill-name`
  registering in Claude Code is fenced. That line was true only because the override
  skips adaptation entirely; fencing it means it stays true if the override is ever retired.

### Note

This is the follow-up flagged in v3.25.1. The ledger review it required was checked first: all 17
override hashes were in sync beforehand, so `update-forge-codex-overrides.ps1 -ConfirmReview`
re-stamped exactly the one changed entry. That tool rewrites **all 17** hashes on every run, so it
is safe only on a clean tree with no other override drift — logged for a `-Only` flag.

---

## v3.25.1 — 2026-08-22

**Host names stop being rewritten into lies** — a substitution exemption for the Codex build

`tools/build-forge-codex.ps1` rewrote `Claude Code` → `Codex` and `Claude` →
`Codex` on every adapted file, unconditionally. That is correct where the text means
*the host*, and false where it names Claude Code as a distinct
product. The shipped plugin therefore claimed "Codex ships built-in commands called `/continue` and
`/review`" — they are Claude Code's — "Dual-runtime Forge — Codex and
Codex", and that `~/.codex/forge/` "is Codex's directory" in an entry describing a
Claude-Code-only skill. Nothing failed; the statements just became
untrue.

The v3.25.0 name-collision work makes this sharper over time, because distinguishing which host
claims which name is the whole point of it.

### Added

- **`no-adapt` fences** — a marker pair (`<!--` `no-adapt` `-->` … `<!--` `/no-adapt` `-->`) in any
  adapted source withholds the fenced span from every substitution and restores it verbatim,
  stripping the markers. Fences wrap a phrase or a block, so a sentence can name
  Claude Code while its surrounding paths and skill names still
  adapt. Documented in `CLAUDE.md` § Naming a host product and
  `plugins/forge-codex/ADAPTATION.md` § Substitution Exemptions.
- **Two guards, because a silent exemption is the failure it replaces.** The build throws on an
  unbalanced fence; parity fails on a marker surviving into `plugins/forge-codex/skills/` or
  `references/` — either means the file was never adapted.

### Fixed

- **`references/CHANGELOG.md`** — the v3.25.0, v3.11.0, v3.9.0, v3.8.2, v3.5.0 and v2.7.0 entries no
  longer attribute Claude Code's built-in command namespace, command stubs,
  `~/.claude/` data directory, or the `$grill-with-claude` alias to Codex.
- **`pickup` 3.0.1** — "shadowed by a Claude Code built-in" survives
  as written. It was the sole non-override skill asserting a fact about another host's namespace,
  and it shipped false.
- **`vibe-security` 1.0.1** — the Usage block listed `**Codex:**` twice, having collapsed the
  Claude Code line into a duplicate of the Codex one.
- **`graphify` 1.0.1** — `references/exports.md` told Codex users to configure MCP in "Codex app"
  via `claude_desktop_config.json`, which is Claude Desktop's file.

### Note

Fences are needed only where a *non-override* skill names a host product. Codex-native overrides
(`write-a-skill` and the rest of `compatibility.json`) skip adaptation entirely, so their files are
safe by that route rather than by fencing — a protection that disappears the moment an override is
retired.

---

## v3.25.0 — 2026-08-22

**`/continue` → `$pickup`, `/review` → `/diff-review`** — two skill names were being shadowed

Claude Code ships built-in commands called `/continue` and `/review`. A built-in wins the name, so
invoking `/continue` ran the built-in rather than the Forge skill — quietly, with no error to
explain why the skill never appeared. `/review` had the same collision and had not yet been noticed.

A deprecation stub is not available as a mitigation: the old name is shadowed, so a stub left at
`commands/continue.md` would never be reached either. The old names simply stop working.

### Breaking

- **`/continue` is now `$pickup`.** It pairs with `$handoff`: one session puts a stream down, the
  next picks it up. Skill moves to `skills/pickup/`, command to `commands/pickup.md`.
- **`/review` is now `/diff-review`.** It names what the skill actually reviews — a pinned diff —
  and joins the existing subject-namespaced family (`brd-review`, `ord-review`, `security-review`,
  `performance-review`), where the bare `review` was always the odd one out. Skill moves to
  `skills/diff-review/` with its `smell-baseline.md`, command to `commands/diff-review.md`.
- Both skills carry major versions (3.0.0) because every reference to the old names breaks. 30 files
  updated across skills, rules, commands, README, and the pipeline diagrams. Historical CHANGELOG
  and README version-history rows are **not** rewritten — they record what shipped at the time.

### Note

Only these two of Forge's 113 skill names collide with a Claude Code built-in today. The vendor's
command namespace keeps growing, so a name check against built-ins at authoring time is the durable
fix — logged rather than built here.

---

## v3.24.0 — 2026-08-22

**One handoff per stream of work** — session state stops being a single file

`docs/HANDOFF.md` was one fixed path with overwrite semantics and three writers (`$handoff`,
`$save-state`, `$debrief`). A project running two threads of work at once had one entry point, so
the second handoff destroyed the first — and the loss was silent, because the file still existed
and still looked valid. The workaround in the wild was hand-named files in `docs/handoffs/` with
`-superseded` suffixes applied by hand, which is a stream register implemented in filenames.

### Added

- **`skills/handoff/STREAMS.md`** — the shared specification, cited by path from every session
  skill and restated in none of them (PRINCIPLE 6). Carries the file layout, the register and
  stream-file schemas, stream identity rules, the resolution table, the concurrent-writer conflict
  guard, the Active/Paused/Blocked/Closed lifecycle, and the migration procedure.
- **The stream register** at `docs/HANDOFF.md` — one pointer row per open stream (`Stream`,
  `Title`, `Status`, `Updated`, `Next action`, `Touches`), holding no content of its own. It is a
  view of the stream files in the sense of `rules/requirements/tables.md`: it restates by reference
  and introduces nothing.
- **Per-stream handoffs** at `docs/handoffs/<slug>.md`, archives at `docs/handoffs/archive/`, and
  `docs/handoffs/unassigned-*.md` for an emergency save with no resolvable stream.
- **`Touches` collision flagging** — two Active streams writing the same artefact are marked `⚠️`
  by whichever skill notices, rather than discovered later.
- **Concurrent-writer conflict guard** — a stream file whose `Last updated` moved under a session
  is never overwritten; the writer produces `<slug>.conflict-YYYY-MM-DD-HHMM.md` and stops for the
  human. Register updates are row-level, so two sessions on different streams do not collide.

### Changed

- **`$handoff` 2.0.0** — writes one stream, resolves which one before writing, and **stops and asks
  when more than one stream is Active and no slug is given**. Never infers the stream from what the
  conversation was about: the write is destructive and silent, so a wrong inference reintroduces
  exactly the failure this release removes. New `--close` flag retires a stream to the archive;
  `--archive` now writes into `docs/handoffs/archive/`.
- **`/continue` 2.0.0** — reads the register, presents a picker when several streams are open,
  takes a slug argument, and loads **one** stream's artifacts rather than everything. Age and
  stale-ticket checks are per stream. It never writes — a legacy handoff is read as-is and left for
  `$handoff` to migrate.
- **`$save-state` 2.0.0** — resolves the stream without ever asking a question, and where it cannot
  (two Active streams, nothing resolved this session) writes `unassigned-*` rather than guessing.
  An unassigned file is recoverable; an overwritten stream is not.
- **`$debrief` 2.0.0** — writes the stream it was run for and is the only session skill that
  **sweeps the register**: stale Active streams surfaced for Pause or Close, `Touches` collisions
  flagged, rows pointing at missing files reported as lost work rather than tidied away.
- **`$approve` 1.2.0** — closes the approved feature's stream (archive + drop the row) instead of
  resetting the whole handoff. Other streams keep running.
- **`/sprint-end` 1.1.0** — writes sprint close state to its own stream and leaves the others alone.
- **`$context-health` 1.2.0** — register budgeted separately at 300/400 tokens (it is pointers); the
  loaded stream file keeps the old 1,200/2,500 thresholds.
- **`project-template/docs/HANDOFF.md`** replaced with a register stub, plus `docs/handoffs/` and
  `docs/handoffs/archive/`. The template had been shipping a real handoff from Forge's own v2.3.7
  development.
- **`$commands` 1.0.1, `$write-a-skill` 1.3.2, `token-report` 1.0.1** — command descriptions, the
  worked stub example, and phase/session-count tracking updated for per-stream state.

### Migration

Automatic and idempotent. The next `$handoff` in a project detects a legacy single-document
`docs/HANDOFF.md` (heading `# Handoff:`, no `| Stream |` table), proposes a slug from its title for
confirmation, copies the body to `docs/handoffs/<slug>.md`, and writes the register in its place.
Nothing is deleted. Date-prefixed files already in `docs/handoffs/` are pre-2.0 archives; nothing
reads them and they can be moved into `archive/` at leisure.

---

## v3.22.2 — 2026-08-18

**Scenario naming gains negative space** — describing a rename does not enforce it

### Fixed

- A `$write-reqs` run still produced `Happy Path` in its output the day after v3.22.1 shipped. The
  source was correct everywhere — pack, rules, skills, no stale copy, `FORGE_REQ_PACK` unset — but
  **no rule anywhere forbade the old terms.** v3.22.1 described the new naming in the schema, the
  definition table and the template, and left the previous labels merely unused. Nothing stopped a
  revert to habit mid-document, which is exactly what a rename without a prohibition invites.
- `rules/requirements/tables.md` § Never now bans `Happy path`, `Happy Path`, `Error`, `Error Case`
  and `Edge` as scenario values and bans `Type` as the column heading, in tables *and* in prose.
- **`$write-prd` 2.6.1** carries the same rule as its first Never, scoped to every place the terms
  can surface — criteria tables, the Phase 1 summary, the coverage warning, the traceability
  matrix's criteria summaries — and requires a check of the finished document before presenting it.
- **`$write-reqs` 1.2.1** scans the returned PRD for the old terms before the Phase 3 gate and
  reports any found in the change set. Delegation does not transfer the check.
- **`$write-ac` 1.4.2** may read the pre-2.6.0 wording but never writes it back out — mapping on
  read is not licence to reproduce the old term on write.

### Notes

- Forge's own `PRINCIPLES.md` requires every skill to declare explicit negative space. v3.22.1
  changed positive instruction only and shipped without it; this is that omission, found in use
  rather than in review.

**`$write-prd`** — acceptance criteria say which weather they describe

### Changed

- **`$write-prd` 2.6.0** renames the acceptance-criteria column from `Type` to **`Scenario`** and its
  values from `Happy path` / `Edge` / `Error` to **`Sunny Day` / `Rainy Day` / `Edge Case`**. The
  column heading was the actual defect: `Type` invites the question "what type of criterion is this?",
  whose answer is always "an acceptance criterion" — the column was never naming a kind of row, it was
  naming the condition the requirement is put through. Each criteria table now carries a one-line
  lead-in saying so, and the template stub ships all three scenario rows rather than a lone happy path,
  so the shape of full coverage is visible before anything is filled in. Reported from repeated
  confusion in live showcases.
- Coverage warning at finalisation now names the missing scenario rather than reporting a count —
  *"PRD-003 is Sunny Day only"* — and states the consequence: specified for the demo, not production.
- **`rules/requirements/tables.md`** carries the canonical schema change and a definition table for the
  three values, plus an explicit note that the labels describe the *condition*, never the certainty —
  the `language.md` modal ban applies to a Rainy Day criterion exactly as to a Sunny Day one.
- **`$write-ac` 1.4.1** reads the new column and maps the pre-2.6.0 heading on sight
  (Happy path → Sunny Day, Error → Rainy Day, Edge → Edge Case) without rewriting the source PRD, so
  PRDs already in `docs/prd/active/` keep working.

### Changed — the pack and the rest of the portfolio

- **The requirements-documents pack now carries the naming**, so the skills read it rather than
  declaring a divergence from it. `reference/prd-standard.md` gains a § *The three scenarios* with the
  definition table and the demo-not-production warning; its INVEST coverage rule now reads "Cover
  Sunny Day, Rainy Day and Edge Case — at minimum"; the worked example's US-03 is retitled
  *(Rainy Day / Edge Case)*. A naming note records the one-to-one mapping from the pre-2026-08 wording
  so a reader holding an older copy is never stranded. `prd-standard-pack.html` carries the same
  content; `ord-standard-wiki.html` and `confluence-export/` regenerated from source; the
  `~/.codex/forge/knowledge/learning` copy and both `_export` bundles rebuilt.
- **The naming is now portfolio-wide.** `$test-coverage` 1.0.1 (generation priority order and the
  0%-coverage failure mode), `$jira` 1.0.1 (ticket test-scenario template), `$testplan` (automated-test
  classification) and `project-template.codex/forge/TESTING.md` all use Sunny Day / Rainy Day / Edge Case.
- **`$write-a-skill` 1.3.1** drops the term without adopting the scenario labels. Its four uses were
  the English idiom — *"a 'never' that's really steering the happy path"* — describing a skill's
  intended instruction flow, not a requirement under a condition. Rewritten as "intended behaviour",
  which is what the sentences meant. Renaming these to Sunny Day would have produced prose that reads
  as a category error.

### Fixed

- **`$write-reqs` 1.2.0** cross-linked into columns that do not exist. Phase 3 targeted a PRD matrix
  `ORD NFR Ref` column — the PRD matrix ends at `SOAP Ref` and has never had an ORD column — and an
  ORD matrix `PRD Ref` column, whose real name is `PRD#`. Both now target the ORD template's
  **Appendix B — PRD Cross-Link** (`ORD#` · `Section` · `PRD#`), which the ORD template already
  describes as the one link its register cannot hold and already names `$write-reqs` as populating.
  The skill was writing into a table it had misremembered rather than one it had read.
- The Phase 1 ORD brief now **requires Appendix B be retained**. The ORD template omits that appendix
  for a standalone ORD, so joint authoring has to ask for it explicitly or Phase 3 has nowhere to
  write. Two failure modes added: an authored ORD with no Appendix B, and one whose column headings
  differ from the template — both stop before the cross-link pass rather than improvising a column.
- The reciprocal NFR-home rule told the PRD to cite an ORD section. `$write-prd` forbids carrying a
  technical figure at all and cites the BRD cost-of-failure instead, so the rule now resolves a
  duplicated NFR by deletion at source rather than by rewriting it into a citation this chain does
  not support.
- Intro states plainly that **the two halves keep their own schemas** — a PRD story is narrative with
  criteria rows, an ORD requirement is a register row; they are never merged or reconciled, and
  Appendix B is held once and read both ways rather than mirrored as a column in each document.

### Notes

- `$write-reqs` still runs the ADR-0001 model in which the PRD and ORD are siblings, while
  `$write-prd` has been reworked onto a chain placing the ORD downstream of the SOAP. This release
  fixes the mechanical break only — every column named now exists and matches its template. The
  underlying question of which chain model is correct is **unresolved**, and `$write-prd`'s failure
  mode still says so when a joint-authoring brief arrives. Settling it needs an ADR, not an edit.
- `happy path` survives in exactly three places, all deliberate: the back-compat mapping lines in
  `$write-ac` and `$write-prd`, and the pack's naming note. Historical `CHANGELOG.md` entries are
  left as written — they are a record.
- `$testplan` is **not version-bumped here**. It carries unrelated in-flight work (operational mode
  against the ORD register) that is uncommitted at the time of writing; whoever lands that should bump
  it once, covering both changes.

---

## v3.22.0 — 2026-08-10

**`$write-brd`** — the chain gains its first hop, and it ends by testing its own exit criterion

### Added

- **`$write-brd` 1.0.0** authors a Business Requirements Document to the requirements-documents
  pack's BABOK v3 standard — the twelve-section anatomy and Appendix A, SMART objectives carrying
  baseline, target and date, the solution-vs-outcome test, a cost-of-failure case for each objective
  carrying operational exposure, and a §12 traceability skeleton. Three phases: **[AFK]** ingest and
  classify by the BABOK taxonomy, **[HITL]** write behind a confirmation gate, **[AFK]** run the
  gate. `$write-ord` already read `docs/brd/` and `/brd-review` already judged what arrived there;
  nothing wrote it.
- **Phase 3 is the handoff gate, self-assessed.** BH-1 – BH-10 with a verdict and an evidence
  citation each, and one of the four outcomes derived by precedence rather than judged. The standard
  puts this gate in the author's hands — a document's readiness is its author's to establish — so the
  skill runs it on its own output and then names `/brd-review` as the independent pass it **does
  not** replace. §8 names a reviewer who did not author the document as the highest-value Tier 1
  control, and a self-assessment cannot be one.
- **A refusal at Phase 3 needs no authority, and the skill says so.** `GATE-PROTOCOL.md`'s
  refusal-and-authority handling exists because declaring *someone else's* document not-ready
  requires a right the standard states is not yet held. Refusing your own does not: an absent bar
  item is the author's to fix, so the outcome returns to Phase 2 rather than being recorded and
  overridden.
- **Where the shared authoring rules meet the pack, the pack wins on BRD-specific forms.** A `[TBD]`
  carries **a named owner and a date** rather than `language.md`'s source quote — the gate reads both
  and a `[TBD]` missing either is a hole that fails the bar, so the generic form would have failed
  BH-1 on a document that looked correctly written.

### Changed

- **`tools/build-review-criteria.py` generates a third extract.** `write-brd/STANDARD.md` carries
  `brd-standard.md` whole plus the size table `$write-brd` reads Appendix A against, so the skill
  authors to a stamped standard on a machine that does not hold the pack — the same reason the two
  review skills ship `CRITERIA.md`. Per-skill output filename and heading noun are now a table:
  calling the BRD standard a set of *criteria* misdescribes the one skill that authors from the pack
  rather than judging against it. `brd-review/CRITERIA.md` and `ord-review/CRITERIA.md` are
  regenerated; their preambles reword, their bodies are unchanged.

---

## v3.21.2 — 2026-08-09

**Every grilling round now closes with a prompt** — a round the human doesn't recognise as a gate isn't one

### Changed

- `FRONTIER.md` gains a **Closing the Round** section, and `$grill-me` 1.2.0 → 1.2.1 and
  `$grill-with-docs` 2.2.0 → 2.2.1 pick it up by reference. Reported from live use of v3.21.0: the
  round rendered its five numbered questions and recommendations correctly and then simply stopped,
  leaving the human to guess whether to answer all five, argue with one, or wait for the session to
  continue. The frontier model made the round a HITL gate; nothing in the output said so.
- **The close names three moves — change, discuss, accept — and the count held back.** `discuss` is
  called out as the one that gets dropped and the one most worth keeping: a recommendation the human
  half-agrees with is where the design actually gets decided, and a human offered only
  accept-or-rewrite takes the recommendation to avoid the friction. That failure is invisible in the
  transcript, which is why it is a rule rather than a matter of style.
- **An explicit "accept all" is an answer** and settles those decisions. Silence still is not — the
  v3.21.0 rule that unanswered questions stay on the frontier is unchanged, and the two cases are now
  stated next to each other so they cannot be conflated.
- New `never` rule and a failure-mode row in both skills.

---

## v3.21.1 — 2026-08-08

**`$handoff` becomes user-invoked only** — the model can no longer overwrite the next session's entry point

### Changed

- `$handoff` 1.1.0 → 1.2.0 — `disable-model-invocation: true` added to frontmatter, with an explicit
  `[HITL]` execution-mode line stating why it is load-bearing. `$handoff` **overwrites**
  `docs/HANDOFF.md`, and `/continue` treats that file as its primary source at the next session start.
  A model that ran handoff on its own initiative destroyed the next session's entry point, and the
  loss was silent — the file still existed and still looked valid. The frontmatter field enforces
  PRINCIPLE 1 as a mechanism rather than as prose the model may or may not honour. The `$handoff`
  slash command is unaffected; no skill chains into handoff programmatically, so nothing else breaks.
- **First use of `disable-model-invocation` anywhere in Forge.** Other skills that silently overwrite
  a file another skill depends on are candidates for the same treatment; none are changed here.
- New failure-mode row: when the session merely *looks* like it is ending, say so and let the human
  call it. `$save-state` remains the human's move for imminent context exhaustion.
- The secret-redaction failure-mode row now states the reason it exists: `docs/HANDOFF.md` is tracked
  — `project-template/.gitignore` excludes only `$prototype` — so every handoff is committed and
  pushed, and that rule is the only control between a session secret and the remote.
- `origin:` frontmatter added, crediting Matt Pocock directly rather than relying on the body line.

### Source

Assimilated from Matt Pocock's `handoff` skill
(`github.com/mattpocock/skills` · `skills/productivity/handoff/SKILL.md`) via `$assimilate`.
Five of the source's seven instructions were already in Forge, in most cases more specifically —
suggested skills, reference-don't-duplicate, redaction, `argument-hint`, and tailoring to a stated
next focus. Only the invocation gate was new.

### Deliberately not adopted

- **"Save to the temporary directory of the OS — not the current workspace."** Upstream keeps the
  handoff out of the repo, which makes a leaked secret structurally impossible. Forge writes
  `docs/HANDOFF.md` because six skills read or write that path — `/continue`, `$debrief`,
  `$save-state`, `/sprint-end`, `$approve`, `$context-health` — it ships in `project-template/docs/`,
  and a tmpdir file cannot be handed to a colleague, which the skill's own description covers.
  Recorded here as a known residual: Forge trades a mechanism for a rule on this one.

---

## v3.21.0 — 2026-08-08

**Grilling moves from depth-first single questions to bounded frontier rounds** — assimilated from the rewritten upstream

### Added

- `global/.claude/skills/grill-me/FRONTIER.md` — the traversal protocol shared by `$grill-me` and
  `$grill-with-docs`. Defines the **design tree**, the **frontier** (every decision whose
  prerequisites are settled), the round, the `❓`/`➡️` question format, the facts-vs-decisions
  boundary, and the stop condition. Both skills reference it; neither restates it, per PRINCIPLE 6.
  The previous arrangement had the same rules written out twice in two skills and already showing
  drift, which is the defect this file removes.

### Changed

- `$grill-me` 1.1.0 → 1.2.0 and `$grill-with-docs` 2.1.0 → 2.2.0 — **the `never batch questions`
  rule is replaced.** Both skills now ask the frontier in rounds of up to 5 numbered questions,
  each carrying its recommended answer, then wait. The rule that replaces it is narrower and
  mechanically checkable: *never place a question in the same round as the question its answer
  depends on.* That dependency, not the count, is what the original rule was reaching for — two
  questions asked together are only confusing when one presupposes the other's answer.
- **Traversal is now dependency-driven, not order-driven.** The prior instruction was "walk each
  branch depth-first, resolving dependencies before moving to siblings", which allows a constraint
  discovered on branch 4 to invalidate branch 1. Working the frontier makes that impossible: a
  question is only asked once everything it depends on is settled.
- **The session has a hard stop condition.** "After all branches are resolved" becomes *the frontier
  is empty* — every branch visited, nothing silently assumed. A satisfied-sounding human no longer
  ends the session; a new failure-mode row makes the skill name what is still open instead.
- **Environment facts are delegated, non-blocking.** A frontier question needing a fact from the
  codebase or filesystem dispatches a subagent (Haiku per `rules/common/model-selection.md`) rather
  than asking the human. A running exploration is an unsettled prerequisite, so only the questions
  downstream of it wait — the rest of the round is asked immediately.
- Round cap and subagent routing are Forge additions, not upstream. Upstream asks the whole frontier
  with no ceiling; the cap of 5 keeps a round inside a human's working memory and preserves the HITL
  gate that PRINCIPLE 1 requires. Both skills now declare `[HITL]` explicitly, which neither did.
- Command stubs, the `grill-me` row in the command reference, and the `origin:` frontmatter on
  both skills updated. `origin:` now credits Matt Pocock directly rather than relying on the body
  credit line alone.

### Source

Assimilated from Matt Pocock's `grilling` skill
(`github.com/mattpocock/skills` · `skills/productivity/grilling/SKILL.md`) via `$assimilate`.
The upstream skill has been rewritten since Forge first adapted it — Forge's `one question at a
time` rule was a faithful copy of the earlier version, which upstream has since reversed.

### Known gap

- `$ia` carries its own `ask questions one at a time` rule (`SKILL.md` lines 38 and 101) while
  delegating to `$grill-with-docs`. Left unchanged in this release and recorded here rather than
  silently reconciled.

---

## v3.20.0 — 2026-08-07

**New skills `/brd-review` and `/ord-review`** — the requirements pack's own Tier 1 control, mechanised

### Added

- `/brd-review` 1.0.0 and `/ord-review` 1.0.0 — `[AFK]` advisory conformance reviews against the two
  handoff gates published in the `requirements-documents` pack. `/brd-review` applies the BRD gate
  (bar BH-1 – BH-4, supporting BH-5 – BH-10, the `[TBD]` treatment rule and its two limits);
  `/ord-review` applies §7.1 (bar OH-1 – OH-7, supporting OH-8 – OH-13) and adds three checks only
  the downstream hop can make: the §7.3 scan, where content the ORD must refuse to produce is
  reported as a **defect rather than a gap** because gaps drive the maturity tier and defects do not;
  the §5 tier rule, where the tier is the weakest status carried by any **KPP-bearing** requirement
  rather than the weakest anywhere; and §2.1, where a technical target is an antipattern **regardless
  of how well it traces**. Both derive one of the gate's four outcomes mechanically from the verdicts
  and emit no score — a percentage is trusted more than a conformance review earns.
- **Why these two, and why now.** §8 of the ORD Intake and Maturity Standard names *"a named
  independent reviewer on every ORD, who did not author it"* as its highest-value Tier 1 control and
  states that its absence causes **silent defect survival**. Every pass over that pack — including
  both `$critic` passes at pack v1.3 — has been its own author's, which the v1.3 critique named as
  the unfixed root cause behind three P1s. These skills are that control, mechanised.
- **The criteria are read at review time, never recalled.** This is the load-bearing constraint: a
  criterion copied into a skill drifts from the standard silently, and the drift is invisible in the
  output. No BH or OH item, no outcome and no threshold is restated in either skill's own prose.
- `tools/build-review-criteria.py` and a `CRITERIA.md` per skill — **the fix for a defect in the
  first cut of these skills.** They resolved the pack by path and stopped where it was absent; the
  pack is held locally and is not in this repo, so both skills were inert for everyone who cloned
  Forge and worked only on the author's machine. The generator now reads the pack and emits a
  stamped extract into each skill, committed like `build-forge-codex.ps1`'s output and never
  hand-edited. Sourcing order is the live pack first (authoritative), then the extract; where both
  are present and disagree, the pack wins and the extract is stale.
  - **Every report names the pack version it applied.** A verdict is only meaningful against a named
    bar — the pack's own thesis, applied to the review of it.
  - **`--check` fails the build on divergence and skips where no pack is held**, which is the CI
    case and is correct: only the pack's custodian can regenerate. Verified against all four states
    — current, drifted, restored, and pack-absent.
  - The generator **fails loudly on a missing section marker** rather than emitting a partial
    extract. A silently truncated criterion is worse than a failed build: the review still runs, and
    applies a criterion that lost half its text.
  - Extract sizes are 16 KB (BRD) and 63 KB (ORD, including the worked example ORD and the three
    desk references). The gate criteria themselves are ~15 KB — the earlier judgement that bundling
    was infeasible rested on measuring whole source files rather than the sections actually applied.
- `brd-review/GATE-PROTOCOL.md` — the protocol both gates share, cited by `/ord-review` by path
  rather than duplicated: the four-verdict vocabulary, the evidence rule (a verdict with no citation
  is an assertion), outcome derivation with its precedence order, refusal-and-authority handling, and
  the report format. It carries **no criterion** — protocol is tooling and has no home in the pack,
  which is barred from referencing Forge skills.
- **Refusal is recorded, not exercised.** The refusal outcome at both gates depends on the Tier 1
  control *"right to declare an ORD not-ready and refuse handoff"*, which the standard states is not
  currently held. Both skills report it as recorded, name the absent bar items, and state that the
  accumulation of those records is the evidence for establishing the control.

### Found while writing, and fixed in the pack

- **Both gates' second outcome had a hole**, and writing the derivation table is what exposed it.
  *Accepted with recorded gaps* / *Handed off with recorded gaps* was conditioned on an item in the
  **supporting** range being outstanding, so a document whose only gap was a declared one on a **bar**
  item matched no outcome row — met for the bar, not gap-free, and clear of the refusal. Neither gate
  stated which outcome wins when several apply, either; the precedence was being inferred from the
  worked assessment rather than stated. **Fixed at both gates in pack v1.4**, so `GATE-PROTOCOL.md`
  now quotes the precedence rather than reading it in. Same shape as the v1.3 defect where the worked
  example fell through all three outcomes — surfaced this time by mechanising the gate rather than by
  reading it, which is the argument for these two skills in one line.

---

## v3.19.0 — 2026-08-06

**New skill `$roap`** — grill a role definition into a single-page Role on a Page

### Added
- `$roap` 1.0.0 — fully HITL intake that produces `docs/roles/[role-slug]-roap.md`. Branches on **design** (role does not exist yet — answers are intent) or **document** (someone does the job today — answers are evidence), then asks nine questions one at a time: Role Title, Team, Reports To, Role Purpose, Key Accountabilities, Success Measures, Typical Activities & Allocation, Development Focus Areas, Key Relationships. The leading constraint is the page — capped sections (4–6 accountabilities, 3–5 measures, 4–7 activities, 2–3 development areas), allocation totalling exactly 100%, every success measure carrying a metric or named evidence source, and a ≤ 600-word page-fit check before review. Success measures follow `rules/requirements/language.md` (declarative present, no modals). Positions only — the skill never names an individual or records personal data, so a ROAP stays a role artefact rather than a performance record. Questions and probes in `GRILL.md`; section schemas, page template, and the soft-measure worked example in `FORMATS.md`.

---

## v3.18.0 — 2026-07-13

**New skill `/brain-setup`** — scaffold and audit the Karpathy second-brain knowledge model across three tiers

### Added
- `/brain-setup` 1.0.0 — sets up or audits the three-tier Raw/Wiki model (global `~/.codex/forge/knowledge/`, company `~/.codex/forge/companies/[name]/knowledge/`, and per-project folders), enforces a **mandatory human-declared scope** for every project (`personal` stays under the global tier permanently, whatever company context is active; `company` stays segregated under the company tier until deployment), and establishes the company `Wiki/pending-changes.md` ledger of potential/confirmed knowledge changes from in-flight company projects. Scope's sole source of truth is the `_scope.md` marker in the project's knowledge folder — **absence means company-restricted** (never shared, moved, or compiled into the global tier), so company information cannot leak global by omission and nothing is ever written to record restriction. `scope: company` must name an existing company install; scope change `company` → `personal` is forbidden in-skill (git history/team remote — manual action only); folder moves are typed-`CONFIRM`-gated per project with a git-sync warning. Design grilled via $grill-me and hardened via $critic (1 P1, 4 P2, 5 P3 — all resolved). Templates in `FORMATS.md`.

### Deferred (backlog 2026-07-13)
- **P2** — scope enforcement in `$ingest` and `$add-project` (read `_scope.md`, treat absence as restricted, ask scope at creation, pending-changes prompt): until it lands the scope model is only binding while `/brain-setup` runs.
- **P3** — merge-on-deploy: `$deploy` first needs a post-deployment cleanup hook, then fold a deployed company project's Wiki into the company Wiki and resolve its pending-changes rows; personal projects permanently exempt.

---

## v3.17.4 — 2026-07-10

**`write-a-skill` craft guidance gains the Negation failure mode** — assimilated from Matt Pocock's `writing-great-skills` skill + GLOSSARY (github.com/mattpocock/skills)

### Changed
- `$write-a-skill` 1.2.0 → 1.3.0 — added **Negation** to the skill-prose failure modes, the one substantive concept its `CRAFT.md` adaptation was missing. `CRAFT.md` gains a new **"Negation: Prohibition vs Guardrail"** section, a Failure Modes row, a Vocabulary entry, and a "Never" rule; the `SKILL.md` failure-modes quick-reference gets a matching row. (`CRAFT.md` was already origin-credited to this same source.)

### Assimilation notes
- **Resolved a real conflict, didn't just import it.** Pocock's Negation ("steering by prohibition backfires — frame positively") appears to contradict Forge PRINCIPLE 2 (*Negative Space Programming* — explicit "never" rules). The adaptation reconciles them by splitting "never" into two tools: **steering prohibitions** on the happy path (weak — reframe as a positive leading word) vs **guardrail prohibitions** on consequential/irreversible actions (strong — keep them; this is the negative space PRINCIPLE 2 protects). Net effect sharpens PRINCIPLE 2 rather than weakening it. No `PRINCIPLES.md` edit.
- **Already covered:** predictability, leading words, completion criteria, information hierarchy, split-by-invocation/sequence, pruning tests, invocation-load tradeoff, and ~16 GLOSSARY terms — all present in `CRAFT.md` from the original assimilation. No new skill created.
- **Dropped:** low-value GLOSSARY labels (Steering, Granularity, Post-Completion Steps) whose concepts `CRAFT.md` already conveys — adding the bare terms would fail CRAFT's own no-op test.

---

## v3.17.3 — 2026-07-10

**`$handoff` gains a secret-redaction rule** — assimilated from Matt Pocock's `handoff` skill (github.com/mattpocock/skills)

### Changed
- `$handoff` 1.0.0 → 1.1.0 — added an explicit **never-carry-secrets** rule: `HANDOFF.md` is a tracked workspace file read by `/continue`, so anything written to it is persisted. Never reproduce API keys, passwords, tokens, or PII surfaced during the session — reference where the value lives (env var, secrets manager, ticket) and redact anything sensitive that must be mentioned. Added a matching Failure Modes row. (Matt Pocock was already credited inline; the Forge `handoff` skill was originally adapted from this same source.)

### Assimilation notes
- **Kept:** the source's redaction instruction — the one point not already present in Forge's richer `handoff` skill; aligns with the security baseline ("never log raw bodies that may contain credentials or PII") and matters more in Forge because the handoff is a *persisted* artifact, not ephemeral scratch.
- **Dropped:** "save to the OS temp directory, not the workspace" — conflicts with Forge convention (Principle 6). Forge deliberately writes `docs/HANDOFF.md` in-workspace so `/continue` reads it and `--archive` snapshots it; the source treats the handoff as ephemeral. Forge's model is intentional and retained.
- **Already covered:** handoff summary, suggested-skills section, reference-don't-duplicate, argument tailoring. No new skill created.

---

## v3.17.2 — 2026-07-10

**Grilling skills sharpen the fact-vs-decision boundary** — assimilated from Matt Pocock's `grilling` skill (github.com/mattpocock/skills)

### Changed
- `$grill-me` 1.0.0 → 1.1.0 — the codebase-lookup rule is rewritten into an explicit **fact-vs-decision boundary**: *facts you look up; decisions you put to the human* — explore and answer any question the code can settle, but never decide on the human's behalf to keep the session moving. Added the rationale behind one-question-at-a-time (asking several at once is bewildering and buries the decision) and a first-time inline credit to Matt Pocock.
- `$grill-with-docs` 2.0.0 → 2.1.0 — same fact-vs-decision sharpening and one-at-a-time rationale applied to its Rules, so both grilling entry points give one consistent answer. (Matt Pocock was already credited inline.)

### Assimilation notes
- **Kept:** the crisp *look-up-facts / decide-nothing-for-the-human* split — it maps directly onto Forge Principle 1 ("The AI Executes. The Human Decides.") and hardens the existing lookup rule.
- **Changed:** phrased the decision half as an explicit Forge negative-space rule (*never decide on the human's behalf*); applied to both grilling skills for consistency.
- **Dropped:** the rest of the source — already covered, and more richly, by the existing grilling skills (CONTEXT.md grounding, term-conflict callouts, Shared Understanding Summary, next-stage routing, ADR offering). No new skill created.

---

## v3.17.1 — 2026-07-10

**`$build` gains an explicit test-execution cadence** — assimilated from Matt Pocock's `implement` skill (github.com/mattpocock/skills)

### Changed
- `$build` 1.2.0 → 1.2.1 — Step 3 (Execute with TDD) now states an explicit **test-execution cadence**: typecheck regularly and run single test files regularly during the RED/GREEN cycle, and run the **full suite once at ticket end** as the final gate before Step 4 review (a red full suite means the ticket is not done). Added a matching negative-space rule — *never run the full test suite after every change*. Credit noted inline in Step 3.

### Assimilation notes
- **Kept:** the tight-loop test rhythm — typecheck often, single files often, whole suite once at the end.
- **Changed:** attached the cadence to `$build`'s existing per-ticket TDD loop and phrased the whole-suite pass as the gate into Forge's `/review` step; expressed the "not every change" half as an explicit Forge negative-space rule.
- **Dropped:** "commit to the current branch" (per human decision — `$build` produces tested code only; committing stays out of its scope) and the rest of the source, already covered by `$build`'s existing TDD + `/review` wiring. No new skill created; Matt Pocock is already credited framework-wide in `PRINCIPLES.md`.

---

## v3.17.0 — 2026-07-10

**`$to-tickets` — plan/PRD → vertical-slice kanban tickets** — assimilated from Matt Pocock's `to-tickets` skill (github.com/mattpocock/skills)

### Added
- `$to-tickets` v1.0.0 — the missing "Kanban stage" that `$write-prd` hands off to. Converts a plan, PRD, spec, or conversation into a set of **vertical-slice tickets** (tracer bullets — each a narrow but complete path through every layer, independently demoable), sized to the **smart zone (<100k tokens)**, with **genuine, minimal blocking edges** and `[HITL]`/`[AFK]` tags. HITL by design: drafts autonomously, then **quizzes the human on granularity and blocking edges before writing** to `docs/kanban.md` in dependency order. Wide refactors are sequenced via **expand–contract** (one batch per ticket, CI green after each) rather than forced into a tracer bullet. "What to build" describes end-to-end user behaviour, never a layer-by-layer list. Delegates oversized slices to `$break-down`, sizing bands to `$estimate`, and external export to `$jira`.

### Changed
- `$break-down` 1.0.0 → 1.1.0 — reoriented toward **vertical-slice-first** to align with `$to-tickets`: a ticket touching several layers is now treated as a healthy tracer bullet, and **layer-based splitting is an explicit last resort** used only when a vertical slice still exceeds the smart zone (the old "touches multiple layers → split further" advice is gone). Cross-references `$to-tickets` as the plan→tickets entry point.
- `$write-prd` 2.1.2 → 2.1.3 — Phase 2 next-steps now names `$to-tickets` as the Kanban stage instead of describing it abstractly.
- `$commands` reference and README pipeline row/flow updated; README skill count 107 → 108; AGENTS.md registry count corrected to 108.

### Assimilation notes
- **Kept:** vertical-slice/tracer-bullet discipline, quiz-before-publish, minimal genuine blocking edges, topological ordering, expand–contract for wide refactors, "end-to-end behaviour not layer lists", domain-vocabulary + ADR grounding.
- **Changed:** `.scratch/` files and GitHub/native issue publishing → Forge's `docs/kanban.md`; "one context window" → the smart zone; `/implement` + "work the frontier" → Forge's `$build`; oversized-slice handling → `$break-down`.
- **Resolved the layer-vs-vertical tension:** adopted vertical-first everywhere and nudged `$break-down` to match, so the two ticket-shaping skills give one consistent answer.

---

## v3.16.0 — 2026-07-10

**`/review` two-axis overhaul + per-ticket wiring into `$build`** — assimilated from Matt Pocock's `code-review` skill (github.com/mattpocock/skills)

### Changed
- `/review` 1.0.0 → 2.0.0 — rebuilt around a **two-axis** methodology adapted from Matt Pocock's `code-review`. A **Spec axis** (does the diff fulfil its originating requirement — missing behaviour, scope creep, incorrect implementation, checked against the active PRD/ticket) and a **Standards axis** (project ADRs/CONTEXT/coding standards plus an immutable Fowler code-smell baseline) are now judged by **isolated parallel sub-agents** so neither contaminates the other, then reported separately without merging or re-ranking. Adds **fixed-point diff pinning** (never review the codebase blind), the **"repo overrides"** doctrine (documented standards beat the baseline; tooling-enforced rules skipped; smells are judgment calls, never hard P1s), and a new supporting reference `review/smell-baseline.md` holding the twelve smells. Retains Forge's P1/P2/P3 severities, advisory-by-default stance, and ADR/CONTEXT/PRD sources of truth. Attribution recorded in frontmatter `origin:` and the skill body.
- `$build` 1.1.0 → 1.2.0 — added **Step 4 — Post-Build Review** to the per-ticket execution loop: once a ticket's `$tdd` cycle is green, `/review` runs on that ticket's diff before the next ticket. AFK and advisory; a **P1 finding pauses** the loop for a human decision (fix now / defer to backlog / stop) — never auto-fixed, never silently passed. Subsequent loop steps renumbered (sign-off → 5, mark-done → 6, checkpoint → 7); Rules, Pipeline Position, and Failure Modes updated.

### Assimilation notes
- **Kept:** two-axis isolation via parallel sub-agents, fixed-point diff scoping, the Fowler smell baseline, the repo-overrides doctrine, aggregate-without-merging.
- **Changed:** git plumbing → Forge's kanban-driven ticket diffs; source's categories → Forge P1/P2/P3; standards sources → Forge ADR/CONTEXT/coding-rules; `general-purpose` agents → Forge sub-agent + model-selection routing.
- **Dropped:** a second standalone `/code-review` command (Forge already owns this slot with `/review` — Principle 6, Reference Don't Duplicate).

---

## v3.15.0 — 2026-07-10

**`$prototype` gains the Logic + UI Prototype methods and a pick-a-branch decision** — assimilated from Matt Pocock's `prototype` skill (github.com/mattpocock/skills)

### Changed
- `$prototype` 1.0.0 → 2.0.0 — reframed around **answering one named design question**, with a new **"Pick a branch"** decision (logic/state question → Logic Prototype; visual/UX question → UI Prototype) and a mandatory **Step 0: name the question** before coding. Adds two methodology references:
  - `prototype/logic-prototype.md` — build the logic as a **pure, liftable module** behind a **throwaway interactive harness** (TUI that clears each tick, renders current-state + keyboard shortcuts, loops init→keystroke→dispatch→re-render), with a module-shape heuristic (pure reducer / state machine / pure-function-set / stateful class), purity rules (logic imports nothing from the harness; nothing flows backward; no I/O or control-flow logging in the logic), one-command run via the project task runner, and "surface the state after every action".
  - `prototype/ui-prototype.md` — build **3–5 structurally different variants** (distinct layout/hierarchy/primary action, never cosmetic) behind a **dev-only switcher** (URL-driven, keyboard nav, gated out of production), read-only with stubbed mutations, reusing existing data-fetching and the project's component library. Two sub-shapes: **A** (variants inside the existing page, preferred) and **B** (throwaway route, last resort). Winning variant is rebuilt under real constraints; losers + switcher go to the throwaway branch. Web/React patterns framed as the concrete case, generalised for other platforms.
  Keeps Forge's `$prototype` folder convention (never `src/`), `LOGIC.md`/`UI.md` findings notes, and the no-tests/no-reuse/no-silent-carryover rules.
- `$write-prd` 2.1.1 → 2.1.2 — the `$prototype` cleanup step now **preserves before it deletes**: the spike is committed to a throwaway branch `prototype/[feature-name]` with a pointer recorded in the PRD's Implementation Decisions before `$prototype` is removed from the working tree (Principle 8, Every Decision Gets Recorded). If no git branch can be created, the spike is left in place rather than destroyed.

### Assimilation notes
- **Kept:** question-first framing, the logic-vs-UI branch decision, both prototype methods (Logic: pure-module-behind-throwaway-harness + module-shape heuristic + purity rules; UI: structurally-different variants behind a dev-only switcher, sub-shapes A/B, read-only), surface-the-state, one-command run, no-tests/no-reuse anti-patterns.
- **Changed:** "place spike adjacent to target" → Forge's single `$prototype` folder; UI method's React/Next specifics (`?variant=`, `NODE_ENV`, shadcn) generalised to "the web case, adapt per platform"; findings wired into Forge's `LOGIC.md`/`UI.md` notes and `$write-prd` handoff.
- **Adapted the preservation conflict:** Pocock preserves the spike on a throwaway branch; Forge previously deleted `$prototype` outright — adopted preserve-on-branch so the code survives as recorded evidence while Forge keeps its clean-working-tree convention. (This also matches Pocock's UI cleanup: losers + switcher to the throwaway branch, winner rebuilt in `src/`.)

---

## v3.14.0 — 2026-06-19

**`$write-ac` — PRD + ORD → Jira Capability acceptance criteria**

### Added
- `$write-ac` v1.0.0 — transforms an authored PRD and ORD into testable Jira acceptance criteria positioned by altitude. Phase 1 (AFK) reads the PRD (`PRD-NNN` stories), the ORD (`ORD-NNN` requirements, `[KPP]` tags), and the joined cross-link matrix, resolves the linked Jira Capability from `external_ids.jira`, and sorts every requirement — KPPs and headline functional outcomes promote to Capability-level AC; detailed story criteria, edge and error cases flow to child Epics/Stories — presenting the split for confirmation. Phase 2 (HITL) translates each requirement into a testable AC (functional → Given/When/Then; operational → threshold + measurement method, kept verbatim), carries the `PRD-NNN`/`ORD-NNN` source ID into each criterion, assigns stable `AC-NNN` IDs, and writes `docs/ac/[capability]-AC.md`. Jira push is optional and gated behind a typed `PUSH` confirmation; child issues that do not yet exist are listed for the human to create, never auto-created. Consumes requirements — never authors them, and never resolves BRD↔PRD↔ORD traceability (that stays in `$write-prd`, `$write-ord`, `$write-reqs`). Handles PRD-only or ORD-only inputs. Sits downstream of `$write-reqs` and feeds `$jira` and `$link-jira`.

---

## v3.13.0 — 2026-06-19

**`$write-reqs` — joint PRD + ORD authoring from a single source**

### Added
- `$write-reqs` v1.0.0 — authors a PRD and an ORD together from one source, per ADR-0001 (BRD is the single origin; PRD and ORD are siblings). Phase 1 (AFK) reads the BRD and source material once and classifies every need by nature — functional ("what the system does") → PRD, operational/NFR ("how it runs") → ORD — splitting dual-nature needs into a linked pair; this phase is ungated routing only. Phase 2 (HITL) delegates authoring end-to-end to `$write-prd` then `$write-ord`, each keeping its own confirmation gate, then runs a cross-link pass that fills the bidirectional BRD↔PRD↔ORD traceability columns neither sibling can complete standalone (PRD's `ORD NFR Ref`, ORD's `PRD Req`) and enforces the reciprocal NFR-home rule (PRD cites, ORD owns). Orchestrates the two sibling skills — never reproduces their templates or quality rules — resolving the orchestrate-vs-inline question left open in ADR-0001.

### Fixed
- Command reference (`$commands`) and README were missing `$write-ord` (shipped in v3.12.0 but never listed) — added both `$write-ord` and `$write-reqs` to the Pipeline rows; corrected the README skill count 104 → 106.

---

## v3.12.0 — 2026-06-19

**`$write-ord` — Operational Requirements Document generator; `$write-prd` ID scheme aligned**

### Added
- `$write-ord` v1.1.0 — ingests a call transcript, meeting notes, document, or conversation context and synthesizes a structured ORD organized by ISO/IEC 25010:2023 quality characteristics (Performance Efficiency, Reliability, Security, Compatibility, Flexibility, Maintainability, Interaction Capability, Functional Suitability, Safety). Two-phase AFK ingest → HITL write with mandatory confirmation gate. Phase 1 reads the BRD if present (the ORD's origin), extracts and classifies operational requirements, tags provenance, identifies KPPs, flags vague statements, and surfaces coverage gaps. Phase 2 assigns stable flat `ORD-001` requirement IDs, writes testable quantified requirements, and populates a BRD-anchored Requirements Traceability Matrix (ORD req → 25010 characteristic → BRD objective → source), flagging orphan scope and BRD coverage gaps. Saves to `docs/ord/[system-name]-ORD.md`. The standalone ORD is a sibling of the PRD — both derive from the BRD; joint authoring is the planned `$write-reqs`. Full template and ISO/IEC 25010:2023 taxonomy (including 2011→2023 delta) in `REFERENCE.md`.

### Changed
- `$write-prd` v2.1.1 — renamed user-story IDs `US-NN` → `PRD-001` (flat, sequential) for symmetry with `$write-ord`'s `ORD-001` scheme; the PRD↔ORD traceability matrix now references `PRD-NNN`/`ORD-NNN` across both documents. Story concept unchanged (still canonical user stories). `manifest.json` write-prd entry corrected to 2.1.1 (was stale at 2.0.0 after PR #18).

---

## v3.11.0 — 2026-06-18

**`$teach` — stateful multi-session learning, assimilated from Matt Pocock**

### Added
- `$teach` v1.0.0 — teach a subject across sessions, grounded in the learner's real **mission** and pitched at their **zone of proximal development**; curates high-trust resources, delivers short self-contained HTML lessons, builds storage strength through desirable difficulty (spacing, interleaving, retrieval practice), and records insights as pedagogical ADRs. Workspaces live under `~/.codex/forge/knowledge/learning/[topic-slug]/`. `SKILL.md` carries the workflow, gates, and pedagogy; `FORMATS.md` holds the MISSION / RESOURCES / learning-record / lesson / quiz formats. Reuses Forge's `$add-term` glossary convention, `$research` + research-first discipline, and the ADR/`$learn` record-everything spirit (PRINCIPLE 8) rather than duplicating them. Adapted from Matt Pocock's "teach" skill (github.com/mattpocock/skills) via `$assimilate`.

### Changed
- **All 104 skills** — added a `## Failure Modes` table and a `## Rules`/`## Never` section to every skill that lacked one, closing the P3 skill-completeness sweep (Failure Modes coverage 57% → 100%, Rules 93% → 100%). Each table is tailored to the skill's real failure conditions. Codex-native overrides `forge-update` and `grill-with-peer` updated in their own idiom; override review hashes refreshed. Documentation-only — no `forge_version` bump.
- Body attribution credits added to `accessibility`, `ai-first-engineering`, `context-health`, and `knowledge-onboard` (their `origin:` frontmatter named a source with no in-body credit).
- `grill-with-peer` — documented the `/grill-with-codex` (Claude) and `$grill-with-claude` (Codex) command aliases inline, clarifying the intentional orphan stubs.

### Housekeeping
- CHANGELOG version coverage reconciled: `critic` v1.1.0 (the correctness/completeness/consistency fixes shipped under v3.8.1) and `ia` v1.3.0 (the Impact Assessment skill, added under v3.8.0) were present in `manifest.json` but not previously tied to their version numbers here.

---

## v3.10.1 — 2026-06-18

**Skill-craft guidance assimilated into `$write-a-skill`**

### Added
- `write-a-skill` v1.2.0 — new `CRAFT.md` reference covering the craft of skill prose: **leading words**, checkable **completion criteria**, the 3-tier **information hierarchy**, the invocation-load tradeoff (adapted to Forge's dual-invocation convention), pruning discipline (**no-op / sediment / sprawl** tests), a failure-modes table, and a vocabulary table. Adapted from Matt Pocock's "Writing Great Skills" (github.com/mattpocock/skills) via `$assimilate`.

### Changed
- `write-a-skill` `SKILL.md` — added a "Writing well" pointer to `CRAFT.md`, sharpened Description Requirements (front-load the leading word, one trigger per branch, prune the description harder than the body), added a craft item to the Review Checklist, and added a Failure Modes table (the skill previously had none).

---

## v3.10.0 — 2026-06-14

**Scan-first build/spawn gate**

### Added
- `$scan-first` v1.0.0 — verify a ticket or task brief against live source before building or spawning agents on it; treats examples, counts, and "this is open" claims as hypotheses until checked, classifies each item OPEN/GHOST/PARTIAL, and gates agent spawning (not just sizing). Promoted from instinct-003 (`scan-engine-before-coverage-tickets`, 5 observations across solo TDD builds and multi-agent waves in PROJ-003).

---

## v3.9.0 — 2026-06-06

**Dual-runtime Forge — Claude Code and Codex from one repository**

### Added
- `$grill-with-peer` v1.0.0 — shared cross-model challenge protocol; Claude delegates to Codex and the Codex-native override delegates to Claude, with explicit consent, redaction, non-interactive execution, and transparent reconciliation
- `/grill-with-codex` and `$grill-with-claude` — thin runtime aliases that route to the shared peer-grilling protocol without duplicating workflow logic
- `$graphify` Claude command stub and manifest entry — restores parity for the upstream graphify skill
- `plugins/forge-codex/` — committed Codex plugin generated from the shared `global/.claude/` workflow source, with reviewed Codex-native overrides
- `.agents/plugins/marketplace.json` — repository marketplace entry for Codex installation
- `tools/build-forge-codex.ps1` — deterministic Codex plugin generation
- `tools/test-forge-parity.ps1` and `.github/workflows/forge-parity.yml` — fail when shared skills are missing, versions drift, generated output is stale, or machine-specific paths enter the plugin
- `plugins/forge-codex/compatibility.json` and `tools/update-forge-codex-overrides.ps1` — explicit review ledger for runtime-specific overrides; parity fails when a shared source changes until its Codex override is reviewed
- `global/.claude/commands/raid.md` — restores the missing Claude Code command stub so every shared skill is invocable in both runtimes

### Changed
- Forge now supports Claude Code and Codex under one shared framework version and changelog
- Codex project templates use `AGENTS.md`, `.agents/skills/`, and `.codex/forge/`
- Codex runtime differences are isolated to documented native overrides instead of silently diverging

---

## v3.8.2 — 2026-06-06

**New skill: $vibe-security**

### Added
- `$vibe-security` v1.0.0 — active security auditor for AI-generated codebases. Produces severity-ranked findings (Critical → High → Medium → Low) with before/after fixes. Loads technology-specific reference files on demand (Supabase RLS, Stripe, mobile, AI/LLM, deployment, data access). Activates proactively when writing or reviewing auth, payment, database, or API key code. Compatible with both Claude Code (`/vibe-security`) and OpenAI Codex (`$vibe-security`).
- 9 reference files covering: secrets & env vars, database security, authentication, rate limiting, payments, mobile, AI/LLM integration, deployment, and data access.
- `agents/openai.yaml` for Codex compatibility.
- Adapted from [Chris Raroque / Aloa](https://github.com/raroque/vibe-security-skill) — MIT licensed.

---

## v3.7.1 — 2026-06-01

**Critic fixes — correctness, completeness, consistency**

### Fixed
- `/forge-install` v2.0.1 — scenario detection script now uses PowerShell ReparsePoint check for Windows junctions; `[ -L ]` alone returns false for NTFS junctions and would misidentify an already-linked machine as needing migration
- `forge-sequence.mmd` — added `$qa-report` step to Phase 6 pipeline (was missing since v3.6.0); fixed `qa-plan.md` filename reference to `qa-plan-[feature].md`
- `$build` v1.1.0 — testplan pre-flight check upgraded from passive read to active warning gate; prompts to run `$testplan` first if no testplan file found
- `$qa-report` v1.1.0 — added step 0: identify active feature from `docs/prd/active/` and validate report filename matches; confirms save path before writing
- `$write-a-skill` v1.1.0 — "After Writing Files" now requires manifest version bump on skill updates and CHANGELOG entry; frozen version numbers explicitly called out as an error
- `manifest.json` — corrected stale versions: `context-health` 1.0.0→1.1.0, `write-prd` 1.0.0→1.1.0, `write-article` 1.0.0→1.1.0, `knowledge-health` 1.0.0→1.1.0

---

## v3.7.0 — 2026-06-01

**Junction-based sync — install.sh, /forge-install, /forge-update rewritten**

### Changed
- `install.sh` v2.0.0 — rewritten to create junctions (Windows: `mklink /J`) and symlinks (Mac/Linux: `ln -s`) for `skills/`, `commands/`, `rules/` dirs and 4 loose framework files (`CHANGELOG.md`, `PRINCIPLES.md`, `SOUL.md`, `forge-sequence.mmd`). Removes copy and backup steps entirely. Idempotent — skips already-linked targets. User-owned dirs (`knowledge/`, `instincts/`, `tokens/`, etc.) are never touched. Platform auto-detected via `$OSTYPE`/`uname`.
- `/forge-install` v2.0.0 — auto-detects scenario: fresh install, legacy migration, already linked (no-op), re-link, or iOS. Migration flow moves repo from any detected location (incl. `OneDrive/Forge`) to `~/forge`, then runs `install.sh`. iOS branch provides PR-only contributor guidance. HITL confirmation required before any file system changes.
- `/forge-update` v2.0.0 — simplified to `git pull` + version check + CHANGELOG display. Drops `update.sh` dependency entirely. Checks junctions are in place before pulling; redirects to `/forge-install` if not. Updates `forge-version` stamp preserving original `installed:` date.
- `update.sh` — deprecated with notice at top of file. Retained for backwards compatibility with legacy copy-based installs. Not called by any skill or `install.sh` going forward.

---

## v3.6.0 — 2026-06-01

**New skill: $qa-report — QA execution evidence artefact**

### Added
- `$qa-report` v1.0.0 — formalises QA session results into a datestamped evidence artefact at `docs/tests/results/[feature]-YYYY-MM-DD.md`. Prompts for structured evidence (CI run link, automated test output file, screenshot folder), records pass/fail/waived per TC-NNN item, computes a summary verdict, and sets an approve gate status. Pipeline: `$testplan` → `$tdd` → `$qa-plan` → *human tests* → `$qa-report` → `$approve`.

### Changed
- `$approve` v1.1.0 — QA report hard-block gate added as step 2 (before PII check). Hard-stops if no `docs/tests/results/[feature]-*.md` exists, or if the report's approve gate status is `Blocked` (unresolved P1 failures). All subsequent steps renumbered (3–14). Two new Failure Mode rows added.
- `$qa-plan` v1.1.0 — output renamed from `docs/qa-plan.md` to `docs/qa-plan-[feature-name].md` for naming consistency with `$testplan`. Closing prompt updated to direct user to `$qa-report` before `$approve`.

---

## v3.5.0 — 2026-05-29

**New skills: /forge-init, /forge-update + $ingest scope prompt + $context-health Intent Layer + category fields**

### Added
- `/forge-init` v1.0.0 — generates `~/.claude/CLAUDE.md` and `~/.claude/AGENTS.md` from a single source of truth. Writes skill-loading instruction and standing instructions (git safety, push confirmation, HITL gates, context limit) for Claude Code. Overlays company config (ai_human_signoff_required, ai_data_restrictions, ai_monthly_spend_cap_usd) when `active_company` is set. Called automatically by `/company-add` as its final write step; runnable standalone after config changes or Forge upgrades. `compatibility: codex: unsupported` (writes to `~/.claude/` which is Claude Code's directory).
- `/forge-update` v1.0.0 — self-update skill for Forge. Ensures `~/forge` clone exists, pulls latest, version-checks current vs incoming, surfaces the CHANGELOG section for the new version, confirms before running `update.sh`. Warns to start a new session after install.

### Changed
- `/company-add` v1.3.0 — runs `/forge-init` silently as its final write step, regenerating `~/.codex/forge/AGENTS.md` with company config overlays applied immediately after setup
- `$ingest` v1.2.0 — structured scope prompt replaces open-ended "which Raw/ folder?" question for all three modes. Reads active projects from `registry.md`, presents a numbered list, pre-highlights any project matching the current working directory, falls back silently to global when no projects registered. Frontmatter description corrected to reflect actual scope behaviour.
- `$context-health` v1.1.0 — Intent Layer child node recommendations added (adapted from Railly Hugo / Crafter Station, Tyler Brandt's Intent Layer framework). Phase 1 now scans first-level source directories (`src/`, `app/`, `lib/`, `packages/`, `services/`, `api/`, `components/`), flags subdirectories exceeding 20k tokens without an `AGENTS.md`, and adds a Child Node Recommendations section to the report with an inline `AGENTS.md` template. 3 new failure modes, 4 new rules.

### Housekeeping
- `category:` frontmatter field added to all 94 skill `SKILL.md` files — aligns with the README skill table groupings: `pipeline`, `ideation`, `session`, `code-quality`, `knowledge`, `metrics`, `pi-release`, `sprint`, `maintenance`, `company`, `framework`

---

## v3.4.0 — 2026-05-28

**Front-gate Phase 5 decision gate + sequence diagram documentation + install.sh auto-pull**

### Changed
- `$front-gate` v1.1.0 — Phase 5 revised from AFK write to HITL submission decision gate:
  - Option 1: **Submit to Jira** — saves brief with `status: pending-jira` to `docs/requests/YYYY-MM-DD-[slug].md`; flagged for company Jira integration to pick up
  - Option 2: **Save as draft** — saves brief with `status: draft` to `docs/requests/YYYY-MM-DD-[slug].md`
  - Option 3: **Discard** — exits without writing anything to disk
  - Rule added: nothing is written to disk until a Phase 5 selection is made — Phase 4 approval alone is not sufficient
  - FORMATS.md updated: YAML frontmatter added to Request Brief template (`status: draft | pending-jira`); `status` field rule added
  - Phase 4 cancel intent clarified: use when the brief itself is wrong; Discard in Phase 5 for a change of mind after approval
  - Failure mode added: re-prompt on invalid Phase 5 input
- `~/.codex/forge/forge-sequence.mmd` — rewritten to 12-phase pipeline; Phase 0 ($front-gate) added; all phases numbered; company, framework, and new skills added to bottom notes

### Added
- `docs/diagrams/` — 13 Mermaid sequence diagrams added to the repo: individual phase diagrams for Phases 0–11 plus `framework-complete.mmd` (full pipeline). Render at [mermaid.live](https://mermaid.live) or any Mermaid-compatible tool.

### Fixed
- `install.sh` — auto-pulls latest from GitHub before installing when run inside a git clone; re-reads `forge_version` after pull so the installer banner shows the updated version; correct usage comments added

---

## v3.3.0 — 2026-05-28

**New skill: $front-gate**

### Added
- `$front-gate` v1.0.0 — structured intake for non-technical users submitting an idea or request for team consideration. Middle ground between `$grill-me` (no doc context) and `$grill-with-docs` (full codebase). Grills the requestor one question at a time using plain language and example answers. Checks `knowledge/systems/` for constraints on any mentioned systems and surfaces conflicts inline before continuing. Produces a Request Brief saved to `docs/requests/YYYY-MM-DD-[slug].md`.
  - Phase 1 [AFK]: interpret — restates idea in plain language, confirms with requestor, reads knowledge base for mentioned systems (silent)
  - Phase 2 [HITL]: grill — 7 questions one at a time: Problem Statement, Objective, Metrics (optional — baseline + goal), What Is Needed, Risk of Doing Nothing, Negative Impacts, Brief Summary
  - Phase 3 [AFK]: compile answers into Request Brief using `FORMATS.md` template
  - Phase 4 [HITL]: review gate — "yes / edit / cancel" before writing to disk
  - Phase 5 [AFK]: write to `docs/requests/YYYY-MM-DD-[slug].md`, confirm with next-step suggestions *(revised to HITL decision gate in v3.4.0 — see above)*
  - Integration: `$idea`, `$grill-with-docs`, `$write-prd`, `$ingest`, `knowledge/systems/*/Wiki/`

---

## v3.2.0 — 2026-05-28

**New skill: $caveman (assimilated from Matt Pocock / AIHero.dev)**

### Added
- `$caveman` v1.0.0 — behavioral toggle that strips articles, filler, pleasantries, and hedging from AI responses to reduce output token usage by ~75%. Technical accuracy fully preserved. State persisted in `preferences.md` (`caveman-mode: on/off`). Safety exception auto-pauses for all HITL gate confirmations and destructive action prompts. Deactivate with `$caveman --off` or "normal mode".
  - Origin: Adapted from Matt Pocock (AIHero.dev / github.com/mattpocock/skills)

---

## v3.1.0 — 2026-05-28

**New skill: $seo (assimilated from Affaan Mustafa / ECC)**

### Added
- `$seo` v1.0.0 — SEO audit and remediation planning. Reads source files directly (no external crawl tool required), ranks findings by severity, and produces a dated report to `docs/seo/`.
  - Phase 1 [AFK]: orient scope — reads `AGENTS.md`, locates `robots.txt`, `sitemap.xml`, and HTML template layer; prompts for scope if no flag passed
  - Phase 2 [AFK]: audit against three-tier taxonomy — Critical (crawlability: robots, canonicals, redirects, broken sitemaps), High (on-page: titles, metas, headings, JSON-LD, Core Web Vitals), Medium (content: thin pages, alt text, orphans, cannibalization)
  - Phase 3 [HITL]: presents ranked findings, confirms which severity tiers to address before creating any tickets
  - Phase 4 [AFK]: writes `docs/seo/audit-YYYY-MM-DD.md` using `FORMATS.md` template; assigns `SEO-YYYYMMDD-NNN` IDs
  - Phase 5 [HITL]: optional kanban ticket creation for confirmed findings — detail stays in report, kanban holds ID + one-liner only
  - Flags: `--audit`, `--page <path>`, `--schema`, `--vitals`, `--content`, `--analyze-only`
  - Integration: `/review` (template changes), `$build` (remediation tickets), `$qa-plan`, `$go-nogo`
  - Origin: Adapted from Affaan Mustafa (ECC / github.com/affaan-m/ECC)

---

## v3.0.0 — 2026-05-28

**New skill: $test-coverage (assimilated from Affaan Mustafa / ECC)**

### Added
- `$test-coverage` v1.0.0 — reactive coverage gap remediation for existing codebases. Distinct from `$tdd` (proactive, test-first): this skill analyzes what's already written and closes the gaps.
  - Phase 1 [AFK]: detect framework via `tools/global.md` `test-runner` category, fall back to file-based detection (jest, vitest, pytest, cargo, maven/jacoco, go)
  - Phase 2 [AFK]: run coverage command, capture output
  - Phase 3 [AFK]: rank files below threshold worst-first; identify untested functions, missing branches, dead code
  - Phase 4 [HITL]: show gap analysis, confirm which files to address before writing anything
  - Phase 5 [AFK]: generate missing tests (happy path → error handling → edge cases → branch coverage); assigns TC IDs via `docs/tests/registry.md`; matches existing project test style
  - Phase 6 [AFK]: verify full test suite passes; re-run coverage
  - Phase 7 [AFK]: before/after comparison table; updates `preferences.md` for `$go-nogo` integration
  - Flags: `--analyze-only`, `--file <path>`, `--threshold <N>`
  - Threshold: reads from `AGENTS.md`; defaults to 80% (quality-checklist.md standard)
  - Origin: Adapted from Affaan Mustafa (ECC / github.com/affaan-m/ECC)

### Version note
Bumped to v3.0.0 — four skills added in one session (git-guardrails, jira, skill-health, test-coverage) completes a significant capability expansion.

---

## v2.9.0 — 2026-05-28

**New skill: $skill-health (assimilated from Affaan Mustafa / ECC)**

### Added
- `$skill-health` v1.0.0 — read-only structural audit of the Forge skill portfolio. Checks every manifest.json entry for: SKILL.md directory, command stub, required sections (Failure Modes, Rules), frontmatter completeness, CHANGELOG coverage for version bumps, and attribution credit lines in assimilated skills. Saves report to `~/.codex/forge/knowledge/skill-health-report.md`.
  - 🔴 Critical: manifest orphans (no SKILL.md), missing frontmatter
  - ⚠️ Amber: missing sections, missing command stubs, CHANGELOG drift, attribution gaps
  - ℹ️ Info: directory orphans, orphaned command stubs, version mismatches
  - Flags: `--critical`, `--skill <name>`
  - Sprint-start integration: warns if overdue (>30 days)
  - Completes the Forge health triad: context-health (tokens) + knowledge-health (articles) + skill-health (skills)
  - Concept adapted from Affaan Mustafa (ECC / github.com/affaan-m/ECC); Forge-native implementation — no runtime telemetry or Node.js scripts required

---

## v2.8.0 — 2026-05-28

**New skill: $jira (assimilated from Affaan Mustafa / ECC)**

### Added
- `$jira` v1.0.0 — live Jira API integration with four subcommands:
  - `get <TICKET-KEY>` [AFK] — fetch ticket and produce structured analysis: requirements, acceptance criteria, test scenarios (happy/error/edge), dependencies, and recommended next steps
  - `comment <TICKET-KEY>` [HITL] — gather session progress from DEVLOG + kanban, preview comment, post on confirmation
  - `transition <TICKET-KEY>` [HITL] — fetch available transitions, present options, execute on selection; offers to sync `docs/kanban.md`
  - `search <JQL>` [AFK] — run JQL query and return a summary table (max 20 results)
  - `setup` [HITL] — guided credential configuration: MCP server (preferred) or env vars
  - Auth: MCP server → env vars fallback; never stores credentials in source files
  - Complements `$link-jira` (static ID mapping) with live API interaction
  - Origin: Adapted from Affaan Mustafa (ECC / github.com/affaan-m/ECC)

---

## v2.7.0 — 2026-05-28

**New skill: $git-guardrails (assimilated from Matt Pocock)**

### Added
- `$git-guardrails` v1.0.0 — hard-blocks dangerous git commands via a `PreToolUse` hook, enforced at the Claude Code tool level rather than the AI instruction level. Complements `rules/common/git-safety.md` (soft rules) with OS-level enforcement. Guided setup for project or global scope, with Windows/Git Bash compatibility notes. Includes deployable `block-dangerous-git.sh` hook script.
  - Blocks: `git push`, `git reset --hard`, `git clean -f/fd`, `git branch -D`, `git checkout .`, `git restore .`
  - Flags: `--project`, `--global`, `--verify`, `--remove`
  - Origin: Adapted from Matt Pocock (AIHero.dev / github.com/mattpocock/skills)

---

## v2.6.0 — 2026-05-25

**New skill: /company-update + critic resolution (16 issues)**

### Added
- `/company-update` v1.0.0 — post-install maintenance for company repos. Two modes:
  - `--reconfigure`: re-run any of the 8 grilling topics from `/company-add` against the existing config; shows a diff of changes before writing; fields from unselected topics are untouched
  - `--update-skills`: compare version fields of the 17 bundled skills against `~/.agents/skills/`; show an update inventory; copy newer versions on confirmation
  - `--all`: reconfigure then update-skills in sequence
- `decisions/ADR-001-one-company-per-install.md` — formal ADR documenting the one-company-per-install constraint: rationale (unambiguous path resolution, knowledge contamination risk, config conflicts), alternatives considered, and revisit criteria

### Changed
- `/company-add` v1.2.0 — multiple correctness and completeness fixes:
  - `setup.sh` template: replaced `sed -i` (broken on macOS — requires backup suffix) with portable `awk` equivalent
  - Frontmatter description: removed stale "instincts" reference
  - Confirm block and AGENTS.md template: corrected bundled skill count from 18 to 17 (learn was removed last patch)
  - Embedded AGENTS.md template: removed `instincts/` from repository structure section
  - Company Skills section header: corrected "18 skills" to "17 skills"
  - `config.md` template: added `git_remote` / `git_branch` fields (default `origin` / `main`) — read by `/company-sync`
  - Next steps: added step 10 — rename `technology1–technology8` to actual domain names with example `mv` command and follow-up note
- `/company-sync` v1.1.0 — safety and portability improvements:
  - Push phase now reads `git_remote` and `git_branch` from `config.md` (defaults to `origin` / `main`)
  - Added HITL gate before committing: shows a `git status --short`-style file list and requires `SYNC` before staging or committing
  - Merge conflict guidance expanded: explains that knowledge article conflicts should be merged (combining content), not overwritten; provides step-by-step resolution commands
  - Failure modes: added branch protection rejection and missing git config fields
- `$ingest` v1.1.0 — technology sub-category routing:
  - When processing items from `technology/Raw/`, after classifying, lists available sub-categories and asks the user which domain each item belongs to (HITL per item)
  - `top` option available to route to `technology/Wiki/` without a sub-category; flagged in compile log for later review
  - Step numbering corrected (10 and 11, not 9 and 10)
- `$build` — fixed duplicate `### Step 5` label in execution loop; second Step 5 renamed to Step 6 — Context Checkpoint
- `$write-a-skill` — two checklist corrections:
  - "SKILL.md under 100 lines" replaced with realistic guidance (~400 lines for workflow logic; dense reference material extracted to REFERENCE.md)
  - Added `forge-sequence.mmd` review item: update diagram when a new pipeline phase is added or phase order changes
- `SOUL.md` — added AFK exception to the file-writing rule: during `$build` AFK execution, writing code, tests, and kanban updates is the expected autonomous output (not a HITL violation)
- `install.sh` — FORGE_VERSION now read dynamically from `manifest.json` instead of hardcoded; never drifts on version bumps
- `update.sh` — added `decisions/` directory to framework file sync; ADRs are now updated alongside PRINCIPLES.md and SOUL.md on `bash update.sh`

### Fixed
- P1-1 `setup.sh` macOS portability — `sed -i` → `awk`
- P1-2 Stale "instincts" in company-add frontmatter description
- P1-3 Wrong bundled skill count (18 → 17) in three locations
- P1-4 `/company-sync` blind commit — HITL gate added
- P1-5 `$build` duplicate Step 5 numbering
- P2-7/P2-8 No post-install update path — resolved by `/company-update`
- P2-9 `$ingest` had no technology sub-category routing
- P2-10 `$write-a-skill` 100-line rule was fiction in practice
- P2-11 `/company-sync` hard-coded `origin main` — now reads from config
- P3-12 One-company constraint undocumented — ADR-001 written
- P3-13 No rename-domain guidance — step 10 added to /company-add next steps
- P3-14 SOUL.md contradiction with AFK mode — exception clause added
- P3-15 forge-sequence.mmd update criterion vague — checklist item added to $write-a-skill
- P3-16 Merge conflict guidance for prose knowledge files was absent

---

## v2.5.8 — 2026-05-25

**Company structure mirrors global: Raw/Wiki/Outputs, rules, projects, tools, legal, technology**

### Changed
- `/company-add` v1.1.0 — scaffold now mirrors global `~/.codex/forge/` structure:
  - Added `knowledge/Raw/`, `knowledge/Wiki/`, `knowledge/Outputs/` — three-tier knowledge pipeline lands in company repo; `$ingest` already routes here when `active_company` is set
  - Added `knowledge/legal/` with full three-tier structure (Raw/Wiki/Outputs) — contracts and legal advice are ingested via Raw/ first; Wiki index stub notes legal privilege sensitivity and suggests `/pii-check` before sharing
  - Added `knowledge/technology/` with Raw/Wiki/Outputs at the domain level; 8 placeholder sub-categories (`technology1/`–`technology8/`) with Wiki/Outputs only — Raw/ lives at `technology/` level, `$ingest` classifies and routes articles into the correct sub-category Wiki/; each sub-category also has a `hardware/` folder (Wiki/Outputs, no Raw/); sub-categories renamed to actual domains at company install
  - Added `projects/` with `registry.md` stub — company-level project index; populated by `$add-project` and `$create-project`. Distinct from `knowledge/projects/` (which holds knowledge content per project)
  - Added `tools.md` — required/approved/prohibited tools registry; scaffolded by `/company-add` and populated via `/tool-add --company [name]`
  - Added Topic 8 — Tools Policy grilling: captures prohibited tools (compliance/licensing), required tools (security scanners, test runners), and approved standard tools; writes skeleton entries to `tools.md` with TODO comments
  - Added `rules/` with `README.md` stub — company rule extensions layer on top of global `~/.codex/forge/rules/common/` baseline
  - Fixed `ideas/archive/` → `ideas/archived/` to match global naming
  - Added `.codex/forge/` scaffold to company repo: 17 company knowledge skills bundled verbatim from `~/.codex/forge/` at install time (commands + SKILL.md files); teammates who clone the repo run `setup.sh` — no full Forge install required
  - Added `setup.sh` — symlinks `~/.codex/forge/companies/[name]` → repo root, sets `active_company` in preferences.md, installs bundled skills to `~/.codex/forge/`; works on macOS/Linux (Git Bash/WSL for Windows)
  - Added `.codex/forge/AGENTS.md` — repo-level onboarding context: explains structure, lists available commands, documents setup process
  - Bundled skills (17): `ingest`, `knowledge-health`, `add-system`, `add-term`, `summarise-system`, `update-context`, `lookup`, `style-check`, `pii-check`, `company-sync`, `add-project`, `incident`, `pir`, `idea`, `tool-add`, `tool-check`, `knowledge-onboard`
  - **Instincts intentionally excluded from company repo** — instincts are personal (tailored to individual way of working) and stay in global `~/.codex/forge/instincts/` only; not a shared team artefact
  - Updated confirm summary, skills list, and next steps to reflect full structure
- `$learn` v1.0.0 — reverted to global-only; no company routing
  - Instincts always write to `~/.codex/forge/instincts/` regardless of `active_company` setting
  - Removed Step 0 scope selection that was added in v1.1.0

### Fixed
- `rules/common/git-safety.md` — present in `forge/global/` but missing from installed `~/.codex/forge/rules/common/`; added to live install

---

## v2.5.6 — 2026-05-23

**New skills: /knowledge-onboard, /style-check + company knowledge layer**

### Added
- `/knowledge-onboard` — guided company knowledge setup for a new employer. Four-stage sequence: style guide → acronyms → domain terms → core systems. HITL gate between every stage. Multi-source ingestion: Confluence URL, file path (PDF/Word), manual paste (SharePoint), or verbal description. Produces `style-guide.md`, populates `acronyms.md` and `context.md`, and scaffolds system knowledge via `$summarise-system` logic.
- `/style-check` — reviews any document against `~/.codex/forge/knowledge/company/style-guide.md`. CRITICAL/HIGH/LOW severity model (mirrors `/pii-check`). Pass/fail gate: APPROVED or NEEDS REVISION. Gracefully degrades if style guide is a placeholder.
- `~/.codex/forge/knowledge/company/style-guide.md` — placeholder template covering written style, formatting, fonts, colour scheme, approved/banned terminology, logo usage, and document types. Populated via `/knowledge-onboard` or manually at the company.

### Changed
- `$write-article` — reads `style-guide.md` before writing (step 0 of writing process); quality gate now includes a `/style-check` reminder for external deliverables
- `$write-prd` — reads `style-guide.md` in Phase 2 before writing
- `$knowledge-health` — company knowledge scan now checks for `style-guide.md`: missing = P1, all-placeholder = P1, partially populated = P2

### Deferred
- `api.md` template and `$add-system` extension — deferred for future build
- `$summarise-system` API ingestion path — deferred for future build

---

## v2.5.5 — 2026-05-23

**New skill: $lang-rules + common coding rules layer + rules/README enrichment**

### Added
- `$lang-rules` — install and activate language-specific coding rule sets for the current project. Detects languages from project files, copies matching rule sets from `~/.codex/forge/rules/<lang>/` into `.codex/forge/rules/`, and writes `.codex/forge/rules/active.md` so `/review`, `$build`, and `$push-standards` know which baselines apply. HITL gate before writing. Adapted from Affaan Mustafa (ECC / github.com/affaan-m/ECC) via $assimilate.
- `~/.codex/forge/rules/common/coding-style.md` — universal baseline: immutability, KISS/DRY/YAGNI, file/function size limits (800-line cap, 50-line function cap, 4-level nesting cap), error handling, input validation, naming conventions.
- `~/.codex/forge/rules/common/quality-checklist.md` — pre-ship checklist covering code quality, testing, security, and CI integration. Referenced by `/review` and `$qa-plan`.
- `~/.codex/forge/rules/common/research-first.md` — search-before-writing rule: codebase → package registry → GitHub → docs → web. Explicit never rules.
- `~/.codex/forge/rules/common/security.md` — pre-commit security checklist and escalation triggers for `/security-review`.
- `~/.codex/forge/rules/README.md` — documents the layered rules architecture and how skills consume it.

### Changed
- `$push-standards` — now reads `.codex/forge/rules/active.md` before exploring the codebase. Uses installed language rules as the baseline; only documents patterns that extend beyond what global rules already define.
- `~/.codex/forge/rules/README.md` — added "Rules vs Skills" distinction (rules = what to meet; skills = how to do it) and "Scaffold a new language" file spec with required opening line format. Adapted from Affaan Mustafa (ECC / github.com/affaan-m/ECC).
- `$lang-rules` — added scaffolding spec: exact file set for a new language directory (`coding-style.md`, `testing.md`, `patterns.md`, `hooks.md`, `security.md`) and required `> This file extends...` opening line convention.

---

## v2.5.4 — 2026-05-22

**New skill: $write-article**

### Added
- `$write-article` — write long-form content in a concrete, human voice. Covers Confluence pages, README, stakeholder summaries, Go/No Go briefs, research outputs, and release notes. Core rules: lead with concrete thing, use proof over adjectives, banned patterns list (AI filler), format guidance per document type, quality gate checklist. Adapted from Affaan Mustafa (ECC / github.com/affaan-m/ECC) via $assimilate.

---

## v2.5.3 — 2026-05-22

**New skill: $assimilate**

### Added
- `$assimilate` — adapt external ideas into Forge with proper attribution. Phase 1 (AFK) fetches source and evaluates fit (what maps, what adds value, what doesn't apply). Phase 2 (HITL) adapts with Forge conventions and writes the skill. Mandatory `origin:` frontmatter field and body credit. Checks against PRINCIPLES.md for conflicts. Attribution standard: "Adapted from [Author] ([Source] / [URL])".

### Changed
- `$write-a-skill` checklist — note added: if adapting from an external source, use `$assimilate` instead

---

## v2.5.2 — 2026-05-22

**New skill: $ai-first-engineering**

### Added
- `$ai-first-engineering` — operating model for AI-assisted delivery teams. Five core process shifts, agent-friendly architecture requirements, AI-first code review focus (behaviour/security/integrity over syntax), testing standards for generated code, anti-patterns, and Forge pipeline alignment table showing which phase embodies which principle. Adapted from ECC (github.com/affaan-m/ECC) by Affaan Mustafa.

### Changed
- `PRINCIPLES.md` — reference to `$ai-first-engineering` added as Further Reading

---

## v2.5.1 — 2026-05-22

**New skill: $accessibility**

### Added
- `$accessibility` — WCAG 2.2 Level AA compliance skill. Covers Web (ARIA/HTML5), iOS (SwiftUI), and Android (Compose). Implementation steps (POUR), cross-platform attribute mapping, code examples, anti-patterns, and a QA checklist for $qa-plan integration. Adapted from ECC (github.com/affaan-m/ECC) by Affaan Mustafa.

### Changed
- `$qa-plan` — rules updated: for any feature with a UI component, the accessibility QA checklist from $accessibility is included in the plan

---

## v2.5.0 — 2026-05-22

**Continuous learning — instincts system. Inspired by ECC.**

### Added
- `$learn` — capture a session pattern as a Forge instinct. Accepts inline description, asks one behaviour question, checks for duplicates, increments observation count if match found. Low/Medium/High confidence based on observation count (1/3+/5+). Human override to High available.
- `$evolve` — review High confidence instincts and promote to formal skills. PROMOTE/DEFER/RETIRE per instinct. Never auto-promotes. Shows Medium instincts approaching High.
- `~/.codex/forge/instincts/registry.md` — instinct counter and index with confidence scores
- `~/.codex/forge/instincts/_template.md` — instinct file template
- `~/.codex/forge/SOUL.md` — agent-facing identity document (core principles, behavioural rules, what the agent is not)

### Changed
- `$debrief` — instinct prompt added at session end: "Did anything this session produce a pattern worth capturing?"
- `$handoff` — instinct prompt added at handoff

### Inspired by
ECC (github.com/affaan-m/ECC) continuous-learning-v2 pattern: instinct-based learning with confidence scoring and cluster promotion.

---

## v2.4.0 — 2026-05-22

**Knowledge base health checking and research promotion.**

### Added
- `$knowledge-health` — read-only diagnostic across all knowledge layers. Coverage scorecard with change tracking. P1 structural health (stale files, missing fields, unresolved ambiguities, undocumented systems, undefined terms). P2 cross-reference findings (Do Not Attempt conflicts with active PRDs, cross-system risk patterns). P3 interesting connections (promotion candidates, new article suggestions, knowledge gaps). Saves to `~/.codex/forge/knowledge/health-report.md`. Suggested at sprint-start if last check > 30 days ago.
- `preferences.md` — `knowledge-health-last-run` field added

### Changed
- `$research` — knowledge base promotion step added at session end: asks whether findings should be promoted to system knowledge, company terms, or company context
- `$commands` — `$knowledge-health` added to Knowledge Base section

### Inspired by
LLM knowledge base pattern: raw data → compiled wiki → health checks → connections surfaced. Applied to Forge's knowledge layer: research files → knowledge base → `$knowledge-health` → promotion via `$research`.

---

## v2.3.7 — 2026-05-21

**New skill: $add-term**

### Added
- `$add-term` — lightweight company-level glossary maintenance. Acronyms → `acronyms.md`, domain concepts → `context.md`. Minimum definition captured immediately, marked `_Needs enrichment_` for later. Conflict detection against existing entries. Optional inline argument. Offers to also add to project `docs/CONTEXT.md` after writing.
- `~/.codex/forge/knowledge/company/context.md` — new company-level domain concept file (companion to `acronyms.md`)

---

## v2.3.6 — 2026-05-21

**Documentation cleanup and design principles.**

### Added
- `~/.codex/forge/PRINCIPLES.md` — 8 Forge design principles: AI executes/human decides, negative space programming, HITL/AFK explicit, smart zone thinking, structure as default, reference don't duplicate, estimates as signals, every decision recorded. Referenced in `$write-a-skill` checklist.

### Changed
- `$commands` — `push-standards` description updated to reference `CODING-STANDARDS.md`
- `push-standards` command file — updated to reference `CODING-STANDARDS.md`
- `$handoff` — description clarified: use for passing work to another agent/person vs `$debrief` for thorough session close
- `$debrief` — description and intro updated with `$handoff` vs `$debrief` distinction
- `$write-a-skill` — checklist now requires reading `PRINCIPLES.md` before finalising
- `README.md` — skill count updated to 50, command count to 51; `PRINCIPLES.md` added to global structure; skill/command counts in global structure updated
- Attribution standardised across handoff skill, grill-with-docs skill, and Confluence page: "Matt Pocock (AIHero.dev / github.com/mattpocock/skills)"
- Confluence page — attribution and Further Reading updated

---

## v2.3.5 — 2026-05-21

**New skill: $handoff**

### Added
- `$handoff` — compact the current session into a structured handoff for the next agent or human. References Forge artifacts by path rather than reproducing content. Suggests which skills the next session should use based on pipeline position. Optional argument: next session focus. Optional `--archive` flag saves a timestamped copy to `docs/handoffs/`. Adapted from AIHero.dev / Matt Pocock's handoff skill.

---

## v2.3.4 — 2026-05-21

**Project-level known issues tracking.**

### Added
- `docs/known-issues.md` — project template file for tracking Active, Deferred, and Resolved issues, plus Known Limitations. Entries use `KI-NNN` sequential IDs.
- `KI-NNN` counter added to `docs/tests/registry.md`

### Changed
- `$qa-plan` — reads `docs/known-issues.md` before generating checklist; "Known Issues to Verify" section added to QA plan output with KI-NNN references
- `$standup` — surfaces active known issues count in daily brief
- `$go-nogo` — reads `docs/known-issues.md` for each project; Active issues included in brief; Critical active issues can block Go/No Go
- `/sprint-start` — surfaces High/Critical active known issues and asks whether any should be scheduled as sprint tickets
- `AGENTS.md` — `docs/known-issues.md` added to key files table
- `INSTALL.md` — `docs/known-issues.md` listed in project scaffold

---

## v2.3.3 — 2026-05-21

**Post-split cleanup and documentation.**

### Changed
- `$push-standards` — now appends to `CODING-STANDARDS.md` "Project-Specific Patterns" section instead of a separate `STANDARDS.md`. Forge defaults never modified. Single file, two sources.
- `CODING-STANDARDS.md` — "Project-Specific Patterns" placeholder section added at bottom
- `AGENTS.md` — on-demand table note added: "agent loads these automatically — no manual action needed"
- `TESTING.md` — "Diagnose Before Fixing" section removed (duplicate of AGENTS.md — single source of truth)
- `README.md` — global file structure updated with `tokens/ledger.md` and `registry.md`; key concepts table updated with correct buffer window, ID types, and `$lookup`
- `registry-README.md` — new file explaining the ID registry, how IDs work, lookup usage, conflict resolution
- Reference files — Forge version comment added to top of each (CODING-STANDARDS, ERROR-HANDLING, SECURITY, TESTING)

---

## v2.3.2 — 2026-05-21

**AGENTS.md split — 427 lines → 186 lines.**

### Added
- `.codex/forge/CODING-STANDARDS.md` — pre-change protocol, layer tags, rollback policy, dependency awareness, versioning rules, advisory discipline, what good looks like
- `.codex/forge/ERROR-HANDLING.md` — error infrastructure, display rules, iOS Safari notes, silent failure discipline, logging standards, common bug patterns
- `.codex/forge/SECURITY.md` — security checkpoints, PII awareness, credential rules
- `.codex/forge/TESTING.md` — test scenarios, platform/compatibility checklist, TDD discipline, test coverage rules, diagnose rule

### Changed
- `AGENTS.md` — rewritten to ~186 lines (session instructions only). On-demand reference table added pointing to 4 extracted files. All extracted content removed from main file.
- `INSTALL.md` — reference files listed in project scaffold; `docs/tests/registry.md` added to docs listing

---

## v2.3.1 — 2026-05-21

**ID system fixes.**

### Changed
- `~/.codex/forge/registry.md` — conflict resolution rule added (never reuse, skip on conflict)
- `$lookup` — ID assignment conflict rule added; stale path recovery: searches for moved files, offers registry update
- `docs/tests/registry.md` — TC status lifecycle documented (Defined → Implemented → Passing | Failing | Waived | Skipped)
- `$qa-plan` — TC-NNN IDs carried from testplan into QA checklist and results table; status values aligned with TC registry
- `AGENTS.md` project template — `← set automatically by $create-project or $onboard` comments added to ID fields

---

## v2.3.0 — 2026-05-21

**Unique entity IDs across ideas, projects, and test cases.**

### Added
- `~/.codex/forge/registry.md` — global ID registry for IDEA-NNN and PROJ-NNN counters, cross-reference links
- `docs/tests/registry.md` — per-project TC-NNN counter and test case index (project template)
- `$lookup` skill — find any entity by ID (IDEA-NNN, PROJ-NNN, TC-NNN), returns summary + file path

### Changed
- `$idea` — assigns IDEA-NNN at pitch time, adds to `idea.md` header and global registry
- `$create-project` — assigns PROJ-NNN, adds to `AGENTS.md`, updates cross-references in `idea.md` and registry
- `$onboard` — assigns PROJ-NNN for existing projects, adds to `AGENTS.md` and registry
- `$testplan` — assigns TC-NNN per test case when testplan is confirmed, updates `docs/tests/registry.md`; testplan format updated with TC column and range in header
- `idea.md` template — `**ID:** IDEA-NNN` and `**Project:** PROJ-NNN` fields added
- `AGENTS.md` project template — `**Project ID:** PROJ-NNN` and `**Origin:** IDEA-NNN` fields added

### ID conventions
- `IDEA-NNN` — assigned at `$idea` start, global counter
- `PROJ-NNN` — assigned at `$create-project` or `$onboard`, global counter
- `TC-NNN` — assigned when testplan is confirmed, project-wide counter
- Bidirectional cross-references: idea.md ↔ AGENTS.md ↔ registry.md

---

## v2.2.3 — 2026-05-21

**Documentation cleanup.**

### Changed
- `README.md` — removed `$update-readme` duplicate from QA category; version history updated through v2.2.2; token tracking category corrected
- `INSTALL.md` — hardcoded skill/command counts replaced with "see manifest.json" reference
- `forge-sequence.mmd` — token recording note added at bottom
- `~/.codex/forge/tokens/README.md` — new file explaining the global ledger, how to read it, reporting, data quality, and correction procedure

---

## v2.2.2 — 2026-05-21

**Token recording housekeeping and documentation.**

### Changed
- `docs/tokens/template.md` → renamed to `_template.md` (underscore prefix distinguishes template from data files)
- `INSTALL.md` — global install listing replaced with full directory tree including `~/.codex/forge/tokens/ledger.md`; `_template.md` referenced correctly
- `TOKEN-RECORDING.md` — feature name derivation convention added ("PRD filename without .md, lowercase, hyphens"); multi-PI feature handling documented; manual correction procedure documented
- `README.md` — skill count updated to 48; token tracking category added; planning category updated with `$grill-with-docs` first and `$estimate` included

---

## v2.2.1 — 2026-05-21

**Token recording completeness fixes.**

### Changed
- `$research`, `$prototype`, `$testplan`, `$estimate`, `$deploy` — token recording steps added (5 missing phases now complete — all 11 phases recorded)
- `INSTALL.md` — `docs/tokens/` folder listed with description
- `HANDOFF.md` template — "Current phase: [name] — Session N of this phase" field added; example comment updated
- `AGENTS.md` — session start now increments phase session counter in token record when same phase continues
- `$approve` — token rollup failure mode added (missing token file doesn't block approval); ledger summary recalculated from all entries (not just incremented) to prevent drift
- `$token-report` calibration report — in-progress features can be included with ⚠️ partial label

---

## v2.2.0 — 2026-05-21

**Token recording and program-level reporting.**

### Added
- `$token-report` — program-level token usage analysis by feature, sprint, PI, or calibration. Reads from per-project token files and global ledger.
- `~/.codex/forge/tokens/ledger.md` — global cross-project token ledger, updated at `$approve`
- `docs/tokens/template.md` — per-feature token record template (project template)
- `~/.agents/skills/token-report/TOKEN-RECORDING.md` — estimation guide and phase recording format reference

### Changed
- `$idea` — records token usage after decision gate
- `$grill-with-docs` — records token usage at session end
- `$write-prd` — records token usage after Phase 2
- `$build` — records token usage at completion with per-ticket breakdown
- `$qa-plan` — records token usage after QA phases complete
- `$approve` — rolls up feature token record to `~/.codex/forge/tokens/ledger.md` at feature close
- `$standup` — shows current feature token spend line
- `/sprint-end` — shows sprint token total line
- `/pi-end` — shows PI token total line, suggests `$token-report`

### Token recording approach
- AFK automatic at phase end — agent estimates, not exact counts
- Input tokens: based on files loaded, estimated by type and size
- Output tokens: based on content generated
- Both separately recorded, band derived from combined total
- Session count tracked per phase

---

## v2.1.3 — 2026-05-21

**Richer domain modelling in $grill-with-docs.**

### Added
- `grill-with-docs/ADR-FORMAT.md` — full guide: minimal ADR template, "when to create" rules, what qualifies, Forge-specific notes
- `grill-with-docs/CONTEXT-FORMAT.md` — full guide: Avoid aliases, example dialogue, flagged ambiguities, single vs multi-context repos, Forge-specific notes

### Changed
- `$grill-with-docs` SKILL.md (v2.0.0) — references new format files, adopts Avoid aliases in term updates, adds Flagged Ambiguities and Example Dialogue guidance, lighter ADR format (1-3 sentences), multi-context repo support, richer Shared Understanding Summary
- `docs/CONTEXT.md` project template — updated to richer format with Avoid aliases, Relationships, Example Dialogue, Flagged Ambiguities sections
- `docs/adr/README.md` project template — updated to lighter ADR format with correct template

---

## v2.1.2 — 2026-05-21

**Commands reference cleanup and convention clarifications.**

### Changed
- `$commands` — `$grill-with-docs` now listed first in Pipeline as planning phase entry point; `$grill-me` labelled "Ad-hoc stress-test only"
- `$grill-me` — description and intro updated to clarify ad-hoc use; directs project planning to `$grill-with-docs`
- `forge-sequence.mmd` — planning phase updated to `$grill-with-docs`; deploy day updated to Monday
- `QUICKSTART.md` — essential commands table annotated: `create-project` labelled "after idea accepted", `$grill-with-docs` vs `$grill-me` distinction added
- `README.md` — pipeline block updated to show `$grill-with-docs`
- `preferences.md` — buffer window clarified: Friday EOD is last working day for feature tickets
- `AGENTS.md` — buffer window clarified in core concepts
- `$build` — buffer window check updated to Friday–Sunday language with Friday EOD callout

---

## v2.1.1 — 2026-05-21

**Convention updates — deployment day and planning phase.**

### Changed
- Release day: Sunday → **Monday** (3rd Monday of each month)
- Sprint start day: Sunday → **Tuesday**
- Buffer window: Thursday → **Friday–Sunday** before release Monday
- Go/No Go cutoff: unchanged — Friday 5pm
- Planning phase pipeline: `$grill-me` → **`$grill-with-docs`** — uses domain model and codebase context
- Updated: `preferences.md`, `$piplan`, `$sprintplan`, `$go-nogo`, `AGENTS.md`, `INSTALL.md`, `QUICKSTART.md`, PI plan template

---

## v2.1.0 — 2026-05-21

**Token and complexity estimation across the full planning pipeline.**

### Added
- `$estimate` — on-demand token cost band (S/M/L/XL) and story point (1/2/3/5/8/13) estimation. Table-based, human confirms in aggregate. XL flags `$break-down` requirement.
- `$save-state` — emergency state save: HANDOFF.md → kanban.md → DEVLOG in priority order. Manual or auto-triggered on context exhaustion.
- `QUICKSTART.md` — 5-minute path from idea to first feature

### Changed
- `$idea` — feature-level estimate generated before decision gate, added to `idea.md`
- `$write-prd` — per-module estimates generated in Phase 2, added to PRD header and Implementation Decisions. PRD header now includes `Estimate (AI Token Cost)`, `Estimate (Story Points)`, `Estimate Status`, `Last estimated`
- `/sprint-start` — sprint capacity check against `preferences.md` limits (story points + token budget). XL tickets flagged. Warning not block.
- `$build` — actuals tracked per ticket. Estimated vs actual band recorded in `kanban-archive.md`. Over-band actuals flagged ⚠️
- `/scope-check` — stale estimate detection. Marks PRD estimate as Stale when scope changes, prompts `$estimate`
- `preferences.md` — `sprint-capacity-points` and `sprint-capacity-tokens` fields added
- `kanban.md` template — `S|M|L|XL | Npts` and `XL ⚠️` tags added
- `kanban-archive.md` template — `estimated: M | actual: L` actuals format added
- `AGENTS.md` — stale estimate detection instruction, context exhaustion protocol
- `CHANGELOG.md` — conventions section added with version bump guidance and diagram update trigger
- `README.md` — CHANGELOG and QUICKSTART referenced

---

## v2.0.0 — 2026-05-21

**Full lifecycle — idea to production.**

### Added
- `$build` — executes sprint AFK tickets in sequence with TDD, buffer window check, context checkpoints, lightweight PII scan
- `$deploy` — staged or direct deployment with Go/No Go gate, health check, rollback validation, deploy log
- `$deploy-pi` — full PI release in configured sequence, per-project status tracking, partial success handling
- `$rollback` — emergency project rollback with mandatory reason, diagnose handoff, deploy log entry
- `$rollback-pi` — full PI rollback in reverse deploy order, stops on failure, PI plan reflects exact state
- `$piplan` — PI creation with auto-derived release dates, Go/No Go gates, buffer windows
- `/pi-end` — formal PI closure with delivery summary, retrospective, stakeholder view
- `$go-nogo` — release gate with AI-prepared brief, GO/NO-GO human decision, NO-GO next step suggestions
- `$standalone-release` — urgent deploy outside monthly cycle, deploy log integration
- `/sprint-replan` — mid-sprint injection with absorb/swap options
- `/pi-replan` — mid-PI scope change with Fixed Deadline risk check and two-gate confirmation
- `/pii-check` — AFK codebase scan + HITL review, Necessary vs Incidental classification, living report
- `$tdd` — red-green-refactor with deep-modules, interface-design, mocking, refactoring reference files
- `$testplan` — testing strategy design before implementation
- `$idea` — structured idea capture with grill, diagrams, impact/effort, ACCEPT/DECLINE/HOLD
- `$create-project` — progress accepted idea to git repo with Forge scaffold
- `$onboard` — bootstrap Forge onto existing project
- `$backlog-list`, `$backlog-proj`, `/backlog-add` — backlog management with priority grouping
- `$critic` — honest prioritised critique across correctness, completeness, consistency, risk
- `$update-readme` — diff-style README proposal against PRD and DEVLOG
- `$write-adr` — explicit ADR creation skill
- `docs/HANDOFF.md` — always-overwritten session handoff, read at session start
- `.codex/forge/deploy.md` — per-project deployment config with build-check, environment variable section
- `docs/releases/deploy-log.md` — deployment audit log with archiving convention
- `~/.codex/forge/priorities.md` — cross-project feature priority list
- `~/.codex/forge/backlog.md` — framework-level backlog with priority grouping
- `~/.codex/forge/forge-sequence.mmd` — framework sequence diagram

### Changed
- `AGENTS.md` — session start now reads `HANDOFF.md` first, staleness warning for knowledge files, session end writes `HANDOFF.md`
- `$approve` — PII gate added, HANDOFF reset on feature close, README update suggestion, fixed step numbering
- `$write-prd` — two-phase AFK explore + HITL write, Sprint and PI fields in PRD template
- `/sprint-end` — kanban archiving to `kanban-archive.md`, HANDOFF update
- `$debrief` — HANDOFF update added as step 2
- `$standup` — reads priorities, flags deadline risk, Go/No Go proximity, auto scope-check for Fixed Deadline features
- `manifest.json` — `forge_version` field added

### Removed
- Nothing removed — all v1.0.0 skills retained

---

## v1.0.0 — 2026-05-20

**Initial release — planning pipeline and sprint management.**

### Skills
`$grill-me`, `$grill-with-docs`, `$research`, `$prototype`, `$write-prd`, `$diagnose`, `$approve`, `$standup`, `$debrief`, `/scope-check`, `$write-adr`, `$break-down`, `$qa-plan`, `/review`, `$push-standards`, `$add-system`, `$summarise-system`, `$update-context`, `/sprint-start`, `/sprint-end`, `$piplan`, `$sprintplan`, `$write-a-skill`, `$commands`
