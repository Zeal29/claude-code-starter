---
description: Resume work - either last worked item or specific ID
allowed-tools: [Read, Glob]
---

Resume work: $ARGUMENTS

## Behavior

**If no arguments**: Resume last worked item from `docs/_index.md`
**If ID provided**: Resume that specific epic/task

## Process

1. **Determine target**
   - No args: Read `docs/_index.md` → "Last worked on" field
   - With args: Use provided ID

2. **Locate context file**
   - Epic: `docs/epics/E###-*/E###-context.md`
   - Task in epic: `docs/epics/E###-*/Tasks/E###-T###-*/T###-context.md`
   - Standalone task: `docs/tasks/T###-*/T###-context.md`

3. **Read context file** (progressive disclosure)
   - Read Meta, Objective, Current Focus first
   - Summarize status

4. **Check for active drafts**
   - Look in `Drafts/` for any `ready` status drafts
   - Alert user if pending drafts exist

5. **Present summary**:
```
## Resuming: {{ID}} - {{NAME}}

**Status**: {{STATUS}}
**Progress**: {{PROGRESS}}

### Last Session
{{LAST_PROGRESS_LOG_ENTRY}}

### Current State
- **Working on**: {{CURRENT_STATE}}
- **Next Step**: {{NEXT_STEP}}
- **Blocker**: {{BLOCKER}}

### Pending
- Drafts ready to process: {{COUNT}}
- Unanswered questions: {{COUNT}}

---
Ready to continue with "{{NEXT_STEP}}"?
Or tell me what you'd like to do.
```

6. **Update master index**
   - Set "Last worked on" to this item

## If Target Not Found
```
❌ Could not find {{ID}}

Available items:
[List active epics and tasks from _index.md]

Use /work:resume <ID> to resume a specific item.
```
