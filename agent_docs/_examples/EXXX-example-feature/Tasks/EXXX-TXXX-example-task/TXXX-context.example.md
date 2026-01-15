# Task: EXXX-TXXX - Example Task

<!-- 
╔═══════════════════════════════════════════════════════════════════╗
║  EXAMPLE FILE: Shows a populated task context file                ║
║  Real location: docs/epics/E001-.../Tasks/E001-T001-.../          ║
║  Template: docs/_templates/task-context.template.md               ║
╚═══════════════════════════════════════════════════════════════════╝

READING GUIDE:
- Parent epic: EXXX-context.example.md (Layer 2)
- This task: Layer 2 detail
- Subtasks, Debug logs: Layer 3 (only if needed)
-->

## Meta
```yaml
id: EXXX-TXXX                   # Real: E001-T001, E001-T002, etc.
name: Example Task              # Descriptive name
epic: EXXX                      # Parent epic (empty if standalone)
status: in-progress             # draft|ready|in-progress|blocked|review|done|archived
created: YYYY-MM-DD
updated: YYYY-MM-DD
owner: your-name
external_id: "PROJ-124"         # Optional external tracker ID
```

## Objective
<!-- Clear 1-2 sentence goal - what does "done" look like? -->
Implement [specific thing] that [does what] for [whom].

## Requirements
<!-- Checkboxes Claude can mark during /work:save -->
- [x] Requirement 1 (completed)
- [x] Requirement 2 (completed)
- [ ] Requirement 3 (in progress)
- [ ] Requirement 4 (not started)

## Relevant Files
<!-- Files Claude should read for context on this task -->
- `src/components/Example.tsx` - main component we're modifying
- `src/lib/api.ts` - API utilities we'll use
- `src/types/example.ts` - TypeScript types

## Subtasks
<!-- Breakdown for complex tasks - details in Subtasks/ folder -->
| ID | Name | Status |
|----|------|--------|
| ST001 | Setup boilerplate | ✅ done |
| ST002 | Implement core logic | ✅ done |
| ST003 | Add error handling | 🔄 in-progress |
| ST004 | Write tests | ⬜ not started |

→ Details: `Subtasks/_subtasks-index.md`

## Approach
<!-- How we're solving this - helps future Claude understand decisions -->
1. Start with [approach A]
2. Handle edge case by [approach B]
3. Test using [method C]

## Definition of Done
<!-- Standard checklist - customize per project -->
- [ ] All requirements checked off
- [ ] Tests pass (`pnpm test`)
- [ ] No TypeScript errors (`pnpm typecheck`)
- [ ] Code reviewed (PR approved)
- [ ] Docs updated (if needed)

## Dependencies
- **Blocked by**: None
- **Blocks**: EXXX-T003 (needs this API endpoint)

## Git Tracking
```yaml
branch: "feature/example-task"
commits:
  - "abc1234"  # Initial implementation
  - "def5678"  # Bug fix
pr_number: "42"
pr_url: "https://github.com/org/repo/pull/42"
```

## Progress Log
<!-- Updated by /work:save after each session -->

### Session YYYY-MM-DD (latest)
- Implemented core logic for [feature]
- Fixed edge case with [issue]
- **Current State**: Error handling partial, need try-catch
- **Next Step**: Add error boundaries, then write tests
- **Blocker**: None

### Session YYYY-MM-DD
- Task created from draft
- Set up boilerplate files
- **Current State**: Boilerplate ready
- **Next Step**: Implement core logic
- **Blocker**: None

## Assumptions
- Input data is always valid JSON
- User is authenticated (checked by middleware)
- Max payload size: 1MB

## Unanswered Questions
- [ ] Should we cache this response?
- [x] Confirmed: 30 second timeout (answered YYYY-MM-DD)

## Time Log
| Date | Duration | Notes |
|------|----------|-------|
| YYYY-MM-DD | 1h | Setup and boilerplate |
| YYYY-MM-DD | 2h | Core implementation |
| YYYY-MM-DD | 30m | Bug fixes |
