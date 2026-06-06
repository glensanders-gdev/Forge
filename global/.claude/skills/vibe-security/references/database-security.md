# Database Access Control

This is the #1 source of critical vulnerabilities in AI-generated apps. AI assistants routinely generate schemas without access control, leaving entire tables exposed.

## Supabase Row-Level Security (RLS)

### Enable RLS on Every Table

Tables created via SQL Editor or migrations have RLS **disabled by default**. A table without RLS is fully readable and writable by anyone with the anon key (which is public). Run this in every migration to catch missed tables:

```sql
DO $$ DECLARE r RECORD;
BEGIN
  FOR r IN SELECT tablename FROM pg_tables WHERE schemaname = 'public'
  LOOP
    EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY;', r.tablename);
  END LOOP;
END $$;
```

### Dangerous RLS Policies

Never use `USING (true)` or `USING (auth.uid() IS NOT NULL)` on SELECT/UPDATE/DELETE — these let any authenticated user access every row:

```sql
-- BAD: any logged-in user reads all rows
CREATE POLICY "view" ON public.documents
  FOR SELECT TO authenticated USING (true);

-- GOOD: users read only their own rows
CREATE POLICY "view own" ON public.documents
  FOR SELECT TO authenticated USING ((SELECT auth.uid()) = user_id);
```

### Missing WITH CHECK

Always include `WITH CHECK` on INSERT and UPDATE policies. Without it, a user can reassign row ownership:

```sql
-- BAD: user can UPDATE user_id to someone else's
CREATE POLICY "update tasks" ON public.tasks
  FOR UPDATE TO authenticated USING ((SELECT auth.uid()) = user_id);

-- GOOD
CREATE POLICY "update tasks" ON public.tasks
  FOR UPDATE TO authenticated
  USING ((SELECT auth.uid()) = user_id)
  WITH CHECK ((SELECT auth.uid()) = user_id);
```

### Sensitive Fields on User-Accessible Tables

If a `profiles` table lets users UPDATE their own row, they can set `is_admin = true` or `credits = 99999`. Fixes:
- **Option A:** Move sensitive fields to a `private` schema table not exposed via PostgREST. Access via `SECURITY DEFINER` functions.
- **Option B:** Use column-level privileges to restrict which columns are writable.

## Firebase Security Rules

Never use `allow read, write: if true` — this exposes the entire collection publicly:

```javascript
// BAD
match /documents/{docId} {
  allow read, write: if true;
}

// GOOD
match /documents/{docId} {
  allow read, write: if request.auth != null && request.auth.uid == resource.data.userId;
}
```

## Convex

Every Convex query and mutation that accesses user data must validate auth:

```typescript
// BAD: no auth check
export const getItems = query(async ({ db }) => {
  return await db.query("items").collect();
});

// GOOD
export const getItems = query(async ({ db, auth }) => {
  const identity = await auth.getUserIdentity();
  if (!identity) throw new Error("Unauthenticated");
  return await db.query("items")
    .filter(q => q.eq(q.field("userId"), identity.subject))
    .collect();
});
```
