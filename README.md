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
│   │   └── docs/             # /project:docs:* commands
│   ├── agents/               # Sub-agent definitions
│   └── rules/                # Auto-loaded rule files (scoped)
├── agent_docs/               # Progressive disclosure docs
└── docs/
    ├── epics/                # Long-running feature tracking
    └── tasks/                # Individual task context
```

## How It Works

### CLAUDE.md (Always Loaded)
Core project info Claude needs for every task:
- Tech stack, key directories
- Critical rules (ALWAYS/NEVER)
- Common commands
- References to deeper docs

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

### agent_docs/ (Progressive Disclosure)
Deep reference docs Claude reads **only when needed**:
- Database schemas
- API patterns
- Architecture decisions

Reference in CLAUDE.md: `→ read @agent_docs/database-schema.md`

### Custom Commands
Markdown files in `.claude/commands/` become slash commands:
- `/project:dev:debug <issue>` - systematic debugging
- `/project:dev:code-review` - thorough code review  
- `/project:dev:test <file>` - write tests
- `/project:git:commit` - conventional commit
- `/project:git:pr` - create pull request

### Sub-Agents
Specialized Claude instances in `.claude/agents/`:
- **code-reviewer** - post-change code review
- **debugger** - systematic debugging
- **researcher** - read-only codebase exploration

Invoke with: "use the code-reviewer agent to review my changes"

### Task Context Management
For tasks spanning multiple sessions:

1. Create `docs/tasks/my-task.md` from template
2. Update progress after each session
3. Next session: "read @docs/tasks/my-task.md and continue"

For epics (large features):
1. Create `docs/epics/my-epic.md` from template
2. Track phases with checkboxes
3. Claude checks off items as completed

## Configuration

### Hooks (settings.json)
Auto-format on save, block sensitive files, notifications.

Current hooks:
- **PostToolUse**: Auto-format TS/Python files after edit

### MCPs (.mcp.json)
Pre-configured:
- **playwright** - browser automation
- **filesystem** - enhanced file ops

Add more with `claude mcp add <name> -- <command>`

## Key Workflows

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

### Context Recovery
```
"Read @docs/tasks/current-task.md and continue from where we left off"
```

## Best Practices

1. **Be concise** - all .md files should be information dense
2. **Use checkboxes** - Claude can check off completed items
3. **Update context files** - before /clear or ending session
4. **Scope rules** - don't load Python rules when working on TS
5. **Verify before done** - always run tests/typecheck

## Customization

1. Update `CLAUDE.md` with your stack
2. Modify rules in `.claude/rules/` for your conventions
3. Add project-specific commands in `.claude/commands/`
4. Fill in `agent_docs/` with your actual patterns
