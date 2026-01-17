# Progressive Disclosure Examples

Examples of proper detail levels at Epic → Task → Subtask hierarchy.

---

## Good Example: OAuth Authentication Feature

### Epic Level (E001) ✅

**Objective (WHAT)**:
Add OAuth authentication to support Google and GitHub login providers.

**Rationale (WHY)**:
**Problem Context**: Users request social login (40% of support tickets). Current email/password only creates friction for new signups and increases password reset requests.

**Approach Rationale**: OAuth 2.0 is industry standard, reduces our security surface (no password storage for social logins), improves user experience. Passport.js chosen for proven strategies and community support.

**Key Strategic Decisions**:
- Start with Google (60% of requests) and GitHub (30%)
- Use Passport.js for OAuth flow management
- Account linking strategy: merge by email if verified

**Approach (HOW - High Level)**:
1. Phase 1: Implement Google OAuth (2-3 days)
2. Phase 2: Add GitHub OAuth (1-2 days)
3. Phase 3: Account linking and migration (1 day)
4. Phase 4: Remove old auth flows (optional)

**Why this is good Epic level**:
- High-level business problem and value
- Strategic decisions with rationale
- Major phases without implementation
- Delegates details to tasks

---

### Task Level (E001-T001) ✅

**Objective (WHAT)**:
Implement Google OAuth provider with account linking.

**Rationale (WHY)**:
**Problem Context**: Google most requested (60% of OAuth tickets), existing users need seamless linking to prevent duplicate accounts. Must handle both new signups and existing account linking.

**Approach Rationale**: Passport-google-oauth20 strategy is well-maintained and compatible with our Express stack. Email-based account linking chosen over manual linking for better UX (verified emails are trustworthy).

**Key Decisions**:
- Use passport-google-oauth20 package (not google-auth-library directly)
- Link accounts by verified email match
- Fallback to new account if email unverified or no match
- Store OAuth tokens for API access (future feature)

**Approach (HOW - Detailed)**:
1. Install and configure passport-google-oauth20
2. Set up Google OAuth app in console, get credentials
3. Create passport strategy in src/config/passport.ts
4. Add OAuth routes in src/routes/auth.ts
5. Implement account linking logic in src/services/user.ts
6. Add OAuth UI buttons to login page
7. Test flow: new user, existing user linking, error cases
8. Document environment variables needed

**Files to Modify**:
- src/config/passport.ts - Add GoogleStrategy
- src/routes/auth.ts - Add /auth/google and /auth/google/callback
- src/services/user.ts - Add findOrCreateFromOAuth
- src/views/login.ejs - Add Google OAuth button
- .env.example - Document GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET
- package.json - Add passport-google-oauth20 dependency

**Why this is good Task level**:
- Specific deliverable with problem context
- Detailed approach (8 steps)
- Files to change (but not exact code)
- Decision rationale from discussion
- Enough detail to start work

---

### Subtask Level (E001-T001-S01) ✅

**Objective (WHAT)**:
Configure Google OAuth strategy in passport configuration.

**Context (WHY)**:
**Parent Task**: E001-T001 (Google OAuth implementation)
**Purpose**: Strategy configuration must happen before routes are added, otherwise passport.authenticate() middleware will fail with "Unknown authentication strategy 'google'". This is the foundation for the OAuth flow.

**Implementation (HOW)**:

**Steps**:
1. Open src/config/passport.ts
2. Import GoogleStrategy at top:
   ```typescript
   import { Strategy as GoogleStrategy } from 'passport-google-oauth20';
   ```
3. Add strategy configuration after existing LocalStrategy:
   ```typescript
   passport.use(new GoogleStrategy({
     clientID: process.env.GOOGLE_CLIENT_ID!,
     clientSecret: process.env.GOOGLE_CLIENT_SECRET!,
     callbackURL: '/auth/google/callback',
     scope: ['profile', 'email']
   }, async (accessToken, refreshToken, profile, done) => {
     try {
       const user = await userService.findOrCreateFromOAuth({
         provider: 'google',
         providerId: profile.id,
         email: profile.emails?.[0]?.value,
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
4. Add type assertion for env variables (fails fast if missing):
   ```typescript
   if (!process.env.GOOGLE_CLIENT_ID || !process.env.GOOGLE_CLIENT_SECRET) {
     throw new Error('Google OAuth credentials missing in environment');
   }
   ```

**Files to Modify**:
- src/config/passport.ts:12-45 - Add GoogleStrategy import and configuration

**Implementation Notes**:
- Scope 'profile' and 'email' required for account linking
- profile.emails may be undefined if user denies email permission
- accessToken/refreshToken stored for future API access feature
- callbackURL must match Google Console redirect URI exactly
- Environment check fails at startup (not at first OAuth attempt) for better DX

**Verification**:
- [ ] Import added without TypeScript errors
- [ ] Strategy registered (check with passport._strategies in debugger)
- [ ] Environment validation throws error if credentials missing
- [ ] No lint errors
- [ ] File saved and formatted

**Progress Log**:
**Current State**: Not started
**Next Step**: Add import and strategy configuration
**Blocker**: None

**Why this is good Subtask level**:
- Atomic action (just passport config)
- Exact code changes with snippets
- Line numbers (12-45)
- Technical gotchas documented
- Why this step in sequence
- Maximum detail - ready to execute

---

## Bad Example: Over-Detailed Epic

### Epic Level (E002) ❌

**Objective (WHAT)**:
Add user profile editing with avatar upload using multer middleware.

**Rationale (WHY)**:
Users request profile customization. We'll use multer for file uploads, store in S3, resize with sharp to 200x200px, validate file type (jpg/png only), max 5MB size.

**Approach (HOW - High Level)**:
```typescript
// Install multer and sharp
npm install multer sharp @aws-sdk/client-s3

// Configure multer in src/middleware/upload.ts
const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 5 * 1024 * 1024 },
  fileFilter: (req, file, cb) => {
    if (file.mimetype === 'image/jpeg' || file.mimetype === 'image/png') {
      cb(null, true);
    } else {
      cb(new Error('Invalid file type'));
    }
  }
});

// Add route in src/routes/profile.ts
router.post('/profile/avatar', upload.single('avatar'), async (req, res) => {
  const buffer = await sharp(req.file.buffer)
    .resize(200, 200)
    .toBuffer();
  const key = `avatars/${req.user.id}.jpg`;
  await s3.putObject({ Bucket: 'myapp', Key: key, Body: buffer });
  // ...
});
```

**Why this is bad**:
- ❌ Code snippets at Epic level (way too detailed)
- ❌ Implementation specifics (multer config, sharp resizing)
- ❌ Should be delegated to Task level (approach) and Subtask level (code)
- ❌ No strategic rationale - just jumps to implementation
- ❌ Missing business context (why do users want this?)

**Should be**:
- WHAT: Add user profile editing
- WHY: Users request customization (X% of feedback)
- HOW: Phase 1 - Basic fields, Phase 2 - Avatar upload, Phase 3 - Privacy settings
- Delegate implementation to tasks

---

## Bad Example: Under-Detailed Subtask

### Subtask Level (E002-T001-S03) ❌

**Objective (WHAT)**:
Add avatar upload.

**Implementation (HOW)**:
Use multer to handle file uploads. Resize images and upload to S3.

**Files to Modify**:
- src/routes/profile.ts
- src/middleware/upload.ts

**Verification**:
- [ ] Works

**Why this is bad**:
- ❌ No exact steps (how do I implement this?)
- ❌ No code snippets (what does "use multer" mean?)
- ❌ Missing technical details (file size? formats? resize dimensions?)
- ❌ No WHY context (why this subtask in sequence?)
- ❌ Vague verification (what does "works" mean?)

**Should be**:
- Exact steps with code snippets
- Specific file paths and line numbers
- Technical notes (5MB limit, jpg/png only, 200x200px)
- Why: Must configure upload middleware before adding routes
- Specific verification (upload 6MB file → rejects, upload png → succeeds, check S3 bucket)

---

## Good Example: API Rate Limiting

### Epic Level (E003) ✅

**Objective (WHAT)**:
Implement API rate limiting to prevent abuse.

**Rationale (WHY)**:
**Problem Context**: API being scraped (logs show single IP making 10K requests/hour). No rate limiting exposes us to DoS attacks and increases infrastructure costs.

**Approach Rationale**: Express-rate-limit middleware is battle-tested and integrates with our Express stack. Redis store chosen for distributed rate limiting across multiple servers.

**Key Strategic Decisions**:
- 100 requests/15min for authenticated users (generous for real usage)
- 20 requests/15min for unauthenticated (prevents scraping)
- 429 status with Retry-After header (standard)
- Redis for distributed state (supports horizontal scaling)

**Approach (HOW - High Level)**:
1. Phase 1: Add rate limiting middleware
2. Phase 2: Configure Redis store
3. Phase 3: Apply to all routes
4. Phase 4: Add monitoring and alerts

---

### Task Level (E003-T001) ✅

**Objective (WHAT)**:
Configure express-rate-limit with Redis store.

**Rationale (WHY)**:
**Problem Context**: In-memory store won't work with multiple servers (each would have independent counters, allowing 100 req/15min PER SERVER). Redis provides shared state.

**Approach Rationale**: rate-limit-redis package is official store implementation, handles connection pooling and key expiration automatically.

**Key Decisions**:
- Use existing Redis instance (already have for sessions)
- Key format: `rl:{ip}:{endpoint}` for easy debugging
- Enable draft-7 headers for better client UX

**Approach (HOW - Detailed)**:
1. Install rate-limit-redis package
2. Create rate limiting middleware in src/middleware/rateLimiter.ts
3. Configure Redis client with connection pooling
4. Set up different limits for auth vs unauth
5. Apply to all API routes in src/app.ts
6. Add error handling for Redis failures (failOpen: true)
7. Test rate limiting behavior
8. Document configuration in README

---

### Subtask Level (E003-T001-S02) ✅

**Objective (WHAT)**:
Create rate limiting middleware configuration in rateLimiter.ts.

**Context (WHY)**:
**Parent Task**: E003-T001 (rate limiting setup)
**Purpose**: Middleware must be created before being applied to routes (app.use). This centralizes rate limit configuration for easier tuning.

**Implementation (HOW)**:

**Steps**:
1. Create file src/middleware/rateLimiter.ts
2. Import dependencies:
   ```typescript
   import rateLimit from 'express-rate-limit';
   import RedisStore from 'rate-limit-redis';
   import { redisClient } from '../config/redis';
   ```
3. Create authenticated user limiter:
   ```typescript
   export const authLimiter = rateLimit({
     store: new RedisStore({
       client: redisClient,
       prefix: 'rl:auth:',
     }),
     windowMs: 15 * 60 * 1000, // 15 minutes
     max: 100, // 100 requests per window
     standardHeaders: true, // Return rate limit info in `RateLimit-*` headers
     legacyHeaders: false, // Disable `X-RateLimit-*` headers
     message: 'Too many requests, please try again later',
   });
   ```
4. Create public limiter (stricter):
   ```typescript
   export const publicLimiter = rateLimit({
     store: new RedisStore({
       client: redisClient,
       prefix: 'rl:public:',
     }),
     windowMs: 15 * 60 * 1000,
     max: 20, // Much stricter for unauthenticated
     standardHeaders: true,
     legacyHeaders: false,
     message: 'Too many requests, please try again later',
   });
   ```
5. Add failOpen for Redis errors:
   ```typescript
   // If Redis fails, allow requests through (don't block entire API)
   authLimiter.skip = () => !redisClient.isReady;
   publicLimiter.skip = () => !redisClient.isReady;
   ```

**Files to Modify**:
- src/middleware/rateLimiter.ts (new file, 45 lines)

**Implementation Notes**:
- prefix 'rl:auth:' vs 'rl:public:' allows separate namespaces in Redis
- standardHeaders: true enables RateLimit-Limit, RateLimit-Remaining, Retry-After
- failOpen prevents Redis outage from taking down API (graceful degradation)
- redisClient from existing config (assumes Redis already set up in T001-S01)

**Verification**:
- [ ] File created with correct imports
- [ ] Both limiters exported
- [ ] TypeScript compiles without errors
- [ ] Redis prefix keys visible in redis-cli (KEYS rl:*)
- [ ] failOpen logic works (test by stopping Redis, API still responds)

---

## Summary: Progressive Disclosure Rules

| Level | Detail | Example WHAT | Example WHY | Example HOW |
|-------|--------|--------------|-------------|-------------|
| **Epic** | Strategic | "Add OAuth" | "40% of support tickets request it" | "Phase 1: Google, Phase 2: GitHub" |
| **Task** | Detailed | "Implement Google OAuth" | "Most requested, good passport.js support" | "Install pkg, configure strategy, add routes, test..." |
| **Subtask** | Maximum | "Configure passport strategy" | "Must be before routes or auth fails" | "Edit passport.ts line 12, add `import { GoogleStrategy }...`" |

**Ask yourself**:
- Epic: "What business value does this provide?" (outcomes, not code)
- Task: "What detailed steps will I take?" (approach, not exact code)
- Subtask: "What exact changes do I make?" (code snippets, line numbers)

**Red flags**:
- 🚩 Code snippets in Epic → Move to Subtask
- 🚩 "Just do it" in Subtask → Add exact steps
- 🚩 Line numbers in Task → Move to Subtask
- 🚩 Business justification in Subtask → Move to Epic/Task Rationale

---

**Last Updated**: 2026-01-18
**Related**: See `work-system.md` for system overview
