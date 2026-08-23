# Authentication & Authorization

## JWT Handling

- **Use `jwt.verify()`, never `jwt.decode()` alone.** `decode` reads the payload without checking the signature — an attacker can forge any payload.
- **Explicitly reject `"alg": "none"`.** Some JWT libraries accept unsigned tokens if the algorithm is `"none"`. Reject it.
- **Validate issuer, audience, and expiration** — not just the signature.

```typescript
// BAD: reads token without verifying signature
const payload = jwt.decode(token);

// GOOD: verifies signature, rejects tampered tokens
const payload = jwt.verify(token, secret, {
  algorithms: ['HS256'],
  issuer: 'your-app',
});
```

## Next.js Middleware Is Not Enough

Next.js middleware runs at the edge and is convenient for auth checks, but **is not a reliable sole auth layer**. CVE-2025-29927 demonstrated middleware could be completely bypassed via a spoofed `x-middleware-subrequest` header.

Always verify auth again in:
- Server Actions
- Route Handlers (`app/api/`)
- Data access functions / database queries

Middleware is a convenience layer, not the only wall between an attacker and your data.

## Server Actions Are Public Endpoints

Server Actions compile into public POST endpoints. Anyone can call them with `curl`. Every Server Action needs three things at the top:

```typescript
// BAD: no auth, no validation
'use server';
export async function deleteItem(id: string) {
  await db.items.delete({ where: { id } });
}

// GOOD: validate input, authenticate, authorize
'use server';
export async function deleteItem(input: unknown) {
  const parsed = schema.safeParse(input);
  if (!parsed.success) return { error: 'Invalid input' };

  const session = await auth();
  if (!session?.user) redirect('/login');

  // Authorize: verify ownership, not just login
  await db.items.deleteMany({
    where: { id: parsed.data.id, userId: session.user.id }
  });
}
```

1. Input validation (Zod or equivalent)
2. Authentication (user is logged in)
3. Authorization (user owns or has permission for this resource)

## Token Storage

- **Web:** store tokens in `httpOnly` cookies, not `localStorage`. `localStorage` is readable by any JavaScript on the page — XSS gives full token access.
- **Mobile:** use `expo-secure-store` or `react-native-keychain`. Never `AsyncStorage` — it's unencrypted plaintext on disk.
