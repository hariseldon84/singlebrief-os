# UI/UX Specification: Story 9.1 - Manager Action Center Widget

**Story ID:** STORY-9.1
**Feature:** Manager Action Center Dashboard Widget
**Design System:** shadcn/ui + Tailwind CSS

---

## 1. Screen Overview

### Purpose
Centralized command center for managers to see critical actions requiring attention at a glance. Must provide immediate visibility into pending work without navigation overhead.

### User Flow Entry Points
1. Dashboard page load (automatic display)
2. Dashboard refresh (polling every 30s)
3. Manual refresh button click

### Success Criteria
- Manager can identify pending actions in <5 seconds
- Action counts are accurate and real-time
- One-click navigation to relevant sections
- Clear visual priority through color coding

---

## 2. Layout Structure

### Card Widget Layout
```
┌─────────────────────────────────────────────────────────┐
│  Action Center                              [Refresh ↻]  │
│  Items requiring your attention                          │
├─────────────────────────────────────────────────────────┤
│                                                           │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐ │
│  │   🔴 3      │  │   🟡 5      │  │   🔵 2          │ │
│  │             │  │             │  │                  │ │
│  │  Pending    │  │  Overdue    │  │  Queued AI      │ │
│  │  Reviews    │  │  Tasks      │  │  Tasks          │ │
│  │             │  │             │  │                  │ │
│  │ [Review Now]│  │[View Overdue]│  │[Execute AI Tasks]│ │
│  └─────────────┘  └─────────────┘  └─────────────────┘ │
│                                                           │
│  OR (Empty State):                                       │
│  😊 Great work! No pending actions.                      │
│                                                           │
└─────────────────────────────────────────────────────────┘
```

### Responsive Breakpoints
- **Mobile (< 768px):** Stack cards vertically, full width
- **Tablet (768-1024px):** 2 cards per row, 1 card on second row
- **Desktop (> 1024px):** 3 cards horizontal layout

---

## 3. Component Specifications

### 3.1 Card Container
**Component:** `<Card>` (shadcn/ui)
- **Width:** Full width, max 1200px
- **Padding:** 24px (desktop), 16px (mobile)
- **Background:** `bg-card` (white in light mode)
- **Border:** `border` (1px solid border color)
- **Border Radius:** `rounded-lg` (8px)
- **Shadow:** `shadow-sm`

### 3.2 Card Header
**Component:** `<CardHeader>`
- **Title:** "Action Center" - `text-xl font-semibold`
- **Description:** "Items requiring your attention" - `text-sm text-muted-foreground`
- **Refresh Button:** Icon button (↻) - `ghost` variant, top-right position

### 3.3 Action Cards (3 total)
**Component:** Custom stat card component

**Structure for Each Card:**
- **Badge:** Circular count badge with color coding
- **Count Number:** Large text `text-3xl font-bold`
- **Category Label:** Below count `text-sm font-medium`
- **Action Button:** Primary action button at bottom

**Card 1: Pending Reviews**
- **Badge Color:** `bg-red-100 text-red-700` (red)
- **Icon:** 📋 or CheckCircle
- **Count:** Dynamic from database
- **Label:** "Pending Reviews"
- **Button:** "Review Now" - `variant="default"`, navigates to Review tab

**Card 2: Overdue Tasks**
- **Badge Color:** `bg-yellow-100 text-yellow-700` (yellow/warning)
- **Icon:** ⏰ or AlertTriangle
- **Count:** Dynamic from database
- **Label:** "Overdue Tasks"
- **Button:** "View Overdue" - `variant="default"`, filters task list

**Card 3: Queued AI Tasks**
- **Badge Color:** `bg-blue-100 text-blue-700` (blue/info)
- **Icon:** 🤖 or Sparkles
- **Count:** Dynamic from database
- **Label:** "Queued AI Tasks"
- **Button:** "Execute AI Tasks" - `variant="default"`, opens FAB dialog

### 3.4 Empty State
**Component:** Custom empty state
- **Icon:** 😊 or PartyPopper (celebratory)
- **Message:** "Great work! No pending actions."
- **Style:** `text-muted-foreground text-center py-8`
- **Display Condition:** All counts === 0

### 3.5 Refresh Button
**Component:** `<Button>` variant="ghost" size="icon"
- **Icon:** RefreshCw (Lucide icon)
- **Position:** Absolute top-right of card header
- **Animation:** Rotate 360° on click (200ms)
- **Action:** Manually trigger data refetch

---

## 4. Interaction Patterns

### 4.1 Data Loading
**Initial Load:**
1. Card displays loading skeleton (3 shimmer boxes)
2. Query Supabase for counts
3. Fade in actual data (300ms ease-out)

**Polling (Every 30 seconds):**
1. Silent background refetch
2. Update counts if changed
3. Smooth number transition animation

### 4.2 Count Updates
**Number Animation:**
- Count changes trigger number counter animation
- Animate from old value to new value (500ms)
- Use spring animation for natural feel

**Badge Pulse:**
- When count increases from 0 → 1+, badge pulses once
- Pulse animation: scale 1 → 1.1 → 1 (300ms)

### 4.3 Button Actions
**"Review Now" Button:**
- Click → Navigate to `/dashboard?tab=review`
- Opens Brief Review tab (Epic 4)
- Disabled when pendingReviews === 0

**"View Overdue" Button:**
- Click → Navigate to `/tasks?filter=overdue`
- Filters task list to show overdue items only
- Disabled when overdueTasks === 0

**"Execute AI Tasks" Button:**
- Click → Open FAB confirmation dialog (Epic 3)
- Shows AI task execution modal
- Disabled when queuedAI === 0

### 4.4 Refresh Action
**Manual Refresh Button:**
1. Click refresh icon
2. Icon rotates 360°
3. Trigger immediate data refetch
4. Show toast: "Updated" (subtle, 2s duration)

---

## 5. States & Visual Feedback

### 5.1 Loading State
- Skeleton loader with 3 placeholder cards
- Each card shows shimmer animation
- No buttons visible during loading

### 5.2 Empty State
- All counts show 0
- Cards hidden
- Display celebratory empty state message
- Refresh button still available

### 5.3 Populated State
- Cards display actual counts
- Buttons enabled/disabled based on count
- Color-coded badges visible
- Hover states on cards and buttons

### 5.4 Error State
**Data Fetch Error:**
- Toast notification: "Failed to load action center. Try refreshing."
- Show last known data (if available)
- Refresh button highlighted with red dot

---

## 6. Responsive Behavior

### Mobile (< 768px)
- Cards stack vertically
- Full width cards (100%)
- Increased padding for touch targets
- Buttons full width within cards
- Reduced font sizes (count: `text-2xl`)

### Tablet (768-1024px)
- 2-column grid layout
- Third card on second row (centered)
- Moderate padding and spacing
- Normal button sizes

### Desktop (> 1024px)
- 3-column grid layout
- Equal width cards (33.33% each)
- Optimal spacing (gap: 16px)
- Hover effects on cards and buttons

---

## 7. Accessibility Requirements

### Keyboard Navigation
- **Tab Order:** Refresh → Card 1 Button → Card 2 Button → Card 3 Button
- **Enter/Space:** Activate focused button
- **Escape:** Close any opened dialogs

### Screen Reader Support
- **Card Title:** `aria-label="Action Center Widget"`
- **Count Badges:** `aria-label="3 pending reviews"` (dynamic)
- **Buttons:** Descriptive aria-labels
  - "Review 3 pending items now"
  - "View 5 overdue tasks"
  - "Execute 2 queued AI tasks"
- **Empty State:** Announced as "No pending actions. Great work!"

### Focus Management
- Clear focus indicators (2px blue ring)
- Focus visible on all interactive elements
- Logical tab order

### Color Contrast
- Badge text meets WCAG AA (4.5:1 minimum)
- Button text on colored backgrounds: 4.5:1
- Disabled state clearly distinguishable (50% opacity)

---

## 8. Design Tokens

### Colors
```css
--red-badge-bg: hsl(0 90% 95%)           /* Light red background */
--red-badge-text: hsl(0 70% 45%)         /* Red text */
--yellow-badge-bg: hsl(45 90% 95%)       /* Light yellow background */
--yellow-badge-text: hsl(45 70% 40%)     /* Yellow/orange text */
--blue-badge-bg: hsl(210 90% 95%)        /* Light blue background */
--blue-badge-text: hsl(210 70% 45%)      /* Blue text */
--card-background: hsl(0 0% 100%)        /* Card background */
--card-border: hsl(240 5.9% 90%)         /* Card border */
```

### Spacing
```css
--card-padding: 24px (desktop), 16px (mobile)
--card-gap: 16px
--button-gap: 12px
--badge-size: 48px (diameter)
```

### Typography
```css
--card-title: 20px / 600 / 1.3
--card-description: 14px / 400 / 1.5
--count-number: 36px / 700 / 1.1
--category-label: 14px / 500 / 1.3
--button-text: 14px / 500 / 1.5
```

---

## 9. Figma Design Notes

### Component Layers
1. **Card Container** - White background with border
2. **Header Section** - Title + description + refresh button
3. **Action Cards Grid** - 3 stat cards
4. **Empty State** - Alternative layout when counts = 0

### Auto-layout Structure
- **Card:** Vertical auto-layout, 24px gap
- **Action Cards Grid:** Horizontal auto-layout (responsive), 16px gap
- **Individual Action Card:** Vertical auto-layout, centered content, 16px gap

### Component Variants Needed
**Action Card Component:**
- Pending Reviews (red badge)
- Overdue Tasks (yellow badge)
- Queued AI Tasks (blue badge)
- Each with hover state

**Button States:**
- Enabled (default)
- Hover (darker background)
- Disabled (50% opacity, cursor not-allowed)
- Loading (spinner icon)

### Interactive Prototype
**Flows to Prototype:**
1. Load dashboard → See action center → Click "Review Now" → Navigate to review tab
2. Click "Execute AI Tasks" → Open FAB dialog → Confirm execution
3. Click refresh → Rotate icon → Update counts → Show toast
4. All counts = 0 → Show empty state → Celebrate

### Design System References
- shadcn/ui Card: https://ui.shadcn.com/docs/components/card
- shadcn/ui Button: https://ui.shadcn.com/docs/components/button
- shadcn/ui Badge: https://ui.shadcn.com/docs/components/badge
- Lucide Icons: https://lucide.dev

---

## 10. Implementation Notes for Developer

### Tech Stack
- **Framework:** React 18 + TypeScript
- **UI Library:** shadcn/ui (Radix UI + Tailwind)
- **Data Fetching:** TanStack Query with 30s polling
- **Backend:** Supabase
- **Navigation:** React Router v6

### Key Files
- Component: `src/components/dashboard/ManagerActionCenter.tsx`
- Queries: `src/hooks/use-action-center.ts`
- Types: `src/types/dashboard.ts`

### Data Query Hook
```typescript
export const useActionCenter = () => {
  return useQuery({
    queryKey: ['manager-action-center'],
    queryFn: async () => {
      const currentUserId = (await supabase.auth.getUser()).data.user?.id;

      // Parallel queries for performance
      const [pendingReviews, overdueTasks, queuedAI] = await Promise.all([
        // Pending Reviews
        supabase
          .from('tasks')
          .select('*', { count: 'exact', head: true })
          .eq('status', 'Done')
          .in('brief_id',
            supabase.from('briefs').select('id').eq('user_id', currentUserId)
          ),

        // Overdue Tasks
        supabase
          .from('tasks')
          .select('*', { count: 'exact', head: true })
          .lt('due_date', new Date().toISOString())
          .not('status', 'in', '(Accepted,Archived)')
          .in('brief_id',
            supabase.from('briefs').select('id').eq('user_id', currentUserId)
          ),

        // Queued AI Tasks
        supabase
          .from('tasks')
          .select('*', { count: 'exact', head: true })
          .eq('status', 'Queued')
          .in('assigned_to',
            supabase.from('auth.users').select('id').eq('is_ai_agent', true)
          )
          .in('brief_id',
            supabase.from('briefs').select('id').eq('user_id', currentUserId)
          )
      ]);

      return {
        pendingReviews: pendingReviews.count || 0,
        overdueTasks: overdueTasks.count || 0,
        queuedAI: queuedAI.count || 0
      };
    },
    refetchInterval: 30000, // 30 seconds
    staleTime: 20000 // 20 seconds
  });
};
```

### Performance Considerations
- Use `count: 'exact', head: true` for count-only queries (faster)
- Parallel queries with `Promise.all` (not sequential)
- Polling interval: 30s (balance between real-time and server load)
- Stale time: 20s (prevent unnecessary refetches)

---

## 11. v0.dev / Lovable AI Prompt

If generating this UI with AI tools, use this prompt:

```
Create a Manager Action Center dashboard widget using React, TypeScript, and shadcn/ui.

LAYOUT:
- Card component with title "Action Center" and description "Items requiring your attention"
- Refresh button (icon) in top-right corner of header
- Grid of 3 stat cards (responsive: 3 columns desktop, 2 columns tablet, 1 column mobile)
- Empty state when all counts = 0

ACTION CARDS (3 total):

1. Pending Reviews Card:
   - Red circular badge with count number
   - Large count display (text-3xl, bold)
   - Label: "Pending Reviews" (text-sm, medium)
   - Button: "Review Now" (primary variant)
   - Disabled when count = 0

2. Overdue Tasks Card:
   - Yellow circular badge with count number
   - Large count display (text-3xl, bold)
   - Label: "Overdue Tasks" (text-sm, medium)
   - Button: "View Overdue" (primary variant)
   - Disabled when count = 0

3. Queued AI Tasks Card:
   - Blue circular badge with count number
   - Large count display (text-3xl, bold)
   - Label: "Queued AI Tasks" (text-sm, medium)
   - Button: "Execute AI Tasks" (primary variant)
   - Disabled when count = 0

EMPTY STATE:
- Display when all counts = 0
- Show celebratory icon (😊 or PartyPopper)
- Message: "Great work! No pending actions."
- Centered, muted text

BEHAVIOR:
- Fetch data from Supabase using TanStack Query
- Poll every 30 seconds for updates
- Smooth number transition animation when counts change
- Refresh button rotates 360° on click
- Navigate to appropriate sections on button click

ACCESSIBILITY:
- All buttons have descriptive aria-labels
- Counts announced to screen readers
- Keyboard navigation support
- WCAG AA color contrast

RESPONSIVE:
- Mobile (<768px): Stack cards vertically
- Tablet (768-1024px): 2 columns, third card on second row
- Desktop (>1024px): 3 columns horizontal

TECH STACK:
- React 18 + TypeScript
- shadcn/ui: Card, CardHeader, CardTitle, CardDescription, CardContent, Button, Badge
- TanStack Query for data fetching
- Supabase for backend
- Tailwind CSS for styling
```

---

## 12. Testing Checklist

### Visual Testing
- [ ] Badge colors match design (red, yellow, blue)
- [ ] Counts display correctly with proper formatting
- [ ] Buttons are disabled when count = 0
- [ ] Empty state displays when all counts = 0
- [ ] Refresh icon rotates on click
- [ ] Number transition animation works smoothly

### Functional Testing
- [ ] Data loads from Supabase correctly
- [ ] Polling updates counts every 30 seconds
- [ ] "Review Now" navigates to review tab
- [ ] "View Overdue" filters task list
- [ ] "Execute AI Tasks" opens FAB dialog
- [ ] Manual refresh triggers data refetch
- [ ] Disabled buttons prevent clicks

### Responsive Testing
- [ ] Mobile: Cards stack vertically
- [ ] Tablet: 2-column layout
- [ ] Desktop: 3-column layout
- [ ] Touch targets are adequate (min 44px)

### Accessibility Testing
- [ ] Screen reader announces counts correctly
- [ ] Keyboard navigation works (Tab, Enter, Space)
- [ ] Focus indicators visible
- [ ] Color contrast meets WCAG AA
- [ ] Disabled state clearly communicated

---

## 13. Related Files & Dependencies

**Component Files:**
- `/src/components/dashboard/ManagerActionCenter.tsx` (to be created)
- `/src/hooks/use-action-center.ts` (to be created)
- `/src/types/dashboard.ts` (to be created)

**Dependencies:**
- Epic 1: Briefs table
- Epic 2: Tasks table with status, due_date
- Epic 3: FAB dialog component
- Epic 4: Brief review tab
- Epic 8: User authentication

**Database Schema:**
- `briefs` table: id, user_id, status
- `tasks` table: id, brief_id, status, due_date, assigned_to, created_at
- `auth.users` table: id, is_ai_agent

---

**Last Updated:** 2025-10-09
**Design Status:** Ready for Development
**Priority:** High (Epic 9 - Story 9.1)
