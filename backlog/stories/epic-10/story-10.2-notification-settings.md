# Story 10.2: Notification Settings (Email + In-App)

**Story ID:** STORY-10.2
**Epic:** Epic 10 - User Settings & Profile Management
**Status:** ⬜ To Do
**Last Updated:** 2025-10-07

---

## User Story

**As a** user
**I want** granular control over email and in-app notifications
**So that** I receive alerts only for what matters to me

---

## Acceptance Criteria

### Notifications Tab
- [ ] Settings page has "Notifications" tab (second tab after Profile) (FR-NOTIF-01)
- [ ] Tab displays notification preferences form

### Master Toggles
- [ ] Two master switches at top (FR-NOTIF-02):
  - **Email Notifications** (toggle switch, default: ON)
  - **In-App Notifications** (toggle switch, default: ON)
- [ ] Disabling master toggle disables all sub-toggles for that channel
- [ ] Disabling master toggle grays out all sub-toggles (visual feedback)

### Granular Notification Type Toggles (8 Types × 2 Channels = 16 Toggles)

**Email Notification Types** (FR-NOTIF-03):
- [ ] Task Assigned (default: ON)
- [ ] Output Submitted (Manager only, default: ON)
- [ ] Task Accepted (default: ON)
- [ ] Task Rejected (Team Member only, default: ON)
- [ ] @Mention in Comments (default: ON)
- [ ] AI Tasks Completed (Manager only, default: ON)
- [ ] Overdue Task Reminder (Daily digest, default: OFF)
- [ ] Queued AI Tasks Reminder (24h delay, default: OFF)

**In-App Notification Types** (FR-NOTIF-04):
- [ ] Task Assigned (default: ON)
- [ ] Output Submitted (default: ON)
- [ ] Task Accepted (default: ON)
- [ ] Task Rejected (default: ON)
- [ ] @Mention in Comments (default: ON)
- [ ] AI Tasks Completed (default: ON)
- [ ] Overdue Task Reminder (default: ON)
- [ ] Queued AI Tasks Reminder (default: ON)

### Do Not Disturb (DND)
- [ ] DND section below notification toggles (FR-NOTIF-05)
- [ ] Description: "No email notifications will be sent during these hours"
- [ ] Start time picker (dropdown, default: 9:00 PM / 21:00)
- [ ] End time picker (dropdown, default: 9:00 AM / 09:00)
- [ ] Time format: 12-hour (with AM/PM) or 24-hour based on locale
- [ ] DND applies to email only (in-app notifications not affected)

### Per-Brief Notification Settings
- [ ] "Mute Specific Briefs" section at bottom (FR-NOTIF-06)
- [ ] Brief selector (dropdown showing active briefs owned by user)
- [ ] "Mute" button next to dropdown
- [ ] Clicking "Mute":
  - Adds brief to muted list
  - Clears dropdown selection
  - Shows brief in muted list below
- [ ] Muted briefs list:
  - Shows each muted brief with title
  - "Unmute" button next to each brief
  - Clicking "Unmute" removes brief from muted list

### Save Functionality
- [ ] "Save Changes" button at bottom of form (FR-NOTIF-07)
- [ ] Button disabled until changes made
- [ ] Clicking "Save Changes":
  - Updates `user_settings` table with all 18 toggle states + DND hours
  - Updates `user_brief_mutes` table (insert/delete)
  - Shows success toast: "Notification settings updated successfully"
- [ ] Settings applied immediately (n8n workflows check on next notification)

---

## Technical Implementation

### Database Schema

**Expand `user_settings` Table:**
```sql
ALTER TABLE user_settings
ADD COLUMN email_notifications_enabled boolean DEFAULT true,
ADD COLUMN inapp_notifications_enabled boolean DEFAULT true,

-- Email toggles (8 types)
ADD COLUMN notify_task_assigned_email boolean DEFAULT true,
ADD COLUMN notify_output_submitted_email boolean DEFAULT true,
ADD COLUMN notify_task_accepted_email boolean DEFAULT true,
ADD COLUMN notify_task_rejected_email boolean DEFAULT true,
ADD COLUMN notify_mention_email boolean DEFAULT true,
ADD COLUMN notify_ai_completed_email boolean DEFAULT true,
ADD COLUMN notify_overdue_email boolean DEFAULT false,
ADD COLUMN notify_queued_ai_email boolean DEFAULT false,

-- In-app toggles (8 types)
ADD COLUMN notify_task_assigned_inapp boolean DEFAULT true,
ADD COLUMN notify_output_submitted_inapp boolean DEFAULT true,
ADD COLUMN notify_task_accepted_inapp boolean DEFAULT true,
ADD COLUMN notify_task_rejected_inapp boolean DEFAULT true,
ADD COLUMN notify_mention_inapp boolean DEFAULT true,
ADD COLUMN notify_ai_completed_inapp boolean DEFAULT true,
ADD COLUMN notify_overdue_inapp boolean DEFAULT true,
ADD COLUMN notify_queued_ai_inapp boolean DEFAULT true,

-- DND hours
ADD COLUMN dnd_start_hour int DEFAULT 21 CHECK (dnd_start_hour >= 0 AND dnd_start_hour < 24),
ADD COLUMN dnd_end_hour int DEFAULT 9 CHECK (dnd_end_hour >= 0 AND dnd_end_hour < 24);
```

**Create `user_brief_mutes` Table:**
```sql
CREATE TABLE IF NOT EXISTS user_brief_mutes (
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE,
  brief_id uuid REFERENCES briefs(id) ON DELETE CASCADE,
  created_at timestamptz DEFAULT now(),
  PRIMARY KEY (user_id, brief_id)
);

-- RLS Policy
CREATE POLICY "Users can manage own brief mutes"
ON user_brief_mutes FOR ALL TO authenticated
USING (user_id = auth.uid());
```

### Frontend (v0.dev + Claude Code)

**Component:** `NotificationSettings.tsx`

**v0.dev Prompt:**
```
Create a notification settings page with:
1. Two master toggle switches (Email, In-App) at top
2. Grid of 8 notification types (rows) × 2 channels (columns)
3. Each cell has a toggle switch (16 total)
4. DND section: Start/End time pickers (dropdowns)
5. Mute Briefs section: Dropdown selector + Mute button, Muted list with Unmute buttons
6. "Save Changes" button at bottom

Use shadcn/ui components: Tabs, Switch, Select, Button, Card.
Gray out sub-toggles when master toggle is OFF.
Show character counter and validation errors inline.
```

**Claude Code Integration:**
```typescript
import { supabase } from "@/integrations/supabase/client";
import { useQuery, useMutation } from "@tanstack/react-query";
import { useToast } from "@/components/ui/use-toast";

// Fetch current settings
const { data: settings } = useQuery({
  queryKey: ['user-settings'],
  queryFn: async () => {
    const currentUserId = (await supabase.auth.getUser()).data.user?.id;
    const { data } = await supabase
      .from('user_settings')
      .select('*')
      .eq('user_id', currentUserId)
      .single();
    return data;
  }
});

// Fetch muted briefs
const { data: mutedBriefs } = useQuery({
  queryKey: ['muted-briefs'],
  queryFn: async () => {
    const currentUserId = (await supabase.auth.getUser()).data.user?.id;
    const { data } = await supabase
      .from('user_brief_mutes')
      .select('brief_id, briefs(title)')
      .eq('user_id', currentUserId);
    return data;
  }
});

// Update settings mutation
const updateSettings = useMutation({
  mutationFn: async (updates) => {
    const currentUserId = (await supabase.auth.getUser()).data.user?.id;
    const { error } = await supabase
      .from('user_settings')
      .upsert({
        user_id: currentUserId,
        ...updates
      });
    if (error) throw error;
  },
  onSuccess: () => {
    toast({ title: "Notification settings updated successfully", variant: "success" });
  },
  onError: () => {
    toast({ title: "Failed to update settings", variant: "destructive" });
  }
});

// Mute brief mutation
const muteBrief = useMutation({
  mutationFn: async (briefId) => {
    const currentUserId = (await supabase.auth.getUser()).data.user?.id;
    const { error } = await supabase
      .from('user_brief_mutes')
      .insert({ user_id: currentUserId, brief_id: briefId });
    if (error) throw error;
  },
  onSuccess: () => {
    toast({ title: "Brief muted", variant: "success" });
  }
});

// Unmute brief mutation
const unmuteBrief = useMutation({
  mutationFn: async (briefId) => {
    const currentUserId = (await supabase.auth.getUser()).data.user?.id;
    const { error } = await supabase
      .from('user_brief_mutes')
      .delete()
      .eq('user_id', currentUserId)
      .eq('brief_id', briefId);
    if (error) throw error;
  },
  onSuccess: () => {
    toast({ title: "Brief unmuted", variant: "success" });
  }
});
```

### n8n Workflow Integration

**Update all n8n notification workflows to check settings before sending:**

```javascript
// Example: Task Assigned notification workflow

// 1. Fetch user settings
const settings = await supabase
  .from('user_settings')
  .select('*')
  .eq('user_id', taskAssignee)
  .single();

// 2. Check master toggle
if (channel === 'email' && !settings.email_notifications_enabled) {
  return; // Don't send email
}
if (channel === 'inapp' && !settings.inapp_notifications_enabled) {
  return; // Don't send in-app notification
}

// 3. Check specific notification type toggle
const toggleField = `notify_task_assigned_${channel}`; // e.g., notify_task_assigned_email
if (!settings[toggleField]) {
  return; // Don't send this notification type
}

// 4. Check DND hours (for email only)
if (channel === 'email') {
  const currentHour = new Date().getHours();
  const isDND = settings.dnd_start_hour > settings.dnd_end_hour
    ? (currentHour >= settings.dnd_start_hour || currentHour < settings.dnd_end_hour)
    : (currentHour >= settings.dnd_start_hour && currentHour < settings.dnd_end_hour);

  if (isDND) {
    return; // Don't send during DND hours
  }
}

// 5. Check per-brief mute
const isMuted = await supabase
  .from('user_brief_mutes')
  .select('*')
  .eq('user_id', taskAssignee)
  .eq('brief_id', task.brief_id)
  .single();

if (isMuted) {
  return; // Don't send notification for muted brief
}

// 6. Send notification (all checks passed)
await sendNotification(taskAssignee, channel, 'task_assigned', taskData);
```

---

## Story Points

**8 points**

**Breakdown:**
- UI component (v0.dev + 16 toggles): 2 points
- Database schema (18 columns + mutes table): 1 point
- Settings CRUD logic: 1.5 points
- Mute/unmute brief logic: 1 point
- n8n workflow updates (8 notification types): 2 points
- Testing: 0.5 point

---

## Dependencies

- **Epic 5** - Notification system exists (Stories 5.1-5.3)
- **Epic 8** - User authentication working
- **Story 10.1** - Settings page navigation exists
- n8n workflows configured for notifications

---

## Testing Checklist

### Unit Tests
- [ ] Master toggle disables all sub-toggles
- [ ] Master toggle grays out sub-toggles (visual feedback)
- [ ] Each notification type toggle works independently
- [ ] DND hours validation (0-23)
- [ ] Mute brief adds to muted list
- [ ] Unmute brief removes from muted list

### Integration Tests
- [ ] Settings load current user preferences
- [ ] Save updates user_settings table
- [ ] n8n workflows check master toggle before sending
- [ ] n8n workflows check specific toggle before sending
- [ ] n8n workflows check DND hours for email
- [ ] n8n workflows check muted briefs list
- [ ] Settings apply immediately on save

### E2E Tests (Playwright)
- [ ] Navigate to Settings → Notifications tab
- [ ] Master toggles work (ON/OFF)
- [ ] Sub-toggles gray out when master is OFF
- [ ] Change notification type toggle → save → persists
- [ ] Set DND hours → save → email blocked during DND
- [ ] Select brief → click "Mute" → appears in muted list
- [ ] Click "Unmute" → brief removed from muted list
- [ ] Notification respects all settings (email + in-app)

---

## Definition of Done

- [ ] All acceptance criteria met
- [ ] Unit tests written and passing
- [ ] Integration tests written and passing
- [ ] E2E test written and passing
- [ ] n8n workflows updated and tested
- [ ] Code reviewed and approved
- [ ] Merged to main branch
- [ ] Deployed to staging
- [ ] Product owner accepts story

---

## FRs Covered

- **FR-NOTIF-01**: Notifications tab in settings
- **FR-NOTIF-02**: Master toggles for email and in-app
- **FR-NOTIF-03**: 8 email notification type toggles
- **FR-NOTIF-04**: 8 in-app notification type toggles
- **FR-NOTIF-05**: Do Not Disturb hours for email
- **FR-NOTIF-06**: Per-brief muting functionality
- **FR-NOTIF-07**: Save and apply settings immediately

---

## Notes

- 16 total toggles (8 types × 2 channels) + 2 master toggles = 18 settings
- DND applies to email only (in-app always enabled when toggle is ON)
- Per-brief muting applies to both email and in-app notifications
- Settings apply on next notification trigger (no immediate retroactive application)
- Consider adding "Notification Digest" option in future (daily/weekly summary)

---

## Related Files

- **Component:** `/src/components/NotificationSettings.tsx` (to be created)
- **Database:** `/supabase/migrations/[timestamp]_add_notification_settings.sql`
- **n8n Workflows:** All 8 notification workflows (to be updated)
- **PRD:** `/docs/prd/newscopemissing.md` - Epic 10, Story 10.2
- **Epic Stories:** `/docs/prd/epic10_stories.md`

---

**Last Updated:** 2025-10-07
**Assignee:** TBD
**Start Date:** TBD
**End Date:** TBD
