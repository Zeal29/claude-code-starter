# Epic: EXXX - Example Feature

<!-- 
╔═══════════════════════════════════════════════════════════════════╗
║  EXAMPLE FILE: Shows a populated epic context file                ║
║  Real location: docs/epics/E001-feature-name/E001-context.md      ║
║  Template: docs/_templates/epic-context.template.md               ║
╚═══════════════════════════════════════════════════════════════════╝

READING GUIDE:
- This file is Layer 2 (loaded when working on this epic)
- Layer 1 (_index.md) shows: "EXXX Example Feature - 50% - active TXXX"
- Layer 3 (Research/, Archive/) loaded only if explicitly needed
-->

## Meta
```yaml
id: EXXX                        # Real: E001, E002, etc.
name: Example Feature           # Descriptive name
status: in-progress             # draft|ready|in-progress|blocked|review|done|archived
created: YYYY-MM-DD             # When created
updated: YYYY-MM-DD             # Last update
owner: your-name                # Who owns this
external_id: "PROJ-123"         # Jira/Linear/GitHub issue (optional)
```

## Objective
<!-- 1-2 sentences: What does completing this epic achieve? -->
Build [feature] that allows users to [action] so that [benefit].

## Success Criteria
<!-- When are we DONE? Checkboxes Claude can mark -->
- [ ] Users can perform [action A]
- [ ] System handles [edge case B]
- [ ] Performance meets [metric C]
- [ ] Tests cover critical paths

## Tasks Overview
<!-- Quick reference table - details in Tasks/ subfolders -->
| ID | Name | Status | Progress | External ID |
|----|------|--------|----------|-------------|
| EXXX-T001 | First Task | 🟢 done | 100% | PROJ-124 |
| EXXX-T002 | Second Task | 🟡 in-progress | 60% | PROJ-125 |
| EXXX-T003 | Third Task | ⚪ ready | 0% | — |

→ Full task details: `Tasks/EXXX-TXXX-name/TXXX-context.md`

## Key Decisions
<!-- Important decisions and WHY - helps future Claude understand context -->
| Date | Decision | Rationale |
|------|----------|-----------|
| YYYY-MM-DD | Chose approach X over Y | Because [reason] |
| YYYY-MM-DD | Using library Z | Because [reason] |

→ Full decision history: `Archive/_archive-index.md`

## Dependencies
<!-- What blocks this? What does this block? -->
- **Depends on**: E002 (needs API from that epic)
- **Blocks**: T005 (waiting for this to complete)

## Git Tracking
```yaml
branch: "feature/example-feature"   # Main epic branch (if any)
related_branches:
  - "feature/example-task-1"
  - "feature/example-task-2"
```

## Current Focus
<!-- Updated by /work:save - shows where we left off -->
**Active Task**: EXXX-T002 (Second Task)
**Current State**: Implemented core logic, need error handling
**Next Step**: Add try-catch blocks and error messages
**Blocker**: None

## Quick Links
<!-- For Claude to find supporting files -->
- Research: `Research/`
- Latest Draft: `Drafts/YYYY-MM-DD-example-requirements/`
- Archive: `Archive/`

## Assumptions
<!-- Things we're assuming are true - if wrong, work may need revision -->
- Users have verified email addresses
- API rate limits are 100 req/min
- Browser support: last 2 versions

## Unanswered Questions
<!-- Open items that need answers - check these when resuming -->
- [ ] Should we support offline mode?
- [ ] What's the timeout for [operation]?
- [x] Confirmed: Using PostgreSQL (answered 2025-01-10)

## Progress Log
<!-- Session summaries - updated by /work:save -->
| Date | Task | Summary |
|------|------|---------|
| YYYY-MM-DD | Setup | Epic created, initial requirements drafted |
| YYYY-MM-DD | EXXX-T001 | Completed first task, merged PR #12 |
| YYYY-MM-DD | EXXX-T002 | Started second task, core logic done |

## Time Log
<!-- Optional: track time spent -->
| Date | Duration | Task | Notes |
|------|----------|------|-------|
| YYYY-MM-DD | 2h | EXXX-T001 | Initial implementation |
| YYYY-MM-DD | 1.5h | EXXX-T001 | Bug fixes and tests |
