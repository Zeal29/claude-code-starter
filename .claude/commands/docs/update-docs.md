---
description: Update documentation based on recent code changes
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep]
---

Update documentation for: $ARGUMENTS

## Process
1. Identify what changed (git diff or specified files)
2. Find related docs in `agent_docs/` and `docs/`
3. Update docs to reflect current state
4. Keep docs concise - information dense, minimal fluff

## Docs to Check
- `agent_docs/architecture.md` - if structure changed
- `agent_docs/database-schema.md` - if DB changed
- `agent_docs/api-patterns.md` - if API changed
- `README.md` - if setup/usage changed
- `docs/epics/*.md` - if epic progress made

## Writing Rules
- Sacrifice grammar for concision
- Never lose information
- Use code examples over long explanations
- Update timestamps/versions if present
- Remove outdated info, don't just add
