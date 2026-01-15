# OAuth Providers Research

## Compared Providers

| Provider | Popularity | Setup Complexity | Notes |
|----------|------------|------------------|-------|
| Google | ★★★★★ | Medium | Most users have Google account |
| GitHub | ★★★★☆ | Easy | Good for dev-focused apps |
| Microsoft | ★★★☆☆ | Medium | Enterprise users |
| Apple | ★★★☆☆ | Hard | Required for iOS apps |
| Facebook | ★★☆☆☆ | Medium | Declining trust |

## Recommendation
Start with **Google + GitHub** based on:
1. User survey showed 78% have Google, 45% have GitHub
2. Both have good documentation
3. Lower implementation complexity

## Implementation Notes

### Google OAuth
- Use `@react-oauth/google` package
- Scopes needed: `openid email profile`
- Callback URL: `/api/auth/callback/google`

### GitHub OAuth
- Use `octokit` or direct API
- Scopes needed: `read:user user:email`
- Callback URL: `/api/auth/callback/github`

## Decision
**Approved:** Google + GitHub for v1, consider Apple/Microsoft for v2

## References
- Google OAuth docs: https://developers.google.com/identity
- GitHub OAuth docs: https://docs.github.com/en/apps/oauth-apps
