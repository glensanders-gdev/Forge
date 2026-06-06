# Data Access & Input Validation

## SQL Injection

Always use parameterized queries or ORM methods. Never concatenate user input into SQL strings:

```typescript
// BAD: SQL injection via string concatenation
const result = await db.query(`SELECT * FROM users WHERE id = '${userId}'`);

// GOOD: parameterized query
const result = await db.query('SELECT * FROM users WHERE id = $1', [userId]);
```

## ORM Safety (Prisma)

Even with an ORM, injection is possible:

- **Validate input with Zod before passing to Prisma.** An attacker can send `{ "email": { "contains": "" } }` to match all records if an unvalidated object is passed as a filter.

```typescript
// BAD: raw request body passed directly to Prisma
const user = await prisma.user.findFirst({ where: req.body });

// GOOD: validate with Zod first
const schema = z.object({ email: z.string().email() });
const parsed = schema.parse(req.body);
const user = await prisma.user.findFirst({ where: { email: parsed.email } });
```

- **Never use `$queryRawUnsafe` or `$executeRawUnsafe` with user-supplied input** — these bypass Prisma's parameterization entirely.

```typescript
// BAD
const results = await prisma.$queryRawUnsafe(
  `SELECT * FROM users WHERE name = '${name}'`
);

// GOOD: use the safe tagged template
const results = await prisma.$queryRaw`
  SELECT * FROM users WHERE name = ${name}
`;
```

## Input Validation

Validate all external input at system boundaries using a runtime schema validator (Zod, Yup, Joi):

- API route handlers
- Server Actions
- Webhook handlers
- Form submissions
- URL parameters and query strings

TypeScript types provide **no runtime protection** — an attacker sending a malformed request bypasses all TypeScript checks. Always validate at the boundary.

## Mass Assignment

Never spread request body objects directly into database creates or updates:

```typescript
// BAD: attacker can set isAdmin, credits, subscriptionTier
await db.users.update({ where: { id }, data: { ...req.body } });

// GOOD: explicit allowlist
const { name, email } = req.body;
await db.users.update({ where: { id }, data: { name, email } });
```
