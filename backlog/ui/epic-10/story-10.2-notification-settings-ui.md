# UI/UX Specification: Story 10.2 - Notification Settings

**Story ID:** STORY-10.2
**Feature:** Email & In-App Notification Settings
**Design System:** shadcn/ui + Tailwind CSS

---

## 1. Screen Overview

### Purpose
Provide granular control over email and in-app notifications. Allow users to customize notification preferences, set Do Not Disturb hours, and mute specific briefs.

### User Flow Entry Points
1. Settings page → Notifications tab (second tab)
2. User menu → Settings → Notifications
3. Notification itself → "Manage preferences" link

### Success Criteria
- User can configure all 16 notification toggles in <2 minutes
- Clear visual hierarchy between master and sub-toggles
- DND hours easy to set and understand
- Brief muting intuitive and immediate

---

## 2. Layout Structure

```
┌─────────────────────────────────────────────────────────────┐
│  SETTINGS                                                    │
│  Profile  [Notifications]  Help  Preferences                │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  MASTER TOGGLES                                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Email Notifications           [ON ]                 │  │
│  │  In-App Notifications          [ON ]                 │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│  NOTIFICATION TYPES                                         │
│  ┌──────────────────────────────────────────────────────┐  │
│  │                      │  Email  │  In-App  │           │  │
│  ├──────────────────────┼─────────┼──────────┤           │  │
│  │  Task Assigned       │  [ON ]  │  [ON  ]  │           │  │
│  │  Output Submitted    │  [ON ]  │  [ON  ]  │           │  │
│  │  Task Accepted       │  [ON ]  │  [ON  ]  │           │  │
│  │  Task Rejected       │  [ON ]  │  [ON  ]  │           │  │
│  │  @Mention            │  [ON ]  │  [ON  ]  │           │  │
│  │  AI Tasks Completed  │  [ON ]  │  [ON  ]  │           │  │
│  │  Overdue Reminder    │  [OFF]  │  [ON  ]  │           │  │
│  │  Queued AI Reminder  │  [OFF]  │  [ON  ]  │           │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│  DO NOT DISTURB (Email Only)                                │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  No email notifications during these hours:          │  │
│  │                                                       │  │
│  │  From: [9:00 PM ▼]    To: [9:00 AM ▼]              │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│  MUTE SPECIFIC BRIEFS                                       │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  [Select brief... ▼]               [Mute Brief]      │  │
│  │                                                       │  │
│  │  Muted Briefs:                                        │  │
│  │  • Q1 Marketing Campaign          [Unmute]           │  │
│  │  • Website Redesign               [Unmute]           │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│                                          [Save Changes]      │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. Component Specifications

### 3.1 Master Toggle Section
**Component:** Card with 2 toggle switches
- **Email Notifications:** Master toggle for all email
- **In-App Notifications:** Master toggle for in-app
- **Style:** Large, prominent switches
- **Behavior:** Disabling master grays out all sub-toggles for that channel

### 3.2 Notification Types Grid
**Component:** Table-like grid
- **Header Row:** Column labels (Notification Type | Email | In-App)
- **Data Rows:** 8 notification types × 2 channels = 16 toggles
- **Toggle Component:** `<Switch>` (shadcn/ui)
- **Disabled State:** Gray background when master toggle OFF

**8 Notification Types:**
1. Task Assigned (default: ON)
2. Output Submitted (Manager only, default: ON)
3. Task Accepted (default: ON)
4. Task Rejected (Team Member only, default: ON)
5. @Mention in Comments (default: ON)
6. AI Tasks Completed (Manager only, default: ON)
7. Overdue Task Reminder (email default: OFF, in-app: ON)
8. Queued AI Tasks Reminder (email default: OFF, in-app: ON)

### 3.3 Do Not Disturb Section
**Component:** Card with time pickers
- **Description:** "No email notifications will be sent during these hours"
- **From Time:** Dropdown select (12-hour or 24-hour format)
- **To Time:** Dropdown select
- **Default:** 9:00 PM to 9:00 AM
- **Note:** "DND applies to email only"

**Time Options:** Every hour (0:00 - 23:00 or 12:00 AM - 11:00 PM)

### 3.4 Mute Briefs Section
**Component:** Card with dropdown and list
- **Brief Selector:** Dropdown showing active briefs owned by user
- **Mute Button:** Primary button next to dropdown
- **Muted List:** Vertical list with unmute buttons
  - Brief title (truncated to 50 chars)
  - Unmute button (outline variant)

### 3.5 Save Changes Button
**Component:** `<Button>` variant="default"
- **Text:** "Save Changes"
- **Position:** Bottom-right
- **Disabled:** Until changes made
- **Loading State:** Spinner + "Saving..."

---

## 4. Interaction Patterns

### 4.1 Master Toggle Behavior
**Email Notifications OFF:**
- All email sub-toggles become disabled (grayed out)
- User cannot change individual email toggles
- Visual feedback: Reduced opacity (60%)

**In-App Notifications OFF:**
- All in-app sub-toggles disabled
- Same visual treatment

### 4.2 Individual Toggle Changes
- Click toggle → Switches state (ON/OFF)
- "Save Changes" button becomes enabled
- Changes not applied until saved

### 4.3 DND Hours
- Click From/To dropdown → Select time
- "Save Changes" button becomes enabled
- Times can cross midnight (e.g., 9 PM to 9 AM)

### 4.4 Mute Brief Flow
1. Click brief selector dropdown
2. Select brief from active briefs list
3. Click "Mute Brief" button
4. Brief added to muted list below
5. Dropdown clears selection
6. "Save Changes" button enabled

### 4.5 Unmute Brief
1. Click "Unmute" button next to muted brief
2. Brief removed from muted list
3. "Save Changes" button enabled

### 4.6 Save All Changes
1. Click "Save Changes"
2. Button shows loading state
3. Update `user_settings` table (18 fields + DND)
4. Update `user_brief_mutes` table (insert/delete)
5. Success toast: "Notification settings updated successfully"
6. Button disabled again

---

## 5. v0.dev / Lovable AI Prompt

```
Create a notification settings page using React, TypeScript, and shadcn/ui.

LAYOUT:
- Settings tabs: Profile | [Notifications] | Help | Preferences
- Notifications tab contains 4 sections

SECTION 1: MASTER TOGGLES
- Two large toggle switches:
  * Email Notifications (ON by default)
  * In-App Notifications (ON by default)
- Disabling master toggle grays out all sub-toggles for that channel

SECTION 2: NOTIFICATION TYPES GRID
- Table-like layout: Notification Type | Email | In-App
- 8 rows × 2 columns of toggle switches (16 total):
  1. Task Assigned: Email[ON] InApp[ON]
  2. Output Submitted: Email[ON] InApp[ON]
  3. Task Accepted: Email[ON] InApp[ON]
  4. Task Rejected: Email[ON] InApp[ON]
  5. @Mention: Email[ON] InApp[ON]
  6. AI Tasks Completed: Email[ON] InApp[ON]
  7. Overdue Reminder: Email[OFF] InApp[ON]
  8. Queued AI Reminder: Email[OFF] InApp[ON]
- Sub-toggles disabled when master toggle OFF (gray, opacity 60%)

SECTION 3: DO NOT DISTURB
- Label: "Do Not Disturb (Email Only)"
- Description: "No email notifications during these hours"
- From time dropdown: Default 9:00 PM
- To time dropdown: Default 9:00 AM
- Time options: 12-hour format with AM/PM

SECTION 4: MUTE SPECIFIC BRIEFS
- Brief selector dropdown (shows active briefs)
- "Mute Brief" button
- Muted briefs list:
  * Each entry: Brief title + "Unmute" button
  * Click unmute → Remove from list

SAVE BUTTON:
- Bottom-right: "Save Changes"
- Disabled until changes made
- Loading state: Spinner + "Saving..."
- On save:
  * Update user_settings table (18 toggles + DND hours)
  * Update user_brief_mutes table
  * Toast: "Notification settings updated successfully"

BEHAVIOR:
- Master toggle OFF → Sub-toggles disabled for that channel
- All changes staged until "Save Changes" clicked
- Toast notifications for success/error

TECH STACK:
- React 18 + TypeScript
- shadcn/ui: Tabs, Switch, Select, Button, Card
- TanStack Query for data fetching
- Supabase backend
- Tailwind CSS
```

---

## 6. Testing Checklist

- [ ] Master toggles disable/enable sub-toggles
- [ ] All 16 individual toggles work
- [ ] DND hours save correctly
- [ ] Brief muting/unmuting works
- [ ] Save button enabled only when dirty
- [ ] Settings persist after page refresh
- [ ] n8n workflows respect settings

---

**Last Updated:** 2025-10-09
**Design Status:** Ready for Development
**Priority:** High (Epic 10 - Story 10.2)
