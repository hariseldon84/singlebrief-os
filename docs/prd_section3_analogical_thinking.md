# PRD Section 3 - Analogical Thinking (Product UI Comparisons)

**Date:** 2025-10-04
**Elicitation Method:** Analogical Thinking
**Purpose:** Compare SingleBrief UI to similar products, identify patterns to adopt or avoid

---

## Analogy 1: Asana - Project Management UI Patterns

### What We Can Learn

**Task Cards with Rich Metadata:**

- Asana shows assignee avatar, due date, subtask count, attachment count in single card
- **Adoption:** SingleBrief task cards should show: Assignee (avatar), Due date, Priority badge, Status badge, Progress % (if enabled)

**Sectioned Views:**

- Asana separates "My Tasks" from "Projects I'm In"
- **Adoption:** Aligns with our unified dashboard decision (Risk Decision: dual-role support)
- Our "My Briefs" + "My Tasks" sections mirror Asana's pattern

**Customizable Sorting:**

- Asana allows sort by: Due date, Priority, Assignee, Custom
- **Adoption:** FR enhancement - Add custom sort options to task list

**Comments on Tasks:**

- Asana has threaded comments, @mentions, file attachments per task
- **Gap Identified:** Our current design has manager feedback (rejection) but no general commenting
- **New Requirement Candidate:** FR93 - Task comments for async collaboration

---

### What to Avoid

**Feature Overload:**

- Asana has 50+ features (Timeline, Workload, Goals, Portfolios, etc.)
- **Learning:** Stay focused on MVP core loop - Brief → Tasks → Execution → Review
- Resist feature creep during MVP phase

**Complex Onboarding:**

- Asana requires 15-minute tutorial for new users (overwhelming)
- **Learning:** SingleBrief onboarding should be <3 minutes - Show value immediately

---

## Analogy 2: Trello - Visual Simplicity

### What We Can Learn

**Drag-and-Drop Status Changes:**

- Trello's Kanban board allows dragging cards between columns
- **Decision:** We chose Linear List over Kanban (Trade-off Analysis), but...
- **Adoption:** Post-MVP, offer Kanban view as alternative layout (view switcher)

**Card Labels (Priority/Category):**

- Trello uses color-coded labels visible on collapsed cards
- **Adoption:** Our priority badges (High: red, Medium: yellow, Low: gray) mirror this pattern

**Minimalist Card Design:**

- Trello cards show: Title, Labels, Due date, Attachments count, Members (avatars)
- **Adoption:** Keep task cards clean - Essential info only on collapsed state, details on click

**Quick-Add Workflow:**

- Trello allows adding card with just title (expand later to add details)
- **Gap Identified:** Our "Add Task" button (FR9) should support quick-add
- **New Requirement Candidate:** FR94 - Quick-add task (title only, expand for details)

---

### What to Avoid

**Lack of Task Dependencies:**

- Trello doesn't support task dependencies (must use Power-Ups)
- **Learning:** Even in MVP, consider showing task relationships (e.g., "Task 3 depends on Task 1")
- **Defer to Post-MVP:** Task dependencies are complex, not MVP scope

**No Built-in Time Tracking:**

- Trello relies on third-party integrations for time estimates
- **Learning:** Our progress % slider (optional per brief) is simpler than time tracking
- Avoid time tracking complexity in MVP

---

## Analogy 3: Linear - Speed and Keyboard Shortcuts

### What We Can Learn

**Keyboard-First Design:**

- Linear emphasizes keyboard shortcuts (Cmd+K command palette, quick task creation)
- **Adoption:** Post-MVP enhancement - Command palette for power users
- **MVP:** Focus on mouse/touch interactions (mobile-first)

**Instant Search:**

- Linear's search shows results as you type (no "Enter" required)
- **Adoption:** Auto-suggest for brief search (FR enhancement)
- Show top 3 matches while typing

**Status Transitions:**

- Linear uses dropdown for status changes (not drag-and-drop)
- **Validation:** Confirms our Linear List decision (status dropdown over Kanban)

**Minimal Chrome:**

- Linear has very little UI chrome (no sidebars by default)
- **Adoption:** SingleBrief should maximize content area, minimize navigation clutter
- Collapsible sidebar for projects (if needed)

---

### What to Avoid

**Developer-Centric Jargon:**

- Linear uses terms like "Cycles", "Triage", "Backlog" (confusing for non-devs)
- **Learning:** Use business-friendly language: "Briefs" not "Epics", "Tasks" not "Issues"

**GitHub Integration Focus:**

- Linear is heavily optimized for developer workflows
- **Learning:** SingleBrief targets managers, not just developers - Avoid technical bias

---

## Analogy 4: Notion - Flexible Content Blocks

### What We Can Learn

**Inline Editing:**

- Notion allows editing text fields directly (click to edit, no "Edit" button)
- **Adoption:** Brief title, task titles should be inline-editable (click to edit)
- Reduces friction, feels modern

**Collapsible Sections:**

- Notion uses toggle blocks extensively (hide/show content)
- **Validation:** Confirms our "Why This Matters" collapsible decision (Trade-off Analysis)

**Templates:**

- Notion has template gallery (pre-built structures)
- **Gap Identified:** Brief templates could accelerate creation
- **New Requirement Candidate:** FR95 - Brief templates (e.g., "Marketing Campaign", "Product Launch")

**Block-Based Content:**

- Notion uses modular content blocks (text, checklist, table)
- **Learning:** Our brief creation is simple textarea (MVP) - Consider rich editor post-MVP
- Defer complexity, validate demand first

---

### What to Avoid

**Overwhelming Flexibility:**

- Notion can be "too flexible" - users paralyzed by blank page
- **Learning:** SingleBrief solves this with AI task breakdown (structured output)
- Resist temptation to add rich formatting options in brief textarea

**Steep Learning Curve:**

- Notion requires investment to master (30+ minute onboarding)
- **Learning:** SingleBrief must be intuitive from first use (<3 min to first brief created)

---

## Analogy 5: Basecamp - Communication-Centric

### What We Can Learn

**Centralized Discussions:**

- Basecamp has "Message Board" per project (threaded discussions)
- **Gap Identified:** SingleBrief lacks team communication beyond task feedback
- **New Requirement Candidate:** FR96 - Brief-level discussions (optional message board)

**To-Do Lists with Comments:**

- Basecamp allows commenting on individual to-dos (async clarification)
- **Adoption:** Aligns with Risk 3.2 mitigation (rejection demotivation)
- **New Requirement Candidate:** FR93 - Task comments thread (already identified in Asana analogy)

**Hill Charts (Progress Visualization):**

- Basecamp uses hill charts to show progress (uphill = figuring it out, downhill = executing)
- **Learning:** Creative progress visualization beyond % slider
- **Defer to Post-MVP:** Interesting but complex for MVP

**Automatic Check-Ins:**

- Basecamp prompts team members: "What did you work on today?"
- **Adoption:** Could tie to progress % updates (Risk 1.2 mitigation)
- **New Requirement Candidate:** FR97 - Daily check-in prompts (opt-in per brief)

---

### What to Avoid

**Email-Heavy Workflow:**

- Basecamp sends emails for every comment/update (notification fatigue)
- **Learning:** Our notification strategy should be selective (critical events only)
- Email: Task assigned, due in 24h, rejected (not every status change)

---

## Analogy 6: Figma - Real-Time Collaboration

### What We Can Learn

**Presence Indicators:**

- Figma shows who's viewing/editing in real-time (avatars at top)
- **Adoption:** Risk 5.1 mitigation (concurrent edit conflicts)
- Show "Sarah is viewing this task" indicator

**Commenting on Specific Elements:**

- Figma allows pinning comments to specific objects
- **Learning:** For task outputs (especially design work), inline comments > general feedback
- **New Requirement Candidate:** FR98 - Inline comments on task outputs (post-MVP)

**Version History:**

- Figma has full version history with previews
- **Adoption:** Already planned in FR88 (Version Comparison UI from Scenario Planning)
- Task outputs should show version history (v1, v2, v3)

---

### What to Avoid

**Complex Permissions:**

- Figma has 5+ permission levels (View, Edit, Can Edit Styles, etc.)
- **Learning:** Our decision (Challenge Assumptions) - No access control in MVP (everyone sees everything)
- Keep simple for small teams

---

## Analogy 7: Slack - Notifications Done Right

### What We Can Learn

**Notification Preferences:**

- Slack allows granular control: All messages, Direct mentions, Nothing
- **Adoption:** Settings page (FR71) should include notification preferences
- Per-brief notification settings (mute specific briefs)

**Unread Badges:**

- Slack shows unread count badges prominently
- **Adoption:** "My Tasks" badge showing unread task count (new assignments, rejections)

**Do Not Disturb:**

- Slack has DND hours (auto-pause notifications)
- **Adoption:** Respect user's working hours (don't send email notifications after 9pm)

**Threading:**

- Slack uses threaded replies to keep conversations organized
- **Adoption:** If we add FR93 (task comments), use threaded replies

---

### What to Avoid

**Notification Overload:**

- Slack can be overwhelming (pings every 30 seconds)
- **Learning:** Default to minimal notifications, let users opt-in to more

---

## Analogy 8: Google Docs - Collaborative Editing

### What We Can Learn

**Suggestion Mode:**

- Google Docs has "Suggesting" mode (tracked changes, accept/reject)
- **Analogy:** Our manager review workflow (Accept/Reject task outputs) mirrors this
- **Validation:** Confirms our FR59 design (rejection feedback loop)

**Activity History:**

- Google Docs shows "Last edit was 2 hours ago by Sarah"
- **Adoption:** Task cards should show last activity timestamp

**Offline Mode:**

- Google Docs works offline, syncs when reconnected
- **Learning:** Consider offline support post-MVP (PWA with service workers)
- **MVP:** Online-only acceptable

---

### What to Avoid

**Real-Time Editing Complexity:**

- Google Docs' Operational Transform is complex (conflict resolution)
- **Learning:** Our 30-second polling + optimistic locking (Risk 5.1) is simpler
- Don't over-engineer concurrency for MVP

---

## New Requirements Discovered from Analogies

### FR93: Task Comments Thread

**Source:** Asana, Basecamp analogies

**Requirement:** Tasks shall support threaded comments for async collaboration between manager and assignee. Comments visible to all users with task access. Supports @mentions for notifications.

**Use Cases:**

- Team member asks clarifying question before starting task
- Manager provides guidance without rejecting output
- Async discussion reduces email back-and-forth

**UI:**

- "Comments" section in Task Detail view
- Comment input with @mention autocomplete
- Thread display with timestamps and user avatars

---

### FR94: Quick-Add Task

**Source:** Trello analogy

**Requirement:** Brief Detail view shall support quick-add task workflow: Enter title only, press Enter, task created with default values. User can expand task later to add description, assignee, priority.

**Benefits:**

- Faster workflow for managers adding manual tasks
- Reduces friction (don't need all fields upfront)

**UI:**

- "+ Add Task" input field at bottom of task list
- Type title, press Enter → Task created (status: To-Do, priority: Medium)
- Click task to expand and edit details

---

### FR95: Brief Templates

**Source:** Notion analogy

**Requirement:** System shall provide brief template gallery with pre-defined structures for common use cases: Marketing Campaign, Product Launch, Hiring Process, Event Planning. Templates include example brief text and suggested task types.

**Benefits:**

- Reduces blank page paralysis (Risk 1.3 related)
- Accelerates brief creation for first-time users
- Demonstrates platform capabilities

**UI:**

- "Use Template" button in brief creation dialog
- Template selector modal with previews
- Selected template populates textarea (user can edit before submitting)

---

### FR96: Brief-Level Discussions

**Source:** Basecamp analogy

**Requirement:** Briefs shall support optional discussion board for team-wide conversations not tied to specific tasks. Manager can enable/disable discussion per brief.

**Defer to Post-MVP:** Communication complexity should be validated before implementing.

---

### FR97: Daily Check-In Prompts

**Source:** Basecamp analogy

**Requirement:** System shall send optional daily check-in prompt to team members with in-progress tasks: "What did you work on today?" Response updates task comments and triggers progress % suggestion.

**Defer to Post-MVP:** Behavioral nudge should be validated through user research.

---

### FR98: Inline Comments on Task Outputs

**Source:** Figma analogy

**Requirement:** For task outputs with visual content (wireframes, designs), manager shall be able to pin comments to specific areas of output (not just general feedback).

**Defer to Post-MVP:** Complex implementation, validate demand first.

---

## UI Pattern Adoption Matrix

| Product | Pattern | SingleBrief Adoption | Status |
|---------|---------|----------------------|--------|
| **Asana** | Rich task cards with metadata | Assignee avatar, due date, priority, status, progress % | ✅ Adopted |
| **Asana** | Task comments thread | FR93 - Task comments for collaboration | ✅ New FR |
| **Trello** | Color-coded priority labels | High: red, Medium: yellow, Low: gray badges | ✅ Adopted |
| **Trello** | Quick-add workflow | FR94 - Quick-add task (title only) | ✅ New FR |
| **Linear** | Instant search with auto-suggest | Show top 3 matches while typing | 📋 Post-MVP |
| **Linear** | Minimal UI chrome | Maximize content area, collapsible sidebar | ✅ Adopted |
| **Notion** | Inline editing | Click-to-edit for titles (no "Edit" button) | ✅ Adopted |
| **Notion** | Templates | FR95 - Brief template gallery | ✅ New FR |
| **Basecamp** | Daily check-ins | FR97 - Optional daily prompts | 📋 Post-MVP |
| **Figma** | Presence indicators | "Sarah is viewing this task" | ✅ Adopted (Risk 5.1) |
| **Figma** | Version history | FR88 - Version comparison UI | ✅ Already planned |
| **Slack** | Notification preferences | Per-brief notification settings in FR71 | ✅ Adopted |
| **Slack** | Unread badges | "My Tasks" badge with count | ✅ Adopted |
| **Google Docs** | Suggestion mode | Accept/Reject workflow (FR59) | ✅ Adopted |
| **Google Docs** | Activity history | "Last updated 2h ago by Sarah" | ✅ Adopted |

---

## Key Design Principles from Analogical Thinking

**1. Adopt Proven Patterns**

- Don't reinvent task cards (Asana), priority labels (Trello), status dropdowns (Linear)
- Users expect familiar patterns - leverage existing mental models

**2. Simplify for MVP**

- Avoid Notion's overwhelming flexibility
- Avoid Asana's feature overload
- Focus on core loop: Brief → Tasks → Execution → Review

**3. Mobile-First Constraints**

- Linear list beats Kanban (mobile scrolling > horizontal swiping)
- Touch-friendly interactions over keyboard shortcuts

**4. Communication is Critical**

- All analogies emphasize collaboration (comments, threads, discussions)
- FR93 (task comments) is essential for async work

**5. Smart Defaults, Flexible Overrides**

- Learn from Slack notifications (default minimal, opt-in for more)
- Learn from Basecamp check-ins (opt-in per brief)

---

## Critical Questions for User Review

### Question 5: Task Comments - Essential or Defer?

**Context:** FR93 identified from Asana and Basecamp patterns - Task-level threaded comments for collaboration

**Question:** Should task comments be included in MVP or deferred?

**Options:**

- **A) Include in MVP** - Essential for async collaboration, prevents email overload
- **B) Defer to post-MVP** - Focus on core loop first, add based on demand
- **C) Simplified version in MVP** - Manager feedback only (no general commenting)

---

### Question 6: Quick-Add Task Workflow

**Context:** FR94 identified from Trello pattern - Quick-add task with title only

**Question:** Should we implement quick-add workflow for manual tasks?

**Options:**

- **A) Yes, include in MVP** - Faster workflow for managers, low complexity
- **B) No, defer to post-MVP** - Full form only (title + description required)
- **C) Title required, description optional** - Middle ground (no "expand later" complexity)

---

### Question 7: Brief Templates

**Context:** FR95 identified from Notion pattern - Template gallery to reduce blank page paralysis

**Question:** Should brief templates be included in MVP?

**Options:**

- **A) Yes, 3-5 core templates** - Marketing Campaign, Product Launch, Event Planning
- **B) No, defer to post-MVP** - Focus on AI generation first, validate template demand later
- **C) Single "Example Brief"** - Show one example in empty state, not full template system

---

### Question 8: Presence Indicators

**Context:** Identified from Figma analogy - Show who's viewing/editing tasks in real-time

**Question:** Should we implement presence indicators to prevent concurrent edit conflicts (Risk 5.1)?

**Options:**

- **A) Yes, full presence system** - Show avatars of users viewing task (like Figma/Google Docs)
- **B) Simpler conflict detection** - Just show warning if edit conflict occurs (no real-time presence)
- **C) Defer to post-MVP** - Accept risk of occasional conflicts, optimize for speed

---

*Analogical Thinking elicitation complete - 3 new requirements added (FR93-FR95), 4 critical questions for user decision*
