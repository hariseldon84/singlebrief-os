# PRD Section 3 - Complete Summary

**Date:** 2025-10-04
**Section:** UI Enhancement Goals & Requirements
**Elicitation Methods Used:** 9 methods (Socratic Questioning, Perspective Shifting x2, Challenge Assumptions, Scenario Planning, Trade-off Analysis, Risk Exploration, Analogical Thinking, Gap Analysis)

---

## Executive Summary

Section 3 elicitation uncovered **111 total functional requirements** (FR1-FR111) through systematic analysis of UI/UX needs. This represents a significant expansion from the original 50 FRs in prd_section2.md.

**Key Discoveries:**

1. **Team Member Perspective** - Entire team member UI was missing from original design (8 new FRs)
2. **AI Agent Execution Model** - Queuing mechanism needed instead of auto-execution (6 new FRs)
3. **Communication Features** - Task comments, @mentions essential for async collaboration (3 new FRs)
4. **Onboarding & Templates** - Blank page paralysis mitigation required (3 new FRs)
5. **Risk Mitigation** - 14 high-priority risks identified with specific UI solutions

---

## New Requirements Added Through Elicitation

### From Perspective Shifting - Team Member (FR54-FR61)

| FR | Requirement | Decision Rationale |
|----|-------------|-------------------|
| FR54 | Team Member Task Inbox | Dedicated view for assigned tasks across all briefs |
| FR55 | Due Date Assignment by Team Member | Team member sets due date when starting task |
| FR56 | Progress Tracking (0-100%) | **Optional per brief** (Decision 1-C) - Reduces friction |
| FR57 | Output Submission with URL | Comments + URL linking (file upload optional per Decision 4-B) |
| FR58 | Brief Access Control | Removed from MVP - Everyone sees everything (Assumption 6) |
| FR59 | Rejected Status & Feedback Loop | Manager rejection triggers rework workflow |
| FR60 | Task History Log | Audit trail for rejection/rework cycles |
| FR61 | Cross-Team Output Visibility | Team members see other members' work (no access control MVP) |

---

### From Perspective Shifting - AI Agent (FR62-FR67)

| FR | Requirement | Decision Rationale |
|----|-------------|-------------------|
| FR62 | AI Auto-Execution | **REVISED TO QUEUING** - See FR75-FR77 (cost control) |
| FR63 | AI Context Window | Full brief + "Why This Matters" + previous outputs |
| FR64 | AI Version History Access | Iterative improvement from manager feedback |
| FR65 | AI Status Visibility | "Generating..." indicator with animated spinner |
| FR66 | "Generate with AI" for Team Members | AI-assisted suggestions (credit to human) |
| FR67 | AI Error Handling | Retry, reassign, user-friendly error messages |

---

### From Challenge Assumptions (FR68-FR81)

| FR | Requirement | Decision Rationale |
|----|-------------|-------------------|
| FR68 | Configurable Task Limit | Settings: 5-50 tasks per brief (default: 20) |
| FR69 | Post-Generation Confirmation | **Progressive disclosure** (Decision 3-B) - Show 5 tasks at a time |
| FR70 | AI Task Regeneration Interface | Text input + "Regenerate" button for modifications |
| FR71 | Settings Page | Max tasks, AI model, notifications, workspace preferences |
| FR72 | Update Notifications | Polling-based alerts (every 30 seconds per NFR29) |
| FR73 | File Upload for Task Outputs | **Always optional** (Decision 4-B) - 10MB limit, Supabase Storage |
| FR74 | File Access Control | RLS policies (assignee, manager, full access members) |
| FR75 | AI Task Queuing | Status: "Queued" - not auto-execute (cost control) |
| FR76 | Batch AI Execution | **Aggressive reminders** (Decision 2-C) - FAB + email after 24h |
| FR77 | AI Cost Preview | Estimated tokens/cost before execution |
| FR78 | PDF Export Template | A4 format with defined sections (internal records) |
| FR79 | Task Priority Levels | High/Medium/Low (manager sets, AI suggests) |
| FR80 | AI Priority Suggestion | AI suggests during generation, manager confirms |
| FR81 | Priority-Based Task Sorting | Sort by priority descending (High first) |

---

### From Scenario Planning (FR82-FR92)

| FR | Requirement | Decision Rationale |
|----|-------------|-------------------|
| FR82 | Brief Title Management | Auto-generate from first 50 chars OR custom title |
| FR83 | Draft Brief Saving | Auto-save if user closes creation dialog |
| FR84 | Task Acceptance Granularity | Selective task acceptance (checkboxes) + "Accept All" |
| FR85 | Overdue Task Indicators | Orange badge when due date passed |
| FR86 | AI Queue Position Visibility | "3rd in queue" indicator for queued tasks |
| FR87 | AI Regeneration Attempt Limits | Max 3 attempts, then suggest reassign to human |
| FR88 | Version Comparison UI | Diff view for rejected vs. resubmitted outputs |
| FR89 | Rework Cycle Tracking | "Rework cycle 2" badge on rejected tasks |
| FR90 | AI-Assisted Output Attribution | "AI-assisted" tag visible to manager |
| FR91 | Search Scope Controls | All Briefs \| My Briefs \| Active Only \| Archived |
| FR92 | Archived Brief Filtering | Exclude archived by default, opt-in to include |

---

### From Analogical Thinking (FR93-FR95)

| FR | Requirement | Decision Rationale |
|----|-------------|-------------------|
| FR93 | Task Comments Thread | **Include in MVP** (Decision 5-A) - Essential for async collaboration |
| FR94 | Quick-Add Task | **Include in MVP** (Decision 6-A) - Title only, expand later |
| FR95 | Brief Templates | **Include in MVP** (Decision 7-A) - 3-5 core templates |

Templates: Marketing Campaign, Product Launch, Event Planning, Hiring Process, Sprint Planning

---

### From Gap Analysis (FR99-FR111)

| FR | Requirement | Decision Rationale |
|----|-------------|-------------------|
| FR99 | Interactive Onboarding Flow | **Minimal** (Decision 9-B) - Welcome screen + rich empty states |
| FR100 | Rich Empty States | Illustrations + action options + inspiration |
| FR101 | @Mentions in Comments | Autocomplete, notifications, linked usernames |
| FR102 | Task Reassignment | "Reassign" button (manager only), notification to previous assignee |
| FR103 | Notification Center | Bell icon, last 30 notifications, deep linking |
| FR104 | Project Progress Dashboard | Aggregated metrics across all briefs in project |
| FR105 | Multi-Format Export | PDF (primary), CSV, Markdown, JSON (post-MVP) |
| FR106 | Bulk Task Actions | **Include in MVP** (Decision 10-A) - Select multiple, assign/prioritize/archive |
| FR107 | Undo Toast for Critical Actions | 10-second grace period with "Undo" button |
| FR108 | Dark Mode Support | **Defer to post-MVP** (Decision 11-B) - Light mode only for MVP |
| FR109 | System Audit Log | Critical events (user invited, brief deleted, settings changed) |
| FR110 | Mobile Gesture Support | **Defer to post-MVP** (Decision 12-C) - Standard tap interactions only |
| FR111 | Advanced Search Filters | Date range, assignee, status, priority, project filters |

---

## Non-Functional Requirements Added

### NFR29: Polling-Based Updates
**Source:** Challenge Assumptions
**Requirement:** System shall poll every 30 seconds to refresh dashboard and brief views automatically. Replaces manual refresh (contradicts "visibility = confidence" core value).

### NFR30: Deep Link Handling
**Source:** Scenario Planning
**Requirement:** Email notification links shall deep link directly to task detail view with proper 404/error handling if task deleted.

### NFR31: Real-Time Progress Visibility
**Source:** Scenario Planning
**Requirement:** Manager dashboard shall poll every 30 seconds to display team member progress updates (0-100%) on in-progress tasks.

### NFR32: Accessibility Compliance
**Source:** Gap Analysis
**Requirement:** System shall meet WCAG 2.1 Level AA standards (keyboard navigation, screen reader support, color contrast, focus management).

---

## Database Schema Changes

### New Tables

**1. settings (FR71)**
- `id`, `user_id`, `max_tasks_per_brief`, `default_ai_model`, `notification_email`, `notification_in_app`

**2. task_files (FR73-FR74)**
- `id`, `task_id`, `file_name`, `file_path`, `file_size`, `file_type`, `uploaded_by`

**3. task_history (FR60)**
- `id`, `task_id`, `event_type`, `old_value`, `new_value`, `changed_by`, `feedback`

**4. task_outputs (FR64, FR88)**
- `id`, `task_id`, `output_text`, `output_url`, `version_number`, `created_by`, `is_ai_generated`, `ai_model`, `status`, `manager_feedback`

**5. task_comments (FR93, FR101)**
- `id`, `task_id`, `user_id`, `comment_text`, `mentioned_users`, `created_at`

**6. notifications (FR103)**
- `id`, `user_id`, `notification_type`, `related_task_id`, `related_brief_id`, `message`, `is_read`, `created_at`

**7. brief_templates (FR95)**
- `id`, `template_name`, `template_description`, `brief_text_template`, `suggested_task_types`, `is_active`

---

### Updated Tables

**tasks table - new columns:**
- `due_date` (timestamp, nullable) - FR55
- `progress_percentage` (integer, 0-100, default 0) - FR56
- `output_url` (text, nullable) - FR57
- `output_comments` (text, nullable) - FR57
- `rework_count` (integer, default 0) - FR89
- `priority` (enum: high, medium, low, default: medium) - FR79
- `queued_at` (timestamp, nullable) - FR75
- `executed_at` (timestamp, nullable) - FR76
- `ai_model` (text, nullable) - FR62
- `generation_time_ms` (integer, nullable) - FR62
- `token_count` (integer, nullable) - FR77
- `ai_error_message` (text, nullable) - FR67

**briefs table - new columns:**
- `brief_title` (text, nullable) - FR82 (auto-generated or custom)
- `template_id` (uuid, foreign key to brief_templates, nullable) - FR95

---

## Updated Task Status Model (7 Statuses)

**Final Status Values:**

1. **To-Do** - Assigned, not started
2. **Queued** - Assigned to AI, awaiting execution (FR75)
3. **In-Progress** - Actively being worked (AI generating or human working)
4. **Done** - Output submitted, awaiting review
5. **Rejected** - Manager rejected with feedback (FR59)
6. **Accepted/Complete** - Manager accepted, terminal status
7. **Archived** - Removed from active views

**Status Transitions:**
```
To-Do → In-Progress (human starts, sets due date)
To-Do → Queued (assigned to AI agent)
Queued → In-Progress (manager clicks "Run AI Tasks")
In-Progress → Done (output submitted)
Done → Accepted (manager accepts)
Done → Rejected (manager rejects with feedback)
Rejected → In-Progress (rework)
Any → Archived (manager archives)
```

---

## Major Design Decisions Summary

### Trade-off Analysis Decisions

| Decision | Option Chosen | Rationale |
|----------|---------------|-----------|
| **Task List Layout** | Linear List with Badges | Mobile-first, 7-status support, faster implementation |
| **"Why This Matters" Display** | Collapsible (Default Collapsed) | Opt-in usage, non-intrusive, user control |
| **Task Assignment UI** | Dropdown Selector | Simple, sufficient for small teams, fast implementation |
| **AI Execution Trigger** | Manual Batch with Cost Preview | Cost control, rate limit safety, manager control |
| **Dashboard Layout** | Unified Dual-Role | Single source of truth, dual-role support |

---

### Risk Mitigation Decisions

**14 Risks Identified, 9 High Priority:**

| Risk | Mitigation | Implementation |
|------|-----------|----------------|
| "Why This Matters" ignored | Track analytics, iterate prompts | A/B testing, user interviews |
| Progress % not updated | **Optional per brief** (Decision 1-C) | Quick-update buttons, gentle nudges |
| Confirmation screen overwhelms | **Progressive disclosure** (Decision 3-B) | Show 5 tasks at a time |
| AI timeout frustrations | Dynamic estimates, 90s timeout | "Generating... typically 30-45s" |
| Queued tasks forgotten | **Aggressive reminders** (Decision 2-C) | FAB + email after 24h + daily digest |
| Team members can't find tasks | Smart sorting, visual hierarchy | Overdue first → Due soon → Priority |
| Rejection demotivates | Tone checker, positive reinforcement | Feedback templates, celebration animations |
| Offensive AI content | Moderation API, reporting | Content moderation before display |
| Concurrent edit conflicts | **Full presence system** (Decision 8-A) | Real-time "who's viewing" avatars |
| Accidental deletions | Soft delete, 30-day recovery | Confirmation modal, "Restore" option |

---

### Analogical Thinking - Pattern Adoption

**Patterns Adopted from Similar Products:**

- **Asana:** Rich task cards with metadata, sectioned views
- **Trello:** Color-coded priority labels, minimalist cards
- **Linear:** Status dropdowns, minimal UI chrome
- **Notion:** Inline editing, collapsible sections, templates
- **Basecamp:** Task comments for async collaboration
- **Figma:** Presence indicators, version history
- **Slack:** Notification preferences, unread badges, threading
- **Google Docs:** Suggestion mode (Accept/Reject workflow)

---

## Scope Changes from Original PRD Section 3

### Originally Planned (7 screens)

1. Dashboard View (Modified)
2. Brief Creation View (New)
3. Brief Detail View (New)
4. Task Output Review Modal (New)
5. Project Detail View (Modified)
6. Team Management View (New)
7. Search Results View (New)

### Expanded After Elicitation (17 screens/views)

**Added:**

8. Team Member Dashboard (Unified with Manager Dashboard)
9. Team Member Task Detail View
10. Post-Generation Confirmation Screen (FR69)
11. Settings Page (FR71)
12. AI Cost Preview Modal (FR77)
13. Notification Center (FR103)
14. Project Progress Dashboard (FR104)
15. Template Gallery (FR95)
16. Onboarding Welcome Screen (FR99)
17. Task Comments Thread View (FR93)

---

## MVP Scope Finalization

### Included in MVP (High Priority FRs)

**Core Features:**

- FR1-FR50: Original requirements from Section 2
- FR54-FR61: Team member UI (except FR58 - no access control)
- FR62-FR67: AI agent features
- FR68-FR81: Challenge assumptions results (14 FRs)
- FR82-FR92: Scenario planning discoveries (11 FRs)
- FR93-FR95: Analogical thinking additions (task comments, quick-add, templates)
- FR99-FR107: Gap analysis essentials (onboarding, @mentions, reassignment, notifications, bulk actions, undo)
- FR109: System audit log
- FR111: Advanced search filters

**Total MVP FRs:** 101 functional requirements

---

### Deferred to Post-MVP (Low Priority)

**Features to Validate Demand:**

- FR96: Brief-level discussions (Basecamp message board)
- FR97: Daily check-in prompts
- FR98: Inline comments on task outputs
- FR108: Dark mode support
- FR110: Mobile gestures
- Time tracking (Gap 3.2)
- Multi-language support (Gap 5.2)
- Team permissions/RBAC (Gap 6.1)
- Billing integration (Gap 6.2) - Manual invoicing for MVP
- Native mobile apps (Gap 7.1)
- Saved searches (Gap 8.2)
- External integrations (Gap 9.1)
- Public API (Gap 9.2)

---

## Key UI Components Required

### shadcn/ui Components Needed

**Existing (Already in Codebase):**
- Button, Card, Dialog, Input, Textarea, Badge, Select, Toast

**New (To Be Added):**
- Collapsible (for "Why This Matters")
- Progress (for brief/task progress bars)
- Slider (for progress % - optional per brief)
- Calendar/DatePicker (for due date selection)
- Avatar (for assignee avatars)
- Popover (for dropdowns, menus)
- Tabs (for view switchers)
- Checkbox (for bulk selection)
- DropdownMenu (for action menus)
- Command (for @mention autocomplete - post-MVP)

---

## Technical Implementation Notes

### Supabase RLS Policies Needed

**Files Access (FR74):**
- Uploaded files accessible only to: Assignee, Manager, Full Access members
- Row-level security on `task_files` table

**Task Access:**
- Team members see only tasks assigned to them OR briefs they have access to
- Managers see all tasks in their created briefs

**Notification Access:**
- Users see only their own notifications
- RLS on `notifications` table

---

### AI Integration Requirements

**LLM API Calls:**

1. **Brief Task Breakdown** (FR6)
   - Input: Brief text, max tasks setting (FR68)
   - Output: Array of tasks with title, description, priority (FR80)

2. **"Why This Matters" Generation** (FR8)
   - Input: Brief text, task list
   - Output: Business value + impact metrics

3. **AI Task Execution** (FR62-FR67)
   - Input: Task title, description, full brief context, previous outputs (FR64)
   - Output: Task completion text
   - Error handling: Timeout (90s), rate limiting, moderation

4. **AI Regeneration** (FR70, FR77)
   - Input: Previous output + manager feedback
   - Output: Improved task list or "Why This Matters"
   - Cost preview before execution

---

### Performance Considerations

**Polling Strategy (NFR29, NFR31):**
- 30-second interval for dashboard/brief updates
- Pause polling when tab inactive (Page Visibility API)
- Redis cache for frequently accessed data
- Database indexes on `status`, `updated_at`

**File Upload (FR73):**
- 10MB limit per file, up to 5 files per task
- Client-side validation before upload
- Chunked upload for files >5MB
- Compression suggestion for images

---

## Success Metrics from Elicitation

### Adoption Metrics

- **"Why This Matters" Usage:** 80% adoption rate (FR8, NFR19)
- **Task Comments Usage:** Track comment frequency (FR93)
- **Template Usage:** % of briefs created from templates vs. blank (FR95)
- **AI Queue Execution:** Median dwell time <48h (Risk 4.2)

### Quality Metrics

- **Rejection Rate:** <30% of submissions rejected (Risk 3.2)
- **AI Timeout Rate:** <15% of generations exceed 60s (Risk 2.1)
- **Progress Update Frequency:** If <30% usage, remove slider (Risk 1.2)
- **Search Abandonment:** <50% abandonment rate (Risk 3.3)

### Performance Metrics

- **Dashboard Load Time:** <3 seconds (Risk 2.2)
- **Polling Response Time:** <500ms average (NFR29)
- **File Upload Success Rate:** >90% (Risk 2.3)

---

## Open Questions for Section 4 (Technical Constraints)

### Infrastructure Questions

1. **Redis Cache:** Do we need Redis for polling optimization, or can we optimize with database indexes only?
2. **Background Jobs:** Queued AI tasks (FR75) - Use Supabase Edge Functions or separate job queue (Bull, BullMQ)?
3. **File Storage Limits:** Supabase Storage free tier limits - What's our storage budget for 100 users?

### AI/LLM Questions

4. **Model Selection:** OpenAI GPT-4 vs. Anthropic Claude for task breakdown - Which is more cost-effective?
5. **Token Budget:** Average tokens per brief generation - Can we estimate monthly costs?
6. **Rate Limiting:** OpenAI tier limits - Do we need to implement our own rate limiting beyond FR76's 5-second delay?

### Authentication Questions

7. **Team Invitations:** Email-based invitations - Use Supabase Auth magic links or custom invite flow?
8. **Session Management:** How long should sessions last? Refresh token strategy?

---

## Summary Statistics

**Requirements:**
- Functional Requirements: 111 (FR1-FR111)
- Non-Functional Requirements: 32 (NFR1-NFR32)
- Compatibility Requirements: 4 (CR1-CR4)
- **Total Requirements:** 147

**Database Changes:**
- New Tables: 7
- Updated Tables: 2
- New Columns: 15+

**UI Views:**
- Original: 7 screens
- Expanded: 17 screens/views
- New Components: 10+ shadcn/ui components

**Elicitation Methods Used:** 9
**User Decisions Made:** 12 critical decisions
**Risks Identified:** 14 (9 high priority)
**Gaps Identified:** 23
**Products Analyzed:** 8 (Asana, Trello, Linear, Notion, Basecamp, Figma, Slack, Google Docs)

---

**Section 3 Complete - Ready to proceed to Section 4: Technical Constraints and Integration Requirements**
