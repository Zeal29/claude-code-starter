---
scope: "**/*.py"
---
# Python Rules

## Style
- Use Ruff for formatting and linting
- Type hints on all function signatures
- Docstrings for public functions

## Patterns
```python
# ✅ Good
def get_user(user_id: str) -> User | None:
    """Fetch user by ID. Returns None if not found."""
    ...

# ❌ Bad
def get_user(user_id):  # missing types
    ...
```

## Async (FastAPI)
```python
# Async endpoint
@app.get("/users/{id}")
async def get_user(id: str) -> User:
    return await db.fetch_user(id)

# Use httpx for async HTTP
async with httpx.AsyncClient() as client:
    response = await client.get(url)
```

## Error Handling
- Use custom exception classes
- FastAPI: raise HTTPException for client errors
- Log unexpected exceptions before re-raising

## Structure
- One class per file for models
- Group related utilities in modules
- Keep endpoints thin - logic in services
