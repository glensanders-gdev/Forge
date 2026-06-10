# Payment Security (Stripe)

## Never Trust Client-Submitted Prices

The #1 payment vulnerability in AI-generated apps: the price comes from the client. An attacker can set any amount, including $0.

```typescript
// BAD: price comes from the request body
const session = await stripe.checkout.sessions.create({
  line_items: [{
    price_data: {
      currency: 'usd',
      unit_amount: req.body.price, // attacker controls this
    },
    quantity: 1,
  }],
});

// GOOD: look up the price server-side
const product = await db.products.findUnique({ where: { id: req.body.productId } });
if (!product) return new Response('Not found', { status: 404 });

const session = await stripe.checkout.sessions.create({
  line_items: [{ price: product.stripePriceId, quantity: 1 }],
});
```

Use Stripe Price IDs (created in the Stripe dashboard) rather than constructing prices from your database. Prices are defined in Stripe and cannot be manipulated.

## Webhook Signature Verification

Stripe webhooks must have signatures verified. This requires the **raw request body** — parsing as JSON first destroys the signature.

```typescript
// Express: webhook route MUST use express.raw() before express.json()
app.post('/webhook', express.raw({ type: 'application/json' }), (req, res) => {
  const sig = req.headers['stripe-signature'];
  const event = stripe.webhooks.constructEvent(req.body, sig, webhookSecret);
});

// Next.js App Router: use request.text(), NOT request.json()
export async function POST(request: Request) {
  const body = await request.text();
  const sig = request.headers.get('stripe-signature')!;
  const event = stripe.webhooks.constructEvent(body, sig, webhookSecret);
}
```

## Subscription Status Validation

Check subscription status **server-side on every protected request** via your database (kept in sync via webhooks). Do not rely on:
- A cached session value from login time
- A client-side flag
- A JWT claim set at token creation

Subscriptions can be cancelled, expire, or change tier at any time. Your database (updated via Stripe webhooks) is the source of truth.
