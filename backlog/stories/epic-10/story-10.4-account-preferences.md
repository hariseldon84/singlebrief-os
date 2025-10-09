# Story 10.4: Account Preferences Consolidation

**Story ID:** STORY-10.4
**Epic:** Epic 10 - User Settings & Profile Management
**Status:** ⬜ To Do
**Last Updated:** 2025-10-07

---

## User Story

**As a** user
**I want to** manage account-level preferences in one place
**So that** I can customize the system behavior to my workflow preferences

---

## Acceptance Criteria

### Preferences Tab
- [ ] Settings page has "Preferences" tab (fourth tab after Profile, Notifications, Help) (FR-PREF-01)
- [ ] Tab displays account preferences form

### Task Limit Setting (Consolidated from Epic 2 Story 1.8)
- [ ] **Task Limit** setting (FR-PREF-02):
  - Label: "Maximum Tasks per Brief"
  - Input: Number input (min: 5, max: 30, default: 15)
  - Description: "Control how many tasks AI generates per brief. Lower limits reduce costs but may require multiple briefs."
  - Validation: Show error if < 5 or > 30
  - Auto-save on blur

### Theme Setting (Future-Proof)
- [ ] **Theme** setting (FR-PREF-03):
  - Label: "Interface Theme"
  - Dropdown: Light, Dark, System (follows OS preference)
  - Default: System
  - Note: "Theme switching deferred to post-MVP. This setting is prepared for future implementation."
  - Grayed out with tooltip: "Coming soon"

### Language/Locale Setting (Future-Proof)
- [ ] **Language** setting (FR-PREF-04):
  - Label: "Language"
  - Dropdown: English (US) - only option in MVP
  - Default: English (US)
  - Note: "Internationalization deferred to post-MVP."
  - Grayed out with tooltip: "Coming soon"

### Timezone Setting
- [ ] **Timezone** setting (FR-PREF-05):
  - Label: "Timezone"
  - Dropdown: All major timezones (e.g., America/New_York, Europe/London)
  - Default: Auto-detected from browser
  - Description: "Used for displaying due dates and notification times"
  - Auto-save on change

### Email Digest Frequency (Future-Proof)
- [ ] **Email Digest** setting (FR-PREF-06):
  - Label: "Email Digest Frequency"
  - Dropdown: None, Daily, Weekly
  - Default: None
  - Description: "Receive a summary of all activity instead of individual emails"
  - Note: "Email digests deferred to post-MVP."
  - Grayed out with tooltip: "Coming soon"

### Save Functionality
- [ ] Changes auto-save on blur/change (no explicit save button)
- [ ] Success toast on each setting update
- [ ] Error toast on validation failure

---

## Technical Implementation

### Frontend (v0.dev + Claude Code)

**Component:** `AccountPreferences.tsx`

**v0.dev Prompt:**
```
Create an account preferences page with 6 settings:
1. Task Limit - Number input (5-30, default 15)
2. Theme - Dropdown (Light, Dark, System) - grayed out
3. Language - Dropdown (English US only) - grayed out
4. Timezone - Dropdown (auto-detect from browser, all timezones)
5. Email Digest - Dropdown (None, Daily, Weekly) - grayed out

Use shadcn/ui components: Tabs, Input, Select, Label, Card.
Show descriptions below each setting.
Add tooltips to grayed-out settings: "Coming soon".
Auto-save on blur/change.
```

**Claude Code Integration:**
```typescript
import { supabase } from "@/integrations/supabase/client";
import { useQuery, useMutation } from "@tanstack/react-query";
import { useToast } from "@/components/ui/use-toast";

// Fetch current preferences
const { data: preferences } = useQuery({
  queryKey: ['user-preferences'],
  queryFn: async () => {
    const currentUserId = (await supabase.auth.getUser()).data.user?.id;
    const { data } = await supabase
      .from('user_settings')
      .select('task_limit, timezone')
      .eq('user_id', currentUserId)
      .single();

    // Auto-detect timezone from browser if not set
    const detectedTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

    return {
      taskLimit: data?.task_limit || 15,
      timezone: data?.timezone || detectedTimezone,
      theme: 'System', // Future
      language: 'English (US)', // Future
      emailDigest: 'None' // Future
    };
  }
});

// Update preference mutation
const updatePreference = useMutation({
  mutationFn: async ({ field, value }) => {
    const currentUserId = (await supabase.auth.getUser()).data.user?.id;
    const { error } = await supabase
      .from('user_settings')
      .upsert({
        user_id: currentUserId,
        [field]: value
      });
    if (error) throw error;
  },
  onSuccess: () => {
    toast({ title: "Preference updated", variant: "success" });
  },
  onError: () => {
    toast({ title: "Failed to update preference", variant: "destructive" });
  }
});

// Auto-save handlers
const handleTaskLimitBlur = (value) => {
  if (value < 5 || value > 30) {
    toast({ title: "Task limit must be between 5 and 30", variant: "destructive" });
    return;
  }
  updatePreference.mutate({ field: 'task_limit', value });
};

const handleTimezoneChange = (value) => {
  updatePreference.mutate({ field: 'timezone', value });
};
```

### Database Schema

**Update `user_settings` Table** (from Epic 2 Story 1.8):
```sql
-- task_limit already exists from Epic 2 Story 1.8
-- Add timezone field
ALTER TABLE user_settings
ADD COLUMN timezone text DEFAULT 'UTC';

-- Future fields (prepare for post-MVP)
ALTER TABLE user_settings
ADD COLUMN theme text DEFAULT 'System' CHECK (theme IN ('Light', 'Dark', 'System')),
ADD COLUMN language text DEFAULT 'en-US',
ADD COLUMN email_digest text DEFAULT 'None' CHECK (email_digest IN ('None', 'Daily', 'Weekly'));
```

### Timezone Support

**Available Timezones** (common ones for dropdown):
- America/New_York
- America/Chicago
- America/Denver
- America/Los_Angeles
- Europe/London
- Europe/Paris
- Europe/Berlin
- Asia/Tokyo
- Asia/Shanghai
- Asia/Kolkata
- Australia/Sydney
- UTC

**Auto-Detection:**
```javascript
const detectedTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
```

---

## Story Points

**3 points**

**Breakdown:**
- UI component (v0.dev + 6 settings): 1 point
- Task limit validation + auto-save: 0.5 point
- Timezone detection + dropdown: 1 point
- Database schema updates: 0.25 point
- Testing: 0.25 point

---

## Dependencies

- **Epic 2 Story 1.8** - Task limit setting exists in `user_settings` table
- **Story 10.1** - Settings page navigation exists

---

## Testing Checklist

### Unit Tests
- [ ] Task limit validation (< 5 shows error)
- [ ] Task limit validation (> 30 shows error)
- [ ] Task limit auto-saves on blur
- [ ] Timezone auto-detects from browser
- [ ] Timezone updates on dropdown change

### Integration Tests
- [ ] Preferences load current user settings
- [ ] Task limit update saves to database
- [ ] Timezone update saves to database
- [ ] Auto-save triggers toast notification
- [ ] Future settings (theme, language, digest) are grayed out

### E2E Tests (Playwright)
- [ ] Navigate to Settings → Preferences tab
- [ ] Task limit displays current value
- [ ] Change task limit to 10 → blur → auto-saves
- [ ] Change task limit to 40 → shows error toast
- [ ] Timezone dropdown shows auto-detected value
- [ ] Change timezone → auto-saves
- [ ] Theme dropdown is grayed out with tooltip
- [ ] Language dropdown is grayed out with tooltip
- [ ] Email digest dropdown is grayed out with tooltip

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

- **FR-PREF-01**: Preferences tab in settings
- **FR-PREF-02**: Task limit setting (consolidated from Epic 2 Story 1.8)
- **FR-PREF-03**: Theme setting (future-proofed)
- **FR-PREF-04**: Language setting (future-proofed)
- **FR-PREF-05**: Timezone setting
- **FR-PREF-06**: Email digest frequency (future-proofed)

---

## Notes

- Consolidates Epic 2 Story 1.8 (Task Limit) into unified preferences page
- Future settings (theme, language, digest) prepared but grayed out in MVP
- Timezone used for due date display and notification scheduling
- Auto-save on blur/change provides seamless UX (no save button needed)
- Consider adding "Reset to Defaults" button in future

---

## Related Files

- **Component:** `/src/components/AccountPreferences.tsx` (to be created)
- **Database:** `/supabase/migrations/[timestamp]_add_preferences.sql`
- **PRD:** `/docs/prd/newscopemissing.md` - Epic 10, Story 10.4
- **Epic Stories:** `/docs/prd/epic10_stories.md`
- **Epic 2 Story 1.8:** Task limit setting (to be consolidated)

---

**Last Updated:** 2025-10-07
**Assignee:** TBD
**Start Date:** TBD
**End Date:** TBD
