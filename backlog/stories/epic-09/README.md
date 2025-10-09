# Epic 9 Stories: Manager Command Center (Dashboard)

**Epic Goal:** Centralized action hub for managers to see visual cues, take immediate action, and track team progress

**Total Stories:** 4
**Total Story Points:** 24
**Timeline:** Week 4 (5 working days, parallel with Epic 6)

---

## Story List

| ID | Story | Points | Status | Dependencies |
|----|-------|--------|--------|--------------|
| **9.1** | [Manager Action Center Widget](story-9.1-manager-action-center.md) | 8 | ⬜ To Do | Epics 1-5 |
| **9.2** | [Summary Analytics Dashboard](story-9.2-summary-analytics.md) | 5 | ⬜ To Do | Epics 1, 2, 4 |
| **9.3** | [Periodic Reminder System](story-9.3-periodic-reminder-system.md) | 6 | ⬜ To Do | 9.1, Epic 10 |
| **9.4** | [Team Member Dashboard View](story-9.4-team-member-dashboard.md) | 5 | ⬜ To Do | 9.1, Epic 8 |

---

## Execution Order

### Phase 1: Foundation (Days 1-2)
1. Story 9.1 - Manager Action Center Widget (8 points)
2. Story 9.2 - Summary Analytics Dashboard (5 points)

### Phase 2: Enhancements (Days 3-4)
3. Story 9.4 - Team Member Dashboard View (5 points)
4. Story 9.3 - Periodic Reminder System (6 points)

---

## Critical Path

```
Story 9.1 (Action Center) ← Critical: Foundation for all dashboard features
    ↓
Story 9.2 (Analytics) ← Can run parallel with 9.4
    ↓
Story 9.4 (Team Member View) ← Reuses 9.1 logic
    ↓
Story 9.3 (Reminders) ← Depends on 9.1 queries + Epic 10 settings
```

**Parallel Work:**
- Story 9.2 (Analytics) can run parallel with 9.4 (Team Member View)
- Story 9.3 (Reminders) should wait for Epic 10 Story 10.2 (Notification Settings)

---

## FRs Covered

**Total:** 21 Functional Requirements (FR-DASH-01 to FR-DASH-21)

- **FR-DASH-01 to FR-DASH-04:** Manager Action Center (Story 9.1)
- **FR-DASH-05 to FR-DASH-11:** Summary Analytics (Story 9.2)
- **FR-DASH-12 to FR-DASH-17:** Periodic Reminders (Story 9.3)
- **FR-DASH-18 to FR-DASH-21:** Team Member Dashboard (Story 9.4)

---

## Key Success Metrics

- ✅ 90%+ of managers check dashboard daily
- ✅ Action center loads in <500ms
- ✅ Analytics refresh every 5 minutes without performance impact
- ✅ Reminder banner reduces missed actions by 70%
- ✅ Team members complete 80%+ of tasks shown on dashboard

---

## Technical Stack

**Frontend:**
- React + TypeScript
- shadcn/ui (Card, Badge, Button, Alert, ScrollArea)
- TanStack Query for polling (30s action center, 5min analytics)

**Backend:**
- n8n workflow (periodic reminder checks every 30 minutes)
- Supabase (tasks, briefs, profiles, user_settings tables)

**Testing:**
- Unit tests (Vitest) - Query logic, calculations
- Integration tests (Supabase client) - Polling, RLS policies
- E2E tests (Playwright) - Dashboard rendering, navigation

---

## Integration Points

### Epic Dependencies
- **Epic 1:** Briefs table (for action center queries)
- **Epic 2:** Tasks table with status, due_date, assigned_to
- **Epic 3:** FAB confirmation dialog (for AI task execution)
- **Epic 4:** Brief review tab (for navigation), task acceptance workflow
- **Epic 5:** 30-second polling pattern, notification system
- **Epic 6:** Dashboard navigation (parallel implementation in Week 4)
- **Epic 8:** User authentication, profiles with role field
- **Epic 10:** Notification settings (DND hours, in-app toggles)

### Data Flow
```
Tasks/Briefs (Supabase)
    ↓
TanStack Query (polling)
    ↓
Dashboard Components (9.1-9.4)
    ↓
Navigation Actions (Epic 3, 4, 6)
```

---

## Getting Started

1. Ensure Epics 1-5 are complete (dashboard needs task/brief data)
2. Verify Epic 8 authentication working (role detection)
3. Start with Story 9.1 (action center is foundation)
4. Implement 9.2 and 9.4 in parallel
5. Complete Story 9.3 after Epic 10 Story 10.2 is ready
6. Epic review after all 4 stories complete

---

## Notes

- Dashboard is **P0 (Must Have)** - critical for manager confidence
- Keep queries performant (<500ms for action center, <1s for analytics)
- Polling intervals: 30s (action center), 5min (analytics), 30min (n8n reminders)
- Team member dashboard ensures non-managers have value too
- Consider caching analytics to reduce database load

---

**Last Updated:** 2025-10-07
