# C4 Model Reference

Guidelines cho tạo C4 diagrams với Mermaid.

---

## C4 Overview

C4 = **C**ontext, **C**ontainers, **C**omponents, **C**ode

```
Level 1: System Context
    ↓
Level 2: Container
    ↓
Level 3: Component
    ↓
Level 4: Code (rarely needed)
```

---

## Level 1: System Context

**Purpose**: Big picture - how system fits in the world

**Elements**:
- **Person** - User or actor
- **System** - The system being designed
- **System_Ext** - External systems

### Mermaid Syntax

```mermaid
C4Context
    title System Context Diagram - E-Commerce Platform

    Person(customer, "Customer", "A user who buys products")
    Person(admin, "Admin", "System administrator")

    System(ecommerce, "E-Commerce Platform", "Allows customers to browse and purchase products")

    System_Ext(payment, "Payment Gateway", "Handles payment processing")
    System_Ext(shipping, "Shipping Provider", "Handles order delivery")
    System_Ext(email, "Email Service", "Sends notifications")

    Rel(customer, ecommerce, "Browses and purchases", "HTTPS")
    Rel(admin, ecommerce, "Manages", "HTTPS")
    Rel(ecommerce, payment, "Processes payments", "REST API")
    Rel(ecommerce, shipping, "Creates shipments", "REST API")
    Rel(ecommerce, email, "Sends emails", "SMTP")
```

### Guidelines

- Keep it simple (5-10 elements max)
- Focus on key interactions
- Don't show internal details
- Label relationships with protocol

---

## Level 2: Container

**Purpose**: High-level technical shape

**Elements**:
- **Container** - Deployable unit (app, database, etc.)
- **ContainerDb** - Database
- **Container_Ext** - External container
- **Container_Boundary** - Group containers

### Mermaid Syntax

```mermaid
C4Container
    title Container Diagram - E-Commerce Platform

    Person(customer, "Customer", "A user who buys products")

    Container_Boundary(ecommerce, "E-Commerce Platform") {
        Container(spa, "Web Application", "React", "Provides product browsing UI")
        Container(api, "API Server", "Go/Gin", "Handles business logic and API")
        Container(worker, "Background Worker", "Go", "Processes async jobs")
        ContainerDb(db, "Database", "PostgreSQL", "Stores orders, products, users")
        ContainerDb(cache, "Cache", "Redis", "Caches frequently accessed data")
    }

    System_Ext(payment, "Payment Gateway", "Stripe")

    Rel(customer, spa, "Uses", "HTTPS")
    Rel(spa, api, "Calls", "REST/JSON")
    Rel(api, db, "Reads/Writes", "SQL")
    Rel(api, cache, "Caches", "Redis Protocol")
    Rel(api, payment, "Processes payments", "REST API")
    Rel(worker, db, "Updates", "SQL")
```

### Guidelines

- Show deployable units
- Include technology choices
- Show data storage
- Group with boundaries

---

## Level 3: Component

**Purpose**: Internal structure of a container

**Elements**:
- **Component** - A component within container
- **Component_Ext** - External component

### Mermaid Syntax

```mermaid
C4Component
    title Component Diagram - API Server

    Container_Boundary(api, "API Server") {
        Component(handlers, "HTTP Handlers", "Go", "Handles HTTP requests")
        Component(services, "Business Services", "Go", "Contains business logic")
        Component(repos, "Repositories", "Go", "Data access layer")
        Component(auth, "Auth Middleware", "Go", "Handles authentication")
    }

    ContainerDb(db, "Database", "PostgreSQL")
    Container_Ext(cache, "Cache", "Redis")

    Rel(handlers, auth, "Uses")
    Rel(handlers, services, "Calls")
    Rel(services, repos, "Uses")
    Rel(repos, db, "Queries")
    Rel(services, cache, "Caches")
```

### Guidelines

- Focus on one container
- Show logical components
- Map dependencies
- Keep manageable (10-15 components)

---

## Element Reference

### People

```mermaid
C4Context
    Person(id, "Name", "Description")
    Person_Ext(id, "External Person", "Description")
```

### Systems

```mermaid
C4Context
    System(id, "Name", "Description")
    System_Ext(id, "External System", "Description")
```

### Containers

```mermaid
C4Container
    Container(id, "Name", "Technology", "Description")
    ContainerDb(id, "Database", "Technology", "Description")
    ContainerQueue(id, "Queue", "Technology", "Description")
    Container_Ext(id, "External", "Technology", "Description")
```

### Boundaries

```mermaid
C4Container
    Container_Boundary(id, "Name") {
        Container(...)
    }

    Enterprise_Boundary(id, "Name") {
        System(...)
    }
```

### Relationships

```mermaid
C4Context
    Rel(from, to, "Label")
    Rel(from, to, "Label", "Technology")
    Rel_D(from, to, "Label")  # Down
    Rel_U(from, to, "Label")  # Up
    Rel_L(from, to, "Label")  # Left
    Rel_R(from, to, "Label")  # Right
```

---

## Best Practices

1. **Start high, go low** - Context → Container → Component
2. **One level per diagram** - Don't mix
3. **Clear descriptions** - What it does, not how
4. **Technology labels** - On containers and components
5. **Relationship labels** - Include protocol
6. **Use boundaries** - Group related items
7. **Limit complexity** - 5-10 elements per diagram
