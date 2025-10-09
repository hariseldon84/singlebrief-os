# Story 9.2: Summary Analytics Dashboard

**Story ID:** STORY-9.2
**Epic:** Epic 9 - Manager Command Center (Dashboard)
**Status:** ⬜ To Do
**Last Updated:** 2025-10-07

---

## User Story

**As a** manager
**I want to** view summary analytics of my briefs and team performance
**So that** I can make informed decisions and track overall progress

---

## Acceptance Criteria

### Analytics Cards Display
- [ ] Display 4 summary stat cards (FR-DASH-05):
  - **Brief Completion %** - (Accepted briefs / Total briefs) × 100
  - **Team Velocity** - Tasks completed this week vs last week
  - **Average Task Duration** - Mean time from Created → Accepted
  - **Active Briefs** - Count of briefs with status='active'

### Visual Presentation
- [ ] Each card shows (FR-DASH-06):
  - Large numeric value (e.g., "87%", "12 tasks/week")
  - Trend indicator (↑ up, ↓ down, → stable)
  - Comparison text (e.g., "+5% from last week")
  - Icon representing metric
- [ ] Cards use color coding:
  - **Green** for positive trends (↑)
  - **Red** for negative trends (↓)
  - **Gray** for stable trends (→)

### Data Calculation
- [ ] **Brief Completion %**: (FR-DASH-07)
  ```sql
  (COUNT(briefs WHERE status='completed') / COUNT(briefs)) * 100
  ```
- [ ] **Team Velocity**: (FR-DASH-08)
  ```sql
  COUNT(tasks WHERE status='Accepted' AND accepted_at >= NOW() - INTERVAL '7 days')
  ```
- [ ] **Average Task Duration**: (FR-DASH-09)
  ```sql
  AVG(EXTRACT(EPOCH FROM (accepted_at - created_at)) / 86400) -- in days
  ```
- [ ] **Active Briefs**: (FR-DASH-10)
  ```sql
  COUNT(briefs WHERE status='active')
  ```

### Refresh and Caching
- [ ] Analytics recalculate every 5 minutes (less frequent than action center) (FR-DASH-11)
- [ ] Show "Last updated: X minutes ago" timestamp
- [ ] Manual refresh button available
- [ ] Loading state during recalculation

### Responsive Design
- [ ] 4 cards display in 2×2 grid on desktop (≥1024px)
- [ ] 2 cards per row on tablet (768px-1023px)
- [ ] 1 card per row on mobile (<768px)

---

## Technical Implementation

### Frontend (v0.dev + Claude Code)

**Component:** `SummaryAnalytics.tsx`

**v0.dev Prompt:**
```
Create a summary analytics dashboard with 4 stat cards:
1. Brief Completion % (circular progress, green/red trend)
2. Team Velocity (tasks/week, bar chart, trend arrow)
3. Average Task Duration (days, trend indicator)
4. Active Briefs (count, trend comparison)

Use shadcn/ui Card, Progress, and Badge components.
Include refresh button and "Last updated" timestamp.
Responsive grid: 2×2 desktop, 2×1 tablet, 1×1 mobile.
```

**Claude Code Integration:**
```typescript
import { supabase } from "@/integrations/supabase/client";
import { useQuery } from "@tanstack/react-query";

const { data: analytics, dataUpdatedAt } = useQuery({
  queryKey: ['summary-analytics'],
  queryFn: async () => {
    const currentUserId = (await supabase.auth.getUser()).data.user?.id;

    // Brief Completion %
    const { count: totalBriefs } = await supabase
      .from('briefs')
      .select('*', { count: 'exact', head: true })
      .eq('user_id', currentUserId);

    const { count: completedBriefs } = await supabase
      .from('briefs')
      .select('*', { count: 'exact', head: true })
      .eq('user_id', currentUserId)
      .eq('status', 'completed');

    const completionRate = totalBriefs > 0
      ? Math.round((completedBriefs / totalBriefs) * 100)
      : 0;

    // Team Velocity (this week)
    const thisWeekStart = new Date();
    thisWeekStart.setDate(thisWeekStart.getDate() - 7);

    const { count: thisWeekTasks } = await supabase
      .from('tasks')
      .select('*', { count: 'exact', head: true })
      .eq('status', 'Accepted')
      .gte('accepted_at', thisWeekStart.toISOString())
      .in('brief_id',
        supabase.from('briefs').select('id').eq('user_id', currentUserId)
      );

    // Team Velocity (last week)
    const lastWeekStart = new Date();
    lastWeekStart.setDate(lastWeekStart.getDate() - 14);
    const lastWeekEnd = new Date();
    lastWeekEnd.setDate(lastWeekEnd.getDate() - 7);

    const { count: lastWeekTasks } = await supabase
      .from('tasks')
      .select('*', { count: 'exact', head: true })
      .eq('status', 'Accepted')
      .gte('accepted_at', lastWeekStart.toISOString())
      .lte('accepted_at', lastWeekEnd.toISOString())
      .in('brief_id',
        supabase.from('briefs').select('id').eq('user_id', currentUserId)
      );

    const velocityTrend = thisWeekTasks - lastWeekTasks;

    // Average Task Duration
    const { data: acceptedTasks } = await supabase
      .from('tasks')
      .select('created_at, accepted_at')
      .eq('status', 'Accepted')
      .not('accepted_at', 'is', null)
      .in('brief_id',
        supabase.from('briefs').select('id').eq('user_id', currentUserId)
      )
      .limit(100); // Last 100 tasks

    const avgDuration = acceptedTasks?.reduce((acc, task) => {
      const duration = (new Date(task.accepted_at) - new Date(task.created_at)) / (1000 * 60 * 60 * 24);
      return acc + duration;
    }, 0) / (acceptedTasks?.length || 1);

    // Active Briefs
    const { count: activeBriefs } = await supabase
      .from('briefs')
      .select('*', { count: 'exact', head: true })
      .eq('user_id', currentUserId)
      .eq('status', 'active');

    return {
      completionRate,
      velocity: { thisWeek: thisWeekTasks, lastWeek: lastWeekTasks, trend: velocityTrend },
      avgDuration: Math.round(avgDuration * 10) / 10, // 1 decimal place
      activeBriefs
    };
  },
  refetchInterval: 300000, // 5 minutes
  staleTime: 240000 // 4 minutes
});

// Calculate "last updated" time
const lastUpdated = dataUpdatedAt
  ? Math.floor((Date.now() - dataUpdatedAt) / 60000)
  : 0;
```

### Database Queries

**Brief Completion Rate:**
```sql
SELECT
  COUNT(*) FILTER (WHERE status = 'completed') AS completed,
  COUNT(*) AS total,
  ROUND((COUNT(*) FILTER (WHERE status = 'completed')::NUMERIC / COUNT(*)) * 100, 0) AS completion_rate
FROM briefs
WHERE user_id = :current_user_id;
```

**Team Velocity (This Week vs Last Week):**
```sql
SELECT
  COUNT(*) FILTER (WHERE accepted_at >= NOW() - INTERVAL '7 days') AS this_week,
  COUNT(*) FILTER (WHERE accepted_at >= NOW() - INTERVAL '14 days'
                     AND accepted_at < NOW() - INTERVAL '7 days') AS last_week
FROM tasks
WHERE status = 'Accepted'
AND brief_id IN (SELECT id FROM briefs WHERE user_id = :current_user_id);
```

**Average Task Duration:**
```sql
SELECT AVG(EXTRACT(EPOCH FROM (accepted_at - created_at)) / 86400) AS avg_days
FROM tasks
WHERE status = 'Accepted'
AND accepted_at IS NOT NULL
AND brief_id IN (SELECT id FROM briefs WHERE user_id = :current_user_id)
LIMIT 100; -- Last 100 tasks
```

**Active Briefs Count:**
```sql
SELECT COUNT(*) FROM briefs
WHERE user_id = :current_user_id
AND status = 'active';
```

---

## Story Points

**5 points**

**Breakdown:**
- UI component (v0.dev + 4 stat cards): 1 point
- 4 analytics queries + calculations: 2 points
- Trend comparison logic: 1 point
- Caching + refresh logic: 0.5 point
- Responsive design + testing: 0.5 point

---

## Dependencies

- **Epic 1** - Briefs table with status field
- **Epic 2** - Tasks table with created_at, accepted_at timestamps
- **Epic 4** - Task acceptance workflow (provides accepted_at data)
- Supabase RLS policies for briefs and tasks
- User authentication working (Epic 8)

---

## Testing Checklist

### Unit Tests
- [ ] Completion rate calculates correctly (0%, 50%, 100%)
- [ ] Velocity trend shows ↑ when this_week > last_week
- [ ] Velocity trend shows ↓ when this_week < last_week
- [ ] Average duration handles null accepted_at gracefully
- [ ] Active briefs count excludes completed/archived briefs

### Integration Tests
- [ ] Analytics refresh every 5 minutes
- [ ] Manual refresh button updates data immediately
- [ ] "Last updated" timestamp updates correctly
- [ ] Loading state appears during recalculation
- [ ] Trend indicators render with correct colors

### E2E Tests (Playwright)
- [ ] Dashboard displays 4 analytics cards
- [ ] Brief completion % shows correct value
- [ ] Team velocity displays tasks/week and trend
- [ ] Average task duration shows in days
- [ ] Active briefs count matches database
- [ ] Manual refresh updates all metrics
- [ ] Responsive grid works on all screen sizes

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

- **FR-DASH-05**: Summary analytics with 4 key metrics
- **FR-DASH-06**: Visual trend indicators with color coding
- **FR-DASH-07**: Brief completion percentage calculation
- **FR-DASH-08**: Team velocity (tasks/week) with comparison
- **FR-DASH-09**: Average task duration in days
- **FR-DASH-10**: Active briefs count
- **FR-DASH-11**: 5-minute refresh interval for analytics

---

## Notes

- Keep analytics queries performant (<500ms)
- Consider adding more metrics in future (AI cost, user engagement)
- Cache results to reduce database load
- Trend comparisons deferred to "last 7 days vs previous 7 days" (not month-over-month)

---

## Related Files

- **Component:** `/src/components/SummaryAnalytics.tsx` (to be created)
- **Database:** `/supabase/migrations/20251005065641_complete_singlebrief_schema.sql`
- **PRD:** `/docs/prd/newscopemissing.md` - Epic 9, Story 9.2
- **Epic Stories:** `/docs/prd/epic9_stories.md`

---

**Last Updated:** 2025-10-07
**Assignee:** TBD
**Start Date:** TBD
**End Date:** TBD
