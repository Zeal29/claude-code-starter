---
description: Generate handoff with next steps for session continuity (any context %)
model: sonnet
allowed-tools: [Bash, Read, Write, Edit, Glob]
---

Generate handoff: $ARGUMENTS

## What This Command Does

Creates an intelligent handoff file with auto-generated next steps for session continuity. Works at ANY context percentage (manual checkpoint).

**Key Features:**
- WHAT/WHY/HOW knowledge preservation template
- Dynamic step count (2-10 based on remaining work)
- approve/reject/edit flow
- No auto-commits (user has full git control)

---

## Phase 1: Determine Target Work Item

### If No Arguments Provided

1. Read `docs/_index.md`
2. Find `**Last worked on**: <ID> - <name>`
3. Extract work item ID

### If Argument Provided

Use the provided ID directly (e.g., `E001-T002`)

### Multiple Active Tasks Detection

If you need to determine the active work item:
1. Check recent git commits (last 10) for work item references
2. If ambiguous, ask user: "Generate handoff for which item? [List options]"

### Parse Work Item Type

From the ID, determine type:
- `E###` (e.g., E001) → Epic
- `E###-T###` (e.g., E001-T002) → Epic Task
- `T###` (e.g., T042) → Standalone Task

Store: `WORK_ID`, `WORK_TYPE`

**If target not found**: List available work items from `_index.md` and exit

---

## Phase 2: Locate Context File

Use Glob tool with patterns based on work type:

**Epic (E###):**
```
Pattern: docs/epics/E###-*/E###-context.md
Example: docs/epics/E001-integrate-context/E001-context.md
```

**Epic Task (E###-T###):**
```
Epic Pattern: docs/epics/E###-*/
Task Pattern: {epic_folder}/Tasks/E###-T###-*/T###-context.md
Example: docs/epics/E001-.../Tasks/E001-T002-check-context/T002-context.md
```

**Standalone Task (T###):**
```
Pattern: docs/tasks/T###-*/T###-context.md
Example: docs/tasks/T042-fix-bug/T042-context.md
```

Store: `CONTEXT_FILE_PATH`, `WORK_FOLDER`

**If context file not found**: Error with troubleshooting steps

---

## Phase 3: Calculate Dynamic Step Count

1. **Read context file `## Requirements` section**
2. **Count unchecked items**: `- [ ] Requirement X`
3. **Calculate step count:**

```
remaining_work = count of unchecked requirements

if remaining_work == 0:
    step_count = 3  # All done, generate polish/test/doc steps
elif remaining_work <= 3:
    step_count = remaining_work  # Just finish what's left
else:
    step_count = min(remaining_work, 5)  # Normal case

# Cap between 2-10
step_count = max(2, min(10, step_count))
```

**Display calculation:**
```
📊 Step Calculation:
- Requirements remaining: {remaining_work}
- Generated steps: {step_count}
```

Store: `STEP_COUNT`

---

## Phase 4: Analyze & Generate Next Steps

### Sub-phase 4A: Gather Context

**Run git commands:**
```bash
git log --oneline -15
git diff --stat HEAD~5..HEAD
```

**Read from context file:**
- `## Objective` - What we're building
- `## Requirements` - Full checklist
- `## Approach` - How we're solving it
- `## Progress Log` - Recent sessions
- `## Current Focus` - Active state

**If git log is empty**: Use only context file for generation

### Sub-phase 4B: Generate Steps with AI

Using the gathered context, generate `STEP_COUNT` next steps that are:

**Quality Criteria:**
- Start with action verb (Implement, Create, Add, Fix, Test, Update, Write)
- Reference specific files/components from THIS project
- Include "Why" (rationale for the step)
- Include "Files" (which files will be affected)
- Sequenced logically (don't test before building)
- Atomic (one clear action per step)
- Build on completed work

**Format for each step:**
```markdown
- [ ] **Step N**: [Specific, actionable task]
  - _Why_: [Brief rationale]
  - _Files_: [Affected files]
```

**Example of GOOD steps:**
```markdown
- [ ] **Step 1**: Implement refresh token rotation in auth.service.ts
  - _Why_: Improve security by limiting token lifetime
  - _Files_: src/services/auth.service.ts, src/types/auth.ts

- [ ] **Step 2**: Add email verification endpoint POST /api/auth/verify
  - _Why_: Complete user registration flow
  - _Files_: src/routes/auth.ts, src/services/email.service.ts

- [ ] **Step 3**: Write integration tests for password reset flow
  - _Why_: Ensure reset flow works end-to-end
  - _Files_: __tests__/auth/password-reset.spec.ts
```

**Example of BAD steps (REJECT THESE):**
```markdown
- [ ] **Step 1**: Continue working on the feature
- [ ] **Step 2**: Add more tests
- [ ] **Step 3**: Fix any bugs
```

**If steps are too generic**: Regenerate or note for user review

Store: `GENERATED_STEPS[]`

---

## Phase 5: User Approval Flow

### Check for Auto-Approve

**Check flag:**
```
If $ARGUMENTS contains --auto-approve:
  → Skip approval, proceed to Phase 6
```

**Check settings preference:**
Read `.claude/settings.json`:
```json
{
  "checkpoint": {
    "auto_approve": true
  }
}
```
If auto_approve = true → Skip approval, proceed to Phase 6

### Display Summary

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ HANDOFF GENERATION SUMMARY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📁 Work Item: {WORK_ID} - {WORK_NAME}
📄 Context File: {CONTEXT_FILE_PATH}

✅ Work Completed This Session:
{List from git log - recent commits}

📋 GENERATED NEXT {STEP_COUNT} STEPS:
{Display all generated steps with Why + Files}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🤔 APPROVAL REQUIRED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Approve this handoff?

1. approve - Save as-is
2. edit - Modify steps before saving
3. reject - Cancel, don't save

Your choice [1/2/3]: _
```

### Handle User Response

**Option 1 - Approve:**
- User inputs: "1" or "approve" or "yes"
- → Proceed to Phase 6

**Option 2 - Edit:**
- User inputs: "2" or "edit"
- → Display steps in editable format
- → "Please modify the steps below, then respond 'done' when ready:"
- → User provides edited steps
- → Validate edited steps (same quality criteria)
- → Proceed to Phase 6 with edited steps

**Option 3 - Reject:**
- User inputs: "3" or "reject" or "no"
- → Display: "🚫 Handoff cancelled. No files modified."
- → Exit cleanly, no changes

---

## Phase 6: Save Handoff

### Sub-phase 6A: Check for Existing Handoff

**Read handoff file status:**
```
Path: {WORK_FOLDER}/Handoff/handoff.md

If file exists:
  - Read frontmatter status field
  - If status = "completed":
    → Archive to Archive/handoff-{timestamp}.md
    → Create new handoff.md
  - If status = "open" or "in-progress":
    → Ask: "Existing handoff not completed. (1) Complete it first (2) Archive and create new"
    → Handle response
```

### Sub-phase 6B: Create Handoff Structure

**If Handoff/ folder doesn't exist:**
```bash
Create: {WORK_FOLDER}/Handoff/
Create: {WORK_FOLDER}/Handoff/Archive/
Create: {WORK_FOLDER}/Handoff/Drafts/
```

### Sub-phase 6C: Fill Handoff Template

**Read from context file:**
- WHAT: From `## Objective` section
- WHY: From context or infer from `## Requirements`
- HOW: From `## Approach` section
- BLOCKERS: From `## Current Focus → Blocker`

**Analyze from git:**
- Work completed: From git log
- Key decisions: From commit messages + context
- Current state: From git diff + context

**Handoff Template:**
```yaml
---
id: handoff-{YYYYMMDD-HHMMSS}
created: {YYYY-MM-DD HH:MM:SS}
status: open
work_item: {WORK_ID}
context_at_creation: {CONTEXT_%}
steps_total: {STEP_COUNT}
steps_completed: 0
modified_via_draft: []
---

# Handoff: {WORK_ITEM_NAME}

## 📋 WHAT (Objective)
**What are we trying to accomplish?**
{From context ## Objective}

## 🎯 WHY (Rationale)
**Why is this important? What problem does it solve?**
{Infer from context or Requirements}

## 🛠️ HOW (Approach)
**How are we going to do it? What's the strategy?**
{From context ## Approach}

## 🔍 CONTEXT (Background)

### Work Completed This Session
{From git log - list commits}

### Current State
- **Status**: {From context ## Current Focus}
- **Files Modified**: {From git diff --stat}
- **Tests Status**: {Infer or from context}
- **Known Working**: {From context or commits}

### Key Decisions Made
{Extract from commit messages or context}

### Learnings & Insights
{From context ## Progress Log or infer}

## ✅ STEPS (Actions)
**Generated steps in priority order:**

{GENERATED_STEPS with checkboxes, Why, Files}

## 🚧 BLOCKERS & DEPENDENCIES
**What's blocking progress or needs attention?**
{From context ## Current Focus → Blocker}
{If none: "- _None_"}

## 🔗 REFERENCES
**Links to relevant resources:**
- Requirements: {Link to context file ## Requirements}
- Research: {Link to Research/ if exists}
- Related PRs: {From context if any}

## 📝 NOTES
**Additional context for next session:**
{Any important notes from context or git analysis}

## 🔄 HOW TO RESUME
1. Read this handoff completely
2. Read {CONTEXT_FILE_PATH} for full context
3. Start with Step 1 above
4. Check off steps as you complete them
5. Run `/work:complete-handoff` when all steps done

---
**Generated by**: `/work:generate-handoff` at {CONTEXT_%}
```

**Write file:**
```
Path: {WORK_FOLDER}/Handoff/handoff.md
Content: {Filled template above}
```

### Sub-phase 6D: Update Context File Progress Log

**Append to `## Progress Log`:**

```markdown
### Session {YYYY-MM-DD}
- **[CHECKPOINT] at {CONTEXT_%} context**
  - Context Usage: {CONTEXT_%}
  - Work Completed This Session:
    {Bullet list from git log}
  - Generated Next {STEP_COUNT} Steps:
    {List the step titles, not full details}
  - Handoff File: `Handoff/handoff.md`
- **Current State**: Handoff saved, ready for next session
- **Next Step**: Run /clear (optional), then /work:resume {WORK_ID}
- **Blocker**: None
```

**Update Meta section:**
```yaml
updated: {YYYY-MM-DD}
```

Use Edit tool to append to Progress Log and update Meta.

### Sub-phase 6E: Success Message

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ HANDOFF SAVED SUCCESSFULLY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📁 Files Created/Updated:
   ✓ Handoff/handoff.md (status: open, {STEP_COUNT} steps)
   ✓ {CONTEXT_FILE_PATH} (Progress Log updated with [CHECKPOINT])

📊 Handoff Details:
   ✓ Context at creation: {CONTEXT_%}
   ✓ Steps generated: {STEP_COUNT}
   ✓ Status: open

💡 Recommended Actions:
   1. Commit handoff manually:
      git add {WORK_FOLDER}/Handoff/ {CONTEXT_FILE_PATH}
   2. Commit message: "checkpoint: handoff created at {CONTEXT_%} context"
   3. Run: /clear (optional - start fresh session)
   4. Run: /work:resume {WORK_ID}
   5. Follow steps in Handoff/handoff.md

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Ready to continue or start next session!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Error Handling

**No active work found:**
```
❌ No active work item found

Available items:
{List from docs/_index.md}

Use /work:generate-handoff <ID> to specify which item.
```

**Context file not found:**
```
❌ Context file not found for {WORK_ID}

Troubleshooting:
- Verify work item exists in docs/_index.md
- Check folder structure matches pattern
- Run /work:status to see all items
```

**Git commands fail:**
```
⚠️  Git history unavailable (no repository or no commits)
Generating handoff based on context file only...
```

**Invalid user input:**
```
Invalid choice. Please enter 1 (approve), 2 (edit), or 3 (reject).
```

---

## Notes

- This command works at ANY context percentage (manual override)
- Use `/work:check-context` for automatic 70% threshold checking
- User commits manually (full git control, no auto-commits)
- Handoff uses WHAT/WHY/HOW template for knowledge preservation
- Dynamic step count (2-10) based on remaining Requirements
- State machine: open → in-progress → completed → archived
