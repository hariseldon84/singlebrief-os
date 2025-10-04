-- Create enums with proper existence check
DO $$ 
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'task_type') THEN
    CREATE TYPE task_type AS ENUM ('ai', 'human');
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'task_status') THEN
    CREATE TYPE task_status AS ENUM ('pending', 'in_progress', 'completed');
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'brief_status') THEN
    CREATE TYPE brief_status AS ENUM ('draft', 'generating', 'active', 'completed');
  END IF;
END$$;

-- Create profiles table
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  phone TEXT,
  department TEXT,
  created_at TIMESTAMPTZ DEFAULT now() NOT NULL
);

-- Create projects table
CREATE TABLE IF NOT EXISTS public.projects (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  owner_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT now() NOT NULL
);

-- Create team_members table
CREATE TABLE IF NOT EXISTS public.team_members (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  project_id UUID NOT NULL REFERENCES public.projects(id) ON DELETE CASCADE,
  department TEXT,
  role TEXT DEFAULT 'member',
  created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
  UNIQUE(user_id, project_id)
);

-- Create briefs table
CREATE TABLE IF NOT EXISTS public.briefs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES public.projects(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  status brief_status DEFAULT 'draft' NOT NULL,
  created_by UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT now() NOT NULL
);

-- Create tasks table
CREATE TABLE IF NOT EXISTS public.tasks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  brief_id UUID NOT NULL REFERENCES public.briefs(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  type task_type NOT NULL,
  assigned_to UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  status task_status DEFAULT 'pending' NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT now() NOT NULL
);

-- Enable RLS on all tables
DO $$ 
BEGIN
  ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
  ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;
  ALTER TABLE public.team_members ENABLE ROW LEVEL SECURITY;
  ALTER TABLE public.briefs ENABLE ROW LEVEL SECURITY;
  ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY;
EXCEPTION
  WHEN OTHERS THEN NULL;
END$$;

-- Profiles policies
DROP POLICY IF EXISTS "Users can view all profiles" ON public.profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can insert own profile" ON public.profiles;

CREATE POLICY "Users can view all profiles"
  ON public.profiles FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Users can update own profile"
  ON public.profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile"
  ON public.profiles FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

-- Projects policies
DROP POLICY IF EXISTS "Users can view their projects" ON public.projects;
DROP POLICY IF EXISTS "Users can create projects" ON public.projects;
DROP POLICY IF EXISTS "Project owners can update their projects" ON public.projects;
DROP POLICY IF EXISTS "Project owners can delete their projects" ON public.projects;

CREATE POLICY "Users can view their projects"
  ON public.projects FOR SELECT
  TO authenticated
  USING (owner_id = auth.uid() OR id IN (
    SELECT project_id FROM public.team_members WHERE user_id = auth.uid()
  ));

CREATE POLICY "Users can create projects"
  ON public.projects FOR INSERT
  TO authenticated
  WITH CHECK (owner_id = auth.uid());

CREATE POLICY "Project owners can update their projects"
  ON public.projects FOR UPDATE
  TO authenticated
  USING (owner_id = auth.uid());

CREATE POLICY "Project owners can delete their projects"
  ON public.projects FOR DELETE
  TO authenticated
  USING (owner_id = auth.uid());

-- Team members policies
DROP POLICY IF EXISTS "Users can view team members in their projects" ON public.team_members;
DROP POLICY IF EXISTS "Project owners can add team members" ON public.team_members;
DROP POLICY IF EXISTS "Project owners can remove team members" ON public.team_members;

CREATE POLICY "Users can view team members in their projects"
  ON public.team_members FOR SELECT
  TO authenticated
  USING (project_id IN (
    SELECT id FROM public.projects WHERE owner_id = auth.uid()
  ) OR user_id = auth.uid());

CREATE POLICY "Project owners can add team members"
  ON public.team_members FOR INSERT
  TO authenticated
  WITH CHECK (project_id IN (
    SELECT id FROM public.projects WHERE owner_id = auth.uid()
  ));

CREATE POLICY "Project owners can remove team members"
  ON public.team_members FOR DELETE
  TO authenticated
  USING (project_id IN (
    SELECT id FROM public.projects WHERE owner_id = auth.uid()
  ));

-- Briefs policies
DROP POLICY IF EXISTS "Users can view briefs in their projects" ON public.briefs;
DROP POLICY IF EXISTS "Users can create briefs in their projects" ON public.briefs;
DROP POLICY IF EXISTS "Users can update briefs in their projects" ON public.briefs;

CREATE POLICY "Users can view briefs in their projects"
  ON public.briefs FOR SELECT
  TO authenticated
  USING (project_id IN (
    SELECT id FROM public.projects WHERE owner_id = auth.uid()
    UNION
    SELECT project_id FROM public.team_members WHERE user_id = auth.uid()
  ));

CREATE POLICY "Users can create briefs in their projects"
  ON public.briefs FOR INSERT
  TO authenticated
  WITH CHECK (
    project_id IN (
      SELECT id FROM public.projects WHERE owner_id = auth.uid()
      UNION
      SELECT project_id FROM public.team_members WHERE user_id = auth.uid()
    )
    AND created_by = auth.uid()
  );

CREATE POLICY "Users can update briefs in their projects"
  ON public.briefs FOR UPDATE
  TO authenticated
  USING (project_id IN (
    SELECT id FROM public.projects WHERE owner_id = auth.uid()
    UNION
    SELECT project_id FROM public.team_members WHERE user_id = auth.uid()
  ));

-- Tasks policies
DROP POLICY IF EXISTS "Users can view tasks in their projects" ON public.tasks;
DROP POLICY IF EXISTS "Users can create tasks in their projects" ON public.tasks;
DROP POLICY IF EXISTS "Users can update tasks in their projects" ON public.tasks;

CREATE POLICY "Users can view tasks in their projects"
  ON public.tasks FOR SELECT
  TO authenticated
  USING (brief_id IN (
    SELECT b.id FROM public.briefs b
    JOIN public.projects p ON b.project_id = p.id
    WHERE p.owner_id = auth.uid()
    UNION
    SELECT b.id FROM public.briefs b
    WHERE b.project_id IN (
      SELECT project_id FROM public.team_members WHERE user_id = auth.uid()
    )
  ));

CREATE POLICY "Users can create tasks in their projects"
  ON public.tasks FOR INSERT
  TO authenticated
  WITH CHECK (brief_id IN (
    SELECT b.id FROM public.briefs b
    JOIN public.projects p ON b.project_id = p.id
    WHERE p.owner_id = auth.uid()
    UNION
    SELECT b.id FROM public.briefs b
    WHERE b.project_id IN (
      SELECT project_id FROM public.team_members WHERE user_id = auth.uid()
    )
  ));

CREATE POLICY "Users can update tasks in their projects"
  ON public.tasks FOR UPDATE
  TO authenticated
  USING (brief_id IN (
    SELECT b.id FROM public.briefs b
    JOIN public.projects p ON b.project_id = p.id
    WHERE p.owner_id = auth.uid()
    UNION
    SELECT b.id FROM public.briefs b
    WHERE b.project_id IN (
      SELECT project_id FROM public.team_members WHERE user_id = auth.uid()
    )
  ));

-- Create trigger function for profile creation
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profiles (id, name, email)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'name', 'User'),
    NEW.email
  );
  RETURN NEW;
END;
$$;

-- Create trigger for new user signup
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION public.update_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

-- Add update triggers
DROP TRIGGER IF EXISTS update_projects_updated_at ON public.projects;
CREATE TRIGGER update_projects_updated_at
  BEFORE UPDATE ON public.projects
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at();

DROP TRIGGER IF EXISTS update_briefs_updated_at ON public.briefs;
CREATE TRIGGER update_briefs_updated_at
  BEFORE UPDATE ON public.briefs
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at();

DROP TRIGGER IF EXISTS update_tasks_updated_at ON public.tasks;
CREATE TRIGGER update_tasks_updated_at
  BEFORE UPDATE ON public.tasks
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at();