# UI/UX Specification: Story 9.4 - Team Member Dashboard View

**Story ID:** STORY-9.4
**Feature:** Team Member Personalized Dashboard
**Design System:** shadcn/ui + Tailwind CSS

---

## 1. Screen Overview

### Purpose
Personalized dashboard for team members showing their assigned tasks and priorities. Provides focused view of individual work without manager-specific analytics. Enables quick task status updates and efficient work management.

### User Flow Entry Points
1. Dashboard page load (role-based automatic routing)
2. Login redirect (if user role = Team Member)
3. Navigation from any page (click "Dashboard" in nav)

### Success Criteria
- Team member sees only relevant tasks in <3 seconds
- Clear distinction from manager dashboard
- Quick actions available for task management
- Easy navigation to task details

---

## 2. Layout Structure

### Team Member Dashboard Layout
```
┌─────────────────────────────────────────────────────────┐
│  My Tasks Dashboard                                      │
├─────────────────────────────────────────────────────────┤
│                                                           │
│  MY TASKS OVERVIEW                                       │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐ │
│  │   🔴 3      │  │   🟡 5      │  │   🟢 2          │ │
│  │             │  │             │  │                  │ │
│  │  Due        │  │  Due This   │  │  In Progress    │ │
│  │  Today      │  │  Week       │  │                  │ │
│  │             │  │             │  │                  │ │
│  └─────────────┘  └─────────────┘  └─────────────────┘ │
│                                                           │
│  TASK PRIORITY LIST                          [View All →]│
│  ┌─────────────────────────────────────────────────────┐ │
│  │ 1. Write blog post               Due tomorrow    📝 │ │
│  │    Brief: Q1 Marketing Campaign                    │ │
│  │    [Start Task]                                     │ │
│  ├─────────────────────────────────────────────────────┤ │
│  │ 2. Design mockups                Due today      🎨  │ │
│  │    Brief: Website Redesign                         │ │
│  │    [Mark Done]                                      │ │
│  ├─────────────────────────────────────────────────────┤ │
│  │ 3. Code review                   Overdue        💻  │ │
│  │    Brief: Feature Development                      │ │
│  │    [Start Task]                                     │ │
│  └─────────────────────────────────────────────────────┘ │
│                                                           │
└─────────────────────────────────────────────────────────┘
```

### Responsive Breakpoints
- **Mobile (< 768px):** Stack cards vertically, simplified task rows
- **Tablet (768-1024px):** 3-column stat cards, 2-column task list
- **Desktop (> 1024px):** Full layout with hover effects

---

## 3. Component Specifications

### 3.1 Dashboard Container
**Component:** Page wrapper
- **Width:** Full width, max 1400px centered
- **Padding:** 24px (desktop), 16px (mobile)
- **Background:** `bg-background`
- **Layout:** Vertical stack with 24px gap

### 3.2 Page Header
**Component:** Custom header
- **Title:** "My Tasks Dashboard"
- **Font:** `text-2xl font-bold`
- **Optional:** Welcome message "Welcome back, [Name]!" as subtitle
- **Alignment:** Left-aligned

### 3.3 My Tasks Widget (Stat Cards)
**Component:** Card grid with 3 stat cards

**Card Container:**
- **Layout:** Grid, 3 columns (desktop), 1 column (mobile)
- **Gap:** 16px
- **Section Title:** "MY TASKS OVERVIEW" - `text-sm font-semibold text-muted-foreground uppercase tracking-wide`

**Card 1: Due Today**
- **Badge:** Red circular badge with count
- **Count:** Dynamic from database
- **Label:** "Due Today"
- **Icon:** 🔴 or AlertCircle (red)
- **Background:** Subtle red tint on hover
- **Click:** Navigate to `/tasks?filter=due-today`

**Card 2: Due This Week**
- **Badge:** Yellow circular badge with count
- **Count:** Dynamic from database
- **Label:** "Due This Week"
- **Icon:** 🟡 or Clock (yellow/amber)
- **Background:** Subtle yellow tint on hover
- **Click:** Navigate to `/tasks?filter=due-week`

**Card 3: In Progress**
- **Badge:** Green circular badge with count
- **Count:** Dynamic from database
- **Label:** "In Progress"
- **Icon:** 🟢 or PlayCircle (green)
- **Background:** Subtle green tint on hover
- **Click:** Navigate to `/tasks?filter=in-progress`

### 3.4 Task Priority List Section
**Component:** Card with scrollable task list

**Section Header:**
- **Title:** "TASK PRIORITY LIST" - `text-sm font-semibold text-muted-foreground uppercase tracking-wide`
- **Action Button:** "View All →" - Link to `/tasks`, right-aligned
- **Spacing:** 16px below title

**Task List Container:**
- **Component:** `<ScrollArea>` (shadcn/ui)
- **Max Height:** 500px (scrollable if >5 tasks)
- **Background:** `bg-card`
- **Border:** `border rounded-lg`

### 3.5 Task Row Component (5 rows max)
**Component:** Custom task card

**Structure:**
- **Row Layout:** Horizontal flex, space-between
- **Left Section:** Task details
- **Right Section:** Due date + status badge + quick action
- **Divider:** Border-bottom between rows (except last)
- **Padding:** 16px
- **Hover:** `bg-muted/50` background

**Task Details (Left):**
- **Number:** Sequential number (1, 2, 3...) - `text-sm font-medium text-muted-foreground`
- **Title:** Task title - `text-base font-medium`, truncated to 50 chars
- **Brief Title:** "Brief: [name]" - `text-sm text-muted-foreground`, truncated to 30 chars
- **Icon:** Emoji or category icon (📝, 🎨, 💻) based on task type

**Due Date & Status (Right):**
- **Due Date:** Formatted text (e.g., "Due tomorrow", "Due today", "Overdue")
- **Color Coding:**
  - Overdue: `text-red-600` (red)
  - Due today: `text-yellow-600` (amber)
  - Due tomorrow: `text-blue-600` (blue)
  - Due this week: `text-muted-foreground` (gray)
- **Status Badge:** Small badge showing status (Queued, In Progress, Done)

**Quick Action Button:**
- **Conditional Button:**
  - If status = 'Queued': "Start Task" - `variant="outline"`
  - If status = 'In Progress': "Mark Done" - `variant="default"`
  - If status = 'Done': Disabled, no button
- **Icon:** PlayCircle (start) or CheckCircle (done)
- **Size:** Small button, compact

### 3.6 Empty State
**Component:** Empty state placeholder
- **Display Condition:** No tasks assigned to user
- **Icon:** 🎉 or Sparkles (celebratory)
- **Message:** "No tasks assigned yet. Great job staying on top of things!"
- **Style:** Centered, muted text
- **Optional:** "Browse available tasks" link

### 3.7 View All Button
**Component:** `<Button>` variant="link"
- **Text:** "View All →"
- **Position:** Top-right of task priority section
- **Action:** Navigate to `/tasks` (full task list)
- **Icon:** ArrowRight (Lucide)

---

## 4. Interaction Patterns

### 4.1 Role-Based Dashboard Routing
**On Dashboard Load:**
1. Query user profile for role
2. If role = 'Manager', render ManagerDashboard (Stories 9.1-9.3)
3. If role = 'Team Member', render TeamMemberDashboard (this story)
4. If role = 'Admin', render AdminDashboard (future)

**TypeScript Logic:**
```typescript
const { data: profile } = useQuery({
  queryKey: ['user-profile'],
  queryFn: async () => {
    const user = await supabase.auth.getUser();
    const { data } = await supabase
      .from('profiles')
      .select('role, full_name')
      .eq('user_id', user.data.user?.id)
      .single();
    return data;
  }
});

// Conditional rendering
if (profile?.role === 'Manager') return <ManagerDashboard />;
return <TeamMemberDashboard />;
```

### 4.2 Stat Card Interactions
**Click Stat Card:**
1. Navigate to `/tasks` with appropriate filter
2. Filter query params:
   - Due Today: `?filter=due-today`
   - Due This Week: `?filter=due-week`
   - In Progress: `?filter=in-progress`
3. Task list pre-filtered on arrival

**Hover Effects (Desktop):**
- Border color changes to primary
- Subtle background tint matching badge color
- Slight elevation (shadow-sm → shadow-md)
- Transition: 200ms ease

### 4.3 Task Row Interactions
**Click Task Row:**
- Navigate to task detail view (`/tasks/:id`)
- Opens task detail page (Epic 2)

**Hover Task Row (Desktop):**
- Background changes to `bg-muted/50`
- Cursor changes to pointer
- Transition: 150ms ease

**Quick Action Buttons:**

**"Start Task" Button:**
1. Click → Update task status from 'Queued' → 'In Progress'
2. Set `started_at` timestamp to now
3. Button changes to "Mark Done"
4. Optimistic UI update (immediate feedback)
5. Background mutation with error rollback
6. Toast notification: "Task started" (2s)

**"Mark Done" Button:**
1. Click → Update task status from 'In Progress' → 'Done'
2. Set `completed_at` timestamp to now
3. Task moves to review queue (manager notification)
4. Optimistic UI update
5. Task removed from priority list (if now outside top 5)
6. Toast notification: "Task marked as done" (2s)

### 4.4 Real-Time Updates
**Polling (Every 30 seconds):**
1. Query Supabase for updated task counts
2. Query top 5 priority tasks
3. Update UI with smooth transitions
4. Number animations for count changes
5. Task list reorders if priorities change

### 4.5 Empty State Handling
**No Tasks Assigned:**
- Display empty state message
- Show celebratory icon
- Optional: Link to browse available tasks (future feature)
- Stat cards show "0" for all counts

---

## 5. States & Visual Feedback

### 5.1 Loading State
- 3 skeleton stat cards with shimmer
- 5 skeleton task rows with shimmer
- Page header visible
- No interaction possible

### 5.2 Populated State
- Stat cards show actual counts
- Task list displays top 5 tasks
- Quick action buttons enabled
- Hover effects active (desktop)

### 5.3 Empty State
- Stat cards show "0" counts
- Empty state message in task list area
- "View All" button hidden or disabled
- Celebratory tone in messaging

### 5.4 Action Loading State
**During Quick Action:**
- Button shows spinner
- Button text: "Starting..." or "Updating..."
- Button disabled
- Row becomes non-clickable (opacity 70%)

### 5.5 Error State
**Data Fetch Error:**
- Toast notification: "Failed to load tasks. Refreshing..."
- Auto-retry after 3 seconds
- Show last cached data if available

**Quick Action Error:**
- Toast notification: "Failed to update task. Please try again."
- Rollback optimistic update
- Re-enable button
- Error persists until retry

---

## 6. Responsive Behavior

### Mobile (< 768px)
- Stat cards stack vertically (1 column)
- Task rows simplified:
  - Number removed
  - Brief title below task title
  - Due date below titles
  - Quick action button full width below content
- Reduced font sizes
- Increased touch targets (min 44px)
- Scroll area max-height: 400px

### Tablet (768-1024px)
- Stat cards: 3 columns
- Task rows: Horizontal layout, compact
- Normal font sizes
- Touch-optimized spacing

### Desktop (> 1024px)
- Stat cards: 3 columns with hover effects
- Task rows: Full horizontal layout
- Hover states enabled
- Optimal spacing and sizing
- Tooltips available

---

## 7. Accessibility Requirements

### Keyboard Navigation
- **Tab Order:** Stat Card 1 → 2 → 3 → Task Row 1 → Quick Action → Task Row 2 → ... → View All
- **Enter/Space:** Activate focused element
- **Arrow Keys:** Navigate between task rows (optional enhancement)

### Screen Reader Support
- **Stat Cards:** `aria-label="3 tasks due today, click to view"`
- **Task Rows:** `role="button"` with descriptive label
  - Example: "Task 1: Write blog post, due tomorrow, in Q1 Marketing Campaign brief, click to view details"
- **Quick Action Buttons:**
  - "Start task: Write blog post"
  - "Mark task as done: Design mockups"
- **Empty State:** Announced as "No tasks assigned. Great job!"

### Focus Management
- Clear focus indicators (2px blue ring)
- Focus visible on all interactive elements
- Skip link for keyboard users: "Skip to task list"

### Color Contrast
- All text meets WCAG AA (4.5:1 minimum)
- Badge colors tested for colorblind users
- Due date colors supplement with text (not color-only)

---

## 8. Design Tokens

### Colors
```css
--stat-card-bg: hsl(0 0% 100%)
--stat-card-border: hsl(240 5.9% 90%)
--stat-card-hover-red: hsl(0 90% 97%)
--stat-card-hover-yellow: hsl(45 90% 97%)
--stat-card-hover-green: hsl(142 90% 97%)
--task-row-hover: hsl(240 5% 96%)
--due-overdue: hsl(0 70% 50%)          /* Red */
--due-today: hsl(45 70% 50%)           /* Amber */
--due-tomorrow: hsl(210 70% 50%)       /* Blue */
--due-week: hsl(240 5% 46%)            /* Gray */
```

### Spacing
```css
--dashboard-padding: 24px (desktop), 16px (mobile)
--section-gap: 24px
--stat-card-gap: 16px
--task-row-padding: 16px
--task-row-gap: 12px
```

### Typography
```css
--page-title: 24px / 700 / 1.3
--section-title: 12px / 600 / 1.4 (uppercase)
--stat-label: 14px / 500 / 1.3
--task-title: 16px / 500 / 1.4
--task-subtitle: 14px / 400 / 1.4
--due-date: 14px / 500 / 1.3
```

---

## 9. Figma Design Notes

### Component Layers
1. **Dashboard Container** - Page wrapper
2. **Page Header** - Title + welcome message
3. **My Tasks Widget** - 3 stat cards grid
4. **Task Priority Section** - Title + task list card
5. **Individual Task Rows** - Repeating component

### Auto-layout Structure
- **Dashboard:** Vertical auto-layout, 24px gap
- **Stat Cards Grid:** Auto-layout wrap, 16px gap, 3 columns
- **Task List:** Vertical auto-layout, 0px gap (dividers between)
- **Task Row:** Horizontal auto-layout, space-between, 16px padding

### Component Variants Needed
**Stat Card Variants:**
- Due Today (red badge, red hover)
- Due This Week (yellow badge, yellow hover)
- In Progress (green badge, green hover)

**Task Row Variants:**
- With "Start Task" button (status=Queued)
- With "Mark Done" button (status=In Progress)
- Completed (no button, muted appearance)

**Quick Action Button Variants:**
- Start Task (outline variant, PlayCircle icon)
- Mark Done (default variant, CheckCircle icon)
- Loading (spinner, disabled)

### Interactive Prototype
**Flows to Prototype:**
1. Load dashboard → See role-based content → Stat cards populate
2. Click stat card → Navigate to filtered task list
3. Click task row → Navigate to task detail
4. Click "Start Task" → Button loading → Status updates → Toast appears
5. Click "Mark Done" → Task moves to done → Removed from list
6. Hover task row → Background changes → Smooth transition

---

## 10. Implementation Notes for Developer

### Tech Stack
- **Framework:** React 18 + TypeScript
- **UI Library:** shadcn/ui + Tailwind CSS
- **Data Fetching:** TanStack Query with 30s polling
- **Optimistic Updates:** TanStack Query optimistic mutations
- **Backend:** Supabase

### Key Files
- Component: `src/components/dashboard/TeamMemberDashboard.tsx`
- Stat Widget: `src/components/dashboard/MyTasksWidget.tsx`
- Task Row: `src/components/dashboard/PriorityTaskRow.tsx`
- Hook: `src/hooks/use-team-member-tasks.ts`
- Types: `src/types/team-dashboard.ts`

### Data Query Hook
```typescript
export const useTeamMemberTasks = () => {
  return useQuery({
    queryKey: ['team-member-tasks'],
    queryFn: async () => {
      const user = await supabase.auth.getUser();
      const currentUserId = user.data.user?.id;

      // Calculate date ranges
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      const tomorrow = new Date(today);
      tomorrow.setDate(tomorrow.getDate() + 1);
      const nextWeek = new Date(today);
      nextWeek.setDate(nextWeek.getDate() + 7);

      // Parallel queries
      const [dueToday, dueThisWeek, inProgress, topTasks] = await Promise.all([
        // Due Today count
        supabase
          .from('tasks')
          .select('*', { count: 'exact', head: true })
          .eq('assigned_to', currentUserId)
          .gte('due_date', today.toISOString())
          .lt('due_date', tomorrow.toISOString())
          .not('status', 'in', '(Accepted,Archived)'),

        // Due This Week count
        supabase
          .from('tasks')
          .select('*', { count: 'exact', head: true })
          .eq('assigned_to', currentUserId)
          .gte('due_date', tomorrow.toISOString())
          .lt('due_date', nextWeek.toISOString())
          .not('status', 'in', '(Accepted,Archived)'),

        // In Progress count
        supabase
          .from('tasks')
          .select('*', { count: 'exact', head: true })
          .eq('assigned_to', currentUserId)
          .eq('status', 'In Progress'),

        // Top 5 priority tasks
        supabase
          .from('tasks')
          .select(`
            id,
            title,
            due_date,
            status,
            brief:briefs(title)
          `)
          .eq('assigned_to', currentUserId)
          .not('status', 'in', '(Accepted,Archived)')
          .order('due_date', { ascending: true, nullsLast: true })
          .order('created_at', { ascending: true })
          .limit(5)
      ]);

      return {
        dueToday: dueToday.count || 0,
        dueThisWeek: dueThisWeek.count || 0,
        inProgress: inProgress.count || 0,
        topTasks: topTasks.data || []
      };
    },
    refetchInterval: 30000 // 30 seconds
  });
};
```

### Quick Action Mutation Hook
```typescript
export const useQuickTaskAction = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async ({ taskId, action }: { taskId: string; action: 'start' | 'done' }) => {
      const updates = action === 'start'
        ? { status: 'In Progress', started_at: new Date().toISOString() }
        : { status: 'Done', completed_at: new Date().toISOString() };

      const { data, error } = await supabase
        .from('tasks')
        .update(updates)
        .eq('id', taskId)
        .select()
        .single();

      if (error) throw error;
      return data;
    },
    onMutate: async ({ taskId, action }) => {
      // Optimistic update
      await queryClient.cancelQueries({ queryKey: ['team-member-tasks'] });
      const previousData = queryClient.getQueryData(['team-member-tasks']);

      queryClient.setQueryData(['team-member-tasks'], (old: any) => {
        // Update task status optimistically
        const updatedTasks = old.topTasks.map((task: any) =>
          task.id === taskId
            ? { ...task, status: action === 'start' ? 'In Progress' : 'Done' }
            : task
        );
        return { ...old, topTasks: updatedTasks };
      });

      return { previousData };
    },
    onError: (err, variables, context) => {
      // Rollback on error
      queryClient.setQueryData(['team-member-tasks'], context?.previousData);
      toast.error('Failed to update task. Please try again.');
    },
    onSuccess: (data, variables) => {
      // Refetch to get accurate counts
      queryClient.invalidateQueries({ queryKey: ['team-member-tasks'] });
      toast.success(variables.action === 'start' ? 'Task started' : 'Task marked as done');
    }
  });
};
```

### Performance Considerations
- Parallel queries with `Promise.all`
- Optimistic updates for quick actions (instant feedback)
- 30-second polling (consistent with other dashboard components)
- Limit top tasks to 5 (prevent large payload)
- Index on `assigned_to` and `due_date` columns

---

## 11. v0.dev / Lovable AI Prompt

If generating this UI with AI tools, use this prompt:

```
Create a Team Member Dashboard using React, TypeScript, shadcn/ui, and TanStack Query.

ROLE-BASED ROUTING:
- Query user profile for role
- If role='Manager': Render ManagerDashboard (separate component)
- If role='Team Member': Render TeamMemberDashboard (this component)

LAYOUT:

1. Page Header:
   - Title: "My Tasks Dashboard" (text-2xl, bold)
   - Optional subtitle: "Welcome back, [Name]!"

2. My Tasks Widget (3 stat cards):
   - Section title: "MY TASKS OVERVIEW" (uppercase, small, muted)
   - Grid: 3 columns desktop, 1 column mobile
   - Gap: 16px

   Card 1: Due Today
   - Red circular badge with count
   - Label: "Due Today"
   - Icon: 🔴 or AlertCircle
   - Click: Navigate to /tasks?filter=due-today

   Card 2: Due This Week
   - Yellow circular badge with count
   - Label: "Due This Week"
   - Icon: 🟡 or Clock
   - Click: Navigate to /tasks?filter=due-week

   Card 3: In Progress
   - Green circular badge with count
   - Label: "In Progress"
   - Icon: 🟢 or PlayCircle
   - Click: Navigate to /tasks?filter=in-progress

3. Task Priority List:
   - Section title: "TASK PRIORITY LIST" + "View All →" link (right)
   - Card with scrollable area (max-height: 500px)
   - Show top 5 tasks sorted by due_date ASC, created_at ASC

   Each task row:
   - Number (1, 2, 3...)
   - Task title (truncate 50 chars)
   - Brief title: "Brief: [name]" (muted, truncate 30 chars)
   - Due date: "Due tomorrow", "Due today", "Overdue" (color-coded)
   - Status badge: Queued, In Progress, Done
   - Quick action button:
     * If Queued: "Start Task" (outline button)
     * If In Progress: "Mark Done" (primary button)
   - Click row: Navigate to /tasks/:id

QUICK ACTIONS:
- "Start Task": Update status Queued → In Progress, set started_at
- "Mark Done": Update status In Progress → Done, set completed_at
- Use optimistic updates for instant feedback
- Show toast notifications on success/error

CALCULATIONS:
- Due Today: assigned_to=currentUser, due_date=today, status NOT IN (Accepted,Archived)
- Due This Week: assigned_to=currentUser, due_date between tomorrow and +7 days
- In Progress: assigned_to=currentUser, status='In Progress'
- Top 5 Tasks: Sort by due_date ASC, created_at ASC, limit 5

EMPTY STATE:
- If no tasks: Show "🎉 No tasks assigned yet. Great job staying on top of things!"

BEHAVIOR:
- Fetch data from Supabase using TanStack Query
- Poll every 30 seconds for updates
- Optimistic updates on quick actions
- Smooth number transitions on count changes
- Hover effects on desktop (stat cards, task rows)

ACCESSIBILITY:
- Screen reader announces all counts and tasks
- Keyboard navigation support
- Focus indicators visible
- WCAG AA color contrast

RESPONSIVE:
- Mobile (<768px): 1 column stat cards, simplified task rows
- Tablet/Desktop (≥768px): 3 column stat cards, full task layout

TECH STACK:
- React 18 + TypeScript
- shadcn/ui: Card, Button, Badge, ScrollArea
- TanStack Query with optimistic updates
- React Router for navigation
- Supabase for backend
- Tailwind CSS
```

---

## 12. Testing Checklist

### Visual Testing
- [ ] Page title displays correctly
- [ ] 3 stat cards show with correct badges
- [ ] Task priority list shows top 5 tasks
- [ ] Task rows format correctly (number, title, brief, due date)
- [ ] Quick action buttons display based on status
- [ ] Empty state shows when no tasks assigned
- [ ] Hover effects work on desktop

### Functional Testing
- [ ] Role-based routing works (Manager vs Team Member)
- [ ] Stat card counts calculate correctly
- [ ] Task list sorted by due_date then created_at
- [ ] Click stat card → navigates with filter
- [ ] Click task row → navigates to task detail
- [ ] "Start Task" updates status to In Progress
- [ ] "Mark Done" updates status to Done
- [ ] Optimistic updates work correctly
- [ ] Error rollback works on mutation failure
- [ ] Polling updates data every 30s

### Responsive Testing
- [ ] Mobile: Stat cards stack vertically
- [ ] Mobile: Task rows simplified layout
- [ ] Tablet: 3-column stat cards
- [ ] Desktop: Full layout with hover effects

### Accessibility Testing
- [ ] Screen reader announces all elements
- [ ] Keyboard navigation works (Tab, Enter)
- [ ] Focus indicators visible
- [ ] Color contrast meets WCAG AA
- [ ] Due date text supplements color

---

## 13. Related Files & Dependencies

**Component Files:**
- `/src/components/dashboard/TeamMemberDashboard.tsx` (to be created)
- `/src/components/dashboard/MyTasksWidget.tsx` (to be created)
- `/src/components/dashboard/PriorityTaskRow.tsx` (to be created)
- `/src/hooks/use-team-member-tasks.ts` (to be created)
- `/src/hooks/use-quick-task-action.ts` (to be created)

**Dependencies:**
- Epic 2: Tasks table with assigned_to, due_date, status
- Epic 8: User authentication and profiles (role field)
- Story 9.1: Dashboard routing logic
- Supabase RLS: Team members can only see assigned tasks

**Database Schema:**
- `profiles` table: user_id, role, full_name
- `tasks` table: id, brief_id, assigned_to, due_date, status, created_at, started_at, completed_at
- `briefs` table: id, title

---

**Last Updated:** 2025-10-09
**Design Status:** Ready for Development
**Priority:** High (Epic 9 - Story 9.4)
