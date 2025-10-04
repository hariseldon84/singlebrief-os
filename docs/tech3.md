# Brainstorming Session - Technique 3: Resource Constraints Challenge

**Session Date:** 2025-10-04
**Product:** SingleBrief - Brief-first Project OS
**Facilitator:** Business Analyst Mary 📊
**Focus:** 4-Week MVP Reality Check

---

## The Challenge

**"You have 4 weeks to launch with Supabase only. What gets cut?"**

Starting with 35 MUST-have features from MoSCoW prioritization, we applied brutal constraints:
- ⏱️ **Timeline:** 4 weeks to launch
- 🛠️ **Tech Stack:** Supabase backend only (no custom servers)
- 👥 **User Base:** Invite-only controlled launch
- 💰 **Monetization:** Manual invoicing (no automated billing)

---

## Features CUT for 4-Week Launch

### AI Agents: 4 → 2

**Original Plan:** 4 AI agents (content, email, calendar, research)

**Reality Check Decision:**
- ❌ **CUT:** Calendar invite agent
- ❌ **CUT:** Research/data gathering agent
- ✅ **KEEP:** Content writing agent
- ✅ **KEEP:** Email draft agent

**Rationale:**
- Content + Email cover widest range of manager tasks
- Proves "AI does work for you" value prop
- Reduces testing and integration complexity
- Calendar & Research can be added post-launch based on demand

**Post-Launch Addition:** Add Calendar and Research agents in weeks 5-8

---

### Summary Document Generation

**Original Plan:** Generate comprehensive brief summary document (all tasks → formatted report)

**Reality Check Decision:**
- ❌ **CUT:** Auto-generated summary document
- ✅ **KEEP:** PDF export of brief view

**Rationale:**
- Summary doc requires templating engine, formatting logic, aggregation complexity
- PDF export of existing brief view achieves same deliverable goal
- Simpler implementation, same user value
- Saves ~3-5 days of development time

**Alternative:** Manager can manually download individual task outputs if needed

---

### Real-Time Updates

**Original Plan:** Real-time updates via websockets/Supabase subscriptions

**Reality Check Decision:**
- ❌ **CUT:** Automatic real-time updates
- ✅ **KEEP:** Manual refresh button

**Rationale:**
- Real-time requires websocket setup, subscription management, complex state handling
- Manual refresh is simple, functional, reliable
- Early users can tolerate clicking refresh
- Saves significant technical complexity
- Can add real-time in v2 based on user feedback

**User Impact:** Minimal - users click refresh to see latest updates

---

### Billing & Subscription Management

**Original Plan:** Automated billing with Stripe integration, subscription handling

**Reality Check Decision:**
- ❌ **CUT:** Automated billing/subscription system
- ✅ **KEEP:** Invite-only with manual invoicing

**Rationale:**
- Stripe integration, webhook handling, invoice generation = 1+ week of work
- Manual invoicing gives control over early customer selection
- Better feedback quality from hand-selected users
- Revenue still possible, just manual process
- Can automate billing in weeks 6-8 after validating product-market fit

**Go-to-Market Impact:** Controlled launch becomes a feature, not a limitation

---

### Search & Filtering

**Original Plan:**
- Filter briefs by status
- Search briefs by keyword

**Reality Check Decision:**
- ❌ **CUT:** Filter by status
- ✅ **KEEP:** Search by keyword only

**Rationale:**
- Search is more flexible (can search for status keywords)
- With invite-only launch, users won't have hundreds of briefs
- Search covers 80% of filtering use cases
- Simpler UI, one input field

**User Impact:** Search "completed" finds all completed briefs - functionally equivalent to filter

---

### Multiple Assignees Per Task

**Original Plan:** Tasks can have multiple assignees (collaborative tasks)

**Reality Check Decision:**
- ❌ **CUT:** Multiple assignees per task
- ✅ **WORKAROUND:** One assignee per task; manager duplicates tasks for collaboration

**Rationale:**
- Multi-assign adds complexity:
  - Assignment UI/UX
  - Notification logic (who gets notified?)
  - Completion logic (all must complete? any one completes?)
  - Progress calculation
- Workaround: Manager creates 2 tasks with same description, assigns to different people
- Keeps data model simple
- Still enables collaboration workflows

**User Impact:** Extra click to duplicate task - acceptable for MVP

---

### Workspace/Organization Management (Multi-Tenant)

**Original Plan:** Multi-workspace system (switch between organizations)

**Reality Check Decision:**
- ❌ **CUT:** Multi-workspace/organization switching
- ✅ **SIMPLIFY:** One personal workspace per user account

**Rationale:**
- Multi-tenancy requires:
  - Workspace switching UI
  - Data isolation logic (RLS policies in Supabase)
  - Invitation flows across workspaces
  - Access control complexity
- Single workspace per user is clean and functional
- Each user manages their own briefs/projects/team
- Can add multi-tenant in v2 when scaling to enterprises

**User Impact:** Each user has their own workspace - simpler mental model for MVP

---

### Tags/Labels for Briefs

**Original Plan:** Tag/label system for organizing briefs

**Reality Check Decision:**
- ❌ **CUT:** Tags/labels
- ✅ **KEEP:** Search only

**Rationale:**
- With status filter already cut, tags less critical
- Search handles organization needs for small brief volumes
- Invite-only users won't have 100s of briefs
- Tag UI, tag management, tag filtering = extra complexity
- Can add tags in v2 based on user requests

**User Impact:** Search is sufficient for MVP brief volumes

---

## What SURVIVED the 4-Week Test

### Core Validated MVP (15 Feature Groups)

**1. Brief Management**
- ✅ Create text-based brief
- ✅ Edit/update brief
- ✅ Delete brief

**2. AI Task Breakdown**
- ✅ AI auto-generates micro-tasks
- ✅ Manually add tasks
- ✅ Edit AI-generated tasks
- ✅ Delete tasks

**3. Task Assignment**
- ✅ Assign to AI agent (2 agents: content, email)
- ✅ Assign to human team member (one per task)
- ✅ Re-assign tasks

**4. Notifications**
- ✅ Notify humans when task assigned

**5. Manager Review Loop**
- ✅ View task output/result
- ✅ Accept task as complete
- ✅ Reject task + provide feedback
- ✅ Re-run task with revisions

**6. Progress & Visibility**
- ✅ Brief-level progress indicator (% complete)
- ✅ Project-level dashboard
- ✅ Task status labels (To Do, In Progress, Under Review, Complete)
- ✅ Manual refresh

**7. Search**
- ✅ Search briefs by keyword

**8. Team Management**
- ✅ Add team members
- ✅ Remove team members
- ✅ Team member profiles (name, email, avatar)

**9. AI Agents (MVP Set)**
- ✅ Content writing agent
- ✅ Email draft agent

**10. Outputs & Deliverables**
- ✅ Task outputs stored in system
- ✅ Download task outputs
- ✅ Export brief to PDF

**11. Authentication**
- ✅ Email/password signup/login
- ✅ Password reset
- ✅ User profile settings

**12. Workspace**
- ✅ Personal workspace per user

**13. Monetization**
- ✅ Invite-only access
- ✅ Manual invoicing

**14. Projects**
- ✅ Create projects (container for briefs)

**15. Core Database (Supabase)**
- ✅ Users, Profiles
- ✅ Workspaces (1:1 with users)
- ✅ Projects
- ✅ Briefs
- ✅ Tasks
- ✅ Task Outputs
- ✅ Team Members
- ✅ Assignments

---

## Simplified 4-Week MVP Loop

### The Confidence Loop (Validated)

1. **Manager creates brief** (text input)
2. **AI breaks into micro-tasks** (automated)
3. **Manager edits/adds/deletes tasks** (full control)
4. **Assign tasks:**
   - To Content Writer AI agent
   - To Email Draft AI agent
   - To human team member (one per task)
5. **Humans get notified** (email notification)
6. **AI/humans execute tasks** (manual trigger for AI)
7. **Manager reviews output:**
   - View result
   - Accept, reject + feedback, or re-run
8. **Progress tracked:**
   - Brief-level % complete
   - Task statuses visible
   - Project dashboard shows all briefs
9. **Search briefs** (find specific briefs)
10. **Download outputs + PDF export** (deliverables)
11. **Manual refresh** (see latest updates)

---

## Core Value Validation

### Does the simplified loop still deliver "Confidence to Act"?

✅ **YES**

**Confidence Mechanisms Still Intact:**

1. ✅ **Visibility into Progress** - Dashboard + brief progress tracking
2. ✅ **Tracking & Roll-up** - Task statuses → brief progress → project view
3. ✅ **AI-Powered Breakdown** - AI still generates comprehensive task lists
4. ✅ **Delegation** - Still can assign to AI (2 agents) or humans
5. ✅ **Design for Strength** - Clean, focused UI without bloat
6. ✅ **Action Enforcement** - Review loop ensures tasks get done, not just planned

**What Changed:**
- Fewer AI agents (but core use cases covered)
- Less automation (manual refresh, manual invoicing)
- Simpler workflows (one assignee, no tags, no filters)

**What Stayed the Same:**
- Core confidence loop intact
- Manager control preserved
- Visibility maintained
- Deliverables still generated

---

## Development Time Saved

Rough estimates of time saved by cuts:

| Feature Cut | Time Saved |
|-------------|------------|
| 2 AI agents (calendar, research) | 3-5 days |
| Summary document generator | 3-5 days |
| Real-time updates | 4-6 days |
| Automated billing/Stripe | 5-7 days |
| Status filtering UI | 1-2 days |
| Multi-assignee logic | 2-3 days |
| Multi-tenant workspaces | 4-6 days |
| Tag management system | 2-3 days |

**Total Time Saved:** ~24-37 days of development work

**Result:** Makes 4-week timeline realistic for core MVP

---

## Post-Launch Roadmap (Weeks 5-12)

Features to add after 4-week launch based on user feedback:

### Quick Wins (Weeks 5-6)
- Add Calendar invite agent
- Add Research agent
- Status filtering (if users request)

### Medium Complexity (Weeks 7-9)
- Real-time updates (if refresh becomes pain point)
- Tags/labels (if organization becomes issue)
- Automated billing/Stripe integration

### Complex Features (Weeks 10-12)
- Multi-assignee tasks (if collaboration demands it)
- Multi-workspace/organization (if enterprise demand)
- Summary document generator (if PDF export insufficient)

---

## Key Insights from Constraint Exercise

### Insight 1: Simplicity Accelerates Launch
Cutting 8 feature areas reduced complexity by ~60% while maintaining core value.

### Insight 2: Manual Processes Are Valid for MVP
Manual refresh, manual invoicing, manual task duplication - all acceptable for invite-only launch.

### Insight 3: AI Breadth vs. Depth Trade-off
2 polished AI agents > 4 half-baked agents. Quality over quantity.

### Insight 4: Invite-Only is a Feature
Controlled launch justifies simpler features (no need for scale on day 1).

### Insight 5: Core Loop is Remarkably Resilient
Even with aggressive cuts, the confidence loop still delivers the fundamental value.

---

## Success Criteria for 4-Week MVP

### Must Prove:
1. ✅ Managers can create a brief and get tasks within 1 minute
2. ✅ AI-generated tasks are useful (>70% acceptance rate)
3. ✅ Review loop works smoothly (accept/reject/re-run feels natural)
4. ✅ Managers feel more confident after using vs. before
5. ✅ At least 1 AI agent is valuable enough to use regularly

### Can Defer Validation:
- Multi-workspace need
- Advanced automation
- Real-time collaboration
- Complex analytics

---

## Final 4-Week MVP Scope Statement

**SingleBrief MVP enables managers to:**

1. Input a brief as free text
2. Receive AI-generated micro-tasks instantly
3. Edit, add, or remove tasks with full control
4. Assign tasks to 2 AI agents (content, email) or human team members
5. Review AI/human outputs and provide feedback
6. Track progress at brief and project levels
7. Search and organize briefs
8. Export deliverables as PDFs
9. Manage a simple team in their personal workspace

**All achievable in 4 weeks with Supabase backend.**

---

*Session Complete: Ready to synthesize into final brainstorming output document*
