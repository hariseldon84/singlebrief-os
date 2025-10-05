# Epic 1 Stories: Brief Creation and AI Task Generation

**Epic Goal:** Enable managers to create briefs and generate AI task breakdowns

**Total Stories:** 8
**Total Story Points:** 41
**Timeline:** Week 1 (5 working days)

---

## Story List

| ID | Story | Points | Status | Dependencies |
|----|-------|--------|--------|--------------|
| **1.1** | [Basic Brief Creation Form](story-1.1-basic-brief-creation.md) | 5 | ⬜ To Do | None |
| **1.2** | [AI Task Breakdown via n8n](story-1.2-ai-task-breakdown.md) | 13 | ⬜ To Do | 1.1 |
| **1.3** | [Progressive Task Confirmation](story-1.3-progressive-confirmation.md) | 5 | ⬜ To Do | 1.2 |
| **1.4** | [Inline Task Editing](story-1.4-inline-task-editing.md) | 3 | ⬜ To Do | 1.3 |
| **1.5** | [Task Regeneration Limit](story-1.5-task-regeneration.md) | 3 | ⬜ To Do | 1.2 |
| **1.6** | [Draft Brief Saving](story-1.6-draft-saving.md) | 3 | ⬜ To Do | 1.1 |
| **1.7** | [Brief Templates](story-1.7-brief-templates.md) | 5 | ⬜ To Do | 1.1 |
| **1.8** | [Task Limit Configuration](story-1.8-task-limit-settings.md) | 4 | ⬜ To Do | 1.2 |

---

## Execution Order

### Phase 1: Foundation (Days 1-2)
1. Story 1.1 - Basic Brief Creation Form
2. Story 1.2 - AI Task Breakdown via n8n

### Phase 2: Confirmation Flow (Days 2-3)
3. Story 1.3 - Progressive Task Confirmation
4. Story 1.4 - Inline Task Editing
5. Story 1.5 - Task Regeneration Limit

### Phase 3: Enhancements (Days 4-5)
6. Story 1.6 - Draft Brief Saving
7. Story 1.7 - Brief Templates
8. Story 1.8 - Task Limit Configuration

---

## Critical Path

```
Story 1.1 (Brief Form)
    ↓
Story 1.2 (AI Generation) ← Critical: Must work reliably
    ↓
Story 1.3 (Confirmation) ← Critical: Reduces cognitive load
```

**Parallel Work:**
- Story 1.6 (Drafts) can run parallel with 1.3-1.5
- Story 1.7 (Templates) can run parallel with 1.3-1.5

---

## FRs Covered

**Total:** 28 Functional Requirements

- FR1-FR5: Basic form
- FR6-FR7: AI generation
- FR9-FR20: Task confirmation, editing, finalization
- FR68-FR70: Settings, progressive disclosure, regeneration
- FR82-FR84: Draft saving, auto-title, task selection
- FR95: Templates

---

## Key Success Metrics

- ✅ 90%+ of briefs generate tasks successfully on first try
- ✅ AI task generation <60 seconds (95th percentile)
- ✅ <10% task regeneration rate
- ✅ 80%+ of users confirm ≥70% of AI tasks
- ✅ Brief creation flow completion rate >85%

---

## Technical Stack

**Frontend:**
- React + TypeScript
- shadcn/ui (Dialog, Input, Textarea, Button)
- TanStack Query for API calls

**Backend:**
- n8n workflow (`/webhook/generate-tasks`)
- OpenRouter API (GPT-4o-mini)
- Supabase (briefs, tasks, user_settings tables)

**Testing:**
- Unit tests (Vitest)
- Integration tests (Supabase client)
- E2E tests (Playwright)

---

## Getting Started

1. Ensure dev environment is set up (see `/docs/SETUP_GUIDE.md`)
2. Start with Story 1.1 (foundational)
3. Complete stories in dependency order
4. Test each story before moving to next
5. Epic review after Story 1.8 completion

---

**Last Updated:** 2025-10-05
