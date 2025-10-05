# Epic 1: Brief Creation and AI Task Generation

**Epic ID:** EPIC-01
**Status:** 🔴 Not Started
**Last Updated:** 2025-10-05

---

## Epic Goal

Enable managers to create briefs and generate AI task breakdowns with configurable limits, templates, and confirmation workflows.

---

## Metadata

| Attribute | Value |
|-----------|-------|
| **Timeline** | Week 1 (5 working days) |
| **Priority** | P0 (Must Have - Core MVP) |
| **Complexity** | High (AI integration, n8n workflows) |
| **Story Count** | 8 stories |
| **Story Points** | 41 points |
| **Epic Owner** | PM (John) |

---

## Functional Requirements Covered

**Primary FRs:** FR1-FR20
**Additional FRs:** FR68-FR70, FR82-FR84, FR95

**Total:** 28 FRs

### FR Breakdown:
- **FR1-FR5:** Basic brief creation form and validation
- **FR6-FR7:** AI task generation via n8n + OpenRouter
- **FR8-FR20:** Task confirmation, editing, deletion, finalization
- **FR68-FR70:** Configurable task limits, progressive disclosure, regeneration
- **FR82-FR84:** Draft saving, auto-title generation, task selection
- **FR95:** Brief templates (5 pre-built)

---

## Story Summary

| Story | Title | Points | Dependencies |
|-------|-------|--------|--------------|
| **1.1** | Basic Brief Creation Form | 5 | None |
| **1.2** | AI Task Breakdown via n8n | 13 | 1.1 |
| **1.3** | Progressive Task Confirmation | 5 | 1.2 |
| **1.4** | Inline Task Editing | 3 | 1.3 |
| **1.5** | Task Regeneration Limit | 3 | 1.2 |
| **1.6** | Draft Brief Saving | 3 | 1.1 |
| **1.7** | Brief Templates | 5 | 1.1 |
| **1.8** | Settings: Task Limit Configuration | 4 | 1.2 |

**Total:** 41 points across 8 stories

---

## User Journey

**Happy Path:**
1. Manager clicks "Create Brief" button
2. Dialog opens with title and description fields
3. Manager enters title: "Q1 2025 Marketing Campaign"
4. Manager enters description (500 words)
5. Character count shows "500/5000"
6. Manager clicks "Generate Tasks"
7. Loading indicator: "Generating tasks..."
8. AI generates 15 tasks in 30 seconds
9. Progressive disclosure: Shows 5 tasks at a time
10. Manager unchecks 2 tasks, clicks "Show More"
11. Reviews next 5 tasks, all look good
12. Clicks "Confirm Tasks"
13. Brief status → 'active', 13 tasks finalized
14. Dashboard now shows 1 active brief

---

## Success Criteria

**Product Metrics:**
- ✅ 90%+ of briefs successfully generate tasks on first try
- ✅ AI task generation completes in <60 seconds (95th percentile)
- ✅ <10% task regeneration rate (indicates good initial quality)
- ✅ 80%+ of users confirm ≥70% of AI-generated tasks

**Technical Metrics:**
- ✅ n8n workflow success rate >95%
- ✅ OpenRouter API response time <10 seconds
- ✅ Form validation prevents invalid submissions
- ✅ Database constraints enforced (title ≤200 chars, description ≤5000 chars)

**UX Metrics:**
- ✅ Brief creation flow completion rate >85%
- ✅ Average time to create first brief <5 minutes
- ✅ Progressive disclosure reduces cognitive load (user feedback)

---

## Dependencies

### External Dependencies:
- **n8n instance** running with webhook endpoints
- **OpenRouter API** account with GPT-4o-mini access
- **Supabase** database with briefs and tasks tables

### Internal Dependencies:
- **Supabase Auth** for user authentication (Epic 8)
- **Database schema** migration complete (see SETUP_GUIDE.md)

### Epic Dependencies:
- **None** - This is the foundation epic

---

## Technical Architecture

### Frontend Components:
1. **BriefCreationDialog** - shadcn/ui Dialog with form
2. **TaskConfirmationList** - Progressive disclosure UI
3. **TaskCard** - Individual task preview with checkbox
4. **BriefTemplateSelector** - Dropdown for templates

### n8n Workflows:
1. **Brief Task Breakdown** (`POST /webhook/generate-tasks`)
   - Input: `{ brief_id, user_id, jwt_token }`
   - Process: Fetch brief → Call OpenRouter → Parse response → Insert tasks
   - Output: `{ task_count, tasks[] }`

2. **AI Cost Estimation** (optional)
   - Calculate tokens and cost before generation

### Database Tables:
- `briefs` (extended with title, description, task_count)
- `tasks` (basic task structure)
- `user_settings` (default_task_limit)

---

## Risks & Mitigation

### Risk 1.1: AI Task Quality (High)
**Risk:** AI-generated tasks may be low quality, vague, or irrelevant

**Mitigation:**
- Story 1.3: Progressive confirmation allows manual review
- Story 1.4: Inline editing for quick fixes
- Story 1.5: Max 3 regeneration attempts to refine
- Prompt engineering: Provide clear AI instructions
- Fallback: Manual task creation always available

### Risk 1.2: OpenRouter API Latency (Medium)
**Risk:** Slow AI responses (>60 seconds) cause poor UX

**Mitigation:**
- Use GPT-4o-mini (fastest model)
- Show loading indicator with progress
- Timeout after 90 seconds with retry option
- Cache brief context to avoid re-sending

### Risk 1.3: Complex Briefs Exceed Token Limit (Low)
**Risk:** Very long descriptions (5000 chars) may exceed API limits

**Mitigation:**
- Truncate description to 3000 chars for AI call
- Warn user at 3000 char count
- Full description still saved in database

### Risk 1.4: User Overwhelm (Medium)
**Risk:** 20 tasks at once may overwhelm managers

**Mitigation:**
- Story 1.3: Progressive disclosure (5 at a time)
- Story 1.8: Configurable task limit (default 20, range 5-50)
- Visual design: Clean, minimal UI

---

## Testing Strategy

### Unit Tests:
- Form validation (title length, description length, required fields)
- Character count accuracy
- Task checkbox state management
- Progressive disclosure logic (show 5, then 10, then 15, etc.)

### Integration Tests:
- n8n workflow end-to-end (webhook → AI → database)
- Brief creation → task generation → confirmation flow
- Draft saving and resuming
- Template application

### E2E Tests (Playwright):
- Complete brief creation happy path
- Task regeneration with different limits
- Template selection and usage
- Error handling (API timeout, invalid input)

---

## Acceptance Criteria (Epic Level)

**Epic is complete when:**
- [ ] All 8 stories are completed and tested
- [ ] Manager can create brief from scratch in <5 minutes
- [ ] AI generates relevant tasks in <60 seconds
- [ ] Progressive confirmation works smoothly
- [ ] Task regeneration produces improved results
- [ ] Draft saving prevents data loss
- [ ] 5 templates are available and working
- [ ] Settings allow task limit configuration (5-50)
- [ ] n8n workflow is stable with >95% success rate
- [ ] All FRs (FR1-FR20, FR68-FR70, FR82-FR84, FR95) are implemented

---

## Definition of Done

- [ ] All acceptance criteria met for all 8 stories
- [ ] Unit tests written and passing
- [ ] Integration tests written and passing
- [ ] E2E tests written and passing (Playwright)
- [ ] n8n workflow deployed and tested
- [ ] Database migration applied
- [ ] Frontend components deployed to Vercel
- [ ] Documentation updated (README, API docs)
- [ ] Code reviewed and merged
- [ ] Epic demo conducted with stakeholders
- [ ] Metrics dashboard tracking key success criteria

---

## Related Documentation

- **PRD Section:** `/docs/prd/CONSOLIDATED_PRD.md` Section 4.1 (Epic 1 FRs)
- **PRD Section 5:** `/docs/prd/prd_section5.md` Section 5.3 (Epic 1 Stories)
- **Database Schema:** `/docs/prd/CONSOLIDATED_PRD.md` Section 5.2
- **n8n Workflows:** `/docs/n8n-workflows/` (to be created)
- **Stories:** `/backlog/stories/epic-01/`

---

## Notes

- This epic is the foundation for the entire MVP - must be rock solid
- AI quality is critical - invest time in prompt engineering
- Progressive disclosure is key to managing cognitive load
- Consider adding "AI task quality score" in post-MVP for feedback loop

---

**Epic Status Tracker:**

| Story | Status | Assignee | Start Date | End Date |
|-------|--------|----------|------------|----------|
| 1.1 | ⬜ To Do | - | - | - |
| 1.2 | ⬜ To Do | - | - | - |
| 1.3 | ⬜ To Do | - | - | - |
| 1.4 | ⬜ To Do | - | - | - |
| 1.5 | ⬜ To Do | - | - | - |
| 1.6 | ⬜ To Do | - | - | - |
| 1.7 | ⬜ To Do | - | - | - |
| 1.8 | ⬜ To Do | - | - | - |

---

**Last Updated:** 2025-10-05
**Next Review:** After Story 1.1 completion
