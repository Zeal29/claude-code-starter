# Epic: E001 - User Authentication

## Meta
```yaml
id: E001
name: User Authentication
status: in-progress  # 🟡
created: 2025-01-10
owner: developer
external_id: AUTH-101
```

## Summary
Complete user authentication system with login, registration, password reset, and OAuth integration.

## Tasks

| ID | Name | Status | Progress | Branch |
|----|------|--------|----------|--------|
| E001-T001 | Login Page | 🟢 done | 100% | feature/login |
| E001-T002 | Registration | 🟢 done | 100% | feature/registration |
| E001-T003 | Password Reset | 🟡 in-progress | 60% | feature/password-reset |
| E001-T004 | OAuth Integration | ⚪ ready | 0% | — |

## Key Decisions

| Decision | Date | Rationale |
|----------|------|-----------|
| JWT for auth tokens | 2025-01-10 | Stateless, scalable, industry standard |
| 15min access / 7day refresh | 2025-01-10 | Balance security vs UX |
| bcrypt for passwords | 2025-01-10 | Battle-tested, configurable cost factor |
| Google + GitHub OAuth first | 2025-01-12 | Highest user demand per survey |

## Requirements
- [x] Login with email/password
- [x] Registration with email verification
- [ ] Password reset via email
- [ ] OAuth login (Google, GitHub)
- [ ] Remember me functionality
- [ ] Rate limiting on auth endpoints

## Current Focus
**Active Task:** E001-T003 (Password Reset)
**Current State:** Email sending implemented, need reset token validation
**Next Step:** Build reset password form and token verification endpoint
**Blocker:** None

## Progress Log

| Date | Task | Summary |
|------|------|---------|
| 2025-01-10 | E001-T001 | Completed login page, JWT implementation |
| 2025-01-11 | E001-T001 | Added tests, merged PR #12 |
| 2025-01-12 | E001-T002 | Built registration form, email verification |
| 2025-01-13 | E001-T002 | Fixed validation bugs, merged PR #15 |
| 2025-01-14 | E001-T003 | Started password reset, email sending works |

## Assumptions
- Users have valid email addresses
- Email service (SendGrid) is configured
- Frontend uses React with TanStack Query

## Unanswered Questions
- Should OAuth users be able to set a password later?
- What's the password reset token expiry? (currently 1 hour)

## References
- Research: `Research/oauth-providers.md`
- Auth flow diagram: `agent_docs/auth-flow.md`
