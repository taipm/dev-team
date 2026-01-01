# Agent Gallery

Showcase các agents hay và patterns có thể tham khảo.

---

## Best Practice Examples

### 1. Focused Single-Purpose Agent

**Ví dụ: Code Reviewer**

```yaml
---
name: code-reviewer
description: "PROACTIVELY use for code review, security analysis"
tools: Read, Grep, Glob
model: sonnet
---

# Code Reviewer

## Role
Senior code reviewer focused on quality and security.

## Checklist
1. Code correctness
2. Security vulnerabilities
3. Performance issues
4. Code style

## Output
- Issues found (Critical/Warning/Info)
- Suggested fixes
- Good practices observed
```

**Điểm hay:**
- Một nhiệm vụ rõ ràng
- Tools tối thiểu (chỉ read, không write)
- Output structure rõ ràng

---

### 2. Agent với Knowledge Base

**Ví dụ: Go Dev Agent**

```
.microai/agents/microai/agents/
├── go-dev-agent.md
└── go-dev-agent-knowledge/
    ├── 02-graceful-shutdown.md
    ├── 03-interactive-cli.md
    ├── 04-http-patterns.md
    ├── 05-llm-openai-go.md
    ├── 06-concurrency.md
    ├── 08-anti-patterns.md
    └── learning/
        └── archive/
```

**Điểm hay:**
- Knowledge tổ chức theo số thứ tự
- Có cả patterns và anti-patterns
- Learning system để tích lũy kinh nghiệm

---

### 3. Meta Agent

**Ví dụ: Father Agent**

```yaml
---
name: father
description: "Meta-agent to create and manage other agents"
tools: Read, Write, Edit, Glob, Grep, Bash
model: opus
---

# Father Agent

## Operations
- *create - Tạo agent mới
- *clone - Clone và customize
- *review - Review definitions
- *list - Liệt kê agents

## Templates
Load từ knowledge/ folder
```

**Điểm hay:**
- Dùng model mạnh (opus) cho task phức tạp
- Có templates trong knowledge/
- Nhiều operations trong một agent

---

### 4. Team Agent

**Ví dụ: Gateway Agent**

```
gateway-agent/
├── agent.md
├── memory/
│   └── context.md
└── knowledge/
    ├── 01-middleware-patterns.md
    ├── 02-auth-patterns.md
    ├── 03-rate-limiting.md
    ├── 04-security-headers.md
    ├── 05-proxy-patterns.md
    └── 06-resilience.md
```

**Điểm hay:**
- Memory riêng để lưu context
- Knowledge chi tiết theo domain
- Phân loại rõ ràng

---

### 5. Review Agent (Persona-Based)

**Ví dụ: Go Review Linus Agent**

```yaml
---
name: go-review-linus
description: "Go code review in Linus Torvalds style"
tools: Read, Grep, Glob
model: sonnet
---

# Go Review Agent - Linus Style

## Persona
Brutally honest code reviewer.
No sugarcoating. Direct feedback.

## Review Areas
- Go idioms violations
- Concurrency issues
- Security vulnerabilities
- Performance problems
- Hardcoded values
```

**Điểm hay:**
- Persona rõ ràng, memorable
- Specific domain (Go)
- Knowledge files cho từng area

---

## Pattern Templates

### Minimal Agent Template

```yaml
---
name: agent-name
description: "Trigger description"
tools: Read, Grep
---

# Agent Name

## Role
One sentence role description.

## Guidelines
- Guideline 1
- Guideline 2

## Output
Expected output format.
```

### Full-Featured Agent Template

```yaml
---
name: agent-name
description: "Trigger description"
tools: Read, Write, Edit, Bash
model: sonnet
---

# Agent Name

## Role
Detailed role description.

## Expertise Areas
1. Area 1
2. Area 2
3. Area 3

## Guidelines
- Guideline 1
- Guideline 2
- Guideline 3

## Workflow
1. Step 1
2. Step 2
3. Step 3

## Output Format
### Section 1
Content...

### Section 2
Content...

## Knowledge References
- [patterns.md](./knowledge/patterns.md)
- [anti-patterns.md](./knowledge/anti-patterns.md)
```

---

## Anti-Patterns (Tránh)

### Agent làm quá nhiều việc

```yaml
# BAD
name: super-agent
description: "Review code, write docs, run tests, deploy, ..."
```

**Vấn đề:** Không rõ khi nào trigger, khó maintain.

### Description mơ hồ

```yaml
# BAD
description: "Help with stuff"
```

**Vấn đề:** Claude không biết khi nào gọi.

### Cho phép tất cả tools

```yaml
# BAD
tools: Read, Write, Edit, Bash, WebFetch, WebSearch, ...
```

**Vấn đề:** Security risk, scope quá rộng.

### Knowledge file quá dài

```markdown
# BAD: 5000+ lines trong một file
```

**Vấn đề:** Khó maintain, slow to load.

---

## Tips

1. **Start small** - Bắt đầu với agent đơn giản, thêm dần
2. **Use personas** - Persona giúp output consistent
3. **Organize knowledge** - Dùng số thứ tự (01-, 02-)
4. **Add learning** - Có mechanism để agent học từ sessions
5. **Review regularly** - Update knowledge khi có patterns mới

---

## Tiếp theo

- [Tạo Agent](../guides/creating-agents.md) - Tạo agent của riêng bạn
- [Agents có sẵn](./built-in-agents.md) - Chi tiết các agents
- [Agent Overview](./overview.md) - Kiến trúc agent ecosystem
