# Archive Index

<!-- 
╔═══════════════════════════════════════════════════════════════════╗
║  EXAMPLE FILE: Shows archive index structure                      ║
║  Real location: docs/epics/E001-.../Archive/_archive-index.md     ║
║  Template: docs/_templates/archive-index.template.md              ║
╚═══════════════════════════════════════════════════════════════════╝

PURPOSE:
- Track what changed and when
- Avoid loading full archived files unless comparing versions
- Progressive Disclosure: read this index first, load files only if needed
-->

## Version History

| Version | Date | File | Summary of Changes |
|---------|------|------|-------------------|
| v3 | YYYY-MM-DD | `YYYY-MM-DD-v3-context.md` | Added T003, updated decisions |
| v2 | YYYY-MM-DD | `YYYY-MM-DD-v2-context.md` | Completed T001, started T002 |
| v1 | YYYY-MM-DD | `YYYY-MM-DD-v1-context.md` | Initial epic setup |

## When to Archive

Archive the context file when:
- Major milestone completed (task done, PR merged)
- Significant decision made
- Requirements changed substantially
- Before processing large draft

## Archive Naming Convention

```
YYYY-MM-DD-vN-context.md
```

- `YYYY-MM-DD` = date of archive
- `vN` = version number (incrementing)
- `context.md` = indicates it's a context file snapshot

## Archived Decisions

<!-- Quick reference for major decisions without loading full files -->

| Date | Decision | Version | Notes |
|------|----------|---------|-------|
| YYYY-MM-DD | Chose PostgreSQL over MongoDB | v1 | Relational data fits better |
| YYYY-MM-DD | JWT with 15min expiry | v2 | Balance security/UX |
| YYYY-MM-DD | Added rate limiting | v3 | Required for production |
