---
description: Mark handoff as complete and archive it
model: sonnet
allowed-tools: [Read, Edit, Bash, Glob]
---

Complete handoff: $ARGUMENTS

## What This Command Does

Marks an active handoff as completed after all steps are done, updates the handoff state machine, and archives it for future reference.

**State Transition:** `open` or `in-progress` → `completed` → archived to `Archive/`

---

## Phase 1: Determine Target Handoff

### If No Arguments Provided

1. Read `docs/_index.md`
2. Find `**Last worked on**: <ID> - <name>`
3. Extract work item ID
4. Look for handoff at: `{WORK_FOLDER}/Handoff/handoff.md`

### If Argument Provided

Use the provided ID directly (e.g., `E001-T002`)

### Parse Work Item Type

From the ID, determine type:
- `E###` (e.g., E001) → Epic
- `E###-T###` (e.g., E001-T002) → Epic Task
- `T###` (e.g., T042) → Standalone Task

Store: `WORK_ID`, `WORK_TYPE`

---

## Phase 2: Locate Handoff File

Use Glob tool with patterns based on work type:

**Epic (E###):**
```
Pattern: docs/epics/E###-*/Handoff/handoff.md
```

**Epic Task (E###-T###):**
```
Epic Pattern: docs/epics/E###-*/
Task Pattern: {epic_folder}/Tasks/E###-T###-*/Handoff/handoff.md
```

**Standalone Task (T###):**
```
Pattern: docs/tasks/T###-*/Handoff/handoff.md
```

Store: `HANDOFF_FILE_PATH`, `WORK_FOLDER`

**If handoff not found:**
```
❌ No active handoff found for {WORK_ID}

Available handoffs:
{List any handoff.md files found in work items}

Or create one with: /work:generate-handoff
```
Exit cleanly.

---

## Phase 3: Read and Validate Handoff

Read the handoff file and parse frontmatter:

```yaml
status: open | in-progress  # Must be one of these to complete
steps_total: N
steps_completed: X
```

**Check status:**
- If `status: completed` or `status: archived`:
  ```
  ℹ️  Handoff already completed and archived.

  Archive location: Archive/handoff-{timestamp}.md
  ```
  Exit cleanly.

- If `status: open` or `status: in-progress`:
  → Proceed to Phase 4

---

## Phase 4: Count Completed Steps

Parse the `## STEPS (Actions)` section:

```markdown
- [x] **Step 1**: ... (completed)
- [x] **Step 2**: ... (completed)
- [ ] **Step 3**: ... (not done)
```

Count:
- `completed_steps` = count of `- [x]`
- `total_steps` = count of all steps

**Display summary:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 HANDOFF COMPLETION SUMMARY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Work Item: {WORK_ID} - {WORK_NAME}
Handoff: {HANDOFF_FILE_PATH}

Steps: {completed_steps}/{total_steps} completed

Status: {completed_steps == total_steps ? "✅ ALL DONE" : "⚠️  INCOMPLETE"}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Phase 5: Confirm Completion

**If steps incomplete (completed < total):**
```
⚠️  Only {completed_steps}/{total_steps} steps completed.

Options:
1. Mark as complete anyway (force)
2. Keep working on remaining steps
3. Cancel

Your choice [1/2/3]: _
```

**Handle response:**
- `1` or `force` → Proceed to Phase 6
- `2` or `continue` → Exit with message: "Continue working, run /work:complete-handoff when done"
- `3` or `cancel` → Exit cleanly

**If all steps completed:**
→ Proceed to Phase 6

---

## Phase 6: Archive Handoff

### Sub-phase 6A: Update Handoff Status

Edit the handoff file frontmatter:

```yaml
status: completed
steps_completed: {completed_steps}
completed_at: {YYYY-MM-DD HH:MM:SS}
```

### Sub-phase 6B: Create Archive Copy

**Check Archive/ folder:**
```bash
Create if not exists: {WORK_FOLDER}/Handoff/Archive/
```

**Generate archive filename:**
```
Format: handoff-{YYYYMMDD-HHMMSS}.md
Example: handoff-20260117-153045.md
```

**Copy to archive:**
```bash
cp {WORK_FOLDER}/Handoff/handoff.md {WORK_FOLDER}/Handoff/Archive/handoff-{timestamp}.md
```

### Sub-phase 6C: Update Context File

Locate context file (same logic as Phase 2):
- Epic: `E###-context.md`
- Task: `T###-context.md`

**Append to `## Progress Log`:**
```markdown
### Session {YYYY-MM-DD} (Handoff Completed)
- **[HANDOFF COMPLETE]**
  - Completed {completed_steps}/{total_steps} steps
  - Archive: `Handoff/Archive/handoff-{timestamp}.md`
  - Work completed:
    {List completed steps titles}
- **Current State**: Handoff workflow complete
- **Next Step**: Continue with remaining task work or mark task done
```

**Update Meta section:**
```yaml
updated: {YYYY-MM-DD}
```

### Sub-phase 6D: Clean Up Active Handoff

**Option 1 - Delete active handoff:**
```bash
rm {WORK_FOLDER}/Handoff/handoff.md
```

**Option 2 - Keep with "completed" status:**
Leave the file as-is (user can manually delete)

**Recommended:** Delete it (keeps workspace clean, archive has full copy)

---

## Phase 7: Success Message

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ HANDOFF COMPLETED & ARCHIVED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📁 Files Updated:
   ✓ Handoff archived to: Archive/handoff-{timestamp}.md
   ✓ Context file updated: {CONTEXT_FILE_PATH}
   ✓ Active handoff cleaned up

📊 Summary:
   ✓ Steps completed: {completed_steps}/{total_steps}
   ✓ Status: completed
   ✓ Archived at: {TIMESTAMP}

💡 Recommended Actions:
   1. Review completed work in context file
   2. If task done, run: /work:status {WORK_ID}
   3. If more work needed, run: /work:generate-handoff (create new handoff)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Ready to continue or mark task complete!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Error Handling

**No handoff found:**
```
❌ No active handoff found for {WORK_ID}

This work item doesn't have a handoff file.

To create one: /work:generate-handoff
```

**Handoff already completed:**
```
ℹ️  This handoff was already completed.

Archive: Archive/handoff-{timestamp}.md
Completed: {DATE}
```

**Archive folder creation fails:**
```
⚠️  Could not create Archive/ folder.

Check permissions and try again.
```

---

## Examples

**Example 1: Complete with all steps done**
```
User: /work:complete-handoff

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 HANDOFF COMPLETION SUMMARY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Work Item: E001-T002 - Check Context Command
Handoff: .../E001-T002-check-context-command/Handoff/handoff.md

Steps: 3/3 completed
Status: ✅ ALL DONE

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ HANDOFF COMPLETED & ARCHIVED

Archive: Archive/handoff-20260117-153000.md
```

**Example 2: Incomplete steps with force**
```
User: /work:complete-handoff E001-T003

Steps: 2/5 completed
Status: ⚠️  INCOMPLETE

⚠️  Only 2/5 steps completed.

Options:
1. Mark as complete anyway (force)
2. Keep working on remaining steps
3. Cancel

Your choice: 1

✅ HANDOFF COMPLETED & ARCHIVED (forced)
```

---

## Notes

- Completes the handoff state machine lifecycle
- Archives preserve full history for future reference
- Multiple handoffs can exist in Archive/ folder
- Active handoff.md is deleted after archiving (clean workspace)
- Context file Progress Log maintains complete audit trail
