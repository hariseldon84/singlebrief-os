# SingleBrief - New Scope: Dashboard & Settings Epics

**Date:** 2025-10-07
**Version:** 1.1
**Status:** Proposal
**Document Type:** Epic Gap Analysis & Recommendation

---

## Executive Summary

This document identifies critical gaps in the current 8-epic structure and proposes **2 new epics** to address missing Dashboard, Profile, Settings, and Help functionality essential for manager confidence and user experience.

**Recommendation:** Add **Epic 9 (Manager Command Center)** and **Epic 10 (User Settings & Profile Management)** to create a complete MVP.

---

## Table of Contents

1. [Discovery Analysis](#1-discovery-analysis)
2. [Strategic Recommendation](#2-strategic-recommendation)
3. [Epic 9: Manager Command Center](#3-epic-9-manager-command-center)
4. [Epic 10: User Settings & Profile Management](#4-epic-10-user-settings--profile-management)
5. [Notification Settings Architecture](#5-notification-settings-architecture)
6. [Implementation Plan](#6-implementation-plan)
7. [Revised Epic Structure](#7-revised-epic-structure)
8. [Impact Analysis](#8-impact-analysis)

---

## 1. Discovery Analysis

### 1.1 Current State (8 Epics)

**Existing Epic Structure:**
1. Brief Creation & AI Task Generation
2. Task Management & Assignment
3. AI Agent Task Execution
4. Manager Review & Output Management
5. Communication & Collaboration
6. Search, Navigation & Bulk Actions
7. "Why This Matters" & Business Value Framing
8. Authentication & Security

**Total:** 111 Core FRs + 17 Auth FRs = **128 FRs**, **42 stories**, **220 story points**

---

### 1.2 Critical Gaps Identified

#### **Gap 1: Dashboard (Scattered, No Unified Vision)**

**Current State:**
- Brief list in Epic 1 (creation focus, not action center)
- Task inbox in Epic 2 (team member view only)
- Activity feed in Epic 5 (passive timeline, not actionable)

**Missing:**
- ❌ **Manager action center** with visual cues (overdue tasks, pending reviews, queued AI tasks)
- ❌ **Periodic reminders** with in-app visual indicators (badges, banners)
- ❌ **Summary analytics** (brief completion %, team velocity, task distribution)
- ❌ **Quick actions** (one-click "Review Outputs," "Execute AI Tasks")
- ❌ **Team member dashboard** (role-specific view with due tasks, blocked items)

**User Pain Point:**
> "As a manager, information is scattered. I need actions at one go with visual cues prompting me and my team to take action."

---

#### **Gap 2: Profile & Settings (Incomplete, Scattered)**

**Current State:**
- User settings in Epic 2 (Story 1.8: Task limit configuration only)
- Notification preferences in Epic 5 (Story 5.3: Basic email ON/OFF, DND hours, per-brief mute)

**Missing:**
- ❌ **Unified profile management** (name, avatar, role, bio)
- ❌ **Granular notification settings** for **email + in-app** (8 notification types)
- ❌ **Account preferences** (timezone, language, consolidated settings)
- ❌ **Help & Support** integration (documentation, FAQs, contact support)

**User Requirement:**
> "We need notification settings for emails and in-app."

---

#### **Gap 3: Help (Not Addressed)**

**Current State:**
- Minimal onboarding (Epic 2, Story 2.10: Welcome modal only)
- No help documentation, support resources, or guided walkthroughs

**Missing:**
- ❌ **Help documentation** (getting started guide, FAQs)
- ❌ **Support resources** (contact support, product tour)
- ❌ **Guided walkthroughs** (re-trigger onboarding)

**User Requirement:**
> "Help needs to be separate documentation."

---

### 1.3 Why Current Epics Don't Address This

| Feature | Current Coverage | Why Insufficient |
|---------|------------------|------------------|
| **Dashboard** | Epic 6 (Search & Navigation) | Epic 6 is about **finding things**, not **taking action**. No visual cues, reminders, or analytics. |
| **Profile** | Epic 8 (Auth) | Auth focuses on **security**, not user preferences or personalization. |
| **Settings** | Scattered (Epic 2, Epic 5) | No centralized location. Notification settings lack granularity (email + in-app). |
| **Help** | Epic 2 (Onboarding) | Welcome modal is **not** documentation or support. |

**Conclusion:** Dashboard and Settings require **dedicated epics** because they are **primary interaction surfaces** that synthesize data from all other epics.

---

## 2. Strategic Recommendation

### 2.1 Create 2 New Epics (Jobs-to-be-Done Framework)

| Epic | Job-to-be-Done | User Need |
|------|----------------|-----------|
| **Epic 9: Manager Command Center** | "When I open SingleBrief, I need to quickly see what requires my attention and get a pulse on team progress, so that I can take action without hunting through multiple views." | **Manager**: Reduce cognitive load, prioritize actions, visual cues for periodic reminders |
| **Epic 10: User Settings & Profile Management** | "When I want to control how I interact with SingleBrief, I need a centralized place to manage my profile, notification preferences, and account settings, so that the system works the way I prefer." | **Manager + Team Member**: Personalization, notification control (email + in-app), help access |

---

### 2.2 Rationale for Separate Epics

#### **Why Epic 9 (Dashboard) is Not Part of Epic 6 (Search & Navigation)**

**Epic 6 Focus:** Finding things (search, filters, archived briefs)
**Epic 9 Focus:** Taking action (visual cues, reminders, quick actions, analytics)

**Evidence:** Dashboard is the **primary interaction surface**. It's not just navigation but an **intelligent action hub** that:
- Synthesizes data from Epics 1-7 (briefs, tasks, reviews, AI execution)
- Requires visual design for action prioritization (not covered in Epic 6)
- Provides analytics and periodic reminders (distinct from search functionality)

---

#### **Why Epic 10 (Settings) is Not Part of Epic 2 or Epic 5**

**Epic 2 Focus:** Task management workflows (assignment, status, execution)
**Epic 5 Focus:** Team collaboration (comments, notifications, presence)
**Epic 10 Focus:** User-level configuration and preferences (cross-cutting all epics)

**Evidence:** Settings affect **every other epic**:
- Notification settings impact Epic 5 (Collaboration)
- Profile impacts Epic 8 (Auth) and Epic 5 (Comments, Activity)
- Task limit setting (Story 1.8) is configuration, not task management
- Help & Support is a utility feature accessed from all contexts

**Decision:** Consolidate all user-level settings into one epic for coherent UX.

---

### 2.3 What About "Help"?

**Recommendation:** Make Help a **component within Epic 10** (Story 10.3), not a separate epic.

**Rationale:**
- Help is accessed infrequently (documentation, FAQs, support)
- It's a **utility feature**, not a workflow (like Brief Creation or Review)
- Including it in Settings keeps epic count focused (9 → 10 epics, not 11)
- Help is naturally discovered in Settings (standard UX pattern)

---

## 3. Epic 9: Manager Command Center

### 3.1 Epic Overview

**Epic Goal:** Centralized action hub for managers to see visual cues, take immediate action, and track team progress.

**Timeline:** Week 4-5 (4 stories, ~24 story points)
**Priority:** **P0 (Must Have)** - Dashboard is critical for manager confidence
**Dependencies:** Epics 1-6 must be complete (needs data from briefs, tasks, reviews)

**Key Deliverables:**
- Manager action center widget (pending reviews, overdue tasks, queued AI tasks)
- Summary analytics dashboard (brief completion %, team velocity)
- Periodic reminder system (in-app banners, badges)
- Team member dashboard view (role-specific action items)

---

### 3.2 User Stories

#### **Story 9.1: Manager Action Center Widget**

**As a** manager
**I want** a dashboard widget showing items requiring my attention
**So that** I can prioritize actions without navigating multiple views

**Acceptance Criteria:**
- [ ] Widget displays 3 action categories with counts:
  - **Pending Reviews** (tasks with status='Done', awaiting accept/reject)
  - **Overdue Tasks** (tasks past due_date, status != 'Accepted')
  - **Queued AI Tasks** (tasks with status='Queued', assignee is AI agent)
- [ ] Visual cues with color-coded badges:
  - Red badge for overdue tasks (urgent)
  - Yellow badge for due today (warning)
  - Blue badge for queued AI tasks (informational)
- [ ] One-click actions:
  - "Review Now" → Navigate to Epic 4 Review tab
  - "Execute AI Tasks" → Open Epic 3 FAB confirmation dialog
  - "View Overdue" → Filter task list to show overdue items
- [ ] Widget updates every 30 seconds (polling, consistent with Epic 5)
- [ ] Empty state message: "Great work! No pending actions." (when all counts = 0)

**Technical Implementation (No-Code):**
- **Frontend (v0.dev + Claude Code):**
  - v0.dev: "Create dashboard widget with 3 stat cards (Pending Reviews, Overdue, Queued AI) with badges and CTA buttons"
  - Claude Code: "Query Supabase for counts, add click handlers for navigation"

- **Database Queries:**
  ```sql
  -- Pending Reviews (manager view)
  SELECT COUNT(*) FROM tasks
  WHERE status = 'Done'
  AND brief_id IN (SELECT id FROM briefs WHERE user_id = current_user_id);

  -- Overdue Tasks
  SELECT COUNT(*) FROM tasks
  WHERE due_date < NOW()
  AND status NOT IN ('Accepted', 'Archived')
  AND brief_id IN (SELECT id FROM briefs WHERE user_id = current_user_id);

  -- Queued AI Tasks
  SELECT COUNT(*) FROM tasks
  WHERE status = 'Queued'
  AND assigned_to IN (SELECT id FROM auth.users WHERE is_ai_agent = true)
  AND brief_id IN (SELECT id FROM briefs WHERE user_id = current_user_id);
  ```

**FRs Covered:** FR129-FR131 (new)

**Story Points:** 8
**Dependencies:** Epic 2 (tasks exist), Epic 3 (AI queuing), Epic 4 (review workflow)

---

#### **Story 9.2: Summary Analytics Dashboard**

**As a** manager
**I want** a high-level view of brief completion and team velocity
**So that** I can track progress without detailed reports

**Acceptance Criteria:**
- [ ] Analytics section displays 4 summary cards:
  - **Active Briefs** (#) - Count of briefs with status='active'
  - **Total Tasks** (#) - Sum of tasks across all active briefs
  - **Completion Rate** (%) - (Accepted tasks / Total tasks) * 100
  - **Tasks Due This Week** (#) - Tasks with due_date in next 7 days
- [ ] Brief completion chart (below summary cards):
  - List of active briefs with progress bars
  - Progress bar: (Accepted tasks / Total tasks in brief) * 100
  - Sorted by completion % (ascending, show incomplete briefs first)
  - Click brief title → Navigate to brief detail
- [ ] Optional: "View Full Analytics" link (deferred to post-MVP)
  - Link shown but disabled with tooltip: "Coming in v2"
- [ ] Analytics update every 30 seconds (polling)

**Technical Implementation (No-Code):**
- **Frontend (v0.dev + Claude Code):**
  - v0.dev: "Create analytics dashboard with 4 stat cards and brief progress chart"
  - Claude Code: "Query Supabase for aggregations, calculate percentages"

- **Database Queries:**
  ```sql
  -- Active Briefs
  SELECT COUNT(*) FROM briefs WHERE status = 'active' AND user_id = current_user_id;

  -- Total Tasks
  SELECT COUNT(*) FROM tasks
  WHERE brief_id IN (SELECT id FROM briefs WHERE user_id = current_user_id AND status = 'active');

  -- Completion Rate
  SELECT
    (COUNT(*) FILTER (WHERE status = 'Accepted') * 100.0 / COUNT(*)) AS completion_rate
  FROM tasks
  WHERE brief_id IN (SELECT id FROM briefs WHERE user_id = current_user_id AND status = 'active');

  -- Tasks Due This Week
  SELECT COUNT(*) FROM tasks
  WHERE due_date BETWEEN NOW() AND NOW() + INTERVAL '7 days'
  AND brief_id IN (SELECT id FROM briefs WHERE user_id = current_user_id);

  -- Brief Progress
  SELECT
    b.id,
    b.title,
    COUNT(*) AS total_tasks,
    COUNT(*) FILTER (WHERE t.status = 'Accepted') AS accepted_tasks,
    (COUNT(*) FILTER (WHERE t.status = 'Accepted') * 100.0 / COUNT(*)) AS progress_percent
  FROM briefs b
  JOIN tasks t ON t.brief_id = b.id
  WHERE b.user_id = current_user_id AND b.status = 'active'
  GROUP BY b.id, b.title
  ORDER BY progress_percent ASC;
  ```

**FRs Covered:** FR132-FR133 (new)

**Story Points:** 5
**Dependencies:** Epic 1 (briefs exist), Epic 2 (tasks exist), Epic 4 (acceptance tracking)

---

#### **Story 9.3: Periodic Reminder System**

**As a** manager
**I want** periodic in-app reminders for pending actions
**So that** I don't forget critical reviews or AI tasks

**Acceptance Criteria:**
- [ ] In-app banner notification (non-intrusive, dismissible):
  - Shown at top of dashboard when action items exist
  - Message: "You have 3 pending reviews and 2 queued AI tasks" (dynamic count)
  - Actions: "Review Now" (navigate to Review tab), "Dismiss" (close banner)
- [ ] Banner trigger conditions:
  - Daily at 9am (if pending reviews > 0 OR overdue tasks > 0)
  - When queued AI tasks exist for >24 hours (matching Epic 3 Story 3.2 email reminder)
- [ ] Persistent badge on "Dashboard" navigation link:
  - Red badge with count of total action items (pending reviews + overdue tasks + queued AI)
  - Badge updates every 30 seconds (polling)
  - Badge removed when count = 0
- [ ] Banner dismissal:
  - User can dismiss banner (hidden until next trigger condition)
  - Dismissal state stored in `user_settings` (per-session, not permanent)

**Technical Implementation (No-Code):**
- **Frontend (v0.dev + Claude Code):**
  - v0.dev: "Create dismissible banner with action buttons and navigation badge"
  - Claude Code: "Add banner trigger logic, badge count calculation, dismissal state"

- **n8n Workflow (Daily Reminder):**
  - Trigger: Cron (daily at 9am)
  - Supabase query: Users with pending reviews OR overdue tasks
  - Insert in-app notification into `notifications` table
  - Email notification (reuse Epic 5 Story 5.2 workflow)

- **Database:**
  ```sql
  -- Banner trigger condition
  SELECT
    (SELECT COUNT(*) FROM tasks WHERE status = 'Done' AND brief_id IN (SELECT id FROM briefs WHERE user_id = current_user_id)) AS pending_reviews,
    (SELECT COUNT(*) FROM tasks WHERE due_date < NOW() AND status NOT IN ('Accepted', 'Archived') AND brief_id IN (SELECT id FROM briefs WHERE user_id = current_user_id)) AS overdue_tasks,
    (SELECT COUNT(*) FROM tasks WHERE status = 'Queued' AND assigned_to IN (SELECT id FROM auth.users WHERE is_ai_agent = true) AND brief_id IN (SELECT id FROM briefs WHERE user_id = current_user_id)) AS queued_ai;

  -- Badge count = pending_reviews + overdue_tasks + queued_ai
  ```

**FRs Covered:** FR134 (new)

**Story Points:** 5
**Dependencies:** Epic 2 (tasks), Epic 3 (AI queuing), Epic 4 (reviews), Epic 5 (notifications)

---

#### **Story 9.4: Team Member Dashboard View**

**As a** team member
**I want** a dashboard showing my assigned tasks and due items
**So that** I know what to work on next

**Acceptance Criteria:**
- [ ] Team member dashboard (distinct from manager view):
  - Widget: "My Tasks" summary with counts:
    - **To-Do** (#) - Tasks with status='To-Do'
    - **In-Progress** (#) - Tasks with status='In-Progress'
    - **Due Today** (#) - Tasks with due_date = today
    - **Overdue** (#) - Tasks past due_date
  - Quick filters (buttons): "Due Today," "High Priority," "All Tasks"
  - Task list preview (top 5 tasks, sorted by due date)
- [ ] One-click action: "Start Task" button on To-Do tasks
  - Clicking changes status to 'In-Progress'
  - Triggers due date picker (from Epic 2 Story 2.4)
- [ ] Visual cues:
  - Red indicator for overdue tasks
  - Yellow indicator for due today
  - Priority badges (High, Medium, Low) from Epic 2 Story 2.7
- [ ] Dashboard updates every 30 seconds (polling)

**Technical Implementation (No-Code):**
- **Frontend (v0.dev + Claude Code):**
  - v0.dev: "Create team member dashboard with task summary widget and quick filters"
  - Claude Code: "Query tasks where assigned_to = current_user, add 'Start Task' button handler"

- **Database Queries:**
  ```sql
  -- My Tasks Summary
  SELECT
    COUNT(*) FILTER (WHERE status = 'To-Do') AS todo_count,
    COUNT(*) FILTER (WHERE status = 'In-Progress') AS in_progress_count,
    COUNT(*) FILTER (WHERE due_date::date = CURRENT_DATE) AS due_today_count,
    COUNT(*) FILTER (WHERE due_date < NOW() AND status NOT IN ('Accepted', 'Archived')) AS overdue_count
  FROM tasks
  WHERE assigned_to = current_user_id;

  -- Task List Preview (top 5, sorted by due date)
  SELECT * FROM tasks
  WHERE assigned_to = current_user_id
  AND status NOT IN ('Accepted', 'Archived')
  ORDER BY due_date ASC NULLS LAST, priority DESC
  LIMIT 5;
  ```

**FRs Covered:** FR135 (new)

**Story Points:** 5
**Dependencies:** Epic 2 (tasks, assignment, status, priority)

---

### 3.3 Epic 9 Summary

- **Total Stories:** 4
- **Total Story Points:** 23
- **Timeline:** Week 4-5 (5 working days)
- **FRs Covered:** 7 new FRs (FR129-FR135)
- **Priority:** P0 (Must Have)

**Key Dependencies:**
- Epic 1: Briefs must exist
- Epic 2: Tasks, assignment, status tracking
- Epic 3: AI queuing system
- Epic 4: Review workflow (accept/reject)
- Epic 5: Notifications infrastructure

---

## 4. Epic 10: User Settings & Profile Management

### 4.1 Epic Overview

**Epic Goal:** Unified profile and notification settings for personalized user experience.

**Timeline:** Week 2 (Stories 10.1-10.2) + Week 5 (Stories 10.3-10.4) (~19 story points)
**Priority:** **P1 (Should Have)** - Notification settings are MVP, profile can be basic
**Dependencies:** Epic 8 (Auth) must be complete

**Key Deliverables:**
- Profile management (name, avatar, role, bio)
- Granular notification settings (email + in-app, 8 notification types)
- Help & Support integration (documentation, FAQs, contact support)
- Account preferences consolidation (task limit, timezone, language)

---

### 4.2 User Stories

#### **Story 10.1: Profile Management**

**As a** user
**I want** to manage my profile information
**So that** my identity is accurate across the system

**Acceptance Criteria:**
- [ ] Settings page accessible from user menu (top-right avatar dropdown)
- [ ] Settings page has "Profile" tab (first tab)
- [ ] Profile form fields:
  - **Name** (text input, required, max 100 chars)
  - **Email** (read-only, pre-filled from Supabase Auth)
  - **Avatar** (image upload, 2MB limit, 400x400px recommended)
  - **Role** (dropdown: Manager, Team Member, default: Manager)
  - **Bio** (textarea, optional, max 500 chars)
- [ ] "Save Changes" button updates `profiles` table in Supabase
- [ ] Avatar upload uses Supabase Storage (bucket: `avatars`)
- [ ] Avatar shown in:
  - Navigation header (top-right)
  - Task assignments (assignee avatar)
  - Comments (user avatar)
  - Activity feed (user avatar)
- [ ] Success toast: "Profile updated successfully"
- [ ] Error handling: Show validation errors inline

**Technical Implementation (No-Code):**
- **Database:**
  ```sql
  CREATE TABLE profiles (
    user_id uuid PRIMARY KEY REFERENCES auth.users(id),
    name text NOT NULL CHECK (length(name) <= 100),
    avatar_url text,
    role text DEFAULT 'Manager' CHECK (role IN ('Manager', 'Team Member')),
    bio text CHECK (length(bio) <= 500),
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
  );

  -- RLS Policy
  CREATE POLICY "Users can view all profiles"
  ON profiles FOR SELECT TO authenticated USING (true);

  CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE TO authenticated USING (user_id = auth.uid());
  ```

- **Frontend (v0.dev + Claude Code):**
  - v0.dev: "Create settings page with Profile tab, form fields, avatar upload"
  - Claude Code: "Add Supabase profile query/update, Supabase Storage avatar upload"

- **Supabase Storage:**
  - Bucket: `avatars` (public, 2MB file size limit)
  - File naming: `{user_id}.{extension}` (overwrites on update)

**FRs Covered:** FR136-FR137 (new)

**Story Points:** 5
**Dependencies:** Epic 8 (Auth - users exist)

---

#### **Story 10.2: Notification Settings (Email + In-App)**

**As a** user
**I want** granular control over email and in-app notifications
**So that** I receive alerts only for what matters to me

**Acceptance Criteria:**
- [ ] Settings page has "Notifications" tab (second tab)
- [ ] Master toggles (top of page):
  - **Email Notifications** (ON/OFF, default: ON)
  - **In-App Notifications** (ON/OFF, default: ON)
- [ ] Granular notification type toggles (8 types):

  **Email Settings:**
  - [✓] Task Assigned
  - [✓] Output Submitted (Manager only)
  - [✓] Task Accepted
  - [✓] Task Rejected (Team Member only)
  - [✓] @Mention in Comments
  - [✓] AI Tasks Completed (Manager only)
  - [ ] Overdue Task Reminder (Daily digest)
  - [ ] Queued AI Tasks Reminder (24h delay)

  **In-App Settings:**
  - [✓] Task Assigned
  - [✓] Output Submitted
  - [✓] Task Accepted
  - [✓] Task Rejected
  - [✓] @Mention in Comments
  - [✓] AI Tasks Completed
  - [✓] Overdue Task Reminder
  - [✓] Queued AI Tasks Reminder

- [ ] Do Not Disturb (DND) section:
  - Start time picker (default: 9:00 PM)
  - End time picker (default: 9:00 AM)
  - Description: "No email notifications will be sent during these hours"
- [ ] Per-Brief Notification Settings:
  - "Mute Specific Briefs" section
  - Dropdown to select brief → Click "Mute" → Brief added to mute list
  - Muted briefs shown with "Unmute" button
- [ ] "Save Changes" button updates `user_settings` + `user_brief_mutes` tables
- [ ] Settings saved per user (persisted in database)
- [ ] n8n workflows check settings before sending notifications (email + in-app)

**Technical Implementation (No-Code):**
- **Database:**
  ```sql
  -- Expand user_settings table (from Epic 2 Story 1.8)
  ALTER TABLE user_settings ADD COLUMN email_notifications_enabled boolean DEFAULT true;
  ALTER TABLE user_settings ADD COLUMN inapp_notifications_enabled boolean DEFAULT true;
  ALTER TABLE user_settings ADD COLUMN notify_task_assigned_email boolean DEFAULT true;
  ALTER TABLE user_settings ADD COLUMN notify_task_assigned_inapp boolean DEFAULT true;
  ALTER TABLE user_settings ADD COLUMN notify_output_submitted_email boolean DEFAULT true;
  ALTER TABLE user_settings ADD COLUMN notify_output_submitted_inapp boolean DEFAULT true;
  ALTER TABLE user_settings ADD COLUMN notify_task_accepted_email boolean DEFAULT true;
  ALTER TABLE user_settings ADD COLUMN notify_task_accepted_inapp boolean DEFAULT true;
  ALTER TABLE user_settings ADD COLUMN notify_task_rejected_email boolean DEFAULT true;
  ALTER TABLE user_settings ADD COLUMN notify_task_rejected_inapp boolean DEFAULT true;
  ALTER TABLE user_settings ADD COLUMN notify_mention_email boolean DEFAULT true;
  ALTER TABLE user_settings ADD COLUMN notify_mention_inapp boolean DEFAULT true;
  ALTER TABLE user_settings ADD COLUMN notify_ai_completed_email boolean DEFAULT true;
  ALTER TABLE user_settings ADD COLUMN notify_ai_completed_inapp boolean DEFAULT true;
  ALTER TABLE user_settings ADD COLUMN notify_overdue_email boolean DEFAULT false;
  ALTER TABLE user_settings ADD COLUMN notify_overdue_inapp boolean DEFAULT true;
  ALTER TABLE user_settings ADD COLUMN notify_queued_ai_email boolean DEFAULT false;
  ALTER TABLE user_settings ADD COLUMN notify_queued_ai_inapp boolean DEFAULT true;
  ALTER TABLE user_settings ADD COLUMN dnd_start_hour int DEFAULT 21; -- 9pm
  ALTER TABLE user_settings ADD COLUMN dnd_end_hour int DEFAULT 9; -- 9am

  -- Per-brief mutes (from Epic 5 Story 5.3)
  CREATE TABLE user_brief_mutes (
    user_id uuid REFERENCES auth.users(id),
    brief_id uuid REFERENCES briefs(id),
    PRIMARY KEY (user_id, brief_id)
  );
  ```

- **Frontend (v0.dev + Claude Code):**
  - v0.dev: "Create notifications settings tab with master toggles, granular toggles, DND pickers, per-brief mute section"
  - Claude Code: "Add Supabase query/update for user_settings, user_brief_mutes"

- **n8n Workflow Updates (All Notification Workflows):**
  - Before sending email or in-app notification:
    1. Fetch user_settings for recipient
    2. Check: `email_notifications_enabled = true` (for email)
    3. Check: `inapp_notifications_enabled = true` (for in-app)
    4. Check: Specific toggle (e.g., `notify_task_assigned_email = true`)
    5. Check: Current hour not in DND range (for email only)
    6. Check: Brief not in `user_brief_mutes` for user
    7. If all checks pass → Send notification

**FRs Covered:** FR138-FR140 (new), consolidates Epic 5 Story 5.3

**Story Points:** 8
**Dependencies:** Epic 5 (Notifications infrastructure), Epic 8 (Auth)

---

#### **Story 10.3: Help & Support Integration**

**As a** user
**I want** easy access to help documentation and support
**So that** I can resolve issues without external communication

**Acceptance Criteria:**
- [ ] Settings page has "Help & Support" tab (third tab)
- [ ] Tab contains 4 sections:

  **1. Getting Started Guide**
  - Button: "View Getting Started Guide"
  - Clicking re-triggers onboarding modal (from Epic 2 Story 2.10)

  **2. FAQ**
  - Accordion with 5-7 common questions:
    - "How do I create a brief?"
    - "How do I assign tasks to AI agents?"
    - "How do I review task outputs?"
    - "How do I customize notification settings?"
    - "How do I invite team members?"
  - Each question expands to show answer (hardcoded in frontend initially)

  **3. Contact Support**
  - Text: "Need help? Contact us at support@singlebrief.ai"
  - Button: "Email Support" (opens mailto: link)

  **4. Product Tour**
  - Button: "Take Product Tour"
  - Clicking re-triggers onboarding modal (same as Getting Started)

- [ ] Navigation footer or header has "Help" link with ? icon
  - Clicking navigates to Settings → Help & Support tab

**Technical Implementation (No-Code):**
- **Frontend (v0.dev + Claude Code):**
  - v0.dev: "Create Help & Support tab with 4 sections (buttons, FAQ accordion, contact info)"
  - Claude Code: "Add navigation link, trigger onboarding modal on button click"

- **FAQ Data (Hardcoded in Frontend):**
  ```typescript
  const faqs = [
    {
      question: "How do I create a brief?",
      answer: "Click 'New Brief' in the dashboard, enter a title and description (500-5000 characters), then click 'Generate Tasks'. You can use templates to get started faster."
    },
    // ... 6 more FAQs
  ];
  ```

**FRs Covered:** FR141 (new)

**Story Points:** 3
**Dependencies:** Epic 2 (Onboarding modal exists)

---

#### **Story 10.4: Account Preferences Consolidation**

**As a** manager
**I want** all account preferences in one place
**So that** I can manage settings efficiently

**Acceptance Criteria:**
- [ ] Settings page has "Preferences" tab (fourth tab)
- [ ] Consolidate settings from Epic 2 Story 1.8:
  - **Default Task Limit** (slider, 5-50, default: 20)
  - Description: "Number of tasks AI generates per brief"
- [ ] New preference fields:
  - **Timezone** (dropdown, default: auto-detect from browser)
    - Options: All major timezones (UTC-12 to UTC+14)
  - **Language** (dropdown, default: English)
    - Options: English (MVP only, other languages post-MVP)
- [ ] "Save Changes" button updates `user_settings` table
- [ ] Success toast: "Preferences updated successfully"
- [ ] Remove Story 1.8 (Settings Page - Task Limit) from Epic 2 (consolidated here)

**Technical Implementation (No-Code):**
- **Database:**
  ```sql
  -- Already exists from Epic 2 Story 1.8
  ALTER TABLE user_settings ADD COLUMN timezone text DEFAULT 'UTC';
  ALTER TABLE user_settings ADD COLUMN language text DEFAULT 'en';
  ```

- **Frontend (v0.dev + Claude Code):**
  - v0.dev: "Create Preferences tab with slider, timezone dropdown, language dropdown"
  - Claude Code: "Auto-detect timezone from browser, add Supabase update"

**FRs Covered:** FR142 (new), consolidates Epic 2 Story 1.8

**Story Points:** 3
**Dependencies:** None

---

### 4.3 Epic 10 Summary

- **Total Stories:** 4
- **Total Story Points:** 19
- **Timeline:** Week 2 (Stories 10.1-10.2, 13 points) + Week 5 (Stories 10.3-10.4, 6 points)
- **FRs Covered:** 7 new FRs (FR136-FR142)
- **Priority:** P1 (Should Have)

**Key Dependencies:**
- Epic 8: Auth (user accounts must exist)
- Epic 5: Notifications (infrastructure for notification types)

**Consolidations:**
- Story 1.8 (Epic 2) → Absorbed into Story 10.4
- Story 5.3 (Epic 5) → Expanded into Story 10.2
- Story 2.10 (Epic 2) → Referenced in Story 10.3

---

## 5. Notification Settings Architecture

### 5.1 Current State vs. Proposed

**Currently in Epic 5 (Story 5.3):**
- Basic email notifications toggle (ON/OFF)
- DND hours (9pm - 9am)
- Per-brief mute (select brief to mute)

**Missing:**
- ❌ In-app notification toggles
- ❌ Granular control per notification type
- ❌ Separate email vs. in-app settings

---

### 5.2 Proposed Notification Types (8 Types)

| Notification Type | Trigger | Recipient | Email Default | In-App Default |
|-------------------|---------|-----------|---------------|----------------|
| **Task Assigned** | Task assigned to user | Assignee | ✓ ON | ✓ ON |
| **Output Submitted** | Team member completes task | Manager (brief owner) | ✓ ON | ✓ ON |
| **Task Accepted** | Manager accepts output | Assignee | ✓ ON | ✓ ON |
| **Task Rejected** | Manager rejects output | Assignee | ✓ ON | ✓ ON |
| **@Mention in Comments** | User mentioned in comment | Mentioned user | ✓ ON | ✓ ON |
| **AI Tasks Completed** | AI batch execution finishes | Manager (brief owner) | ✓ ON | ✓ ON |
| **Overdue Task Reminder** | Daily digest (9am) if tasks overdue | Task assignee | ✗ OFF | ✓ ON |
| **Queued AI Tasks** | AI tasks queued >24h | Manager (brief owner) | ✗ OFF | ✓ ON |

**Total:** 8 notification types × 2 channels (email + in-app) = **16 toggles**

---

### 5.3 Settings UI Design

```
┌─────────────────────────────────────────────────────┐
│ Notification Preferences                            │
├─────────────────────────────────────────────────────┤
│                                                     │
│ Master Controls                                     │
│ ─────────────────────────────────────────────────  │
│ [ ✓ ] Email Notifications        (Master Switch)   │
│ [ ✓ ] In-App Notifications       (Master Switch)   │
│                                                     │
│ Email Notification Types                            │
│ ─────────────────────────────────────────────────  │
│ [ ✓ ] Task Assigned                                │
│ [ ✓ ] Output Submitted                             │
│ [ ✓ ] Task Accepted                                │
│ [ ✓ ] Task Rejected                                │
│ [ ✓ ] @Mentions in Comments                        │
│ [ ✓ ] AI Tasks Completed                           │
│ [ ✗ ] Overdue Task Reminders (Daily Digest)        │
│ [ ✗ ] Queued AI Tasks (24h Reminder)               │
│                                                     │
│ In-App Notification Types                           │
│ ─────────────────────────────────────────────────  │
│ [ ✓ ] Task Assigned                                │
│ [ ✓ ] Output Submitted                             │
│ [ ✓ ] Task Accepted                                │
│ [ ✓ ] Task Rejected                                │
│ [ ✓ ] @Mentions in Comments                        │
│ [ ✓ ] AI Tasks Completed                           │
│ [ ✓ ] Overdue Task Reminders                       │
│ [ ✓ ] Queued AI Tasks                              │
│                                                     │
│ Do Not Disturb                                      │
│ ─────────────────────────────────────────────────  │
│ No email notifications during these hours:          │
│ Start: [9:00 PM] ▼   End: [9:00 AM] ▼             │
│                                                     │
│ Per-Brief Settings                                  │
│ ─────────────────────────────────────────────────  │
│ Mute specific briefs:                               │
│ [Select brief...          ▼] [ Mute ]              │
│                                                     │
│ Muted Briefs:                                       │
│ • Q1 2025 Marketing Campaign   [ Unmute ]          │
│ • Product Launch Brief         [ Unmute ]          │
│                                                     │
│                        [ Save Changes ]             │
└─────────────────────────────────────────────────────┘
```

---

### 5.4 n8n Workflow Logic

**Before Sending Any Notification:**

```javascript
// Fetch user settings
const settings = await supabase
  .from('user_settings')
  .select('*')
  .eq('user_id', recipient_user_id)
  .single();

// Check master switch
if (notification_channel === 'email' && !settings.email_notifications_enabled) {
  return; // Don't send
}
if (notification_channel === 'inapp' && !settings.inapp_notifications_enabled) {
  return; // Don't send
}

// Check specific toggle (e.g., task_assigned)
const toggle_field = `notify_${notification_type}_${notification_channel}`;
if (!settings[toggle_field]) {
  return; // Don't send
}

// Check DND hours (email only)
if (notification_channel === 'email') {
  const current_hour = new Date().getHours();
  if (current_hour >= settings.dnd_start_hour || current_hour < settings.dnd_end_hour) {
    return; // Don't send during DND
  }
}

// Check per-brief mute
const muted = await supabase
  .from('user_brief_mutes')
  .select('*')
  .eq('user_id', recipient_user_id)
  .eq('brief_id', brief_id)
  .single();
if (muted) {
  return; // Don't send, brief is muted
}

// All checks passed → Send notification
sendNotification(recipient_user_id, notification_type, notification_channel);
```

---

## 6. Implementation Plan

### 6.1 Revised Timeline (5 Weeks + 2 New Epics)

| Week | Epics | Stories | Story Points | Priority |
|------|-------|---------|--------------|----------|
| **Week 1** | Epic 1: Brief Creation | 8 | 41 | P0 |
| **Week 2** | Epic 2: Task Management<br>Epic 3: AI Agents<br>Epic 8: Authentication<br>**Epic 10 (Part 1): Profile + Notifications** | 10 + 5 + 2 + **2** = **19** | 45 + 26 + 8 + **13** = **92** | P0 + P1 |
| **Week 3** | Epic 4: Review Workflow<br>Epic 5: Collaboration | 6 + 5 = 11 | 31 + 31 = 62 | P0 + P1 |
| **Week 4** | **Epic 9: Dashboard**<br>Epic 6: Search & Navigation | **4** + 4 = **8** | **24** + 20 = **44** | P0 + P1 |
| **Week 5** | Epic 7: Why This Matters<br>**Epic 10 (Part 2): Help + Preferences** | 4 + **2** = **6** | 18 + **6** = **24** | P0 + P1 |

**Total Story Points:** 220 (original) + 24 (Epic 9) + 19 (Epic 10) = **263 points**

**Average Velocity Required:** 52 story points/week (up from 44/week)

---

### 6.2 Story Point Distribution

| Epic | Stories | Story Points | % of Total | Week |
|------|---------|--------------|------------|------|
| Epic 1: Brief Creation | 8 | 41 | 16% | 1 |
| Epic 2: Task Management | 10 | 45 | 17% | 2 |
| Epic 3: AI Agents | 5 | 26 | 10% | 2 |
| Epic 8: Authentication | 2 | 8 | 3% | 2 |
| **Epic 10 (Part 1)** | **2** | **13** | **5%** | **2** |
| Epic 4: Review Workflow | 6 | 31 | 12% | 3 |
| Epic 5: Collaboration | 5 | 31 | 12% | 3 |
| **Epic 9: Dashboard** | **4** | **24** | **9%** | **4** |
| Epic 6: Search | 4 | 20 | 8% | 4 |
| Epic 7: Why This Matters | 4 | 18 | 7% | 5 |
| **Epic 10 (Part 2)** | **2** | **6** | **2%** | **5** |
| **TOTAL** | **52** | **263** | **100%** | **5** |

---

### 6.3 Dependency Map

```
Epic 1 (Week 1)
  └─> Epic 2 (Week 2) - Tasks exist
       ├─> Epic 3 (Week 2) - AI agents concurrent
       ├─> Epic 8 (Week 2) - Auth concurrent
       └─> Epic 10 Part 1 (Week 2) - Profile + Notifications concurrent
            └─> Epic 4 (Week 3) - Review workflow
                 └─> Epic 5 (Week 3) - Collaboration concurrent
                      ├─> Epic 9 (Week 4) - Dashboard (needs all data)
                      └─> Epic 6 (Week 4) - Search concurrent
                           └─> Epic 7 (Week 5) - Why This Matters
                                └─> Epic 10 Part 2 (Week 5) - Help + Preferences concurrent
```

**Critical Path:** Epic 1 → Epic 2 → Epic 4 → Epic 9 → Epic 7 (16% + 17% + 12% + 9% + 7% = **61% of work**)

---

### 6.4 Risk Mitigation

**Risk 1: Week 2 Overload (92 Story Points)**

**Mitigation:**
- Epic 10 Part 1 (Stories 10.1-10.2) can run **parallel** with Epic 2/3/8
- Profile management (Story 10.1) has minimal dependencies (just Auth)
- Notification settings (Story 10.2) extends existing Epic 5 infrastructure

**Risk 2: Epic 9 Dependencies (Needs Epics 1-6)**

**Mitigation:**
- Schedule Epic 9 in Week 4 **after** Epic 4 (Review) and Epic 5 (Collaboration) complete
- Epic 9 runs **parallel** with Epic 6 (Search) - both are UI-focused, minimal conflicts

**Risk 3: Scope Creep (+42 Story Points)**

**Mitigation:**
- Both new epics are **P0-P1 priority** for MVP (Dashboard is critical for manager confidence)
- Notification settings are **user requirement** ("We need notification settings for emails and in-app")
- Help & Support (Story 10.3) is minimal (3 points, mostly hardcoded FAQs)

---

### 6.5 What Changes?

#### **Consolidations:**
1. **Epic 2 Story 1.8** (Settings Page - Task Limit) → Absorbed into **Epic 10 Story 10.4**
2. **Epic 5 Story 5.3** (Notification Preferences) → Expanded into **Epic 10 Story 10.2**
3. **Epic 2 Story 2.10** (Onboarding) → Referenced in **Epic 10 Story 10.3** (Help)

#### **Removals:**
- None (all original stories preserved or consolidated)

#### **Additions:**
- **Epic 9:** 4 new stories (23 points)
- **Epic 10:** 4 new stories (19 points)

#### **New Functional Requirements:**
- **FR129-FR135:** Dashboard action center, analytics, periodic reminders (7 FRs)
- **FR136-FR142:** Profile management, notification granularity, help integration (7 FRs)

**Total FRs:** 128 (original) + 14 (new) = **142 FRs**

---

## 7. Revised Epic Structure

### 7.1 Final Epic List (10 Epics)

| # | Epic Name | Timeline | Priority | Stories | Story Points |
|---|-----------|----------|----------|---------|--------------|
| 1 | Brief Creation & AI Task Generation | Week 1 | P0 | 8 | 41 |
| 2 | Task Management & Assignment | Week 2 | P0 | 10 | 45 |
| 3 | AI Agent Task Execution | Week 2 | P0 | 5 | 26 |
| 8 | Authentication & Security | Week 2 | P0 | 2 | 8 |
| **10** | **User Settings & Profile (Part 1)** | **Week 2** | **P1** | **2** | **13** |
| 4 | Manager Review & Output Management | Week 3 | P0 | 6 | 31 |
| 5 | Communication & Collaboration | Week 3 | P1 | 5 | 31 |
| **9** | **Manager Command Center (Dashboard)** | **Week 4** | **P0** | **4** | **23** |
| 6 | Search, Navigation & Bulk Actions | Week 4 | P1 | 4 | 20 |
| 7 | "Why This Matters" & Business Value | Week 5 | P0 | 4 | 18 |
| **10** | **User Settings & Profile (Part 2)** | **Week 5** | **P1** | **2** | **6** |

**Total:** 10 Epics, 52 Stories, 262 Story Points

---

### 7.2 Epic Prioritization

**P0 (Must Have - 6 Epics):**
- Epic 1: Brief Creation
- Epic 2: Task Management
- Epic 3: AI Agents
- Epic 8: Authentication
- Epic 4: Review Workflow
- **Epic 9: Dashboard** (NEW)
- Epic 7: Why This Matters

**P1 (Should Have - 4 Epics):**
- **Epic 10: Settings & Profile** (NEW)
- Epic 5: Collaboration
- Epic 6: Search & Navigation

---

## 8. Impact Analysis

### 8.1 User Requirements Met

**Original User Requirements:**
1. ✅ **Dashboard as navigation hub** → Epic 9 Story 9.1-9.2
2. ✅ **Summarizing analytics** → Epic 9 Story 9.2
3. ✅ **Separate analytics menu** → Epic 9 Story 9.2 (with "View Full Analytics" link for post-MVP)
4. ✅ **Profile and settings grouped** → Epic 10 (all 4 stories)
5. ✅ **Help as separate documentation** → Epic 10 Story 10.3 (Help & Support tab)
6. ✅ **Notification settings for emails and in-app** → Epic 10 Story 10.2 (granular toggles)
7. ✅ **Visual cues and periodic reminders** → Epic 9 Story 9.1, 9.3 (badges, banners, daily reminders)
8. ✅ **Manager action center** → Epic 9 Story 9.1 (pending reviews, overdue, queued AI)
9. ✅ **Team member dashboard** → Epic 9 Story 9.4 (role-specific view)

**All requirements addressed with focused, single-purpose epics.**

---

### 8.2 Jobs-to-be-Done Alignment

| JTBD | Epic | Stories | Outcome |
|------|------|---------|---------|
| "When I open SingleBrief, I need to see what requires my attention" | Epic 9 | 9.1, 9.3 | Manager confidence through visual cues and action prioritization |
| "When I want to track team progress, I need high-level analytics" | Epic 9 | 9.2 | Manager visibility into brief completion and team velocity |
| "When I want to control notifications, I need granular settings" | Epic 10 | 10.2 | User empowerment through email + in-app toggles (8 types) |
| "When I need help, I want easy access to documentation" | Epic 10 | 10.3 | User self-service through FAQ, support contact, product tour |

---

### 8.3 Technical Impact

**Database Changes:**
- New table: `profiles` (Story 10.1)
- Expanded table: `user_settings` (Story 10.2 - 16 new columns for notification toggles)
- Existing table: `user_brief_mutes` (already in Epic 5, used in Story 10.2)

**n8n Workflow Changes:**
- All 8 notification workflows (Epic 5) must check new granular toggles (Story 10.2)
- New workflow: Daily reminder banner (Story 9.3)

**Frontend Components:**
- 8 new dashboard widgets (Epic 9)
- 4 new settings tabs (Epic 10)

**No Breaking Changes:** All changes are additive, no existing FRs modified.

---

### 8.4 Timeline Impact

**Original:** 5 weeks, 220 story points, 44 points/week average
**Revised:** 5 weeks, 262 story points, 52 points/week average

**Velocity Increase:** +18% story points per week

**Mitigation:**
- Epic 10 Part 1 (13 points) runs parallel with Week 2 epics (already high velocity)
- Epic 9 (23 points) runs parallel with Epic 6 (20 points) in Week 4
- Epic 10 Part 2 (6 points) runs parallel with Epic 7 (18 points) in Week 5

**Conclusion:** Timeline remains **5 weeks** with adjusted velocity expectations.

---

### 8.5 Post-MVP Backlog Impact

**New Deferred Features:**
- Advanced analytics dashboard (full charts, custom date ranges) - Defer to v2
- Multi-language support (Story 10.4 dropdown prepared, implementation deferred) - Defer to v2
- Dynamic FAQ (CMS-managed instead of hardcoded) - Defer to v2

**Existing Deferred Features (Unchanged):**
- Dark mode
- Mobile gestures
- Brief-level discussions
- Real-time WebSockets (polling → Realtime at >50 users)
- Algolia search (PostgreSQL → Algolia at 10K briefs)

---

## 9. Next Steps

**Immediate Actions:**

1. **Review & Approve:** Review this proposal with stakeholders
2. **Create Stories:** Draft full user stories for Epic 9 and Epic 10 with:
   - Detailed acceptance criteria
   - Technical implementation (no-code)
   - FR mappings
   - Story point estimates
3. **Update PRD:** Create `prd_section6.md` documenting Epic 9 and Epic 10
4. **Adjust Timeline:** Update implementation schedule to reflect 262-point scope

---

## 10. Appendix

### 10.1 Epic 9 & 10 Functional Requirements

**Epic 9: Manager Command Center (FR129-FR135)**

- **FR129:** Dashboard shall display Manager Action Center widget showing pending reviews count
- **FR130:** Dashboard shall display overdue tasks count with red visual indicator
- **FR131:** Dashboard shall display queued AI tasks count with cost estimate
- **FR132:** Dashboard shall display summary analytics (active briefs, total tasks, completion %)
- **FR133:** Dashboard shall display brief completion chart with progress bars per active brief
- **FR134:** Dashboard shall show periodic reminder banner for pending actions (daily at 9am)
- **FR135:** Team member dashboard shall display "My Tasks" summary (To-Do, In-Progress, Due Today, Overdue)

**Epic 10: User Settings & Profile (FR136-FR142)**

- **FR136:** System shall provide profile management page with name, avatar, role, bio fields
- **FR137:** Profile avatar shall be uploadable to Supabase Storage and displayed across system
- **FR138:** System shall provide notification settings page with email + in-app master toggles
- **FR139:** System shall provide granular notification toggles (8 types × 2 channels = 16 toggles)
- **FR140:** Notification workflows shall check master toggle + specific toggle + DND + per-brief mute before sending
- **FR141:** Settings shall provide Help & Support tab with FAQ, contact support, product tour
- **FR142:** Settings shall consolidate account preferences (task limit, timezone, language)

---

### 10.2 Glossary Updates

**Action Center:** Dashboard widget showing items requiring manager attention (pending reviews, overdue tasks, queued AI tasks)

**Periodic Reminder:** In-app banner notification triggered daily at 9am if action items exist

**Summary Analytics:** High-level metrics displayed on dashboard (active briefs, completion %, tasks due this week)

**Granular Notifications:** Per-type notification toggles for email + in-app channels (8 types, 16 toggles total)

**Profile Management:** User settings page for managing identity (name, avatar, role, bio)

**Help & Support:** Settings tab with FAQ, contact support, and product tour access

---

### 10.3 References

**Source Documents:**
- `docs/prd/CONSOLIDATED_PRD.md` - Original 8-epic structure
- `docs/prd/prd_section5.md` - Epic and story breakdown (Epics 1-7)
- User requirements (conversation context) - Dashboard, Profile, Settings, Help specifications

**Related Epics:**
- Epic 2 (Task Management) - Story 1.8 consolidated into Epic 10
- Epic 5 (Collaboration) - Story 5.3 expanded into Epic 10
- Epic 6 (Search & Navigation) - Distinct from Epic 9 (Dashboard)

---

**Document Status:** Ready for Review
**Next Action:** Stakeholder approval → Create detailed user stories → Update PRD Section 6
