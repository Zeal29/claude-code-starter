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

## Reference Docs (read when relevant)
- Architecture → `@agent_docs/architecture.md`
- Database → `@agent_docs/database-schema.md`
- API patterns → `@agent_docs/api-patterns.md`
- Auth flow → `@agent_docs/auth-flow.md`
- Components → `@agent_docs/component-guide.md`

---

## Work Management System

### Hierarchy
```
Epic (E###) → Task (E###-T###) → Subtask (ST###)
```
Max 3 levels. Standalone tasks use T### (no epic prefix).

### States (Epics & Tasks)
| State | Emoji | Description |
|-------|-------|-------------|
| draft | 📝 | Created, not fully defined |
| ready | ⚪ | Defined, waiting to start |
| in-progress | 🟡 | Active work |
| blocked | 🔴 | Waiting on dependency |
| review | 🔵 | Code complete, in review |
| done | 🟢 | Completed |
| archived | ⬛ | Closed |

### Draft States
| State | Description |
|-------|-------------|
| open | Created, user adding content |
| ready | User marked ready for processing |
| processing | Claude executing |
| completed | Successfully processed |
| failed | Processing failed |

### Quick Commands
| Command | Use |
|---------|-----|
| `/work:status` | Project overview |
| `/work:resume [ID]` | Resume work |
| `/work:save [ID]` | Save progress |
| `/work:epic-new "name"` | Create epic |
| `/work:task-new [E###] "name"` | Create task |
| `/work:draft-new ID "title"` | Create draft |
| `/work:draft-ready ID folder` | Mark draft ready |
| `/work:draft-process ID folder` | Execute draft |
| `/work:subtask-add TASK "name"` | Add subtask |
| `/work:debug-start TASK "issue"` | Start debug session |
| `/work:pr-draft TASK` | Generate PR |

### Core Workflow

**Starting New Work:**
1. `/work:epic-new "feature name"` or `/work:task-new "bug fix"`
2. `/work:draft-new E001 "requirements"` - create draft
3. Fill draft.md with requirements, add supporting files
4. `/work:draft-ready E001 folder` - mark ready
5. `/work:draft-process E001 folder` - execute

**During Work:**
1. `/work:resume E001-T001` - resume task
2. Work on implementation
3. `/work:save` - save progress periodically

**Before Ending Session:**
1. `/work:save` - **ALWAYS** save before `/clear`
2. Progress is preserved in context files

**Debugging:**
1. `/work:debug-start E001-T001 "issue description"`
2. Add console.log with `[DEBUG_TRACE]` prefix
3. Run app, paste logs
4. `/work:debug-log E001-T001` - save findings

### File Structure
```
docs/
├── _index.md                    # Master index (read first)
├── _templates/                  # Templates for new items
├── epics/
│   └── E###-name/
│       ├── E###-context.md      # Epic index (progressive disclosure)
│       ├── Drafts/              # Draft folders
│       ├── Archive/             # Version history
│       ├── Research/            # Discovery docs
│       ├── Tasks/               # Child tasks
│       └── PRs/                 # Epic-level PRs
└── tasks/                       # Standalone tasks
    └── T###-name/
```

### Progressive Disclosure Rules
1. Read `docs/_index.md` first for overview
2. Read `*-context.md` files for item details
3. Read supporting files only when needed
4. Never load Archive/ unless comparing versions
5. Drafts are input; context files are output

### External IDs
Tasks can link to external systems (Jira, Linear, GitHub):
```yaml
external_id: "PROJ-123"
```
Set in context file Meta section. Configure system in `docs/_index.md`.

---

## Debugging Protocol
When debugging:
1. Form 2-3 hypotheses
2. Add `console.log('[DEBUG_TRACE]', Date.now(), 'location', {vars})`
3. Wait for runtime output
4. Analyze and fix
5. Remove debug statements
6. Log findings with `/work:debug-log`
