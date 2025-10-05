# UI/UX Specification: Story 1.3 - Progressive Task Confirmation

**Story ID:** STORY-1.3
**Feature:** Progressive Disclosure (5 Tasks at a Time)
**Design System:** shadcn/ui + Tailwind CSS

---

## 1. Screen Overview

**Purpose:** Reduce cognitive load by showing AI-generated tasks in batches of 5, preventing overwhelm from long lists.

**User Flow:**
- Brief created → AI generates 15-20 tasks
- First 5 tasks shown automatically
- "Show 5 More" button reveals next batch
- Manager reviews progressively

**Success Criteria:**
- Manager feels in control, not overwhelmed
- Clear indication of progress (5 of 20)
- Smooth animations during expansion

---

## 2. Layout Structure

### Batch Display Pattern
```
┌─────────────────────────────────┐
│ Tasks 1-5 (Batch 1)             │
│ [Fully visible]                 │
├─────────────────────────────────┤
│   [Show 5 More Tasks (10 left)]│
├─────────────────────────────────┤
│ Tasks 6-10 (Hidden)             │
│ Tasks 11-15 (Hidden)            │
│ Tasks 16-20 (Hidden)            │
└─────────────────────────────────┘
```

---

## 3. Component Specifications

### "Show More" Button
- **Component:** `<Button>` variant="outline"
- **Width:** Full width (mobile), Auto (desktop)
- **Height:** 44px
- **Icon:** ChevronDown
- **Text Variations:**
  - "Show 5 More Tasks" (when more exist)
  - "Show All Tasks" (shortcut to reveal all)
  - "Collapse" (when all shown)

### Progress Indicator (Optional)
- **Text:** "Showing 5 of 20 tasks"
- **Position:** Next to "Show More" button
- **Style:** `text-sm text-muted-foreground`

### Batch Animation
- **Expand:** 300ms ease-out slide-in
- **Collapse:** 300ms ease-in slide-out
- **Scroll Behavior:** Auto-scroll to new batch

---

## 4. Interaction Patterns

### Click "Show More"
1. Button shows loading spinner (200ms)
2. Next 5 tasks slide in from bottom
3. Button text updates with remaining count
4. Smooth scroll to first new task
5. Focus moves to first new checkbox

### Auto-Scroll Logic
- When revealing new batch, scroll so first new task is at 20% from top
- Smooth scroll (500ms ease)
- Don't scroll if user manually scrolled up

### Collapse Behavior (Optional)
- "Collapse" button to hide batches 2+
- Preserves selection state
- Scroll back to top

---

## 5. Responsive Behavior

### Mobile
- Full-width button
- Larger touch target (48px min)
- Text shortened: "Show More (10)"

### Desktop
- Centered button with max-width
- Hover state (slight shadow increase)
- Full descriptive text

---

## 6. Accessibility

**Keyboard:**
- Enter/Space on button to expand
- Focus moves to first new task

**Screen Reader:**
```html
<button aria-expanded="false" aria-controls="task-batch-2">
  Show 5 More Tasks
  <span class="sr-only">(10 tasks remaining)</span>
</button>
```

**Live Region:**
```html
<div role="status" aria-live="polite">
  Showing 10 of 20 tasks
</div>
```

---

## 7. v0.dev Prompt

```
Create a progressive disclosure component for task lists.

Requirements:
- Show 5 tasks initially
- "Show 5 More Tasks" button (full-width, outline)
- Smooth slide-in animation for new batches (300ms)
- Progress text: "Showing X of Y tasks"
- Auto-scroll to new batch
- Button text updates dynamically
- Accessible (ARIA expanded, focus management)
- Mobile responsive

Use shadcn/ui Button, Tailwind CSS, Framer Motion for animations.
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
