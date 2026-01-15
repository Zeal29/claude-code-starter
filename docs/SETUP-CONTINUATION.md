# Claude Code Starter Template - Complete Setup Guide

## Project Location
```
D:\Work\Templates\Calude\claude-code-starter
```

---

# PART 1: THE WHAT

## What is This Project?
A **reusable starter template** for Claude Code CLI projects. Copy this folder to start any new project with:
- Optimized CLAUDE.md configuration
- Custom slash commands for common workflows
- Sub-agents for specialized tasks
- Scoped rules (load TypeScript rules only when editing .ts files)
- **Advanced work management system** for tracking epics, tasks, subtasks
- Progressive disclosure architecture to minimize token usage

## What Problem Does It Solve?

### Problem 1: Context Loss Between Sessions
Claude Code sessions are ephemeral. When you `/clear` or start new session, context is lost. Developers waste time re-explaining what they're working on.

**Solution**: Persistent context files (`*-context.md`) that capture:
- What you're building
- Progress made
- Decisions taken
- Next steps

### Problem 2: Large Tasks Don't Fit in One Session
Complex features (epics) span multiple sessions over days/weeks. Claude's context window fills up.

**Solution**: Hierarchical breakdown:
```
Epic (big feature) → Tasks (session-sized work) → Subtasks (atomic steps)
```

### Problem 3: Token Waste
Loading irrelevant info into context wastes tokens and degrades output quality.

**Solution**: Progressive disclosure — index files summarize; Claude reads details only when needed.

### Problem 4: Context Files Get Messy
If user edits context files directly, they become inconsistent, lose structure.

**Solution**: Draft-based workflow — user creates drafts, Claude processes them and updates context files properly.

## What is the Hierarchy?

```
Epic (E001)                          # Big feature, spans weeks
├── Task (E001-T001)                 # Session-sized work, spans hours/days
│   └── Subtask (ST001)              # Atomic step, < 1 hour
├── Task (E001-T002)
│   ├── Subtask (ST001)
│   └── Subtask (ST002)
└── Task (E001-T003)

Standalone Task (T001)               # Not part of epic, one-off work
```

**Max 3 levels.** If you think you need more, you're modeling wrong — create sibling tasks instead.

## What is Progressive Disclosure?

Loading strategy where you reveal info gradually:

| Layer | What Loads | When |
|-------|-----------|------|
| Layer 1 | Index file (summaries, tables) | Always — gives overview |
| Layer 2 | Context file (full details) | When working on that item |
| Layer 3 | Supporting files (research, specs) | Only if specifically needed |

**Example:**
```
docs/_index.md                    # Layer 1: "E001 - Auth, 43% done, active task T003"
  → E001-context.md               # Layer 2: Full epic details, all decisions
    → Research/oauth-comparison.md # Layer 3: Deep research on OAuth providers
```

Claude reads Layer 1 first. If working on E001, reads Layer 2. Only reads Layer 3 if task involves OAuth.

## What is a Draft?

A **draft** is a folder containing:
- `draft.md` — Instructions for Claude (what to do)
- Supporting files — Slack chats, specs, CSVs, images

**User fills draft → marks ready → Claude processes → context files updated**

User NEVER edits `*-context.md` directly. This ensures:
- Consistent structure
- Audit trail (drafts show what changed and why)
- Claude understands intent, not just raw edits

## What are the States?

### Epic/Task States
```
┌────────┐     ┌───────┐     ┌─────────────┐     ┌────────┐     ┌──────┐
│ draft  │────▶│ ready │────▶│ in-progress │────▶│ review │────▶│ done │
└────────┘     └───────┘     └─────────────┘     └────────┘     └──────┘
                                    │                               │
                                    ▼                               ▼
                              ┌─────────┐                     ┌──────────┐
                              │ blocked │                     │ archived │
                              └─────────┘                     └──────────┘
```

| State | Emoji | Meaning |
|-------|-------|---------|
| draft | 📝 | Created but requirements not complete |
| ready | ⚪ | Requirements complete, waiting to start |
| in-progress | 🟡 | Actively working on it |
| blocked | 🔴 | Waiting on something (dependency, question, etc.) |
| review | 🔵 | Code done, in PR review |
| done | 🟢 | Completed and verified |
| archived | ⬛ | Closed, moved to archive |

### Draft States
```
┌──────┐     ┌───────┐     ┌────────────┐     ┌───────────┐
│ open │────▶│ ready │────▶│ processing │────▶│ completed │
└──────┘     └───────┘     └────────────┘     └───────────┘
                                  │
                                  ▼
                            ┌────────┐
                            │ failed │────▶ (fix and retry)
                            └────────┘
```

| State | Meaning |
|-------|---------|
| open | User is adding content to draft |
| ready | User marked ready, waiting for processing |
| processing | Claude is executing the draft |
| completed | Successfully processed, context updated |
| failed | Error during processing, needs fix |

---

# PART 2: THE WHY

## Why Folder-Per-Task Instead of File-Per-Task?

**File approach problems:**
- Where do you put supporting docs (slack chats, specs)?
- Where do you put debug logs?
- Where do you put PR drafts?
- Where do you put archived versions?

**Folder approach:**
```
E001-T001-login/
├── T001-context.md      # Main context
├── Drafts/              # Input for changes
├── Archive/             # Old versions
├── Subtasks/            # Breakdown
├── Debug/               # Debug sessions
└── PRs/                 # PR drafts
```

Everything related to a task lives together. Self-contained. Portable.

## Why Drafts Instead of Direct Editing?

1. **Structure enforcement** — Claude ensures YAML frontmatter, required sections
2. **Intent clarity** — Draft says "create 3 tasks" not just "here's some text"
3. **Audit trail** — Can see what changes were requested and when
4. **Batch operations** — One draft can create multiple tasks, update docs, etc.
5. **Error handling** — If processing fails, draft remains, can retry
6. **Supporting files** — Draft folder can contain specs, images, data files

## Why 3 Levels Max?

Research finding: Deeper hierarchies create:
- Complex IDs: `E001-T001-ST001-SST001` — hard to type, hard to remember
- Navigation hell — too many folders to traverse
- Cognitive overload — where does X belong?

**If you need 4 levels, you're modeling wrong:**
```
❌ Task → Subtask → Sub-subtask → Sub-sub-subtask
✅ Task1, Task2, Task3, Task4 (siblings with dependencies)
```

## Why These Specific States?

Matches standard software development workflow:
- `draft` → Requirements gathering
- `ready` → Backlog (prioritized, waiting for sprint)
- `in-progress` → Current sprint work
- `blocked` → Impediment (tracked separately)
- `review` → PR submitted, awaiting approval
- `done` → Merged, deployed
- `archived` → Historical record

## Why Index Files Everywhere?

**Without index:**
```
Claude reads E001-context.md (500 tokens)
Claude reads E001-T001-context.md (300 tokens)
Claude reads E001-T002-context.md (300 tokens)
Claude reads E001-T003-context.md (300 tokens)
Total: 1400 tokens just to understand epic status
```

**With index:**
```
Claude reads E001-context.md which contains:
| Task | Status | Progress |
| T001 | done   | 100%     |
| T002 | done   | 100%     |
| T003 | wip    | 60%      |

Total: 500 tokens, same information
```

Index = summary table. Details = separate files loaded only if needed.

## Why Separate Internal IDs (E001-T001) and External IDs (JIRA-123)?

**Internal IDs:**
- Predictable format: E001, E002, E003
- Easy to type and reference
- Sequential, no gaps
- Work offline (no API needed)

**External IDs:**
- From Jira/Linear/GitHub
- Often non-sequential (PROJ-847, PROJ-923)
- Required for team workflows
- Linked in context file, not used as folder name

## Why Git Tracking Per Task?

Each task may be on different branch. Tracking enables:
- `/work:pr-draft` can auto-generate PR from branch diff
- Know which commits relate to which task
- Track PR status without leaving Claude
- Resume work = checkout correct branch

---

# PART 3: THE HOW

## How to Start New Work

### Creating an Epic
```bash
# In Claude Code
/work:epic-new "user authentication"

# Creates:
# docs/epics/E001-user-authentication/
# ├── E001-context.md (from template, status: draft)
# ├── Drafts/
# ├── Archive/_archive-index.md
# ├── Research/
# ├── Tasks/
# └── PRs/
```

### Adding Requirements via Draft
```bash
/work:draft-new E001 "initial requirements"

# Creates:
# docs/epics/E001-.../Drafts/2025-01-15-initial-requirements/
# └── draft.md (from template)
```

Then:
1. Edit `draft.md` — fill in Summary, Details
2. Add supporting files (slack-discussion.md, requirements.csv)
3. Check Intent boxes (what should Claude do)
4. Mark ready: `/work:draft-ready E001 2025-01-15-initial-requirements`
5. Process: `/work:draft-process E001 2025-01-15-initial-requirements`

### Creating Tasks
```bash
# Under an epic
/work:task-new E001 "login page"
# Creates: docs/epics/E001-.../Tasks/E001-T001-login-page/

# Standalone task
/work:task-new "fix header bug"
# Creates: docs/tasks/T001-fix-header-bug/
```

## How Does Draft Processing Work?

When you run `/work:draft-process E001 2025-01-15-requirements`:

1. **Claude reads `draft.md`**
   - Parses YAML meta (target, status)
   - Reads Intent checkboxes to know what actions

2. **Claude reads supporting files** (progressive disclosure)
   - Only files referenced in draft.md
   - Only sections relevant to intent

3. **Claude executes intent:**
   - If "Create new tasks" checked → creates task folders
   - If "Update context" checked → modifies E001-context.md
   - If "Add research" checked → creates file in Research/

4. **Claude updates draft.md:**
   ```yaml
   status: completed
   processed_at: 2025-01-15T14:30:00
   processed_by: claude-sonnet-4
   ```
   - Lists actions taken
   - Lists files modified
   - Notes any errors

5. **Archives if requested:**
   - Moves draft folder to Archive/drafts/

## How Do Templates Work?

Templates use `{{PLACEHOLDER}}` syntax:

```markdown
# Epic: {{EPIC_ID}} - {{EPIC_NAME}}

## Meta
id: {{EPIC_ID}}
created: {{DATE}}
```

When Claude creates from template:
- Replaces `{{EPIC_ID}}` with `E001`
- Replaces `{{EPIC_NAME}}` with user-provided name
- Replaces `{{DATE}}` with current date

Templates live in `docs/_templates/`:
- `epic-context.template.md`
- `task-context.template.md`
- `draft.template.md`
- `subtask.template.md`
- `subtasks-index.template.md`
- `archive-index.template.md`
- `debug-session.template.md`
- `pr-draft.template.md`

## How to Switch Between Tasks?

```bash
# See what's available
/work:status

# Resume specific task
/work:resume E001-T002

# Resume last worked item
/work:resume
```

Claude:
1. Reads context file
2. Reads last Progress Log entry
3. Summarizes: "You were working on X, last did Y, next step is Z"
4. Asks: "Ready to continue?"

## How to Handle Blocked Tasks?

1. Update status to `blocked` in context
2. Add to Unanswered Questions: "Waiting for API spec from backend team"
3. Switch to different task: `/work:resume E001-T003`
4. When unblocked, change status back to `in-progress`

## How to Save Progress Before Ending Session?

```bash
/work:save
# or
/work:save E001-T001  # specific task
```

Claude:
1. Updates Progress Log with session summary
2. Updates "Current State", "Next Step", "Blocker"
3. Checks off completed Requirements
4. Updates Time Log
5. Archives if significant changes

**ALWAYS run `/work:save` before `/clear`!**

## How Does Git Tracking Work?

In task context file:
```yaml
## Git Tracking
branch: "feature/login-page"
commits: ["abc123", "def456"]
pr_number: "42"
pr_url: "https://github.com/org/repo/pull/42"
```

Updated by:
- User manually
- `/work:pr-draft` command (auto-detects branch, commits)
- `/work:save` can prompt to add recent commits

## How to Archive Old Versions?

When context changes significantly:

1. Copy current `E001-context.md` to `Archive/2025-01-15-v2-context.md`
2. Update `Archive/_archive-index.md`:
```markdown
| v2 | 2025-01-15 | Added tasks T003-T005, updated timeline | 2025-01-15-v2-context.md |
```
3. Make changes to `E001-context.md`

Index shows what changed without loading full files.

---

# PART 4: CURRENT STATUS

## What's Complete ✅

### Core Structure
- Root folder with CLAUDE.md, .gitignore, .mcp.json
- `.claude/settings.json` with hooks (auto-format on save)
- `.claude/agents/` — code-reviewer, debugger, researcher
- `.claude/rules/` — general, typescript, nextjs, nodejs, python, testing
- `agent_docs/` — architecture, api-patterns, auth-flow, component-guide, database-schema

### Templates (8 files in `docs/_templates/`)
- epic-context.template.md
- task-context.template.md
- draft.template.md
- subtask.template.md
- subtasks-index.template.md
- archive-index.template.md
- debug-session.template.md
- pr-draft.template.md

### Work Commands (12 files in `.claude/commands/work/`)
| Command | Purpose |
|---------|---------|
| epic-new.md | Create epic |
| task-new.md | Create task |
| draft-new.md | Create draft |
| draft-ready.md | Mark draft ready |
| draft-process.md | Execute draft |
| resume.md | Resume work |
| save.md | Save progress |
| subtask-add.md | Add subtask |
| debug-start.md | Start debug session |
| debug-log.md | Log debug findings |
| pr-draft.md | Generate PR |
| status.md | Show status |

### Other Commands
- `.claude/commands/dev/` — debug.md, code-review.md, test.md
- `.claude/commands/git/` — commit.md, pr.md
- `.claude/commands/docs/` — update-docs.md

### Index Files
- `docs/_index.md` — Master project index

## What's Remaining ⬜

**ALL TASKS COMPLETED** ✅ (2025-01-15)

### Task 1: Update README.md ✅ DONE
Comprehensive README with all sections, ASCII diagrams, command tables.

### Task 2: Clean Up Old Files ✅ DONE
- Cleaned `docs/tasks/` (now empty with .gitkeep for standalone tasks)
- Deleted `docs/epics/_template.md`
- Confirmed `.claude/commands/task/` already removed

### Task 3: Create Example Epic ✅ DONE
Created E001-user-authentication with:
- Full E001-context.md (4 tasks, decisions, progress)
- Tasks: E001-T001-login, E001-T002-registration
- Subtasks with index and example files (ST001, ST002)
- Debug session example in T002
- Processed draft example
- Archive index with v1 entry
- Research/oauth-providers.md

### Task 4: Update .gitignore ✅ DONE
Debug log exclusions already present.

### Task 5: Final Verification ✅ DONE
All components verified present and correct.

---

# PART 5: CONTINUATION PROMPTS

## Task 1: Update README.md

```
I'm continuing work on a Claude Code starter template project.

Project location: D:\Work\Templates\Calude\claude-code-starter

First, read the complete context file:
D:\Work\Templates\Calude\claude-code-starter\docs\SETUP-CONTINUATION.md

This file contains WHAT the system is, WHY it's designed this way, and HOW it works.

Now read these implementation files:
1. D:\Work\Templates\Calude\claude-code-starter\CLAUDE.md
2. D:\Work\Templates\Calude\claude-code-starter\docs\_index.md
3. All files in D:\Work\Templates\Calude\claude-code-starter\.claude\commands\work\
4. All files in D:\Work\Templates\Calude\claude-code-starter\docs\_templates\

Write a comprehensive README.md that covers:
1. Project overview — what this is, who it's for
2. Quick start — copy, configure, use
3. Folder structure with explanations
4. Work management system (Epic → Task → Subtask)
5. State machines (both epic/task and draft states)
6. All slash commands organized by category with examples
7. The draft workflow step-by-step
8. Progressive disclosure explanation
9. Git tracking and external ID integration
10. Best practices and tips

Make it scannable with tables. Include ASCII diagrams for state machines.
```

## Task 2: Clean Up Old Files

```
I'm continuing work on a Claude Code starter template.

Project: D:\Work\Templates\Calude\claude-code-starter

Read docs\SETUP-CONTINUATION.md for context.

Delete these old files superseded by the new work management system:
1. Delete entire folder: docs\tasks\
2. Delete file: docs\epics\_template.md (if exists)
3. Delete entire folder: .claude\commands\task\

After deletion, list the folder structure to confirm cleanup.
```

## Task 3: Create Example Epic

```
I'm continuing work on a Claude Code starter template.

Project: D:\Work\Templates\Calude\claude-code-starter

Read docs\SETUP-CONTINUATION.md for full context on the system design.

Create a realistic example epic "User Authentication" to demonstrate the system:

1. Create folder: docs\epics\E001-user-authentication\

2. Create E001-context.md with:
   - Status: in-progress
   - 4 tasks: Login (done), Registration (done), Password Reset (in-progress), OAuth (ready)
   - Key decisions table with real decisions
   - Current focus on T003
   - External ID: AUTH-101

3. Create subfolders:
   - Drafts\ with one example processed draft
   - Archive\_archive-index.md with v1 entry
   - Research\ with oauth-providers.md
   - Tasks\ with E001-T001 and E001-T002 folders

4. For E001-T001-login:
   - T001-context.md (status: done)
   - Subtasks\ with _subtasks-index.md and example subtasks
   
5. For E001-T002-registration:
   - T002-context.md (status: done)
   - Debug\ with one example debug session

6. Update docs\_index.md to show E001 in Active Epics table

Make all content realistic and useful as documentation.
```

## Task 4: Update .gitignore

```
Project: D:\Work\Templates\Calude\claude-code-starter

Read and update .gitignore to add:

# Debug logs (local only, don't commit raw logs)
docs/epics/*/Debug/*/logs/
docs/epics/*/Tasks/*/Debug/*/logs/
docs/tasks/*/Debug/*/logs/
```

## Task 5: Final Verification

```
Project: D:\Work\Templates\Calude\claude-code-starter

List the complete folder structure with depth 5.

Verify these components exist:
1. CLAUDE.md — should have "Work Management System" section
2. README.md — should be comprehensive (if Task 1 done)
3. docs\_index.md — master index with ID counters
4. docs\_templates\ — 8 template files
5. .claude\commands\work\ — 12 command files
6. .claude\commands\dev\ — 3 files (debug, code-review, test)
7. .claude\commands\git\ — 2 files (commit, pr)
8. .claude\agents\ — 3 files
9. .claude\rules\ — 6 files (general, typescript, nextjs, nodejs, python, testing)
10. agent_docs\ — 5 files

Report status of each. List any missing files.
```

---

# PART 6: ORIGINAL REQUIREMENTS & RESEARCH

## User's Original Pain Points
1. "Claude keeps losing context on big features"
2. "I waste time re-explaining project structure"
3. "Debugging is slow"
4. "Tasks evolve, split, aren't clear upfront"
5. "I work on multiple tasks, need isolation"

## User's Original Ideas (Incorporated)
- Every task/epic should be a folder
- Folder naming: `[id]-[name]`
- Context file as index with progressive disclosure
- Drafts folder for input
- ArchivedContexts for version history
- subTasks folder
- PRs folder
- DevDebugLogs folder
- User never edits context directly — uses drafts

## Key Research Findings

### From Anthropic Best Practices
- CLAUDE.md under 300 lines performs better
- Use ALWAYS/NEVER for critical rules
- Explore → Plan → Code → Commit workflow
- Sub-agents preserve context

### From Community
- "Document & Clear" pattern for large tasks
- Progressive disclosure via SKILL.md pattern
- Task files with checkboxes persist across sessions
- Session.md for quick resume context

### Token Efficiency Rules
- Be concise — sacrifice grammar for information density
- Never lose information when being concise
- Index files summarize; detail files loaded on-demand
- Scoped rules only load for matching files

## Alternatives Considered & Rejected

| Approach | Why Rejected |
|----------|--------------|
| Single todo.md file | No place for supporting docs, gets messy |
| File-per-task (not folder) | Can't store related artifacts |
| Unlimited hierarchy depth | Too complex, hard to navigate |
| Direct context editing | Loses structure, no audit trail |
| Date-based IDs only | Hard to reference, not memorable |
| No external ID support | Breaks team workflows with Jira/Linear |

---

# PART 7: CONFIGURATION REFERENCE

## ID Format
```
Epic: E001, E002, E003...
Task (in epic): E001-T001, E001-T002...
Task (standalone): T001, T002...
Subtask: ST001, ST002...
```

## File Naming
```
Folder: E001-kebab-case-name
Context: E001-context.md or T001-context.md
Draft folder: YYYY-MM-DD-kebab-case-title
PR draft: YYYY-MM-DD-PR-draft.md
Debug session: YYYY-MM-DD-session-N
Archive: YYYY-MM-DD-vN-context.md
```

## Template Placeholders
```
{{EPIC_ID}}, {{EPIC_NAME}}
{{TASK_ID}}, {{TASK_NAME}}
{{DATE}}, {{DATETIME}}
{{OWNER}}
{{DRAFT_ID}}, {{DRAFT_TITLE}}
{{TARGET_ID}}
{{SUBTASK_ID}}, {{SUBTASK_NAME}}
{{SESSION_NUM}}
{{BRANCH_NAME}}
```

## External System Config (in docs/_index.md)
```yaml
system: jira  # jira | linear | github | notion | none
project_key: PROJ
```

---

**End of Setup Guide**

To continue: Start new conversation, paste the appropriate prompt from Part 5.
