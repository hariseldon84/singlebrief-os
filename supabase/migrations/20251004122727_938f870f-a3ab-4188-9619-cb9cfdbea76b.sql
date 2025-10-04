-- Create security definer function to check if user can view a profile
CREATE OR REPLACE FUNCTION public.user_can_view_profile(_viewer_id uuid, _profile_id uuid)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  -- Allow viewing own profile
  SELECT _viewer_id = _profile_id
  -- Or viewing profiles of users in shared projects (as owner or team member)
  OR EXISTS (
    SELECT 1 FROM public.projects p
    WHERE p.owner_id = _viewer_id 
    AND (
      p.owner_id = _profile_id 
      OR EXISTS (
        SELECT 1 FROM public.team_members tm 
        WHERE tm.project_id = p.id AND tm.user_id = _profile_id
      )
    )
  )
  OR EXISTS (
    SELECT 1 FROM public.team_members tm1
    WHERE tm1.user_id = _viewer_id
    AND (
      EXISTS (
        SELECT 1 FROM public.projects p2
        WHERE p2.id = tm1.project_id AND p2.owner_id = _profile_id
      )
      OR EXISTS (
        SELECT 1 FROM public.team_members tm2
        WHERE tm2.project_id = tm1.project_id AND tm2.user_id = _profile_id
      )
    )
  )
$$;

-- Update profiles SELECT policy to restrict access
DROP POLICY IF EXISTS "Users can view all profiles" ON public.profiles;
CREATE POLICY "Users can view accessible profiles"
  ON public.profiles FOR SELECT
  TO authenticated
  USING (public.user_can_view_profile(auth.uid(), id));