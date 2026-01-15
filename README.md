# Claude Code Starter Template

Optimized project structure for Claude Code CLI with agentic workflows, sub-agents, custom commands, hooks, and context management.

## Quick Start

1. **Copy this template** to your new project
2. **Update CLAUDE.md** with your project's tech stack and commands
3. **Update agent_docs/** with your project's specific patterns
4. **Start Claude Code**: `claude` in your project directory

## Structure Overview

```
├── CLAUDE.md                 # Main project memory (always loaded)
├── CLAUDE.local.md           # Personal overrides (gitignored)
├── .mcp.json                  # MCP server configs
├── .claude/
│   ├── settings.json         # Team settings (hooks, permissions)
│   ├── settings.local.json   # Personal settings (gitignored)
│   ├── commands/             # Custom slash commands
│   │   ├── dev/              # /project:dev:* commands
│   │   ├── git/              # /project:git:* commands
│   │   ├── task/             # /project:task:* commands
│   │   └── docs/             # /project:docs:* commands
│   ├── agents/               # Sub-agent definitions
│   └── rules/                # Auto-loaded rule files (scoped)
├── agent_docs/               # Progressive disclosure docs
└── docs/
    ├── epics/                # Long-running feature tracking
    └── tasks/                # Task context management
        ├── current-task.md   # Active task context
        └── archive/          # Completed tasks
```

## Task Context System

The most important feature for maintaining context across sessions.

### The Problem
Claude Code sessions are ephemeral. When you `/clear` or start a new session, context is lost. For multi-session tasks, you waste tokens re-explaining what you're doing.

### The Solution
`docs/tasks/current-task.md` — a living document that tracks:
- What you're trying to accomplish
- Current progress (checkboxes)
- Decisions made
- Next steps
- Open questions

### Workflow

**Starting a new task:**
```
/project:task:new implement user authentication
```
Claude creates fresh context file, breaks down requirements, identifies relevant files.

**During work:**
Claude checks off requirements as completed, logs progress, documents assumptions.

**Before ending session:**
```
/project:task:save
```
Claude updates context file with current state, next steps, blockers.

**Resuming next session:**
```
/project:task:resume
```
Claude reads context, summarizes where you left off, asks what to do next.

### Manual Usage
You can also manage context manually:
- Edit `docs/tasks/current-task.md` directly
- Tell Claude: "Read @docs/tasks/current-task.md and continue"
- Tell Claude: "Update the task context with what we just did"

### Task File Structure
```markdown
# Current Task

## Context
**Created**: 2025-01-15
**Status**: 🟡 In Progress
**Epic**: docs/epics/auth-system.md (if part of larger feature)

## Objective
Implement password reset flow

## Requirements
- [x] Create reset token generation
- [x] Build email sending service
- [ ] Create reset password page
- [ ] Add token validation endpoint

## Relevant Files
- src/lib/auth.ts - existing auth utilities
- src/app/api/auth/ - auth API routes

## Progress Log
### Session 2025-01-15
- Created token generation with 1hr expiry
- Set up SendGrid integration
- **Current State**: Email sending works
- **Next Step**: Build reset password UI
- **Blocker**: None

## Assumptions
- Using SendGrid for email (confirmed with user)
- Tokens expire after 1 hour

## Unanswered Questions
- [ ] Should we rate limit reset requests?
```

---

## How It Works

### CLAUDE.md (Always Loaded)
Core project info Claude needs for every task:
- Tech stack, key directories
- Critical rules (ALWAYS/NEVER)
- Common commands
- References to deeper docs
- Task context management instructions

**Keep under 300 lines** - move details to agent_docs/

### .claude/rules/ (Auto-Loaded)
Rule files loaded automatically at session start.

**Scoped rules** only load when working on matching files:
```markdown
---
scope: "**/*.{ts,tsx}"
---
# TypeScript Rules
...
```

| File | Scope | When Loaded |
|------|-------|-------------|
| general.md | (none) | Always |
| typescript.md | `**/*.{ts,tsx}` | TS/TSX files |
| nextjs.md | `src/app/**/*` | Next.js app router |
| nodejs.md | `src/api/**/*` | Backend code |
| python.md | `**/*.py` | Python files |
| testing.md | `**/*.{test,spec}.*` | Test files |

### agent_docs/ (Progressive Disclosure)
Deep reference docs Claude reads **only when needed**:
- Database schemas
- API patterns
- Architecture decisions

Reference in CLAUDE.md: `→ read @agent_docs/database-schema.md`

---

## Custom Slash Commands

### Task Management
| Command | Description |
|---------|-------------|
| `/project:task:new <desc>` | Start new task with fresh context |
| `/project:task:save` | Save progress before ending session |
| `/project:task:resume` | Resume from saved context |

### Development
| Command | Description |
|---------|-------------|
| `/project:dev:debug <issue>` | Systematic hypothesis-driven debugging |
| `/project:dev:code-review` | Review recent changes |
| `/project:dev:test <file>` | Write tests TDD style |

### Git
| Command | Description |
|---------|-------------|
| `/project:git:commit` | Conventional commit with emoji |
| `/project:git:pr` | Create PR with template |

### Documentation
| Command | Description |
|---------|-------------|
| `/project:docs:update-docs` | Update docs after changes |

---

## Sub-Agents

Specialized Claude instances in `.claude/agents/`:

| Agent | Purpose | Tools |
|-------|---------|-------|
| code-reviewer | Post-change code review | Read-only |
| debugger | Systematic debugging | Read + Write |
| researcher | Explore codebase, fetch docs | Read-only + Web |

**Invoke with:** "use the code-reviewer agent to review my changes"

---

## Configuration

### Hooks (settings.json)
Current hooks:
- **PostToolUse**: Auto-format TS/Python files after edit

### MCPs (.mcp.json)
Pre-configured:
- **playwright** - browser automation
- **filesystem** - enhanced file ops

Add more: `claude mcp add <name> -- <command>`

---

## Key Workflows

### Standard Task Flow
```
/project:task:new "add user profile page"    # Start
[work on task...]
/project:task:save                            # Before ending
[next session]
/project:task:resume                          # Continue
```

### Explore → Plan → Code → Commit
```
1. "Read src/lib/ and explain the auth system" (explore)
2. "Plan how to add password reset" (plan)
3. [Review plan] "Implement it" (code)
4. /project:git:commit (commit)
```

### Debugging
```
/project:dev:debug "login fails with 401"
[Claude adds console.logs]
[You run app, paste logs]
[Claude analyzes and fixes]
```

---

## Best Practices

1. **Use task context** - Always `/project:task:save` before ending session
2. **Be concise** - All .md files should be information dense
3. **Use checkboxes** - Claude can check off completed items
4. **Scope rules** - Don't load Python rules when working on TS
5. **Verify before done** - Always run tests/typecheck

---

## Customization

1. Update `CLAUDE.md` with your stack
2. Modify rules in `.claude/rules/` for your conventions
3. Add project-specific commands in `.claude/commands/`
4. Fill in `agent_docs/` with your actual patterns
5. Customize task template in `docs/tasks/_template.md`
