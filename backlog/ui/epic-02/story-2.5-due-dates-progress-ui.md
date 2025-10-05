# UI/UX Specification: Story 2.5 - Due Dates & Progress Tracking

**Story ID:** STORY-2.5
**Feature:** Due Date Picker + Progress Percentage

## Due Date Component
```
Due Date: [March 15, 2025] [📅]
          │ Date display      │ Calendar icon
          
Calendar Picker:
┌──────────────────────┐
│  March 2025    < >   │
├──────────────────────┤
│ S  M  T  W  T  F  S  │
│ 1  2  3  4  5  6  7  │
│ 8  9 10 11 12 13 14  │
│15 16 17 18 19 20 21  │
│22 23 24 25 26 27 28  │
└──────────────────────┘
```

**Component:** `<DatePicker>` (shadcn/ui)
- Click date or calendar icon → open calendar
- Select date → auto-save
- Clear button to remove due date
- Visual indicators: Overdue (red), Due today (orange), Upcoming (blue)

## Progress Tracker
```
Progress: [━━━━━━━━━━] 65%
          │ Slider      │ Percentage
```

**Component:** `<Slider>` (shadcn/ui)
- Range: 0-100%
- Step: 5%
- Visual feedback with color gradient
- Auto-save on change

**v0.dev Prompt:**
```
Create due date picker and progress tracker components.
Requirements: Calendar date picker (shadcn DatePicker), visual indicators for overdue/due today, progress slider (0-100%, step 5%), auto-save, accessible.
Use shadcn/ui DatePicker, Slider, Tailwind CSS.
```

---

## AI Generation Prompts

### v0.dev / Lovable
```
[Implement this feature using React 18 + TypeScript + shadcn/ui components]
Key components: [List from spec above]
Key interactions: [From interaction patterns above]
Responsive: Mobile-first, follows breakpoints specified
Accessible: WCAG 2.1 AA compliant with keyboard navigation
Use React Hook Form for forms, TanStack Query for data fetching
```

### Figma AI
```
[Design this interface following the specifications above]
Create component variants for all states mentioned
Use the design tokens (colors, spacing, typography) specified
Ensure proper auto-layout structure for responsive design
```

### Quick Prompt (All Tools)
```
[Feature name from above]
Components: [Key UI elements]
Layout: [Main structure]  
States: [Empty, loading, active, error, success as applicable]
Styling: shadcn/ui + Tailwind CSS
Interactions: [Key user actions]
```

**Complete specifications available in sections above**
