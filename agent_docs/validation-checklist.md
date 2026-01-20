# Validation Checklist

**Purpose**: Systematic validation of work items and SSOT enforcement for task/subtask architecture.

---

## Epic Level Validation

### Structure Checks
- [ ] `E###-context.md` exists in `docs/epics/E###-epic-name/`
- [ ] File contains all required sections: Meta, Objective, Rationale, Approach, Success Criteria, Tasks Overview
- [ ] YAML meta section is valid
- [ ] ID matches folder name (E###)

### Content Checks
- [ ] Objective: 1-2 clear sentences
- [ ] Rationale: Problem Context + Approach Rationale + Key Decisions
- [ ] Approach: High-level strategy (not implementation details)
- [ ] Success Criteria: Outcome-focused checkboxes
- [ ] Tasks Overview: Table lists all child tasks

### Hierarchy Checks
- [ ] Tasks/ folder contains all tasks referenced in Tasks Overview table
- [ ] No orphaned task folders (all folders referenced in table)
- [ ] No circular epic dependencies

---

## Task Level Validation

### Structure Checks
- [ ] `T###-context.md` exists in task folder
- [ ] File contains all required sections: Meta, Objective, Rationale, Requirements, Relevant Files, Subtasks, Approach, Definition of Done
- [ ] YAML meta section is valid
- [ ] ID matches folder name (T### or E###-T###)
- [ ] Parent epic link correct (if applicable)

### Content Checks
- [ ] Objective: 1-2 sentences, clear deliverable
- [ ] Rationale: Problem Context + Approach Rationale + Key Decisions
- [ ] Requirements: Checkboxes, specific and testable
- [ ] Relevant Files: List of implementation-relevant files
- [ ] Approach: Step-by-step, delegates to subtasks
- [ ] Definition of Done: Completion checklist

### Subtasks Table Validation (NEW - SSOT Pattern)
- [ ] `## Subtasks` section exists in task-context.md
- [ ] Table format: `| ID | Name | Status | File |`
- [ ] All subtask IDs unique (ST001, ST002, etc.)
- [ ] Status column values valid (✅, 🟢, 🟡, ⚪, 🔴, ⬛)
- [ ] **File Column Consistency**:
  - [ ] Link format: `[ST###-name.md](./Subtasks/ST###-name.md)`
  - [ ] Links point to existing ST###.md files in Subtasks/ folder
  - [ ] Em-dashes (—) used for inline-only subtasks (no file)
  - [ ] No broken links (file referenced but doesn't exist)
  - [ ] No missing links (file exists but not referenced)

### File Column Validation (NEW - Strictest Check)
- [ ] **Check 1**: Every link in File column → verify file exists at that path
  - If link broken: Either remove link or create missing file
- [ ] **Check 2**: Every ST###.md file in Subtasks/ → verify table entry exists
  - If file orphaned: Either add to table or delete file
- [ ] **Check 3**: Every em-dash (—) entry → verify no corresponding ST###.md file exists
  - If file exists: Either add link to table or delete file
  - If correct: Keep as-is (inline-only subtask)

### Legacy Format Detection (NEW)
- [ ] **WARN** if `_subtasks-index.md` found (old pattern, should migrate)
- [ ] **ERROR** if both _subtasks-index.md AND Subtasks table exist with different subtasks (out of sync)

---

## Subtask Level Validation

### Structure Checks (Optional ST###.md files)
- [ ] If ST###.md exists: Contains all required sections (Meta, Objective, Context, Implementation, Verification)
- [ ] YAML meta section is valid
- [ ] ID matches filename (ST### format)
- [ ] Parent task ID in meta matches parent task-context.md

### Content Checks (If File Exists)
- [ ] Objective: Single, focused action
- [ ] Context (WHY): Links to parent task, explains sequencing
- [ ] Implementation: Steps, Files to Modify, Implementation Notes
- [ ] Verification: Specific tests/checks
- [ ] Atomic: Cannot be broken into smaller meaningful steps

---

## New/Moved Work Items

### When Creating Task
- [ ] Run `/work:task-new E### "name"` to generate structure
- [ ] Verify task-context.md created with empty Subtasks table
- [ ] Verify Subtasks/ folder created (empty)
- [ ] No _subtasks-index.md created (old pattern removed)

### When Adding Subtask
- [ ] Run `/work:subtask-add E###-T### "name"` to add to table
- [ ] Verify: Row added to Subtasks table
- [ ] Verify: Status set to ⚪ (ready)
- [ ] Verify: File column set to — (inline by default)
- [ ] If substantial: Create ST###.md file and update File column link

---

## Quick Validation (Before /work:save)

Run these checks before saving work:

### Epic Tasks
```bash
/work:validate E###
# → ✅ Consistent: Tasks in table match Tasks/ folder
# → ⚠️ Legacy format: Found old pattern (optional migration)
# → ❌ MISMATCH: Out of sync
```

### Individual Task
```bash
/work:validate E###-T###
# → ✅ Consistent: Subtasks table matches filesystem
# → ⚠️ Legacy format: Found _subtasks-index.md
# → ❌ MISMATCH: File column inconsistent
```

### Full Validation with Sync (NEW)
```bash
/work:validate --full          # All items in project
/work:validate --sync          # Auto-fix File column inconsistencies
/work:validate --migrate       # Consolidate old _subtasks-index.md → table
```

---

## Common Issues & Fixes

### Issue: "File column has link but file doesn't exist"
**Symptom**: `/work:validate` reports broken link
**Cause**: File deleted manually, or link added without creating file
**Fix**:
- Option A: Remove link, set to — (inline only)
- Option B: Create the ST###.md file matching link

### Issue: "Subtasks table missing"
**Symptom**: Task-context.md has no Subtasks section
**Cause**: Old template used (pre-SSOT migration), or manual deletion
**Fix**: Add `## Subtasks` section with table after "Relevant Files"

### Issue: "Old _subtasks-index.md found"
**Symptom**: `/work:validate` warns "legacy format"
**Cause**: Task not yet migrated from old pattern
**Fix**:
- Option A: Use `/work:validate --migrate` to auto-consolidate
- Option B: Manual migration (copy table to context.md, delete index file)

### Issue: "Orphaned subtask file (ST###.md exists but no table entry)"
**Symptom**: ST###.md file in Subtasks/ but not in table
**Cause**: File created manually without adding table entry
**Fix**:
- Option A: Add table row with File column = link to file
- Option B: Delete orphaned file if not needed

---

## Comprehensive Validation Checklist (Full)

### SSOT (Single Source of Truth) Validation

**Subtask Status SSOT**:
- [ ] Subtasks table in task-context.md is used as source of truth (NOT individual ST###.md files)
- [ ] Status column in table reflects current status (⚪🟡🟢🔴⬛)
- [ ] Individual ST###.md files (if exist) have optional status field (can be cache/stale)
- [ ] Commands only update table (never read individual file status as truth)
- [ ] After `/work:save`: Table status updated, individual files optionally updated

**Subtask Metadata SSOT**:
- [ ] ID: Subtasks table has ST### format (matches filename if file exists)
- [ ] Name: Table has subtask name (consistent with file if exists)
- [ ] File column: Accurately reflects filesystem (link or em-dash)

**Task Tracking SSOT**:
- [ ] Task-context.md is source of truth for task requirements and progress
- [ ] Subtasks table is source of truth for subtask list and status
- [ ] Git Tracking section is source of truth for branch/commit/PR info

### Granularity Validation

**Subtask Size Check**:
- [ ] Each subtask fits within 15min-2hr window (not too small, not too large)
- [ ] Subtask has single, focused purpose (atomic)
- [ ] Can be tested independently
- [ ] Too-small subtasks merged with adjacent subtasks
- [ ] Too-large subtasks split into multiple subtasks

**File/Inline Decision Validation**:
- [ ] Substantial subtasks (> 30min): Have individual ST###.md file
- [ ] Simple subtasks (< 15min): Inline only (File column = —)
- [ ] ST###.md exists ↔ File column has link (bidirectional)
- [ ] File column = — ↔ NO ST###.md file (bidirectional)

### Context Loading Validation

**Progressive Disclosure Checks**:
- [ ] Epic context: High-level strategy, business value (no implementation details)
- [ ] Task context: Detailed requirements and approach (no line-by-line code)
- [ ] Subtask file: Exact changes, implementation details (maximum depth)
- [ ] Each layer can stand alone (progressive reading possible)

**Token Efficiency Checks**:
- [ ] Layer 1 (Epic): ~1-1.5k tokens
- [ ] Layer 2 (Task): ~3-4k tokens
- [ ] Layer 3 (Subtask): ~2.5-3.5k tokens
- [ ] Total for deep work: ~10k tokens available
- [ ] Detail not unnecessarily duplicated across layers

### Progress Tracking Validation

**3-Level Progress System** (no duplication):
- [ ] **Level 1**: Task Progress Log (session summaries) - Checked before `/work:save`
- [ ] **Level 2**: Subtasks table Status column (current completion %) - Updated by save
- [ ] **Level 3**: Individual ST###.md Progress Log (implementation notes) - Optional cache
- [ ] No info duplicated between levels
- [ ] Each level serves distinct purpose

**Status Consistency**:
- [ ] All subtask statuses in table are valid (⚪🟡🟢🔴⬛)
- [ ] Status reflects actual completion (not "done" if tests failing)
- [ ] After `/work:save`: Table updated with current session's progress

### File Column Consistency Validation

**The 3 Checks**:
- [ ] **Check 1**: Every link in File column → file exists at path
- [ ] **Check 2**: Every ST###.md file → has table entry with link
- [ ] **Check 3**: Every em-dash → NO corresponding ST###.md file exists
- [ ] All 3 checks pass = File column is consistent

**Broken State Recovery**:
- [ ] No orphaned files (ST###.md with no table entry)
- [ ] No broken links (link to non-existent file)
- [ ] No inconsistent dashes (dash but file exists)
- [ ] Use `/work:validate --sync` to auto-fix if needed

### Legacy Format Detection

**Old Pattern Checks**:
- [ ] No `_subtasks-index.md` files in Subtasks/ folders (if found: warn about legacy format)
- [ ] No duplicate Subtasks tables (one in context.md + one in index = error)
- [ ] If legacy format found: Offer migration via `/work:validate --migrate`

---

## Validation Rules Summary

| Check | Level | Automatic? | Action |
|-------|-------|-----------|--------|
| **Structure** | Epic/Task | On create | `/work:epic-new`, `/work:task-new` |
| **Content** | Epic/Task | Manual | Review before save |
| **Hierarchy** | Epic | `/work:validate` | Detects orphaned tasks |
| **Subtasks Table** | Task | On create | `/work:task-new` creates empty table |
| **File Column** | Task | `/work:validate` | Detects broken links, orphaned files |
| **Status Values** | Task | Manual | Checked during `/work:save` |
| **Legacy Format** | Task | `/work:validate` | Warns if _subtasks-index.md found |

---

## Related Documentation

- **Work System**: `@agent_docs/work-management-system.md`
- **SSOT Pattern**: See "Single Source of Truth (SSOT)" section
- **File Column Semantics**: See "Subtask Data" section
- **Context Loading**: See "Progressive Disclosure" section
- **Examples**: `@agent_docs/_examples/`

---

**Last Updated**: 2026-01-20
**Pattern**: Subtask Index Removal (SSOT Enforcement)
