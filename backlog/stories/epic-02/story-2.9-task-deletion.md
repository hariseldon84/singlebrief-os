# Story 2.9: Task Deletion with Soft Delete

**Story ID:** STORY-2.9
**Status:** ⬜ To Do

## User Story
**As a** manager
**I want to** delete tasks with recovery option
**So that** I can remove mistakes without permanent loss

## Acceptance Criteria
- [ ] Delete button in task detail (FR38)
- [ ] Confirmation dialog: "Delete task?" (FR38)
- [ ] Soft delete: status='Archived', visible for 30 days
- [ ] "Show Archived" toggle reveals deleted tasks
- [ ] Can restore archived tasks
- [ ] Hard delete after 30 days (database cleanup job)

## Story Points: 3
## Dependencies: Story 2.1
## FRs: FR38
