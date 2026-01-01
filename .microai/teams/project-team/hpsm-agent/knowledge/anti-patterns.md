# HPSM Anti-Patterns to Avoid

## 1. Hardcoded Credentials

```go
// BAD: Hardcoded credentials
client := hpsm.NewClient("https://hpsm.example.com")
client.Login("admin", "password123")

// GOOD: Use environment variables
config := &hpsm.Config{
    BaseURL:  os.Getenv("HPSM_BASE_URL"),
    Username: os.Getenv("HPSM_USERNAME"),
    Password: os.Getenv("HPSM_PASSWORD"),
}
client, err := hpsm.NewClientWithConfig(config)
```

## 2. Ignoring Token Expiration

```go
// BAD: No retry on 401
resp, err := c.HTTPClient.Do(req)
if resp.StatusCode == 401 {
    return nil, errors.New("unauthorized")  // User sees error
}

// GOOD: Auto-retry with token refresh
resp, err := c.doRequestWithRetry(req)  // Handles 401 transparently
```

## 3. Missing Validation

```go
// BAD: No validation before API call
response, err := client.CreateInteraction(req)  // May fail with cryptic API error

// GOOD: Validate first
req.SetDefaults()
if err := req.Validate(); err != nil {
    return fmt.Errorf("validation failed: %w", err)  // Clear error message
}
response, err := client.CreateInteraction(req)
```

## 4. Assuming Single Response Format

```go
// BAD: Only handle one format
ticket := response.Incidents  // Breaks if format changes

// GOOD: Use unified getter
ticket := response.GetInteraction()  // Handles all 3 formats
```

## 5. Magic Numbers

```go
// BAD: Magic numbers
if priority == "3" {
    // ...
}

// GOOD: Named constants or config
const PriorityMedium = "3"
// Or use GetDefaults()
defaults := GetDefaults()
if priority == defaults.Priority {
    // ...
}
```

## 6. Ignoring Description Quality

```go
// BAD: Accept any description
if input.Description != "" {
    // OK
}

// GOOD: Validate quality
descWords := len(strings.Fields(input.Description))
if descWords < 10 {
    return fmt.Errorf("description too short (%d words). Need at least 10 words", descWords)
}
```

## 7. Blocking Logging

```go
// BAD: Synchronous logging in hot path
_, err := collection.InsertOne(ctx, logEntry)  // Blocks request

// GOOD: Async logging with channel
s.logChan <- entry  // Non-blocking
// Background worker handles insert
```

## 8. No Timeout on HTTP Client

```go
// BAD: No timeout
client := &http.Client{}

// GOOD: Set appropriate timeout
client := &http.Client{
    Timeout: 30 * time.Second,
}
```

## 9. Logging Sensitive Data

```go
// BAD: Log passwords/tokens
log.Printf("Login with user=%s pass=%s", username, password)
log.Printf("Token: %s", token)

// GOOD: Log only necessary info
log.Printf("[HPSM] Login successful for user: %s", username)
log.Printf("[HPSM] Token refreshed at %v", time.Now())
```

## 10. Not Closing Response Body

```go
// BAD: Leak file descriptors
resp, _ := c.HTTPClient.Do(req)
body, _ := io.ReadAll(resp.Body)
// resp.Body never closed!

// GOOD: Always close
resp, err := c.HTTPClient.Do(req)
if err != nil {
    return nil, err
}
defer resp.Body.Close()
body, _ := io.ReadAll(resp.Body)
```

## 11. Hardcoded Domain Registry without Extension Point

```go
// BAD: No way to add domains without code change
var domainRegistry = map[string]*DomainInfo{
    "tthd-online": {...},
    // Adding new domain requires code change
}

// BETTER: Consider loading from config (when appropriate)
// Or at minimum, document the extension process
```

## 12. Ignoring Context Cancellation

```go
// BAD: Ignore context
func (t *Tool) Execute(ctx context.Context, params string) (string, error) {
    // Long running operation without checking ctx.Done()
    result := t.longOperation()
    return result, nil
}

// GOOD: Respect context
func (t *Tool) Execute(ctx context.Context, params string) (string, error) {
    select {
    case <-ctx.Done():
        return "", ctx.Err()
    default:
    }
    result := t.longOperation()
    return result, nil
}
```

## 13. Not Using Structured Logging

```go
// BAD: Unstructured logs
log.Printf("Created ticket %s for %s", ticketID, username)

// GOOD: Structured with consistent prefix
log.Printf("[HPSM] CreateTicket SUCCESS | ID: %s | User: %s | Duration: %v",
    ticketID, username, duration)

// Or use structured logger
log.WithFields(log.Fields{
    "component": "hpsm",
    "operation": "create",
    "ticket_id": ticketID,
    "username":  username,
    "duration":  duration,
}).Info("Ticket created successfully")
```

## 14. Mixing Concerns in Models

```go
// BAD: Business logic in model
type Interaction struct {
    Title string
    // ...
}

func (i *Interaction) SendNotification() {
    // Business logic doesn't belong here
}

// GOOD: Keep models pure data, logic in services
type Interaction struct {
    Title string
    // ...
}

// In service layer
func (s *NotificationService) NotifyTicketCreated(i *Interaction) {
    // Business logic here
}
```

## 15. Silent Error Handling

```go
// BAD: Swallow errors
result, _ := json.Marshal(output)  // Error ignored

// GOOD: Handle or propagate
result, err := json.Marshal(output)
if err != nil {
    return "", fmt.Errorf("failed to marshal output: %w", err)
}
```

## 16. Not Testing Edge Cases

```go
// BAD: Only happy path tests
func TestCreateTicket(t *testing.T) {
    result, err := tool.Execute(ctx, validInput)
    assert.NoError(t, err)
}

// GOOD: Test edge cases too
func TestCreateTicket_EmptyTitle(t *testing.T) {
    result, err := tool.Execute(ctx, `{"title":"","description":"..."}`)
    assert.Error(t, err)
    assert.Contains(t, err.Error(), "title is required")
}

func TestCreateTicket_TokenExpired(t *testing.T) {
    // Mock 401 response
    // Verify retry logic works
}
```

## 17. Duplicate Service Validation

```go
// BAD: Validate in multiple places
// In handler:
if !isValidService(req.Service) { return err }
// In model:
if !isValidService(r.Service) { return err }
// In tool:
if !isValidService(input.Service) { return err }

// GOOD: Single validation point
// Validate at entry point (tool/handler), trust internal code
func (t *Tool) Execute(ctx context.Context, params string) (string, error) {
    var input CreateTicketInput
    json.Unmarshal([]byte(params), &input)

    if err := input.Validate(); err != nil {
        return "", err  // Single validation point
    }

    // Internal code trusts validated input
    return t.createTicket(ctx, input)
}
```

## 18. Not Documenting API Quirks

```go
// BAD: Undocumented quirk
func (c *Client) CloseInteraction(id string, req *CloseRequest) (*Response, error) {
    httpReq, _ := http.NewRequest("POST", url, body)  // Why POST not PUT?
    // ...
}

// GOOD: Document the quirk
// CloseInteraction closes an interaction
// NOTE: API spec says PUT but production uses POST (see ADR-001)
func (c *Client) CloseInteraction(id string, req *CloseRequest) (*Response, error) {
    // POST because HPSM gateway requires it (legacy compatibility)
    httpReq, _ := http.NewRequest("POST", url, body)
    // ...
}
```
