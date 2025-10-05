# UI/UX Specification: Story 1.6 - Draft Brief Auto-Save

**Story ID:** STORY-1.6
**Feature:** Auto-save Draft Briefs
**Design System:** shadcn/ui + Tailwind CSS

---

## 1. Screen Overview

**Purpose:** Prevent data loss by auto-saving brief drafts every 30 seconds, with clear save status indication.

**Success Criteria:**
- Users feel confident their work is saved
- Clear visual feedback on save status
- No interruption to workflow

---

## 2. Component Specifications

### Save Status Indicator
**Position:** Top-right of brief creation dialog OR below header

**States:**
- **Saving:** "Saving..." + spinner icon
- **Saved:** "Saved" + checkmark icon (green)
- **Unsaved:** "Unsaved changes" + dot icon (orange)
- **Error:** "Failed to save" + warning icon (red)

**Visual Design:**
```
Status Indicator Variations:

┌─────────────────┐     ┌─────────────────┐
│ ⟳ Saving...     │     │ ✓ Saved         │
└─────────────────┘     └─────────────────┘

┌─────────────────┐     ┌─────────────────┐
│ • Unsaved       │     │ ⚠ Failed to save│
└─────────────────┘     └─────────────────┘
```

- **Font:** `text-sm` (14px)
- **Color:**
  - Saving: `text-muted-foreground`
  - Saved: `text-green-600`
  - Unsaved: `text-orange-600`
  - Error: `text-destructive`

### Auto-save Logic
- **Trigger:** Every 30 seconds if changes detected
- **Debounce:** Wait 2 seconds after last keystroke
- **API:** POST to Supabase with `status='Draft'`
- **Optimistic UI:** Show "Saved" immediately, revert on error

---

## 3. Interaction Patterns

### User Types in Form
1. Status changes to "Unsaved changes"
2. After 2 seconds of inactivity → trigger save
3. Status changes to "Saving..."
4. API call completes
5. Status changes to "Saved" (with checkmark animation)
6. After 3 seconds, fade to minimal dot

### Save Error
1. API fails → Status "Failed to save"
2. Show toast: "Failed to save draft. Retrying..."
3. Retry after 5 seconds
4. If retry fails → Show persistent error banner

### Manual Save (Optional)
- **Cmd/Ctrl + S:** Trigger immediate save
- **Save Button:** Optional explicit save button

---

## 4. Accessibility

**Screen Reader:**
```html
<div role="status" aria-live="polite" aria-atomic="true">
  Saved at 3:42 PM
</div>
```

**Announcements:**
- "Draft saved" (on success)
- "Saving draft" (during save)
- "Failed to save draft, retrying" (on error)

---

## 5. v0.dev Prompt

```
Create an auto-save status indicator component.

Requirements:
- 4 states: Saving (spinner), Saved (checkmark), Unsaved (dot), Error (warning)
- Auto-save after 2 seconds of inactivity
- Save every 30 seconds if changes exist
- Visual feedback with icons and color coding
- Toast notification on save errors
- Retry logic for failed saves
- Accessible (ARIA live region, announcements)

Use shadcn/ui icons, Tailwind CSS, React hooks for debouncing.
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
