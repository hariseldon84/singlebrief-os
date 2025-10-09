# Story 9.4: Team Member Dashboard View

**Story ID:** STORY-9.4
**Epic:** Epic 9 - Manager Command Center (Dashboard)
**Status:** ⬜ To Do
**Last Updated:** 2025-10-07

---

## User Story

**As a** team member
**I want to** see a personalized dashboard showing my assigned tasks and priorities
**So that** I can focus on my work without navigating multiple sections

---

## Acceptance Criteria

### Dashboard Personalization
- [ ] Dashboard displays differently based on user role (FR-DASH-18):
  - **Manager Role:** Shows Action Center + Summary Analytics (Stories 9.1-9.3)
  - **Team Member Role:** Shows My Tasks widget + Task Priority list
- [ ] Role detection uses `profiles.role` field (Epic 8 - User Authentication)

### My Tasks Widget
- [ ] Display 3 task categories with counts (FR-DASH-19):
  - **Due Today** - Tasks with due_date = today
  - **Due This Week** - Tasks with due_date within next 7 days
  - **In Progress** - Tasks with status='In Progress' assigned to me
- [ ] Color-coded badges:
  - **Red badge** for overdue tasks (past due_date)
  - **Yellow badge** for due today
  - **Blue badge** for due this week
  - **Green badge** for in progress

### Task Priority List
- [ ] Show top 5 tasks sorted by priority (FR-DASH-20):
  - Primary sort: due_date (ascending - soonest first)
  - Secondary sort: created_at (ascending - oldest first)
  - Tertiary sort: status (Done > In Progress > Queued)
- [ ] Each task displays:
  - Task title (truncated to 50 chars)
  - Due date (formatted as "Due today", "Due tomorrow", "Due in X days")
  - Brief title (truncated to 30 chars)
  - Status badge
- [ ] Click task → Navigate to task detail view (Epic 2)

### Quick Actions
- [ ] **Start Task Button:** Change status from 'Queued' → 'In Progress' (FR-DASH-21)
- [ ] **Mark Done Button:** Change status from 'In Progress' → 'Done' (Epic 4)
- [ ] **View All Tasks Button:** Navigate to full task list filtered by assigned user

### Real-Time Updates
- [ ] Widget updates every 30 seconds (polling, consistent with manager dashboard)
- [ ] Task counts recalculate on each poll
- [ ] Smooth transition when tasks move between categories

### Responsive Design
- [ ] Task priority list scrollable on mobile (max-height: 400px)
- [ ] Widget stacks vertically on mobile (<768px)
- [ ] Touch-friendly task rows (min 48px height)

---

## Technical Implementation

### Frontend (v0.dev + Claude Code)

**Component:** `TeamMemberDashboard.tsx`

**v0.dev Prompt:**
```
Create a team member dashboard with 2 sections:
1. My Tasks Widget - 3 stat cards (Due Today, Due This Week, In Progress)
2. Task Priority List - Top 5 tasks with title, due date, brief, status badge

Use shadcn/ui Card, Badge, Button, and ScrollArea components.
Include quick action buttons: "Start Task", "Mark Done", "View All Tasks".
Responsive: Stack vertically on mobile, horizontal on desktop.
```

**Claude Code Integration:**
```typescript
import { supabase } from "@/integrations/supabase/client";
import { useQuery } from "@tanstack/react-query";

// Detect user role
const { data: profile } = useQuery({
  queryKey: ['user-profile'],
  queryFn: async () => {
    const currentUserId = (await supabase.auth.getUser()).data.user?.id;
    const { data } = await supabase
      .from('profiles')
      .select('role')
      .eq('user_id', currentUserId)
      .single();
    return data;
  }
});

// Conditionally render dashboard
if (profile?.role === 'Manager') {
  return <ManagerDashboard />; // Stories 9.1-9.3
} else {
  return <TeamMemberDashboard />; // This story
}

// Query tasks assigned to team member
const { data: myTasks } = useQuery({
  queryKey: ['team-member-tasks'],
  queryFn: async () => {
    const currentUserId = (await supabase.auth.getUser()).data.user?.id;

    // Due Today
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);

    const { count: dueToday } = await supabase
      .from('tasks')
      .select('*', { count: 'exact', head: true })
      .eq('assigned_to', currentUserId)
      .gte('due_date', today.toISOString())
      .lt('due_date', tomorrow.toISOString())
      .not('status', 'in', '(Accepted,Archived)');

    // Due This Week
    const nextWeek = new Date(today);
    nextWeek.setDate(nextWeek.getDate() + 7);

    const { count: dueThisWeek } = await supabase
      .from('tasks')
      .select('*', { count: 'exact', head: true })
      .eq('assigned_to', currentUserId)
      .gte('due_date', tomorrow.toISOString())
      .lt('due_date', nextWeek.toISOString())
      .not('status', 'in', '(Accepted,Archived)');

    // In Progress
    const { count: inProgress } = await supabase
      .from('tasks')
      .select('*', { count: 'exact', head: true })
      .eq('assigned_to', currentUserId)
      .eq('status', 'In Progress');

    // Top 5 priority tasks
    const { data: topTasks } = await supabase
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
      .limit(5);

    return { dueToday, dueThisWeek, inProgress, topTasks };
  },
  refetchInterval: 30000 // 30 seconds
});

// Handle quick actions
const handleStartTask = async (taskId) => {
  await supabase
    .from('tasks')
    .update({ status: 'In Progress', started_at: new Date().toISOString() })
    .eq('id', taskId);
};

const handleMarkDone = async (taskId) => {
  await supabase
    .from('tasks')
    .update({ status: 'Done', completed_at: new Date().toISOString() })
    .eq('id', taskId);
};
```

### Database Queries

**Due Today Count:**
```sql
SELECT COUNT(*) FROM tasks
WHERE assigned_to = :current_user_id
AND due_date >= CURRENT_DATE
AND due_date < CURRENT_DATE + INTERVAL '1 day'
AND status NOT IN ('Accepted', 'Archived');
```

**Due This Week Count:**
```sql
SELECT COUNT(*) FROM tasks
WHERE assigned_to = :current_user_id
AND due_date >= CURRENT_DATE + INTERVAL '1 day'
AND due_date < CURRENT_DATE + INTERVAL '7 days'
AND status NOT IN ('Accepted', 'Archived');
```

**In Progress Count:**
```sql
SELECT COUNT(*) FROM tasks
WHERE assigned_to = :current_user_id
AND status = 'In Progress';
```

**Top 5 Priority Tasks:**
```sql
SELECT
  t.id,
  t.title,
  t.due_date,
  t.status,
  b.title AS brief_title
FROM tasks t
JOIN briefs b ON t.brief_id = b.id
WHERE t.assigned_to = :current_user_id
AND t.status NOT IN ('Accepted', 'Archived')
ORDER BY
  t.due_date ASC NULLS LAST,
  t.created_at ASC
LIMIT 5;
```

---

## Story Points

**5 points**

**Breakdown:**
- UI component (v0.dev + 2 widgets): 1 point
- Role-based dashboard switching: 1 point
- 3 task count queries: 1 point
- Top 5 tasks query + sorting: 1 point
- Quick action handlers + testing: 1 point

---

## Dependencies

- **Epic 2** - Tasks table with assigned_to, due_date, status
- **Epic 8** - User authentication and profiles table with role field
- **Story 9.1** - Dashboard layout and navigation
- Supabase RLS policies for tasks (team members can only see their own tasks)

---

## Testing Checklist

### Unit Tests
- [ ] Role detection returns 'Manager' or 'Team Member'
- [ ] Dashboard switches correctly based on role
- [ ] Due today query filters by current date
- [ ] Due this week query filters next 7 days
- [ ] Top 5 tasks sorted by due_date → created_at
- [ ] Quick action handlers update task status

### Integration Tests
- [ ] Polling updates counts every 30 seconds
- [ ] Task counts recalculate after status change
- [ ] Start Task changes status to 'In Progress'
- [ ] Mark Done changes status to 'Done'
- [ ] RLS policies enforce user can only see assigned tasks

### E2E Tests (Playwright)
- [ ] Team member logs in → sees team member dashboard
- [ ] Manager logs in → sees manager dashboard
- [ ] My Tasks widget displays 3 categories
- [ ] Task priority list shows top 5 tasks
- [ ] Click task → navigates to task detail
- [ ] Click "Start Task" → status updates
- [ ] Click "Mark Done" → status updates
- [ ] Click "View All Tasks" → navigates to full task list

---

## Definition of Done

- [ ] All acceptance criteria met
- [ ] Unit tests written and passing
- [ ] Integration tests written and passing
- [ ] E2E test written and passing
- [ ] Code reviewed and approved
- [ ] Merged to main branch
- [ ] Deployed to staging
- [ ] Product owner accepts story

---

## FRs Covered

- **FR-DASH-18**: Role-based dashboard personalization (Manager vs Team Member)
- **FR-DASH-19**: My Tasks widget with 3 categories
- **FR-DASH-20**: Task priority list sorted by due date
- **FR-DASH-21**: Quick action buttons (Start Task, Mark Done)

---

## Notes

- Keep queries performant (<200ms) for good UX
- Consider adding "Blocked" tasks category in future
- Task detail view from Epic 2 should be reused (no duplication)
- Ensure RLS policies prevent cross-user data leakage

---

## Related Files

- **Component:** `/src/components/TeamMemberDashboard.tsx` (to be created)
- **Component:** `/src/components/ManagerDashboard.tsx` (from Stories 9.1-9.3)
- **Database:** `/supabase/migrations/20251005065641_complete_singlebrief_schema.sql`
- **PRD:** `/docs/prd/newscopemissing.md` - Epic 9, Story 9.4
- **Epic Stories:** `/docs/prd/epic9_stories.md`

---

**Last Updated:** 2025-10-07
**Assignee:** TBD
**Start Date:** TBD
**End Date:** TBD
