# UI/UX Specification: Story 2.1 - Task Assignment

**Story ID:** STORY-2.1
**Feature:** Assign Tasks to Team Members or AI Agents
**Design System:** shadcn/ui + Tailwind CSS

---

## 1. Screen Overview

**Purpose:** Enable managers to assign tasks to team members or AI agents via dropdown selector.

**User Flow:**
- Task card or detail view → "Assign to" dropdown
- Shows team members + AI agents
- Select assignee → Save + notify

**Success Criteria:**
- Clear distinction between humans and AI
- Quick assignment process
- Confirmation of assignment

---

## 2. Component Specifications

### Assignee Dropdown
```
┌────────────────────────────────┐
│ Assign to:                     │
│ ┌────────────────────────────┐ │
│ │ ▾ Select assignee...        │ │
│ └────────────────────────────┘ │
│                                │
│ Dropdown Menu:                 │
│ ┌────────────────────────────┐ │
│ │ 👤 TEAM MEMBERS            │ │
│ │ ──────────────────────────  │ │
│ │   Sarah Johnson           │ │
│ │   Mike Chen                │ │
│ │   Alex Kumar               │ │
│ │                             │ │
│ │ 🤖 AI AGENTS               │ │
│ │ ──────────────────────────  │ │
│ │   Content Writer Agent     │ │
│ │   Email Drafter Agent      │ │
│ │   Unassigned               │ │
│ └────────────────────────────┘ │
└────────────────────────────────┘
```

**Component:** `<Select>` (shadcn/ui) with grouped options
- **Human Section:** "👤 TEAM MEMBERS"
- **AI Section:** "🤖 AI AGENTS"
- **Default:** "Unassigned"

### Assignee Badge (After Assignment)
```
Assigned to: [Sarah Johnson] [X]
             │  Avatar + Name  │ Remove
```

- **Component:** Badge with avatar
- **Avatar:** Profile picture (human) or robot icon (AI)
- **Name:** Full name
- **Remove Button:** X icon to unassign

### AI Agent Indicator
- **Icon:** 🤖 Robot icon before name
- **Color:** Distinct color (purple/blue)
- **Tooltip:** "AI Agent - Auto-executes when queued"

---

## 3. Interaction Patterns

### Assign Task
1. Click dropdown or "Unassigned" badge
2. Dropdown opens with team list
3. User selects assignee
4. Dropdown closes
5. Badge appears with avatar + name
6. Auto-save to database
7. Notification sent to assignee (if human)
8. Toast: "Task assigned to Sarah Johnson"

### Unassign Task
1. Click X on assignee badge
2. Badge removed
3. Shows "Unassigned" state
4. Auto-save
5. Toast: "Task unassigned"

### Reassign Task
1. Click existing assignee badge
2. Dropdown opens
3. Select new assignee
4. Badge updates
5. Notifications sent to both (old + new)

---

## 4. Accessibility

**Keyboard:**
- Tab to dropdown
- Arrow keys to navigate options
- Enter to select
- Escape to close

**Screen Reader:**
```html
<label for="assignee-select">Assign to</label>
<select id="assignee-select" aria-label="Select task assignee">
  <optgroup label="Team Members">
    <option value="user-1">Sarah Johnson</option>
  </optgroup>
  <optgroup label="AI Agents">
    <option value="agent-1">Content Writer Agent</option>
  </optgroup>
</select>
```

---

## 5. v0.dev Prompt

```
Create a task assignment dropdown component.

Requirements:
- Grouped dropdown: Team Members + AI Agents sections
- Avatar icons for team members, robot icon for AI agents
- Selected assignee shown as badge with avatar + name + remove button
- "Unassigned" state when no assignee
- Auto-save on selection
- Toast notification on assignment/unassignment
- Notification sent to assignee (if human)
- Accessible (keyboard navigation, ARIA labels, groups)

Use shadcn/ui Select, Avatar, Badge, Tailwind CSS.
```
