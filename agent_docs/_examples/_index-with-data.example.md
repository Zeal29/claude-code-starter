# Project Work Index

<!-- 
╔═══════════════════════════════════════════════════════════════════╗
║  EXAMPLE FILE: Shows _index.md WITH active epics and tasks        ║
║  Location in real project: docs/_index.md                         ║
║  This demonstrates how the index looks during active development  ║
╚═══════════════════════════════════════════════════════════════════╝
-->

## Active Epics
| ID | Name | Status | Progress | Active Task | External ID |
|----|------|--------|----------|-------------|-------------|
| E001 | User Authentication | 🟡 in-progress | 65% | E001-T003 | AUTH-101 |
| E002 | Dashboard Redesign | 📝 draft | 0% | — | DASH-200 |

## Active Standalone Tasks
| ID | Name | Status | External ID |
|----|------|--------|-------------|
| T001 | Fix header responsive bug | 🟡 in-progress | BUG-42 |
| T002 | Update dependencies | ⚪ ready | — |

## Quick Resume
**Last worked on**: E001-T003 (Password Reset)
**Command**: `/work:resume E001-T003`

## ID Counters
```yaml
next_epic: E003
next_standalone_task: T003
```

## State Legend
| Emoji | State | Description |
|-------|-------|-------------|
| 📝 | draft | Created, not fully defined |
| ⚪ | ready | Defined, waiting to start |
| 🟡 | in-progress | Active work |
| 🔴 | blocked | Waiting on dependency |
| 🔵 | review | Code complete, in review |
| 🟢 | done | Completed |
| ⬛ | archived | Closed and archived |

## External ID System
```yaml
system: jira  # Options: jira, linear, github, notion, none
project_key: PROJ  # Your project prefix
```

## Progressive Disclosure Note
<!--
Layer 1 Info Shown Above:
- E001 Auth epic: 65% done, working on T003
- E002 Dashboard: just created (draft)
- T001 Bug fix: in progress
- T002 Dependencies: ready to start

To get details, Claude reads:
- docs/epics/E001-user-authentication/E001-context.md (Layer 2)
- docs/tasks/T001-fix-header-responsive-bug/T001-context.md (Layer 2)

Layer 3 (only if needed):
- Research/, Archive/, supporting files
-->
