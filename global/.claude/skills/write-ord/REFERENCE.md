# write-ord Reference

ISO/IEC 25010:2023 taxonomy and ORD template used by SKILL.md.

---

## ISO/IEC 25010:2023 Quality Characteristics

Nine top-level characteristics. Map every non-functional requirement to one sub-characteristic before writing the ORD.

### 1. Functional Suitability
Does the system do the right things?
- **Functional Completeness** — all specified tasks covered
- **Functional Correctness** — accurate results with required precision
- **Functional Appropriateness** — functions align with user goals

*ORD relevance:* operational scope, what the system must do in production (not how it is built).

### 2. Performance Efficiency
Does the system perform its functions within required time, throughput, and resource constraints?
- **Time Behavior** — response and processing times, throughput rates *(highest ORD priority)*
- **Resource Utilization** — CPU, memory, storage, network, energy usage
- **Capacity** — maximum concurrent users, peak transaction volumes, data volume limits

*ORD relevance:* quantified thresholds required. "Fast" is not a requirement.

### 3. Compatibility
Can the system exchange information and coexist with other systems?
- **Coexistence** — operates without harming other systems sharing the environment
- **Interoperability** — exchanges information with specified external systems per defined protocols

*ORD relevance:* interface table, protocol standards, failure behavior on integration errors.

### 4. Interaction Capability *(formerly Usability — 2011)*
Can specified users operate the system to achieve their goals?
- **Appropriateness Recognizability** — users can identify if the system fits their needs
- **Learnability** — users can learn to operate it within a specified timeframe
- **Operability** — easy to operate and control
- **User Engagement** — features encourage continued use *(replaced UI Aesthetics)*
- **Accessibility** — usable by people with the widest range of characteristics
- **Inclusivity** — designed for diverse abilities and backgrounds *(NEW in 2023)*
- **Self-Descriptiveness** — system communicates how to use it correctly *(NEW in 2023)*

*ORD relevance:* operator training requirements, accessibility compliance (WCAG 2.1 AA), self-service capability.

### 5. Reliability
Does the system perform its functions without failure over a specified period under specified conditions?
- **Faultlessness** — degree to which the system is free from faults *(replaced Maturity — 2023)*
- **Availability** — system is operational and accessible when required
- **Fault Tolerance** — maintains operation despite hardware or software faults
- **Recoverability** — restores data and operations following interruption or failure

*ORD relevance:* uptime targets, MTBF, MTTR, RTO, RPO, degraded-mode requirements. KPP candidates live here.

### 6. Security
Does the system protect information and data with appropriate access controls?
- **Confidentiality** — data accessible only to authorized parties
- **Integrity** — state and data protected from unauthorized modification or deletion
- **Non-repudiation** — actions can be proven to have taken place
- **Accountability** — actions traceable to the entity that performed them
- **Authenticity** — identity of subjects and resources can be verified
- **Resistance** — system sustains operations under attack *(NEW in 2023)*

*ORD relevance:* compliance frameworks (FedRAMP, HIPAA, ISO 27001, PCI-DSS), encryption standards, penetration test thresholds, access control model.

### 7. Maintainability
Can the system be effectively and efficiently modified without degrading quality?
- **Modularity** — change to one component has minimal impact on others
- **Reusability** — components can be used across products or contexts
- **Analyzability** — impact of intended changes can be assessed
- **Modifiability** — changes can be made without introducing defects

*ORD relevance:* patch management cadence, configuration management, change window requirements, version control obligations.

### 8. Flexibility *(formerly Portability — 2011)*
Can the system operate effectively in contexts not originally specified?
- **Adaptability** — adapts to different or evolving hardware, software, and usage environments
- **Installability** — can be successfully installed/uninstalled in specified environments
- **Replaceability** — can replace another specified product for the same purpose
- **Scalability** — handles growing or shrinking workloads; elastic capacity *(NEW in 2023)*

*ORD relevance:* cloud hosting model, elasticity requirements, multi-region or multi-tenancy, upgrade and rollback procedures.

### 9. Safety *(NEW top-level characteristic — 2023)*
Does the system protect against risk of injury or harm to people, property, or the environment?
- **Operational Constraint** — operational constraints prevent hazardous situations
- **Risk Identification** — hazardous situations and conditions are identified
- **Fail Safe** — system reaches a safe state on failure
- **Hazard Warning** — timely, effective warnings about hazards are provided
- **Safe Integration** — safe integration with other systems

*ORD relevance:* applicable to safety-critical systems (healthcare, infrastructure, industrial control). If not applicable, note explicitly.

---

## 2011 vs 2023 Quick Reference

| Changed | 2011 | 2023 |
|---|---|---|
| Top-level count | 8 | 9 |
| New characteristic | — | Safety |
| Renamed | Usability | Interaction Capability |
| Renamed | Portability | Flexibility |
| New sub-characteristics | — | Inclusivity, Self-Descriptiveness, Resistance, Scalability |
| Replaced sub-characteristic | Maturity | Faultlessness |
| Replaced sub-characteristic | UI Aesthetics | User Engagement |

---

## ORD Template

Save output to `docs/ord/[system-name]-ORD.md`.

```markdown
# Operational Requirements Document
## [System / Service Name]

**Version:** 1.0  
**Date:** YYYY-MM-DD  
**Status:** Draft | Under Review | Approved  
**Owner:** [Role / Name]  
**Classification:** [Internal / Confidential / Restricted]  
**ISO/IEC Standard:** 25010:2023  

---

### Document Control

| Version | Date | Author | Changes |
|---|---|---|---|
| 1.0 | YYYY-MM-DD | [Name] | Initial draft |

**Approvers:**  
**Distribution:**  

---

## 1. Introduction

### 1.1 Purpose
[What this document defines and for whom.]

### 1.2 Scope
[What system or service this covers; what is excluded.]

### 1.3 Background and Capability Gap
[Current state and what operational gap this system addresses.]

### 1.4 Related Documents
[CONOPS, BRD, PRD, Architecture Doc, SLAs]

### 1.5 Definitions and Acronyms
[Terms used in this document.]

---

## 2. Operational Concept

### 2.1 Mission / Business Context
[The operational mission this system supports.]

### 2.2 System Overview
[Description of the system and how it operates in production.]

### 2.3 User Community and Operator Profiles
[Who operates and uses the system day-to-day.]

### 2.4 Operational Scenarios
[Day-in-the-life narratives: normal operation, peak load, failure, recovery.]

### 2.5 Operating Timeframes
[Business hours, 24/7, seasonal peaks, maintenance windows.]

---

## 3. Operational Performance Parameters

> Requirements in this section are organized by ISO/IEC 25010:2023 characteristics.  
> **[KPP]** = Key Performance Parameter — failure constitutes program/system failure.  
> Wording follows `rules/requirements/language.md`; presentation, schemas and IDs follow
> `rules/requirements/tables.md`. Both are authoritative — the tables below show the shape only.

Every requirement is one row in the register schema below. The subsection heading supplies the
25010 characteristic, so no characteristic column is needed.

**Worked example** — the threshold lives *inside* the Requirement Description as a declarative
end state, never in a separate column:

| BRD# | ORD# | Requirement Description | MoSCoW | Timing | Source | Delivery Agent | Verification | Capability | Epic | Comments |
|---|---|---|---|---|---|---|---|---|---|---|
| BRD-04 | ORD-001 | Search results are returned within 3 seconds at P95 under normal load | Must | Q3 FY26 | Digital, Service Ops, A. Patel | Platform Engineering | APM tool, monthly report | CAP-12 | EPIC-31 | Threshold agreed at 12 Jun workshop |

| Column | Holds |
|---|---|
| `BRD#` | Originating BRD item — `BO-N` for an objective, `BR-N` for a business requirement, which are the IDs `/write-brd` emits. Never `BRD-NN`; nothing produces that form. `—` where no BRD exists — then `Source` carries provenance alone. |
| `ORD#` | `ORD-NNN`, flat and sequential, never reused. |
| `Requirement Description` | The declarative end state, carrying its own quantified value. Prefix **[KPP]** where failure constitutes program failure. |
| `MoSCoW` | `Must` / `Should` / `Could` / `Won't`. |
| `Timing` | When the requirement needs to be live — release, quarter, or date. |
| `Source` | Business Unit, Function, Name. |
| `Delivery Agent` | The department accountable for delivering it. |
| `Verification` | How it is proven — load test, monitoring tool, audit, DR drill. Required; `/write-ac` rejects an operational criterion without one. |
| `Capability` | The Jira Capability whose AC covers it. Written back by `/write-ac`. |
| `Epic` | The Epic under that Capability delivering it. Written back by `/write-ac`. |
| `Comments` | Free text during refinement. Never the home of a commitment — if it binds, it belongs in the Description. |

**MoSCoW and [KPP] are orthogonal and both are kept.** A KPP is a program-failure threshold; a
Must is required for this release. Most KPPs are Musts; most Musts are not KPPs.

**`Should` and `Could` as MoSCoW values do not violate `language.md`.** That rule bans hedging
verbs inside requirement *text*. A controlled enum in a priority column is unambiguous.

Where source material gives no value, write the Description as `[TBD — source: "quoted vague
statement"]` — never drop to prose, and never invent a value.

**Subsections with no requirement are omitted from the body** and listed once in the Coverage
Gaps table at the end of this section. Check against the full sub-characteristic set in the
taxonomy above — all nine characteristics and every sub-characteristic — not only the
subsections pre-scaffolded below.

### 3.1 Performance Efficiency

**3.1.1 Time Behavior** — response and processing times, throughput rates.

| BRD# | ORD# | Requirement Description | MoSCoW | Timing | Source | Delivery Agent | Verification | Capability | Epic | Comments |
|---|---|---|---|---|---|---|---|---|---|---|
| [BO-N / BR-N or —] | ORD-NNN | [declarative statement carrying the value] | Must | [when live] | [BU, Function, Name] | [Department] | [how proven] | [CAP-NN or —] | [EPIC-NN or —] | |

**3.1.2 Resource Utilization** — CPU, memory, storage, network constraints under defined load.

| BRD# | ORD# | Requirement Description | MoSCoW | Timing | Source | Delivery Agent | Verification | Capability | Epic | Comments |
|---|---|---|---|---|---|---|---|---|---|---|
| [BO-N / BR-N or —] | ORD-NNN | [declarative statement carrying the value] | Must | [when live] | [BU, Function, Name] | [Department] | [how proven] | [CAP-NN or —] | [EPIC-NN or —] | |

**3.1.3 Capacity** — peak concurrent users, transaction throughput, data volume, growth.

| BRD# | ORD# | Requirement Description | MoSCoW | Timing | Source | Delivery Agent | Verification | Capability | Epic | Comments |
|---|---|---|---|---|---|---|---|---|---|---|
| [BO-N / BR-N or —] | ORD-NNN | [declarative statement carrying the value] | Must | [when live] | [BU, Function, Name] | [Department] | [how proven] | [CAP-NN or —] | [EPIC-NN or —] | |

---

### 3.2 Reliability

**3.2.1 Availability** — uptime, measurement window, permitted maintenance.

| BRD# | ORD# | Requirement Description | MoSCoW | Timing | Source | Delivery Agent | Verification | Capability | Epic | Comments |
|---|---|---|---|---|---|---|---|---|---|---|
| [BO-N / BR-N or —] | ORD-NNN | [declarative statement carrying the value] | Must | [when live] | [BU, Function, Name] | [Department] | [how proven] | [CAP-NN or —] | [EPIC-NN or —] | |

**3.2.2 Fault Tolerance** — behaviour under partial failure; what must keep running.

| BRD# | ORD# | Requirement Description | MoSCoW | Timing | Source | Delivery Agent | Verification | Capability | Epic | Comments |
|---|---|---|---|---|---|---|---|---|---|---|
| [BO-N / BR-N or —] | ORD-NNN | [declarative statement carrying the value] | Must | [when live] | [BU, Function, Name] | [Department] | [how proven] | [CAP-NN or —] | [EPIC-NN or —] | |

**3.2.3 Recoverability** — recovery targets after interruption or failure.

| BRD# | ORD# | Requirement Description | MoSCoW | Timing | Source | Delivery Agent | Verification | Capability | Epic | Comments |
|---|---|---|---|---|---|---|---|---|---|---|
| [BO-N / BR-N or —] | ORD-NNN | [declarative statement carrying the value] | Must | [when live] | [BU, Function, Name] | [Department] | [how proven] | [CAP-NN or —] | [EPIC-NN or —] | |

**3.2.4 Faultlessness** — production defect rate, MTBF, MTTR.

| BRD# | ORD# | Requirement Description | MoSCoW | Timing | Source | Delivery Agent | Verification | Capability | Epic | Comments |
|---|---|---|---|---|---|---|---|---|---|---|
| [BO-N / BR-N or —] | ORD-NNN | [declarative statement carrying the value] | Must | [when live] | [BU, Function, Name] | [Department] | [how proven] | [CAP-NN or —] | [EPIC-NN or —] | |

---

### 3.3 Security

**3.3.1 Confidentiality** — data classification, encryption at rest and in transit, access control model.

| BRD# | ORD# | Requirement Description | MoSCoW | Timing | Source | Delivery Agent | Verification | Capability | Epic | Comments |
|---|---|---|---|---|---|---|---|---|---|---|
| [BO-N / BR-N or —] | ORD-NNN | [declarative statement carrying the value] | Must | [when live] | [BU, Function, Name] | [Department] | [how proven] | [CAP-NN or —] | [EPIC-NN or —] | |

**3.3.2 Integrity** — integrity controls, audit logging.

| BRD# | ORD# | Requirement Description | MoSCoW | Timing | Source | Delivery Agent | Verification | Capability | Epic | Comments |
|---|---|---|---|---|---|---|---|---|---|---|
| [BO-N / BR-N or —] | ORD-NNN | [declarative statement carrying the value] | Must | [when live] | [BU, Function, Name] | [Department] | [how proven] | [CAP-NN or —] | [EPIC-NN or —] | |

**3.3.3 Non-repudiation and Accountability** — audit trail, log retention.

| BRD# | ORD# | Requirement Description | MoSCoW | Timing | Source | Delivery Agent | Verification | Capability | Epic | Comments |
|---|---|---|---|---|---|---|---|---|---|---|
| [BO-N / BR-N or —] | ORD-NNN | [declarative statement carrying the value] | Must | [when live] | [BU, Function, Name] | [Department] | [how proven] | [CAP-NN or —] | [EPIC-NN or —] | |

**3.3.4 Authenticity** — authentication standards (MFA, SSO, certificates).

| BRD# | ORD# | Requirement Description | MoSCoW | Timing | Source | Delivery Agent | Verification | Capability | Epic | Comments |
|---|---|---|---|---|---|---|---|---|---|---|
| [BO-N / BR-N or —] | ORD-NNN | [declarative statement carrying the value] | Must | [when live] | [BU, Function, Name] | [Department] | [how proven] | [CAP-NN or —] | [EPIC-NN or —] | |

**3.3.5 Resistance** — penetration test cadence, vulnerability remediation SLA.

| BRD# | ORD# | Requirement Description | MoSCoW | Timing | Source | Delivery Agent | Verification | Capability | Epic | Comments |
|---|---|---|---|---|---|---|---|---|---|---|
| [BO-N / BR-N or —] | ORD-NNN | [declarative statement carrying the value] | Must | [when live] | [BU, Function, Name] | [Department] | [how proven] | [CAP-NN or —] | [EPIC-NN or —] | |

**3.3.6 Compliance Frameworks** — applicable frameworks and the operational obligations they impose.

| BRD# | ORD# | Requirement Description | MoSCoW | Timing | Source | Delivery Agent | Verification | Capability | Epic | Comments |
|---|---|---|---|---|---|---|---|---|---|---|
| [BO-N / BR-N or —] | ORD-NNN | [declarative statement carrying the value] | Must | [when live] | [BU, Function, Name] | [Department] | [how proven] | [CAP-NN or —] | [EPIC-NN or —] | |

---

### 3.4 Compatibility

**3.4.1 Interoperability** — one register row per interface, as normal. Per-interface technical
detail lives in Appendix E, keyed by `ORD#`, so the register keeps one schema throughout.

| BRD# | ORD# | Requirement Description | MoSCoW | Timing | Source | Delivery Agent | Verification | Capability | Epic | Comments |
|---|---|---|---|---|---|---|---|---|---|---|
| [BO-N / BR-N or —] | ORD-NNN | [e.g. Consignment status is exchanged with [System] over HTTPS, queued on failure] | Must | [when live] | [BU, Function, Name] | [Department] | [e.g. integration test] | [CAP-NN or —] | [EPIC-NN or —] | see Appendix E |

**3.4.2 Coexistence** — shared-infrastructure constraints; no degradation of co-hosted systems.

| BRD# | ORD# | Requirement Description | MoSCoW | Timing | Source | Delivery Agent | Verification | Capability | Epic | Comments |
|---|---|---|---|---|---|---|---|---|---|---|
| [BO-N / BR-N or —] | ORD-NNN | [declarative statement carrying the value] | Must | [when live] | [BU, Function, Name] | [Department] | [how proven] | [CAP-NN or —] | [EPIC-NN or —] | |

---

### 3.5 Flexibility

**3.5.1 Scalability** — horizontal/vertical scaling, elasticity, growth projections.

| BRD# | ORD# | Requirement Description | MoSCoW | Timing | Source | Delivery Agent | Verification | Capability | Epic | Comments |
|---|---|---|---|---|---|---|---|---|---|---|
| [BO-N / BR-N or —] | ORD-NNN | [declarative statement carrying the value] | Must | [when live] | [BU, Function, Name] | [Department] | [how proven] | [CAP-NN or —] | [EPIC-NN or —] | |

**3.5.2 Adaptability** — multi-environment requirements (cloud regions, hosting models).

| BRD# | ORD# | Requirement Description | MoSCoW | Timing | Source | Delivery Agent | Verification | Capability | Epic | Comments |
|---|---|---|---|---|---|---|---|---|---|---|
| [BO-N / BR-N or —] | ORD-NNN | [declarative statement carrying the value] | Must | [when live] | [BU, Function, Name] | [Department] | [how proven] | [CAP-NN or —] | [EPIC-NN or —] | |

**3.5.3 Installability** — deployment, upgrade, rollback capability.

| BRD# | ORD# | Requirement Description | MoSCoW | Timing | Source | Delivery Agent | Verification | Capability | Epic | Comments |
|---|---|---|---|---|---|---|---|---|---|---|
| [BO-N / BR-N or —] | ORD-NNN | [declarative statement carrying the value] | Must | [when live] | [BU, Function, Name] | [Department] | [how proven] | [CAP-NN or —] | [EPIC-NN or —] | |

---

### 3.6 Maintainability

**3.6.1 Modifiability** — change window and change-management obligations.

| BRD# | ORD# | Requirement Description | MoSCoW | Timing | Source | Delivery Agent | Verification | Capability | Epic | Comments |
|---|---|---|---|---|---|---|---|---|---|---|
| [BO-N / BR-N or —] | ORD-NNN | [declarative statement carrying the value] | Must | [when live] | [BU, Function, Name] | [Department] | [how proven] | [CAP-NN or —] | [EPIC-NN or —] | |

**3.6.2 Analyzability** — monitoring and observability; what must be instrumented.

| BRD# | ORD# | Requirement Description | MoSCoW | Timing | Source | Delivery Agent | Verification | Capability | Epic | Comments |
|---|---|---|---|---|---|---|---|---|---|---|
| [BO-N / BR-N or —] | ORD-NNN | [declarative statement carrying the value] | Must | [when live] | [BU, Function, Name] | [Department] | [how proven] | [CAP-NN or —] | [EPIC-NN or —] | |

---

### 3.7 Interaction Capability

**3.7.1 Accessibility** — WCAG level, assistive-technology support.

| BRD# | ORD# | Requirement Description | MoSCoW | Timing | Source | Delivery Agent | Verification | Capability | Epic | Comments |
|---|---|---|---|---|---|---|---|---|---|---|
| [BO-N / BR-N or —] | ORD-NNN | [declarative statement carrying the value] | Must | [when live] | [BU, Function, Name] | [Department] | [how proven] | [CAP-NN or —] | [EPIC-NN or —] | |

**3.7.2 Learnability** — operator training, time-to-competency.

| BRD# | ORD# | Requirement Description | MoSCoW | Timing | Source | Delivery Agent | Verification | Capability | Epic | Comments |
|---|---|---|---|---|---|---|---|---|---|---|
| [BO-N / BR-N or —] | ORD-NNN | [declarative statement carrying the value] | Must | [when live] | [BU, Function, Name] | [Department] | [how proven] | [CAP-NN or —] | [EPIC-NN or —] | |

**3.7.3 Self-Descriptiveness** — documentation, in-system help, runbook obligations.

| BRD# | ORD# | Requirement Description | MoSCoW | Timing | Source | Delivery Agent | Verification | Capability | Epic | Comments |
|---|---|---|---|---|---|---|---|---|---|---|
| [BO-N / BR-N or —] | ORD-NNN | [declarative statement carrying the value] | Must | [when live] | [BU, Function, Name] | [Department] | [how proven] | [CAP-NN or —] | [EPIC-NN or —] | |

---

### 3.8 Functional Suitability

**3.8.1 Functional Completeness** — operational functions required at go-live; what can be phased.

| BRD# | ORD# | Requirement Description | MoSCoW | Timing | Source | Delivery Agent | Verification | Capability | Epic | Comments |
|---|---|---|---|---|---|---|---|---|---|---|
| [BO-N / BR-N or —] | ORD-NNN | [declarative statement carrying the value] | Must | [when live] | [BU, Function, Name] | [Department] | [how proven] | [CAP-NN or —] | [EPIC-NN or —] | |

---

### 3.9 Safety *(if applicable)*

**3.9.1 Fail Safe** — safe-state definition and behaviour on failure.

| BRD# | ORD# | Requirement Description | MoSCoW | Timing | Source | Delivery Agent | Verification | Capability | Epic | Comments |
|---|---|---|---|---|---|---|---|---|---|---|
| [BO-N / BR-N or —] | ORD-NNN | [declarative statement carrying the value] | Must | [when live] | [BU, Function, Name] | [Department] | [how proven] | [CAP-NN or —] | [EPIC-NN or —] | |

**3.9.2 Hazard Warning** — alerting for hazardous conditions.

| BRD# | ORD# | Requirement Description | MoSCoW | Timing | Source | Delivery Agent | Verification | Capability | Epic | Comments |
|---|---|---|---|---|---|---|---|---|---|---|
| [BO-N / BR-N or —] | ORD-NNN | [declarative statement carrying the value] | Must | [when live] | [BU, Function, Name] | [Department] | [how proven] | [CAP-NN or —] | [EPIC-NN or —] | |

> If Safety is not applicable, state in place of the tables above: "[System name] is not
> classified as safety-critical. Safety characteristic requirements are not applicable."

### 3.10 Coverage Gaps

Every ISO/IEC 25010:2023 sub-characteristic with no requirement, listed once. Subsections with no
requirement do not appear in the body above — they appear here.

| Absent subsection | Reason | Action |
|---|---|---|
| [e.g. 3.5 Flexibility → Replaceability] | [e.g. no source material] | [e.g. stakeholder workshop] |

A requirement that exists but is unquantified is **not** a gap — it stays in its own table as a
`[TBD — source: "…"]` row.

---

## 4. Operating Environment and Constraints

Environment and regulatory statements are binding, so they are requirements and carry IDs. Prose
belongs in §2.2 System Overview, not here.

### 4.1 Physical Environment
Hosting model, geographic locations, data residency, power and cooling.

| BRD# | ORD# | Requirement Description | MoSCoW | Timing | Source | Delivery Agent | Verification | Capability | Epic | Comments |
|---|---|---|---|---|---|---|---|---|---|---|
| [BO-N / BR-N or —] | ORD-NNN | [declarative statement carrying the value] | Must | [when live] | [BU, Function, Name] | [Department] | [how proven] | [CAP-NN or —] | [EPIC-NN or —] | |

### 4.2 Network and Connectivity
Bandwidth, latency bounds, protocol and connectivity constraints.

| BRD# | ORD# | Requirement Description | MoSCoW | Timing | Source | Delivery Agent | Verification | Capability | Epic | Comments |
|---|---|---|---|---|---|---|---|---|---|---|
| [BO-N / BR-N or —] | ORD-NNN | [declarative statement carrying the value] | Must | [when live] | [BU, Function, Name] | [Department] | [how proven] | [CAP-NN or —] | [EPIC-NN or —] | |

> Network latency that affects user-facing response time belongs in §3.1.1 Time Behavior. Record
> it once — cite the ID here as a view rather than restating the value.

### 4.3 Regulatory and Compliance Constraints
Each regulation and the specific operational obligation it imposes.

| BRD# | ORD# | Requirement Description | MoSCoW | Timing | Source | Delivery Agent | Verification | Capability | Epic | Comments |
|---|---|---|---|---|---|---|---|---|---|---|
| [BO-N / BR-N or —] | ORD-NNN | [declarative statement carrying the value] | Must | [when live] | [BU, Function, Name] | [Department] | [how proven] | [CAP-NN or —] | [EPIC-NN or —] | |

> Certification and audit obligations belong in §3.3.6 Compliance Frameworks. This subsection
> carries operational obligations imposed *by* regulation, not the frameworks themselves.

---

## 5. Support Model

### 5.1 Support Tier Structure
| Tier | Description | Owner | Coverage |
|---|---|---|---|
| Tier 0 | Self-service / knowledge base | [Team] | 24/7 |
| Tier 1 | Service desk — first contact | [Team] | [Hours] |
| Tier 2 | Technical operations | [Team] | [Hours / On-call] |
| Tier 3 | Development / vendor escalation | [Team / Vendor] | [SLA-driven] |

### 5.2 Incident Management

Severity definitions are context (prose); the response and resolution commitments are register rows.

| Severity | Definition |
|---|---|
| P1 Critical | [definition] |
| P2 High | [definition] |
| P3 Medium | [definition] |
| P4 Low | [definition] |

| BRD# | ORD# | Requirement Description | MoSCoW | Timing | Source | Delivery Agent | Verification | Capability | Epic | Comments |
|---|---|---|---|---|---|---|---|---|---|---|
| [BO-N / BR-N or —] | ORD-NNN | [e.g. P1 incident response is initiated within 15 minutes of raise] | Must | [when live] | [BU, Function, Name] | [Department] | [e.g. ITSM report] | [CAP-NN or —] | [EPIC-NN or —] | |
| [BO-N / BR-N or —] | ORD-NNN | [e.g. P1 incident resolution is achieved within 2 hours of raise] | Must | [when live] | [BU, Function, Name] | [Department] | [e.g. ITSM report] | [CAP-NN or —] | [EPIC-NN or —] | |

### 5.3 Change and Patch Management
Change windows, emergency change path, patch SLAs by severity.

| BRD# | ORD# | Requirement Description | MoSCoW | Timing | Source | Delivery Agent | Verification | Capability | Epic | Comments |
|---|---|---|---|---|---|---|---|---|---|---|
| [BO-N / BR-N or —] | ORD-NNN | [declarative statement carrying the value] | Must | [when live] | [BU, Function, Name] | [Department] | [how proven] | [CAP-NN or —] | [EPIC-NN or —] | |

### 5.4 Monitoring and Alerting
Instrumentation coverage, alert thresholds, on-call routing.

| BRD# | ORD# | Requirement Description | MoSCoW | Timing | Source | Delivery Agent | Verification | Capability | Epic | Comments |
|---|---|---|---|---|---|---|---|---|---|---|
| [BO-N / BR-N or —] | ORD-NNN | [declarative statement carrying the value] | Must | [when live] | [BU, Function, Name] | [Department] | [how proven] | [CAP-NN or —] | [EPIC-NN or —] | |

---

## 6. Staffing and Organizational Requirements

Role roster — context, not commitments. The binding staffing requirements are register rows below.

| Role | Responsibilities | Skills / Certifications | FTE |
|---|---|---|---|
| [Role] | [Description] | [Requirements] | [Count] |

**Operating commitments** — on-call, training, handover, and the FTE establishment itself are
binding, so they are rows.

| BRD# | ORD# | Requirement Description | MoSCoW | Timing | Source | Delivery Agent | Verification | Capability | Epic | Comments |
|---|---|---|---|---|---|---|---|---|---|---|
| [BO-N / BR-N or —] | ORD-NNN | [declarative statement carrying the value] | Must | [when live] | [BU, Function, Name] | [Department] | [how proven] | [CAP-NN or —] | [EPIC-NN or —] | |

---

## 7. Service Level Requirements

> *View of Sections 3 and 5. Values are authoritative in the referenced rows; this table adds no
> new commitments.* Externally-facing SLA summary — every row cites an existing `ORD-NNN`.

| ORD# | Section | Metric | Agreed value | Measurement Period | Data Source |
|---|---|---|---|---|---|
| ORD-NNN | §3.2.1 | Availability | [as registered] | Calendar month | [Monitoring tool] |
| ORD-NNN | §5.2 | P1 Response | [as registered] | Per incident | [ITSM tool] |
| ORD-NNN | §3.2.4 | MTTR | [as registered] | Rolling 3 months | [ITSM tool] |

**SLA governance** — review cadence and breach reporting are themselves commitments.

| BRD# | ORD# | Requirement Description | MoSCoW | Timing | Source | Delivery Agent | Verification | Capability | Epic | Comments |
|---|---|---|---|---|---|---|---|---|---|---|
| [BO-N / BR-N or —] | ORD-NNN | [declarative statement carrying the value] | Must | [when live] | [BU, Function, Name] | [Department] | [how proven] | [CAP-NN or —] | [EPIC-NN or —] | |

---

## 8. Infrastructure and Facilities

Hosting model, compute, storage, network, and physical security of operational infrastructure.

| BRD# | ORD# | Requirement Description | MoSCoW | Timing | Source | Delivery Agent | Verification | Capability | Epic | Comments |
|---|---|---|---|---|---|---|---|---|---|---|
| [BO-N / BR-N or —] | ORD-NNN | [declarative statement carrying the value] | Must | [when live] | [BU, Function, Name] | [Department] | [how proven] | [CAP-NN or —] | [EPIC-NN or —] | |

---

## 9. Trade-offs, Risk, Assumptions and Dependencies

### 9.1 Accepted Trade-offs and Risks

Risks are owned by the RAID log — cite the `R-NNN` rather than duplicating the risk record.

| RAID Ref | Trade-off / Risk | Accepted? | Mitigation |
|---|---|---|---|
| [R-NNN or —] | [e.g. cost vs availability] | Yes / No | [Mitigation] |

### 9.2 Assumptions

Carries forward the assumptions table from `/idea`. `If false` is mandatory. On falsification set
`Status: Falsified`, run `/raid add risk`, and record the `R-NNN` in `If false`.

| ID | Assumption | Status | If false | Owner |
|---|---|---|---|---|
| ASM-NNN | [declarative statement] | Unvalidated / Validated / Falsified | [consequence] | [role] |

### 9.3 Dependencies

| ID | Depends on | Type | Owner | Needed by | Status |
|---|---|---|---|---|---|
| DEP-NNN | [named system, team, or deliverable] | Internal / External / Vendor | [role] | [date or milestone] | Open / Met / At risk |

---

## Appendices

### A. Acronyms and Abbreviations
### B. PRD Cross-Link

> *View. The register in §§3–8 is the source of truth — `BRD#` and `Source` already live in each
> row, so they are not restated here.*

This appendix exists only for the one link the register cannot hold: the sibling PRD. Omit it
entirely for a standalone ORD. It is populated by `/write-reqs`, which owns the cross-link pass.

| ORD# | Section | PRD# |
|---|---|---|
| ORD-001 | [e.g. 3.2.1] | [PRD-NNN] |

Flag rather than resolve, against the register itself:
- A row with `BRD#` = `—` **and** no `Source` is **orphan scope**.
- A BRD requirement with no resulting register row is a **coverage gap**.
- `ASM-NNN` and `DEP-NNN` are not requirements and never appear here — they live in §9.

### E. Interface Detail

Per-interface technical detail, keyed to the §3.4.1 register rows. Specification, not commitment —
the binding statement is the register row.

| ORD# | Integrated System | Interface Type | Protocol | Data Exchanged | Direction | Failure Behavior |
|---|---|---|---|---|---|---|
| ORD-NNN | [System name] | [REST/SFTP/etc.] | [HTTPS/SFTP/etc.] | [Description] | [In/Out/Bidirectional] | [Queue / alert / degrade] |

### C. Contacts
### D. Change History
```
