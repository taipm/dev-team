# HPSM Project Decisions & Conventions

## Architectural Decisions

### ADR-001: Two-Layer Architecture

**Decision:** Separate HPSM code into two distinct layers:
- `internal/hpsm/` - Infrastructure layer (HTTP client, models)
- `tools/hpsm/` - Application layer (LLM tools, business logic)

**Rationale:**
- Infrastructure layer can be reused by CLI tools, scripts, other services
- Application layer contains LLM-specific logic (tool definitions, agent integration)
- Clear separation of concerns
- Easier testing (can mock infrastructure layer)

### ADR-002: Static Domain Registry

**Decision:** Use static `domainRegistry` in Go code instead of MongoDB config.

**Rationale:**
- Domains change rarely (quarterly at most)
- Faster lookup (no DB call)
- Simpler deployment (no config migration)
- Easy to extend by modifying code

**Trade-off:** Need code deployment to add new domains.

### ADR-003: 4-Tier Configuration Hierarchy

**Decision:** Configuration priority order:
1. Routing Rules (MongoDB)
2. Service Defaults (MongoDB)
3. Field Config Defaults (MongoDB)
4. Hardcoded Global Fallback (Environment vars)

**Rationale:**
- Most specific config wins
- DB configs allow runtime changes
- Env vars as safety net
- Predictable fallback behavior

### ADR-004: FlexibleString for Polymorphic Fields

**Decision:** Use custom `FlexibleString` type for Description, Assignment fields.

**Rationale:**
- HPSM API returns these as string OR array depending on context
- Single type handles both cases
- Consumer code doesn't need to check type
- Always get string value

### ADR-005: Auto-Retry on 401

**Decision:** Transparently retry requests after token refresh on 401.

**Rationale:**
- Better user experience (no manual re-auth)
- Credentials stored in client for auto-refresh
- Single retry prevents infinite loops
- Common pattern for OAuth2 clients

### ADR-006: Async Logging with Channel

**Decision:** Use buffered channel for async logging to MongoDB.

**Rationale:**
- Logging shouldn't block request handling
- 1000-entry buffer handles bursts
- Drop entries gracefully on overflow (with warning)
- Background worker for actual inserts

### ADR-007: Tool Interface Standardization

**Decision:** All HPSM tools implement common `Tool` interface.

```go
type Tool interface {
    GetName() string
    GetDescription() string
    GetDefinition() map[string]interface{}
    Execute(ctx context.Context, paramsJSON string) (string, error)
}
```

**Rationale:**
- Consistent registration in tool registry
- OpenAI-compatible function definitions
- JSON-in, JSON-out for flexibility
- Context propagation for cancellation

---

## Naming Conventions

### File Naming

| Type | Pattern | Example |
|------|---------|---------|
| Client methods | `client.go` | All in single file |
| Models | `models_*.go` | `models_request.go`, `models_response.go` |
| Tools | `<action>.go` | `create_ticket_tool.go`, `detect_situation.go` |
| Tests | `*_test.go` | `routing_matcher_test.go` |

### Function Naming

| Type | Pattern | Example |
|------|---------|---------|
| Constructor | `New<Type>` | `NewClient`, `NewRoutingMatcher` |
| Getter | `Get<Field>` | `GetInteraction`, `GetCallID` |
| Setter | `Set<Field>` | `SetDefaults` |
| Validator | `Validate` | `Validate()` |
| Helper | `<verb><Noun>` | `stripDomainPrefix`, `isValidAffectedItem` |

### Log Message Format

```
[HPSM] <Operation> <Result> | <Key>: <Value> | <Key>: <Value>
```

Examples:
```
[HPSM] CreateInteraction Response | Status: 200 | Body: {...}
[HPSM] CreateTicket SUCCESS | ID: SD12345 | Duration: 250ms
[HPSM] Token refresh failed: connection timeout
```

---

## Code Conventions

### Error Handling

```go
// Wrap errors with context
return fmt.Errorf("failed to create interaction: %w", err)

// Use specific error messages
return fmt.Errorf("validation failed: Title is required")

// Log before returning on critical paths
log.Printf("[HPSM] CreateTicket FAILED | Error: %v", err)
return nil, err
```

### Validation Order

1. Required fields first
2. Format validation second
3. Business rules last

```go
func (r *CreateInteractionRequest) Validate() error {
    // 1. Required fields
    if r.Title == "" {
        return fmt.Errorf("Title is required")
    }

    // 2. Format validation
    if len(r.Title) > 100 {
        return fmt.Errorf("Title too long (max 100 chars)")
    }

    // 3. Business rules
    if !isValidAffectedItem(r.AffectedItem) {
        return fmt.Errorf("AffectedItem must be a valid BIDV service")
    }

    return nil
}
```

### Default Values

```go
// Use SetDefaults() pattern
func (r *CreateInteractionRequest) SetDefaults() {
    if r.Priority == "" {
        r.Priority = HPSMDefaults.Priority  // "3" = Medium
    }
    if r.Impact == "" {
        r.Impact = HPSMDefaults.Impact
    }
    // ...
}

// Call before validate
req.SetDefaults()
if err := req.Validate(); err != nil {
    return err
}
```

---

## Testing Conventions

### Unit Tests

```go
func TestCreateTicket_Success(t *testing.T) {
    // Arrange
    mockServer := httptest.NewServer(...)
    client := hpsm.NewClient(mockServer.URL)

    // Act
    response, err := client.CreateInteraction(req)

    // Assert
    assert.NoError(t, err)
    assert.Equal(t, "SD12345", response.GetCallID())
}
```

### Table-Driven Tests

```go
func TestValidation(t *testing.T) {
    tests := []struct {
        name    string
        input   CreateTicketInput
        wantErr bool
        errMsg  string
    }{
        {"empty title", CreateTicketInput{Title: ""}, true, "title is required"},
        {"short desc", CreateTicketInput{Title: "Test", Description: "short"}, true, "too short"},
        {"valid", CreateTicketInput{Title: "Test", Description: "..." /* 10+ words */}, false, ""},
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            _, err := tool.createTicket(ctx, tt.input)
            if tt.wantErr {
                assert.Error(t, err)
                assert.Contains(t, err.Error(), tt.errMsg)
            } else {
                assert.NoError(t, err)
            }
        })
    }
}
```

---

## MongoDB Collections

| Collection | Purpose | TTL |
|------------|---------|-----|
| `hpsm_interactions_log` | Operation logging | 90 days |
| `hpsm_field_config` | Field validation configs | None |
| `hpsm_services` | Service catalog | None |
| `hpsm_routing_rules` | Routing rules | None |

---

## Environment Variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `HPSM_BASE_URL` | Yes | - | HPSM Gateway API URL |
| `HPSM_USERNAME` | Yes | - | OAuth2 username |
| `HPSM_PASSWORD` | Yes | - | OAuth2 password |
| `HPSM_DEFAULT_PRIORITY` | No | `Medium` | Default priority |
| `HPSM_DEFAULT_IMPACT` | No | `Medium` | Default impact |
| `HPSM_DEFAULT_URGENCY` | No | `Medium` | Default urgency |
| `HPSM_DEFAULT_ASSIGNMENT_GROUP` | No | `Service Desk` | Default assignment |

---

## Version History

| Date | Version | Changes |
|------|---------|---------|
| 2025-12-22 | Story 14-10 | Removed ClarificationEngine dependency |
| 2025-12-09 | Story 36-8 | Added 4-tier routing hierarchy |
| 2025-12-08 | Story 30-6 | Refactored to use Database Provider |
| 2025-11-27 | Epic 8 | Initial HPSM integration |
