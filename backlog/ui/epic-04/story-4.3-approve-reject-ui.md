# UI/UX Spec: Story 4.3 - Approve/Reject Flow
**Feature:** Manager review actions
**Layout:** Task detail shows: "Approve" (green) + "Request Changes" (orange) buttons
**Feedback:** Textarea for rejection feedback (required for "Request Changes")
**Actions:** 
- Approve → status=Done, notification to assignee
- Request Changes → status=In Progress, feedback shown, notification sent
**v0.dev:** Review buttons (Approve/Request Changes, feedback textarea, confirmation, notifications)


---

## AI Generation Prompts

**v0.dev/Lovable:** Implement review workflow using React + shadcn/ui. Include approval/rejection buttons, feedback forms, version history, and notifications as specified above.

**Figma AI:** Design review interface with clear approval states (pending, approved, rejected), feedback input areas, and iteration tracking.

**All Tools:** Use specifications from sections above for complete layout, components, interactions, and styling details.

