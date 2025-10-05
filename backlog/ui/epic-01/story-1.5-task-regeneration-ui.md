# UI/UX Specification: Story 1.5 - Task Regeneration

**Story ID:** STORY-1.5
**Feature:** Regenerate AI Tasks for Brief
**Design System:** shadcn/ui + Tailwind CSS

---

## 1. Screen Overview

**Purpose:** Allow managers to request new AI-generated tasks if initial suggestions don't meet expectations.

**User Flow:**
- Review AI tasks
- Click "Regenerate Tasks" button
- Confirmation dialog appears
- New tasks generated (30s)
- Replace old tasks

**Success Criteria:**
- Clear warning about losing current selection
- Transparent AI generation process
- Easy to retry if unsatisfied

---

## 2. Component Specifications

### Regenerate Button
- **Component:** `<Button>` variant="outline"
- **Icon:** Refresh/Reload icon (rotating)
- **Text:** "Regenerate Tasks"
- **Position:** Above task list, next to "Confirm Tasks"
- **Loading State:** Spinner + "Regenerating..."

### Confirmation Dialog
```
┌─────────────────────────────────────┐
│  Regenerate Tasks?          [X]     │
├─────────────────────────────────────┤
│                                     │
│  ⚠️  This will replace all current │
│  tasks with new AI suggestions.    │
│                                     │
│  Your selections will be lost.     │
│                                     │
│  ┌──────────┐  ┌────────────────┐ │
│  │ Cancel   │  │ Regenerate     │ │
│  └──────────┘  └────────────────┘ │
└─────────────────────────────────────┘
```

- **Component:** `<AlertDialog>` (shadcn/ui)
- **Width:** 400px
- **Icon:** Warning icon (orange/yellow)
- **Primary Action:** "Regenerate" (destructive variant)
- **Secondary Action:** "Cancel" (ghost variant)

### Loading State
- **Skeleton:** Same as initial generation
- **Text:** "Regenerating tasks... (this may take 30 seconds)"
- **Progress:** Optional animated dots
- **Background:** Previous tasks fade to 20% opacity

---

## 3. Interaction Patterns

### Click "Regenerate"
1. Show confirmation dialog
2. If user clicks "Cancel" → close dialog, no action
3. If user clicks "Regenerate":
   - Close dialog
   - Fade out current tasks (300ms)
   - Show loading skeleton
   - Call n8n workflow (30s)
   - Fade in new tasks (300ms)
   - All new tasks checked by default
   - Reset selection counter

### Error Handling
- **API Error:** Toast notification "Failed to regenerate tasks. Try again."
- **Timeout (> 60s):** "Taking longer than expected. Continue waiting?"
- **Network Error:** "Connection lost. Retry when online."

### Cancel During Generation
- **Option:** "Cancel" button during loading
- **Action:** Stop API call if possible, show error message
- **Fallback:** Restore previous tasks if available

---

## 4. Accessibility

**Keyboard:**
- Tab to "Regenerate" button
- Enter/Space to trigger
- Focus moves to dialog
- Escape to cancel dialog

**Screen Reader:**
```html
<button aria-label="Regenerate all tasks">
  <RefreshIcon aria-hidden="true" />
  Regenerate Tasks
</button>
<div role="alertdialog" aria-labelledby="dialog-title" aria-describedby="dialog-desc">
  <h2 id="dialog-title">Regenerate Tasks?</h2>
  <p id="dialog-desc">This will replace all current tasks...</p>
</div>
```

---

## 5. v0.dev Prompt

```
Create a task regeneration component with confirmation dialog.

Requirements:
- "Regenerate Tasks" button (outline, refresh icon)
- Confirmation dialog (AlertDialog): "This will replace all current tasks. Your selections will be lost."
- Warning icon in dialog
- "Cancel" and "Regenerate" buttons (destructive variant)
- Loading state: Skeleton with "Regenerating tasks..." message
- Error handling with toast notifications
- Fade transitions for task replacement (300ms)
- Accessible (ARIA, keyboard navigation, focus management)

Use shadcn/ui AlertDialog, Button, Tailwind CSS.
```

---

## AI Generation Prompts

### v0.dev / Lovable
```
[Copy the feature description from above and use shadcn/ui components with React + TypeScript + Tailwind CSS]
```

### Figma AI
```
[Design the screens with proper spacing, typography, and component states as specified above]
```

### Visily.ai / Uizard
```
[Create wireframes following the layout structure and component specifications detailed above]
```

**Note:** Refer to sections 1-10 above for complete specifications including layout, components, interactions, states, responsive behavior, and accessibility requirements.
