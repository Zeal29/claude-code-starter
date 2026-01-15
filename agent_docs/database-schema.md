# Database Schema

## Overview
Database: PostgreSQL / MongoDB (update as needed)
ORM: Prisma / Mongoose

## Tables/Collections

### users
| Column | Type | Constraints |
|--------|------|-------------|
| id | uuid | PK |
| email | varchar(255) | unique, not null |
| password_hash | varchar(255) | not null |
| created_at | timestamp | default now() |
| updated_at | timestamp | auto-update |

### [other_table]
<!-- Add your tables here -->

## Relationships
```
users 1---* orders (user_id FK)
orders *---* products (order_items junction)
```

## Indexes
- `users.email` - unique index for login lookup
- [Add performance-critical indexes]

## Migrations
```bash
npx prisma migrate dev --name description
npx prisma migrate deploy  # production
```

## Assumptions
- [Schema assumptions]

## Unanswered Questions
- [Open questions about data model]
