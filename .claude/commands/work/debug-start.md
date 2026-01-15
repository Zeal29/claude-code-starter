---
description: Start a debug session for a task
allowed-tools: [Read, Write, Bash, Glob]
---

Start debugging: $ARGUMENTS

## Argument Parsing
Format: `<TASK_ID> "issue description"`

## Process

1. **Locate task** Debug/ folder

2. **Generate session folder name**
   - Format: `YYYY-MM-DD-session-N`
   - N = count of existing sessions today + 1

3. **Create debug session structure**:
```
Debug/YYYY-MM-DD-session-N/
├── session.md      # From template
├── hypotheses.md   # Tracking theories
└── logs/           # For console/network output
```

4. **Create session.md** from `docs/_templates/debug-session.template.md`
   - Fill in task ID and issue description
   - Initialize with empty hypotheses

5. **Initial analysis**:
   - Read task context to understand what we're working on
   - Read relevant files mentioned in task
   - Form initial hypotheses (2-3)

6. **Report**:
```
## 🔍 Debug Session Started

**Task**: {{TASK_ID}}
**Issue**: "{{ISSUE}}"
**Session**: {{SESSION_FOLDER}}

### Initial Hypotheses
1. **{{H1}}** ({{LIKELIHOOD}})
   - Test: {{HOW_TO_TEST}}
2. **{{H2}}** ({{LIKELIHOOD}})
   - Test: {{HOW_TO_TEST}}

### Next Steps
1. Add console.log with `[DEBUG_TRACE]` prefix at:
   - {{LOCATION_1}}
   - {{LOCATION_2}}
2. Run the app and trigger the issue
3. Paste logs back to me

Ready to add debug logging?
```

## Debug Workflow
1. Start session → form hypotheses
2. Add strategic logging
3. User runs app, pastes logs
4. Analyze → confirm/reject hypotheses
5. Fix root cause
6. Remove debug logging
7. Close session with findings
