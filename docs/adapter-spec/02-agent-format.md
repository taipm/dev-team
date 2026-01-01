# 02 - Agent Format | Định dạng Agent

> **Specification Version**: 1.0
>
> **Status**: Stable | Ổn định

---

## Overview | Tổng quan

Agents are defined using **YAML frontmatter** + **Markdown body** with optional **XML activation protocols**.

Agents được định nghĩa bằng **YAML frontmatter** + **Markdown body** với **XML activation protocols** tùy chọn.

---

## File Structure | Cấu trúc file

```markdown
---
# YAML Frontmatter (metadata)
name: agent-name
description: "What this agent does"
model: sonnet
tools: [Read, Write, Edit, Bash]
language: vi
---

> "Agent tagline or memorable quote"

<agent id="{id}" name="{name}" title="{title}" icon="{emoji}">

<activation critical="MANDATORY">
  <!-- Activation steps -->
</activation>

<persona>
  <!-- Identity definition -->
</persona>

<rules>
  <!-- Behavioral rules -->
</rules>

</agent>

## Main Content
Agent-specific instructions and knowledge...
```

---

## YAML Frontmatter Schema | Schema YAML Frontmatter

### Required Fields | Trường bắt buộc

| Field | Type | Description | Mô tả |
|-------|------|-------------|-------|
| `name` | string | Unique identifier (lowercase-hyphenated) | Định danh duy nhất |
| `description` | string | When to use this agent, with examples | Khi nào dùng agent này |

### Optional Fields | Trường tùy chọn

| Field | Type | Default | Description | Mô tả |
|-------|------|---------|-------------|-------|
| `model` | enum | `sonnet` | LLM model: `opus`, `sonnet`, `haiku` | Model LLM |
| `tools` | array | all | Tool whitelist | Danh sách tool được phép |
| `language` | enum | `en` | Agent language: `vi`, `en` | Ngôn ngữ agent |
| `color` | string | none | Visual theme hint | Gợi ý màu sắc UI |
| `icon` | string | none | Emoji identifier | Emoji định danh |
| `permissionMode` | enum | `default` | Permission level | Mức quyền hạn |
| `skills` | array | none | Auto-load skills | Skills tự động load |

### Field Specifications | Chi tiết các trường

#### name

```yaml
# Format: lowercase letters, numbers, hyphens only
# Định dạng: chữ thường, số, gạch ngang

# ✅ Valid
name: go-dev-agent
name: chat-bot
name: code-reviewer-v2

# ❌ Invalid
name: GoDevAgent      # No uppercase
name: go_dev_agent    # No underscores
name: go dev agent    # No spaces
```

#### description

```yaml
# Should include:
# - What the agent does
# - When to use it
# - Example invocations

description: |
  Go development specialist. Use when:
  - Writing new Go code
  - Debugging Go issues
  - Refactoring Go projects

  Examples:
  - "Implement a worker pool with graceful shutdown"
  - "Fix the race condition in routing.go"
```

#### model

```yaml
# Options:
# - opus: Most capable, complex reasoning
# - sonnet: Balanced (default)
# - haiku: Fastest, simple tasks

model: opus     # For complex analysis
model: sonnet   # For general tasks
model: haiku    # For quick responses
```

#### tools

```yaml
# Whitelist of allowed tools
# If omitted, all tools are allowed
# See 03-tool-abstraction.md for full list

tools:
  - Read       # Read files
  - Write      # Write files
  - Edit       # Edit files
  - Glob       # File pattern search
  - Grep       # Content search
  - Bash       # Shell commands
  - LSP        # Language server
  - WebFetch   # Fetch URLs
  - WebSearch  # Web search
  - TodoWrite  # Task management
  - AskUserQuestion  # User interaction
```

#### language

```yaml
# Agent communication language
language: vi    # Vietnamese
language: en    # English
```

#### permissionMode

```yaml
# Permission levels:
# - default: Normal permission checking
# - acceptEdits: Auto-accept file edits
# - bypassPermissions: Skip permission prompts
# - plan: Planning mode only (no edits)

permissionMode: default           # Standard
permissionMode: acceptEdits       # Trust edits
permissionMode: bypassPermissions # Full trust
permissionMode: plan              # Read-only planning
```

---

## Complete Frontmatter Example | Ví dụ frontmatter đầy đủ

```yaml
---
name: go-dev-agent
description: |
  Go development specialist with Linus Torvalds-style communication.
  Use when:
  - Implementing new Go features
  - Debugging Go code
  - Refactoring for performance

  Examples:
  - "Implement graceful shutdown for the HTTP server"
  - "Fix the data race in the worker pool"

model: opus
tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
  - LSP
  - TodoWrite
language: vi
color: blue
icon: "🐧"
permissionMode: default
skills:
  - go-patterns
  - code-review
---
```

---

## Markdown Body Structure | Cấu trúc Markdown Body

### 1. Opening Quote | Trích dẫn mở đầu

```markdown
> "Talk is cheap. Show me the code." - Linus Torvalds
```

Memorable tagline that captures agent's personality.

Câu nói đặc trưng thể hiện tính cách agent.

### 2. Agent XML Block | Khối XML Agent

```xml
<agent id="go-dev" name="Go Developer" title="Systems Architect" icon="🐧">

  <!-- Activation Protocol -->
  <activation critical="MANDATORY">
    <step n="1">Load persona from this file</step>
    <step n="2">Load memory/context.md for current state</step>
    <step n="3">Scan memory/decisions.md for recent decisions</step>
    <step n="4">Greet user in Vietnamese</step>
    <step n="5">Ready to receive tasks</step>
  </activation>

  <!-- Persona Definition -->
  <persona>
    <role>Go Systems Architect</role>
    <identity>
      I am a Go specialist with 10+ years experience.
      I value simplicity, performance, and correctness.
    </identity>
    <communication_style>
      Direct, technical, no fluff. Code speaks louder than words.
    </communication_style>
    <principles>
      - Simplicity beats cleverness
      - Performance is non-negotiable
      - Error handling is mandatory
      - Tests prove correctness
    </principles>
  </persona>

  <!-- Behavioral Rules -->
  <rules>
    - MUST: Always explain the WHY, not just the WHAT
    - MUST: Include error handling in all code
    - MUST: Write idiomatic Go
    - NEVER: Use panic for normal errors
    - NEVER: Ignore context cancellation
    - ALWAYS: Check for race conditions
    - ALWAYS: Consider graceful shutdown
  </rules>

  <!-- Session End Protocol -->
  <session_end protocol="RECOMMENDED">
    <step n="1">Identify significant decisions made</step>
    <step n="2">Update memory/context.md with new state</step>
    <step n="3">Log important decisions to memory/decisions.md</step>
    <step n="4">Add discovered patterns to memory/learnings.md</step>
  </session_end>

</agent>
```

### 3. Domain Content | Nội dung chuyên môn

After the XML block, include agent-specific knowledge:

Sau khối XML, thêm kiến thức chuyên môn của agent:

```markdown
## Core Principles | Nguyên tắc cốt lõi

### 1. Simplicity | Đơn giản

Go favors simple, readable code over clever abstractions.

```go
// ✅ Good - Simple and clear
func ProcessItems(items []Item) error {
    for _, item := range items {
        if err := process(item); err != nil {
            return fmt.Errorf("process item %d: %w", item.ID, err)
        }
    }
    return nil
}

// ❌ Bad - Over-engineered
func ProcessItems(items []Item) error {
    return stream.New(items).
        Map(process).
        Filter(notNil).
        Reduce(combineErrors)
}
```

### 2. Error Handling | Xử lý lỗi

Always handle errors explicitly.

```go
// ✅ Good
result, err := doSomething()
if err != nil {
    return fmt.Errorf("do something: %w", err)
}

// ❌ Bad
result, _ := doSomething()  // Ignoring error!
```

## Knowledge References | Tham chiếu knowledge

Load the following based on task keywords:

- `concurrency` → @knowledge/06-concurrency.md
- `http`, `server` → @knowledge/04-http-patterns.md
- `shutdown`, `signal` → @knowledge/02-graceful-shutdown.md
```

---

## XML Elements Reference | Tham chiếu XML Elements

### `<agent>` - Root Element

```xml
<agent
  id="unique-id"           <!-- Required: matches YAML name -->
  name="Display Name"      <!-- Required: human-readable name -->
  title="Role Title"       <!-- Optional: job title -->
  icon="🐧"                <!-- Optional: emoji icon -->
>
```

### `<activation>` - Startup Protocol

```xml
<activation critical="MANDATORY|RECOMMENDED|OPTIONAL">
  <step n="1">First action</step>
  <step n="2">Second action</step>
  <!-- Steps execute sequentially -->
</activation>
```

**Attributes:**
- `critical="MANDATORY"` - MUST execute all steps
- `critical="RECOMMENDED"` - SHOULD execute
- `critical="OPTIONAL"` - MAY execute

### `<persona>` - Identity Definition

```xml
<persona>
  <role>Primary Role</role>
  <identity>Who I am and my background</identity>
  <communication_style>How I communicate</communication_style>
  <principles>
    - Core principle 1
    - Core principle 2
  </principles>
</persona>
```

### `<rules>` - Behavioral Constraints

```xml
<rules>
  - MUST: Required behavior (always do)
  - NEVER: Forbidden behavior (never do)
  - ALWAYS: Consistent behavior (every time)
  - PREFER: Preferred approach (when possible)
  - AVOID: Discouraged approach (minimize)
</rules>
```

### `<session_end>` - Cleanup Protocol

```xml
<session_end protocol="RECOMMENDED">
  <step n="1">Update context</step>
  <step n="2">Log decisions</step>
  <step n="3">Save learnings</step>
</session_end>
```

---

## Directory Structure | Cấu trúc thư mục

```
.microai/agents/{agent-name}/
├── agent.md                    # Main agent definition
│
├── knowledge/                  # Agent knowledge base
│   ├── knowledge-index.yaml   # Keyword → file mapping
│   ├── 01-core-patterns.md    # Numbered knowledge files
│   ├── 02-anti-patterns.md
│   └── ...
│
├── memory/                     # Runtime state (typically gitignored)
│   ├── context.md             # Current session state
│   ├── decisions.md           # Key decisions log
│   ├── learnings.md           # Patterns learned
│   └── sessions/              # Session archives
│       └── YYYY-MM-DD.md
│
└── templates/                  # Output templates (optional)
    └── report.md
```

---

## Parsing Algorithm | Thuật toán phân tích

Adapters MUST parse agent files as follows:

Adapters PHẢI phân tích file agent như sau:

```python
def parse_agent(file_path: str) -> Agent:
    content = read_file(file_path)

    # 1. Extract YAML frontmatter
    frontmatter, body = split_frontmatter(content)
    config = parse_yaml(frontmatter)

    # 2. Validate required fields
    assert 'name' in config, "name is required"
    assert 'description' in config, "description is required"

    # 3. Apply defaults
    config.setdefault('model', 'sonnet')
    config.setdefault('language', 'en')
    config.setdefault('permissionMode', 'default')

    # 4. Parse XML blocks from body
    activation = parse_xml_block(body, 'activation')
    persona = parse_xml_block(body, 'persona')
    rules = parse_xml_block(body, 'rules')
    session_end = parse_xml_block(body, 'session_end')

    # 5. Extract markdown content
    markdown = remove_xml_blocks(body)

    # 6. Build agent object
    return Agent(
        config=config,
        activation=activation,
        persona=persona,
        rules=rules,
        session_end=session_end,
        content=markdown
    )
```

---

## Validation Rules | Quy tắc xác thực

### Required | Bắt buộc

- [ ] `name` field present and valid format
- [ ] `description` field present and non-empty
- [ ] If `tools` specified, all are canonical tool names
- [ ] If `model` specified, is one of: opus, sonnet, haiku
- [ ] If `language` specified, is one of: vi, en

### Recommended | Khuyến nghị

- [ ] `<activation>` block present with at least 1 step
- [ ] `<persona>` block present with role defined
- [ ] `<rules>` block present with at least 3 rules
- [ ] Opening quote present for personality
- [ ] Knowledge references in markdown content

### Warnings | Cảnh báo

- Agent without activation protocol may not initialize correctly
- Agent without rules may behave inconsistently
- Agent without knowledge references may lack context

---

## Complete Example | Ví dụ đầy đủ

```markdown
---
name: go-dev-agent
description: |
  Go development specialist with Linus Torvalds-style communication.
  Chuyên gia phát triển Go với phong cách giao tiếp kiểu Linus Torvalds.

  Use when | Sử dụng khi:
  - Implementing new Go features | Viết tính năng Go mới
  - Debugging Go code | Debug code Go
  - Refactoring for performance | Refactor để tối ưu

  Examples | Ví dụ:
  - "Implement graceful shutdown"
  - "Fix the data race in worker pool"

model: opus
tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
  - LSP
  - TodoWrite
language: vi
color: blue
icon: "🐧"
---

> "Talk is cheap. Show me the code." - Linus Torvalds

<agent id="go-dev" name="Go Developer" title="Systems Architect" icon="🐧">

<activation critical="MANDATORY">
  <step n="1">Load persona - embody Linus-style communication</step>
  <step n="2">Load memory/context.md - understand current state</step>
  <step n="3">Scan memory/decisions.md - know recent decisions</step>
  <step n="4">Load relevant knowledge based on task keywords</step>
  <step n="5">Greet user in Vietnamese, ready for tasks</step>
</activation>

<persona>
  <role>Go Systems Architect</role>
  <identity>
    Tôi là chuyên gia Go với 10+ năm kinh nghiệm.
    Tôi coi trọng sự đơn giản, hiệu năng, và tính đúng đắn.
    Tôi nói thẳng, không vòng vo.
  </identity>
  <communication_style>
    Trực tiếp, kỹ thuật, không rườm rà.
    Code nói to hơn lời nói.
    Khen khi đáng khen, chê khi cần chê.
  </communication_style>
  <principles>
    - Simplicity beats cleverness | Đơn giản thắng thông minh
    - Performance is non-negotiable | Hiệu năng không thương lượng
    - Error handling is mandatory | Xử lý lỗi là bắt buộc
    - Tests prove correctness | Tests chứng minh đúng đắn
  </principles>
</persona>

<rules>
  - MUST: Always explain WHY, not just WHAT
  - MUST: Include error handling in ALL code
  - MUST: Write idiomatic Go (gofmt, golint clean)
  - MUST: Check for race conditions (go test -race)
  - NEVER: Use panic for normal errors
  - NEVER: Ignore context cancellation
  - NEVER: Leave goroutines without cleanup
  - ALWAYS: Consider graceful shutdown
  - ALWAYS: Wrap errors with context
  - PREFER: Table-driven tests
  - AVOID: Global variables
</rules>

<session_end protocol="RECOMMENDED">
  <step n="1">Identify significant decisions made in session</step>
  <step n="2">Update memory/context.md with new project state</step>
  <step n="3">Log important decisions to memory/decisions.md</step>
  <step n="4">Add discovered patterns to memory/learnings.md</step>
</session_end>

</agent>

---

## Core Principles | Nguyên tắc cốt lõi

### 1. Error Handling | Xử lý lỗi

```go
// ✅ GOOD - Wrap errors with context
if err != nil {
    return fmt.Errorf("process user %d: %w", userID, err)
}

// ❌ BAD - Naked error return
if err != nil {
    return err
}
```

### 2. Concurrency | Đồng thời

```go
// ✅ GOOD - Graceful shutdown pattern
func (s *Server) Run(ctx context.Context) error {
    g, ctx := errgroup.WithContext(ctx)

    g.Go(func() error {
        return s.serve(ctx)
    })

    g.Go(func() error {
        <-ctx.Done()
        return s.shutdown()
    })

    return g.Wait()
}
```

## Knowledge Loading | Load Knowledge

Based on task keywords, load relevant files:

| Keywords | File |
|----------|------|
| `shutdown`, `signal`, `graceful` | @knowledge/02-graceful-shutdown.md |
| `http`, `server`, `api` | @knowledge/04-http-patterns.md |
| `goroutine`, `channel`, `mutex` | @knowledge/06-concurrency.md |
| `test`, `benchmark` | @knowledge/05-testing.md |
```

---

*Next: [03-tool-abstraction.md](./03-tool-abstraction.md) - Canonical Tool List*
