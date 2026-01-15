---
description: Create a new epic with folder structure
allowed-tools: [Read, Write, Bash, Glob]
---

Create a new epic: $ARGUMENTS

## Process

1. **Read master index** at `docs/_index.md`
   - Get next epic ID from `next_epic` counter
   - Increment counter

2. **Parse arguments**
   - Extract epic name from $ARGUMENTS
   - Generate folder name: `E###-kebab-case-name`

3. **Create epic folder structure**:
```
docs/epics/E###-name/
├── E###-context.md      # From template
├── Drafts/
├── Archive/
│   └── _archive-index.md
├── Research/
├── Tasks/
└── PRs/
```

4. **Create context file** from `docs/_templates/epic-context.template.md`
   - Replace {{EPIC_ID}} with new ID
   - Replace {{EPIC_NAME}} with provided name
   - Replace {{DATE}} with today's date
   - Set status to `draft`

5. **Create archive index** from `docs/_templates/archive-index.template.md`

6. **Update master index** `docs/_index.md`
   - Add epic to Active Epics table
   - Update `next_epic` counter

7. **Report**:
```
✅ Created epic E###: "name"
📁 Location: docs/epics/E###-name/
📝 Status: draft

Next steps:
1. Edit E###-context.md to add objective and success criteria
2. Or use /draft:new E### "planning" to create a draft
3. When ready, change status to 'ready'
```

## Rules
- Epic name should be descriptive but concise
- Use kebab-case for folder names
- Always initialize with `draft` status
