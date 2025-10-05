# PRD Source Document Mapping Table

**Purpose:** Navigation guide for tracing CONSOLIDATED_PRD sections back to original source documents

**Last Updated:** 2025-10-05
**Total Source Files:** 17 (16 source + 1 consolidated)

---

## Quick Reference Map

| CONSOLIDATED_PRD Section | Source Documents | Lines | Description |
|--------------------------|------------------|-------|-------------|
| **1. Executive Summary** | prd_section1.md<br>prd_section1_insights.md | 102<br>185 | Product vision, core problem, solution approach, key metrics, competitive differentiation |
| **2. Business Context & Strategic Vision** | brainstorming-session-results.md<br>tech1.md<br>tech2.md<br>tech3.md | 500+<br>150+<br>150+<br>150+ | First principles thinking, MoSCoW prioritization, resource constraints, strategic themes |
| **3. Product Overview** | prd_section2.md<br>prd_section2_updates.md | 257<br>172 | Target users, user journeys, core features summary |
| **4. Complete Requirements (FR1-FR128)** | prd_section3.md<br>+ 9 elicitation files<br>prd_section3_summary.md | 295<br>4,500+<br>486 | Functional requirements via 9 analysis methods, NFRs |
| **5. Technical Architecture** | prd_section4.md | 1,239 | Tech stack, database schema, n8n workflows, AI integration, no-code approach |
| **6. Implementation Plan** | prd_section5.md | 1,807 | 8 epics, 42 stories, 5-week timeline, story point breakdown |
| **7. Success Metrics** | Various sections | N/A | MVP criteria, post-MVP metrics (synthesized from multiple sources) |
| **8. Appendices** | Various sections | N/A | Glossary, decisions, backlog, technical debt (synthesized) |

---

## Detailed Section Mapping

### Section 1: Executive Summary

**Consolidated Lines:** 24-80

| Subsection | Source File(s) | Key Content |
|------------|----------------|-------------|
| 1.1 Product Vision | prd_section1.md | SingleBrief transforms planning paralysis into action confidence |
| 1.2 Core Problem | tech1.md (First Principles) | Planning inertia, overwhelming scope, time scarcity, fear of incompleteness |
| 1.3 Solution | prd_section1.md | Confidence through visibility, AI breakdown, manager control |
| 1.4 Key Metrics | prd_section1_insights.md | MVP success criteria, 5-week timeline |
| 1.5 Competitive Differentiation | prd_section1.md | Why SingleBrief vs. ChatGPT (8 differentiators) |

---

### Section 2: Business Context & Strategic Vision

**Consolidated Lines:** 82-148

| Subsection | Source File(s) | Key Content |
|------------|----------------|-------------|
| 2.1 First Principles Analysis | tech1.md | Core insight: Confidence is the product, not task management |
| 2.2 Minimum Viable Confidence Loop | tech1.md | 6-step confidence loop |
| 2.3 MVP Prioritization | tech2.md (MoSCoW) | 35 MUST, 5 SHOULD, 4 COULD, 13 WON'T features from 57 analyzed |
| 2.4 Resource Constraints | tech3.md | 8 major cuts/simplifications to fit 4→5 week timeline |
| 2.5 Strategic Themes | brainstorming-session-results.md | 5 strategic themes identified |

---

### Section 3: Product Overview

**Consolidated Lines:** 150-274

| Subsection | Source File(s) | Key Content |
|------------|----------------|-------------|
| 3.1 Target Users | prd_section2.md | Primary: Managers, Secondary: Team Members, Tertiary: AI Agents |
| 3.2 User Journeys | prd_section2.md | 4 complete user journeys (Happy Path, Team Execution, Manager Review, AI Batch) |
| 3.3 Core Features Summary | prd_section2_updates.md | Brief management, task management, AI execution, review workflow, collaboration, search, deliverables |

---

### Section 4: Complete Requirements

**Consolidated Lines:** 276-482

#### 4.1 Functional Requirements (FR1-FR128)

**Primary Source:** prd_section3.md (base requirements)

**Elicitation Method Files (9 Total):**

| File | Lines | Method | FRs Contributed |
|------|-------|--------|-----------------|
| prd_section3_team_member_perspective.md | 362 | Team Member POV | Task inbox, notifications, progress tracking refinements |
| prd_section3_ai_agent_perspective.md | 455 | AI Agent POV | Queuing system, batch execution, context window |
| prd_section3_scenario_planning.md | 466 | Scenario Planning | Edge cases, error handling, workflow states |
| prd_section3_analogical_thinking.md | 527 | Analogical Thinking | Presence indicators (Q8), review loop patterns |
| prd_section3_assumptions_challenged.md | 546 | Assumptions Challenge | Optional progress tracking, template validation |
| prd_section3_tradeoff_analysis.md | 550 | Tradeoff Analysis | Polling vs. real-time, single assignee decisions |
| prd_section3_gap_analysis.md | 683 | Gap Analysis | Onboarding, bulk actions, quick-add tasks |
| prd_section3_risk_exploration.md | 753 | Risk Exploration | Rework cycle limits, rejection feedback requirements |
| prd_section3_summary.md | 486 | Summary Synthesis | Final 111 FRs consolidated |

**Epic 8 Addition (FR112-FR128):** Added post-summary for authentication/security foundation

#### 4.2 Non-Functional Requirements (NFR1-NFR30)

**Source:** prd_section3_summary.md + tech3.md (constraints)

| NFR Category | Count | Source |
|--------------|-------|--------|
| Performance | NFR1-NFR6 | tech3.md (resource constraints) |
| Scalability | NFR7-NFR10 | prd_section3_summary.md |
| Security | NFR11-NFR15 | prd_section3_summary.md |
| Reliability | NFR16-NFR19 | prd_section3_summary.md |
| Usability | NFR20-NFR23 | prd_section3_gap_analysis.md |
| Maintainability | NFR24-NFR27 | tech3.md (no-code approach) |
| Cost | NFR28-NFR30 | tech3.md (resource constraints) |

---

### Section 5: Technical Architecture

**Consolidated Lines:** 485-756

| Subsection | Source File(s) | Key Content |
|------------|----------------|-------------|
| 5.1 Technology Stack | prd_section4.md | Frontend (React/Vite), Backend (n8n/Supabase), Hosting (Vercel/Railway) |
| 5.2 Database Schema | prd_section4.md | 11 tables fully specified with SQL |
| 5.3 n8n Workflows | prd_section4.md | 6 workflows documented (task breakdown, AI execution, notifications, etc.) |
| 5.4 Authentication | prd_section4.md | Supabase Auth, JWT, RLS policies, magic links |
| 5.5 AI Integration | prd_section4.md | OpenRouter, GPT-4o-mini, cost estimates, fallback models |
| 5.6 No-Code Workflow | prd_section4.md | v0.dev + Claude Code + GitHub Copilot development process |

---

### Section 6: Implementation Plan

**Consolidated Lines:** 758-876

| Subsection | Source File(s) | Key Content |
|------------|----------------|-------------|
| 6.1 Epic-Based Timeline | prd_section5.md | 5-week breakdown, 42 stories, 220 story points |
| 6.2 Epic 8: Authentication | Added post-prd_section5.md | Security foundation, 2 stories, 8 points |
| 6.3 Critical Path | prd_section5.md | Epic 1 → Epic 2 (+ Epic 8) → Epic 4 → Epic 7 |
| 6.4 Risk Mitigation | prd_section5.md | Risks mapped to specific stories |

**Epic Breakdown:**

| Epic | Week | Stories | Points | Source Section |
|------|------|---------|--------|----------------|
| Epic 1: Brief Creation | Week 1 | 8 | 41 | prd_section5.md Section 5.3 |
| Epic 2: Task Management | Week 2 | 10 | 40 | prd_section5.md Section 5.4 |
| Epic 3: AI Agents | Week 2 | 5 | 27 | prd_section5.md Section 5.5 |
| Epic 4: Review Workflow | Week 3 | 6 | 35 | prd_section5.md Section 5.6 |
| Epic 5: Collaboration | Week 3 | 5 | 27 | prd_section5.md Section 5.7 |
| Epic 6: Search & Navigation | Week 4 | 4 | 20 | prd_section5.md Section 5.8 |
| Epic 7: "Why This Matters" | Week 5 | 4 | 18 | prd_section5.md Section 5.9 |
| Epic 8: Authentication | Week 2 | 2 | 8 | Added to CONSOLIDATED_PRD Section 6.2 |
| **Total** | **5 weeks** | **44** | **216** | **prd_section5.md + additions** |

**Note:** Slight variance in story count (42 vs 44) and points (220 vs 216) due to Epic 8 integration adjustments.

---

### Section 7: Success Metrics

**Consolidated Lines:** 878-914

| Subsection | Source File(s) | Key Content |
|------------|----------------|-------------|
| 7.1 MVP Success Criteria | prd_section1_insights.md + tech2.md | Product validation, user engagement, technical performance metrics |
| 7.2 Post-MVP Metrics | brainstorming-session-results.md | Retention, monetization, product evolution targets |

---

### Section 8: Appendices

**Consolidated Lines:** 916-1034

| Subsection | Source File(s) | Key Content |
|------------|----------------|-------------|
| 8.1 Glossary | prd_section3_summary.md | Key terms defined |
| 8.2 User Decisions | prd_section3_analogical_thinking.md<br>prd_section3_assumptions_challenged.md<br>prd_section3_tradeoff_analysis.md | 12 critical decisions from elicitation (Q1-Q12 answers) |
| 8.3 Post-MVP Backlog | tech2.md (WON'T Have) | Deferred features for v2+ |
| 8.4 Technical Debt | tech3.md (constraints) | Known limitations and migration triggers |
| 8.5 Cost Breakdown | tech3.md | MVP and scale cost estimates |
| 8.6 Document Version History | N/A (CONSOLIDATED_PRD only) | Consolidation history and source list |

---

## Document Evolution Timeline

```
Phase 1: Foundation Research (Oct 4 AM)
├── brainstorming-session-results.md
├── tech1.md (First Principles)
├── tech2.md (MoSCoW)
└── tech3.md (Resource Constraints)

Phase 2: Product Definition (Oct 4 Midday)
├── prd_section1.md (Executive Summary)
├── prd_section1_insights.md
├── prd_section2.md (Product Overview)
└── prd_section2_updates.md

Phase 3: Requirements Elicitation (Oct 4 PM - Oct 5 AM)
├── prd_section3.md (Base Requirements)
├── prd_section3_team_member_perspective.md
├── prd_section3_ai_agent_perspective.md
├── prd_section3_scenario_planning.md
├── prd_section3_analogical_thinking.md
├── prd_section3_assumptions_challenged.md
├── prd_section3_tradeoff_analysis.md
├── prd_section3_gap_analysis.md (Latest: Oct 5 12:10)
├── prd_section3_risk_exploration.md
└── prd_section3_summary.md

Phase 4: Technical Design (Oct 4 Late PM)
└── prd_section4.md

Phase 5: Implementation Planning (Oct 4 Night)
└── prd_section5.md

Phase 6: Consolidation (Oct 5 AM)
└── CONSOLIDATED_PRD.md (v1.0, Oct 5 08:43)

Phase 7: Refinement (Oct 5)
└── CONSOLIDATED_PRD.md (Updated Oct 5 with Epic 8 notes)
```

---

## File Size Reference

| File | Lines | Size Category | Purpose |
|------|-------|---------------|---------|
| CONSOLIDATED_PRD.md | 1,034 | Large | **SINGLE SOURCE OF TRUTH** |
| prd_section5.md | 1,807 | XL | Epic/Story details |
| prd_section4.md | 1,239 | Large | Technical architecture |
| prd_section3_risk_exploration.md | 753 | Medium | Risk analysis |
| prd_section3_gap_analysis.md | 683 | Medium | Gap identification |
| prd_section3_tradeoff_analysis.md | 550 | Medium | Decision analysis |
| prd_section3_assumptions_challenged.md | 546 | Medium | Assumption validation |
| prd_section3_analogical_thinking.md | 527 | Medium | Pattern matching |
| prd_section3_summary.md | 486 | Medium | Requirements summary |
| prd_section3_scenario_planning.md | 466 | Medium | Edge cases |
| prd_section3_ai_agent_perspective.md | 455 | Medium | AI requirements |
| prd_section3_team_member_perspective.md | 362 | Small | Team UX |
| prd_section3.md | 295 | Small | Base requirements |
| prd_section2.md | 257 | Small | Product overview |
| prd_section1_insights.md | 185 | Small | Executive insights |
| prd_section2_updates.md | 172 | Small | Product updates |
| prd_section1.md | 102 | Small | Executive summary |

---

## Navigation Tips

### Finding Specific Content

**For Business Context:**
- Strategic decisions → `tech2.md` (MoSCoW)
- Timeline constraints → `tech3.md` (Resource Constraints)
- Core philosophy → `tech1.md` (First Principles)

**For Requirements:**
- Start with → `prd_section3.md` (base FRs)
- Deep dive → Choose elicitation method file for specific domain
- Final list → `prd_section3_summary.md`

**For Technical Details:**
- Database → `prd_section4.md` Section 5.2
- n8n workflows → `prd_section4.md` Section 5.3
- Cost estimates → `tech3.md` + `prd_section4.md` Section 5.5

**For Implementation:**
- Epic breakdown → `prd_section5.md`
- Story details → `prd_section5.md` Sections 5.3-5.9
- Timeline → `prd_section5.md` Section 5.2

### When to Use Source Files vs. CONSOLIDATED_PRD

**Use CONSOLIDATED_PRD for:**
- Implementation reference
- Dev handoff
- Story creation
- Technical specs

**Use Source Files for:**
- Understanding decision rationale
- Seeing evolution of ideas
- Deep-diving into specific elicitation methods
- Audit trail for stakeholder questions

---

## Maintenance Notes

**Document Owner:** Product Manager (or designated maintainer)

**Update Triggers:**
1. New epic added → Update Section 6, Epic table
2. FR changes → Update Section 4, trace back to source if needed
3. Architecture changes → Update Section 5
4. Timeline shifts → Update Section 6

**Archive Policy:**
- Source files: Keep in `/docs/prd/` for reference
- CONSOLIDATED_PRD: Version control all changes
- Deprecated sources: Move to `/docs/prd/archive/` if consolidation is re-run

---

**END OF SOURCE MAPPING**

**Quick Access:** All PRD files located in `/docs/prd/`
**Primary Reference:** `CONSOLIDATED_PRD.md` (Updated Oct 5, 2025)
