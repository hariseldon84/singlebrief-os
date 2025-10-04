# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Core Development
```bash
# Install dependencies
npm i

# Start development server (runs on port 8080)
npm run dev

# Build for production
npm run build

# Build for development mode
npm run build:dev

# Preview production build
npm run preview

# Run ESLint
npm run lint
```

### BMAD-Method Integration
This project uses BMAD-Method for agent-based development workflows. See `AGENTS.md` for full agent definitions.

```bash
# List available agents
npm run bmad:list

# Refresh BMAD core and regenerate AGENTS.md
npm run bmad:refresh

# Validate BMAD configuration
npm run bmad:validate
```

## Architecture Overview

### Technology Stack
- **Build Tool**: Vite with React SWC plugin
- **Framework**: React 18 with TypeScript
- **Routing**: React Router v6
- **UI Library**: shadcn/ui (Radix UI primitives + Tailwind CSS)
- **State Management**: TanStack Query (React Query)
- **Backend**: Supabase (authentication, database, storage)
- **Styling**: Tailwind CSS with custom configuration

### Project Structure

**Core Application Files**:
- `src/main.tsx` - Application entry point
- `src/App.tsx` - Root component with routing setup, QueryClient provider, and toast notifications
- `src/index.css` - Global styles and Tailwind directives

**Key Directories**:
- `src/components/ui/` - shadcn/ui components (auto-generated, avoid manual edits)
- `src/pages/` - Page components mapped to routes:
  - `Index.tsx` - Landing page (/)
  - `Auth.tsx` - Authentication page (/auth)
  - `Dashboard.tsx` - Dashboard (/dashboard)
  - `Project.tsx` - Project detail page (/project/:id)
  - `NotFound.tsx` - 404 catch-all route
- `src/integrations/supabase/` - Supabase client and auto-generated types
- `src/hooks/` - Custom React hooks
- `src/lib/` - Utility functions (includes `cn()` for className merging)

**Configuration**:
- `vite.config.ts` - Vite configuration with path alias (`@` → `./src`)
- `tailwind.config.ts` - Tailwind CSS configuration
- `components.json` - shadcn/ui configuration
- `.bmad-core/` - BMAD-Method agent definitions and workflows

### Supabase Integration

**Database Schema** (see `src/integrations/supabase/types.ts`):
- `profiles` - User profiles with email, name, department, phone
- `projects` - Project entities with title, description, status, owner
- `briefs` - Briefs associated with projects, with content and status
- `project_members` - Many-to-many relationship for project membership

**Client Setup**:
```typescript
import { supabase } from "@/integrations/supabase/client";
```

**Environment Variables** (required in `.env`):
- `VITE_SUPABASE_URL` - Supabase project URL
- `VITE_SUPABASE_PUBLISHABLE_KEY` - Supabase anon/public key
- `VITE_SUPABASE_PROJECT_ID` - Supabase project ID

**Migrations**: Located in `supabase/migrations/` with timestamped SQL files

### Routing Architecture

Routes are defined in `src/App.tsx` using React Router v6:
- Catch-all route (`path="*"`) must remain last
- Add new routes ABOVE the NotFound catch-all route
- Use `<Route path="/new-path" element={<Component />} />` pattern

### TypeScript Configuration

The project uses relaxed TypeScript settings (see `tsconfig.json`):
- `noImplicitAny: false` - Implicit any types allowed
- `noUnusedParameters: false` - Unused parameters allowed
- `strictNullChecks: false` - Null checks disabled
- Path alias: `@/*` maps to `./src/*`

### Styling Conventions

- Use `cn()` utility from `@/lib/utils` for conditional className merging
- Tailwind CSS with custom theme configuration
- shadcn/ui components provide consistent design system
- Component-level CSS in `App.css`

### Development Notes

1. **Adding New Routes**: Always add custom routes ABOVE the `path="*"` catch-all route in `App.tsx`

2. **Supabase Types**: The `src/integrations/supabase/types.ts` file is auto-generated. Update via migrations, not manual edits.

3. **UI Components**: Components in `src/components/ui/` are from shadcn/ui. Customize by wrapping or extending, not modifying directly.

4. **Path Aliases**: Use `@/` prefix for imports (e.g., `@/components/ui/button`)

5. **Agent Workflows**: This project uses BMAD-Method agents. Reference agents naturally (e.g., "As dev, implement...") or run agent commands with `*` prefix (e.g., `*help`)

6. **Lovable Integration**: This project is designed for use with Lovable (lovable.dev) - a development platform that commits changes automatically

7. **Development Server**: Runs on port 8080 with IPv6 support (host: "::")
