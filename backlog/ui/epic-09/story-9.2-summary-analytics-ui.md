# UI/UX Specification: Story 9.2 - Summary Analytics Dashboard

**Story ID:** STORY-9.2
**Feature:** Summary Analytics Dashboard Widget
**Design System:** shadcn/ui + Tailwind CSS

---

## 1. Screen Overview

### Purpose
Provide managers with high-level performance metrics and trend analysis. Enable data-driven decision making through visual analytics and historical comparisons.

### User Flow Entry Points
1. Dashboard page load (automatic display below Action Center)
2. Dashboard refresh (polling every 5 minutes)
3. Manual refresh button click

### Success Criteria
- Manager can assess team performance in <10 seconds
- Trends are immediately visible and understandable
- Historical comparisons provide actionable insights
- Analytics load within 500ms

---

## 2. Layout Structure

### Analytics Grid Layout
```
┌─────────────────────────────────────────────────────────────┐
│  Summary Analytics                     Last updated: 2m ago  │
│                                                    [Refresh ↻]│
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐   │
│  │ 📊  87%      │  │ 📈  12       │  │ ⏱️   3.5 days   │   │
│  │              │  │              │  │                   │   │
│  │ Brief        │  │ Team         │  │ Average Task     │   │
│  │ Completion   │  │ Velocity     │  │ Duration         │   │
│  │              │  │              │  │                   │   │
│  │ ↑ +5% from   │  │ ↓ -2 tasks   │  │ → No change      │   │
│  │ last week    │  │ from last wk │  │ from last week   │   │
│  └──────────────┘  └──────────────┘  └──────────────────┘   │
│                                                               │
│  ┌──────────────┐                                            │
│  │ 📁  8        │                                            │
│  │              │                                            │
│  │ Active       │                                            │
│  │ Briefs       │                                            │
│  │              │                                            │
│  │ ↑ +2 from    │                                            │
│  │ last week    │                                            │
│  └──────────────┘                                            │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

### Responsive Breakpoints
- **Mobile (< 768px):** 1 card per row, vertical stack
- **Tablet (768-1024px):** 2 cards per row
- **Desktop (> 1024px):** 2×2 grid (4 cards total)

---

## 3. Component Specifications

### 3.1 Analytics Card Container
**Component:** `<Card>` (shadcn/ui)
- **Width:** Full width, max 1200px
- **Padding:** 24px (desktop), 16px (mobile)
- **Background:** `bg-card`
- **Border:** `border`
- **Border Radius:** `rounded-lg`
- **Shadow:** `shadow-sm`

### 3.2 Card Header
**Component:** `<CardHeader>`
- **Title:** "Summary Analytics" - `text-xl font-semibold`
- **Timestamp:** "Last updated: X min ago" - `text-sm text-muted-foreground`
- **Refresh Button:** Icon button (↻) - `ghost` variant, top-right

### 3.3 Stat Cards (4 total)
**Component:** Custom analytics card

**Structure for Each Card:**
- **Icon:** Relevant emoji or Lucide icon
- **Value:** Large primary metric `text-4xl font-bold`
- **Label:** Metric name `text-sm font-medium text-muted-foreground`
- **Trend Indicator:** Arrow icon (↑/↓/→) with comparison text
- **Trend Color:** Green (positive), Red (negative), Gray (stable)

**Card 1: Brief Completion %**
- **Icon:** 📊 or BarChart3
- **Value:** "87%" (calculated percentage)
- **Label:** "Brief Completion"
- **Calculation:** (Completed briefs / Total briefs) × 100
- **Trend Example:** "↑ +5% from last week" (green)
- **Trend Logic:**
  - Green (↑) if percentage increased
  - Red (↓) if percentage decreased
  - Gray (→) if no change (±1%)

**Card 2: Team Velocity**
- **Icon:** 📈 or TrendingUp
- **Value:** "12" (tasks/week)
- **Label:** "Team Velocity"
- **Subtitle:** "tasks/week"
- **Calculation:** Tasks accepted this week
- **Trend Example:** "↓ -2 tasks from last week" (red)
- **Trend Logic:**
  - Green (↑) if this week > last week
  - Red (↓) if this week < last week
  - Gray (→) if same count

**Card 3: Average Task Duration**
- **Icon:** ⏱️ or Clock
- **Value:** "3.5 days" (decimal days)
- **Label:** "Average Task Duration"
- **Calculation:** AVG(accepted_at - created_at) for last 100 tasks
- **Trend Example:** "→ No change from last week" (gray)
- **Trend Logic:**
  - Green (↓) if duration decreased (faster is better)
  - Red (↑) if duration increased (slower is worse)
  - Gray (→) if change < 0.5 days

**Card 4: Active Briefs**
- **Icon:** 📁 or FolderOpen
- **Value:** "8" (count)
- **Label:** "Active Briefs"
- **Calculation:** COUNT(briefs WHERE status='active')
- **Trend Example:** "↑ +2 from last week" (neutral/blue)
- **Trend Logic:**
  - Blue (↑) if count increased
  - Blue (↓) if count decreased
  - Gray (→) if no change

### 3.4 Trend Indicators
**Component:** Custom trend badge

**Arrow Icons:**
- **Up (↑):** TrendingUp icon from Lucide
- **Down (↓):** TrendingDown icon from Lucide
- **Stable (→):** ArrowRight icon from Lucide

**Color Coding:**
```css
/* Positive trends (green) */
--trend-positive-text: hsl(142 70% 45%)
--trend-positive-bg: hsl(142 70% 95%)

/* Negative trends (red) */
--trend-negative-text: hsl(0 70% 50%)
--trend-negative-bg: hsl(0 70% 95%)

/* Neutral/Stable trends (gray) */
--trend-neutral-text: hsl(240 5% 46%)
--trend-neutral-bg: hsl(240 5% 95%)
```

### 3.5 Last Updated Timestamp
**Component:** Custom text element
- **Format:** "Last updated: X min ago"
- **Update Logic:**
  - 0-59 seconds: "just now"
  - 1-59 minutes: "Xm ago"
  - 1+ hours: "Xh ago"
- **Position:** Top-right, next to refresh button
- **Style:** `text-xs text-muted-foreground`

### 3.6 Refresh Button
**Component:** `<Button>` variant="ghost" size="icon"
- **Icon:** RefreshCw (Lucide)
- **Position:** Top-right header
- **Animation:** Rotate 360° on click (200ms)
- **Action:** Force immediate refetch

---

## 4. Interaction Patterns

### 4.1 Data Loading
**Initial Load:**
1. Display 4 skeleton cards with shimmer animation
2. Query Supabase for all metrics (parallel queries)
3. Fade in data with stagger effect (card 1 → 2 → 3 → 4, 100ms delay each)

**Polling (Every 5 minutes):**
1. Silent background refetch
2. Update values if changed
3. Animate number transitions (500ms)
4. Update "last updated" timestamp

### 4.2 Number Animations
**Value Changes:**
- Animate from old value to new value using Framer Motion or CSS counter
- Duration: 500ms with easeInOut
- Decimal values: Animate smoothly with 1 decimal place

**Trend Changes:**
- Trend arrow fades in/out (200ms) when trend direction changes
- Trend text updates with smooth opacity transition

### 4.3 Manual Refresh
**Click Refresh Button:**
1. Rotate icon 360°
2. Trigger immediate refetch (ignoring cache)
3. Show loading state (subtle pulse on cards)
4. Update "last updated" to "just now"
5. Show toast: "Analytics updated" (2s duration)

### 4.4 Hover States
**Stat Card Hover (Desktop):**
- Border color changes to primary
- Slight elevation (shadow-md)
- Transition: 200ms ease

**Tooltip on Hover:**
- Show detailed calculation on icon hover
- Example: "Calculated as (completed briefs / total briefs) × 100"

---

## 5. States & Visual Feedback

### 5.1 Loading State
- 4 skeleton cards with shimmer animation
- Each card shows placeholder for icon, value, label, trend
- No interaction possible during load

### 5.2 Populated State
- All metrics display actual values
- Trend indicators visible with colors
- "Last updated" timestamp shows
- Refresh button available

### 5.3 Error State
**Data Fetch Error:**
- Toast notification: "Failed to load analytics. Refreshing..."
- Attempt auto-retry after 3 seconds
- Show last cached data (if available)
- Refresh button highlighted with amber border

### 5.4 Zero Data State
**No Data Available:**
- Display "0" values with dashes for trends
- Message: "No data yet. Complete tasks to see analytics."
- Muted colors, no trend indicators

---

## 6. Responsive Behavior

### Mobile (< 768px)
- 1 card per row (vertical stack)
- Full width cards
- Larger touch targets
- Font sizes slightly reduced:
  - Value: `text-3xl` (instead of `text-4xl`)
  - Icon: 24px (instead of 32px)
- Timestamp moves below title

### Tablet (768-1024px)
- 2 cards per row
- 2 rows total (2×2 grid)
- Medium spacing (gap: 12px)
- Normal font sizes

### Desktop (> 1024px)
- 2×2 grid layout
- Maximum width: 1200px
- Optimal spacing (gap: 16px)
- Hover effects enabled
- Tooltips on icon hover

---

## 7. Accessibility Requirements

### Keyboard Navigation
- **Tab Order:** Refresh button (only interactive element)
- **Enter:** Trigger refresh
- **Escape:** Close any open tooltips

### Screen Reader Support
- **Card Labels:** `aria-label="Brief completion rate: 87%, up 5% from last week"`
- **Trend Indicators:**
  - "Trending up" / "Trending down" / "Stable trend"
  - Include comparison text in aria-label
- **Timestamp:** Announced as "Analytics last updated 2 minutes ago"
- **Refresh Button:** `aria-label="Refresh analytics data"`

### Focus Management
- Focus ring on refresh button (2px blue)
- Tooltip keyboard accessible (Space to toggle)
- Skip link available for keyboard users

### Color Contrast
- All text meets WCAG AA (4.5:1 minimum)
- Trend colors tested for colorblind accessibility
- Icons supplement color with arrows (not color-only)

---

## 8. Design Tokens

### Colors
```css
--analytics-card-bg: hsl(0 0% 100%)
--analytics-card-border: hsl(240 5.9% 90%)
--value-text: hsl(240 10% 3.9%)
--label-text: hsl(240 5% 46%)
--trend-positive: hsl(142 70% 45%)      /* Green */
--trend-negative: hsl(0 70% 50%)        /* Red */
--trend-neutral: hsl(240 5% 46%)        /* Gray */
--trend-blue: hsl(210 70% 50%)          /* Blue (for active briefs) */
```

### Spacing
```css
--analytics-card-padding: 24px (desktop), 16px (mobile)
--grid-gap: 16px (desktop), 12px (mobile)
--card-gap-internal: 12px
--icon-size: 32px (desktop), 24px (mobile)
```

### Typography
```css
--card-title: 20px / 600 / 1.3
--stat-value: 36px / 700 / 1.1
--stat-label: 14px / 500 / 1.3
--trend-text: 12px / 500 / 1.4
--timestamp: 12px / 400 / 1.3
```

---

## 9. Figma Design Notes

### Component Layers
1. **Analytics Container** - Card with header
2. **Header Section** - Title + timestamp + refresh button
3. **Stats Grid** - 2×2 grid of stat cards
4. **Individual Stat Card** - Icon + value + label + trend

### Auto-layout Structure
- **Container:** Vertical auto-layout, 24px gap
- **Stats Grid:** Auto-layout wrap, 16px gap
- **Stat Card:** Vertical auto-layout, 12px gap, centered content

### Component Variants Needed
**Stat Card Variants:**
- Brief Completion (percentage, green/red trend)
- Team Velocity (number + unit, green/red trend)
- Average Duration (decimal + days, inverted trend logic)
- Active Briefs (count, blue trend)

**Trend Indicator Variants:**
- Positive (green, up arrow)
- Negative (red, down arrow)
- Neutral (gray, right arrow)
- Blue (blue, up/down arrow)

### Interactive Prototype
**Flows to Prototype:**
1. Load dashboard → See analytics grid → Hover over card → See border highlight
2. Hover over icon → Show tooltip with calculation
3. Click refresh → Rotate icon → Update values → Show toast
4. Poll update → Numbers animate → Trend changes → Smooth transition

### Design System References
- shadcn/ui Card: https://ui.shadcn.com/docs/components/card
- shadcn/ui Button: https://ui.shadcn.com/docs/components/button
- Lucide Icons: https://lucide.dev/icons
- Framer Motion: https://www.framer.com/motion/

---

## 10. Implementation Notes for Developer

### Tech Stack
- **Framework:** React 18 + TypeScript
- **UI Library:** shadcn/ui + Tailwind CSS
- **Animation:** Framer Motion for number counters
- **Data Fetching:** TanStack Query with 5min polling
- **Backend:** Supabase

### Key Files
- Component: `src/components/dashboard/SummaryAnalytics.tsx`
- Stat Card: `src/components/dashboard/StatCard.tsx`
- Trend Indicator: `src/components/dashboard/TrendIndicator.tsx`
- Hook: `src/hooks/use-summary-analytics.ts`
- Types: `src/types/analytics.ts`

### Data Query Hook
```typescript
export const useSummaryAnalytics = () => {
  return useQuery({
    queryKey: ['summary-analytics'],
    queryFn: async () => {
      const currentUserId = (await supabase.auth.getUser()).data.user?.id;

      // Parallel queries for performance
      const [
        briefsData,
        thisWeekTasks,
        lastWeekTasks,
        taskDurations,
        activeBriefs
      ] = await Promise.all([
        // Brief Completion %
        supabase
          .from('briefs')
          .select('status', { count: 'exact' })
          .eq('user_id', currentUserId),

        // Team Velocity (This Week)
        supabase
          .from('tasks')
          .select('*', { count: 'exact', head: true })
          .eq('status', 'Accepted')
          .gte('accepted_at', getWeekStart(0))
          .in('brief_id',
            supabase.from('briefs').select('id').eq('user_id', currentUserId)
          ),

        // Team Velocity (Last Week)
        supabase
          .from('tasks')
          .select('*', { count: 'exact', head: true })
          .eq('status', 'Accepted')
          .gte('accepted_at', getWeekStart(-1))
          .lte('accepted_at', getWeekStart(0))
          .in('brief_id',
            supabase.from('briefs').select('id').eq('user_id', currentUserId)
          ),

        // Average Task Duration
        supabase
          .from('tasks')
          .select('created_at, accepted_at')
          .eq('status', 'Accepted')
          .not('accepted_at', 'is', null)
          .in('brief_id',
            supabase.from('briefs').select('id').eq('user_id', currentUserId)
          )
          .limit(100),

        // Active Briefs
        supabase
          .from('briefs')
          .select('*', { count: 'exact', head: true })
          .eq('user_id', currentUserId)
          .eq('status', 'active')
      ]);

      // Calculate metrics
      const totalBriefs = briefsData.count || 0;
      const completedBriefs = briefsData.data?.filter(
        b => b.status === 'completed'
      ).length || 0;
      const completionRate = totalBriefs > 0
        ? Math.round((completedBriefs / totalBriefs) * 100)
        : 0;

      const velocity = {
        thisWeek: thisWeekTasks.count || 0,
        lastWeek: lastWeekTasks.count || 0,
        trend: (thisWeekTasks.count || 0) - (lastWeekTasks.count || 0)
      };

      const avgDuration = taskDurations.data?.reduce((acc, task) => {
        const duration = (
          new Date(task.accepted_at).getTime() -
          new Date(task.created_at).getTime()
        ) / (1000 * 60 * 60 * 24);
        return acc + duration;
      }, 0) / (taskDurations.data?.length || 1);

      return {
        completionRate,
        velocity,
        avgDuration: Math.round(avgDuration * 10) / 10, // 1 decimal
        activeBriefs: activeBriefs.count || 0
      };
    },
    refetchInterval: 300000, // 5 minutes
    staleTime: 240000 // 4 minutes
  });
};
```

### Number Animation Component
```typescript
// Use Framer Motion for smooth number animations
import { motion, useSpring, useTransform } from 'framer-motion';

const AnimatedNumber = ({ value }: { value: number }) => {
  const spring = useSpring(value, { stiffness: 100, damping: 30 });
  const display = useTransform(spring, current => Math.round(current));

  useEffect(() => {
    spring.set(value);
  }, [value, spring]);

  return <motion.span>{display}</motion.span>;
};
```

### Performance Considerations
- Parallel queries with `Promise.all`
- 5-minute polling (less frequent than action center)
- Stale time: 4 minutes (prevent unnecessary refetches)
- Number animation: GPU-accelerated with transform
- Limit task duration query to last 100 tasks

---

## 11. v0.dev / Lovable AI Prompt

If generating this UI with AI tools, use this prompt:

```
Create a Summary Analytics dashboard widget using React, TypeScript, shadcn/ui, and Framer Motion.

LAYOUT:
- Card component with header "Summary Analytics"
- Timestamp "Last updated: X min ago" in top-right
- Refresh button (icon) next to timestamp
- 2×2 grid of stat cards (responsive: 1 column mobile, 2 columns tablet/desktop)

STAT CARDS (4 total):

1. Brief Completion %:
   - Icon: 📊 or BarChart3
   - Large value: "87%" (text-4xl, bold)
   - Label: "Brief Completion" (text-sm, muted)
   - Trend: "↑ +5% from last week" (green if positive, red if negative)

2. Team Velocity:
   - Icon: 📈 or TrendingUp
   - Large value: "12 tasks/week" (text-4xl, bold)
   - Label: "Team Velocity" (text-sm, muted)
   - Trend: "↓ -2 tasks from last week" (red if down, green if up)

3. Average Task Duration:
   - Icon: ⏱️ or Clock
   - Large value: "3.5 days" (text-4xl, bold)
   - Label: "Average Task Duration" (text-sm, muted)
   - Trend: "→ No change from last week" (gray if stable)
   - NOTE: Inverted logic - decrease is good (green), increase is bad (red)

4. Active Briefs:
   - Icon: 📁 or FolderOpen
   - Large value: "8" (text-4xl, bold)
   - Label: "Active Briefs" (text-sm, muted)
   - Trend: "↑ +2 from last week" (blue, neutral trend)

TREND INDICATORS:
- Arrow icon: ↑ (TrendingUp), ↓ (TrendingDown), → (ArrowRight)
- Color coding:
  - Green (hsl(142 70% 45%)): Positive trends
  - Red (hsl(0 70% 50%)): Negative trends
  - Gray (hsl(240 5% 46%)): Stable trends
  - Blue (hsl(210 70% 50%)): Neutral (active briefs)

BEHAVIOR:
- Fetch data from Supabase using TanStack Query
- Poll every 5 minutes for updates
- Animate number changes with Framer Motion spring animation
- Refresh button rotates 360° on click
- Show "Last updated" timestamp (format: "Xm ago" or "Xh ago")
- Tooltips on icon hover showing calculation details

CALCULATIONS:
- Brief Completion %: (Completed briefs / Total briefs) × 100
- Team Velocity: Tasks accepted this week vs last week
- Avg Task Duration: Mean time from created_at to accepted_at (last 100 tasks)
- Active Briefs: Count of briefs with status='active'

ACCESSIBILITY:
- Screen reader announces values and trends
- Refresh button has aria-label
- Keyboard navigation support
- WCAG AA color contrast
- Trend arrows supplement color (not color-only)

RESPONSIVE:
- Mobile (<768px): 1 column, smaller text (text-3xl)
- Tablet (768-1024px): 2×2 grid
- Desktop (>1024px): 2×2 grid with hover effects

TECH STACK:
- React 18 + TypeScript
- shadcn/ui: Card, CardHeader, CardTitle, CardDescription, CardContent, Button
- Framer Motion for number animations
- TanStack Query for data fetching with 5min polling
- Supabase for backend
- Tailwind CSS for styling
```

---

## 12. Testing Checklist

### Visual Testing
- [ ] All 4 stat cards display correctly
- [ ] Trend indicators show correct colors and arrows
- [ ] Number animations are smooth
- [ ] "Last updated" timestamp updates correctly
- [ ] Refresh icon rotates on click
- [ ] Hover states work on desktop

### Functional Testing
- [ ] Brief completion % calculates correctly
- [ ] Team velocity shows this week vs last week
- [ ] Average task duration displays in days
- [ ] Active briefs count is accurate
- [ ] Trend logic works (up/down/stable)
- [ ] Manual refresh triggers data refetch
- [ ] Polling updates data every 5 minutes

### Responsive Testing
- [ ] Mobile: 1 column layout
- [ ] Tablet: 2×2 grid
- [ ] Desktop: 2×2 grid with proper spacing
- [ ] Text sizes adjust for mobile

### Accessibility Testing
- [ ] Screen reader announces all metrics
- [ ] Trend directions announced correctly
- [ ] Refresh button keyboard accessible
- [ ] Tooltips accessible via keyboard
- [ ] Color contrast meets WCAG AA

---

## 13. Related Files & Dependencies

**Component Files:**
- `/src/components/dashboard/SummaryAnalytics.tsx` (to be created)
- `/src/components/dashboard/StatCard.tsx` (to be created)
- `/src/components/dashboard/TrendIndicator.tsx` (to be created)
- `/src/hooks/use-summary-analytics.ts` (to be created)

**Dependencies:**
- Epic 1: Briefs table with status field
- Epic 2: Tasks table with created_at, accepted_at timestamps
- Epic 4: Task acceptance workflow
- Epic 8: User authentication

**Database Schema:**
- `briefs` table: id, user_id, status
- `tasks` table: id, brief_id, status, created_at, accepted_at

---

**Last Updated:** 2025-10-09
**Design Status:** Ready for Development
**Priority:** Medium (Epic 9 - Story 9.2)
