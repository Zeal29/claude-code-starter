# Examples Folder

> ⚠️ **THIS FOLDER CONTAINS EXAMPLES ONLY**
> These are reference examples showing how the work management system looks when populated.
> Do NOT copy these directly - use `docs/_templates/` for creating new items.

## What's Here

| File/Folder | Shows |
|-------------|-------|
| `_index-empty.example.md` | Fresh project with no epics/tasks |
| `_index-with-data.example.md` | Project with active work |
| `EXXX-example-feature/` | Complete epic folder structure |

## How to Use This

1. **Learning the system?** → Read through these examples
2. **Creating new epic?** → Use `/work:epic-new` command (uses `docs/_templates/`)
3. **Creating new task?** → Use `/work:task-new` command (uses `docs/_templates/`)
4. **Unsure what a file should look like?** → Check the example here

## Naming Convention

- `EXXX` = Epic ID placeholder (real: E001, E002, etc.)
- `TXXX` = Task ID placeholder (real: T001, E001-T001, etc.)
- `STXXX` = Subtask ID placeholder (real: ST001, ST002, etc.)
- `YYYY-MM-DD` = Date placeholder (real: 2025-01-15)
- `{{PLACEHOLDER}}` = Value you fill in

## Example vs Template

| Location | Purpose | When Used |
|----------|---------|-----------|
| `agent_docs/_examples/` | **Reference** - see what filled-in files look like | Learning, debugging |
| `docs/_templates/` | **Creation** - blank templates with placeholders | `/work:*` commands |
