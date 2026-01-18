# Epic: EXXX - Example Feature

<!-- 
╔═══════════════════════════════════════════════════════════════════╗
║  EXAMPLE FILE: Shows a populated epic context file                ║
║  Real location: docs/epics/E001-feature-name/E001-context.md      ║
║  Template: docs/_templates/epic-context.template.md               ║
╚═══════════════════════════════════════════════════════════════════╝

READING GUIDE:
- This file is Layer 2 (loaded when working on this epic)
- Layer 1 (_index.md) shows: "EXXX Example Feature - 50% - active TXXX"
- Layer 3 (Research/, Archive/) loaded only if explicitly needed
-->

## Meta
```yaml
id: EXXX                        # Real: E001, E002, etc.
name: Example Feature           # Descriptive name
status: in-progress             # draft|ready|in-progress|blocked|review|done|archived
created: YYYY-MM-DD             # When created
updated: YYYY-MM-DD             # Last update
owner: your-name                # Who owns this
external_id: "PROJ-123"         # Jira/Linear/GitHub issue (optional)
```

## Objective (WHAT)
<!-- 1-2 sentences: What does completing this epic achieve? -->
Add OAuth authentication to support Google and GitHub login providers, enabling users to sign in with social accounts instead of traditional email/password.

## Rationale (WHY)
<!-- Why this epic exists, problem being solved, business value -->
<!-- This section demonstrates knowledge preservation - future Claude understands context -->

**Problem Context**:
<!-- What problem are we solving, why does it exist -->
Users frequently request social login (40% of support tickets cite "forgot password" or "prefer Google login"). Current email/password-only auth creates friction for new signups and increases password reset requests (averaging 50/day). Competitor analysis shows 3/4 major competitors offer social login as primary authentication method.

**Approach Rationale**:
<!-- Why this approach over alternatives -->
OAuth 2.0 is industry standard and reduces our security surface (no password storage for social logins). Passport.js chosen for proven strategies and extensive community support (50K+ weekly downloads, maintained by Jared Hanson). Alternative considered: Auth0 ($$$) - rejected due to cost and vendor lock-in concerns for our scale.

**Key Strategic Decisions**:
<!-- Critical high-level decisions made -->
- **Provider Priority**: Start with Google (60% of requests) and GitHub (30% - developer audience), defer Facebook/Twitter
- **Account Linking**: Merge accounts by verified email match (prevents duplicate accounts, maintains data continuity)
- **Migration Strategy**: Keep existing email/password auth (don't force migration, offer linking at login)
- **Token Storage**: Store OAuth access/refresh tokens for future API integrations (planned: calendar sync, email features)

## Approach (HOW - High Level)
<!-- Epic-level strategy, major phases, key architectural decisions -->
<!-- Detail level: Strategic phases, NOT implementation steps -->

**Phase 1: Google OAuth** (Est: 2-3 days)
- Set up OAuth app in Google Cloud Console
- Implement Passport Google Strategy
- Add account linking logic (merge by verified email)
- Test: new user signup, existing user linking, edge cases

**Phase 2: GitHub OAuth** (Est: 1-2 days)
- Set up OAuth app in GitHub Developer Settings
- Implement Passport GitHub Strategy
- Reuse account linking logic from Phase 1
- Test: developer workflow, org permissions

**Phase 3: Account Management** (Est: 1 day)
- UI for viewing linked accounts
- Unlink/relink functionality
- Primary account designation
- Email verification flow updates

**Phase 4: Migration & Cleanup** (Optional, future)
- Migrate high-value users to OAuth
- Deprecate email/password for new signups
- Remove old auth code (if fully migrated)

**Architectural Decisions**:
- Use Passport.js middleware (proven, extensible to more providers)
- Store tokens encrypted in database (future API access)
- Implement OAuth callback handling on `/auth/:provider/callback` routes
- Add OAuth button UI to existing login page (don't create separate page)

## Success Criteria
<!-- When are we DONE? Checkboxes Claude can mark -->
<!-- Epic-level criteria focus on OUTCOMES, not implementation details -->
- [x] Users can sign in with Google OAuth (Phase 1 complete)
- [ ] Users can sign in with GitHub OAuth
- [ ] Existing accounts automatically link by verified email
- [ ] OAuth tokens stored securely for future API use
- [ ] Login page shows OAuth buttons prominently
- [ ] All authentication flows tested (new user, existing user, edge cases)
- [ ] Security review completed (OWASP OAuth best practices)

## Tasks Overview
<!-- Quick reference table - details in Tasks/ subfolders -->
| ID | Name | Status | Progress | External ID |
|----|------|--------|----------|-------------|
| EXXX-T001 | Implement Google OAuth | 🟢 done | 100% | PROJ-124 |
| EXXX-T002 | Implement GitHub OAuth | 🟡 in-progress | 60% | PROJ-125 |
| EXXX-T003 | Add Account Management UI | ⚪ ready | 0% | PROJ-126 |
| EXXX-T004 | Security & Performance Review | ⚪ ready | 0% | — |

→ Full task details: `Tasks/EXXX-TXXX-name/TXXX-context.md`

## Key Decisions
<!-- Important decisions and WHY - helps future Claude understand context -->
<!-- Epic-level decisions are STRATEGIC - delegate technical decisions to tasks -->
| Date | Decision | Rationale |
|------|----------|-----------|
| 2026-01-10 | Use Passport.js vs Auth0 | Cost ($0 vs $240/mo), no vendor lock-in, extensible to custom providers later |
| 2026-01-10 | Email-based account linking | Prevents duplicate accounts, 95% of users have verified emails, UX seamless |
| 2026-01-12 | Google first, then GitHub | User research: 60% want Google, 30% GitHub (developer audience), defer FB/Twitter |
| 2026-01-15 | Store OAuth tokens encrypted | Future features need API access (calendar, email), security best practice |

→ Full decision history: `Archive/_archive-index.md`

## Dependencies
<!-- What blocks this? What does this block? -->
- **Depends on**: None (greenfield feature)
- **Blocks**: E005 (Social Profile Import - needs OAuth tokens from this epic)

## Git Tracking
```yaml
branch: "feature/oauth-authentication"   # Main epic branch (if any)
related_branches:
  - "feature/google-oauth"      # T001 (merged)
  - "feature/github-oauth"      # T002 (in progress)
```

## Current Focus
<!-- Updated by /work:save - shows where we left off -->
**Active Task**: EXXX-T002 (Implement GitHub OAuth)
**Current State**: GitHub strategy configured, callback routes added, testing account linking
**Next Step**: Add UI buttons to login page, test with GitHub org permissions
**Blocker**: None

## Quick Links
<!-- For Claude to find supporting files -->
- Research: `Research/` (OAuth provider comparison, security review)
- Latest Draft: `Drafts/2026-01-10-oauth-requirements/`
- Archive: `Archive/` (decision history, previous iterations)

## Assumptions
<!-- Things we're assuming are true - if wrong, work may need revision -->
<!-- Epic-level assumptions are BUSINESS/STRATEGIC -->
- 95%+ users have verified email addresses (for account linking)
- OAuth providers maintain 99.9% uptime (acceptable for our SLA)
- Users understand "Sign in with Google" pattern (no onboarding needed)
- Future features will need OAuth API access (justifies token storage)
- Google/GitHub sufficient for MVP (Facebook/Twitter deferred)

## Unanswered Questions
<!-- Open items that need answers - check these when resuming -->
<!-- Epic-level questions are STRATEGIC - technical questions go in tasks -->
- [ ] Should we deprecate email/password entirely, or keep both?
- [ ] What's our plan for users who don't have Google/GitHub accounts?
- [ ] Do we need admin override for OAuth failures (support tool)?
- [x] Confirmed: Email-based linking (vs manual linking UI) - 2026-01-10
- [x] Confirmed: Store tokens encrypted in DB (vs in-memory only) - 2026-01-15

## Progress Log
<!-- Session summaries - updated by /work:save -->
<!-- Epic-level log tracks TASK completion, not individual sessions -->
| Date | Task | Summary |
|------|------|---------|
| 2026-01-10 | Setup | Epic created, OAuth requirements drafted in Drafts/ |
| 2026-01-15 | EXXX-T001 | Google OAuth complete - strategy, routes, linking logic, tests all passing |
| 2026-01-16 | EXXX-T001 | Merged PR #42 (Google OAuth), deployed to staging |
| 2026-01-18 | EXXX-T002 | Started GitHub OAuth, strategy configured, testing account linking |

## Time Log
<!-- Optional: track time spent -->
| Date | Duration | Task | Notes |
|------|----------|------|-------|
| 2026-01-10 | 1h | Setup | Requirements gathering, draft creation |
| 2026-01-15 | 3h | EXXX-T001 | Google OAuth implementation |
| 2026-01-16 | 2h | EXXX-T001 | Testing, PR review, merge |
| 2026-01-18 | 2h | EXXX-T002 | GitHub OAuth started |
