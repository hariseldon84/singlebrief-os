# SingleBrief UI/UX Specifications

**Complete UI/UX design specifications for Figma implementation**

This directory contains comprehensive UI/UX specifications for all 44 stories across 8 epics. Each specification is production-ready for Figma designers to implement directly without additional clarification.

---

## 📁 Directory Structure

```
backlog/ui/
├── README.md (this file)
├── epic-01/ (8 stories - Brief Creation)
├── epic-02/ (10 stories - Task Management)
├── epic-03/ (5 stories - AI Agents)
├── epic-04/ (6 stories - Review Workflow)
├── epic-05/ (5 stories - Collaboration)
├── epic-06/ (4 stories - Search & Navigation)
├── epic-07/ (4 stories - Why This Matters)
└── epic-08/ (2 stories - Authentication)
```

**Total:** 44 UI/UX specifications ready for Figma design

---

## 🎨 Design System

### Technology Stack
- **Framework:** React 18 + TypeScript
- **UI Library:** shadcn/ui (Radix UI primitives + Tailwind CSS)
- **State Management:** TanStack Query (React Query)
- **Backend:** Supabase
- **Styling:** Tailwind CSS with custom configuration

### Design System Resources
- **shadcn/ui Components:** https://ui.shadcn.com/docs/components
- **Radix UI Primitives:** https://www.radix-ui.com/primitives
- **Tailwind CSS:** https://tailwindcss.com/docs
- **Color Palette:** HSL-based (defined in each spec)

### Common Design Tokens

**Colors (HSL Format):**
```css
--background: hsl(0 0% 100%)              /* White */
--foreground: hsl(240 10% 3.9%)           /* Near black */
--primary: hsl(240 5.9% 10%)              /* Primary actions */
--muted-foreground: hsl(240 3.8% 46.1%)   /* Helper text */
--border: hsl(240 5.9% 90%)               /* Borders */
--destructive: hsl(0 84.2% 60.2%)         /* Error red */
--success: hsl(142 71% 45%)               /* Success green */
--warning: hsl(38 92% 50%)                /* Warning orange */
```

**Spacing Scale:**
- 4px (--spacing-1)
- 8px (--spacing-2)
- 12px (--spacing-3)
- 16px (--spacing-4)
- 24px (--spacing-6)
- 32px (--spacing-8)

**Typography:**
- Font Family: Inter (primary), system font fallbacks
- Scale: 12px, 14px, 16px, 18px, 24px, 32px
- Weights: 400 (normal), 500 (medium), 600 (semibold), 700 (bold)

**Border Radius:**
- Small: 4px (`rounded-sm`)
- Medium: 8px (`rounded-lg`)
- Large: 12px (`rounded-xl`)

---

## 📋 Epic Summaries

### Epic 1: Brief Creation (8 stories)
**Purpose:** Core brief creation flow with AI task generation

| Story | Feature | Complexity | File |
|-------|---------|------------|------|
| 1.1 | Basic Brief Creation Dialog | Medium | `epic-01/story-1.1-basic-brief-creation-ui.md` |
| 1.2 | AI Task Breakdown & Progressive Disclosure | High | `epic-01/story-1.2-ai-task-breakdown-ui.md` |
| 1.3 | Progressive Confirmation (5 at a time) | Medium | `epic-01/story-1.3-progressive-confirmation-ui.md` |
| 1.4 | Inline Task Editing | Medium | `epic-01/story-1.4-inline-task-editing-ui.md` |
| 1.5 | Task Regeneration | Medium | `epic-01/story-1.5-task-regeneration-ui.md` |
| 1.6 | Draft Auto-Save | Low | `epic-01/story-1.6-draft-saving-ui.md` |
| 1.7 | Brief Templates | Medium | `epic-01/story-1.7-brief-templates-ui.md` |
| 1.8 | Task Limit Settings | Low | `epic-01/story-1.8-task-limit-settings-ui.md` |

**Key Components:** Dialog, Form, Input, Textarea, Button, Checkbox, Alert

---

### Epic 2: Task Management (10 stories)
**Purpose:** Comprehensive task management and assignment

| Story | Feature | Complexity | File |
|-------|---------|------------|------|
| 2.1 | Task Assignment Dropdown | Medium | `epic-02/story-2.1-task-assignment-ui.md` |
| 2.2 | Task Status Management | Low | `epic-02/story-2.2-task-status-ui.md` |
| 2.3 | Task Detail View | High | `epic-02/story-2.3-task-detail-view-ui.md` |
| 2.4 | My Tasks Inbox | Medium | `epic-02/story-2.4-my-tasks-inbox-ui.md` |
| 2.5 | Due Dates & Progress | Medium | `epic-02/story-2.5-due-dates-progress-ui.md` |
| 2.6 | Priority System | Low | `epic-02/story-2.6-priority-system-ui.md` |
| 2.7 | Quick-Add Task | Low | `epic-02/story-2.7-quick-add-task-ui.md` |
| 2.8 | Bulk Task Actions | Medium | `epic-02/story-2.8-bulk-actions-ui.md` |
| 2.9 | Task Soft Delete | Low | `epic-02/story-2.9-task-deletion-ui.md` |
| 2.10 | Onboarding Welcome Modal | Medium | `epic-02/story-2.10-onboarding-ui.md` |

**Key Components:** Select, Badge, DatePicker, Slider, Tabs, Card, Checkbox

---

### Epic 3: AI Agents (5 stories)
**Purpose:** AI agent integration and task automation

| Story | Feature | Complexity | File |
|-------|---------|------------|------|
| 3.1 | AI Agent Accounts | Low | `epic-03/story-3.1-ai-agent-accounts-ui.md` |
| 3.2 | Task Queuing for Agents | Medium | `epic-03/story-3.2-task-queuing-ui.md` |
| 3.3 | Batch Execution FAB | Low | `epic-03/story-3.3-batch-execution-fab-ui.md` |
| 3.4 | AI Context Window Display | Medium | `epic-03/story-3.4-context-window-ui.md` |
| 3.5 | Agent Error Handling | Low | `epic-03/story-3.5-error-handling-ui.md` |

**Key Components:** Badge (robot icons), FAB, Dialog, Alert

---

### Epic 4: Review Workflow (6 stories)
**Purpose:** Manager review and approval process

| Story | Feature | Complexity | File |
|-------|---------|------------|------|
| 4.1 | Submit for Review | Low | `epic-04/story-4.1-submit-review-ui.md` |
| 4.2 | Review Queue Dashboard | Medium | `epic-04/story-4.2-review-dashboard-ui.md` |
| 4.3 | Approve/Reject Flow | Medium | `epic-04/story-4.3-approve-reject-ui.md` |
| 4.4 | Iteration Tracking | Low | `epic-04/story-4.4-iteration-tracking-ui.md` |
| 4.5 | Output Version History | Medium | `epic-04/story-4.5-version-history-ui.md` |
| 4.6 | Review Notifications | Low | `epic-04/story-4.6-review-notifications-ui.md` |

**Key Components:** Button, Textarea, Badge, Timeline, Alert

---

### Epic 5: Collaboration (5 stories)
**Purpose:** Team collaboration and communication

| Story | Feature | Complexity | File |
|-------|---------|------------|------|
| 5.1 | Real-time Notifications | High | `epic-05/story-5.1-notifications-ui.md` |
| 5.2 | Task Comments | Medium | `epic-05/story-5.2-task-comments-ui.md` |
| 5.3 | @Mentions | Medium | `epic-05/story-5.3-mentions-ui.md` |
| 5.4 | Task Activity Feed | Medium | `epic-05/story-5.4-activity-feed-ui.md` |
| 5.5 | User Presence Indicators | Medium | `epic-05/story-5.5-presence-ui.md` |

**Key Components:** Popover, Textarea, Avatar, Timeline, Badge

---

### Epic 6: Search & Navigation (4 stories)
**Purpose:** Global search and navigation

| Story | Feature | Complexity | File |
|-------|---------|------------|------|
| 6.1 | Global Search | High | `epic-06/story-6.1-global-search-ui.md` |
| 6.2 | Search Filters | Medium | `epic-06/story-6.2-search-filters-ui.md` |
| 6.3 | Recent Items | Low | `epic-06/story-6.3-recent-items-ui.md` |
| 6.4 | Keyboard Shortcuts | Medium | `epic-06/story-6.4-keyboard-shortcuts-ui.md` |

**Key Components:** Command, Input, Badge, Dialog

---

### Epic 7: Why This Matters (4 stories)
**Purpose:** Business context and value framing

| Story | Feature | Complexity | File |
|-------|---------|------------|------|
| 7.1 | Why This Matters Field | Low | `epic-07/story-7.1-why-field-ui.md` |
| 7.2 | Why This Matters Display | Low | `epic-07/story-7.2-why-display-ui.md` |
| 7.3 | Context Preservation | Low | `epic-07/story-7.3-context-preservation-ui.md` |
| 7.4 | Why Analytics Dashboard | Medium | `epic-07/story-7.4-why-analytics-ui.md` |

**Key Components:** Textarea, Card, Collapsible, Chart

---

### Epic 8: Authentication (2 stories)
**Purpose:** User authentication and profile management

| Story | Feature | Complexity | File |
|-------|---------|------------|------|
| 8.1 | Supabase Auth Integration | Medium | `epic-08/story-8.1-supabase-auth-ui.md` |
| 8.2 | User Profile Management | Low | `epic-08/story-8.2-profile-management-ui.md` |

**Key Components:** Form, Input, Button, Avatar Upload

---

## 🎯 Implementation Priority

### Phase 1: Core MVP (Weeks 1-2)
**Epic 1 + Epic 8**
- Authentication (8.1, 8.2)
- Brief creation (1.1, 1.2)
- Task generation (1.3, 1.4, 1.5)
- Auto-save (1.6)

### Phase 2: Task Management (Week 2)
**Epic 2**
- Task assignment (2.1)
- Status management (2.2)
- Task detail view (2.3)
- My Tasks inbox (2.4)

### Phase 3: AI & Review (Week 3)
**Epic 3 + Epic 4**
- AI agents (3.1, 3.2, 3.3)
- Review workflow (4.1, 4.2, 4.3)
- Error handling (3.5)

### Phase 4: Collaboration (Week 4)
**Epic 5 + Epic 6**
- Notifications (5.1)
- Comments & mentions (5.2, 5.3)
- Search (6.1, 6.2)
- Activity feed (5.4)

### Phase 5: Polish (Week 5)
**Epic 7 + Remaining**
- Why This Matters (7.1, 7.2, 7.3)
- Templates (1.7)
- Advanced features (2.5, 2.6, 2.7, 2.8, 4.4, 4.5)

---

## 📖 Specification Format

Each UI spec includes:

1. **Screen Overview** - Purpose, user flow, success criteria
2. **Layout Structure** - ASCII diagrams and component hierarchy
3. **Component Specifications** - Detailed specs for each UI component
4. **Interaction Patterns** - User interactions and state changes
5. **States & Visual Feedback** - Empty, loading, error, success states
6. **Responsive Behavior** - Mobile, tablet, desktop breakpoints
7. **Accessibility Requirements** - ARIA, keyboard navigation, screen reader
8. **Design Tokens** - Colors, spacing, typography
9. **Figma Design Notes** - Component variants, auto-layout, prototyping
10. **v0.dev/Lovable Prompts** - AI generation prompts (optional)

---

## 🔧 Common Patterns

### Modal Dialogs
- Max width: 600px (desktop)
- 90vw width (mobile - full screen)
- Backdrop: `bg-black/50` with blur
- Border radius: `rounded-lg` (8px)
- Shadow: `shadow-xl`

### Form Inputs
- Height: 44px (desktop), 48px (mobile - larger touch targets)
- Font size: 16px (prevents mobile zoom)
- Border: `border-gray-200` 1px solid
- Focus: 2px blue ring (`ring-2 ring-primary`)

### Buttons
- Primary: `bg-primary text-white` + hover/active states
- Secondary: `bg-secondary` variant
- Ghost: Transparent with hover background
- Loading: Spinner + text
- Disabled: Reduced opacity + cursor-not-allowed

### Status Badges
- To-Do: Gray
- In Progress: Blue
- Done: Green
- Archived: Red
- Border radius: `rounded-full`
- Padding: 4px 12px

### Empty States
- Illustration or icon (centered)
- Title: Clear message (24px, semibold)
- Description: Helper text (14px, gray)
- CTA: Primary button

---

## ✅ Accessibility Standards

All components must meet **WCAG 2.1 AA** compliance:

- **Color Contrast:** 4.5:1 minimum for text
- **Touch Targets:** 48px minimum on mobile
- **Keyboard Navigation:** Full keyboard support
- **Focus Indicators:** Visible 2px ring
- **ARIA Labels:** Proper semantic HTML + ARIA attributes
- **Screen Reader:** Announcements for dynamic content

---

## 🚀 Getting Started

### For Figma Designers:

1. **Review Design System** - Start with shadcn/ui component library
2. **Read Epic 1 Specs** - Comprehensive specs for core flows
3. **Create Master File** - Set up Figma file with:
   - Design tokens (colors, typography, spacing)
   - Component library (buttons, inputs, badges, etc.)
   - Page structure for each epic
4. **Build by Epic** - Follow implementation priority
5. **Prototype Key Flows** - Interactive prototypes for:
   - Brief creation → AI generation → Confirmation
   - Task assignment → Execution → Review
   - Login → Dashboard → Task detail

### For Developers:

Each spec includes:
- **Component names** - shadcn/ui component references
- **Technical notes** - React, TypeScript, TanStack Query
- **API integration** - Supabase client examples
- **v0.dev prompts** - AI generation shortcuts

---

## 📞 Contact & Questions

**Project:** SingleBrief MVP
**Timeline:** 5 weeks
**Tech Stack:** React 18 + TypeScript + shadcn/ui + Supabase
**Design System:** shadcn/ui (https://ui.shadcn.com)

For questions about specifications, refer to the source story files in `backlog/stories/` or the consolidated PRD in `docs/prd/`.

---

**Ready to design?** Start with **Epic 1: Brief Creation** for the core user experience! 🎨
