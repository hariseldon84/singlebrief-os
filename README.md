# SingleBrief - Brief-first Project OS

**Confidence to Act: Transform Planning Paralysis into Execution**

SingleBrief is a Brief-first Project Operating System that eliminates the planning inertia managers face when starting new projects. Instead of creating 100 tasks manually, managers create **one brief** - and the system handles the rest.

---

## The Problem

Managers struggle to start new projects due to:

- **Overwhelming Scope**: Translating vision → concrete steps feels massive
- **Time Scarcity**: Detailed planning takes too long
- **Fear of Incompleteness**: "What am I missing?"
- **Knowledge Gaps**: Lack expertise in certain areas
- **Motivation Deficit**: "Why should we do this?" and "Is this worth my time?"

Traditional project management tools force managers to create detailed task lists upfront, which creates **decision paralysis**.

---

## The Solution

SingleBrief flips the model: **One Brief → AI-Powered Breakdown → Confident Execution**

### Core Value Proposition

**We sell confidence, not task management.**

Confidence comes through:
1. **Visibility into Progress** (primary driver)
2. **Tracking & Roll-up** (brief + project levels)
3. **AI-Powered Breakdown** (intelligent task generation)
4. **Delegation** (AI agents + human team members)
5. **Manager Control** (accept/reject/re-run review loop)
6. **Business Value Clarity** ("Why This Matters" framing)

---

## How It Works

### The 6-Step Confidence Loop

1. **Manager creates brief** (simple text input)
2. **AI breaks down into micro-tasks** (automated decomposition)
3. **Manager reviews and edits tasks** (full control)
4. **Assign to AI agents or humans** (one assignee per task)
5. **Execute + Review cycle** (accept/reject/re-run with feedback)
6. **Track progress** (visibility at brief and project levels)

### "Why This Matters" Feature

After task breakdown, AI generates a business value section including:
- Impact articulation
- Suggested success metrics
- Motivation framing for manager and team

Managers can edit, regenerate, or skip this optional feature.

---

## MVP Features (5-Week Launch)

### Core Capabilities

**Brief Management**
- Create, edit, delete briefs
- Free-form text input
- Search across briefs

**AI Task Breakdown**
- Automatic micro-task generation from brief
- Manual task add/edit/delete
- Full CRUD control

**Task Assignment**
- Assign to 2 pre-built AI agents (Content Writer, Email Drafter)
- Assign to human team members
- Re-assignment capability
- Email notifications for human assignees

**Manager Review Loop**
- View task outputs
- Accept tasks as complete
- Reject with feedback
- Re-run tasks with same or different assignee

**Progress Tracking**
- Brief-level progress indicator (% complete)
- Project-level dashboard
- Task status labels (To Do, In Progress, Under Review, Complete)
- Manual refresh

**Outputs & Deliverables**
- Store task outputs in system
- Download individual outputs
- Export brief to PDF

**Team Management**
- Add/remove team members
- Team member profiles (name, email, avatar)
- Personal workspace per user

**Authentication**
- Email/password signup/login
- Password reset
- User profile settings

**Monetization**
- Invite-only access (controlled launch)
- Manual invoicing (no automated billing in MVP)

---

## Technology Stack

**Frontend**
- React 18 with TypeScript
- Vite (build tool)
- shadcn/ui (component library)
- Tailwind CSS (styling)
- React Router v6 (routing)
- TanStack Query (state management)

**Backend**
- Supabase (authentication, database, storage)
- PostgreSQL (database)
- Row-Level Security (RLS) for data isolation

**AI Integration**
- LLM API (OpenAI/Anthropic) for task breakdown and "Why This Matters" generation
- Pre-built AI agents for task execution

**Development**
- TypeScript with relaxed settings (noImplicitAny: false)
- Path alias: `@/*` → `./src/*`
- Port 8080 for development server

---

## Project Status

**Current Phase:** Brownfield MVP Development

The project has:
- ✅ Foundation code (React + TypeScript + Supabase)
- ✅ Basic authentication scaffolding
- ✅ Database schema (briefs, tasks, projects, team_members)
- ✅ Comprehensive PRD and brainstorming documentation
- 🔄 **In Progress:** Core confidence loop implementation

**Timeline:**
- Weeks 1-4: Core MVP (confidence loop, AI agents, review system)
- Week 5: "Why This Matters" feature + polish
- Week 5+: Invite-only beta launch

---

## Key Differentiators

### vs. Traditional Project Management (Asana, Monday, ClickUp)
- **Brief-first** vs. task-first approach
- **AI-powered breakdown** vs. manual task creation
- **Confidence delivery** vs. feature-based value

### vs. ChatGPT + MCPs + Agents
SingleBrief is **not** a general-purpose AI assistant. It's a **purpose-built confidence platform** for managers that:

1. **Persistent State Management**: Briefs, tasks, and progress live in a structured database, not ephemeral chat conversations
2. **Team Collaboration**: Human team members receive tasks, submit outputs, and collaborate within the system
3. **Manager Review Loop**: Built-in accept/reject/re-run workflow with feedback - not just prompting an AI
4. **Progress Visibility**: Real-time tracking at brief and project levels - not buried in chat history
5. **Accountability & Audit Trail**: All task outputs, decisions, and changes are tracked and auditable
6. **Business Value Framing**: "Why This Matters" is contextualized to the specific brief and organization
7. **Professional Deliverables**: PDF exports, structured outputs, searchable brief history
8. **Integrated Workflow**: One platform for planning, execution, and tracking - not tool-switching between chat and project management

**In short:** ChatGPT helps you *think* about your project. SingleBrief helps you *execute* it with your team.

---

## Development Setup

```bash
# Install dependencies
npm install

# Start development server (port 8080)
npm run dev

# Build for production
npm run build

# Run linter
npm run lint
```

### Environment Variables

Create a `.env` file with:

```
VITE_SUPABASE_URL=your_supabase_url
VITE_SUPABASE_PUBLISHABLE_KEY=your_supabase_anon_key
VITE_SUPABASE_PROJECT_ID=your_project_id
VITE_AI_API_KEY=your_openai_or_anthropic_key
```

---

## Documentation

- **Architecture**: See `CLAUDE.md` for codebase architecture
- **Brainstorming Analysis**: `docs/brainstorming-session-results.md`
- **First Principles**: `docs/tech1.md`
- **Feature Prioritization**: `docs/tech2.md`
- **MVP Constraints**: `docs/tech3.md`
- **PRD**: `docs/prd_section1.md`, `docs/prd_section2.md`

---

## Contributing

This project uses BMAD-Method for agent-based development. See `AGENTS.md` for available development agents and workflows.

---

## License

Proprietary - All Rights Reserved

---

**Built with confidence. Powered by AI. Designed for action.**
