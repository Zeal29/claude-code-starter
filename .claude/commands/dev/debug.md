---
description: Systematic debugging with hypothesis testing and console.log insertion
allowed-tools: [Read, Grep, Glob, Bash, Write, Edit]
---

Debug the issue: $ARGUMENTS

## Process
1. **Hypothesize** - Form 2-3 theories about possible causes
2. **Locate** - Find relevant code files using Grep/Glob
3. **Instrument** - Add strategic console.log with format:
   ```js
   console.log('[DEBUG_TRACE]', Date.now(), 'function_name', { relevantVars });
   ```
4. **Report** - Tell me what logs you added and where
5. **Wait** - I will run the code and paste runtime output
6. **Analyze** - Review logs I provide, identify root cause
7. **Fix** - Implement minimal fix addressing root cause
8. **Cleanup** - After I confirm fix works, remove all DEBUG_TRACE logs

## Rules
- Add logs at function entry, exit, and decision points
- Log variable values, not just "reached here"
- Keep hypotheses ranked by likelihood
- One fix at a time, verify before moving on
