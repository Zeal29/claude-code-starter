---
description: Show status of epic, task, or project overview
allowed-tools: [Read, Glob]
---

Show status: $ARGUMENTS

## Behavior

**No arguments**: Show project overview
**Epic ID (E###)**: Show epic status
**Task ID (E###-T### or T###)**: Show task status

## Project Overview (no args)

Read `docs/_index.md` and present:
```
## 📊 Project Status

### Active Epics
| Epic | Status | Progress | Active Task |
|------|--------|----------|-------------|
| E001 - Auth | 🟡 | 43% (3/7) | T003 |
| E002 - Dashboard | ⚪ | 0% | - |

### Standalone Tasks
| Task | Status |
|------|--------|
| T100 - Fix header | 🟡 |

### Quick Stats
- Total Epics: 2 (1 active, 1 not started)
- Total Tasks: 8 (3 done, 2 in progress, 3 not started)
- Pending Drafts: 1

### Last Activity
{{LAST_WORKED_ON}} - {{DATE}}
```

## Epic Status (E###)

Read epic context and present:
```
## 📊 Epic: E001 - User Authentication

**Status**: 🟡 In Progress
**Progress**: 43% (3/7 tasks)
**External ID**: PROJ-123

### Tasks
| ID | Name | Status | Progress |
|----|------|--------|----------|
| T001 | Login Page | 🟢 | 100% |
| T002 | Registration | 🟢 | 100% |
| T003 | Password Reset | 🟡 | 60% |
| T004 | OAuth Google | ⚪ | 0% |

### Current Focus
- **Active**: T003 - Password Reset
- **Blocker**: None
- **Next**: Email template integration

### Pending
- Drafts ready: 0
- Unanswered questions: 2
```

## Task Status (T### or E###-T###)

Read task context and present:
```
## 📊 Task: E001-T003 - Password Reset

**Status**: 🟡 In Progress
**Epic**: E001 - Auth
**External ID**: PROJ-456
**Branch**: feature/password-reset

### Requirements
- [x] Create reset token (done)
- [x] Email service (done)
- [ ] Reset page UI
- [ ] Token validation

### Subtasks
3/5 complete (60%)

### Last Session
{{DATE}} - {{SUMMARY}}

### Git
- Branch: feature/password-reset
- Commits: 5
- PR: None yet
```
