# UI/UX Specification: Story 1.4 - Inline Task Editing

**Story ID:** STORY-1.4
**Feature:** Inline Editing of AI-Generated Tasks
**Design System:** shadcn/ui + Tailwind CSS

---

## 1. Screen Overview

**Purpose:** Allow managers to refine AI-generated tasks before confirmation, editing title and description inline.

**User Flow:**
- Task card in review mode
- Click "Edit" icon → Inline editor appears
- Edit title/description → Save or Cancel
- Changes persist in selection

**Success Criteria:**
- Quick, non-modal editing experience
- Clear save/cancel actions
- No page refresh needed

---

## 2. Component Specifications

### Task Card with Edit Mode

**Default Mode:**
```
┌───────────────────────────────────┐
│ ☑  Research audience demographics │ [✏️ Edit]
│    Analyze current customer...    │
└───────────────────────────────────┘
```

**Edit Mode:**
```
┌───────────────────────────────────┐
│ ☑  ┌──────────────────────────┐  │
│    │ Research audience...      │  │
│    └──────────────────────────┘  │
│    ┌──────────────────────────┐  │
│    │ Analyze current customer │  │
│    │ data and identify...     │  │
│    └──────────────────────────┘  │
│    [Cancel] [Save Changes]       │
└───────────────────────────────────┘
```

### Edit Button
- **Icon:** Pencil/Edit icon
- **Size:** 16px icon button
- **Position:** Top-right of task card
- **Hover:** Gray background circle
- **Tooltip:** "Edit task"

### Inline Input Fields
**Title Input:**
- **Component:** `<Input>` (shadcn/ui)
- **Max Length:** 100 characters
- **Validation:** Required, min 5 chars

**Description Textarea:**
- **Component:** `<Textarea>` (shadcn/ui)
- **Min Height:** 80px
- **Auto-expand:** Yes
- **Max Height:** 200px

### Action Buttons
**Cancel:**
- Variant: ghost
- Reverts changes
- Returns to display mode

**Save Changes:**
- Variant: default (primary)
- Validates and saves
- Closes edit mode

---

## 3. Interaction Patterns

### Enter Edit Mode
1. Click Edit icon on task card
2. Card expands with smooth animation (200ms)
3. Input fields appear with current values
4. Title input auto-focused
5. Checkbox remains visible but disabled

### Save Changes
1. Validate title (min 5 chars)
2. Update task data locally
3. Close edit mode with animation
4. Show checkmark animation briefly
5. Return to display mode

### Cancel Editing
1. Show confirmation if changes made: "Discard changes?"
2. If confirmed, revert to original values
3. Close edit mode
4. Return to display mode

### Keyboard Shortcuts
- **Cmd/Ctrl + Enter:** Save changes
- **Escape:** Cancel editing
- **Tab:** Move between title and description

---

## 4. Accessibility

**Keyboard Navigation:**
- Edit button accessible via Tab
- Enter/Space to activate edit mode
- Focus moves to title input
- Tab between fields
- Escape to cancel

**Screen Reader:**
```html
<button aria-label="Edit task: Research audience demographics">
  <EditIcon />
</button>
<div role="region" aria-label="Editing task">
  <input aria-label="Task title" />
  <textarea aria-label="Task description" />
</div>
```

---

## 5. v0.dev Prompt

```
Create an inline editable task card component.

Requirements:
- Default mode: Title + description (read-only) with Edit button
- Edit mode: Title input + description textarea + Save/Cancel buttons
- Smooth transition animation (200ms)
- Auto-focus title input when entering edit mode
- Validation: Title min 5 chars, required
- Confirmation on cancel if changes made
- Keyboard shortcuts: Cmd+Enter (save), Escape (cancel)
- Accessible (ARIA, focus management)

Use shadcn/ui Input, Textarea, Button, Tailwind CSS.
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
