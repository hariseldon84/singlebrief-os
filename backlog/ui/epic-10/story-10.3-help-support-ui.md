# UI/UX Specification: Story 10.3 - Help & Support Integration

**Story ID:** STORY-10.3
**Feature:** Help & Support Resources Page
**Design System:** shadcn/ui + Tailwind CSS

---

## 1. Screen Overview

### Purpose
Provide users with self-service help resources, FAQs, video tutorials, and support contact information. Enable users to restart onboarding tour and access documentation.

### User Flow Entry Points
1. Settings page → Help tab (third tab)
2. User menu → "Help & Support"
3. Question mark icon in header (global access)

### Success Criteria
- User can find answers to common questions in <1 minute
- Video tutorials accessible with one click
- Support contact information clearly visible
- Onboarding tour restartable with confirmation

---

## 2. Layout Structure

```
┌─────────────────────────────────────────────────────────────┐
│  SETTINGS                                                    │
│  Profile  Notifications  [Help]  Preferences                │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  QUICK START GUIDE                                          │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  📚 Getting Started                                   │  │
│  │  Learn the basics of creating briefs and managing... │  │
│  │                                  [Get Started →]      │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│  VIDEO TUTORIALS                                            │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  🎥 Watch Step-by-Step Tutorials                     │  │
│  │  [Video thumbnail or link]                            │  │
│  │                                  [Watch Videos →]     │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│  FREQUENTLY ASKED QUESTIONS                                 │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  ▶ How does AI task generation work?                 │  │
│  │  ▶ What are the different task statuses?            │  │
│  │  ▶ How do I assign tasks to team members?           │  │
│  │  ▶ Can I customize notification settings?           │  │
│  │  ▶ What happens when I reject a task output?        │  │
│  │  ▶ How do I track team progress?                    │  │
│  │  ▶ Can I edit a brief after creating it?            │  │
│  │  ▶ What is the FAB (Floating Action Button)?        │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│  CONTACT SUPPORT                                            │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  📧 Need more help? Contact our support team         │  │
│  │  Email: support@singlebrief.com                      │  │
│  │  Response time: Usually within 24 hours              │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│  PRODUCT TOUR                                               │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  🎯 Restart Product Tour                             │  │
│  │  Go through the onboarding guide again               │  │
│  │                              [Restart Tour]           │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. Component Specifications

### 3.1 Quick Start Guide Card
**Component:** `<Card>` with icon, text, and button
- **Icon:** 📚 or BookOpen (Lucide)
- **Title:** "Getting Started"
- **Description:** "Learn the basics of creating briefs and managing tasks"
- **Button:** "Get Started →" (link to docs, opens new tab)
- **URL:** `https://docs.singlebrief.com/getting-started`

### 3.2 Video Tutorials Card
**Component:** `<Card>` with video thumbnail/embed
- **Icon:** 🎥 or Video (Lucide)
- **Title:** "Watch Step-by-Step Tutorials"
- **Content:** Embedded video or thumbnail with play button
- **Topics:** Brief creation, Task assignment, Review workflow
- **Button:** "Watch Videos →" (link to playlist, opens new tab)
- **URL:** `https://docs.singlebrief.com/video-tutorials`

### 3.3 FAQs Section
**Component:** `<Accordion>` (shadcn/ui)
- **8 Common Questions:**
  1. How does AI task generation work?
  2. What are the different task statuses?
  3. How do I assign tasks to team members?
  4. Can I customize notification settings?
  5. What happens when I reject a task output?
  6. How do I track team progress?
  7. Can I edit a brief after creating it?
  8. What is the FAB (Floating Action Button)?

**Each FAQ Item:**
- **Question:** Bold, collapsible header with chevron icon
- **Answer:** 1-2 sentences, concise explanation
- **Optional Link:** "Learn more →" to detailed docs

### 3.4 Contact Support Card
**Component:** `<Card>` with contact info
- **Icon:** 📧 or Mail (Lucide)
- **Description:** "Need more help? Contact our support team"
- **Email:** `support@singlebrief.com` (mailto: link, blue color)
- **Response Time:** "We typically respond within 24 hours"

### 3.5 Restart Product Tour Card
**Component:** `<Card>` with button
- **Icon:** 🎯 or RotateCcw (Lucide)
- **Title:** "Restart Product Tour"
- **Description:** "Go through the onboarding guide again"
- **Button:** "Restart Tour" (outline variant)
- **Action:** Opens onboarding modal from Epic 2 Story 2.10

---

## 4. Interaction Patterns

### 4.1 External Link Behavior
- All documentation links open in new tab (`target="_blank"`)
- Security: Use `rel="noopener noreferrer"`
- Visual indicator: External link icon (↗) next to link text

### 4.2 FAQ Accordion
- Click question → Expands to show answer
- Click again → Collapses answer
- Only one FAQ open at a time (optional)
- Smooth expand/collapse animation (200ms)

### 4.3 Contact Support
- Click email → Opens default mail client with mailto:
- Pre-filled subject: "SingleBrief Support Request"
- Body template: "Hi Support Team,\n\n[Describe your issue here]\n\nThanks!"

### 4.4 Restart Product Tour
**Flow:**
1. Click "Restart Tour" button
2. Confirmation dialog appears: "This will restart the product tour. Continue?"
3. If Cancel → Dialog closes, no action
4. If Continue:
   - Reset `onboarding-completed` flag in localStorage to 'false'
   - Reload page or trigger onboarding modal
   - Toast: "Product tour restarted"

---

## 5. FAQ Content

1. **How does AI task generation work?**
   "When you create a brief with a title and description, our AI analyzes the content and generates a breakdown of tasks. You can review, edit, or regenerate tasks before finalizing."

2. **What are the different task statuses?**
   "Tasks progress through: Queued → In Progress → Done → Accepted/Rejected. Managers review completed tasks and accept or reject them with feedback."

3. **How do I assign tasks to team members?**
   "After confirming AI-generated tasks, you can assign each task to a team member or an AI agent. Assigned users receive email and in-app notifications."

4. **Can I customize notification settings?**
   "Yes! Go to Settings → Notifications to control email and in-app notifications. You can enable/disable specific notification types, set Do Not Disturb hours, and mute individual briefs."

5. **What happens when I reject a task output?**
   "When you reject a task, it returns to 'In Progress' status. The assignee receives a notification with your rejection reason and can resubmit the output."

6. **How do I track team progress?**
   "The Dashboard shows summary analytics including brief completion %, team velocity, and active briefs. You can also view task lists filtered by status."

7. **Can I edit a brief after creating it?**
   "Briefs can be edited while in 'draft' status. Once tasks are generated and confirmed, the brief becomes active and cannot be edited (to maintain task integrity)."

8. **What is the FAB (Floating Action Button)?**
   "The FAB is the circular button at the bottom-right of your screen. It provides quick access to execute queued AI tasks with a single click."

---

## 6. v0.dev / Lovable AI Prompt

```
Create a help and support page using React, TypeScript, and shadcn/ui.

LAYOUT:
- Settings tabs: Profile | Notifications | [Help] | Preferences
- Help tab contains 5 sections vertically stacked

SECTION 1: QUICK START GUIDE (Card)
- Icon: 📚 or BookOpen
- Title: "Getting Started"
- Description: "Learn the basics of creating briefs and managing tasks"
- Button: "Get Started →" (opens docs in new tab)

SECTION 2: VIDEO TUTORIALS (Card)
- Icon: 🎥 or Video
- Title: "Watch Step-by-Step Tutorials"
- Embedded video or thumbnail with play icon
- Button: "Watch Videos →" (opens playlist in new tab)

SECTION 3: FAQs (Accordion)
- 8 collapsible Q&A items:
  1. How does AI task generation work?
  2. What are the different task statuses?
  3. How do I assign tasks to team members?
  4. Can I customize notification settings?
  5. What happens when I reject a task output?
  6. How do I track team progress?
  7. Can I edit a brief after creating it?
  8. What is the FAB (Floating Action Button)?
- Each answer: 1-2 sentences, concise
- Optional "Learn more →" links to detailed docs

SECTION 4: CONTACT SUPPORT (Card)
- Icon: 📧 or Mail
- Description: "Need more help? Contact our support team"
- Email: support@singlebrief.com (mailto: link, blue)
- Response time: "We typically respond within 24 hours"

SECTION 5: RESTART PRODUCT TOUR (Card)
- Icon: 🎯 or RotateCcw
- Title: "Restart Product Tour"
- Description: "Go through the onboarding guide again"
- Button: "Restart Tour" (outline variant)
- On click:
  * Show confirmation: "This will restart the product tour. Continue?"
  * If yes: Reset localStorage flag, reload/show onboarding modal

BEHAVIOR:
- All external links open in new tab (target="_blank", rel="noopener noreferrer")
- FAQ accordion: Click to expand/collapse (one at a time)
- Email link opens mailto: with pre-filled subject/body
- Restart tour shows confirmation before resetting

TECH STACK:
- React 18 + TypeScript
- shadcn/ui: Tabs, Card, Accordion, Button
- Lucide icons
- Tailwind CSS
```

---

## 7. Testing Checklist

- [ ] All 5 sections display correctly
- [ ] External links open in new tab
- [ ] FAQ accordion expands/collapses
- [ ] Email link opens mailto:
- [ ] Restart tour shows confirmation
- [ ] Restart tour resets onboarding flag
- [ ] Onboarding modal appears after restart

---

**Last Updated:** 2025-10-09
**Design Status:** Ready for Development
**Priority:** Medium (Epic 10 - Story 10.3)
