---
scope: "src/app/**/*"
---
# Next.js App Router Rules

## File Conventions
- `page.tsx` - route page component
- `layout.tsx` - shared layout
- `loading.tsx` - loading UI
- `error.tsx` - error boundary
- `not-found.tsx` - 404 page

## Component Types
```typescript
// Server Component (default) - no 'use client'
export const ServerComp = async () => {
  const data = await fetchData(); // can await directly
  return <div>{data}</div>;
};

// Client Component - needs interactivity
'use client';
export const ClientComp = () => {
  const [state, setState] = useState();
  return <button onClick={() => setState(x)}>Click</button>;
};
```

## Rules
- Default to Server Components
- Only add 'use client' when needed (hooks, events, browser APIs)
- Keep client components small, push logic to server
- Use `loading.tsx` over manual loading states
- Use `error.tsx` over manual error boundaries

## Data Fetching
- Fetch in Server Components, not client
- Use React cache() for deduplication
- Revalidate with `revalidatePath` or `revalidateTag`
