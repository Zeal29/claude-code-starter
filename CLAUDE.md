# Project: [PROJECT_NAME]

## Tech Stack
<!-- Update these based on your project -->
Frontend: Next.js 14 (App Router), TypeScript 5, TailwindCSS 3
Backend: Node.js, Express / Python FastAPI
Database: PostgreSQL / MongoDB
Testing: Vitest, Playwright

## Commands
```bash
pnpm dev          # start dev server
pnpm build        # production build
pnpm test         # run tests
pnpm typecheck    # type check
pnpm lint:fix     # auto-fix linting
```

## Key Directories
- `src/app/` - Next.js routes
- `src/components/` - React components
- `src/lib/` - utilities
- `docs/` - Work management (epics, tasks, drafts)
- `agent_docs/` - Progressive disclosure reference docs

## Critical Rules
**ALWAYS** be concise in .md files - sacrifice grammar for density, never lose info
**ALWAYS** use named exports, **NEVER** default exports
**ALWAYS** put assumptions under `## Assumptions` section
**ALWAYS** put unanswered questions under `## Unanswered Questions` section
**ALWAYS** run `/work:save` before ending session or `/clear`
**NEVER** edit context files directly - use drafts

## Reference Docs (Progressive Disclosure)
<!-- Read these ONLY when relevant to current task -->
- Work system guide → `@agent_docs/work-management-system.md`
- Work examples → `@agent_docs/_examples/`
- Architecture → `@agent_docs/architecture.md`
- Database → `@agent_docs/database-schema.md`
- API patterns → `@agent_docs/api-patterns.md`
- Auth flow → `@agent_docs/auth-flow.md`
- Components → `@agent_docs/component-guide.md`

---

## Work Management (Quick Reference)

### Hierarchy
```
Epic (E###) → Task (E###-T###) → Subtask (ST###)
```
Max 3 levels. Standalone tasks use T### (no epic prefix).

### States
| Emoji | State |
|-------|-------|
| 📝 | draft |
| ⚪ | ready |
| 🟡 | in-progress |
| 🔴 | blocked |
| 🔵 | review |
| 🟢 | done |
| ⬛ | archived |

### Essential Commands
| Command | Use |
|---------|-----|
| `/work:status` | Project overview |
| `/work:resume [ID]` | Resume work |
| `/work:save [ID]` | Save progress (**ALWAYS before /clear**) |
| `/work:epic-new "name"` | Create epic |
| `/work:task-new [E###] "name"` | Create task |
| `/work:draft-new ID "title"` | Create draft |
| `/work:draft-ready ID folder` | Mark draft ready |
| `/work:draft-process ID folder` | Execute draft |

### Core Workflow
1. `/work:epic-new "name"` or `/work:task-new "name"` - create work
2. `/work:resume ID` - start/continue work
3. Work on implementation
4. `/work:save` - save progress (**CRITICAL**)

### File Locations
```
docs/_index.md           # Layer 1: Overview (read first)
docs/epics/E###/         # Epic folders
  E###-context.md        # Layer 2: Epic details
  Tasks/E###-T###/       # Task folders
    T###-context.md      # Layer 2: Task details
docs/tasks/T###/         # Standalone tasks
docs/_templates/         # Templates for new items
```

→ **Full guide**: `@agent_docs/work-management-system.md`
→ **Examples**: `@agent_docs/_examples/`

---

## Debugging Protocol
1. Form 2-3 hypotheses
2. Add `console.log('[DEBUG_TRACE]', Date.now(), 'location', {vars})`
3. Wait for runtime output
4. Analyze and fix
5. Remove debug statements
