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

2.5. **Check for active handoff**
   - Look for `{WORK_FOLDER}/Handoff/handoff.md`
   - If exists, read YAML frontmatter:
     - status (open|in-progress|completed)
     - steps_total, steps_completed
     - context_at_creation
   - Parse YAML frontmatter:
     - If YAML parse fails → Skip handoff, display: "⚠️ Handoff file malformed (invalid YAML), skipping"
     - If missing required fields → Skip handoff, display: "⚠️ Handoff missing required fields, skipping"
     - If field types invalid → Skip handoff, display: "⚠️ Handoff data invalid, skipping"
     - Continue normal command execution
   - Store for display later

3. **Update Progress Log** - Add new session entry:
```markdown
### Session {{TODAY}}
<!-- Active handoff = Handoff/handoff.md exists AND status in [open, in-progress] -->
{{IF_ACTIVE_HANDOFF}}
- **Handoff Progress**: {{steps_completed}}/{{steps_total}} steps completed (handoff at {{context_at_creation}}% context)
{{END_IF}}
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

{{IF_ACTIVE_HANDOFF}}
## 📋 Active Checkpoint
- Handoff Status: {{STATUS}} ({{steps_completed}}/{{steps_total}} steps)
- Created at: {{context_at_creation}}% context
- Next steps: See [Handoff/handoff.md]({{WORK_FOLDER}}/Handoff/handoff.md)
- Use `/work:complete-handoff` when all steps done
{{END_IF}}

## Git
- Branch: {{BRANCH}}
- Commits: {{COMMIT_COUNT}} new

Ready to /clear or continue working.
```

## Rules
- Be concise in Progress Log
- Capture enough context to resume later
- Don't lose information
