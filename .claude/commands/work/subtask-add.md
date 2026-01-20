---
description: Add subtask to a task
allowed-tools: [Read, Write, Edit, Glob]
---

Add subtask: $ARGUMENTS

## Argument Parsing
Format: `<TASK_ID> "subtask name"`

## Process

1. **Locate task** and read task-context.md

2. **Read task-context.md "## Subtasks" section**
   - Find "## Subtasks" section
   - Parse existing table to determine next ST### ID
   - Count rows (excluding header/separator/empty placeholder)

3. **Determine file strategy**:
   - If subtask is simple (inline-only): Table entry only, no file
   - If subtask is substantial: Create individual ST###-name.md file

4. **Create subtask file** (if substantial)

   **For individual file** (`ST###-name.md`):
   - Use `docs/_templates/subtask.template.md`
   - Fill in: id, parent_task, name, status=ready
   - Create in `Subtasks/ST###-name.md`

5. **Update task-context.md "## Subtasks" table** (SINGLE SOURCE OF TRUTH)
   - Use Edit tool to find existing table
   - Add new row: `| ST### | {{name}} | ready | — |`
   - If created individual file: Update File column with `[ST###-name.md](./Subtasks/ST###-name.md)`
   - If inline-only: Keep File column as `—`

6. **Report**:
```
✅ Added subtask {{ST_ID}}: "name"
📁 File: {{FILE_PATH}} (or "inline-only" if no file)
📊 Task progress: {{X}}/{{Y}} subtasks
```

## Notes
- **SSOT**: Subtask table in task-context.md is the single source of truth
- **Status**: Always initialize as "ready" in table
- **File column**: `—` for inline, `[ST###-name.md](./Subtasks/ST###-name.md)` for file-based
- **Individual files**: Only create when subtask is substantial (see granularity guidelines in work-management-system.md)
