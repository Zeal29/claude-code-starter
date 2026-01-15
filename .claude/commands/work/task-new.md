---
description: Create a new task (under epic or standalone)
allowed-tools: [Read, Write, Bash, Glob]
---

Create a new task: $ARGUMENTS

## Argument Parsing
- If starts with `E###`: Task under that epic (e.g., `E001 "login page"`)
- Otherwise: Standalone task (e.g., `"fix header bug"`)

## Process for Epic Task

1. **Validate epic exists** at `docs/epics/E###-*/`

2. **Read epic context** to get next task number
   - Count existing tasks in `Tasks/` folder
   - New task ID = `E###-T###`

3. **Create task folder structure**:
```
docs/epics/E###-name/Tasks/E###-T###-task-name/
├── T###-context.md
├── Drafts/
├── Archive/
│   └── _archive-index.md
├── Subtasks/
│   └── _subtasks-index.md
├── PRs/
└── Debug/
```

4. **Create context file** from `docs/_templates/task-context.template.md`
   - Replace all {{PLACEHOLDERS}}
   - Set `epic: E###`

5. **Update epic context** `E###-context.md`
   - Add task to Tasks Overview table
   - Set as Active Task if epic is in-progress

6. **Update master index** if needed

## Process for Standalone Task

1. **Read master index** `docs/_index.md`
   - Get `next_standalone_task` counter
   - New task ID = `T###`

2. **Create task folder** at `docs/tasks/T###-task-name/`
   - Same structure as epic task
   - Set `epic: ""` in context

3. **Update master index**
   - Add to Active Standalone Tasks
   - Increment counter

## Report
```
✅ Created task {{TASK_ID}}: "name"
📁 Location: {{PATH}}
🔗 Epic: {{EPIC_ID}} (or "Standalone")
📝 Status: draft

Next steps:
1. Edit context file to add requirements
2. Or use /draft:new {{TASK_ID}} "requirements" to create a draft
```
