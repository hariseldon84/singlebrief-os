# UI/UX Specification: Story 10.4 - Account Preferences

**Story ID:** STORY-10.4
**Feature:** Account Preferences & Settings Consolidation
**Design System:** shadcn/ui + Tailwind CSS

---

## 1. Screen Overview

### Purpose
Consolidate account-level preferences including task limit, timezone, and future-proofed settings (theme, language, email digest). Provide seamless auto-save experience.

### User Flow Entry Points
1. Settings page → Preferences tab (fourth tab)
2. User menu → Settings → Preferences
3. Brief creation flow → "Adjust task limit" link

### Success Criteria
- User can adjust task limit in <10 seconds
- Timezone auto-detected from browser
- Future settings clearly marked as "Coming soon"
- All changes auto-save without explicit save button

---

## 2. Layout Structure

```
┌─────────────────────────────────────────────────────────────┐
│  SETTINGS                                                    │
│  Profile  Notifications  Help  [Preferences]                │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  TASK GENERATION                                            │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Maximum Tasks per Brief                             │  │
│  │  ┌────────┐                                          │  │
│  │  │   15   │                                          │  │
│  │  └────────┘                                          │  │
│  │  Range: 5-30 tasks                                   │  │
│  │  Lower limits reduce AI costs but may require...    │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│  INTERFACE                                                  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Theme                           🔒 Coming Soon      │  │
│  │  ┌────────────────────────────────────────────────┐ │  │
│  │  │ System (follows OS)                        ▼   │ │  │
│  │  └────────────────────────────────────────────────┘ │  │
│  │  Options: Light | Dark | System                     │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│  LOCALIZATION                                               │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Language                        🔒 Coming Soon      │  │
│  │  ┌────────────────────────────────────────────────┐ │  │
│  │  │ English (US)                               ▼   │ │  │
│  │  └────────────────────────────────────────────────┘ │  │
│  │                                                       │  │
│  │  Timezone                                            │  │
│  │  ┌────────────────────────────────────────────────┐ │  │
│  │  │ America/New_York (Auto-detected)           ▼   │ │  │
│  │  └────────────────────────────────────────────────┘ │  │
│  │  Used for displaying due dates and notifications    │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│  EMAIL PREFERENCES                                          │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Email Digest Frequency          🔒 Coming Soon      │  │
│  │  ┌────────────────────────────────────────────────┐ │  │
│  │  │ None                                       ▼   │ │  │
│  │  └────────────────────────────────────────────────┘ │  │
│  │  Options: None | Daily | Weekly                     │  │
│  │  Receive a summary instead of individual emails     │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. Component Specifications

### 3.1 Task Limit Setting
**Component:** Number input
- **Label:** "Maximum Tasks per Brief"
- **Input:** Number input, min: 5, max: 30, default: 15
- **Validation:**
  - < 5: Error "Minimum 5 tasks required"
  - > 30: Error "Maximum 30 tasks allowed"
- **Description:** "Control how many tasks AI generates per brief. Lower limits reduce costs but may require multiple briefs."
- **Auto-save:** On blur

### 3.2 Theme Setting (Future-Proofed)
**Component:** Select dropdown (disabled)
- **Label:** "Theme" + 🔒 "Coming soon" badge
- **Options:** Light | Dark | System (follows OS)
- **Default:** System
- **State:** Grayed out, disabled
- **Tooltip:** "Theme switching coming soon"
- **Description:** "Choose your preferred interface theme"

### 3.3 Language Setting (Future-Proofed)
**Component:** Select dropdown (disabled)
- **Label:** "Language" + 🔒 "Coming soon" badge
- **Options:** English (US) - only option in MVP
- **Default:** English (US)
- **State:** Grayed out, disabled
- **Tooltip:** "Internationalization coming soon"

### 3.4 Timezone Setting
**Component:** Select dropdown (active)
- **Label:** "Timezone"
- **Options:** All major timezones (America/New_York, Europe/London, etc.)
- **Default:** Auto-detected from browser using `Intl.DateTimeFormat().resolvedOptions().timeZone`
- **Description:** "Used for displaying due dates and notification times"
- **Auto-save:** On change
- **Display Format:** "America/New_York (Auto-detected)" if auto-detected

### 3.5 Email Digest Setting (Future-Proofed)
**Component:** Select dropdown (disabled)
- **Label:** "Email Digest Frequency" + 🔒 "Coming soon" badge
- **Options:** None | Daily | Weekly
- **Default:** None
- **State:** Grayed out, disabled
- **Tooltip:** "Email digests coming soon"
- **Description:** "Receive a summary of all activity instead of individual emails"

---

## 4. Interaction Patterns

### 4.1 Task Limit Auto-Save
**User Flow:**
1. User changes value in number input
2. User blurs field (clicks away)
3. Validation checks (5-30 range)
4. If valid:
   - Auto-save to `user_settings.task_limit`
   - Toast: "Task limit updated to X"
5. If invalid:
   - Show error message below field
   - Toast: "Task limit must be between 5 and 30"

### 4.2 Timezone Auto-Detection
**On Page Load:**
1. Detect browser timezone: `Intl.DateTimeFormat().resolvedOptions().timeZone`
2. Query `user_settings.timezone`
3. If NULL, use detected timezone and save
4. Display in dropdown with "(Auto-detected)" label

**On Change:**
1. User selects new timezone from dropdown
2. Auto-save immediately
3. Toast: "Timezone updated to [timezone]"

### 4.3 Future Settings (Disabled State)
**Visual Treatment:**
- Dropdown grayed out (opacity 60%)
- Lock icon 🔒 next to label
- "Coming soon" badge in muted color
- Tooltip on hover: "This feature is coming soon"
- Not clickable/interactive

---

## 5. Timezone Options

**Major Timezones (Dropdown):**
- America/New_York (EST/EDT)
- America/Chicago (CST/CDT)
- America/Denver (MST/MDT)
- America/Los_Angeles (PST/PDT)
- Europe/London (GMT/BST)
- Europe/Paris (CET/CEST)
- Europe/Berlin (CET/CEST)
- Asia/Tokyo (JST)
- Asia/Shanghai (CST)
- Asia/Kolkata (IST)
- Australia/Sydney (AEDT/AEST)
- UTC (Coordinated Universal Time)

**Display Format:** "America/New_York (EST)" or "America/New_York (Auto-detected)"

---

## 6. v0.dev / Lovable AI Prompt

```
Create an account preferences page using React, TypeScript, and shadcn/ui.

LAYOUT:
- Settings tabs: Profile | Notifications | Help | [Preferences]
- 4 sections: Task Generation, Interface, Localization, Email

SECTION 1: TASK GENERATION
- Label: "Maximum Tasks per Brief"
- Number input: Min 5, Max 30, Default 15
- Description: "Control how many tasks AI generates per brief. Lower limits reduce costs..."
- Validation: Show error if <5 or >30
- Auto-save on blur

SECTION 2: INTERFACE
- Label: "Theme" + 🔒 "Coming soon" badge
- Dropdown: Light | Dark | System (grayed out, disabled)
- Tooltip: "Theme switching coming soon"

SECTION 3: LOCALIZATION
- Label: "Language" + 🔒 "Coming soon" badge
- Dropdown: English (US) only (grayed out, disabled)
- Tooltip: "Internationalization coming soon"

- Label: "Timezone"
- Dropdown: Major timezones (active, enabled)
- Default: Auto-detected from browser
- Description: "Used for displaying due dates and notification times"
- Auto-save on change

SECTION 4: EMAIL PREFERENCES
- Label: "Email Digest Frequency" + 🔒 "Coming soon" badge
- Dropdown: None | Daily | Weekly (grayed out, disabled)
- Description: "Receive a summary instead of individual emails"
- Tooltip: "Email digests coming soon"

AUTO-DETECTION:
- Timezone auto-detected using: Intl.DateTimeFormat().resolvedOptions().timeZone
- Display as "America/New_York (Auto-detected)"

AUTO-SAVE:
- Task limit: On blur
- Timezone: On change
- Toast notifications for success

FUTURE SETTINGS (DISABLED):
- Gray opacity: 60%
- Lock icon next to label
- "Coming soon" badge
- Tooltip on hover
- Not clickable

TECH STACK:
- React 18 + TypeScript
- shadcn/ui: Tabs, Input, Select, Card, Badge
- TanStack Query
- Supabase backend
- Tailwind CSS
```

---

## 7. Testing Checklist

- [ ] Task limit validates (5-30 range)
- [ ] Task limit auto-saves on blur
- [ ] Timezone auto-detects on load
- [ ] Timezone saves on change
- [ ] Future settings are grayed out
- [ ] Tooltips show on hover
- [ ] Settings persist after refresh

---

**Last Updated:** 2025-10-09
**Design Status:** Ready for Development
**Priority:** Medium (Epic 10 - Story 10.4)
