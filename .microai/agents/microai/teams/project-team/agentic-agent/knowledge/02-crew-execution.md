# Crew Execution - Deep Dive

> Chi tiết về multi-agent orchestration với Crew system.

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    CREW SYSTEM ARCHITECTURE                              │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │                      CrewExecutor                                │    │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │    │
│  │  │ CrewConfig  │  │ CrewRouter  │  │ BudgetTracker│             │    │
│  │  └─────────────┘  └─────────────┘  └─────────────┘              │    │
│  └────────────────────────────┬────────────────────────────────────┘    │
│                               │                                          │
│                               ▼                                          │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │                      AgentExecutor                               │    │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │    │
│  │  │ AgentConfig │  │ ToolRegistry│  │ OpenAI Client│             │    │
│  │  └─────────────┘  └─────────────┘  └─────────────┘              │    │
│  └─────────────────────────────────────────────────────────────────┘    │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Crew Configuration (YAML)

### Structure

```yaml
# config/agents/my-crew/crew.yaml
name: my-crew
description: Multi-agent crew for specific task
entry_agent: main_agent

agents:
  main_agent:
    name: Main Agent
    system_prompt: |
      You are the main entry point...
    model: gpt-4o-mini
    tools:
      - tool1
      - tool2
    signals:
      - handoff_to_specialist
      - complete_task

  specialist_agent:
    name: Specialist Agent
    system_prompt: |
      You are a specialist in...
    model: gpt-4o
    tools:
      - specialized_tool

routing:
  handoff_to_specialist:
    from: main_agent
    to: specialist_agent
    condition: when_specialized_needed

  complete_task:
    terminal: true
```

### Config Loading

```go
// config.go
type CrewConfig struct {
    Name        string                 `yaml:"name"`
    Description string                 `yaml:"description"`
    EntryAgent  string                 `yaml:"entry_agent"`
    Agents      map[string]AgentConfig `yaml:"agents"`
    Routing     map[string]RouteConfig `yaml:"routing"`
}

type AgentConfig struct {
    Name         string   `yaml:"name"`
    SystemPrompt string   `yaml:"system_prompt"`
    Model        string   `yaml:"model"`
    Tools        []string `yaml:"tools"`
    Signals      []string `yaml:"signals"`
}

type RouteConfig struct {
    From      string `yaml:"from"`
    To        string `yaml:"to"`
    Condition string `yaml:"condition"`
    Terminal  bool   `yaml:"terminal"`
}

func LoadCrewConfig(path string) (*CrewConfig, error) {
    data, err := os.ReadFile(path)
    if err != nil {
        return nil, err
    }

    var config CrewConfig
    if err := yaml.Unmarshal(data, &config); err != nil {
        return nil, err
    }

    return &config, nil
}
```

---

## Execution Flow

### Main Loop

```go
// crew.go
func (c *CrewExecutor) Execute(ctx context.Context, input string) (*CrewResult, error) {
    currentAgent := c.config.EntryAgent
    conversationHistory := []Message{}
    totalCost := 0.0

    for {
        // 1. Get agent config
        agentConfig := c.config.Agents[currentAgent]

        // 2. Execute agent
        result, err := c.agentExec.Execute(ctx, ExecuteInput{
            AgentConfig: agentConfig,
            Input:       input,
            History:     conversationHistory,
        })
        if err != nil {
            return nil, err
        }

        // 3. Track cost
        totalCost += result.Cost
        if c.budgetTracker.IsExceeded() {
            return nil, ErrBudgetExceeded
        }

        // 4. Update history
        conversationHistory = append(conversationHistory, result.Messages...)

        // 5. Check for signal
        signal := c.extractSignal(result)
        if signal == "" {
            // No signal, use default
            signal = "continue"
        }

        // 6. Route to next agent
        route := c.config.Routing[signal]
        if route.Terminal {
            return &CrewResult{
                Response: result.Response,
                Cost:     totalCost,
                Agents:   c.agentsUsed,
            }, nil
        }

        currentAgent = route.To
        input = result.Response // Pass response as next input
    }
}
```

### Signal Extraction

```go
// crew_routing.go
func (c *CrewExecutor) extractSignal(result *AgentResult) string {
    // Check for explicit signal in response
    for _, signal := range c.config.Agents[currentAgent].Signals {
        if strings.Contains(result.Response, "[SIGNAL:"+signal+"]") {
            return signal
        }
    }

    // Check tool calls for signal
    for _, toolCall := range result.ToolCalls {
        if toolCall.Name == "emit_signal" {
            return toolCall.Arguments["signal"].(string)
        }
    }

    return ""
}
```

---

## Signal-Based Routing

### How Signals Work

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    SIGNAL-BASED ROUTING                                  │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  Agent emits signal:                                                     │
│    - Explicit: "[SIGNAL:handoff_specialist]"                            │
│    - Tool call: emit_signal(signal="handoff_specialist")                │
│                                                                          │
│  Router matches signal:                                                  │
│    routing:                                                              │
│      handoff_specialist:                                                 │
│        from: main_agent                                                  │
│        to: specialist_agent                                              │
│                                                                          │
│  Next agent determined:                                                  │
│    currentAgent = "specialist_agent"                                     │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Routing Table

```go
type CrewRouter struct {
    routes map[string]RouteConfig
}

func (r *CrewRouter) Route(signal string, currentAgent string) (string, error) {
    route, exists := r.routes[signal]
    if !exists {
        return "", fmt.Errorf("unknown signal: %s", signal)
    }

    if route.From != "" && route.From != currentAgent {
        return "", fmt.Errorf("signal %s not valid from agent %s", signal, currentAgent)
    }

    if route.Terminal {
        return "", ErrTerminal
    }

    return route.To, nil
}
```

---

## Parallel Execution (crew_parallel.go)

### When to Use Parallel

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    PARALLEL VS SEQUENTIAL                                │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  PARALLEL (crew_parallel.go)                                            │
│  ───────────────────────────                                            │
│  Use when:                                                               │
│    - Agents don't depend on each other's output                         │
│    - Need to gather information from multiple sources                   │
│    - Time is critical                                                    │
│                                                                          │
│  Example: Investigation phase                                            │
│    - Agent A: Check logs                                                 │
│    - Agent B: Query database                                             │
│    - Agent C: Analyze metrics                                            │
│    → All can run simultaneously                                          │
│                                                                          │
│  SEQUENTIAL (default)                                                    │
│  ────────────────────                                                   │
│  Use when:                                                               │
│    - Agent B needs output from Agent A                                  │
│    - Order matters                                                       │
│    - State must be preserved                                             │
│                                                                          │
│  Example: Processing pipeline                                            │
│    - Agent A: Parse input → output to B                                 │
│    - Agent B: Process → output to C                                     │
│    - Agent C: Format response                                            │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Parallel Execution Code

```go
// crew_parallel.go
type ParallelTask struct {
    Agent  string
    Input  string
    Result *AgentResult
    Err    error
}

func (c *CrewExecutor) ExecuteParallel(ctx context.Context, tasks []ParallelTask) error {
    var wg sync.WaitGroup
    errCh := make(chan error, len(tasks))

    for i := range tasks {
        wg.Add(1)
        go func(task *ParallelTask) {
            defer wg.Done()

            result, err := c.agentExec.Execute(ctx, ExecuteInput{
                AgentConfig: c.config.Agents[task.Agent],
                Input:       task.Input,
            })

            if err != nil {
                task.Err = err
                errCh <- err
                return
            }

            task.Result = result
        }(&tasks[i])
    }

    wg.Wait()
    close(errCh)

    // Collect errors
    var errs []error
    for err := range errCh {
        errs = append(errs, err)
    }

    if len(errs) > 0 {
        return fmt.Errorf("parallel execution errors: %v", errs)
    }

    return nil
}
```

---

## Tool Execution

### Tool Registry

```go
// tools/registry.go
type ToolRegistry struct {
    tools map[string]Tool
    mu    sync.RWMutex
}

func (r *ToolRegistry) Register(name string, tool Tool) {
    r.mu.Lock()
    defer r.mu.Unlock()
    r.tools[name] = tool
}

func (r *ToolRegistry) Execute(ctx context.Context, name string, args map[string]interface{}) (interface{}, error) {
    r.mu.RLock()
    tool, exists := r.tools[name]
    r.mu.RUnlock()

    if !exists {
        return nil, fmt.Errorf("unknown tool: %s", name)
    }

    return tool.Execute(ctx, args)
}
```

### Tool Interface

```go
type Tool interface {
    Name() string
    Description() string
    Parameters() map[string]ParameterDef
    Execute(ctx context.Context, args map[string]interface{}) (interface{}, error)
}
```

---

## Cost Tracking in Crew

### Per-Agent Cost

```go
type AgentCost struct {
    AgentName    string
    InputTokens  int
    OutputTokens int
    Cost         float64
}

type CrewCost struct {
    TotalCost   float64
    AgentCosts  []AgentCost
    TotalTokens int
}

func (c *CrewExecutor) GetCostBreakdown() CrewCost {
    return CrewCost{
        TotalCost:   c.totalCost,
        AgentCosts:  c.agentCosts,
        TotalTokens: c.totalTokens,
    }
}
```

### Budget Enforcement

```go
func (c *CrewExecutor) Execute(ctx context.Context, input string) (*CrewResult, error) {
    for {
        // Before each agent execution
        if c.budgetTracker.IsExceeded() {
            return nil, &BudgetExceededError{
                CurrentCost: c.budgetTracker.GetCurrentCost(),
                MaxCost:     c.budgetTracker.GetMaxCost(),
                AgentsUsed:  c.agentsUsed,
            }
        }

        // Execute agent...

        // After execution
        c.budgetTracker.RecordUsage(result.InputTokens, result.OutputTokens, agentConfig.Model)
    }
}
```

---

## Streaming Support

### SSE Streaming

```go
// streaming.go
type StreamingCrewExecutor struct {
    *CrewExecutor
    streamCh chan StreamEvent
}

type StreamEvent struct {
    Type    string      // "agent_start", "token", "agent_end", "error"
    Agent   string
    Content string
    Error   error
}

func (c *StreamingCrewExecutor) ExecuteStreaming(ctx context.Context, input string) <-chan StreamEvent {
    c.streamCh = make(chan StreamEvent, 100)

    go func() {
        defer close(c.streamCh)

        currentAgent := c.config.EntryAgent

        for {
            c.streamCh <- StreamEvent{Type: "agent_start", Agent: currentAgent}

            // Stream tokens from agent
            tokenCh := c.agentExec.ExecuteStreaming(ctx, agentConfig, input)
            for token := range tokenCh {
                c.streamCh <- StreamEvent{Type: "token", Agent: currentAgent, Content: token}
            }

            c.streamCh <- StreamEvent{Type: "agent_end", Agent: currentAgent}

            // Route to next...
        }
    }()

    return c.streamCh
}
```

---

## Common Patterns

### Pattern 1: Hub-and-Spoke

```yaml
# Main agent routes to specialists, they return to main
entry_agent: main

routing:
  need_specialist_a:
    from: main
    to: specialist_a

  specialist_a_done:
    from: specialist_a
    to: main

  complete:
    terminal: true
```

### Pattern 2: Pipeline

```yaml
# Sequential processing through stages
entry_agent: stage1

routing:
  to_stage2:
    from: stage1
    to: stage2

  to_stage3:
    from: stage2
    to: stage3

  complete:
    from: stage3
    terminal: true
```

### Pattern 3: Conditional Branching

```yaml
# Different paths based on condition
entry_agent: classifier

routing:
  route_a:
    from: classifier
    to: handler_a

  route_b:
    from: classifier
    to: handler_b

  complete:
    terminal: true
```

---

## Testing Crew Execution

```go
func TestCrewExecution_BasicFlow(t *testing.T) {
    config := &CrewConfig{
        EntryAgent: "main",
        Agents: map[string]AgentConfig{
            "main": {Name: "Main", Model: "gpt-4o-mini"},
        },
        Routing: map[string]RouteConfig{
            "complete": {Terminal: true},
        },
    }

    executor := NewCrewExecutor(config, mockAgentExec, mockBudget)
    result, err := executor.Execute(context.Background(), "test input")

    assert.NoError(t, err)
    assert.NotEmpty(t, result.Response)
}
```
