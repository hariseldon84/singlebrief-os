# UI/UX Specification: Story 2.4 - My Tasks Inbox

**Story ID:** STORY-2.4
**Feature:** Personal Task Inbox for Team Members

## Layout
```
┌─────────────────────────────────────────┐
│ My Tasks                    [Filters]   │
├─────────────────────────────────────────┤
│ Tabs: [All] [To-Do] [In Progress] [Done│
├─────────────────────────────────────────┤
│ ┌─────────────────────────────────────┐ │
│ │ ● Research audience (Q1 Campaign)   │ │
│ │   Due: March 15 • Priority: High    │ │
│ └─────────────────────────────────────┘ │
│ ┌─────────────────────────────────────┐ │
│ │ ○ Write blog outline (Content)      │ │
│ │   Due: March 20 • Priority: Medium  │ │
│ └─────────────────────────────────────┘ │
└─────────────────────────────────────────┘
```

**Components:**
- Tabs for status filtering (All, To-Do, In Progress, Done)
- Task cards with: Status dot, title, brief name, due date, priority
- Empty state: "No tasks assigned to you"
- Sort options: Due date, priority, created date

**v0.dev Prompt:**
```
Create a personal task inbox page.
Requirements: Tabs for status filtering, task cards (status, title, brief name, due date, priority), empty state, sort dropdown, responsive, accessible.
Use shadcn/ui Tabs, Card, Select, Tailwind CSS.
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
