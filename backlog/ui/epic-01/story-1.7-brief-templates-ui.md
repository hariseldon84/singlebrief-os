# UI/UX Specification: Story 1.7 - Brief Templates

**Story ID:** STORY-1.7
**Feature:** Pre-built Brief Templates
**Design System:** shadcn/ui + Tailwind CSS

---

## 1. Screen Overview

**Purpose:** Accelerate brief creation with 3 pre-built templates (Marketing Campaign, Product Launch, Research Project).

**User Flow:**
- Click "Create Brief" → Dialog opens
- "Use Template" dropdown OR template gallery
- Select template → Pre-fill title + description
- Edit as needed → Generate tasks

**Success Criteria:**
- Reduces time to create brief
- Templates provide good starting structure
- Easy to customize after selection

---

## 2. Component Specifications

### Template Selector (Option A: Dropdown)
**Position:** Above title input in create dialog

```
┌────────────────────────────────────┐
│ Create New Brief          [X]      │
├────────────────────────────────────┤
│                                    │
│ Start from template (optional)    │
│ ┌────────────────────────────┐   │
│ │ ▾ Choose a template...      │   │
│ └────────────────────────────┘   │
│                                    │
│ Brief Title *                      │
│ ┌────────────────────────────┐   │
│ │                             │   │
└────────────────────────────────────┘
```

**Component:** `<Select>` (shadcn/ui)
- **Options:**
  - "Marketing Campaign"
  - "Product Launch"
  - "Research Project"
  - "Start from scratch" (default)

### Template Selector (Option B: Card Gallery)
**Alternative:** Template cards before form

```
┌────────────────────────────────────┐
│ Choose a template or start blank  │
├────────────────────────────────────┤
│ ┌──────┐  ┌──────┐  ┌──────┐      │
│ │📢    │  │🚀    │  │🔬    │      │
│ │Market│  │Launch│  │Resrch│      │
│ └──────┘  └──────┘  └──────┘      │
│                                    │
│        [Start Blank]               │
└────────────────────────────────────┘
```

- **Component:** Grid of template cards
- **Size:** 100px x 120px each
- **Hover:** Shadow + scale (1.05)
- **Icon:** Large emoji or icon
- **Title:** Template name below

### Template Content

**Marketing Campaign Template:**
```yaml
title: "Q{quarter} Marketing Campaign"
description: |
  Plan and execute a comprehensive marketing campaign including:
  - Target audience research and segmentation
  - Core messaging and value propositions
  - Multi-channel content strategy (email, social, blog)
  - Campaign calendar and milestones
  - Success metrics and tracking dashboard
```

**Product Launch Template:**
```yaml
title: "Product Launch: {Product Name}"
description: |
  Coordinate a successful product launch including:
  - Launch timeline and milestone planning
  - Go-to-market strategy and positioning
  - Marketing materials and sales collateral
  - Internal team enablement and training
  - Launch day coordination and monitoring
```

**Research Project Template:**
```yaml
title: "{Topic} Research Project"
description: |
  Conduct thorough research and analysis including:
  - Research questions and hypotheses
  - Data collection methodology and sources
  - Analysis framework and tools
  - Findings documentation and reporting
  - Recommendations and next steps
```

---

## 3. Interaction Patterns

### Select Template (Dropdown)
1. User opens dropdown
2. Selects template
3. Title and description fields auto-populate
4. User can edit populated content
5. Placeholder text replaced with actual values

### Select Template (Card Gallery)
1. User clicks template card
2. Card gallery fades out (300ms)
3. Form appears with pre-filled content
4. Focus moves to title input for editing

### Clear Template
- "Clear" or "X" button next to dropdown
- Reverts to blank form
- Confirmation if user already edited

---

## 4. Design Tokens

### Template Card Colors
```css
--template-marketing: hsl(271 91% 65%)   /* Purple */
--template-launch: hsl(221 83% 53%)      /* Blue */
--template-research: hsl(142 71% 45%)    /* Green */
```

---

## 5. v0.dev Prompt

```
Create a brief template selector component.

Requirements:
- 3 pre-built templates: Marketing, Launch, Research
- Option A: Dropdown above form fields
- Option B: Card gallery with icons
- Auto-populate title and description on selection
- Allow editing of populated content
- "Clear template" option to start blank
- Smooth transitions (300ms fade)
- Accessible (keyboard navigation, ARIA labels)

Use shadcn/ui Select or custom cards, Tailwind CSS.
```

---

## AI Generation Prompts

### v0.dev / Lovable
```
[Copy the feature description from above and use shadcn/ui components with React + TypeScript + Tailwind CSS]
```

### Figma AI
```
[Design the screens with proper spacing, typography, and component states as specified above]
```

### Visily.ai / Uizard
```
[Create wireframes following the layout structure and component specifications detailed above]
```

**Note:** Refer to sections 1-10 above for complete specifications including layout, components, interactions, states, responsive behavior, and accessibility requirements.
