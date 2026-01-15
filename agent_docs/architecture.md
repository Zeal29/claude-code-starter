# Architecture Overview

## High-Level Structure
```
[Client] → [API Gateway] → [Services] → [Database]
```

## Layers
1. **Presentation** - React components, pages
2. **Application** - API routes, controllers
3. **Domain** - Business logic, services
4. **Infrastructure** - DB, external APIs, caching

## Key Decisions
| Decision | Choice | Rationale |
|----------|--------|-----------|
| State mgmt | Zustand (client) + TanStack Query (server) | Simple, minimal boilerplate |
| Styling | TailwindCSS | Utility-first, fast iteration |
| API | REST with JSON | Simple, well-understood |
| Auth | JWT (access + refresh) | Stateless, scalable |

## Directory Mapping
```
src/
├── app/          → Presentation (Next.js routes)
├── components/   → Presentation (UI components)
├── lib/          → Domain + Infrastructure
├── hooks/        → Application (React hooks)
└── api/          → Application (API routes)
```

## Assumptions
- [List assumptions made about architecture]

## Unanswered Questions
- [List open architectural questions]
