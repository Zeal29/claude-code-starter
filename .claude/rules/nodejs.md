---
scope: "src/api/**/*,server/**/*,backend/**/*"
---
# Node.js / Express Rules

## Structure
```
src/api/
├── routes/        # Express route handlers
├── services/      # Business logic
├── middleware/    # Custom middleware
├── utils/         # Helpers
└── types/         # Shared types
```

## Route Pattern
```typescript
// routes/users.ts
export const userRoutes = Router();

userRoutes.get('/:id', asyncHandler(async (req, res) => {
  const user = await userService.getById(req.params.id);
  if (!user) return res.status(404).json({ error: 'Not found' });
  res.json({ data: user });
}));
```

## Error Handling
- Wrap async handlers with asyncHandler utility
- Use custom AppError class for operational errors
- Global error handler catches all, logs unexpected errors
- Never expose stack traces in production

## Response Format
```typescript
// Success
{ data: T, meta?: { page, total } }

// Error
{ error: { code: string, message: string } }
```

## Validation
- Validate all input with Zod
- Validate at route entry point
- Return 400 with validation errors
