# Mocking Guidelines

Mocks are a tool for controlling external dependencies — not a substitute for testing real behaviour.

## When to Mock

Mock when:
- The dependency is genuinely external (network, database, filesystem, time)
- The real implementation is slow, flaky, or has side effects in tests
- You need to test error paths that are hard to trigger with real implementations

Do NOT mock:
- Internal collaborators within the same module
- Pure functions
- Simple data objects
- Anything you own and control that isn't slow or stateful

## The Rule

**Mock at the boundary of your system, not inside it.**

```javascript
// WRONG — mocking internal collaborator
test("processOrder notifies user", async () => {
  const mockNotifier = jest.mock(InternalNotifier);
  await processOrder(order);
  expect(mockNotifier.notify).toHaveBeenCalled();
});

// RIGHT — mocking external boundary
test("processOrder sends confirmation email", async () => {
  const mockEmailService = jest.mock(ExternalEmailAPI);
  await processOrder(order);
  expect(mockEmailService.send).toHaveBeenCalledWith(
    expect.objectContaining({ to: order.userEmail })
  );
});
```

## Mock Boundaries in Forge Projects

Common boundaries worth mocking:
- External APIs and third-party SDKs
- Database clients (use an in-memory or test database instead where possible)
- Email/SMS/notification services
- File system operations
- `Date.now()` and time-dependent logic
- Feature flags

## Warning Signs Your Mocks Are Wrong

- You're mocking more than 2–3 things in one test
- Your mock setup is longer than the assertion
- Tests pass but the feature doesn't work in production
- You have to update mocks every time you refactor
