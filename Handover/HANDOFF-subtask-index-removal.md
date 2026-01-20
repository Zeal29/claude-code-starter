---
id: handoff-20260120-subtask-index-removal
created: 2026-01-20
status: open
work_item: Progressive Disclosure Refactor - Subtask Index Removal
context_at_creation: 83%
steps_total: 10
steps_completed: 6
---

# Handoff: Remove Subtask Index Files & Enforce SSOT

## 📋 WHAT (Objective)

Remove `_subtasks-index.md` files throughout the project and consolidate subtask tracking into task-context.md files. This enforces Single Source of Truth (SSOT) for subtask data and eliminates duplication between index files and task context files.

## 🎯 WHY (Rationale)

**Problem**: Current architecture violates SSOT principle:
- Subtask details exist in TWO places: `_subtasks-index.md` AND individual subtask files
- Creates sync issues and maintenance burden
- Confuses developers about which is authoritative

**Solution**: Move subtask table INTO task-context.md:
- ONE table per task (SSOT enforced)
- Individual ST###.md files optional (for substantial subtasks)
- File column shows link when file exists, "—" when inline-only

## 🛠️ HOW (Approach)

**16-step implementation plan:**

**Phase 1: Templates & Commands** (Steps 1-5) ✅ COMPLETE
- Update task-context.template.md with Subtasks section
- Delete subtasks-index.template.md
- Update commands: subtask-add.md, task-new.md, draft-process.md

**Phase 2: Data Migration** (Step 6) ✅ COMPLETE
- Migrated 8 existing _subtasks-index.md files to parent task-context.md
- Preserved all notes, updated File column format
- Deleted all 8 index files

**Phase 3: Documentation** (Steps 7-16) ⚠️ IN PROGRESS
- Update work-management-system.md with new pattern
- Update examples to show new structure
- Add validation rules, SSOT docs, context loading strategy
- Add granularity guidelines, progress tracking clarification

## 🔍 CONTEXT (Background)

### Work Completed This Session

**✅ Templates Updated:**
1. `claude-code-starter/docs/_templates/task-context.template.md`
   - Added "## Subtasks" section after Definition of Done
   - Removed pointer to _subtasks-index.md (line 40)
   - Table format: `| ID | Name | Status | File |`

2. `claude-code-starter/docs/_templates/subtasks-index.template.md`
   - **DELETED** (no longer needed)

**✅ Commands Updated:**
3. `claude-code-starter/.claude/commands/work/subtask-add.md`
   - Now updates task-context.md table (not index file)
   - References granularity guidelines

4. `claude-code-starter/.claude/commands/work/task-new.md`
   - Removed _subtasks-index.md creation
   - Creates empty Subtasks/ folder only

5. `claude-code-starter/.claude/commands/work/draft-process.md`
   - Updates task-context.md table when creating subtasks
   - File column logic: substantial → link, simple → "—"

**✅ Data Migration Complete:**
6. Migrated **8 files** (7 epic tasks + 1 standalone):
   - `docs/tasks/T001-.../Subtasks/_subtasks-index.md` → T001-context.md
   - `docs/epics/E001-.../Tasks/E001-T001-.../Subtasks/_subtasks-index.md` → T001-context.md
   - `docs/epics/E001-.../Tasks/E001-T002-.../Subtasks/_subtasks-index.md` → T002-context.md
   - `docs/epics/E001-.../Tasks/E001-T003-.../Subtasks/_subtasks-index.md` → T003-context.md
   - `docs/epics/E001-.../Tasks/E001-T004-.../Subtasks/_subtasks-index.md` → T004-context.md
   - `docs/epics/E001-.../Tasks/E001-T005-.../Subtasks/_subtasks-index.md` → T005-context.md
   - `docs/epics/E001-.../Tasks/E001-T006-.../Subtasks/_subtasks-index.md` → T006-context.md
   - `docs/epics/E001-.../Tasks/E001-T007-.../Subtasks/_subtasks-index.md` → T007-context.md
   - All notes preserved, File column added, all index files deleted

### Current State

- **Status**: Phase 2 complete (6/16 steps done = 37.5%)
- **Files Modified**: 11 files (3 templates, 3 commands, 1 deleted, 8 migrated data files)
- **Tests Status**: Not yet run (validation needed)
- **Known Working**: Template structure validated, migration completed successfully
- **Context Usage**: 83% (103k/200k tokens)

### Key Decisions Made

1. **Table Placement**: After Definition of Done section (not after Approach)
   - User preference: keeps implementation strategy together
   - More logical flow: WHAT→WHY→HOW→SUBTASKS→DoD

2. **File Column Format**: Relative path with `./`
   - `[ST001-name.md](./Subtasks/ST001-name.md)` when file exists
   - `—` when inline-only

3. **Status SSOT**: task-context.md table is authoritative
   - Individual file YAML is cache (allowed to be stale)
   - Commands update table only

4. **Migration Strategy**: Manual (not automated)
   - Only 8 files to migrate
   - Allows careful validation per task
   - Notes preserved without loss

### Learnings & Insights

- **Progressive disclosure works**: 3-layer architecture (Epic→Task→Subtask) maintained
- **Migration revealed patterns**: Most tasks have 3-9 subtasks, notes were valuable
- **File column flexibility**: Supporting both inline and file-based subtasks is critical
- **SSOT enforcement**: Moving from 2 sources (index + file) to 1 source (table) simplifies dramatically

## ✅ STEPS (Actions)

**Remaining work - 10 documentation steps:**

### Step 7: Update Work-Management-System Documentation
- [ ] **Step 7**: Update work-management-system.md with new subtask pattern
  - _Why_: Core documentation must reflect new SSOT architecture
  - _Files_: `claude-code-starter/agent_docs/work-management-system.md` (lines 140-178)
  - _What_: Replace "Subtask Data" section showing index file → show table as SSOT
  - _Details_: Document table format, File column values, state update flow

### Step 8: Update Example Task File
- [ ] **Step 8**: Update TXXX-context.example.md with subtask table example
  - _Why_: Examples guide users on correct usage
  - _Files_: `claude-code-starter/agent_docs/_examples/EXXX-example-feature/Tasks/EXXX-TXXX-example-task/TXXX-context.example.md` (line 78)
  - _What_: Replace pointer with full table showing both inline and file-based subtasks
  - _Example rows_: ST001-ST002 inline (File="—"), ST003-ST004 with files (File=link)

### Step 9: Delete Example Index File
- [ ] **Step 9**: Delete _subtasks-index.example.md
  - _Why_: Remove outdated example showing old pattern
  - _Files_: `claude-code-starter/agent_docs/_examples/EXXX-example-feature/Tasks/EXXX-TXXX-example-task/Subtasks/_subtasks-index.example.md`
  - _What_: DELETE entire file

### Step 10: Update Validation Checklist (Basic)
- [ ] **Step 10**: Add basic subtask validation rules to validation-checklist.md
  - _Why_: Ensure new pattern is validated correctly
  - _Files_: `claude-code-starter/agent_docs/validation-checklist.md` (lines 32, 44, 155-157)
  - _What_: Add checks for table format, File column, no orphaned index files

### Step 11: Add Status SSOT Documentation
- [ ] **Step 11**: Document status update flow in work-management-system.md
  - _Why_: Clarify SSOT for status (table vs individual file YAML)
  - _Files_: `claude-code-starter/agent_docs/work-management-system.md` (new section after Subtask Data)
  - _What_: Explain table Status column is authoritative, file YAML is cache
  - _Details_: Update flow, rationale, commands affected (save.md, subtask-add.md)

### Step 12: Add Context Loading Strategy Documentation
- [ ] **Step 12**: Document 3-layer context loading strategy in work-management-system.md
  - _Why_: AI needs clear guidance on what to load when resuming subtasks
  - _Files_: `claude-code-starter/agent_docs/work-management-system.md` (new section after Progressive Disclosure)
  - _What_: Layer 3 (subtask) → Layer 2 (task) → Layer 1 (epic)
  - _Details_: Token budget (~2.5-5.5k total), sections to load, optimization tips

### Step 13: Add File Column Validation Rules
- [ ] **Step 13**: Add file consistency validation to validate.md command
  - _Why_: Detect mismatches between table File column and filesystem
  - _Files_: `claude-code-starter/.claude/commands/work/validate.md`
  - _What_: Check 1 (link→file exists), Check 2 (file→link exists), Check 3 (em-dash→no file)
  - _Details_: Add --sync flag to auto-fix mismatches

### Step 14: Add Subtask Granularity Guidelines
- [ ] **Step 14**: Document subtask sizing guidelines in work-management-system.md
  - _Why_: Help users create appropriately-sized subtasks
  - _Files_: `claude-code-starter/agent_docs/work-management-system.md` (new section in Subtasks)
  - _What_: Ideal = 15min-2hr, 1-3 files, atomic deliverable
  - _Details_: Too small → merge, too large → split into siblings (NO sub-subtasks)

### Step 15: Add Progress Tracking Clarification
- [ ] **Step 15**: Add progress tracking clarification to task-context.template.md
  - _Why_: Reduce confusion about when to use which progress log
  - _Files_: `claude-code-starter/docs/_templates/task-context.template.md` (bottom), `docs/_templates/subtask.template.md`
  - _What_: 3 levels explained - Task Progress Log (session notes), Subtask Table (status), Subtask File Progress Log (implementation details)
  - _Details_: No duplication, each serves different purpose

### Step 16: Update Validation Checklist (Comprehensive)
- [ ] **Step 16**: Add comprehensive subtask validation checks to validation-checklist.md
  - _Why_: Complete validation coverage for new architecture
  - _Files_: `claude-code-starter/agent_docs/validation-checklist.md`
  - _What_: Structure checks, File consistency, Status consistency, Granularity, Context loading
  - _Details_: Full checklist matching all new patterns documented in Steps 11-15

## 🚧 BLOCKERS & DEPENDENCIES

**Current Blockers:**
- None

**Dependencies:**
- Steps 7-10 must complete before Steps 11-16 (basic docs before advanced)
- Step 13 (validation) references Step 11 (status SSOT) and Step 12 (file column semantics)
- Step 16 (comprehensive validation) depends on Steps 11-15 (must validate what's documented)

## 🔗 REFERENCES

**Plan File:**
- Full implementation plan: `C:\Users\pc\.claude\plans\immutable-roaming-oasis.md`

**Templates Modified:**
- Task context: `claude-code-starter/docs/_templates/task-context.template.md`
- Subtask: `claude-code-starter/docs/_templates/subtask.template.md`

**Commands Modified:**
- `claude-code-starter/.claude/commands/work/subtask-add.md`
- `claude-code-starter/.claude/commands/work/task-new.md`
- `claude-code-starter/.claude/commands/work/draft-process.md`

**Migration Results:**
- All 8 tasks: Check `docs/epics/E001-*/Tasks/E001-T00*/T00*-context.md` for migrated tables
- Standalone task: `docs/tasks/T001-fix-task-and-subtask-behaviour/T001-context.md`

**User Decisions:**
- Table placement: After Definition of Done (user preference over after Approach)
- Link format: Relative path with `./` prefix
- Status SSOT: Table is authoritative, file YAML is cache
- File validation: Add checks to /work:validate
- Granularity guidelines: 15min-2hr rule approved

## 📝 NOTES

**Critical Architecture Points:**
1. **SSOT Enforcement**: Subtask table in task-context.md is THE single source of truth
2. **File Column Semantics**: "—" = inline, link = individual file exists
3. **Optional Individual Files**: Only create ST###.md for substantial subtasks
4. **Backward Compatibility**: No breaking changes - existing workflow preserved

**Testing Needed (After Step 16):**
- Create new task with `/work:task-new "test-pattern"`
- Add subtask with `/work:subtask-add T999 "test subtask"`
- Verify: No `_subtasks-index.md` created, table in task-context.md
- Verify: Resume existing migrated task works correctly

**Git Strategy:**
- No commits made yet (user has full control)
- Recommend: Commit after Step 10 (basic docs), then after Step 16 (full completion)
- Suggested messages:
  - After Step 10: `refactor: complete subtask-index removal (basic docs)`
  - After Step 16: `docs: complete SSOT documentation and validation`

**Context Management:**
- Current: 83% (103k/200k)
- After /clear: Can resume with fresh context
- Handoff ensures continuity

## 🔄 HOW TO RESUME

1. **Read this handoff completely**
2. **Review plan file**: `C:\Users\pc\.claude\plans\immutable-roaming-oasis.md`
3. **Verify completed work**:
   - Check templates exist/updated
   - Check 8 migrated task-context.md files have Subtasks sections
   - Check no `_subtasks-index.md` files remain in docs/
4. **Start with Step 7** (work-management-system.md update)
5. **Work through Steps 7-16 sequentially**
6. **Test after Step 16** (validation)
7. **Commit when satisfied**

**Quick Resume:**
```bash
# After /clear or new session:
cd d:\Work\Templates\claude-code-starter-template-manager\claude-code-starter

# Start with Step 7 - update work-management-system.md
# See plan file for exact changes needed
```

---
**Generated manually at 83% context**
**Next session**: Continue from Step 7 (documentation updates)
**Estimated time remaining**: 40-50 minutes (Steps 7-16 are mostly documentation)
