# Task: {{TASK_ID}} - {{TASK_NAME}}

## Meta
```yaml
id: {{TASK_ID}}
name: {{TASK_NAME}}
epic: {{EPIC_ID}}  # Empty if standalone task
status: draft  # draft|ready|in-progress|blocked|review|done|archived
created: {{DATE}}
updated: {{DATE}}
owner: {{OWNER}}
external_id: ""  # Jira/Linear/etc ticket ID
```

## Objective (WHAT)
<!-- Clear 1-2 sentence goal - what this task accomplishes -->

## Rationale (WHY)
<!-- Why this task is needed, problem context, decision rationale -->
<!-- This section often extracted from draft discussion - see Archive/ -->

**Problem Context**:
<!-- What problem does this task solve, why does it exist -->

**Approach Rationale**:
<!-- Why this approach over alternatives, key trade-offs -->

**Key Decisions**:
<!-- Critical decisions made during planning/discussion -->

## Requirements
- [ ] Requirement 1
- [ ] Requirement 2
- [ ] Requirement 3

## Relevant Files
<!-- Files Claude should read for context -->
- `path/to/file.ts` - why relevant

→ Subtasks: See `Subtasks/_subtasks-index.md`

## Approach (HOW - Detailed)
<!-- Task-level implementation plan, step-by-step approach -->
<!-- Detail level: Detailed steps, file modifications, testing strategy -->

## Definition of Done
- [ ] All tests pass
- [ ] Code reviewed
- [ ] No TypeScript errors
- [ ] Docs updated (if needed)

## Dependencies
- **Blocked by**: None
- **Blocks**: None

## Git Tracking
```yaml
branch: ""
commits: []
pr_number: ""
```

## Progress Log
### Session {{DATE}}
- Task created
- **Current State**: Not started
- **Next Step**: 
- **Blocker**: None

## Assumptions
- 

## Unanswered Questions
- [ ] 

## Time Log
| Date | Duration | Notes |
|------|----------|-------|
| {{DATE}} | - | Task created |

---

## Progressive Disclosure Guide
**This is Layer 2 - Task Level**

- **Focus**: Detailed requirements, implementation approach, session progress
- **Detail**: WHAT (specific deliverable), WHY (problem context, decision rationale), HOW (step-by-step implementation)
- **Delegate to subtasks**: Atomic work units, specific file edits, verification steps

**What belongs at Task level**:
- Specific deliverable and requirements
- Problem context from draft discussions
- Detailed implementation approach (steps, not exact code)
- Files to modify (list, not exact changes)
- Session-by-session progress tracking
- Detailed assumptions and open questions
- Definition of done with specific criteria

**What to delegate to Subtask level**:
- Atomic work units (single focused action)
- Exact file changes (line-by-line if needed)
- Deep implementation details
- Complex debugging steps
- Verification procedures for specific changes
