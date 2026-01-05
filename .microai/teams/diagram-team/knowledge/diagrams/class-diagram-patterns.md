# Class Diagram Patterns

Reference cho tạo class diagrams hiệu quả.

---

## Relationship Types

### Inheritance (Generalization)

```mermaid
classDiagram
    class Animal {
        +String name
        +makeSound()
    }
    class Dog {
        +bark()
    }
    class Cat {
        +meow()
    }

    Animal <|-- Dog
    Animal <|-- Cat
```

### Interface Implementation

```mermaid
classDiagram
    class Repository {
        <<interface>>
        +Save(entity)
        +FindByID(id)
        +Delete(id)
    }
    class PostgresRepo {
        -db: DB
        +Save(entity)
        +FindByID(id)
        +Delete(id)
    }
    class MemoryRepo {
        -data: Map
        +Save(entity)
        +FindByID(id)
        +Delete(id)
    }

    Repository <|.. PostgresRepo
    Repository <|.. MemoryRepo
```

### Association

```mermaid
classDiagram
    class Order {
        +String id
        +getTotal()
    }
    class Customer {
        +String name
        +getOrders()
    }

    Customer --> Order : places
```

### Composition

```mermaid
classDiagram
    class Order {
        +String id
        +List~LineItem~ items
    }
    class LineItem {
        +Product product
        +int quantity
    }

    Order *-- LineItem : contains
```

### Aggregation

```mermaid
classDiagram
    class Department {
        +String name
        +List~Employee~ employees
    }
    class Employee {
        +String name
    }

    Department o-- Employee
```

### Dependency

```mermaid
classDiagram
    class OrderService {
        +createOrder(input)
    }
    class EmailService {
        +send(email)
    }

    OrderService ..> EmailService : uses
```

---

## Common Patterns

### Repository Pattern

```mermaid
classDiagram
    class Repository~T~ {
        <<interface>>
        +Save(entity: T) T
        +FindByID(id: string) T
        +FindAll() List~T~
        +Update(entity: T) T
        +Delete(id: string)
    }

    class UserRepository {
        <<interface>>
        +FindByEmail(email: string) User
    }

    class PostgresUserRepo {
        -db: *sql.DB
        +Save(user: User) User
        +FindByID(id: string) User
        +FindByEmail(email: string) User
    }

    Repository <|-- UserRepository
    UserRepository <|.. PostgresUserRepo
```

### Service Pattern

```mermaid
classDiagram
    class UserService {
        -repo: UserRepository
        -cache: CacheService
        -email: EmailService
        +Create(input: CreateUserInput) User
        +GetByID(id: string) User
        +Update(id: string, input: UpdateInput) User
    }

    class UserRepository {
        <<interface>>
    }
    class CacheService {
        <<interface>>
    }
    class EmailService {
        <<interface>>
    }

    UserService --> UserRepository
    UserService --> CacheService
    UserService --> EmailService
```

### Factory Pattern

```mermaid
classDiagram
    class PaymentProcessor {
        <<interface>>
        +process(amount: decimal) Result
    }
    class StripeProcessor {
        +process(amount: decimal) Result
    }
    class PayPalProcessor {
        +process(amount: decimal) Result
    }
    class PaymentFactory {
        +create(type: string) PaymentProcessor
    }

    PaymentProcessor <|.. StripeProcessor
    PaymentProcessor <|.. PayPalProcessor
    PaymentFactory ..> PaymentProcessor
```

### Domain Model

```mermaid
classDiagram
    class Order {
        +UUID id
        +UUID customerId
        +OrderStatus status
        +List~OrderItem~ items
        +Money total
        +DateTime createdAt
        +addItem(item: OrderItem)
        +removeItem(itemId: UUID)
        +calculateTotal() Money
        +submit()
        +cancel()
    }

    class OrderItem {
        +UUID id
        +UUID productId
        +int quantity
        +Money unitPrice
        +getSubtotal() Money
    }

    class OrderStatus {
        <<enumeration>>
        DRAFT
        SUBMITTED
        PAID
        SHIPPED
        COMPLETED
        CANCELLED
    }

    Order *-- OrderItem
    Order --> OrderStatus
```

---

## Visibility Modifiers

| Symbol | Access |
|--------|--------|
| `+` | Public |
| `-` | Private |
| `#` | Protected |
| `~` | Package/Internal |

---

## Annotations

```mermaid
classDiagram
    class MyInterface {
        <<interface>>
    }
    class MyAbstract {
        <<abstract>>
    }
    class MyService {
        <<service>>
    }
    class MyEnum {
        <<enumeration>>
    }
```

---

## Best Practices

1. **Group by domain** - Separate domain models from services
2. **Show public interfaces** - Hide implementation details
3. **Use proper relationships** - Composition vs Aggregation
4. **Include key methods** - Skip getters/setters
5. **Use annotations** - Mark interfaces, abstracts
6. **Limit complexity** - 10-15 classes per diagram
