# SingleBrief Brownfield Enhancement PRD - Section 2

## Requirements

### Functional Requirements

#### Brief Management (FR1-FR5)

**FR1:** Users shall be able to create a brief by entering free-form text describing the project or initiative they want to execute.

**FR2:** Users shall be able to edit and update brief content after creation without losing associated tasks or progress data.

**FR3:** Users shall be able to delete briefs, with system warning if brief contains incomplete tasks or team member assignments.

**FR4:** System shall preserve brief history and audit trail for deleted briefs (soft delete) for 30 days before permanent removal.

**FR5:** System shall support tagging briefs with custom labels for organization and categorization.

---

#### AI Task Breakdown (FR6-FR12)

**FR6:** System shall automatically generate micro-tasks from brief content using AI (LLM integration) within 30 seconds of brief submission.

**FR7:** AI-generated tasks shall include task title, description, and suggested assignee type (AI agent vs. human).

**FR8:** System shall generate "Why This Matters" section after task breakdown, including business value articulation and suggested impact metrics (optional feature).

**FR9:** Users shall be able to manually add new tasks to any brief with title, description, and assignment fields.

**FR10:** Users shall be able to edit AI-generated or manually-created tasks (title, description, assignment, status).

**FR11:** Users shall be able to delete tasks from a brief with confirmation prompt if task has outputs or is assigned.

**FR12:** System shall suggest task dependencies during AI breakdown (SHOULD-have feature, may defer to post-MVP).

---

#### "Why This Matters" Feature (FR13-FR16)

**FR13:** System shall generate "Why This Matters" section AFTER displaying task breakdown to manager (not before).

**FR14:** Manager shall be able to directly edit "Why This Matters" content via simple text field.

**FR15:** Manager shall be able to reject "Why This Matters" and request AI regeneration with feedback prompt.

**FR16:** Manager shall be able to skip "Why This Matters" section entirely (optional field with default hidden state).

---

#### Task Assignment (FR17-FR21)

**FR17:** Users shall be able to assign tasks to pre-built AI agents (Content Writer, Email Drafter) with manual trigger requirement.

**FR18:** Users shall be able to assign tasks to human team members from workspace team list.

**FR19:** Users shall be able to re-assign tasks to different team members or AI agents at any time.

**FR20:** System shall support single assignee per task (one AI agent OR one human, not multiple - simplified MVP model).

**FR21:** System shall send email notification to human team members when task is assigned to them, including brief context and task details.

---

#### Manager Review & Feedback (FR22-FR26)

**FR22:** Users shall be able to view task output/result submitted by AI agents or human team members.

**FR23:** Users shall be able to accept task as complete, updating task status to "Complete" and brief progress indicator.

**FR24:** Users shall be able to reject task output with feedback text, returning task to assignee with manager comments.

**FR25:** Users shall be able to re-run task (assign back to same or different assignee) while preserving previous attempt history.

**FR26:** System shall track task output version history (COULD-have feature, may defer to post-MVP).

---

#### Progress Tracking & Visibility (FR27-FR32)

**FR27:** System shall display brief-level progress indicator showing percentage complete (completed tasks / total tasks).

**FR28:** System shall provide project-level dashboard view showing all briefs within a project with status indicators.

**FR29:** System shall support task status labels: To Do, In Progress, Under Review, Complete.

**FR30:** System shall provide keyword search across brief titles, descriptions, and task content.

**FR31:** System shall support manual refresh button to update dashboard and brief views (no auto-refresh in MVP).

**FR32:** System shall provide activity feed/timeline showing recent brief and task updates (SHOULD-have, may defer).

---

#### Team Management (FR33-FR36)

**FR33:** Workspace owners shall be able to add team members by email invitation to their personal workspace.

**FR34:** Workspace owners shall be able to remove team members, with system reassigning or unassigning their active tasks.

**FR35:** System shall maintain team member profiles including name, email, and avatar.

**FR36:** System shall support basic team member roles/permissions (owner vs. member) (SHOULD-have, may simplify to single role in MVP).

---

#### AI Agents (FR37-FR38)

**FR37:** System shall provide 2 pre-built AI agents for MVP: Content Writing Agent and Email Draft Agent.

**FR38:** AI agents shall execute tasks only when manually triggered by manager (no automatic execution in MVP).

---

#### Outputs & Deliverables (FR39-FR42)

**FR39:** System shall store all task outputs (AI-generated and human-submitted) in Supabase storage with versioning.

**FR40:** Users shall be able to download individual task outputs as text files.

**FR41:** Users shall be able to export brief view (including tasks, status, outputs) to PDF format.

**FR42:** PDF export shall include "Why This Matters" section if present and not skipped by manager.

---

#### Authentication & Account (FR43-FR46)

**FR43:** System shall provide email/password signup and login via Supabase Auth.

**FR44:** System shall provide password reset functionality via email verification.

**FR45:** Users shall be able to update profile settings (name, email, avatar).

**FR46:** System shall provide personal workspace per user (1:1 user-to-workspace model for MVP, no multi-tenant switching).

---

#### Monetization (FR47-FR48)

**FR47:** System shall support invite-only access control (no public signup) during MVP launch.

**FR48:** System shall track user/workspace usage for manual invoicing (no automated billing in MVP).

---

#### Projects & Organization (FR49-FR50)

**FR49:** Users shall be able to create projects as containers for multiple briefs.

**FR50:** Users shall be able to search briefs by keyword (no status filtering in MVP).

---

### Non-Functional Requirements

#### Performance (NFR1-NFR5)

**NFR1:** AI task breakdown shall complete within 30 seconds for briefs up to 2000 words.

**NFR2:** "Why This Matters" generation shall complete within 5 seconds after task breakdown display.

**NFR3:** Dashboard page load shall complete within 2 seconds for workspaces with up to 100 briefs.

**NFR4:** Search results shall return within 1 second for keyword queries.

**NFR5:** PDF export shall generate within 10 seconds for briefs with up to 50 tasks.

---

#### Scalability (NFR6-NFR8)

**NFR6:** System shall support up to 50 concurrent users during MVP phase (invite-only).

**NFR7:** Database shall handle up to 1000 briefs and 10,000 tasks per workspace without performance degradation.

**NFR8:** Supabase storage shall accommodate up to 10GB of task outputs per workspace.

---

#### Reliability (NFR9-NFR11)

**NFR9:** System uptime shall be 99% during business hours (9am-6pm local time).

**NFR10:** AI API failures shall not crash application; system shall display error message and allow retry.

**NFR11:** Failed task assignments shall rollback cleanly without orphaning tasks or corrupting brief state.

---

#### Security (NFR12-NFR15)

**NFR12:** All API requests shall be authenticated via Supabase Auth JWT tokens.

**NFR13:** Row-Level Security (RLS) policies in Supabase shall enforce workspace data isolation (users cannot access other workspaces).

**NFR14:** Password reset tokens shall expire after 1 hour.

**NFR15:** Task outputs containing sensitive data shall be encrypted at rest in Supabase storage.

---

#### Usability (NFR16-NFR19)

**NFR16:** Brief creation form shall be accessible via single click from dashboard.

**NFR17:** Task status changes shall provide visual feedback within 500ms (optimistic UI updates).

**NFR18:** Error messages shall be user-friendly and actionable (no raw error codes exposed).

**NFR19:** "Why This Matters" adoption rate shall reach 80%+ (managers choose to use feature vs. skip).

---

#### Compatibility (NFR20-NFR22)

**NFR20:** Application shall function on latest versions of Chrome, Firefox, Safari, Edge browsers.

**NFR21:** UI shall be responsive and functional on tablet devices (iPad and above).

**NFR22:** System shall maintain compatibility with Supabase PostgreSQL 13.0.5 version.

---

### Compatibility Requirements

#### CR1: Database Schema Compatibility

All new database tables and columns must follow existing Supabase schema conventions. Row-Level Security (RLS) policies must be applied to all tables containing user data. Migration scripts must be reversible with down migrations.

#### CR2: UI/UX Consistency

New components must use existing shadcn/ui library and Tailwind CSS configuration. Design patterns must align with existing authentication and dashboard pages. Component prop interfaces must follow TypeScript strict typing conventions from tsconfig.json.

#### CR3: API Integration Compatibility

AI API integration (OpenAI/Anthropic) must use environment variables (`VITE_AI_API_KEY`) following existing `.env` pattern. API calls must handle rate limiting and implement exponential backoff retry logic. Error responses must conform to existing error handling patterns in Supabase client usage.

#### CR4: Build & Deployment Compatibility

New features must build successfully with existing Vite configuration without additional build tools. All TypeScript must compile with current tsconfig settings (noImplicitAny: false, strictNullChecks: false). Application must run on port 8080 with existing `npm run dev` command.

---

## Requirements Summary

**Total Functional Requirements:** 50
**Total Non-Functional Requirements:** 22
**Total Compatibility Requirements:** 4

**MUST-Have:** 40 requirements
**SHOULD-Have:** 5 requirements (FR12, FR26, FR32, FR36, NFR32)
**COULD-Have:** 2 requirements (FR26 version history)

---

*Section 2 of SingleBrief Brownfield Enhancement PRD*
