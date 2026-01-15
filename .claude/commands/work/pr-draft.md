---
description: Generate PR draft for a task
allowed-tools: [Read, Write, Bash, Glob, Grep]
---

Create PR draft: $ARGUMENTS

## Argument Parsing
Format: `<TASK_ID>`

## Process

1. **Read task context** to understand what was done

2. **Analyze git changes**:
```bash
git branch --show-current
git log main..HEAD --oneline
git diff main..HEAD --stat
```

3. **Create PR folder** if not exists: `PRs/`

4. **Generate PR draft** from `docs/_templates/pr-draft.template.md`
   - Filename: `YYYY-MM-DD-PR-draft.md`
   - Fill in all sections from task context and git analysis

5. **Auto-fill sections**:
   - **Title**: From task objective + conventional format
   - **Summary**: From task objective
   - **Changes**: From git diff --stat
   - **Type**: Infer from task name/changes
   - **Related Issues**: From task external_id

6. **Report**:
```
## 📝 PR Draft Created

**File**: {{PATH}}
**Branch**: {{BRANCH}} → main
**Commits**: {{COUNT}}

### Preview
---
**{{TITLE}}**

{{SUMMARY}}

**Changes**:
{{CHANGES_LIST}}
---

Review and edit the draft, then:
- Copy to GitHub/GitLab PR form
- Or use `gh pr create --body-file {{PATH}}`
```

## Git Tracking
After PR is submitted:
1. Update task context with PR number/URL
2. Change task status to `review`
3. Update master index

## Multiple PRs
If task already has PR drafts, create new one with incremented name.
Previous drafts remain for history.
