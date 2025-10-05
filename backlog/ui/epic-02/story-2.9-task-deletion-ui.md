# UI/UX Spec: Story 2.9 - Task Soft Delete
**Feature:** Delete with confirmation, soft delete (30-day recovery)
**Interaction:** Delete button → Confirmation: "Delete task?" → status=Archived
**UI:** "Show Archived" toggle, Restore button on archived tasks
**v0.dev:** Delete with confirmation (AlertDialog, soft delete, restore option)

---

## AI Generation Prompts

### v0.dev / Lovable
```
[Implement this feature using React 18 + TypeScript + shadcn/ui components]
Key components: [List from spec above]
Key interactions: [From interaction patterns above]
Responsive: Mobile-first, follows breakpoints specified
Accessible: WCAG 2.1 AA compliant with keyboard navigation
Use React Hook Form for forms, TanStack Query for data fetching
```

### Figma AI
```
[Design this interface following the specifications above]
Create component variants for all states mentioned
Use the design tokens (colors, spacing, typography) specified
Ensure proper auto-layout structure for responsive design
```

### Quick Prompt (All Tools)
```
[Feature name from above]
Components: [Key UI elements]
Layout: [Main structure]  
States: [Empty, loading, active, error, success as applicable]
Styling: shadcn/ui + Tailwind CSS
Interactions: [Key user actions]
```

**Complete specifications available in sections above**
