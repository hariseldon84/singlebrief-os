# UI/UX Specification: Story 1.2 - AI Task Breakdown & Progressive Confirmation

**Story ID:** STORY-1.2
**Feature:** AI-Generated Task List with Progressive Disclosure
**Design System:** shadcn/ui + Tailwind CSS

---

## 1. Screen Overview

### Purpose
Display AI-generated tasks with progressive disclosure (5 at a time) and allow managers to select/deselect before confirmation. Must build confidence through clear organization and control.

### User Flow
1. Manager creates brief → AI generates tasks (30s loading)
2. Brief detail page loads with generated tasks
3. Tasks shown 5 at a time with "Show More" button
4. Manager reviews, checks/unchecks tasks
5. Clicks "Confirm Tasks" to finalize

### Success Criteria
- Manager feels in control of AI suggestions
- Progressive disclosure reduces overwhelm
- Easy to scan and evaluate tasks
- Clear path to confirmation

---

## 2. Layout Structure

### Page Layout
```
┌────────────────────────────────────────────────────┐
│  SingleBrief                    [Search] [Profile]  │
├────────────────────────────────────────────────────┤
│  ← Back to Dashboard                                │
│                                                     │
│  Q1 Marketing Campaign                   [••• Menu] │
│  Created 2 minutes ago • Draft                      │
│                                                     │
│  ┌──────────────────────────────────────────────┐ │
│  │ 🤖 AI generated 15 tasks                     │ │
│  │ Review and select tasks to include           │ │
│  └──────────────────────────────────────────────┘ │
│                                                     │
│  ┌──────────────────────────────────────────────┐ │
│  │ ☑ Research target audience demographics     │ │
│  │   Analyze current customer data and...       │ │
│  │   ───────────────────────────────────────     │ │
│  │ ☑ Define campaign messaging pillars         │ │
│  │   Create core value propositions that...     │ │
│  │   ───────────────────────────────────────     │ │
│  │ ☑ Design email campaign templates           │ │
│  │   Create responsive email templates...       │ │
│  │   ───────────────────────────────────────     │ │
│  │ ☑ Create social media content calendar      │ │
│  │   Plan daily posts across platforms...       │ │
│  │   ───────────────────────────────────────     │ │
│  │ ☐ Set up analytics tracking dashboard       │ │
│  │   Configure Google Analytics and...          │ │
│  │   ───────────────────────────────────────     │ │
│  │                                               │ │
│  │         [Show 5 More Tasks]                   │ │
│  └──────────────────────────────────────────────┘ │
│                                                     │
│  13 tasks selected                                  │
│  ┌──────────────┐  ┌────────────────────────┐     │
│  │ Regenerate   │  │ Confirm Tasks          │     │
│  └──────────────┘  └────────────────────────┘     │
└────────────────────────────────────────────────────┘
```

### Responsive Breakpoints
- **Mobile (< 640px):** Single column, stacked layout
- **Tablet (640-1024px):** Single column with more padding
- **Desktop (> 1024px):** Max-width 900px, centered

---

## 3. Component Specifications

### 3.1 Info Banner (AI Generation Notice)
**Component:** `<Alert>` (shadcn/ui)
- **Variant:** Info (blue background)
- **Icon:** Robot/AI icon (🤖)
- **Title:** "AI generated {count} tasks"
- **Description:** "Review and select tasks to include"
- **Dismissible:** Yes (X button top-right)

### 3.2 Task Card
**Component:** Custom card with checkbox
- **Layout:** Horizontal flex with checkbox + content
- **Background:** White with subtle border
- **Hover:** Light gray background, shadow increase
- **Spacing:** 16px padding
- **Border:** `border-gray-200` 1px solid
- **Border Radius:** `rounded-lg` (8px)

**Card Structure:**
```
┌─────────────────────────────────────────┐
│ ☑  Task Title (Bold, 16px)              │
│    Task description (14px, gray)        │
│    Truncated to 2 lines with "..."     │
│    ─────────────────────────────────    │
└─────────────────────────────────────────┘
```

### 3.3 Checkbox
**Component:** `<Checkbox>` (shadcn/ui)
- **Size:** 20px x 20px
- **Checked State:** Blue checkmark
- **Unchecked State:** Empty box with border
- **Disabled State:** Gray with reduced opacity
- **Position:** Aligned to top of card content

### 3.4 Task Title
- **Font:** `text-base` (16px)
- **Weight:** `font-semibold` (600)
- **Color:** `text-foreground`
- **Line Height:** `leading-tight` (1.25)
- **Max Lines:** 2 lines with ellipsis

### 3.5 Task Description
- **Font:** `text-sm` (14px)
- **Weight:** `font-normal` (400)
- **Color:** `text-muted-foreground`
- **Line Height:** `leading-relaxed` (1.625)
- **Max Lines:** 2 lines with ellipsis
- **Top Margin:** 4px below title

### 3.6 Task Divider
- **Component:** `<Separator>` (shadcn/ui)
- **Color:** `border-gray-200`
- **Height:** 1px
- **Margin:** 12px top and bottom

### 3.7 "Show More" Button
**Component:** `<Button>` variant="outline"
- **Width:** Full width (block)
- **Height:** 44px
- **Text:** "Show {count} More Tasks" or "Show All Tasks"
- **Icon:** ChevronDown icon
- **State:** Disabled when all tasks shown
- **Loading:** Spinner when expanding (brief animation)

### 3.8 Selection Counter
**Component:** Text with badge
- **Text:** "{count} tasks selected"
- **Font:** `text-sm font-medium`
- **Position:** Below task list, above buttons
- **Badge:** Circular badge with count (optional)

### 3.9 Action Buttons
**Regenerate Button:**
- **Component:** `<Button>` variant="outline"
- **Icon:** Refresh icon
- **Text:** "Regenerate"
- **Loading State:** Spinner + "Regenerating..."
- **Confirmation:** Modal "Regenerate tasks? Current selection will be lost."

**Confirm Tasks Button:**
- **Component:** `<Button>` variant="default"
- **Text:** "Confirm Tasks" or "Confirm {count} Tasks"
- **Disabled:** When 0 tasks selected
- **Loading State:** Spinner + "Confirming..."
- **Action:** Save selections, update brief status

---

## 4. Interaction Patterns

### 4.1 Initial Load (AI Generation)
**Loading State:**
- Skeleton UI with shimmer effect
- 5 placeholder cards (gray rectangles)
- Text: "AI is generating tasks... (typically 30 seconds)"
- Animated dots or spinner

**Success Load:**
- Skeleton fades out
- Task cards fade in with stagger (50ms delay each)
- Info banner appears at top
- First 5 tasks visible
- "Show More" button appears if > 5 tasks

### 4.2 Task Selection
**Click Checkbox:**
- Checkbox toggles checked/unchecked
- Selection counter updates immediately
- "Confirm Tasks" button enables/disables
- Smooth animation (150ms)

**Click Card:**
- Entire card acts as clickable area
- Toggle checkbox when clicking anywhere
- Provide visual feedback (ripple effect)

### 4.3 Progressive Disclosure
**Click "Show More":**
1. Button shows loading spinner (200ms)
2. Next 5 tasks fade in below existing
3. Button text updates: "Show 5 More" → "Show 3 More" → "Show All"
4. When all shown, button becomes "Collapse" or disappears
5. Smooth scroll to newly revealed tasks

**Animation:**
- Tasks slide in from bottom (300ms ease-out)
- Existing tasks stay in place
- No layout shift

### 4.4 Regeneration Flow
**Click "Regenerate":**
1. Show confirmation modal: "Regenerate tasks? Your current selections will be lost."
2. If confirmed:
   - All tasks fade out
   - Loading skeleton appears
   - API call to n8n workflow
   - New tasks generated (30s)
   - New tasks fade in
   - All checkboxes start checked by default

### 4.5 Confirmation Flow
**Click "Confirm Tasks":**
1. Button enters loading state
2. Selected tasks saved to database
3. Brief status changes from "Draft" to "Active"
4. Redirect to brief detail page (with active tasks)
5. Toast notification: "{count} tasks confirmed successfully"

---

## 5. States & Visual Feedback

### 5.1 Loading State (Initial)
- 5 skeleton cards with shimmer
- Loading text: "AI is generating tasks..."
- Buttons disabled
- Info banner not shown

### 5.2 Empty State (No Tasks Generated)
- Empty state illustration (robot with question mark)
- Message: "No tasks could be generated"
- Subtext: "Try providing more detail in your brief description"
- CTA: "Edit Brief" button
- Secondary CTA: "Try Again" button

### 5.3 Default State (Tasks Loaded)
- First 5 tasks visible, all checked
- "Show More" button visible if > 5 tasks
- Selection counter shows total
- "Confirm Tasks" button enabled
- Info banner visible

### 5.4 Partial Selection State
- Some tasks unchecked
- Selection counter reflects actual count
- "Confirm Tasks" button text updates: "Confirm {count} Tasks"
- No visual indication of which batch tasks are in

### 5.5 No Selection State
- All tasks unchecked
- Selection counter: "0 tasks selected"
- "Confirm Tasks" button disabled
- Helper text: "Select at least one task to continue"

### 5.6 All Expanded State
- All tasks visible
- "Show More" button hidden or shows "Collapse All"
- Scrollable list if many tasks

### 5.7 Regenerating State
- All task cards fade to 50% opacity
- Skeleton overlay appears
- "Regenerate" button shows spinner
- All interactions disabled
- Info banner persists

---

## 6. Responsive Behavior

### Mobile (< 640px)
- Task cards full width
- Checkbox larger (24px) for touch
- Description text truncated to 1 line
- Buttons stack vertically
- "Show More" collapses to icon button
- Selection counter moves to sticky footer

### Tablet (640-1024px)
- Task cards with more padding
- Description shows 2 lines
- Buttons side-by-side
- Increased touch targets
- Comfortable spacing

### Desktop (> 1024px)
- Max width 900px, centered
- Hover states on cards
- Description can expand on hover (tooltip)
- Larger "Show More" button
- Optimal line length

---

## 7. Accessibility Requirements

### Keyboard Navigation
- **Tab:** Move between checkboxes
- **Space:** Toggle checkbox
- **Enter:** On card, toggle checkbox
- **Arrow Keys:** Navigate between task cards (optional)

### Screen Reader Support
- **List Role:** Task list has `role="list"`
- **Item Role:** Each task card `role="listitem"`
- **Checkbox:** Properly labeled with task title
- **Selection Counter:** Live region, announces changes
- **Show More:** Announces "Showing {new_count} of {total} tasks"

### Focus Management
- Clear focus indicators (2px blue ring)
- Focus moves logically through checkboxes
- "Show More" button maintains focus after expansion
- "Confirm Tasks" has clear focus state

### ARIA Attributes
```html
<div role="list" aria-label="AI generated tasks">
  <div role="listitem">
    <input type="checkbox" aria-labelledby="task-title-1" />
    <span id="task-title-1">Research target audience</span>
  </div>
</div>
<div role="status" aria-live="polite" aria-atomic="true">
  {count} tasks selected
</div>
```

---

## 8. Design Tokens

### Colors
```css
--task-card-bg: hsl(0 0% 100%)
--task-card-border: hsl(240 5.9% 90%)
--task-card-hover-bg: hsl(240 4.8% 95.9%)
--checkbox-checked: hsl(221.2 83.2% 53.3%)
--info-banner-bg: hsl(221.2 83.2% 97%)
--info-banner-border: hsl(221.2 83.2% 85%)
```

### Spacing
```css
--task-card-gap: 12px
--task-card-padding: 16px
--progressive-batch-size: 5
```

### Typography
```css
--task-title: 16px / 600 / 1.25
--task-description: 14px / 400 / 1.625
--selection-counter: 14px / 500 / 1.5
```

---

## 9. Figma Design Notes

### Component Variants
**Task Card:**
- Default (unchecked)
- Checked
- Hover
- Disabled
- Loading skeleton

**Checkbox:**
- Unchecked
- Checked
- Indeterminate (if "Select All" added)
- Disabled

### Auto-layout Structure
- Task list: Vertical auto-layout, 12px gap
- Task card: Horizontal auto-layout, 12px gap
- Button group: Horizontal auto-layout, 12px gap

### Interactive Prototype
1. Check/uncheck tasks → Selection counter updates
2. Click "Show More" → Reveal next batch
3. Click "Regenerate" → Show confirmation → Regenerate flow
4. Click "Confirm" → Success state

---

## 10. Technical Implementation Notes

### Progressive Disclosure Logic
```typescript
const BATCH_SIZE = 5;
const [visibleCount, setVisibleCount] = useState(BATCH_SIZE);
const showMore = () => setVisibleCount(prev => Math.min(prev + BATCH_SIZE, tasks.length));
```

### Selection State
```typescript
const [selectedTasks, setSelectedTasks] = useState<string[]>(
  tasks.map(t => t.id) // All checked by default
);
```

### API Integration
- **Generate:** POST to n8n webhook → OpenRouter API → Returns JSON task array
- **Save:** POST selected task IDs to Supabase `tasks` table

---

## 11. v0.dev / Lovable AI Prompt

```
Create a React component showing AI-generated tasks with progressive disclosure.

Requirements:
- Display task cards with checkboxes (all checked by default)
- Each card shows task title (bold, 16px) + description (14px, gray, 2 lines)
- Show 5 tasks initially, "Show More" button to reveal next 5
- Selection counter: "{count} tasks selected"
- "Regenerate" button (outline, with confirmation modal)
- "Confirm Tasks" button (primary, disabled when 0 selected)
- Info banner at top: "AI generated 15 tasks"
- Loading skeleton for initial generation (30s)
- Smooth animations for expansion and selection
- Fully accessible (ARIA, keyboard navigation)
- Responsive (mobile stacks, desktop max-width 900px)

Use shadcn/ui components, Tailwind CSS, React hooks for state.
```

## 12. Enhanced AI Tool Prompts

### For v0.dev / Lovable

```
Create a task list component with progressive disclosure showing AI-generated tasks.

LAYOUT:
- Info banner at top (blue background): "🤖 AI generated 15 tasks - Review and select tasks to include"
- Task list container with vertical stack
- Show 5 tasks initially, "Show 5 More" button below
- Selection counter: "{count} tasks selected"
- Action buttons: "Regenerate" (outline) + "Confirm Tasks" (primary)

TASK CARD COMPONENT:
- Horizontal layout: Checkbox + Content
- Width: Full width
- Padding: 16px
- Border: 1px solid gray-200
- Border radius: 8px
- Gap between cards: 12px
- Hover: Light gray background + shadow

TASK CARD CONTENT:
- Title: Bold, 16px, max 2 lines with ellipsis
- Description: Regular, 14px, gray, max 2 lines with ellipsis
- Separator: 1px horizontal line (gray-200)

CHECKBOX:
- Size: 20px × 20px
- Position: Top-aligned with card content
- Default: All checked
- Interactive: Click card or checkbox to toggle

"SHOW MORE" BUTTON:
- Full width
- Height: 44px
- Outline variant
- Text: "Show 5 More Tasks" or "Show {remaining} More Tasks"
- Icon: ChevronDown
- Disabled when all shown

ACTION BUTTONS:
- "Regenerate": Outline, refresh icon, left-aligned
  * Confirmation dialog: "Regenerate tasks? Current selections will be lost."
- "Confirm Tasks": Primary, right-aligned
  * Disabled when 0 selected
  * Shows count: "Confirm 13 Tasks"

INTERACTIONS:
- Progressive disclosure: Show 5 at a time
- Smooth animations: 300ms slide-in for new tasks
- Auto-scroll to newly revealed tasks
- Selection updates counter in real-time

STATES:
- Loading (initial): Skeleton cards with shimmer
- Default: First 5 tasks shown, all checked
- Expanded: More tasks visible
- Regenerating: Skeleton overlay on existing tasks
- Empty: No tasks generated (error state)

TECH STACK:
- React 18 + TypeScript
- shadcn/ui: Alert, Button, Checkbox, Skeleton
- Framer Motion for animations
- Tailwind CSS
```

### For Figma AI

```
Design a task selection interface with progressive disclosure.

COMPONENTS:

1. Info Banner (full-width)
   - Background: Light blue (#dbeafe)
   - Border: 1px #93c5fd
   - Padding: 12px 16px
   - Icon: 🤖 robot (left)
   - Text: "AI generated 15 tasks" (semibold)
   - Subtext: "Review and select tasks to include" (regular, gray)
   - Dismiss button: X (top-right)

2. Task Card (repeating component)
   - Container: 
     * Width: Full
     * Height: Auto
     * Padding: 16px
     * Border: 1px #e5e7eb
     * Border-radius: 8px
     * Background: White
     * Hover: Background #f9fafb, Shadow-sm
   
   - Layout (horizontal):
     [Checkbox 20px] [Content flex-1]
   
   - Content:
     * Title: 16px semibold #1f2937, max-height 40px (2 lines)
     * Separator: 1px line #e5e7eb, margin 8px vertical
     * Description: 14px regular #6b7280, max-height 45px (2 lines)
   
   - States:
     * Default (unchecked)
     * Checked (blue checkmark)
     * Hover (gray background)

3. Show More Button
   - Width: Full
   - Height: 44px
   - Border: 1px #e5e7eb
   - Border-radius: 6px
   - Background: White
   - Text: "Show 5 More Tasks" (14px medium)
   - Icon: ChevronDown (right of text)
   - Hover: Background #f9fafb

4. Selection Counter
   - Text: "13 tasks selected" (14px medium #6b7280)
   - Position: Below task list, above buttons
   - Padding: 12px 0

5. Action Buttons Row
   - Container: Horizontal, space-between, 12px gap
   - Left: "Regenerate" button
     * Style: Outline
     * Icon: Refresh/Reload
     * Text: "Regenerate"
     * Size: Medium
   - Right: "Confirm Tasks" button
     * Style: Primary (filled)
     * Text: "Confirm 13 Tasks"
     * Size: Medium
     * States: Normal, Disabled (0 selected)

ANIMATIONS TO PROTOTYPE:
- Checkbox toggle (150ms)
- New tasks sliding in (300ms ease-out)
- Button loading state (spinner rotation)

COLOR PALETTE:
- Primary: #3b82f6
- Background: #ffffff
- Border: #e5e7eb
- Text primary: #1f2937
- Text secondary: #6b7280
- Hover: #f9fafb
```

### For Visily.ai

```
SCREEN: Task Selection with Progressive Disclosure

LAYOUT: Vertical stack

SECTION 1: Info Banner
- Background: Light blue
- Icon: Robot emoji
- Text: "AI generated 15 tasks"
- Subtext: "Review and select"
- Dismiss: X button

SECTION 2: Task List (scrollable)
- Display: 5 tasks initially
- Spacing: 12px gap between cards

TASK CARD (repeating):
- Layout: Checkbox (left) + Text content (right)
- Border: Light gray, 1px
- Padding: 16px
- Corner radius: 8px
- States: Normal, Hover, Checked

Text Content:
- Title (bold, 16px, 2 lines max)
- Divider line
- Description (regular, 14px, gray, 2 lines max)

SECTION 3: Show More Control
- Button: "Show 5 More Tasks" (outline)
- Full width
- Center-aligned text with down arrow

SECTION 4: Footer
- Selection count: "13 tasks selected"
- Buttons row:
  * Left: "Regenerate" (outline, with icon)
  * Right: "Confirm Tasks" (primary)

INTERACTIONS:
- Tap checkbox or card → Toggle selection
- Tap "Show More" → Reveal next 5 tasks
- Tap "Regenerate" → Show confirmation → Replace tasks
- Tap "Confirm" → Save selections

RESPONSIVE:
- Mobile: Full width, vertical buttons
- Desktop: Max-width 900px, horizontal buttons
```

### For Uizard

```
Screen: "Task Review & Selection"
Type: List with Progressive Disclosure

Components:

1. [Alert Banner] Info
   - Background: Blue-100
   - Icon: Robot
   - Message: "AI generated 15 tasks"

2. [List] Task Cards
   - Items: 5 visible initially
   - Item template:
     * [Checkbox] Left-aligned, 20px
     * [Text] Title - Bold, 16px
     * [Divider] Thin line
     * [Text] Description - Regular, 14px, Gray

3. [Button] "Show More"
   - Style: Outline
   - Width: Full
   - Icon: Down arrow

4. [Text] Counter
   - Content: "{count} tasks selected"
   - Style: Medium gray

5. [Button Group] Actions
   - Left button: "Regenerate" (Outline, Refresh icon)
   - Right button: "Confirm Tasks" (Primary)

Behavior:
- All checkboxes start checked
- Click checkbox or card → Toggle
- Click "Show More" → Add 5 more items
- Counter updates live
- "Confirm" disabled when 0 selected

Layout: Vertical, 900px max-width, centered
```
