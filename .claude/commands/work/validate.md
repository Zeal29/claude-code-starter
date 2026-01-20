---
description: Validate work item consistency (state machine check)
allowed-tools: [Read, Glob, Grep]
---

Validate work items: $ARGUMENTS (optional: specific epic/task ID)

## Purpose

Validates consistency of work items to detect state machine issues:
- Epic context tasks table vs Tasks/ folder contents (orphaned tasks)
- Task context subtasks table vs Subtasks/ folder (File column accuracy)
- File column consistency: links point to real files, dashes have no files
- Legacy format detection (_subtasks-index.md files)

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
   - Extract `## Subtasks` table
   - Glob Subtasks/ folder for ST###.md files
   - Check File column consistency (3 checks):
     - **Check 1**: Every link in File column → verify file exists
     - **Check 2**: Every ST###.md file in Subtasks/ → verify table entry exists
     - **Check 3**: Every em-dash (—) → verify no corresponding ST###.md file
   - Check for legacy _subtasks-index.md (if found, report warning)
   - Report:
     - "⚠️ Legacy format: Found _subtasks-index.md" (old pattern, optional migration)
     - "❌ MISMATCH: File column inconsistent" (broken state)
     - "✅ Consistent" (all checks pass)

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

✅ E001-T001: context-loading-strategy
   - Subtasks in table: 5
   - Subtask files: 3 ([ST003.md](./Subtasks/ST003.md), [ST004.md](./Subtasks/ST004.md), [ST005.md](./Subtasks/ST005.md))
   - Inline subtasks: 2 (ST001, ST002 → File column = —)
   - File column: Consistent (3 links valid, 2 dashes correct)
   - Legacy format: NO
   - Status: Consistent

❌ E001-T003: migration-in-progress
   - Subtasks in table: 8
   - Subtask files: 3
   - File column issues:
     - Link to [ST006.md](./Subtasks/ST006.md) but file doesn't exist
     - File ST007.md exists but not in table (orphaned)
   - Status: MISMATCH - File column inconsistent
   - Action: Use /work:validate --sync to auto-fix broken links

⚠️ T001: legacy-task-format
   - Subtasks in table: 4
   - Legacy _subtasks-index.md: Found (old pattern)
   - File column: Consistent but old format used
   - Status: Consistent but using legacy pattern
   - Action: Optional - use /work:validate --migrate to consolidate to new format

================================
Summary:
- Total validated: 3 tasks, 1 epic
- Issues found: 1 mismatch, 1 legacy format
- Consistent: 1 task
```

## Implementation Notes

**Detecting Subtasks Table**:
- Grep for `## Subtasks` section followed by table (`| ID | Name | Status | File |`)
- Extract all rows between header and next section
- Parse File column: extract links and em-dashes

**File Column Validation (3 Checks)**:
1. **Check 1 - Broken Links**: For each `[ST###.md](./Subtasks/...)` link:
   - Extract path from link (e.g., `./Subtasks/ST003.md`)
   - Verify file exists at that path
   - If not: Report "Broken link: [ST###.md] points to missing file"
2. **Check 2 - Missing Links**: For each ST###.md file in Subtasks/ folder:
   - Find corresponding row in table (matching ST### ID)
   - If row exists, verify File column has link to this file
   - If row missing: Report "Orphaned file: ST###.md exists but no table entry"
3. **Check 3 - Dash Verification**: For each em-dash (—) in File column:
   - Verify NO ST###.md file exists for that subtask ID
   - If file exists: Report "Dash inconsistent: ST###.md exists but File column = —"

**Legacy Format Detection**:
- Glob for `_subtasks-index.md` in Subtasks/ folder
- If found: Report "⚠️ Legacy format: Found _subtasks-index.md (use --migrate to consolidate)"

## Exit Codes

- 0: All consistent
- 1: Mismatches found (state machine broken, File column inconsistent)
- 2: Legacy format detected (warning, not error)

## Flags

- `--sync`: Auto-fix File column mismatches (remove broken links, add missing links)
- `--migrate`: Consolidate old _subtasks-index.md → new table format
- `--full`: Validate all items in project
- `--verbose`: Show detailed validation steps

## Examples

```bash
# Validate all work items
/work:validate

# Validate specific epic
/work:validate E001

# Validate specific task
/work:validate E001-T003
/work:validate T001

# Auto-fix File column inconsistencies
/work:validate E001-T001 --sync

# Consolidate legacy _subtasks-index.md to new format
/work:validate T001 --migrate

# Full validation with detailed output
/work:validate --full --verbose
```
