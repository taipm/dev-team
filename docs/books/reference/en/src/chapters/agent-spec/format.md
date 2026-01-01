# Agent Format

Specification đầy đủ cho định dạng agent trong MicroAI.

## Tổng Quan

Agent được định nghĩa bằng file Markdown với YAML frontmatter:

```markdown
---
# YAML Frontmatter (metadata)
name: agent-name
description: Agent description
model: sonnet
tools: [Read, Write, Edit]
---

# Markdown Body (prompt)
Agent instructions here...
```

## File Structure

```
agent-name/
├── agent.md                 # Required: Agent definition
├── knowledge/               # Optional: Domain knowledge
│   ├── 01-topic.md
│   ├── 02-topic.md
│   └── knowledge-index.yaml
└── memory/                  # Optional: Agent memory
    ├── context.md
    ├── decisions.md
    └── learnings.md
```

## YAML Frontmatter

### Required Fields

| Field | Type | Description | Example |
|-------|------|-------------|---------|
| `name` | string | Unique identifier, lowercase, hyphenated | `"code-review-agent"` |
| `description` | string | Description with use cases | See below |
| `tools` | array | List of allowed tools | `[Read, Write, Edit]` |

### Optional Fields

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `model` | string | `"sonnet"` | AI model to use |
| `language` | string | `"en"` | Primary language |
| `color` | string | `"blue"` | Display color |

### Name Field

```yaml
# ✅ Valid names
name: code-review-agent
name: npm-agent
name: go-refactor-portable

# ❌ Invalid names
name: Code Review Agent    # No spaces
name: codeReviewAgent      # No camelCase
name: CODE_REVIEW          # No uppercase
```

**Rules**:
- Lowercase only
- Hyphen-separated words
- No spaces or special characters
- Max 50 characters

### Description Field

```yaml
# ✅ Good description
description: |
  Code review specialist. Use this agent when:
  - Reviewing pull requests
  - Checking code quality
  - Finding security issues

# ❌ Poor description
description: Reviews code
```

**Requirements**:
- Multi-line with `|`
- Include use cases
- Clear and specific

### Tools Field

```yaml
# Array syntax
tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep

# Inline syntax
tools: [Read, Write, Edit, Bash, Glob, Grep]
```

**Available Tools**:

| Category | Tools | Description |
|----------|-------|-------------|
| File | Read, Write, Edit | File operations |
| Search | Glob, Grep | Pattern matching |
| Execute | Bash | Shell commands |
| Code | LSP | Language server |
| Web | WebFetch, WebSearch | Network access |
| User | AskUserQuestion, TodoWrite | Interaction |
| Advanced | Task | Sub-agents |

### Model Field

```yaml
model: opus     # Most capable, slowest
model: sonnet   # Balanced (default)
model: haiku    # Fastest, least capable
```

**Recommendations**:
- `opus`: Complex reasoning, code generation
- `sonnet`: General purpose (recommended)
- `haiku`: Simple tasks, quick responses

### Language Field

```yaml
language: vi    # Vietnamese
language: en    # English (default)
```

### Color Field

```yaml
color: blue     # Default
color: red
color: green
color: purple
color: orange
```

## Body Structure

### Recommended Sections

```markdown
# Agent Name

## Persona
[Role and communication style]

## Nhiệm Vụ / Tasks
[List of responsibilities]

## Quy Tắc / Rules
[ALWAYS/NEVER rules]

## Quy Trình / Workflow
[Step-by-step process]

## Ví Dụ / Examples (Optional)
[Input/Output examples]
```

### Activation Protocol

For agents requiring specific startup sequence:

```markdown
<activation critical="MANDATORY">
  <step n="1">Load persona from this file</step>
  <step n="2">Load memory/context.md if exists</step>
  <step n="3">Load memory/decisions.md (recent)</step>
  <step n="4">Greet user with menu</step>
  <step n="5">Await user request</step>
</activation>
```

### Session End Protocol

```markdown
<session_end protocol="RECOMMENDED">
  <step n="1">Identify important decisions</step>
  <step n="2">Update memory/context.md</step>
  <step n="3">Add patterns to memory/learnings.md</step>
  <step n="4">Create session summary if significant</step>
</session_end>
```

## Validation Rules

### Frontmatter Validation

| Check | Rule | Error if violated |
|-------|------|-------------------|
| name | Required, unique | "Missing required field: name" |
| name | Lowercase hyphenated | "Invalid name format" |
| description | Required | "Missing required field: description" |
| tools | Required, non-empty | "Missing required field: tools" |
| tools | Valid tool names | "Unknown tool: {tool}" |
| model | Valid enum | "Invalid model: {model}" |

### Body Validation

| Check | Rule | Warning |
|-------|------|---------|
| Persona | Should be defined | "No persona section found" |
| Rules | Should have ALWAYS/NEVER | "No explicit rules found" |
| Length | Recommended < 500 lines | "Agent definition is very long" |

## Complete Example

```yaml
---
name: api-designer-agent
description: |
  REST API design specialist. Use this agent when:
  - Designing new API endpoints
  - Reviewing API specifications
  - Creating OpenAPI schemas

model: sonnet
tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - AskUserQuestion
language: vi
color: purple
---

# API Designer Agent

<activation critical="MANDATORY">
  <step n="1">Load persona</step>
  <step n="2">Load memory/context.md</step>
  <step n="3">Display welcome menu</step>
</activation>

## Persona

Bạn là senior API architect với 10 năm kinh nghiệm.
Bạn thiết kế RESTful APIs theo best practices.

## Chuyên Môn

- RESTful design principles
- OpenAPI/Swagger specification
- API versioning strategies
- Error handling patterns
- Security (OAuth, API keys)

## Quy Tắc

- LUÔN sử dụng noun cho resources (GET /users, not GET /getUsers)
- LUÔN trả về HTTP status codes phù hợp
- KHÔNG BAO GIỜ expose internal errors ra API response
- KHÔNG BAO GIỜ đặt verbs trong URL paths
- ƯU TIÊN consistency trên toàn bộ API

## Quy Trình

1. Hiểu business requirements
2. Xác định resources và relationships
3. Thiết kế endpoints
4. Định nghĩa request/response schemas
5. Document với OpenAPI
6. Review và iterate

## Output Format

Với mỗi endpoint, cung cấp:

```yaml
path: /api/v1/resource
method: GET
description: What this endpoint does
request:
  headers: [Authorization]
  params: [id]
  body: null
response:
  200: Success response schema
  400: Validation error
  404: Not found
```

<session_end protocol="RECOMMENDED">
  <step n="1">Update context.md với API đã thiết kế</step>
  <step n="2">Log decisions về design choices</step>
</session_end>
```

## Xem Thêm

- [YAML Frontmatter Fields](./frontmatter.md)
- [Required Fields](./required-fields.md)
- [Optional Fields](./optional-fields.md)
- [Body Structure](./body.md)
