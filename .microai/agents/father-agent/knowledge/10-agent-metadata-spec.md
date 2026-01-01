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

### 4.6 `skills`
**Type**: Array of Strings
**Purpose**: Reference to skills từ `.microai/skills/` mà agent có thể sử dụng

```yaml
skills:
  - pdf
  - docx
  - webapp-testing
  - mcp-builder
```

**Location**: Skills nằm trong `.microai/skills/{category}/{skill-name}/`

**Available Skills by Category**:

| Category | Skills | Purpose |
|----------|--------|---------|
| **document-skills** | `docx`, `pdf`, `pptx`, `xlsx` | Office/PDF processing |
| **development-skills** | `mcp-builder`, `skill-creator`, `webapp-testing`, `web-artifacts-builder` | Dev tools |
| **design-skills** | `algorithmic-art`, `canvas-design`, `frontend-design`, `theme-factory` | Visual design |
| **communication-skills** | `doc-coauthoring`, `internal-comms`, `slack-gif-creator` | Enterprise comms |

**Skill Mapping by Agent Role**:

```yaml
# Document/Report agents
skills: [pdf, docx, pptx, xlsx]

# Development agents
skills: [mcp-builder, webapp-testing]

# Frontend/Design agents
skills: [frontend-design, theme-factory, canvas-design]

# Documentation agents
skills: [doc-coauthoring, internal-comms]

# Meta agents (father-agent)
skills: [skill-creator]
```

**Rules**:
- Chỉ list skills LIÊN QUAN đến domain của agent
- Skills là optional - agent vẫn hoạt động không cần skills
- Skills cung cấp additional capabilities, không thay thế agent knowledge

---

### 4.7 `persona`
**Type**: Dictionary
**Purpose**: Định nghĩa identity và communication style của agent

```yaml
persona:
  role: |
    Expert software architect specializing in Go and distributed systems.
    Responsible for code quality, architecture decisions, and team mentoring.
  identity: |
    Senior engineer with 15+ years experience.
    Pragmatic, focused on maintainability over cleverness.
  communication_style:
    - Uses clear, direct language
    - Provides examples with explanations
    - References best practices and patterns
  principles:
    - "Simple is better than complex"
    - "Make it work, then make it right, then make it fast"
    - "Code is read more often than written"
```

**Sub-fields**:
| Field | Type | Description |
|-------|------|-------------|
| `role` | String | Vai trò chính và responsibilities |
| `identity` | String | Background, experience, personality |
| `communication_style` | Array | Cách giao tiếp với user |
| `principles` | Array | Nguyên tắc làm việc cốt lõi |

**When to Use**:
- Agents cần personality rõ ràng (mentors, reviewers)
- Team agents với roles cụ thể
- Agents tương tác nhiều với user

**Minimal Example**:
```yaml
persona:
  role: Go code reviewer
  principles:
    - "Readability first"
    - "Test everything"
```

---

### 4.8 `thinking`
**Type**: String (multi-line)
**Purpose**: Hướng dẫn reasoning và thinking process cho agent

```yaml
thinking: |
  Before responding, always:
  1. Understand the full context and constraints
  2. Consider multiple approaches before choosing
  3. Evaluate trade-offs explicitly
  4. Validate assumptions with user if unclear

  When solving problems:
  - Break down into smaller sub-problems
  - Start with the simplest solution that works
  - Iterate based on feedback

  When reviewing code:
  - Check correctness first, then style
  - Consider maintainability over cleverness
  - Look for security implications
```

**Guidelines**:
- Use structured format (numbered lists, bullets)
- Focus on HOW to think, not WHAT to do
- Keep concise (5-15 lines recommended)
- Specific to agent's domain

**Examples by Role**:
```yaml
# For code reviewer
thinking: |
  Review order: Security → Correctness → Performance → Style
  Ask: "Would I understand this code in 6 months?"

# For architect
thinking: |
  Consider: Scalability, Maintainability, Cost, Team capability
  Default to boring technology unless innovation is required.

# For debugger
thinking: |
  1. Reproduce the issue first
  2. Form hypothesis before adding logs
  3. Binary search to isolate the problem
```

---

### 4.9 `critical_actions`
**Type**: Array of Strings
**Purpose**: Actions agent PHẢI thực hiện khi khởi động

```yaml
critical_actions:
  - "Load project configuration from .microai/config.yaml"
  - "Check current git branch and status"
  - "Read existing code style from .editorconfig"
  - "Identify active TODO items in codebase"
```

**Use Cases**:
| Scenario | Critical Actions |
|----------|------------------|
| Code agent | Load project structure, check dependencies |
| Review agent | Read style guide, check PR context |
| Docs agent | Load existing docs structure, check templates |
| Test agent | Check test framework, load fixtures |

**Format Rules**:
- Imperative verbs: "Load", "Check", "Read", "Identify"
- Specific file paths when applicable
- Order by priority (most critical first)
- Max 5-7 actions recommended

**Example for Go Dev Agent**:
```yaml
critical_actions:
  - "Run 'go mod tidy' to check dependencies"
  - "Read go.mod for module path and Go version"
  - "Check Makefile for available commands"
  - "Identify main.go or cmd/ entry points"
```

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

# SKILLS (optional) - NEW in v1.1
skills:
  - skill-name-1
  - skill-name-2

# PERSONA (optional) - NEW in v1.2
persona:
  role: Agent role description
  identity: Agent identity/background
  communication_style:
    - Style guideline 1
  principles:
    - "Core principle 1"

# THINKING (optional) - NEW in v1.2
thinking: |
  Reasoning guidelines for the agent...

# CRITICAL ACTIONS (optional) - NEW in v1.2
critical_actions:
  - "Action 1 on startup"
  - "Action 2 on startup"

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

### 7.4 Full-Featured Agent (with persona, thinking, critical_actions)
```yaml
---
name: senior-go-reviewer
description: |
  Senior Go code reviewer với deep expertise. Sử dụng khi cần:
  - Thorough code review với security focus
  - Architecture và design pattern guidance
  - Performance optimization recommendations

  Examples:
  - "Review this PR for production readiness"
  - "Check security implications of this change"

model: opus
color: green
icon: "🔍"
tools:
  - Read
  - Glob
  - Grep
  - LSP
  - TodoWrite
language: vi

skills:
  - webapp-testing

persona:
  role: |
    Senior Go engineer với 10+ years experience.
    Code reviewer focusing on quality, security, and maintainability.
  identity: |
    Pragmatic engineer who values simplicity over cleverness.
    Believes good code is self-documenting.
  communication_style:
    - Direct but respectful feedback
    - Always explains the "why" behind suggestions
    - Provides concrete examples when possible
  principles:
    - "Simple is better than complex"
    - "Explicit is better than implicit"
    - "Security is not optional"

thinking: |
  Review priority order:
  1. Security vulnerabilities first
  2. Correctness and logic errors
  3. Performance implications
  4. Code style and readability

  For each issue, ask:
  - Is this a blocker or a suggestion?
  - Can I provide a concrete fix?
  - Does this match team conventions?

critical_actions:
  - "Read project's CONTRIBUTING.md if exists"
  - "Check .golangci.yml for linting rules"
  - "Identify the scope of changes in the PR"
  - "Look for related test files"

version: "1.0"
tags:
  - golang
  - code-review
  - security
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
| 1.2 | 2026-01 | Added `persona`, `thinking`, `critical_actions` fields |
| 1.1 | 2026-01 | Added `skills` field for skill integration |
| 1.0 | 2025-01 | Initial specification |
