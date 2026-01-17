# Work Management System

**Purpose**: Hierarchical work tracking with Epic → Task → Subtask structure, progressive disclosure, and knowledge preservation using WHAT/WHY/HOW pattern.

---

## Quick Reference

### The Hierarchy (Max 3 Levels)
```
Epic (E###)                    # Big feature, spans days/weeks
├── Task (E###-T###)           # Session-sized work, hours/days
│   └── Subtask (S###)         # Atomic step, < 1 hour
└── Task (E###-T###)

Standalone Task (T###)         # One-off work, not part of epic
```

### ID Format
| Type | Format | Example |
|------|--------|---------|
| Epic | `E###` | E001, E002 |
| Task (in epic) | `E###-T###` | E001-T001, E001-T002 |
| Standalone Task | `T###` | T001, T002 |
| Subtask | `S###` | S1, S2, S3 |

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

## System Overview

### File Structure

```
docs/
├── _index.md                           # Master index - all epics and standalone tasks
├── _templates/                         # Templates for context files
│   ├── epic-context.template.md
│   ├── task-context.template.md
│   └── subtask.template.md
├── epics/
│   └── E###-epic-name/
│       ├── E###-context.md             # Epic context file
│       ├── Tasks/
│       │   └── E###-T###-task-name/
│       │       ├── T###-context.md     # Task context file
│       │       ├── Subtasks/
│       │       │   └── _subtasks-index.md  # SINGLE SOURCE OF TRUTH for subtasks
│       │       ├── Drafts/
│       │       ├── Archive/
│       │       └── PRs/
│       ├── Drafts/
│       ├── Archive/
│       ├── Research/
│       └── PRs/
└── tasks/
    └── T###-task-name/                 # Standalone tasks
        ├── T###-context.md
        ├── Subtasks/
        └── ...
```

---

## Core Concepts

### 1. Progressive Disclosure (Token Efficiency)

Information loads in layers to minimize token usage:

| Layer | What | When Loaded | Purpose |
|-------|------|-------------|---------|
| **Layer 0** | `CLAUDE.md` | Always | Quick reference, commands |
| **Layer 1** | `docs/_index.md` | Work management | Overview of all epics/tasks |
| **Layer 2** | `*-context.md` | Working specific item | Full details of one epic/task |
| **Layer 3** | Supporting files | Only if needed | Research, specs, archives |

**Information density increases as you go deeper:**
- **Epic**: High-level strategy (what outcomes, why they matter, how in broad strokes)
- **Task**: Detailed requirements (what to build, why this approach, how step-by-step)
- **Subtask**: Maximum detail (what exact change, why in sequence, how line-by-line)

### 2. WHAT/WHY/HOW Pattern

All work items use knowledge preservation structure:

#### Epic Level
```markdown
## Objective (WHAT)
1-2 sentence business goal

## Rationale (WHY)
**Problem Context**: What problem we're solving, why it exists
**Approach Rationale**: Why this approach over alternatives
**Key Strategic Decisions**: Critical high-level decisions

## Approach (HOW - High Level)
Epic-level strategy, major phases, key architectural decisions
```

#### Task Level
```markdown
## Objective (WHAT)
Clear deliverable

## Rationale (WHY)
<!-- Often extracted from draft discussion -->
**Problem Context**: Specific problem this task solves
**Approach Rationale**: Why this implementation approach
**Key Decisions**: Decisions made during planning

## Approach (HOW - Detailed)
Step-by-step implementation plan
```

#### Subtask Level
```markdown
## Objective (WHAT)
One atomic action

## Context (WHY)
Why this subtask in the sequence, links to parent task

## Implementation (HOW)
**Steps**: Numbered list
**Files to Modify**: Exact paths
**Implementation Notes**: Gotchas, edge cases

Maximum detail - this is the deepest layer
```

### 3. Single Source of Truth

#### Epic Data
**Source**: `E###-context.md`
**Tasks Reference**: Tasks Overview table with ID/Name/Status only
**Full Task Details**: Delegated to `Tasks/E###-T###/T###-context.md`

#### Task Data
**Source**: `T###-context.md`
**Subtasks Reference**: `→ Subtasks: See Subtasks/_subtasks-index.md`
**NO Subtasks table in context.md** (new template removes this)

#### Subtask Data
**Source**: `Subtasks/_subtasks-index.md` (SINGLE SOURCE OF TRUTH)
**Individual Files**: Optional (for substantial subtasks)
**NOT in task context.md** (prevents duplicate storage, sync issues)

#### State Machine Fix

**Old (Broken)**:
```
subtask-add →
  1. Update _subtasks-index.md
  2. Update task context Subtasks table

If #2 fails, #1 may have succeeded = out of sync
Example: E001-T003 has 9 subtasks in context.md, 3 in _subtasks-index.md
```

**New (Fixed)**:
```
subtask-add →
  1. Update _subtasks-index.md ONLY

Single update point = no sync issues possible
Task context just references: "→ Subtasks: See Subtasks/_subtasks-index.md"
```

### 4. Draft Workflow (Never Edit Context Directly)

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

**Context Files Are Output (Not Input)**:
```
┌─────────────────┐         ┌──────────────────┐
│  Drafts/        │ ──────► │  *-context.md    │
│  (User Input)   │ Claude  │  (System Output) │
│                 │ Process │                  │
└─────────────────┘         └──────────────────┘
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
# WHY extracted and added to E001-context.md Rationale
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

### Creating Task from Draft

```bash
/work:task-new E001 "implement google oauth"
/work:draft-new E001-T001 "implementation plan"
# Discuss approach, decisions, trade-offs
/work:draft-ready E001-T001 2026-01-18-plan
/work:draft-process E001-T001 2026-01-18-plan
# Rationale extracted from draft discussion
```

### Adding Subtasks (No Duplication)

```bash
/work:subtask-add E001-T001 "configure passport strategy"
/work:subtask-add E001-T001 "add OAuth routes"
/work:subtask-add E001-T001 "test OAuth flow"
# All 3 only in _subtasks-index.md, NOT in task context
/work:validate E001-T001
# → ✅ Consistent (new format)
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
8. **Extract WHY** - generates Rationale section from discussion

---

## Commands Reference

### Creation Commands

| Command | Updates | Description |
|---------|---------|-------------|
| `/work:epic-new` | E###-context.md, _index.md | Creates epic with WHAT/WHY/HOW template |
| `/work:task-new` | T###-context.md, _subtasks-index.md, epic context, _index.md | Creates task with Rationale section, reference line (no Subtasks table) |
| `/work:subtask-add` | _subtasks-index.md ONLY | Adds subtask to index (does NOT update task context) |

### Update Commands

| Command | Updates | Description |
|---------|---------|-------------|
| `/work:save` | Context Progress Log, Meta, Git Tracking | Saves session progress, does NOT touch subtasks |
| `/work:resume` | _index.md "last worked on" | Loads context progressively, shows next step |
| `/work:draft-new` | Creates draft folder | Captures requirements/discussion |
| `/work:draft-ready` | Marks draft ready | Signals completion |
| `/work:draft-process` | Context Rationale section, other fields | Extracts WHY from draft, shows for approval, inserts into context |

### Validation Commands

| Command | Purpose | Output |
|---------|---------|--------|
| `/work:validate` | Detects state machine inconsistencies | Reports mismatches (e.g. E001-T003: 9 vs 3 subtasks) |
| `/work:status` | Shows current state | Epic/task overview with progress |

---

## Template Formats

### Epic Context Template (~85 lines)
- Meta (YAML)
- Objective (WHAT)
- **Rationale (WHY)** - NEW
- **Approach (HOW - High Level)** - NEW
- Success Criteria
- Tasks Overview (table + reference)
- Key Decisions
- Dependencies
- Git Tracking
- Current Focus
- Quick Links
- Assumptions
- Unanswered Questions
- Time Log
- **Progressive Disclosure Guide** - NEW

### Task Context Template (~90 lines)
- Meta (YAML)
- Objective (WHAT)
- **Rationale (WHY)** - NEW
- Requirements
- Relevant Files
- **→ Subtasks reference** (NOT table) - CHANGED
- Approach (HOW - Detailed)
- Definition of Done
- Dependencies
- Git Tracking
- Progress Log
- Assumptions
- Unanswered Questions
- Time Log
- **Progressive Disclosure Guide** - NEW

### Subtask Template (~55 lines, expanded from 23)
- Meta (YAML) - added `updated` field
- Objective (WHAT)
- **Context (WHY)** - NEW
- **Implementation (HOW)** - EXPANDED
  - Steps
  - Files to Modify
  - Implementation Notes
- Verification
- **Progress Log** - NEW
- **Progressive Disclosure Guide** - NEW

---

## Context File Anatomy

### Epic Context File Sections

| Section | Purpose | Updated By |
|---------|---------|------------|
| **Meta** | ID, status, dates, owner | Claude on state changes |
| **Objective** | 1-2 sentence goal | Draft processing |
| **Rationale** | WHY (problem, approach, decisions) | Draft processing |
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
| **Rationale** | WHY (problem, approach, decisions) | Draft processing |
| **Requirements** | Checkboxes for what to build | Draft processing |
| **Relevant Files** | Code files Claude should read | During work |
| **Subtasks** | Reference to _subtasks-index.md | Template default |
| **Approach** | How to solve | Draft or during work |
| **Definition of Done** | Completion checklist | Template default |
| **Git Tracking** | Branch, commits, PR | During work |
| **Progress Log** | Session-by-session notes | `/work:save` |
| **Assumptions** | Things assumed true | During work |
| **Unanswered Questions** | Open items | During work |

---

## Draft System Integration

### Purpose
Capture lengthy discussions and requirements before creating/updating work items.

### Workflow Benefits
- **Information preservation**: Discussion context not lost
- **Knowledge transfer**: Next session sees WHY from draft
- **Progressive disclosure**: Draft Details → Context Rationale (condensed)

### WHY Extraction (NEW)
Draft processing now:
- Reads Summary and Details
- Extracts problem statements, decisions, discussion
- Generates Rationale (WHY) section
- Shows to user for approval
- Inserts into context file with archive reference

---

## Validation Strategy

### Purpose
Detect state machine inconsistencies (like E001-T003 with 9 vs 3 subtasks).

### What /work:validate Checks

**Epic Level**:
- Tasks in context Tasks Overview match Tasks/ folder contents
- No orphaned task folders
- No missing task folders

**Task Level**:
- Subtasks in _subtasks-index.md have corresponding files (if individual)
- No orphaned subtask files
- **Legacy format detection**: Warns if task context has Subtasks table
- **Mismatch detection**: Compares old Subtasks table vs _subtasks-index.md if both exist

### Report Format
- ✅ Consistent: All good
- ⚠️ Legacy format: Using old template (optional migration)
- ❌ MISMATCH: Out of sync (broken state machine)

### Proof of Detection
E001-T003 example:
- Context.md Subtasks table: S1-S9 (9 subtasks)
- _subtasks-index.md: S1-S3 (3 subtasks)
- `/work:validate E001-T003` → reports "MISMATCH"

---

## Best Practices

### Progressive Disclosure Guidelines

**Ask: "Does this detail belong at this level or lower?"**

#### Epic Level
- Focus on business value and strategic decisions
- Keep Success Criteria outcome-focused (not implementation)
- Use Key Decisions table for major architectural choices
- Delegate implementation to tasks

**Include**:
- Business objectives
- Success criteria
- Key decisions (with rationale)
- High-level approach
- Dependencies and blockers

**Exclude** (delegate to tasks):
- Specific implementation requirements
- File modifications
- Detailed step-by-step approaches
- Session progress tracking

#### Task Level
- Capture WHY from draft discussions (problem context, rationale)
- Break down approach into clear steps
- List files to modify (not exact changes)
- Use subtasks for atomic work units
- Track progress session-by-session

**Include**:
- Specific deliverable
- Detailed requirements checklist
- Problem context from draft discussions
- Step-by-step approach
- Files to modify (list, not exact changes)
- Session-by-session progress
- Assumptions and open questions

**Exclude** (delegate to subtasks):
- Atomic work units
- Exact line-by-line code changes
- Deep debugging details

#### Subtask Level
- Maximum detail - don't hold back
- Include code snippets if helpful
- Document gotchas and edge cases
- Specific verification steps
- Keep atomic (single focused action)

**Include**:
- Single focused action
- Exact file paths and line numbers
- Specific code changes (can include code snippets)
- Step-by-step implementation
- Technical notes, gotchas, edge cases
- Verification steps

**No delegation** - this is the deepest layer.

### Knowledge Preservation
- Use drafts for lengthy discussions
- Process drafts to extract Rationale
- Include archive references in context
- Document decisions with rationale
- Keep assumptions and questions visible

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

## Backward Compatibility

### Old Work Items
- Continue to function without migration
- Commands handle missing sections gracefully
- `/work:validate` reports "legacy format" warning (not error)

### Command Handling
- `subtask-add`: Checks for Subtasks table
  - If exists: Updates both (backward compatible)
  - If not: Updates only _subtasks-index.md
- `resume`: Reads sections if they exist, skips if missing
- `save`: Works on both old and new format
- `validate`: Detects format version, reports appropriately

### Migration (Optional)
User can manually:
1. Add Rationale (WHY) sections to context files
2. Remove Subtasks table from task context
3. Verify subtasks in _subtasks-index.md
4. Add Progressive Disclosure Guide

Not required for functionality - old format remains supported.

---

## Troubleshooting

### Subtask Sync Issues
**Symptom**: Task context Subtasks table doesn't match _subtasks-index.md
**Cause**: Old template had duplicate storage
**Fix**: Migrate to new template (remove Subtasks table, add reference line)
**Detection**: `/work:validate` reports mismatch

### Information Loss
**Symptom**: Can't remember why we made a decision
**Cause**: Draft discussion not captured in context
**Fix**: Use `/work:draft-process` to extract WHY into Rationale
**Prevention**: Always process drafts with "Update context" checked

### Context Bloat
**Symptom**: Context file too long, hard to scan
**Cause**: Too much detail at wrong level
**Fix**: Move detail down to subtasks, keep task/epic high-level
**Guide**: Use Progressive Disclosure Guide in templates

### Detecting Broken State
```bash
/work:validate E001-T003
# → ❌ MISMATCH: 9 subtasks in context.md, 3 in index
# Action: Migrate to new template format
```

---

**Last Updated**: 2026-01-18
**Related**: See `_examples/` folder for concrete examples of progressive disclosure
