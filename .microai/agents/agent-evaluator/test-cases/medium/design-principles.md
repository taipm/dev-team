---
id: M-4
name: Interface Segregation Problem
category: Design
difficulty: 3
points: 5
keywords:
  - interface segregation
  - too large
  - Reader
  - smaller
  - ISP
  - SOLID
  - split
---

# Interface Segregation Problem

## Prompt

<prompt>
```go
type DataStore interface {
    Create(item Item) error
    Read(id string) (Item, error)
    Update(item Item) error
    Delete(id string) error
    List() ([]Item, error)
    Search(query string) ([]Item, error)
    Backup() error
    Restore() error
}
```

A component only needs to read items. What's the design problem?
</prompt>

## Expected Behavior

The answer should:
1. Identify Interface Segregation Principle (ISP) violation
2. Explain the problem with large interfaces
3. Propose smaller, focused interfaces
4. Show how to compose interfaces if needed

## Rubric

| Score | Criteria |
|-------|----------|
| 5 pts | Identifies ISP with refactored interface examples |
| 4 pts | Explains problem with splitting suggestion |
| 3 pts | Identifies interface is too large |
| 2 pts | Vague mention of design issue |
| 1 pt  | Notices something but unclear |
| 0 pts | Says design is fine |

## Good Answer Example

```
Problem: This violates the Interface Segregation Principle (ISP) from SOLID.

A component that only reads is forced to depend on Create, Update, Delete,
Backup, Restore methods it will never use. This:
1. Makes testing harder (must mock unused methods)
2. Creates unnecessary coupling
3. Makes the interface hard to implement

Solution - Split into focused interfaces:

type Reader interface {
    Read(id string) (Item, error)
}

type Writer interface {
    Create(item Item) error
    Update(item Item) error
    Delete(id string) error
}

type Searcher interface {
    List() ([]Item, error)
    Search(query string) ([]Item, error)
}

type BackupManager interface {
    Backup() error
    Restore() error
}

// Compose when needed
type DataStore interface {
    Reader
    Writer
    Searcher
    BackupManager
}

Now a read-only component only depends on Reader interface.
```

## Why This Test

- Tests SOLID principles knowledge
- Go's implicit interfaces make ISP natural
- Requires architectural thinking
- Common issue in real codebases
