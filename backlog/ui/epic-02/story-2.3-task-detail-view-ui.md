# UI/UX Specification: Story 2.3 - Task Detail View

**Story ID:** STORY-2.3
**Feature:** Comprehensive Task Detail Modal/Page

## Layout Structure
```
┌──────────────────────────────────────────┐
│ ← Back to Brief      Task #3      [X]    │
├──────────────────────────────────────────┤
│ [● In Progress]  Assigned to: Sarah J.   │
│                                          │
│ Research target audience demographics   │
│ ══════════════════════════════════════   │
│                                          │
│ Description                              │
│ Analyze current customer data and...    │
│                                          │
│ Due Date: March 15, 2025                 │
│ Priority: High                           │
│                                          │
│ ──────────────────────────────────────   │
│                                          │
│ Output URL:                              │
│ ┌────────────────────────────────────┐  │
│ │ https://docs.google.com/...        │  │
│ └────────────────────────────────────┘  │
│                                          │
│ [Submit for Review]                      │
└──────────────────────────────────────────┘
```

**Sections:**
1. **Header:** Task number + close button
2. **Status Bar:** Status badge + assignee
3. **Title:** Large, bold (24px)
4. **Description:** Multi-line text, markdown supported
5. **Metadata:** Due date, priority, created/updated times
6. **Output:** URL input field
7. **Actions:** Submit for review, edit, delete

**Component:** Full-page view or large modal (800px width)
- Responsive: Full-screen on mobile
- Accessible: Focus trap, Escape to close
- Auto-save: Changes saved on blur

**v0.dev Prompt:**
```
Create a task detail view component.
Requirements: Header with back button, status badge, assignee, title, description, due date, priority, output URL input, submit button, responsive (full-screen mobile, 800px modal desktop), accessible.
Use shadcn/ui Dialog, Input, Button, Badge, Tailwind CSS.
```
