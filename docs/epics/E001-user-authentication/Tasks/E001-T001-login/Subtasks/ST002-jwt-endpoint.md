# Subtask: ST002 - Implement JWT Auth Endpoint

## Meta
```yaml
id: ST002
task: E001-T001
name: Implement JWT auth endpoint
status: done  # 🟢
created: 2025-01-10
completed: 2025-01-10
estimate: 2h
actual: 2h
```

## Description
Create POST /api/auth/login endpoint that validates credentials and returns JWT tokens.

## Acceptance Criteria
- [x] Validate email/password against database
- [x] Generate access token (15min expiry)
- [x] Generate refresh token (7day expiry)
- [x] Set refresh token in httpOnly cookie
- [x] Return access token in response body
- [x] Return 401 for invalid credentials

## Implementation Notes
- Used `jose` library for JWT signing
- Access token in response body for SPA use
- Refresh token in httpOnly cookie for security
- bcrypt.compare for password verification

## Files Modified
- `src/app/api/auth/login/route.ts` (created)
- `src/lib/auth/jwt.ts` (created)
- `src/lib/auth/password.ts` (created)
