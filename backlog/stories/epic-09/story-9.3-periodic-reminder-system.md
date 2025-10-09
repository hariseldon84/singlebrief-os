# Story 9.3: Periodic Reminder System

**Story ID:** STORY-9.3
**Epic:** Epic 9 - Manager Command Center (Dashboard)
**Status:** ⬜ To Do
**Last Updated:** 2025-10-07

---

## User Story

**As a** manager
**I want to** receive periodic in-app reminders when actions are pending
**So that** I don't miss important tasks or reviews

---

## Acceptance Criteria

### Reminder Triggers
- [ ] **AI Tasks:** Reminder activates when tasks have been queued for >24 hours (FR-DASH-12)
  - Tasks with status='Queued'
  - Created more than 24 hours ago
  - Assigned to AI agent
- [ ] **Manual Tasks:** Reminder activates when tasks are approaching due date (FR-DASH-13)
  - Tasks due within 24 hours (due tomorrow or today)
  - Tasks already overdue
- [ ] **Task Priority Display:** Show tasks due first (sorted by due date ascending)
- [ ] Reminder checks run every 30 minutes via n8n workflow
- [ ] No reminders sent if Do Not Disturb (DND) hours active (Epic 10, Story 10.2)

### Visual Reminder Display
- [ ] **Banner Style:** Non-blocking banner at top of dashboard (FR-DASH-14)
  - Yellow background for warning
  - Icon: Bell or Clock
  - Message: "You have [count] pending actions requiring attention"
  - **Task details:** Show top 3 tasks due soonest with title and due date
    - Example: "• Write blog post (due tomorrow) • Design mockups (due today) • Code review (overdue)"
- [ ] **Badge on Dashboard Icon:** Red notification dot on sidebar/navbar (FR-DASH-15)
  - Shows count of total pending actions
  - Persists until user dismisses banner or completes actions

### User Actions
- [ ] **View Tasks Button:** Navigate to task list filtered by pending actions (FR-DASH-16)
- [ ] **Review Now Button:** Navigate to Brief Review tab (if pending reviews exist)
- [ ] **Dismiss Button:** Hide banner for 2 hours (snooze) (FR-DASH-17)
  - Dismissal stored in localStorage
  - Banner reappears after 2 hours if actions still pending

### Notification Preferences Integration
- [ ] Respect user's in-app notification settings (Epic 10, Story 10.2)
- [ ] Check `user_settings.inapp_notifications_enabled` before showing reminder
- [ ] Check `user_settings.notify_task_reminder_inapp` for granular control

---

## Technical Implementation

### Frontend (v0.dev + Claude Code)

**Component:** `PeriodicReminderBanner.tsx`

**v0.dev Prompt:**
```
Create a dismissible banner notification component:
- Yellow/warning background
- Bell icon on left
- Text: "You have X pending actions requiring attention"
- List of top 3 tasks with due dates
- Two buttons: "View Tasks" (primary), "Review Now" (secondary), "Dismiss" (ghost)
- Slide-in animation from top
- Use shadcn/ui Alert, Button components
```

**Claude Code Integration:**
```typescript
import { supabase } from "@/integrations/supabase/client";
import { useQuery } from "@tanstack/react-query";

// Check if reminder should be shown
const { data: actionData } = useQuery({
  queryKey: ['action-badge'],
  queryFn: async () => {
    const currentUserId = (await supabase.auth.getUser()).data.user?.id;

    // Check notification settings
    const { data: settings } = await supabase
      .from('user_settings')
      .select('inapp_notifications_enabled, notify_task_reminder_inapp')
      .eq('user_id', currentUserId)
      .single();

    if (!settings?.inapp_notifications_enabled || !settings?.notify_task_reminder_inapp) {
      return { totalCount: 0, upcomingTasks: [] };
    }

    // Check localStorage for dismissal
    const dismissed = localStorage.getItem('reminder-dismissed');
    if (dismissed && Date.now() - parseInt(dismissed) < 7200000) { // 2 hours
      return { totalCount: 0, upcomingTasks: [] };
    }

    // Pending Reviews
    const { count: pendingReviews } = await supabase
      .from('tasks')
      .select('*', { count: 'exact', head: true })
      .eq('status', 'Done')
      .in('brief_id', supabase.from('briefs').select('id').eq('user_id', currentUserId));

    // Overdue Tasks
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

    // Queued AI Tasks (>24h)
    const yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);
    const { count: queuedAI } = await supabase
      .from('tasks')
      .select('*', { count: 'exact', head: true })
      .eq('status', 'Queued')
      .lt('created_at', yesterday.toISOString())
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
  refetchInterval: 30000 // 30 seconds
});

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

// Handle dismiss
const handleDismiss = () => {
  localStorage.setItem('reminder-dismissed', Date.now().toString());
  setShowBanner(false);
};
```

### Backend (n8n Workflow)

**Workflow:** `Periodic Reminder Check`

**Trigger:** Cron schedule - Every 30 minutes

**Steps:**
1. **Query Users with Pending Actions:**
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

2. **Fetch Top 3 Tasks (For Each User):**
   ```sql
   SELECT id, title, due_date
   FROM tasks
   WHERE brief_id IN (SELECT id FROM briefs WHERE user_id = :user_id)
   AND status NOT IN ('Accepted', 'Archived')
   AND due_date IS NOT NULL
   ORDER BY due_date ASC
   LIMIT 3;
   ```

3. **Check Notification Settings:**
   ```javascript
   const settings = await supabase
     .from('user_settings')
     .select('inapp_notifications_enabled, notify_task_reminder_inapp, dnd_start_hour, dnd_end_hour')
     .eq('user_id', user.id)
     .single();

   if (!settings.inapp_notifications_enabled || !settings.notify_task_reminder_inapp) {
     return; // Skip this user
   }

   // Check DND hours (optional for in-app, but consistent with email)
   const currentHour = new Date().getHours();
   const isDND = settings.dnd_start_hour > settings.dnd_end_hour
     ? (currentHour >= settings.dnd_start_hour || currentHour < settings.dnd_end_hour)
     : (currentHour >= settings.dnd_start_hour && currentHour < settings.dnd_end_hour);

   if (isDND) return; // Skip during DND hours
   ```

4. **Insert In-App Notification (Optional - for future enhancement):**
   ```sql
   INSERT INTO notifications (user_id, type, message, created_at)
   VALUES (:user_id, 'task_reminder', 'You have X pending actions', NOW());
   ```

   **Note:** For MVP, frontend polling handles display. Notification table insertion deferred to post-MVP.

---

## Story Points

**6 points**

**Breakdown:**
- UI banner component (v0.dev): 1 point
- Frontend query logic (4 counts + top 3 tasks): 1.5 points
- n8n workflow (cron + SQL queries): 1.5 points
- Dismiss/snooze logic (localStorage): 1 point
- Notification settings integration: 0.5 point
- Testing: 0.5 point

---

## Dependencies

- **Epic 1** - Briefs table
- **Epic 2** - Tasks table with created_at, due_date, status
- **Epic 5** - Notification settings table (for DND hours)
- **Epic 10** - User settings (in-app notification preferences)
- **Story 9.1** - Action center queries (reuse logic)
- n8n instance configured with Supabase connection

---

## Testing Checklist

### Unit Tests
- [ ] AI task reminder triggers when created_at > 24h ago
- [ ] Manual task reminder triggers when due_date within 24 hours
- [ ] Manual task reminder triggers when due_date is overdue
- [ ] Tasks sorted by due_date ascending (due first)
- [ ] Top 3 tasks fetched correctly
- [ ] Due date formatting (overdue, due today, due tomorrow, due in X days)
- [ ] Dismiss logic stores timestamp in localStorage
- [ ] Banner reappears after 2 hours
- [ ] Notification settings checked before showing banner

### Integration Tests
- [ ] n8n workflow runs every 30 minutes
- [ ] SQL query identifies users with pending actions correctly
- [ ] Frontend polling updates banner state
- [ ] Banner disappears when actions completed
- [ ] DND hours block reminders (when enabled)
- [ ] Settings toggle disables reminders

### E2E Tests (Playwright)
- [ ] Banner appears when actions pending >24h
- [ ] Banner shows correct count of pending actions
- [ ] Banner displays top 3 tasks with titles and due dates
- [ ] Click "View Tasks" → navigates to task list
- [ ] Click "Review Now" → navigates to review tab
- [ ] Click "Dismiss" → banner hides for 2 hours
- [ ] Banner reappears after 2 hours if actions still pending
- [ ] Badge on dashboard icon shows count

---

## Definition of Done

- [ ] All acceptance criteria met
- [ ] Unit tests written and passing
- [ ] Integration tests written and passing
- [ ] E2E test written and passing
- [ ] n8n workflow tested and deployed
- [ ] Code reviewed and approved
- [ ] Merged to main branch
- [ ] Deployed to staging
- [ ] Product owner accepts story

---

## FRs Covered

- **FR-DASH-12**: AI task reminders after 24h queued
- **FR-DASH-13**: Manual task reminders for tasks due within 24h or overdue
- **FR-DASH-14**: Non-blocking banner notification style
- **FR-DASH-15**: Badge on dashboard icon with count
- **FR-DASH-16**: "View Tasks" navigation action
- **FR-DASH-17**: Dismiss/snooze functionality (2-hour delay)

---

## Notes

- Keep banner non-intrusive (dismissible)
- Consider sound notification in future (post-MVP)
- Email reminders handled separately in Epic 5 (notification system)
- DND hours respect user preferences from Epic 10

---

## Related Files

- **Component:** `/src/components/PeriodicReminderBanner.tsx` (to be created)
- **n8n Workflow:** `Periodic Reminder Check` (to be created)
- **Database:** `/supabase/migrations/20251005065641_complete_singlebrief_schema.sql`
- **PRD:** `/docs/prd/newscopemissing.md` - Epic 9, Story 9.3
- **Epic Stories:** `/docs/prd/epic9_stories.md`

---

**Last Updated:** 2025-10-07
**Assignee:** TBD
**Start Date:** TBD
**End Date:** TBD
