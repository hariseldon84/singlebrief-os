# SingleBrief - Complete Product Requirements Document

**Product Name:** SingleBrief - Brief-first Project OS
**Version:** 1.0
**Date:** 2025-10-04
**Status:** Ready for Implementation
**Document Type:** Consolidated Brownfield PRD (MVP)

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Business Context & Strategic Vision](#2-business-context--strategic-vision)
3. [Product Overview](#3-product-overview)
4. [Complete Requirements](#4-complete-requirements)
5. [Technical Architecture (No-Code MVP)](#5-technical-architecture-no-code-mvp)
6. [Implementation Plan](#6-implementation-plan)
7. [Success Metrics](#7-success-metrics)
8. [Appendices](#8-appendices)

---

## 1. Executive Summary

### 1.1 Product Vision

**SingleBrief transforms manager planning paralysis into action confidence** through AI-powered brief decomposition, intelligent task breakdown, and human-in-the-loop execution tracking.

Instead of creating 100 tasks manually, managers create a single Brief. The system breaks it into micro-tasks powered by AI, assigns them to AI agents or team members, and provides real-time visibility into progress—all within a confidence-building workflow.

### 1.2 Core Problem

**Planning Inertia & Paralysis** - Managers struggle with:
- **Overwhelming Scope**: Translating vision into concrete steps feels massive
- **Time Scarcity**: No time for detailed task breakdown
- **Fear of Incompleteness**: "What am I missing?" anxiety
- **Knowledge Gaps**: Uncertainty in unfamiliar domains

### 1.3 Solution: Confidence Through Visibility

SingleBrief delivers **confidence to act** through:
1. **Visibility into Progress** (PRIMARY) - Real-time view of what's happening
2. **AI-Powered Breakdown** - Intelligent task decomposition
3. **Manager Control** - Accept/reject/re-run review loop
4. **Delegation** - Assign to AI agents or humans
5. **Progress Tracking** - Brief + project level roll-up
6. **Professional Deliverables** - PDF exports, task outputs

### 1.4 Key Metrics

**MVP Success Criteria (5-Week Timeline):**
- ✅ Managers create brief → get tasks within 1 minute
- ✅ AI task acceptance rate >70%
- ✅ Review loop feels natural (accept/reject/re-run)
- ✅ Manager confidence increases post-use
- ✅ 80%+ of briefs generate satisfactory tasks on first try

**Scope:**
- **111 Functional Requirements** across 8 epics
- **42 User Stories** (212 story points)
- **5-Week Implementation** (4 weeks core + 1 week "Why This Matters")
- **No-Code Architecture** (n8n + Supabase + AI-generated frontend)

### 1.5 Competitive Differentiation vs. ChatGPT

**Why SingleBrief vs. ChatGPT + MCPs + Agents?**

1. **Persistent State Management** - Not ephemeral chat; structured project tracking
2. **Team Collaboration** - Multi-user workflows, not solo conversations
3. **Manager Review Loop** - Structured accept/reject workflow, not just outputs
4. **Progress Visibility** - Real-time dashboard, not lost in chat history
5. **Accountability & Audit Trail** - Version history, task logs, team assignments
6. **Business Value Framing** - "Why This Matters" explains impact, not just tasks
7. **Professional Deliverables** - PDF exports, structured outputs, not screenshots
8. **Integrated Workflow** - Brief → Tasks → Execution → Review in one system

**In short:** ChatGPT helps you think. SingleBrief helps you execute with your team.

---

## 2. Business Context & Strategic Vision

### 2.1 First Principles Analysis

**Core Insight:** Confidence is the actual product, not task management.

**Fundamental Problem:** Planning paralysis stems from:
- Gap between vision and execution
- Fear of missing critical steps
- Lack of domain expertise
- Time constraints preventing thorough planning

**Root Solution:** Deliver confidence through:
- Intelligent automation (AI breakdown)
- Visibility (real-time tracking)
- Control (manager review loop)
- Delegation (AI + human execution)

### 2.2 Minimum Viable Confidence Loop (6 Steps)

1. **Manager creates brief** (text input)
2. **AI breaks into micro-tasks** (automated)
3. **Assign to AI agents or humans** (delegation)
4. **Execute + Review cycle** (accept/reject/re-run)
5. **Progress tracked** (brief + project level)
6. **Manager dashboard** (all briefs + outputs)

### 2.3 MVP Prioritization (MoSCoW Analysis)

**From 57 features analyzed:**
- ✅ **MUST Have:** 35 features (61%) - Core confidence loop
- 🟡 **SHOULD Have:** 5 features (9%) - Quality enhancements
- 💡 **COULD Have:** 4 features (7%) - Nice-to-have polish
- ❌ **WON'T Have:** 13 features (23%) - Deferred to v2+

### 2.4 Resource Constraints (4→5 Week Timeline)

**8 Major Cuts/Simplifications:**
1. **AI Agents:** 4 → 2 (Content Writer, Email Drafter only)
2. **Real-Time Updates:** WebSockets → 30-second polling
3. **Billing:** Stripe → Manual invoicing (invite-only)
4. **Multi-Assignee:** Collaboration → Single assignee + duplicate workaround
5. **Multi-Workspace:** Organizations → Personal workspace per user
6. **Tags/Labels:** Tag system → Search-only organization
7. **Summary Doc:** Auto-generation → PDF export of brief view
8. **Filters:** Status filtering → Search covers 80% of use cases

**Time Saved:** 24-37 development days → Makes 5-week timeline realistic

### 2.5 Strategic Themes

**Theme 1: Confidence Through Visibility**
- Real-time progress tracking, transparency, dashboard views

**Theme 2: Manager Control Over AI**
- Full CRUD on tasks, accept/reject loop, trust through oversight

**Theme 3: Text-First AI Agents**
- Content + Email agents (avoid multimedia complexity)

**Theme 4: Simplicity Enables Speed**
- Flat team structure, pre-built agents, minimal decision paralysis

**Theme 5: Manual Processes Valid for MVP**
- Invite-only + manual invoicing enables customer relationships

---

## 3. Product Overview

### 3.1 Target Users

**Primary User: Managers/Leaders**
- Creates briefs for projects, initiatives, campaigns
- Reviews AI-generated task breakdowns
- Assigns work to team members or AI agents
- Accepts/rejects outputs, provides feedback
- Tracks progress across multiple briefs

**Secondary User: Team Members**
- Receives task assignments from managers
- Executes tasks, submits outputs
- Sees task context ("Why This Matters")
- Collaborates via task comments
- Tracks own workload in "My Tasks" inbox

**Tertiary User: AI Agents**
- 2 pre-built agents (Content Writer, Email Drafter)
- Assigned to tasks like team members
- Auto-execute when queued (manual batch trigger)
- Outputs reviewed by manager (same workflow as human outputs)

### 3.2 User Journeys

#### Journey 1: Manager Creates First Brief (Happy Path)
1. Login → Dashboard (empty state with "Create Brief" CTA)
2. Click "Create Brief" → Dialog opens
3. Enter title: "Q1 2025 Marketing Campaign"
4. Enter description (500 words) → Character count shown
5. Click "Generate Tasks" → AI breakdown in 30 seconds
6. Review 15 AI-generated tasks (progressive disclosure: 5 at a time)
7. Uncheck 2 tasks, click "Show More", review next 5
8. Click "Confirm Tasks" → Brief status: Active, 13 tasks confirmed
9. Click "Generate Why This Matters" → AI explains business value
10. Read "Why This Matters" (collapsible section)
11. Assign 3 tasks to Content Writer AI, 10 tasks to team members
12. Dashboard now shows 1 active brief (0% complete)

#### Journey 2: Team Member Executes Task
1. Receives email: "You've been assigned to task: Write blog post outline"
2. Clicks link → Task detail view opens
3. Reads task description + "Why This Matters" context
4. Changes status: To-Do → In-Progress
5. Sets due date: 7 days from now
6. Updates progress: 50% (optional, if enabled for brief)
7. Completes work, changes status: In-Progress → Done
8. Enters output URL: `https://docs.google.com/document/d/xyz`
9. Submits → Manager notified for review

#### Journey 3: Manager Reviews Output
1. Receives email: "Task 'Write blog post outline' completed"
2. Clicks link → Review modal opens
3. Reads task output (embedded iframe if URL supports)
4. **Decision Point:**
   - **Accept:** Task status → Accepted, brief progress +7%
   - **Reject:** Enter feedback ("Add competitive analysis section"), task status → Rejected, team member notified
   - **Re-run:** Task resets to To-Do with manager notes
5. Team member sees rejection feedback, revises work
6. Resubmits → Version 2 stored, manager reviews again
7. Accepts v2 → Task complete, rework cycle: 1

#### Journey 4: AI Agent Batch Execution
1. Manager assigns 3 tasks to AI Writer agent → Status: Queued
2. Floating Action Button (FAB) appears: "Execute 3 AI Tasks"
3. Clicks FAB → Confirmation modal: "~$0.15 estimated cost"
4. Confirms → n8n workflow triggered
5. Progress indicator: "Executing 1/3..." (5-second delay between tasks)
6. All 3 tasks complete in 2 minutes → Email sent: "3 AI tasks completed"
7. Manager reviews each AI output (same accept/reject flow)
8. Accepts 2, rejects 1 with feedback ("Make tone more casual")
9. Re-queues rejected task → FAB shows "Execute 1 AI Task"

### 3.3 Core Features Summary

**Brief Management:**
- Create, edit, delete briefs
- AI task breakdown (configurable limit: 5-50 tasks, default 20)
- Brief templates (5 pre-built: Marketing, Product Launch, Event, Hiring, Custom)
- "Why This Matters" AI generation (after task breakdown)
- Draft saving, title auto-generation

**Task Management:**
- Task assignment (AI agents, team members)
- Status tracking (To-Do, Queued, In-Progress, Done, Rejected, Accepted, Archived)
- Priority system (High, Medium, Low with color-coded badges)
- Due date assignment, progress tracking (optional per brief)
- Task comments with @mentions
- Quick-add tasks (title only, expand later)
- Bulk actions (assign, priority change, archive, delete)

**AI Execution:**
- 2 pre-built agents: Content Writer, Email Drafter
- Queuing system (no auto-execution)
- Batch execution via FAB (manual trigger)
- Cost preview before execution
- Full context window (brief + "Why This Matters" + previous outputs)
- Error handling with retry (max 3 attempts)

**Review Workflow:**
- Accept/reject task outputs
- Rejection feedback (constructive, required)
- Rework cycle tracking (warning after 3 cycles)
- Version history (compare v1 vs v2)
- AI output attribution badges

**Collaboration:**
- Task comments thread (async collaboration)
- Notifications (assignments, outputs, rejections, @mentions)
- Presence indicators ("Sarah is viewing this task")
- Activity feed (recent team actions)
- Notification preferences (per-brief mute, DND hours)

**Search & Organization:**
- PostgreSQL full-text search (briefs + tasks)
- Search scope controls (status, date range, assignee filters)
- Archived brief filtering (show/hide toggle)

**Deliverables:**
- Task output storage (URLs, files)
- PDF export (brief view)
- File upload (10MB limit, optional per task)

---

## 4. Complete Requirements

### 4.1 Functional Requirements (FR1-FR111)

#### Epic 1: Brief Creation and AI Task Generation (FR1-FR20, FR68-FR70, FR82-FR84, FR95)

**FR1:** System shall provide "New Brief" button in dashboard
**FR2:** Brief creation dialog shall have title (required, max 200 chars) and description (required, max 5000 chars)
**FR3:** System shall show character count below description textarea
**FR4:** System shall warn user at 3000 chars with color change
**FR5:** System shall disable "Generate Tasks" button until title and description filled
**FR6:** System shall call n8n workflow to generate tasks via OpenRouter API
**FR7:** AI-generated tasks shall have: title, description, status='To-Do', priority='Medium'
**FR8:** System shall generate "Why This Matters" business value explanation after task breakdown
**FR9:** System shall display AI-generated tasks in progressive disclosure (5 at a time)
**FR10:** System shall allow manager to edit task title and description inline
**FR11:** System shall allow manager to delete tasks before confirmation
**FR12:** System shall allow manager to add manual tasks during review
**FR13:** System shall provide "Show More" button to reveal next 5 tasks
**FR14:** System shall allow task selection via checkboxes (default: checked)
**FR15:** "Confirm Tasks" shall finalize selected tasks and update brief status to 'active'
**FR16:** System shall delete unchecked tasks on confirmation
**FR17:** System shall show final task count after confirmation
**FR18:** System shall update brief status: draft → active after task confirmation
**FR19:** System shall save draft briefs without task generation
**FR20:** Draft briefs shall be editable and resumable

**FR68:** System shall allow configurable task limit (5-50, default 20) in settings
**FR69:** Task confirmation shall use progressive disclosure (5 tasks at a time)
**FR70:** System shall allow task regeneration (max 3 attempts per brief)
**FR82:** System shall auto-generate brief title from description (first sentence, 100 chars)
**FR83:** System shall allow saving brief as draft before task generation
**FR84:** Task confirmation shall show checkboxes for selection
**FR95:** System shall provide 5 brief templates (Marketing, Product Launch, Event, Hiring, Custom)

#### Epic 2: Task Management and Assignment (FR21-FR38, FR54-FR61, FR79-FR81, FR94, FR99-FR100)

**FR21:** Task detail view shall have "Assign" dropdown
**FR22:** Dropdown shall show: "Unassigned", team members, AI agents
**FR23:** Selecting assignee shall update task and trigger notification
**FR24:** AI agents shall appear in assignment dropdown with robot icon
**FR25:** Task detail shall have status dropdown
**FR26:** Status options: To-Do, Queued, In-Progress, Done, Rejected, Accepted, Archived
**FR27:** Changing status shall update `updated_at` timestamp
**FR28:** Status changes shall be logged in task_history table
**FR29:** System shall track task status transitions
**FR30:** Task card shall show: title, assignee avatar, due date, priority, status, progress %
**FR31:** Task list shall be sortable by: due date, priority, status, assignee
**FR32:** Clicking task card shall open task detail view
**FR33:** System shall send email notification when task assigned to human
**FR34:** Task reassignment shall notify new assignee
**FR35:** Task detail shall show last activity timestamp
**FR36:** System shall support task duplication (workaround for multi-assignee)
**FR37:** Bulk task actions shall support: assign, priority change, archive, delete
**FR38:** Task deletion shall require confirmation (soft delete for 30 days)

**FR54:** "My Tasks" page shall show tasks assigned to current user
**FR55:** Team member shall set due date when changing status to "In-Progress"
**FR56:** Task detail shall show progress slider (0-100%) if enabled for brief
**FR57:** Task detail shall have "Output URL" field when status='Done'
**FR58:** Deleted - Access control removed from MVP (everyone sees everything)
**FR59:** Rejected tasks shall show rejection feedback to assignee
**FR60:** Task history shall log: status changes, assignments, output submissions
**FR61:** Cross-team members shall see outputs of tasks in same brief

**FR79:** Tasks shall have priority field (High, Medium, Low)
**FR80:** Priority badges: High=red, Medium=yellow, Low=gray
**FR81:** Task list shall sort by priority (High → Medium → Low)
**FR94:** Brief detail shall have quick-add task input (title only, press Enter to create)
**FR99:** First-time users shall see welcome modal with 3-step guide
**FR100:** Onboarding modal shall be dismissible and never shown again

#### Epic 3: AI Agent Task Execution (FR62-FR67, FR75-FR77, FR87)

**FR62:** System shall have 2 AI agent accounts: AI Writer, AI Researcher
**FR63:** AI agents shall receive full context: brief title, description, "Why This Matters", task, previous outputs
**FR64:** AI agents shall access previous output versions for learning
**FR65:** System shall show "Generating..." indicator when AI executing
**FR66:** Team members shall have "Generate with AI" button for AI-assisted output
**FR67:** System shall handle AI errors with retry logic (max 3 attempts)

**FR75:** Tasks assigned to AI agents shall change status to 'Queued' (not auto-execute)
**FR76:** Floating Action Button (FAB) shall appear when >0 queued tasks
**FR77:** FAB click shall show cost preview modal before batch execution
**FR87:** AI regeneration shall have max 3 attempts per task

#### Epic 4: Manager Review and Output Management (FR39-FR53, FR88, FR90, FR101-FR102)

**FR39:** Brief detail shall have "Review" tab showing tasks with status='Done'
**FR40:** Review modal shall have "Accept" button → changes status to 'Accepted'
**FR41:** Review modal shall have "Reject" button → shows feedback textarea (required)
**FR42:** Brief shall have "Mark Complete" button when all tasks accepted
**FR43:** Brief shall have "Archive" button to hide from default view
**FR44:** Task outputs shall be stored in Supabase Storage (if file upload)
**FR45:** Task outputs shall be downloadable
**FR46:** Brief shall be exportable to PDF (brief view)
**FR47:** PDF export shall include: brief title, description, "Why This Matters", tasks, outputs
**FR48:** Deleted - Multi-assignee removed from MVP
**FR49:** Task output URL shall be validated (starts with http:// or https://)
**FR50:** Task rejection shall notify assignee via email
**FR51:** Rejection feedback shall be visible to assignee in task detail
**FR52:** Accepted tasks shall contribute to brief completion percentage
**FR53:** Brief completion shall calculate: (accepted tasks / total tasks) * 100

**FR88:** Task outputs shall have version history (v1, v2, v3)
**FR90:** AI-generated task outputs shall have "AI Generated" badge
**FR101:** Manager shall see all task outputs in brief detail
**FR102:** Task outputs shall be filterable by status (All, Accepted, Rejected, Pending)

#### Epic 5: Communication and Collaboration (FR93, FR103-FR107, Presence Indicators)

**FR93:** Tasks shall support threaded comments for async collaboration
**FR103:** System shall have notification bell icon with unread count badge
**FR104:** Critical notifications shall send email (assigned, rejected, @mention)
**FR105:** Users shall have notification preferences (email ON/OFF, per-brief mute, DND hours)
**FR106:** Dashboard shall have "Activity" feed showing recent team actions
**FR107:** Notifications shall show: icon, text, timestamp, link to task/brief

**Presence Indicators (Decision Q8-A):**
- Task detail shall show avatars of users currently viewing
- Presence updated every 30 seconds (polling)
- "Sarah is viewing this task" text shown below avatars

#### Epic 6: Search, Navigation, and Bulk Actions (FR91-FR92, FR108, FR110-FR111)

**FR91:** Search shall support scope controls (status, date range, assignee filters)
**FR92:** "Show Archived" toggle shall reveal archived briefs
**FR108:** Global search bar shall search across brief titles, descriptions, task titles
**FR110:** Bulk actions bar shall appear when >0 tasks selected
**FR111:** Bulk actions: Assign, Change Priority, Archive, Delete (with confirmation)

#### Epic 7: "Why This Matters" and Business Value Framing (FR8, FR70, FR87)

**FR8:** System shall generate "Why This Matters" via n8n workflow + OpenRouter
- AI prompt: "Explain why this brief matters in 2-3 sentences focusing on business impact and team motivation"
- Shown AFTER task breakdown (not before)
- Collapsible section (default: collapsed)
- Editable by manager
- Regenerable (max 3 attempts)
- Visible to team members in task detail

#### Epic 8: Authentication and Security (NEW - Added per user request)

**FR112:** System shall use Supabase Auth for email + password authentication
**FR113:** System shall support magic link (passwordless) login
**FR114:** System shall provide password reset flow via email
**FR115:** System shall send email verification on signup
**FR116:** System shall use JWT tokens for session management
**FR117:** Access tokens shall expire after 1 hour
**FR118:** Refresh tokens shall expire after 30 days
**FR119:** System shall auto-refresh tokens via Supabase client
**FR120:** User profile shall have: name, email, avatar, settings
**FR121:** Team member invitations shall use Supabase Auth magic links
**FR122:** Invite links shall expire after 24 hours
**FR123:** Invite links shall be one-time use only
**FR124:** Email verification required before account access
**FR125:** Row-Level Security (RLS) policies shall enforce data access
**FR126:** Users shall only see briefs they created OR briefs with tasks assigned to them
**FR127:** Users shall only see tasks assigned to them OR tasks in briefs they created
**FR128:** User sessions shall be managed by Supabase (no custom session handling)

### 4.2 Non-Functional Requirements (NFR1-NFR30)

**Performance:**
- NFR1: Initial page load <3s on 3G
- NFR2: Dashboard load <2s (cached <500ms)
- NFR3: Task list query <50ms
- NFR4: Search query <200ms
- NFR5: AI task generation <60s for 20 tasks
- NFR6: Polling interval: 30 seconds

**Scalability:**
- NFR7: Support 100 users in MVP phase
- NFR8: Support 10K briefs without performance degradation
- NFR9: Support 100K tasks across all briefs
- NFR10: Database indexes on all frequent query columns

**Security:**
- NFR11: HTTPS only (no HTTP)
- NFR12: All API keys stored in Supabase secrets (never in frontend)
- NFR13: RLS policies on all user-facing tables
- NFR14: File uploads scanned for malware (Supabase Storage)
- NFR15: JWT token validation on all API calls

**Reliability:**
- NFR16: 99.9% uptime (Supabase + Vercel SLA)
- NFR17: Error rate <0.1% for critical operations
- NFR18: All errors logged to Sentry
- NFR19: Automated backup (Supabase daily backups)

**Usability:**
- NFR20: Mobile-responsive (320px min width)
- NFR21: WCAG 2.1 AA accessibility compliance
- NFR22: Keyboard navigation support
- NFR23: Screen reader compatible

**Maintainability:**
- NFR24: No backend coding (n8n visual workflows only)
- NFR25: Frontend AI-generated (v0.dev + Claude Code)
- NFR26: All workflows documented in n8n UI
- NFR27: Database schema versioned via Supabase migrations

**Cost:**
- NFR28: MVP cost: $10-15/month (n8n hosting + AI usage)
- NFR29: Scale cost: $90-145/month at 500-1K users
- NFR30: AI cost per brief: ~$0.0015 (GPT-4o-mini)

---

## 5. Technical Architecture (No-Code MVP)

### 5.1 Technology Stack

**Frontend (AI-Generated):**
- React 18.3.1 + TypeScript 5.6.2
- Vite 5.4.2 (build tool)
- shadcn/ui (component library)
- Tailwind CSS 3.4.1 (styling)
- TanStack Query v5 (data fetching/caching)
- React Router v6 (routing)
- **Code Generation:** v0.dev (Figma → React) + Claude Code (Supabase integration) + GitHub Copilot

**Backend (100% No-Code):**
- **n8n (self-hosted):** All backend workflows, AI calls, email triggers
- **Supabase:** PostgreSQL database, Auth, Storage, Realtime (future)
- **OpenRouter:** Unified LLM API (GPT-4o-mini primary)

**Hosting:**
- **Frontend:** Vercel (free tier, auto-deploy from GitHub)
- **n8n:** Railway ($5/month) or self-hosted VPS
- **Database:** Supabase (free tier → Pro $25/month at scale)

### 5.2 Database Schema (Supabase PostgreSQL)

**Core Tables:**

```sql
-- Users (Supabase Auth managed)
CREATE TABLE auth.users (
  id uuid PRIMARY KEY,
  email text UNIQUE NOT NULL,
  encrypted_password text,
  email_confirmed_at timestamptz,
  is_ai_agent boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

-- User Settings
CREATE TABLE user_settings (
  user_id uuid PRIMARY KEY REFERENCES auth.users(id),
  default_task_limit int DEFAULT 20 CHECK (default_task_limit BETWEEN 5 AND 50),
  email_notifications_enabled boolean DEFAULT true,
  dnd_start_hour int DEFAULT 21,
  dnd_end_hour int DEFAULT 9,
  onboarding_completed boolean DEFAULT false,
  updated_at timestamptz DEFAULT now()
);

-- Briefs
CREATE TABLE briefs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users(id),
  title text NOT NULL CHECK (length(title) <= 200),
  description text NOT NULL CHECK (length(description) <= 5000),
  why_matters text,
  why_matters_regen_count int DEFAULT 0,
  status text DEFAULT 'draft' CHECK (status IN ('draft', 'active', 'completed', 'archived')),
  task_count int DEFAULT 0,
  progress_tracking_enabled boolean DEFAULT false,
  regeneration_count int DEFAULT 0,
  search_vector tsvector,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Tasks
CREATE TABLE tasks (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  brief_id uuid REFERENCES briefs(id) ON DELETE CASCADE,
  title text NOT NULL,
  description text,
  assigned_to uuid REFERENCES auth.users(id),
  status text DEFAULT 'To-Do' CHECK (status IN ('To-Do', 'Queued', 'In-Progress', 'Done', 'Rejected', 'Accepted', 'Archived')),
  priority text DEFAULT 'Medium' CHECK (priority IN ('High', 'Medium', 'Low')),
  due_date timestamptz,
  progress_percent int DEFAULT 0 CHECK (progress_percent BETWEEN 0 AND 100),
  output_url text,
  rejection_feedback text,
  rework_cycle int DEFAULT 0,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Task History
CREATE TABLE task_history (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  task_id uuid REFERENCES tasks(id) ON DELETE CASCADE,
  user_id uuid REFERENCES auth.users(id),
  action text NOT NULL,
  old_value text,
  new_value text,
  created_at timestamptz DEFAULT now()
);

-- Task Output Versions
CREATE TABLE task_output_versions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  task_id uuid REFERENCES tasks(id) ON DELETE CASCADE,
  version_number int NOT NULL,
  output_url text NOT NULL,
  submitted_by uuid REFERENCES auth.users(id),
  status text CHECK (status IN ('Accepted', 'Rejected', 'Pending')),
  created_at timestamptz DEFAULT now()
);

-- Task Comments
CREATE TABLE task_comments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  task_id uuid REFERENCES tasks(id) ON DELETE CASCADE,
  user_id uuid REFERENCES auth.users(id),
  comment text NOT NULL,
  mentioned_users uuid[],
  created_at timestamptz DEFAULT now()
);

-- Notifications
CREATE TABLE notifications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users(id),
  type text NOT NULL,
  title text NOT NULL,
  message text,
  link_url text,
  is_read boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

-- Task Presence
CREATE TABLE task_presence (
  user_id uuid REFERENCES auth.users(id),
  task_id uuid REFERENCES tasks(id),
  last_seen timestamptz DEFAULT now(),
  PRIMARY KEY (user_id, task_id)
);

-- User Brief Mutes
CREATE TABLE user_brief_mutes (
  user_id uuid REFERENCES auth.users(id),
  brief_id uuid REFERENCES briefs(id),
  PRIMARY KEY (user_id, brief_id)
);
```

### 5.3 n8n Workflows (No-Code Backend)

**Workflow 1: Brief Task Breakdown**
- Trigger: Webhook POST `/webhook/generate-tasks`
- Input: `{ brief_id, user_id, jwt_token }`
- Steps:
  1. Webhook node receives POST
  2. Function node validates JWT
  3. Supabase node fetches brief + user settings (task_limit)
  4. HTTP Request node calls OpenRouter API (GPT-4o-mini)
  5. Function node parses AI response (JSON array of tasks)
  6. Supabase node batch inserts tasks
  7. HTTP Response node returns success

**Workflow 2: "Why This Matters" Generation**
- Trigger: Webhook POST `/webhook/generate-why-matters`
- Input: `{ brief_id, tasks[], jwt_token }`
- Steps:
  1. Webhook receives POST
  2. HTTP Request calls OpenRouter with brief + tasks
  3. Supabase updates brief.why_matters
  4. HTTP Response returns generated text

**Workflow 3: AI Task Execution**
- Trigger: Webhook POST `/webhook/execute-ai-task`
- Input: `{ task_id, jwt_token }`
- Steps:
  1. Supabase fetches task + brief + "Why This Matters"
  2. HTTP Request calls OpenRouter with full context
  3. Supabase updates task output_url, status='Done'
  4. Email notification sent to manager

**Workflow 4: AI Batch Queue Processor**
- Trigger: Cron (every 5 minutes)
- Steps:
  1. Supabase queries tasks where status='Queued'
  2. Loop node processes each (5-second delay between)
  3. Call Workflow 3 for each task
  4. Email summary when batch complete

**Workflow 5: Email Notifications**
- Trigger: Webhook POST `/webhook/send-notification`
- Input: `{ user_id, notification_type, data }`
- Steps:
  1. Supabase fetches user email + settings
  2. Check DND hours, email_notifications_enabled
  3. Send email via Supabase SMTP (or Resend if >50/hour)

**Workflow 6: Task Due Reminders**
- Trigger: Cron (daily at 9am)
- Steps:
  1. Supabase queries tasks due in 24 hours
  2. Loop through tasks
  3. Call Workflow 5 for each reminder

### 5.4 Authentication Implementation (Supabase Auth)

**Setup:**
- Email + password authentication (primary)
- Magic link passwordless login (secondary)
- JWT token management (auto-refresh via Supabase client)
- Email verification required before access

**Team Member Invitations (n8n workflow):**
1. Manager enters email in UI
2. Frontend calls n8n webhook `/webhook/invite-team-member`
3. n8n creates invite record in database
4. n8n calls Supabase Auth API to send magic link
5. Team member clicks link → auto-signup → redirected to dashboard

**RLS Policies:**
```sql
-- Users can only see their own briefs OR briefs with tasks assigned to them
CREATE POLICY "Users can view accessible briefs"
ON briefs FOR SELECT TO authenticated
USING (
  auth.uid() = user_id OR
  id IN (SELECT brief_id FROM tasks WHERE assigned_to = auth.uid())
);

-- Users can only see tasks assigned to them OR tasks in briefs they created
CREATE POLICY "Users can view accessible tasks"
ON tasks FOR SELECT TO authenticated
USING (
  assigned_to = auth.uid() OR
  brief_id IN (SELECT id FROM briefs WHERE user_id = auth.uid())
);
```

### 5.5 AI Integration (OpenRouter)

**Primary Model:** `openai/gpt-4o-mini` ($0.15/1M input, $0.60/1M output)

**Fallback Models:**
1. `anthropic/claude-3-haiku` ($0.25/1M input, $1.25/1M output)
2. `google/gemini-flash` (free tier available)

**Cost Estimates:**
- Brief task breakdown: ~$0.0009 per brief
- "Why This Matters": ~$0.0006 per brief
- AI task execution: ~$0.0012 per task
- **Total monthly (100 users, 10 briefs each):** ~$4-5

### 5.6 No-Code Development Workflow

**1. Frontend Component Creation:**
- Design in Figma → Screenshot
- Paste into v0.dev with prompt: "Create React component with shadcn/ui and Tailwind CSS"
- Copy generated code into project
- Use Claude Code to add Supabase integration
- GitHub Copilot for autocomplete

**2. Backend Workflow Creation (n8n):**
- Open n8n visual editor
- Drag-and-drop nodes (Webhook, Supabase, HTTP Request, Function)
- Configure nodes via visual forms (no coding)
- Test workflow with "Execute Workflow" button
- Activate workflow → Get webhook URL

**3. Database Schema Changes:**
- Prompt Claude Code: "Generate Supabase migration SQL to add X"
- Copy-paste SQL into Supabase SQL Editor
- Click "Run"
- Run `supabase gen types` to regenerate TypeScript types

**Total Implementation:** ~30 min/component + ~20 min/workflow + ~10 min/schema change

---

## 6. Implementation Plan

### 6.1 Epic-Based Timeline (5 Weeks, 212 Story Points)

**Week 1: Brief Creation and AI Task Generation (Epic 1)**
- 8 stories, 41 story points
- Deliverables: Brief creation form, AI task breakdown, progressive confirmation, templates, settings

**Week 2: Task Management + AI Agents (Epic 2 + Epic 3 + Epic 8)**
- 16 stories, 75 story points
- Deliverables: Task assignment, status tracking, team member inbox, AI queuing, authentication

**Week 3: Review Workflow + Collaboration (Epic 4 + Epic 5)**
- 11 stories, 62 story points
- Deliverables: Accept/Reject, version history, task comments, notifications, presence

**Week 4: Search and Navigation (Epic 6)**
- 4 stories, 20 story points
- Deliverables: PostgreSQL search, filters, bulk actions, navigation

**Week 5: "Why This Matters" Feature (Epic 7)**
- 4 stories, 18 story points
- Deliverables: AI generation, collapsible UI, edit/regenerate, team visibility

### 6.2 Epic 8: Authentication and Security (NEW)

**Epic Goal:** Implement Supabase Auth for secure user authentication, team invitations, and session management.

**Timeline:** Week 2 (concurrent with Task Management)
**Priority:** P0 (Must Have - Security Foundation)
**Story Points:** 8 points

#### Story 8.1: Supabase Auth Setup

**As a** user
**I want to** sign up and log in securely
**So that** my data is protected and I have my own workspace

**Acceptance Criteria:**
- [ ] Email + password signup form with validation
- [ ] Email verification sent on signup (Supabase Auth)
- [ ] Login form with email/password
- [ ] Password reset flow (forgot password link)
- [ ] Magic link login option (passwordless)
- [ ] JWT tokens auto-managed by Supabase client
- [ ] Session persists across browser refresh

**Technical Implementation (No-Code):**
- **Frontend (v0.dev + Claude Code):**
  - Prompt: "Create auth pages (signup, login, reset password) with shadcn/ui forms"
  - Claude Code adds Supabase auth integration
- **Supabase Dashboard:**
  - Enable email auth
  - Configure SMTP for emails (Supabase Auth SMTP free tier)

**FRs Covered:** FR112-FR120

**Story Points:** 5
**Dependencies:** None

#### Story 8.2: Team Member Invitation via Magic Links

**As a** manager
**I want to** invite team members via email
**So that** they can access briefs and tasks I assign to them

**Acceptance Criteria:**
- [ ] "Invite Team Member" button in settings/team page
- [ ] Email input field with validation
- [ ] n8n workflow sends magic link via Supabase Auth
- [ ] Invite link expires after 24 hours
- [ ] One-time use only (consumed on click)
- [ ] New user redirected to signup with pre-filled email
- [ ] Invited user added to manager's accessible team members

**Technical Implementation (No-Code):**
- **n8n Workflow:**
  1. Webhook: POST `/webhook/invite-team-member`
  2. Supabase: Insert invite record
  3. HTTP Request: Call Supabase Auth API for magic link
  4. Email: Send invitation email
- **Frontend (Claude Code):**
  - Prompt: "Add invite team member form with email input"

**FRs Covered:** FR121-FR124

**Story Points:** 3
**Dependencies:** Story 8.1

### 6.3 Critical Path

Epic 1 → Epic 2 (incl. Epic 8) → Epic 4 → Epic 7

**Parallel Tracks:**
- Epic 3 (AI Agents) runs concurrent with Epic 2 (Week 2)
- Epic 5 (Collaboration) runs concurrent with Epic 4 (Week 3)
- Epic 6 (Search) runs in Week 4

### 6.4 Risk Mitigation in Stories

**Risk 1.1: AI Task Quality (High)**
- Story 1.5: Max 3 regeneration attempts
- Story 1.3: Progressive confirmation allows editing
- Story 3.4: Full context window management

**Risk 1.2: Progress Update Friction (High)**
- Story 2.5: Optional progress tracking per brief
- Story 5.5: Activity feed shows updates

**Risk 3.2: Rejection Demotivation (High)**
- Story 4.2: Constructive feedback required
- Story 5.1: Task comments for clarification
- Story 7.1-7.4: "Why This Matters" for motivation

**Risk 5.1: Concurrent Edit Conflicts (Medium)**
- Story 5.4: Presence indicators
- Polling with `updated_at` timestamps

---

## 7. Success Metrics

### 7.1 MVP Success Criteria (Week 5 Launch)

**Product Validation:**
- ✅ 80%+ of briefs generate satisfactory tasks on first try
- ✅ AI task acceptance rate >70%
- ✅ Review loop completion rate >90%
- ✅ <2 rework cycles average per task

**User Engagement:**
- ✅ 90%+ of invited users complete onboarding
- ✅ 50%+ of tasks have ≥1 comment
- ✅ Search used 3+ times per user per week
- ✅ 70%+ of team members read "Why This Matters"

**Technical Performance:**
- ✅ AI task generation <60 seconds (95th percentile)
- ✅ <10% AI task failure rate
- ✅ Dashboard load <2 seconds
- ✅ 99.9% uptime

### 7.2 Post-MVP Metrics (Weeks 6-12)

**Retention:**
- Week 4 retention: >60%
- Week 8 retention: >40%

**Monetization:**
- Manual invoicing conversion: >80%
- Average revenue per user: $50-100/month

**Product Evolution:**
- Feature request volume (prioritize v2 roadmap)
- NPS score: >40

---

## 8. Appendices

### 8.1 Glossary

**Brief:** Manager-created project description (text input, 500-5000 chars)
**Task:** Micro-task generated by AI or created manually
**AI Agent:** Pre-built automated worker (Content Writer, Email Drafter)
**Review Loop:** Manager workflow to accept/reject/re-run task outputs
**"Why This Matters":** AI-generated business value explanation
**Queued:** Task status when assigned to AI agent (manual trigger required)
**Rework Cycle:** Count of times task rejected and revised
**Progressive Disclosure:** UI pattern showing 5 items at a time (reduce overwhelm)
**RLS:** Row-Level Security (Supabase access control)
**n8n:** Visual workflow automation tool (no-code backend)
**OpenRouter:** Unified LLM API gateway (multi-model support)

### 8.2 User Decisions from PRD Development

**12 Critical Decisions (From Section 3 Elicitation):**

1. **Progress Tracking:** Optional per brief (not mandatory)
2. **AI Queue Reminders:** Aggressive (FAB + 24h email)
3. **Task Confirmation:** Progressive disclosure (5 at a time)
4. **File Upload:** Always optional (not required for task completion)
5. **Task Comments:** Include in MVP (async collaboration essential)
6. **Quick-Add Task:** Include in MVP (faster workflow)
7. **Brief Templates:** 3-5 core templates in MVP
8. **Presence Indicators:** Full presence system in MVP
9. **Onboarding:** Minimal (welcome screen only)
10. **Bulk Actions:** Full bulk operations in MVP
11. **Dark Mode:** Defer to post-MVP
12. **Mobile Gestures:** Defer to post-MVP

### 8.3 Post-MVP Backlog

**Deferred Features (v2+):**
- Dark mode
- Mobile gestures (swipe actions)
- Brief-level discussions (message board)
- Daily check-in prompts
- Inline comments on outputs (Figma-style pinning)
- Kanban view (alternative to linear list)
- Multi-workspace/organization management
- Advanced analytics dashboard
- Calendar + Research AI agents (add back 2 more agents)
- Stripe billing automation
- Real-time WebSockets (migrate from polling at >50 concurrent users)
- Algolia search (migrate at 10K briefs)

### 8.4 Technical Debt and Constraints

**Known Limitations (MVP):**
- **30-second polling:** Not real-time (acceptable for invite-only)
- **Single assignee per task:** Duplicate for collaboration
- **Personal workspace only:** One workspace per user
- **Search-only organization:** No tags/labels/filters
- **Manual invoicing:** No automated billing
- **2 AI agents:** Limited to Content + Email (expand post-MVP)

**Migration Triggers:**
- Polling → Realtime: >50 concurrent users
- Supabase SMTP → Resend: >50 emails/hour
- PostgreSQL search → Algolia: >10K briefs
- Free tier → Paid tier: >100 users

### 8.5 Cost Breakdown

**MVP (0-100 users):**
- Vercel: $0
- Supabase: $0
- n8n hosting: $5/month
- OpenRouter AI: $5-10/month
- Sentry: $0
- **Total: $10-15/month**

**Scale (500-1K users):**
- Vercel Pro: $20
- Supabase Pro: $25
- n8n hosting: $20
- OpenRouter AI: $50-100
- Sentry Team: $26
- Resend: $20
- **Total: $161-211/month**

### 8.6 Document Version History

**v1.0 (2025-10-04):**
- Initial consolidated PRD
- Combined 17 source documents into single reference
- Added Epic 8: Authentication and Security
- Incorporated business context from brainstorming sessions
- Total: 128 FRs (111 original + 17 auth-related)

**Source Documents:**
- brainstorming-session-results.md
- tech1.md (First Principles)
- tech2.md (MoSCoW)
- tech3.md (Resource Constraints)
- prd_section1.md + insights
- prd_section2.md + updates
- prd_section3.md + 9 elicitation methods + summary
- prd_section4.md (No-Code Architecture)
- prd_section5.md (Epics + Stories)

---

**END OF CONSOLIDATED PRD**

**Ready for Implementation:** ✅
**Total Requirements:** 128 FRs across 8 Epics
**Timeline:** 5 weeks (42 stories, 220 story points)
**Architecture:** Fully no-code (n8n + Supabase + AI-generated frontend)
**Cost:** $10-15/month MVP → $161-211/month at scale

**Next Steps:**
1. Review and approve consolidated PRD
2. Set up development environment (Supabase project, n8n instance, Vercel deployment)
3. Begin Week 1 implementation (Epic 1: Brief Creation)
