# Software Design Patterns

> Language-agnostic design patterns for building maintainable software.

---

## Pattern Categories

| Category | Purpose | Examples |
|----------|---------|----------|
| **Creational** | Object creation | Factory, Singleton, Builder |
| **Structural** | Object composition | Adapter, Decorator, Facade |
| **Behavioral** | Object communication | Strategy, Observer, Command |

---

## Creational Patterns

### Factory

Create objects without exposing creation logic.

```
Client → Factory.create(type) → Product

Use when:
- Object type determined at runtime
- Multiple product types with common interface
- Decouple creation from usage
```

| Pros | Cons |
|------|------|
| Decoupling | Can grow large |
| Single point of creation | Indirect instantiation |
| Easy to extend | Over-engineering for simple cases |

### Builder

Construct complex objects step by step.

```
Director → Builder.step1().step2().build() → Product

Use when:
- Object has many optional fields
- Complex initialization logic
- Different representations needed
```

| Pros | Cons |
|------|------|
| Fluent API | More code |
| Immutable objects | Requires builder class |
| Step-by-step construction | Overkill for simple objects |

### Singleton

Ensure single instance with global access.

```
Singleton.getInstance() → always same instance

Use when:
- Exactly one instance needed (config, logger)
- Controlled access required
- Lazy initialization desired
```

| Pros | Cons |
|------|------|
| Global access | Global state (testing nightmare) |
| Lazy initialization | Hidden dependencies |
| Controlled access | Tight coupling |

**Warning:** Often considered anti-pattern. Prefer dependency injection.

---

## Structural Patterns

### Adapter

Convert interface to another expected interface.

```
Client → Adapter → Adaptee (legacy/third-party)

Use when:
- Using incompatible interfaces
- Wrapping legacy code
- Third-party library integration
```

| Pros | Cons |
|------|------|
| Reuse existing code | Indirection |
| Interface compatibility | Can mask bad design |
| Open/closed principle | Complexity |

### Decorator

Add behavior dynamically without modifying original.

```
Client → Decorator → Decorator → Component

Use when:
- Add responsibilities dynamically
- Avoid subclass explosion
- Behaviors can be combined
```

| Pros | Cons |
|------|------|
| Dynamic composition | Many small objects |
| Single responsibility | Order matters |
| Open/closed principle | Complex to debug |

### Facade

Simplified interface to complex subsystem.

```
Client → Facade → Complex Subsystem

Use when:
- Complex subsystem needs simple interface
- Decouple client from subsystem
- Layered architecture
```

| Pros | Cons |
|------|------|
| Simplified interface | Can become god object |
| Decoupling | May hide useful features |
| Single entry point | Over-simplification |

---

## Behavioral Patterns

### Strategy

Define family of algorithms, make them interchangeable.

```
Context → Strategy interface → ConcreteStrategy

Use when:
- Multiple algorithms for same task
- Algorithm selection at runtime
- Avoid conditional logic
```

| Pros | Cons |
|------|------|
| Open/closed principle | Client must know strategies |
| Runtime switching | More classes |
| Eliminate conditionals | Over-engineering risk |

### Observer

One-to-many dependency, auto-notify on change.

```
Subject.notify() → Observer1.update(), Observer2.update()...

Use when:
- State changes need to notify multiple objects
- Loosely coupled communication
- Event-driven architecture
```

| Pros | Cons |
|------|------|
| Loose coupling | Unexpected updates |
| Open/closed principle | Memory leaks if not unsubscribed |
| Broadcast communication | Update order not guaranteed |

### Command

Encapsulate request as object.

```
Invoker → Command.execute() → Receiver

Use when:
- Parameterize actions
- Queue operations
- Support undo/redo
- Log operations
```

| Pros | Cons |
|------|------|
| Decouple invoker/receiver | More classes |
| Undo/redo support | Complexity |
| Queueing/logging | Indirection |

### Template Method

Define algorithm skeleton, let subclasses fill in steps.

```
AbstractClass.templateMethod() calls:
  - step1()    (abstract - subclass implements)
  - step2()    (concrete - base provides)
  - step3()    (abstract - subclass implements)
```

| Pros | Cons |
|------|------|
| Code reuse | Inheritance coupling |
| Inversion of control | Limited flexibility |
| Consistent algorithm | Can be fragile |

---

## Pattern Selection Guide

| Problem | Pattern | Why |
|---------|---------|-----|
| Create object based on type | Factory | Decouple creation |
| Configure complex object | Builder | Step-by-step construction |
| Wrap incompatible interface | Adapter | Interface translation |
| Add behavior dynamically | Decorator | Runtime composition |
| Simplify complex API | Facade | Single entry point |
| Switch algorithms at runtime | Strategy | Eliminate conditionals |
| React to state changes | Observer | Loose coupling |
| Support undo/redo | Command | Encapsulate action |
| Reuse algorithm structure | Template Method | Define skeleton |

---

## Anti-Pattern Warnings

| Pattern | Common Misuse |
|---------|---------------|
| Singleton | Global mutable state, testing difficulty |
| Factory | Over-abstraction for simple creation |
| Observer | Memory leaks, unexpected cascades |
| Decorator | Too many layers, hard to debug |

---

## Quick Reference

```
Creational:
  Factory   = "Create for me"
  Builder   = "Build step by step"
  Singleton = "Only one exists"

Structural:
  Adapter   = "Make it fit"
  Decorator = "Add behavior"
  Facade    = "Make it simple"

Behavioral:
  Strategy  = "Pick algorithm"
  Observer  = "Notify changes"
  Command   = "Encapsulate action"
  Template  = "Fill in the steps"
```

---

*Knowledge Forge: Universal Layer*
*Applicable to: All agents, all languages*
