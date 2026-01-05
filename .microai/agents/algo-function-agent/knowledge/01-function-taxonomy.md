# Function Taxonomy

> Phân loại functions theo 3 chiều: Domain, Operation Type, Abstraction Level

---

## 1. Classification by Domain

### Authentication Domain
```yaml
functions:
  - login(credentials) → Result<Session, AuthError>
  - logout(session) → void
  - register(userInfo) → Result<User, ValidationError>
  - verifyEmail(token) → Result<bool, TokenError>
  - resetPassword(email) → Result<void, UserNotFound>
  - changePassword(userId, oldPass, newPass) → Result<void, Error>
  - refreshToken(refreshToken) → Result<AccessToken, TokenError>
  - validateToken(token) → Result<Claims, TokenError>
  - revokeToken(token) → void
  - generateMFA(userId) → MFASecret
  - verifyMFA(userId, code) → bool
```

### Data Access Domain
```yaml
functions:
  # Basic CRUD
  - create(entity) → Result<ID, ValidationError>
  - read(id) → Result<Entity, NotFoundError>
  - update(id, changes) → Result<Entity, Error>
  - delete(id) → Result<void, Error>

  # Query operations
  - findOne(criteria) → Entity?
  - findMany(criteria) → List<Entity>
  - query(criteria, pagination) → Page<Entity>
  - count(criteria) → int
  - exists(criteria) → bool

  # Aggregation
  - aggregate(pipeline) → AggregateResult
  - groupBy(field, aggregation) → Map<Key, Value>
  - sum(field, criteria) → number
  - average(field, criteria) → number

  # Bulk operations
  - bulkCreate(entities) → Result<List<ID>, BulkError>
  - bulkUpdate(criteria, changes) → Result<int, Error>
  - bulkDelete(criteria) → Result<int, Error>
```

### File Operations Domain
```yaml
functions:
  # Upload/Download
  - upload(file, destination) → Result<URL, UploadError>
  - download(url) → Result<Stream, DownloadError>
  - getSignedUrl(path, expiry) → SignedURL

  # Transformation
  - resize(image, dimensions) → Image
  - compress(file, level) → File
  - convert(file, targetFormat) → File
  - extractText(document) → string

  # Validation
  - validateType(file, allowedTypes) → bool
  - validateSize(file, maxSize) → bool
  - scanVirus(file) → ScanResult

  # Management
  - move(source, destination) → Result<void, Error>
  - copy(source, destination) → Result<void, Error>
  - delete(path) → Result<void, Error>
  - listFiles(directory) → List<FileInfo>
```

### Communication Domain
```yaml
functions:
  # Email
  - sendEmail(recipient, subject, body) → Result<MessageId, SendError>
  - sendBulkEmail(recipients, template, data) → BulkResult
  - scheduleEmail(email, sendAt) → ScheduleId

  # SMS
  - sendSMS(phone, message) → Result<MessageId, SendError>
  - sendOTP(phone) → Result<OTPReference, Error>
  - verifyOTP(reference, code) → bool

  # Notifications
  - pushNotification(userId, payload) → Result<void, Error>
  - subscribeTopic(userId, topic) → void
  - unsubscribeTopic(userId, topic) → void

  # Events
  - publishEvent(topic, event) → Result<EventId, Error>
  - subscribeEvent(topic, handler) → Subscription
  - acknowledgeEvent(eventId) → void
```

### Payment Domain
```yaml
functions:
  - createPaymentIntent(amount, currency) → PaymentIntent
  - confirmPayment(intentId, paymentMethod) → Result<Payment, PaymentError>
  - capturePayment(paymentId) → Result<Payment, Error>
  - refundPayment(paymentId, amount?) → Result<Refund, Error>
  - createSubscription(customerId, planId) → Subscription
  - cancelSubscription(subscriptionId) → void
  - getInvoice(invoiceId) → Invoice
  - handleWebhook(event) → void
```

---

## 2. Classification by Operation Type

### Queries (Read, no side effects)
```
Characteristics:
- Idempotent: Same input always produces same output
- No state modification
- Safe to cache
- Safe to retry

Examples:
- get, find, search, list, count, exists
- calculate, compute, derive
- validate, verify, check
- parse, extract, transform (pure)
```

### Commands (Write, has side effects)
```
Characteristics:
- May not be idempotent
- Modifies state
- Requires transaction handling
- May need retry with idempotency key

Examples:
- create, update, delete, insert
- send, publish, emit
- execute, process, run
- start, stop, pause, resume
```

### Transformers (Pure functions)
```
Characteristics:
- No side effects
- Output depends only on input
- Highly testable
- Safe to parallelize

Examples:
- map, filter, reduce, sort, group
- format, serialize, deserialize
- encrypt, decrypt, hash
- compress, decompress
```

### Validators (Boolean or Result return)
```
Characteristics:
- Check conditions
- Return bool or detailed validation result
- Should not modify state
- May have complex rules

Examples:
- validate, verify, check, assert, ensure
- isValid, canPerform, hasPermission
- meetsRequirements, satisfiesConstraints
```

### Orchestrators (Coordinate multiple operations)
```
Characteristics:
- Combine multiple operations
- Handle complex workflows
- May need saga pattern for distributed transactions
- Error handling across steps

Examples:
- workflow, saga, pipeline, batch
- checkout, onboarding, migration
- sync, reconcile, replicate
```

---

## 3. Classification by Abstraction Level

### Level 1: Primitive (Language/runtime provided)
```
- Memory operations: allocate, free
- System calls: read, write, open, close
- Atomic operations: compareAndSwap, atomicIncrement
- Thread primitives: lock, unlock, wait, signal
```

### Level 2: Utility (Common patterns)
```
- Encoding: base64Encode, urlEncode, jsonSerialize
- Hashing: md5, sha256, bcryptHash
- Compression: gzip, deflate
- Time: formatDate, parseDate, addDuration
- String: trim, split, join, replace
```

### Level 3: Business (Domain-specific)
```
- calculateTax(order, region) → Tax
- applyDiscount(cart, coupon) → DiscountedCart
- processOrder(order) → ProcessedOrder
- generateReport(criteria) → Report
- validateBusinessRule(entity) → ValidationResult
```

### Level 4: Orchestration (High-level workflows)
```
- checkoutProcess(cart, payment, shipping) → Order
- userOnboarding(userInfo) → OnboardedUser
- monthlyBillingRun(accounts) → BillingResults
- dataSync(source, target) → SyncReport
```

---

## 4. Function Signature Patterns

### Result Pattern
```
// When operation can fail
function operation(input) → Result<Output, Error>

Examples:
- login(creds) → Result<Session, AuthError>
- parse(json) → Result<Data, ParseError>
- sendEmail(email) → Result<MessageId, SendError>
```

### Optional Pattern
```
// When result may not exist
function find(criteria) → Output?

Examples:
- findUser(id) → User?
- getConfig(key) → string?
- lookup(dictionary, key) → Value?
```

### Collection Pattern
```
// When returning multiple items
function findMany(criteria) → List<Output>
function paginate(criteria, page) → Page<Output>

Examples:
- searchUsers(query) → List<User>
- getOrders(userId, page) → Page<Order>
```

### Void Pattern
```
// When no return value needed
function sideEffect(input) → void

Examples:
- logEvent(event) → void
- sendNotification(notif) → void
- updateCache(key, value) → void
```

### Builder Pattern
```
// Fluent API for complex construction
builder.withField(value).withField2(value2).build() → Output

Examples:
- QueryBuilder().where(cond).orderBy(field).limit(n).build()
- EmailBuilder().to(addr).subject(sub).body(text).build()
```

---

## 5. Common Function Compositions

### Validate → Process → Persist
```
function processEntity(input):
    validated = validate(input)        // Validator
    if validated.isError:
        return validated.error

    processed = transform(validated)   // Transformer
    result = persist(processed)        // Command
    return result
```

### Find → Check → Execute
```
function performAction(entityId, action):
    entity = find(entityId)            // Query
    if entity is null:
        return NotFound

    canDo = checkPermission(entity)    // Validator
    if not canDo:
        return Forbidden

    return execute(entity, action)     // Command
```

### Orchestration Pattern
```
function complexWorkflow(input):
    step1Result = step1(input)
    if step1Result.isError:
        return rollback(step1Result)

    step2Result = step2(step1Result)
    if step2Result.isError:
        return rollback(step1Result, step2Result)

    step3Result = step3(step2Result)
    return finalize(step1Result, step2Result, step3Result)
```

---

## Quick Reference Table

| Domain | Common Functions | Typical Return |
|--------|------------------|----------------|
| Auth | login, logout, verify | Result<Session> |
| Data | create, read, update, delete | Result<Entity> |
| File | upload, download, transform | Result<URL/Stream> |
| Communication | send, publish, subscribe | Result<ID> |
| Payment | charge, refund, subscribe | Result<Transaction> |

| Operation Type | Side Effects | Idempotent | Examples |
|----------------|--------------|------------|----------|
| Query | No | Yes | get, find, count |
| Command | Yes | Maybe | create, update, send |
| Transformer | No | Yes | map, filter, format |
| Validator | No | Yes | validate, check |
| Orchestrator | Yes | No | workflow, saga |
