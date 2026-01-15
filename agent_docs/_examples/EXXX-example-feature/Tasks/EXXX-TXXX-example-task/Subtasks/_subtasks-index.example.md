# Subtasks Index

<!-- 
╔═══════════════════════════════════════════════════════════════════╗
║  EXAMPLE FILE: Shows subtasks index for a task                    ║
║  Real location: .../Tasks/E001-T001-.../Subtasks/_subtasks-index  ║
║  Template: docs/_templates/subtasks-index.template.md             ║
╚═══════════════════════════════════════════════════════════════════╝

PURPOSE:
- Quick overview of all subtasks
- Parent task context shows summary table
- This index has slightly more detail
- Individual subtask files have full detail (Layer 3)
-->

## Parent Task
**Task**: EXXX-TXXX - Example Task
**Epic**: EXXX - Example Feature

## Subtasks Overview

| ID | Name | Status | Est. | Actual | Notes |
|----|------|--------|------|--------|-------|
| ST001 | Setup boilerplate | ✅ done | 30m | 25m | Clean setup |
| ST002 | Implement core logic | ✅ done | 2h | 2.5h | Took longer, edge cases |
| ST003 | Add error handling | 🔄 in-progress | 1h | — | In progress |
| ST004 | Write tests | ⬜ not started | 1h | — | — |

## Status Legend
- ✅ done
- 🔄 in-progress  
- ⬜ not started
- 🔴 blocked

## Subtask Details

### ST001 - Setup boilerplate
- Create component file structure
- Add TypeScript interfaces
- Setup basic routing
- **Files**: `src/components/Example/`

### ST002 - Implement core logic
- Fetch data from API
- Transform response
- Update state
- **Files**: `src/lib/example-logic.ts`

### ST003 - Add error handling
- Add try-catch blocks
- Show error UI
- Log errors to service
- **Files**: `src/components/Example/ErrorBoundary.tsx`

### ST004 - Write tests
- Unit tests for logic
- Component tests for UI
- Integration test for flow
- **Files**: `src/__tests__/example/`
