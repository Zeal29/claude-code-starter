---
description: Thorough code review of recent changes or specified files
allowed-tools: [Read, Grep, Glob, Bash]
---

Review code: $ARGUMENTS

## Process
1. If no files specified, run `git diff HEAD~1` to see recent changes
2. Read each modified file completely
3. Analyze against checklist below
4. Provide feedback organized by priority

## Checklist
- [ ] Code is simple, readable, follows project conventions
- [ ] No exposed secrets, API keys, or hardcoded credentials
- [ ] Proper error handling (try/catch, Result types, error boundaries)
- [ ] Input validation on all external data
- [ ] No console.log left in (except intentional logging)
- [ ] TypeScript strict mode satisfied (no any, proper types)
- [ ] Tests added/updated for new functionality
- [ ] No obvious performance issues (N+1 queries, unnecessary re-renders)

## Output Format
**🚨 Critical** (must fix before merge)
**⚠️ Warning** (should fix)
**💡 Suggestion** (consider improving)
**✅ Good** (things done well)
