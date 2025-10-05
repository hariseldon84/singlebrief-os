# Story 1.1: Basic Brief Creation Form

**Story ID:** STORY-1.1
**Epic:** Epic 1 - Brief Creation and AI Task Generation
**Status:** ⬜ To Do
**Last Updated:** 2025-10-05

---

## User Story

**As a** manager
**I want to** create a new brief by entering a title and description
**So that** I can initiate a project and get AI-generated tasks

---

## Acceptance Criteria

- [ ] Brief creation dialog opens when clicking "New Brief" button (FR1)
- [ ] Form has title field (required, max 200 chars) (FR2)
- [ ] Form has description textarea (required, max 5000 chars, ~1500 words) (FR2)
- [ ] Character count shown below textarea (FR3)
- [ ] Character count turns orange at 3000 chars with warning message (FR4)
- [ ] "Generate Tasks" button is disabled until title and description are filled (FR5)
- [ ] Form validates inputs before submission
- [ ] Brief saved to Supabase with status='draft'
- [ ] Error handling for failed submissions

---

## Technical Implementation

### Frontend (v0.dev + Claude Code)

**Component:** `BriefCreationDialog.tsx`

**v0.dev Prompt:**
```
Create a brief creation dialog with shadcn/ui components:
- Dialog component with "New Brief" trigger button
- Input field for title (max 200 chars)
- Textarea for description (max 5000 chars)
- Character counter below textarea
- "Generate Tasks" button (disabled state)
- Form validation
- Use Tailwind CSS for styling
```

**Claude Code Integration:**
```typescript
// Add Supabase integration
import { supabase } from "@/integrations/supabase/client";

const handleCreateBrief = async () => {
  const { data, error } = await supabase
    .from('briefs')
    .insert({
      title,
      description,
      status: 'draft',
      created_by: user.id
    })
    .select()
    .single();

  if (error) throw error;
  return data;
};
```

### Database Schema

```sql
-- Already exists from migration, verify fields:
ALTER TABLE briefs ADD COLUMN IF NOT EXISTS title TEXT CHECK (length(title) <= 200);
ALTER TABLE briefs ADD COLUMN IF NOT EXISTS description TEXT CHECK (length(description) <= 5000);
```

### Validation Rules

**Title:**
- Required
- 1-200 characters
- No HTML allowed
- Trim whitespace

**Description:**
- Required
- 10-5000 characters
- Warning at 3000 characters
- Rich text not supported in MVP

---

## Story Points

**5 points**

**Breakdown:**
- UI component (v0.dev): 1 point
- Form validation: 1 point
- Supabase integration: 1 point
- Character count logic: 1 point
- Error handling + testing: 1 point

---

## Dependencies

- **None** - This is the first story
- Supabase project must be set up (SETUP_GUIDE.md)
- User authentication working (Epic 8 - can run in parallel)

---

## Testing Checklist

### Unit Tests
- [ ] Title validation (empty, too long, valid)
- [ ] Description validation (empty, too long, too short, valid)
- [ ] Character count updates correctly
- [ ] Warning shows at 3000 chars
- [ ] Button disabled when fields invalid

### Integration Tests
- [ ] Brief saves to Supabase correctly
- [ ] Status set to 'draft'
- [ ] User ID captured
- [ ] Timestamps auto-generated

### E2E Tests (Playwright)
- [ ] Click "New Brief" → dialog opens
- [ ] Enter valid title and description
- [ ] Character count updates in real-time
- [ ] Warning appears at 3000 chars
- [ ] Submit brief successfully
- [ ] Brief appears in dashboard

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

- FR1: System shall provide "New Brief" button in dashboard
- FR2: Brief creation dialog shall have title (required, max 200 chars) and description (required, max 5000 chars)
- FR3: System shall show character count below description textarea
- FR4: System shall warn user at 3000 chars with color change
- FR5: System shall disable "Generate Tasks" button until title and description filled

---

## Notes

- Keep UI simple and clean - this is the entry point for the entire app
- Character count should update on every keystroke (debounced if performance issue)
- Consider adding "Save Draft" button in future iteration
- HTML/markdown support deferred to post-MVP

---

## Related Files

- **Component:** `/src/components/BriefCreationDialog.tsx` (to be created)
- **Database:** `/supabase/migrations/20251005065641_complete_singlebrief_schema.sql`
- **PRD:** `/docs/prd/CONSOLIDATED_PRD.md` Section 4.1 (FR1-FR5)

---

**Last Updated:** 2025-10-05
**Assignee:** TBD
**Start Date:** TBD
**End Date:** TBD
