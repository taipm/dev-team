# Diagram Best Practices

Guidelines để tạo diagrams hiệu quả và dễ đọc.

---

## General Principles

### 1. Clarity Over Completeness

- **Focus on key elements** - Not every class needs to be in diagram
- **7±2 rule** - Cognitive limit for elements per view
- **Multiple views** - Better than one overcrowded diagram

### 2. Consistent Abstraction Level

- **Don't mix levels** - System vs Container vs Code
- **One concept per diagram** - Architecture OR sequence, not both
- **Match audience** - Technical depth appropriate for reader

### 3. Visual Hierarchy

- **Important elements prominent** - Size, position, color
- **Group related items** - Subgraphs, containers
- **Flow direction consistent** - Left-to-right or top-to-bottom

---

## By Diagram Type

### Architecture Diagrams

**DO:**
- Show system boundaries clearly
- Include external systems
- Label relationships with protocols
- Use C4 levels appropriately

**DON'T:**
- Include implementation details
- Show database schema
- Mix system and code level

**Example Structure:**
```
Context Level:
- Users → System → External Systems

Container Level:
- System decomposed into deployable units
- Show technology choices
```

### Sequence Diagrams

**DO:**
- Focus on key scenarios
- Show happy path first
- Include error paths separately
- Use activation boxes

**DON'T:**
- Show every possible path
- Include logging calls
- Make diagrams too wide

**Example Structure:**
```
1. Authentication Flow
2. Main Business Flow
3. Error Handling Flow
```

### Class Diagrams

**DO:**
- Show public interfaces
- Include key methods only
- Group by domain
- Show relationships clearly

**DON'T:**
- List all getters/setters
- Include utility classes
- Show implementation details

**Example Structure:**
```
Domain Models:
- Core entities
- Value objects

Services:
- Public interfaces
- Key dependencies
```

### ERD Diagrams

**DO:**
- Include primary keys
- Show foreign key relationships
- Document cardinality
- Group related tables

**DON'T:**
- List every column
- Include audit fields
- Show junction table details

**Example Structure:**
```
Core Entities:
- User, Order, Product

Relationships:
- One-to-Many, Many-to-Many
```

### Flowcharts

**DO:**
- Clear start/end points
- Decision diamonds for branches
- Loop indicators
- Consistent direction

**DON'T:**
- Too many decision points
- Overlapping lines
- Unclear flow direction

**Example Structure:**
```
Start → Validate → Process → Success/Error → End
```

---

## Naming Conventions

### Elements
- **CamelCase** for classes: `UserService`, `OrderHandler`
- **snake_case** for tables: `user_orders`, `product_items`
- **lowercase** for containers: `web-app`, `api-server`

### Relationships
- Use **verbs**: "uses", "contains", "stores"
- Be **specific**: "reads from" vs "accesses"
- Include **protocol** when relevant: "HTTPS", "gRPC"

---

## Layout Guidelines

### Top-to-Bottom (TD)
- Hierarchical structures
- Inheritance diagrams
- Directory trees

### Left-to-Right (LR)
- Process flows
- Timelines
- Data pipelines

### Subgraphs
- Group by domain
- Group by layer
- Group by deployment

---

## Common Mistakes to Avoid

1. **Too many elements** - Split into multiple diagrams
2. **Unclear relationships** - Label all connections
3. **Missing legend** - Explain symbols used
4. **Outdated diagrams** - Keep in sync with code
5. **Wrong abstraction** - Match audience needs

---

## Review Checklist

Before finalizing:

- [ ] Can understand in < 30 seconds?
- [ ] Key elements highlighted?
- [ ] Relationships labeled?
- [ ] Abstraction level consistent?
- [ ] No overlapping lines?
- [ ] Direction consistent?
- [ ] Valid Mermaid syntax?
