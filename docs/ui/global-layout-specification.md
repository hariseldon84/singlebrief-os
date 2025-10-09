# SingleBrief - Global Layout Specification

**Document Type:** UI Specification - Layout Templates
**Version:** 1.0
**Date:** 2025-10-07
**Status:** Ready for Design

---

## Purpose

This document defines reusable page layout templates for SingleBrief. All page-specific UI specifications should reference these templates to maintain consistency.

---

## Layout Components

### 1. Global Header

**Component Name:** `GlobalHeader`
**File:** `src/components/layout/GlobalHeader.tsx`

**Specifications:**

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│ [Menu Icon] [Page Title / Breadcrumb]    [Search] [?] [Avatar] │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Dimensions:**
- Height: 64px fixed
- Width: 100% viewport width
- Z-index: 50 (above content, below modals)

**Elements:**

1. **Menu Icon** (Mobile only, <768px)
   - Icon: `lucide-react` Menu icon
   - Size: 24px × 24px
   - Action: Toggles sidebar drawer
   - Color: Gray 700 (#374151)

2. **Page Title / Breadcrumb**
   - Typography: 18px, Semi-bold (600), Gray 900
   - Breadcrumb format: `Parent > Child > Current`
   - Breadcrumb separator: `/` or `>`
   - Max-width: 60% of header (truncate with ellipsis)
   - Examples:
     - "Dashboard"
     - "Briefs > Marketing Campaign"
     - "Settings > Profile"

3. **Search Icon**
   - Icon: `lucide-react` Search icon
   - Size: 20px × 20px
   - Action: Opens global search overlay (Epic 6)
   - Keyboard shortcut hint: Tooltip shows "⌘K" or "Ctrl+K"
   - Color: Gray 600 on default, Indigo 600 on hover

4. **Help Icon**
   - Icon: `lucide-react` HelpCircle icon
   - Size: 20px × 20px
   - Action: Opens Settings → Help & Support tab
   - Tooltip: "Help & Support"
   - Color: Gray 600 on default, Indigo 600 on hover

5. **User Avatar Dropdown**
   - Avatar component (shadcn/ui Avatar)
   - Size: 40px × 40px, rounded-full
   - Displays: User uploaded avatar or initials
   - Dropdown Menu (shadcn/ui DropdownMenu):
     ```
     ┌──────────────────────┐
     │ John Doe             │
     │ john@company.com     │
     ├──────────────────────┤
     │ Profile              │
     │ Settings             │
     │ Help                 │
     ├──────────────────────┤
     │ Sign Out             │
     └──────────────────────┘
     ```

**Styling:**
- Background: White (#FFFFFF)
- Border-bottom: 1px solid Gray 200 (#E5E7EB)
- Shadow: `0 1px 3px rgba(0,0,0,0.06)`
- Padding: 0 24px (desktop), 0 16px (mobile)

**Responsive:**
- Desktop (≥1024px): All elements visible
- Tablet (768px-1023px): Menu icon appears, title truncates
- Mobile (<768px): Only Menu, Title, Avatar visible

---

### 2. Global Sidebar

**Component Name:** `GlobalSidebar`
**File:** `src/components/layout/GlobalSidebar.tsx`

**Specifications:**

```
┌─────────────────────────────┐
│ [Logo] SingleBrief          │
├─────────────────────────────┤
│                             │
│ 🏠 Dashboard           [3]  │
│                             │
│ 📝 Briefs              [>]  │
│                             │
│ ✅ My Tasks            [12] │
│                             │
│ 🔍 Search                   │
│                             │
│ ⚙️ Settings                 │
│                             │
│                             │
│                             │
│ [Footer Content]            │
└─────────────────────────────┘
```

**Dimensions:**
- Width: 240px (expanded), 64px (collapsed)
- Height: 100vh
- Z-index: 40

**Logo Section:**
- Height: 64px (matches header height)
- Padding: 16px
- Logo size: 160px × 40px (expanded), 32px × 32px (collapsed)
- Logo format: SVG
- Click action: Navigate to Dashboard (/)

**Navigation Items:**

**Structure:**
```typescript
type NavItem = {
  label: string;
  icon: LucideIcon;
  href: string;
  badge?: number | string;
  subItems?: NavItem[];
  role?: 'manager' | 'team-member' | 'all';
};
```

**Items:**
1. Dashboard
   - Icon: Home
   - Href: `/`
   - Badge: Action items count (number)
   - Role: All

2. Briefs
   - Icon: FileText
   - Href: `/briefs`
   - Expandable: Yes
   - Sub-items:
     - All Briefs → `/briefs`
     - Active → `/briefs?status=active`
     - Completed → `/briefs?status=completed`
     - Archived → `/briefs?status=archived`
   - Role: All

3. My Tasks
   - Icon: CheckSquare
   - Href: `/tasks`
   - Badge: Pending tasks count (number)
   - Expandable: Yes
   - Sub-items:
     - To-Do → `/tasks?status=todo`
     - In Progress → `/tasks?status=in-progress`
     - Done → `/tasks?status=done`
     - All Tasks → `/tasks`
   - Role: All

4. Search
   - Icon: Search
   - Action: Opens search overlay (not href)
   - Role: All

5. Settings
   - Icon: Settings
   - Href: `/settings`
   - Expandable: Yes
   - Sub-items:
     - Profile → `/settings?tab=profile`
     - Notifications → `/settings?tab=notifications`
     - Preferences → `/settings?tab=preferences`
     - Help & Support → `/settings?tab=help`
   - Role: All

**Nav Item States:**
- Default: Gray 700 text, no background
- Hover: Gray 100 background, Gray 900 text
- Active: Indigo 600 text, Indigo 50 background, 3px left border (Indigo 600)
- Disabled: Gray 400 text, no hover effect

**Styling:**
- Background: White (#FFFFFF)
- Border-right: 1px solid Gray 200 (#E5E7EB)
- Shadow: `2px 0 8px rgba(0,0,0,0.04)`
- Padding: 16px (vertical), 12px (horizontal for items)
- Item height: 44px
- Item gap: 4px
- Sub-item indent: 16px

**Collapse Behavior:**
- Toggle button: Bottom of sidebar (Chevron icon)
- Collapsed state: Shows icons only, hides text
- Tooltip on hover: Shows full label when collapsed
- Persists state in localStorage

**Responsive:**
- Desktop (≥1024px): Always visible (unless collapsed by user)
- Tablet (768px-1023px): Overlay drawer, hidden by default
- Mobile (<768px): Overlay drawer, hidden by default, full-screen

---

### 3. Global Footer

**Component Name:** `GlobalFooter`
**File:** `src/components/layout/GlobalFooter.tsx`

**Specifications:**

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│ © 2025 SingleBrief  •  Privacy  •  Terms  •  Help  •  v1.0.0  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Dimensions:**
- Height: 48px
- Width: 100% (minus sidebar width on desktop)
- Position: Sticky bottom (short pages), Natural position (long pages)

**Elements:**
- Copyright text: `© 2025 SingleBrief`
- Links:
  - Privacy → `/privacy` (external or page)
  - Terms → `/terms` (external or page)
  - Help → Opens Settings → Help & Support tab
- Version: `v1.0.0` (dynamic from package.json)
- Separator: `•` (bullet)

**Styling:**
- Background: Gray 50 (#F9FAFB)
- Text: Gray 500 (#6B7280), 14px
- Links: Underline on hover, Indigo 600 color
- Padding: 16px 24px
- Text-align: Center

**Responsive:**
- Desktop: Single line, centered
- Mobile: Stacked links, smaller font (12px)

---

### 4. Page Content Container

**Component Name:** `PageContent`
**File:** `src/components/layout/PageContent.tsx`

**Specifications:**
- Max-width: 1280px
- Margin: 0 auto (centered)
- Padding: 24px (desktop), 16px (mobile)
- Min-height: `calc(100vh - 64px - 48px)` (full height minus header/footer)
- Background: White or Gray 50 (depending on page)

---

## Page Templates

### Template 1: Dashboard Layout

**Use Cases:** Dashboard page (Manager/Team Member views)

**Structure:**
```
┌─────────────────────────────────────────────────────────────────┐
│ GlobalHeader                                                    │
├──────┬──────────────────────────────────────────────────────────┤
│      │                                                          │
│      │ [Dismissible Banner - Periodic Reminders]               │
│      │                                                          │
│ Side │ ┌──────────┬──────────┬──────────┐                     │
│ bar  │ │ Widget 1 │ Widget 2 │ Widget 3 │                     │
│      │ └──────────┴──────────┴──────────┘                     │
│      │                                                          │
│      │ Section Title                                           │
│      │ ┌──────────────────────────────────┐                   │
│      │ │ List Item 1                      │                   │
│      │ │ List Item 2                      │                   │
│      │ │ List Item 3                      │                   │
│      │ └──────────────────────────────────┘                   │
│      │                                                          │
│      │                                      [FAB]              │
├──────┴──────────────────────────────────────────────────────────┤
│ GlobalFooter                                                    │
└─────────────────────────────────────────────────────────────────┘
```

**Components:**
- GlobalHeader
- GlobalSidebar
- Banner component (dismissible Alert)
- Widget grid (3 columns on desktop, 1 on mobile)
- Card components for widgets
- List components
- FAB (Floating Action Button)
- GlobalFooter

---

### Template 2: List Page Layout

**Use Cases:** Briefs list, My Tasks list

**Structure:**
```
┌─────────────────────────────────────────────────────────────────┐
│ GlobalHeader                                                    │
├──────┬──────────────────────────────────────────────────────────┤
│      │                                                          │
│      │ Page Title                                 [Filter] [Sort]│
│      │ ───────────────────────────────────────────────────────  │
│ Side │                                                          │
│ bar  │ ┌──────────────────────────────────────┐                │
│      │ │ □ List Item 1              [Actions] │                │
│      │ ├──────────────────────────────────────┤                │
│      │ │ □ List Item 2              [Actions] │                │
│      │ ├──────────────────────────────────────┤                │
│      │ │ □ List Item 3              [Actions] │                │
│      │ └──────────────────────────────────────┘                │
│      │                                                          │
│      │ [Pagination]                            [FAB]           │
├──────┴──────────────────────────────────────────────────────────┤
│ GlobalFooter                                                    │
└─────────────────────────────────────────────────────────────────┘
```

**Components:**
- GlobalHeader (with breadcrumb)
- GlobalSidebar
- Page title + Filter/Sort controls
- Table or Card list with checkboxes
- Action buttons per item
- Pagination component
- FAB for adding new items
- GlobalFooter

---

### Template 3: Detail Page with Tabs

**Use Cases:** Brief detail, Task detail

**Structure:**
```
┌─────────────────────────────────────────────────────────────────┐
│ GlobalHeader (with breadcrumb)                                 │
├──────┬────────────────────────────────────────┬─────────────────┤
│      │                                        │                 │
│      │ Header Section                         │   Side Panel    │
│      │ ┌────────────────────────────────────┐ │                 │
│      │ │ Title, Status, Actions             │ │   Info Card     │
│ Side │ │ Progress Bar                        │ │                 │
│ bar  │ └────────────────────────────────────┘ │   Team Card     │
│      │                                        │                 │
│      │ Tabs: [Tab1][Tab2][Tab3][Tab4]        │   AI Card       │
│      │ ──────────────────────────────────────│                 │
│      │                                        │                 │
│      │ Tab Content Area                       │                 │
│      │ (Dynamic based on active tab)          │                 │
│      │                                        │                 │
│      │                             [FAB]      │                 │
├──────┴────────────────────────────────────────┴─────────────────┤
│ GlobalFooter                                                    │
└─────────────────────────────────────────────────────────────────┘
```

**Components:**
- GlobalHeader with breadcrumb
- GlobalSidebar
- Header card with title, metadata, actions
- Progress indicator
- Tabs navigation (shadcn/ui Tabs)
- Tab content panels
- Side panel (collapsible on mobile)
- FAB (context-aware)
- GlobalFooter

**Side Panel Specs:**
- Width: 280px (desktop)
- Background: Gray 50
- Collapsible: Yes (button at top)
- Mobile: Drawer at bottom or separate page

---

### Template 4: Form Page Layout

**Use Cases:** Settings pages, Create Brief modal content

**Structure:**
```
┌─────────────────────────────────────────────────────────────────┐
│ GlobalHeader                                                    │
├──────┬──────────────────────────────────────────────────────────┤
│      │                                                          │
│      │ Page Title                                              │
│      │ ───────────────────────────────────────────────────────  │
│ Side │                                                          │
│ bar  │ Tabs: [Tab1][Tab2][Tab3][Tab4]                          │
│      │ ───────────────────────────────────────────────────────  │
│      │                                                          │
│      │ Form Content                                            │
│      │ ┌────────────────────────────────────┐                 │
│      │ │ Form Field 1                       │                 │
│      │ │ Form Field 2                       │                 │
│      │ │ Form Field 3                       │                 │
│      │ └────────────────────────────────────┘                 │
│      │                                                          │
│      │ [Cancel] [Save Changes]                                 │
├──────┴──────────────────────────────────────────────────────────┤
│ GlobalFooter                                                    │
└─────────────────────────────────────────────────────────────────┘
```

**Components:**
- GlobalHeader
- GlobalSidebar
- Page title
- Tabs (for multi-section forms like Settings)
- Form fields (shadcn/ui Input, Select, Textarea, etc.)
- Form validation messages
- Action buttons (Cancel, Save)
- GlobalFooter

**Form Layout Specs:**
- Max-width: 600px (forms should be narrow for readability)
- Label position: Top of field
- Field height: 40px (inputs), auto (textarea)
- Field spacing: 24px vertical gap
- Button alignment: Right-aligned
- Dirty state: Track form changes, disable Save until modified

---

### Template 5: Modal/Dialog Layout

**Use Cases:** Create Brief, Review Task, Confirmation dialogs

**Structure:**
```
┌─────────────────────────────────────────────────────────────────┐
│                         [Backdrop Overlay]                      │
│                                                                 │
│           ┌────────────────────────────────────────┐           │
│           │ [X]                                    │           │
│           │ Dialog Title                           │           │
│           ├────────────────────────────────────────┤           │
│           │                                        │           │
│           │ Dialog Content                         │           │
│           │ (Forms, text, lists, etc.)             │           │
│           │                                        │           │
│           │                                        │           │
│           ├────────────────────────────────────────┤           │
│           │              [Cancel] [Action]         │           │
│           └────────────────────────────────────────┘           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Specifications:**
- Component: shadcn/ui Dialog
- Max-width: 600px (default), 800px (large), 400px (small)
- Max-height: 90vh (with scroll if content exceeds)
- Backdrop: rgba(0,0,0,0.5)
- Shadow: `0 20px 25px rgba(0,0,0,0.15)`
- Border-radius: 8px
- Padding: 24px
- Close button: Top-right (X icon, 20px × 20px)
- Footer buttons: Right-aligned, 8px gap
- Focus trap: Yes
- Esc key: Closes modal
- Click backdrop: Closes modal (with confirmation if form dirty)

---

## Component Specifications

### Floating Action Button (FAB)

**Component Name:** `FloatingActionButton`
**File:** `src/components/ui/FloatingActionButton.tsx`

**Specifications:**
- Size: 56px × 56px (desktop), 48px × 48px (mobile)
- Shape: Circular
- Position: Fixed, bottom-right
- Offset: 24px from right, 24px from bottom
- Z-index: 60 (above most content)
- Shadow: `0 4px 6px rgba(0,0,0,0.1), 0 2px 4px rgba(0,0,0,0.06)`
- Background: Indigo 600 (#6366F1)
- Icon: White, 24px × 24px
- Hover: Scale 1.05, shadow increases
- Active: Scale 0.95
- Transition: all 150ms ease

**Context-Aware Content:**
| Page | Icon | Label | Action |
|------|------|-------|--------|
| Dashboard | Plus | New Brief | Open Create Brief dialog |
| Briefs List | Plus | New Brief | Open Create Brief dialog |
| Brief Detail (Tasks tab) | Plus | Add Task | Open Quick Add Task modal |
| My Tasks | Plus | Quick Add | Open Quick Add Task modal |
| Manager Dashboard (AI queued) | Zap | Execute AI | Open AI Execution dialog |

---

### Banner Component

**Component Name:** `PeriodicReminderBanner`
**File:** `src/components/ui/PeriodicReminderBanner.tsx`

**Specifications:**
- Component: shadcn/ui Alert (warning variant)
- Position: Top of page content, below header
- Width: 100% (minus padding)
- Padding: 16px 24px
- Background: Amber 50 (#FFFBEB)
- Border: 1px solid Amber 200
- Border-radius: 6px
- Icon: AlertTriangle (Amber 600)
- Dismissible: Yes (X button, top-right)
- Actions: Buttons inline with message

**Content Structure:**
```
[Icon] Message text with counts                [Action1] [Action2] [Dismiss]
```

**Behavior:**
- Shows: When action items exist (Epic 9 conditions)
- Dismissal: Stored in sessionStorage, persists until next day
- Animation: Slide-down on appear, fade-out on dismiss

---

### Card Component

**Component Name:** Standard shadcn/ui Card
**File:** `src/components/ui/card.tsx`

**Variants:**

**1. Widget Card (Dashboard):**
- Shadow: `0 1px 3px rgba(0,0,0,0.12)`
- Padding: 20px
- Border-radius: 8px
- Hover: Shadow increases to `0 4px 6px rgba(0,0,0,0.1)`

**2. List Item Card:**
- Shadow: `0 1px 2px rgba(0,0,0,0.05)`
- Padding: 16px
- Border-radius: 6px
- Hover: Background Gray 50

**3. Side Panel Card:**
- Shadow: None
- Padding: 16px
- Border: 1px solid Gray 200
- Border-radius: 6px

---

## Accessibility Specifications

### Focus Management
- **Focus rings:** 2px solid Indigo 600, 2px offset
- **Focus order:** Logical tab order (left to right, top to bottom)
- **Focus trap:** Modals trap focus, return to trigger on close
- **Skip links:** "Skip to main content" link (hidden until focused)

### ARIA Labels
- **Sidebar:** `<nav aria-label="Main navigation">`
- **Header:** `<header role="banner">`
- **Main content:** `<main role="main">`
- **Footer:** `<footer role="contentinfo">`
- **FAB:** `<button aria-label="Create new brief">`

### Keyboard Shortcuts
- `Cmd/Ctrl + K`: Open search
- `Cmd/Ctrl + B`: Toggle sidebar
- `Escape`: Close modal/dialog
- `Tab`: Navigate forward
- `Shift + Tab`: Navigate backward
- `Enter`: Activate button/link
- `Space`: Activate button/checkbox

### Screen Reader Support
- **Live regions:** `aria-live="polite"` for toast notifications
- **Dynamic content:** `aria-busy="true"` during loading
- **Expandable items:** `aria-expanded="true/false"`
- **Hidden content:** `aria-hidden="true"` for decorative elements

---

## Responsive Breakpoints

**Tailwind CSS Breakpoints:**
```css
/* Mobile First Approach */
sm:  640px   /* Small tablets */
md:  768px   /* Tablets */
lg:  1024px  /* Laptops */
xl:  1280px  /* Desktops */
2xl: 1536px  /* Large desktops */
```

**Layout Breakpoints:**
- **Mobile:** < 768px
  - Sidebar: Drawer overlay
  - Header: Compact (menu + title + avatar)
  - Content: Full-width, 16px padding
  - Cards: Single column
  - FAB: 48px size

- **Tablet:** 768px - 1023px
  - Sidebar: Drawer overlay, collapsible
  - Header: Full (menu + title + search + help + avatar)
  - Content: Full-width, 20px padding
  - Cards: 2 columns
  - FAB: 56px size

- **Desktop:** ≥1024px
  - Sidebar: Always visible (unless collapsed)
  - Header: Full
  - Content: Max-width 1280px, centered, 24px padding
  - Cards: 3-4 columns
  - FAB: 56px size

---

## Animation & Transitions

### Page Transitions
- **Navigation:** 150ms fade
- **Modals:** 200ms fade + scale (0.95 → 1.0)
- **Sidebar:** 300ms slide (drawer mode)
- **Tabs:** 150ms fade between content

### Micro-interactions
- **Buttons:** 150ms all properties
- **Hover effects:** 200ms opacity/background
- **Focus rings:** Instant (no transition)
- **Loading spinners:** 600ms rotation (infinite)

### Easing Functions
- **Default:** `ease-in-out`
- **Entrances:** `ease-out`
- **Exits:** `ease-in`
- **Elastic:** `cubic-bezier(0.68, -0.55, 0.265, 1.55)` (for FAB)

---

## Loading States

### Skeleton Loaders
- **Cards:** shadcn/ui Skeleton component
- **Text:** Shimmer animation, Gray 200 background
- **Images:** Placeholder with loading icon
- **Lists:** 3-5 skeleton rows

### Loading Indicators
- **Buttons:** Spinner icon (lucide-react Loader2), 16px, rotating
- **Page load:** Full-page spinner, centered
- **Inline load:** Small spinner next to text

### Progress Indicators
- **File upload:** Linear progress bar (shadcn/ui Progress)
- **Task completion:** Circular progress (percentage)
- **Brief progress:** Horizontal bar with percentage text

---

## Empty States

### Pattern
```
┌──────────────────────────────────┐
│                                  │
│         [Illustration]           │
│                                  │
│      Empty State Title           │
│   Helpful description text       │
│                                  │
│   [Primary Action Button]        │
│                                  │
└──────────────────────────────────┘
```

### Specifications
- **Illustration:** 120px × 120px, Gray 400 color
- **Title:** 18px, Semi-bold, Gray 900
- **Description:** 14px, Regular, Gray 600, max 400px width
- **Button:** Primary style, centered
- **Padding:** 48px vertical, 24px horizontal

### Examples
- **Dashboard (no briefs):** "No briefs yet" + "Create your first brief" button
- **Briefs list (empty):** "No briefs found" + "Create Brief" button
- **My Tasks (empty):** "No tasks assigned" + descriptive text (no button)
- **Search (no results):** "No results found" + "Try different keywords" text

---

## Error States

### Pattern
```
┌──────────────────────────────────┐
│                                  │
│      [Error Icon]                │
│                                  │
│    Error Title                   │
│  Error message description       │
│                                  │
│  [Retry] [Contact Support]       │
│                                  │
└──────────────────────────────────┘
```

### Types

**1. Page-Level Error (500, 404):**
- Full-page layout
- Error code + friendly message
- Retry or Home button

**2. Component-Level Error:**
- Error Alert (shadcn/ui Alert, destructive variant)
- Red icon + message
- Retry button inline

**3. Form Validation Error:**
- Inline below field
- Red text, 14px
- Error icon (AlertCircle)

**4. Toast Notification Error:**
- shadcn/ui Toast (destructive variant)
- Auto-dismiss after 5 seconds
- Close button available

---

## Print Styles

### PDF Export Layout
- **Brief export:** Hide sidebar, header, footer
- **Task export:** Single column, grayscale
- **Page breaks:** Avoid breaking inside cards
- **Typography:** Increase sizes slightly for readability

---

## Design Tokens Reference

**For complete design token specifications, see:**
- `docs/design/tokens.md` (colors, typography, spacing, shadows)

**Quick Reference:**
- **Primary Color:** #6366F1 (Indigo 600)
- **Font Family:** Inter, system-ui, sans-serif
- **Border Radius:** 6px (default), 8px (cards), 9999px (pills/badges)
- **Shadow:** `0 1px 3px rgba(0,0,0,0.12)` (default)

---

**Document Status:** Ready for Implementation
**Next Steps:**
1. Create layout components in `src/components/layout/`
2. Implement responsive behavior with Tailwind
3. Test accessibility compliance
4. Create Storybook stories for each layout template
5. Validate with design team
