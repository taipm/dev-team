# ERD Patterns

Reference cho tạo Entity-Relationship diagrams.

---

## Basic Syntax

```mermaid
erDiagram
    TABLE_NAME {
        type column_name constraints
    }
```

### Column Types
- `uuid`, `int`, `bigint`
- `string`, `text`
- `decimal`, `float`
- `boolean`
- `timestamp`, `date`
- `json`

### Constraints
- `PK` - Primary Key
- `FK` - Foreign Key
- `UK` - Unique Key

---

## Relationship Notation

| Left | Right | Meaning |
|------|-------|---------|
| `\|o` | `o\|` | Zero or one |
| `\|\|` | `\|\|` | Exactly one |
| `}o` | `o{` | Zero or more |
| `}\|` | `\|{` | One or more |

### Examples

```mermaid
erDiagram
    A ||--o{ B : "one to many"
    C ||--|| D : "one to one"
    E }o--o{ F : "many to many"
```

---

## Common Patterns

### User and Orders (1:N)

```mermaid
erDiagram
    USER ||--o{ ORDER : places

    USER {
        uuid id PK
        string name
        string email UK
        string password_hash
        timestamp created_at
    }

    ORDER {
        uuid id PK
        uuid user_id FK
        decimal total
        string status
        timestamp created_at
    }
```

### Order with Items (1:N with Product)

```mermaid
erDiagram
    ORDER ||--|{ ORDER_ITEM : contains
    PRODUCT ||--o{ ORDER_ITEM : "is in"

    ORDER {
        uuid id PK
        uuid user_id FK
        decimal total
    }

    ORDER_ITEM {
        uuid id PK
        uuid order_id FK
        uuid product_id FK
        int quantity
        decimal unit_price
    }

    PRODUCT {
        uuid id PK
        string name
        decimal price
        int stock
    }
```

### Many-to-Many with Junction Table

```mermaid
erDiagram
    STUDENT }o--o{ COURSE : enrolls
    STUDENT ||--o{ ENROLLMENT : has
    COURSE ||--o{ ENROLLMENT : has

    STUDENT {
        uuid id PK
        string name
        string email UK
    }

    COURSE {
        uuid id PK
        string title
        int credits
    }

    ENROLLMENT {
        uuid id PK
        uuid student_id FK
        uuid course_id FK
        string grade
        timestamp enrolled_at
    }
```

### Self-Reference (Hierarchical)

```mermaid
erDiagram
    CATEGORY {
        uuid id PK
        uuid parent_id FK
        string name
        int level
    }

    CATEGORY ||--o{ CATEGORY : "has children"
```

### Polymorphic Association

```mermaid
erDiagram
    COMMENT {
        uuid id PK
        string commentable_type
        uuid commentable_id
        string body
    }

    POST {
        uuid id PK
        string title
    }

    PHOTO {
        uuid id PK
        string url
    }

    POST ||--o{ COMMENT : has
    PHOTO ||--o{ COMMENT : has
```

---

## Full E-Commerce Example

```mermaid
erDiagram
    USER ||--o{ ORDER : places
    USER ||--o{ ADDRESS : has
    USER ||--o{ REVIEW : writes
    ORDER ||--|{ ORDER_ITEM : contains
    ORDER ||--|| ADDRESS : "ships to"
    PRODUCT ||--o{ ORDER_ITEM : "is ordered"
    PRODUCT }|--|| CATEGORY : "belongs to"
    PRODUCT ||--o{ REVIEW : has
    PRODUCT ||--o{ PRODUCT_IMAGE : has

    USER {
        uuid id PK
        string name
        string email UK
        string password_hash
        boolean is_active
        timestamp created_at
        timestamp updated_at
    }

    ADDRESS {
        uuid id PK
        uuid user_id FK
        string type
        string street
        string city
        string state
        string postal_code
        string country
        boolean is_default
    }

    ORDER {
        uuid id PK
        uuid user_id FK
        uuid shipping_address_id FK
        string order_number UK
        decimal subtotal
        decimal tax
        decimal shipping
        decimal total
        string status
        timestamp ordered_at
        timestamp shipped_at
        timestamp delivered_at
    }

    ORDER_ITEM {
        uuid id PK
        uuid order_id FK
        uuid product_id FK
        int quantity
        decimal unit_price
        decimal subtotal
    }

    PRODUCT {
        uuid id PK
        uuid category_id FK
        string sku UK
        string name
        text description
        decimal price
        decimal cost
        int stock
        boolean is_active
    }

    CATEGORY {
        uuid id PK
        uuid parent_id FK
        string name
        string slug UK
        int level
    }

    REVIEW {
        uuid id PK
        uuid user_id FK
        uuid product_id FK
        int rating
        text comment
        timestamp created_at
    }

    PRODUCT_IMAGE {
        uuid id PK
        uuid product_id FK
        string url
        int position
        boolean is_primary
    }
```

---

## Best Practices

1. **Always use primary keys** - `uuid id PK`
2. **Mark foreign keys** - `uuid user_id FK`
3. **Show unique constraints** - `string email UK`
4. **Include important columns only** - Skip audit fields if not relevant
5. **Name relationships** - Use verbs: "places", "contains", "has"
6. **Group related tables** - Keep related entities near each other
7. **Use singular table names** - `USER` not `USERS`
