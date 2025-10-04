# PRD Section 2 - Updates from Perspective Shifting

**Date:** 2025-10-04
**Elicitation Method:** Perspective Shifting (Skeptical Manager)

---

## Requirement Updates Based on Feedback

### FR6 Update: AI Task Breakdown Timing

**Original:**
> **FR6:** System shall automatically generate micro-tasks from brief content using AI (LLM integration) within 30 seconds of brief submission.

**Updated:**
> **FR6:** System shall automatically generate micro-tasks from brief content using AI (LLM integration). Generation time will vary based on brief complexity and length.

**Rationale:**
- Removed artificial 30-second constraint
- AI generation speed depends on LLM API performance and brief complexity
- Better to set user expectations through UI feedback ("Generating tasks...") than hard time limits
- Allows for higher quality task breakdown without arbitrary deadline pressure

---

### FR20 Update: Single Assignee Workaround

**Original:**
> **FR20:** System shall support single assignee per task (one AI agent OR one human, not multiple - simplified MVP model).

**Updated:**
> **FR20:** System shall support single assignee per task (one AI agent OR one human, not multiple). For collaborative tasks requiring multiple assignees, manager can duplicate the task and assign to different team members. **Note:** Full product roadmap includes native multi-assignee support post-MVP.

**Rationale:**
- Documents the duplicate-task workaround explicitly
- Acknowledges this is MVP simplification, not permanent design
- Sets expectation for future enhancement
- Helps developers understand this is temporary technical debt

---

### FR8 Update: "Why This Matters" Quality Expectations

**Original:**
> **FR8:** System shall generate "Why This Matters" section after task breakdown, including business value articulation and suggested impact metrics (optional feature).

**Updated:**
> **FR8:** System shall generate "Why This Matters" section after task breakdown, including business value articulation and suggested impact metrics (optional feature). **MVP Quality Bar:** Generic/buzzword content acceptable for initial launch; post-MVP iterations will focus on improving specificity and relevance through prompt engineering and user feedback.

**Rationale:**
- Sets realistic expectations for MVP AI quality
- Acknowledges "corporate buzzword soup" risk is known and acceptable initially
- Commits to improvement post-launch based on real user feedback
- Prevents over-investment in prompt engineering during MVP phase

---

## Critical Differentiator: Why Not ChatGPT + MCPs + Agents?

### The Skeptical Manager's Question

**"Why can't I just use ChatGPT with MCPs and AI agents to do all this?"**

This is THE critical product positioning question that will determine SingleBrief's viability.

### Answer Framework (for PRD Section 1 or Positioning Doc)

#### 1. Persistent State Management
- **ChatGPT:** Ephemeral chat conversations, context lost when session ends
- **SingleBrief:** Structured database where briefs, tasks, and progress persist indefinitely
- **Manager Value:** Can return to a brief weeks later and see full history

#### 2. Team Collaboration
- **ChatGPT:** Solo interaction, outputs need manual distribution to team
- **SingleBrief:** Team members are system users who receive tasks, submit outputs, collaborate
- **Manager Value:** Team sees assignments automatically, manager doesn't manually forward AI outputs

#### 3. Manager Review Loop
- **ChatGPT:** Regenerate outputs via new prompts, no structured workflow
- **SingleBrief:** Built-in accept/reject/re-run with feedback, task versioning
- **Manager Value:** Quality control is workflow, not ad-hoc prompting

#### 4. Progress Visibility
- **ChatGPT:** Buried in chat history, requires scrolling/searching
- **SingleBrief:** Real-time dashboard showing all briefs, tasks, completion status
- **Manager Value:** One-glance confidence about what's done, what's pending

#### 5. Accountability & Audit Trail
- **ChatGPT:** No tracking of who did what when, outputs are copy-paste
- **SingleBrief:** Every task output, decision, and change is tracked and auditable
- **Manager Value:** Can prove work was done, review decisions made, analyze patterns

#### 6. Business Value Framing
- **ChatGPT:** Generic advice, no organizational context
- **SingleBrief:** "Why This Matters" contextualized to specific brief and org culture
- **Manager Value:** Motivation tied to actual project, not generic inspiration

#### 7. Professional Deliverables
- **ChatGPT:** Copy-paste into docs, manual formatting
- **SingleBrief:** PDF exports, structured outputs, searchable history
- **Manager Value:** Present to leadership without reformatting

#### 8. Integrated Workflow
- **ChatGPT:** Tool-switching between chat and project management tool
- **SingleBrief:** One platform for planning, execution, tracking
- **Manager Value:** Context never lost, no duplicate data entry

### Summary Statement

> **ChatGPT helps you think about your project. SingleBrief helps you execute it with your team.**

- ChatGPT = thought partner for manager
- SingleBrief = execution platform for manager + team

---

## New Functional Requirements Based on Differentiation

### FR51: Audit Trail and Activity Logging

**FR51:** System shall maintain comprehensive audit trail of all brief modifications, task assignments, status changes, and output submissions with timestamps and user attribution.

**Rationale:** Core differentiator vs. ChatGPT - accountability and traceability are built-in, not manual

---

### FR52: Brief State Persistence

**FR52:** System shall persist all briefs, tasks, and associated data indefinitely (until explicitly deleted by user) with full history accessible across sessions.

**Rationale:** Unlike chat conversations that expire, briefs are permanent project records

---

### FR53: Team Member Task Inbox

**FR53:** Team members shall have dedicated task inbox showing all tasks assigned to them across all briefs, with ability to submit outputs directly within system.

**Rationale:** Team members interact with system directly, not receiving forwarded AI outputs from manager

---

## Competitive Positioning Requirements

### Non-Functional Requirement Update

**NFR23:** System shall provide competitive differentiation from ChatGPT through:
- Structured data persistence (vs. ephemeral chat)
- Multi-user collaboration (vs. solo interaction)
- Workflow automation (vs. manual prompting)
- Progress dashboards (vs. chat history)
- Audit trails (vs. no tracking)

**Rationale:** These are not just features - they're existential requirements for product viability

---

## Questions This Raises for Further Sections

1. **Pricing Strategy:** Can we charge when ChatGPT is "free"? (Answer: Yes, because we're solving workflow/collaboration, not just AI access)

2. **Go-to-Market:** How do we communicate this differentiation without sounding defensive? (Position as "ChatGPT for teams" or "Project execution OS")

3. **Technical Architecture:** Do we need integration WITH ChatGPT/Claude? (Maybe - allow managers to use their preferred LLM)

4. **User Onboarding:** First-time users will ask "Why not just use ChatGPT?" - need clear answer in onboarding flow

5. **Feature Roadmap:** Which differentiators do we double-down on vs. which become commoditized if OpenAI adds them?

---

*Perspective Shifting elicitation complete - moving to Section 3*
