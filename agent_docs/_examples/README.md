# Examples Folder

> ⚠️ **THIS FOLDER CONTAINS EXAMPLES ONLY**
> These are reference examples showing how the work management system looks when populated.
> Do NOT copy these directly - use `docs/_templates/` for creating new items.

## What's Here

| File/Folder | Shows |
|-------------|-------|
| `_index-empty.example.md` | Fresh project with no epics/tasks |
| `_index-with-data.example.md` | Project with active work |
| `EXXX-example-feature/` | Complete epic folder structure with OAuth authentication example |
| `EXXX-example-feature/EXXX-context.example.md` | Epic context with WHAT/WHY/HOW pattern |
| `EXXX-example-feature/Tasks/EXXX-TXXX-example-task/` | Task folder with detailed implementation |
| `EXXX-example-feature/Tasks/.../Subtasks/ST003-...` | Individual subtask with maximum detail |
| `EXXX-example-feature/PRs/2026-01-15-...` | PR draft example |

## How to Use This

1. **Learning the system?** → Read through these examples (see "Progressive Disclosure Walkthrough" below)
2. **Creating new epic?** → Use `/work:epic-new` command (uses `docs/_templates/`)
3. **Creating new task?** → Use `/work:task-new` command (uses `docs/_templates/`)
4. **Unsure what a file should look like?** → Check the example here (see "Template-to-Example Mapping" below)

## Template-to-Example Mapping

Match your template to the corresponding example:

| Template File | Example File | What It Shows |
|--------------|--------------|---------------|
| `epic-context.template.md` | `EXXX-context.example.md` | Epic with Rationale (WHY), Approach (HOW), strategic decisions |
| `task-context.template.md` | `Tasks/EXXX-TXXX-example-task/TXXX-context.example.md` | Task with Problem Context, detailed approach, session tracking |
| `subtask.template.md` | `Subtasks/ST003-configure-passport-strategy.example.md` | Individual subtask with code snippets, line numbers, verification |
| `subtasks-index.template.md` | `Subtasks/_subtasks-index.example.md` | Single source of truth for all subtasks |
| `draft.template.md` | `Drafts/YYYY-MM-DD-example-requirements/draft.example.md` | Requirements capture, discussion, WHY extraction |
| `pr-draft.template.md` | `PRs/2026-01-15-google-oauth-pr.example.md` | PR summary, test plan, reviewer notes |
| `archive-index.template.md` | `Archive/_archive-index.example.md` | Version history, decision log |
| `debug-session.template.md` | `Tasks/.../Debug/YYYY-MM-DD-api-timeout.example.md` | Systematic debugging pattern |

## Progressive Disclosure Walkthrough

**Goal**: Understand examples efficiently by reading in layers (Layer 1 → Layer 2 → Layer 3).

### Layer 1: Overview (Start Here)
📄 Read: `_index-with-data.example.md`

**What you'll see**:
- State Legend (emoji meanings)
- Epic/Task overview table (ID, Name, Status, Progress)
- Quick resume command
- ID counters and external ID mapping

**Time**: 2-3 minutes
**Purpose**: Get bird's-eye view of active work

---

### Layer 2: Epic Details (Dive Deeper)
📄 Read: `EXXX-example-feature/EXXX-context.example.md`

**What you'll see**:
- **Objective (WHAT)**: 1-2 sentence goal
- **Rationale (WHY)**: Problem context, approach rationale, strategic decisions
- **Approach (HOW - High Level)**: Phases, architectural decisions
- Success Criteria (outcomes, not implementation)
- Tasks Overview (table + delegation to task files)
- Key Decisions (strategic choices with rationale)
- Current Focus, Assumptions, Questions

**Time**: 5-7 minutes
**Purpose**: Understand epic strategy and business value

**Key Learning**: Epic level is STRATEGIC - delegates implementation to tasks.

---

### Layer 2: Task Details (Implementation Plan)
📄 Read: `EXXX-example-feature/Tasks/EXXX-TXXX-example-task/TXXX-context.example.md`

**What you'll see**:
- **Objective (WHAT)**: Specific deliverable
- **Rationale (WHY)**: Problem context, approach rationale, key decisions (extracted from draft discussions)
- Requirements (specific, testable checkboxes)
- Relevant Files (implementation-specific)
- **Approach (HOW - Detailed)**: Step-by-step plan (8 steps for OAuth task)
- Progress Log (session-by-session tracking)
- Assumptions (technical), Questions (implementation-specific)

**Time**: 7-10 minutes
**Purpose**: Understand detailed implementation approach

**Key Learning**: Task level is DETAILED - step-by-step approach, delegates exact code to subtasks.

---

### Layer 3: Subtask Details (Maximum Detail)
📄 Read: `EXXX-example-feature/Tasks/.../Subtasks/ST003-configure-passport-strategy.example.md`

**What you'll see**:
- **Objective (WHAT)**: Single atomic action
- **Context (WHY)**: Why this step in sequence (must precede routes or fails)
- **Implementation (HOW)**: Exact code snippets, line numbers, step-by-step
- Files to Modify (exact paths and line numbers)
- Implementation Notes (gotchas, edge cases, technical details)
- Verification (specific checkboxes)

**Time**: 10-15 minutes
**Purpose**: See maximum detail level - ready to execute

**Key Learning**: Subtask level is EXECUTABLE - code snippets, line numbers, no delegation.

---

### Supporting Files (As Needed)
📄 Read: `Subtasks/_subtasks-index.example.md`, `PRs/2026-01-15-google-oauth-pr.example.md`, `Drafts/...`, `Archive/...`

**Purpose**: See specialized workflows (subtask index, PR creation, requirements drafts, decision history)

---

## WHAT/WHY/HOW Pattern

All examples demonstrate knowledge preservation through WHAT/WHY/HOW sections:

### Epic Level (Strategic WHY)
- **WHAT**: Add OAuth authentication
- **WHY**: 40% of support tickets request it, reduces password reset burden, competitor analysis shows it's standard
- **HOW**: Phase 1 (Google) → Phase 2 (GitHub) → Phase 3 (Account Management)

### Task Level (Detailed WHY)
- **WHAT**: Implement Google OAuth provider
- **WHY**: Most requested (60%), passport.js compatibility, email-based linking for smooth UX
- **HOW**: Install deps → Configure strategy → Add routes → Implement linking → Test → Document (8 steps)

### Subtask Level (Implementation WHY)
- **WHAT**: Configure Passport GoogleStrategy
- **WHY**: Must precede routes or auth fails with "Unknown strategy" error
- **HOW**: Exact code snippets with line numbers, imports, config, error handling

**Key Insight**: WHY deepens as you go down hierarchy:
- Epic WHY = Business problem
- Task WHY = Implementation approach
- Subtask WHY = Why this step in sequence

## Naming Convention

- `EXXX` = Epic ID placeholder (real: E001, E002, etc.)
- `TXXX` = Task ID placeholder (real: T001, E001-T001, etc.)
- `ST###` = Subtask ID placeholder (real: ST001, ST002, etc.)
- `YYYY-MM-DD` = Date placeholder (real: 2026-01-15)
- `{{PLACEHOLDER}}` = Value you fill in

## Example vs Template

| Location | Purpose | When Used |
|----------|---------|-----------|
| `agent_docs/_examples/` | **Reference** - see what filled-in files look like | Learning, debugging |
| `docs/_templates/` | **Creation** - blank templates with placeholders | `/work:*` commands |

## Example Narrative

All examples use **OAuth Authentication** as a consistent story:

- **Epic (EXXX)**: Add OAuth authentication (Google + GitHub providers)
- **Task (EXXX-TXXX)**: Implement Google OAuth (first provider)
- **Subtask (ST003)**: Configure Passport GoogleStrategy (foundation step)
- **PR**: Google OAuth PR #42 (merged 2026-01-16)

This creates a coherent narrative showing progressive detail increase across hierarchy levels.
