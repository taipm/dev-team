# Sequence Diagram Patterns

Reference cho tạo sequence diagrams hiệu quả.

---

## Common Patterns

### 1. Request-Response

```mermaid
sequenceDiagram
    participant C as Client
    participant S as Server

    C->>S: Request
    S-->>C: Response
```

### 2. Layered Architecture

```mermaid
sequenceDiagram
    participant C as Client
    participant H as Handler
    participant S as Service
    participant R as Repository
    participant D as Database

    C->>H: HTTP Request
    activate H
    H->>S: Call Service
    activate S
    S->>R: Query Data
    activate R
    R->>D: SQL Query
    D-->>R: Result Set
    deactivate R
    R-->>S: Domain Objects
    deactivate S
    S-->>H: Response DTO
    deactivate H
    H-->>C: HTTP Response
```

### 3. Authentication Flow

```mermaid
sequenceDiagram
    participant U as User
    participant C as Client
    participant A as Auth Service
    participant API as API Server
    participant DB as Database

    U->>C: Enter credentials
    C->>A: POST /auth/login
    A->>DB: Validate credentials
    alt Valid
        DB-->>A: User data
        A-->>C: JWT Token
        C->>API: Request + Token
        API->>A: Validate token
        A-->>API: Valid
        API-->>C: Protected resource
    else Invalid
        DB-->>A: Not found
        A-->>C: 401 Unauthorized
    end
```

### 4. CRUD Operations

#### Create
```mermaid
sequenceDiagram
    participant C as Client
    participant H as Handler
    participant S as Service
    participant R as Repository

    C->>H: POST /resources
    H->>H: Validate input
    H->>S: Create(input)
    S->>S: Business validation
    S->>R: Save(entity)
    R-->>S: Created entity
    S-->>H: DTO
    H-->>C: 201 Created
```

#### Read
```mermaid
sequenceDiagram
    participant C as Client
    participant H as Handler
    participant S as Service
    participant R as Repository
    participant Cache as Cache

    C->>H: GET /resources/:id
    H->>S: GetByID(id)
    S->>Cache: Get(key)
    alt Cache hit
        Cache-->>S: Cached data
    else Cache miss
        S->>R: FindByID(id)
        R-->>S: Entity
        S->>Cache: Set(key, data)
    end
    S-->>H: DTO
    H-->>C: 200 OK
```

### 5. Async Processing

```mermaid
sequenceDiagram
    participant C as Client
    participant API as API Server
    participant Q as Message Queue
    participant W as Worker

    C->>API: POST /jobs
    API->>Q: Enqueue job
    API-->>C: 202 Accepted (job_id)

    loop Poll
        C->>API: GET /jobs/:id
        API-->>C: Status: processing
    end

    W->>Q: Dequeue job
    W->>W: Process
    W->>API: Update status

    C->>API: GET /jobs/:id
    API-->>C: Status: completed
```

### 6. Webhook/Callback

```mermaid
sequenceDiagram
    participant C as Client
    participant API as API Server
    participant Ext as External Service

    C->>API: POST /orders
    API->>Ext: POST /payments
    Ext-->>API: payment_id

    Note over API: Wait for webhook

    Ext->>API: POST /webhook (payment_complete)
    API->>API: Update order status
    API-->>Ext: 200 OK

    C->>API: GET /orders/:id
    API-->>C: Order (status: paid)
```

---

## Advanced Features

### Loops

```mermaid
sequenceDiagram
    participant W as Worker
    participant Q as Queue

    loop Every 5 seconds
        W->>Q: Poll for jobs
        alt Jobs available
            Q-->>W: Job data
            W->>W: Process
        else No jobs
            Q-->>W: Empty
        end
    end
```

### Parallel

```mermaid
sequenceDiagram
    participant C as Client
    participant API as API

    C->>API: Request

    par Parallel calls
        API->>Service1: Call 1
        Service1-->>API: Response 1
    and
        API->>Service2: Call 2
        Service2-->>API: Response 2
    end

    API-->>C: Aggregated response
```

### Critical Section

```mermaid
sequenceDiagram
    participant A as Process A
    participant L as Lock
    participant R as Resource

    critical Acquire lock
        A->>L: Lock
        A->>R: Access resource
        R-->>A: Data
        A->>L: Unlock
    end
```

### Notes

```mermaid
sequenceDiagram
    participant A as Alice
    participant B as Bob

    A->>B: Hello
    Note right of B: Bob thinks
    B-->>A: Hi!
    Note over A,B: They are friends
```

---

## Best Practices

1. **Name participants clearly** - Use short, meaningful names
2. **Show activation** - Use activate/deactivate for long operations
3. **Group related messages** - Use boxes or notes
4. **Show alternatives** - Use alt/else for branches
5. **Limit width** - Max 5-6 participants
6. **Focus on key flow** - Skip logging, trivial calls
7. **Include timing** - Note delays when relevant
