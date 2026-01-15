# Draft: {{DRAFT_TITLE}}

## Meta
```yaml
id: {{DRAFT_ID}}
target: {{TARGET_ID}}  # Epic or Task ID this draft is for
status: open  # open|ready|processing|completed|failed
created: {{DATE}}
updated: {{DATE}}
processed_at: ""
```

## Intent
<!-- What should Claude do when processing this draft? Check all that apply -->
- [ ] Create new tasks
- [ ] Update epic/task context
- [ ] Add to Research/
- [ ] Update agent_docs/
- [ ] Create subtasks
- [ ] Other: 

## Summary
<!-- Brief overview of what this draft is about -->

## Details
<!-- Full requirements, context, specifications -->

## Supporting Files
<!-- List any additional files in this draft folder -->
| File | Description |
|------|-------------|
| - | - |

## Questions for Claude
<!-- Things you want Claude to figure out or decide -->
- [ ] 

## Processing Instructions
<!-- Special instructions for how Claude should process this -->

## After Processing
<!-- What should happen after Claude processes this draft -->
- Update `{{TARGET_ID}}-context.md` with: 
- Create folders/files: 
- Archive this draft: Yes

---
<!-- PROCESSING LOG - Claude fills this when processing -->
## Processing Log
```yaml
processed_by: ""
processed_at: ""
status: ""
```

### Actions Taken
- 

### Files Modified
- 

### Errors/Warnings
- 
