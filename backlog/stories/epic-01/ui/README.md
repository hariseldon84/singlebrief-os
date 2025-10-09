# Epic 1: Brief Creation & AI Task Generation - UI Specifications

**Epic Overview:** Brief creation flow with AI-powered task breakdown

**Total Stories:** 8 stories
**UI Specifications Required:** All stories need UI specs

---

## Global References

**Before reviewing these UI specifications, familiarize yourself with:**

1. **Global Navigation Structure:** `docs/ui/global-navigation-structure.md`
   - Application-wide navigation patterns
   - Information architecture
   - Page hierarchy

2. **Global Layout Specification:** `docs/ui/global-layout-specification.md`
   - Reusable page templates
   - Component specifications
   - Header, sidebar, footer standards

---

## UI Specifications Index

### Story 1.1: Basic Brief Creation
**File:** `ui-1.1-basic-brief-creation.md`
**Page Type:** Modal Dialog (Create Brief)
**Key Components:** Form with title, description, task limit
**Layout Template:** Template 5 (Modal/Dialog Layout)

### Story 1.2: AI Task Breakdown
**File:** `ui-1.2-ai-task-breakdown.md`
**Page Type:** In-modal workflow (continued from 1.1)
**Key Components:** Loading state, generated task list, progressive disclosure
**Layout Template:** Template 5 (Modal/Dialog Layout)

### Story 1.3: Progressive Confirmation
**File:** `ui-1.3-progressive-confirmation.md`
**Page Type:** In-modal interaction pattern
**Key Components:** Task checkboxes, "Show More" button, confirmation flow
**Layout Template:** Template 5 (Modal/Dialog Layout)

### Story 1.4: Inline Task Editing
**File:** `ui-1.4-inline-task-editing.md`
**Page Type:** In-modal editing interface
**Key Components:** Inline edit mode, save/cancel actions
**Layout Template:** Template 5 (Modal/Dialog Layout)

### Story 1.5: Task Regeneration
**File:** `ui-1.5-task-regeneration.md`
**Page Type:** In-modal action flow
**Key Components:** Regenerate button, loading state, re-confirmation
**Layout Template:** Template 5 (Modal/Dialog Layout)

### Story 1.6: Draft Saving
**File:** `ui-1.6-draft-saving.md`
**Page Type:** Auto-save indicator + manual save
**Key Components:** Save indicator, toast notifications
**Layout Template:** Template 5 (Modal/Dialog Layout)

### Story 1.7: Brief Templates
**File:** `ui-1.7-brief-templates.md`
**Page Type:** Template selection screen (pre-form)
**Key Components:** Template gallery, preview cards, selection flow
**Layout Template:** Template 5 (Modal/Dialog Layout) or dedicated template selector

### Story 1.8: Task Limit Settings
**File:** `ui-1.8-task-limit-settings.md`
**Page Type:** Settings page integration
**Key Components:** Slider component, real-time preview
**Layout Template:** Template 4 (Form Page Layout)

---

## Epic-Level UI Considerations

### Workflow Continuity
All Story 1.1-1.6 specs form a **single continuous modal workflow**:
1. User clicks "+ New Brief" FAB
2. Modal opens → Story 1.1 (form)
3. Click "Generate Tasks" → Story 1.2 (AI generation)
4. Tasks appear → Stories 1.3-1.5 (interaction)
5. Auto-save throughout → Story 1.6
6. Click "Confirm Tasks" → Modal closes, navigate to Brief Detail

**Template Selection (Story 1.7):**
- Optional pre-step before Story 1.1
- If user selects template, pre-fills form in Story 1.1

### Key UI Patterns
- **Modal Size:** 800px width (large modal for multi-step workflow)
- **Progressive Disclosure:** Show 5 tasks at a time (Story 1.3)
- **Inline Editing:** Click task title to edit (Story 1.4)
- **Loading States:** Skeleton loaders during AI generation (Story 1.2)
- **Auto-Save:** Visual indicator in modal header (Story 1.6)

### Responsive Behavior
- **Desktop:** Full 800px modal
- **Tablet:** 90% viewport width, scrollable
- **Mobile:** Full-screen modal with header, scrollable content

---

## Design Deliverables Needed

For Figma handoff, each UI spec should include:

1. **Full Page Mockup:**
   - Complete layout with global header, sidebar, footer
   - Modal overlays properly positioned
   - Correct spacing and typography

2. **Component States:**
   - Default, hover, active, disabled, error states
   - Loading states (skeletons, spinners)
   - Empty states

3. **Responsive Views:**
   - Desktop (1280px)
   - Tablet (768px)
   - Mobile (375px)

4. **Interactive Elements:**
   - Button styles and states
   - Form field styles (default, focus, error, disabled)
   - Modal behavior (open/close, backdrop)

5. **Accessibility Annotations:**
   - Focus order
   - ARIA labels
   - Keyboard shortcuts
   - Screen reader text

---

## Next Steps

1. Create individual UI spec files for each story
2. Reference global templates for consistent layouts
3. Include full-page context (header, sidebar, footer, navigation state)
4. Specify exact component usage from shadcn/ui library
5. Document responsive behavior for each screen
6. Add accessibility requirements
7. Create Figma mockups based on specs

---

**Status:** UI specifications in progress
**Last Updated:** 2025-10-07
