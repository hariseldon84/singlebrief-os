# Story 10.1: Profile Management

**Story ID:** STORY-10.1
**Epic:** Epic 10 - User Settings & Profile Management
**Status:** ⬜ To Do
**Last Updated:** 2025-10-07

---

## User Story

**As a** user
**I want to** manage my profile information (name, avatar, bio, role)
**So that** my colleagues can identify me and understand my role in the team

---

## Acceptance Criteria

### Profile Fields
- [ ] Display and edit 4 profile fields (FR-PROF-01):
  - **Name** (required, max 100 chars)
  - **Avatar** (optional, image upload, max 2MB)
  - **Role** (dropdown: Manager, Team Member)
  - **Bio** (optional, max 500 chars)
- [ ] All fields pre-populated from `profiles` table on load
- [ ] Changes auto-save on blur (no explicit save button)

### Avatar Upload
- [ ] Click avatar → Opens file picker (FR-PROF-02)
- [ ] Accepts: JPG, PNG, GIF (max 2MB)
- [ ] Image uploads to Supabase Storage (`avatars` bucket)
- [ ] Avatar displays as circular thumbnail (80px × 80px)
- [ ] Shows upload progress indicator
- [ ] Error handling for oversized files or invalid formats

### Validation Rules
- [ ] **Name:** 1-100 characters, no HTML (FR-PROF-03)
- [ ] **Avatar:** Max 2MB, image formats only
- [ ] **Role:** Must be 'Manager' or 'Team Member'
- [ ] **Bio:** Max 500 characters, no HTML
- [ ] Show inline validation errors below each field

### Profile Display
- [ ] Profile card shows current user info (FR-PROF-04):
  - Avatar (or default icon if no avatar)
  - Name (large, bold)
  - Role badge (color-coded: Manager=blue, Team Member=green)
  - Bio (wrapped text, max 3 lines with ellipsis)
- [ ] "Edit Profile" button → Opens edit mode

### Success Feedback
- [ ] Toast notification on successful save: "Profile updated" (FR-PROF-05)
- [ ] Toast notification on upload success: "Avatar uploaded"
- [ ] Error toast for failures: "Failed to update profile. Please try again."

---

## Technical Implementation

### Frontend (v0.dev + Claude Code)

**Component:** `ProfileManagement.tsx`

**v0.dev Prompt:**
```
Create a profile management page with:
- Avatar upload (circular, 80px, file picker)
- Input field for name (max 100 chars)
- Dropdown for role (Manager, Team Member)
- Textarea for bio (max 500 chars)
- Character counters below name and bio
- "Edit Profile" button to toggle edit mode
- Use shadcn/ui Card, Input, Textarea, Select, Avatar, Button

Validation: Inline errors, auto-save on blur, toast notifications.
```

**Claude Code Integration:**
```typescript
import { supabase } from "@/integrations/supabase/client";
import { useQuery, useMutation } from "@tanstack/react-query";
import { useToast } from "@/components/ui/use-toast";

// Fetch current profile
const { data: profile } = useQuery({
  queryKey: ['user-profile'],
  queryFn: async () => {
    const currentUserId = (await supabase.auth.getUser()).data.user?.id;
    const { data } = await supabase
      .from('profiles')
      .select('*')
      .eq('user_id', currentUserId)
      .single();
    return data;
  }
});

// Update profile mutation
const updateProfile = useMutation({
  mutationFn: async (updates) => {
    const currentUserId = (await supabase.auth.getUser()).data.user?.id;
    const { error } = await supabase
      .from('profiles')
      .update(updates)
      .eq('user_id', currentUserId);
    if (error) throw error;
  },
  onSuccess: () => {
    toast({ title: "Profile updated", variant: "success" });
  },
  onError: () => {
    toast({ title: "Failed to update profile", variant: "destructive" });
  }
});

// Avatar upload mutation
const uploadAvatar = useMutation({
  mutationFn: async (file) => {
    const currentUserId = (await supabase.auth.getUser()).data.user?.id;
    const fileExt = file.name.split('.').pop();
    const fileName = `${currentUserId}.${fileExt}`;

    // Upload to Supabase Storage
    const { error: uploadError } = await supabase.storage
      .from('avatars')
      .upload(fileName, file, { upsert: true });
    if (uploadError) throw uploadError;

    // Get public URL
    const { data: { publicUrl } } = supabase.storage
      .from('avatars')
      .getPublicUrl(fileName);

    // Update profile with avatar URL
    await updateProfile.mutateAsync({ avatar_url: publicUrl });
  },
  onSuccess: () => {
    toast({ title: "Avatar uploaded", variant: "success" });
  },
  onError: () => {
    toast({ title: "Avatar upload failed", variant: "destructive" });
  }
});

// Auto-save on blur
const handleBlur = (field, value) => {
  updateProfile.mutate({ [field]: value });
};
```

### Database Schema

```sql
-- Profiles table (already exists from Epic 8, verify fields)
CREATE TABLE IF NOT EXISTS profiles (
  user_id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  name text NOT NULL CHECK (length(name) <= 100 AND length(name) > 0),
  avatar_url text,
  role text DEFAULT 'Manager' CHECK (role IN ('Manager', 'Team Member')),
  bio text CHECK (length(bio) <= 500),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Trigger to update updated_at
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER profiles_updated_at
BEFORE UPDATE ON profiles
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

-- RLS Policies
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own profile"
ON profiles FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "Users can update own profile"
ON profiles FOR UPDATE
USING (auth.uid() = user_id);
```

### Supabase Storage

**Bucket:** `avatars`

**Configuration:**
- Public bucket (read access for all users)
- File size limit: 2MB
- Allowed MIME types: `image/jpeg`, `image/png`, `image/gif`

**RLS Policies:**
```sql
-- Allow users to upload their own avatar
CREATE POLICY "Users can upload own avatar"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'avatars'
  AND auth.uid()::text = (storage.foldername(name))[1]
);

-- Allow users to update their own avatar
CREATE POLICY "Users can update own avatar"
ON storage.objects FOR UPDATE
USING (
  bucket_id = 'avatars'
  AND auth.uid()::text = (storage.foldername(name))[1]
);
```

---

## Story Points

**5 points**

**Breakdown:**
- UI component (v0.dev + profile fields): 1 point
- Avatar upload to Supabase Storage: 1.5 points
- Auto-save logic + validation: 1 point
- Database schema + RLS policies: 1 point
- Testing: 0.5 point

---

## Dependencies

- **Epic 8** - User authentication working
- `profiles` table exists (created in Epic 8)
- Supabase Storage configured
- User can access Settings page (Epic 10 navigation)

---

## Testing Checklist

### Unit Tests
- [ ] Name validation (empty, too long, HTML injection)
- [ ] Bio validation (too long, HTML injection)
- [ ] Role validation (only Manager or Team Member accepted)
- [ ] Avatar file size validation (reject >2MB)
- [ ] Avatar format validation (reject non-images)

### Integration Tests
- [ ] Profile loads current user data on mount
- [ ] Auto-save triggers on blur (not on every keystroke)
- [ ] Avatar upload saves to Supabase Storage
- [ ] Avatar URL updates in profiles table
- [ ] Toast notifications appear on success/error
- [ ] RLS policies prevent cross-user access

### E2E Tests (Playwright)
- [ ] Navigate to Settings → Profile tab
- [ ] Profile displays current user info
- [ ] Click "Edit Profile" → fields become editable
- [ ] Edit name → blur → auto-saves
- [ ] Edit bio → blur → auto-saves
- [ ] Change role → auto-saves
- [ ] Click avatar → file picker opens
- [ ] Upload avatar → shows progress → displays new avatar
- [ ] Upload oversized file → shows error toast
- [ ] Profile updates persist after page refresh

---

## Definition of Done

- [ ] All acceptance criteria met
- [ ] Unit tests written and passing
- [ ] Integration tests written and passing
- [ ] E2E test written and passing
- [ ] Code reviewed and approved
- [ ] Merged to main branch
- [ ] Deployed to staging
- [ ] Product owner accepts story

---

## FRs Covered

- **FR-PROF-01**: Profile fields (name, avatar, role, bio)
- **FR-PROF-02**: Avatar upload with file picker
- **FR-PROF-03**: Validation rules for all fields
- **FR-PROF-04**: Profile card display with role badge
- **FR-PROF-05**: Success/error feedback via toast notifications

---

## Notes

- Default avatar icon: Use user initials (e.g., "JD" for John Doe)
- Avatar cropping deferred to post-MVP (use as-is upload)
- Consider adding "Delete Avatar" button in future
- Bio supports plain text only (no markdown/HTML in MVP)

---

## Related Files

- **Component:** `/src/components/ProfileManagement.tsx` (to be created)
- **Database:** `/supabase/migrations/[timestamp]_create_profiles_table.sql`
- **Storage:** Supabase Storage `avatars` bucket
- **PRD:** `/docs/prd/newscopemissing.md` - Epic 10, Story 10.1
- **Epic Stories:** `/docs/prd/epic10_stories.md`

---

**Last Updated:** 2025-10-07
**Assignee:** TBD
**Start Date:** TBD
**End Date:** TBD
