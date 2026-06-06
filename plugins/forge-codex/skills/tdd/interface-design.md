# Interface Design for Testability

Interfaces designed for testability are easier to test AND easier to use. Good interface design and TDD reinforce each other.

## Principles

### Depend on abstractions, not concretions
Pass dependencies in rather than creating them internally. This makes swapping implementations for tests trivial.

```javascript
// HARD TO TEST — creates its own dependency
class OrderService {
  process(order) {
    const emailer = new EmailService();  // can't swap this
    emailer.send(order.userEmail, "Order confirmed");
  }
}

// EASY TO TEST — dependency injected
class OrderService {
  constructor(emailer) {
    this.emailer = emailer;
  }
  process(order) {
    this.emailer.send(order.userEmail, "Order confirmed");
  }
}
```

### Return values over side effects where possible
Functions that return values are easier to test than functions that produce side effects.

### Keep interfaces narrow
The fewer methods on a public interface, the fewer test cases needed to cover it.

### Name interfaces after behaviour, not implementation
`Notifier` not `EmailSender` — the interface shouldn't reveal how it works.

## Design Questions to Ask Before Writing Tests

1. What is the minimum public surface needed to satisfy the behaviours?
2. What dependencies does this module need — can they be injected?
3. What does a caller need to observe to know this worked?
4. What can change internally without affecting callers?

## Interface Design and the PRD

The PRD's Implementation Decisions section should capture interface contracts. If an interface decision is hard to reverse, it warrants an ADR. The testplan should verify the interface, not the implementation.
