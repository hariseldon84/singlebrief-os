# PRD Section 3 - Gap Analysis (Missing UI Elements)

**Date:** 2025-10-04
**Elicitation Method:** Gap Analysis
**Purpose:** Identify missing UI elements, features, and workflows by comparing current design against complete user needs

---

## Gap Category 1: Onboarding and First-Time User Experience

### Gap 1.1: No Guided Onboarding Flow

**Current State:** User signs up → Lands on empty dashboard

**What's Missing:**

- No welcome screen explaining SingleBrief value proposition
- No interactive tutorial showing brief creation workflow
- No sample brief pre-loaded for exploration
- No "Quick Start Guide" or video tutorial

**User Impact:**

- First-time users confused about where to start
- Increased time to first value (should be <3 minutes per Analogical Thinking)
- Higher abandonment rate in first session

**Recommendation:**

**FR99: Interactive Onboarding Flow**

System shall provide 3-step interactive onboarding for new users:

1. **Welcome Screen:** Value proposition + "Create Your First Brief" CTA
2. **Guided Brief Creation:** Inline hints during first brief creation ("Describe your project in 2-3 sentences")
3. **Tutorial Brief:** Pre-loaded example brief (Marketing Campaign template) that user can explore

**Skip Option:** "I already know how to use this" link for returning users or team members invited by managers

---

### Gap 1.2: No Empty State Guidance

**Current State:** Empty dashboard shows "No briefs yet. Create your first brief."

**What's Missing:**

- No visual illustration (empty state feels barren)
- No guidance on WHAT to write in brief
- No examples or inspiration
- No alternative actions (explore templates, watch video, read docs)

**Recommendation:**

**FR100: Rich Empty States**

Empty states shall include:

- **Visual Illustration:** Friendly graphic (not just text)
- **Action Options:**
  - Primary: "Create New Brief" button
  - Secondary: "Browse Templates" link
  - Tertiary: "Watch 2-min Demo Video" link
- **Inspiration:** "Not sure where to start? Try: 'Launch Q1 marketing campaign for enterprise customers'"

---

## Gap Category 2: Team Collaboration and Communication

### Gap 2.1: No @Mentions in Task Comments

**Current State:** FR93 (task comments) planned without mention system

**What's Missing:**

- Cannot notify specific team members in comments
- No way to ask for input from specific person
- Comments are broadcast to everyone (no targeting)

**Recommendation:**

**FR101: @Mentions in Comments**

Task comments shall support @mentions:

- Type "@" triggers autocomplete with team member names
- Mentioned user receives notification (email + in-app)
- Mention renders as linked username (clickable to profile)
- Multiple mentions supported per comment

**UI:**

- Autocomplete dropdown appears on "@" keypress
- Highlighted mention: `@Sarah` in blue text
- Notification: "Sarah mentioned you in Task: Design wireframes"

---

### Gap 2.2: No Way to Reassign Tasks

**Current State:** Manager assigns task to Alex → No reassignment workflow if Alex unavailable

**What's Missing:**

- Cannot reassign task to different team member
- No "Reassign" button in task detail view
- If assignee leaves team, task is orphaned

**Recommendation:**

**FR102: Task Reassignment**

Managers shall be able to reassign tasks to different team members:

- "Reassign" button in Task Detail view (manager only)
- Select new assignee from dropdown
- Optional: Add reassignment reason/note
- Previous assignee receives notification: "Sarah reassigned your task to Alex"
- Task history log records reassignment event

---

### Gap 2.3: No Notification History

**Current State:** Email notifications sent, but no in-app record

**What's Missing:**

- Cannot see "What notifications did I receive this week?"
- No central notification inbox
- Dismissed notifications are lost forever
- Cannot re-read notification without finding original email

**Recommendation:**

**FR103: Notification Center**

System shall provide in-app notification center:

- Bell icon in navigation (badge shows unread count)
- Dropdown panel showing last 30 notifications
- Notification types: Task assigned, Due soon, Rejected, Accepted, Mentioned
- Mark as read/unread
- Click notification → Deep link to task/brief

---

## Gap Category 3: Progress Tracking and Reporting

### Gap 3.1: No Project-Level Progress Dashboard

**Current State:** Can see individual brief progress, but no rollup to project level

**What's Missing:**

- Cannot answer: "How is Project X doing overall?"
- No aggregated progress across all briefs in project
- No project-level metrics (total tasks, completion rate, average cycle time)

**Recommendation:**

**FR104: Project Progress Dashboard**

Project Detail view shall show aggregated metrics:

- **Overall Progress:** All tasks across all briefs in project (e.g., "68 of 100 tasks complete")
- **Active Briefs:** Count of briefs with status "active" or "generating"
- **Team Velocity:** Average tasks completed per week
- **Bottlenecks:** Briefs with >30% tasks rejected (needs attention)

**Visual:**

- Progress bar for project completion
- Brief cards showing individual progress
- "Top Performers" section (team members with highest acceptance rate)

---

### Gap 3.2: No Time Tracking or Estimates

**Current State:** Tasks have due dates but no time estimates or actual time tracking

**What's Missing:**

- Cannot estimate "How long will this brief take?"
- No historical data for future planning
- Cannot see "Alex spent 8 hours on this task"

**Decision:**

**Defer to Post-MVP** - Time tracking is complex and often unused (Analogical Thinking: Trello avoids built-in time tracking)

**Alternative:** Use task count and historical completion rates as proxy for effort estimation

---

### Gap 3.3: No Export Options Beyond PDF

**Current State:** FR78 specifies PDF export for briefs

**What's Missing:**

- Cannot export to CSV (for spreadsheet analysis)
- Cannot export to Markdown (for documentation)
- Cannot export to JSON (for API integrations)
- Cannot export task list only (separate from full brief)

**Recommendation:**

**FR105: Multi-Format Export**

Brief Detail view shall support export in multiple formats:

- **PDF:** Full brief report (FR78 template) - Primary format
- **CSV:** Task list with columns (Title, Assignee, Status, Priority, Due Date, Output) - For Excel analysis
- **Markdown:** Plain text format for documentation/wikis
- **JSON:** Structured data for API integrations (post-MVP)

**UI:**

- "Export" dropdown button with format options
- Format selection → Download file immediately

---

## Gap Category 4: Error Handling and Edge Cases

### Gap 4.1: No Bulk Actions for Tasks

**Current State:** Manager must act on tasks one at a time

**What's Missing:**

- Cannot select multiple tasks and assign to same person
- Cannot bulk-update priority (e.g., set 5 tasks to "High")
- Cannot bulk-archive completed tasks
- Cannot bulk-delete tasks from confirmation screen

**Recommendation:**

**FR106: Bulk Task Actions**

Task lists shall support bulk selection and actions:

- Checkbox on each task card
- "Select All" checkbox in list header
- Bulk actions toolbar appears when ≥1 task selected:
  - Assign to [Dropdown]
  - Set Priority to [Dropdown]
  - Archive Selected
  - Delete Selected

**Safety:**

- Bulk delete shows confirmation modal: "Delete 5 tasks? This cannot be undone."

---

### Gap 4.2: No Undo Mechanism

**Current State:** All actions are immediate and irreversible (except soft delete for briefs)

**What's Missing:**

- Cannot undo task status change (accidentally marked as Done)
- Cannot undo task deletion
- Cannot undo brief deletion (30-day recovery exists per FR in Risk Exploration, but no quick undo)
- Cannot undo rejection (if manager clicks Reject by mistake)

**Recommendation:**

**FR107: Undo Toast for Critical Actions**

Critical actions shall show undo toast notification:

- Actions: Delete task, Archive brief, Reject output, Bulk actions
- Toast appears for 10 seconds: "Task deleted. [Undo]"
- Click "Undo" → Action reversed immediately
- After 10 seconds → Toast dismissed, action committed

**Technical:**

- Soft delete with 10-second grace period
- Undo button triggers restore operation

---

### Gap 4.3: No Offline Support

**Current State:** App requires internet connection for all operations

**What's Missing:**

- Cannot view briefs/tasks offline
- Cannot draft task output offline (e.g., on airplane)
- Cannot queue actions for sync when reconnected
- No "You're offline" indicator

**Recommendation:**

**Defer to Post-MVP** - Offline support requires PWA, service workers, complex sync logic

**Mitigation for MVP:**

- Show clear error message when offline: "No internet connection. Please reconnect to continue."
- Auto-retry failed requests when connection restored

---

## Gap Category 5: Accessibility and Internationalization

### Gap 5.1: No Accessibility Compliance Plan

**Current State:** No explicit accessibility requirements defined

**What's Missing:**

- No WCAG 2.1 AA compliance target
- No keyboard navigation specification
- No screen reader testing plan
- No color contrast validation
- No focus management strategy

**Recommendation:**

**NFR32: Accessibility Compliance**

System shall meet WCAG 2.1 Level AA standards:

- **Keyboard Navigation:** All interactive elements accessible via Tab/Enter/Space
- **Focus Management:** Visible focus indicators, logical tab order
- **Screen Reader Support:** Semantic HTML, ARIA labels, alt text for icons
- **Color Contrast:** Minimum 4.5:1 ratio for text, 3:1 for UI components
- **Testing:** Automated (axe-core) + manual (screen reader testing)

**Implementation:**

- Use shadcn/ui components (built with accessibility)
- Add ARIA labels to all interactive elements
- Test with NVDA/JAWS screen readers before launch

---

### Gap 5.2: No Multi-Language Support

**Current State:** English-only UI

**What's Missing:**

- Cannot switch to Spanish, French, German, etc.
- AI-generated content always in English
- No localization framework (i18n)

**Recommendation:**

**Defer to Post-MVP** - Internationalization is complex (requires i18n library, translation management, LLM multilingual prompts)

**MVP Decision:** English-only acceptable for invite-only launch in US market

**Post-MVP:** Use react-i18next for UI translations, pass language preference to LLM for AI-generated content

---

### Gap 5.3: No Dark Mode

**Current State:** Light theme only

**What's Missing:**

- Cannot switch to dark mode (user preference)
- No system theme detection (auto dark mode based on OS setting)

**Recommendation:**

**FR108: Dark Mode Support**

System shall support light and dark themes:

- Theme toggle in Settings page (FR71)
- Auto-detect system preference (default)
- Manual override option
- All UI components styled for both themes (shadcn/ui supports dark mode)

**Implementation:**

- Use Tailwind CSS dark mode classes
- Store theme preference in localStorage
- Apply theme class to root element

---

## Gap Category 6: Admin and Settings

### Gap 6.1: No Team Management Permissions

**Current State:** All team members have equal capabilities (no roles)

**What's Missing:**

- Cannot designate "Admin" role (manage team, billing, settings)
- Cannot restrict who can create briefs (e.g., only managers)
- Cannot prevent team members from inviting others

**Recommendation:**

**Defer to Post-MVP** - Role-based access control (RBAC) is complex

**MVP Decision:** Trust-based model for small teams (everyone can create briefs, invite team members)

**Post-MVP:** Add Admin role with permissions (manage billing, invite users, delete briefs)

---

### Gap 6.2: No Billing Integration

**Current State:** Manual invoicing mentioned for MVP

**What's Missing:**

- No credit card payment collection
- No subscription management UI
- No usage-based billing (AI task count tracking)
- No invoice history/download

**Recommendation:**

**Defer to Post-MVP** - MVP uses manual invoicing (confirmed in brainstorming)

**Post-MVP:** Integrate Stripe for:

- Credit card collection
- Subscription plans (Starter, Pro, Enterprise)
- Usage-based billing for AI tasks
- Self-service invoice downloads

---

### Gap 6.3: No Audit Log for Admins

**Current State:** Task history exists (FR60), but no system-wide audit log

**What's Missing:**

- Cannot see "Who invited user X?"
- Cannot see "Who deleted brief Y?"
- Cannot see "Who changed settings Z?"
- No compliance trail for security audits

**Recommendation:**

**FR109: System Audit Log**

System shall maintain audit log of critical events:

- User invited/removed
- Brief created/deleted/restored
- Settings changed
- Role changes (post-MVP when roles exist)

**Access:**

- Admin-only view (post-MVP when admin role exists)
- Shows: Event type, User, Timestamp, IP address (optional)
- Filterable by user, event type, date range

---

## Gap Category 7: Mobile Experience

### Gap 7.1: No Native Mobile App

**Current State:** Responsive web app only

**What's Missing:**

- No iOS/Android native apps
- No push notifications (email only)
- No offline capability (native apps handle offline better)
- No app store presence

**Recommendation:**

**Defer to Post-MVP** - Native apps require separate codebases, app store approvals

**MVP Decision:** Mobile-optimized web app is sufficient (NFR21: Tablet-optimized)

**Post-MVP:** Consider React Native for cross-platform native apps

---

### Gap 7.2: No Mobile-Specific Shortcuts

**Current State:** Same UI patterns for desktop and mobile

**What's Missing:**

- No swipe gestures (e.g., swipe task card to archive)
- No long-press menus (e.g., long-press task for quick actions)
- No mobile-optimized navigation (bottom tab bar)

**Recommendation:**

**FR110: Mobile Gesture Support**

Mobile view shall support touch gestures:

- **Swipe Left on Task:** Quick archive
- **Swipe Right on Task:** Quick assign
- **Long Press on Task:** Context menu (Assign, Archive, Delete)
- **Pull to Refresh:** Refresh dashboard/brief list

**Implementation:**

- Use React gesture libraries (react-swipeable)
- Progressive enhancement (gestures on mobile only)

---

## Gap Category 8: Search and Filtering

### Gap 8.1: No Advanced Search

**Current State:** FR30 specifies keyword search, FR91 adds basic filters

**What's Missing:**

- Cannot search by date range ("briefs created in March 2024")
- Cannot search by assignee ("tasks assigned to Alex")
- Cannot search by status ("all rejected tasks")
- Cannot combine filters (e.g., "High priority tasks assigned to Sarah due this week")

**Recommendation:**

**FR111: Advanced Search Filters**

Search shall support advanced filter combinations:

- **Keyword:** Free text search in title, description
- **Date Range:** Created between [Date] and [Date]
- **Assignee:** Tasks assigned to [User]
- **Status:** Filter by task status (To-Do, In-Progress, Done, etc.)
- **Priority:** Filter by High/Medium/Low
- **Project:** Filter by project association

**UI:**

- "Advanced Filters" toggle to show filter panel
- Apply multiple filters simultaneously
- "Clear Filters" button to reset

---

### Gap 8.2: No Saved Searches

**Current State:** User must re-enter search criteria each time

**What's Missing:**

- Cannot save frequent searches (e.g., "My overdue high-priority tasks")
- Cannot name saved searches
- Cannot set saved search as default view

**Recommendation:**

**Defer to Post-MVP** - Saved searches add complexity

**Alternative for MVP:** Smart default views in "My Tasks" section:

- Overdue Tasks
- Due This Week
- High Priority
- Rejected (Needs Rework)

---

## Gap Category 9: Integration and API

### Gap 9.1: No External Integrations

**Current State:** Standalone system, no integrations

**What's Missing:**

- Cannot sync with Slack (post brief updates to channel)
- Cannot sync with Google Calendar (task due dates → calendar events)
- Cannot sync with Email (create brief from forwarded email)
- Cannot integrate with GitHub/Jira (link tasks to code/issues)

**Recommendation:**

**Defer to Post-MVP** - Integrations require OAuth, webhook infrastructure, maintenance overhead

**Post-MVP Priority Integrations:**

1. **Slack:** Post brief creation, task completion to Slack channel
2. **Google Calendar:** Sync task due dates
3. **Zapier:** Enable user-created integrations without custom code

---

### Gap 9.2: No Public API

**Current State:** No API for external developers

**What's Missing:**

- Cannot build custom integrations
- Cannot automate brief creation via API
- Cannot export data programmatically
- Cannot build mobile app using SingleBrief backend

**Recommendation:**

**Defer to Post-MVP** - Public API requires documentation, rate limiting, authentication (API keys), versioning

**Post-MVP:** RESTful API with endpoints:

- `POST /briefs` - Create brief
- `GET /briefs/:id/tasks` - List tasks
- `PATCH /tasks/:id` - Update task status
- `GET /users/me` - Current user info

---

## Gap Summary Matrix

| Gap ID | Gap Description | Category | Priority | Recommendation |
|--------|-----------------|----------|----------|----------------|
| 1.1 | No guided onboarding | Onboarding | **HIGH** | FR99 - Interactive onboarding |
| 1.2 | No rich empty states | Onboarding | **MEDIUM** | FR100 - Illustrations + guidance |
| 2.1 | No @mentions | Communication | **HIGH** | FR101 - @mentions in comments |
| 2.2 | No task reassignment | Collaboration | **HIGH** | FR102 - Reassign button |
| 2.3 | No notification history | Communication | **MEDIUM** | FR103 - Notification center |
| 3.1 | No project dashboard | Reporting | **MEDIUM** | FR104 - Project metrics |
| 3.2 | No time tracking | Reporting | **LOW** | Defer to post-MVP |
| 3.3 | No multi-format export | Reporting | **MEDIUM** | FR105 - CSV/Markdown export |
| 4.1 | No bulk actions | Efficiency | **HIGH** | FR106 - Bulk task operations |
| 4.2 | No undo mechanism | UX | **MEDIUM** | FR107 - Undo toast |
| 4.3 | No offline support | Accessibility | **LOW** | Defer to post-MVP |
| 5.1 | No accessibility plan | Accessibility | **HIGH** | NFR32 - WCAG 2.1 AA |
| 5.2 | No multi-language | Accessibility | **LOW** | Defer to post-MVP |
| 5.3 | No dark mode | UX | **MEDIUM** | FR108 - Theme toggle |
| 6.1 | No team permissions | Admin | **LOW** | Defer to post-MVP |
| 6.2 | No billing integration | Admin | **LOW** | Defer to post-MVP |
| 6.3 | No audit log | Admin | **MEDIUM** | FR109 - System audit log |
| 7.1 | No native mobile app | Mobile | **LOW** | Defer to post-MVP |
| 7.2 | No mobile gestures | Mobile | **MEDIUM** | FR110 - Swipe/long-press |
| 8.1 | No advanced search | Search | **MEDIUM** | FR111 - Advanced filters |
| 8.2 | No saved searches | Search | **LOW** | Defer to post-MVP |
| 9.1 | No integrations | Integration | **LOW** | Defer to post-MVP |
| 9.2 | No public API | Integration | **LOW** | Defer to post-MVP |

---

**Total Gaps Identified:** 23
**High Priority (Include in MVP):** 7
**Medium Priority (Consider for MVP):** 9
**Low Priority (Defer to Post-MVP):** 7

---

*Gap Analysis elicitation complete - 23 gaps identified, 13 new FRs proposed (FR99-FR111)*

Decision Documentation (Questions 9-12)

  Question 9: Onboarding Flow → B) Minimal onboarding
  - Welcome screen with "Create First Brief" CTA
  - Rich empty states (FR100) provide guidance
  - Balance between speed to value and user support

  Question 10: Bulk Task Actions → A) Full bulk actions
  - Select multiple tasks, assign/prioritize/archive in bulk
  - Essential for 20+ task briefs
  - FR106 added to MVP scope

  Question 11: Dark Mode → B) Light mode only
  - Defer to post-MVP
  - Focus MVP effort on core functionality
  - Add based on user demand post-launch

  Question 12: Mobile Gestures → C) No gestures in MVP
  - Standard tap interactions only
  - Validate mobile usage patterns first
  - Add gestures based on actual mobile user feedback