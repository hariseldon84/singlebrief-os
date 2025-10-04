-- Create security definer function to check project access
CREATE OR REPLACE FUNCTION public.user_can_access_project(_user_id uuid, _project_id uuid)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.projects 
    WHERE id = _project_id AND owner_id = _user_id
  ) OR EXISTS (
    SELECT 1 FROM public.team_members 
    WHERE project_id = _project_id AND user_id = _user_id
  )
$$;

-- Update projects policies to use the function
DROP POLICY IF EXISTS "Users can view their projects" ON public.projects;
CREATE POLICY "Users can view their projects"
  ON public.projects FOR SELECT
  TO authenticated
  USING (public.user_can_access_project(auth.uid(), id));