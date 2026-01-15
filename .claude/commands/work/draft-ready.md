---
description: Mark a draft as ready for processing
allowed-tools: [Read, Edit]
---

Mark draft ready: $ARGUMENTS

## Argument Parsing
Format: `<ID> <draft-folder>`
- ID: Epic or task ID
- draft-folder: The draft folder name (YYYY-MM-DD-title)

## Process

1. **Locate draft** at `{target}/Drafts/{folder}/draft.md`

2. **Validate draft**
   - Check status is `open`
   - Check Intent section has at least one item checked
   - Check Summary is not empty

3. **Update draft.md**
   - Change status from `open` to `ready`
   - Add `ready_at: {DATETIME}` to meta

4. **Report**:
```
✅ Draft marked ready: {{FOLDER}}
📝 Status: ready

Next step:
Run /draft:process {{ID}} {{FOLDER}} to execute this draft
```

## Validation Errors
If validation fails:
```
❌ Draft not ready:
- [ ] Intent section needs at least one checked item
- [ ] Summary section is empty
- [ ] Status is not 'open' (current: {{STATUS}})

Fix these issues and try again.
```
