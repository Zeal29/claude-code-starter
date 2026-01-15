---
description: Create pull request with proper description
allowed-tools: [Bash, Read, Grep]
---

Create a PR for current branch.

## Process
1. Get current branch: `git branch --show-current`
2. Get commit history vs main: `git log main..HEAD --oneline`
3. Analyze changes: `git diff main..HEAD --stat`
4. Generate PR description
5. Create PR: `gh pr create --title "..." --body "..."`

## PR Template
```markdown
## Summary
[1-2 sentence overview]

## Changes
- [bullet points of main changes]

## Testing
- [ ] Unit tests added/updated
- [ ] Manual testing done
- [ ] No regressions in existing tests

## Screenshots (if UI)
[if applicable]

## Notes for Reviewers
[anything reviewer should know]
```

## Rules
- Title: same format as commit messages
- Link related issues: "Closes #123" or "Relates to #456"
- Keep description concise but complete
