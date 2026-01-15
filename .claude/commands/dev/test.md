---
description: Write tests for specified file or feature using TDD approach
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep]
---

Write tests for: $ARGUMENTS

## Process
1. Read the target file/feature to understand functionality
2. Identify test cases:
   - Happy path (normal operation)
   - Edge cases (empty, null, boundary values)
   - Error cases (invalid input, failures)
3. Write tests FIRST (TDD style)
4. Run tests to confirm they fail (no implementation cheating)
5. Report test file location and coverage

## Test Structure
```typescript
describe('FeatureName', () => {
  describe('methodName', () => {
    it('should handle normal case', () => {});
    it('should handle edge case: empty input', () => {});
    it('should throw on invalid input', () => {});
  });
});
```

## Rules
- Colocate tests in `__tests__/` folder next to source
- Name: `*.test.ts` or `*.spec.ts`
- One test file per source file
- Mock external dependencies, don't mock internal logic
