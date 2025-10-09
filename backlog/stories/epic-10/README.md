# Epic 10 Stories: User Settings & Profile Management

**Epic Goal:** Unified settings hub for profile management, notification preferences, help resources, and account customization

**Total Stories:** 4
**Total Story Points:** 19
**Timeline:** Week 2 (Stories 10.1-10.2) + Week 5 (Stories 10.3-10.4)

---

## Story List

| ID | Story | Points | Status | Dependencies |
|----|-------|--------|--------|--------------|
| **10.1** | [Profile Management](story-10.1-profile-management.md) | 5 | ⬜ To Do | Epic 8 |
| **10.2** | [Notification Settings (Email + In-App)](story-10.2-notification-settings.md) | 8 | ⬜ To Do | 10.1, Epic 5 |
| **10.3** | [Help & Support Integration](story-10.3-help-support.md) | 3 | ⬜ To Do | 10.1, Epic 2.10 |
| **10.4** | [Account Preferences Consolidation](story-10.4-account-preferences.md) | 3 | ⬜ To Do | 10.1, Epic 2.1.8 |

---

## Execution Order

### Phase 1: Core Settings (Week 2, Days 1-3)
1. Story 10.1 - Profile Management (5 points)
2. Story 10.2 - Notification Settings (8 points)

### Phase 2: Supporting Features (Week 5, Days 1-2)
3. Story 10.3 - Help & Support Integration (3 points)
4. Story 10.4 - Account Preferences Consolidation (3 points)

---

## Critical Path

```
Story 10.1 (Profile) ← Foundation: Settings page structure
    ↓
Story 10.2 (Notifications) ← Critical: 8 notification types × 2 channels
    ↓
Story 10.3 (Help) + 10.4 (Preferences) ← Can run in parallel
```

**Parallel Work:**
- Story 10.3 (Help) and 10.4 (Preferences) can run simultaneously in Week 5

**Integration Points:**
- Story 10.2 depends on Epic 5 (notification system must exist)
- Story 10.3 reuses Epic 2 Story 2.10 (onboarding modal)
- Story 10.4 consolidates Epic 2 Story 1.8 (task limit setting)

---

## FRs Covered

**Total:** 24 Functional Requirements

- **FR-PROF-01 to FR-PROF-05:** Profile Management (Story 10.1)
- **FR-NOTIF-01 to FR-NOTIF-07:** Notification Settings (Story 10.2)
- **FR-HELP-01 to FR-HELP-05:** Help & Support (Story 10.3)
- **FR-PREF-01 to FR-PREF-06:** Account Preferences (Story 10.4)

---

## Key Success Metrics

- ✅ 80%+ of users complete profile setup within first session
- ✅ Notification settings reduce unwanted emails by 60%
- ✅ Help resources reduce support tickets by 40%
- ✅ Profile avatar upload success rate >95%
- ✅ Settings auto-save without errors 99%+ of the time

---

## Technical Stack

**Frontend:**
- React + TypeScript
- shadcn/ui (Tabs, Card, Switch, Input, Select, Avatar, Accordion)
- TanStack Query for settings CRUD
- Supabase Storage for avatar uploads

**Backend:**
- Supabase (profiles, user_settings, user_brief_mutes tables)
- n8n workflows (notification settings integration)

**Testing:**
- Unit tests (Vitest) - Validation, auto-save logic
- Integration tests (Supabase client) - Settings persistence, RLS policies
- E2E tests (Playwright) - Settings navigation, form interactions

---

## Integration Points

### Epic Dependencies
- **Epic 2 Story 1.8:** Task limit setting (consolidated into Story 10.4)
- **Epic 2 Story 2.10:** Onboarding modal (reused in Story 10.3)
- **Epic 5:** Notification system (Stories 5.1-5.3) - n8n workflows updated in Story 10.2
- **Epic 8:** User authentication and profiles table
- **Epic 9:** Dashboard reminders respect notification settings (Story 10.2)

### Data Flow
```
User Settings (Supabase)
    ↓
TanStack Query (auto-save)
    ↓
Settings Components (10.1-10.4)
    ↓
n8n Workflows (notification checks)
```

---

## Notification Settings Architecture (Story 10.2)

**Total Settings:** 20 toggles + 2 time pickers + per-brief mutes

**Master Toggles:**
- Email Notifications (ON/OFF)
- In-App Notifications (ON/OFF)

**8 Notification Types × 2 Channels = 16 Toggles:**
1. Task Assigned (email + in-app)
2. Output Submitted (email + in-app)
3. Task Accepted (email + in-app)
4. Task Rejected (email + in-app)
5. @Mention in Comments (email + in-app)
6. AI Tasks Completed (email + in-app)
7. Overdue Task Reminder (email + in-app)
8. Queued AI Tasks Reminder (email + in-app)

**Do Not Disturb (DND):**
- Start Hour (default: 9 PM)
- End Hour (default: 9 AM)

**Per-Brief Muting:**
- Mute/unmute individual briefs (affects all notification types)

---

## Settings Tab Structure

**Tab 1: Profile** (Story 10.1)
- Name, Avatar, Role, Bio

**Tab 2: Notifications** (Story 10.2)
- Master toggles (email, in-app)
- 16 granular toggles (8 types × 2 channels)
- DND hours
- Per-brief mutes

**Tab 3: Help** (Story 10.3)
- Quick Start Guide
- Video Tutorials
- FAQs
- Contact Support
- Restart Onboarding

**Tab 4: Preferences** (Story 10.4)
- Task Limit (5-30, default 15)
- Timezone
- Theme (future)
- Language (future)
- Email Digest (future)

---

## Getting Started

1. Ensure Epic 8 (authentication) is complete
2. Ensure Epic 5 (notification system) is working
3. Start with Story 10.1 (profile management)
4. Complete Story 10.2 (notification settings) - critical for Epic 9
5. Implement Stories 10.3 and 10.4 in parallel (Week 5)
6. Epic review after all 4 stories complete

---

## Notes

- Story 10.2 is **P0 (Must Have)** - notification control is critical for user satisfaction
- Avatar uploads use Supabase Storage (2MB limit)
- All settings auto-save on blur/change (no save button needed, except Story 10.2)
- Future-proof settings (theme, language, digest) prepared but grayed out in MVP
- Help documentation can use placeholders initially (external docs site post-MVP)
- Settings page accessible from user menu in navigation

---

**Last Updated:** 2025-10-07
