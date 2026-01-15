---
description: Start a new task with fresh context file
allowed-tools: [Read, Write, Edit, Glob]
---

Start a new task: $ARGUMENTS

## Process
1. Check if `docs/tasks/current-task.md` has active work
   - If yes, ask user: "Current task has progress. Archive it first? (y/n)"
   - If user says yes, move to `docs/tasks/archive/YYYY-MM-DD-[name].md`

2. Create fresh `docs/tasks/current-task.md` with:
```markdown
# Current Task

## Context
**Created**: [TODAY'S DATE]
**Status**: 🟡 In Progress
**Epic**: None

## Objective
[From $ARGUMENTS or ask user]

## Requirements
- [ ] [Break down objective into requirements]
- [ ] [Ask user if unclear]

## Relevant Files
- [Identify files related to this task]

## Approach
[Propose approach, ask user to confirm]

## Progress Log
### Session [TODAY'S DATE]
- Task created
- [Initial analysis]

## Assumptions
- [List initial assumptions]

## Unanswered Questions
- [ ] [Questions to clarify with user]

## Debug Notes
```

3. Present task summary to user
4. Ask: "Ready to start? Or should I adjust the requirements/approach?"

## Rules
- Always confirm approach before coding
- Break vague objectives into concrete requirements
- Identify relevant files upfront
