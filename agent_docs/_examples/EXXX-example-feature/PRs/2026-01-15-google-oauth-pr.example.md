# PR Draft: 2026-01-15 - Google OAuth Implementation

<!--
╔═══════════════════════════════════════════════════════════════════╗
║  EXAMPLE FILE: Shows PR draft structure                           ║
║  Real location: PRs/YYYY-MM-DD-description.md                     ║
║  Template: docs/_templates/pr-draft.template.md                   ║
╚═══════════════════════════════════════════════════════════════════╝

READING GUIDE:
- This draft created by `/work:pr-draft EXXX-TXXX` command
- Used to generate GitHub PR description
- Tracks PR submission status
-->

## Meta
```yaml
task: EXXX-TXXX                          # Real: E001-T001
epic: EXXX                               # Real: E001 (optional)
branch: feature/google-oauth
target_branch: main
created: 2026-01-15
submitted: true
pr_number: "42"
pr_url: "https://github.com/org/repo/pull/42"
pr_status: "merged"                      # open|approved|changes-requested|merged|closed
```

## Title
<!-- PR title in conventional format with emoji -->
✨ feat(auth): Add Google OAuth authentication with account linking

## Summary
<!-- 1-2 sentence overview -->
Implements Google OAuth 2.0 authentication using Passport.js, enabling users to sign in with their Google account. Includes intelligent account linking that automatically merges OAuth logins with existing email/password accounts based on verified email match.

## Changes
<!-- Bullet points of main changes -->
- **Authentication Strategy**: Added `passport-google-oauth20` package and configured GoogleStrategy
- **Routes**: New `/auth/google` and `/auth/google/callback` endpoints
- **Account Linking**: Implemented `findOrCreateFromOAuth()` service with email-based account merging
- **Token Storage**: Encrypted storage of OAuth access_token and refresh_token for future API integrations
- **Types**: Added `OAuthProfile` and `OAuthProvider` TypeScript interfaces
- **Environment**: Added `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET` configuration
- **Tests**: 14 new unit tests covering new user flow, existing user linking, and edge cases

## Type of Change
- [ ] 🐛 Bug fix (non-breaking change fixing an issue)
- [x] ✨ New feature (non-breaking change adding functionality)
- [ ] 💥 Breaking change (fix or feature causing existing functionality to change)
- [ ] 📝 Documentation update
- [ ] ♻️ Refactor (no functional changes)

## Testing
<!-- How was this tested? -->
- [x] Unit tests added/updated (14 new tests, all passing)
  - `findOrCreateFromOAuth()` with new user (creates account)
  - `findOrCreateFromOAuth()` with existing user (links account)
  - Edge cases: missing email, unverified email, duplicate OAuth provider
- [x] Manual testing done
  - ✅ New user: Sign in with Google → account created → logged in → dashboard loads
  - ✅ Existing user: Sign in with Google → account linked by email → logged in → user data preserved
  - ✅ Edge case: Deny email permission → graceful error message, no crash
  - ✅ Edge case: Google API error → error page shown, can retry
- [x] Existing tests pass (`npm test` - 87/87 tests passing)
- [x] Integration tests pass on staging environment
- [x] No TypeScript errors (`npm run typecheck`)

## Screenshots
<!-- If UI changes -->
N/A - Backend authentication flow, no UI changes in this PR (UI buttons added in separate PR)

## Performance Impact
- **Database**: +1 query per OAuth login (check existing account by email)
- **Response Time**: OAuth callback ~200ms avg (includes Google API roundtrip + DB query)
- **Token Storage**: ~500 bytes per user (encrypted tokens stored in users table)

All within acceptable performance SLAs.

## Security Considerations
- ✅ OAuth tokens stored encrypted using bcrypt-based encryption
- ✅ No plaintext credentials in code (uses environment variables)
- ✅ CSRF protection via Passport.js built-in state parameter
- ✅ Callback URL validation (must match Google Console configuration)
- ✅ Graceful handling of denied permissions (no crashes)
- ✅ Account linking only on verified emails (prevents account takeover)

## Checklist
- [x] Code follows project conventions (ESLint passing)
- [x] Self-reviewed the code
- [x] No new warnings/errors (clean build)
- [x] Docs updated (`.env.example` and README setup instructions)
- [x] Related issues linked (see below)

## Related Issues
<!-- Link to Jira/Linear/GitHub issues -->
- Closes: PROJ-124 (Google OAuth implementation)
- Related: PROJ-123 (Epic: OAuth Authentication)
- Blocks: PROJ-125 (GitHub OAuth - will reuse account linking logic)

## Dependencies
<!-- What this PR depends on or what depends on this -->
- **Depends on**: None (first OAuth provider)
- **Blocks**: GitHub OAuth PR (PROJ-125) - will use same account linking pattern
- **Enables**: Future OAuth providers (Facebook, Twitter) using same architecture

## Notes for Reviewers
<!-- Anything reviewers should know -->

**Key areas to review**:
1. **Account linking logic** (`src/services/user.ts:145-210`): Does email-based linking handle all edge cases correctly?
2. **Token encryption** (`src/services/user.ts:195-198`): Is bcrypt encryption sufficient for OAuth tokens, or should we use crypto.encrypt()?
3. **Error handling** (`src/routes/auth.ts:78-85`): Do we show helpful error messages without leaking security details?

**Design decisions**:
- **Why email-based linking?** 95% of users have verified emails, automatic linking is smoother UX than manual prompt
- **Why store refresh_token?** Future features (calendar sync, email import) will need API access
- **Why passport-google-oauth20?** Official Passport strategy, well-maintained, better than raw google-auth-library

**Testing notes**:
- Manual testing done with real Google account (test@example.com)
- Edge case tested: Denied email permission → fails gracefully, no crash
- Staging deployment tested with 5 beta users, all successful

**Follow-up work** (NOT in this PR):
- Add "Sign in with Google" button to login page UI (separate PR, frontend focus)
- Add OAuth account management UI on user profile page (future task)
- Security audit by InfoSec team (scheduled for next sprint)

---

🤖 Generated with [Claude Code](https://claude.com/claude-code)
