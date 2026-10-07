# Requirements Language

> Governs the wording of requirements, acceptance criteria, and commitments in generated
> documents. Read the scope boundary in [README.md](README.md) first — these rules do **not**
> apply to skill instruction prose.

## The Principle

**Describe the delivered world as a fact, not the project's intentions about it.**

A requirement states how things *are* once the solution is in place. Written that way it is
either true or false at verification time, and there is no hedge to argue about.

| Instead of | Write |
|---|---|
| The system should respond within 3 seconds | Search results are returned within 3 seconds |
| We will encrypt data in transit | Data in transit is encrypted using TLS 1.3 |
| Users may be notified of despatch | Customer despatch notification is issued within 5 minutes |
| The service shall be available 99.9% of the time | Service availability is 99.9% per calendar month |

## Voice and Tone

Adopted from the Australian Government Style Manual, *Voice and tone*
(stylemanual.gov.au, page updated 21 October 2025). Here, **voice** means who the document speaks
as. That is a different thing from the grammatical active or passive voice covered in
§ *Voice by Altitude* below.

**Voice: the definitive source.** A requirements document uses the Style Manual's basic government
voice. It is respectful, clear and direct, and objective and impartial. A company style guide may
set a house voice on top of this (see [README.md](README.md) § *Enforcement*), but it never
replaces it.

**Tone: formal.** The Style Manual puts policies, reports and legal writing in formal tone, and a
document that carries commitments belongs in that group. Formal tone does not excuse unclear
writing: plain language applies at every level of formality.

| Element of tone | In a generated requirements document |
|---|---|
| Word choice | Everyday words. No contractions, metaphor, idiom or slang, and words keep their dictionary meaning. Every acronym and piece of internal shorthand is defined on first use and in the Glossary |
| Viewpoint | Third person and impersonal. No `I`, `we`, `our` or `you`, because a requirements document has many readers and `you` names none of them. Name the party instead, as the "the system" ban already requires for components |
| Grammar | Short sentences, one idea each. § *Voice by Altitude* sets the form for each element |
| Formality | Formal throughout, executive summary included |

**Clear and direct.** Narrative prose uses the active voice with a named actor. An unfavourable
position is stated plainly: an exclusion, a `Won't`, an Adverse outcome or a refused request leads
with the answer, not with the process that produced it.

| Instead of | Write |
|---|---|
| Items not meeting first-round criteria are deemed unsuccessful subject to FMC review | Bulk reassignment is out of scope for this release |
| Unfortunately the legacy platform is a mess and constantly falls over | The current dispatch service had 14 unplanned outages in the 12 months to June 2026 |

**Objective and impartial.** State facts with a benchmark, not opinion. An evaluative adjective or
adverb (`just`, `significantly`, `dramatically`, `unfortunately`, `obviously`, `simply`,
`seamless`, `world-class`) carries a judgement the source did not make. `only` is evaluative when
it judges an amount (`only 15 outages`). It is not evaluative when it limits a scope (`visible only
to the submitting party`), which is a precise restriction and stays. Replace it with the
baseline, the comparison or the source that supports it. A problem statement presents the
evidence and does not assign blame to a team, a vendor or an earlier decision.

**Respectful.** Inclusive language. The document neither talks down to its reader nor addresses
them familiarly.

**Exempt from this section:** verbatim source quotations, such as the text inside
`[TBD — source: "…"]` or a quoted stakeholder statement, which keep the speaker's own words, and
controlled vocabulary such as the MoSCoW value `Won't`.

## Voice by Altitude

Two registers. Applying the wrong one at the wrong level is the most common error.

| Element | Form | Example |
|---|---|---|
| Capability / feature name | **Noun phrase** | `Customer despatch notification` |
| Requirement or story title | **Active, verb-first** | `Notify customer of despatch` |
| "I want" clause | **Active, verb-first**, solution-agnostic | `Notify the customer when despatch occurs` |
| Acceptance criterion | **Noun-first, passive, declarative** | `Despatch notification is issued within 5 minutes of consignment scan` |
| ORD register row | **Active, verb-first** `Requirement Title`; **noun-first, passive** `Business Tolerance` carrying its own value | `Notify customer of despatch` / `Despatch notification is issued within 1 business hour of consignment scan, beyond which the delivery promise is breached` |

Titles command. Criteria state. The criterion form is deliberate: leading with the noun and
using the passive leaves **no grammatical slot for a modal verb**, so the failure this ruleset
exists to prevent becomes hard to write rather than merely discouraged.

## Banned in Generated Requirements

**Modals — never appear in a requirement, criterion, or commitment:**
`could` · `should` · `would` · `may` · `might`

They make the statement unfalsifiable: a criterion that *may* be met cannot fail a test.

**`shall` — permitted but avoided.** It is not ambiguous, but the declarative present is
shorter and reads as a fact rather than an obligation. Prefer the rewrite; do not treat an
existing correct `shall` as a defect.

**Constructions — never:**
`allow me to` · `allows the user to` · `enables` · `is able to` · `can [verb]`

These describe a capability the solution grants rather than an outcome that is true. `can` is
the most common offender and the easiest to miss:

> ✗ `Then they can complete the purchase without re-entering card details`
> ✓ `Purchase completion is available to a returning customer without card re-entry`

**Never write "the system"** — or "the platform", "the application", "the solution". Name the
product, service, or component. Where no name exists yet, use the `[SYSTEM-NAME-TBD]`
placeholder the skill already defines, and resolve it before the document is approved.

## Demand, not design

**Quantify the business tolerance, not the engineering figure that satisfies it.**

A requirement can be fully quantified and testable — as ISO/IEC/IEEE 29148:2018 requires — without
presupposing a design. The discipline is one level down from the rule that a BRD never names a
solution.

| Business demand (belongs in the requirement) | Technical target (the design response, downstream) |
|---|---|
| An agent retrieves a customer's account without the customer noticing a wait | Sub-200ms API response at the 99th percentile |
| Service is restorable within 1 business day; beyond that, obligation X is breached at cost Y | RTO 4h, active-active across two zones |
| No more than 1 working day of transactions is lost in any failure | RPO 1h |
| A field technician completes a job through a 30-minute connectivity gap | Offline cache with conflict resolution on reconnect |

Every left-hand statement is quantified, testable and traceable to a business source — a contract, a
regulatory obligation, an incident cost, a named stakeholder. **None requires an architect to
write.** That is what makes a requirements document producible by a business-side role.

**Where a document states a technical target, it pre-empts the review it exists to inform.** The
figure is asserted rather than derived, and the design review becomes ratification of a number an
analyst chose. Supply the demand; let the design response supply the target.

**This is not a ban on numbers.** A tolerance without a number is a vagueness defect under the next
section. The test is not *is there a figure* but *whose figure is it* — the business's tolerance, or
the engineer's answer to it.

## Vagueness

Unquantified adjectives are not requirements: `fast`, `reliable`, `intuitive`, `robust`,
`scalable`, `secure`, `user-friendly`. Either give a threshold and a measurement method, or
write `[TBD — source: "quoted vague statement"]` and leave the gap visible. Never quantify by
invention.

Quantification alone is **not** sufficient — "The system should respond within 3 seconds" is
quantified and still fails this ruleset. Both the number and the form are required.

## Sentences and Word Choice

Adopted from the Australian Government Style Manual: *Sentences*, *Plain language and word
choice* and *Clear language and writing style*.

**Length.** Sentences average 15 words, and none is longer than 25. This applies to narrative
prose and to every register cell. A longer statement is split into separate sentences or a list,
and a tolerance that needs more is carrying mechanism, which belongs in a cited `BRL-NNN`. An ID
or a cited reference counts as one word.

**Structure.**
- Subject, verb, object, in that order. A modifier goes after the main clause, never inside it.
  Write `Notification is issued within 1 hour of scan`, not `Notification is, within 1 hour of
  scan, issued`.
- Positive statements. State what is true, not what is not, and never use a double negative
  (`not unacceptable`). A prohibition is written as one, plainly.
- Never use `if` and `unless` in the same sentence. Split the conditions, or put them in a
  business rule.
- `other than` goes directly after the term it qualifies, so the exception is unambiguous.
- No `such … as` (`such steps as are appropriate`) and no `being` as a joining word. Use `and`.
- No `there is` or `there are` when they add words but no meaning.
- No more than 3 nouns or adjectives in a row. `Customer despatch notification` is the limit.
  `Customer despatch notification exception reporting` is a noun train, so rewrite it as a clause.

**Verbs over hidden verbs.** Write `decide`, not `make a decision`, and `consider`, not `give
consideration to`. This does not conflict with § *Voice by Altitude*: a criterion starts with a
noun *subject*. What this rule bans is a verb turned into a noun inside the sentence.

**Cut unnecessary words.** Each word has a job. Adverbs and adjectives go first. Then check that
the sentence still means the same and is still grammatical.

**Everyday words.** Use the plain alternative unless a term is defined in the Glossary or taken
from a standard this ruleset cites (ISO/IEC/IEEE 24765, ISO/IEC 25010). A defined term keeps its
defined form: `impact` names an `IMP-NNN` row and stays.

| Instead of | Write |
|---|---|
| in order to | to |
| prior to / subsequent to | before / after |
| commence / cease | start / stop |
| utilise | use |
| in the event that | if |
| due to the fact that / as a consequence of | because |
| in relation to / with regard to / in respect of | about |
| pursuant to | under |
| until such time as | until |
| ascertain | find out |
| approximately | about |
| a number of | the number itself, or `some` |
| at a later date | the date, or the timeframe |
| leverage | use, build on |
| deliver / drive (an outcome) | the actual verb: `reduce`, `increase`, `replace` |
| impact (verb) | affect |
| require (verb) | state the end state that is needed |

**Shortened forms.**
- Write the full term first, with the acronym in brackets after it: `Network Operations Centre
  (NOC)`. A shortened form that is better known than its full form goes first, with the expansion
  after it.
- Every acronym goes in the Glossary. A register row is read on its own, so an acronym in a row
  is also defined in the Glossary, not only in an earlier paragraph.
- A term used only once or twice is written in full and not shortened.
- No plural or possessive form at the point of definition, and no full stops inside or after an
  acronym.

**Reading level.** The executive summary and the narrative sections aim for a lower-secondary
reading level (WCAG 2.2 success criterion 3.1.5). Specialist content is supported with the
Glossary and a short summary in plain terms. It is never written down to.

## Numbers, Dates and Units

Adopted from the Style Manual, *Grammar, punctuation and conventions* § *Numbers and
measurements*.

**Numerals.**
- In prose, numbers from 2 up are numerals, and `zero` and `one` are words.
- **Every number in a register cell is a numeral**, `0` and `1` included. So is every number with
  a unit, every comparison, decimal, percentage, date, time and series. A tolerance is a
  measurement, so `1 business hour` and `4 business days` are correct.
- Never start a sentence with a numeral. Reword it: `Rates made up 55% of revenue`, not `55% of
  revenue came from rates`.
- Numbers of 4 or more digits use commas, never spaces: `2,500`. Large rounded numbers use a
  numeral and a word: `2.5 million`, `$50 million`.

**Percentages.** A numeral with no space before `%`: `99.5%`. Use decimals, not fractions. Write
the noun as `percentage`, and `per cent` as 2 words. **Never describe a change as a percentage
alone.** State the baseline and the new value, as the BRD objective schema already requires. A
percentage can sit next to them but never replaces them.

**Dates and times in prose** (locale default, see § *Locale Conventions*).
- Day, month, year, with no comma or ordinal: `15 October 2026`, `Thursday 15 October 2026`.
- Spans: `from 3 to 21 December`. Financial years use an en dash: `the 2026–27 financial year`.
- Times use a colon and a lower-case `am`/`pm`: `9:30 am`, `2 pm`. Use `noon` and `midnight`,
  never `12 am` or `12 pm`. The 24-hour clock is used where the operation already runs on it.
- A tolerance that depends on a time zone names it.

**Dates in register cells** use `yyyy-mm-dd` (see § *Recorded Deviations from the Australian
Government Style Manual*).

**Units.** Numerals with the SI symbol and a non-breaking space: `30 km`, `500 kg`. A symbol the
reader may not know is spelt out at first use, with the symbol in brackets after it. Symbols take
no full stop and no plural form.

## Punctuation, Capitalisation and Spelling

Adopted from the Style Manual, *Grammar, punctuation and conventions* § *Punctuation* and
§ *Spelling*.

**Minimal punctuation.**
- No full stop at the end of a heading, a caption or a list item that is not a full sentence.
- No semicolons at the end of list items.
- One space after a full stop, never two.
- A sentence that needs a lot of punctuation is too long. Split it.

**Capitals.** Sentence case in all free text. Capitals go on proper nouns only. A role or position
named in prose is lower case (`the regulatory reporting manager`) unless it is a title the
organisation sets in legislation or policy. Fixed labels keep their form (see deviations below).

**Spelling** (locale default, see § *Locale Conventions*). Australian English, from one Australian
dictionary used consistently: the Macquarie Dictionary, unless the company style guide names the
Australian Oxford. Where a word has more than one spelling, use the first one listed. `-ise`
endings, `per cent`, and `judgement` (but `judgment` in legal material).

## Locale Conventions

**The Australian locale is on by default.** The rules marked *locale default* above are the only
ones in this file that depend on where the document is written and read:

| Convention | Australian default |
|---|---|
| Spelling and dictionary | Australian English, Macquarie Dictionary, first listed spelling |
| Dates in prose | `15 October 2026`, with no comma or ordinal |
| Times | `9:30 am`, `2 pm`, `noon`, `midnight` |
| Financial year | `2026–27`, running 1 July to 30 June |
| Percentage in words | `per cent` |

**Before drafting, read `~/.claude/knowledge/company/style-guide.md`.** If the file is missing,
is a placeholder or has no `Locale` section, the Australian defaults apply and nothing is
reported.

**A company style guide can replace this whole table.** It does so with a `Locale` section that
states a value for every row, for example US English with Merriam-Webster and `October 15, 2026`.
A partial `Locale` section replaces nothing: the rows it leaves out would fall back to Australian
values and the document would mix 2 conventions. A partial section is reported as a finding and
the Australian defaults stay in force.

**Nothing else in this file is a locale rule.** Plain language, sentence length, numerals,
objective tone, acronym handling and every deviation apply whatever the locale. A `Locale`
section that tries to change them is a relaxation, and § *Enforcement* in [README.md](README.md)
refuses it.

Register cells date as `yyyy-mm-dd` in every locale.

## Citing Sources

Adopted from the Australian Government Style Manual, *Referencing and attribution*
(stylemanual.gov.au). Every source a document relies on is cited in a form a reader can find, and
every citation resolves to a row in the reference list ([tables.md](tables.md) § *Reference list*).

**The system is author–date.** The Style Manual prefers it to footnotes for accessibility, and it
survives the move into tables and the `.llm.md` companion. No footnotes or endnotes are used.

| Source | In text and in `Source` cells | Notes |
|---|---|---|
| Act of parliament | *Privacy Act 1988* (Cth) at first mention, then Privacy Act | Title case, with the year and the jurisdiction. Italic at first mention only |
| Pinpoint in an Act | Privacy Act s 6, subs 6(1), para 6(1)(a), Pt 3, Sch 1 | No full stops. In running prose, write `section 6` in full |
| Delegated legislation or a code | The same pattern as an Act | Use the authorised title from the jurisdiction's legislation register |
| Standard | ISO/IEC 25010:2023 | The designation and year. Cite the AS or AS/NZS adoption where one exists ([ai.md](ai.md) § *Standards of record*) |
| Contract or agreement | Retail service agreement cl 14 | `cl` for a clause and `Sch` for a schedule, from the contract's own numbering |
| Report, webpage or dataset | (Acme Communications 2026) | Author and year with no comma. `n.d.` with no date, and `et al.` for 3 or more authors |
| Internal record | Incident record INC-2291 | The record's own identifier, so the owning system can find it |

**First mention, then the short form.** An Act takes its full short title in italics at first
mention, and the short form after that. A shortened form that does more than drop the year goes
in brackets at first mention: *Work Health and Safety Act 2011* (Cth) (WHS Act). The `Cited as`
column of the reference list holds the short form.

**Shortened forms.** `s`, `ss`, `subs`, `para`, `cl`, `Pt`, `Div`, `Sch`, `p` and `pp` take no full
stop. `n.d.` and `et al.` keep theirs. Never use `ibid.`, `op. cit.`, `loc. cit.` or `id.`: repeat
the short form instead.

**Quote exactly.** A quoted source keeps its own words, spelling and acronyms. An unexplained
acronym in a quote gets its expansion in square brackets.

## Narrative Sections

Background, mission context, operational scenarios and day-in-the-life narratives are prose by
design and are exempt from the noun-first criterion form. They remain subject to the modal ban
and the "the system" ban, and they must never introduce a commitment that does not also appear
as a row (see [tables.md](tables.md)).

## Recorded Deviations from ISO/IEC/IEEE 29148:2018

`/write-prd` cites 29148. This ruleset deviates from it twice, deliberately:

1. **Declarative present is preferred over `shall`.** 29148 makes `shall` the canonical binding
   verb. We prefer the end-state form because it is shorter and verifiable as a statement of
   fact. `shall` remains valid, so this is a preference, not a conflict.

   **The same deviation applies to the INCOSE *Guide to Writing Requirements*,** which is more
   prescriptive than the ISO text on this point and is the practitioner authority most likely to be
   cited against a document authored under these rules. Recording the deviation once, against both
   sources, is deliberate: a deviation noted against 29148 alone silently extends to INCOSE, which
   is how a documented choice becomes an apparent defect in review.
2. **Passive voice is mandated for acceptance criteria.** 29148 recommends active voice on the
   grounds that passive hides the actor. Accepted and mitigated: where the actor is
   load-bearing — authorisation, non-repudiation, audit, and anything in ORD §7.3 Security —
   name the actor explicitly and use the active voice. Elsewhere the passive is what makes
   noun-first possible once "the system" is banned.

Neither deviation is silent: any document claiming 29148 conformance cites this file.

## Recorded Deviations from the Australian Government Style Manual

The Style Manual is written for content that tells a reader what to do. A requirements document
states what is true once a change is delivered, and it is verified against that statement. Four
deviations follow from the difference. Each is deliberate:

1. **Passive voice in acceptance criteria and Business Tolerance cells.** The Style Manual's own
   counter-example, `Applications are assessed within 30 days`, is the exact form this ruleset
   requires of a criterion. It names no actor because the actor belongs to the design response,
   not the demand. The mitigation is the one in the 29148 deviation 2: where the actor is
   load-bearing, name it and use the active voice. Titles and narrative prose use the active voice,
   as the Style Manual says.
2. **No second person.** The Style Manual recommends `we` and `you` where they suit the voice and
   tone. Its tone guidance puts reports and policies in formal tone, which uses the third person,
   and a requirements document is one of those.
3. **Fixed labels keep title case.** Section headings, column names, controlled values (`Sunny
   Day`, `Must`, `Provisional`) and role names in `Owner` cells are labels that reviewers, other
   skills and tooling match on exactly. They keep the form their schema gives them. Sentence case
   applies to all other text.
4. **Register cells date as `yyyy-mm-dd`.** The Style Manual uses `15/10/2026` in tables. Register
   dates are sorted, compared and read outside Australia, and the Style Manual accepts
   international standards for data. Prose uses `15 October 2026`.

**Not aligned to ASD-STE100.** Simplified Technical English mandates active voice and the
imperative, and governs technical *documentation* (procedures, manuals), not requirements.
Downstream operational artefacts — runbooks, operator and field procedures — may adopt STE
independently; requirements documents do not.

## Never

- Never use `could`, `should`, `would`, `may`, or `might` in a requirement, criterion, or commitment.
- Never state a technical target where a business tolerance belongs — no RTO, RPO, latency figure,
  availability percentage, instance count or protocol choice in a demand-side requirement.
- Never coin a term where ISO/IEC/IEEE 24765 (systems and software vocabulary) or, for AI,
  ISO/IEC 22989:2022 supplies one. Record the adopted term via `/add-term`.
- Never write `enables`, `is able to`, `allows … to`, or `can [verb]` in a criterion.
- Never refer to "the system", "the platform", "the application", or "the solution".
- Never treat quantification as sufficient — a hedged number is still a hedge.
- Never invent a threshold to avoid writing `[TBD]`.
- Never use a contraction, metaphor, idiom or slang in a generated document, except as controlled
  vocabulary or inside a verbatim quotation.
- Never write in the first or second person (`I`, `we`, `our`, `you`) outside a verbatim quotation.
- Never use an evaluative adjective or adverb that has no benchmark, and never assign blame in a
  problem statement.
- Never use an acronym or internal shorthand that is not defined on first use.
- Never bury an unfavourable position under the process that produced it.
- Never write a sentence longer than 25 words, in prose or in a register cell.
- Never use a double negative, or `if` and `unless` in the same sentence.
- Never string more than 3 nouns or adjectives together.
- Never write a number in a register cell as a word, and never start a sentence with a numeral.
- Never describe a change as a percentage alone. State the baseline and the new value.
- Never mix spellings or date formats. Use the active locale, which is Australian unless a
  complete company `Locale` section replaces it.
- Never cite a source in a form the reference list does not hold, and never use a footnote.
- Never use `ibid.`, `op. cit.`, `loc. cit.` or `id.`.
- Never apply these rules to the skills' own instruction prose (see [README.md](README.md)).
