---
description: Add subtask to a task
allowed-tools: [Read, Write, Edit, Glob]
---

Add subtask: $ARGUMENTS

## Argument Parsing
Format: `<TASK_ID> "subtask name"`

## Process

1. **Locate task** and read context

2. **Read `_subtasks-index.md`** in Subtasks/ folder
   - Count existing subtasks
   - Determine next ST### number

3. **Determine file strategy**:
   - If subtask is small (simple, one-liner): Add to grouped file
   - If subtask is substantial: Create individual file

4. **Create subtask**

   **For individual file** (`ST###-name.md`):
   - Use `docs/_templates/subtask.template.md`
   - Fill in details

   **For grouped file** (append to existing):
   - Find or create `ST###-ST###-group-name.md`
   - Add subtask entry

5. **Update `_subtasks-index.md`**
   - Add to table
   - Update totals

6. **Update task context**
   - Add to Subtasks table
   - Recalculate progress

7. **Report**:
```
✅ Added subtask {{ST_ID}}: "name"
📁 File: {{FILE_PATH}}
📊 Task progress: {{X}}/{{Y}} subtasks ({{%}})
```

## Grouped Subtasks
If adding multiple related small subtasks:
```
/subtask:add E001-T001 "validate email"
/subtask:add E001-T001 "validate password"
/subtask:add E001-T001 "validate username"
```
These can be grouped into: `ST001-ST003-form-validation.md`
