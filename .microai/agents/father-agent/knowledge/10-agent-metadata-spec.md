# Agent Metadata Specification v1.0

> Quy chuẩn thống nhất cho metadata (frontmatter) của tất cả agents trong ecosystem.

---

## 1. Tổng Quan

### 1.1 Mục đích
- **Consistency**: Tất cả agents có cấu trúc metadata giống nhau
- **Discovery**: Dễ dàng tìm kiếm và filter agents
- **Validation**: Có thể tự động validate agents
- **UI/UX**: Hiển thị thống nhất trên các interfaces

### 1.2 Format
```yaml
---
# REQUIRED FIELDS (5)
name: agent-name
description: |
  ...
model: opus
tools:
  - Tool1
language: vi

# STYLE FIELDS (2)
color: purple
icon: "🤖"

# OPTIONAL FIELDS
knowledge:
  shared: []
  specific: []
team: team-name
alias: Friendly Name
version: "1.0"
tags: []
---
```

---

## 2. Required Fields (Bắt buộc)

### 2.1 `name`
**Type**: String
**Format**: kebab-case (lowercase, hyphens)
**Constraint**: Unique trong toàn ecosystem

```yaml
# ✅ CORRECT
name: father-agent
name: go-dev-agent
name: deep-question-agent

# ❌ WRONG
name: Father Agent      # spaces not allowed
name: FatherAgent       # camelCase not allowed
name: father_agent      # underscores not allowed
```

**Naming Convention**:
```
{domain}-agent          # Cho standalone agents
{domain}-{role}-agent   # Cho specific roles
{team}-{role}           # Cho team members (không có suffix)
```

---

### 2.2 `description`
**Type**: String (multi-line)
**Format**: YAML pipe `|`
**Structure**: 3 phần bắt buộc

```yaml
description: |
  [One-liner mô tả purpose chính]

  Key capabilities:
  - Capability 1
  - Capability 2
  - Capability 3

  Examples:
  - "Example use case 1"
  - "Example use case 2"
```

**Template**:
```yaml
description: |
  {Role/Purpose} cho {domain/project}. Sử dụng khi cần:
  - {Capability 1}
  - {Capability 2}
  - {Capability 3}

  Examples:
  - "{Action verb} + {object} + {context}"
  - "{Action verb} + {object} + {context}"
```

**Length Guide**:
| Agent Type | Lines | Detail Level |
|------------|-------|--------------|
| Simple | 3-5 | Brief |
| Standard | 5-8 | Moderate |
| Complex | 8-12 | Detailed |

---

### 2.3 `model`
**Type**: Enum
**Valid Values**: `opus`, `sonnet`, `haiku`

```yaml
# Selection Guide
model: opus    # Complex reasoning, multi-step, architecture
model: sonnet  # Balanced analysis, documentation, review
model: haiku   # Simple tasks, fast response, lightweight
```

**Decision Matrix**:
| Task Type | Recommended Model | Reason |
|-----------|-------------------|--------|
| Code generation | opus | Complex reasoning |
| Architecture | opus | Multi-step planning |
| Documentation | sonnet | Balanced quality/speed |
| Code review | sonnet | Analysis focused |
| Translation | haiku | Simple transformation |
| Formatting | haiku | Fast, deterministic |
| Complex Q&A | opus | Deep understanding |

---

### 2.4 `tools`
**Type**: Array of Strings
**Format**: Capitalized tool names

```yaml
tools:
  - Bash
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - TodoWrite
  - AskUserQuestion
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

**Tool Selection by Role**:
```yaml
# Minimal (read-only analysis)
tools: [Read, Glob, Grep]

# Standard (code modification)
tools: [Bash, Read, Write, Edit, Glob, Grep, TodoWrite]

# Full (interactive development)
tools: [Bash, Read, Write, Edit, Glob, Grep, LSP, Task, WebFetch, WebSearch, TodoWrite, AskUserQuestion]
```

---

### 2.5 `language`
**Type**: String
**Format**: ISO 639-1 code (lowercase)
**Valid Values**: `vi`, `en`

```yaml
language: vi   # Vietnamese - output tiếng Việt
language: en   # English - output in English
```

**Rules**:
- PHẢI explicit khai báo, KHÔNG có default
- Ảnh hưởng đến output language của agent
- Comments trong agent.md có thể bất kỳ ngôn ngữ

---

## 3. Style Fields (Khuyến nghị)

### 3.1 `color`
**Type**: String (color name)
**Format**: lowercase

**Standard Palette**:
| Color | Hex | Use Case |
|-------|-----|----------|
| `purple` | #9B59B6 | Meta-agents, orchestration |
| `red` | #E74C3C | Development, coding |
| `green` | #27AE60 | Testing, validation |
| `orange` | #F39C12 | Configuration, setup |
| `blue` | #3498DB | Analysis, exploration |
| `cyan` | #1ABC9C | Routing, communication |
| `yellow` | #F1C40F | Documentation |
| `pink` | #E91E63 | Creative, design |

**Selection by Category**:
```yaml
# By agent role
color: purple  # Meta/orchestration (father, ab-test)
color: red     # Development (go-dev, npm)
color: green   # Testing (test-agent)
color: orange  # Config/ops (config, ollama)
color: blue    # Analysis (explorer, kanban)
color: cyan    # Communication (router, gateway)
```

---

### 3.2 `icon`
**Type**: String (emoji)
**Format**: Quoted emoji

```yaml
icon: "🤖"   # Generic agent
icon: "👨‍👦"   # Father/meta agent
icon: "🦙"   # LLM-related (Ollama)
icon: "🔮"   # Deep thinking
icon: "🎭"   # Security/hacking
icon: "🧪"   # Testing/experiment
icon: "🚀"   # Production/deployment
icon: "🔍"   # Search/exploration
icon: "📦"   # Package management
icon: "⚙️"   # Configuration
icon: "🔧"   # Tools/utilities
icon: "📝"   # Documentation
icon: "🏗️"   # Architecture
icon: "🔒"   # Security
```

**Rules**:
- Phải quoted: `icon: "🤖"` (không phải `icon: 🤖`)
- Một emoji duy nhất (không combine)
- Position: sau `color`, trước `tools`

---

## 4. Optional Fields

### 4.1 `knowledge`
**Type**: Dictionary
**Purpose**: Reference to knowledge base files

```yaml
knowledge:
  shared:
    - ../knowledge/shared/01-fundamentals.md
    - ../knowledge/shared/02-best-practices.md
  specific:
    - ./knowledge/01-agent-specific.md
    - ./knowledge/02-patterns.md
```

**Structure**:
- `shared`: Files dùng chung trong team/project
- `specific`: Files chỉ agent này dùng

**Path Convention**:
```
# Shared knowledge (team level)
../knowledge/shared/{number}-{topic}.md

# Specific knowledge (agent level)
./knowledge/{number}-{topic}.md
```

---

### 4.2 `team`
**Type**: String
**Format**: kebab-case

```yaml
team: go-team
team: project-team
team: mining-team
team: dev-qa
```

**Usage**: Chỉ định team ownership cho agent

---

### 4.3 `alias`
**Type**: String
**Purpose**: Human-friendly name

```yaml
name: father-agent
alias: Father Agent

name: deep-question-agent
alias: Socrates
```

---

### 4.4 `version`
**Type**: String (semver)
**Format**: "MAJOR.MINOR" hoặc "MAJOR.MINOR.PATCH"

```yaml
version: "1.0"
version: "2.1"
version: "1.0.3"
```

**Versioning Guide**:
- MAJOR: Breaking changes to activation/behavior
- MINOR: New capabilities added
- PATCH: Bug fixes, minor improvements

---

### 4.5 `tags`
**Type**: Array of Strings
**Purpose**: Categorization for filtering

```yaml
tags:
  - golang
  - testing
  - ci-cd
  - backend
```

**Standard Tags**:
| Category | Tags |
|----------|------|
| Language | golang, python, typescript, rust |
| Domain | backend, frontend, devops, security |
| Task | testing, documentation, refactoring |
| Level | simple, standard, complex |

---

## 5. Field Order Convention

```yaml
---
# IDENTIFICATION (required)
name: agent-name
description: |
  ...

# MODEL SELECTION (required)
model: opus

# STYLE (recommended)
color: purple
icon: "🤖"

# CAPABILITIES (required)
tools:
  - Tool1
  - Tool2

# LOCALIZATION (required)
language: vi

# KNOWLEDGE (optional)
knowledge:
  shared: []
  specific: []

# ORGANIZATION (optional)
team: team-name
alias: Friendly Name
version: "1.0"
tags: []
---
```

---

## 6. Validation Checklist

### 6.1 Required Fields
```
□ name: lowercase kebab-case, unique
□ description: multi-line với 3 sections
□ model: opus | sonnet | haiku
□ tools: array of valid tool names
□ language: vi | en (explicit)
```

### 6.2 Style Fields
```
□ color: from standard palette
□ icon: quoted emoji
□ Position: color → icon → tools
```

### 6.3 Format Validation
```
□ YAML syntax valid
□ No tabs (spaces only)
□ Proper indentation (2 spaces)
□ Multi-line strings use |
□ Arrays use - prefix
```

### 6.4 Content Validation
```
□ name matches filename
□ description có examples
□ tools phù hợp với role
□ model phù hợp với complexity
```

---

## 7. Examples

### 7.1 Minimal Agent (Read-only)
```yaml
---
name: code-explorer
description: |
  Explore và analyze codebase. Sử dụng khi cần:
  - Tìm hiểu cấu trúc project
  - Search patterns trong code

  Examples:
  - "Explore authentication flow"
  - "Find all API endpoints"

model: sonnet
color: blue
icon: "🔍"
tools:
  - Read
  - Glob
  - Grep
language: vi
---
```

### 7.2 Standard Agent
```yaml
---
name: go-dev-agent
description: |
  Go development specialist. Sử dụng khi cần:
  - Implement Go code
  - Debug và fix issues
  - Refactor existing code

  Examples:
  - "Implement HTTP handler for /users"
  - "Fix nil pointer in ProcessOrder"

model: opus
color: red
icon: "🔧"
tools:
  - Bash
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - LSP
  - TodoWrite
language: vi
version: "1.0"
tags:
  - golang
  - backend
---
```

### 7.3 Team Agent with Knowledge
```yaml
---
name: architect-agent
description: |
  Solution Architect cho Go projects. Sử dụng khi cần:
  - Design system architecture
  - Review architectural decisions
  - Create ADRs

  Examples:
  - "Design microservices architecture"
  - "Review current API design"

model: opus
color: purple
icon: "🏗️"
tools:
  - Read
  - Glob
  - Grep
  - Write
  - TodoWrite
  - AskUserQuestion
language: vi

knowledge:
  shared:
    - ../knowledge/shared/01-go-fundamentals.md
    - ../knowledge/shared/02-best-practices.md
  specific:
    - ./knowledge/01-architecture-patterns.md
    - ./knowledge/02-adr-template.md

team: go-team
version: "1.0"
tags:
  - architecture
  - golang
  - design
---
```

---

## 8. Migration Guide

### 8.1 Từ agents thiếu fields
```yaml
# BEFORE (missing fields)
---
name: my-agent
description: Does stuff
model: opus
tools: [Read]
---

# AFTER (complete)
---
name: my-agent
description: |
  My agent purpose. Sử dụng khi cần:
  - Capability 1

  Examples:
  - "Example use case"

model: opus
color: blue
icon: "🤖"
tools:
  - Read
language: vi
---
```

### 8.2 Validation Script
```bash
# Check required fields
grep -l "^name:" .microai/agents/*/agent.md
grep -l "^language:" .microai/agents/*/agent.md
grep -l "^color:" .microai/agents/*/agent.md
```

---

## 9. Anti-patterns

| Anti-pattern | Problem | Solution |
|--------------|---------|----------|
| Missing language | Ambiguous output language | Always explicit |
| CamelCase name | Inconsistent with ecosystem | Use kebab-case |
| Inline description | Hard to parse | Use multi-line `|` |
| Too many tools | Unfocused agent | Limit to role needs |
| Missing examples | Hard to understand usage | Add 2-3 examples |
| Unquoted icon | YAML parse error | Always quote: `"🤖"` |
| Wrong field order | Hard to read | Follow convention |

---

## 10. Changelog

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-01 | Initial specification |
