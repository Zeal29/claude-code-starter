---
scope: "**/*.{ts,tsx}"
---
# TypeScript Rules

## Exports
- **ALWAYS** use named exports
- **NEVER** use default exports

## Types
- Prefer `interface` over `type` for object shapes
- Use `type` for unions, intersections, primitives
- **NEVER** use `any` - use `unknown` if type truly unknown
- Use strict null checks - handle `null | undefined`

## Patterns
```typescript
// ✅ Good
export interface User { id: string; name: string; }
export const getUser = async (id: string): Promise<User | null> => {}

// ❌ Bad
export default function getUser() {} // default export
const data: any = response; // any type
```

## Error Handling
- Use Result<T, E> pattern for recoverable errors
- Throw only for programmer errors (invariant violations)
- Always type catch blocks: `catch (error: unknown)`

## Async
- Always use async/await over .then()
- Handle promise rejections explicitly
- Use `Promise.all` for parallel operations
