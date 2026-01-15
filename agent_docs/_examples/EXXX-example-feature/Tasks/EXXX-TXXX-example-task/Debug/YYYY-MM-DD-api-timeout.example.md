# Debug Session: API Timeout Issue

<!-- 
╔═══════════════════════════════════════════════════════════════════╗
║  EXAMPLE FILE: Shows debug session documentation                  ║
║  Real location: .../Tasks/E001-T001-.../Debug/YYYY-MM-DD-issue.md ║
║  Template: docs/_templates/debug-session.template.md              ║
╚═══════════════════════════════════════════════════════════════════╝

WORKFLOW:
1. Start with /work:debug-start TASK "issue description"
2. Form hypotheses
3. Add strategic console.logs with [DEBUG_TRACE] prefix
4. Run app, capture output
5. Paste logs to Claude for analysis
6. Fix issue
7. Save findings with /work:debug-log TASK
-->

## Meta
```yaml
task: EXXX-TXXX
issue: "API calls timing out on slow connections"
started: YYYY-MM-DD HH:MM
resolved: YYYY-MM-DD HH:MM
duration: 45m
```

## Issue Description
API calls to `/api/example` are timing out when user has slow connection. 
Error: "Request timeout after 5000ms"

## Hypotheses
1. ❌ Server processing too slow → Ruled out (server logs show 200ms response)
2. ❌ Network latency → Ruled out (ping shows <100ms)
3. ✅ Client timeout too aggressive → **ROOT CAUSE**

## Debug Traces Added
```javascript
// In src/lib/api.ts
console.log('[DEBUG_TRACE]', Date.now(), 'api.fetch.start', { url, timeout });
console.log('[DEBUG_TRACE]', Date.now(), 'api.fetch.response', { status, duration });
console.log('[DEBUG_TRACE]', Date.now(), 'api.fetch.error', { error, elapsed });
```

## Logs Captured
```
[DEBUG_TRACE] 1705123456789 api.fetch.start { url: '/api/example', timeout: 5000 }
[DEBUG_TRACE] 1705123461890 api.fetch.error { error: 'timeout', elapsed: 5101 }
```

## Root Cause
Default fetch timeout was 5000ms. On slow 3G connections, large responses 
take 6-8 seconds. The timeout was triggering before response completed.

## Solution
```typescript
// Changed in src/lib/api.ts
const DEFAULT_TIMEOUT = 15000; // Was 5000, now 15000

// Also added retry logic for timeout errors
if (error.name === 'TimeoutError') {
  return retry(request, { maxAttempts: 2 });
}
```

## Files Modified
- `src/lib/api.ts` - increased timeout, added retry
- `src/lib/config.ts` - made timeout configurable

## Verification
- Tested on throttled connection (slow 3G)
- Request completes successfully in 7.2s
- Retry logic works on transient failures

## Lessons Learned
- Default timeouts should account for slow connections
- Add configurable timeouts for different environments
- Consider adding loading progress indicator for slow requests
