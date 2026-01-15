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
- `src/app/` - Next.js routes (App Router)
- `src/components/` - React components
- `src/lib/` - utilities and helpers
- `src/hooks/` - custom React hooks
- `src/api/` - API routes / backend

## Critical Rules
**ALWAYS** be concise in .md files - sacrifice grammar for density, never lose info
**ALWAYS** use named exports, **NEVER** default exports
**ALWAYS** colocate tests in `__tests__/` alongside source
**ALWAYS** put assumptions under `## Assumptions` section
**ALWAYS** put unanswered questions under `## Unanswered Questions` section
**NEVER** modify files in `docs/epics/` without explicit permission

## Reference Docs (read when relevant)
- Architecture decisions → `@agent_docs/architecture.md`
- Database schemas → `@agent_docs/database-schema.md`
- API patterns → `@agent_docs/api-patterns.md`
- Auth flow → `@agent_docs/auth-flow.md`
- Component conventions → `@agent_docs/component-guide.md`

## Task Context
- Current task context → check `docs/tasks/` for active task files
- Epic tracking → check `docs/epics/` for long-running features

## Debugging Protocol
When debugging:
1. Form 2-3 hypotheses about cause
2. Add `console.log('[DEBUG_TRACE]', Date.now(), 'location', {vars})` at strategic points
3. Wait for me to provide runtime output
4. Analyze and propose fix
5. After fix confirmed, remove debug statements
