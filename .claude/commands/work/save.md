---
description: Save current session progress to active task/epic context
allowed-tools: [Read, Write, Edit]
---

Save progress for: $ARGUMENTS

## Behavior
- If ID provided: Save to that item
- If no ID: Save to "Last worked on" from `docs/_index.md`

## Process

1. **Identify target** and locate context file

2. **Read current context**

3. **Update Progress Log** - Add new session entry:
```markdown
### Session {{TODAY}}
- {{SUMMARY_OF_WORK_DONE}}
- **Current State**: {{WHAT_IS_WORKING}}
- **Next Step**: {{WHAT_TO_DO_NEXT}}
- **Blocker**: {{ANY_BLOCKERS}}
```

4. **Update other sections** as needed:
   - Check off completed Requirements
   - Add new Assumptions discovered
   - Add new Unanswered Questions
   - Update Time Log

5. **Update Meta**
   - Set `updated: {{TODAY}}`
   - Update `status` if changed

6. **Update Git Tracking** (if commits made):
   - Add recent commit hashes
   - Update branch name if changed

7. **Archive if significant changes**
   - If major progress, archive previous version
   - Update `_archive-index.md`

8. **Update master index**
   - Update progress percentage
   - Update "Last worked on"

9. **Report**:
```
✅ Progress saved for {{ID}}

## Updated
- Progress Log: Added session {{DATE}}
- Requirements: {{X}}/{{Y}} complete
- Status: {{STATUS}}

## Git
- Branch: {{BRANCH}}
- Commits: {{COMMIT_COUNT}} new

Ready to /clear or continue working.
```

## Rules
- Be concise in Progress Log
- Capture enough context to resume later
- Don't lose information
