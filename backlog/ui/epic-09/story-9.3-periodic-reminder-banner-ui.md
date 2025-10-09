# UI/UX Specification: Story 9.3 - Periodic Reminder System

**Story ID:** STORY-9.3
**Feature:** Periodic In-App Reminder Banner
**Design System:** shadcn/ui + Tailwind CSS

---

## 1. Screen Overview

### Purpose
Proactive notification system to keep managers aware of pending actions requiring attention. Non-blocking, dismissible banner that respects user preferences and Do Not Disturb settings.

### User Flow Entry Points
1. Dashboard page load (if pending actions exist)
2. Automatic appearance after 30-minute polling check
3. Reappearance after 2-hour dismiss snooze period

### Success Criteria
- Manager notices pending actions within 10 seconds
- Reminder is non-intrusive and dismissible
- Clear actionable next steps provided
- Respects user notification preferences

---

## 2. Layout Structure

### Banner Notification Layout
```
┌─────────────────────────────────────────────────────────────┐
│  🔔  You have 5 pending actions requiring attention          │
│                                                        [X]    │
│  • Write blog post (due tomorrow)                            │
│  • Design mockups (due today)                                │
│  • Code review (overdue)                                     │
│                                                               │
│  [View Tasks] [Review Now] [Dismiss for 2 hours]            │
└─────────────────────────────────────────────────────────────┘
```

**Alternative: With Badge on Dashboard Icon**
```
┌─────────────────┐
│  Dashboard  🔴3 │  ← Red notification badge
└─────────────────┘
```

### Responsive Breakpoints
- **Mobile (< 640px):** Full-width banner, stacked buttons, simplified task list
- **Tablet (640-1024px):** Full-width banner, horizontal buttons
- **Desktop (> 1024px):** Centered banner with max-width 900px

---

## 3. Component Specifications

### 3.1 Banner Container
**Component:** `<Alert>` (shadcn/ui) or custom banner
- **Position:** Fixed at top of dashboard, below header
- **Width:** Full width (mobile), max 900px centered (desktop)
- **Background:** `bg-yellow-50` (warning/attention color)
- **Border:** `border-l-4 border-yellow-500` (left accent border)
- **Border Radius:** `rounded-md` (4px)
- **Padding:** 16px (mobile), 20px (desktop)
- **Shadow:** `shadow-md`
- **Animation:** Slide down from top (300ms ease-out)

### 3.2 Alert Icon
**Component:** Bell or AlertCircle icon (Lucide)
- **Size:** 24px
- **Color:** `text-yellow-700`
- **Position:** Left side, vertically centered
- **Animation:** Gentle bounce on first appearance

### 3.3 Alert Message
**Component:** Text content
- **Primary Message:** "You have [X] pending actions requiring attention"
- **Font:** `text-base font-medium text-yellow-900`
- **Format:** Dynamic count in bold
- **Example:** "You have **5** pending actions requiring attention"

### 3.4 Task Preview List
**Component:** Unordered list with top 3 tasks
- **Display:** Bullet list, max 3 tasks shown
- **Each Task Shows:**
  - Task title (truncated to 50 chars)
  - Due date status in parentheses
- **Font:** `text-sm text-yellow-800`
- **Spacing:** 4px between list items
- **Example Items:**
  ```
  • Write blog post (due tomorrow)
  • Design mockups (due today)
  • Code review (overdue)
  ```

**Due Date Formatting:**
- Overdue tasks: "(overdue)" in red text
- Due today: "(due today)" in amber text
- Due tomorrow: "(due tomorrow)" in normal text
- Due in X days: "(due in X days)" in normal text

### 3.5 Close Button
**Component:** `<Button>` variant="ghost" size="icon"
- **Icon:** X (close icon)
- **Position:** Top-right corner of banner
- **Size:** 20px icon, 32px touch target
- **Action:** Dismiss banner for 2 hours
- **Hover:** Background: `hover:bg-yellow-100`

### 3.6 Action Buttons (3 total)
**Component:** `<Button>` with different variants

**Button 1: View Tasks**
- **Variant:** "default"
- **Text:** "View Tasks"
- **Icon:** List icon (optional, before text)
- **Action:** Navigate to `/tasks?filter=pending`
- **Priority:** Primary action

**Button 2: Review Now**
- **Variant:** "secondary"
- **Text:** "Review Now"
- **Icon:** CheckCircle icon (optional)
- **Action:** Navigate to `/dashboard?tab=review`
- **Display Condition:** Only show if pendingReviews > 0

**Button 3: Dismiss**
- **Variant:** "ghost"
- **Text:** "Dismiss for 2 hours"
- **Icon:** Clock icon (optional)
- **Action:** Hide banner, store timestamp in localStorage
- **Visual:** Lighter appearance, less prominent

### 3.7 Dashboard Badge Indicator
**Component:** Custom badge on dashboard nav item
- **Shape:** Circular dot, 16px diameter
- **Position:** Top-right of "Dashboard" nav item
- **Background:** `bg-red-500`
- **Text:** Count number (white text, 10px font)
- **Animation:** Pulse animation on first appearance
- **Display Condition:** totalCount > 0 AND banner dismissed

---

## 4. Interaction Patterns

### 4.1 Banner Appearance
**Trigger Conditions:**
1. AI tasks queued >24 hours
2. Manual tasks due within 24 hours
3. Manual tasks overdue
4. Pending reviews exist

**Animation:**
1. Check if banner was dismissed recently (localStorage check)
2. If yes and <2 hours, don't show
3. If no or >2 hours, slide down from top (300ms)
4. Icon bounces gently once (200ms delay)
5. Badge appears on dashboard nav simultaneously

**Polling Check (Every 30 minutes):**
- Backend n8n workflow checks conditions
- Frontend polling queries pending action counts
- Banner appears if conditions met AND not dismissed

### 4.2 Task List Display
**Top 3 Tasks Logic:**
1. Query tasks matching reminder conditions
2. Sort by due_date ascending (earliest first)
3. Take first 3 tasks
4. Format each task:
   - Truncate title to 50 chars
   - Add due date status

**No Tasks Edge Case:**
- If totalCount > 0 but no specific tasks (rare)
- Show generic message: "Multiple items need attention"
- Don't show bullet list

### 4.3 Button Actions
**"View Tasks" Button:**
1. Click → Navigate to `/tasks?filter=pending`
2. Filter shows tasks matching reminder criteria
3. Banner remains visible (doesn't auto-dismiss)
4. Badge disappears when user returns to dashboard

**"Review Now" Button:**
1. Only visible if pendingReviews > 0
2. Click → Navigate to `/dashboard?tab=review`
3. Opens Brief Review tab
4. Banner auto-dismisses on navigation

**"Dismiss" Button:**
1. Click → Store current timestamp in localStorage
2. Banner slides up and disappears (200ms)
3. Badge appears on dashboard nav
4. Reminder reappears after 2 hours if actions still pending

### 4.4 Close Button (X)
**Same as Dismiss Button:**
- Stores timestamp
- Hides banner
- Shows badge
- 2-hour snooze

### 4.5 Notification Settings Integration
**Before Showing Banner:**
1. Check `user_settings.inapp_notifications_enabled`
2. Check `user_settings.notify_task_reminder_inapp`
3. Check Do Not Disturb hours (optional for in-app)
4. If any setting is OFF, don't show banner
5. If all ON, show banner

---

## 5. States & Visual Feedback

### 5.1 Hidden State (Default)
- Banner not visible
- No badge on dashboard nav
- Polling continues in background

### 5.2 Visible State
- Banner slides down from top
- Icon bounces on appearance
- Task list displays top 3 items
- Buttons available for interaction
- Badge on dashboard nav (if dismissed previously)

### 5.3 Dismissed State
- Banner slides up and disappears
- Timestamp stored in localStorage
- Badge appears on dashboard nav with count
- Snooze timer starts (2 hours)

### 5.4 Expired Snooze State
**After 2 Hours:**
1. Check if actions still pending
2. If yes, banner reappears
3. If no, remain hidden

### 5.5 No Notifications Enabled State
- Banner never appears
- Badge never appears
- Polling still runs (data available for other features)

---

## 6. Responsive Behavior

### Mobile (< 640px)
- Full-width banner, edge-to-edge
- Left border accent
- Icon and message stack if needed
- Task list: 2 items shown (not 3)
- Buttons stack vertically, full width
- Close button top-right

### Tablet (640-1024px)
- Full-width banner with padding
- Icon and message horizontal
- Task list: 3 items shown
- Buttons horizontal row, right-aligned
- Normal spacing

### Desktop (> 1024px)
- Max-width 900px, centered
- All content horizontal
- Task list: 3 items shown
- Buttons horizontal, right-aligned
- Hover states enabled

---

## 7. Accessibility Requirements

### Keyboard Navigation
- **Tab Order:** Close button → View Tasks → Review Now → Dismiss
- **Enter/Space:** Activate focused button
- **Escape:** Close banner (same as dismiss)

### Screen Reader Support
- **Banner Role:** `role="alert"` (announces automatically)
- **Alert Message:** Announced immediately on appearance
- **Task List:** `aria-label="Top 3 pending tasks"`
- **Buttons:** Descriptive aria-labels
  - "View 5 pending tasks"
  - "Review pending items now"
  - "Dismiss reminder for 2 hours"
- **Badge:** `aria-label="5 pending actions requiring attention"`

### Focus Management
- Focus moves to banner when it appears (optional, for screen readers)
- Focus trapped within banner if modal-like behavior desired
- Clear focus indicators (2px blue ring)

### Color Contrast
- Yellow background with dark text: 7:1 contrast (AAA)
- Button text on colored backgrounds: 4.5:1 (AA)
- Red overdue text: Sufficient contrast on yellow background

---

## 8. Design Tokens

### Colors
```css
--banner-bg: hsl(45 90% 95%)              /* Light yellow */
--banner-border: hsl(45 70% 50%)          /* Yellow accent */
--banner-text: hsl(45 100% 15%)           /* Dark yellow/brown */
--banner-icon: hsl(45 70% 35%)            /* Medium yellow */
--overdue-text: hsl(0 70% 45%)            /* Red for overdue */
--due-today-text: hsl(30 80% 45%)         /* Amber for due today */
--badge-bg: hsl(0 80% 50%)                /* Red badge */
--badge-text: hsl(0 0% 100%)              /* White text */
```

### Spacing
```css
--banner-padding: 20px (desktop), 16px (mobile)
--banner-gap: 12px
--task-list-gap: 4px
--button-gap: 8px
```

### Typography
```css
--banner-message: 16px / 500 / 1.5
--task-list: 14px / 400 / 1.4
--button-text: 14px / 500 / 1.5
--badge-count: 10px / 600 / 1
```

---

## 9. Figma Design Notes

### Component Layers
1. **Banner Container** - Yellow background with left border
2. **Content Row** - Icon + Message + Close button
3. **Task List Section** - Bullet list of top 3 tasks
4. **Action Buttons Row** - 3 buttons horizontal
5. **Dashboard Badge** - Red circular badge

### Auto-layout Structure
- **Banner:** Vertical auto-layout, 12px gap
- **Content Row:** Horizontal auto-layout, 8px gap, space-between
- **Task List:** Vertical auto-layout, 4px gap
- **Buttons:** Horizontal auto-layout, 8px gap, right-aligned

### Component Variants Needed
**Banner Variants:**
- With Review button (pendingReviews > 0)
- Without Review button (pendingReviews = 0)
- Mobile (vertical buttons)
- Desktop (horizontal buttons)

**Badge Variants:**
- Active (visible, with count)
- Hidden (not shown)

### Interactive Prototype
**Flows to Prototype:**
1. Dashboard load → Banner slides down → Show content → User reads
2. Click "View Tasks" → Navigate to task list → Tasks filtered
3. Click "Dismiss" → Banner slides up → Badge appears on nav
4. Wait 2 hours → Banner reappears (simulated)
5. Click close (X) → Same as dismiss

### Animation Specifications
- **Slide Down:** translateY(-100%) to translateY(0), 300ms ease-out
- **Slide Up:** translateY(0) to translateY(-100%), 200ms ease-in
- **Icon Bounce:** scale(1) → scale(1.1) → scale(1), 300ms, 200ms delay
- **Badge Pulse:** opacity 1 → 0.7 → 1, 1s infinite

---

## 10. Implementation Notes for Developer

### Tech Stack
- **Framework:** React 18 + TypeScript
- **UI Library:** shadcn/ui (Alert, Button components)
- **Animation:** Framer Motion or CSS transitions
- **State:** localStorage for dismiss tracking
- **Backend:** Supabase + n8n for polling logic

### Key Files
- Component: `src/components/dashboard/PeriodicReminderBanner.tsx`
- Badge: `src/components/layout/DashboardNavBadge.tsx`
- Hook: `src/hooks/use-reminder-banner.ts`
- Utilities: `src/lib/reminder-utils.ts`

### Reminder Hook Implementation
```typescript
export const useReminderBanner = () => {
  const [isVisible, setIsVisible] = useState(false);

  const { data: actionData } = useQuery({
    queryKey: ['reminder-banner'],
    queryFn: async () => {
      const currentUserId = (await supabase.auth.getUser()).data.user?.id;

      // Check user settings
      const { data: settings } = await supabase
        .from('user_settings')
        .select('inapp_notifications_enabled, notify_task_reminder_inapp')
        .eq('user_id', currentUserId)
        .single();

      if (!settings?.inapp_notifications_enabled ||
          !settings?.notify_task_reminder_inapp) {
        return { totalCount: 0, upcomingTasks: [] };
      }

      // Check dismiss timestamp
      const dismissed = localStorage.getItem('reminder-dismissed');
      const twoHoursAgo = Date.now() - (2 * 60 * 60 * 1000);
      if (dismissed && parseInt(dismissed) > twoHoursAgo) {
        return { totalCount: 0, upcomingTasks: [] };
      }

      // Parallel queries for pending actions
      const [pendingReviews, overdueTasks, dueSoonTasks, queuedAI, upcomingTasks] =
        await Promise.all([
          // ... (same queries as Story 9.1)
        ]);

      const totalCount = pendingReviews + overdueTasks + dueSoonTasks + queuedAI;

      return {
        totalCount,
        upcomingTasks, // Top 3 tasks
        pendingReviews,
        overdueTasks,
        dueSoonTasks,
        queuedAI
      };
    },
    refetchInterval: 30000 // 30 seconds
  });

  // Show banner if totalCount > 0
  useEffect(() => {
    if (actionData && actionData.totalCount > 0) {
      setIsVisible(true);
    }
  }, [actionData]);

  const handleDismiss = () => {
    localStorage.setItem('reminder-dismissed', Date.now().toString());
    setIsVisible(false);
  };

  return {
    isVisible,
    totalCount: actionData?.totalCount || 0,
    upcomingTasks: actionData?.upcomingTasks || [],
    pendingReviews: actionData?.pendingReviews || 0,
    handleDismiss
  };
};
```

### Date Formatting Utility
```typescript
export const formatDueDate = (dueDate: string): string => {
  const now = new Date();
  const due = new Date(dueDate);
  const diffDays = Math.floor((due - now) / (1000 * 60 * 60 * 24));

  if (diffDays < 0) return 'overdue';
  if (diffDays === 0) return 'due today';
  if (diffDays === 1) return 'due tomorrow';
  return `due in ${diffDays} days`;
};
```

### Performance Considerations
- localStorage for client-side dismiss tracking (no DB write)
- Polling interval: 30s (consistent with Action Center)
- Conditional rendering (don't mount if settings disabled)
- Lazy load animation library (Framer Motion)

---

## 11. v0.dev / Lovable AI Prompt

If generating this UI with AI tools, use this prompt:

```
Create a periodic reminder banner notification component using React, TypeScript, and shadcn/ui.

LAYOUT:
- Alert/Banner component with yellow/warning background
- Left accent border (4px, yellow-500)
- Fixed position at top of dashboard content area
- Slide-down animation on appearance (300ms)

CONTENT STRUCTURE:

1. Header Row:
   - Bell icon (24px, yellow-700) on left
   - Message: "You have [X] pending actions requiring attention"
   - Close button (X icon) on right

2. Task Preview List:
   - Show top 3 tasks (bullet list)
   - Each task: Title (50 chars max) + due date status
   - Due date formats:
     * "(overdue)" - red text
     * "(due today)" - amber text
     * "(due tomorrow)" - normal text
     * "(due in X days)" - normal text

3. Action Buttons Row (right-aligned, horizontal):
   - "View Tasks" (primary button)
   - "Review Now" (secondary button, conditional: show if pendingReviews > 0)
   - "Dismiss for 2 hours" (ghost button)

BANNER APPEARANCE CONDITIONS:
- AI tasks queued >24 hours
- Manual tasks due within 24 hours
- Manual tasks overdue
- Pending reviews exist
- NOT dismissed in last 2 hours (localStorage check)
- User settings allow in-app notifications

BEHAVIOR:
- Query Supabase for pending actions every 30s
- Check user_settings for notification permissions
- Check localStorage for dismiss timestamp
- If dismissed, show badge on dashboard nav instead
- Slide down on appearance, slide up on dismiss
- Store dismiss timestamp in localStorage (2-hour snooze)

DASHBOARD NAV BADGE:
- Red circular badge (16px diameter)
- Shows count number (white text, 10px)
- Position: top-right of "Dashboard" nav item
- Pulse animation
- Only visible when banner is dismissed AND totalCount > 0

BUTTONS:
- "View Tasks": Navigate to /tasks?filter=pending
- "Review Now": Navigate to /dashboard?tab=review (only if pendingReviews > 0)
- "Dismiss": Hide banner for 2 hours, show badge
- Close (X): Same as Dismiss

ACCESSIBILITY:
- role="alert" on banner (auto-announces)
- Descriptive aria-labels on all buttons
- Keyboard navigation (Tab, Enter, Escape to close)
- WCAG AA color contrast

RESPONSIVE:
- Mobile (<640px): Full-width, vertical buttons, show 2 tasks
- Tablet/Desktop (≥640px): Max-width 900px, horizontal buttons, show 3 tasks

TECH STACK:
- React 18 + TypeScript
- shadcn/ui: Alert, Button components
- Framer Motion for animations (or CSS transitions)
- localStorage for dismiss tracking
- TanStack Query for data fetching (30s polling)
- Supabase for backend
- Tailwind CSS
```

---

## 12. Testing Checklist

### Visual Testing
- [ ] Banner slides down smoothly on appearance
- [ ] Yellow background with left border accent
- [ ] Icon bounces once on first load
- [ ] Task list shows top 3 tasks correctly
- [ ] Due date formatting displays correctly (overdue, today, tomorrow)
- [ ] Buttons align properly (horizontal on desktop)
- [ ] Badge appears on nav when dismissed

### Functional Testing
- [ ] Banner appears when pending actions exist
- [ ] Banner respects 2-hour dismiss snooze
- [ ] localStorage stores dismiss timestamp
- [ ] Notification settings disable banner
- [ ] "View Tasks" navigates to filtered task list
- [ ] "Review Now" opens review tab
- [ ] "Dismiss" hides banner and shows badge
- [ ] Close (X) works same as Dismiss
- [ ] Polling updates counts every 30s

### Responsive Testing
- [ ] Mobile: Full-width, vertical buttons, 2 tasks shown
- [ ] Tablet: Horizontal buttons, 3 tasks shown
- [ ] Desktop: Max-width 900px, centered, hover states

### Accessibility Testing
- [ ] Banner announces automatically (role="alert")
- [ ] Screen reader announces task count
- [ ] Keyboard navigation works (Tab, Enter, Escape)
- [ ] Focus indicators visible
- [ ] Color contrast meets WCAG AA

---

## 13. Related Files & Dependencies

**Component Files:**
- `/src/components/dashboard/PeriodicReminderBanner.tsx` (to be created)
- `/src/components/layout/DashboardNavBadge.tsx` (to be created)
- `/src/hooks/use-reminder-banner.ts` (to be created)
- `/src/lib/reminder-utils.ts` (to be created)

**Dependencies:**
- Epic 1: Briefs table
- Epic 2: Tasks table with due_date, status
- Epic 5: Notification settings integration
- Epic 10: User settings (in-app notification preferences)
- Story 9.1: Action center queries (reuse logic)
- n8n: Periodic reminder check workflow

**Database Schema:**
- `briefs` table: id, user_id, status
- `tasks` table: id, brief_id, status, due_date, assigned_to, created_at
- `user_settings` table: user_id, inapp_notifications_enabled, notify_task_reminder_inapp, dnd_start_hour, dnd_end_hour

---

**Last Updated:** 2025-10-09
**Design Status:** Ready for Development
**Priority:** Medium (Epic 9 - Story 9.3)
