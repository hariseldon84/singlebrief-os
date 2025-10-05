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
