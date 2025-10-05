# AI Generation Prompts Guide

**Complete AI tool prompts for all 44 UI specifications**

This guide explains how to use the AI generation prompts included in each UI specification file to quickly generate interfaces using tools like v0.dev, Lovable, Visily.ai, Figma AI, or Uizard.

---

## 📋 What's Included

Every UI specification file now includes **comprehensive AI generation prompts** at the end, organized by tool:

1. **v0.dev / Lovable** - Detailed React + TypeScript + shadcn/ui prompts
2. **Figma AI / Design Tools** - Figma-specific design prompts with precise specifications
3. **Visily.ai / Wireframing Tools** - Structured prompts for rapid wireframing
4. **Uizard / Quick Prototyping** - Component-based prompts for fast prototyping

---

## 🎯 Prompt Quality Levels

### Tier 1: Ultra-Detailed Prompts (Epic 1, Stories 1.1-1.2)

These include **4 different prompts per tool category** with extensive details:

**Story 1.1 - Brief Creation Dialog:**
- v0.dev/Lovable: 100+ lines with complete layout, components, behavior, validation, accessibility
- Figma AI: Detailed frame structure, auto-layout specs, color palette, component variants
- Visily.ai: Structured screen layout with sections and interactions
- Uizard: Component-based breakdown ready for drag-and-drop

**Story 1.2 - AI Task Breakdown:**
- Similar comprehensive prompts for task list with progressive disclosure
- Includes animation specifications and state variations

### Tier 2: Detailed Prompts (Remaining Epic 1, All of Epic 2-3)

**Structured prompts covering:**
- Component specifications
- Layout and styling details
- Interaction patterns
- States and variations
- References to full specifications in the file

### Tier 3: Concise Prompts (Epic 4-8)

**Quick reference prompts that:**
- Point to full specifications in the same file
- Provide tool-specific guidance
- Include key implementation details
- Reference complete layout, components, and interactions from earlier sections

---

## 🚀 How to Use the Prompts

### Using v0.dev / Lovable

1. **Open the UI spec file** for your story (e.g., `epic-01/story-1.1-basic-brief-creation-ui.md`)
2. **Scroll to the bottom** - Find "AI Generation Prompts" section
3. **Copy the v0.dev/Lovable prompt**
4. **Paste into v0.dev or Lovable**
5. **Review and iterate** - The AI will generate React components with shadcn/ui

**Example workflow:**
```bash
# 1. Read the spec
cat backlog/ui/epic-01/story-1.1-basic-brief-creation-ui.md

# 2. Copy the v0.dev prompt (at bottom of file)

# 3. Paste into v0.dev and generate
```

**What you'll get:**
- Fully functional React components
- shadcn/ui integration
- TypeScript types
- Tailwind CSS styling
- Accessibility features
- Form validation (where applicable)

### Using Figma AI / Design Tools

1. **Open the UI spec file**
2. **Locate the "Figma AI" prompt** section
3. **Copy the design specifications**
4. **Use in Figma AI or your design tool**

**The prompts include:**
- Frame structure and hierarchy
- Auto-layout specifications
- Component variants needed
- Color palette
- Typography scale
- Spacing and padding
- States to design
- Prototype flows

**Example use case:**
- Create a new Figma file
- Use Figma AI to generate components based on the prompt
- Refine using the detailed specifications in sections 1-10
- Create variants for all states mentioned
- Link interactive prototype flows

### Using Visily.ai

1. **Open Visily.ai**
2. **Start a new project**
3. **Copy the Visily.ai prompt** from the spec file
4. **Paste and generate wireframes**

**Visily prompts are structured for:**
- Screen layout definition
- Component lists
- Section breakdowns
- Interaction mapping
- Responsive specifications

### Using Uizard

1. **Open Uizard**
2. **Create new screen**
3. **Use the Uizard prompt** for component placement
4. **Drag components** following the ROW structure in the prompt

**Uizard prompts provide:**
- Row-by-row layout instructions
- Component types and properties
- Spacing and sizing
- Color specifications
- Behavior definitions

---

## 💡 Pro Tips

### For Best Results

**1. Start with Tier 1 prompts (Stories 1.1 and 1.2)**
- These are the most detailed
- Use them to understand the pattern
- Adapt the approach for other stories

**2. Read the full specification first**
- Prompts are summaries
- Full specs (sections 1-10) contain critical details
- Use prompts as starting point, specs for refinement

**3. Iterate and refine**
- First generation won't be perfect
- Use the detailed specs to refine
- Test against acceptance criteria in the story files

**4. Combine tools**
- Use Figma AI for design
- Use v0.dev for code
- Use Visily for quick wireframes
- Use Uizard for rapid prototyping

### Common Patterns

**All prompts reference:**
- shadcn/ui component library
- Tailwind CSS for styling
- React 18 + TypeScript
- Accessibility requirements (WCAG 2.1 AA)
- Responsive design (mobile-first)

**Every prompt ensures:**
- Proper component hierarchy
- State management
- Error handling
- Loading states
- Empty states
- Validation (where applicable)

---

## 📁 File Structure Reference

```
backlog/ui/
├── README.md (Design system + overview)
├── AI-PROMPTS-GUIDE.md (This file)
│
├── epic-01/ (8 stories - Brief Creation)
│   ├── story-1.1-basic-brief-creation-ui.md ⭐ ULTRA-DETAILED
│   ├── story-1.2-ai-task-breakdown-ui.md ⭐ ULTRA-DETAILED
│   ├── story-1.3-progressive-confirmation-ui.md
│   ├── story-1.4-inline-task-editing-ui.md
│   ├── story-1.5-task-regeneration-ui.md
│   ├── story-1.6-draft-saving-ui.md
│   ├── story-1.7-brief-templates-ui.md
│   └── story-1.8-task-limit-settings-ui.md
│
├── epic-02/ (10 stories - Task Management)
│   ├── story-2.1-task-assignment-ui.md
│   ├── story-2.2-task-status-ui.md
│   ├── story-2.3-task-detail-view-ui.md
│   ├── story-2.4-my-tasks-inbox-ui.md
│   ├── story-2.5-due-dates-progress-ui.md
│   ├── story-2.6-priority-system-ui.md
│   ├── story-2.7-quick-add-task-ui.md
│   ├── story-2.8-bulk-actions-ui.md
│   ├── story-2.9-task-deletion-ui.md
│   └── story-2.10-onboarding-ui.md
│
├── epic-03/ (5 stories - AI Agents)
│   └── [All 5 files with AI-specific prompts]
│
├── epic-04/ (6 stories - Review Workflow)
│   └── [All 6 files with review-specific prompts]
│
├── epic-05/ (5 stories - Collaboration)
│   └── [All 5 files with collaboration prompts]
│
├── epic-06/ (4 stories - Search & Navigation)
│   └── [All 4 files with search/nav prompts]
│
├── epic-07/ (4 stories - Why This Matters)
│   └── [All 4 files with context-specific prompts]
│
└── epic-08/ (2 stories - Authentication)
    └── [Both files with auth-specific prompts]
```

---

## 🎨 Recommended Workflow

### Phase 1: Design Foundation (Week 1)

**Use Figma AI for:**
1. Start with Epic 1, Story 1.1 (Brief Creation Dialog)
2. Generate design using Figma AI prompt
3. Create component library based on shadcn/ui
4. Set up design tokens (colors, typography, spacing)
5. Create variants for all component states

**Deliverables:**
- Figma design system
- Component library
- Design tokens
- Interactive prototypes

### Phase 2: Development (Weeks 2-5)

**Use v0.dev/Lovable for:**
1. Generate React components story by story
2. Integrate with Supabase
3. Add form validation and state management
4. Implement responsive behavior
5. Add accessibility features

**Deliverables:**
- Functional React components
- Working features
- Tested interfaces

### Phase 3: Rapid Prototyping (Ongoing)

**Use Visily.ai/Uizard for:**
1. Quick wireframes for new ideas
2. User flow visualization
3. Stakeholder presentations
4. Iteration testing

---

## ✅ Quality Checklist

Before considering a UI complete, verify:

- [ ] Matches the layout structure in the spec
- [ ] All components from spec are present
- [ ] All states are implemented (empty, loading, error, success)
- [ ] Responsive behavior works across breakpoints
- [ ] Accessibility requirements met (keyboard nav, ARIA, contrast)
- [ ] Validation works as specified
- [ ] Interactions match the patterns described
- [ ] Design tokens (colors, spacing, typography) used correctly
- [ ] Component variants created for all states

---

## 🔗 Quick Links

**Essential Resources:**
- [shadcn/ui Components](https://ui.shadcn.com/docs/components)
- [Radix UI Primitives](https://www.radix-ui.com/primitives)
- [Tailwind CSS Docs](https://tailwindcss.com/docs)
- [React Hook Form](https://react-hook-form.com)
- [TanStack Query](https://tanstack.com/query)

**AI Tools:**
- [v0.dev](https://v0.dev) - AI React component generator
- [Lovable](https://lovable.dev) - AI web app builder
- [Visily.ai](https://visily.ai) - AI wireframing tool
- [Uizard](https://uizard.io) - AI design tool

**Project Resources:**
- Design System: `backlog/ui/README.md`
- Story Details: `backlog/stories/`
- PRD: `docs/prd/CONSOLIDATED_PRD.md`

---

## 💬 Support & Questions

**If a prompt doesn't work perfectly:**
1. Check the full specification (sections 1-10 in the file)
2. Review the design system in `README.md`
3. Compare with similar components from other stories
4. Iterate with the AI tool using spec details
5. Refer to shadcn/ui documentation for component APIs

**Remember:** The prompts are starting points. The full specifications contain all the details needed for pixel-perfect implementation!

---

**Ready to generate?** Start with Story 1.1 (Brief Creation) and work through the epics in order! 🚀
