# PRD Section 3 - Team Member Perspective Updates

**Date:** 2025-10-04
**Elicitation Method:** Perspective Shifting (Team Member Role)
**Critical Discovery:** Team member experience is fundamentally different from manager experience

---

## Major UI Additions Required

### 1. Team Member Dashboard (New View)

**Purpose:** Team member's personal task inbox

**Layout:**
- "My Tasks" view showing all tasks assigned to this team member across all briefs/projects
- Task cards with:
  - Task title
  - Brief title (parent context)
  - Status badge (To-Do, In-Progress, Rejected, Done, Archived)
  - Due date (if set)
  - Progress indicator (% complete if in progress)
  - Last updated timestamp
- Filter by status
- Sort by due date, priority, or brief

**Navigation:**
- Team member lands here after login (different from manager dashboard)
- Can navigate to Brief Detail (if access granted by manager)

---

### 2. Task Detail View - Team Member Version (New)

**Purpose:** Team member's workspace for executing assigned task

**Layout Sections:**

**A. Task Header**
- Task title (read-only for team member, editable by manager only)
- Task description (read-only)
- Brief title link (clickable if access granted, grayed out if no access)
- Current status badge

**B. Task Metadata (Team Member Controls)**
- **Status Dropdown:** To-Do, In-Progress, Done, Rejected (read-only), Archived
- **Due Date Picker:** Set when starting task (empty initially, required when moving to In-Progress)
- **Progress Slider:** 0-100% completion (editable when In-Progress)
- **Assignee:** Shows team member name (read-only, cannot reassign themselves)

**C. Output Submission Section**
- **Comments Textarea:** Free-form text for notes, updates, or output content
- **URL Input:** Upload link to final work (Google Docs, Figma, GitHub PR, etc.)
- **Attachment Upload:** (Future enhancement - not MVP)
- **Submit Output Button:** Moves status to "Done" and notifies manager

**D. Brief Context (Conditional)**
- **If Manager Granted Access:**
  - Show full brief text
  - Show "Why This Matters" section
  - Show other team members' tasks (titles only)
  - Show other team members' outputs (if manager enabled cross-team visibility)
- **If No Access:**
  - Show message: "Limited access - contact manager for full brief context"
  - Only show task title and description

**E. Task History Log**
- Timeline of status changes
- Rejection history (if applicable):
  - "Rejected by [Manager Name] on [Date]"
  - Manager feedback text
  - "Reworked - moved to In-Progress on [Date]"
- Completion history
- Shows all rework cycles

---

### 3. Updated Task Status Model

**New Status Values (Expanded from Original 4):**

1. **To-Do** - Task assigned but not started
2. **In-Progress** - Team member actively working (requires due date set)
3. **Done** - Team member submitted output, awaiting manager review
4. **Rejected** - Manager rejected output with feedback (read-only status, auto-set by system)
5. **Accepted/Complete** - Manager accepted output (terminal status)
6. **Archived** - Task archived by manager (removed from active views)

**Status Transitions:**

```
To-Do → In-Progress (team member sets due date)
In-Progress → Done (team member submits output)
Done → Accepted/Complete (manager accepts)
Done → Rejected (manager rejects with feedback)
Rejected → In-Progress (team member reworks)
In-Progress → Done (resubmission after rework)
Any → Archived (manager archives)
```

---

### 4. New Functional Requirements (Team Member Features)

#### FR54: Team Member Task Inbox

**FR54:** System shall provide team members with dedicated task inbox showing all tasks assigned to them across all briefs and projects, with filtering and sorting capabilities.

---

#### FR55: Due Date Assignment

**FR55:** Team members shall be able to set task due date when moving task from "To-Do" to "In-Progress" status. Due date field is required to transition to In-Progress.

---

#### FR56: Progress Tracking

**FR56:** Team members shall be able to update task progress percentage (0-100%) while task is in "In-Progress" status. Progress is visible to manager in real-time.

---

#### FR57: Output Submission with URL

**FR57:** Team members shall be able to submit task output via:
- Free-form comments/text (required)
- URL to external work (Google Docs, Figma, GitHub, etc.) (optional)

Submission automatically transitions task status to "Done" and triggers manager notification.

---

#### FR58: Brief Access Control

**FR58:** Managers shall be able to grant or deny team members access to full brief context on per-brief basis. Default: No access (team member only sees assigned task details).

**Access Levels:**
- **No Access:** Task title and description only
- **Brief Access:** Full brief text + "Why This Matters"
- **Full Access:** Brief + other team members' tasks and outputs

---

#### FR59: Rejected Status and Feedback Loop

**FR59:** When manager rejects task output, system shall:
- Automatically set task status to "Rejected"
- Display manager feedback to team member
- Allow team member to transition from "Rejected" to "In-Progress" for rework
- Maintain history of rejection and rework cycles

---

#### FR60: Task History Log

**FR60:** System shall maintain comprehensive task history log showing:
- All status transitions with timestamps
- Rejection events with manager feedback
- Rework cycles
- Output submission history
- Due date changes

History visible to both team member and manager.

---

#### FR61: Cross-Team Output Visibility

**FR61:** If manager grants "Full Access" to brief, team members shall be able to view:
- Other team members' task titles
- Other team members' submitted outputs
- Other team members' task statuses

This enables team collaboration and context awareness.

---

## Updated UI Components Needed

### Task Status Badge Component (Updated)

**Statuses and Colors:**
- To-Do: Gray badge
- In-Progress: Blue badge with pulsing indicator
- Done: Green badge (awaiting review)
- Rejected: Red badge
- Accepted/Complete: Dark green badge with checkmark
- Archived: Muted gray badge

---

### Due Date Picker Component (New)

**Requirements:**
- Calendar picker UI (shadcn/ui Popover + Calendar)
- Required field when transitioning to In-Progress
- Validation: Cannot be in the past
- Visual warning if due date approaching (within 48 hours)

---

### Progress Slider Component (New)

**Requirements:**
- 0-100% slider (shadcn/ui Slider component)
- Updates in real-time (optimistic UI)
- Shows percentage label
- Optional color coding: 0-30% (red), 31-70% (yellow), 71-100% (green)

---

### URL Input Component (New)

**Requirements:**
- Text input with URL validation
- Link preview (optional - show domain/favicon)
- "Open in new tab" button next to saved URL
- Supports multiple URLs (comma-separated or repeated field)

---

### Task History Timeline Component (New)

**Requirements:**
- Vertical timeline UI
- Icons for different event types (status change, rejection, submission)
- Timestamps with relative time ("2 hours ago")
- Expandable details for rejection feedback

---

## Manager UI Updates Required

### Brief Settings - Access Control (New)

**Purpose:** Manager controls team member access to brief context

**Location:** Brief Detail view → Settings button

**UI:**
- List of team members with tasks in this brief
- Toggle switches for each member:
  - "Can view full brief"
  - "Can view other team members' outputs"
- Default: Both toggles OFF (task-only access)

---

### Task Card Updates for Managers

**Additional Information Displayed:**
- Due date (if set by team member)
- Progress percentage (if task in progress)
- "Rejected" status indicator with rework cycle count
- Time since last update

---

## Database Schema Implications

### Tasks Table Updates

**New Columns Needed:**
- `due_date` (timestamp, nullable)
- `progress_percentage` (integer, 0-100, default 0)
- `output_url` (text, nullable)
- `output_comments` (text, nullable)
- `rework_count` (integer, default 0, increments on rejection)

### Task_History Table (New)

**Purpose:** Track all task status changes and events

**Columns:**
- `id` (uuid, primary key)
- `task_id` (uuid, foreign key to tasks)
- `event_type` (enum: status_change, rejection, submission, due_date_change)
- `old_value` (text, nullable)
- `new_value` (text, nullable)
- `changed_by` (uuid, foreign key to users)
- `feedback` (text, nullable, for rejection events)
- `created_at` (timestamp)

### Brief_Access Table (New)

**Purpose:** Control team member access to briefs

**Columns:**
- `id` (uuid, primary key)
- `brief_id` (uuid, foreign key to briefs)
- `user_id` (uuid, foreign key to users)
- `can_view_brief` (boolean, default false)
- `can_view_team_outputs` (boolean, default false)
- `granted_by` (uuid, foreign key to users)
- `created_at` (timestamp)

---

## Non-Functional Requirement Updates

#### NFR24: Real-Time Progress Updates

**NFR24:** Progress percentage updates shall be reflected in manager's view within 2 seconds using optimistic UI updates (no page refresh required).

---

#### NFR25: Task History Performance

**NFR25:** Task history log shall load within 1 second for tasks with up to 50 history events.

---

## Key Insights from Team Member Perspective

### What Was Missing from Original Section 3

1. **Entire Team Member UI** - Original Section 3 was manager-centric
2. **Task Status Complexity** - Needed "Rejected" status and rework workflow
3. **Due Date Control** - Team members set their own deadlines
4. **Progress Tracking** - % completion granularity
5. **Access Control** - Not all team members should see everything
6. **Output Flexibility** - URLs to external work (not just text)
7. **Task History** - Audit trail for rework cycles
8. **Cross-Team Visibility** - Optional collaboration transparency

### This Changes the Product Significantly

**Before:** Manager-only tool with team notifications
**After:** Multi-user collaboration platform with role-based access

**Implications:**
- More complex permission model
- Additional database tables and queries
- More UI views and components
- Notification system needs expansion
- Team member onboarding flow needed

---

## Questions This Raises

1. **Can team members reassign tasks to other team members, or only managers?**
   - Assumption: Only managers (keeps control centralized)

2. **Can team members see the "Why This Matters" section even without full brief access?**
   - Decision: Only with brief access granted

3. **Should team members be able to comment on other team members' outputs (if visible)?**
   - Defer to post-MVP (adds complexity)

4. **What happens if team member misses due date they set themselves?**
   - Visual indicator (overdue badge), notification to manager?

5. **Can team members edit their submitted output after moving to "Done" status?**
   - Decision needed: Lock after submission, or allow edits until manager reviews?

6. **Should managers see real-time progress updates, or only when team member submits?**
   - NFR24 says yes to real-time - requires polling or websockets

---

*Team Member Perspective elicitation complete - critical UI gaps identified*
