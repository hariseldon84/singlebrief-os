# Epic 10: User Settings & Profile Management - Detailed User Stories

**Date:** 2025-10-07
**Version:** 1.0
**Status:** Ready for Implementation
**Document Type:** User Story Breakdown

---

## Epic Overview

**Epic Goal:** Unified profile and notification settings for personalized user experience.

**Timeline:** Week 2 (Stories 10.1-10.2, 13 points) + Week 5 (Stories 10.3-10.4, 6 points)
**Priority:** **P1 (Should Have)** - Notification settings are MVP, profile can be basic
**Dependencies:** Epic 8 (Auth) must be complete

**Key Deliverables:**

- Profile management (name, avatar, role, bio)
- Granular notification settings (email + in-app, 8 notification types)
- Help & Support integration (documentation, FAQs, contact support)
- Account preferences consolidation (task limit, timezone, language)

---

## Story 10.1: Profile Management

### User Story

**As a** user
**I want** to manage my profile information
**So that** my identity is accurate across the system

---

### Acceptance Criteria

**Settings Page Access:**

- [ ] Settings page accessible from user menu (top-right avatar dropdown)
- [ ] User menu shows: "Profile," "Settings," "Help," "Sign Out"
- [ ] Clicking "Profile" navigates to Settings page with Profile tab active

**Profile Tab:**

- [ ] Settings page has "Profile" tab (first tab in tab navigation)
- [ ] Tab navigation includes: Profile, Notifications, Preferences, Help & Support

**Profile Form Fields:**

- [ ] **Name**
  - Text input, required, max 100 characters
  - Validation: Cannot be empty
  - Default: Pre-filled from Supabase Auth (if available)
- [ ] **Email**
  - Text input, read-only (disabled), pre-filled from Supabase Auth
  - Tooltip: "Email managed by authentication system"
- [ ] **Avatar**
  - Image upload component
  - Max file size: 2MB
  - Accepted formats: PNG, JPG, JPEG, GIF
  - Recommended dimensions: 400x400px (square)
  - Preview shown after upload
  - Default: Initials-based avatar (e.g., "JD" for John Doe)
- [ ] **Role**
  - Dropdown: "Manager," "Team Member"
  - Default: "Manager"
  - Informational: Affects dashboard view (Epic 9 Story 9.4)
- [ ] **Bio**
  - Textarea, optional, max 500 characters
  - Character count shown below textarea
  - Placeholder: "Tell us about yourself..."

**Save Functionality:**

- [ ] "Save Changes" button at bottom of form
- [ ] Button disabled until changes made (dirty state detection)
- [ ] Clicking "Save Changes":
  - Validates form (name required, avatar < 2MB)
  - Uploads avatar to Supabase Storage (if changed)
  - Updates `profiles` table in Supabase
  - Shows success toast: "Profile updated successfully"
  - Resets dirty state (button disabled again)

**Error Handling:**

- [ ] Show validation errors inline (red text below fields)
  - Name empty: "Name is required"
  - Avatar too large: "Avatar must be under 2MB"
  - Avatar wrong format: "Avatar must be PNG, JPG, or GIF"
- [ ] Show error toast on save failure: "Failed to update profile. Please try again."

**Avatar Display Across System:**

- [ ] Avatar shown in:
  - Navigation header (top-right user menu)
  - Task assignments (assignee avatar in task cards)
  - Comments (user avatar in comment threads)
  - Activity feed (user avatar in activity items)
  - Manager Action Center (if user is performing actions)

---

### Technical Implementation (No-Code)

#### **Database Schema**

```sql
CREATE TABLE profiles (
  user_id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  name text NOT NULL CHECK (length(name) <= 100),
  avatar_url text,
  role text DEFAULT 'Manager' CHECK (role IN ('Manager', 'Team Member')),
  bio text CHECK (length(bio) <= 500),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- RLS Policies
CREATE POLICY "Users can view all profiles"
ON profiles FOR SELECT TO authenticated
USING (true);

CREATE POLICY "Users can update own profile"
ON profiles FOR UPDATE TO authenticated
USING (user_id = auth.uid());

CREATE POLICY "Users can insert own profile"
ON profiles FOR INSERT TO authenticated
WITH CHECK (user_id = auth.uid());

-- Auto-update updated_at timestamp
CREATE TRIGGER update_profiles_updated_at
BEFORE UPDATE ON profiles
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Trigger function (if not exists)
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

---

#### **Supabase Storage Setup**

**Bucket Configuration:**

```javascript
// Create avatars bucket (Supabase Dashboard)
{
  name: 'avatars',
  public: true,
  fileSizeLimit: 2097152, // 2MB in bytes
  allowedMimeTypes: ['image/png', 'image/jpeg', 'image/jpg', 'image/gif']
}
```

**RLS Policies for Storage:**

```sql
-- Allow authenticated users to upload their own avatar
CREATE POLICY "Users can upload own avatar"
ON storage.objects FOR INSERT TO authenticated
WITH CHECK (
  bucket_id = 'avatars'
  AND (storage.foldername(name))[1] = auth.uid()::text
);

-- Allow public read access
CREATE POLICY "Avatars are publicly accessible"
ON storage.objects FOR SELECT TO public
USING (bucket_id = 'avatars');

-- Allow users to update/delete their own avatar
CREATE POLICY "Users can update own avatar"
ON storage.objects FOR UPDATE TO authenticated
USING (
  bucket_id = 'avatars'
  AND (storage.foldername(name))[1] = auth.uid()::text
);
```

---

#### **Frontend (v0.dev + Claude Code)**

**v0.dev Prompt:**

```
Create a settings page with tab navigation (Profile, Notifications, Preferences, Help & Support).

Profile tab contains a form with:
1. Name input (text, required, max 100 chars)
2. Email input (text, read-only, pre-filled)
3. Avatar upload (image, 2MB limit, with preview)
4. Role dropdown (Manager, Team Member)
5. Bio textarea (optional, max 500 chars, character counter)
6. Save Changes button (disabled until form is dirty)

Use shadcn/ui components: Tabs, Input, Textarea, Select, Button, Avatar, Label.
Show validation errors inline.
Toast notifications for success/error.
```

**Claude Code Integration:**

```typescript
import { supabase } from '@/integrations/supabase/client';

// Fetch current profile
const { data: profile } = useQuery({
  queryKey: ['profile'],
  queryFn: async () => {
    const { data: { user } } = await supabase.auth.getUser();
    const { data } = await supabase
      .from('profiles')
      .select('*')
      .eq('user_id', user.id)
      .single();
    return data;
  }
});

// Form state management
const [formData, setFormData] = useState({
  name: profile?.name || '',
  email: user?.email || '',
  avatar_url: profile?.avatar_url || '',
  role: profile?.role || 'Manager',
  bio: profile?.bio || ''
});

const [avatarFile, setAvatarFile] = useState(null);
const [isDirty, setIsDirty] = useState(false);

// Avatar upload handler
const handleAvatarUpload = async (e) => {
  const file = e.target.files[0];
  if (!file) return;

  // Validate file size (2MB)
  if (file.size > 2 * 1024 * 1024) {
    toast.error('Avatar must be under 2MB');
    return;
  }

  // Validate file type
  const allowedTypes = ['image/png', 'image/jpeg', 'image/jpg', 'image/gif'];
  if (!allowedTypes.includes(file.type)) {
    toast.error('Avatar must be PNG, JPG, or GIF');
    return;
  }

  setAvatarFile(file);
  setIsDirty(true);

  // Generate preview
  const reader = new FileReader();
  reader.onloadend = () => {
    setFormData({ ...formData, avatar_url: reader.result });
  };
  reader.readAsDataURL(file);
};

// Save profile handler
const saveProfile = async () => {
  const { data: { user } } = await supabase.auth.getUser();

  // Upload avatar to Supabase Storage (if changed)
  let avatarUrl = formData.avatar_url;
  if (avatarFile) {
    const fileExt = avatarFile.name.split('.').pop();
    const fileName = `${user.id}.${fileExt}`;
    const filePath = `${user.id}/${fileName}`;

    const { error: uploadError } = await supabase.storage
      .from('avatars')
      .upload(filePath, avatarFile, { upsert: true });

    if (uploadError) {
      toast.error('Failed to upload avatar');
      return;
    }

    const { data: { publicUrl } } = supabase.storage
      .from('avatars')
      .getPublicUrl(filePath);
    avatarUrl = publicUrl;
  }

  // Update profile in database
  const { error } = await supabase
    .from('profiles')
    .upsert({
      user_id: user.id,
      name: formData.name,
      avatar_url: avatarUrl,
      role: formData.role,
      bio: formData.bio
    });

  if (error) {
    toast.error('Failed to update profile');
    return;
  }

  toast.success('Profile updated successfully');
  setIsDirty(false);
  setAvatarFile(null);
};
```

---

### Functional Requirements Covered

- **FR136:** System shall provide profile management page with name, avatar, role, bio fields
- **FR137:** Profile avatar shall be uploadable to Supabase Storage and displayed across system

---

### Story Points

**5 points**

**Breakdown:**

- Frontend form (v0.dev): 1 point
- Supabase profile integration: 1 point
- Avatar upload (Storage + validation): 2 points
- Avatar display across system: 0.5 points
- Testing & polish: 0.5 points

---

### Dependencies

- Epic 8 (Authentication) - User accounts must exist

---

### Testing Checklist

- [ ] Settings page accessible from user menu
- [ ] Profile tab displays correctly
- [ ] Form fields pre-filled with existing data
- [ ] Email field is read-only
- [ ] Avatar upload validates file size (<2MB)
- [ ] Avatar upload validates file type (PNG/JPG/GIF)
- [ ] Avatar preview shows after upload
- [ ] Name validation (required, max 100 chars)
- [ ] Bio character counter works (max 500 chars)
- [ ] "Save Changes" disabled until form is dirty
- [ ] Save updates profile in database
- [ ] Save uploads avatar to Supabase Storage
- [ ] Success toast shown after save
- [ ] Error toast shown on save failure
- [ ] Avatar displays in navigation, tasks, comments, activity feed

---

## Story 10.2: Notification Settings (Email + In-App)

### User Story

**As a** user
**I want** granular control over email and in-app notifications
**So that** I receive alerts only for what matters to me

---

### Acceptance Criteria

**Notifications Tab:**

- [ ] Settings page has "Notifications" tab (second tab)
- [ ] Tab displays notification preferences form

**Master Toggles:**

- [ ] Two master switches at top:
  - **Email Notifications** (toggle switch, default: ON)
  - **In-App Notifications** (toggle switch, default: ON)
- [ ] Disabling master toggle disables all sub-toggles for that channel
- [ ] Disabling master toggle grays out all sub-toggles (visual feedback)

**Granular Notification Type Toggles (8 Types):**

**Email Notification Types:**

- [ ] Task Assigned (default: ON)
- [ ] Output Submitted (Manager only, default: ON)
- [ ] Task Accepted (default: ON)
- [ ] Task Rejected (Team Member only, default: ON)
- [ ] @Mention in Comments (default: ON)
- [ ] AI Tasks Completed (Manager only, default: ON)
- [ ] Overdue Task Reminder (Daily digest, default: OFF)
- [ ] Queued AI Tasks Reminder (24h delay, default: OFF)

**In-App Notification Types:**

- [ ] Task Assigned (default: ON)
- [ ] Output Submitted (default: ON)
- [ ] Task Accepted (default: ON)
- [ ] Task Rejected (default: ON)
- [ ] @Mention in Comments (default: ON)
- [ ] AI Tasks Completed (default: ON)
- [ ] Overdue Task Reminder (default: ON)
- [ ] Queued AI Tasks Reminder (default: ON)

**Do Not Disturb (DND):**

- [ ] DND section below notification toggles
- [ ] Description: "No email notifications will be sent during these hours"
- [ ] Start time picker (dropdown or input, default: 9:00 PM)
- [ ] End time picker (dropdown or input, default: 9:00 AM)
- [ ] Time format: 12-hour (with AM/PM) or 24-hour based on locale

**Per-Brief Notification Settings:**

- [ ] "Mute Specific Briefs" section at bottom
- [ ] Brief selector (dropdown showing active briefs)
- [ ] "Mute" button next to dropdown
- [ ] Clicking "Mute":
  - Adds brief to muted list
  - Clears dropdown selection
  - Shows brief in muted list below
- [ ] Muted briefs list:
  - Shows each muted brief with title
  - "Unmute" button next to each brief
  - Clicking "Unmute" removes brief from muted list

**Save Functionality:**

- [ ] "Save Changes" button at bottom of form
- [ ] Button disabled until changes made
- [ ] Clicking "Save Changes":
  - Updates `user_settings` table with all toggle states
  - Updates `user_brief_mutes` table (insert/delete)
  - Shows success toast: "Notification settings updated successfully"
- [ ] Settings applied immediately (n8n workflows check on next notification)

---

### Technical Implementation (No-Code)

#### **Database Schema**

```sql
-- Expand user_settings table (from Epic 2 Story 1.8)
ALTER TABLE user_settings
ADD COLUMN email_notifications_enabled boolean DEFAULT true,
ADD COLUMN inapp_notifications_enabled boolean DEFAULT true,
ADD COLUMN notify_task_assigned_email boolean DEFAULT true,
ADD COLUMN notify_task_assigned_inapp boolean DEFAULT true,
ADD COLUMN notify_output_submitted_email boolean DEFAULT true,
ADD COLUMN notify_output_submitted_inapp boolean DEFAULT true,
ADD COLUMN notify_task_accepted_email boolean DEFAULT true,
ADD COLUMN notify_task_accepted_inapp boolean DEFAULT true,
ADD COLUMN notify_task_rejected_email boolean DEFAULT true,
ADD COLUMN notify_task_rejected_inapp boolean DEFAULT true,
ADD COLUMN notify_mention_email boolean DEFAULT true,
ADD COLUMN notify_mention_inapp boolean DEFAULT true,
ADD COLUMN notify_ai_completed_email boolean DEFAULT true,
ADD COLUMN notify_ai_completed_inapp boolean DEFAULT true,
ADD COLUMN notify_overdue_email boolean DEFAULT false,
ADD COLUMN notify_overdue_inapp boolean DEFAULT true,
ADD COLUMN notify_queued_ai_email boolean DEFAULT false,
ADD COLUMN notify_queued_ai_inapp boolean DEFAULT true,
ADD COLUMN dnd_start_hour int DEFAULT 21, -- 9pm
ADD COLUMN dnd_end_hour int DEFAULT 9; -- 9am

-- Per-brief mutes table (from Epic 5 Story 5.3)
CREATE TABLE IF NOT EXISTS user_brief_mutes (
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE,
  brief_id uuid REFERENCES briefs(id) ON DELETE CASCADE,
  created_at timestamptz DEFAULT now(),
  PRIMARY KEY (user_id, brief_id)
);

-- RLS Policy
CREATE POLICY "Users can manage own brief mutes"
ON user_brief_mutes FOR ALL TO authenticated
USING (user_id = auth.uid());
```

---

#### **Frontend (v0.dev + Claude Code)**

**v0.dev Prompt:**

```
Create Notifications tab in settings page with:
1. Two master toggles: Email Notifications, In-App Notifications
2. Two sections: Email Settings and In-App Settings
3. Each section has 8 toggle switches (notification types)
4. DND section with start/end time pickers
5. Per-brief mute section with dropdown + Mute button
6. Muted briefs list with Unmute buttons
7. Save Changes button

Use shadcn/ui Switch, Label, Select, Button components.
Disable sub-toggles when master toggle is OFF (gray out).
```

**Claude Code Integration:**

```typescript
// Fetch user settings
const { data: settings } = useQuery({
  queryKey: ['notification-settings'],
  queryFn: async () => {
    const { data: { user } } = await supabase.auth.getUser();
    const { data } = await supabase
      .from('user_settings')
      .select('*')
      .eq('user_id', user.id)
      .single();
    return data;
  }
});

// Fetch muted briefs
const { data: mutedBriefs } = useQuery({
  queryKey: ['muted-briefs'],
  queryFn: async () => {
    const { data: { user } } = await supabase.auth.getUser();
    const { data } = await supabase
      .from('user_brief_mutes')
      .select('brief_id, briefs(title)')
      .eq('user_id', user.id);
    return data;
  }
});

// Form state management
const [formData, setFormData] = useState(settings);

// Mute brief handler
const muteBrief = async (briefId) => {
  const { data: { user } } = await supabase.auth.getUser();
  const { error } = await supabase
    .from('user_brief_mutes')
    .insert({ user_id: user.id, brief_id: briefId });

  if (!error) {
    toast.success('Brief muted');
    refetch(); // Refresh muted briefs list
  }
};

// Unmute brief handler
const unmuteBrief = async (briefId) => {
  const { data: { user } } = await supabase.auth.getUser();
  const { error } = await supabase
    .from('user_brief_mutes')
    .delete()
    .eq('user_id', user.id)
    .eq('brief_id', briefId);

  if (!error) {
    toast.success('Brief unmuted');
    refetch();
  }
};

// Save settings handler
const saveSettings = async () => {
  const { data: { user } } = await supabase.auth.getUser();
  const { error } = await supabase
    .from('user_settings')
    .upsert({ user_id: user.id, ...formData });

  if (error) {
    toast.error('Failed to update settings');
    return;
  }

  toast.success('Notification settings updated successfully');
  setIsDirty(false);
};
```

---

#### **n8n Workflow Updates**

**All notification workflows must check settings before sending.**

**Updated Workflow Logic:**

```javascript
// Fetch user notification settings
const { data: settings } = await supabase
  .from('user_settings')
  .select('*')
  .eq('user_id', recipient_user_id)
  .single();

// Notification channel (email or inapp)
const channel = 'email'; // or 'inapp'

// Notification type (e.g., 'task_assigned', 'output_submitted')
const notificationType = 'task_assigned';

// Check master toggle
if (channel === 'email' && !settings.email_notifications_enabled) {
  return; // Don't send email
}
if (channel === 'inapp' && !settings.inapp_notifications_enabled) {
  return; // Don't send in-app notification
}

// Check specific toggle
const toggleField = `notify_${notificationType}_${channel}`;
if (!settings[toggleField]) {
  return; // Don't send this notification type
}

// Check DND hours (email only)
if (channel === 'email') {
  const currentHour = new Date().getHours();
  const { dnd_start_hour, dnd_end_hour } = settings;

  // DND active if current hour is between start and end
  // Handle overnight DND (e.g., 21:00 - 09:00)
  const isDND = dnd_start_hour > dnd_end_hour
    ? (currentHour >= dnd_start_hour || currentHour < dnd_end_hour)
    : (currentHour >= dnd_start_hour && currentHour < dnd_end_hour);

  if (isDND) {
    return; // Don't send during DND hours
  }
}

// Check per-brief mute
const { data: muted } = await supabase
  .from('user_brief_mutes')
  .select('*')
  .eq('user_id', recipient_user_id)
  .eq('brief_id', brief_id)
  .single();

if (muted) {
  return; // Brief is muted, don't send
}

// All checks passed → Send notification
sendNotification(recipient_user_id, notificationType, channel, message);
```

---

### Functional Requirements Covered

- **FR138:** System shall provide notification settings page with email + in-app master toggles
- **FR139:** System shall provide granular notification toggles (8 types × 2 channels = 16 toggles)
- **FR140:** Notification workflows shall check master toggle + specific toggle + DND + per-brief mute before sending

**Consolidates:** Epic 5 Story 5.3 (basic notification preferences)

---

### Story Points

**8 points**

**Breakdown:**

- Frontend settings form (v0.dev): 2 points
- Supabase integration (settings + mutes): 2 points
- Per-brief mute logic: 1 point
- n8n workflow updates (8 workflows): 2 points
- Testing & polish: 1 point

---

### Dependencies

- Epic 5 (Collaboration) - Notifications infrastructure
- Epic 8 (Authentication) - User accounts

---

### Testing Checklist

- [ ] Notifications tab displays correctly
- [ ] Master toggles work (enable/disable all)
- [ ] Disabling master toggle grays out sub-toggles
- [ ] All 16 granular toggles work independently
- [ ] DND time pickers work (start/end time)
- [ ] Brief selector shows active briefs
- [ ] "Mute" adds brief to muted list
- [ ] "Unmute" removes brief from muted list
- [ ] "Save Changes" updates user_settings table
- [ ] "Save Changes" updates user_brief_mutes table
- [ ] n8n workflows respect master toggle
- [ ] n8n workflows respect specific toggles
- [ ] n8n workflows respect DND hours
- [ ] n8n workflows respect per-brief mutes
- [ ] Email notifications blocked during DND
- [ ] In-app notifications not affected by DND

---

## Story 10.3: Help & Support Integration

### User Story

**As a** user
**I want** easy access to help documentation and support
**So that** I can resolve issues without external communication

---

### Acceptance Criteria

**Help & Support Tab:**

- [ ] Settings page has "Help & Support" tab (fourth tab)
- [ ] Tab contains 4 sections (vertically stacked)

**Section 1: Getting Started Guide:**

- [ ] Section title: "Getting Started"
- [ ] Description: "New to SingleBrief? Take a quick tour"
- [ ] Button: "View Getting Started Guide"
- [ ] Clicking button re-triggers onboarding modal (Epic 2 Story 2.10)

**Section 2: FAQ:**

- [ ] Section title: "Frequently Asked Questions"
- [ ] Accordion with 5-7 common questions:
  1. "How do I create a brief?"
  2. "How do I assign tasks to AI agents?"
  3. "How do I review task outputs?"
  4. "How do I customize notification settings?"
  5. "How do I invite team members?"
  6. "How do I export a brief to PDF?"
  7. "What happens if I delete a brief?"
- [ ] Each question expands to show answer (2-3 sentences, markdown supported)
- [ ] All questions collapsed by default
- [ ] Clicking question expands answer, collapses others

**Section 3: Contact Support:**

- [ ] Section title: "Contact Support"
- [ ] Description: "Need help? We're here to assist."
- [ ] Email display: "support@singlebrief.ai"
- [ ] Button: "Email Support"
- [ ] Clicking button opens mailto: link (support@singlebrief.ai)

**Section 4: Product Tour:**

- [ ] Section title: "Product Tour"
- [ ] Description: "Explore SingleBrief features step-by-step"
- [ ] Button: "Take Product Tour"
- [ ] Clicking button re-triggers onboarding modal (same as Getting Started)

**Navigation Link:**

- [ ] Footer or header has "Help" link with ? icon
- [ ] Clicking "Help" navigates to Settings → Help & Support tab
- [ ] Link visible on all pages (persistent navigation)

---

### Technical Implementation (No-Code)

#### **Frontend (v0.dev + Claude Code)**

**v0.dev Prompt:**

```
Create Help & Support tab in settings page with 4 sections:
1. Getting Started - Description + "View Getting Started Guide" button
2. FAQ - Accordion with 5-7 questions/answers (shadcn/ui Accordion)
3. Contact Support - Email display + "Email Support" button
4. Product Tour - Description + "Take Product Tour" button

Use shadcn/ui Card, Accordion, Button components.
FAQ accordion: Only one question expanded at a time.
```

**Claude Code Integration:**

```typescript
// FAQ data (hardcoded in frontend)
const faqs = [
  {
    question: "How do I create a brief?",
    answer: "Click 'New Brief' in the dashboard, enter a title and description (500-5000 characters), then click 'Generate Tasks'. You can use templates to get started faster."
  },
  {
    question: "How do I assign tasks to AI agents?",
    answer: "In the task detail view, click the 'Assign' dropdown and select 'AI Writer' or 'AI Researcher'. Tasks assigned to AI agents are queued and executed when you click 'Execute AI Tasks' in the dashboard."
  },
  {
    question: "How do I review task outputs?",
    answer: "Navigate to the 'Review' tab in your brief. Tasks with status 'Done' will appear here. Click a task to open the review modal, then click 'Accept' or 'Reject' with feedback."
  },
  {
    question: "How do I customize notification settings?",
    answer: "Go to Settings → Notifications tab. You can toggle email and in-app notifications individually for 8 notification types, set Do Not Disturb hours, and mute specific briefs."
  },
  {
    question: "How do I invite team members?",
    answer: "Go to Settings → Team (future feature). Enter the team member's email and click 'Invite'. They will receive a magic link to join your workspace."
  },
  {
    question: "How do I export a brief to PDF?",
    answer: "Open the brief detail page and click the 'Export to PDF' button in the top-right. The PDF includes the brief title, description, 'Why This Matters', tasks, and outputs."
  },
  {
    question: "What happens if I delete a brief?",
    answer: "Deleted briefs are soft-deleted for 30 days. During this time, you can restore them from the 'Archived' view. After 30 days, they are permanently deleted along with all tasks and outputs."
  }
];

// Trigger onboarding modal
const showOnboarding = () => {
  // Reuse onboarding modal component from Epic 2 Story 2.10
  setOnboardingOpen(true);
};

// Open email client
const emailSupport = () => {
  window.location.href = 'mailto:support@singlebrief.ai';
};
```

---

#### **UI Component Structure**

```tsx
<TabsContent value="help">
  <div className="space-y-6">
    {/* Getting Started */}
    <Card>
      <CardHeader>
        <CardTitle>Getting Started</CardTitle>
        <CardDescription>New to SingleBrief? Take a quick tour</CardDescription>
      </CardHeader>
      <CardContent>
        <Button onClick={showOnboarding}>View Getting Started Guide</Button>
      </CardContent>
    </Card>

    {/* FAQ */}
    <Card>
      <CardHeader>
        <CardTitle>Frequently Asked Questions</CardTitle>
      </CardHeader>
      <CardContent>
        <Accordion type="single" collapsible>
          {faqs.map((faq, index) => (
            <AccordionItem key={index} value={`item-${index}`}>
              <AccordionTrigger>{faq.question}</AccordionTrigger>
              <AccordionContent>{faq.answer}</AccordionContent>
            </AccordionItem>
          ))}
        </Accordion>
      </CardContent>
    </Card>

    {/* Contact Support */}
    <Card>
      <CardHeader>
        <CardTitle>Contact Support</CardTitle>
        <CardDescription>Need help? We're here to assist.</CardDescription>
      </CardHeader>
      <CardContent>
        <p className="text-sm text-muted-foreground mb-4">
          Email: support@singlebrief.ai
        </p>
        <Button onClick={emailSupport}>Email Support</Button>
      </CardContent>
    </Card>

    {/* Product Tour */}
    <Card>
      <CardHeader>
        <CardTitle>Product Tour</CardTitle>
        <CardDescription>Explore SingleBrief features step-by-step</CardDescription>
      </CardHeader>
      <CardContent>
        <Button onClick={showOnboarding}>Take Product Tour</Button>
      </CardContent>
    </Card>
  </div>
</TabsContent>
```

---

### Functional Requirements Covered

- **FR141:** Settings shall provide Help & Support tab with FAQ, contact support, product tour

**References:** Epic 2 Story 2.10 (Onboarding modal)

---

### Story Points

**3 points**

**Breakdown:**

- Frontend Help tab (v0.dev): 1 point
- FAQ data (hardcoded): 0.5 points
- Navigation link: 0.5 points
- Onboarding modal integration: 0.5 points
- Testing & polish: 0.5 points

---

### Dependencies

- Epic 2 (Task Management) - Onboarding modal exists (Story 2.10)

---

### Testing Checklist

- [ ] Help & Support tab displays correctly
- [ ] Getting Started section shows
- [ ] "View Getting Started Guide" triggers onboarding modal
- [ ] FAQ accordion displays all questions
- [ ] FAQ accordion expands/collapses correctly
- [ ] Only one FAQ expanded at a time
- [ ] FAQ answers are readable and accurate
- [ ] Contact Support section shows email
- [ ] "Email Support" opens mailto: link
- [ ] Product Tour section shows
- [ ] "Take Product Tour" triggers onboarding modal
- [ ] "Help" navigation link visible on all pages
- [ ] Clicking "Help" link navigates to correct tab

---

## Story 10.4: Account Preferences Consolidation

### User Story

**As a** manager
**I want** all account preferences in one place
**So that** I can manage settings efficiently

---

### Acceptance Criteria

**Preferences Tab:**

- [ ] Settings page has "Preferences" tab (third tab, before Help & Support)

**Consolidated Settings:**

- [ ] **Default Task Limit**
  - Slider component (5-50 range, step: 1)
  - Default: 20
  - Current value shown above slider (e.g., "20 tasks")
  - Description: "Number of tasks AI generates per brief"
  - Updates in real-time as slider moves

**New Preference Fields:**

- [ ] **Timezone**
  - Dropdown (shadcn/ui Select)
  - Auto-detect from browser on first load (using `Intl.DateTimeFormat().resolvedOptions().timeZone`)
  - Options: All major timezones (UTC-12 to UTC+14)
  - Searchable dropdown (filter by typing)
  - Example options:
    - America/New_York (EST/EDT)
    - America/Los_Angeles (PST/PDT)
    - Europe/London (GMT/BST)
    - Asia/Tokyo (JST)
    - Australia/Sydney (AEST/AEDT)
  - Description: "Used for due dates and notification scheduling"

- [ ] **Language**
  - Dropdown (shadcn/ui Select)
  - Default: English
  - Options (MVP):
    - English (only option in MVP)
  - Disabled options with tooltip: "Coming soon" (for other languages)
  - Description: "Interface language (more languages coming soon)"

**Save Functionality:**

- [ ] "Save Changes" button at bottom of form
- [ ] Button disabled until changes made
- [ ] Clicking "Save Changes":
  - Updates `user_settings` table
  - Shows success toast: "Preferences updated successfully"

**Migration:**

- [ ] Remove Epic 2 Story 1.8 (Settings Page - Task Limit Configuration) from Epic 2
- [ ] Consolidate task limit setting into this story

---

### Technical Implementation (No-Code)

#### **Database Schema**

```sql
-- user_settings table already exists from Epic 2 Story 1.8
-- Add new columns for timezone and language
ALTER TABLE user_settings
ADD COLUMN timezone text DEFAULT 'UTC',
ADD COLUMN language text DEFAULT 'en' CHECK (language IN ('en')); -- Expand in future
```

---

#### **Frontend (v0.dev + Claude Code)**

**v0.dev Prompt:**

```
Create Preferences tab in settings page with:
1. Default Task Limit slider (5-50, default 20)
   - Show current value above slider
2. Timezone dropdown (searchable, auto-detect from browser)
   - Major timezones listed
3. Language dropdown (English only in MVP, others disabled)
   - Tooltip: "Coming soon" on disabled options
4. Save Changes button

Use shadcn/ui Slider, Select, Button, Label components.
```

**Claude Code Integration:**

```typescript
// Fetch user settings
const { data: settings } = useQuery({
  queryKey: ['preferences'],
  queryFn: async () => {
    const { data: { user } } = await supabase.auth.getUser();
    const { data } = await supabase
      .from('user_settings')
      .select('*')
      .eq('user_id', user.id)
      .single();
    return data;
  }
});

// Auto-detect timezone on first load
const detectedTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

// Form state management
const [formData, setFormData] = useState({
  default_task_limit: settings?.default_task_limit || 20,
  timezone: settings?.timezone || detectedTimezone,
  language: settings?.language || 'en'
});

// Timezone options (major timezones)
const timezones = [
  { value: 'America/New_York', label: 'America/New York (EST/EDT)' },
  { value: 'America/Chicago', label: 'America/Chicago (CST/CDT)' },
  { value: 'America/Denver', label: 'America/Denver (MST/MDT)' },
  { value: 'America/Los_Angeles', label: 'America/Los Angeles (PST/PDT)' },
  { value: 'Europe/London', label: 'Europe/London (GMT/BST)' },
  { value: 'Europe/Paris', label: 'Europe/Paris (CET/CEST)' },
  { value: 'Asia/Tokyo', label: 'Asia/Tokyo (JST)' },
  { value: 'Asia/Shanghai', label: 'Asia/Shanghai (CST)' },
  { value: 'Asia/Dubai', label: 'Asia/Dubai (GST)' },
  { value: 'Australia/Sydney', label: 'Australia/Sydney (AEST/AEDT)' },
  { value: 'Pacific/Auckland', label: 'Pacific/Auckland (NZST/NZDT)' },
  { value: 'UTC', label: 'UTC (Coordinated Universal Time)' }
];

// Language options (MVP: English only)
const languages = [
  { value: 'en', label: 'English', disabled: false },
  { value: 'es', label: 'Español (Coming Soon)', disabled: true },
  { value: 'fr', label: 'Français (Coming Soon)', disabled: true },
  { value: 'de', label: 'Deutsch (Coming Soon)', disabled: true },
  { value: 'ja', label: '日本語 (Coming Soon)', disabled: true }
];

// Save preferences handler
const savePreferences = async () => {
  const { data: { user } } = await supabase.auth.getUser();
  const { error } = await supabase
    .from('user_settings')
    .upsert({
      user_id: user.id,
      default_task_limit: formData.default_task_limit,
      timezone: formData.timezone,
      language: formData.language
    });

  if (error) {
    toast.error('Failed to update preferences');
    return;
  }

  toast.success('Preferences updated successfully');
  setIsDirty(false);
};
```

---

### Functional Requirements Covered

- **FR142:** Settings shall consolidate account preferences (task limit, timezone, language)

**Consolidates:** Epic 2 Story 1.8 (Settings Page - Task Limit Configuration)

---

### Story Points

**3 points**

**Breakdown:**

- Frontend preferences form (v0.dev): 1 point
- Timezone dropdown (auto-detect): 1 point
- Supabase integration: 0.5 points
- Testing & polish: 0.5 points

---

### Dependencies

- None

---

### Testing Checklist

- [ ] Preferences tab displays correctly
- [ ] Task limit slider works (5-50 range)
- [ ] Current task limit value shown above slider
- [ ] Timezone dropdown shows major timezones
- [ ] Timezone auto-detects from browser on first load
- [ ] Timezone dropdown is searchable
- [ ] Language dropdown shows English (enabled)
- [ ] Other languages shown as disabled with tooltip
- [ ] "Save Changes" updates user_settings table
- [ ] Success toast shown after save
- [ ] Settings persist across sessions
- [ ] Epic 2 Story 1.8 removed (no duplicate settings)

---

## Epic 10 Summary

### Total Story Points: 19

| Story | Story Points | Timeline | Priority |
|-------|--------------|----------|----------|
| 10.1: Profile Management | 5 | Week 2 | P1 |
| 10.2: Notification Settings | 8 | Week 2 | P1 |
| 10.3: Help & Support Integration | 3 | Week 5 | P1 |
| 10.4: Account Preferences Consolidation | 3 | Week 5 | P1 |

**Week 2 Subtotal:** 13 points (Stories 10.1-10.2)
**Week 5 Subtotal:** 6 points (Stories 10.3-10.4)

---

### Epic Dependencies

**Required Before Starting:**

- Epic 8: Authentication (user accounts must exist)
- Epic 5: Collaboration (notification infrastructure for Story 10.2)
- Epic 2: Task Management (onboarding modal for Story 10.3)

---

### Timeline

**Week 2 (Stories 10.1-10.2):**

- Day 1-2: Story 10.1 (Profile Management)
- Day 2-4: Story 10.2 (Notification Settings)
- Runs parallel with Epic 2, Epic 3, Epic 8

**Week 5 (Stories 10.3-10.4):**

- Day 1-2: Story 10.3 (Help & Support)
- Day 2-3: Story 10.4 (Account Preferences)
- Runs parallel with Epic 7 (Why This Matters)

---

### Functional Requirements Covered

- **FR136:** Profile management page with name, avatar, role, bio fields
- **FR137:** Profile avatar uploadable to Supabase Storage, displayed across system
- **FR138:** Notification settings page with email + in-app master toggles
- **FR139:** Granular notification toggles (8 types × 2 channels = 16 toggles)
- **FR140:** Notification workflows check master + specific + DND + per-brief mute
- **FR141:** Help & Support tab with FAQ, contact support, product tour
- **FR142:** Account preferences consolidation (task limit, timezone, language)

**Total:** 7 new FRs

---

### Consolidations

**Stories Removed/Absorbed:**

1. **Epic 2 Story 1.8** (Settings Page - Task Limit) → **Story 10.4**
2. **Epic 5 Story 5.3** (Notification Preferences) → **Story 10.2** (expanded)
3. **Epic 2 Story 2.10** (Onboarding) → Referenced in **Story 10.3** (not removed, just reused)

---

### Success Metrics

**Epic-Level Metrics:**

- **Adoption:** 80%+ of users complete profile setup (name + avatar)
- **Notification Control:** 60%+ of users customize notification settings
- **Help Usage:** 40%+ of new users access Help & Support tab in first week
- **Preferences:** 50%+ of managers adjust default task limit from default (20)

**Story-Level Metrics:**

- Story 10.1: Profile completion rate >80%
- Story 10.2: Notification customization rate >60%
- Story 10.3: FAQ engagement rate >30% (expand at least 1 question)
- Story 10.4: Timezone auto-detection accuracy >95%

---

**Document Status:** Ready for Implementation
**Next Steps:** Review stories → Begin Week 2 implementation (10.1-10.2) → Week 5 polish (10.3-10.4)
