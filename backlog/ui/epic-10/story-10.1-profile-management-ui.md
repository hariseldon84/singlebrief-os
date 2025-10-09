# UI/UX Specification: Story 10.1 - Profile Management

**Story ID:** STORY-10.1
**Feature:** User Profile Management Page
**Design System:** shadcn/ui + Tailwind CSS

---

## 1. Screen Overview

### Purpose
Allow users to manage their profile information including name, avatar, role, and bio. Provides team visibility and personalization. Auto-save functionality for seamless experience.

### User Flow Entry Points
1. Settings page → Profile tab (first tab)
2. User menu → "My Profile" or "Settings"
3. First-time setup (after authentication)

### Success Criteria
- User can update profile in <30 seconds
- Avatar upload completes in <5 seconds
- Changes auto-save without explicit save button
- Profile displays correctly across all views

---

## 2. Layout Structure

### Profile Management Layout
```
┌───────────────────────────────────────────────────────┐
│  SETTINGS                                              │
│  ┌─────────┬─────────────┬──────┬─────────────┐      │
│  │ Profile │Notifications│ Help │ Preferences │       │
│  └─────────┴─────────────┴──────┴─────────────┘      │
├───────────────────────────────────────────────────────┤
│                                                        │
│  PROFILE DISPLAY                                      │
│  ┌──────────────────────────────────────────────────┐ │
│  │  👤 [Avatar]          John Doe                   │ │
│  │   80×80px           [Manager]                    │ │
│  │                                                   │ │
│  │  "Product manager with 5 years experience..."   │ │
│  │                                                   │ │
│  │                               [Edit Profile]     │ │
│  └──────────────────────────────────────────────────┘ │
│                                                        │
│  EDIT MODE (Toggle)                                   │
│  ┌──────────────────────────────────────────────────┐ │
│  │  👤 [Click to upload]                            │ │
│  │   (Max 2MB: JPG, PNG, GIF)                       │ │
│  │                                                   │ │
│  │  Name *                                          │ │
│  │  ┌────────────────────────────────────────────┐ │ │
│  │  │ John Doe                              (45) │ │ │
│  │  └────────────────────────────────────────────┘ │ │
│  │  1-100 characters                                │ │
│  │                                                   │ │
│  │  Role *                                          │ │
│  │  ┌────────────────────────────────────────────┐ │ │
│  │  │ Manager                               ▼    │ │ │
│  │  └────────────────────────────────────────────┘ │ │
│  │                                                   │ │
│  │  Bio (Optional)                                  │ │
│  │  ┌────────────────────────────────────────────┐ │ │
│  │  │ Product manager with 5 years...            │ │ │
│  │  │                                   (120/500)│ │ │
│  │  └────────────────────────────────────────────┘ │ │
│  │  Max 500 characters                              │ │
│  │                                                   │ │
│  │                           [Cancel]  [Save]       │ │
│  └──────────────────────────────────────────────────┘ │
│                                                        │
└────────────────────────────────────────────────────────┘
```

### Responsive Breakpoints
- **Mobile (< 640px):** Full-width layout, stacked fields
- **Tablet (640-1024px):** Centered card, max-width 600px
- **Desktop (> 1024px):** Centered card, max-width 700px

---

## 3. Component Specifications

### 3.1 Settings Container
**Component:** Tabs container with 4 tabs
- **Tabs:** Profile | Notifications | Help | Preferences
- **Active Tab:** Profile (default)
- **Style:** `border-b` with active indicator
- **Tab Indicator:** Blue underline on active tab

### 3.2 Profile Display Card (View Mode)
**Component:** `<Card>` (shadcn/ui)
- **Avatar:** 80×80px circular image or initials
- **Name:** `text-2xl font-bold`
- **Role Badge:** Pill-shaped badge
  - Manager: Blue (`bg-blue-100 text-blue-700`)
  - Team Member: Green (`bg-green-100 text-green-700`)
- **Bio:** `text-sm text-muted-foreground`, max 3 lines with ellipsis
- **Edit Button:** Top-right position, `variant="outline"`

### 3.3 Avatar Component
**Display Mode:**
- **With Image:** Circular 80×80px image
- **Without Image:** Initials in circle (2 letters, uppercase)
  - Background: Gradient or solid color
  - Text: White, 24px font
  - Example: "JD" for John Doe

**Edit Mode:**
- **Click Area:** Full 80×80px circle with dashed border
- **Icon:** Upload icon in center
- **Text Below:** "Click to upload" - `text-xs text-muted-foreground`
- **File Restrictions:** "Max 2MB: JPG, PNG, GIF"
- **Upload State:** Progress ring around avatar (0-100%)

### 3.4 Name Input
**Component:** `<Input>` (shadcn/ui)
- **Label:** "Name *" (required asterisk)
- **Placeholder:** "Enter your name"
- **Max Length:** 100 characters
- **Character Counter:** Bottom-right `(X/100)`
- **Validation:**
  - Min 1 character: "Name is required"
  - Max 100 characters: "Name too long"
  - No HTML: Strip tags automatically
- **Auto-save:** On blur

### 3.5 Role Dropdown
**Component:** `<Select>` (shadcn/ui)
- **Label:** "Role *" (required)
- **Options:**
  - Manager
  - Team Member
- **Default:** Current user role
- **Auto-save:** On change
- **Icon:** Chevron down

### 3.6 Bio Textarea
**Component:** `<Textarea>` (shadcn/ui)
- **Label:** "Bio (Optional)"
- **Placeholder:** "Tell your team about yourself..."
- **Min Height:** 120px
- **Max Length:** 500 characters
- **Character Counter:** Bottom-right `(X/500)`
- **Auto-expand:** Up to 200px max height
- **Validation:**
  - Max 500 characters
  - No HTML (strip tags)
- **Auto-save:** On blur

### 3.7 Action Buttons (Edit Mode)
**Cancel Button:**
- **Component:** `<Button>` variant="outline"
- **Text:** "Cancel"
- **Action:** Revert changes, exit edit mode
- **Position:** Bottom-right, left of Save

**Save Button:**
- **Component:** `<Button>` variant="default"
- **Text:** "Save Changes"
- **Action:** Save all fields, exit edit mode
- **Loading State:** Spinner + "Saving..."
- **Position:** Bottom-right

---

## 4. Interaction Patterns

### 4.1 View to Edit Mode
**"Edit Profile" Button:**
1. Click → Switch to edit mode
2. All fields become editable
3. Avatar shows upload target
4. Cancel and Save buttons appear

### 4.2 Avatar Upload
**Click Avatar in Edit Mode:**
1. File picker opens
2. Select image (JPG, PNG, GIF, max 2MB)
3. Validate file size and format
4. If valid:
   - Show progress ring (0-100%)
   - Upload to Supabase Storage (`avatars` bucket)
   - Get public URL
   - Update profile with avatar URL
   - Display new avatar
   - Toast: "Avatar uploaded successfully"
5. If invalid:
   - Toast error: "File too large (max 2MB)" or "Invalid format"

### 4.3 Auto-Save Behavior
**Name Field:**
- User types → Counter updates
- User blurs field → Auto-save triggers
- Success: Toast "Profile updated"
- Error: Toast "Failed to update profile"

**Role Dropdown:**
- User selects new role → Auto-save immediately
- Success: Badge color updates, toast appears
- Error: Revert to previous role, show toast

**Bio Textarea:**
- User types → Counter updates
- User blurs → Auto-save triggers
- Same toast notifications as name

### 4.4 Cancel and Save
**Cancel Button:**
1. Click → Confirmation if changes made: "Discard changes?"
2. If yes → Revert to original values
3. Exit edit mode → Return to view mode

**Save Button:**
1. Click → Validate all fields
2. If valid → Save all changes
3. Show loading state
4. On success:
   - Toast: "Profile updated successfully"
   - Exit edit mode
5. On error:
   - Toast: "Failed to save profile"
   - Stay in edit mode

---

## 5. States & Visual Feedback

### 5.1 View Mode
- Avatar displays (image or initials)
- Name, role, bio displayed
- Edit button visible
- No input fields

### 5.2 Edit Mode
- Avatar shows upload target
- All fields editable
- Character counters visible
- Cancel and Save buttons visible

### 5.3 Avatar Upload States
- **Idle:** Dashed circle with upload icon
- **Hover:** Border color changes to primary
- **Uploading:** Progress ring animates (0-100%)
- **Success:** New avatar displays
- **Error:** Red border, error icon

### 5.4 Field Validation States
- **Valid:** Green checkmark icon (optional)
- **Invalid:** Red border, error message below
- **Too Long:** Character counter turns red

### 5.5 Loading States
- **Save Button:** Spinner + "Saving..."
- **Avatar Upload:** Progress ring + percentage
- **Entire Form:** Disabled overlay (optional)

---

## 6. Responsive Behavior

### Mobile (< 640px)
- Full-width layout
- Avatar: 64×64px (smaller)
- Fields stack vertically
- Buttons full width, stacked
- Character counters below fields

### Tablet (640-1024px)
- Centered card, max-width 600px
- Avatar: 80×80px
- Normal field layout
- Buttons horizontal at bottom

### Desktop (> 1024px)
- Centered card, max-width 700px
- Avatar: 80×80px
- Optimal spacing
- Hover effects enabled

---

## 7. Accessibility Requirements

### Keyboard Navigation
- **Tab Order:** Avatar → Name → Role → Bio → Cancel → Save
- **Enter:** Submit form (if in edit mode)
- **Escape:** Cancel edit mode (with confirmation)

### Screen Reader Support
- **Avatar:** `aria-label="User avatar, click to upload"`
- **Input Labels:** Properly associated with `for` attribute
- **Required Fields:** `aria-required="true"`
- **Character Counters:** `aria-live="polite"` for dynamic updates
- **Error Messages:** `aria-invalid="true"` and `aria-describedby` linked

### Focus Management
- Focus moves to first field on edit mode
- Focus returns to Edit button on cancel
- Clear focus indicators (2px blue ring)

### Color Contrast
- All text meets WCAG AA (4.5:1 minimum)
- Role badges have sufficient contrast
- Error states clearly visible

---

## 8. Design Tokens

### Colors
```css
--profile-avatar-bg: hsl(210 70% 95%)
--profile-avatar-text: hsl(210 70% 40%)
--profile-name: hsl(240 10% 3.9%)
--role-manager-bg: hsl(210 90% 95%)
--role-manager-text: hsl(210 70% 45%)
--role-member-bg: hsl(142 90% 95%)
--role-member-text: hsl(142 70% 45%)
--bio-text: hsl(240 5% 46%)
```

### Spacing
```css
--avatar-size: 80px (desktop), 64px (mobile)
--card-padding: 24px
--field-gap: 20px
--button-gap: 12px
```

### Typography
```css
--name-display: 24px / 700 / 1.2
--role-badge: 12px / 500 / 1.3
--bio-text: 14px / 400 / 1.5
--label: 14px / 500 / 1.4
--input: 16px / 400 / 1.5
--counter: 12px / 400 / 1.3
```

---

## 9. Implementation Notes for Developer

### Tech Stack
- **Framework:** React 18 + TypeScript
- **UI Library:** shadcn/ui + Tailwind CSS
- **Data Fetching:** TanStack Query
- **File Upload:** Supabase Storage
- **Backend:** Supabase

### Key Files
- Component: `src/components/settings/ProfileManagement.tsx`
- Avatar: `src/components/settings/AvatarUpload.tsx`
- Hook: `src/hooks/use-profile.ts`

### Profile Data Hook
```typescript
export const useProfile = () => {
  return useQuery({
    queryKey: ['user-profile'],
    queryFn: async () => {
      const user = await supabase.auth.getUser();
      const { data } = await supabase
        .from('profiles')
        .select('*')
        .eq('user_id', user.data.user?.id)
        .single();
      return data;
    }
  });
};
```

### Avatar Upload Hook
```typescript
export const useAvatarUpload = () => {
  return useMutation({
    mutationFn: async (file: File) => {
      // Validate file
      if (file.size > 2 * 1024 * 1024) {
        throw new Error('File too large (max 2MB)');
      }

      const user = await supabase.auth.getUser();
      const fileExt = file.name.split('.').pop();
      const fileName = `${user.data.user?.id}.${fileExt}`;

      // Upload to Storage
      const { error } = await supabase.storage
        .from('avatars')
        .upload(fileName, file, { upsert: true });

      if (error) throw error;

      // Get public URL
      const { data: { publicUrl } } = supabase.storage
        .from('avatars')
        .getPublicUrl(fileName);

      // Update profile
      await supabase
        .from('profiles')
        .update({ avatar_url: publicUrl })
        .eq('user_id', user.data.user?.id);

      return publicUrl;
    }
  });
};
```

---

## 10. v0.dev / Lovable AI Prompt

```
Create a user profile management page using React, TypeScript, and shadcn/ui.

LAYOUT:
- Settings page with 4 tabs: Profile | Notifications | Help | Preferences
- Profile tab active by default
- Two modes: View mode and Edit mode

VIEW MODE:
- Card with user profile display
- Avatar: 80×80px circular (image or initials)
- Name: Large, bold text
- Role Badge: Pill shape (Manager=blue, Team Member=green)
- Bio: 3 lines max with ellipsis
- "Edit Profile" button (outline variant, top-right)

EDIT MODE:
- Avatar upload: Click 80×80px circle to open file picker
  * Accepts: JPG, PNG, GIF (max 2MB)
  * Shows progress ring during upload
  * Displays error toast if invalid
- Name input: Max 100 chars, character counter, required
- Role dropdown: Manager or Team Member, required
- Bio textarea: Max 500 chars, character counter, optional, auto-expand to 200px
- Cancel and Save buttons at bottom

AUTO-SAVE:
- Name: Auto-save on blur
- Role: Auto-save on change
- Bio: Auto-save on blur
- Toast notifications for success/error

AVATAR UPLOAD TO SUPABASE:
- Upload to `avatars` bucket in Supabase Storage
- Get public URL
- Update `profiles` table with avatar_url

VALIDATION:
- Name: 1-100 chars, no HTML
- Bio: Max 500 chars, no HTML
- Avatar: Max 2MB, image formats only
- Show inline error messages

BUTTONS:
- Cancel: Revert changes, confirm if dirty, exit edit mode
- Save: Validate → Save → Toast → Exit edit mode
- Edit Profile: Enter edit mode

RESPONSIVE:
- Mobile (<640px): Full-width, 64×64px avatar, stacked buttons
- Desktop (≥640px): Centered card, 80×80px avatar

ACCESSIBILITY:
- Keyboard navigation
- Screen reader labels
- Focus indicators
- WCAG AA contrast

TECH STACK:
- React 18 + TypeScript
- shadcn/ui: Card, Input, Textarea, Select, Button, Avatar, Tabs
- TanStack Query for data fetching
- Supabase for backend and storage
- Tailwind CSS
```

---

## 11. Testing Checklist

### Visual Testing
- [ ] Avatar displays correctly (image or initials)
- [ ] Role badge shows correct color
- [ ] Edit mode shows all fields
- [ ] Character counters update in real-time
- [ ] Upload progress ring animates

### Functional Testing
- [ ] Edit button toggles edit mode
- [ ] Avatar upload works (valid files)
- [ ] Avatar upload rejects oversized files
- [ ] Auto-save on blur (name, bio)
- [ ] Auto-save on change (role)
- [ ] Cancel button reverts changes
- [ ] Save button saves all fields

### Responsive Testing
- [ ] Mobile: 64×64px avatar, full-width
- [ ] Tablet: Centered, 80×80px avatar
- [ ] Desktop: Optimal layout

### Accessibility Testing
- [ ] Keyboard navigation works
- [ ] Screen reader announces elements
- [ ] Focus indicators visible
- [ ] Color contrast meets WCAG AA

---

## 12. Related Files & Dependencies

**Component Files:**
- `/src/components/settings/ProfileManagement.tsx` (to be created)
- `/src/components/settings/AvatarUpload.tsx` (to be created)
- `/src/hooks/use-profile.ts` (to be created)
- `/src/hooks/use-avatar-upload.ts` (to be created)

**Dependencies:**
- Epic 8: User authentication, `profiles` table
- Supabase Storage: `avatars` bucket configured
- Settings navigation exists

**Database Schema:**
- `profiles` table: user_id, name, avatar_url, role, bio

---

**Last Updated:** 2025-10-09
**Design Status:** Ready for Development
**Priority:** High (Epic 10 - Story 10.1)
