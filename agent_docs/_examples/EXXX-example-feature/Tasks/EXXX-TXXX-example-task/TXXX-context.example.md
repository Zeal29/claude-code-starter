# Task: EXXX-TXXX - Example Task

<!-- 
╔═══════════════════════════════════════════════════════════════════╗
║  EXAMPLE FILE: Shows a populated task context file                ║
║  Real location: docs/epics/E001-.../Tasks/E001-T001-.../          ║
║  Template: docs/_templates/task-context.template.md               ║
╚═══════════════════════════════════════════════════════════════════╝

READING GUIDE:
- Parent epic: EXXX-context.example.md (Layer 2)
- This task: Layer 2 detail
- Subtasks, Debug logs: Layer 3 (only if needed)
-->

## Meta
```yaml
id: EXXX-TXXX                   # Real: E001-T001, E001-T002, etc.
name: Example Task              # Descriptive name
epic: EXXX                      # Parent epic (empty if standalone)
status: in-progress             # draft|ready|in-progress|blocked|review|done|archived
created: YYYY-MM-DD
updated: YYYY-MM-DD
owner: your-name
external_id: "PROJ-124"         # Optional external tracker ID
```

## Objective (WHAT)
<!-- Clear 1-2 sentence goal - what does "done" look like? -->
Implement Google OAuth authentication provider with account linking logic, enabling users to sign in with their Google account and automatically link to existing accounts via verified email.

## Rationale (WHY)
<!-- Why this task is needed, problem context, decision rationale -->
<!-- This section often extracted from draft discussion - see Archive/ for full context -->

**Problem Context**:
<!-- What problem does this task solve, why does it exist -->
Google is the most requested OAuth provider (60% of social login requests from support tickets). Current email/password auth forces users to remember yet another password, leading to frequent "forgot password" flows and user frustration. Existing users need seamless account linking to prevent creating duplicate accounts when switching to OAuth.

**Approach Rationale**:
<!-- Why this approach over alternatives, key trade-offs -->
Using `passport-google-oauth20` strategy because it's the official, well-maintained Passport.js plugin (50K+ weekly downloads, active maintenance). Email-based account linking chosen over manual linking UI for better UX - 95% of our users have verified emails, and automatic linking is transparent. Alternative considered: requiring manual account connection UI - rejected due to friction and user confusion.

**Key Decisions**:
<!-- Critical decisions made during planning/discussion -->
- **Strategy Choice**: passport-google-oauth20 (vs direct google-auth-library) - better Express integration, less boilerplate
- **Account Linking**: Automatic by verified email match (vs manual linking prompt) - smoother UX, fewer steps
- **Token Storage**: Store access_token and refresh_token encrypted (vs access_token only) - enables future API features
- **Scope**: Request 'profile' and 'email' scopes only (vs 'profile email calendar contacts') - minimal permissions, can expand later
- **Error Handling**: Graceful degradation if email not provided (vs hard failure) - rare but possible if user denies email permission

→ See `Archive/2026-01-10-oauth-draft-discussion.md` for full discussion context

## Requirements
<!-- Checkboxes Claude can mark during /work:save -->
<!-- Task-level requirements are SPECIFIC and TESTABLE -->
- [x] Install passport-google-oauth20 package
- [x] Set up Google OAuth app in Google Cloud Console (get credentials)
- [x] Configure GoogleStrategy in src/config/passport.ts
- [x] Add /auth/google and /auth/google/callback routes
- [x] Implement findOrCreateFromOAuth() in src/services/user.ts
- [ ] Add "Sign in with Google" button to login page UI
- [ ] Test: new user signup flow (creates account, logs in)
- [ ] Test: existing user linking (merges accounts by email)
- [ ] Test: edge cases (email missing, unverified email, provider error)
- [ ] Document GOOGLE_CLIENT_ID and GOOGLE_CLIENT_SECRET in .env.example

## Relevant Files
<!-- Files Claude should read for context on this task -->
<!-- Task-level files are IMPLEMENTATION-SPECIFIC -->
- `src/config/passport.ts` - Passport.js configuration, add GoogleStrategy here
- `src/routes/auth.ts` - Authentication routes, add /auth/google endpoints
- `src/services/user.ts` - User service, implement findOrCreateFromOAuth()
- `src/types/auth.ts` - Auth TypeScript types, may need OAuthProfile interface
- `src/views/login.ejs` - Login page template, add Google OAuth button
- `.env.example` - Environment variables documentation

→ Subtasks: See `Subtasks/_subtasks-index.md`

## Approach (HOW - Detailed)
<!-- How we're solving this - helps future Claude understand decisions -->
<!-- Task-level approach is STEP-BY-STEP, delegates exact code to subtasks -->

1. **Install Dependencies** (ST001)
   - Run `npm install passport-google-oauth20`
   - Update package.json and package-lock.json

2. **Google Cloud Console Setup** (ST002)
   - Create new OAuth 2.0 credentials in Google Cloud Console
   - Set authorized redirect URI: `http://localhost:3000/auth/google/callback` (dev) and production URL
   - Copy Client ID and Client Secret to .env

3. **Configure Passport Strategy** (ST003)
   - Import GoogleStrategy in src/config/passport.ts
   - Add strategy configuration with clientID, clientSecret, callbackURL
   - Request 'profile' and 'email' scopes
   - Implement verify callback to call userService.findOrCreateFromOAuth()

4. **Add OAuth Routes** (ST004)
   - Add GET /auth/google route (initiates OAuth flow)
   - Add GET /auth/google/callback route (handles OAuth callback)
   - Both routes use passport.authenticate('google') middleware
   - Callback route redirects to dashboard on success, login on failure

5. **Implement Account Linking Logic** (ST005)
   - Create findOrCreateFromOAuth() in src/services/user.ts
   - Check if user exists by OAuth provider ID (google:{profile.id})
   - If not, check by verified email match
   - If match found, link OAuth provider to existing account
   - If no match, create new user with OAuth provider
   - Store access_token and refresh_token encrypted

6. **Add UI Button** (ST006)
   - Add "Sign in with Google" button to src/views/login.ejs
   - Style with Google brand guidelines (blue button, Google logo)
   - Link to /auth/google route

7. **Testing** (ST007)
   - Test new user flow: click button → Google login → account created → logged in
   - Test existing user: click button → links to existing account → logged in
   - Test edge cases: denied email permission, Google API error, etc.

8. **Documentation** (ST008)
   - Add GOOGLE_CLIENT_ID and GOOGLE_CLIENT_SECRET to .env.example
   - Update README with OAuth setup instructions

## Definition of Done
<!-- Standard checklist - customize per project -->
<!-- Task-level DoD is SPECIFIC to this task -->
- [x] All requirements checked off (8/10 complete, UI and edge case tests remaining)
- [x] Unit tests pass for findOrCreateFromOAuth()
- [ ] Integration tests pass for full OAuth flow
- [x] No TypeScript errors (`npm run typecheck`)
- [x] Code reviewed (PR #42 approved by @teammate)
- [ ] Deployed to staging, tested by QA
- [ ] .env.example updated with new credentials
- [ ] Security review: token encryption verified, no plaintext storage

## Dependencies
- **Blocked by**: None (first OAuth provider, no dependencies)
- **Blocks**: EXXX-T002 (GitHub OAuth - will reuse account linking logic)

## Git Tracking
```yaml
branch: "feature/google-oauth"
commits:
  - "a1b2c3d"  # Install passport-google-oauth20, add types
  - "e4f5g6h"  # Configure GoogleStrategy in passport.ts
  - "i7j8k9l"  # Add /auth/google routes
  - "m0n1o2p"  # Implement findOrCreateFromOAuth with account linking
  - "q3r4s5t"  # Add unit tests for account linking logic
pr_number: "42"
pr_url: "https://github.com/org/repo/pull/42"
pr_status: "approved"  # merged to main 2026-01-16
```

## Progress Log
<!-- Updated by /work:save after each session -->
<!-- Task-level log tracks SESSION-BY-SESSION progress with specific details -->

### Session 2026-01-16 (latest)
- Completed PR review feedback: added error handling for missing email
- All unit tests passing (14/14)
- Merged PR #42 to main, deployed to staging
- **Current State**: DONE - Google OAuth fully functional
- **Next Step**: N/A (task complete)
- **Blocker**: None

### Session 2026-01-15
- Implemented findOrCreateFromOAuth() with email-based account linking
- Added encryption for access_token and refresh_token storage
- Wrote unit tests for linking logic (new user, existing user, edge cases)
- **Current State**: Core logic complete, awaiting PR review
- **Next Step**: Address PR feedback, then merge
- **Blocker**: Waiting on code review from @teammate

### Session 2026-01-14
- Set up Google Cloud Console OAuth app, got credentials
- Configured GoogleStrategy in src/config/passport.ts
- Added /auth/google and /auth/google/callback routes
- **Current State**: Routes working, need account linking logic
- **Next Step**: Implement findOrCreateFromOAuth()
- **Blocker**: None

### Session 2026-01-13
- Task created from draft discussion (see Archive/)
- Installed passport-google-oauth20 package
- Added TypeScript types for OAuthProfile
- **Current State**: Dependencies ready
- **Next Step**: Set up Google Cloud Console
- **Blocker**: None

## Assumptions
<!-- Task-level assumptions are TECHNICAL -->
- Google OAuth API maintains 99.9%+ uptime (acceptable for our needs)
- Users will grant 'profile' and 'email' permissions (or flow fails gracefully)
- Verified email from Google is trustworthy for account linking
- passport-google-oauth20 package will remain maintained (active as of 2026-01)
- Environment has GOOGLE_CLIENT_ID and GOOGLE_CLIENT_SECRET configured

## Unanswered Questions
<!-- Task-level questions are TECHNICAL/IMPLEMENTATION -->
- [ ] Should we show "Link Google Account" on user profile page for existing users?
- [ ] What happens if user's Google email changes? (edge case)
- [x] Confirmed: Store both access and refresh tokens (not just access) - 2026-01-13
- [x] Confirmed: Encrypt tokens before DB storage (use bcrypt-based encryption) - 2026-01-14

## Time Log
| Date | Duration | Notes |
|------|----------|-------|
| 2026-01-13 | 1.5h | Setup, package install, types |
| 2026-01-14 | 3h | Google Console, strategy config, routes |
| 2026-01-15 | 4h | Account linking logic, tests |
| 2026-01-16 | 2h | PR review feedback, merge, deploy |
