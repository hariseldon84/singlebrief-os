# Epic 2: Task Management and Assignment

**Epic ID:** EPIC-02
**Status:** 🔴 Not Started
**Last Updated:** 2025-10-05

---

## Epic Goal

Enable task assignment, status tracking, and team member task execution with "My Tasks" inbox, bulk operations, and quick-add functionality.

---

## Metadata

| Attribute | Value |
|-----------|-------|
| **Timeline** | Week 2 (5 working days) |
| **Priority** | P0 (Must Have - Core MVP) |
| **Complexity** | Medium (database, RLS policies, team member UI) |
| **Story Count** | 10 stories |
| **Story Points** | 40 points |
| **Epic Owner** | Engineering Lead (Sarah) |

---

## Functional Requirements Covered

**Primary FRs:** FR21-FR38
**Additional FRs:** FR54-FR61, FR79-FR81, FR94, FR99-FR100

**Total:** 30 FRs

### FR Breakdown:
- **FR21-FR27:** Task assignment and status management
- **FR28-FR31:** Task UI (cards, sorting, detail view)
- **FR32-FR38:** Notifications, reassignment, bulk actions, deletion
- **FR54-FR61:** Team member "My Tasks" inbox, due dates, progress tracking
- **FR79-FR81:** Priority system (High/Medium/Low)
- **FR94:** Quick-add task functionality
- **FR99-FR100:** Onboarding flow

---

## Story Summary

| Story | Title | Points | Dependencies |
|-------|-------|--------|--------------|
| **2.1** | Task Assignment Dropdown | 5 | Epic 1 |
| **2.2** | Task Status Management | 3 | 2.1 |
| **2.3** | Task Detail View | 5 | 2.1 |
| **2.4** | "My Tasks" Inbox | 5 | 2.3 |
| **2.5** | Task Due Dates & Progress Tracking | 4 | 2.3 |
| **2.6** | Task Priority System | 3 | 2.1 |
| **2.7** | Quick-Add Task | 3 | Epic 1 |
| **2.8** | Bulk Task Actions | 5 | 2.1 |
| **2.9** | Task Deletion with Soft Delete | 3 | 2.1 |
| **2.10** | Onboarding Welcome Modal | 4 | 2.4 |

**Total:** 40 points across 10 stories

---

## Success Criteria

**Product Metrics:**
- ✅ 90%+ of tasks successfully assigned without errors
- ✅ Team members complete task status updates within 24 hours
- ✅ "My Tasks" inbox used by 80%+ of team members daily
- ✅ Bulk actions reduce time to assign 10+ tasks by 70%

**Technical Metrics:**
- ✅ RLS policies prevent unauthorized task access
- ✅ Task assignment triggers email notification within 30 seconds
- ✅ Soft delete allows recovery within 30 days
- ✅ Database queries for "My Tasks" <50ms

---

## Dependencies

### External Dependencies:
- **Supabase Auth** for user management
- **n8n email workflow** for assignment notifications

### Internal Dependencies:
- **Epic 1** must be complete (briefs and tasks exist)
- **Epic 8** (Auth) running in parallel for team member invites

---

## Risks & Mitigation

### Risk 2.1: Multi-Assignee Complexity (Resolved)
**Risk:** Users expect multiple assignees per task
**Mitigation:** MVP uses single assignee + task duplication workaround (FR36)

### Risk 2.2: Email Notification Delays (Medium)
**Risk:** Email notifications delayed >5 minutes cause confusion
**Mitigation:** n8n workflow with <30 second SLA, fallback to in-app notifications

---

## Related Documentation

- **PRD Section:** `/docs/prd/CONSOLIDATED_PRD.md` Section 4.1 (Epic 2 FRs)
- **PRD Section 5:** `/docs/prd/prd_section5.md` Section 5.4
- **Stories:** `/backlog/stories/epic-02/`

---

**Last Updated:** 2025-10-05
