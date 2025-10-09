# Epic 9: Manager Command Center - Detailed User Stories

**Date:** 2025-10-07
**Version:** 1.0
**Status:** Ready for Implementation
**Document Type:** User Story Breakdown

---

## Epic Overview

**Epic Goal:** Centralized action hub for managers to see visual cues, take immediate action, and track team progress.

**Timeline:** Week 4-5 (4 stories, ~23 story points)
**Priority:** **P0 (Must Have)** - Dashboard is critical for manager confidence
**Dependencies:** Epics 1-6 must be complete (needs data from briefs, tasks, reviews)

**Key Deliverables:**

- Manager action center widget (pending reviews, overdue tasks, queued AI tasks)
- Summary analytics dashboard (brief completion %, team velocity)
- Periodic reminder system (in-app banners, badges)
- Team member dashboard view (role-specific action items)

---

## Story 9.1: Manager Action Center Widget

### User Story

**As a** manager
**I want** a dashboard widget showing items requiring my attention
**So that** I can prioritize actions without navigating multiple views

---

### Acceptance Criteria

**Widget Display:**

- [ ] Widget displays 3 action categories with counts:
  - **Pending Reviews** (tasks with status='Done', awaiting accept/reject)
  - **Overdue Tasks** (tasks past due_date, status != 'Accepted')
  - **Queued AI Tasks** (tasks with status='Queued', assignee is AI agent)

**Visual Cues:**

- [ ] Color-coded badges for each category:
  - **Red badge** for overdue tasks (urgent priority)
  - **Yellow badge** for due today tasks (warning priority)
  - **Blue badge** for queued AI tasks (informational priority)
- [ ] Badge shows count number (e.g., "3" for 3 pending reviews)
- [ ] Empty state: "Great work! No pending actions." (when all counts = 0)

**One-Click Actions:**

- [ ] "Review Now" button → Navigate to Brief Review tab (Epic 4)
- [ ] "Execute AI Tasks" button → Open FAB confirmation dialog (Epic 3)
- [ ] "View Overdue" button → Filter task list to show only overdue items
- [ ] Each button disabled when count = 0

**Real-Time Updates:**

- [ ] Widget updates every 30 seconds (polling, consistent with Epic 5)
- [ ] Counts recalculate on each poll
- [ ] Smooth fade transition when counts change

**Responsive Design:**

- [ ] Widget stacks vertically on mobile (<768px)
- [ ] Cards remain horizontal on desktop (≥768px)
- [ ] Touch-friendly button sizes (min 44px height)

---

### Technical Implementation (No-Code)

#### **Frontend (v0.dev + Claude Code)**

**v0.dev Prompt:**

```
Create a dashboard widget with 3 stat cards:
1. Pending Reviews - Red badge, count, "Review Now" button
2. Overdue Tasks - Yellow badge, count, "View Overdue" button
3. Queued AI Tasks - Blue badge, count + cost estimate, "Execute AI Tasks" button

Use shadcn/ui Card, Badge, and Button components.
Include empty state message when all counts = 0.
Responsive: Stack vertically on mobile, horizontal on desktop.
```

**Claude Code Integration:**

```typescript
// Query Supabase for counts
const { data: actionCounts } = useQuery({
  queryKey: ['manager-action-center'],
  queryFn: async () => {
    const currentUserId = (await supabase.auth.getUser()).data.user?.id;

    // Pending Reviews
    const { count: pendingReviews } = await supabase
      .from('tasks')
      .select('*', { count: 'exact', head: true })
      .eq('status', 'Done')
      .in('brief_id',
        supabase.from('briefs').select('id').eq('user_id', currentUserId)
      );

    // Overdue Tasks
    const { count: overdueTasks } = await supabase
      .from('tasks')
      .select('*', { count: 'exact', head: true })
      .lt('due_date', new Date().toISOString())
      .not('status', 'in', '(Accepted,Archived)')
      .in('brief_id',
        supabase.from('briefs').select('id').eq('user_id', currentUserId)
      );

    // Queued AI Tasks
    const { count: queuedAI } = await supabase
      .from('tasks')
      .select('*', { count: 'exact', head: true })
      .eq('status', 'Queued')
      .in('assigned_to',
        supabase.from('auth.users').select('id').eq('is_ai_agent', true)
      )
      .in('brief_id',
        supabase.from('briefs').select('id').eq('user_id', currentUserId)
      );

    return { pendingReviews, overdueTasks, queuedAI };
  },
  refetchInterval: 30000 // 30 seconds
});
```

---

#### **Database Queries**

**Pending Reviews Count:**

```sql
SELECT COUNT(*) FROM tasks
WHERE status = 'Done'
AND brief_id IN (
  SELECT id FROM briefs WHERE user_id = :current_user_id
);
```

**Overdue Tasks Count:**

```sql
SELECT COUNT(*) FROM tasks
WHERE due_date < NOW()
AND status NOT IN ('Accepted', 'Archived')
AND brief_id IN (
  SELECT id FROM briefs WHERE user_id = :current_user_id
);
```

**Queued AI Tasks Count:**

```sql
SELECT COUNT(*) FROM tasks
WHERE status = 'Queued'
AND assigned_to IN (
  SELECT id FROM auth.users WHERE is_ai_agent = true
)
AND brief_id IN (
  SELECT id FROM briefs WHERE user_id = :current_user_id
);
```

---

#### **UI Component Structure**

```tsx
<Card className="manager-action-center">
  <CardHeader>
    <CardTitle>Action Center</CardTitle>
    <CardDescription>Items requiring your attention</CardDescription>
  </CardHeader>
  <CardContent>
    {totalActions === 0 ? (
      <p className="text-muted-foreground">Great work! No pending actions.</p>
    ) : (
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <ActionCard
          title="Pending Reviews"
          count={pendingReviews}
          badgeColor="red"
          buttonText="Review Now"
          onClick={navigateToReview}
        />
        <ActionCard
          title="Overdue Tasks"
          count={overdueTasks}
          badgeColor="yellow"
          buttonText="View Overdue"
          onClick={filterOverdue}
        />
        <ActionCard
          title="Queued AI Tasks"
          count={queuedAI}
          badgeColor="blue"
          buttonText="Execute AI Tasks"
          onClick={openAIDialog}
        />
      </div>
    )}
  </CardContent>
</Card>
```

---

### Functional Requirements Covered

- **FR129:** Dashboard shall display Manager Action Center widget showing pending reviews count
- **FR130:** Dashboard shall display overdue tasks count with red visual indicator
- **FR131:** Dashboard shall display queued AI tasks count with cost estimate

---

### Story Points

**8 points**

**Breakdown:**

- Frontend component (v0.dev): 2 points
- Supabase integration (3 queries): 3 points
- Polling logic: 1 point
- Button navigation handlers: 1 point
- Testing & polish: 1 point

---

### Dependencies

- Epic 2 (Task Management) - Tasks must exist
- Epic 3 (AI Agents) - AI queuing system
- Epic 4 (Review Workflow) - Review tab navigation
- Epic 5 (Collaboration) - Polling pattern established

---

### Testing Checklist

- [ ] Widget displays correct counts (create test data)
- [ ] Badge colors match specification (red/yellow/blue)
- [ ] Empty state shows when counts = 0
- [ ] "Review Now" navigates to correct page
- [ ] "Execute AI Tasks" opens FAB dialog
- [ ] "View Overdue" filters task list
- [ ] Polling updates counts every 30s
- [ ] Responsive layout works on mobile/desktop

---

## Story 9.2: Summary Analytics Dashboard

### User Story

**As a** manager
**I want** a high-level view of brief completion and team velocity
**So that** I can track progress without detailed reports

---

### Acceptance Criteria

**Summary Cards:**

- [ ] Display 4 summary metrics at top of dashboard:
  - **Active Briefs** (#) - Count of briefs with status='active'
  - **Total Tasks** (#) - Sum of tasks across all active briefs
  - **Completion Rate** (%) - (Accepted tasks / Total tasks) × 100
  - **Tasks Due This Week** (#) - Tasks with due_date in next 7 days
- [ ] Each card shows:
  - Large number (metric value)
  - Label (metric name)
  - Icon (relevant to metric type)

**Brief Completion Chart:**

- [ ] List of active briefs with progress bars
- [ ] Each row shows:
  - Brief title (clickable → navigate to brief detail)
  - Progress bar (visual representation of completion %)
  - Percentage text (e.g., "67% complete")
- [ ] Progress bar color:
  - Green (≥75%)
  - Yellow (50-74%)
  - Red (<50%)
- [ ] Sorted by completion % (ascending, show incomplete briefs first)
- [ ] Limit to top 5 briefs (show "View All" link if >5)

**Optional Features (Post-MVP):**

- [ ] "View Full Analytics" link shown but disabled
- [ ] Tooltip on disabled link: "Coming in v2 - Advanced charts and custom date ranges"

**Real-Time Updates:**

- [ ] Analytics update every 30 seconds (polling)
- [ ] Smooth fade transition when values change

---

### Technical Implementation (No-Code)

#### **Frontend (v0.dev + Claude Code)**

**v0.dev Prompt:**

```
Create analytics dashboard with:
1. 4 stat cards at top (Active Briefs, Total Tasks, Completion Rate %, Tasks Due This Week)
   - Use shadcn/ui Card component
   - Large number display with label and icon
2. Brief progress chart below cards
   - List of briefs with progress bars (shadcn/ui Progress component)
   - Color-coded bars (green ≥75%, yellow 50-74%, red <50%)
   - Sorted by completion % ascending
   - Clickable brief titles

Include "View Full Analytics" link (disabled with tooltip).
Responsive: Stack cards vertically on mobile.
```

**Claude Code Integration:**

```typescript
// Query Supabase for analytics
const { data: analytics } = useQuery({
  queryKey: ['manager-analytics'],
  queryFn: async () => {
    const currentUserId = (await supabase.auth.getUser()).data.user?.id;

    // Active Briefs Count
    const { count: activeBriefs } = await supabase
      .from('briefs')
      .select('*', { count: 'exact', head: true })
      .eq('user_id', currentUserId)
      .eq('status', 'active');

    // Total Tasks in Active Briefs
    const { count: totalTasks } = await supabase
      .from('tasks')
      .select('*', { count: 'exact', head: true })
      .in('brief_id',
        supabase.from('briefs').select('id').eq('user_id', currentUserId).eq('status', 'active')
      );

    // Completion Rate
    const { data: taskStats } = await supabase
      .from('tasks')
      .select('status')
      .in('brief_id',
        supabase.from('briefs').select('id').eq('user_id', currentUserId).eq('status', 'active')
      );
    const acceptedCount = taskStats?.filter(t => t.status === 'Accepted').length || 0;
    const completionRate = totalTasks > 0 ? Math.round((acceptedCount / totalTasks) * 100) : 0;

    // Tasks Due This Week
    const weekFromNow = new Date();
    weekFromNow.setDate(weekFromNow.getDate() + 7);
    const { count: dueSoon } = await supabase
      .from('tasks')
      .select('*', { count: 'exact', head: true })
      .gte('due_date', new Date().toISOString())
      .lte('due_date', weekFromNow.toISOString())
      .in('brief_id',
        supabase.from('briefs').select('id').eq('user_id', currentUserId)
      );

    // Brief Progress Details
    const { data: briefProgress } = await supabase
      .from('briefs')
      .select(`
        id,
        title,
        tasks:tasks(status)
      `)
      .eq('user_id', currentUserId)
      .eq('status', 'active');

    const progressData = briefProgress?.map(brief => {
      const totalTasks = brief.tasks.length;
      const acceptedTasks = brief.tasks.filter(t => t.status === 'Accepted').length;
      const progressPercent = totalTasks > 0 ? Math.round((acceptedTasks / totalTasks) * 100) : 0;
      return {
        id: brief.id,
        title: brief.title,
        totalTasks,
        acceptedTasks,
        progressPercent
      };
    }).sort((a, b) => a.progressPercent - b.progressPercent); // Ascending

    return {
      activeBriefs,
      totalTasks,
      completionRate,
      dueSoon,
      briefProgress: progressData?.slice(0, 5) // Top 5
    };
  },
  refetchInterval: 30000 // 30 seconds
});
```

---

#### **Database Queries**

**Active Briefs:**

```sql
SELECT COUNT(*) FROM briefs
WHERE status = 'active' AND user_id = :current_user_id;
```

**Total Tasks:**

```sql
SELECT COUNT(*) FROM tasks
WHERE brief_id IN (
  SELECT id FROM briefs WHERE user_id = :current_user_id AND status = 'active'
);
```

**Completion Rate:**

```sql
SELECT
  (COUNT(*) FILTER (WHERE status = 'Accepted') * 100.0 / COUNT(*)) AS completion_rate
FROM tasks
WHERE brief_id IN (
  SELECT id FROM briefs WHERE user_id = :current_user_id AND status = 'active'
);
```

**Tasks Due This Week:**

```sql
SELECT COUNT(*) FROM tasks
WHERE due_date BETWEEN NOW() AND NOW() + INTERVAL '7 days'
AND brief_id IN (
  SELECT id FROM briefs WHERE user_id = :current_user_id
);
```

**Brief Progress:**

```sql
SELECT
  b.id,
  b.title,
  COUNT(t.id) AS total_tasks,
  COUNT(t.id) FILTER (WHERE t.status = 'Accepted') AS accepted_tasks,
  (COUNT(t.id) FILTER (WHERE t.status = 'Accepted') * 100.0 / COUNT(t.id)) AS progress_percent
FROM briefs b
LEFT JOIN tasks t ON t.brief_id = b.id
WHERE b.user_id = :current_user_id AND b.status = 'active'
GROUP BY b.id, b.title
ORDER BY progress_percent ASC
LIMIT 5;
```

---

### Functional Requirements Covered

- **FR132:** Dashboard shall display summary analytics (active briefs, total tasks, completion %)
- **FR133:** Dashboard shall display brief completion chart with progress bars per active brief

---

### Story Points

**5 points**

**Breakdown:**

- Frontend components (stat cards + progress chart): 2 points
- Supabase queries (4 analytics queries): 2 points
- Progress bar color logic: 0.5 points
- Testing & polish: 0.5 points

---

### Dependencies

- Epic 1 (Brief Creation) - Briefs must exist
- Epic 2 (Task Management) - Tasks must exist
- Epic 4 (Review Workflow) - Acceptance tracking

---

### Testing Checklist

- [ ] Stat cards display correct counts
- [ ] Completion rate calculates correctly
- [ ] Brief progress bars show correct percentages
- [ ] Progress bar colors match thresholds (green/yellow/red)
- [ ] Briefs sorted by completion % ascending
- [ ] Top 5 briefs shown (if >5 exist)
- [ ] Brief title navigation works
- [ ] "View Full Analytics" link is disabled with tooltip
- [ ] Polling updates analytics every 30s

---

## Story 9.3: Periodic Reminder System

### User Story

**As a** manager
**I want** periodic in-app reminders for pending actions
**So that** I don't forget critical reviews or AI tasks

---

### Acceptance Criteria

**In-App Banner Notification:**

- [ ] Banner shown at top of dashboard when action items exist
- [ ] Banner is dismissible (close icon in top-right)
- [ ] Banner message format (dynamic based on action items):
  - Pending reviews: "You have {count} pending review{s}"
  - Queued AI tasks: "{count} AI task{s} queued for >24h"
  - Tasks due soon: "{count} task{s} due within 24 hours"
  - Overdue tasks: "{count} overdue task{s}"
  - Combined example: "You have 3 pending reviews, 2 tasks due within 24 hours, and 1 AI task queued"
- [ ] **Task details in banner:** Show top 3 tasks due soonest with title and due date
  - Example: "• Write blog post (due tomorrow) • Design mockups (due today) • Code review (overdue)"
- [ ] Banner actions:
  - **"Review Now"** button → Navigate to Review tab
  - **"View Tasks"** button → Navigate to task list filtered by due date
  - **"Dismiss"** button (or X icon) → Close banner

**Banner Trigger Conditions:**

- [ ] Daily at 9am (if pending reviews > 0 OR overdue tasks > 0 OR tasks due soon > 0)
- [ ] **AI Tasks:** When queued AI tasks exist for >24 hours
- [ ] **Manual Tasks:** When tasks are approaching due date:
  - Tasks due within 24 hours (due tomorrow or today)
  - Tasks already overdue
- [ ] Banner auto-shows on dashboard load if conditions met
- [ ] **Task Priority Display:** Show tasks due first (sorted by due date ascending)

**Persistent Navigation Badge:**

- [ ] Red badge on "Dashboard" navigation link (sidebar or header)
- [ ] Badge shows total action item count (pending reviews + overdue tasks + tasks due soon + queued AI)
- [ ] Badge updates every 30 seconds (polling)
- [ ] Badge removed when count = 0

**Banner Dismissal:**

- [ ] User can dismiss banner (hidden until next trigger condition)
- [ ] Dismissal state stored per-session (not permanent)
- [ ] Banner re-appears if:
  - User navigates away and returns to dashboard
  - Next day at 9am (if conditions still met)

---

### Technical Implementation (No-Code)

#### **Frontend (v0.dev + Claude Code)**

**v0.dev Prompt:**

```
Create dismissible banner notification:
- Alert component (shadcn/ui Alert) with yellow/warning styling
- Dynamic message showing count of:
  - Pending reviews
  - Queued AI tasks (>24h)
  - Tasks due within 24 hours
  - Overdue tasks
- Show top 3 tasks due soonest with title and due date (bullet list)
- Three actions: "Review Now", "View Tasks", and "Dismiss" (X icon)
- Shown at top of dashboard, above widgets

Create navigation badge:
- Red badge (shadcn/ui Badge) on "Dashboard" nav link
- Shows total action item count
- Auto-hide when count = 0
```

**Claude Code Integration:**

```typescript
// Banner state management
const [bannerDismissed, setBannerDismissed] = useState(() => {
  return sessionStorage.getItem('banner-dismissed') === 'true';
});

const dismissBanner = () => {
  setBannerDismissed(true);
  sessionStorage.setItem('banner-dismissed', 'true');
};

// Reset dismissal on new day
useEffect(() => {
  const lastDismissDate = sessionStorage.getItem('banner-dismiss-date');
  const today = new Date().toDateString();
  if (lastDismissDate !== today) {
    sessionStorage.removeItem('banner-dismissed');
    sessionStorage.setItem('banner-dismiss-date', today);
  }
}, []);

// Action item count for badge
const { data: actionData } = useQuery({
  queryKey: ['action-badge'],
  queryFn: async () => {
    const currentUserId = (await supabase.auth.getUser()).data.user?.id;

    // Pending reviews
    const { count: pendingReviews } = await supabase
      .from('tasks')
      .select('*', { count: 'exact', head: true })
      .eq('status', 'Done')
      .in('brief_id', supabase.from('briefs').select('id').eq('user_id', currentUserId));

    // Overdue tasks
    const { count: overdueTasks } = await supabase
      .from('tasks')
      .select('*', { count: 'exact', head: true })
      .lt('due_date', new Date().toISOString())
      .not('status', 'in', '(Accepted,Archived)')
      .in('brief_id', supabase.from('briefs').select('id').eq('user_id', currentUserId));

    // Tasks due within 24 hours (manual tasks only)
    const tomorrow = new Date();
    tomorrow.setDate(tomorrow.getDate() + 1);
    const { count: dueSoonTasks } = await supabase
      .from('tasks')
      .select('*', { count: 'exact', head: true })
      .gte('due_date', new Date().toISOString())
      .lte('due_date', tomorrow.toISOString())
      .not('status', 'in', '(Accepted,Archived)')
      .in('brief_id', supabase.from('briefs').select('id').eq('user_id', currentUserId));

    // Queued AI tasks (>24h)
    const dayAgo = new Date();
    dayAgo.setDate(dayAgo.getDate() - 1);
    const { count: queuedAI } = await supabase
      .from('tasks')
      .select('*', { count: 'exact', head: true })
      .eq('status', 'Queued')
      .lt('created_at', dayAgo.toISOString())
      .in('assigned_to', supabase.from('auth.users').select('id').eq('is_ai_agent', true))
      .in('brief_id', supabase.from('briefs').select('id').eq('user_id', currentUserId));

    // Fetch top 3 tasks due soonest (for banner display)
    const { data: upcomingTasks } = await supabase
      .from('tasks')
      .select('id, title, due_date')
      .not('status', 'in', '(Accepted,Archived)')
      .not('due_date', 'is', null)
      .in('brief_id', supabase.from('briefs').select('id').eq('user_id', currentUserId))
      .order('due_date', { ascending: true })
      .limit(3);

    return {
      pendingReviews,
      overdueTasks,
      dueSoonTasks,
      queuedAI,
      upcomingTasks,
      totalCount: pendingReviews + overdueTasks + dueSoonTasks + queuedAI
    };
  },
  refetchInterval: 30000
});

// Banner message generation
const getBannerMessage = (data) => {
  const items = [];
  if (data.pendingReviews > 0)
    items.push(`${data.pendingReviews} pending review${data.pendingReviews > 1 ? 's' : ''}`);
  if (data.dueSoonTasks > 0)
    items.push(`${data.dueSoonTasks} task${data.dueSoonTasks > 1 ? 's' : ''} due within 24 hours`);
  if (data.overdueTasks > 0)
    items.push(`${data.overdueTasks} overdue task${data.overdueTasks > 1 ? 's' : ''}`);
  if (data.queuedAI > 0)
    items.push(`${data.queuedAI} AI task${data.queuedAI > 1 ? 's' : ''} queued`);

  return items.length > 0 ? `You have ${items.join(', ')}` : '';
};

// Format task due date for display
const formatDueDate = (dueDate) => {
  const now = new Date();
  const due = new Date(dueDate);
  const diffDays = Math.floor((due - now) / (1000 * 60 * 60 * 24));

  if (diffDays < 0) return 'overdue';
  if (diffDays === 0) return 'due today';
  if (diffDays === 1) return 'due tomorrow';
  return `due in ${diffDays} days`;
};
```

---

#### **n8n Workflow (Daily Reminder)**

**Workflow Name:** Daily Action Reminder

**Trigger:** Cron (daily at 9am)

**Steps:**

1. **Cron Node:** Trigger daily at 9:00 AM
2. **Supabase Node:** Query users with pending actions
   ```sql
   SELECT DISTINCT b.user_id
   FROM briefs b
   JOIN tasks t ON t.brief_id = b.id
   WHERE (
     -- Pending reviews
     t.status = 'Done' OR

     -- Overdue tasks
     (t.due_date < NOW() AND t.status NOT IN ('Accepted', 'Archived')) OR

     -- Tasks due within 24 hours (manual tasks)
     (t.due_date >= NOW() AND t.due_date <= NOW() + INTERVAL '24 hours'
      AND t.status NOT IN ('Accepted', 'Archived')) OR

     -- Queued AI tasks (>24h)
     (t.status = 'Queued'
      AND t.created_at < NOW() - INTERVAL '24 hours'
      AND t.assigned_to IN (SELECT id FROM auth.users WHERE is_ai_agent = true))
   )
   AND b.status = 'active';
   ```
3. **Loop Node:** For each user_id
4. **Fetch Top 3 Tasks Node:** Query tasks due soonest for this user
   ```sql
   SELECT title, due_date
   FROM tasks
   WHERE brief_id IN (SELECT id FROM briefs WHERE user_id = :user_id)
   AND status NOT IN ('Accepted', 'Archived')
   AND due_date IS NOT NULL
   ORDER BY due_date ASC
   LIMIT 3;
   ```
5. **Notification Node:** Create in-app notification
   - Insert into `notifications` table
   - Type: 'daily_reminder'
   - Message: "You have pending actions. Top upcoming: [task1], [task2], [task3]"
6. **Email Node (Optional):** Send email notification
   - Reuse Epic 5 email workflow
   - Check user notification settings (Epic 10 Story 10.2)
   - Include top 3 tasks in email body

---

### Functional Requirements Covered

- **FR134:** Dashboard shall show periodic reminder banner for pending actions (daily at 9am), including:
  - AI tasks: Queued for >24 hours
  - Manual tasks: Due within 24 hours or overdue
  - Display top 3 tasks due soonest (sorted by due date ascending)
  - Show task titles and due dates in banner

---

### Story Points

**6 points** (increased from 5 due to enhanced logic)

**Breakdown:**

- Frontend banner component (with task list display): 1.5 points
- Banner trigger logic (4 types + due date tracking): 1.5 points
- Navigation badge (updated count logic): 1 point
- n8n daily reminder workflow (enhanced queries): 1.5 points
- Testing & polish: 0.5 points

---

### Dependencies

- Epic 2 (Task Management) - Tasks
- Epic 3 (AI Agents) - Queued AI tasks
- Epic 4 (Review Workflow) - Pending reviews
- Epic 5 (Notifications) - Notification infrastructure

---

### Testing Checklist

- [ ] Banner shows when action items exist
- [ ] Banner message formats correctly for all types:
  - [ ] Pending reviews
  - [ ] Tasks due within 24 hours
  - [ ] Overdue tasks
  - [ ] Queued AI tasks (>24h)
- [ ] Banner displays top 3 tasks due soonest with titles and due dates
- [ ] Tasks in banner sorted by due date (ascending)
- [ ] "Review Now" navigates to Review tab
- [ ] "View Tasks" navigates to task list filtered by due date
- [ ] "Dismiss" closes banner
- [ ] Banner re-appears on next day if conditions met
- [ ] Navigation badge shows correct count (includes tasks due soon)
- [ ] Badge updates every 30s
- [ ] Badge hidden when count = 0
- [ ] n8n daily reminder executes at 9am
- [ ] n8n workflow includes tasks due within 24 hours
- [ ] n8n workflow excludes AI tasks unless >24h queued
- [ ] Top 3 tasks fetched and included in notification
- [ ] Email notification sent (if enabled) with task details

---

## Story 9.4: Team Member Dashboard View

### User Story

**As a** team member
**I want** a dashboard showing my assigned tasks and due items
**So that** I know what to work on next

---

### Acceptance Criteria

**Team Member Dashboard (Distinct from Manager View):**

- [ ] Dashboard displays "My Tasks" summary widget with counts:
  - **To-Do** (#) - Tasks with status='To-Do'
  - **In-Progress** (#) - Tasks with status='In-Progress'
  - **Due Today** (#) - Tasks with due_date = today
  - **Overdue** (#) - Tasks past due_date

**Quick Filters:**

- [ ] Filter buttons: "Due Today," "High Priority," "All Tasks"
- [ ] Clicking filter updates task list preview below
- [ ] Active filter highlighted (visual indicator)
- [ ] Default filter: "All Tasks"

**Task List Preview:**

- [ ] Show top 5 tasks (sorted by due date, then priority)
- [ ] Each task shows:
  - Task title
  - Brief title (secondary text)
  - Due date (if set)
  - Priority badge (High/Medium/Low)
- [ ] Click task → Navigate to task detail view
- [ ] "View All Tasks" link → Navigate to "My Tasks" full page (Epic 2 Story 2.3)

**One-Click Action:**

- [ ] "Start Task" button on To-Do tasks
- [ ] Clicking "Start Task":
  - Changes status to 'In-Progress'
  - Triggers due date picker (Epic 2 Story 2.4)
  - Updates task immediately (no page refresh)

**Visual Cues:**

- [ ] Red indicator for overdue tasks
- [ ] Yellow indicator for due today tasks
- [ ] Priority badges with colors (High=red, Medium=yellow, Low=gray)

**Real-Time Updates:**

- [ ] Dashboard updates every 30 seconds (polling)

---

### Technical Implementation (No-Code)

#### **Frontend (v0.dev + Claude Code)**

**v0.dev Prompt:**

```
Create team member dashboard with:
1. "My Tasks" summary widget - 4 stat cards (To-Do, In-Progress, Due Today, Overdue)
2. Quick filter buttons (Due Today, High Priority, All Tasks)
3. Task list preview - Top 5 tasks with title, brief, due date, priority badge
4. "Start Task" button on To-Do tasks
5. "View All Tasks" link at bottom

Use shadcn/ui Card, Badge, Button components.
Responsive: Stack stat cards vertically on mobile.
```

**Claude Code Integration:**

```typescript
// Query Supabase for team member tasks
const { data: myTasks } = useQuery({
  queryKey: ['my-tasks-summary', activeFilter],
  queryFn: async () => {
    const currentUserId = (await supabase.auth.getUser()).data.user?.id;

    // Summary counts
    let query = supabase
      .from('tasks')
      .select('*', { count: 'exact' })
      .eq('assigned_to', currentUserId);

    const { count: todoCount } = await query.eq('status', 'To-Do');
    const { count: inProgressCount } = await query.eq('status', 'In-Progress');
    const { count: dueTodayCount } = await query.eq('due_date', new Date().toISOString().split('T')[0]);
    const { count: overdueCount } = await query.lt('due_date', new Date().toISOString()).not('status', 'in', '(Accepted,Archived)');

    // Task list preview (top 5, filtered)
    let taskQuery = supabase
      .from('tasks')
      .select('*, briefs(title)')
      .eq('assigned_to', currentUserId)
      .not('status', 'in', '(Accepted,Archived)');

    if (activeFilter === 'dueToday') {
      taskQuery = taskQuery.eq('due_date', new Date().toISOString().split('T')[0]);
    } else if (activeFilter === 'highPriority') {
      taskQuery = taskQuery.eq('priority', 'High');
    }

    const { data: taskList } = await taskQuery
      .order('due_date', { ascending: true, nullsLast: true })
      .order('priority', { ascending: false }) // High → Medium → Low
      .limit(5);

    return {
      counts: { todoCount, inProgressCount, dueTodayCount, overdueCount },
      taskList
    };
  },
  refetchInterval: 30000
});

// Start task handler
const startTask = async (taskId) => {
  await supabase
    .from('tasks')
    .update({ status: 'In-Progress' })
    .eq('id', taskId);

  // Trigger due date picker (Epic 2 Story 2.4)
  openDueDatePicker(taskId);
};
```

---

#### **Database Queries**

**My Tasks Summary:**

```sql
SELECT
  COUNT(*) FILTER (WHERE status = 'To-Do') AS todo_count,
  COUNT(*) FILTER (WHERE status = 'In-Progress') AS in_progress_count,
  COUNT(*) FILTER (WHERE due_date::date = CURRENT_DATE) AS due_today_count,
  COUNT(*) FILTER (WHERE due_date < NOW() AND status NOT IN ('Accepted', 'Archived')) AS overdue_count
FROM tasks
WHERE assigned_to = :current_user_id;
```

**Task List Preview:**

```sql
SELECT
  t.id,
  t.title,
  t.due_date,
  t.priority,
  t.status,
  b.title AS brief_title
FROM tasks t
JOIN briefs b ON t.brief_id = b.id
WHERE t.assigned_to = :current_user_id
AND t.status NOT IN ('Accepted', 'Archived')
ORDER BY t.due_date ASC NULLS LAST, t.priority DESC
LIMIT 5;
```

---

### Functional Requirements Covered

- **FR135:** Team member dashboard shall display "My Tasks" summary (To-Do, In-Progress, Due Today, Overdue)

---

### Story Points

**5 points**

**Breakdown:**

- Frontend summary widget: 1 point
- Quick filter logic: 1 point
- Task list preview: 1 point
- "Start Task" button handler: 1 point
- Testing & polish: 1 point

---

### Dependencies

- Epic 2 (Task Management) - Tasks, assignment, status, priority
- Epic 2 Story 2.4 (Due Date Assignment) - Due date picker

---

### Testing Checklist

- [ ] Summary cards display correct counts
- [ ] Quick filters update task list
- [ ] Task list shows top 5 tasks
- [ ] Task list sorted correctly (due date, then priority)
- [ ] "Start Task" changes status to In-Progress
- [ ] Due date picker opens on "Start Task"
- [ ] Visual cues for overdue (red) and due today (yellow)
- [ ] Priority badges show correct colors
- [ ] "View All Tasks" navigates to full page
- [ ] Polling updates dashboard every 30s

---

## Epic 9 Summary

### Total Story Points: 24

| Story | Story Points | Priority |
|-------|--------------|----------|
| 9.1: Manager Action Center Widget | 8 | P0 |
| 9.2: Summary Analytics Dashboard | 5 | P0 |
| 9.3: Periodic Reminder System | 6 | P0 |
| 9.4: Team Member Dashboard View | 5 | P0 |

---

### Epic Dependencies

**Required Before Starting:**

- Epic 1: Brief Creation (briefs exist)
- Epic 2: Task Management (tasks, assignment, status)
- Epic 3: AI Agents (queuing system)
- Epic 4: Review Workflow (pending reviews)
- Epic 5: Collaboration (notifications, polling pattern)

---

### Timeline

**Week 4-5 (5 working days)**

- Day 1-2: Story 9.1 (Action Center Widget)
- Day 2-3: Story 9.2 (Summary Analytics)
- Day 3-4: Story 9.3 (Periodic Reminders)
- Day 4-5: Story 9.4 (Team Member Dashboard)

**Parallel Execution:**

- Epic 9 runs concurrent with Epic 6 (Search & Navigation) in Week 4
- Minimal dependencies between epics (both UI-focused)

---

### Functional Requirements Covered

- **FR129:** Manager Action Center widget showing pending reviews count
- **FR130:** Overdue tasks count with red visual indicator
- **FR131:** Queued AI tasks count with cost estimate
- **FR132:** Summary analytics (active briefs, total tasks, completion %)
- **FR133:** Brief completion chart with progress bars per active brief
- **FR134:** Periodic reminder banner for pending actions (daily at 9am)
- **FR135:** Team member dashboard "My Tasks" summary

**Total:** 7 new FRs

---

### Success Metrics

**Epic-Level Metrics:**

- **Adoption:** 90%+ of managers use dashboard daily (track page views)
- **Engagement:** Action Center CTR >50% (clicks / views)
- **Efficiency:** Average time to find pending actions <10 seconds
- **Team Member Usage:** 70%+ of team members check dashboard daily

**Story-Level Metrics:**

- Story 9.1: "Review Now" CTR >60%
- Story 9.2: Brief progress chart engagement >40%
- Story 9.3: Banner dismissal rate <30% (indicates relevance)
- Story 9.4: "Start Task" usage >50% of To-Do tasks

---

**Document Status:** Ready for Implementation
**Next Steps:** Review stories → Begin Week 4 implementation → Run parallel with Epic 6
