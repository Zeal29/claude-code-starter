---
description: Create conventional commit with emoji prefix
allowed-tools: [Bash]
---

Create a commit for staged changes.

## Process
1. Run `git status` to see staged files
2. Run `git diff --cached` to analyze changes
3. Determine commit type and write message
4. Execute `git commit -m "message"`

## Commit Format
```
<emoji> <type>(<scope>): <description>

[optional body]
```

## Types & Emojis
- ✨ feat: new feature
- 🐛 fix: bug fix
- 📝 docs: documentation only
- 💄 style: formatting, no code change
- ♻️ refactor: code change, no new feature or fix
- ✅ test: adding/updating tests
- 🔧 chore: config, build, dependencies
- ⚡ perf: performance improvement
- 🔒 security: security fix

## Rules
- Description: imperative mood, lowercase, no period
- Max 50 chars for first line
- Scope: component/module affected (optional)
- Body: explain what and why, not how
