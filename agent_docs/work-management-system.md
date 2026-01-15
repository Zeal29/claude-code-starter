# Work Management System Guide

> **Progressive Disclosure**: This is the main reference for epic/task management.
> - Start here for overview and quick reference
> - Deep dive docs: `_examples/` folder for concrete examples
> - Templates: `docs/_templates/` for creating new items

---

## Quick Reference

### The Hierarchy (Max 3 Levels)
```
Epic (EXXX)                    # Big feature, spans days/weeks
├── Task (EXXX-TXXX)           # Session-sized work, hours/days
│   └── Subtask (STXXX)        # Atomic step, < 1 hour
└── Task (EXXX-TXXX)

Standalone Task (TXXX)         # One-off work, not part of epic
```

### ID Format
| Type | Format | Example |
|------|--------|---------|
| Epic | `EXXX` | E001, E002 |
| Task (in epic) | `EXXX-TXXX` | E001-T001, E001-T002 |
| Standalone Task | `TXXX` | T001, T002 |
| Subtask | `STXXX` | ST001, ST002 |

### States
| Emoji | State | Meaning |
|-------|-------|---------|
| 📝 | draft | Created, requirements incomplete |
| ⚪ | ready | Requirements complete, waiting to start |
| 🟡 | in-progress | Actively being worked |
| 🔴 | blocked | Waiting on dependency/question |
| 🔵 | review | Code complete, in PR review |
| 🟢 | done | Completed and verified |
| ⬛ | archived | Closed, moved to archive |

---

## Core Concepts

### 1. Progressive Disclosure (Token Efficiency)

Information loads in layers to minimize token usage:

| Layer | What | When Loaded | Purpose |
|-------|------|-------------|---------|
| **Layer 0** | `CLAUDE.md` | Always | Quick reference, commands |
| **Layer 1** | `docs/_index.md` | When doing work management | Overview of all epics/tasks |
| **Layer 2** | `*-context.md` | When working specific item | Full details of one epic/task |
| **Layer 3** | Supporting files | Only if explicitly needed | Research, specs, archives |

**Example Flow:**
```
CLAUDE.md says "read docs/_index.md for work overview"
    ↓
_index.md shows "E001 Auth - 65% done, active T003"
    ↓
You say "resume E001-T003"
    ↓
Claude reads E001-T003/T003-context.md (Layer 2)
    ↓
Only if task mentions OAuth research:
    Claude reads Research/oauth-providers.md (Layer 3)
```

### 2. Draft Workflow (Never Edit Context Directly)

**Why drafts exist:**
- Structure enforcement (Claude validates YAML, sections)
- Intent clarity (draft says "create 3 tasks" not raw text)
- Audit trail (see what changes were requested)
- Supporting files (draft folder holds specs, images, data)
- Error recovery (if processing fails, draft remains)

**Draft States:**
```
open → ready → processing → completed
                   ↓
                failed → (fix and retry)
```

| State | Who Acts | What Happens |
|-------|----------|--------------|
| open | User | Adding content to draft.md |
| ready | User marks | Signals draft is complete |
| processing | Claude | Reading and executing |
| completed | — | Context files updated |
| failed | User fixes | Then retry processing |

### 3. Context Files Are Output (Not Input)

```
┌─────────────────┐         ┌──────────────────┐
│  Drafts/        │ ──────► │  *-context.md    │
│  (User Input)   │ Claude  │  (System Output) │
│                 │ Process │                  │
└─────────────────┘         └──────────────────┘
```

- **User writes**: Drafts, supporting files
- **Claude writes**: Context files, index updates
- **Never**: User editing context files directly

---

## Folder Structure

### Epic Folder Structure
```
docs/epics/EXXX-epic-name/
├── EXXX-context.md           # Epic details (Layer 2)
├── Drafts/                   # User input folders
│   └── YYYY-MM-DD-title/
│       ├── draft.md          # Instructions for Claude
│       └── [supporting files]
├── Archive/                  # Version history
│   ├── _archive-index.md     # What changed when
│   └── YYYY-MM-DD-vX-context.md
├── Research/                 # Discovery documents
├── Tasks/                    # Child task folders
│   └── EXXX-TXXX-name/
│       ├── TXXX-context.md
│       ├── Subtasks/
│       └── Debug/
└── PRs/                      # Epic-level PRs
```

### Task Folder Structure
```
docs/epics/EXXX-name/Tasks/EXXX-TXXX-name/
├── TXXX-context.md           # Task details
├── Subtasks/                 # If task has subtasks
│   ├── _subtasks-index.md
│   └── STXXX-name.md
└── Debug/                    # Debug session logs
    └── YYYY-MM-DD-issue.md
```

### Standalone Task Folder
```
docs/tasks/TXXX-name/
├── TXXX-context.md
├── Subtasks/
└── Debug/
```

---

## Workflows

### Creating New Epic

```bash
# 1. Create epic structure
/work:epic-new "feature name"
# Creates: docs/epics/E001-feature-name/ with all subfolders

# 2. Add requirements via draft
/work:draft-new E001 "initial requirements"
# Creates: Drafts/YYYY-MM-DD-initial-requirements/draft.md

# 3. Edit draft.md with your requirements
# Add supporting files if needed

# 4. Mark ready and process
/work:draft-ready E001 YYYY-MM-DD-initial-requirements
/work:draft-process E001 YYYY-MM-DD-initial-requirements
```

### Creating Tasks

```bash
# Task within epic
/work:task-new E001 "login page"
# Creates: docs/epics/E001-.../Tasks/E001-T001-login-page/

# Standalone task (no epic)
/work:task-new "fix header bug"
# Creates: docs/tasks/T001-fix-header-bug/
```

### Resuming Work

```bash
# Resume last worked item
/work:resume

# Resume specific item
/work:resume E001-T002

# Claude will:
# 1. Read _index.md (Layer 1)
# 2. Read relevant context file (Layer 2)
# 3. Summarize: where you left off, next step, blockers
# 4. Ask if ready to continue
```

### Saving Progress (CRITICAL)

```bash
# Before /clear or ending session
/work:save
# or
/work:save E001-T001

# Claude updates:
# - Progress Log with session summary
# - Current State, Next Step, Blocker fields
# - Checks off completed requirements
# - Archives if significant changes
```

**⚠️ ALWAYS `/work:save` before `/clear`**

### Processing Drafts

When Claude processes a draft:

1. **Read** draft.md for instructions
2. **Read** any supporting files referenced
3. **Execute** the intent (create tasks, update requirements, etc.)
4. **Update** relevant context files
5. **Update** `docs/_index.md` with new items
6. **Mark** draft as completed
7. **Archive** previous context version if significant change

---

## Context File Anatomy

### Epic Context File Sections

| Section | Purpose | Updated By |
|---------|---------|------------|
| **Meta** | ID, status, dates, owner | Claude on state changes |
| **Objective** | 1-2 sentence goal | Draft processing |
| **Success Criteria** | Checkboxes for completion | Draft + manual check |
| **Tasks Overview** | Table of child tasks | Auto on task create |
| **Key Decisions** | Decision log with rationale | Draft processing |
| **Dependencies** | What blocks/is blocked by | Draft processing |
| **Current Focus** | Active task, state, next step | `/work:save` |
| **Assumptions** | Things assumed true | Draft processing |
| **Unanswered Questions** | Open questions | Draft + during work |
| **Time Log** | Session tracking | `/work:save` |

### Task Context File Sections

| Section | Purpose | Updated By |
|---------|---------|------------|
| **Meta** | ID, status, epic ref, dates | Claude on state changes |
| **Objective** | Clear 1-2 sentence goal | Draft processing |
| **Requirements** | Checkboxes for what to build | Draft processing |
| **Relevant Files** | Code files Claude should read | During work |
| **Subtasks** | Breakdown table | `/work:subtask-add` |
| **Approach** | How to solve | Draft or during work |
| **Definition of Done** | Completion checklist | Template default |
| **Git Tracking** | Branch, commits, PR | During work |
| **Progress Log** | Session-by-session notes | `/work:save` |
| **Assumptions** | Things assumed true | During work |
| **Unanswered Questions** | Open items | During work |

---

## Best Practices

### Do ✅
- Always `/work:save` before `/clear`
- Use drafts for any context changes
- Keep epic scope to 1-2 weeks max
- Break tasks into subtasks if > 4 hours
- Update "Unanswered Questions" when stuck
- Reference files with relative paths

### Don't ❌
- Edit `*-context.md` files directly
- Create more than 3 hierarchy levels
- Let epics grow beyond 2 weeks
- Skip the save step
- Load Archive/ unless comparing versions

---

## Deep Dive References

| Topic | Location |
|-------|----------|
| **Concrete examples** | `agent_docs/_examples/` |
| **Empty templates** | `docs/_templates/` |
| **Command reference** | `CLAUDE.md` or README.md |
| **Full README** | `README.md` |
