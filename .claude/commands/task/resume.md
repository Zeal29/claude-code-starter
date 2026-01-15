---
description: Resume work from saved task context
allowed-tools: [Read, Glob, Grep]
---

Resume work from task context file.

## Process
1. Read `docs/tasks/current-task.md`
2. Summarize for user:
   - **Objective**: What we're trying to do
   - **Status**: Current progress (X of Y requirements done)
   - **Last Session**: What was accomplished
   - **Next Step**: What to do now
   - **Blockers**: Any issues to address

3. Read any Relevant Files listed in task context
4. Ask user: "Ready to continue with [Next Step]? Or do you want to do something else?"

## Rules
- Don't start coding until user confirms direction
- If task file is empty/template, ask user what they want to work on
- If multiple tasks exist, list them and ask which to resume
