# Mermaid Syntax Reference

Quick reference cho tất cả Mermaid diagram types được sử dụng trong Diagram-Team.

---

## 1. Flowchart

```mermaid
flowchart TD
    A[Rectangle] --> B{Diamond}
    B -->|Yes| C[Process]
    B -->|No| D[End]
```

### Node Shapes
| Syntax | Shape |
|--------|-------|
| `[text]` | Rectangle |
| `{text}` | Diamond (decision) |
| `([text])` | Stadium |
| `[[text]]` | Subroutine |
| `[(text)]` | Cylinder (database) |
| `((text))` | Circle |

### Arrows
| Syntax | Type |
|--------|------|
| `-->` | Arrow |
| `---` | Line |
| `-.->` | Dotted arrow |
| `==>` | Thick arrow |

### Direction
- `TD` / `TB` = Top to Bottom
- `BT` = Bottom to Top
- `LR` = Left to Right
- `RL` = Right to Left

---

## 2. Sequence Diagram

```mermaid
sequenceDiagram
    participant A as Alice
    participant B as Bob
    A->>B: Hello
    B-->>A: Hi
```

### Message Types
| Syntax | Type |
|--------|------|
| `->` | Solid line without arrow |
| `-->` | Dotted line without arrow |
| `->>` | Solid line with arrow |
| `-->>` | Dotted line with arrow |
| `-x` | Solid line with X |
| `--x` | Dotted line with X |

### Activation
```mermaid
sequenceDiagram
    A->>+B: Request
    B-->>-A: Response
```

### Alt/Opt/Loop
```mermaid
sequenceDiagram
    alt Condition
        A->>B: Message
    else Other
        A->>C: Message
    end
```

---

## 3. Class Diagram

```mermaid
classDiagram
    class Animal {
        +String name
        +int age
        +makeSound()
    }
    class Dog {
        +bark()
    }
    Animal <|-- Dog
```

### Visibility
| Symbol | Access |
|--------|--------|
| `+` | Public |
| `-` | Private |
| `#` | Protected |
| `~` | Package |

### Relationships
| Syntax | Type |
|--------|------|
| `<\|--` | Inheritance |
| `<\|..` | Realization |
| `-->` | Association |
| `--*` | Composition |
| `--o` | Aggregation |
| `..>` | Dependency |

---

## 4. ERD (Entity Relationship)

```mermaid
erDiagram
    USER ||--o{ ORDER : places
    ORDER ||--|{ LINE_ITEM : contains

    USER {
        int id PK
        string name
        string email UK
    }
```

### Cardinality
| Syntax | Meaning |
|--------|---------|
| `\|\|` | Exactly one |
| `\|o` | Zero or one |
| `}o` | Zero or more |
| `}\|` | One or more |

---

## 5. State Diagram

```mermaid
stateDiagram-v2
    [*] --> State1
    State1 --> State2
    State2 --> [*]
```

### Transitions
```mermaid
stateDiagram-v2
    s1 --> s2 : Event
```

### Composite States
```mermaid
stateDiagram-v2
    state Composite {
        s1 --> s2
    }
```

---

## 6. C4 Diagrams

### C4 Context
```mermaid
C4Context
    Person(user, "User", "Description")
    System(system, "System", "Description")
    System_Ext(ext, "External", "Description")
    Rel(user, system, "Uses")
```

### C4 Container
```mermaid
C4Container
    Container(web, "Web App", "React", "Description")
    ContainerDb(db, "Database", "PostgreSQL", "Description")
    Container_Boundary(c1, "System") {
        Container(api, "API", "Go", "Description")
    }
```

---

## 7. Graph (for Directory Structure)

```mermaid
graph TD
    root["project/"]
    root --> src["src/"]
    root --> tests["tests/"]
    src --> main["main.go"]
```

---

## Styling

### Node Style
```mermaid
flowchart TD
    A[Node]:::green
    classDef green fill:#9f6,stroke:#333
```

### Link Style
```mermaid
flowchart TD
    A --> B
    linkStyle 0 stroke:red
```

---

## Best Practices

1. **Keep it simple** - 7±2 elements per diagram
2. **Use subgraphs** - Group related items
3. **Clear labels** - Descriptive but concise
4. **Consistent direction** - TD for hierarchy, LR for flows
5. **Valid syntax** - Test in Mermaid Live Editor
