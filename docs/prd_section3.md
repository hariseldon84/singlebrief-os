# SingleBrief Brownfield Enhancement PRD - Section 3

## User Interface Enhancement Goals

### Integration with Existing UI

#### Existing Design System

**Component Library:** shadcn/ui (Radix UI primitives)

**Styling:** Tailwind CSS

**Icons:** Lucide React

**Patterns:**
- Card-based layouts
- Dialog modals
- Toast notifications

**Consistency Requirements:**

All new UI elements for SingleBrief MVP must:
- Use existing shadcn/ui components (Button, Card, Dialog, Input, Textarea, etc.)
- Follow Tailwind utility class patterns from existing Dashboard and Auth pages
- Use Lucide React icons for consistency with existing icon usage (Plus, LogOut, Sparkles, FolderOpen, Calendar)
- Maintain existing Card-based layout pattern for content containers
- Use existing Toast notification system for user feedback
- Follow existing Dialog pattern for modal interactions

---

### Modified/New Screens and Views

#### 1. Dashboard View (Modified)

**Existing:** Project list with create button

**New Elements:**
- Brief count badge on each project card
- Quick "Create Brief" button in navigation
- Search bar for briefs across all projects (FR30)
- Manual refresh button (FR31)
- Progress indicators showing active briefs per project

**UI Components:**
- Extend existing `Card` component for project cards
- Add `Badge` component for brief counts
- Add `Input` with search icon for brief search
- Add `Button` with refresh icon (Lucide's `RefreshCw`)
- Add `Progress` component for visual progress bars

---

#### 2. Brief Creation View (New)

**Purpose:** Simple text input for creating briefs

**Layout:**
- Full-screen Dialog modal (using existing `Dialog` component)
- Large `Textarea` (minimum 6 rows) for brief content
- Character count indicator (helpful, non-blocking)
- "Create Brief" button (primary action)
- "Cancel" button (secondary action)

**UI Flow:**

1. User clicks "New Brief" button from Dashboard or Project view
2. Dialog opens with focus on textarea
3. User types brief description (free-form text)
4. Click "Create Brief" triggers AI task breakdown
5. Loading state shows "Generating tasks..." with spinner
6. On completion, navigate to Brief Detail view

**Accessibility:**
- Textarea has clear label "Describe your project or initiative"
- Keyboard shortcuts: ESC to cancel, Cmd/Ctrl+Enter to submit
- Focus trap within dialog

---

#### 3. Brief Detail View (New)

**Purpose:** Central view showing brief, AI-generated tasks, and progress

**Layout Sections:**

**A. Brief Header**
- Brief title (editable inline)
- "Why This Matters" section (collapsible, shows AFTER task breakdown per FR13)
- Progress indicator (% complete based on completed tasks / total tasks per FR27)
- Action buttons: Edit Brief, Export PDF, Delete Brief

**B. Task List**
- Task cards showing:
  - Task title (editable)
  - Task description (editable)
  - Assignee (dropdown: AI agents or team members)
  - Status label (To Do, In Progress, Under Review, Complete per FR29)
  - Action buttons: View Output, Accept, Reject, Re-run (based on status)
- Add Task button (+ icon for manual task creation per FR9)
- Visual grouping by status (columns or sections)

**C. "Why This Matters" Section (Optional, Collapsible)**
- Shows AFTER task breakdown (FR13)
- Editable text area (FR14)
- "Regenerate" button with feedback prompt (FR15)
- "Skip" option to hide entirely (FR16)
- Collapsed by default, expand with user interaction

**UI Components:**
- `Card` for brief header
- `Collapsible` for "Why This Matters" section
- `Badge` for status labels
- `Select` or `Dropdown` for assignee selection
- `Button` variants for actions (primary, secondary, destructive)
- `Separator` between task list sections

---

#### 4. Task Output Review Modal (New)

**Purpose:** Manager reviews AI/human task outputs and provides feedback

**Layout:**
- Full-screen `Dialog` modal
- Task title and description (read-only header)
- Output content (read-only text display or rendered content)
- Feedback textarea (appears when "Reject" clicked)
- Action buttons:
  - "Accept" (green, completes task)
  - "Reject" (red, shows feedback textarea)
  - "Re-run" (orange, re-assigns task with optional feedback)

**UI Flow:**

1. Manager clicks "View Output" on task card
2. Modal opens showing task output
3. Manager reviews content
4. Choose action: Accept (task completes), Reject (provide feedback), or Re-run (try again)
5. Feedback textarea appears if Reject/Re-run selected
6. Submit action, modal closes, task status updates

**Accessibility:**
- Clear button labeling
- Keyboard navigation (Tab through actions)
- Confirm dialog for destructive actions

---

#### 5. Project Detail View (Modified)

**Existing:** Basic project information

**New Elements:**
- List of briefs within project
- Brief cards showing:
  - Brief title
  - Progress bar (% complete)
  - Task count (total and completed)
  - Last updated timestamp
  - Quick actions: View, Edit, Delete
- "New Brief" button scoped to current project
- Search briefs within project

**UI Components:**
- Extend existing project card pattern
- Add `Progress` component for brief progress bars
- Add brief count badges
- Add timestamp display (using date-fns for formatting)

---

#### 6. Team Management View (New)

**Purpose:** Add/remove team members (FR33-FR35)

**Layout:**
- Settings-style page (not modal)
- Team member list with:
  - Avatar (or initials badge)
  - Name
  - Email
  - Role (if FR36 implemented)
  - "Remove" button (with confirmation)
- "Add Team Member" button opens dialog with email input
- Email invitation sent on submit

**UI Components:**
- `Avatar` component (from shadcn/ui)
- `Table` or `Card` list for team members
- `Dialog` for add member flow
- `Input` for email entry
- `Alert` for removal confirmation

---

#### 7. Search Results View (New)

**Purpose:** Display brief search results across workspace (FR30)

**Layout:**
- Search input in navigation (always visible)
- Results page showing:
  - Brief title (clickable to Brief Detail)
  - Brief excerpt (first 200 characters)
  - Project badge (which project this brief belongs to)
  - Match highlighting (keyword highlighted in excerpt)
  - Last updated timestamp
- Empty state: "No briefs found matching 'keyword'"

**UI Components:**
- `Input` with search icon (Lucide's `Search`)
- `Card` for each result
- `Badge` for project association
- Text highlight utility (Tailwind `bg-yellow-200`)

---

### UI Consistency Requirements

#### Design Patterns to Follow

**1. Button Hierarchy:**
- Primary action: Default shadcn Button (solid background)
- Secondary action: Button variant="outline"
- Destructive action: Button variant="destructive"

**2. Modal Pattern:**
- Use `Dialog` component for all modals
- Full-screen for complex forms (Brief Creation, Task Review)
- Standard size for simple actions (Delete confirmation)

**3. Loading States:**
- Use `Skeleton` component during data loading
- Show spinner with text for AI operations ("Generating tasks...")
- Optimistic UI updates where possible

**4. Error Handling:**
- Use existing `toast` pattern for error messages
- Variant="destructive" for errors
- Include actionable message (not raw error codes per NFR18)

**5. Responsive Design:**
- Mobile-first approach using Tailwind breakpoints
- Tablet-optimized (per NFR21)
- Desktop enhancements (wider cards, multi-column layouts)

**6. Icons:**

Use Lucide React exclusively for consistency

**Suggested icons:**
- Brief: `FileText`
- Task: `CheckSquare`
- AI Agent: `Sparkles` or `Bot`
- Team Member: `User` or `Users`
- Progress: `TrendingUp` or `Activity`
- Refresh: `RefreshCw`
- Export: `Download`

---

## UI Design Decisions

### Trade-offs

- **Dialog Pattern:** Used existing Dialog pattern for all modals (consistency over innovation)
- **Card-based Layouts:** Matching existing Dashboard (familiarity over novelty)
- **Collapsible "Why This Matters":** Reduces visual clutter for optional feature
- **Full-screen Task Review:** Output might be lengthy, needs space for proper review

### Key Assumptions

- Existing shadcn/ui theme provides sufficient color palette for status labels
- Lucide icons library has all needed icons (verified: FileText, CheckSquare, Bot, RefreshCw, etc.)
- Tailwind CSS configuration supports all needed utilities
- Toast notification system can handle all user feedback needs

### Design Decisions

- **"Why This Matters" timing:** Shows AFTER task breakdown (per FR13) - requires UI state management
- **Search highlighting:** Matches highlighted in results (improves scannability)
- **Progress bars:** On both Project cards AND Brief cards (different granularities)
- **Team Management:** Full page (not modal) - implies settings-style navigation

### Open Questions

- Should Brief Detail view be single-page or tabbed (Overview, Tasks, Why This Matters)?
- Should task list be Kanban-style columns (by status) or linear list with status badges?
- Do we need dark mode support, or is existing theme sufficient?
- Should PDF export preview brief before generating, or direct download?

---

*Section 3 of SingleBrief Brownfield Enhancement PRD*
