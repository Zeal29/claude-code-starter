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
│       │       ├── T###-context.md     # Task context file (SSOT for subtasks table)
│       │       ├── Subtasks/
│       │       │   ├── ST001-name.md   # Optional: substantial subtasks
│       │       │   └── ST002-name.md   # Optional: if needed
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

### 3. Single Source of Truth (SSOT)

#### Epic Data
**Source**: `E###-context.md`
**Tasks Reference**: Tasks Overview table with ID/Name/Status only
**Full Task Details**: Delegated to `Tasks/E###-T###/T###-context.md`

#### Task Data
**Source**: `T###-context.md`
**Subtasks Table**: Inside `## Subtasks` section (SINGLE SOURCE OF TRUTH)
**Table Format**: `| ID | Name | Status | File |`
**File Column**: `[ST001-name.md](./Subtasks/ST001-name.md)` if file exists, `—` if inline-only

#### Subtask Data
**Primary**: Subtasks table in parent task-context.md (status, tracking)
**Optional**: Individual `ST###.md` files (for substantial subtasks only)
**File Semantics**: Link in File column = individual file exists; "—" = inline-only (no file)

#### State Machine Fix

**Old (Broken)**:
```
subtask-add →
  1. Update _subtasks-index.md
  2. Update task context Subtasks table

Out of sync issue: Table could drift from index
Example: E001-T003 has 9 subtasks in context.md, 3 in _subtasks-index.md
```

**New (Fixed)**:
```
subtask-add → 1. Update task-context.md Subtasks table ONLY

Single update point = no sync issues possible
No separate _subtasks-index.md files
```

### 3a. Status Updates (SSOT for Subtasks)

**Subtask Status SSOT**: Subtasks table in task-context.md is the SINGLE SOURCE OF TRUTH for status.

**Authority Hierarchy**:
1. **Table (Authoritative)**: Status in Subtasks table is THE current status
2. **Individual ST###.md file (Cache)**: Can have status field, but can become stale
3. **Allowed drift**: Individual file status can lag behind table by 1 session
4. **Never allowed**: Table status lagging behind individual file

**Why This Pattern**:
- Single update point: Commands only update table
- Prevents sync issues: No duplication possible
- Clear authority: Everyone knows table is truth
- Performance: Don't need to read individual files to see status

**Commands That Update Status**:
- `/work:subtask-add`: Adds new row, sets status = ⚪
- `/work:save`: Updates status based on user input
- Manual edits: Update table directly (not individual files)

**Status Values** (Subtasks table):
- `⚪` (ready) - Not yet started
- `🟡` (in-progress) - Currently being worked
- `🟢` (done) - Complete and verified
- `🔴` (blocked) - Waiting on dependency/question
- `⬛` (archived) - Closed, moved to archive

**Individual File YAML** (Optional, cache only):
- Can contain `status: in-progress` field
- Used for context when working on subtask
- Updated by `/work:save` after session
- Can be out of date (not an issue)
- **NOT** read by commands to determine truth

**Update Flow**:
```
Session starts → Read table status ✅
                ↓
           Work on subtask
                ↓
       Call /work:save → Updates table ✅
                ↓
         Optional: Update individual file ✅ (cache)
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

### Adding Subtasks (All in Task Context Table)

```bash
/work:subtask-add E001-T001 "configure passport strategy"
/work:subtask-add E001-T001 "add OAuth routes"
/work:subtask-add E001-T001 "test OAuth flow"
# All 3 added to task-context.md Subtasks table only
/work:validate E001-T001
# → ✅ Consistent (all subtasks in table)
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
| `/work:task-new` | T###-context.md, epic context, _index.md | Creates task with Rationale section, empty Subtasks table |
| `/work:subtask-add` | T###-context.md Subtasks table | Adds row to task context table (Status/File auto-set) |

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
- Subtasks table exists in task-context.md
- File column consistency: Links point to existing files, dashes have no files
- No orphaned subtask files (files without table entries)
- **Legacy format detection**: Warns if _subtasks-index.md found (old pattern)

### Report Format
- ✅ Consistent: All good
- ⚠️ Legacy format: Found old _subtasks-index.md (use --migrate flag to consolidate)
- ❌ MISMATCH: File column inconsistent with filesystem

### Example Validation
```bash
/work:validate E001-T001
# → ✅ Consistent: 5 subtasks, File column matches filesystem
```

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
- Optional: Create ST###.md file for substantial subtasks

**Include**:
- Single focused action (15min-2hr ideal)
- Exact file paths and line numbers (in ST###.md if file exists)
- Specific code changes (can include code snippets)
- Step-by-step implementation
- Technical notes, gotchas, edge cases
- Verification steps

**Inline vs. File**:
- Inline (—): Simple tasks, note in table only
- File link: Substantial tasks, create ST###.md with full details

**No delegation** - this is the deepest layer.

### Context Loading Strategy (3-Layer Pattern)

**When resuming work, Claude uses progressive disclosure to load only necessary context** (token efficiency).

**Layer 3 Load (Resuming Subtask)**:
```
WORKFLOW: /work:resume ST001

1. Load: docs/_index.md
   - Find which task ST001 belongs to (search)

2. Load: Parent task T###-context.md
   - Read full task to understand context
   - Specifically: Objective, Rationale, Approach
   - Find ST001 in Subtasks table (row 1)

3. Load: Individual ST001.md (if file exists)
   - Get detailed implementation steps
   - Specific files to modify
   - Implementation notes, gotchas

4. NOT loaded: Other subtasks (not needed for this session)
5. NOT loaded: Epic (parent context, focus on task level)

RESULT: ~2.5-3.5k tokens for full subtask context
```

**Layer 2 Load (Resuming Task)**:
```
WORKFLOW: /work:resume E001-T001

1. Load: docs/_index.md
   - Find parent epic (search)

2. Load: Parent epic E001-context.md
   - Read full epic for strategic context
   - Find T001 in Tasks Overview table

3. Load: Task E001-T001-context.md
   - Full task details: Objective, Rationale, Approach
   - Subtasks table (status overview, no individual file details)
   - Don't load individual ST###.md files (not needed for task-level work)

4. NOT loaded: Individual subtasks (unless explicitly working on specific subtask)

RESULT: ~3-4k tokens for full task context
```

**Layer 1 Load (Epic or Overview)**:
```
WORKFLOW: /work:resume E001

1. Load: docs/_index.md
   - See all epics and tasks at a glance
   - Strategic overview

2. Load: Epic E001-context.md
   - Strategic decisions, approach
   - Tasks Overview table
   - NOT: Individual task details

3. NOT loaded: Task or subtask details (too deep)

RESULT: ~1-1.5k tokens for strategic overview
```

**Token Budget** (Total across layers):
- Layer 3 (Subtask): ~2.5-3.5k tokens
- Layer 2 (Task): ~3-4k tokens
- Layer 1 (Epic): ~1-1.5k tokens
- **Total available**: ~10k tokens for deep work (subtask + task + epic)
- **Reserve for implementation**: 5-10k tokens for coding

**Optimization Rules**:
1. Load only what you need for current session
2. If getting stuck on subtask, load parent task (context)
3. If task approach unclear, load parent epic (strategy)
4. Subtask files optional - only load if table status unclear or need detailed steps
5. Never load Archive/ unless comparing versions or recovering from mistakes

**What NOT to Load** (Token Waste):
- ❌ All subtasks when working on single subtask
- ❌ All tasks when working on single task
- ❌ Epic details when working on subtask details
- ❌ Archive/ folder (historical versions, noise)
- ❌ Entire Task Overview when only working on 1 task

**Hint for Tooling**:
When `/work:resume` returns output, it should:
1. Load Layer 1 (always): docs/_index.md
2. Load Layer 2 (context): Relevant context file
3. Suggest: "Run `/work:resume ST001` to load individual subtask details" if user needs Layer 3

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

### Migration Path (For Old Tasks)
Old tasks using `_subtasks-index.md` can be migrated:
1. Copy subtask table from _subtasks-index.md to task-context.md Subtasks section
2. Delete _subtasks-index.md file
3. Update File column: link if ST###.md exists, "—" if inline-only
4. Verify with `/work:validate [TASK]`

Can use `/work:validate --migrate` for automated consolidation.
Not required - old format continues to work with warnings.

---

## Troubleshooting

### Subtask Sync Issues
**Symptom**: File column doesn't match filesystem (link points nowhere or file missing link)
**Cause**: Manual edits or incomplete subtask operations
**Fix**: Update File column to match: link if ST###.md exists, "—" if not
**Detection**: `/work:validate` reports mismatch, use `--sync` to auto-fix

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

### Subtask Granularity Guidelines

**Ideal Subtask Size**: 15 minutes to 2 hours

**How to Evaluate**:

| Aspect | Too Small | Just Right | Too Large |
|--------|-----------|-----------|-----------|
| **Duration** | < 15min | 15min-2hr | > 2hr |
| **Scope** | Trivial 1-line change | 1-3 files, atomic action | Spans multiple files, multiple concerns |
| **Verification** | Obvious (no test needed) | Clear test case | Requires integration testing |
| **Dependencies** | Depends on other subtasks | Mostly independent | Many internal dependencies |
| **Cognitive Load** | Trivial | Single focus area | Context switching required |

**Decision Tree**:

1. **Can the subtask be completed and verified in < 15 minutes?**
   - YES → Merge with adjacent subtask (too granular)
   - NO → Continue to step 2

2. **Will the subtask take > 2 hours?**
   - YES → Split into multiple subtasks (too large)
   - NO → Looks good, continue to step 3

3. **Does the subtask have a single, focused purpose?**
   - YES → Atomic ✅
   - NO → Split by concern (each subtask = one concern)

4. **Can it be tested independently?**
   - YES → Good granularity ✅
   - NO → May need to merge with dependent subtask

**Examples**:

✅ **Good Granularity (15min-2hr)**:
- "Add validation for email field in signup form" (1 file, 1 concern, 30min)
- "Write unit tests for UserService.findOrCreate()" (1 file, clear verification, 1hr)
- "Refactor error handler middleware to use custom AppError" (1 file, 1 concern, 1.5hr)

❌ **Too Small** (merge adjacent):
- "Add import statement" (should be part of larger subtask)
- "Change variable name from `x` to `xCoord`" (trivial rename, merge)
- "Update comment" (merge with code change)

❌ **Too Large** (split into multiple):
- "Implement full OAuth flow including Google, GitHub, Discord" (3 separate subtasks)
- "Refactor entire auth system" (break into: strategy config, routes, user service, tests)
- "Build search feature with filters, sorting, pagination" (3-4 subtasks)

**When to Create Individual ST###.md File**:
- **YES**: Subtask is substantial (> 30 min, complex logic, multiple files affected)
- **NO**: Subtask is simple (< 15 min, straightforward change)
- **Maybe**: Use discretion based on implementation complexity

**Inline vs. File Decision**:
```
Is subtask substantial?
├─ YES (30min+, complex logic)
│  └─ Create ST###.md file, set File column = [ST###-name.md](./Subtasks/ST###-name.md)
└─ NO (< 30min, straightforward)
   └─ Keep inline, set File column = —
```

### Detecting Broken State
```bash
/work:validate E001-T001
# → ❌ MISMATCH: File column inconsistent (3 links, 0 files)
# Action: Update File column - remove broken links or create missing files
# OR use: /work:validate E001-T001 --sync  # Auto-fix by removing broken links
```

---

**Last Updated**: 2026-01-18
**Related**: See `_examples/` folder for concrete examples of progressive disclosure
