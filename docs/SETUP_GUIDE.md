# SingleBrief Development Environment Setup Guide

**Last Updated:** 2025-10-05
**Target:** MVP Implementation (5-week timeline)

---

## Overview

This guide will help you set up the complete development environment for SingleBrief following the no-code architecture defined in the PRD.

**Architecture Stack:**
- **Frontend:** React + TypeScript + Vite + shadcn/ui (AI-generated)
- **Backend:** n8n workflows (no-code)
- **Database:** Supabase (PostgreSQL + Auth + Storage)
- **Hosting:** Vercel (frontend) + Railway/VPS (n8n)

---

## Prerequisites

- Node.js 18+ installed
- npm or yarn package manager
- Git installed
- Supabase CLI (`npm install -g supabase`)
- Modern browser (Chrome/Firefox/Edge)

---

## Step 1: Supabase Setup ✅ (Partially Complete)

### 1.1 Current Status

**Already Configured:**
- ✅ Supabase project created (`nnushzrquttpnshtfmlo`)
- ✅ Environment variables set in `.env`
- ✅ Basic schema created (profiles, projects, team_members, briefs, tasks)
- ✅ RLS policies enabled

**Needs Setup:**
1. Complete database schema (add missing tables and fields per PRD)
2. Authentication configuration
3. Storage buckets for file uploads
4. Database indexes for performance

### 1.2 Complete Database Schema Migration

**Action Required:** Run the new migration to add PRD-compliant schema.

```bash
# Navigate to project root
cd /Users/aarora/singlebriefos/singlebrief-os

# Create new migration for complete schema
supabase migration new complete_singlebrief_schema

# The migration file will be created in supabase/migrations/
# Copy the schema from PRD Section 5.2
```

**Migration Contents** (see `supabase/migrations/[timestamp]_complete_singlebrief_schema.sql`):
- Add missing fields to `briefs` table (title, description, why_matters, etc.)
- Add missing fields to `tasks` table (priority, due_date, output_url, etc.)
- Create `user_settings` table
- Create `task_history` table
- Create `task_output_versions` table
- Create `task_comments` table
- Create `notifications` table
- Create `task_presence` table
- Create `user_brief_mutes` table
- Add full-text search indexes
- Update RLS policies

### 1.3 Enable Email Authentication

**Supabase Dashboard Steps:**

1. Go to https://supabase.com/dashboard/project/nnushzrquttpnshtfmlo
2. Navigate to **Authentication** → **Providers**
3. Enable **Email** provider (should already be enabled)
4. Enable **Magic Link** (passwordless) option
5. Configure **Email Templates**:
   - Confirm signup
   - Magic link
   - Reset password
6. Navigate to **Authentication** → **URL Configuration**
   - Site URL: `http://localhost:8080` (dev) / `https://your-domain.com` (prod)
   - Redirect URLs: Add `http://localhost:8080/**` for dev

### 1.4 Create Storage Buckets

**Supabase Dashboard Steps:**

1. Navigate to **Storage**
2. Create bucket: `task-outputs`
   - Public: No (private uploads)
   - File size limit: 10 MB
   - Allowed MIME types: `image/*, application/pdf, text/*, application/vnd.openxmlformats-officedocument.*`
3. Create RLS policies for `task-outputs`:
   - Upload: `auth.uid() IS NOT NULL` (authenticated users only)
   - Select: `auth.uid() IN (SELECT assigned_to FROM tasks WHERE task_id = storage.foldername(name))`

### 1.5 Database Indexes (Performance)

Add these indexes via Supabase SQL Editor:

```sql
-- Search indexes
CREATE INDEX IF NOT EXISTS idx_briefs_search ON briefs USING gin(search_vector);
CREATE INDEX IF NOT EXISTS idx_tasks_search ON tasks USING gin(to_tsvector('english', title || ' ' || COALESCE(description, '')));

-- Query optimization indexes
CREATE INDEX IF NOT EXISTS idx_tasks_brief_id ON tasks(brief_id);
CREATE INDEX IF NOT EXISTS idx_tasks_assigned_to ON tasks(assigned_to);
CREATE INDEX IF NOT EXISTS idx_tasks_status ON tasks(status);
CREATE INDEX IF NOT EXISTS idx_task_comments_task_id ON task_comments(task_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_is_read ON notifications(is_read);
```

---

## Step 2: n8n Backend Setup 🔧 (TODO)

### 2.1 Installation Options

**Option A: Railway (Recommended for MVP)**
- Cost: $5/month
- One-click deploy
- Auto-scaling
- Built-in SSL

**Option B: Self-Hosted VPS (DigitalOcean/Linode)**
- Cost: $5-10/month
- More control
- Requires setup

**Option C: Local Development**
- Cost: Free
- For testing only (not production)

### 2.2 Quick Start with Railway

1. Go to https://railway.app
2. Sign in with GitHub
3. Click **New Project** → **Deploy n8n**
4. Set environment variables:
   - `N8N_BASIC_AUTH_ACTIVE=true`
   - `N8N_BASIC_AUTH_USER=admin`
   - `N8N_BASIC_AUTH_PASSWORD=[your-secure-password]`
   - `WEBHOOK_URL=https://[your-n8n-url].up.railway.app`
5. Deploy and wait for build
6. Access n8n at: `https://[your-n8n-url].up.railway.app`

### 2.3 Local n8n Setup (Development)

```bash
# Install n8n globally
npm install -g n8n

# Start n8n
n8n start

# Access at http://localhost:5678
```

### 2.4 Configure n8n Credentials

**In n8n Dashboard:**

1. **Credentials** → **Add Credential**
2. Add **Supabase** credential:
   - Host: `https://nnushzrquttpnshtfmlo.supabase.co`
   - Service Role Key: (get from Supabase dashboard → Settings → API → service_role key)
3. Add **OpenRouter** credential:
   - API Key: (get from https://openrouter.ai/keys)
   - Base URL: `https://openrouter.ai/api/v1`

### 2.5 Create Core Workflows

Create these 6 workflows in n8n (from PRD Section 5.3):

1. **Brief Task Breakdown**
   - Webhook trigger: `POST /webhook/generate-tasks`
   - Calls OpenRouter API (GPT-4o-mini)
   - Inserts tasks into Supabase

2. **"Why This Matters" Generation**
   - Webhook trigger: `POST /webhook/generate-why-matters`
   - Generates business value explanation
   - Updates brief record

3. **AI Task Execution**
   - Webhook trigger: `POST /webhook/execute-ai-task`
   - Executes individual AI task
   - Updates task with output

4. **AI Batch Queue Processor**
   - Cron trigger: Every 5 minutes
   - Processes queued AI tasks
   - Sends completion email

5. **Email Notifications**
   - Webhook trigger: `POST /webhook/send-notification`
   - Checks user preferences and DND hours
   - Sends emails via Supabase SMTP

6. **Task Due Reminders**
   - Cron trigger: Daily at 9am
   - Queries tasks due in 24 hours
   - Sends reminder emails

**Workflow Templates:** See `/docs/n8n-workflows/` folder (to be created)

---

## Step 3: Frontend Vercel Setup ✅ (Partially Complete)

### 3.1 Current Status

**Already Configured:**
- ✅ React + Vite project structure
- ✅ shadcn/ui components installed
- ✅ Tailwind CSS configured
- ✅ Supabase client integration
- ✅ Environment variables in `.env`

**Needs Setup:**
1. Connect GitHub repository
2. Deploy to Vercel
3. Configure production environment variables

### 3.2 Deploy to Vercel

**Option A: Vercel CLI**

```bash
# Install Vercel CLI
npm install -g vercel

# Login to Vercel
vercel login

# Deploy from project root
vercel

# Follow prompts:
# - Set up and deploy? Yes
# - Which scope? [your-account]
# - Link to existing project? No
# - Project name: singlebrief-os
# - Directory: ./
# - Override settings? No

# For production deployment
vercel --prod
```

**Option B: Vercel Dashboard**

1. Go to https://vercel.com/new
2. Import Git Repository
3. Select `singlebriefos/singlebrief-os`
4. Configure:
   - Framework Preset: Vite
   - Build Command: `npm run build`
   - Output Directory: `dist`
   - Install Command: `npm install`
5. Add Environment Variables:
   - `VITE_SUPABASE_URL`: `https://nnushzrquttpnshtfmlo.supabase.co`
   - `VITE_SUPABASE_PUBLISHABLE_KEY`: [your-anon-key]
   - `VITE_SUPABASE_PROJECT_ID`: `nnushzrquttpnshtfmlo`
   - `VITE_N8N_WEBHOOK_URL`: `https://[your-n8n-url]/webhook` (add after n8n setup)
6. Click **Deploy**

### 3.3 Configure Custom Domain (Optional)

1. Vercel Dashboard → Project Settings → Domains
2. Add domain: `yourdomain.com`
3. Configure DNS records as instructed
4. Update Supabase redirect URLs to match production domain

---

## Step 4: Environment Configuration 🔧

### 4.1 Update `.env` File

Add n8n webhook URL after n8n setup:

```env
# Existing Supabase config
VITE_SUPABASE_PROJECT_ID="nnushzrquttpnshtfmlo"
VITE_SUPABASE_PUBLISHABLE_KEY="eyJhbG..."
VITE_SUPABASE_URL="https://nnushzrquttpnshtfmlo.supabase.co"

# n8n Webhooks (add after n8n setup)
VITE_N8N_WEBHOOK_GENERATE_TASKS="https://[your-n8n-url]/webhook/generate-tasks"
VITE_N8N_WEBHOOK_GENERATE_WHY_MATTERS="https://[your-n8n-url]/webhook/generate-why-matters"
VITE_N8N_WEBHOOK_EXECUTE_AI_TASK="https://[your-n8n-url]/webhook/execute-ai-task"
VITE_N8N_WEBHOOK_SEND_NOTIFICATION="https://[your-n8n-url]/webhook/send-notification"

# OpenRouter (for cost estimation in UI)
VITE_OPENROUTER_API_KEY="[get-from-openrouter]"
```

### 4.2 Create `.env.production` (Vercel)

Same structure as `.env` but with production URLs:

```env
VITE_SUPABASE_PROJECT_ID="nnushzrquttpnshtfmlo"
VITE_SUPABASE_PUBLISHABLE_KEY="eyJhbG..."
VITE_SUPABASE_URL="https://nnushzrquttpnshtfmlo.supabase.co"

VITE_N8N_WEBHOOK_GENERATE_TASKS="https://[production-n8n].up.railway.app/webhook/generate-tasks"
# ... (all production webhook URLs)
```

---

## Step 5: Testing & Validation ✅

### 5.1 Database Connection Test

```bash
# Test Supabase connection
npx supabase db diff

# Should show no errors and display current schema
```

### 5.2 Frontend Local Test

```bash
# Install dependencies (if not already done)
npm install

# Run dev server
npm run dev

# Open http://localhost:8080
# Verify:
# - [ ] Page loads without errors
# - [ ] Can sign up with email
# - [ ] Supabase Auth works
```

### 5.3 n8n Workflow Test

1. Open n8n dashboard
2. Create simple test workflow:
   - Webhook node (POST /webhook/test)
   - Supabase node (SELECT * FROM profiles LIMIT 1)
   - HTTP Response node
3. Execute workflow
4. Check for errors

### 5.4 End-to-End Integration Test

Once all services are running:

1. **Test Brief Creation**:
   - Create account on frontend
   - Create new brief
   - Verify brief appears in Supabase dashboard

2. **Test AI Task Generation** (requires n8n workflow):
   - Click "Generate Tasks" on brief
   - Verify n8n webhook is called
   - Check tasks are inserted in database

3. **Test Notifications**:
   - Assign task to user
   - Verify email notification sent

---

## Step 6: Monitoring & Debugging 🔍

### 6.1 Logging Setup

**Supabase Logs:**
- Dashboard → Logs → Database/Auth/Storage
- Real-time query monitoring

**n8n Logs:**
- Workflow executions dashboard
- View execution history and errors

**Vercel Logs:**
- Dashboard → Deployments → View Logs
- Real-time function logs

### 6.2 Error Tracking (Optional for MVP)

**Sentry Setup:**

```bash
# Install Sentry
npm install @sentry/react

# Add to src/main.tsx
import * as Sentry from "@sentry/react";

Sentry.init({
  dsn: "your-sentry-dsn",
  environment: import.meta.env.MODE,
  integrations: [new Sentry.BrowserTracing()],
  tracesSampleRate: 1.0,
});
```

---

## Cost Summary

### MVP Phase (0-100 users)

| Service | Tier | Cost |
|---------|------|------|
| Vercel | Hobby (Free) | $0 |
| Supabase | Free | $0 |
| n8n (Railway) | Starter | $5/month |
| OpenRouter | Pay-as-you-go | $5-10/month |
| **Total** | | **$10-15/month** |

### Scale Phase (500-1K users)

| Service | Tier | Cost |
|---------|------|------|
| Vercel | Pro | $20/month |
| Supabase | Pro | $25/month |
| n8n (Railway) | Pro | $20/month |
| OpenRouter | Pay-as-you-go | $50-100/month |
| Sentry | Team | $26/month |
| Resend (Email) | Pro | $20/month |
| **Total** | | **$161-211/month** |

---

## Next Steps

**Immediate Actions (in order):**

1. ✅ Review this setup guide
2. 🔧 Run complete database migration
3. 🔧 Set up n8n instance (Railway recommended)
4. 🔧 Create 6 core n8n workflows
5. 🔧 Test webhook connections
6. ✅ Deploy to Vercel
7. ✅ Test end-to-end flow
8. 📝 Begin Epic 1 implementation

**Ready to Proceed?**

Choose your next action:
- **A**: Run database migration now
- **B**: Set up n8n workflows first
- **C**: Deploy to Vercel first
- **D**: Follow this guide step-by-step

---

**Status Checklist:**

- [x] Supabase project created
- [ ] Complete database schema migrated
- [ ] Email auth configured
- [ ] Storage buckets created
- [ ] n8n instance running
- [ ] Core workflows created
- [ ] Vercel deployment live
- [ ] Environment variables set
- [ ] End-to-end test passed
- [ ] Ready for Epic 1

---

**Last Updated:** 2025-10-05
**Document Owner:** Development Team
