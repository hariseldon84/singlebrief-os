# Brainstorming Session - Technique 2: MoSCoW Prioritization

**Session Date:** 2025-10-04
**Product:** SingleBrief - Brief-first Project OS
**Facilitator:** Business Analyst Mary 📊
**Focus:** MVP Feature Categorization

---

## MoSCoW Framework

- **MUST Have** = MVP dies without this - critical for launch
- **SHOULD Have** = Important but can launch without it
- **COULD Have** = Nice-to-have if time permits
- **WON'T Have** = Explicitly deferred to v2+

---

## Feature Categorization Results

### 1. Core Brief Management

| # | Feature | Priority |
|---|---------|----------|
| 1 | Create text-based brief | ✅ MUST |
| 2 | Edit/update brief after creation | ✅ MUST |
| 3 | Delete a brief | ✅ MUST |
| 4 | Archive completed briefs | ❌ WON'T |
| 5 | Brief templates | 💡 COULD |

**Key Decision:** Keep brief management ultra-simple. Archive can wait - delete is enough for MVP.

---

### 2. AI Task Breakdown

| # | Feature | Priority |
|---|---------|----------|
| 6 | AI breaks brief into micro-tasks automatically | ✅ MUST |
| 7 | Manager can manually add tasks | ✅ MUST |
| 8 | Manager can edit AI-generated tasks | ✅ MUST |
| 9 | Manager can delete AI-generated tasks | ✅ MUST |
| 10 | AI suggests task dependencies | 🟡 SHOULD |
| 11 | AI estimates time/effort per task | ❌ WON'T |

**Key Decision:** Full CRUD control over tasks (AI + manual). Dependencies are nice but not critical. Time estimates deferred.

---

### 3. Task Assignment & Execution

| # | Feature | Priority |
|---|---------|----------|
| 12 | Assign task to pre-built AI agent | ✅ MUST |
| 13 | Assign task to human team member | ✅ MUST |
| 14 | Re-assign task | ✅ MUST |
| 15 | Task can have multiple assignees | ✅ MUST |
| 16 | AI agent executes automatically | ❌ WON'T |
| 17 | Human gets notified when assigned | ✅ MUST |

**Key Decision:** AI agents need manual triggering (no auto-execution in MVP). Simplifies complexity. Collaborative tasks (multi-assignee) are critical.

---

### 4. Manager Review & Feedback

| # | Feature | Priority |
|---|---------|----------|
| 18 | View task output/result | ✅ MUST |
| 19 | Accept task as complete | ✅ MUST |
| 20 | Reject task and provide feedback | ✅ MUST |
| 21 | Re-run task | ✅ MUST |
| 22 | Comment thread on tasks | ❌ WON'T |
| 23 | Version history of task outputs | 💡 COULD |

**Key Decision:** Core review loop (view → accept/reject → re-run) is MUST. Comments deferred. Version history is nice-to-have.

---

### 5. Progress Tracking & Visibility

| # | Feature | Priority |
|---|---------|----------|
| 24 | Brief-level progress indicator | ✅ MUST |
| 25 | Project-level dashboard | ✅ MUST |
| 26 | Task status labels | ✅ MUST |
| 27 | Filter briefs by status | ✅ MUST |
| 28 | Search briefs by keyword | ✅ MUST |
| 29 | Activity feed/timeline | 🟡 SHOULD |
| 30 | Real-time updates | ✅ MUST |

**Key Decision:** Visibility is PRIMARY confidence driver - everything here is MUST except activity feed. Real-time updates critical for trust.

---

### 6. Team Management

| # | Feature | Priority |
|---|---------|----------|
| 31 | Add team members | ✅ MUST |
| 32 | Remove team members | ✅ MUST |
| 33 | View team member workload | ❌ WON'T |
| 34 | Team member roles/permissions | 🟡 SHOULD |
| 35 | Team member profiles | ✅ MUST |

**Key Decision:** Keep team management flat and simple. Workload views deferred. Roles/permissions should-have for security.

---

### 7. Pre-built AI Agents (MVP Set)

| # | Agent Type | Priority |
|---|------------|----------|
| 36 | Content writing agent | ✅ MUST |
| 37 | Email draft agent | ✅ MUST |
| 38 | Calendar invite/summary agent | ✅ MUST |
| 39 | Research/data gathering agent | ✅ MUST |
| 40 | Image generation agent | ❌ WON'T |
| 41 | Code generation agent | ❌ WON'T |

**Key Decision:** 4 text-focused AI agents for MVP. No image/code generation. Keeps scope manageable and focused on core use cases.

**MVP AI Agent Set:**
1. **Content Writer** - Blog posts, articles, copy
2. **Email Drafter** - Professional email composition
3. **Calendar Agent** - Meeting summaries, invite text
4. **Researcher** - Data gathering, fact-checking

---

### 8. Output & Deliverables

| # | Feature | Priority |
|---|---------|----------|
| 42 | Task outputs stored in system | ✅ MUST |
| 43 | Download task output | ✅ MUST |
| 44 | Generate brief summary document | ✅ MUST |
| 45 | Share brief externally | ❌ WON'T |
| 46 | Export brief to PDF | ✅ MUST |

**Key Decision:** All output management is MUST except external sharing. PDF export critical for professional deliverables.

---

### 9. Authentication & Account

| # | Feature | Priority |
|---|---------|----------|
| 47 | User signup/login (email + password) | ✅ MUST |
| 48 | Social login (Google, Microsoft) | ❌ WON'T |
| 49 | Password reset | ✅ MUST |
| 50 | User profile settings | ✅ MUST |
| 51 | Workspace/organization management | ✅ MUST |
| 52 | Billing/subscription management | ✅ MUST |

**Key Decision:** Billing is MUST - monetization from day one. Social login deferred for simplicity. Multi-tenant workspace model required.

---

### 10. Projects & Organization

| # | Feature | Priority |
|---|---------|----------|
| 53 | Create projects | ✅ MUST |
| 54 | Move briefs between projects | 💡 COULD |
| 55 | Project-level permissions | 🟡 SHOULD |
| 56 | Project templates | ❌ WON'T |
| 57 | Tags/labels for briefs | ✅ MUST |

**Key Decision:** Projects are containers for briefs (MUST). Tagging critical for organization. Templates deferred.

---

## Summary Statistics

### Feature Count by Priority

- ✅ **MUST Have:** 35 features (61%)
- 🟡 **SHOULD Have:** 5 features (9%)
- 💡 **COULD Have:** 4 features (7%)
- ❌ **WON'T Have:** 13 features (23%)

**Total Features Analyzed:** 57

---

## MVP Feature List (MUST Haves Only)

### Core Flows (35 Features)

**Brief Management (3)**
1. Create text-based brief
2. Edit/update brief
3. Delete brief

**AI Task Breakdown (4)**
4. AI auto-generates micro-tasks
5. Manually add tasks
6. Edit AI-generated tasks
7. Delete tasks

**Task Assignment (4)**
8. Assign to AI agent
9. Assign to human
10. Re-assign tasks
11. Multiple assignees per task

**Notifications (1)**
12. Notify humans when assigned

**Manager Review Loop (4)**
13. View task output
14. Accept task
15. Reject + provide feedback
16. Re-run task

**Progress & Visibility (7)**
17. Brief-level progress indicator
18. Project-level dashboard
19. Task status labels
20. Filter briefs by status
21. Search briefs
22. Real-time updates
23. Tags/labels for briefs

**Team Management (3)**
24. Add team members
25. Remove team members
26. Team member profiles

**AI Agents (4)**
27. Content writing agent
28. Email draft agent
29. Calendar agent
30. Research agent

**Outputs (4)**
31. Store task outputs
32. Download outputs
33. Generate brief summary doc
34. Export to PDF

**Auth & Account (5)**
35. Email/password login
36. Password reset
37. User profile settings
38. Workspace management
39. Billing/subscription

**Projects (1)**
40. Create projects

---

## Feature Themes & Patterns

### Theme 1: Confidence Through Visibility
Features 17-23 all serve the primary goal of giving managers confidence through real-time visibility into progress.

### Theme 2: Manager Control
Features 5-9 and 13-16 give managers full control over the AI's output - critical for trust.

### Theme 3: Text-First AI
Features 27-30 focus on text/content AI agents - avoiding complexity of multimedia generation.

### Theme 4: Monetization Ready
Features 38-39 show intent to charge from day one - not a freemium model.

### Theme 5: Collaboration Native
Features 11, 24-26 indicate this is multi-user by design, not single-user with sharing bolted on.

---

## Deferred Features (WON'T Have - V2+)

Features explicitly excluded from MVP:
1. Archive completed briefs
2. AI time/effort estimates
3. AI auto-execution (no manual trigger)
4. Comment threads on tasks
5. Team member workload view
6. Image generation agent
7. Code generation agent
8. Share brief externally
9. Social login
10. Project templates

**Strategic Reason for Deferrals:** Focus MVP on core confidence loop. Add sophistication in v2 based on user feedback.

---

## Next Steps

Move to Technique 3: **Resource Constraints Challenge** to validate feasibility with 4-week timeline + Supabase backend.

---

*Next: Force ruthless prioritization through realistic constraints*
