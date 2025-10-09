# Story 10.3: Help & Support Integration

**Story ID:** STORY-10.3
**Epic:** Epic 10 - User Settings & Profile Management
**Status:** ⬜ To Do
**Last Updated:** 2025-10-07

---

## User Story

**As a** user
**I want to** access help documentation and support resources from settings
**So that** I can learn how to use the system and get assistance when needed

---

## Acceptance Criteria

### Help Tab
- [ ] Settings page has "Help" tab (third tab after Profile and Notifications) (FR-HELP-01)
- [ ] Tab displays help and support resources

### Help Content Sections
- [ ] **Quick Start Guide** section (FR-HELP-02):
  - Link to "Getting Started" documentation
  - Brief description: "Learn the basics of creating briefs and managing tasks"
  - Opens in new tab/window
- [ ] **Video Tutorials** section:
  - Embedded video or link to video playlist
  - Brief description: "Watch step-by-step tutorials"
  - Videos cover: Brief creation, Task assignment, Review workflow
- [ ] **FAQs** section (FR-HELP-03):
  - Accordion component with 8-10 common questions
  - Questions cover: AI task generation, notifications, task statuses, team collaboration
  - Each answer includes concise explanation + link to detailed docs (if applicable)
- [ ] **Keyboard Shortcuts** section:
  - Table showing keyboard shortcuts (if any in MVP)
  - Example shortcuts: `Ctrl+N` (New Brief), `Ctrl+/` (Search)
  - Deferred to post-MVP if no shortcuts implemented yet

### Support Contact
- [ ] **Contact Support** section at bottom (FR-HELP-04):
  - Email: `support@singlebrief.com` (clickable mailto: link)
  - Brief description: "Need more help? Contact our support team"
  - Response time estimate: "We typically respond within 24 hours"

### Onboarding Modal Link
- [ ] **Restart Onboarding** button (FR-HELP-05):
  - Button text: "Restart Product Tour"
  - Clicking button reopens onboarding modal from Epic 2 Story 2.10
  - Confirmation dialog: "This will restart the product tour. Continue?"

### Documentation Links
- [ ] All external documentation links open in new tab (`target="_blank"`)
- [ ] Links use `rel="noopener noreferrer"` for security

---

## Technical Implementation

### Frontend (v0.dev + Claude Code)

**Component:** `HelpSupport.tsx`

**v0.dev Prompt:**
```
Create a help and support page with 5 sections:
1. Quick Start Guide - Card with icon, description, "Get Started" button
2. Video Tutorials - Card with embedded video or thumbnail + link
3. FAQs - Accordion component with 8-10 Q&A items
4. Keyboard Shortcuts - Table with shortcut keys and descriptions
5. Contact Support - Card with email (mailto:), response time estimate

Include "Restart Product Tour" button at bottom.

Use shadcn/ui components: Tabs, Card, Accordion, Button, Table.
Keep design clean and easy to scan.
```

**Claude Code Integration:**
```typescript
import { useState } from "react";
import { useToast } from "@/components/ui/use-toast";

// Restart onboarding handler
const handleRestartOnboarding = () => {
  // Show confirmation dialog
  const confirmed = window.confirm("This will restart the product tour. Continue?");
  if (!confirmed) return;

  // Reset onboarding completion flag
  localStorage.setItem('onboarding-completed', 'false');

  // Reload page to trigger onboarding modal
  window.location.reload();

  toast({ title: "Product tour restarted", variant: "success" });
};

// FAQs data
const faqs = [
  {
    question: "How does AI task generation work?",
    answer: "When you create a brief with a title and description, our AI analyzes the content and generates a breakdown of tasks. You can review, edit, or regenerate tasks before finalizing."
  },
  {
    question: "What are the different task statuses?",
    answer: "Tasks progress through: Queued → In Progress → Done → Accepted/Rejected. Managers review completed tasks and accept or reject them with feedback."
  },
  {
    question: "How do I assign tasks to team members?",
    answer: "After confirming AI-generated tasks, you can assign each task to a team member or an AI agent. Assigned users receive email and in-app notifications."
  },
  {
    question: "Can I customize notification settings?",
    answer: "Yes! Go to Settings → Notifications to control email and in-app notifications. You can enable/disable specific notification types, set Do Not Disturb hours, and mute individual briefs."
  },
  {
    question: "What happens when I reject a task output?",
    answer: "When you reject a task, it returns to 'In Progress' status. The assignee receives a notification with your rejection reason and can resubmit the output."
  },
  {
    question: "How do I track team progress?",
    answer: "The Dashboard shows summary analytics including brief completion %, team velocity, and active briefs. You can also view task lists filtered by status."
  },
  {
    question: "Can I edit a brief after creating it?",
    answer: "Briefs can be edited while in 'draft' status. Once tasks are generated and confirmed, the brief becomes active and cannot be edited (to maintain task integrity)."
  },
  {
    question: "What is the FAB (Floating Action Button)?",
    answer: "The FAB is the circular button at the bottom-right of your screen. It provides quick access to execute queued AI tasks with a single click."
  }
];

// External documentation URLs (replace with actual URLs)
const DOCS_BASE_URL = "https://docs.singlebrief.com";
const quickStartUrl = `${DOCS_BASE_URL}/getting-started`;
const videoPlaylistUrl = `${DOCS_BASE_URL}/video-tutorials`;
```

### Help Content Management

**Documentation Structure** (external):
- `docs.singlebrief.com/getting-started` - Quick start guide
- `docs.singlebrief.com/video-tutorials` - Video playlist
- `docs.singlebrief.com/briefs` - Brief creation guide
- `docs.singlebrief.com/tasks` - Task management guide
- `docs.singlebrief.com/notifications` - Notification settings guide

**Note:** For MVP, use placeholder links or inline documentation. External docs site deferred to post-MVP.

### Integration with Onboarding

**Reuse Onboarding Modal from Epic 2 Story 2.10:**

```typescript
// In HelpSupport.tsx
import { OnboardingModal } from "@/components/OnboardingModal";

const handleRestartOnboarding = () => {
  localStorage.setItem('onboarding-completed', 'false');
  setShowOnboarding(true);
};

// Render modal conditionally
{showOnboarding && <OnboardingModal onClose={() => setShowOnboarding(false)} />}
```

---

## Story Points

**3 points**

**Breakdown:**
- UI component (v0.dev + 5 sections): 1 point
- FAQs content writing: 0.5 point
- Onboarding modal integration: 0.5 point
- External links configuration: 0.5 point
- Testing: 0.5 point

---

## Dependencies

- **Epic 2 Story 2.10** - Onboarding modal exists (for "Restart Tour" button)
- **Story 10.1** - Settings page navigation exists
- External documentation URLs (can use placeholders for MVP)

---

## Testing Checklist

### Unit Tests
- [ ] FAQs render correctly (all 8 questions)
- [ ] Accordion expands/collapses on click
- [ ] Restart onboarding confirmation dialog appears
- [ ] Confirmation dialog cancels correctly (if user clicks Cancel)

### Integration Tests
- [ ] Restart onboarding resets localStorage flag
- [ ] Restart onboarding triggers modal display
- [ ] External links open in new tab
- [ ] External links use noopener/noreferrer

### E2E Tests (Playwright)
- [ ] Navigate to Settings → Help tab
- [ ] Help tab displays all 5 sections
- [ ] Click "Get Started" → opens documentation in new tab
- [ ] Click FAQ → accordion expands
- [ ] Click "Contact Support" → opens mailto: link
- [ ] Click "Restart Product Tour" → confirmation dialog appears
- [ ] Confirm restart → onboarding modal appears
- [ ] Cancel restart → modal does not appear

---

## Definition of Done

- [ ] All acceptance criteria met
- [ ] Unit tests written and passing
- [ ] Integration tests written and passing
- [ ] E2E test written and passing
- [ ] FAQs reviewed and approved by product owner
- [ ] Code reviewed and approved
- [ ] Merged to main branch
- [ ] Deployed to staging
- [ ] Product owner accepts story

---

## FRs Covered

- **FR-HELP-01**: Help tab in settings
- **FR-HELP-02**: Quick start guide link
- **FR-HELP-03**: FAQs with common questions
- **FR-HELP-04**: Contact support email
- **FR-HELP-05**: Restart onboarding functionality

---

## Notes

- Keep FAQs concise (1-2 sentences per answer)
- Update FAQs based on common user questions post-launch
- External documentation site can be built post-MVP (use inline help for now)
- Consider adding chat widget in future (Intercom, Drift)
- Keyboard shortcuts section can be hidden if no shortcuts in MVP

---

## Related Files

- **Component:** `/src/components/HelpSupport.tsx` (to be created)
- **Component:** `/src/components/OnboardingModal.tsx` (from Epic 2 Story 2.10)
- **PRD:** `/docs/prd/newscopemissing.md` - Epic 10, Story 10.3
- **Epic Stories:** `/docs/prd/epic10_stories.md`

---

**Last Updated:** 2025-10-07
**Assignee:** TBD
**Start Date:** TBD
**End Date:** TBD
