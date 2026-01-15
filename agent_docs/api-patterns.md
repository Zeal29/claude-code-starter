# API Patterns

## Response Format
All endpoints return consistent shape:

```typescript
// Success
{
  data: T | T[],
  meta?: { page: number, pageSize: number, total: number }
}

// Error
{
  error: {
    code: string,      // machine-readable: "VALIDATION_ERROR"
    message: string    // human-readable: "Email is required"
  }
}
```

## HTTP Status Codes
| Code | When |
|------|------|
| 200 | Success (GET, PUT, PATCH) |
| 201 | Created (POST) |
| 204 | No content (DELETE) |
| 400 | Validation error |
| 401 | Not authenticated |
| 403 | Not authorized |
| 404 | Resource not found |
| 500 | Server error |

## Validation (Zod)
```typescript
import { z } from 'zod';

export const createUserSchema = z.object({
  email: z.string().email(),
  password: z.string().min(8),
  name: z.string().min(1).max(100),
});

type CreateUserInput = z.infer<typeof createUserSchema>;
```

## Error Handling
```typescript
// Custom error class
export class AppError extends Error {
  constructor(
    public code: string,
    message: string,
    public statusCode: number = 400
  ) {
    super(message);
  }
}

// Usage
throw new AppError('USER_NOT_FOUND', 'User does not exist', 404);
```

## Assumptions
- [API assumptions]

## Unanswered Questions
- [Open API questions]
