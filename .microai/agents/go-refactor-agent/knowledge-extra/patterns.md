# Go Refactoring Patterns

## Documented Patterns

### Generic HTTP Streaming Helper
- **Context**: Multiple methods with identical HTTP streaming logic but different response types
- **Before**:
```go
// Duplicated in GenerateStream and ChatStream
func (c *Client) GenerateStream(...) error {
    // 60+ lines of duplicated logic:
    // - Create HTTP request
    // - Execute request
    // - Check status, read error body
    // - Scan response lines
    // - Unmarshal JSON chunks
    // - Call callback
    // - Handle done flag
}
```
- **After**:
```go
// Generic helper function (not method - Go limitation)
func doStreamRequest[T any](
    c *Client,
    ctx context.Context,
    endpoint string,
    body []byte,
    callback StreamCallback,
    extract func(*T) (string, bool),
) error

// Simplified caller
func (c *Client) GenerateStream(...) error {
    req := GenerateRequest{...}
    body, _ := json.Marshal(req)
    return doStreamRequest(c, ctx, "/api/generate", body, callback,
        func(chunk *GenerateResponse) (string, bool) {
            return chunk.Response, chunk.Done
        })
}
```
- **Benefits**:
  - Reduced duplication from 120+ lines to 50 lines
  - Single point of maintenance for streaming logic
  - Type-safe with generics

### Parameter Object for Goroutine Captures
- **Context**: Goroutine needs many captured variables from parent scope
- **Before**:
```go
// 83 lines inline with 8 captured variables
go func() {
    capturedUserID := streamCtx.UserID
    capturedSessionID := streamCtx.SessionID
    capturedUserMessage := userMessage
    // ... more captures

    // Long goroutine body using capturedXxx variables
}()
```
- **After**:
```go
// Clean struct to hold all parameters
type conversationSaveParams struct {
    UserID           string
    SessionID        string
    UserMessage      string
    FinalContent     string
    Model            string
    ToolsCalledCount int
    DurationMs       int64
    RequestID        string
}

// Named function with struct parameter
func saveConversationAsync(deps *ChatHandlerDeps, p conversationSaveParams) {
    go func() {
        // Use p.UserID, p.SessionID, etc.
    }()
}

// Clean call site
saveConversationAsync(deps, conversationSaveParams{
    UserID:    streamCtx.UserID,
    SessionID: streamCtx.SessionID,
    // ...
})
```
- **Benefits**:
  - Named parameters improve readability
  - Struct can be reused and tested independently
  - Caller explicitly sees what data is passed
  - Avoids closure capture bugs

### Error Body Reader Extraction
- **Context**: Same error reading pattern repeated in multiple places
- **Before**:
```go
bodyBytes, _ := io.ReadAll(io.LimitReader(resp.Body, MaxErrorBodySize))
return fmt.Errorf("ollama API error (status %d): %s", resp.StatusCode, string(bodyBytes))
```
- **After**:
```go
func readErrorBody(resp *http.Response) error {
    bodyBytes, _ := io.ReadAll(io.LimitReader(resp.Body, MaxErrorBodySize))
    return fmt.Errorf("ollama API error (status %d): %s", resp.StatusCode, string(bodyBytes))
}
```
- **Benefits**: Single source of truth, easier to modify error format

---

## Pattern Template
### [Pattern Name]
- **Context**: When to apply
- **Before**: Code before refactoring
- **After**: Code after refactoring
- **Benefits**: Why this improves the code
