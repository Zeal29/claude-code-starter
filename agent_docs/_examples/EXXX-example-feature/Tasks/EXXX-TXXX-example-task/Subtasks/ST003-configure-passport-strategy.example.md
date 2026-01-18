# Subtask: ST003 - Configure Passport GoogleStrategy

<!--
╔═══════════════════════════════════════════════════════════════════╗
║  EXAMPLE FILE: Shows individual subtask file structure            ║
║  Real location: Tasks/E001-T001-.../Subtasks/ST003-...md         ║
║  Template: docs/_templates/subtask.template.md                    ║
╚═══════════════════════════════════════════════════════════════════╝

READING GUIDE:
- Parent task: EXXX-TXXX-context.example.md (Layer 2)
- This subtask: Layer 3 - MAXIMUM DETAIL (no further delegation)
- Optional: Individual subtask files only for substantial subtasks
- Simple subtasks can stay inline in _subtasks-index.md
-->

## Meta
```yaml
id: ST003
parent_task: EXXX-TXXX                # Real: E001-T001, E002-T005, etc.
status: done                          # ready|in-progress|done
created: 2026-01-14
updated: 2026-01-14
```

## Objective (WHAT)
<!-- One clear sentence - what this subtask accomplishes -->
Configure Google OAuth 2.0 strategy in Passport.js with proper scopes, callback URL, and verification callback to enable Google authentication.

## Context (WHY)
<!-- Why this subtask exists, what problem it solves within the task -->
<!-- Link to parent task section this supports -->

**Parent Task**: EXXX-TXXX (Implement Google OAuth)
**Purpose**:
<!-- Why this specific subtask is needed in the sequence -->
Passport strategy configuration MUST happen before adding routes (Step 3 before Step 4 in task approach), otherwise `passport.authenticate('google')` middleware will fail with "Unknown authentication strategy 'google'" error. This is the foundation of the OAuth flow - all subsequent steps depend on this being configured correctly.

Strategy config is separate from routes to follow separation of concerns: config/passport.ts handles authentication strategies, routes/auth.ts handles HTTP endpoints.

## Implementation (HOW)
<!-- Detailed implementation steps - this is the deepest level, maximum detail -->
<!-- SUBTASK LEVEL: Show exact code, line numbers, everything needed to execute -->

**Steps**:

1. **Open src/config/passport.ts**
   - This file already exists with LocalStrategy
   - We'll add GoogleStrategy after LocalStrategy (around line 45)

2. **Add GoogleStrategy import at top of file** (line 3):
   ```typescript
   import { Strategy as GoogleStrategy } from 'passport-google-oauth20';
   ```
   - Note: Import as `Strategy as GoogleStrategy` to avoid conflict with LocalStrategy
   - If line 3 already has imports, add this after existing Strategy imports

3. **Add environment variable validation** (after existing imports, before strategies):
   ```typescript
   // Validate Google OAuth credentials at startup
   if (!process.env.GOOGLE_CLIENT_ID || !process.env.GOOGLE_CLIENT_SECRET) {
     throw new Error('Google OAuth credentials missing: GOOGLE_CLIENT_ID and GOOGLE_CLIENT_SECRET required in .env');
   }
   ```
   - This fails fast at startup (better DX than failing at first OAuth attempt)
   - Place after imports, before `passport.use()` calls (around line 12)

4. **Add GoogleStrategy configuration** (after LocalStrategy, around line 45):
   ```typescript
   // Google OAuth Strategy
   passport.use(new GoogleStrategy({
     clientID: process.env.GOOGLE_CLIENT_ID!,
     clientSecret: process.env.GOOGLE_CLIENT_SECRET!,
     callbackURL: '/auth/google/callback',
     scope: ['profile', 'email']  // Request profile and email data
   }, async (accessToken, refreshToken, profile, done) => {
     try {
       // Call user service to find or create user with OAuth data
       const user = await userService.findOrCreateFromOAuth({
         provider: 'google',
         providerId: profile.id,
         email: profile.emails?.[0]?.value,  // May be undefined if user denies email permission
         name: profile.displayName,
         accessToken,
         refreshToken
       });
       return done(null, user);
     } catch (err) {
       return done(err);
     }
   }));
   ```

5. **Verify final file structure**:
   ```typescript
   // File: src/config/passport.ts
   import passport from 'passport';
   import { Strategy as LocalStrategy } from 'passport-local';
   import { Strategy as GoogleStrategy } from 'passport-google-oauth20';  // NEW
   import { userService } from '../services/user';

   // Validate environment (NEW)
   if (!process.env.GOOGLE_CLIENT_ID || !process.env.GOOGLE_CLIENT_SECRET) {
     throw new Error('Google OAuth credentials missing');
   }

   // ... LocalStrategy configuration (existing code) ...

   // Google OAuth Strategy (NEW - full code block from step 4)
   passport.use(new GoogleStrategy({ ... }));

   // Serialize/deserialize (existing code, no changes)
   passport.serializeUser(...);
   passport.deserializeUser(...);

   export default passport;
   ```

**Files to Modify**:
- `src/config/passport.ts:3` - Add GoogleStrategy import
- `src/config/passport.ts:12-15` - Add environment validation (NEW lines)
- `src/config/passport.ts:45-65` - Add GoogleStrategy configuration (NEW block)

**Implementation Notes**:
<!-- Any gotchas, edge cases, dependencies, technical details -->

- **Scope 'profile' and 'email' required**: Account linking needs email to match existing users. If user denies email permission, `profile.emails` will be undefined - handled gracefully in findOrCreateFromOAuth().

- **callbackURL must match Google Console**: The `/auth/google/callback` URL must EXACTLY match the "Authorized redirect URI" set in Google Cloud Console. Mismatch = OAuth flow fails with "redirect_uri_mismatch" error.

- **accessToken vs refreshToken**:
  - `accessToken`: Short-lived (1 hour), used for immediate API calls
  - `refreshToken`: Long-lived, used to get new access tokens when expired
  - Both stored for future API integrations (e.g., calendar sync)

- **TypeScript non-null assertion (`!`)**: Using `process.env.GOOGLE_CLIENT_ID!` is safe because we validate above. If missing, app crashes at startup (not at runtime).

- **Error handling**: Try-catch in verify callback ensures OAuth errors don't crash the server. Passport receives the error via `done(err)`.

- **profile.emails optional chaining**: `profile.emails?.[0]?.value` prevents crash if Google doesn't return email (rare, but possible if user denies permission).

- **Strategy registration timing**: Must happen BEFORE app starts listening (server.listen). Passport.js caches strategies at registration time.

## Verification
<!-- How to verify this subtask is complete -->
- [x] GoogleStrategy import added without TypeScript errors
- [x] Environment validation throws error if GOOGLE_CLIENT_ID missing (tested by commenting out .env)
- [x] Strategy registered in Passport (check with `passport._strategies['google']` in debugger - should be defined)
- [x] No TypeScript errors (`npm run typecheck`)
- [x] No lint errors (`npm run lint`)
- [x] File saved and formatted (Prettier ran)
- [x] Code compiles successfully (`npm run build`)

**Manual test** (after routes added in ST004):
1. Visit http://localhost:3000/auth/google
2. Should redirect to Google login page (not "Unknown strategy" error)
3. If error, check: strategy name matches (`'google'`), callback URL matches Google Console

## Progress Log
<!-- For multi-session subtask work - simpler than task Progress Log -->

**Current State**: Done (2026-01-14)
**Next Step**: N/A (subtask complete, moving to ST004)
**Blocker**: None

**Notes**:
- Completed in one session (30 minutes)
- No issues encountered
- Environment validation caught missing .env on first run (good!)
- Strategy verified working when tested with ST004 (routes)

---

## Progressive Disclosure Guide
**This is Layer 3 - Subtask Level (Deepest)**

- **Focus**: Atomic work unit, specific files, exact changes, verification
- **Detail**: WHAT (configure strategy), WHY (must precede routes), HOW (exact code with line numbers)
- **Delegate to**: NOTHING (this is the deepest layer - all detail captured here)

**What this subtask demonstrates**:
✅ Single focused action (just passport config, not routes)
✅ Exact file paths and line numbers (passport.ts:3, :12-15, :45-65)
✅ Code snippets ready to copy-paste
✅ Step-by-step implementation (5 numbered steps)
✅ Technical gotchas documented (callback URL match, email optional, token types)
✅ Specific verification steps (7 checkboxes)
✅ Why this step in sequence (must precede routes or fails)

**This is maximum detail** - future Claude can execute this without reading parent task.
