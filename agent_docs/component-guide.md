# Component Guide

## Naming Conventions
- PascalCase for components: `UserCard.tsx`
- camelCase for hooks: `useUserData.ts`
- kebab-case for routes: `/user-settings`

## Component Structure
```typescript
// 1. Imports
import { useState } from 'react';
import { cn } from '@/lib/utils';

// 2. Types
interface UserCardProps {
  user: User;
  onEdit?: (id: string) => void;
}

// 3. Component (named export)
export const UserCard = ({ user, onEdit }: UserCardProps) => {
  // hooks first
  const [isOpen, setIsOpen] = useState(false);
  
  // handlers
  const handleEdit = () => onEdit?.(user.id);
  
  // render
  return (
    <div className={cn('p-4 rounded', isOpen && 'bg-gray-100')}>
      {user.name}
    </div>
  );
};
```

## File Organization
```
components/
├── ui/              # Generic reusable (Button, Input, Modal)
├── features/        # Feature-specific (UserCard, OrderList)
└── layouts/         # Layout components (Header, Sidebar)
```

## Testing
- Test file: `__tests__/ComponentName.test.tsx`
- Use React Testing Library
- Test user interactions, not implementation

## Assumptions
- [Component assumptions]

## Unanswered Questions
- [Open component questions]
