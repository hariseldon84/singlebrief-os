# SingleBrief PRD - Section 1 Insights from Socratic Questioning

**Date:** 2025-10-04
**Method:** Socratic Questioning with Product Team
**Facilitator:** PM John

---

## Critical New Insights Beyond Brainstorming

### 1. Manager Struggle Hierarchy (NEW)

**Primary Struggle:** Personal motivation ("Is this worth my time and energy?")
**Secondary Struggle:** Justifying to leadership (ROI/business value)
**Tertiary Struggle:** Justifying to team ("Why are we doing this?")

**Implication:** SingleBrief must address motivation, not just execution.

---

### 2. Moments of Maximum Frustration

1. **Blank page paralysis** - Getting assigned new project, staring at nothing
2. **Overwhelming explanation** - Trying to communicate project to team
3. **Lack of clarity** - "What do I do first?"
4. **Lack of motivation** - "Why should we do this?" (impact measurement gap)
5. **Fear of missing something** - "What am I overlooking?"

**Original brainstorming identified:** 1, 3, 5
**New insights discovered:** 2, 4

---

### 3. "Why This Matters" Feature (MVP Addition)

#### Feature Specification

**What:** AI generates business value/impact framing section after task breakdown

**When:** AFTER task breakdown is shown (not before)

**Status:** Optional (manager can skip)

**Manager Controls:**
- ✅ Edit directly (simple text field)
- ✅ Reject and regenerate with feedback
- ✅ Skip entirely

**Content:**
- Business value articulation ("What problem does this solve?")
- Suggested impact metrics based on brief content
- Motivation framing for manager and team

---

### 4. Strategic Sequencing Decision

**Flow:**
1. Manager creates brief (text input)
2. AI generates task breakdown
3. **Manager reviews tasks FIRST** (builds trust in AI competence)
4. AI offers "Why This Matters" section (optional, lower stakes)
5. Manager edits/regenerates/accepts/skips

**Rationale:**
- Task breakdown proves AI value first
- Business value framing is additive, not critical path
- If "Why This Matters" is weak, doesn't damage trust in tasks
- Core value (tasks) delivered before bonus feature (motivation)

---

### 5. Timeline Impact

**Original MVP:** 4 weeks
**Updated MVP:** 5 weeks

**Breakdown:**
- Weeks 1-4: Core confidence loop (original scope from tech3.md)
- Week 5: "Why This Matters" feature + final polish

**Trade-off Decision:** Extended timeline rather than cutting features

---

### 6. Success Metrics

**"Why This Matters" Feature Success:**
- **Primary Metric:** 80%+ adoption rate (managers choose to use it)
- **Validation:** Feature resonates if vast majority of managers keep it vs. skip

**Confidence Loop Success (from brainstorming):**
- Managers can create brief → tasks in <1 minute
- AI task acceptance rate >70%
- Review loop feels natural (accept/reject/re-run)
- Managers feel more confident vs. before using system
- At least 1 AI agent used regularly

---

### 7. Product Positioning Shift

**Original Positioning (from brainstorming):**
- "Task management tool that uses AI to break down briefs"

**Updated Positioning:**
- "Confidence platform that eliminates planning paralysis through AI-powered task breakdown AND business value clarity"

**Implication:** We're solving TWO confidence gaps:
1. **Execution confidence** - "What do I do?" (task breakdown)
2. **Motivational confidence** - "Why does this matter?" (business value)

---

### 8. Coupled Trust Analysis

**Question:** If AI gets "Why This Matters" wrong, does it damage trust in task breakdown?

**Answer (inferred from sequencing decision):**
- NO - they are mentally separate in manager's mind
- Showing tasks FIRST prevents contamination
- "Why This Matters" is optional, so low-stakes experimentation
- Manager can ignore weak business value framing without losing task value

---

## Updated MVP Scope

### Original Scope (from tech3.md)
1. Brief creation (text input)
2. AI task breakdown
3. Manual add/edit/delete tasks
4. Assign to 2 AI agents (Content, Email) or humans (one per task)
5. Human notifications
6. Manager review loop (accept/reject/re-run)
7. Progress tracking (brief + project level)
8. Dashboard view
9. Search briefs
10. Download outputs + PDF export
11. Manual refresh
12. Team management
13. Basic auth
14. Personal workspace per user
15. Invite-only + manual invoicing

### NEW Addition (from Socratic questioning)
16. **"Why This Matters" AI-generated section** (optional, post-task breakdown)
    - Business value articulation
    - Suggested impact metrics
    - Edit or regenerate with feedback
    - Success metric: 80%+ adoption

---

## Requirements Impact

These insights will add new requirements in Section 2:

**Functional Requirements:**
- FR-NEW: AI generates "Why This Matters" section after task breakdown
- FR-NEW: Manager can edit "Why This Matters" directly
- FR-NEW: Manager can regenerate "Why This Matters" with feedback
- FR-NEW: Manager can skip "Why This Matters" (optional field)

**Non-Functional Requirements:**
- NFR-NEW: "Why This Matters" generation time <5 seconds
- NFR-NEW: 80%+ adoption rate target for "Why This Matters" feature

**Compatibility Requirements:**
- CR-NEW: "Why This Matters" must not delay task breakdown delivery
- CR-NEW: Review loop pattern (accept/reject/re-run) consistent across tasks and business value

---

## Questions for Further Exploration

1. What AI prompt generates compelling "Why This Matters" content?
2. Should "Why This Matters" be visible to team members when tasks are assigned?
3. Can we measure actual motivation/confidence increase, or just adoption?
4. Should impact metrics be tracked over time (predicted vs. actual)?
5. Does "Why This Matters" appear in PDF exports?

---

*Insights captured from Socratic Questioning session - Section 1 complete*
