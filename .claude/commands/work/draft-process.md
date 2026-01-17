---
description: Process a draft - read it and execute its intent
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep]
---

Process draft: $ARGUMENTS

## Argument Parsing
Format: `<ID> <draft-folder>`

## Pre-Processing

1. **Locate and read draft.md**
2. **Validate status is `ready`**
3. **Update status to `processing`**

## Processing Steps

1. **Parse Intent checklist**
   - Identify what actions are requested
   - Build action plan

2. **Read Supporting Files**
   - For each file in Supporting Files table
   - Read and understand context
   - Progressive disclosure: only read what's needed

2.5. **Extract WHY Context** (if "Update epic/task context" is checked):
   - Read draft Summary and Details sections
   - Extract key problem statements, decisions, discussion points
   - Generate Rationale (WHY) section content:
     - **Problem Context**: What problem is being solved, why it exists
     - **Approach Rationale**: Why this approach over alternatives
     - **Key Decisions**: Critical decisions made during discussion
   - Show extracted content to user for approval/editing
   - Prepare to insert into context file's Rationale section
   - Add archive reference comment: `<!-- Extracted from draft: Archive/{{DRAFT_ID}}/ -->`

3. **Execute Intent** (based on checked items):

   **If "Create new tasks":**
   - Parse task definitions from Details
   - Create task folders using task-new logic
   - Update epic context

   **If "Update epic/task context":**
   - Read current context file
   - Archive current version to `Archive/`
   - Update `_archive-index.md` with change summary
   - Insert extracted Rationale (WHY) section (from step 2.5) if user approved
   - Update other fields as needed (Requirements, Approach, etc.)
   - Write updated context with archive reference comment

   **If "Add to Research/":**
   - Create research document in Research/ folder
   - Link from context file

   **If "Update agent_docs/":**
   - Identify relevant agent_docs file
   - Update with new patterns/info
   - Or create new file if needed

   **If "Create subtasks":**
   - Parse subtask definitions
   - Create subtask files in Subtasks/
   - Update `_subtasks-index.md`

4. **Update Processing Log** in draft.md:
   - Set `processed_by`, `processed_at`, `status`
   - List Actions Taken
   - List Files Modified
   - Note any Errors/Warnings

5. **Move Draft to Archive** (if "Archive this draft: Yes"):
   - Move folder to `Archive/drafts/`
   - Or keep in Drafts/ with `completed` status

## Post-Processing

1. **Update draft status to `completed`** (or `failed` if errors)

2. **Report**:
```
✅ Draft processed successfully

## Actions Taken
- Created 3 new tasks: E001-T001, E001-T002, E001-T003
- Updated E001-context.md
- Added research doc: Research/api-comparison.md

## Files Modified
- docs/epics/E001-auth/E001-context.md
- docs/epics/E001-auth/Tasks/... (3 new folders)
- agent_docs/api-patterns.md

## Next Steps
- Review created tasks
- Start work with /task:resume E001-T001
```

## Error Handling
If processing fails:
- Set status to `failed`
- Log errors in Processing Log
- Report what succeeded and what failed
- User can fix and re-run
