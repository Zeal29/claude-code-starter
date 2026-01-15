# Draft: Example Requirements

<!-- 
╔═══════════════════════════════════════════════════════════════════╗
║  EXAMPLE FILE: Shows how a draft.md should be structured          ║
║  Real location: docs/epics/E001-.../Drafts/YYYY-MM-DD-title/      ║
║  Template: docs/_templates/draft.template.md                      ║
╚═══════════════════════════════════════════════════════════════════╝

WORKFLOW:
1. User creates draft folder with /work:draft-new
2. User edits this draft.md file
3. User adds supporting files to this folder (optional)
4. User marks ready with /work:draft-ready
5. Claude processes with /work:draft-process
6. Claude updates context files based on instructions here
-->

## Meta
```yaml
draft_id: YYYY-MM-DD-example-requirements
target: EXXX                    # Epic or Task ID this modifies
type: requirements              # requirements|update|decision|research
status: completed               # open|ready|processing|completed|failed
created: YYYY-MM-DD
processed: YYYY-MM-DD
```

## Intent
<!-- What should Claude DO when processing this draft? Be explicit! -->
Create 3 tasks for the Example Feature epic:
1. Task for setting up the database schema
2. Task for building the API endpoints  
3. Task for creating the frontend components

## Details
<!-- Detailed information for Claude to work with -->

### Task 1: Database Schema
- Create tables for [entities]
- Add indexes for [queries]
- Migration should be reversible

### Task 2: API Endpoints
- GET /api/example - list all
- POST /api/example - create new
- PUT /api/example/:id - update
- DELETE /api/example/:id - delete
- All endpoints need auth middleware

### Task 3: Frontend Components
- List view with pagination
- Create/Edit form with validation
- Delete confirmation modal
- Use existing UI components from `src/components/ui/`

## Supporting Files
<!-- List any files in this draft folder that Claude should read -->
- `requirements-spec.pdf` - detailed requirements from PM
- `api-sketch.md` - rough API design notes
- `slack-discussion.txt` - context from team chat

## Acceptance Criteria
<!-- How do we know the draft was processed correctly? -->
- [ ] 3 tasks created in Tasks/ folder
- [ ] Each task has proper context file
- [ ] Epic context updated with task table
- [ ] _index.md updated with new tasks

## Notes
<!-- Any additional context -->
- Priority: Database → API → Frontend (in that order)
- Frontend task depends on API task completion
- Estimate: ~3 days total
