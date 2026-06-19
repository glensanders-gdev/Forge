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
> Every requirement carries a stable ID — `ORD-001`, `ORD-002`, … flat and sequential, assigned in order of first appearance. In tables use the ID column; in prose subsections prefix the requirement with its bold ID (e.g. **ORD-007**). IDs never encode the characteristic and are never reused once retired.

### 3.1 Performance Efficiency

**3.1.1 Time Behavior**

| ID | Requirement | Threshold | Objective | Measurement |
|---|---|---|---|---|
| ORD-001 | [e.g. API response time] | [e.g. ≤ 3s P95] | [e.g. ≤ 1s P95] | [e.g. APM tool, monthly report] |

**3.1.2 Resource Utilization**
[CPU, memory, storage, network constraints under defined load.]

**3.1.3 Capacity** **[KPP candidate]**
[Peak concurrent users, transaction throughput, data volume limits, growth projections.]

---

### 3.2 Reliability

**3.2.1 Availability** **[KPP]**
- **ORD-NNN** Uptime target: [e.g. 99.9% per calendar month]
- Measurement period: [calendar month / rolling 30 days]
- Permitted maintenance windows: [e.g. 4 hours/month, 02:00–06:00 local]

**3.2.2 Fault Tolerance**
[Behavior under partial failure — what the system must continue to do.]

**3.2.3 Recoverability**
- Recovery Time Objective (RTO): [e.g. 4 hours]
- Recovery Point Objective (RPO): [e.g. 1 hour]
- Maximum Tolerable Period of Disruption (MTPD): [e.g. 8 hours]

**3.2.4 Faultlessness**
[Defect rate targets in production, MTBF, MTTR.]

---

### 3.3 Security

**3.3.1 Confidentiality**
[Data classification, encryption at rest and in transit, access control model.]

**3.3.2 Integrity**
[Data integrity controls, audit logging requirements.]

**3.3.3 Non-repudiation and Accountability**
[Audit trail requirements, log retention periods.]

**3.3.4 Authenticity**
[Authentication standards — MFA, SSO, certificate requirements.]

**3.3.5 Resistance**
[Penetration test cadence, vulnerability SLA (e.g. critical patched within 24h).]

**3.3.6 Compliance Frameworks**
[FedRAMP / HIPAA / PCI-DSS / ISO 27001 / SOC 2 / other applicable frameworks.]

---

### 3.4 Compatibility

**3.4.1 Interoperability**

| ID | Integrated System | Interface Type | Protocol | Data Exchanged | Direction | Failure Behavior |
|---|---|---|---|---|---|---|
| ORD-NNN | [System name] | [REST/SFTP/etc.] | [HTTPS/SFTP/etc.] | [Description] | [In/Out/Bidirectional] | [Queue / alert / degrade] |

**3.4.2 Coexistence**
[Shared infrastructure constraints — no degradation of co-hosted systems.]

---

### 3.5 Flexibility

**3.5.1 Scalability**
[Horizontal/vertical scaling requirements, elasticity targets, growth projections 1/3/5 year.]

**3.5.2 Adaptability**
[Multi-environment requirements — cloud regions, hosting models.]

**3.5.3 Installability**
[Deployment and upgrade requirements, rollback capability.]

---

### 3.6 Maintainability

**3.6.1 Modifiability**
[Change window requirements, change management process obligations.]

**3.6.2 Analyzability**
[Monitoring and observability requirements — what must be instrumented.]

---

### 3.7 Interaction Capability

**3.7.1 Accessibility**
[WCAG level, assistive technology support requirements.]

**3.7.2 Learnability**
[Operator training requirements, time-to-competency targets.]

**3.7.3 Self-Descriptiveness**
[Documentation requirements, in-system help, runbook obligations.]

---

### 3.8 Functional Suitability

**3.8.1 Functional Completeness**
[What operational functions must be present at go-live; what can be phased.]

---

### 3.9 Safety *(if applicable)*

**3.9.1 Fail Safe**
[System behavior on failure — safe state definition.]

**3.9.2 Hazard Warning**
[Alerting requirements for hazardous conditions.]

> If Safety is not applicable: "This system is not classified as safety-critical. Safety characteristic requirements are not applicable."

---

## 4. Operating Environment and Constraints

### 4.1 Physical Environment
[Data center, cloud, edge, geographic locations, power and cooling constraints.]

### 4.2 Network and Connectivity
[Bandwidth, latency bounds, protocol requirements, VPN, air-gap constraints.]

### 4.3 Regulatory and Compliance Constraints
[All applicable regulations and the specific operational obligations they impose.]

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
| Severity | Definition | Response Target | Resolution Target |
|---|---|---|---|
| P1 Critical | [definition] | [e.g. 15 min] | [e.g. 2 hours] |
| P2 High | [definition] | [e.g. 1 hour] | [e.g. 8 hours] |
| P3 Medium | [definition] | [e.g. 4 hours] | [e.g. 2 days] |
| P4 Low | [definition] | [e.g. next business day] | [e.g. 5 days] |

### 5.3 Change and Patch Management
[Change windows, emergency change process, patch SLAs by severity.]

### 5.4 Monitoring and Alerting
[What must be monitored, alert thresholds, on-call model, tooling.]

---

## 6. Staffing and Organizational Requirements

| Role | Responsibilities | Skills / Certifications | FTE |
|---|---|---|---|
| [Role] | [Description] | [Requirements] | [Count] |

**On-call model:** [24/7 / business hours + on-call / other]  
**Training requirements:** [Mandatory training per role, refresh cadence]  
**Handover criteria:** [What must be true before project team hands to operations]

---

## 7. Service Level Requirements

| Metric | Target | Measurement Period | Data Source |
|---|---|---|---|
| Availability | [e.g. 99.9%] | Calendar month | [Monitoring tool] |
| P1 Response | [e.g. 15 min] | Per incident | [ITSM tool] |
| P1 Resolution | [e.g. 2 hours] | Per incident | [ITSM tool] |
| MTTR | [e.g. < 2 hours] | Rolling 3 months | [ITSM tool] |

**SLA review cadence:** [e.g. quarterly]  
**Breach reporting:** [How and to whom breaches are reported]

---

## 8. Infrastructure and Facilities

[Hosting model, hardware requirements, storage, network infrastructure, physical security of operational infrastructure.]

---

## 9. Trade-offs and Risk

| Trade-off / Risk | Description | Accepted? | Mitigation |
|---|---|---|---|
| [e.g. Cost vs availability] | [Description] | Yes / No | [Mitigation] |

**Assumptions:**  
**Dependencies:**

---

## Appendices

### A. Acronyms and Abbreviations
### B. Requirements Traceability Matrix

One row per requirement. Anchored on the BRD (the ORD's origin). The PRD column is `—` for a standalone ORD; it is populated only when the ORD is authored jointly with a PRD via `$write-reqs`.

| ORD Req ID | ISO/IEC 25010 Characteristic | BRD Objective | Provenance / Source | PRD Ref |
|---|---|---|---|---|
| ORD-001 | [Characteristic] | [BRD-NN or —] | [source quote / stakeholder] | [— or PRD-NNN] |

- A requirement with no BRD objective and no source is **orphan scope** — flag it.
- A BRD objective with no resulting requirement is a **coverage gap** — flag it.

### C. Contacts
### D. Change History
```
