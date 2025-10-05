# UI/UX Specification: Story 2.2 - Task Status Management

**Story ID:** STORY-2.2
**Feature:** Task Status Dropdown (To-Do, In Progress, Done, Archived)

## Component: Status Badge with Dropdown

```
Current Status: [● In Progress ▾]
                   │ Color-coded badge

Dropdown Options:
┌──────────────────┐
│ ○ To-Do          │
│ ● In Progress    │
│ ✓ Done           │
│ □ Archived       │
└──────────────────┘
```

**Status Colors:**
- To-Do: Gray (`bg-gray-100 text-gray-700`)
- In Progress: Blue (`bg-blue-100 text-blue-700`)
- Done: Green (`bg-green-100 text-green-700`)
- Archived: Red (`bg-red-100 text-red-700`)

**Component:** `<DropdownMenu>` (shadcn/ui) + `<Badge>`
- Click badge → dropdown opens
- Select status → auto-save + log to history
- Icon indicators for each status
- Keyboard: Arrow keys navigate, Enter selects

**v0.dev Prompt:**
```
Create a task status dropdown badge.
Requirements: 4 statuses (To-Do, In Progress, Done, Archived), color-coded badges, dropdown menu, auto-save on change, status change logged to task_history, accessible (keyboard navigation).
Use shadcn/ui DropdownMenu, Badge, Tailwind CSS.
```
