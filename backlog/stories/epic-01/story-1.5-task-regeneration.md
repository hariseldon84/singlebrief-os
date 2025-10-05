# Story 1.5: Task Regeneration Limit

**Story ID:** STORY-1.5
**Status:** ⬜ To Do

## User Story
**As a** manager
**I want to** regenerate tasks if the AI output is unsatisfactory
**So that** I can get better task breakdowns

## Acceptance Criteria
- [ ] "Regenerate Tasks" button shown after initial generation
- [ ] Regeneration calls same n8n workflow with same brief
- [ ] Max 3 regeneration attempts per brief (FR70)
- [ ] Counter shows: "Attempt 2/3"
- [ ] After 3 attempts, button disabled with message
- [ ] Each regeneration replaces previous tasks
- [ ] Warning shown before replacing tasks
- [ ] Regeneration count tracked in database

## Story Points: 3
## Dependencies: Story 1.2
## FRs: FR70
