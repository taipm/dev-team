# Flowchart Patterns

Reference cho tạo logic flow diagrams.

---

## Basic Syntax

```mermaid
flowchart TD
    A[Start] --> B{Decision}
    B -->|Yes| C[Action]
    B -->|No| D[End]
```

---

## Node Shapes

| Syntax | Shape | Use For |
|--------|-------|---------|
| `[text]` | Rectangle | Process/Action |
| `{text}` | Diamond | Decision |
| `([text])` | Stadium | Start/End |
| `[[text]]` | Subroutine | Sub-process |
| `[(text)]` | Cylinder | Database |
| `((text))` | Circle | Connector |
| `>text]` | Asymmetric | Note |
| `{{text}}` | Hexagon | Preparation |

---

## Common Patterns

### Linear Process

```mermaid
flowchart TD
    A([Start]) --> B[Step 1]
    B --> C[Step 2]
    C --> D[Step 3]
    D --> E([End])
```

### If-Else

```mermaid
flowchart TD
    A([Start]) --> B{Condition?}
    B -->|Yes| C[Action A]
    B -->|No| D[Action B]
    C --> E([End])
    D --> E
```

### Multiple Conditions

```mermaid
flowchart TD
    A([Start]) --> B{Check Type}
    B -->|Type A| C[Handle A]
    B -->|Type B| D[Handle B]
    B -->|Type C| E[Handle C]
    B -->|Default| F[Handle Default]
    C --> G([End])
    D --> G
    E --> G
    F --> G
```

### Loop (While)

```mermaid
flowchart TD
    A([Start]) --> B[Initialize]
    B --> C{Condition met?}
    C -->|No| D[Process item]
    D --> E[Update counter]
    E --> C
    C -->|Yes| F([End])
```

### Loop (For Each)

```mermaid
flowchart TD
    A([Start]) --> B[Get items]
    B --> C{More items?}
    C -->|Yes| D[Get next item]
    D --> E[Process item]
    E --> C
    C -->|No| F([End])
```

### Try-Catch

```mermaid
flowchart TD
    A([Start]) --> B[Try operation]
    B --> C{Success?}
    C -->|Yes| D[Continue]
    C -->|No| E[Handle error]
    E --> F{Recoverable?}
    F -->|Yes| G[Retry]
    G --> B
    F -->|No| H[Log & Exit]
    D --> I([End])
    H --> I
```

---

## Advanced Patterns

### Request Handling

```mermaid
flowchart TD
    A([Request]) --> B{Authenticated?}
    B -->|No| C[Return 401]
    B -->|Yes| D{Authorized?}
    D -->|No| E[Return 403]
    D -->|Yes| F{Valid input?}
    F -->|No| G[Return 400]
    F -->|Yes| H[Process]
    H --> I{Success?}
    I -->|No| J[Return 500]
    I -->|Yes| K[Return 200]

    style C fill:#f66
    style E fill:#f66
    style G fill:#f66
    style J fill:#f66
    style K fill:#6f6
```

### Order Processing

```mermaid
flowchart TD
    A([New Order]) --> B[Validate Order]
    B --> C{Valid?}
    C -->|No| D[Reject Order]
    C -->|Yes| E[Check Inventory]
    E --> F{In Stock?}
    F -->|No| G[Backorder]
    F -->|Yes| H[Reserve Stock]
    H --> I[Calculate Total]
    I --> J[Apply Discounts]
    J --> K[Process Payment]
    K --> L{Payment OK?}
    L -->|No| M[Release Stock]
    M --> N[Payment Failed]
    L -->|Yes| O[Create Shipment]
    O --> P[Send Confirmation]
    P --> Q([Order Complete])

    subgraph Inventory
        E
        F
        G
        H
    end

    subgraph Payment
        I
        J
        K
        L
        M
        N
    end

    subgraph Fulfillment
        O
        P
    end
```

### State Machine

```mermaid
flowchart LR
    A([Draft]) --> B([Submitted])
    B --> C([Processing])
    C --> D([Completed])
    C --> E([Failed])
    E --> C

    style A fill:#eee
    style B fill:#aaf
    style C fill:#ffa
    style D fill:#afa
    style E fill:#faa
```

---

## Subgraphs

```mermaid
flowchart TD
    subgraph Frontend
        A[User Action] --> B[Send Request]
    end

    subgraph Backend
        C[Handle Request] --> D[Business Logic]
        D --> E[Data Access]
    end

    subgraph Database
        F[(Store Data)]
    end

    B --> C
    E --> F
```

---

## Styling

### Node Colors

```mermaid
flowchart TD
    A[Success]:::success --> B[Warning]:::warning --> C[Error]:::error

    classDef success fill:#9f6,stroke:#333
    classDef warning fill:#ff9,stroke:#333
    classDef error fill:#f66,stroke:#333
```

### Link Styles

```mermaid
flowchart TD
    A --> B
    B --> C
    linkStyle 0 stroke:green
    linkStyle 1 stroke:red,stroke-dasharray: 5 5
```

---

## Best Practices

1. **Clear start/end** - Use stadium shapes
2. **Decision diamonds** - Use for all branches
3. **Consistent direction** - TD for vertical, LR for horizontal
4. **Group with subgraphs** - Related steps together
5. **Label arrows** - Especially for decisions
6. **Color code** - Success/error paths
7. **Keep simple** - Max 15-20 nodes
