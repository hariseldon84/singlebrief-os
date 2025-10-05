-- ============================================================================
-- SingleBrief Complete Schema Migration
-- PRD Version: 1.0 (Section 5.2)
-- Date: 2025-10-05
-- ============================================================================
-- This migration upgrades the basic schema to the complete PRD-specified schema
-- Adds missing tables, fields, indexes, and RLS policies
-- ============================================================================

-- ============================================================================
-- PART 1: Extend Existing Tables
-- ============================================================================

-- Extend briefs table with PRD fields
ALTER TABLE public.briefs
  ADD COLUMN IF NOT EXISTS title TEXT CHECK (length(title) <= 200),
  ADD COLUMN IF NOT EXISTS description TEXT CHECK (length(description) <= 5000),
  ADD COLUMN IF NOT EXISTS why_matters TEXT,
  ADD COLUMN IF NOT EXISTS why_matters_regen_count INT DEFAULT 0,
  ADD COLUMN IF NOT EXISTS task_count INT DEFAULT 0,
  ADD COLUMN IF NOT EXISTS progress_tracking_enabled BOOLEAN DEFAULT false,
  ADD COLUMN IF NOT EXISTS regeneration_count INT DEFAULT 0,
  ADD COLUMN IF NOT EXISTS search_vector tsvector;

-- Migrate existing 'content' to 'description' if needed
UPDATE public.briefs SET description = content WHERE description IS NULL AND content IS NOT NULL;

-- Extend tasks table with PRD fields
ALTER TABLE public.tasks
  ADD COLUMN IF NOT EXISTS priority TEXT DEFAULT 'Medium' CHECK (priority IN ('High', 'Medium', 'Low')),
  ADD COLUMN IF NOT EXISTS due_date TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS progress_percent INT DEFAULT 0 CHECK (progress_percent BETWEEN 0 AND 100),
  ADD COLUMN IF NOT EXISTS output_url TEXT,
  ADD COLUMN IF NOT EXISTS rejection_feedback TEXT,
  ADD COLUMN IF NOT EXISTS rework_cycle INT DEFAULT 0;

-- ============================================================================
-- PART 2: Create New Tables
-- ============================================================================

-- User Settings table
CREATE TABLE IF NOT EXISTS public.user_settings (
  user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  default_task_limit INT DEFAULT 20 CHECK (default_task_limit BETWEEN 5 AND 50),
  email_notifications_enabled BOOLEAN DEFAULT true,
  dnd_start_hour INT DEFAULT 21,
  dnd_end_hour INT DEFAULT 9,
  onboarding_completed BOOLEAN DEFAULT false,
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Task History table
CREATE TABLE IF NOT EXISTS public.task_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  task_id UUID REFERENCES public.tasks(id) ON DELETE CASCADE,
  user_id UUID REFERENCES auth.users(id),
  action TEXT NOT NULL,
  old_value TEXT,
  new_value TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Task Output Versions table
CREATE TABLE IF NOT EXISTS public.task_output_versions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  task_id UUID REFERENCES public.tasks(id) ON DELETE CASCADE,
  version_number INT NOT NULL,
  output_url TEXT NOT NULL,
  submitted_by UUID REFERENCES auth.users(id),
  status TEXT CHECK (status IN ('Accepted', 'Rejected', 'Pending')),
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Task Comments table
CREATE TABLE IF NOT EXISTS public.task_comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  task_id UUID REFERENCES public.tasks(id) ON DELETE CASCADE,
  user_id UUID REFERENCES auth.users(id),
  comment TEXT NOT NULL,
  mentioned_users UUID[],
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Notifications table
CREATE TABLE IF NOT EXISTS public.notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  type TEXT NOT NULL,
  title TEXT NOT NULL,
  message TEXT,
  link_url TEXT,
  is_read BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Task Presence table (for real-time user presence)
CREATE TABLE IF NOT EXISTS public.task_presence (
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  task_id UUID REFERENCES public.tasks(id) ON DELETE CASCADE,
  last_seen TIMESTAMPTZ DEFAULT now(),
  PRIMARY KEY (user_id, task_id)
);

-- User Brief Mutes table (notification preferences)
CREATE TABLE IF NOT EXISTS public.user_brief_mutes (
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  brief_id UUID REFERENCES public.briefs(id) ON DELETE CASCADE,
  PRIMARY KEY (user_id, brief_id)
);

-- ============================================================================
-- PART 3: Create Indexes for Performance
-- ============================================================================

-- Search indexes
CREATE INDEX IF NOT EXISTS idx_briefs_search ON public.briefs USING gin(search_vector);
CREATE INDEX IF NOT EXISTS idx_tasks_search ON public.tasks USING gin(to_tsvector('english', title || ' ' || COALESCE(description, '')));

-- Query optimization indexes
CREATE INDEX IF NOT EXISTS idx_tasks_brief_id ON public.tasks(brief_id);
CREATE INDEX IF NOT EXISTS idx_tasks_assigned_to ON public.tasks(assigned_to);
CREATE INDEX IF NOT EXISTS idx_tasks_status ON public.tasks(status);
CREATE INDEX IF NOT EXISTS idx_tasks_priority ON public.tasks(priority);
CREATE INDEX IF NOT EXISTS idx_task_comments_task_id ON public.task_comments(task_id);
CREATE INDEX IF NOT EXISTS idx_task_history_task_id ON public.task_history(task_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON public.notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_is_read ON public.notifications(is_read);
CREATE INDEX IF NOT EXISTS idx_task_output_versions_task_id ON public.task_output_versions(task_id);
CREATE INDEX IF NOT EXISTS idx_briefs_status ON public.briefs(status);
CREATE INDEX IF NOT EXISTS idx_briefs_created_by ON public.briefs(created_by);

-- ============================================================================
-- PART 4: Enable RLS on New Tables
-- ============================================================================

ALTER TABLE public.user_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.task_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.task_output_versions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.task_comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.task_presence ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_brief_mutes ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- PART 5: Create RLS Policies (PRD Section 5.4)
-- ============================================================================

-- User Settings Policies
CREATE POLICY "Users can view own settings"
  ON public.user_settings FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can update own settings"
  ON public.user_settings FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own settings"
  ON public.user_settings FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Briefs Policies (Updated per PRD)
DROP POLICY IF EXISTS "Users can view accessible briefs" ON public.briefs;
CREATE POLICY "Users can view accessible briefs"
  ON public.briefs FOR SELECT
  TO authenticated
  USING (
    auth.uid() = created_by OR
    id IN (SELECT brief_id FROM public.tasks WHERE assigned_to = auth.uid())
  );

CREATE POLICY "Users can create own briefs"
  ON public.briefs FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = created_by);

CREATE POLICY "Users can update own briefs"
  ON public.briefs FOR UPDATE
  TO authenticated
  USING (auth.uid() = created_by);

-- Tasks Policies (Updated per PRD)
DROP POLICY IF EXISTS "Users can view accessible tasks" ON public.tasks;
CREATE POLICY "Users can view accessible tasks"
  ON public.tasks FOR SELECT
  TO authenticated
  USING (
    assigned_to = auth.uid() OR
    brief_id IN (SELECT id FROM public.briefs WHERE created_by = auth.uid())
  );

CREATE POLICY "Brief owners can create tasks"
  ON public.tasks FOR INSERT
  TO authenticated
  WITH CHECK (
    brief_id IN (SELECT id FROM public.briefs WHERE created_by = auth.uid())
  );

CREATE POLICY "Brief owners can update tasks"
  ON public.tasks FOR UPDATE
  TO authenticated
  USING (
    brief_id IN (SELECT id FROM public.briefs WHERE created_by = auth.uid())
  );

CREATE POLICY "Assignees can update own task status"
  ON public.tasks FOR UPDATE
  TO authenticated
  USING (assigned_to = auth.uid())
  WITH CHECK (assigned_to = auth.uid());

-- Task History Policies
CREATE POLICY "Users can view task history for accessible tasks"
  ON public.task_history FOR SELECT
  TO authenticated
  USING (
    task_id IN (
      SELECT id FROM public.tasks WHERE
        assigned_to = auth.uid() OR
        brief_id IN (SELECT id FROM public.briefs WHERE created_by = auth.uid())
    )
  );

CREATE POLICY "System can insert task history"
  ON public.task_history FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Task Output Versions Policies
CREATE POLICY "Users can view output versions for accessible tasks"
  ON public.task_output_versions FOR SELECT
  TO authenticated
  USING (
    task_id IN (
      SELECT id FROM public.tasks WHERE
        assigned_to = auth.uid() OR
        brief_id IN (SELECT id FROM public.briefs WHERE created_by = auth.uid())
    )
  );

CREATE POLICY "Assignees can create output versions"
  ON public.task_output_versions FOR INSERT
  TO authenticated
  WITH CHECK (
    task_id IN (SELECT id FROM public.tasks WHERE assigned_to = auth.uid())
  );

-- Task Comments Policies
CREATE POLICY "Users can view comments on accessible tasks"
  ON public.task_comments FOR SELECT
  TO authenticated
  USING (
    task_id IN (
      SELECT id FROM public.tasks WHERE
        assigned_to = auth.uid() OR
        brief_id IN (SELECT id FROM public.briefs WHERE created_by = auth.uid())
    )
  );

CREATE POLICY "Users can create comments on accessible tasks"
  ON public.task_comments FOR INSERT
  TO authenticated
  WITH CHECK (
    task_id IN (
      SELECT id FROM public.tasks WHERE
        assigned_to = auth.uid() OR
        brief_id IN (SELECT id FROM public.briefs WHERE created_by = auth.uid())
    )
  );

-- Notifications Policies
CREATE POLICY "Users can view own notifications"
  ON public.notifications FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can update own notifications"
  ON public.notifications FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "System can create notifications"
  ON public.notifications FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Task Presence Policies
CREATE POLICY "Users can view presence on accessible tasks"
  ON public.task_presence FOR SELECT
  TO authenticated
  USING (
    task_id IN (
      SELECT id FROM public.tasks WHERE
        assigned_to = auth.uid() OR
        brief_id IN (SELECT id FROM public.briefs WHERE created_by = auth.uid())
    )
  );

CREATE POLICY "Users can upsert own presence"
  ON public.task_presence FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own presence"
  ON public.task_presence FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Brief Mutes Policies
CREATE POLICY "Users can manage own brief mutes"
  ON public.user_brief_mutes FOR ALL
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- ============================================================================
-- PART 6: Create Triggers and Functions
-- ============================================================================

-- Function to update search_vector on brief changes
CREATE OR REPLACE FUNCTION update_brief_search_vector()
RETURNS TRIGGER AS $$
BEGIN
  NEW.search_vector := to_tsvector('english',
    COALESCE(NEW.title, '') || ' ' ||
    COALESCE(NEW.description, '')
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to auto-update search_vector
DROP TRIGGER IF EXISTS brief_search_vector_update ON public.briefs;
CREATE TRIGGER brief_search_vector_update
  BEFORE INSERT OR UPDATE OF title, description
  ON public.briefs
  FOR EACH ROW
  EXECUTE FUNCTION update_brief_search_vector();

-- Function to log task status changes
CREATE OR REPLACE FUNCTION log_task_status_change()
RETURNS TRIGGER AS $$
BEGIN
  IF (TG_OP = 'UPDATE' AND OLD.status IS DISTINCT FROM NEW.status) THEN
    INSERT INTO public.task_history (task_id, user_id, action, old_value, new_value)
    VALUES (NEW.id, auth.uid(), 'status_change', OLD.status::text, NEW.status::text);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to auto-log status changes
DROP TRIGGER IF EXISTS task_status_change_log ON public.tasks;
CREATE TRIGGER task_status_change_log
  AFTER UPDATE ON public.tasks
  FOR EACH ROW
  EXECUTE FUNCTION log_task_status_change();

-- Function to update brief task_count
CREATE OR REPLACE FUNCTION update_brief_task_count()
RETURNS TRIGGER AS $$
BEGIN
  IF (TG_OP = 'INSERT') THEN
    UPDATE public.briefs SET task_count = task_count + 1 WHERE id = NEW.brief_id;
  ELSIF (TG_OP = 'DELETE') THEN
    UPDATE public.briefs SET task_count = task_count - 1 WHERE id = OLD.brief_id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Trigger to auto-update task_count
DROP TRIGGER IF EXISTS brief_task_count_update ON public.tasks;
CREATE TRIGGER brief_task_count_update
  AFTER INSERT OR DELETE ON public.tasks
  FOR EACH ROW
  EXECUTE FUNCTION update_brief_task_count();

-- ============================================================================
-- Migration Complete
-- ============================================================================
-- The database schema is now fully aligned with PRD Section 5.2
-- Next steps:
-- 1. Run this migration: supabase db push
-- 2. Verify schema in Supabase dashboard
-- 3. Set up n8n workflows
-- ============================================================================
