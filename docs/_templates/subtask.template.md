# Subtask: {{SUBTASK_ID}} - {{SUBTASK_NAME}}

## Meta
```yaml
id: {{SUBTASK_ID}}
parent_task: {{TASK_ID}}
status: ready  # ready|in-progress|done
created: {{DATE}}
updated: {{DATE}}
```

## Objective (WHAT)
<!-- One clear sentence - what this subtask accomplishes -->

## Context (WHY)
<!-- Why this subtask exists, what problem it solves within the task -->
<!-- Link to parent task section this supports -->

**Parent Task**: {{TASK_ID}}
**Purpose**:
<!-- Why this specific subtask is needed in the sequence -->

## Implementation (HOW)
<!-- Detailed implementation steps - this is the deepest level, maximum detail -->

**Steps**:
1.
2.
3.

**Files to Modify**:
- `path/to/file` - what change to make

**Implementation Notes**:
<!-- Any gotchas, edge cases, dependencies, technical details -->

## Verification
<!-- How to verify this subtask is complete -->
- [ ] Changes made
- [ ] Tested manually
- [ ] No regressions
- [ ] Meets acceptance criteria

## Progress Log
<!-- For multi-session subtask work - OPTIONAL, only if needed -->
<!-- See parent task for task-level progress tracking -->
<!-- Status in parent Subtasks table is source of truth (SSOT) -->

**Current State**: Not started
**Next Step**:
**Blocker**: None

**Notes**:
<!-- Quick notes on progress, issues encountered, implementation decisions -->
<!-- This is CACHE-level detail - can lag behind table status -->

**Note on Progress Tracking**:
- **Source of Truth**: Parent task's Subtasks table Status column (has authority)
- **This file**: Optional cache for implementation details
- **Update frequency**: After session work, not mandatory
- **Sync**: Parent table status takes precedence if this file is stale

---

## Progressive Disclosure Guide
**This is Layer 3 - Subtask Level (Deepest)**

- **Focus**: Atomic work unit, specific files, exact changes, verification
- **Detail**: WHAT (one focused action), WHY (why in task sequence), HOW (exact code changes, line-by-line if needed)
- **Delegate to**: NOTHING (this is the deepest layer - capture ALL detail here)

**What belongs at Subtask level**:
- Single focused action (atomic work unit)
- Exact file paths and line numbers
- Specific code changes (can include code snippets)
- Step-by-step implementation (numbered list)
- Detailed technical notes (gotchas, edge cases)
- Specific verification steps
- Any debugging or troubleshooting done

**This is the maximum detail layer** - don't hold back on specifics.
