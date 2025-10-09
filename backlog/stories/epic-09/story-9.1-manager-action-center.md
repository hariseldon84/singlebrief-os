# Story 9.1: Manager Action Center Widget

**Story ID:** STORY-9.1
**Epic:** Epic 9 - Manager Command Center (Dashboard)
**Status:** ⬜ To Do
**Last Updated:** 2025-10-07

---

## User Story

**As a** manager
**I want to** see a dashboard widget showing items requiring my attention
**So that** I can prioritize actions without navigating multiple views

---

## Acceptance Criteria

### Widget Display
- [ ] Widget displays 3 action categories with counts (FR-DASH-01):
  - **Pending Reviews** (tasks with status='Done', awaiting accept/reject)
  - **Overdue Tasks** (tasks past due_date, status != 'Accepted')
  - **Queued AI Tasks** (tasks with status='Queued', assignee is AI agent)

### Visual Cues
- [ ] Color-coded badges for each category (FR-DASH-02):
  - **Red badge** for overdue tasks (urgent priority)
  - **Yellow badge** for due today tasks (warning priority)
  - **Blue badge** for queued AI tasks (informational priority)
- [ ] Badge shows count number (e.g., "3" for 3 pending reviews)
- [ ] Empty state: "Great work! No pending actions." (when all counts = 0)

### One-Click Actions
- [ ] "Review Now" button → Navigate to Brief Review tab (Epic 4) (FR-DASH-03)
- [ ] "Execute AI Tasks" button → Open FAB confirmation dialog (Epic 3)
- [ ] "View Overdue" button → Filter task list to show only overdue items
- [ ] Each button disabled when count = 0

### Real-Time Updates
- [ ] Widget updates every 30 seconds (polling, consistent with Epic 5) (FR-DASH-04)
- [ ] Counts recalculate on each poll
- [ ] Smooth fade transition when counts change

### Responsive Design
- [ ] Widget stacks vertically on mobile (<768px)
- [ ] Cards remain horizontal on desktop (≥768px)
- [ ] Touch-friendly button sizes (min 44px height)

---

## Technical Implementation

### Frontend (v0.dev + Claude Code)

**Component:** `ManagerActionCenter.tsx`

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
import { supabase } from "@/integrations/supabase/client";
import { useQuery } from "@tanstack/react-query";

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

### Database Queries

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

### UI Component Structure

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
          onClick={openFABDialog}
        />
      </div>
    )}
  </CardContent>
</Card>
```

---

## Story Points

**8 points**

**Breakdown:**
- UI component (v0.dev + shadcn/ui): 2 points
- 3 Supabase count queries: 2 points
- Polling logic + real-time updates: 2 points
- Navigation integration (Epic 3, 4): 1 point
- Responsive design + testing: 1 point

---

## Dependencies

- **Epic 1** - Briefs table exists
- **Epic 2** - Tasks table with status, due_date fields
- **Epic 3** - FAB confirmation dialog (for AI task execution)
- **Epic 4** - Brief review tab (for navigation)
- **Epic 5** - 30-second polling pattern established
- Supabase RLS policies for tasks and briefs
- User authentication working (Epic 8)

---

## Testing Checklist

### Unit Tests
- [ ] Pending reviews count query returns correct count
- [ ] Overdue tasks query filters by due_date correctly
- [ ] Queued AI tasks query filters by AI agent assignee
- [ ] Empty state displays when all counts = 0
- [ ] Badges render with correct colors

### Integration Tests
- [ ] Polling updates counts every 30 seconds
- [ ] Counts recalculate after task status change
- [ ] Navigation buttons work correctly
- [ ] Buttons disabled when count = 0
- [ ] Real-time updates reflect database changes

### E2E Tests (Playwright)
- [ ] Dashboard loads with action center widget
- [ ] Counts display correctly on page load
- [ ] Click "Review Now" → navigates to review tab
- [ ] Click "Execute AI Tasks" → opens FAB dialog
- [ ] Click "View Overdue" → filters task list
- [ ] Widget updates when task status changes
- [ ] Empty state shows when no actions pending
- [ ] Responsive layout works on mobile and desktop

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

- **FR-DASH-01**: Action center displays 3 categories (pending reviews, overdue tasks, queued AI)
- **FR-DASH-02**: Color-coded visual badges (red=urgent, yellow=warning, blue=info)
- **FR-DASH-03**: One-click navigation to relevant sections
- **FR-DASH-04**: Real-time polling updates (30-second interval)

---

## Notes

- Widget should be prominently placed at top of dashboard
- Consider adding sound/notification when counts change from 0 → 1 (post-MVP)
- AI task cost estimation deferred to Epic 3 enhancement
- Keep query performance <200ms for good UX

---

## Related Files

- **Component:** `/src/components/ManagerActionCenter.tsx` (to be created)
- **Database:** `/supabase/migrations/20251005065641_complete_singlebrief_schema.sql`
- **PRD:** `/docs/prd/newscopemissing.md` - Epic 9, Story 9.1
- **Epic Stories:** `/docs/prd/epic9_stories.md`

---

**Last Updated:** 2025-10-07
**Assignee:** TBD
**Start Date:** TBD
**End Date:** TBD
