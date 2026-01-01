# HPSM Development Patterns

## 1. Client Initialization Pattern

```go
// Pattern: Config-based client with auto-login
config := &hpsm.Config{
    BaseURL:  os.Getenv("HPSM_BASE_URL"),
    Username: os.Getenv("HPSM_USERNAME"),
    Password: os.Getenv("HPSM_PASSWORD"),
}
client, err := hpsm.NewClientWithConfig(config)
if err != nil {
    return fmt.Errorf("HPSM client init failed: %w", err)
}
```

## 2. Tool Interface Pattern

```go
// Pattern: Implement Tool interface for LLM integration
type MyHPSMTool struct {
    hpsmClient *hpsm.Client
}

func (t *MyHPSMTool) GetName() string {
    return "my_hpsm_tool"
}

func (t *MyHPSMTool) GetDescription() string {
    return "Description for LLM to understand when to use this tool"
}

func (t *MyHPSMTool) GetDefinition() map[string]interface{} {
    return map[string]interface{}{
        "function": map[string]interface{}{
            "name":        t.GetName(),
            "description": t.GetDescription(),
            "parameters": map[string]interface{}{
                "type":       "object",
                "properties": map[string]interface{}{
                    "param1": map[string]interface{}{
                        "type":        "string",
                        "description": "Parameter description",
                    },
                },
                "required": []string{"param1"},
            },
        },
    }
}

func (t *MyHPSMTool) Execute(ctx context.Context, paramsJSON string) (string, error) {
    var input MyInput
    if err := json.Unmarshal([]byte(paramsJSON), &input); err != nil {
        return "", fmt.Errorf("failed to parse input: %w", err)
    }

    result, err := t.doWork(ctx, input)
    if err != nil {
        return "", err
    }

    output, _ := json.Marshal(result)
    return string(output), nil
}
```

## 3. Request Validation Pattern

```go
// Pattern: Validate before API call
func (r *CreateInteractionRequest) Validate() error {
    if r.Title == "" {
        return fmt.Errorf("Title is required")
    }
    if len(r.Description) == 0 {
        return fmt.Errorf("Description is required")
    }
    if !isValidAffectedItem(r.AffectedItem) {
        return fmt.Errorf("AffectedItem must be one of the predefined services")
    }
    return nil
}

// Usage
req := &models.CreateInteractionRequest{...}
req.SetDefaults()
if err := req.Validate(); err != nil {
    return fmt.Errorf("validation failed: %w", err)
}
response, err := client.CreateInteraction(req)
```

## 4. Response Format Handling Pattern

```go
// Pattern: Handle multiple API response formats
type InteractionResponse struct {
    Interaction *Interaction         `json:"interaction,omitempty"`  // Format 1
    Incidents   *Interaction         `json:"incidents,omitempty"`    // Format 2
    Response    *HPSMResponseWrapper `json:"response,omitempty"`     // Format 3
}

// Unified getter
func (i *InteractionResponse) GetInteraction() *Interaction {
    if i.Incidents != nil {
        return i.Incidents  // Production format
    }
    if i.Interaction != nil {
        return i.Interaction  // Legacy format
    }
    if i.Response != nil && i.Response.Incidents != nil {
        return i.Response.Incidents  // Nested format
    }
    return nil
}
```

## 5. FlexibleString Pattern

```go
// Pattern: Handle polymorphic JSON fields
type FlexibleString struct {
    Value string
}

func (fs *FlexibleString) UnmarshalJSON(data []byte) error {
    // Try string first
    var s string
    if err := json.Unmarshal(data, &s); err == nil {
        fs.Value = s
        return nil
    }

    // Try array
    var arr []string
    if err := json.Unmarshal(data, &arr); err == nil {
        fs.Value = strings.Join(arr, "\n")
        return nil
    }

    return fmt.Errorf("cannot unmarshal FlexibleString")
}
```

## 6. Auto-Retry Pattern

```go
// Pattern: Retry on 401 with token refresh
func (c *Client) doRequestWithRetry(req *http.Request) (*http.Response, error) {
    resp, err := c.HTTPClient.Do(req)
    if err != nil {
        return nil, err
    }

    if resp.StatusCode == http.StatusUnauthorized {
        resp.Body.Close()

        if err := c.RefreshToken(); err != nil {
            return nil, fmt.Errorf("token refresh failed: %w", err)
        }

        req.Header.Set("Authorization", "Bearer "+c.Token)
        return c.HTTPClient.Do(req)
    }

    return resp, nil
}
```

## 7. Configuration Hierarchy Pattern

```go
// Pattern: 4-tier configuration with fallback
func (m *RoutingMatcher) ApplyRouting(params *CreateTicketInput) (*RoutingResult, error) {
    result := &RoutingResult{}

    // Tier 1: Routing rules (highest priority)
    if rule, _ := m.findMatchingRoutingRule(params); rule != nil {
        m.applyRoutingRule(result, rule)
        result.Source = "routing_rule"
        return result, nil
    }

    // Tier 2: Service defaults
    if service, _ := m.configLoader.GetServiceByName(params.AffectedItem); service != nil {
        if service.Defaults != nil {
            m.applyServiceDefaults(result, service.Defaults)
            result.Source = "service_defaults"
            return result, nil
        }
    }

    // Tier 3: Field config defaults
    if err := m.applyFieldConfigDefaults(result); err == nil {
        result.Source = "field_config"
        return result, nil
    }

    // Tier 4: Hardcoded global fallback (env vars)
    m.applyHardcodedDefaults(result)
    result.Source = "hardcoded"
    return result, nil
}
```

## 8. Caching Pattern (Duplicate Call Prevention)

```go
// Pattern: Cache with TTL to prevent duplicate tool calls
type detectCacheEntry struct {
    output    *DetectSituationOutput
    timestamp time.Time
}

const detectCacheTTL = 5 * time.Second

func (t *DetectSituationTool) Execute(ctx context.Context, paramsJSON string) (string, error) {
    var input DetectSituationInput
    json.Unmarshal([]byte(paramsJSON), &input)

    // Check cache
    cacheKey := t.getCacheKey(input)
    if cached := t.getFromCache(cacheKey); cached != nil {
        cached.Action = "ALREADY_PROCESSED"
        result, _ := json.Marshal(cached)
        return string(result), nil
    }

    // Execute and cache
    output := t.executeInternal(input)
    t.storeInCache(cacheKey, output)

    result, _ := json.Marshal(output)
    return string(result), nil
}
```

## 9. Async Logging Pattern

```go
// Pattern: Non-blocking async logging with channel
type HPSMLogService struct {
    logChan chan *models.HPSMLogEntry
    wg      sync.WaitGroup
}

func (s *HPSMLogService) Log(entry *models.HPSMLogEntry) {
    if !s.config.Enabled {
        return  // No-op if disabled
    }

    select {
    case s.logChan <- entry:
        // Queued successfully
    default:
        // Channel full, drop with warning
        log.Warn("Log queue full, dropping entry")
    }
}

// Background worker
func (s *HPSMLogService) worker() {
    defer s.wg.Done()
    for entry := range s.logChan {
        // Insert to MongoDB
        s.collection.InsertOne(ctx, entry)
    }
}
```

## 10. User Context Extraction Pattern

```go
// Pattern: Extract user from JWT context
func (t *CreateHPSMTicketTool) createTicket(ctx context.Context, input CreateTicketInput) (*CreateTicketOutput, error) {
    var username, userEmail, displayName string

    userCtx := middleware.GetUserContext(ctx)
    if userCtx != nil {
        username = stripDomainPrefix(userCtx.DisplayName)
        userEmail = userCtx.Email
        displayName = userCtx.DisplayName
        log.Printf("User context from JWT: %s <%s>", displayName, userEmail)
    } else if input.ContactName != "" {
        username = stripDomainPrefix(input.ContactName)
        displayName = input.ContactName
        log.Printf("Using contact_name from input: %s", input.ContactName)
    }

    // Use in request
    req := &models.CreateInteractionRequest{
        Contact:          username,
        ServiceRecipient: userEmail,
        ContactName:      displayName,
        // ...
    }
}
```

## 11. Priority Normalization Pattern

```go
// Pattern: Normalize human-readable to HPSM numeric
func setDefaultPriority(priority string) string {
    switch strings.ToLower(priority) {
    case "low", "1":
        return "4"
    case "medium", "2":
        return "3"
    case "high", "3":
        return "2"
    case "critical", "4":
        return "1"
    default:
        return "3" // Default: Medium
    }
}
```

## 12. Graceful Shutdown Pattern

```go
// Pattern: Graceful shutdown with timeout
func (s *HPSMLogService) Close() error {
    s.mu.Lock()
    if s.closed {
        s.mu.Unlock()
        return nil
    }
    s.closed = true
    s.mu.Unlock()

    close(s.logChan)  // Signal worker to stop

    done := make(chan struct{})
    go func() {
        s.wg.Wait()
        close(done)
    }()

    select {
    case <-done:
        log.Info("HPSM Log Service: Gracefully shut down")
        return nil
    case <-time.After(s.config.CloseTimeout):
        return fmt.Errorf("shutdown timeout after %v", s.config.CloseTimeout)
    }
}
```
