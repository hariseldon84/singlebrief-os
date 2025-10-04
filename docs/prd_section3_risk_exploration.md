# PRD Section 3 - Risk Exploration (UI/UX Risks)

**Date:** 2025-10-04
**Elicitation Method:** Risk Exploration
**Purpose:** Identify potential UI/UX risks, failure modes, and mitigation strategies

---

## Risk Category 1: User Adoption Risks

### Risk 1.1: "Why This Matters" Feature Ignored

**Risk Description:**
Despite being a key differentiator, managers ignore the "Why This Matters" feature, treating it as bloatware rather than value-add.

**Likelihood:** Medium (40%)
**Impact:** High (Success metric is 80% adoption)

**Indicators:**

- Collapsed section never expanded (tracked via analytics)
- "Regenerate" button never clicked
- Managers skip directly to task assignment

**Root Causes:**

- Generic AI-generated content (buzzword soup)
- Doesn't address manager's actual motivation gaps
- Feature feels like "extra work" rather than helpful
- Managers already know why project matters (don't need AI to tell them)

**Mitigation Strategies:**

**Pre-Launch:**

- A/B test prompt engineering to reduce generic content
- Show preview during user onboarding (highlight value)
- Seed beta users with high-quality examples

**Post-Launch:**

- Track expansion rate analytics (trigger if <50% after week 1)
- User interviews: "Did you find 'Why This Matters' helpful?"
- Iterate prompt based on feedback (FR8: MVP accepts buzzword soup, improve post-launch)

**Fallback Plan:**

- If adoption <40% after 4 weeks, consider removing feature or making it opt-out instead of opt-in
- Alternative: Convert to "Project Summary" instead of motivation framing

---

### Risk 1.2: Team Members Don't Update Progress %

**Risk Description:**
Team members assigned tasks never update progress percentage (0% until submission), defeating real-time visibility value proposition.

**Likelihood:** High (60%)
**Impact:** Medium (Managers lose confidence in progress tracking)

**Indicators:**

- 80%+ of tasks remain at 0% progress until status changes to "Done"
- Managers complain "I don't know if Alex is actually working on this"
- Progress slider rarely interacted with (analytics)

**Root Causes:**

- Updating progress feels like busywork (extra step)
- No immediate benefit to team member (only helps manager)
- Unclear what "50% complete" means for creative tasks
- Competing priorities (team members focus on actual work, not status updates)

**Mitigation Strategies:**

**Design Changes:**

- Auto-suggest progress milestones (e.g., "Research: 25%, Drafting: 50%, Review: 75%")
- Quick-update buttons (25% / 50% / 75%) instead of slider only
- Tie progress updates to output comments (when adding comment, prompt for progress update)

**Behavioral Nudges:**

- Gentle reminder notification: "Haven't updated progress in 2 days. Quick update?"
- Gamification (optional): Progress streak badges
- Manager setting: "Require progress updates every X days"

**Fallback Plan:**

- If usage <30%, remove progress slider from MVP
- Keep simpler status-based tracking only (To-Do → In-Progress → Done)

---

### Risk 1.3: Managers Overwhelmed by Confirmation Screen

**Risk Description:**
Post-generation confirmation screen (FR69) with 20 AI-generated tasks paralyzes managers instead of helping them.

**Likelihood:** Medium (35%)
**Impact:** High (Blocks brief creation, defeats "confidence to act" value)

**Indicators:**

- Users abandon confirmation screen without accepting tasks
- High "Regenerate" requests with vague feedback ("make it simpler")
- Users accept all tasks without reviewing (defeating purpose of confirmation)

**Root Causes:**

- Too many tasks to review at once (cognitive overload)
- Unclear editing workflow (how do I change task 7?)
- Fear of missing something important
- Analysis paralysis (is this the "right" breakdown?)

**Mitigation Strategies:**

**Design Changes:**

- Collapsible task groups by priority (show High priority first, expand Medium/Low)
- Progressive disclosure: Show 5 tasks at a time with "Show More" button
- Visual hierarchy: Larger cards for High priority, smaller for Low

**Workflow Simplification:**

- "Quick Accept" option: "These look good, proceed to brief"
- Defer editing to Brief Detail view (accept all → edit later)
- AI confidence score per task ("80% confident this is needed")

**Validation:**

- User testing with 20-task scenario before launch
- If >50% of users take >2 minutes on confirmation screen, redesign

---

## Risk Category 2: Technical Performance Risks

### Risk 2.1: AI Generation Timeouts Frustrate Users

**Risk Description:**
AI task breakdown takes 60+ seconds for complex briefs, causing users to abandon or assume system is broken.

**Likelihood:** Medium (40%)
**Impact:** High (First impression failure, users lose trust)

**Indicators:**

- >20% of AI generations exceed 60 seconds
- Users refresh page mid-generation (lost context)
- Support tickets: "System stuck on 'Generating tasks...'"

**Root Causes:**

- Complex briefs with multiple domains (LLM takes longer to process)
- API rate limiting slows response
- No user expectation setting (unclear how long it should take)

**Mitigation Strategies:**

**User Experience:**

- Dynamic time estimates: "Generating tasks... (typically 30-45 seconds for briefs like this)"
- Progress indicators: "Analyzing brief... Breaking down tasks... Assigning priorities..."
- "Taking longer than usual?" message after 45 seconds with option to cancel

**Technical:**

- Set hard timeout at 90 seconds (fail with retry option)
- Background processing: Generate tasks async, notify when done
- Streaming responses: Show tasks as they're generated (progressive enhancement)

**Fallback Plan:**

- If timeout rate >15%, switch to background generation model
- Alternative: Generate 5 tasks quickly, offer "Generate More Tasks" button

---

### Risk 2.2: Polling Every 30 Seconds Causes Performance Issues

**Risk Description:**
NFR29 (30-second polling) creates excessive server load, slow dashboard rendering, or battery drain on mobile.

**Likelihood:** Medium (35%)
**Impact:** Medium (Poor UX, infrastructure costs)

**Indicators:**

- Dashboard load time >3 seconds
- API rate limit errors during peak usage
- Mobile users report battery drain
- Server costs spike unexpectedly

**Root Causes:**

- Too many concurrent poll requests (100 users = 100 requests/30s)
- Inefficient database queries (full table scans on each poll)
- No cache layer (every poll hits database)
- Polling continues even when user inactive (tab backgrounded)

**Mitigation Strategies:**

**Technical Optimization:**

- Implement Redis cache for frequently accessed data (brief status, task counts)
- Use database indexes on status, updated_at columns
- Batch poll requests (aggregate updates for multiple briefs in one query)
- Pause polling when tab inactive (Page Visibility API)

**Adaptive Polling:**

- Slow down to 60 seconds if no activity detected in last 5 minutes
- Stop polling after 30 minutes of inactivity
- Speed up to 10 seconds during active task execution

**Monitoring:**

- Alert if average poll response time >500ms
- Track polling-to-actual-update ratio (if <5% updates have changes, reduce frequency)

**Fallback Plan:**

- If performance degrades, increase poll interval to 60 seconds
- Post-MVP: Migrate to WebSockets for real-time updates

---

### Risk 2.3: File Upload Failures Block Task Submission

**Risk Description:**
FR73 file upload (10MB limit, Supabase Storage) fails silently or blocks task submission, frustrating team members.

**Likelihood:** Medium (30%)
**Impact:** Medium (Task completion blocked, data loss)

**Indicators:**

- Upload progress bar stuck at 90%
- "Submit Output" button remains disabled
- Support tickets: "Can't upload my file"
- Network errors in browser console

**Root Causes:**

- Slow network connections (mobile, remote workers)
- File type validation errors (user uploads .psd instead of .pdf)
- Supabase Storage rate limits
- No retry mechanism on transient failures

**Mitigation Strategies:**

**User Experience:**

- Clear error messages: "File too large (12MB). Maximum size is 10MB. Compress or split file."
- Upload progress indicator with time estimate
- Retry button on failure (don't force full re-upload)
- Allow task submission without file (make file upload optional)

**Technical:**

- Client-side validation before upload (size, type, count)
- Chunked upload for files >5MB (resume on failure)
- Compression suggestion for images (auto-compress PNGs)
- Queue failed uploads for background retry

**Fallback Plan:**

- If upload failure rate >10%, make file upload fully optional
- Encourage URL linking instead (Figma, Google Drive, etc.)

---

## Risk Category 3: Usability Risks

### Risk 3.1: Team Members Can't Find Their Tasks

**Risk Description:**
Team member inbox (FR54) is poorly organized, causing tasks to be overlooked or forgotten.

**Likelihood:** Medium (40%)
**Impact:** High (Missed deadlines, manager frustration)

**Indicators:**

- Tasks marked overdue without team member logging in
- Email notifications ignored (users rely on dashboard)
- Support tickets: "Where is my task?"
- Low task completion rate

**Root Causes:**

- Too many tasks listed (scrolling fatigue)
- No smart sorting (newest tasks at bottom, missed)
- Lack of visual priority (all tasks look same importance)
- Competing views (dashboard shows briefs AND tasks, cluttered)

**Mitigation Strategies:**

**Smart Defaults:**

- Default sort: Overdue first, then Due Soon, then Priority
- Visual hierarchy: Overdue tasks highlighted in red banner at top
- Auto-collapse completed tasks (show on demand)
- "Needs Attention" section (overdue + rejected + due in 24h)

**Notification Strategy:**

- Email: Task assigned, due in 24h, overdue by 1 day
- In-app badge: Unread task count
- Desktop notification (opt-in): "Task due in 2 hours"

**Validation:**

- User testing: "Find the task due tomorrow" (measure time to complete)
- Track click patterns: Which sort/filter options are used most?

---

### Risk 3.2: Rejection Feedback Loop Demotivates Team Members

**Risk Description:**
FR59 rejection workflow creates negative experience, causing team member disengagement.

**Likelihood:** Medium (35%)
**Impact:** High (Team morale, attrition risk)

**Indicators:**

- High rejection rates (>30% of submissions rejected)
- Team members stop using progress updates after first rejection
- Passive-aggressive output comments ("Fixed per your request")
- Team members leave platform (churn)

**Root Causes:**

- Harsh manager feedback tone (feels like personal criticism)
- No context for rejection (unclear what to fix)
- Repeated rejections (more than 2) feel punitive
- No positive reinforcement (only negative feedback visible)

**Mitigation Strategies:**

**Design Nudges:**

- Feedback templates for managers: "Great start! Here's what to refine..."
- Character count on feedback (encourage specificity)
- Tone checker (flag harsh language like "This is wrong")
- Limit rejections per task (after 3rd rejection, suggest meeting)

**Positive Reinforcement:**

- "Accept" shows celebration animation (confetti, green checkmark)
- Acceptance rate badge on team member profile ("92% first-time acceptance")
- Manager prompted to add positive comment with acceptance

**Communication Features:**

- "Ask Clarifying Question" button on rejected tasks
- Inline comments on specific parts of output (not just general feedback)
- Async chat thread per task (discuss before resubmission)

**Validation:**

- Track rejection-to-churn correlation
- Exit interviews: "Did rejection feedback feel constructive?"

---

### Risk 3.3: Search Returns Too Many Irrelevant Results

**Risk Description:**
FR30 brief search overwhelms users with false positives, making feature unusable.

**Likelihood:** Medium (35%)
**Impact:** Medium (Search abandoned, users scroll dashboard instead)

**Indicators:**

- Search used <10% of sessions (low adoption)
- Users perform multiple searches to find one brief
- Support tickets: "Can't find my brief"
- Search abandonment rate >50%

**Root Causes:**

- Broad keyword matching (searches all text fields)
- No relevance ranking (newest results first, not best match)
- Archived briefs mixed with active (clutter)
- Lack of filters (can't narrow by project, status, date range)

**Mitigation Strategies:**

**Search Improvements:**

- Weighted search: Title matches rank higher than description matches
- Auto-suggest: Show top 3 matches as user types
- Highlight matches: Yellow background on matched keywords
- Fuzzy matching: "markting" finds "marketing"

**Filter Enhancements (FR91):**

- Quick filters: My Briefs | Team Briefs | Active | Completed
- Date range picker: Last 7 days | Last 30 days | All Time
- Project selector: Filter by specific project

**Empty State:**

- "No results for 'blockchain'. Try: Check spelling, Use different keywords, Clear filters"
- Suggest recent briefs if search fails

**Validation:**

- A/B test relevance algorithms (track click-through rate on search results)
- Analytics: Which filters are used most? (Optimize for common patterns)

---

## Risk Category 4: AI-Specific Risks

### Risk 4.1: AI Generates Nonsensical or Offensive Content

**Risk Description:**
AI task breakdown or "Why This Matters" includes hallucinations, biased language, or inappropriate content.

**Likelihood:** Low (15%)
**Impact:** Critical (Legal risk, brand damage, user trust loss)

**Indicators:**

- User reports offensive content
- Hallucinated facts (e.g., "Target 500% ROI" when brief says 50%)
- Biased language (gender, race, political assumptions)
- Gibberish output (token limit exceeded, incomplete generation)

**Root Causes:**

- LLM prompt engineering gaps (insufficient guardrails)
- Context window overflow (brief too long, truncation)
- Model bias (inherent in training data)
- Edge case inputs (special characters, code in brief text)

**Mitigation Strategies:**

**Prevention:**

- System prompts with explicit rules: "Avoid gender assumptions, political views, unverified claims"
- Content moderation API (OpenAI Moderation endpoint) before displaying output
- Sanity checks: Reject outputs with profanity, extreme numbers (>1000% ROI)
- Human-in-the-loop: Manager reviews BEFORE tasks visible to team

**Detection:**

- User reporting: "Flag this content" button on AI outputs
- Automated scanning: Regex patterns for problematic content
- Audit logs: Track all AI generations for review

**Response Plan:**

- Immediate content removal upon flag (pending review)
- Incident report to stakeholders within 24h
- Model fine-tuning based on failure patterns

**Validation:**

- Red team testing: Adversarial inputs to trigger failures
- Beta users trained to report issues (bug bounty)

---

### Risk 4.2: AI Task Queuing Creates Forgotten Backlog

**Risk Description:**
FR75 queuing mechanism causes managers to assign tasks to AI but forget to click "Run AI Tasks", creating stale queue.

**Likelihood:** High (50%)
**Impact:** Medium (Wasted opportunity, perceived AI failure)

**Indicators:**

- 30%+ of queued tasks remain queued >7 days
- Managers manually reassign queued tasks to humans
- Support tickets: "Why didn't AI run my task?"

**Root Causes:**

- "Run AI Tasks" button not prominent enough
- Manager assigns 1 task, forgets to run (expects auto-execution)
- No reminder system (out of sight, out of mind)
- Competing priorities (manager moves to next brief)

**Mitigation Strategies:**

**Proactive Reminders:**

- Email notification: "You have 4 tasks queued for AI. Run them now?"
- In-app banner: "🔔 4 AI tasks waiting. Estimated cost: $0.60 [Run Now]"
- Daily digest: "Your queued tasks summary"

**Design Changes:**

- Floating action button (FAB) when queued tasks exist (always visible)
- Auto-run setting (opt-in): "Automatically run AI tasks after assignment"
- Queue expiration: After 7 days, prompt manager: "Run or reassign?"

**Analytics:**

- Track queue dwell time (median time from queued → run)
- Alert if >20% of queued tasks >3 days old

**Fallback Plan:**

- If median dwell time >48h, consider reverting to auto-execution (revisit FR75 decision)

---

### Risk 4.3: AI Generation Cost Spirals Out of Control

**Risk Description:**
FR77 cost preview is ignored or underestimated, causing unexpected bills for early users.

**Likelihood:** Low (20%)
**Impact:** High (Churn, negative reviews, financial loss)

**Indicators:**

- Users exceed allocated credits by >200%
- Complaints about unexpected charges
- High token usage (>100K tokens/week per user)
- Users spam "Regenerate" button (each click costs money)

**Root Causes:**

- Cost preview dismissed without reading (modal fatigue)
- Users don't understand token pricing ($0.01/1K tokens means what?)
- Regeneration loops (AI rejects → regenerate → reject → regenerate)
- No hard spending limits (runaway usage)

**Mitigation Strategies:**

**Spending Controls:**

- Weekly budget caps (default $10/week, adjustable in settings)
- Alert at 50%, 80%, 100% of budget ("You've used 80% of weekly AI budget")
- Block AI execution at budget limit (upgrade prompt)

**Cost Education:**

- Onboarding tutorial: "Each task generation costs ~$0.10-0.30"
- Real-time cost tracker: "This week: $3.20 of $10.00 budget used"
- Cost history graph (show spending trends)

**Regeneration Limits:**

- FR87: Max 3 regeneration attempts per task (after that, reassign to human)
- Exponential backoff pricing: 1st regen = $0.15, 2nd = $0.25, 3rd = $0.40
- Cooldown period: 5-minute wait between regenerations

**Validation:**

- Beta testing with $5/week budget (observe behavior)
- Track regeneration rate (if >30% of tasks regenerated, investigate prompts)

---

## Risk Category 5: Data Integrity Risks

### Risk 5.1: Concurrent Edits Cause Data Loss

**Risk Description:**
Manager and team member edit same task simultaneously, causing one person's changes to be overwritten.

**Likelihood:** Medium (30%)
**Impact:** Medium (Frustration, lost work)

**Indicators:**

- Support tickets: "My changes disappeared"
- Version history shows conflicting timestamps
- Users report "stale data" (seeing old task status)

**Root Causes:**

- No locking mechanism (last-write-wins)
- 30-second polling delay (user sees stale data, edits based on it)
- No conflict detection (no warning before overwrite)

**Mitigation Strategies:**

**Optimistic Locking:**

- Include `updated_at` timestamp in update requests
- Backend checks: If DB timestamp > request timestamp, reject update
- Show conflict modal: "This task was updated by [User]. Reload or overwrite?"

**UI Indicators:**

- Real-time presence: "Sarah is viewing this task" (like Google Docs)
- Disable editing if another user active on same task
- Auto-save drafts (prevent data loss if overwrite occurs)

**Fallback Plan:**

- If conflict rate >5%, implement full locking (only one user can edit at a time)

---

### Risk 5.2: Deleted Briefs Lose All Task History

**Risk Description:**
Manager deletes brief accidentally, losing all task outputs, history, and team work.

**Likelihood:** Low (15%)
**Impact:** Critical (Permanent data loss, team work wasted)

**Indicators:**

- Support tickets: "I deleted brief by mistake, can you restore?"
- No recovery mechanism (permanent delete)
- Users afraid to delete old briefs (database bloat)

**Mitigation Strategies:**

**Soft Delete:**

- Move deleted briefs to "Archived" status instead of hard delete
- Archived briefs hidden from dashboard but recoverable
- "Restore" option available for 30 days
- Automatic hard delete after 30 days (GDPR compliance)

**Confirmation:**

- Two-step delete: Click "Delete" → Confirmation modal → Type brief title to confirm
- Warning: "This will archive [Brief Title] and all 12 tasks. This can be undone for 30 days."

**Audit Trail:**

- Log all deletions with user, timestamp, brief ID
- Admin dashboard shows deleted briefs (for support recovery)

**Validation:**

- Track accidental deletion rate (if >2% of deletes are restored, improve UX)

---

## Risk Summary Matrix

| Risk ID | Risk Description | Likelihood | Impact | Priority | Mitigation Status |
|---------|------------------|------------|--------|----------|-------------------|
| 1.1 | "Why This Matters" ignored | Medium | High | **HIGH** | Track analytics, iterate prompts |
| 1.2 | Progress % not updated | High | Medium | **HIGH** | Quick-update buttons, nudges |
| 1.3 | Confirmation screen overwhelms | Medium | High | **HIGH** | Progressive disclosure, user testing |
| 2.1 | AI timeout frustrations | Medium | High | **HIGH** | Dynamic estimates, 90s timeout |
| 2.2 | Polling performance issues | Medium | Medium | **MEDIUM** | Redis cache, adaptive polling |
| 2.3 | File upload failures | Medium | Medium | **MEDIUM** | Retry logic, optional uploads |
| 3.1 | Tasks not found by team members | Medium | High | **HIGH** | Smart sorting, visual hierarchy |
| 3.2 | Rejection demotivates | Medium | High | **HIGH** | Tone checker, positive reinforcement |
| 3.3 | Search returns junk | Medium | Medium | **MEDIUM** | Weighted search, filters |
| 4.1 | Offensive AI content | Low | Critical | **HIGH** | Moderation API, reporting |
| 4.2 | Queued tasks forgotten | High | Medium | **HIGH** | Proactive reminders, FAB |
| 4.3 | Cost spirals | Low | High | **MEDIUM** | Budget caps, regeneration limits |
| 5.1 | Concurrent edit conflicts | Medium | Medium | **MEDIUM** | Optimistic locking |
| 5.2 | Accidental deletions | Low | Critical | **HIGH** | Soft delete, 30-day recovery |

---

**Total Risks Identified:** 14
**High Priority:** 9
**Medium Priority:** 5

---

## Critical Questions for User Review

### Question 1: Progress Tracking Philosophy

**Context:** Risk 1.2 identifies high likelihood (60%) that team members won't update progress %.

**Question:** Should we keep the progress % slider in MVP, or simplify to status-only tracking (To-Do → In-Progress → Done)?

**Options:**

- **A) Keep progress slider** - Implement quick-update buttons (25%/50%/75%) and gentle nudges
- **B) Remove progress slider for MVP** - Focus on status-only, add progress % post-MVP based on demand
- **C) Make it optional** - Team members can choose to enable progress tracking per brief

---

### Question 2: AI Task Queue Reminder Strategy

**Context:** Risk 4.2 identifies high likelihood (50%) that queued AI tasks will be forgotten.

**Question:** How aggressive should reminder notifications be for queued AI tasks?

**Options:**

- **A) Passive (Low Frequency)** - Email daily digest only, no in-app banners
- **B) Balanced (Medium Frequency)** - In-app banner + email if queue >3 days old
- **C) Aggressive (High Frequency)** - Floating action button (always visible) + email after 24h + daily digest

---

### Question 3: Confirmation Screen Complexity

**Context:** Risk 1.3 identifies managers may be overwhelmed by reviewing 20 AI-generated tasks.

**Question:** Should the confirmation screen support progressive disclosure or show all tasks at once?

**Options:**

- **A) Show all tasks** - Single scrollable view with collapsible priority groups
- **B) Progressive disclosure** - Show 5 tasks at a time with "Show More" button
- **C) Quick accept flow** - Show summary only ("8 tasks generated"), defer editing to Brief Detail view

---

### Question 4: File Upload Requirement

**Context:** Risk 2.3 identifies file upload failures may block task submission.

**Question:** Should file upload be required, optional, or deferred to post-MVP?

**Options:**

- **A) Required for certain task types** - Force upload for deliverable tasks (wireframes, documents)
- **B) Always optional** - Team members can submit with URL only, file upload is bonus
- **C) Defer to post-MVP** - Start with URL-only, add file upload after validating demand

---

*Risk Exploration elicitation complete - 4 critical questions identified for user decision*
 ---
  Decision Documentation

  Question 1: Progress Tracking → C) Optional per brief
  - Team members can enable/disable progress tracking
  - Reduces friction for those who find it burdensome
  - Allows motivated teams to use granular tracking

  Question 2: AI Queue Reminders → C) Aggressive notifications
  - Floating action button when queued tasks exist
  - Email after 24h + daily digest
  - Maximizes AI task execution rate

  Question 3: Confirmation Screen → B) Progressive disclosure
  - Show 5 tasks at a time with "Show More" button
  - Reduces cognitive overload
  - Maintains review quality

  Question 4: File Upload → B) Always optional
  - URL linking preferred, file upload is bonus
  - Reduces submission friction
  - Prevents upload failures from blocking work