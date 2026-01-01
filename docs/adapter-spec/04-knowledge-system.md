# 04 - Knowledge System | Hệ thống Knowledge

> **Specification Version**: 1.0
>
> **Status**: Stable | Ổn định

---

## Overview | Tổng quan

The Knowledge System enables **selective loading** of agent knowledge based on task keywords, reducing context size by 50-80%.

Hệ thống Knowledge cho phép **load chọn lọc** kiến thức agent dựa trên từ khóa task, giảm 50-80% kích thước context.

---

## Directory Structure | Cấu trúc thư mục

```
.microai/agents/{agent-name}/
├── agent.md                        # Main agent definition
└── knowledge/
    ├── knowledge-index.yaml        # Keyword → file mapping
    ├── 01-core-patterns.md         # Numbered knowledge files
    ├── 02-anti-patterns.md
    ├── 03-common-issues.md
    ├── 04-advanced-topics.md
    └── ...
```

---

## knowledge-index.yaml Schema | Schema knowledge-index.yaml

```yaml
# Metadata
version: "1.0"
last_updated: "YYYY-MM-DD"

# Core files - ALWAYS loaded regardless of task
# File lõi - LUÔN được load bất kể task
core_files:
  - "01-core-patterns.md"
  - "02-anti-patterns.md"

# Knowledge entries with keyword mapping
# Các mục knowledge với ánh xạ từ khóa
knowledge:
  - file: "03-graceful-shutdown.md"
    topics:
      - shutdown
      - signals
      - cleanup
    keywords:
      - graceful
      - shutdown
      - SIGINT
      - SIGTERM
      - signal
      - context.Done
      - os.Signal
    priority: 1                     # 1=high, 2=medium, 3=low
    size: 450                       # Estimated tokens
    description: "Signal handling and graceful shutdown patterns"

  - file: "04-http-patterns.md"
    topics:
      - http
      - server
      - api
    keywords:
      - http
      - server
      - handler
      - middleware
      - router
      - REST
      - endpoint
      - request
      - response
    priority: 2
    size: 600
    description: "HTTP server and client patterns"

  - file: "05-concurrency.md"
    topics:
      - concurrency
      - parallelism
    keywords:
      - goroutine
      - channel
      - mutex
      - sync
      - atomic
      - race
      - deadlock
      - waitgroup
      - errgroup
    priority: 1
    size: 800
    description: "Concurrency patterns and pitfalls"

# Keyword aliases for normalization
# Alias từ khóa để chuẩn hóa
aliases:
  goroutines: goroutine
  channels: channel
  signals: signal
  mutexes: mutex
  ctx: context

# Topic groups for broader matching
# Nhóm topic để match rộng hơn
topic_groups:
  concurrent:
    - concurrency
    - goroutine
    - channel
    - sync
  networking:
    - http
    - server
    - client
    - api
  lifecycle:
    - shutdown
    - startup
    - initialization
```

---

## Loading Algorithm | Thuật toán load

### Step-by-Step | Từng bước

```python
def load_knowledge(task: str, index: KnowledgeIndex) -> List[str]:
    """
    Load relevant knowledge files based on task keywords.
    Load các file knowledge liên quan dựa trên từ khóa task.
    """
    # 1. Always load core files
    # Luôn load file lõi
    files_to_load = set(index.core_files)

    # 2. Extract keywords from task
    # Trích xuất từ khóa từ task
    task_words = extract_words(task.lower())

    # 3. Normalize using aliases
    # Chuẩn hóa bằng aliases
    normalized_words = []
    for word in task_words:
        normalized = index.aliases.get(word, word)
        normalized_words.append(normalized)

    # 4. Expand topic groups
    # Mở rộng nhóm topic
    expanded_words = set(normalized_words)
    for word in normalized_words:
        for group_name, group_words in index.topic_groups.items():
            if word in group_words:
                expanded_words.update(group_words)

    # 5. Match against knowledge entries
    # Match với các mục knowledge
    matched_files = []
    for entry in index.knowledge:
        # Check keyword match
        if any(kw in expanded_words for kw in entry.keywords):
            matched_files.append((entry.priority, entry.file))
            continue

        # Check topic match
        if any(topic in expanded_words for topic in entry.topics):
            matched_files.append((entry.priority, entry.file))

    # 6. Sort by priority and deduplicate
    # Sắp xếp theo priority và loại trùng
    matched_files.sort(key=lambda x: x[0])
    files_to_load.update(f for _, f in matched_files)

    # 7. Load file contents
    # Load nội dung file
    knowledge_content = []
    for file_name in files_to_load:
        path = f"{agent_path}/knowledge/{file_name}"
        content = read_file(path)
        knowledge_content.append(f"## {file_name}\n\n{content}")

    return knowledge_content


def extract_words(text: str) -> List[str]:
    """Extract meaningful words from text."""
    # Remove punctuation, split, filter short words
    import re
    words = re.findall(r'\b[a-z][a-z0-9_]+\b', text)
    return [w for w in words if len(w) >= 3]
```

### Flow Diagram | Sơ đồ luồng

```
┌─────────────────────────────────────────────────────────────────────────┐
│ Task: "Fix the race condition in the goroutine worker pool"            │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│ Step 1: Load core files                                                 │
│ ──────────────────────                                                  │
│ files = ["01-core-patterns.md", "02-anti-patterns.md"]                 │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│ Step 2: Extract keywords                                                │
│ ────────────────────────                                                │
│ keywords = ["fix", "race", "condition", "goroutine", "worker", "pool"] │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│ Step 3: Normalize with aliases                                          │
│ ──────────────────────────────                                          │
│ "goroutines" → "goroutine" (normalized)                                │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│ Step 4: Expand topic groups                                             │
│ ───────────────────────────                                             │
│ "goroutine" ∈ concurrent group                                         │
│ → add: ["concurrency", "channel", "sync"]                              │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│ Step 5: Match knowledge entries                                         │
│ ───────────────────────────────                                         │
│ "race" matches 05-concurrency.md keywords                              │
│ "goroutine" matches 05-concurrency.md keywords                         │
│ → matched: ["05-concurrency.md"]                                       │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│ Step 6: Final file list                                                 │
│ ───────────────────────                                                 │
│ Load: [                                                                 │
│   "01-core-patterns.md",    # Core (always)                            │
│   "02-anti-patterns.md",    # Core (always)                            │
│   "05-concurrency.md"       # Matched                                  │
│ ]                                                                       │
│                                                                         │
│ Saved: 70% (didn't load 03, 04, 06, 07, 08, 09, 10)                   │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Knowledge File Format | Định dạng file Knowledge

### Best Practices | Thực hành tốt nhất

```markdown
# {Topic Title}

> Brief description of what this file covers
> Mô tả ngắn về nội dung file này

---

## Overview | Tổng quan

{1-2 paragraphs introducing the topic}

---

## Patterns | Mẫu

### Pattern 1: {Name}

**When to use | Khi nào dùng:**
- Condition 1
- Condition 2

**Implementation | Triển khai:**

```go
// Good example with comments
// Ví dụ tốt với chú thích
func GoodPattern() {
    // ...
}
```

**Why this works | Tại sao hoạt động:**
- Explanation 1
- Explanation 2

---

### Pattern 2: {Name}

{Same structure}

---

## Anti-Patterns | Phản mẫu

### Anti-Pattern 1: {Name}

**The Problem | Vấn đề:**

```go
// Bad example
func BadPattern() {
    // This causes...
}
```

**Why it's bad | Tại sao tệ:**
- Issue 1
- Issue 2

**The Fix | Cách sửa:**

```go
// Fixed version
func FixedPattern() {
    // Better because...
}
```

---

## Quick Reference | Tham chiếu nhanh

| Scenario | Pattern | File |
|----------|---------|------|
| Need X | Pattern A | L42 |
| Need Y | Pattern B | L78 |

---

## See Also | Xem thêm

- Related topic 1 → @knowledge/related-file.md
- Related topic 2 → @knowledge/another-file.md
```

---

## Indexing Best Practices | Thực hành tốt khi đánh index

### 1. Choose Specific Keywords | Chọn từ khóa cụ thể

```yaml
# ✅ Good - Specific
keywords:
  - graceful
  - shutdown
  - SIGINT
  - os.Signal
  - context.Done

# ❌ Bad - Too generic
keywords:
  - code
  - function
  - error
```

### 2. Include Variations | Bao gồm biến thể

```yaml
keywords:
  - goroutine
  - goroutines     # Plural
  - go routine     # Space variant (if common)

aliases:
  goroutines: goroutine
  go routine: goroutine
```

### 3. Group Related Topics | Nhóm topic liên quan

```yaml
topic_groups:
  database:
    - sql
    - postgres
    - mysql
    - query
    - transaction
    - migration
```

### 4. Prioritize Wisely | Ưu tiên hợp lý

```yaml
# Priority 1: Critical, frequently needed
- file: "anti-patterns.md"
  priority: 1

# Priority 2: Common scenarios
- file: "http-patterns.md"
  priority: 2

# Priority 3: Advanced/niche topics
- file: "profiling.md"
  priority: 3
```

---

## Size Estimation | Ước tính kích thước

Estimate tokens for each knowledge file:

Ước tính tokens cho mỗi file knowledge:

```yaml
# Rule of thumb | Quy tắc chung:
# 1 token ≈ 4 characters (English)
# 1 token ≈ 1-2 characters (Vietnamese)

knowledge:
  - file: "concurrency.md"
    size: 800                   # Estimated tokens
    # File is ~3200 characters
```

### Token Budget | Ngân sách token

```yaml
recommendations:
  core_files_total: 1000-2000   # Always loaded
  matched_files_total: 2000-4000 # Per task
  single_file_max: 1000         # Individual file
  total_budget: 6000            # All knowledge
```

---

## Implementation Requirements | Yêu cầu implement

### For Level 2 Compliance | Cho tuân thủ Level 2

Adapters MUST:

1. **Parse knowledge-index.yaml**
   - Validate schema
   - Build keyword lookup table

2. **Extract keywords from tasks**
   - Tokenize user input
   - Normalize casing

3. **Apply aliases**
   - Map variations to canonical forms

4. **Match keywords to files**
   - Check against keywords and topics
   - Apply topic groups

5. **Load selected files**
   - Respect priority ordering
   - Handle missing files gracefully

6. **Inject into context**
   - Prepend to agent prompt
   - Maintain file boundaries

---

## Example: Complete Index | Ví dụ: Index đầy đủ

```yaml
version: "1.0"
last_updated: "2025-12-31"

core_files:
  - "01-core-patterns.md"
  - "08-anti-patterns.md"
  - "10-learned-anti-patterns.md"

knowledge:
  - file: "02-graceful-shutdown.md"
    topics: [shutdown, signals, cleanup]
    keywords: [graceful, shutdown, SIGINT, SIGTERM, signal, os.Signal, context.Done, cleanup]
    priority: 1
    size: 450
    description: "Signal handling and graceful shutdown patterns"

  - file: "03-interactive-cli.md"
    topics: [cli, terminal, input]
    keywords: [stdin, readline, prompt, interactive, terminal, tty, bufio.Scanner]
    priority: 2
    size: 380
    description: "Interactive CLI patterns with goroutines"

  - file: "04-http-patterns.md"
    topics: [http, server, api]
    keywords: [http, server, handler, middleware, router, mux, REST, endpoint, request, response, http.Server]
    priority: 2
    size: 620
    description: "HTTP server and client patterns"

  - file: "05-testing.md"
    topics: [testing, tests]
    keywords: [test, testing, benchmark, table-driven, mock, testify, assert, t.Run, t.Parallel]
    priority: 2
    size: 540
    description: "Testing patterns and best practices"

  - file: "06-concurrency.md"
    topics: [concurrency, parallelism]
    keywords: [goroutine, channel, mutex, sync, atomic, race, deadlock, WaitGroup, errgroup, semaphore, worker, pool]
    priority: 1
    size: 850
    description: "Concurrency patterns and pitfalls"

  - file: "07-error-handling.md"
    topics: [errors, handling]
    keywords: [error, errors, wrap, unwrap, fmt.Errorf, errors.Is, errors.As, sentinel, custom]
    priority: 1
    size: 420
    description: "Error handling and wrapping patterns"

  - file: "09-performance.md"
    topics: [performance, optimization]
    keywords: [performance, optimize, benchmark, profile, pprof, allocation, memory, cpu, escape]
    priority: 3
    size: 680
    description: "Performance optimization techniques"

aliases:
  goroutines: goroutine
  channels: channel
  signals: signal
  mutexes: mutex
  ctx: context
  err: error
  errs: error
  tests: test
  benchmarks: benchmark

topic_groups:
  concurrent:
    - concurrency
    - goroutine
    - channel
    - sync
    - mutex
    - atomic
  networking:
    - http
    - server
    - client
    - api
    - rest
  lifecycle:
    - shutdown
    - startup
    - initialization
    - cleanup
  quality:
    - test
    - testing
    - benchmark
    - performance
```

---

## Summary | Tóm tắt

| Component | Purpose | Required Level |
|-----------|---------|----------------|
| `knowledge/` directory | Store knowledge files | Level 2 |
| `knowledge-index.yaml` | Keyword → file mapping | Level 2 |
| Core files loading | Always-on knowledge | Level 2 |
| Keyword matching | Selective loading | Level 2 |
| Aliases | Normalization | Level 2 |
| Topic groups | Broader matching | Level 3 |
| Size estimation | Token budget | Level 3 |

---

*Next: [05-memory-system.md](./05-memory-system.md) - Memory Persistence*
