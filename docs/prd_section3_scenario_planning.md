# PRD Section 3 - Scenario Planning (UI User Journeys)

**Date:** 2025-10-04
**Elicitation Method:** Scenario Planning
**Purpose:** Walk through complete user journeys to identify gaps, edge cases, and missing UI elements

---

## User Journey 1: Manager Creates First Brief

### Happy Path Scenario

**Context:** Sarah (Manager) logs in for the first time after onboarding

**Journey Steps:**

1. **Dashboard Landing** (0:00)
   - Empty state: "No briefs yet. Create your first brief to get started."
   - Prominent "Create New Brief" button
   - **Gap Identified:** What if user has no projects yet? Should brief creation force project selection first?

2. **Brief Creation Dialog Opens** (0:05)
   - Full-screen modal with large textarea
   - Placeholder text: "Describe your project or initiative..."
   - Character count indicator (helpful, non-blocking)
   - **Gap Identified:** Should there be example briefs to inspire users? "See examples" link?

3. **Sarah Types Brief** (0:10 - 2:30)
   - "We need to launch our Q4 marketing campaign for the new product line. Target is enterprise customers in healthcare. Key deliverables include landing page, email sequence, product demo video, and sales collateral."
   - **Edge Case:** What if Sarah hits Escape accidentally? Auto-save draft?

4. **Sarah Clicks "Create Brief"** (2:35)
   - Loading state: "Generating tasks..." with spinner
   - **Gap Identified:** What if AI generation takes 60+ seconds? Timeout handling?
   - **Gap Identified:** Can Sarah close dialog and check generation status later?

5. **AI Task Breakdown Complete** (3:10)
   - **NEW REQUIREMENT DISCOVERED:** Post-generation confirmation screen (FR69)
   - Shows 8 generated tasks with titles, descriptions, suggested priorities
   - Options: "Accept All", "Edit Tasks", "Regenerate with Feedback"
   - **Gap Identified:** What if Sarah wants to accept SOME tasks but not all? Checkbox selection?

6. **Sarah Reviews Generated Tasks** (3:15 - 4:00)
   - Task 1: "Design landing page wireframes" - Priority: High
   - Task 2: "Write landing page copy" - Priority: High
   - Task 3: "Create product demo video script" - Priority: Medium
   - ...
   - **Edge Case:** What if AI generates only 2 tasks when Sarah expected 10+? Feedback mechanism needed

7. **Sarah Edits Task 3** (4:05)
   - Clicks "Edit" on Task 3
   - Inline editing: Changes title to "Write AND record product demo video"
   - Adds description detail
   - **Gap Identified:** Should edited tasks be marked differently? (AI-generated, user-modified indicator?)

8. **Sarah Accepts Tasks** (4:30)
   - Clicks "Accept All Tasks"
   - Brief Detail view loads
   - **Gap Identified:** Should there be a success toast? "8 tasks created successfully"

9. **Brief Detail View First Impression** (4:35)
   - Brief header shows title (auto-generated from brief text), progress (0% complete)
   - Task list shows 8 tasks, all status "To-Do"
   - "Why This Matters" section collapsed with badge "NEW"
   - **Gap Identified:** What's the brief title? Auto-extracted or Sarah names it?

10. **Sarah Expands "Why This Matters"** (4:40)
    - AI-generated section shows:
      - Business value: "Q4 revenue target of $2M from healthcare enterprise"
      - Impact metrics: "30% increase in qualified leads, 15% conversion rate"
    - **Edge Case:** What if "Why This Matters" is generic buzzword soup? User needs easy "Regenerate" option

11. **Sarah Assigns Tasks** (5:00 - 6:30)
    - Task 1 → Assigns to "Design Team (Sarah)" (human)
    - Task 2 → Assigns to "Content Writing Agent" (AI)
    - **Gap Identified:** When Sarah assigns to AI, does task status change to "Queued" immediately?
    - **Gap Identified:** Should there be visual indicator showing "4 tasks queued for AI"?

12. **Sarah Clicks "Run AI Tasks"** (6:35)
    - **NEW REQUIREMENT:** Cost preview modal (FR77)
    - "Run 4 AI tasks? Estimated cost: $0.80 (based on 8,000 tokens)"
    - **Edge Case:** What if Sarah doesn't have enough credits? Block with upgrade prompt?
    - Sarah confirms
    - **Gap Identified:** Should tasks execute sequentially with live progress ("Running task 2 of 4...")?

13. **AI Generation In Progress** (6:40 - 8:00)
    - Task 2 status changes to "Generating..." with animated spinner
    - **Edge Case:** What if AI takes 90 seconds? Timeout warning needed
    - **Gap Identified:** Can Sarah navigate away and return to check status?

14. **AI Task Completes** (8:05)
    - Task 2 status → "Done"
    - Toast notification: "Content Writing Agent completed task 'Write landing page copy'"
    - **Gap Identified:** Should toast have "View Output" quick action?

### Error Path Scenario

**Scenario 1A: AI Generation Fails**

**Trigger:** OpenAI API timeout at step 4

**Flow:**
- Error modal: "AI task generation failed. Please try again."
- **Gap Identified:** Should brief be saved in "Draft" status with original text preserved?
- Options: "Retry", "Cancel and Save Draft"
- **Missing UI:** Draft briefs section in dashboard

**Scenario 1B: Sarah Accidentally Closes Confirmation Screen**

**Trigger:** Sarah hits Escape at step 6

**Flow:**
- **Gap Identified:** Are generated tasks lost? Or saved to draft?
- **Recommendation:** Auto-save to draft, show warning modal: "Tasks not confirmed yet. Save as draft?"

---

## User Journey 2: Team Member Completes Task with Rejection Cycle

### Happy Path Scenario

**Context:** Alex (Team Member) receives task assignment notification

**Journey Steps:**

1. **Email Notification** (external)
   - "Sarah assigned you a task: 'Design landing page wireframes'"
   - **Gap Identified:** What's in the email? Just title or full task description?
   - Link: "View Task"

2. **Alex Clicks Link** (0:00)
   - Redirects to login (if not logged in)
   - After auth → Direct deep link to Task Detail view
   - **Gap Identified:** What if link is stale (task deleted)? 404 handling?

3. **Task Detail View** (0:10)
   - Task title, description visible
   - Status: "To-Do"
   - Due date field: Empty with placeholder "Set due date to start"
   - Brief context section: "Limited access - contact Sarah for full brief context"
   - **Gap Identified:** Should there be a "Request Access" button to ping Sarah?

4. **Alex Sets Due Date** (0:20)
   - Calendar picker opens
   - Alex selects "3 days from now"
   - **Validation:** Cannot select past dates
   - **Gap Identified:** Should system suggest due date based on brief timeline?

5. **Status Auto-Updates to In-Progress** (0:25)
   - Status badge changes: Gray "To-Do" → Blue pulsing "In-Progress"
   - Progress slider appears: 0%
   - **Gap Identified:** Should Sarah (manager) get notification? "Alex started task X"

6. **Alex Works on Task** (0:30 - 48 hours)
   - Alex periodically updates progress: 25% → 50% → 75%
   - **Edge Case:** What if Alex updates progress but doesn't submit for 7 days? Overdue indicator?
   - **Gap Identified:** Can Sarah see real-time progress updates? (Yes, per NFR29 polling)

7. **Alex Submits Output** (48:00)
   - Progress set to 100%
   - Output comments: "Wireframes complete. Focused on mobile-first responsive design."
   - Output URL: "https://figma.com/file/abc123"
   - **Gap Identified:** Should there be file upload option? (Yes, FR73 - but need UI design)
   - Clicks "Submit Output"

8. **Status Changes to Done** (48:05)
   - Status badge: Green "Done - Awaiting Review"
   - **Gap Identified:** Should Alex see estimated review time? "Typically reviewed within 24 hours"
   - Toast: "Output submitted successfully. Sarah will be notified."

9. **Sarah Reviews Output** (50:00)
   - Sarah opens Task Output Review Modal
   - Sees wireframes link, reads comments
   - **Decision:** Rejects with feedback
   - Feedback textarea: "Great start, but need tablet breakpoint wireframes too. Also add accessibility annotations."
   - Clicks "Reject"

10. **Alex Receives Rejection** (50:10)
    - Email notification: "Sarah requested changes to 'Design landing page wireframes'"
    - **Gap Identified:** Should rejection email include feedback text directly?
    - Alex logs in → Task Detail view

11. **Task Detail After Rejection** (50:15)
    - Status badge: Red "Rejected"
    - Manager feedback visible in prominent card: [Sarah's feedback text]
    - Previous output shown in collapsed "Version History" section
    - **Gap Identified:** Can Alex see previous output and new output side-by-side for comparison?
    - **Gap Identified:** Should there be "Ask Question" button to clarify feedback?

12. **Alex Starts Rework** (51:00)
    - Clicks "Start Rework" button
    - Status auto-changes to "In-Progress"
    - Progress resets to 50% (not 0% - acknowledges prior work)
    - **Gap Identified:** Should rework cycle number be visible? "Rework cycle 1 of 3 allowed"?

13. **Alex Resubmits** (72:00)
    - New output comments: "Added tablet wireframes (768px-1024px) and WCAG AA accessibility annotations"
    - Same Figma URL (updated file)
    - Clicks "Submit Output"

14. **Sarah Accepts** (73:00)
    - Sarah reviews → Clicks "Accept"
    - Status changes to "Accepted/Complete" (dark green badge with checkmark)
    - Task locked (no further edits)
    - **Gap Identified:** Should there be "Reopen Task" option if Sarah realizes mistake later?

### Error Path Scenario

**Scenario 2A: Alex Misses Due Date**

**Trigger:** Due date passes, task still In-Progress at 60%

**Flow:**
- **Gap Identified:** Overdue badge needed (orange "Overdue" indicator)
- **Gap Identified:** Should Sarah get notification? "Task X is overdue by 2 days"
- **Gap Identified:** Can Alex extend due date themselves or request extension from Sarah?

**Scenario 2B: Alex Submits Without Setting Due Date**

**Trigger:** Alex tries to submit output while status is still "To-Do"

**Flow:**
- **Validation Error:** "Please set due date and move to In-Progress before submitting"
- **Alternative:** Auto-set due date to today and allow submission?

---

## User Journey 3: AI Agent Generates Content with Multiple Rejections

### Happy Path Scenario

**Context:** Content Writing Agent assigned "Write blog post about product launch"

**Journey Steps:**

1. **Task Assignment** (0:00)
   - Sarah assigns task to "Content Writing Agent"
   - Status: "Queued" (orange badge with clock icon)
   - **Gap Identified:** Should queued tasks show queue position? "3rd in queue"

2. **Sarah Clicks "Run AI Tasks"** (1:00)
   - Cost preview: "Run 1 AI task? Estimated cost: $0.15"
   - Sarah confirms
   - Status changes to "Generating..." (animated purple spinner)

3. **AI Generation** (1:05 - 1:45)
   - Backend sends full context to LLM:
     - Task title, description
     - Full brief text
     - "Why This Matters" section
   - **Gap Identified:** Should there be progress indicator? "Generating... 40 seconds elapsed"

4. **AI Completes Generation** (1:50)
   - Status → "Done"
   - Output saved to database
   - Toast notification: "Content Writing Agent completed task"
   - **Gap Identified:** Should toast show output preview? "Preview: 'Introducing Our Revolutionary...'"

5. **Sarah Reviews AI Output** (2:00)
   - Task Output Review Modal opens
   - Output preview: 800-word blog post
   - **Edge Case:** What if output is 5,000 words? Scrollable with "Read More" expansion?
   - Sarah reads and decides: Too generic, lacks specific product details

6. **Sarah Rejects AI Output** (3:00)
   - Clicks "Reject"
   - Feedback: "Too generic. Include specific features: real-time collaboration, 256-bit encryption, 99.9% uptime SLA. Target tone: professional but approachable."
   - Clicks "Submit Feedback"

7. **Task Requeued** (3:05)
   - Status changes back to "Queued"
   - **Gap Identified:** Should rejection count be visible? "Rejected 1 time"
   - **Gap Identified:** Should there be limit? "Maximum 3 AI regeneration attempts"

8. **Sarah Triggers Regeneration** (3:10)
   - Clicks "Run AI Tasks" again
   - **NEW CONTEXT:** AI now receives:
     - Original task description
     - Previous output (800-word blog post)
     - Sarah's rejection feedback
   - Cost preview: "Run 1 AI task? Estimated cost: $0.20 (longer context)"

9. **AI Regeneration** (3:15 - 4:00)
   - Status: "Generating..."
   - **Gap Identified:** Should UI show "Regeneration attempt 2" indicator?

10. **AI Second Attempt Complete** (4:05)
    - Status → "Done"
    - Output: Improved 850-word blog post with specific features mentioned
    - **Gap Identified:** Should there be diff view comparing v1 vs v2?

11. **Sarah Accepts** (5:00)
    - Reviews improved output
    - Clicks "Accept"
    - Status → "Accepted/Complete"
    - **Gap Identified:** Should accepted AI outputs be editable by humans post-acceptance? "Edit and Refine" option?

### Error Path Scenario

**Scenario 3A: AI Generation Timeout**

**Trigger:** LLM API takes 90 seconds (exceeds 60s threshold)

**Flow:**
- Status changes to "Failed" (red badge with alert icon)
- Error message: "AI generation timed out. Please try again or reassign to human team member."
- **Gap Identified:** Retry button with same context or different model?
- Options: "Retry with Claude", "Retry with GPT-4", "Reassign to Human"

**Scenario 3B: AI Hits Rate Limit**

**Trigger:** Sarah tries to run 20 AI tasks simultaneously

**Flow:**
- **Gap Identified:** Should system enforce max concurrent AI tasks? "Maximum 5 concurrent AI tasks"
- Error modal: "Rate limit reached. Please wait 30 seconds before running more AI tasks."
- **Recommendation:** Queue management with automatic sequential execution

---

## User Journey 4: Manager Searches for Old Brief

### Happy Path Scenario

**Context:** Sarah needs to find marketing campaign brief from 3 months ago

**Journey Steps:**

1. **Dashboard Search** (0:00)
   - Sarah types in search bar: "Q4 marketing"
   - **Gap Identified:** Search scope selector needed? "Search: All Briefs | My Briefs | Active Only"
   - Filter dropdown: "All Briefs" selected

2. **Search Results** (0:02)
   - 3 results found:
     - "Q4 Marketing Campaign" (completed, 3 months ago)
     - "Q4 Marketing Budget Planning" (active, 1 month ago)
     - "Q3 Marketing Retrospective" (archived, 4 months ago)
   - **Gap Identified:** Should archived briefs show by default or filtered out?

3. **Result Display** (0:05)
   - Each result card shows:
     - Brief title (auto-generated or user-named?)
     - Brief excerpt (first 200 characters)
     - Project badge
     - Status badge
     - Last updated timestamp
     - Progress indicator
   - **Gap Identified:** Should there be "Quick Actions" on result cards? "View | Export PDF | Duplicate"

4. **Sarah Clicks Result** (0:10)
   - Navigates to Brief Detail view
   - Shows completed brief with all 12 tasks accepted
   - **Edge Case:** What if brief has 50+ tasks? Pagination or infinite scroll?

### Error Path Scenario

**Scenario 4A: No Results Found**

**Trigger:** Sarah searches for "blockchain" (no matches)

**Flow:**
- Empty state: "No briefs found matching 'blockchain'"
- **Gap Identified:** Suggestions needed? "Try different keywords or check filters"
- **Gap Identified:** Should there be "Create New Brief" shortcut from empty state?

---

## User Journey 5: Team Member Uses "Generate with AI" Assistance

### Happy Path Scenario

**Context:** Alex struggles with writing email copy, uses AI assistance

**Journey Steps:**

1. **Task In Progress** (0:00)
   - Alex assigned "Write follow-up email to healthcare prospects"
   - Status: In-Progress, due in 2 days, 30% progress

2. **Alex Clicks "Generate with AI"** (1:00)
   - Button in output section (below textarea, above submit button)
   - Modal opens: "AI is generating suggestions..."
   - **Gap Identified:** Loading state duration? Show estimated time?

3. **AI Suggestion Generated** (1:25)
   - AI Output Preview Component appears
   - Shows suggested email with subject line and body
   - **Gap Identified:** Should AI explain its reasoning? "This email emphasizes compliance and ROI based on healthcare context"

4. **Preview Actions** (1:30)
   - Three buttons visible:
     - "Use This" (populates textarea, replaces current content)
     - "Edit & Use" (populates textarea, allows modification)
     - "Discard" (clears suggestion)
   - **Edge Case:** What if Alex already has 200 words written? "Use This" should warn about overwriting

5. **Alex Clicks "Edit & Use"** (1:35)
   - Suggested content populates output textarea
   - Alex makes edits: Changes tone, adds specific numbers
   - **Gap Identified:** Should there be version comparison? "Show original vs. AI suggestion vs. my edits"

6. **Alex Submits** (3:00)
   - Clicks "Submit Output"
   - Output credited to Alex (human), not AI
   - **Gap Identified:** Should there be attribution metadata? "AI-assisted output" tag visible to Sarah?

### Error Path Scenario

**Scenario 5A: AI Assistance Fails**

**Trigger:** LLM API error during suggestion generation

**Flow:**
- Error message: "AI suggestion generation failed. Please try again."
- **Gap Identified:** Should error persist or auto-retry once?
- "Try Again" button reappears

---

## Newly Discovered UI Requirements

### From Journey Analysis

**FR82: Brief Title Management**
- System shall auto-generate brief title from first 50 characters of brief text OR allow manager to set custom title during confirmation screen

**FR83: Draft Brief Saving**
- System shall auto-save brief text to draft status if user closes creation dialog before confirming AI-generated tasks. Draft accessible from dashboard "Drafts" section.

**FR84: Task Acceptance Granularity**
- Post-generation confirmation screen shall support selective task acceptance (checkboxes) in addition to "Accept All" option

**FR85: Overdue Task Indicators**
- System shall display overdue badge (orange) on tasks where current date exceeds due date and status is In-Progress

**FR86: AI Queue Position Visibility**
- Queued AI tasks shall display queue position ("3rd in queue") to set manager expectations

**FR87: AI Regeneration Attempt Limits**
- System shall limit AI regeneration attempts to 3 per task. After 3 rejections, suggest reassignment to human team member.

**FR88: Version Comparison UI**
- Task Output Review Modal shall include "Compare Versions" option showing diff view between rejected output and resubmitted output

**FR89: Rework Cycle Tracking**
- Task cards shall display rework cycle count badge when task has been rejected and resubmitted (e.g., "Rework cycle 2")

**FR90: AI-Assisted Output Attribution**
- When team member uses "Generate with AI" feature, output metadata shall tag as "AI-assisted" (visible to manager in review modal)

**FR91: Search Scope Controls**
- Brief search shall include scope selector: All Briefs | My Briefs | Active Only | Archived

**FR92: Archived Brief Filtering**
- Search results shall exclude archived briefs by default unless "Include Archived" filter enabled

**NFR30: Deep Link Handling**
- Email notification links shall deep link directly to task detail view with proper 404/error handling if task deleted

**NFR31: Real-Time Progress Visibility**
- Manager dashboard shall poll every 30 seconds to display team member progress updates (0-100%) on in-progress tasks

---

*Scenario Planning elicitation complete - 11 new requirements identified from user journey analysis*
