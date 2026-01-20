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

## Approach (HOW - Detailed)
<!-- Task-level implementation plan, step-by-step approach -->
<!-- Detail level: Detailed steps, file modifications, testing strategy -->

## Definition of Done
- [ ] All tests pass
- [ ] Code reviewed
- [ ] No TypeScript errors
- [ ] Docs updated (if needed)

## Subtasks
<!-- Layer 2 → Layer 3: High-level breakdown with links to detailed implementation -->

| ID | Name | Status | File |
|----|------|--------|------|
| — | (No subtasks yet) | — | — |

→ Full details: See individual files in `Subtasks/` folder

**Notes**:
<!-- Subtask grouping logic, dependencies, or execution order -->

## Progress Tracking (3 Levels Explained)

**There are 3 places to track progress. Each serves a different purpose - DON'T DUPLICATE**:

1. **Task Progress Log** (this file, "Progress Log" section below)
   - WHAT: Session-by-session notes about task completion
   - WHY: Preserve session context, help next Claude understand what happened
   - HOW: Update after `/work:save`, write session-level summaries
   - EXAMPLE: "Session 2026-01-16: Completed requirements 1-5. Still blocked on API integration until T002 merges."

2. **Subtasks Table** (Status column above, "Subtasks" section)
   - WHAT: Current status of each subtask (⚪🟡🟢🔴⬛)
   - WHY: Quick glance at task completion percentage
   - HOW: Updated by `/work:save` and `/work:subtask-add`, reflects current progress
   - EXAMPLE: 8 subtasks total, 5 done (🟢), 3 in-progress (🟡) = 62% complete

3. **Subtask File Progress Log** (if ST###.md file exists)
   - WHAT: Implementation-level notes within individual subtask file
   - WHY: Preserve implementation details and debugging steps for deep work
   - HOW: Updated while working on subtask (optional, cache-level detail)
   - EXAMPLE: "Tried approach A (failed due to race condition), switched to approach B (working)"

**DON'T**: Update all 3 places (causes duplication)
**DO**: Use each for its intended level of detail

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
