---
description: Validate work item consistency (state machine check)
allowed-tools: [Read, Glob, Grep]
---

Validate work items: $ARGUMENTS (optional: specific epic/task ID)

## Purpose

Validates consistency between context files and index files to detect state machine issues like:
- Epic context tasks table vs Tasks/ folder contents
- Task context subtasks table vs _subtasks-index.md (detects duplicate storage)
- Orphaned files vs index entries
- Legacy format detection

## Process

1. **Determine scope**
   - No args: Validate all active epics and tasks from `docs/_index.md`
   - E###: Validate specific epic and its tasks
   - T### or E###-T###: Validate specific task

2. **For each epic** (if in scope):
   - Read `docs/epics/E###-*/E###-context.md`
   - Extract tasks from Tasks Overview table
   - List actual folders in `Tasks/` directory
   - Compare: tasks in context vs tasks in folder
   - Report mismatches

3. **For each task** (if in scope):
   - Read task context file
   - Check if task has Subtasks table (legacy format detection)
   - Read `Subtasks/_subtasks-index.md`
   - Extract subtasks from index
   - Check for individual subtask files (if referenced)
   - Report:
     - If task has Subtasks table: "⚠️ Legacy format - task context has Subtasks table (should only be in _subtasks-index.md)"
     - If subtask count mismatch: "❌ MISMATCH"
     - If all consistent: "✅ Consistent"

4. **Generate report**

## Report Format

```
🔍 Work Item Validation Results
================================

## Epics

✅ E001: integrate-context-checkpoint
   - Tasks in context: 7
   - Tasks in folder: 7
   - Status: Consistent

## Tasks

❌ E001-T003: integration-with-work-commands
   - Subtasks in context.md table: 9 (S1-S9)
   - Subtasks in _subtasks-index.md: 3 (S1-S3)
   - Status: MISMATCH - Context table out of sync with index
   - Action: Update to new template format (remove Subtasks table from context.md)

⚠️ T001: fix-task-and-subtask-behaviour
   - Subtasks in _subtasks-index.md: 4
   - Subtask files: 0 (using grouped file strategy)
   - Legacy format: YES (has Subtasks table in context.md)
   - Status: Consistent but using old template
   - Action: Consider migrating to new template (optional)

✅ E003-T001: google-oauth
   - Subtasks in _subtasks-index.md: 5
   - Subtask files: 5 individual files
   - Legacy format: NO
   - Status: Consistent (new format)

================================
Summary:
- Total validated: 3 tasks, 1 epic
- Issues found: 1 mismatch, 1 legacy format
- Consistent: 1 task
```

## Implementation Notes

**Detecting Subtasks Table in Context**:
- Use Grep to search for `## Subtasks` followed by table format (`| ID | Name |`)
- If found: Legacy format
- If not found: New format (reference line only)

**Counting Subtasks**:
- Parse `_subtasks-index.md` table rows (exclude header/separator)
- Count non-empty rows

**Detecting Individual Files**:
- Glob for `Subtasks/*.md` excluding `_subtasks-index.md`
- Compare file count with index entries

## Exit Codes

- 0: All consistent
- 1: Mismatches found (state machine broken)
- 2: Legacy format detected (warning, not error)

## Examples

```bash
# Validate all work items
/work:validate

# Validate specific epic
/work:validate E001

# Validate specific task
/work:validate E001-T003
/work:validate T001
```
