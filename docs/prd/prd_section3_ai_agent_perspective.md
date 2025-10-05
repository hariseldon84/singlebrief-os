# PRD Section 3 - AI Agent Perspective Updates

**Date:** 2025-10-04
**Elicitation Method:** Perspective Shifting (AI Agent as Actor)
**Critical Discovery:** AI agents behave like team members with auto-execution

---

## AI Agent Execution Model

### Core Principle

**AI agents are treated as specialized team members with automatic execution.**

- Same task assignment workflow as humans
- Same output submission mechanism
- Same review/rejection cycle
- Same task status model
- Different: Auto-execute on assignment (no manual trigger)

---

## AI Agent Types (MVP)

### 1. Content Writing Agent

**Task Types:**
- Blog posts
- Articles
- Marketing copy
- Documentation
- Any long-form content creation

**Input Context:**
- Task title
- Task description
- Due date (if set)
- Brief context (full brief text for context)
- "Why This Matters" section (for tone/purpose alignment)
- Previous output (if rework/rejection)

**Output:**
- Plain text content
- Submitted to output section (same field as team members)

---

### 2. Email Generation Agent

**Task Types:**
- Professional emails
- Follow-ups
- Announcements
- Internal communications

**Input Context:**
- Task title (e.g., "Draft email to stakeholders about launch")
- Task description (recipients, purpose, key points)
- Due date (if set)
- Brief context (for background)
- Previous output (if rework/rejection)

**Output:**
- Email subject line + body
- Plain text format
- Submitted to output section

---

## AI Agent Status Indicators (New UI Component)

### Status Values for AI Execution

**1. Assigned (To-Do)**
- Task assigned to AI agent
- Waiting in queue for execution
- Visual: Standard To-Do badge

**2. Generating (In-Progress)**
- AI actively generating output
- API call in progress
- Visual: Animated badge with spinner "AI Generating..."
- Progress indicator: Indeterminate (can't predict completion time)

**3. Done**
- AI completed output generation
- Output submitted to output section
- Awaiting manager review
- Visual: Green "Done" badge

**4. Failed**
- AI generation error (API timeout, rate limit, error response)
- Error message displayed
- Manager can "Retry" or reassign to human
- Visual: Red "Failed" badge with error icon

**5. Rejected**
- Manager rejected AI output with feedback
- Feedback text visible to AI for next iteration
- Can see previous output version
- Visual: Red "Rejected" badge

---

## New Functional Requirements (AI Agent Features)

### FR62: AI Auto-Execution

**FR62:** When task is assigned to AI agent, system shall automatically initiate task execution without requiring manual trigger. Execution begins immediately after assignment.

**Technical Implementation:**
- Task assignment triggers async job/webhook
- API call to LLM with task context
- Progress polling for completion
- Auto-submit output when generation completes

---

### FR63: AI Context Window

**FR63:** AI agents shall receive comprehensive context when executing tasks, including:
- Task title and description
- Full brief text (for context and alignment)
- "Why This Matters" section (for tone and purpose)
- Due date (if set)
- Previous output versions (for iterative improvement)

**Rationale:** Rich context improves AI output quality and alignment with manager intent.

---

### FR64: AI Version History Access

**FR64:** When manager rejects AI output, system shall provide AI agent access to previous output versions during regeneration to enable iterative improvement.

**UI Implication:** AI can "learn" from past attempts and manager feedback.

---

### FR65: AI Status Visibility

**FR65:** System shall display real-time AI execution status to manager, including:
- "Generating..." indicator with animated spinner
- Estimated time (if available from API)
- Error messages if generation fails
- Retry option on failure

---

### FR66: "Generate with AI" for Team Members

**FR66:** Team members shall have access to "Generate with AI" button in output section to receive AI-assisted output suggestions.

**Workflow:**
1. Team member starts task (In-Progress)
2. Clicks "Generate with AI" in output section
3. System sends task context to AI agent
4. AI generates suggested output
5. Team member can accept, edit, or discard suggestion
6. Final submission is credited to team member (not AI)

**Rationale:** AI augments human work, not replaces it for human-assigned tasks.

---

### FR67: AI Error Handling

**FR67:** When AI generation fails, system shall:
- Display user-friendly error message (not raw API error)
- Provide "Retry" button to attempt regeneration
- Allow manager to reassign task to different AI agent or human
- Log error details for debugging

**Common Error Scenarios:**
- API timeout (LLM took too long)
- Rate limit exceeded (too many requests)
- Invalid API response (malformed output)
- API service down

---

## Updated UI Components

### AI Agent Badge Component (New)

**Visual Design:**
- Icon: Sparkles or Bot icon (Lucide React)
- Text: "AI Agent"
- Color: Purple or teal (distinct from human team members)
- Position: Next to assignee name in task cards

---

### AI Status Indicator Component (New)

**States:**

**1. Generating (Animated)**
```
[Spinner Icon] AI Generating...
```
- Purple background
- Animated pulsing effect
- Spinner rotates continuously

**2. Failed (Error)**
```
[Alert Icon] AI Generation Failed - Retry?
```
- Red background
- "Retry" button inline
- Error tooltip on hover

**3. Done (Success)**
```
[Check Icon] AI Generated
```
- Green background
- Static checkmark

---

### "Generate with AI" Button Component (New)

**Location:** Output section of Task Detail view (team member version)

**Visual Design:**
- Button with Sparkles icon
- Label: "Generate with AI"
- Style: Secondary button (outlined)
- Position: Below output textarea, above submit button

**States:**
- Default: Ready to generate
- Loading: "Generating..." with spinner
- Success: Suggested output populates textarea
- Error: "Generation failed - try again"

---

### AI Output Preview Component (New)

**Purpose:** Show AI-generated suggestion to team member before accepting

**Layout:**
- Comparison view: Suggested output in card above textarea
- Action buttons:
  - "Use This" (populates textarea)
  - "Edit & Use" (populates textarea, allows modification)
  - "Discard" (clears suggestion)

---

## AI Agent Task Cards (Manager View)

### Visual Differences from Human Tasks

**Indicators:**
- Purple AI badge next to assignee
- Real-time status during generation
- "Retry" button visible on failure
- Version history icon (if rework cycles exist)

**Additional Info Displayed:**
- Generation time (how long AI took)
- Token count (optional, for cost tracking)
- Model used (e.g., "GPT-4" or "Claude Sonnet")

---

## Database Schema Updates

### Tasks Table - AI Fields

**New Columns:**
- `ai_model` (text, nullable) - e.g., "gpt-4", "claude-sonnet"
- `generation_time_ms` (integer, nullable) - API response time
- `token_count` (integer, nullable) - For cost tracking
- `ai_error_message` (text, nullable) - Last error if failed

### Task_Outputs Table (New)

**Purpose:** Store all output versions (AI and human)

**Columns:**
- `id` (uuid, primary key)
- `task_id` (uuid, foreign key to tasks)
- `output_text` (text) - The actual content
- `output_url` (text, nullable) - External link if provided
- `version_number` (integer) - Increments on each submission
- `created_by` (uuid, foreign key to users/agents)
- `is_ai_generated` (boolean)
- `ai_model` (text, nullable)
- `status` (enum: draft, submitted, accepted, rejected)
- `manager_feedback` (text, nullable) - Rejection reason
- `created_at` (timestamp)

---

## AI Agent Workflow Diagrams

### Workflow 1: AI Task Assignment and Execution

```
Manager assigns task to AI Agent
    ↓
Task status: To-Do
    ↓
System auto-triggers AI execution
    ↓
Task status: Generating (In-Progress)
    ↓
API call to LLM with context
    ↓
[Success] → Output saved to task_outputs
    ↓
Task status: Done
    ↓
Manager notification
    ↓
Manager reviews output
    ↓
[Accept] → Task status: Accepted/Complete
[Reject] → Task status: Rejected
    ↓
[If Rejected] AI can see previous output
    ↓
Regenerate with feedback → Status: Generating
```

---

### Workflow 2: Team Member Uses "Generate with AI"

```
Team member starts task (In-Progress)
    ↓
Clicks "Generate with AI" button
    ↓
Modal shows "Generating suggestion..."
    ↓
API call to AI (same model as AI agents)
    ↓
[Success] → Show suggested output in preview
    ↓
Team member chooses:
    [Use This] → Populates output textarea
    [Edit & Use] → Populates textarea, allows edits
    [Discard] → Clear suggestion
    ↓
Team member submits output (credited to human)
    ↓
Task status: Done (human submission)
```

---

## Updated Non-Functional Requirements

### NFR26: AI Generation Performance

**NFR26:** AI-generated task outputs shall complete within 60 seconds for tasks up to 1000 words. If generation exceeds 60 seconds, system shall show "Taking longer than usual..." message with option to cancel.

---

### NFR27: AI Error Rate Tolerance

**NFR27:** AI generation failures shall not exceed 5% of all AI task attempts. System shall log all failures for analysis and improvement.

---

### NFR28: AI Cost Tracking

**NFR28:** System shall track token usage and estimated cost for all AI generations to enable usage-based billing or cost monitoring.

---

## Key Insights from AI Agent Perspective

### What Was Missing from Original Section 3

1. **AI as Team Member Model** - Treat AI agents like auto-executing team members
2. **AI Status Indicators** - Real-time generation feedback for managers
3. **"Generate with AI" for Humans** - AI augmentation for team members
4. **Version History for AI** - Iterative improvement through feedback
5. **Error Handling UI** - Graceful failure states and retry mechanisms
6. **Output Versioning System** - Track all attempts (AI and human)

### This Simplifies Implementation

**Good News:**
- AI agents use same task/output data model as humans
- No separate "AI task queue" needed
- Same review/rejection workflow
- Reuse existing UI components with AI-specific badges

**Added Complexity:**
- Async job handling for AI execution
- API rate limiting and error handling
- Token cost tracking (for billing)
- Version history storage and retrieval

---

## Open Questions

### Q1: Context Window for AI

**Should AI agents receive context from other tasks in the brief?**

Example: If Task 1 is "Write blog post" and Task 2 is "Draft email promoting the blog post", should Task 2's AI see Task 1's output?

**Options:**
- A) AI sees only its own task (isolated)
- B) AI sees all completed tasks in same brief (contextual)
- C) Manager selects which tasks are visible to AI (custom)

**Recommendation:** Option B (contextual) - enables coherence across brief

---

### Q2: AI Model Selection

**Can managers choose which AI model to use (GPT-4 vs Claude vs etc.)?**

**MVP Decision:** Single model (GPT-4 or Claude Sonnet) pre-configured
**Post-MVP:** Model selection per agent or per task

---

### Q3: AI Output Length Limits

**Should AI outputs have length constraints?**

**Concern:** Runaway API costs if AI generates 10,000-word outputs
**Mitigation:** Task description includes length guidance ("500-word blog post")

**System Limits:**
- Content Agent: Max 5,000 words
- Email Agent: Max 1,000 words
- Hard cutoff at limits to prevent cost overruns

---

### Q4: Human Override of AI Output

**Can team members edit AI-generated outputs before submission?**

**Scenario:** Manager assigns task to AI, AI generates output, but manager wants human to review/edit before finalizing.

**Solution:** Manager can reassign from AI to human after AI generation. Human sees AI output as "draft" and can edit before submitting.

---

*AI Agent Perspective elicitation complete - AI execution model clarified*
