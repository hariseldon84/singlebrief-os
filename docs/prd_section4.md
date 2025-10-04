# SingleBrief Brownfield Enhancement PRD - Section 4

## Technical Constraints and Integration Requirements (No-Code MVP Architecture)

**Date:** 2025-10-04
**Version:** 2.0 (Fully No-Code)
**Status:** Draft - Revised for No-Code Implementation

---

## 4.1 No-Code Architecture Philosophy

### 4.1.1 Core Principle: Maximize SaaS, Minimize Coding

**Primary Directive:** "Avoid as much code as possible and use smarter integrations"

**Implementation Strategy:**
- **Frontend:** React components generated via AI tools (v0.dev, Claude Code, GitHub Copilot)
- **Backend Logic:** Visual workflows in n8n (self-hosted) - NO manual coding
- **Database:** Supabase PostgreSQL with auto-generated APIs
- **Auth:** Supabase Auth (built-in, no coding required)
- **AI Calls:** n8n workflows calling OpenRouter API
- **Storage:** Supabase Storage (built-in, no coding required)

**Why This Approach:**
- User stated: "I don't know any coding"
- No Edge Functions to write or maintain
- Visual workflow builder (n8n) for all backend logic
- AI-generated UI components from Figma designs
- Free/low-cost for MVP (0-100 users)

---

### 4.1.2 Technology Stack Overview

**Frontend (AI-Generated Code):**
- React 18.3.1 + TypeScript 5.6.2
- Vite 5.4.2 (build tool)
- shadcn/ui components (Radix UI + Tailwind CSS)
- **Code Generation:** v0.dev (Figma → React) + Claude Code (modifications) + GitHub Copilot (autocomplete)
- **No Manual React Coding Required**

**Backend (100% No-Code):**
- **n8n (self-hosted):** All backend workflows, AI calls, email triggers
- **Supabase:** PostgreSQL database, Auth, Storage, Realtime (future)
- **OpenRouter:** Unified LLM API (GPT-4o-mini, Claude, Gemini, etc.)

**Hosting:**
- **Frontend:** Vercel (free tier, auto-deploy from GitHub)
- **n8n:** Self-hosted on Railway/Fly.io/Docker VPS (~$5/month)
- **Database:** Supabase (free tier → Pro $25/month at scale)

**Cost Breakdown:**
- **MVP (0-100 users):** $0-5/month (just n8n hosting)
- **Scale (500-1K users):** $30-50/month (Supabase Pro $25 + n8n hosting $5 + AI usage $10-20)

---

## 4.2 Frontend Technology Constraints

### 4.2.1 React Framework (AI-Generated)

**TC1: Component Generation Workflow**

System shall use AI tools to generate React components with NO manual coding:

**Step 1: Design in Figma**
- Create component designs in Figma (screens, modals, forms)
- Use Figma Auto Layout for responsive design
- Include all states (loading, error, empty, success)

**Step 2: Generate with v0.dev**
- Paste Figma screenshot into v0.dev
- Prompt: "Create React component with shadcn/ui and Tailwind CSS"
- v0.dev generates JSX + TypeScript code
- Copy generated code into project

**Step 3: Modify with Claude Code**
- Use Claude Code to connect Supabase APIs
- Prompt: "Connect this component to Supabase table 'briefs' with TanStack Query"
- Claude Code adds API integration code
- No manual TypeScript required

**Step 4: Autocomplete with GitHub Copilot**
- GitHub Copilot suggests completions while editing
- Accept suggestions for boilerplate code
- Focus on prompting, not coding

**Rationale:** User doesn't know coding - AI handles all React/TypeScript complexity

---

**TC2: Component Library (shadcn/ui Only)**

System shall ONLY use shadcn/ui components (no other libraries):
- All components pre-built and accessible
- Tailwind CSS styling (utility classes)
- Copy-paste installation via CLI: `npx shadcn@latest add button`

**Required shadcn/ui Components for MVP:**
- alert-dialog, avatar, badge, button, calendar, card, checkbox, collapsible, command, dialog, dropdown-menu, form, input, label, popover, progress, select, separator, slider, tabs, textarea, toast, tooltip

**Rationale:** Consistency, accessibility built-in, AI tools know shadcn/ui patterns well

---

**TC3: TypeScript Configuration**

System shall use strict TypeScript (AI-generated types):
- `strict: true` in tsconfig.json
- AI tools generate proper types automatically
- User doesn't need to write types manually

**Example AI Prompt for Claude Code:**
> "Generate TypeScript interface for Supabase 'briefs' table with columns: id (uuid), user_id (uuid), title (text), description (text), status (enum), created_at (timestamp)"

Claude Code generates:
```typescript
interface Brief {
  id: string;
  user_id: string;
  title: string;
  description: string;
  status: 'draft' | 'active' | 'completed' | 'archived';
  created_at: string;
}
```

**Rationale:** AI handles TypeScript complexity, user just prompts

---

**TC4: Styling (Tailwind CSS Only)**

System shall use Tailwind CSS exclusively:
- No custom CSS files
- No styled-components or CSS-in-JS
- All styling via utility classes: `className="flex items-center gap-2 p-4"`

**AI Generation Pattern:**
- v0.dev generates Tailwind classes automatically
- Claude Code suggests Tailwind utilities
- No CSS knowledge required from user

---

## 4.3 Backend Architecture (n8n No-Code Workflows)

### 4.3.1 Why n8n Over Edge Functions

**User Decision:** "Let us use n8n self-hosted" + "All calls to happen on n8n" + "Fully No-Code for MVP"

**n8n Advantages:**
- **Visual Workflow Builder:** Drag-and-drop nodes, no coding
- **Self-Hosted Free:** Open source, host on $5/month VPS
- **200+ Integrations:** Supabase, OpenRouter, email, webhooks, cron jobs
- **Error Handling:** Built-in retry logic, error workflows
- **Testing:** Built-in test execution, debug mode
- **No Coding Required:** User who doesn't know coding can build workflows

**vs. Edge Functions (Rejected):**
- Edge Functions require TypeScript coding
- Harder to debug (no visual interface)
- User stated "I don't know any coding"

---

### 4.3.2 n8n Architecture Overview

**Architecture Flow:**
```
┌─────────────────────────────────────────────────────┐
│        Frontend (React on Vercel)                   │
│  User clicks "Generate Tasks" button                │
└────────────────┬────────────────────────────────────┘
                 │
                 ▼ Webhook POST /webhook/generate-tasks
┌─────────────────────────────────────────────────────┐
│           n8n (Self-Hosted Workflows)               │
│  ┌──────────────────────────────────────┐          │
│  │ Workflow 1: Brief Task Breakdown     │          │
│  │ 1. Webhook Trigger                   │          │
│  │ 2. Validate JWT (Supabase)           │          │
│  │ 3. Fetch brief from Supabase         │          │
│  │ 4. Call OpenRouter API (GPT-4o-mini) │          │
│  │ 5. Parse AI response                 │          │
│  │ 6. Insert tasks into Supabase        │          │
│  │ 7. Return success response           │          │
│  └──────────────────────────────────────┘          │
└────────────────┬────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────┐
│        OpenRouter API (Unified LLM Gateway)         │
│  Routes to: GPT-4o-mini, Claude, Gemini, etc.      │
└─────────────────────────────────────────────────────┘
```

**Why This Works:**
- Frontend just makes HTTP POST to n8n webhook
- n8n handles ALL backend logic visually
- No TypeScript coding required
- Easy to modify workflows in n8n UI

---

### 4.3.3 Required n8n Workflows

**TC5: n8n Workflow Catalog**

System shall implement following n8n workflows (all visual, no coding):

**Workflow 1: Brief Task Breakdown (FR6)**
- **Trigger:** Webhook POST /webhook/generate-tasks
- **Input:** `{ brief_id, user_id, jwt_token }`
- **Steps:**
  1. Webhook node receives POST
  2. Function node validates JWT token
  3. Supabase node fetches brief details
  4. HTTP Request node calls OpenRouter API
  5. Function node parses AI response (JSON)
  6. Supabase node inserts tasks (batch)
  7. HTTP Response node returns success

**Workflow 2: "Why This Matters" Generation (FR8)**
- **Trigger:** Webhook POST /webhook/generate-why-matters
- **Input:** `{ brief_id, tasks[], jwt_token }`
- **Steps:**
  1. Webhook node receives POST
  2. Function node validates JWT
  3. HTTP Request node calls OpenRouter
  4. Supabase node updates brief with "Why This Matters"
  5. HTTP Response node returns result

**Workflow 3: AI Task Execution (FR62-67)**
- **Trigger:** Webhook POST /webhook/execute-ai-task
- **Input:** `{ task_id, jwt_token }`
- **Steps:**
  1. Webhook receives request
  2. Supabase fetches task + brief context
  3. HTTP Request calls OpenRouter
  4. Supabase updates task output
  5. Email notification sent (optional)

**Workflow 4: AI Batch Queue Processor (FR75-76)**
- **Trigger:** Cron (every 5 minutes)
- **Steps:**
  1. Schedule Trigger node (every 5 minutes)
  2. Supabase node fetches tasks with status='Queued'
  3. Loop node processes each task (5-second delay between)
  4. For each: Call Workflow 3 via HTTP Request
  5. Email node sends summary when all complete

**Workflow 5: Email Notifications (TC25)**
- **Trigger:** Webhook POST /webhook/send-notification
- **Input:** `{ user_id, notification_type, data }`
- **Steps:**
  1. Webhook receives request
  2. Switch node based on notification_type
  3. Supabase fetches user email
  4. Email node sends (via Supabase SMTP or Resend)

**Workflow 6: Task Due Reminders (FR85)**
- **Trigger:** Cron (daily at 9am)
- **Steps:**
  1. Schedule Trigger (daily)
  2. Supabase queries tasks due in 24 hours
  3. Loop through tasks
  4. Call Workflow 5 for each reminder

---

### 4.3.4 n8n Deployment Strategy

**TC6: n8n Self-Hosting Options**

System shall self-host n8n on one of these platforms:

**Option A: Railway (Recommended for MVP)**
- Cost: $5/month (hobby plan)
- Setup: Click "Deploy n8n Template" button
- Includes: PostgreSQL database for n8n (separate from Supabase)
- Auto-scaling: Handles 100+ workflows easily
- HTTPS: Automatic SSL certificate

**Option B: Fly.io**
- Cost: ~$5-10/month (pay-as-you-go)
- Setup: Deploy via CLI (one command)
- Global edge network (low latency)

**Option C: Docker on VPS (DigitalOcean/Hetzner)**
- Cost: $5-6/month (cheapest VPS)
- Setup: Docker Compose file (copy-paste)
- Full control, but requires basic server management

**Recommendation:** Railway for MVP (easiest, zero config), migrate to VPS if cost becomes issue

---

**TC7: n8n Configuration**

System shall configure n8n with following settings:

**Environment Variables (Railway):**
```bash
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=[secure-password]
N8N_HOST=https://your-n8n.up.railway.app
WEBHOOK_URL=https://your-n8n.up.railway.app
EXECUTIONS_MODE=regular
```

**Credentials in n8n UI (Visual Setup):**
1. **Supabase Credential:**
   - Type: "Supabase" node
   - Host: `https://xxx.supabase.co`
   - Service Role Key: `eyJhbGc...` (from Supabase dashboard)

2. **OpenRouter Credential:**
   - Type: "HTTP Request" node with Header Auth
   - Authorization: `Bearer [OpenRouter API key]`
   - Base URL: `https://openrouter.ai/api/v1`

3. **Email Credential (Resend):**
   - Type: "Email" node or "HTTP Request"
   - API Key: `re_xxx` (from Resend dashboard)
   - Or use Supabase Auth SMTP (already configured)

**No Coding Required:** All setup done via n8n visual UI

---

## 4.4 Database Architecture (Supabase)

### 4.4.1 Supabase as Single Backend

**TC8: Supabase Services Used**

System shall use Supabase for ALL backend services (user chose Supabase over Clerk):

**Services:**
- **PostgreSQL Database:** All data storage
- **Supabase Auth:** User authentication (NOT Clerk)
- **Supabase Storage:** File uploads for tasks
- **Supabase Realtime:** Future upgrade from polling (when >50 users)
- **Auto-Generated REST API:** No API coding required
- **Auto-Generated TypeScript Types:** Generated via Supabase CLI

**Why NOT Clerk:** User chose "Let us use Supabase Auth only as we are already using Supabase"

---

**TC9: Database Schema (Auto-Generated APIs)**

System shall use Supabase auto-generated REST APIs (no manual API coding):

**Example: Fetch Briefs**
```typescript
// Frontend code (AI-generated by Claude Code)
const { data: briefs } = await supabase
  .from('briefs')
  .select('*')
  .eq('user_id', userId)
  .order('created_at', { ascending: false });
```

**Supabase Handles:**
- REST endpoint generation (`GET /rest/v1/briefs`)
- GraphQL endpoint (optional)
- Row-Level Security enforcement
- Type generation for TypeScript

**User Doesn't Write:**
- API routes
- Controllers
- Validation logic (handled by RLS)

---

**TC10: Row-Level Security (RLS) Policies**

System shall use Supabase RLS for access control (no backend code):

**Example RLS Policy (Written in SQL, Applied via Supabase Dashboard):**
```sql
-- Briefs: Users can only see their own briefs OR briefs with tasks assigned to them
CREATE POLICY "Users can view accessible briefs"
ON briefs FOR SELECT
TO authenticated
USING (
  auth.uid() = user_id OR
  id IN (
    SELECT brief_id FROM tasks
    WHERE assigned_to = auth.uid()
  )
);
```

**How User Creates Policies:**
1. Open Supabase Dashboard → Authentication → Policies
2. Click "New Policy" button
3. Copy-paste SQL from PRD (provided by AI)
4. Click "Save"

**No Coding Required:** SQL provided, just copy-paste

---

### 4.4.2 Database Performance

**TC11: Indexes for Performance**

System shall create indexes for fast queries:

**How to Create (Supabase Dashboard):**
1. Open Supabase SQL Editor
2. Paste index creation SQL (provided below)
3. Click "Run"

**Required Indexes (Copy-Paste SQL):**
```sql
-- Briefs
CREATE INDEX idx_briefs_user_id ON briefs(user_id);
CREATE INDEX idx_briefs_status ON briefs(status);
CREATE INDEX idx_briefs_updated_at ON briefs(updated_at DESC);

-- Tasks
CREATE INDEX idx_tasks_brief_id ON tasks(brief_id);
CREATE INDEX idx_tasks_assigned_to ON tasks(assigned_to);
CREATE INDEX idx_tasks_status ON tasks(status);
CREATE INDEX idx_tasks_due_date ON tasks(due_date) WHERE due_date IS NOT NULL;

-- Task Comments
CREATE INDEX idx_task_comments_task_id ON task_comments(task_id);

-- Notifications
CREATE INDEX idx_notifications_user_id_unread ON notifications(user_id, is_read, created_at DESC);
```

**Performance Targets:**
- Dashboard query: <100ms
- Task list query: <50ms
- Search query: <200ms

---

## 4.5 AI Integration (OpenRouter + n8n)

### 4.5.1 Why OpenRouter (User's Choice)

**TC12: OpenRouter as Unified LLM Gateway**

System shall use OpenRouter for ALL AI calls (user chose OpenRouter):

**Why OpenRouter:**
- **Unified API:** One API for 100+ models (GPT-4, Claude, Gemini, Llama, etc.)
- **Easy Model Switching:** Change model in n8n workflow (no code changes)
- **Cost Optimization:** Compare prices across providers in real-time
- **Fallback Support:** If GPT-4o-mini fails, fallback to Claude Haiku automatically
- **No Rate Limits:** OpenRouter handles rate limiting across providers

**Example OpenRouter API Call (in n8n HTTP Request Node):**
```json
{
  "method": "POST",
  "url": "https://openrouter.ai/api/v1/chat/completions",
  "headers": {
    "Authorization": "Bearer {{ $credentials.openrouter.apiKey }}",
    "Content-Type": "application/json"
  },
  "body": {
    "model": "openai/gpt-4o-mini",
    "messages": [
      {
        "role": "system",
        "content": "You are a task breakdown assistant..."
      },
      {
        "role": "user",
        "content": "{{ $json.brief_description }}"
      }
    ]
  }
}
```

**n8n Visual Setup (No Coding):**
1. Add "HTTP Request" node
2. Set method: POST
3. Set URL: `https://openrouter.ai/api/v1/chat/completions`
4. Add Header: `Authorization` = `Bearer sk-or-xxx`
5. Add Body (JSON): Paste above template
6. Done - no coding required

---

**TC13: Model Selection Strategy**

System shall use following models via OpenRouter:

**Primary Model (MVP):**
- **openai/gpt-4o-mini** ($0.15/1M input, $0.60/1M output)
- Best cost/quality ratio for task breakdown
- 128K context window (plenty for briefs)

**Fallback Models (If GPT-4o-mini Fails):**
1. **anthropic/claude-3-haiku** ($0.25/1M input, $1.25/1M output)
2. **google/gemini-flash** (Free tier available)

**Upgrade Models (If Quality Insufficient):**
1. **openai/gpt-4o** ($2.50/1M input, $10/1M output)
2. **anthropic/claude-3.5-sonnet** ($3/1M input, $15/1M output)

**Switching Models in n8n:**
- Change `"model": "openai/gpt-4o-mini"` to `"model": "openai/gpt-4o"`
- No code changes required
- Click "Save" in n8n workflow

---

### 4.5.2 AI Workflow Implementation (n8n)

**TC14: Brief Task Breakdown Workflow (FR6)**

System shall implement AI task breakdown in n8n (visual, no coding):

**n8n Workflow Nodes:**

1. **Webhook Node** (Trigger)
   - Method: POST
   - Path: `/webhook/generate-tasks`
   - Response Mode: Last Node

2. **Function Node** (Validate JWT)
   ```javascript
   // Minimal code (n8n provides template)
   const jwt = $json.jwt_token;
   const valid = jwt.startsWith('eyJ'); // Basic validation
   return { jwt_valid: valid, user_id: $json.user_id };
   ```

3. **Supabase Node** (Fetch Brief)
   - Operation: Select Rows
   - Table: briefs
   - Filter: `id = {{ $json.brief_id }}`
   - Return Fields: title, description, user_id

4. **HTTP Request Node** (Call OpenRouter)
   - Method: POST
   - URL: `https://openrouter.ai/api/v1/chat/completions`
   - Body: See TC12 example
   - Response: JSON with tasks array

5. **Function Node** (Parse AI Response)
   ```javascript
   // n8n template
   const tasks = JSON.parse($json.response.choices[0].message.content);
   return tasks.map(task => ({
     brief_id: $json.brief_id,
     title: task.title,
     description: task.description,
     status: 'To-Do'
   }));
   ```

6. **Supabase Node** (Insert Tasks - Batch)
   - Operation: Insert Rows
   - Table: tasks
   - Rows: `{{ $json }}` (from previous node)

7. **HTTP Response Node** (Return Success)
   - Status: 200
   - Body: `{ success: true, task_count: {{ $json.length }} }`

**Total Setup Time:** ~15 minutes in n8n visual UI (no coding)

---

## 4.6 Authentication (Supabase Auth)

### 4.6.1 Why Supabase Auth (Not Clerk)

**TC15: Supabase Auth Implementation**

System shall use Supabase Auth ONLY (user rejected Clerk):

**User Decision:** "Let us use Supabase Auth only as we are already using Supabase"

**Supabase Auth Features:**
- Email + Password authentication
- Magic link (passwordless) login
- Email verification
- Password reset flows
- JWT token generation
- Built-in SMTP (50 emails/hour free)

**Why NOT Clerk:**
- Extra cost ($25/month at scale)
- Extra integration complexity
- Supabase Auth already included (free)

**Frontend Integration (AI-Generated by Claude Code):**
```typescript
// Login (AI-generated code)
const { data, error } = await supabase.auth.signInWithPassword({
  email: 'user@example.com',
  password: 'password123'
});

// Magic link (AI-generated code)
const { error } = await supabase.auth.signInWithOtp({
  email: 'user@example.com'
});
```

**No Manual Coding:** Claude Code generates auth integration from prompt

---

**TC16: Team Member Invitation Flow**

System shall use Supabase Auth magic links for invitations (FR33):

**n8n Workflow for Invitations:**

1. **Webhook Node** (Trigger)
   - POST /webhook/invite-team-member
   - Input: `{ email, inviter_id, jwt_token }`

2. **Supabase Node** (Create Invite Record)
   - Table: invitations
   - Insert: `{ email, inviter_id, status: 'pending' }`

3. **HTTP Request Node** (Send Magic Link via Supabase)
   - Method: POST
   - URL: `https://xxx.supabase.co/auth/v1/magiclink`
   - Headers: `apikey: [supabase-anon-key]`
   - Body: `{ email: {{ $json.email }} }`

4. **HTTP Response Node**
   - Return: `{ success: true, invite_sent: true }`

**User Experience:**
1. Manager enters email in UI
2. Frontend calls n8n webhook
3. n8n sends magic link via Supabase
4. Team member clicks link → Auto-signed up

**No Email Template Coding:** Supabase provides default templates

---

## 4.7 File Storage (Supabase Storage)

### 4.7.1 File Upload Implementation

**TC17: Supabase Storage Configuration**

System shall use Supabase Storage for task file uploads (FR73):

**Setup (Supabase Dashboard, No Coding):**
1. Open Supabase → Storage → Create Bucket
2. Bucket Name: `task-attachments`
3. Public Access: OFF (private files only)
4. File Size Limit: 10MB (set in bucket settings)
5. Allowed Types: Images, PDFs, Documents

**RLS Policy (Copy-Paste SQL):**
```sql
-- Users can upload files for their tasks
CREATE POLICY "Users can upload task files"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'task-attachments' AND
  auth.uid() IN (
    SELECT assigned_to FROM tasks
    WHERE id::text = (storage.foldername(name))[1]
  )
);
```

**Frontend Upload (AI-Generated by Claude Code):**
```typescript
// User prompt: "Add file upload for task with progress bar"
// Claude Code generates:
const { data, error } = await supabase.storage
  .from('task-attachments')
  .upload(`${taskId}/${file.name}`, file, {
    onUploadProgress: (progress) => {
      setUploadProgress((progress.loaded / progress.total) * 100);
    }
  });
```

**No Manual Coding:** AI generates upload logic from prompt

---

## 4.8 Search (Supabase PostgreSQL)

### 4.8.1 Full-Text Search

**TC18: PostgreSQL Full-Text Search**

System shall use Supabase built-in PostgreSQL search (no external service):

**User Decision:** "Let us use Supabase" (rejected Algolia)

**Why PostgreSQL Search:**
- Already included in Supabase (free)
- No extra service to manage
- Good enough for <10K briefs (MVP scale)
- Upgrade to Algolia post-MVP if needed

**Setup (SQL, No Coding):**
```sql
-- Add search column (copy-paste in Supabase SQL Editor)
ALTER TABLE briefs ADD COLUMN search_vector tsvector;

-- Create search index
CREATE INDEX idx_briefs_search ON briefs USING gin(search_vector);

-- Auto-update search vector (trigger)
CREATE TRIGGER briefs_search_update
BEFORE INSERT OR UPDATE ON briefs
FOR EACH ROW EXECUTE FUNCTION
tsvector_update_trigger(search_vector, 'pg_catalog.english', title, description);
```

**Frontend Search (AI-Generated):**
```typescript
// Prompt: "Add search for briefs by title and description"
// Claude Code generates:
const { data } = await supabase
  .from('briefs')
  .select('*')
  .textSearch('search_vector', searchQuery);
```

**Performance:** <200ms for searches across 10K briefs

---

## 4.9 Email (Supabase SMTP → Resend)

### 4.9.1 Email Strategy

**TC19: Email Service Selection**

System shall start with Supabase Auth SMTP, upgrade to Resend at scale:

**User Decisions:**
- "Start with Supabase Auth SMTP, upgrade to Resend when you hit 50 emails/hour"
- "Let us use Supabase" (initial choice)

**Phase 1: MVP (0-100 users) - Supabase Auth SMTP**
- Free tier: 50 emails/hour
- Sufficient for: Auth emails, invitations, critical notifications
- Setup: Already configured (no action needed)

**Phase 2: Scale (>100 users) - Resend API**
- Cost: $0 for 3K emails/month, $20 for 50K emails/month
- Setup via n8n: Add "HTTP Request" node for Resend API
- Better deliverability, analytics, template management

**Email Workflow (n8n):**

1. **Webhook Node** (Trigger)
   - POST /webhook/send-email
   - Input: `{ user_id, template, data }`

2. **Supabase Node** (Fetch User Email)
   - Select from auth.users

3. **Switch Node** (Choose Service)
   - If email_count_today < 50 → Supabase SMTP
   - Else → Resend API

4. **HTTP Request Node** (Send Email)
   - **Option A (Supabase):** Use Supabase Admin API
   - **Option B (Resend):** POST to `https://api.resend.com/emails`

**No Email Server Management:** Fully managed services

---

## 4.10 Real-Time Updates (Polling → Supabase Realtime)

### 4.10.1 Polling Strategy (MVP)

**TC20: Polling Implementation**

System shall use 30-second polling for MVP (user approved):

**User Decision:** "Start with polling, switch to Supabase Realtime (free, already included) when we have >50 active users"

**Frontend Polling (AI-Generated by Claude Code):**
```typescript
// Prompt: "Add 30-second polling for task updates"
// Claude Code generates:
const { data: tasks } = useQuery({
  queryKey: ['tasks', briefId],
  queryFn: () => supabase.from('tasks').select('*').eq('brief_id', briefId),
  refetchInterval: 30000, // 30 seconds
  refetchOnWindowFocus: true
});
```

**Optimization:**
- Pause polling when tab inactive (Page Visibility API)
- Only poll active briefs (not archived)
- Use `updated_at` to detect changes (index required)

**When to Migrate to Realtime:**
- >50 concurrent users
- User complaints about delays
- Mobile app launch (realtime better for mobile)

---

### 4.10.2 Supabase Realtime (Future)

**TC21: Realtime Migration Path**

System shall migrate to Supabase Realtime when scale requires:

**Migration (Supabase Dashboard, No Coding):**
1. Open Supabase → Database → Replication
2. Enable replication for tables: briefs, tasks, task_comments
3. Click "Enable Realtime"

**Frontend Update (AI-Generated):**
```typescript
// Prompt: "Replace polling with Supabase Realtime subscriptions"
// Claude Code generates:
const subscription = supabase
  .channel('tasks')
  .on('postgres_changes', {
    event: '*',
    schema: 'public',
    table: 'tasks',
    filter: `brief_id=eq.${briefId}`
  }, (payload) => {
    queryClient.setQueryData(['tasks', briefId], (old) => {
      // Update local cache with new data
    });
  })
  .subscribe();
```

**Cost:** Included in Supabase Free tier (no extra charge)

**Performance:** <100ms latency for updates

---

## 4.11 Monitoring and Analytics

### 4.11.1 Analytics (Vercel Analytics)

**TC22: Vercel Analytics Implementation**

System shall use Vercel Analytics (free tier, zero setup):

**User Decision:** "Vercel Analytics free tier (automatic, zero setup) for now"

**Setup:**
1. Deploy to Vercel
2. Analytics automatically enabled (no config needed)

**Metrics Tracked (Automatic):**
- Page views
- Unique visitors
- Top pages
- Referrers
- Countries
- Devices/browsers

**Web Vitals (Automatic):**
- LCP (Largest Contentful Paint)
- FID (First Input Delay)
- CLS (Cumulative Layout Shift)
- TTFB (Time to First Byte)

**Cost:** $0 (free tier, 100K events/month)

**No Setup Required:** Deploy and done

---

### 4.11.2 Error Tracking (Sentry)

**TC23: Sentry Integration**

System shall use Sentry free tier for error tracking:

**User Decision:** "Sentry free tier (5K errors/month = ~160/day, plenty for MVP)"

**Setup (Sentry Dashboard, 5 Minutes):**
1. Create Sentry account (free)
2. Create new project (React + Vite)
3. Copy DSN: `https://xxx@xxx.ingest.sentry.io/xxx`
4. Add to `.env`: `VITE_SENTRY_DSN=...`

**Frontend Integration (AI-Generated):**
```typescript
// Prompt: "Add Sentry error tracking to main.tsx"
// Claude Code generates:
import * as Sentry from "@sentry/react";

Sentry.init({
  dsn: import.meta.env.VITE_SENTRY_DSN,
  environment: import.meta.env.MODE,
  tracesSampleRate: 0.1,
});
```

**n8n Error Tracking:**
- n8n has built-in error workflow triggers
- Configure error workflow to POST errors to Sentry API

**Cost:** $0 (5K errors/month free)

---

## 4.12 Deployment and CI/CD

### 4.12.1 Hosting (Vercel)

**TC24: Vercel Deployment**

System shall deploy frontend to Vercel (free tier):

**User Decision:** "Vercel is good to go"

**Setup (One-Time, 5 Minutes):**
1. Connect GitHub repo to Vercel
2. Vercel auto-detects Vite config
3. Add environment variables:
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`
   - `VITE_N8N_WEBHOOK_URL`
4. Click "Deploy"

**Auto-Deploy on Git Push:**
- Push to `main` branch → Production deploy
- Push to feature branch → Preview deploy (unique URL)

**Cost:** $0 (free tier, 100GB bandwidth/month)

**Custom Domain:** Add custom domain in Vercel dashboard (free HTTPS)

---

### 4.12.2 Database Migrations (Supabase)

**TC25: Supabase Migration Workflow**

System shall use Supabase CLI for database migrations:

**Setup (One-Time):**
```bash
# Install Supabase CLI
npm install -g supabase

# Link to project
supabase link --project-ref xxx

# Pull existing schema
supabase db pull
```

**Creating Migrations:**
```bash
# Create new migration
supabase migration new add_task_comments_table

# Edit SQL file in supabase/migrations/xxx_add_task_comments_table.sql
# Example:
CREATE TABLE task_comments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  task_id uuid REFERENCES tasks(id) ON DELETE CASCADE,
  user_id uuid REFERENCES auth.users(id),
  comment text NOT NULL,
  created_at timestamptz DEFAULT now()
);

# Apply migration
supabase db push
```

**No Manual SQL Knowledge Required:** Copy-paste migration SQL from PRD documentation

---

### 4.12.3 CI/CD Pipeline

**TC26: GitHub Actions (Optional, Post-MVP)**

System shall use GitHub Actions for automated testing:

**Minimal CI/CD (MVP):**
- Vercel handles deployments (auto-deploy on push)
- Supabase CLI handles migrations (manual `supabase db push`)
- No automated tests initially (add post-MVP)

**Post-MVP CI/CD (GitHub Actions):**
```yaml
# .github/workflows/deploy.yml
name: Deploy
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: npm install
      - run: npm run typecheck
      - run: npm run lint
      - run: supabase db push --dry-run # Check migrations
      # Vercel deploys automatically
```

**For MVP:** Skip CI/CD complexity, deploy manually

---

## 4.13 Cost Breakdown

### 4.13.1 Monthly Costs (Detailed)

**TC27: Cost Estimates**

**MVP Phase (0-100 users):**

| Service | Tier | Cost | Notes |
|---------|------|------|-------|
| Vercel | Free | $0 | 100GB bandwidth, auto-deploy |
| Supabase | Free | $0 | 500MB DB, 1GB storage, 2GB bandwidth |
| n8n Hosting | Railway Hobby | $5 | Self-hosted workflows |
| OpenRouter AI | Pay-per-use | $5-10 | ~1K brief generations/month |
| Sentry | Free | $0 | 5K errors/month |
| Resend Email | Free | $0 | 3K emails/month (not needed yet) |
| **TOTAL** | | **$10-15/month** | |

**Scale Phase (500-1K users):**

| Service | Tier | Cost | Notes |
|---------|------|------|-------|
| Vercel | Pro | $20 | Better analytics, more bandwidth |
| Supabase | Pro | $25 | 8GB DB, 100GB storage |
| n8n Hosting | Railway Pro | $20 | More resources for workflows |
| OpenRouter AI | Pay-per-use | $50-100 | ~10K brief generations/month |
| Sentry | Team | $26 | 50K errors/month |
| Resend Email | Paid | $20 | 50K emails/month |
| **TOTAL** | | **$161-211/month** | |

**Comparison to Original Architecture (Rejected):**
- **Old (Clerk + Pipedream):** $0 MVP → $70-120 scale (Clerk $25 + Pipedream $19 + Supabase $25)
- **New (n8n + Supabase Auth):** $10-15 MVP → $90-145 scale (n8n $20 + Supabase $25 + OpenRouter $50)
- **Difference:** ~$25/month higher at scale, but fully no-code (worth it for maintainability)

---

## 4.14 Development Workflow (No-Code)

### 4.14.1 Component Development Workflow

**TC28: Building UI Components (No Coding)**

**Step-by-Step Process:**

**1. Design Phase (Figma):**
- Create screen design in Figma
- Include all states: default, loading, error, empty, success
- Use Figma components for consistency
- Add annotations for interactions

**2. Code Generation (v0.dev):**
- Screenshot Figma design
- Paste into v0.dev with prompt:
  > "Create React component with shadcn/ui, TypeScript, and Tailwind CSS. Include loading and error states."
- v0.dev generates complete component code
- Copy code to clipboard

**3. Integration (Claude Code):**
- Paste code into VS Code
- Open Claude Code chat
- Prompt:
  > "Connect this component to Supabase table 'briefs' using TanStack Query. Add real-time polling every 30 seconds."
- Claude Code adds Supabase integration
- Accept changes

**4. Testing (Manual):**
- `npm run dev` to start dev server
- Test component in browser
- Use React DevTools to inspect state

**5. Deployment:**
- `git add .`
- `git commit -m "Add brief list component"`
- `git push origin main`
- Vercel auto-deploys in 2 minutes

**Total Time:** ~30 minutes per component (vs. 2-3 hours manual coding)

---

### 4.14.2 n8n Workflow Development

**TC29: Building Backend Workflows (Visual, No Coding)**

**Step-by-Step Process:**

**1. Open n8n Editor:**
- Navigate to `https://your-n8n.up.railway.app`
- Login with basic auth
- Click "New Workflow"

**2. Add Nodes (Drag-and-Drop):**
- Drag "Webhook" node (trigger)
- Drag "Supabase" node (fetch data)
- Drag "HTTP Request" node (call OpenRouter)
- Drag "Function" node (parse response)
- Drag "Supabase" node (insert data)
- Connect nodes with lines

**3. Configure Nodes (Visual Forms):**
- Click each node
- Fill in forms (no coding):
  - Webhook: Set path `/webhook/generate-tasks`
  - Supabase: Select table, set filters
  - HTTP Request: Paste OpenRouter API details
  - Function: Paste JavaScript template (provided in PRD)

**4. Test Workflow:**
- Click "Execute Workflow" button
- n8n shows results at each step
- Debug any errors visually

**5. Activate Workflow:**
- Click "Active" toggle
- Workflow now listens for webhooks

**6. Get Webhook URL:**
- Copy webhook URL: `https://your-n8n.up.railway.app/webhook/generate-tasks`
- Add to frontend `.env`: `VITE_N8N_WEBHOOK_URL=...`

**Total Time:** ~20 minutes per workflow (vs. 1-2 hours coding Edge Functions)

---

### 4.14.3 Database Changes Workflow

**TC30: Making Database Changes (SQL, No Backend Coding)**

**Step-by-Step Process:**

**1. Plan Schema Change:**
- Document new table/column in PRD
- Example: "Add `priority` column to tasks table"

**2. Generate Migration SQL (Claude Code):**
- Prompt Claude Code:
  > "Generate Supabase migration SQL to add 'priority' enum column to tasks table. Values: High, Medium, Low. Default: Medium."
- Claude Code generates:
```sql
ALTER TABLE tasks ADD COLUMN priority text CHECK (priority IN ('High', 'Medium', 'Low')) DEFAULT 'Medium';
CREATE INDEX idx_tasks_priority ON tasks(priority);
```

**3. Apply Migration (Supabase Dashboard):**
- Open Supabase SQL Editor
- Paste generated SQL
- Click "Run"
- Verify success

**4. Update TypeScript Types (Auto-Generated):**
```bash
# Run Supabase CLI to regenerate types
supabase gen types typescript --project-id xxx > src/types/supabase.ts
```

**5. Update Frontend (AI-Generated):**
- Prompt Claude Code:
  > "Update TaskCard component to show priority badge (High=red, Medium=yellow, Low=gray)"
- Claude Code updates component with new field

**Total Time:** ~10 minutes per schema change

---

## 4.15 Open Technical Questions

**Q1:** n8n Hosting - Railway ($5/month) or VPS ($5/month)?
- **Recommendation:** Railway for MVP (easier), migrate to VPS if needed

**Q2:** OpenRouter Model - Start with GPT-4o-mini or Claude Haiku?
- **Recommendation:** GPT-4o-mini (cheaper, good quality)

**Q3:** Email Service - When to migrate from Supabase SMTP to Resend?
- **Recommendation:** Migrate at 50 emails/hour (Supabase limit) or 100 active users

**Q4:** Realtime Migration - When to migrate from polling to Supabase Realtime?
- **Recommendation:** Migrate at 50 concurrent users or user complaints

**Q5:** PostgreSQL Search - When to migrate to Algolia?
- **Recommendation:** Migrate at 10K briefs or <500ms search performance

---

## 4.16 Technical Constraints Summary

**No-Code Constraints:**
- ✅ **Frontend:** AI-generated React code (v0.dev + Claude Code + Copilot)
- ✅ **Backend:** n8n visual workflows (NO Edge Functions coding)
- ✅ **Database:** Supabase auto-generated APIs (NO API coding)
- ✅ **Auth:** Supabase Auth (NO Clerk, NO custom auth code)
- ✅ **AI:** OpenRouter via n8n (NO backend AI integration code)
- ✅ **Storage:** Supabase Storage (NO custom upload code)
- ✅ **Search:** PostgreSQL full-text (NO Algolia integration)
- ✅ **Email:** Supabase SMTP → Resend (NO email server setup)
- ✅ **Realtime:** Polling → Supabase Realtime (NO WebSocket coding)

**User Requirement Met:** "I don't know any coding" + "Fully No-Code for MVP please" ✅

**Cost:** $10-15/month MVP → $90-145/month at scale ✅

**Maintainability:** All workflows visual, easy to modify ✅

---

**Section 4 Complete - No-Code Technical Architecture Defined**

**Next Section:** Section 5 - Epic and Story Structure
