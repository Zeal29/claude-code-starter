---
description: Log debug findings and close session
allowed-tools: [Read, Write, Edit]
---

Log debug findings: $ARGUMENTS

## Argument Parsing
Format: `<TASK_ID> [session-folder]`
- If session-folder omitted: Use most recent session

## Process

1. **Locate debug session**
   - Find most recent or specified session in Debug/

2. **Analyze conversation**
   - What hypotheses were tested?
   - What was confirmed/rejected?
   - What was the root cause?
   - What fix was applied?

3. **Update session.md**:
   - Set `resolved: true/false`
   - Fill in `resolution` if resolved
   - Update hypotheses statuses

4. **Update hypotheses.md**:
   - Mark each hypothesis as ✅ Confirmed / ❌ Rejected / ⬜ Not tested

5. **Save logs** (if provided):
   - Save console output to `logs/console-N.txt`
   - Save network logs to `logs/network-N.txt`

6. **If resolved, update task context**:
   - Add to Progress Log: "Fixed: {{ISSUE}}"
   - Link to debug session
   - Remove [DEBUG_TRACE] logs from code

7. **Report**:
```
## 🔍 Debug Session {{STATUS}}

**Root Cause**: {{ROOT_CAUSE}}
**Fix Applied**: {{FIX}}
**Files Changed**: {{FILES}}

### Hypothesis Results
- ✅ {{H1}}: Confirmed - {{RESULT}}
- ❌ {{H2}}: Rejected - {{RESULT}}

### Prevention
{{HOW_TO_PREVENT}}

Session saved to: {{PATH}}
```

## If Not Resolved
```
## 🔍 Debug Session Paused

**Status**: Unresolved
**Findings so far**: {{FINDINGS}}
**Next steps**: {{WHAT_TO_TRY}}

Resume with /debug:start {{TASK_ID}} "{{ISSUE}}"
```
