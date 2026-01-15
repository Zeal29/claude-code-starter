# Claude Code Starter Template

A **reusable starter template** for Claude Code CLI projects with an advanced work management system. Copy this folder to start any new project with optimized configuration, custom slash commands, sub-agents, and persistent context tracking.

## Who Is This For?

Developers who:
- Work on features spanning multiple Claude sessions
- Want to preserve context between `/clear` commands
- Need to track progress on complex, multi-task epics
- Want to eliminate the "where was I?" problem

## The Problem This Solves

| Problem | Solution |
|---------|----------|
| Context lost between sessions | Persistent `*-context.md` files track progress, decisions, next steps |
| Large tasks don't fit one session | Hierarchical breakdown: Epic → Task → Subtask |
| Token waste from loading irrelevant info | Progressive disclosure — index files summarize, details loaded on-demand |
| Context files get messy with manual edits | Draft-based workflow — user creates drafts, Claude processes and updates |

---

## Quick Start

```bash
# 1. Copy this template
cp -r claude-code-starter my-new-project

# 2. Update configuration
# Edit CLAUDE.md with your tech stack
# Edit docs/_index.md external system config (jira/linear/etc)

# 3. Start Claude Code
cd my-new-project
claude

# 4. Create your first epic
/work:epic-new "user authentication"
```

---

## Folder Structure

```
project-root/
├── CLAUDE.md                      # Project memory (always loaded, <300 lines)
├── CLAUDE.local.md                # Personal overrides (gitignored)
├── .mcp.json                      # MCP server configs
├── .gitignore
│
├── .claude/
│   ├── settings.json              # Team settings (hooks, permissions)
│   ├── settings.local.json        # Personal settings (gitignored)
│   ├── commands/                  # Custom slash commands
│   │   ├── work/                  # /work:* — Work management (12 commands)
│   │   ├── dev/                   # /dev:* — Development tools
│   │   ├── git/                   # /git:* — Git workflows
│   │   └── docs/                  # /docs:* — Documentation
│   ├── agents/                    # Sub-agent definitions
│   │   ├── code-reviewer.md
│   │   ├── debugger.md
│   │   └── researcher.md
│   └── rules/                     # Auto-loaded rule files (scoped)
│       ├── general.md             # Always loaded
│       ├── typescript.md          # Loaded for .ts/.tsx files
│       ├── nextjs.md              # Loaded for src/app/**
│       ├── nodejs.md              # Loaded for backend code
│       ├── python.md              # Loaded for .py files
│       └── testing.md             # Loaded for test files
│
├── agent_docs/                    # Progressive disclosure reference docs
│   ├── work-management-system.md  # Full guide for epics/tasks/drafts
│   ├── _examples/                 # Example files showing populated structure
│   │   ├── _index-empty.example.md
│   │   ├── _index-with-data.example.md
│   │   └── EXXX-example-feature/  # Complete example epic
│   ├── architecture.md
│   ├── database-schema.md
│   ├── api-patterns.md
│   ├── auth-flow.md
│   └── component-guide.md
│
└── docs/
    ├── _index.md                  # Master project index (read first!)
    ├── _templates/                # Templates for new items (8 files)
    ├── epics/                     # Epic folders
    │   └── E###-name/
    │       ├── E###-context.md    # Epic details
    │       ├── Drafts/            # Input for changes
    │       ├── Archive/           # Version history
    │       ├── Research/          # Discovery docs
    │       ├── Tasks/             # Child task folders
    │       └── PRs/               # Epic-level PRs
    └── tasks/                     # Standalone tasks (not in epics)
        └── T###-name/
```

### Learning the Structure

To see what populated files look like, check the examples:
- **Empty project**: `agent_docs/_examples/_index-empty.example.md`
- **Active project**: `agent_docs/_examples/_index-with-data.example.md`  
- **Complete epic**: `agent_docs/_examples/EXXX-example-feature/`
- **Full guide**: `agent_docs/work-management-system.md`

---

## Work Management System

### The Hierarchy

```
Epic (E001)                          # Big feature, spans days/weeks
├── Task (E001-T001)                 # Session-sized work, spans hours/days
│   └── Subtask (ST001)              # Atomic step, < 1 hour
├── Task (E001-T002)
│   ├── Subtask (ST001)
│   └── Subtask (ST002)
└── Task (E001-T003)

Standalone Task (T001)               # One-off work, not part of epic
```

**Maximum 3 levels.** If you think you need more, create sibling tasks instead.

### ID Format

| Type | Format | Example |
|------|--------|---------|
| Epic | `E###` | E001, E002, E003 |
| Task (in epic) | `E###-T###` | E001-T001, E001-T002 |
| Task (standalone) | `T###` | T001, T002 |
| Subtask | `ST###` | ST001, ST002 |


### State Machine (Epics & Tasks)

```
┌────────┐     ┌───────┐     ┌─────────────┐     ┌────────┐     ┌──────┐
│  📝    │────▶│  ⚪   │────▶│     🟡      │────▶│   🔵   │────▶│  🟢  │
│ draft  │     │ ready │     │ in-progress │     │ review │     │ done │
└────────┘     └───────┘     └─────────────┘     └────────┘     └──────┘
                                    │                               │
                                    ▼                               ▼
                              ┌─────────┐                     ┌──────────┐
                              │   🔴    │                     │    ⬛    │
                              │ blocked │                     │ archived │
                              └─────────┘                     └──────────┘
```

| State | Emoji | Description |
|-------|-------|-------------|
| draft | 📝 | Created but requirements not complete |
| ready | ⚪ | Requirements complete, waiting to start |
| in-progress | 🟡 | Actively being worked on |
| blocked | 🔴 | Waiting on dependency, question, etc. |
| review | 🔵 | Code complete, in PR review |
| done | 🟢 | Completed and verified |
| archived | ⬛ | Closed, moved to archive |

### State Machine (Drafts)

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

| State | Description |
|-------|-------------|
| open | User is adding content to draft |
| ready | User marked ready, waiting for Claude to process |
| processing | Claude is executing the draft instructions |
| completed | Successfully processed, context files updated |
| failed | Error during processing, needs fix and retry |

---

## Progressive Disclosure

**The key to token efficiency.** Information loads in layers:

| Layer | What Loads | When |
|-------|-----------|------|
| Layer 1 | `docs/_index.md` (summaries, tables) | Always — overview of all work |
| Layer 2 | `*-context.md` (full details) | When working on that item |
| Layer 3 | Supporting files (research, specs) | Only if specifically needed |

**Example flow:**
```
docs/_index.md                    # Layer 1: "E001 - Auth, 43% done, active T003"
  → E001-context.md               # Layer 2: Full epic details, all decisions
    → Research/oauth-comparison.md # Layer 3: Deep research on OAuth providers
```

Claude reads Layer 1 first. If working on E001, reads Layer 2. Only reads Layer 3 if the task involves OAuth.

---

## The Draft Workflow

Users **never edit `*-context.md` files directly**. Instead:

1. **Create a draft** — A folder containing `draft.md` with instructions
2. **Add supporting files** — Slack chats, specs, CSVs, images
3. **Mark ready** — Signal that draft is complete
4. **Claude processes** — Reads draft, executes intent, updates context files

### Why Drafts?

| Benefit | Explanation |
|---------|-------------|
| Structure enforcement | Claude ensures YAML frontmatter, required sections |
| Intent clarity | Draft says "create 3 tasks" not just raw text |
| Audit trail | Can see what changes were requested and when |
| Batch operations | One draft can create multiple items |
| Error handling | If processing fails, draft remains, can retry |
| Supporting files | Draft folder can contain specs, images, data |

### Draft Workflow Step-by-Step

```bash
# 1. Create a draft for an epic
/work:draft-new E001 "add oauth providers"
# Creates: docs/epics/E001-.../Drafts/2025-01-15-add-oauth-providers/

# 2. Edit draft.md with your requirements
# Add supporting files (slack-discussion.md, requirements.csv, etc.)

# 3. Mark draft as ready for processing
/work:draft-ready E001 2025-01-15-add-oauth-providers

# 4. Process the draft
/work:draft-process E001 2025-01-15-add-oauth-providers
# Claude reads intent, executes actions, updates context files
```

---

## All Slash Commands

### Work Management (`/work:*`)

| Command | Description | Example |
|---------|-------------|---------|
| `/work:status` | Show project overview | `/work:status` |
| `/work:resume [ID]` | Resume work (last or specific) | `/work:resume E001-T002` |
| `/work:save [ID]` | Save progress before ending | `/work:save` |
| `/work:epic-new "name"` | Create new epic | `/work:epic-new "user auth"` |
| `/work:task-new [E###] "name"` | Create task (in epic or standalone) | `/work:task-new E001 "login"` |
| `/work:draft-new ID "title"` | Create draft for epic/task | `/work:draft-new E001 "requirements"` |
| `/work:draft-ready ID folder` | Mark draft ready for processing | `/work:draft-ready E001 2025-01-15-req` |
| `/work:draft-process ID folder` | Execute draft instructions | `/work:draft-process E001 2025-01-15-req` |
| `/work:subtask-add TASK "name"` | Add subtask to a task | `/work:subtask-add E001-T001 "write tests"` |
| `/work:debug-start TASK "issue"` | Start debug session | `/work:debug-start E001-T001 "login 401"` |
| `/work:debug-log TASK` | Log debug findings | `/work:debug-log E001-T001` |
| `/work:pr-draft TASK` | Generate PR from task | `/work:pr-draft E001-T001` |

### Development (`/dev:*`)

| Command | Description |
|---------|-------------|
| `/dev:debug "issue"` | Hypothesis-driven debugging |
| `/dev:code-review` | Review recent changes |
| `/dev:test "file"` | Write tests TDD style |

### Git (`/git:*`)

| Command | Description |
|---------|-------------|
| `/git:commit` | Conventional commit with emoji |
| `/git:pr` | Create PR with template |

### Documentation (`/docs:*`)

| Command | Description |
|---------|-------------|
| `/docs:update-docs` | Update docs after changes |


---

## Core Workflows

### Starting a New Feature (Epic)

```bash
# 1. Create the epic
/work:epic-new "user authentication"
# Creates E001-user-authentication/ with context file, subfolders

# 2. Add requirements via draft
/work:draft-new E001 "initial requirements"
# Edit draft.md, add supporting files

# 3. Mark ready and process
/work:draft-ready E001 2025-01-15-initial-requirements
/work:draft-process E001 2025-01-15-initial-requirements
# Claude creates tasks, updates epic context

# 4. Start working on a task
/work:resume E001-T001
```

### Resuming Work

```bash
# Resume last worked item
/work:resume

# Resume specific task
/work:resume E001-T002

# Claude will:
# 1. Read context file
# 2. Summarize where you left off
# 3. Show next step and any blockers
# 4. Ask if ready to continue
```

### Saving Progress (CRITICAL!)

```bash
# Before /clear or ending session:
/work:save
# or for specific task:
/work:save E001-T001

# Claude will:
# 1. Update Progress Log with session summary
# 2. Update "Current State", "Next Step", "Blocker"
# 3. Check off completed requirements
# 4. Archive if significant changes
```

**⚠️ ALWAYS run `/work:save` before `/clear`!**

### Debugging Workflow

```bash
# 1. Start debug session
/work:debug-start E001-T001 "login returns 401 on valid credentials"

# 2. Claude adds strategic console.logs
# Look for: console.log('[DEBUG_TRACE]', Date.now(), 'location', {vars});

# 3. Run your app, trigger the bug

# 4. Paste console output back to Claude

# 5. Claude analyzes and fixes

# 6. Save findings
/work:debug-log E001-T001
```

### Handling Blocked Tasks

```bash
# 1. Update status in context file to blocked
# 2. Add to Unanswered Questions section:
#    "Waiting for API spec from backend team"

# 3. Switch to different task
/work:resume E001-T003

# 4. When unblocked, change status back to in-progress
```

### Archiving Context Versions

When context changes significantly (new tasks added, major decisions):

```bash
# Claude handles this during /work:save, but manually:
# 1. Copy current E001-context.md to Archive/2025-01-15-v2-context.md
# 2. Update Archive/_archive-index.md with change summary
# 3. Make changes to E001-context.md
```

Archive index shows what changed without loading full files.

---

## Sub-Agents

Specialized Claude instances that run in **their own context window** to prevent pollution of your main context.

| Agent | Purpose | Tools | Location |
|-------|---------|-------|----------|
| code-reviewer | Post-change code review | Read-only | `.claude/agents/code-reviewer.md` |
| debugger | Systematic debugging | Read + Write | `.claude/agents/debugger.md` |
| researcher | Explore codebase, web research | Read + Web | `.claude/agents/researcher.md` |

**Invoke:** "Use the code-reviewer agent to review my changes"

---

## Scoped Rules

Rules in `.claude/rules/` auto-load based on file scope:

| File | Scope | When Loaded |
|------|-------|-------------|
| `general.md` | (none) | Always |
| `typescript.md` | `**/*.{ts,tsx}` | TypeScript/TSX files |
| `nextjs.md` | `src/app/**/*` | Next.js App Router |
| `nodejs.md` | `src/api/**/*` | Backend code |
| `python.md` | `**/*.py` | Python files |
| `testing.md` | `**/*.{test,spec}.*` | Test files |

This prevents loading Python rules when working on TypeScript, saving tokens.

---

## External ID Integration

Link tasks to external systems (Jira, Linear, GitHub Issues):

**In `docs/_index.md`:**
```yaml
system: jira  # Options: jira, linear, github, notion, none
project_key: PROJ  # Your project prefix
```

**In context files:**
```yaml
external_id: "PROJ-123"
```

Internal IDs (E001, T001) are used for folders and local references. External IDs link to your team's issue tracker.

---

## Git Tracking

Each task can track its git branch and commits:

```yaml
## Git Tracking
branch: "feature/login-page"
commits: ["abc123", "def456"]
pr_number: "42"
pr_url: "https://github.com/org/repo/pull/42"
```

The `/work:pr-draft` command auto-detects branch and commits to generate PR descriptions.

---

## Best Practices

### Do ✅

- **Always `/work:save` before `/clear`** — preserve your progress
- **Keep CLAUDE.md under 300 lines** — move details to agent_docs/
- **Use drafts, not direct edits** — maintain structure and audit trail
- **Use checkboxes** — Claude can check off completed items
- **Run `/work:status` first** — get oriented before diving in
- **Scope your rules** — don't load Python rules for TypeScript work

### Don't ❌

- **Don't edit `*-context.md` directly** — use drafts
- **Don't create deep hierarchies** — max 3 levels (Epic → Task → Subtask)
- **Don't embed code in CLAUDE.md** — use `@file:line` references
- **Don't skip the save step** — context loss is painful

---

## Customization

1. **Update `CLAUDE.md`** — Add your tech stack, commands, rules
2. **Configure external system** — Edit `docs/_index.md` (jira/linear/github/none)
3. **Modify rules** — Edit `.claude/rules/` for your conventions
4. **Add commands** — Create new `.md` files in `.claude/commands/`
5. **Fill agent_docs/** — Add your architecture, patterns, schemas
6. **Customize templates** — Edit `docs/_templates/` for your workflow

---

## Templates Reference

Located in `docs/_templates/`:

| Template | Purpose |
|----------|---------|
| `epic-context.template.md` | New epic context file |
| `task-context.template.md` | New task context file |
| `draft.template.md` | New draft |
| `subtask.template.md` | New subtask |
| `subtasks-index.template.md` | Subtasks index |
| `archive-index.template.md` | Archive index |
| `debug-session.template.md` | Debug session log |
| `pr-draft.template.md` | PR description |

Templates use `{{PLACEHOLDER}}` syntax that Claude replaces during creation.

---

## Configuration Files

| File | Purpose | Git |
|------|---------|-----|
| `CLAUDE.md` | Main project memory | ✅ Commit |
| `CLAUDE.local.md` | Personal overrides | ❌ Gitignore |
| `.claude/settings.json` | Team settings (hooks) | ✅ Commit |
| `.claude/settings.local.json` | Personal settings | ❌ Gitignore |
| `.mcp.json` | MCP server configs | ✅ Commit |
| `docs/_index.md` | Master work index | ✅ Commit |

---

## License

MIT — Use freely, attribution appreciated.
