# PRD Section 3 - Challenge Assumptions Results

**Date:** 2025-10-04
**Elicitation Method:** Challenge Assumptions
**Result:** 10 assumptions tested, 8 revised, 2 confirmed

---

## Assumption Testing Results

### ✅ Assumption 1: Task List Display - REVISED

**Original Assumption:** Brief Detail View shows all tasks in one scrollable list

**Challenge:** What if AI generates 50+ tasks?

**Decision:**
- ✅ **AI generates maximum of X tasks** (configurable in settings)
- ✅ **Settings page needed** with "Maximum Tasks per Brief" field
- ✅ **User confirmation required** after AI generation
- ✅ **Manual task management:** User can add/edit/remove tasks after AI generation
- ✅ **AI re-generation capability:** Text box + "Regenerate" button to request more tasks or modifications

**New Requirements:**

#### FR68: Configurable Task Limit

**FR68:** System settings shall include configurable "Maximum Tasks per Brief" field (default: 20, range: 5-50). AI task breakdown shall respect this limit and generate no more than the configured maximum.

---

#### FR69: Post-Generation Confirmation

**FR69:** After AI generates tasks, system shall display confirmation screen showing all generated tasks with options to:
- Accept all tasks (proceed to Brief Detail)
- Manually add tasks
- Manually edit tasks (title, description)
- Manually delete tasks
- Request AI regeneration with feedback

User must explicitly confirm before tasks are saved to brief.

---

#### FR70: AI Task Regeneration Interface

**FR70:** Brief Detail view shall include "Request AI Changes" section with:
- Text input for regeneration instructions (e.g., "Add marketing tasks", "Break down task 5 into subtasks")
- "Regenerate" button to request AI modifications
- "Add New Tasks" button to request AI generate additional tasks beyond current set

AI incorporates existing tasks + user feedback to generate updated task list.

---

#### FR71: Settings Page

**FR71:** System shall provide Settings page accessible from navigation with configurable options:
- Maximum Tasks per Brief (5-50, default: 20)
- Default AI model (future: GPT-4, Claude, etc.)
- Notification preferences
- Workspace preferences

---

### ✅ Assumption 2: Separate Dashboards - REVISED

**Original Assumption:** Managers have different dashboard from team members

**Challenge:** Users can have BOTH roles

**Decision:**
- ✅ **Users can have both roles** (create briefs AND receive task assignments)
- ✅ **Clear separation** of "Tasks I Assigned" vs "Tasks Assigned to Me"
- ✅ **Unified dashboard** with dual-role support

**Updated UI Design:**

#### Unified Dashboard Layout

**Sections:**

1. **My Briefs** (Manager Role)
   - Briefs I created
   - Quick stats: Active, Completed, Needs Review
   - "Create New Brief" button

2. **My Tasks** (Team Member Role)
   - Tasks assigned to me across all briefs
   - Grouped by status: Needs Attention, In Progress, To Do
   - "My Tasks" count badge

3. **Projects** (Organizational)
   - Projects I own or participate in
   - Cross-cutting view

**Navigation:**
- Default view shows both sections if user has both roles
- If user only creates briefs (no tasks assigned): Show "My Briefs" only
- If user only receives tasks (no briefs created): Show "My Tasks" only

---

### ✅ Assumption 3: "Why This Matters" Timing - CONFIRMED

**Original Assumption:** Show "Why This Matters" AFTER task breakdown

**Challenge:** Should it show earlier for motivation?

**Decision:**
- ✅ **Collapsed by default** in Brief Detail view
- ✅ **Displayed AFTER** task confirmation (maintains FR13 sequencing)
- ✅ **Always accessible** in brief header (user can expand anytime)

No changes needed - original assumption holds with "collapsed by default" clarification.

---

### ✅ Assumption 4: Manual Refresh - REVISED

**Original Assumption:** Manual refresh button acceptable for MVP

**Challenge:** Contradicts "visibility = confidence" core value

**Decision:**
- ❌ **Manual refresh NOT acceptable**
- ✅ **Implement polling** for real-time-like updates
- ✅ **Avoid websockets complexity** while delivering visibility

**New Requirements:**

#### NFR29: Polling-Based Updates

**NFR29:** System shall implement polling mechanism to refresh dashboard and brief views every 30 seconds automatically. User shall see updated task statuses, progress indicators, and notifications without manual refresh.

**Technical Implementation:**
- Client-side polling every 30 seconds
- Optimistic UI updates for user's own actions (immediate feedback)
- Background sync on window focus/visibility change
- Visual indicator when updates detected ("3 tasks updated")

---

#### FR72: Update Notifications

**FR72:** When polling detects changes (new task assignments, status changes, manager feedback), system shall display non-intrusive notification banner:
- "New task assigned to you"
- "Manager reviewed your output"
- "Brief progress updated"

Notifications dismissable, do not block workflow.

---

### ✅ Assumption 5: No File Uploads - REVISED

**Original Assumption:** Text + URL only for task outputs

**Challenge:** File upload is not complex with Supabase Storage

**Decision:**
- ✅ **File upload enabled** in MVP
- ✅ **Use Supabase Storage** (already part of stack)
- ✅ **10MB limit per file**
- ✅ **Support images, PDFs, docs**

**New Requirements:**

#### FR73: File Upload for Task Outputs

**FR73:** Team members and AI agents shall be able to attach files to task outputs with following constraints:
- **File types:** Images (PNG, JPG, SVG), Documents (PDF, DOCX, TXT), Spreadsheets (XLSX, CSV)
- **Size limit:** 10MB per file
- **Multiple files:** Up to 5 files per task
- **Storage:** Supabase Storage with proper access control (RLS)

**UI:**
- Drag-and-drop upload area
- File preview (thumbnails for images, icons for docs)
- Download button for uploaded files
- Delete option (before submission only)

---

#### FR74: File Access Control

**FR74:** Uploaded files shall be accessible only to:
- Task assignee (uploader)
- Brief creator (manager)
- Team members with "Full Access" to brief (if access control enabled post-MVP)

Files stored with RLS policies enforcing access restrictions.

---

### ✅ Assumption 6: Three-Level Access Control - REVISED

**Original Assumption:** No Access | Brief Access | Full Access

**Challenge:** Overengineered for small teams

**Decision:**
- ❌ **No access control in MVP**
- ✅ **Everyone sees everything** (trust-based small teams)
- ✅ **Add permissions post-MVP** if users request

**Simplified Model:**
- All team members with tasks in a brief can see full brief
- All team members can see other team members' outputs
- No toggles, no settings, no complexity

**Database Impact:**
- Remove `brief_access` table from MVP scope
- Defer to post-MVP based on user feedback

---

### ✅ Assumption 7: AI Auto-Execution - REVISED

**Original Assumption:** AI executes immediately on assignment

**Challenge:** Rate limiting, cost control, batch efficiency

**Decision:**
- ❌ **No immediate auto-execution**
- ✅ **Assign to AI queues task** (status: Queued)
- ✅ **"Run AI Tasks" button** triggers batch execution
- ✅ **Rate limiting protection** (5-second delay between tasks)
- ✅ **Manual trigger** gives manager control

**New Requirements:**

#### FR75: AI Task Queuing

**FR75:** When task is assigned to AI agent, task status shall be set to "Queued" (not auto-executing). Task remains in queue until manager triggers execution.

**UI Indicator:**
- Badge: "Queued for AI"
- Color: Orange/amber
- Icon: Clock or queue icon

---

#### FR76: Batch AI Execution

**FR76:** Brief Detail view shall include "Run AI Tasks" button (visible when ≥1 task is Queued). Clicking button triggers batch execution of all queued AI tasks with:
- Sequential execution (one at a time)
- 5-second delay between tasks (rate limit protection)
- Progress indicator showing "Running task 3 of 7..."
- Cancel option to stop batch mid-execution

---

#### FR77: AI Cost Preview

**FR77:** Before executing AI tasks, system shall display estimated cost preview:
- Number of tasks to execute
- Estimated token count (based on task description length)
- Estimated cost (if billing enabled)
- Confirmation prompt: "Run 7 AI tasks (estimated cost: $0.50)?"

Manager must confirm before execution begins.

---

### ✅ Assumption 8: Search Without Filters - REVISED

**Original Assumption:** Keyword search only, no status filtering

**Challenge:** Confusing UX when user searches "completed"

**Decision:**
- ✅ **Search + Basic Filters**
- ✅ **Filter dropdown:** All | Active | Completed
- ✅ **Keyword search** works within filtered results

**Updated UI:**

#### Search Bar Component

**Layout:**
- Search input field (icon: magnifying glass)
- Filter dropdown next to search (default: "All Briefs")
- Results count: "12 briefs found"

**Filter Options:**
- All Briefs
- Active Only (status: active, generating, draft)
- Completed Only (status: completed)

**Behavior:**
- Keyword search applies to filtered set
- Example: Filter "Active" + Search "marketing" = Active briefs containing "marketing"

---

### ✅ Assumption 9: PDF Export Undefined - REVISED

**Original Assumption:** PDF export with unspecified format

**Challenge:** What does PDF actually look like?

**Decision:**
- ✅ **PDF for internal records** (not external presentation)
- ✅ **Well-organized A4 document**
- ✅ **Template with clearly defined sections**

**New Requirements:**

#### FR78: PDF Export Template

**FR78:** PDF export shall use structured A4 template with following sections:

**Header:**
- Brief title
- Created by (manager name)
- Created date
- Last updated date
- Completion status (X of Y tasks complete)

**Section 1: Brief Overview**
- Brief description (full text)
- "Why This Matters" (if present and not skipped)
- Project association
- Tags/labels

**Section 2: Progress Summary**
- Visual progress bar
- Task status breakdown (To-Do: 5, In Progress: 3, Done: 2, etc.)
- Key metrics

**Section 3: Task List**
- Grouped by status
- Each task shows:
  - Title
  - Description
  - Assignee
  - Due date (if set)
  - Status
  - Output summary (if completed)

**Section 4: Completed Task Outputs** (Optional)
- Full output text for accepted tasks
- File attachments listed with download links
- Team member attribution

**Section 5: Task History** (Optional, checkbox on export)
- Timeline of major events
- Status changes
- Rejections and rework cycles

**Footer:**
- Export date
- Page numbers
- "Generated by SingleBrief" watermark

**Formatting:**
- Professional typography (sans-serif headers, serif body)
- Consistent margins (2cm all sides)
- Color coding for status badges (matching UI)
- Printer-friendly (black & white compatible)

---

### ✅ Assumption 10: No Priority Levels - REVISED

**Original Assumption:** Task status labels sufficient, no priority needed

**Challenge:** All tasks treated equal when they're not

**Decision:**
- ✅ **Priority levels needed**
- ✅ **Add priority field to tasks**
- ✅ **Manager sets priority** (AI can suggest, manager confirms)

**New Requirements:**

#### FR79: Task Priority Levels

**FR79:** Tasks shall have priority field with three levels:
- **High:** Critical, blocking, time-sensitive
- **Medium:** Important but not urgent (default)
- **Low:** Nice-to-have, can be deferred

**Priority Set By:**
- Manager (manual assignment)
- AI (suggested during task generation, manager can override)

**UI Display:**
- Priority badge on task card (High: Red, Medium: Yellow, Low: Gray)
- Priority icon (High: exclamation, Medium: equals, Low: minus)
- Sort/filter by priority

---

#### FR80: AI Priority Suggestion

**FR80:** When AI generates tasks, it shall suggest priority level for each task based on:
- Keywords in task description (urgent, critical, must-have = High)
- Task dependencies (blocking tasks = High)
- Brief context and "Why This Matters" section

Manager reviews and adjusts priorities during post-generation confirmation (FR69).

---

#### FR81: Priority-Based Task Sorting

**FR81:** Task lists shall support sorting by:
- Priority (High → Medium → Low)
- Status (Needs Attention → In Progress → To Do)
- Due date (soonest first)
- Assignee (group by team member)

Default sort: Priority descending (High first).

---

## Updated Task Status Model (Complete)

### Status Values (7 Total)

1. **To-Do** - Assigned, not started
2. **Queued** - Assigned to AI, awaiting execution (NEW)
3. **In-Progress** - Actively being worked (AI generating or human working)
4. **Done** - Output submitted, awaiting review
5. **Rejected** - Manager rejected with feedback
6. **Accepted/Complete** - Manager accepted, terminal status
7. **Archived** - Removed from active views

### Status Transitions (Updated)

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

## New Database Schema Updates

### Tasks Table - Additional Columns

**Priority Field:**
- `priority` (enum: high, medium, low, default: medium)

**Queued Status Support:**
- `queued_at` (timestamp, nullable) - When task was queued for AI
- `executed_at` (timestamp, nullable) - When AI execution started

---

### Settings Table (New)

**Purpose:** Store user/workspace preferences

**Columns:**
- `id` (uuid, primary key)
- `user_id` (uuid, foreign key to users)
- `max_tasks_per_brief` (integer, default: 20, range: 5-50)
- `default_ai_model` (text, default: "gpt-4")
- `notification_email` (boolean, default: true)
- `notification_in_app` (boolean, default: true)
- `created_at` (timestamp)
- `updated_at` (timestamp)

---

### Task_Files Table (New)

**Purpose:** Store file attachments for task outputs

**Columns:**
- `id` (uuid, primary key)
- `task_id` (uuid, foreign key to tasks)
- `file_name` (text)
- `file_path` (text) - Supabase Storage path
- `file_size` (integer) - Bytes
- `file_type` (text) - MIME type
- `uploaded_by` (uuid, foreign key to users)
- `created_at` (timestamp)

---

## Summary of Changes from Challenge Assumptions

### Requirements Added
- **FR68-FR71:** Task generation, confirmation, settings (4 new FRs)
- **FR72:** Update notifications via polling
- **FR73-FR74:** File upload capabilities (2 new FRs)
- **FR75-FR77:** AI queuing and batch execution (3 new FRs)
- **FR78:** PDF export template specification
- **FR79-FR81:** Task priority system (3 new FRs)

**Total New Requirements:** 13 functional requirements

---

### UI Components Added
- Settings page
- Post-generation confirmation screen
- AI regeneration interface
- Unified dashboard (dual-role support)
- File upload component
- "Run AI Tasks" batch control
- Priority badges and sorting
- Basic filter dropdown for search

---

### Database Tables Added
- `settings` table
- `task_files` table

**Tables Removed from MVP:**
- `brief_access` table (access control deferred)

---

### NFR Updates
- **NFR29:** Polling every 30 seconds (replaces manual refresh)

---

## Open Questions Resolved

1. ✅ **Max tasks per brief:** Configurable in settings (5-50, default 20)
2. ✅ **Dual roles:** Unified dashboard with clear separation
3. ✅ **"Why This Matters" display:** Collapsed by default
4. ✅ **Refresh mechanism:** Polling every 30 seconds
5. ✅ **File uploads:** Enabled with 10MB limit, Supabase Storage
6. ✅ **Access control:** None in MVP (everyone sees everything)
7. ✅ **AI execution:** Queued, manual batch trigger
8. ✅ **Search filters:** Basic status filter (All/Active/Completed)
9. ✅ **PDF format:** A4 template with defined sections
10. ✅ **Task priority:** Three levels (High/Medium/Low) with AI suggestions

---

*Challenge Assumptions elicitation complete - 13 new requirements added*
