# SingleBrief Brownfield Enhancement PRD - Section 5

## Epic and Story Structure

**Date:** 2025-10-04
**Version:** 1.0
**Status:** Draft

---

## 5.1 Overview

This section breaks down the 111 functional requirements (FR1-FR111) from Section 2 and Section 3 into actionable epics and user stories for MVP implementation.

**Organization:**
- **7 Epics** aligned with core product domains
- **42 User Stories** mapped to 111 FRs
- **5-Week Timeline** (4 weeks core + 1 week "Why This Matters")
- **No-Code Implementation** using n8n, Supabase, and AI-generated frontend

---

## 5.2 Epic Hierarchy

### Epic 1: Brief Creation and AI Task Generation
**Goal:** Enable managers to create briefs and generate task breakdowns with AI

**Timeline:** Week 1 (8 stories)
**Complexity:** High (AI integration, n8n workflows)
**FRs Covered:** FR1-FR20, FR68-FR70, FR82-FR84, FR95

---

### Epic 2: Task Management and Assignment
**Goal:** Enable task assignment, status tracking, and team member task execution

**Timeline:** Week 2 (10 stories)
**Complexity:** Medium (database, RLS policies, team member UI)
**FRs Covered:** FR21-FR38, FR54-FR61, FR79-FR81, FR94, FR99-FR100

---

### Epic 3: AI Agent Task Execution
**Goal:** Implement AI agents as team members with queuing and batch execution

**Timeline:** Week 2 (5 stories)
**Complexity:** High (n8n workflows, OpenRouter integration, queuing logic)
**FRs Covered:** FR62-FR67, FR75-FR77, FR87

---

### Epic 4: Manager Review and Output Management
**Goal:** Enable managers to review, accept, reject, and track task outputs

**Timeline:** Week 3 (6 stories)
**Complexity:** Medium (workflow states, version history, notifications)
**FRs Covered:** FR39-FR53, FR88, FR90, FR101-FR102

---

### Epic 5: Communication and Collaboration
**Goal:** Implement task comments, notifications, and team collaboration features

**Timeline:** Week 3 (5 stories)
**Complexity:** Medium (n8n email workflows, real-time polling, presence indicators)
**FRs Covered:** FR93, FR103-FR107, FR8 (presence indicators from Analogical Thinking Q8)

---

### Epic 6: Search, Navigation, and Bulk Actions
**Goal:** Implement search, filtering, bulk operations, and navigation

**Timeline:** Week 4 (4 stories)
**Complexity:** Low-Medium (PostgreSQL search, UI components)
**FRs Covered:** FR91-FR92, FR108, FR110-FR111

---

### Epic 7: "Why This Matters" and Business Value Framing
**Goal:** Implement motivational framing and business context for briefs

**Timeline:** Week 5 (4 stories)
**Complexity:** Medium (AI generation via n8n, collapsible UI, regeneration)
**FRs Covered:** FR8 (primary), FR70 (regeneration), Decision 1.2 (show AFTER task breakdown)

---

## 5.3 Detailed Epic Breakdown

---

## Epic 1: Brief Creation and AI Task Generation

**Epic Goal:** Enable managers to create briefs and generate AI task breakdowns with configurable limits, templates, and confirmation workflows.

**Epic Owner:** PM (John)
**Timeline:** Week 1 (5 working days)
**Priority:** P0 (Must Have - Core MVP)

---

### Story 1.1: Basic Brief Creation Form

**As a** manager
**I want to** create a new brief by entering a title and description
**So that** I can initiate a project and get AI-generated tasks

**Acceptance Criteria:**
- [ ] Brief creation dialog opens when clicking "New Brief" button (FR1)
- [ ] Form has title field (required, max 200 chars) (FR3)
- [ ] Form has description textarea (required, max 5000 chars, ~1500 words) (FR4)
- [ ] Character count shown below textarea with warning at 3000 chars
- [ ] "Generate Tasks" button is disabled until title and description are filled (FR2)
- [ ] Form validates inputs before submission

**Technical Implementation (No-Code):**
- **Frontend (v0.dev + Claude Code):**
  - Prompt: "Create brief creation dialog with shadcn/ui Dialog, Input, Textarea, Button"
  - v0.dev generates React component
  - Claude Code adds Supabase integration for brief insertion

- **Database (Supabase):**
  ```sql
  CREATE TABLE briefs (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid REFERENCES auth.users(id),
    title text NOT NULL CHECK (length(title) <= 200),
    description text NOT NULL CHECK (length(description) <= 5000),
    status text DEFAULT 'draft' CHECK (status IN ('draft', 'active', 'completed', 'archived')),
    task_count int DEFAULT 0,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
  );
  ```

**FRs Covered:** FR1-FR4

**Story Points:** 5
**Dependencies:** None

---

### Story 1.2: AI Task Breakdown via n8n

**As a** manager
**I want to** submit my brief and get AI-generated task breakdown
**So that** I don't have to manually create tasks

**Acceptance Criteria:**
- [ ] Clicking "Generate Tasks" triggers n8n workflow (FR6)
- [ ] Frontend shows loading state: "Generating tasks..." (FR65)
- [ ] n8n workflow calls OpenRouter API with brief context (TC14)
- [ ] AI response parsed and tasks inserted into Supabase (FR6)
- [ ] Default task limit: 20 (configurable 5-50 via settings) (FR68)
- [ ] Each task has: title, description, status='To-Do', priority='Medium' (FR7)
- [ ] Tasks returned to frontend and displayed (FR9)
- [ ] Error handling: Show error message if AI call fails, allow retry (FR67)

**Technical Implementation (No-Code):**
- **n8n Workflow (Visual):**
  1. Webhook node: POST `/webhook/generate-tasks`
  2. Function node: Validate JWT token
  3. Supabase node: Fetch brief details
  4. HTTP Request node: Call OpenRouter API
     - Model: `openai/gpt-4o-mini`
     - System prompt: "You are a task breakdown assistant. Break the brief into 5-20 actionable tasks..."
  5. Function node: Parse JSON response, validate task count
  6. Supabase node: Batch insert tasks
  7. HTTP Response node: Return success with task count

- **Frontend (AI-Generated):**
  - Prompt Claude Code: "Add API call to n8n webhook with loading state and error handling"

**FRs Covered:** FR6-FR7, FR65, FR67, FR68

**Story Points:** 13
**Dependencies:** Story 1.1

---

### Story 1.3: Progressive Task Confirmation

**As a** manager
**I want to** review and confirm AI-generated tasks before finalizing
**So that** I can make adjustments without being overwhelmed

**Acceptance Criteria:**
- [ ] After AI generation, show 5 tasks at a time (progressive disclosure) (FR69, Decision Q3-B)
- [ ] "Show More" button reveals next 5 tasks
- [ ] Each task has checkbox (default: checked) (FR84)
- [ ] User can uncheck tasks to exclude from final list
- [ ] "Confirm Tasks" button at bottom
- [ ] Clicking "Confirm Tasks" updates brief status to 'active' and task status to 'To-Do'
- [ ] Unchecked tasks are deleted from database
- [ ] Show final count: "X tasks confirmed"

**Technical Implementation (No-Code):**
- **Frontend (v0.dev + Claude Code):**
  - v0.dev: "Create task confirmation list with checkboxes, progressive disclosure (5 at a time), Confirm button"
  - Claude Code: "Add logic to delete unchecked tasks and update brief status"

**FRs Covered:** FR69, FR84

**Story Points:** 5
**Dependencies:** Story 1.2

---

### Story 1.4: Brief Templates

**As a** manager
**I want to** start from a brief template
**So that** I can create briefs faster without blank page paralysis

**Acceptance Criteria:**
- [ ] "Use Template" button in brief creation dialog (FR95, Decision Q7-A)
- [ ] Template selector modal shows 3-5 templates:
  - Marketing Campaign
  - Product Launch
  - Event Planning
  - Hiring Process
  - Custom (blank)
- [ ] Selecting template populates title and description with example text
- [ ] User can edit template text before submitting
- [ ] Template text is just example, not enforced

**Technical Implementation (No-Code):**
- **Frontend (v0.dev + Claude Code):**
  - v0.dev: "Create template selector modal with template previews"
  - Claude Code: "Add template text data and populate form on selection"

- **Template Data (Hardcoded in Frontend):**
  ```typescript
  const templates = [
    {
      name: "Marketing Campaign",
      title: "Launch Q1 2025 Marketing Campaign",
      description: "Plan and execute comprehensive marketing campaign targeting new customer segment. Includes: market research, content creation, channel strategy, budget allocation, and performance tracking."
    },
    // ... 4 more templates
  ];
  ```

**FRs Covered:** FR95

**Story Points:** 3
**Dependencies:** Story 1.1

---

### Story 1.5: AI Task Regeneration

**As a** manager
**I want to** regenerate tasks if AI output is not satisfactory
**So that** I can get better results without starting over

**Acceptance Criteria:**
- [ ] "Regenerate Tasks" button shown on confirmation screen (FR70)
- [ ] Clicking regenerate calls n8n workflow again with same brief
- [ ] Previous tasks are deleted before new generation (FR70)
- [ ] Max 3 regeneration attempts (FR87)
- [ ] After 3 attempts, show message: "Max attempts reached. Please edit brief or continue with current tasks."
- [ ] Regeneration count tracked in database

**Technical Implementation (No-Code):**
- **Database:**
  ```sql
  ALTER TABLE briefs ADD COLUMN regeneration_count int DEFAULT 0;
  ```

- **n8n Workflow:**
  - Add Function node: Check if `regeneration_count < 3`
  - If exceeded, return error: `{ error: "Max regenerations exceeded" }`

- **Frontend (Claude Code):**
  - Prompt: "Add regenerate button with max 3 attempts tracking"

**FRs Covered:** FR70, FR87

**Story Points:** 5
**Dependencies:** Story 1.2, Story 1.3

---

### Story 1.6: Draft Brief Saving

**As a** manager
**I want to** save a brief as draft without generating tasks
**So that** I can return later to complete it

**Acceptance Criteria:**
- [ ] "Save as Draft" button in brief creation dialog (FR83)
- [ ] Clicking saves brief with status='draft'
- [ ] No tasks generated (AI not called)
- [ ] Draft briefs shown in "My Briefs" with "Draft" badge
- [ ] Clicking draft brief reopens creation dialog with pre-filled data
- [ ] User can edit and then generate tasks or save again

**Technical Implementation (No-Code):**
- **Frontend (Claude Code):**
  - Prompt: "Add 'Save as Draft' button that inserts brief without calling n8n workflow"

- **Database:**
  - Brief inserted with `status='draft'`

**FRs Covered:** FR83

**Story Points:** 3
**Dependencies:** Story 1.1

---

### Story 1.7: Brief Title Auto-Generation

**As a** manager
**I want** the brief title to auto-generate from description
**So that** I can save time if I don't have a title in mind

**Acceptance Criteria:**
- [ ] "Auto-Generate Title" button next to title field (FR82)
- [ ] Clicking button extracts first sentence of description (up to 100 chars)
- [ ] If description is empty, show error: "Enter description first"
- [ ] Generated title is editable
- [ ] Title generation is optional (not automatic)

**Technical Implementation (No-Code):**
- **Frontend (Claude Code):**
  - Prompt: "Add auto-generate title button that extracts first sentence from description"

- **Logic (Frontend JavaScript):**
  ```javascript
  const autoGenerateTitle = () => {
    const firstSentence = description.split('.')[0];
    setTitle(firstSentence.slice(0, 100));
  };
  ```

**FRs Covered:** FR82

**Story Points:** 2
**Dependencies:** Story 1.1

---

### Story 1.8: Settings Page - Task Limit Configuration

**As a** manager
**I want to** configure default task generation limit
**So that** I can control brief complexity

**Acceptance Criteria:**
- [ ] Settings page accessible from user menu (FR71)
- [ ] "Default Task Limit" field with slider (5-50) (FR68)
- [ ] Default value: 20
- [ ] Setting saved to user profile in Supabase
- [ ] n8n workflow reads user's task limit setting

**Technical Implementation (No-Code):**
- **Database:**
  ```sql
  CREATE TABLE user_settings (
    user_id uuid PRIMARY KEY REFERENCES auth.users(id),
    default_task_limit int DEFAULT 20 CHECK (default_task_limit BETWEEN 5 AND 50),
    updated_at timestamptz DEFAULT now()
  );
  ```

- **Frontend (v0.dev + Claude Code):**
  - v0.dev: "Create settings page with slider for task limit"
  - Claude Code: "Add Supabase integration to save/load settings"

- **n8n Workflow:**
  - Add Supabase node: Fetch user settings before AI call
  - Use `task_limit` in system prompt

**FRs Covered:** FR68, FR71

**Story Points:** 5
**Dependencies:** None

---

**Epic 1 Summary:**
- **Total Stories:** 8
- **Total Story Points:** 41
- **Timeline:** Week 1 (5 working days)
- **FRs Covered:** 20 FRs (FR1-FR20, FR68-FR70, FR82-FR84, FR95)

---

## Epic 2: Task Management and Assignment

**Epic Goal:** Enable task assignment, status tracking, progress management, and team member task execution interface.

**Epic Owner:** PM (John)
**Timeline:** Week 2 (5 working days)
**Priority:** P0 (Must Have - Core MVP)

---

### Story 2.1: Task Assignment Interface

**As a** manager
**I want to** assign tasks to team members or AI agents
**So that** work can be distributed and tracked

**Acceptance Criteria:**
- [ ] Each task in brief detail view has "Assign" dropdown (FR21)
- [ ] Dropdown shows: "Unassigned", team members, AI agents (FR22, FR24)
- [ ] Selecting assignee updates task and sends notification (FR33, FR103)
- [ ] Unassigned tasks stay visible to manager only
- [ ] Assigned tasks appear in assignee's "My Tasks" inbox (FR54)

**Technical Implementation (No-Code):**
- **Database:**
  ```sql
  CREATE TABLE tasks (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    brief_id uuid REFERENCES briefs(id) ON DELETE CASCADE,
    title text NOT NULL,
    description text,
    assigned_to uuid REFERENCES auth.users(id), -- NULL = unassigned
    status text DEFAULT 'To-Do' CHECK (status IN ('To-Do', 'Queued', 'In-Progress', 'Done', 'Rejected', 'Accepted', 'Archived')),
    priority text DEFAULT 'Medium' CHECK (priority IN ('High', 'Medium', 'Low')),
    due_date timestamptz,
    progress_percent int DEFAULT 0 CHECK (progress_percent BETWEEN 0 AND 100),
    output_url text,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
  );
  ```

- **Frontend (v0.dev + Claude Code):**
  - v0.dev: "Create task card with assign dropdown showing team members"
  - Claude Code: "Add Supabase update and notification trigger on assignment"

- **n8n Workflow (Email Notification):**
  - Trigger: Webhook POST `/webhook/send-notification`
  - Fetch user email from Supabase
  - Send email via Supabase Auth SMTP: "You've been assigned to task: [title]"

**FRs Covered:** FR21-FR24, FR33, FR54, FR103

**Story Points:** 8
**Dependencies:** Story 1.2 (tasks exist)

---

### Story 2.2: Task Status Tracking

**As a** team member
**I want to** update task status as I work
**So that** managers can see progress

**Acceptance Criteria:**
- [ ] Task detail view has status dropdown (FR25)
- [ ] Status options: To-Do, In-Progress, Done (FR26-FR28)
- [ ] Changing status updates `updated_at` timestamp
- [ ] Manager sees status change in real-time (30-second polling) (FR72, TC20)
- [ ] Status history logged (FR60)

**Technical Implementation (No-Code):**
- **Database:**
  ```sql
  CREATE TABLE task_history (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    task_id uuid REFERENCES tasks(id) ON DELETE CASCADE,
    user_id uuid REFERENCES auth.users(id),
    action text NOT NULL, -- 'status_changed', 'assigned', 'output_submitted', etc.
    old_value text,
    new_value text,
    created_at timestamptz DEFAULT now()
  );
  ```

- **Frontend (Claude Code):**
  - Prompt: "Add status dropdown that updates Supabase and inserts history record"

- **Polling (TanStack Query):**
  ```typescript
  useQuery({
    queryKey: ['tasks', briefId],
    queryFn: () => supabase.from('tasks').select('*').eq('brief_id', briefId),
    refetchInterval: 30000 // 30 seconds
  });
  ```

**FRs Covered:** FR25-FR28, FR60, FR72

**Story Points:** 5
**Dependencies:** Story 2.1

---

### Story 2.3: Team Member Task Inbox

**As a** team member
**I want to** see all tasks assigned to me
**So that** I know what to work on

**Acceptance Criteria:**
- [ ] "My Tasks" page shows tasks assigned to current user (FR54)
- [ ] Tasks grouped by status: To-Do, In-Progress, Done
- [ ] Each task shows: title, brief title, priority, due date (if set), progress % (if enabled)
- [ ] Clicking task opens task detail view
- [ ] Unread count badge on "My Tasks" navigation (FR from Analogical Thinking - Slack)

**Technical Implementation (No-Code):**
- **Frontend (v0.dev + Claude Code):**
  - v0.dev: "Create task inbox with grouped lists by status"
  - Claude Code: "Query Supabase for tasks where assigned_to = current user"

- **RLS Policy:**
  ```sql
  CREATE POLICY "Users can view assigned tasks"
  ON tasks FOR SELECT
  TO authenticated
  USING (assigned_to = auth.uid());
  ```

**FRs Covered:** FR54, Analogical Thinking badge feature

**Story Points:** 5
**Dependencies:** Story 2.1

---

### Story 2.4: Due Date Assignment

**As a** team member
**I want to** set a due date when starting a task
**So that** I can manage my own deadlines

**Acceptance Criteria:**
- [ ] When changing status to "In-Progress", show due date picker (optional) (FR55)
- [ ] Calendar widget for date selection (shadcn/ui Calendar)
- [ ] Due date saved to task
- [ ] Overdue tasks shown with red indicator (FR85)
- [ ] Tasks due in 24 hours highlighted in yellow

**Technical Implementation (No-Code):**
- **Frontend (v0.dev + Claude Code):**
  - v0.dev: "Add due date picker (shadcn/ui Calendar) to task detail"
  - Claude Code: "Show picker when status changes to In-Progress"

- **Overdue Logic (Frontend):**
  ```typescript
  const isOverdue = task.due_date && new Date(task.due_date) < new Date();
  const dueSoon = task.due_date &&
    new Date(task.due_date) - new Date() < 24 * 60 * 60 * 1000;
  ```

**FRs Covered:** FR55, FR85

**Story Points:** 5
**Dependencies:** Story 2.2

---

### Story 2.5: Progress Tracking (Optional Per Brief)

**As a** team member
**I want to** update progress percentage on tasks
**So that** managers can see how close I am to completion

**Acceptance Criteria:**
- [ ] Manager enables/disables progress tracking per brief (FR56, Decision Q1-C)
- [ ] If enabled, task detail shows progress slider (0-100%)
- [ ] Slider updates in real-time (debounced)
- [ ] Progress % shown on task card
- [ ] If disabled, progress field hidden

**Technical Implementation (No-Code):**
- **Database:**
  ```sql
  ALTER TABLE briefs ADD COLUMN progress_tracking_enabled boolean DEFAULT false;
  ```

- **Frontend (v0.dev + Claude Code):**
  - v0.dev: "Add progress slider (shadcn/ui Slider) to task detail"
  - Claude Code: "Show slider only if brief.progress_tracking_enabled = true"

**FRs Covered:** FR56, Decision Q1-C

**Story Points:** 5
**Dependencies:** Story 2.2

---

### Story 2.6: Task Output Submission

**As a** team member
**I want to** submit output URL when task is complete
**So that** managers can review my work

**Acceptance Criteria:**
- [ ] Task detail has "Output URL" field (FR57)
- [ ] Field appears when status = "Done"
- [ ] URL validation (starts with http:// or https://)
- [ ] Submitting output triggers manager notification (FR103)
- [ ] Output URL shown to manager in task review view

**Technical Implementation (No-Code):**
- **Frontend (Claude Code):**
  - Prompt: "Add output URL field with validation, shown when status = Done"

- **n8n Notification Workflow:**
  - Webhook: POST `/webhook/notify-output-submitted`
  - Fetch manager email from brief
  - Send email: "Task '[title]' completed. Review output: [url]"

**FRs Covered:** FR57, FR103

**Story Points:** 3
**Dependencies:** Story 2.2

---

### Story 2.7: Task Priority System

**As a** manager
**I want to** set task priority
**So that** team members know what to work on first

**Acceptance Criteria:**
- [ ] Each task has priority field: High, Medium, Low (FR79-FR81)
- [ ] Default priority: Medium (AI-generated tasks)
- [ ] Manager can change priority via dropdown
- [ ] Priority badge shown on task card: High=red, Medium=yellow, Low=gray
- [ ] Tasks sorted by priority in "My Tasks" inbox

**Technical Implementation (No-Code):**
- **Frontend (v0.dev + Claude Code):**
  - v0.dev: "Add priority dropdown with color-coded badges"
  - Claude Code: "Add sort by priority in task list query"

- **Database Index:**
  ```sql
  CREATE INDEX idx_tasks_priority ON tasks(priority);
  ```

**FRs Covered:** FR79-FR81

**Story Points:** 3
**Dependencies:** Story 2.1

---

### Story 2.8: Quick-Add Task

**As a** manager
**I want to** quickly add a manual task with just a title
**So that** I can add tasks without full form

**Acceptance Criteria:**
- [ ] "Add Task" input at bottom of task list in brief detail (FR94, Decision Q6-A)
- [ ] Type title, press Enter → task created
- [ ] Default values: status='To-Do', priority='Medium', assigned_to=NULL
- [ ] Task immediately appears in list
- [ ] Clicking task opens detail view to add description, assignee

**Technical Implementation (No-Code):**
- **Frontend (Claude Code):**
  - Prompt: "Add quick-add task input with Enter key handler"

**FRs Covered:** FR94

**Story Points:** 3
**Dependencies:** Story 1.2

---

### Story 2.9: Bulk Task Actions

**As a** manager
**I want to** perform bulk actions on tasks
**So that** I can manage multiple tasks efficiently

**Acceptance Criteria:**
- [ ] Checkboxes on task cards for multi-select (FR110, Decision Q10-A)
- [ ] Bulk actions bar appears when >0 tasks selected
- [ ] Actions: Assign, Change Priority, Archive, Delete
- [ ] "Select All" checkbox in header
- [ ] Confirmation dialog for destructive actions (Delete)

**Technical Implementation (No-Code):**
- **Frontend (v0.dev + Claude Code):**
  - v0.dev: "Add bulk actions bar with checkboxes"
  - Claude Code: "Add Supabase batch update logic"

**FRs Covered:** FR110, Decision Q10-A

**Story Points:** 5
**Dependencies:** Story 2.1

---

### Story 2.10: Minimal Onboarding

**As a** new user
**I want to** see a quick welcome screen
**So that** I understand how to get started

**Acceptance Criteria:**
- [ ] On first login, show welcome modal (FR99, Decision Q9-B)
- [ ] Modal contains:
  - Welcome message
  - 3 quick steps: "1. Create Brief → 2. Generate Tasks → 3. Assign to Team"
  - "Get Started" button (dismisses modal)
- [ ] Modal never shown again (stored in user_settings)
- [ ] "Help" link in navigation to re-show onboarding

**Technical Implementation (No-Code):**
- **Database:**
  ```sql
  ALTER TABLE user_settings ADD COLUMN onboarding_completed boolean DEFAULT false;
  ```

- **Frontend (v0.dev + Claude Code):**
  - v0.dev: "Create welcome modal with 3-step guide"
  - Claude Code: "Check user_settings.onboarding_completed, show modal if false"

**FRs Covered:** FR99, Decision Q9-B

**Story Points:** 3
**Dependencies:** None

---

**Epic 2 Summary:**
- **Total Stories:** 10
- **Total Story Points:** 45
- **Timeline:** Week 2 (5 working days)
- **FRs Covered:** 25 FRs (FR21-FR38, FR54-FR61, FR79-FR81, FR94, FR99-FR100)

---

## Epic 3: AI Agent Task Execution

**Epic Goal:** Implement AI agents as specialized team members with queuing, batch execution, cost control, and error handling.

**Epic Owner:** PM (John)
**Timeline:** Week 2 (concurrent with Epic 2)
**Priority:** P0 (Must Have - Core MVP)

---

### Story 3.1: AI Agent User Creation

**As a** manager
**I want to** have AI agents available as team members
**So that** I can assign tasks to AI for automation

**Acceptance Criteria:**
- [ ] 2 default AI agent accounts created during onboarding:
  - "AI Writer" (email: ai-writer@singlebrief.ai)
  - "AI Researcher" (email: ai-researcher@singlebrief.ai)
- [ ] AI agents appear in task assignment dropdown (FR24)
- [ ] AI agents have special avatar/badge (robot icon)
- [ ] AI agents cannot login (no password, special flag in database)

**Technical Implementation (No-Code):**
- **Database:**
  ```sql
  ALTER TABLE auth.users ADD COLUMN is_ai_agent boolean DEFAULT false;

  -- Insert AI agents during user signup
  INSERT INTO auth.users (email, is_ai_agent) VALUES
    ('ai-writer@singlebrief.ai', true),
    ('ai-researcher@singlebrief.ai', true);
  ```

- **Frontend (Claude Code):**
  - Prompt: "Filter users where is_ai_agent = true, show robot icon"

**FRs Covered:** FR24, FR62

**Story Points:** 3
**Dependencies:** None

---

### Story 3.2: AI Task Queuing

**As a** manager
**I want** tasks assigned to AI agents to queue instead of auto-executing
**So that** I can control AI costs and review before execution

**Acceptance Criteria:**
- [ ] When task assigned to AI agent, status changes to "Queued" (FR75, Decision Q2-C)
- [ ] Queued tasks shown with special icon/badge
- [ ] Queued tasks do NOT execute immediately
- [ ] Manager must manually trigger execution via FAB or batch action (FR76)
- [ ] If task queued for 24h without execution, send email reminder to manager (FR75)

**Technical Implementation (No-Code):**
- **Database Logic:**
  - When `assigned_to` is AI agent, set `status = 'Queued'` instead of 'To-Do'

- **n8n Workflow (Daily Reminder):**
  - Trigger: Cron (daily at 9am)
  - Supabase query: Tasks where `status='Queued'` AND `created_at < NOW() - INTERVAL '24 hours'`
  - Email manager: "You have X queued AI tasks. Execute them?"

**FRs Covered:** FR75, Decision Q2-C

**Story Points:** 5
**Dependencies:** Story 3.1

---

### Story 3.3: AI Batch Execution via FAB

**As a** manager
**I want to** trigger AI batch execution via floating action button
**So that** I can run all queued AI tasks at once

**Acceptance Criteria:**
- [ ] Floating Action Button (FAB) shown when >0 queued tasks (FR76)
- [ ] FAB shows count: "Execute 5 AI Tasks"
- [ ] Clicking FAB shows confirmation with cost preview: "~$0.10 estimated cost" (FR77)
- [ ] Confirming triggers n8n batch workflow
- [ ] Tasks execute sequentially with 5-second delay between calls (FR76)
- [ ] Progress indicator shows: "Executing 3/5..."
- [ ] Email sent when batch complete: "5 tasks completed. Review outputs."

**Technical Implementation (No-Code):**
- **Frontend (v0.dev + Claude Code):**
  - v0.dev: "Create FAB with count badge and confirmation dialog"
  - Claude Code: "Call n8n webhook with list of queued task IDs"

- **n8n Workflow (Batch Execution):**
  - Webhook: POST `/webhook/execute-ai-batch`
  - Input: `{ task_ids: [uuid, uuid, ...] }`
  - Loop node: For each task_id
    - Fetch task + brief context from Supabase
    - HTTP Request: Call OpenRouter API
    - Parse response
    - Update task: `status='Done'`, `output_url=[generated]`
    - Wait 5 seconds (delay node)
  - Email: Send completion summary to manager

**FRs Covered:** FR76-FR77

**Story Points:** 8
**Dependencies:** Story 3.2

---

### Story 3.4: AI Context Window Management

**As an** AI agent
**I want to** receive full brief context + "Why This Matters"
**So that** I can generate high-quality outputs

**Acceptance Criteria:**
- [ ] n8n workflow fetches: brief title, description, "Why This Matters", task title, task description (FR63)
- [ ] Context sent to OpenRouter in system prompt
- [ ] AI can access previous output versions for learning (FR64)
- [ ] Token count estimated and logged

**Technical Implementation (No-Code):**
- **n8n Workflow:**
  - Supabase node: Fetch brief + task + task_history (previous outputs)
  - Function node: Build context string
    ```javascript
    const context = `
    Brief: ${brief.title}
    Description: ${brief.description}
    Why This Matters: ${brief.why_matters}
    Task: ${task.title}
    Task Description: ${task.description}
    Previous Outputs: ${previousOutputs.join('\n')}
    `;
    ```
  - HTTP Request: Include context in OpenRouter API call

**FRs Covered:** FR63-FR64

**Story Points:** 5
**Dependencies:** Story 3.3

---

### Story 3.5: AI Error Handling and Retry

**As a** manager
**I want** AI errors to be handled gracefully
**So that** I can retry or reassign failed tasks

**Acceptance Criteria:**
- [ ] If AI call fails (timeout, rate limit, API error), set task status='To-Do' (FR67)
- [ ] Error message stored in task_history
- [ ] Manager notified via email: "AI task failed. Error: [message]. Retry or reassign?"
- [ ] Task shown with error badge in UI
- [ ] Manager can click "Retry" to re-queue task

**Technical Implementation (No-Code):**
- **n8n Workflow (Error Handling):**
  - Add Error Trigger node
  - On error:
    - Supabase update: `status='To-Do'`
    - Insert error into task_history
    - Email manager with error details
  - Retry logic: Max 3 retries with exponential backoff

**FRs Covered:** FR67, FR87 (max attempts)

**Story Points:** 5
**Dependencies:** Story 3.3

---

**Epic 3 Summary:**
- **Total Stories:** 5
- **Total Story Points:** 26
- **Timeline:** Week 2 (concurrent with Epic 2)
- **FRs Covered:** 10 FRs (FR62-FR67, FR75-FR77, FR87)

---

## Epic 4: Manager Review and Output Management

**Epic Goal:** Enable managers to review task outputs, accept/reject work, track rework cycles, and manage version history.

**Epic Owner:** PM (John)
**Timeline:** Week 3 (5 working days)
**Priority:** P0 (Must Have - Core MVP)

---

### Story 4.1: Task Review Interface

**As a** manager
**I want to** review completed task outputs
**So that** I can accept or request revisions

**Acceptance Criteria:**
- [ ] Tasks with status='Done' shown in "Review" tab of brief detail (FR39)
- [ ] Review card shows: task title, assignee, output URL, completion date
- [ ] Clicking task opens review modal
- [ ] Modal shows: task description, output URL (embedded iframe if possible), Accept/Reject buttons

**Technical Implementation (No-Code):**
- **Frontend (v0.dev + Claude Code):**
  - v0.dev: "Create task review modal with iframe and Accept/Reject buttons"
  - Claude Code: "Query tasks where status='Done' and brief belongs to manager"

**FRs Covered:** FR39

**Story Points:** 5
**Dependencies:** Story 2.6 (output submission)

---

### Story 4.2: Accept/Reject Workflow

**As a** manager
**I want to** accept or reject task outputs with feedback
**So that** team members know if rework is needed

**Acceptance Criteria:**
- [ ] "Accept" button changes task status to "Accepted" (FR40)
- [ ] "Reject" button shows feedback textarea (required) (FR41, FR59)
- [ ] Rejection feedback saved to task
- [ ] Task status changes to "Rejected" (FR59)
- [ ] Team member notified via email: "Task rejected. Feedback: [text]" (FR103)
- [ ] Rejected task reappears in team member's "My Tasks" with feedback visible

**Technical Implementation (No-Code):**
- **Database:**
  ```sql
  ALTER TABLE tasks ADD COLUMN rejection_feedback text;
  ALTER TABLE tasks ADD COLUMN rework_cycle int DEFAULT 0;
  ```

- **Frontend (v0.dev + Claude Code):**
  - v0.dev: "Add rejection modal with textarea and Reject/Cancel buttons"
  - Claude Code: "Update task status and send notification webhook"

- **n8n Workflow (Rejection Notification):**
  - Webhook: POST `/webhook/notify-rejection`
  - Fetch assignee email
  - Send email with feedback and task link

**FRs Covered:** FR40-FR41, FR59, FR103

**Story Points:** 8
**Dependencies:** Story 4.1

---

### Story 4.3: Rework Cycle Tracking

**As a** manager
**I want to** track how many times a task has been reworked
**So that** I can identify problematic tasks

**Acceptance Criteria:**
- [ ] Each rejection increments `rework_cycle` counter (FR89)
- [ ] Task card shows rework count if >0: "Rework cycle: 2"
- [ ] After 3 rework cycles, show warning: "High rework count. Consider reassigning or clarifying requirements."
- [ ] Rework count visible in task history

**Technical Implementation (No-Code):**
- **Frontend (Claude Code):**
  - Prompt: "Increment rework_cycle on rejection, show badge if > 0"

**FRs Covered:** FR89

**Story Points:** 3
**Dependencies:** Story 4.2

---

### Story 4.4: Version History and Comparison

**As a** manager
**I want to** see version history of task outputs
**So that** I can compare changes after rework

**Acceptance Criteria:**
- [ ] Each output submission creates version record (FR88)
- [ ] Review modal shows "Version History" dropdown
- [ ] Selecting version loads that output URL in iframe
- [ ] Version comparison: Side-by-side view of v1 vs v2 (if URLs are embeddable)
- [ ] Version metadata: submitted date, assignee, status (Accepted/Rejected)

**Technical Implementation (No-Code):**
- **Database:**
  ```sql
  CREATE TABLE task_output_versions (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    task_id uuid REFERENCES tasks(id) ON DELETE CASCADE,
    version_number int NOT NULL,
    output_url text NOT NULL,
    submitted_by uuid REFERENCES auth.users(id),
    status text CHECK (status IN ('Accepted', 'Rejected', 'Pending')),
    created_at timestamptz DEFAULT now()
  );
  ```

- **Frontend (v0.dev + Claude Code):**
  - v0.dev: "Add version history dropdown with side-by-side comparison view"
  - Claude Code: "Query task_output_versions, show in dropdown"

**FRs Covered:** FR88

**Story Points:** 8
**Dependencies:** Story 4.2

---

### Story 4.5: Brief Completion and Archiving

**As a** manager
**I want to** mark briefs as completed or archived
**So that** I can keep my dashboard clean

**Acceptance Criteria:**
- [ ] Brief detail has "Mark Complete" button (FR42)
- [ ] Clicking shows confirmation: "All tasks accepted?"
- [ ] If yes, brief status → 'completed'
- [ ] "Archive Brief" button moves brief to archived state (FR43)
- [ ] Archived briefs hidden from default view (FR92)
- [ ] "Show Archived" toggle in "My Briefs" reveals archived briefs

**Technical Implementation (No-Code):**
- **Frontend (Claude Code):**
  - Prompt: "Add Complete and Archive buttons with confirmation"

- **Database Query:**
  ```sql
  -- Default: Hide archived
  SELECT * FROM briefs WHERE status != 'archived'

  -- Show archived
  SELECT * FROM briefs WHERE status = 'archived'
  ```

**FRs Covered:** FR42-FR43, FR92

**Story Points:** 5
**Dependencies:** Story 4.2

---

### Story 4.6: AI Output Attribution

**As a** manager
**I want to** clearly see which outputs were AI-generated
**So that** I can adjust review expectations

**Acceptance Criteria:**
- [ ] Task cards show "AI Generated" badge if assignee is AI agent (FR90)
- [ ] Badge visible in review interface
- [ ] Task history shows AI agent actions separately

**Technical Implementation (No-Code):**
- **Frontend (Claude Code):**
  - Prompt: "Show 'AI Generated' badge if task.assigned_to.is_ai_agent = true"

**FRs Covered:** FR90

**Story Points:** 2
**Dependencies:** Story 3.1

---

**Epic 4 Summary:**
- **Total Stories:** 6
- **Total Story Points:** 31
- **Timeline:** Week 3 (5 working days)
- **FRs Covered:** 12 FRs (FR39-FR53, FR88, FR90, FR101-FR102)

---

## Epic 5: Communication and Collaboration

**Epic Goal:** Implement task comments, notifications, presence indicators, and team collaboration features.

**Epic Owner:** PM (John)
**Timeline:** Week 3 (concurrent with Epic 4)
**Priority:** P1 (Should Have - MVP)

---

### Story 5.1: Task Comments Thread

**As a** team member or manager
**I want to** comment on tasks for async collaboration
**So that** I can ask questions and provide context without email

**Acceptance Criteria:**
- [ ] Task detail has "Comments" section (FR93, Decision Q5-A)
- [ ] Comment input with @mention autocomplete
- [ ] Submit comment → appears in thread immediately
- [ ] Comments show: avatar, name, timestamp, text
- [ ] Comments visible to anyone with task access (manager + assignee)
- [ ] @mentioned users get email notification

**Technical Implementation (No-Code):**
- **Database:**
  ```sql
  CREATE TABLE task_comments (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    task_id uuid REFERENCES tasks(id) ON DELETE CASCADE,
    user_id uuid REFERENCES auth.users(id),
    comment text NOT NULL,
    mentioned_users uuid[], -- Array of user IDs mentioned
    created_at timestamptz DEFAULT now()
  );
  ```

- **Frontend (v0.dev + Claude Code):**
  - v0.dev: "Create comment thread with @mention autocomplete"
  - Claude Code: "Add Supabase insert and real-time subscription"

- **n8n Workflow (@Mention Notification):**
  - Webhook: POST `/webhook/notify-mention`
  - Loop through mentioned_users
  - Send email: "[User] mentioned you in task: [title]"

**FRs Covered:** FR93, Decision Q5-A

**Story Points:** 8
**Dependencies:** Story 2.1

---

### Story 5.2: Notification System

**As a** user
**I want to** receive notifications for important events
**So that** I stay informed without constantly checking

**Acceptance Criteria:**
- [ ] Notification bell icon in header with unread count badge (FR103)
- [ ] Clicking bell opens notification dropdown
- [ ] Notification types:
  - Task assigned
  - Output submitted (to manager)
  - Task accepted
  - Task rejected (to assignee)
  - Comment added
  - @mention
- [ ] Each notification shows: icon, text, timestamp, "Mark as Read" button
- [ ] Clicking notification navigates to task
- [ ] Email sent for critical notifications (FR104)

**Technical Implementation (No-Code):**
- **Database:**
  ```sql
  CREATE TABLE notifications (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid REFERENCES auth.users(id),
    type text NOT NULL,
    title text NOT NULL,
    message text,
    link_url text, -- Link to task/brief
    is_read boolean DEFAULT false,
    created_at timestamptz DEFAULT now()
  );
  ```

- **Frontend (v0.dev + Claude Code):**
  - v0.dev: "Create notification dropdown with bell icon and badges"
  - Claude Code: "Query unread notifications, mark as read on click"

- **n8n Workflow (Universal Notification):**
  - Webhook: POST `/webhook/create-notification`
  - Insert notification into Supabase
  - If type is critical (rejected, assigned), send email

**FRs Covered:** FR103-FR104

**Story Points:** 8
**Dependencies:** None

---

### Story 5.3: Notification Preferences

**As a** user
**I want to** control notification settings
**So that** I'm not overwhelmed

**Acceptance Criteria:**
- [ ] Settings page has "Notifications" section (FR105, FR71)
- [ ] Toggles for:
  - Email notifications ON/OFF
  - Per-brief notification settings (mute specific briefs)
  - Do Not Disturb hours (9pm - 9am, no emails sent)
- [ ] Settings saved per user
- [ ] n8n checks user preferences before sending email

**Technical Implementation (No-Code):**
- **Database:**
  ```sql
  ALTER TABLE user_settings ADD COLUMN email_notifications_enabled boolean DEFAULT true;
  ALTER TABLE user_settings ADD COLUMN dnd_start_hour int DEFAULT 21; -- 9pm
  ALTER TABLE user_settings ADD COLUMN dnd_end_hour int DEFAULT 9; -- 9am

  CREATE TABLE user_brief_mutes (
    user_id uuid REFERENCES auth.users(id),
    brief_id uuid REFERENCES briefs(id),
    PRIMARY KEY (user_id, brief_id)
  );
  ```

- **n8n Workflow:**
  - Before sending email, fetch user_settings
  - Check: email_notifications_enabled = true
  - Check: current hour not in DND range
  - Check: brief not in user_brief_mutes

**FRs Covered:** FR105, FR71

**Story Points:** 5
**Dependencies:** Story 5.2

---

### Story 5.4: Presence Indicators

**As a** user
**I want to** see who's viewing a task
**So that** I can avoid edit conflicts

**Acceptance Criteria:**
- [ ] Task detail shows avatars of users currently viewing (Decision Q8-A)
- [ ] "Sarah is viewing this task" text below avatars
- [ ] Presence updated in real-time (30-second polling initially, Supabase Realtime later)
- [ ] User's presence removed when they navigate away

**Technical Implementation (No-Code):**
- **Database:**
  ```sql
  CREATE TABLE task_presence (
    user_id uuid REFERENCES auth.users(id),
    task_id uuid REFERENCES tasks(id),
    last_seen timestamptz DEFAULT now(),
    PRIMARY KEY (user_id, task_id)
  );
  ```

- **Frontend (Claude Code):**
  - On task view mount: Insert presence record (upsert)
  - Poll every 30s: Update `last_seen`
  - Query: Users with `last_seen > NOW() - INTERVAL '1 minute'`
  - On unmount: Delete presence record

**FRs Covered:** Decision Q8-A (Analogical Thinking - Figma)

**Story Points:** 5
**Dependencies:** None

---

### Story 5.5: Activity Feed

**As a** manager
**I want to** see recent activity across all briefs
**So that** I can stay updated on team progress

**Acceptance Criteria:**
- [ ] "Activity" tab in dashboard (FR106)
- [ ] Shows recent events: task completed, brief created, output submitted, etc.
- [ ] Each event shows: avatar, action text, timestamp, link to resource
- [ ] Filter by: All Briefs, Specific Brief, User
- [ ] Real-time updates (30-second polling)

**Technical Implementation (No-Code):**
- **Database:**
  - Use existing `task_history` table
  - Query recent records with joins to get user/task/brief names

- **Frontend (v0.dev + Claude Code):**
  - v0.dev: "Create activity feed with timeline layout"
  - Claude Code: "Query task_history ordered by created_at DESC, limit 50"

**FRs Covered:** FR106

**Story Points:** 5
**Dependencies:** Story 2.2 (task_history exists)

---

**Epic 5 Summary:**
- **Total Stories:** 5
- **Total Story Points:** 31
- **Timeline:** Week 3 (concurrent with Epic 4)
- **FRs Covered:** 8 FRs (FR93, FR103-FR107, Decision Q8-A)

---

## Epic 6: Search, Navigation, and Bulk Actions

**Epic Goal:** Implement search, filtering, bulk operations, and efficient navigation patterns.

**Epic Owner:** PM (John)
**Timeline:** Week 4 (5 working days)
**Priority:** P1 (Should Have - MVP)

---

### Story 6.1: PostgreSQL Full-Text Search

**As a** user
**I want to** search for briefs and tasks by keyword
**So that** I can quickly find what I need

**Acceptance Criteria:**
- [ ] Global search bar in header (FR108)
- [ ] Search across: brief titles, descriptions, task titles
- [ ] Results grouped by: Briefs, Tasks
- [ ] Show top 10 results per category
- [ ] Clicking result navigates to brief/task
- [ ] Search executes on Enter or after 300ms debounce

**Technical Implementation (No-Code):**
- **Database (PostgreSQL Full-Text Search):**
  ```sql
  -- Add search vector column
  ALTER TABLE briefs ADD COLUMN search_vector tsvector;

  -- Create search index
  CREATE INDEX idx_briefs_search ON briefs USING gin(search_vector);

  -- Auto-update trigger
  CREATE TRIGGER briefs_search_update
  BEFORE INSERT OR UPDATE ON briefs
  FOR EACH ROW EXECUTE FUNCTION
  tsvector_update_trigger(search_vector, 'pg_catalog.english', title, description);

  -- Same for tasks table
  ```

- **Frontend (v0.dev + Claude Code):**
  - v0.dev: "Create search bar with dropdown results"
  - Claude Code: "Add Supabase textSearch query with debounce"

**FRs Covered:** FR108

**Story Points:** 8
**Dependencies:** None

---

### Story 6.2: Search Scope Controls

**As a** user
**I want to** filter search by brief status, date range, assignee
**So that** I can narrow down results

**Acceptance Criteria:**
- [ ] Search dropdown has filter chips: "Active Briefs", "Completed", "My Tasks" (FR91)
- [ ] Clicking chip filters results
- [ ] Date range picker for created/updated date
- [ ] Assignee filter (dropdown)
- [ ] Filters combine with AND logic

**Technical Implementation (No-Code):**
- **Frontend (Claude Code):**
  - Prompt: "Add filter chips that modify Supabase query filters"

**FRs Covered:** FR91

**Story Points:** 5
**Dependencies:** Story 6.1

---

### Story 6.3: Dashboard Navigation Optimization

**As a** user
**I want** fast navigation between briefs and tasks
**So that** I can work efficiently

**Acceptance Criteria:**
- [ ] Unified dashboard shows both "My Briefs" and "My Tasks" (Trade-off Decision: Unified Dashboard)
- [ ] Quick filters: "Active", "Completed", "Archived"
- [ ] Breadcrumb navigation: Dashboard > Brief > Task
- [ ] Back button remembers scroll position
- [ ] Keyboard shortcuts: "/" for search, "n" for new brief, "Esc" to close modals

**Technical Implementation (No-Code):**
- **Frontend (v0.dev + Claude Code):**
  - v0.dev: "Create unified dashboard with tabs and breadcrumbs"
  - Claude Code: "Add keyboard event listeners for shortcuts"

**FRs Covered:** Trade-off Analysis - Unified Dashboard

**Story Points:** 5
**Dependencies:** None

---

### Story 6.4: Archived Brief Filtering

**As a** user
**I want to** easily toggle archived briefs visibility
**So that** I can clean up my dashboard without losing data

**Acceptance Criteria:**
- [ ] "Show Archived" toggle in "My Briefs" section (FR92)
- [ ] Toggle default: OFF (archived hidden)
- [ ] When ON, archived briefs shown with "Archived" badge
- [ ] Archived briefs at bottom of list

**Technical Implementation (No-Code):**
- **Frontend (Claude Code):**
  - Prompt: "Add toggle that modifies Supabase query to include/exclude status='archived'"

**FRs Covered:** FR92

**Story Points:** 2
**Dependencies:** Story 4.5 (archiving exists)

---

**Epic 6 Summary:**
- **Total Stories:** 4
- **Total Story Points:** 20
- **Timeline:** Week 4 (5 working days)
- **FRs Covered:** 4 FRs (FR91-FR92, FR108, FR110-FR111)

---

## Epic 7: "Why This Matters" and Business Value Framing

**Epic Goal:** Implement motivational "Why This Matters" feature to communicate business value and increase manager confidence.

**Epic Owner:** PM (John)
**Timeline:** Week 5 (5 working days)
**Priority:** P0 (Must Have - Differentiator)

---

### Story 7.1: "Why This Matters" AI Generation

**As a** manager
**I want** AI to generate "Why This Matters" context after task breakdown
**So that** I can communicate business value to my team

**Acceptance Criteria:**
- [ ] After task confirmation, show "Generate Why This Matters" button (FR8)
- [ ] Clicking triggers n8n workflow
- [ ] n8n calls OpenRouter with: brief title, description, tasks (FR8)
- [ ] AI generates 2-3 sentence business value explanation
- [ ] "Why This Matters" saved to brief
- [ ] Shown AFTER task breakdown, not before (Decision 1.2)

**Technical Implementation (No-Code):**
- **Database:**
  ```sql
  ALTER TABLE briefs ADD COLUMN why_matters text;
  ```

- **n8n Workflow:**
  - Webhook: POST `/webhook/generate-why-matters`
  - Supabase: Fetch brief + tasks
  - HTTP Request: OpenRouter API
    - System prompt: "You are a business value communicator. Explain why this brief matters in 2-3 sentences focusing on business impact and team motivation."
  - Supabase: Update brief with `why_matters`
  - HTTP Response: Return generated text

- **Frontend (Claude Code):**
  - Prompt: "Add 'Generate Why This Matters' button that calls n8n webhook"

**FRs Covered:** FR8, Decision 1.2

**Story Points:** 8
**Dependencies:** Story 1.2 (task generation exists)

---

### Story 7.2: "Why This Matters" Collapsible UI

**As a** team member
**I want** "Why This Matters" to be collapsible
**So that** I can choose to read it or not

**Acceptance Criteria:**
- [ ] "Why This Matters" shown as collapsible section in brief detail (Trade-off Decision: Collapsible)
- [ ] Default state: COLLAPSED (user can expand)
- [ ] Expand/collapse animates smoothly
- [ ] Icon changes: chevron-right (collapsed) → chevron-down (expanded)
- [ ] State saved per user (collapsed/expanded preference)

**Technical Implementation (No-Code):**
- **Frontend (v0.dev + Claude Code):**
  - v0.dev: "Create collapsible section with shadcn/ui Collapsible component"
  - Claude Code: "Save user's collapse state to localStorage"

**FRs Covered:** Trade-off Decision: Collapsible "Why This Matters"

**Story Points:** 3
**Dependencies:** Story 7.1

---

### Story 7.3: "Why This Matters" Edit and Regenerate

**As a** manager
**I want to** edit or regenerate "Why This Matters"
**So that** I can customize the message

**Acceptance Criteria:**
- [ ] "Edit" button next to "Why This Matters" (FR8)
- [ ] Clicking shows textarea with current text
- [ ] User can edit and save
- [ ] "Regenerate" button calls n8n workflow again (FR70)
- [ ] Regeneration replaces existing text (confirmation shown)
- [ ] Max 3 regenerations (same limit as task regeneration) (FR87)

**Technical Implementation (No-Code):**
- **Frontend (v0.dev + Claude Code):**
  - v0.dev: "Add edit textarea and Regenerate button"
  - Claude Code: "Track regeneration count, call n8n webhook"

- **Database:**
  ```sql
  ALTER TABLE briefs ADD COLUMN why_matters_regen_count int DEFAULT 0;
  ```

**FRs Covered:** FR8, FR70, FR87

**Story Points:** 5
**Dependencies:** Story 7.1

---

### Story 7.4: "Why This Matters" Visibility to Team

**As a** team member
**I want to** see "Why This Matters" in my task inbox
**So that** I understand the business context

**Acceptance Criteria:**
- [ ] "Why This Matters" shown in task detail view (for team members)
- [ ] Also shown in brief header when viewing brief
- [ ] Optional: Show snippet in "My Tasks" card hover tooltip
- [ ] Team members can expand/collapse (same as manager)

**Technical Implementation (No-Code):**
- **Frontend (Claude Code):**
  - Prompt: "Show brief.why_matters in task detail and brief header"

**FRs Covered:** FR8 (team visibility)

**Story Points:** 2
**Dependencies:** Story 7.1

---

**Epic 7 Summary:**
- **Total Stories:** 4
- **Total Story Points:** 18
- **Timeline:** Week 5 (5 working days)
- **FRs Covered:** 4 FRs (FR8, FR70, FR87, Trade-off Decisions)

---

## 5.4 Implementation Timeline Summary

### Week 1: Brief Creation and AI Task Generation (Epic 1)
- **Stories:** 8 stories (Story 1.1 - 1.8)
- **Story Points:** 41
- **FRs:** 20 FRs
- **Key Deliverables:**
  - Basic brief creation form
  - AI task breakdown via n8n + OpenRouter
  - Progressive task confirmation
  - Brief templates
  - Settings page (task limit config)

---

### Week 2: Task Management + AI Agents (Epic 2 + Epic 3)
- **Stories:** 15 stories (Story 2.1 - 2.10, Story 3.1 - 3.5)
- **Story Points:** 71
- **FRs:** 35 FRs
- **Key Deliverables:**
  - Task assignment and status tracking
  - Team member task inbox
  - Due dates and progress tracking
  - Task output submission
  - Priority system and bulk actions
  - AI agent accounts
  - AI task queuing and batch execution
  - AI error handling

---

### Week 3: Review Workflow + Collaboration (Epic 4 + Epic 5)
- **Stories:** 11 stories (Story 4.1 - 4.6, Story 5.1 - 5.5)
- **Story Points:** 62
- **FRs:** 20 FRs
- **Key Deliverables:**
  - Manager review interface (Accept/Reject)
  - Rework cycle tracking
  - Version history and comparison
  - Brief completion and archiving
  - Task comments with @mentions
  - Notification system with preferences
  - Presence indicators
  - Activity feed

---

### Week 4: Search and Navigation (Epic 6)
- **Stories:** 4 stories (Story 6.1 - 6.4)
- **Story Points:** 20
- **FRs:** 4 FRs
- **Key Deliverables:**
  - PostgreSQL full-text search
  - Search scope controls and filters
  - Dashboard navigation optimization
  - Archived brief filtering

---

### Week 5: "Why This Matters" Feature (Epic 7)
- **Stories:** 4 stories (Story 7.1 - 7.4)
- **Story Points:** 18
- **FRs:** 4 FRs
- **Key Deliverables:**
  - AI-generated "Why This Matters"
  - Collapsible UI with user preference
  - Edit and regenerate functionality
  - Team visibility and context

---

## 5.5 Story Point Distribution

**Total Story Points:** 212

| Epic | Stories | Story Points | % of Total |
|------|---------|--------------|------------|
| Epic 1: Brief Creation | 8 | 41 | 19% |
| Epic 2: Task Management | 10 | 45 | 21% |
| Epic 3: AI Agents | 5 | 26 | 12% |
| Epic 4: Review Workflow | 6 | 31 | 15% |
| Epic 5: Collaboration | 5 | 31 | 15% |
| Epic 6: Search | 4 | 20 | 9% |
| Epic 7: Why This Matters | 4 | 18 | 8% |

**Average Velocity Required:** 42 story points/week (assuming 5-week timeline)

---

## 5.6 Dependency Map

```
Epic 1 (Week 1)
  └─> Epic 2 (Week 2) - Depends on tasks existing
       ├─> Epic 3 (Week 2) - AI agents concurrent with task management
       └─> Epic 4 (Week 3) - Depends on task output submission
            └─> Epic 5 (Week 3) - Collaboration concurrent with review
                 └─> Epic 6 (Week 4) - Search needs all entities created
                      └─> Epic 7 (Week 5) - "Why This Matters" final layer
```

**Critical Path:** Epic 1 → Epic 2 → Epic 4 → Epic 7 (19 + 21 + 15 + 8 = 63% of work)

---

## 5.7 Risk Mitigation in Stories

**Risk 1.1: AI Task Quality (High)**
- **Mitigation in Stories:**
  - Story 1.5: Max 3 regeneration attempts (FR87)
  - Story 1.3: Progressive confirmation (FR69)
  - Story 3.4: Full context window management (FR63-FR64)

**Risk 1.2: Progress Update Friction (High)**
- **Mitigation in Stories:**
  - Story 2.5: Optional progress tracking per brief (Decision Q1-C)
  - Story 5.5: Activity feed shows updates (FR106)

**Risk 3.2: Rejection Demotivation (High)**
- **Mitigation in Stories:**
  - Story 4.2: Constructive rejection feedback required (FR41, FR59)
  - Story 5.1: Task comments for clarification (FR93)
  - Story 7.1-7.4: "Why This Matters" for motivation (FR8)

**Risk 5.1: Concurrent Edit Conflicts (Medium)**
- **Mitigation in Stories:**
  - Story 5.4: Presence indicators (Decision Q8-A)
  - Polling with `updated_at` timestamps

---

## 5.8 No-Code Implementation Notes

**All stories follow no-code implementation pattern:**

1. **Frontend:** v0.dev (Figma → React) + Claude Code (Supabase integration) + GitHub Copilot (autocomplete)
2. **Backend:** n8n visual workflows (NO TypeScript coding)
3. **Database:** Supabase auto-generated APIs + RLS policies (copy-paste SQL)
4. **AI:** OpenRouter via n8n HTTP Request nodes
5. **Deployment:** Vercel (auto-deploy) + Railway (n8n hosting)

**User's Requirement Met:** "I don't know any coding" + "Fully No-Code for MVP" ✅

---

## 5.9 Success Metrics per Epic

### Epic 1: Brief Creation
- **Success Metric:** 80%+ of briefs generate satisfactory tasks on first try
- **Measurement:** Track regeneration rate (FR70 counter)

### Epic 2: Task Management
- **Success Metric:** 90%+ of assigned tasks reach "Done" status within 7 days
- **Measurement:** Task completion rate by status and due date

### Epic 3: AI Agents
- **Success Metric:** <10% AI task failure rate
- **Measurement:** Track error rate from n8n workflows (FR67)

### Epic 4: Review Workflow
- **Success Metric:** <2 rework cycles average per task
- **Measurement:** Track `rework_cycle` field (FR89)

### Epic 5: Collaboration
- **Success Metric:** 50%+ of tasks have ≥1 comment
- **Measurement:** Count tasks with comments (FR93)

### Epic 6: Search
- **Success Metric:** Search used 3+ times per user per week
- **Measurement:** Log search query count

### Epic 7: "Why This Matters"
- **Success Metric:** 70%+ of team members read "Why This Matters"
- **Measurement:** Track collapsible expand events

---

## 5.10 Post-MVP Backlog (Deferred Features)

**From User Decisions:**
- Dark mode (Decision Q11-B) - Defer to post-MVP
- Mobile gestures (Decision Q12-C) - Defer to post-MVP
- Brief-level discussions (FR96) - Defer to post-MVP
- Daily check-in prompts (FR97) - Defer to post-MVP
- Inline comments on outputs (FR98) - Defer to post-MVP

**From Trade-off Analysis:**
- Kanban view (alternative to Linear List) - Post-MVP
- Real-time WebSockets (migrate from polling at >50 users) - Post-MVP

**From Technical Constraints:**
- Algolia search (migrate at 10K briefs) - Post-MVP
- Resend email (migrate at 50 emails/hour) - Post-MVP

---

**Section 5 Complete - Epic and Story Structure Defined**

**Next Steps:**
1. Review and approve story breakdown
2. Assign story owners
3. Begin Week 1 implementation (Epic 1)
4. Set up n8n workflows based on TC5-TC7 specifications
