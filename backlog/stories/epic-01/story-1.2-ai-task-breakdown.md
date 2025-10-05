# Story 1.2: AI Task Breakdown via n8n

**Story ID:** STORY-1.2
**Epic:** Epic 1 - Brief Creation and AI Task Generation
**Status:** ⬜ To Do
**Last Updated:** 2025-10-05

---

## User Story

**As a** manager
**I want to** submit my brief and get AI-generated task breakdown
**So that** I don't have to manually create tasks

---

## Acceptance Criteria

- [ ] Clicking "Generate Tasks" triggers n8n workflow (FR6)
- [ ] Frontend shows loading state: "Generating tasks..." (FR65)
- [ ] n8n workflow calls OpenRouter API with brief context
- [ ] AI response parsed and tasks inserted into Supabase (FR6)
- [ ] Default task limit: 20 (configurable 5-50 via settings) (FR68)
- [ ] Each task has: title, description, status='To-Do', priority='Medium' (FR7)
- [ ] Tasks returned to frontend and displayed (FR9)
- [ ] Error handling: Show error message if AI call fails, allow retry (FR67)
- [ ] Timeout after 90 seconds with retry option
- [ ] Cost estimation shown before generation (optional for MVP)

---

## Technical Implementation

### n8n Workflow (Visual No-Code)

**Workflow Name:** `Brief Task Breakdown`
**Webhook URL:** `POST /webhook/generate-tasks`

**Nodes:**
1. **Webhook** - Receive POST request
   - Input: `{ brief_id, user_id, jwt_token }`

2. **Function** - Validate JWT token
   ```javascript
   const jwt = items[0].json.jwt_token;
   // Validate JWT (simplified for MVP)
   return items;
   ```

3. **Supabase** - Fetch brief details
   - Query: `SELECT * FROM briefs WHERE id = {{$json.brief_id}}`

4. **Supabase** - Fetch user settings
   - Query: `SELECT default_task_limit FROM user_settings WHERE user_id = {{$json.user_id}}`
   - Default: 20 if not found

5. **HTTP Request** - Call OpenRouter API
   - Method: POST
   - URL: `https://openrouter.ai/api/v1/chat/completions`
   - Headers: `Authorization: Bearer {{$env.OPENROUTER_API_KEY}}`
   - Body:
   ```json
   {
     "model": "openai/gpt-4o-mini",
     "messages": [
       {
         "role": "system",
         "content": "You are a task breakdown assistant. Break the brief into 5-{{task_limit}} actionable, specific tasks. Return JSON array with format: [{title: string, description: string}]"
       },
       {
         "role": "user",
         "content": "Brief Title: {{brief.title}}\n\nBrief Description: {{brief.description}}\n\nGenerate {{task_limit}} tasks."
       }
     ]
   }
   ```

6. **Function** - Parse AI response
   ```javascript
   const response = items[0].json.choices[0].message.content;
   const tasks = JSON.parse(response);

   // Validate task count
   if (tasks.length > task_limit) {
     tasks = tasks.slice(0, task_limit);
   }

   // Add default values
   return tasks.map(task => ({
     ...task,
     brief_id: items[0].json.brief_id,
     status: 'To-Do',
     priority: 'Medium'
   }));
   ```

7. **Supabase** - Batch insert tasks
   - Table: `tasks`
   - Operation: Insert multiple rows

8. **HTTP Response** - Return success
   ```json
   {
     "success": true,
     "task_count": {{$json.length}},
     "tasks": {{$json}}
   }
   ```

### Frontend Integration

```typescript
const generateTasks = async (briefId: string) => {
  setLoading(true);
  try {
    const response = await fetch(`${N8N_WEBHOOK_URL}/generate-tasks`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        brief_id: briefId,
        user_id: user.id,
        jwt_token: session.access_token
      })
    });

    if (!response.ok) throw new Error('Failed to generate tasks');

    const data = await response.json();
    setTasks(data.tasks);
  } catch (error) {
    toast.error('Failed to generate tasks. Please try again.');
  } finally {
    setLoading(false);
  }
};
```

---

## Story Points

**13 points**

**Breakdown:**
- n8n workflow setup: 5 points
- OpenRouter integration: 3 points
- Task parsing & validation: 2 points
- Frontend integration: 2 points
- Error handling & retry: 1 point

---

## Dependencies

- Story 1.1 (Brief Creation Form)
- n8n instance running (SETUP_GUIDE.md Step 2)
- OpenRouter API key configured
- Supabase tasks table exists

---

## Testing Checklist

### n8n Workflow Tests
- [ ] Webhook receives request correctly
- [ ] JWT validation works
- [ ] Brief fetched from Supabase
- [ ] OpenRouter API called successfully
- [ ] AI response parsed correctly
- [ ] Tasks inserted to database
- [ ] Response returned to frontend

### Integration Tests
- [ ] End-to-end: Brief → AI generation → Tasks created
- [ ] Task limit respected (5-50 range)
- [ ] Default values applied (status, priority)
- [ ] Error handling for API timeout
- [ ] Retry mechanism works

### E2E Tests
- [ ] Generate tasks for brief
- [ ] Loading indicator shown
- [ ] Tasks appear after generation
- [ ] Error message shown on failure
- [ ] Retry button works

---

## FRs Covered

- FR6: System shall call n8n workflow to generate tasks via OpenRouter API
- FR7: AI-generated tasks shall have: title, description, status='To-Do', priority='Medium'
- FR65: System shall show "Generating..." indicator when AI executing
- FR67: System shall handle AI errors with retry logic (max 3 attempts)
- FR68: System shall allow configurable task limit (5-50, default 20) in settings

---

## Notes

- **AI Model:** GPT-4o-mini ($0.15/1M input, $0.60/1M output)
- **Cost per brief:** ~$0.0009 (500 words brief → 20 tasks)
- **Timeout:** 90 seconds (safe buffer for slow responses)
- **Prompt engineering:** Critical for quality - iterate based on feedback

---

**Last Updated:** 2025-10-05
**Assignee:** TBD
**Dependencies:** Story 1.1
