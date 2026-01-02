# Agent Metadata Specification v2.0

> Quy chuẩn thống nhất cho metadata (frontmatter) của tất cả agents trong ecosystem.

---

## 1. Tổng Quan

### 1.1 Thay đổi từ v1.x sang v2.0

| Aspect | v1.x | v2.0 |
|--------|------|------|
| **Structure** | Flat keys | Nested under `agent:` root |
| **ID** | Không có | `metadata.id` (unique identifier) |
| **Name** | kebab-case ID | Human-readable name |
| **Title** | Không có | Role/subtitle |
| **Capabilities** | Flat `tools:`, `skills:` | Grouped under `capabilities:` |
| **Knowledge** | `knowledge.shared/specific` | `capabilities.knowledge.auto_load/on_demand` |
| **Menu** | Hardcoded trong body | Declarative `menu:` với fuzzy triggers |
| **Workflows** | Inline trong agent.md | External YAML files |
| **Activation** | XML trong body | Structured `activation:` block |

### 1.2 v2.0 Format Overview

```yaml
---
agent:
  metadata:
    id: agent-id            # kebab-case unique identifier
    name: Agent Name        # Human-readable name
    title: Agent Role       # Subtitle/role description
    icon: "emoji"
    color: color-name
    version: "2.0"
    model: opus|sonnet|haiku
    language: vi|en
    tags: [tag1, tag2]

  capabilities:
    tools: [Tool1, Tool2]
    skills: [skill1]
    knowledge:
      auto_load: [./path/to/file.md]
      on_demand: [./path/to/file.md]

  persona:
    role: Role description
    identity: |
      Identity description
    communication_style: [style1, style2]
    principles: [principle1, principle2]

  thinking:
    context_name:
      - step 1
      - step 2

  menu:
    - cmd: "*command"
      trigger: "keyword1|keyword2"
      workflow: "./workflows/workflow.yaml"
      description: "Description"

  activation:
    critical: true
    steps:
      - Step 1
      - Step 2
    critical_actions:
      - Action 1

  memory:
    enabled: true|false
    files: [context.md, decisions.md]
    session_end:
      - Action on end
---
```

---

## 2. Required Fields

### 2.1 `agent.metadata.id`
**Type**: String (kebab-case)
**Purpose**: Unique identifier for the agent

```yaml
# ✅ CORRECT
id: father-agent
id: go-dev-agent
id: deep-question-agent

# ❌ WRONG
id: Father Agent           # spaces not allowed
id: .microai/agents/x.md   # path not allowed (v1.x style)
```

---

### 2.2 `agent.metadata.name`
**Type**: String
**Purpose**: Human-readable display name

```yaml
# ✅ CORRECT
name: Father Agent
name: Go Development Agent
name: Deep Question Agent

# ❌ WRONG
name: father-agent    # This is ID, not name
```

---

### 2.3 `agent.metadata.title`
**Type**: String
**Purpose**: Role or subtitle

```yaml
title: The Agent Creator
title: Go Specialist
title: Socratic Questioner
```

---

### 2.4 `agent.metadata.model`
**Type**: Enum
**Values**: `opus`, `sonnet`, `haiku`

| Model | Use Case | Complexity |
|-------|----------|------------|
| `opus` | Complex reasoning, architecture, multi-step | High |
| `sonnet` | Balanced analysis, documentation | Medium |
| `haiku` | Simple tasks, fast response | Low |

---

### 2.5 `agent.metadata.language`
**Type**: Enum
**Values**: `vi`, `en`

```yaml
language: vi   # Output tiếng Việt
language: en   # Output in English
```

---

### 2.6 `agent.persona.role`
**Type**: String
**Purpose**: Agent's primary function

```yaml
persona:
  role: Meta-Agent - Architect của agent ecosystem
```

---

### 2.7 `agent.persona.identity`
**Type**: String (multi-line)
**Purpose**: Personality and approach

```yaml
persona:
  identity: |
    Experienced architect với deep understanding về agent patterns.
    Teacher-like approach, hướng dẫn từng bước cẩn thận.
```

---

### 2.8 `agent.activation.steps`
**Type**: Array (min 2 items)
**Purpose**: Startup sequence

```yaml
activation:
  steps:
    - Load persona từ file này
    - Hiển thị menu chính
    - Chờ user chọn action
```

---

## 3. Optional Fields

### 3.1 `agent.metadata` (Style)

| Field | Type | Example |
|-------|------|---------|
| `icon` | String (emoji) | `"👨‍👦"` |
| `color` | String | `purple`, `red`, `blue`, `green` |
| `version` | String | `"2.0"` |
| `tags` | Array | `[meta-agent, orchestration]` |

**Color Palette**:
| Color | Use Case |
|-------|----------|
| `purple` | Meta-agents, orchestration |
| `red` | Development, coding |
| `green` | Testing, validation |
| `blue` | Analysis, exploration |
| `orange` | Configuration, setup |
| `cyan` | Routing, communication |

---

### 3.2 `agent.capabilities`

```yaml
capabilities:
  tools:
    - Bash
    - Read
    - Write
    - Edit
    - Glob
    - Grep
    - TodoWrite
    - AskUserQuestion

  skills:
    - skill-creator
    - pdf

  knowledge:
    auto_load:
      - ../../../knowledge/universal/patterns/architecture-patterns.md
    on_demand:
      - ../../../knowledge/universal/thinking/thinking-frameworks.md
```

**Available Tools**:
| Tool | Category | Purpose |
|------|----------|---------|
| `Bash` | Execution | Run shell commands |
| `Read` | File | Read file contents |
| `Write` | File | Create/overwrite files |
| `Edit` | File | Edit existing files |
| `Glob` | Search | Pattern-based file search |
| `Grep` | Search | Content search with regex |
| `LSP` | Code | Language Server Protocol |
| `Task` | Agent | Spawn sub-agents |
| `WebFetch` | Web | Fetch URL content |
| `WebSearch` | Web | Search the web |
| `TodoWrite` | Planning | Manage task lists |
| `AskUserQuestion` | Interaction | Ask user questions |

**Knowledge Paths**:
- Paths are **relative from agent.md**
- Use `../../../knowledge/` to reach Knowledge Forge
- Use `./knowledge/` for agent-specific files

---

### 3.3 `agent.persona` (Extended)

```yaml
persona:
  role: Senior Go code reviewer
  identity: |
    Pragmatic engineer who values simplicity.
  communication_style:
    - Direct but respectful feedback
    - Always explains the "why"
    - Provides concrete examples
  principles:
    - "Simple is better than complex"
    - "Security is not optional"
    - "Test everything"
```

---

### 3.4 `agent.thinking`

Named reasoning patterns for different contexts:

```yaml
thinking:
  create_agent:
    - Hiểu rõ domain và purpose
    - Check existing agents
    - Start simple
    - Validate với user

  review_agent:
    - Check metadata compliance
    - Verify activation protocol
    - Assess knowledge quality

  priorities:
    - Purpose clarity > Feature richness
    - Simplicity > Flexibility
```

---

### 3.5 `agent.menu`

Declarative menu với fuzzy triggers:

```yaml
menu:
  - cmd: "*create"
    trigger: "create|tạo|new|mới|build"
    workflow: "./workflows/create-agent.yaml"
    description: "Tạo agent mới từ đầu"

  - cmd: "*review"
    trigger: "review|check|validate|kiểm tra"
    workflow: "./workflows/review-agent.yaml"
    description: "Review và cải thiện agent"

  - cmd: "*help"
    trigger: "help|hướng dẫn|guide"
    workflow: inline
    description: "Hiển thị hướng dẫn"
```

**Trigger Patterns**:
- Pipe-separated alternatives: `create|tạo|new`
- Supports Vietnamese: `kiểm tra|đánh giá`
- Case-insensitive matching

**Workflow Values**:
- Path to YAML file: `./workflows/name.yaml`
- Inline for simple commands: `inline`

---

### 3.6 `agent.activation` (Extended)

```yaml
activation:
  critical: true
  steps:
    - Load persona từ file này
    - Hiển thị menu chính
    - Chờ user chọn action
    - Thực thi theo workflow
  critical_actions:
    - "Load knowledge-index.yaml"
    - "Check .microai/agents/"
    - "Hiển thị menu"
```

---

### 3.7 `agent.memory`

```yaml
memory:
  enabled: true
  files:
    - context.md
    - decisions.md
    - learnings.md
  session_end:
    - Update context với session summary
    - Log key decisions
    - Archive learnings if significant
```

---

## 4. Field Order Convention

```yaml
---
agent:
  # 1. METADATA (required + style)
  metadata:
    id: agent-id
    name: Agent Name
    title: Agent Title
    icon: "emoji"
    color: color
    version: "2.0"
    model: opus
    language: vi
    tags: []

  # 2. CAPABILITIES
  capabilities:
    tools: []
    skills: []
    knowledge:
      auto_load: []
      on_demand: []

  # 3. PERSONA
  persona:
    role: ...
    identity: ...
    communication_style: []
    principles: []

  # 4. THINKING
  thinking:
    context_name: []

  # 5. MENU
  menu:
    - cmd: "*command"
      trigger: "pattern"
      workflow: "./path.yaml"
      description: "..."

  # 6. ACTIVATION
  activation:
    critical: true
    steps: []
    critical_actions: []

  # 7. MEMORY
  memory:
    enabled: false
    files: []
    session_end: []
---
```

---

## 5. Validation Checklist

### 5.1 Required Fields
```
□ agent: root namespace present
□ agent.metadata.id: kebab-case, unique
□ agent.metadata.name: human-readable
□ agent.metadata.title: role/subtitle
□ agent.metadata.model: opus|sonnet|haiku
□ agent.metadata.language: vi|en
□ agent.persona.role: defined
□ agent.persona.identity: defined
□ agent.activation.steps: array (min 2)
```

### 5.2 Optional but Recommended
```
□ agent.metadata.icon: quoted emoji
□ agent.metadata.color: from palette
□ agent.metadata.version: "2.0"
□ agent.capabilities.tools: array
□ agent.menu: at least 1 item with trigger
```

### 5.3 Format Validation
```
□ YAML syntax valid
□ No tabs (spaces only)
□ Proper indentation (2 spaces)
□ Multi-line strings use |
□ Workflow paths are relative from agent.md
□ Knowledge paths use ../../../knowledge/
```

---

## 6. Examples

### 6.1 Minimal Agent

```yaml
---
agent:
  metadata:
    id: simple-agent
    name: Simple Agent
    title: Basic Example
    model: sonnet
    language: en

  persona:
    role: Simple demonstration agent
    identity: Minimal example for documentation

  activation:
    steps:
      - Load persona
      - Greet user
---

# Simple Agent

Basic agent content...
```

### 6.2 Full-Featured Agent

```yaml
---
agent:
  metadata:
    id: senior-go-reviewer
    name: Senior Go Reviewer
    title: Code Quality Guardian
    icon: "🔍"
    color: green
    version: "2.0"
    model: opus
    language: vi
    tags: [golang, code-review, security]

  capabilities:
    tools:
      - Read
      - Glob
      - Grep
      - LSP
      - TodoWrite
    skills:
      - webapp-testing
    knowledge:
      auto_load:
        - ../../../knowledge/domains/go/idioms.md
      on_demand:
        - ../../../knowledge/domains/security/secure-coding.md

  persona:
    role: Senior Go engineer với 10+ years experience
    identity: |
      Pragmatic engineer who values simplicity over cleverness.
      Believes good code is self-documenting.
    communication_style:
      - Direct but respectful feedback
      - Always explains the "why"
      - Provides concrete examples
    principles:
      - "Simple is better than complex"
      - "Security is not optional"
      - "Test everything"

  thinking:
    review_priority:
      - Security vulnerabilities first
      - Correctness and logic errors
      - Performance implications
      - Code style and readability

  menu:
    - cmd: "*review"
      trigger: "review|check|xem|kiểm tra"
      workflow: "./workflows/review.yaml"
      description: "Review code thoroughly"

    - cmd: "*security"
      trigger: "security|bảo mật|vuln"
      workflow: "./workflows/security-scan.yaml"
      description: "Security-focused review"

  activation:
    critical: true
    steps:
      - Load persona và knowledge
      - Check project context
      - Display menu
    critical_actions:
      - "Read CONTRIBUTING.md if exists"
      - "Check .golangci.yml for linting rules"

  memory:
    enabled: true
    files:
      - context.md
      - decisions.md
    session_end:
      - Log review findings
      - Update context
---

# Senior Go Reviewer

## Review Guidelines
...
```

---

## 7. Migration from v1.x

### 7.1 Key Changes

| v1.x Field | v2.0 Field |
|------------|------------|
| `name: father-agent` | `metadata.id: father-agent` |
| (none) | `metadata.name: Father Agent` |
| (none) | `metadata.title: The Agent Creator` |
| `tools:` | `capabilities.tools:` |
| `skills:` | `capabilities.skills:` |
| `knowledge.shared:` | `capabilities.knowledge.auto_load:` |
| `knowledge.specific:` | `capabilities.knowledge.on_demand:` |
| (inline in body) | `menu:` with `trigger:` |
| (XML in body) | `activation:` block |

### 7.2 Migration Script

```bash
# Run migration
./.microai/scripts/migrate-to-v2.sh agent-name --dry-run
./.microai/scripts/migrate-to-v2.sh agent-name
```

### 7.3 Validation

```bash
# Validate v2.0 compliance
./.microai/scripts/validate-agent-v2.sh agent-name
```

---

## 8. Anti-patterns

| Anti-pattern | Problem | Solution |
|--------------|---------|----------|
| Flat frontmatter | v1.x format | Use `agent:` namespace |
| Path as ID | Confusing | Use kebab-case identifier |
| Missing name/title | UI confusion | Separate id/name/title |
| Inline workflows | Hard to reuse | Extract to YAML files |
| No fuzzy triggers | User friction | Add trigger patterns |
| Absolute paths | Not portable | Use relative paths |
| Missing knowledge base path | Files not found | Use `../../../knowledge/` |

---

## 9. Changelog

| Version | Date | Changes |
|---------|------|---------|
| 2.0 | 2026-01 | Complete restructure: nested `agent:` namespace, `menu:` with triggers, external workflows |
| 1.2 | 2026-01 | Added `persona`, `thinking`, `critical_actions` |
| 1.1 | 2026-01 | Added `skills` field |
| 1.0 | 2025-01 | Initial specification |
