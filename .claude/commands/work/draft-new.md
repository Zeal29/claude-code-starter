---
description: Create a new draft for an epic or task
allowed-tools: [Read, Write, Bash, Glob]
---

Create a new draft: $ARGUMENTS

## Argument Parsing
Format: `<ID> "draft title"`
- ID: E### for epic, E###-T### or T### for task
- Title: What this draft is about

## Process

1. **Locate target**
   - Find epic/task folder by ID
   - Verify it exists

2. **Generate draft folder name**
   - Format: `YYYY-MM-DD-kebab-case-title`
   - Example: `2025-01-15-add-oauth-providers`

3. **Create draft folder**:
```
Drafts/YYYY-MM-DD-title/
├── draft.md          # From template
└── (empty, user adds files)
```

4. **Create draft.md** from `docs/_templates/draft.template.md`
   - Replace {{DRAFT_ID}} with folder name
   - Replace {{TARGET_ID}} with epic/task ID
   - Replace {{DRAFT_TITLE}} with provided title
   - Set status to `open`

5. **Report**:
```
✅ Created draft for {{ID}}: "title"
📁 Location: {{PATH}}
📝 Status: open

Next steps:
1. Edit draft.md with your requirements
2. Add supporting files (slack chats, specs, etc.)
3. Run /draft:ready {{ID}} {{FOLDER}} when done adding content
4. Run /draft:process {{ID}} {{FOLDER}} to execute
```

## Draft States
- `open` - Created, user adding content
- `ready` - User marked ready for processing  
- `processing` - Claude is processing
- `completed` - Successfully processed
- `failed` - Processing failed
