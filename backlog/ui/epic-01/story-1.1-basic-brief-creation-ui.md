# UI/UX Specification: Story 1.1 - Basic Brief Creation

**Story ID:** STORY-1.1
**Feature:** Basic Brief Creation Form
**Design System:** shadcn/ui + Tailwind CSS

---

## 1. Screen Overview

### Purpose
Primary entry point for managers to create new briefs. Must feel lightweight yet capable, removing friction while maintaining structure.

### User Flow Entry Points
1. Dashboard → "Create Brief" button (primary CTA)
2. Empty state CTA when no briefs exist
3. Header navigation "+ New Brief" button (global)

### Success Criteria
- Manager can create brief in <2 minutes
- Form feels simple, not overwhelming
- Validation guides correct completion
- Clear path to AI task generation

---

## 2. Layout Structure

### Dialog/Modal Layout
```
┌─────────────────────────────────────────┐
│  Create New Brief              [X]      │
├─────────────────────────────────────────┤
│                                         │
│  Brief Title *                          │
│  ┌─────────────────────────────────┐  │
│  │ e.g., Q1 Marketing Campaign     │  │
│  └─────────────────────────────────┘  │
│                                         │
│  Brief Description *                    │
│  ┌─────────────────────────────────┐  │
│  │                                  │  │
│  │ Describe what needs to be done  │  │
│  │ in detail...                     │  │
│  │                                  │  │
│  │                          (850)   │  │
│  └─────────────────────────────────┘  │
│  500-1000 characters recommended      │
│                                         │
│  ┌──────────────┐  ┌───────────────┐  │
│  │ Cancel       │  │ Generate Tasks│  │
│  └──────────────┘  └───────────────┘  │
└─────────────────────────────────────────┘
```

### Responsive Breakpoints
- **Mobile (< 640px):** Full-screen modal, simplified layout
- **Tablet (640-1024px):** 80% width modal, centered
- **Desktop (> 1024px):** 600px fixed width modal, centered

---

## 3. Component Specifications

### 3.1 Dialog Container
**Component:** `<Dialog>` (shadcn/ui)
- **Width:** 600px (desktop), 90vw (mobile)
- **Max Height:** 90vh with internal scroll
- **Background:** White (`bg-background`)
- **Border Radius:** `rounded-lg` (8px)
- **Shadow:** `shadow-xl`
- **Overlay:** Dark semi-transparent (`bg-black/50`)

### 3.2 Title Input
**Component:** `<Input>` (shadcn/ui)
- **Placeholder:** "e.g., Q1 Marketing Campaign"
- **Max Length:** 100 characters
- **Validation:** Required, min 5 characters
- **Error State:** Red border + error message below
- **Height:** `h-11` (44px)
- **Font:** `text-base` (16px) - prevents mobile zoom

### 3.3 Description Textarea
**Component:** `<Textarea>` (shadcn/ui)
- **Placeholder:** "Describe what needs to be done in detail..."
- **Min Height:** 200px (mobile), 250px (desktop)
- **Max Height:** Auto-expand to 400px
- **Character Counter:** Bottom-right, gray text
- **Recommended Range:** 500-1000 characters
- **Validation:** Required, min 100 characters
- **Font:** `text-base` (16px)
- **Line Height:** `leading-relaxed` (1.625)

### 3.4 Character Counter
**Component:** Custom text element
- **Position:** Absolute bottom-right inside textarea
- **Style:** `text-sm text-muted-foreground`
- **Format:** `(850)` - just the number
- **Color Changes:**
  - `< 500 chars`: `text-muted-foreground` (gray)
  - `500-1000 chars`: `text-green-600` (green - optimal)
  - `> 1000 chars`: `text-orange-600` (orange - still valid but long)

### 3.5 Helper Text
**Component:** `<p>` below textarea
- **Text:** "500-1000 characters recommended"
- **Style:** `text-sm text-muted-foreground`
- **Icon:** Optional info icon `(i)` before text

### 3.6 Action Buttons
**Primary Button:** "Generate Tasks"
- **Component:** `<Button>` variant="default"
- **Width:** Auto-width with padding
- **State Disabled:** When title or description invalid
- **Loading State:** Spinner + "Generating..." text
- **Icon:** Sparkles icon (✨) before text

**Secondary Button:** "Cancel"
- **Component:** `<Button>` variant="ghost"
- **Action:** Close dialog, discard changes
- **Confirmation:** If form has content, show "Discard changes?" alert

---

## 4. Interaction Patterns

### 4.1 Opening the Dialog
**Trigger Actions:**
1. Click "Create Brief" button on Dashboard
2. Click "+ New Brief" in header navigation
3. Keyboard shortcut: `Cmd/Ctrl + N` (global)

**Animation:**
- Dialog fades in (200ms ease-out)
- Overlay appears with backdrop blur
- Focus automatically moves to Title input

### 4.2 Form Validation
**Real-time Validation:**
- **Title:** Show error after blur if < 5 chars
- **Description:** Show error after blur if < 100 chars
- **Character Counter:** Updates on every keystroke

**Error Messages:**
- Title: "Title must be at least 5 characters"
- Description: "Description must be at least 100 characters"

**Success State:**
- Green checkmark icon appears in input (optional)
- "Generate Tasks" button becomes enabled

### 4.3 Submission Flow
**Click "Generate Tasks":**
1. Button enters loading state (spinner + "Generating...")
2. Form inputs become disabled (gray background)
3. Send brief to Supabase
4. Trigger n8n workflow for AI task generation
5. Close dialog
6. Redirect to brief detail page
7. Show loading state while AI generates tasks

**Error Handling:**
- Network error: Toast notification "Failed to create brief. Try again."
- API error: Toast with specific error message
- Stay in dialog, re-enable form

---

## 5. States & Visual Feedback

### 5.1 Empty State
- All fields blank
- Placeholder text visible
- "Generate Tasks" button disabled
- Character counter shows `(0)`

### 5.2 In-Progress State
- User typing in fields
- Character counter updating
- Validation errors appear after blur
- Button enables when valid

### 5.3 Valid State
- Both fields meet requirements
- No error messages visible
- "Generate Tasks" button enabled and prominent
- Green checkmarks in inputs (optional)

### 5.4 Loading State
**During Submission:**
- Button shows spinner + "Generating..."
- All inputs disabled with gray background
- Dialog overlay prevents clicks
- Close button disabled

### 5.5 Error State
**Validation Errors:**
- Input border turns red (`border-destructive`)
- Error message below input in red (`text-destructive`)
- Icon: Small alert icon in input

**Submission Errors:**
- Toast notification at top of screen
- Error persists until user acknowledges
- Form re-enables for retry

---

## 6. Responsive Behavior

### Mobile (< 640px)
- Full-screen modal (100vw x 100vh)
- Simplified padding (16px)
- Textarea height: 200px min
- Buttons stack vertically
- Character counter below textarea (not inside)

### Tablet (640-1024px)
- Modal width: 80vw, max 600px
- Centered with backdrop
- Normal layout preserved
- Increased touch targets (48px min)

### Desktop (> 1024px)
- Fixed 600px width
- Centered with backdrop
- Optimal spacing and sizing
- Hover states on buttons

---

## 7. Accessibility Requirements

### Keyboard Navigation
- **Tab Order:** Title → Description → Cancel → Generate Tasks
- **Escape Key:** Close dialog (with confirmation if dirty)
- **Enter Key:** Submit form (if valid)
- **Cmd/Ctrl + N:** Open dialog from anywhere

### Screen Reader Support
- **Dialog Role:** `role="dialog"` `aria-modal="true"`
- **Title:** `aria-labelledby="dialog-title"`
- **Description:** `aria-describedby="dialog-description"`
- **Labels:** All inputs have associated `<label>` elements
- **Error Messages:** `aria-invalid="true"` and `aria-describedby` linked to error

### Focus Management
- Focus moves to Title input on dialog open
- Focus trapped within dialog
- Focus returns to trigger button on close
- Clear focus indicators (2px blue ring)

### Color Contrast
- All text meets WCAG AA (4.5:1 minimum)
- Error states have sufficient contrast
- Disabled states clearly distinguishable

---

## 8. Design Tokens

### Colors
```css
--background: hsl(0 0% 100%)           /* Dialog background */
--foreground: hsl(240 10% 3.9%)       /* Primary text */
--muted-foreground: hsl(240 3.8% 46.1%)  /* Helper text */
--border: hsl(240 5.9% 90%)           /* Input borders */
--input: hsl(240 5.9% 90%)            /* Input background */
--destructive: hsl(0 84.2% 60.2%)     /* Error red */
--primary: hsl(240 5.9% 10%)          /* Primary button */
```

### Spacing
```css
--spacing-dialog-padding: 24px (desktop), 16px (mobile)
--spacing-input-gap: 16px
--spacing-button-gap: 12px
```

### Typography
```css
--font-dialog-title: 18px / 600 / 1.3
--font-input-label: 14px / 500 / 1.5
--font-input-text: 16px / 400 / 1.5
--font-helper-text: 14px / 400 / 1.5
--font-error-text: 14px / 500 / 1.5
```

---

## 9. Figma Design Notes

### Component Layers
1. **Dialog Overlay** - Semi-transparent backdrop
2. **Dialog Container** - White card with shadow
3. **Header Section** - Title + Close button
4. **Form Section** - Inputs with labels
5. **Footer Section** - Action buttons

### Auto-layout Structure
- **Dialog:** Vertical auto-layout, 24px gap
- **Form Inputs:** Vertical auto-layout, 16px gap
- **Button Group:** Horizontal auto-layout, 12px gap, right-aligned

### Component Variants Needed
**Input Component:**
- Default
- Focused (blue ring)
- Error (red border + message)
- Disabled (gray background)

**Button Component:**
- Primary (default)
- Primary hover
- Primary loading (spinner)
- Primary disabled
- Ghost (cancel)
- Ghost hover

### Interactive Prototype
**Flows to Prototype:**
1. Open dialog → Focus title → Type → Tab to description → Type → Click generate
2. Validation error flow → Blur with invalid input → See error → Fix → Error clears
3. Cancel flow → Click cancel → Show confirmation if dirty → Confirm → Close

### Design System References
- shadcn/ui Dialog: https://ui.shadcn.com/docs/components/dialog
- shadcn/ui Input: https://ui.shadcn.com/docs/components/input
- shadcn/ui Textarea: https://ui.shadcn.com/docs/components/textarea
- shadcn/ui Button: https://ui.shadcn.com/docs/components/button

---

## 10. Implementation Notes for Developer

### Tech Stack
- **Framework:** React 18 + TypeScript
- **UI Library:** shadcn/ui (Radix UI + Tailwind)
- **Form:** React Hook Form + Zod validation
- **State:** TanStack Query for mutations
- **Backend:** Supabase

### Key Files
- Component: `src/components/BriefCreationDialog.tsx`
- Form Schema: `src/lib/validations/brief.ts`
- API Hook: `src/hooks/use-create-brief.ts`

### Validation Schema (Zod)
```typescript
const briefSchema = z.object({
  title: z.string().min(5, "Title must be at least 5 characters"),
  description: z.string().min(100, "Description must be at least 100 characters"),
});
```

---

## 11. v0.dev / Lovable AI Prompt

If generating this UI with AI tools, use this prompt:

```
Create a React dialog component for creating a new brief using shadcn/ui.

Requirements:
- Dialog with 600px width, centered, with backdrop
- Title input (100 char max, required, min 5 chars)
- Description textarea (auto-expand 200-400px, required, min 100 chars)
- Character counter for description (bottom-right, color changes: gray < 500, green 500-1000, orange > 1000)
- Helper text: "500-1000 characters recommended"
- Cancel button (ghost variant)
- "Generate Tasks" button (primary, disabled when invalid, loading state with spinner)
- Real-time validation with error messages
- Fully accessible (ARIA, keyboard nav, focus management)
- Responsive (full-screen on mobile, modal on desktop)

Use React Hook Form + Zod for validation, shadcn/ui components, Tailwind CSS.
```

## 12. Enhanced AI Tool Prompts

### For v0.dev / Lovable (Enhanced)

```
Create a professional brief creation dialog using React, TypeScript, and shadcn/ui.

LAYOUT:
- Modal dialog, 600px width on desktop, full-screen on mobile
- Semi-transparent backdrop with blur effect
- Header: "Create New Brief" + close button (X)
- Form body with vertical layout, 24px spacing
- Footer: Cancel (ghost) + Generate Tasks (primary) buttons

COMPONENTS:

1. Title Input:
   - Label: "Brief Title *" (required indicator)
   - Placeholder: "e.g., Q1 Marketing Campaign"
   - Max length: 100 characters
   - Validation: Min 5 chars, show error on blur
   - Error message: "Title must be at least 5 characters"
   - Full-width, 44px height, 16px font size

2. Description Textarea:
   - Label: "Brief Description *"
   - Placeholder: "Describe what needs to be done in detail..."
   - Min height: 200px, max height: 400px (auto-expand)
   - Character counter (bottom-right inside textarea):
     * < 500: gray color
     * 500-1000: green color (optimal)
     * > 1000: orange color
     * Format: (850)
   - Validation: Min 100 chars
   - Error message: "Description must be at least 100 characters"

3. Helper Text:
   - Below textarea: "500-1000 characters recommended"
   - Small text, muted color

4. Buttons:
   - Cancel: Ghost variant, left-aligned
   - Generate Tasks: Primary variant, right-aligned
     * Disabled when form invalid
     * Loading state: Spinner + "Generating..." text
     * Sparkles icon (✨) before text when enabled

BEHAVIOR:
- Auto-focus title input on open
- Real-time character counting
- Validation on blur (not on every keystroke)
- Escape key closes dialog (with confirmation if dirty)
- Form submission on Ctrl/Cmd + Enter

VALIDATION:
- Use React Hook Form + Zod schema
- Show errors below inputs in red
- Disable submit button when invalid

ACCESSIBILITY:
- Dialog role with aria-modal
- All inputs have labels
- Error messages linked with aria-describedby
- Focus trap within dialog
- Focus returns to trigger on close

RESPONSIVE:
- Mobile (< 640px): Full-screen modal, vertical buttons
- Desktop (> 640px): 600px centered modal, horizontal buttons

TECH STACK:
- React 18 + TypeScript
- shadcn/ui: Dialog, Input, Textarea, Button, Label
- React Hook Form for form state
- Zod for validation schema
- Tailwind CSS for styling
```

### For Figma AI / Design Tools

```
Design a brief creation modal dialog with the following specifications:

FRAME STRUCTURE:
1. Overlay (full viewport)
   - Background: rgba(0, 0, 0, 0.5) with blur
   - Click to close

2. Dialog Container (600px × auto, centered)
   - Background: White
   - Border radius: 8px
   - Shadow: 0 25px 50px rgba(0, 0, 0, 0.25)
   - Padding: 24px

3. Header Section (auto-layout horizontal)
   - Title: "Create New Brief" (18px, semibold)
   - Close button: X icon (24px, clickable)
   - Spacing: Space between (justify)

4. Form Section (auto-layout vertical, 16px gap)
   
   A. Title Input Group:
      - Label: "Brief Title *" (14px, medium, #1e293b)
      - Input field:
        * Height: 44px
        * Border: 1px solid #e2e8f0
        * Border radius: 6px
        * Padding: 12px 16px
        * Placeholder: "e.g., Q1 Marketing Campaign" (gray)
        * Font: 16px regular
      - Error state: Red border + error text below

   B. Description Textarea Group:
      - Label: "Brief Description *" (14px, medium, #1e293b)
      - Textarea:
        * Min height: 200px
        * Border: 1px solid #e2e8f0
        * Border radius: 6px
        * Padding: 12px 16px
        * Placeholder: "Describe what needs to be done..."
        * Font: 16px regular, line-height: 1.625
        * Character counter (bottom-right): (850)
      - Helper text: "500-1000 characters recommended" (12px, #64748b)

5. Footer Section (auto-layout horizontal, 12px gap, right-aligned)
   - Cancel button:
     * Background: transparent
     * Border: none
     * Text: "Cancel" (14px, medium)
     * Padding: 10px 20px
     * Hover: Light gray background
   
   - Generate Tasks button:
     * Background: #0f172a (primary)
     * Text: "Generate Tasks" (14px, medium, white)
     * Padding: 10px 24px
     * Border radius: 6px
     * Icon: ✨ sparkles (left of text)
     * Disabled state: 50% opacity
     * Loading state: Spinner animation

STATES TO DESIGN:
1. Empty state (pristine)
2. Typing state (active input)
3. Valid state (green indicators)
4. Error state (red borders + messages)
5. Loading state (generating)

COLOR PALETTE:
- Background: #FFFFFF
- Text primary: #0f172a
- Text secondary: #64748b
- Border: #e2e8f0
- Error: #ef4444
- Success: #10b981
- Primary button: #0f172a

VARIANTS NEEDED:
- Desktop (600px width)
- Mobile (full-width, 100vw)
```

### For Visily.ai / Wireframing Tools

```
SCREEN: Brief Creation Modal

COMPONENTS:
1. Modal overlay (full screen, dark semi-transparent)
2. Dialog box (white card, centered, 600px wide)

STRUCTURE (top to bottom):

[Header]
- Text: "Create New Brief" (left-aligned, bold)
- Icon button: X close (right-aligned)
- Divider line below

[Form Body - 24px padding]

Input 1: Brief Title
- Label above: "Brief Title *"
- Text input field (single line, 100 char limit)
- Placeholder: "e.g., Q1 Marketing Campaign"
- Error text area below (hidden by default)

Input 2: Brief Description  
- Label above: "Brief Description *"
- Multi-line text area (expandable, 200-400px height)
- Placeholder: "Describe what needs to be done in detail..."
- Character counter inside (bottom-right): "(0)"
- Help text below: "500-1000 characters recommended"
- Error text area below (hidden by default)

[Footer - 24px padding]
- Button: "Cancel" (secondary, left)
- Button: "Generate Tasks" (primary, right, with sparkles icon)

INTERACTIONS:
- Click overlay → Close dialog (with confirmation if form has content)
- Type in title → Update count, validate on blur
- Type in description → Update character count in real-time
- Click Cancel → Close dialog
- Click Generate Tasks → Submit form (if valid) or show errors

STATES:
- Default: Empty form, Generate button disabled
- Active: User typing, realtime updates
- Valid: Both fields meet requirements, button enabled
- Invalid: Show error messages, button disabled
- Loading: Generating tasks (spinner on button)

RESPONSIVE:
- Desktop: 600px centered modal
- Mobile: Full-screen modal
```

### For Uizard / Quick Prototyping

```
Create a "Brief Creation Dialog" screen

Layout Type: Modal/Dialog
Screen Size: 600px × Auto (Desktop), Full-screen (Mobile)

Elements:

ROW 1: Header
- [Text] "Create New Brief" - Bold, 18px
- [Button] Close (X icon) - Top-right corner

ROW 2: Title Input
- [Label] "Brief Title *" - 14px
- [Input] Single-line text field
  * Placeholder: "e.g., Q1 Marketing Campaign"
  * Max length: 100 characters
  * Height: 44px

ROW 3: Description Input
- [Label] "Brief Description *" - 14px
- [Textarea] Multi-line text field
  * Placeholder: "Describe what needs to be done..."
  * Min height: 200px
  * Character counter: Bottom-right inside
- [Text] Helper: "500-1000 characters recommended" - 12px, gray

ROW 4: Actions (Buttons in horizontal row)
- [Button] "Cancel" - Ghost style, left-aligned
- [Button] "Generate Tasks" - Primary style, right-aligned
  * Icon: Sparkles (✨)
  * States: Normal, Disabled, Loading

Spacing: 16px between rows, 12px between buttons

Colors:
- Background: White (#FFFFFF)
- Primary: Dark gray (#0f172a)
- Borders: Light gray (#e2e8f0)
- Text: Dark (#1e293b)
- Helper text: Medium gray (#64748b)
- Error: Red (#ef4444)
- Success: Green (#10b981)

Validation Rules:
- Title: Minimum 5 characters, required
- Description: Minimum 100 characters, required
- Show errors below fields in red
- Disable submit button when invalid
```

