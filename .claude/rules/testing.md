---
scope: "**/*.{test,spec}.{ts,tsx,js,jsx}"
---
# Testing Rules

## File Naming
- Unit tests: `*.test.ts`
- Integration tests: `*.spec.ts`
- Location: `__tests__/` folder alongside source

## Structure
```typescript
describe('ModuleName', () => {
  // Setup
  beforeEach(() => { /* reset state */ });
  afterEach(() => { /* cleanup */ });

  describe('functionName', () => {
    it('should handle normal case', () => {});
    it('should handle empty input', () => {});
    it('should throw on invalid input', () => {});
  });
});
```

## Assertions
```typescript
// ✅ Specific assertions
expect(result).toEqual({ id: '1', name: 'Test' });
expect(fn).toThrow(ValidationError);
expect(arr).toHaveLength(3);

// ❌ Vague assertions
expect(result).toBeTruthy();
expect(thing).toBeDefined();
```

## Mocking
- Mock external dependencies (API, DB)
- Don't mock internal logic
- Use dependency injection for easier mocking
- Reset mocks in afterEach

## Coverage
- Aim for 80%+ on business logic
- 100% not required - focus on critical paths
- Ignore generated files, types, configs
