# SingleBrief - Global Navigation Structure & Information Architecture

**Document Type:** UI Specification - Navigation
**Version:** 1.0
**Date:** 2025-10-07
**Status:** Ready for Design

---

## Navigation Philosophy

**Core Principles:**
- **Task-Focused:** Primary navigation organized around user workflows (Create → Execute → Review)
- **Role-Aware:** Navigation adapts based on user role (Manager vs. Team Member)
- **Minimal Clicks:** Critical actions accessible in ≤2 clicks from any page
- **Progressive Disclosure:** Advanced features revealed contextually
- **Persistent Context:** Current brief/project always visible when relevant

---

## Global Navigation Structure

### Primary Navigation (Left Sidebar)

**Always Visible Navigation:**

```
┌─────────────────────────────────────┐
│ [Logo] SingleBrief                  │
├─────────────────────────────────────┤
│                                     │
│ 🏠 Dashboard                        │
│    └─ Badge: Action items count    │
│                                     │
│ 📝 Briefs                           │
│    ├─ All Briefs                   │
│    ├─ Active                       │
│    ├─ Completed                    │
│    └─ Archived                     │
│                                     │
│ ✅ My Tasks (Team Member)          │
│    ├─ To-Do                        │
│    ├─ In Progress                  │
│    ├─ Done                         │
│    └─ All Tasks                    │
│                                     │
│ 🔍 Search                          │
│                                     │
│ ⚙️ Settings                        │
│    ├─ Profile                      │
│    ├─ Notifications                │
│    ├─ Preferences                  │
│    └─ Help & Support               │
│                                     │
└─────────────────────────────────────┘
```

**Navigation States:**
- Active state: Bold text + left border accent
- Hover state: Background highlight
- Badge indicators: Red dot for urgent items, number for counts
- Collapsible: Sidebar can collapse to icons only (mobile/preference)

---

### Top Header (Global)

**Header Layout:**

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│ [Menu Icon] [Current Page Title]         [Search] [?] [Avatar]│
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Header Components:**

1. **Menu Icon** (Mobile only)
   - Hamburger icon to toggle sidebar
   - Only visible on screens <768px

2. **Current Page Title**
   - Dynamic: "Dashboard" | "Brief: [Title]" | "My Tasks" | "Settings"
   - Breadcrumb trail for nested pages: "Briefs > Marketing Campaign > Task #3"

3. **Global Search Icon**
   - Opens search overlay (Epic 6)
   - Keyboard shortcut: Cmd/Ctrl + K

4. **Help Icon** (?)
   - Opens Help & Support (Epic 10)
   - Tooltip: "Help & Support"

5. **User Avatar Dropdown**
   - Shows user avatar (or initials)
   - Dropdown menu:
     - Profile
     - Settings
     - Help
     - Sign Out

---

### Footer (Global)

**Footer Layout (Bottom of all pages):**

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│ © 2025 SingleBrief  •  Privacy  •  Terms  •  Help  •  v1.0.0  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Footer Links:**
- Privacy: Links to privacy policy
- Terms: Links to terms of service
- Help: Opens Help & Support tab in Settings
- Version number: Displays current app version

**Footer Positioning:**
- Sticky to bottom on short pages
- Natural position after content on long pages
- Background: Subtle gray (#F9FAFB)
- Text: Muted (#6B7280)

---

## Information Architecture

### Page Hierarchy

```
SingleBrief App
│
├─ 🏠 Dashboard (/)
│   ├─ Manager View
│   │   ├─ Action Center Widget (Epic 9)
│   │   ├─ Summary Analytics (Epic 9)
│   │   ├─ Periodic Reminders (Epic 9)
│   │   └─ Recent Briefs List
│   │
│   └─ Team Member View
│       ├─ My Tasks Widget (Epic 9)
│       ├─ Quick Filters (Epic 9)
│       └─ Task List Preview (Epic 9)
│
├─ 📝 Briefs (/briefs)
│   ├─ All Briefs List
│   │   └─ + New Brief Button (FAB)
│   │
│   └─ Brief Detail (/briefs/:id)
│       ├─ Brief Header
│       │   ├─ Title, Status, Created Date
│       │   ├─ Actions: Edit, Archive, Export PDF, Delete
│       │   └─ Progress Bar (% complete)
│       │
│       ├─ Tabs Navigation
│       │   ├─ Overview (default)
│       │   │   ├─ Description
│       │   │   ├─ "Why This Matters" (Epic 7)
│       │   │   └─ Quick Stats
│       │   │
│       │   ├─ Tasks
│       │   │   ├─ Task List (All tasks for this brief)
│       │   │   ├─ Filters: Status, Assignee, Priority
│       │   │   └─ + Add Task Button
│       │   │
│       │   ├─ Review (Manager only)
│       │   │   ├─ Pending Reviews List (Epic 4)
│       │   │   └─ Accept/Reject Workflow
│       │   │
│       │   └─ Activity
│       │       └─ Activity Timeline (Epic 5)
│       │
│       └─ Side Panel (Collapsible)
│           ├─ Brief Info
│           ├─ Team Members
│           └─ AI Agents Assigned
│
├─ ✅ My Tasks (/tasks)
│   ├─ My Tasks List (Team Member)
│   │   ├─ Filters: Status, Priority, Due Date
│   │   ├─ Sort: Due Date, Priority, Created Date
│   │   └─ Bulk Actions (Epic 6)
│   │
│   └─ Task Detail (/tasks/:id)
│       ├─ Task Header
│       │   ├─ Title, Status, Priority
│       │   ├─ Assignee, Due Date
│       │   └─ Actions: Edit, Change Status, Delete
│       │
│       ├─ Task Description
│       │   ├─ Full Description
│       │   └─ "Why This Matters" Context (Epic 7)
│       │
│       ├─ Output Section (if status = Done)
│       │   ├─ Output URL/Text
│       │   └─ Submitted Date
│       │
│       ├─ Comments Section (Epic 5)
│       │   ├─ Comment Thread
│       │   ├─ @Mentions Support
│       │   └─ Add Comment Input
│       │
│       └─ Activity Log
│           └─ Status changes, assignee changes, edits
│
├─ 🔍 Search (/search)
│   ├─ Global Search (Epic 6)
│   │   ├─ Search Input (Cmd/Ctrl + K)
│   │   ├─ Filters: Briefs, Tasks, Comments
│   │   └─ Results List with highlighting
│   │
│   └─ Advanced Search (Future)
│
└─ ⚙️ Settings (/settings)
    ├─ Profile Tab (Epic 10)
    │   ├─ Name, Email, Avatar
    │   ├─ Role, Bio
    │   └─ Save Changes
    │
    ├─ Notifications Tab (Epic 10)
    │   ├─ Master Toggles (Email, In-App)
    │   ├─ Granular Toggles (8 types)
    │   ├─ Do Not Disturb
    │   ├─ Per-Brief Mutes
    │   └─ Save Changes
    │
    ├─ Preferences Tab (Epic 10)
    │   ├─ Default Task Limit
    │   ├─ Timezone
    │   ├─ Language
    │   └─ Save Changes
    │
    └─ Help & Support Tab (Epic 10)
        ├─ Getting Started Guide
        ├─ FAQ Accordion
        ├─ Contact Support
        └─ Product Tour
```

---

## Role-Based Navigation

### Manager Navigation

**Visible Items:**
- Dashboard (Manager View)
- Briefs (Full access to create, edit, archive)
- My Tasks (Only tasks assigned to them)
- Search
- Settings

**Manager-Only Features:**
- Review tab in Brief Detail
- Action Center Widget
- Summary Analytics
- Execute AI Tasks button

### Team Member Navigation

**Visible Items:**
- Dashboard (Team Member View)
- Briefs (Read-only access)
- My Tasks (Full access)
- Search
- Settings

**Team Member-Only Features:**
- My Tasks Widget (prominent)
- Quick Filters (Due Today, High Priority)
- Start Task button

---

## Contextual Navigation

### Floating Action Button (FAB)

**Location:** Bottom-right corner (fixed position)

**Context-Aware Display:**

1. **Dashboard Page:**
   - Button: "+ New Brief"
   - Action: Opens Create Brief Dialog (Epic 1)

2. **Briefs List Page:**
   - Button: "+ New Brief"
   - Action: Opens Create Brief Dialog

3. **Brief Detail Page (Tasks Tab):**
   - Button: "+ Add Task"
   - Action: Opens Quick Add Task Modal (Epic 2)

4. **My Tasks Page:**
   - Button: "+ Quick Add Task"
   - Action: Opens Quick Add Task Modal

5. **Manager Dashboard (AI Tasks Queued):**
   - Button: "⚡ Execute AI Tasks"
   - Action: Opens AI Execution Confirmation Dialog (Epic 3)

**FAB States:**
- Default: Primary color (#6366F1)
- Hover: Darker shade
- Disabled: Grayed out with tooltip explaining why

---

## Responsive Behavior

### Desktop (≥1024px)
- Sidebar: Always visible (240px width)
- Header: Full width with all elements
- Footer: Full width
- Content: Max-width 1280px, centered

### Tablet (768px - 1023px)
- Sidebar: Collapsible, starts collapsed
- Header: Hamburger menu + title + icons
- Footer: Full width
- Content: Full width with padding

### Mobile (<768px)
- Sidebar: Drawer (overlay), hidden by default
- Header: Compact (menu + title + avatar only)
- Footer: Stacked links, smaller font
- Content: Full width, minimal padding
- FAB: Smaller size (56px → 48px)

---

## Navigation Patterns

### Page Transitions
- **Same-level navigation:** Instant (no animation)
- **Drill-down navigation:** Slide-in from right
- **Drill-up navigation:** Slide-out to right
- **Modal overlays:** Fade in with backdrop

### Loading States
- **Page load:** Skeleton loaders for content areas
- **Sidebar:** Instant (no loading state)
- **Header:** Instant (user data loads progressively)
- **Search:** Spinner in search input

### Empty States
- **Dashboard:** "Create your first brief to get started" with CTA
- **Briefs List:** "No briefs yet. Click + New Brief to create one."
- **My Tasks:** "No tasks assigned yet. Check back soon!"
- **Search Results:** "No results found. Try different keywords."

---

## Accessibility

### Keyboard Navigation
- **Tab:** Navigate through interactive elements
- **Shift + Tab:** Navigate backwards
- **Enter/Space:** Activate buttons and links
- **Escape:** Close modals and dropdowns
- **Cmd/Ctrl + K:** Open global search
- **Cmd/Ctrl + B:** Toggle sidebar
- **Arrow keys:** Navigate within lists and menus

### Screen Reader Support
- **Landmarks:** Proper ARIA landmarks (nav, main, aside, footer)
- **Labels:** All interactive elements have accessible labels
- **Live Regions:** Dynamic content updates announced
- **Skip Links:** "Skip to main content" link at top

### Focus Management
- **Focus indicators:** Visible focus rings (2px solid #6366F1)
- **Focus trap:** Modals trap focus within dialog
- **Focus return:** Focus returns to trigger element after modal close

---

## Visual Design Tokens

### Colors
- **Primary:** #6366F1 (Indigo 600)
- **Primary Hover:** #4F46E5 (Indigo 700)
- **Background:** #FFFFFF (White)
- **Surface:** #F9FAFB (Gray 50)
- **Border:** #E5E7EB (Gray 200)
- **Text Primary:** #111827 (Gray 900)
- **Text Secondary:** #6B7280 (Gray 500)
- **Success:** #10B981 (Green 500)
- **Warning:** #F59E0B (Amber 500)
- **Error:** #EF4444 (Red 500)

### Typography
- **Font Family:** Inter, system-ui, sans-serif
- **Headings:** 600 weight (Semi-bold)
- **Body:** 400 weight (Regular)
- **Navigation:** 500 weight (Medium)
- **Small Text:** 400 weight, 14px

### Spacing
- **Sidebar Padding:** 16px
- **Header Height:** 64px
- **Footer Height:** 48px
- **Content Padding:** 24px (desktop), 16px (mobile)
- **Component Gap:** 16px
- **Section Gap:** 32px

### Shadows
- **Sidebar:** box-shadow: 2px 0 8px rgba(0,0,0,0.04)
- **Header:** box-shadow: 0 1px 3px rgba(0,0,0,0.06)
- **Cards:** box-shadow: 0 1px 3px rgba(0,0,0,0.12)
- **Modals:** box-shadow: 0 20px 25px rgba(0,0,0,0.15)

---

## Logo Placement

### Logo Specifications
- **Location:** Top-left corner of sidebar
- **Size:**
  - Full sidebar: 160px width × 40px height
  - Collapsed sidebar: 32px × 32px (icon only)
- **Format:** SVG (scalable)
- **Variants:**
  - Full logo: Text + Icon
  - Icon only: For collapsed sidebar and mobile
- **Colors:**
  - Primary: Use brand color (#6366F1)
  - Monochrome: For dark mode (future)

### Logo Behavior
- **Click:** Returns to Dashboard (/)
- **Hover:** Subtle opacity change (0.9)
- **Mobile:** Shows icon only in collapsed state

---

## Page Templates

### Template 1: Dashboard Page
```
┌─────────────────────────────────────────────────────────────┐
│ Header: [Menu] Dashboard                    [Search] [Avatar]│
├──────┬──────────────────────────────────────────────────────┤
│      │                                                      │
│ Side │  [Periodic Reminder Banner - Dismissible]           │
│ bar  │                                                      │
│      │  ┌────────────┬────────────┬────────────┐          │
│ Nav  │  │ Action Ctr │ Analytics  │ Reminders  │          │
│ Menu │  └────────────┴────────────┴────────────┘          │
│      │                                                      │
│      │  Recent Briefs List                                 │
│      │  ┌──────────────────────────────────────┐          │
│      │  │ Brief 1                              │          │
│      │  │ Brief 2                              │          │
│      │  │ Brief 3                              │          │
│      │  └──────────────────────────────────────┘          │
│      │                                                      │
│      │                               [+ New Brief FAB]     │
├──────┴──────────────────────────────────────────────────────┤
│ Footer: © 2025 SingleBrief • Privacy • Terms • Help        │
└─────────────────────────────────────────────────────────────┘
```

### Template 2: Brief Detail Page
```
┌─────────────────────────────────────────────────────────────┐
│ Header: Brief: Marketing Campaign            [Search] [Avatar]│
├──────┬──────────────────────────────────────────┬───────────┤
│      │                                          │           │
│ Side │  Brief Header (Title, Status, Actions)  │  Side     │
│ bar  │  Progress Bar                            │  Panel    │
│      │  ─────────────────────────────────────── │           │
│ Nav  │  Tabs: [Overview][Tasks][Review][Activity]│  Info   │
│ Menu │                                          │  Team     │
│      │  Tab Content Area                        │  AI       │
│      │  (Dynamic based on active tab)           │           │
│      │                                          │           │
│      │                                          │           │
│      │                               [FAB]      │           │
├──────┴──────────────────────────────────────────┴───────────┤
│ Footer                                                       │
└─────────────────────────────────────────────────────────────┘
```

### Template 3: Settings Page
```
┌─────────────────────────────────────────────────────────────┐
│ Header: Settings                             [Search] [Avatar]│
├──────┬──────────────────────────────────────────────────────┤
│      │                                                      │
│ Side │  Tabs: [Profile][Notifications][Preferences][Help] │
│ bar  │  ───────────────────────────────────────────────── │
│      │                                                      │
│ Nav  │  Tab Content Area                                   │
│ Menu │  (Forms, toggles, inputs)                          │
│      │                                                      │
│      │                                                      │
│      │  [Save Changes Button]                              │
│      │                                                      │
├──────┴──────────────────────────────────────────────────────┤
│ Footer                                                       │
└─────────────────────────────────────────────────────────────┘
```

---

## Component Library Reference

### shadcn/ui Components Used

**Navigation:**
- Sidebar component (custom)
- Navigation Menu
- Dropdown Menu
- Breadcrumb

**Layout:**
- Card
- Tabs
- Sheet (for mobile drawer)
- Dialog (for modals)

**Interactive:**
- Button
- Input
- Select
- Switch
- Slider
- Checkbox

**Feedback:**
- Toast
- Alert
- Badge
- Progress
- Skeleton

**Content:**
- Avatar
- Accordion
- Table
- Tooltip

---

## Design System Documentation

**For complete design system specifications, see:**
- Color palette: `docs/design/colors.md`
- Typography scale: `docs/design/typography.md`
- Component library: `docs/design/components.md`
- Icon set: `docs/design/icons.md`

**For implementation details, see:**
- shadcn/ui setup: `components.json`
- Tailwind config: `tailwind.config.ts`
- Global styles: `src/index.css`

---

**Document Status:** Ready for Design Review
**Next Steps:**
1. Review with design team
2. Create UI mockups in Figma
3. Implement navigation components
4. Test responsive behavior
5. Validate accessibility compliance
