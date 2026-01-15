---
description: Save current progress to task context file before ending session or /clear
allowed-tools: [Read, Write, Edit]
---

Save current session progress to `docs/tasks/current-task.md`.

## Process
1. Read current `docs/tasks/current-task.md`
2. Update the following sections based on our conversation:

### Progress Log
Add new entry with today's date:
```markdown
### Session YYYY-MM-DD
- [Summary of what was accomplished]
- [Key decisions made]
- [Problems encountered and solutions]
```

### Status Update
- Update requirement checkboxes (mark completed items)
- Update Status emoji if changed

### Current State
Add/update at end of Progress Log:
```markdown
**Current State**: [What's working now]
**Next Step**: [Immediate next action to take]
**Blocker**: None / [Describe if blocked]
```

### Assumptions & Questions
- Add any new assumptions discovered
- Add any new unanswered questions

3. Write updated file
4. Confirm save complete

## Rules
- Be concise - information dense
- Don't remove existing progress entries
- Preserve all context needed to resume later
