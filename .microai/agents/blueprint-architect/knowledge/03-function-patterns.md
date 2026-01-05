# Function Patterns by Domain

> Common function signatures and contracts organized by domain

---

## Authentication Domain

```yaml
functions:
  login:
    signature: login(credentials) → Result<Session, AuthError>
    contract:
      pre:
        - credentials.email matches RFC 5322
        - credentials.password.length >= 8
        - rate limit not exceeded
      post_success:
        - session.userId == user.id
        - session.expiry > now + MIN_DURATION
        - session.token is cryptographically random
      post_failure:
        - error ∈ {InvalidCredentials, UserNotFound, RateLimited, AccountLocked}
      invariant:
        - password NEVER logged
        - constant-time comparison
    complexity: O(1) with indexed email
    io: 1 read + 1 write

  logout:
    signature: logout(sessionId) → void
    contract:
      pre: sessionId is valid UUID
      post: session invalidated in storage
    complexity: O(1)
    io: 1 delete

  validateToken:
    signature: validateToken(token) → Result<Claims, TokenError>
    contract:
      pre: token is non-empty string
      post_success: claims.exp > now
      post_failure: error ∈ {Expired, Invalid, Revoked}
    complexity: O(1) for JWT, O(1) for opaque with cache
    io: 0 for JWT, 1 read for opaque

  refreshToken:
    signature: refreshToken(refreshToken) → Result<TokenPair, TokenError>
    contract:
      pre: refreshToken is valid
      post_success: new access + refresh tokens
      post_failure: error ∈ {Expired, Invalid, Revoked}
    io: 1 read + 1 write

  hashPassword:
    signature: hashPassword(plain) → HashedPassword
    contract:
      pre: plain.length >= 8
      post: hash uses bcrypt/argon2 with cost >= 10
      invariant: plain not stored
    note: CPU-intensive, ~100ms

  verifyPassword:
    signature: verifyPassword(plain, hash) → bool
    contract:
      pre: both non-empty
      post: true if match
      invariant: constant-time comparison
```

---

## Data Access Domain

```yaml
functions:
  # CRUD Operations
  create:
    signature: create(entity) → Result<ID, Error>
    contract:
      pre: entity passes validation
      pre: no duplicate key
      post_success: entity persisted with unique ID
      post_failure: error ∈ {Validation, Duplicate, DBError}
    io: 1 write

  read:
    signature: read(id) → Result<Entity, Error>
    contract:
      pre: id is valid format
      post_found: entity.id == id
      post_not_found: returns null (NOT error)
    io: 1 read

  update:
    signature: update(id, changes) → Result<Entity, Error>
    contract:
      pre: id exists
      pre: changes contains only allowed fields
      post_success: entity updated, version incremented
      post_failure: error ∈ {NotFound, Validation, Conflict}
    io: 1 read + 1 write

  delete:
    signature: delete(id) → Result<void, Error>
    contract:
      pre: id exists
      post_success: entity removed or soft-deleted
      post_failure: error ∈ {NotFound, Forbidden}
    io: 1 delete

  # Query Operations
  findOne:
    signature: findOne(criteria) → Entity?
    contract:
      pre: criteria is valid
      post: first matching entity or null
    io: 1 read

  findMany:
    signature: findMany(criteria, pagination) → Page<Entity>
    contract:
      pre: pagination.limit <= MAX_LIMIT
      post: results ordered and paginated
    io: 1 read

  count:
    signature: count(criteria) → int
    contract:
      pre: criteria is valid
      post: count >= 0
    io: 1 read

  exists:
    signature: exists(criteria) → bool
    contract:
      post: true if at least one match
    io: 1 read (optimized)
```

---

## File Operations Domain

```yaml
functions:
  upload:
    signature: upload(file, destination) → Result<URL, UploadError>
    contract:
      pre: file.size <= MAX_SIZE
      pre: file.type in ALLOWED_TYPES
      pre: user has write permission
      post_success: file accessible at returned URL
      post_failure: error ∈ {SizeExceeded, TypeNotAllowed, StorageFull}
      invariant: no partial files left on failure
    io: 1 storage write

  download:
    signature: download(url) → Result<Stream, DownloadError>
    contract:
      pre: url is valid and accessible
      post_success: returns readable stream
      post_failure: error ∈ {NotFound, Forbidden, NetworkError}
    io: 1 storage read

  getSignedUrl:
    signature: getSignedUrl(path, expiry) → SignedURL
    contract:
      pre: path exists
      pre: expiry > 0 && expiry <= MAX_EXPIRY
      post: URL valid for expiry duration
    io: 0 (computed)

  delete:
    signature: delete(path) → Result<void, Error>
    contract:
      pre: path exists
      pre: user has delete permission
      post_success: file removed
    io: 1 storage delete

  validateFile:
    signature: validateFile(file) → ValidationResult
    contract:
      post: result.valid OR result.errors non-empty
    checks: [size, type, virus scan]
```

---

## Communication Domain

```yaml
functions:
  sendEmail:
    signature: sendEmail(to, subject, body) → Result<MessageId, SendError>
    contract:
      pre: to is valid email
      pre: subject.length <= MAX_SUBJECT
      post_success: email queued for delivery
      post_failure: error ∈ {InvalidRecipient, RateLimited, ServiceUnavailable}
    io: 1 external API call
    note: async, fire-and-forget OK

  sendSMS:
    signature: sendSMS(phone, message) → Result<MessageId, SendError>
    contract:
      pre: phone is valid E.164 format
      pre: message.length <= 160 (or segments)
      post_success: SMS queued
    io: 1 external API call

  sendNotification:
    signature: sendNotification(userId, payload) → Result<void, Error>
    contract:
      pre: user has push subscription
      post_success: notification delivered or queued
    io: 1 push service call

  publishEvent:
    signature: publishEvent(topic, event) → Result<EventId, Error>
    contract:
      pre: topic exists
      pre: event is serializable
      post_success: event published with ID
      invariant: at-least-once delivery
    io: 1 message queue write
```

---

## Payment Domain

```yaml
functions:
  createPaymentIntent:
    signature: createPaymentIntent(amount, currency) → PaymentIntent
    contract:
      pre: amount > 0
      pre: currency is valid ISO 4217
      post: intent created with unique ID
    io: 1 payment provider API

  confirmPayment:
    signature: confirmPayment(intentId, paymentMethod) → Result<Payment, PaymentError>
    contract:
      pre: intent exists and not expired
      pre: paymentMethod is valid
      post_success: payment completed
      post_failure: error ∈ {Declined, InsufficientFunds, Expired}
    io: 1-2 payment provider API calls
    note: handle webhooks for async confirmation

  refundPayment:
    signature: refundPayment(paymentId, amount?) → Result<Refund, RefundError>
    contract:
      pre: payment exists and successful
      pre: amount <= original amount (or full if not specified)
      post_success: refund initiated
      post_failure: error ∈ {AlreadyRefunded, AmountExceeds}
    io: 1 payment provider API
```

---

## Quick Reference

| Domain | Common Functions | Typical Return |
|--------|------------------|----------------|
| Auth | login, logout, validate | Result<Session> |
| Data | create, read, update, delete | Result<Entity> |
| File | upload, download, delete | Result<URL/Stream> |
| Communication | send, publish | Result<MessageId> |
| Payment | charge, refund | Result<Transaction> |
