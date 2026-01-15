# Authentication Flow

## Overview
Strategy: JWT with access + refresh tokens

## Token Configuration
| Token | Lifetime | Storage |
|-------|----------|---------|
| Access | 15 minutes | Memory / header |
| Refresh | 7 days | HttpOnly cookie |

## Flow Diagram
```
[Login] → POST /auth/login → { accessToken } + Set-Cookie: refreshToken

[API Call] → Authorization: Bearer <accessToken>

[Token Expired] → 401 → POST /auth/refresh → new accessToken

[Logout] → POST /auth/logout → Clear cookies
```

## Endpoints
| Endpoint | Method | Description |
|----------|--------|-------------|
| /auth/register | POST | Create account |
| /auth/login | POST | Get tokens |
| /auth/logout | POST | Invalidate tokens |
| /auth/refresh | POST | Refresh access token |
| /auth/me | GET | Get current user |

## Security Rules
- Hash passwords with bcrypt (cost 12)
- Store refresh tokens hashed in DB
- Invalidate all tokens on password change
- Rate limit auth endpoints

## Client Implementation
```typescript
// Axios interceptor for auto-refresh
api.interceptors.response.use(
  (res) => res,
  async (err) => {
    if (err.response?.status === 401 && !err.config._retry) {
      err.config._retry = true;
      await refreshToken();
      return api(err.config);
    }
    throw err;
  }
);
```

## Assumptions
- [Auth assumptions]

## Unanswered Questions
- [Open auth questions]
