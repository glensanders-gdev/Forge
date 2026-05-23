# Deep Modules

A deep module has a simple interface but rich, complex internals. The complexity is hidden behind the interface — callers don't need to know about it.

## What Makes a Module Deep

```
Simple interface  →  |████████████████|  ←  Complex implementation
                     |                |
                     |   All the      |
                     |   complexity   |
                     |   lives here   |
                     |________________|
```

- Small public API surface
- Hides implementation decisions that might change
- Independently testable through its interface
- Easy to mock or replace because the interface is narrow

## Shallow vs Deep

```javascript
// SHALLOW — complexity leaks out
class UserRepository {
  findByEmail(email) { ... }
  findById(id) { ... }
  findByEmailAndStatus(email, status) { ... }
  findActiveByEmail(email) { ... }  // grows forever
}

// DEEP — simple interface, rich internals
class UserRepository {
  find(criteria) { ... }  // one method handles all queries
}
```

## When to Extract a Deep Module

- When the same complexity appears in multiple places
- When internal implementation is likely to change
- When the logic is independently testable
- When a collaborator needs to be replaced for testing (keep the interface, swap the implementation)

## Deep Modules and TDD

Design the interface first — ask "what is the simplest API that satisfies these behaviours?"

Then write tests against that interface. The tests shouldn't care how the module works internally.

If your test needs to know about the internals to verify behaviour, the module isn't deep enough yet.
