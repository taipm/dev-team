# Product Requirements Document (PRD)

## @microai.club/dev-team

**Version:** 1.0.0-alpha.2
**Ngày cập nhật:** 2025-12-31
**Trạng thái:** Alpha
**Ngôn ngữ:** Tiếng Việt

---

## Mục lục

- [Phần 1: Tổng quan điều hành](#phần-1-tổng-quan-điều-hành)
  - [1.1 Tóm tắt điều hành](#11-tóm-tắt-điều-hành)
  - [1.2 Tầm nhìn & Sứ mệnh](#12-tầm-nhìn--sứ-mệnh)
  - [1.3 Bài toán cần giải quyết](#13-bài-toán-cần-giải-quyết)
  - [1.4 Giá trị cốt lõi](#14-giá-trị-cốt-lõi)
- [Phần 2: Định nghĩa sản phẩm](#phần-2-định-nghĩa-sản-phẩm)
  - [2.1 Đối tượng người dùng](#21-đối-tượng-người-dùng)
  - [2.2 Ma trận tính năng](#22-ma-trận-tính-năng)
  - [2.3 Các trường hợp sử dụng](#23-các-trường-hợp-sử-dụng)
- [Phần 3: Kiến trúc kỹ thuật](#phần-3-kiến-trúc-kỹ-thuật)
  - [3.1 Kiến trúc hệ thống](#31-kiến-trúc-hệ-thống)
  - [3.2 Hệ sinh thái Agent](#32-hệ-sinh-thái-agent)
  - [3.3 MicroAI Adapter Specification](#33-microai-adapter-specification)
  - [3.4 Lớp trừu tượng công cụ](#34-lớp-trừu-tượng-công-cụ)
  - [3.5 Hệ thống Knowledge & Memory](#35-hệ-thống-knowledge--memory)
  - [3.6 Mô hình bảo mật & phân quyền](#36-mô-hình-bảo-mật--phân-quyền)
- [Phần 4: Triển khai](#phần-4-triển-khai)
  - [4.1 NPM Package & CLI](#41-npm-package--cli)
  - [4.2 Cài đặt & Cấu hình](#42-cài-đặt--cấu-hình)
  - [4.3 Platform Adapters](#43-platform-adapters)
  - [4.4 Compliance Framework](#44-compliance-framework)
- [Phần 5: Lộ trình & Metrics](#phần-5-lộ-trình--metrics)
  - [5.1 Lộ trình sản phẩm](#51-lộ-trình-sản-phẩm)
  - [5.2 Metrics thành công](#52-metrics-thành-công)
  - [5.3 Phụ lục](#53-phụ-lục)

---

# Phần 1: Tổng quan điều hành

## 1.1 Tóm tắt điều hành

### TL;DR (1 phút đọc)

**Dev-team** là một NPM package cho phép development teams thiết lập và triển khai **AI agent teams chuyên biệt** trong môi trường Claude Code. Thay vì dùng một AI general-purpose cho mọi tác vụ, dev-team cung cấp:

- **43+ agents chuyên biệt** được pre-configured với domain knowledge
- **12+ team patterns** cho collaboration workflows
- **MicroAI Adapter Specification** cho platform portability
- **Persistent memory** để agents học từ các sessions trước

```
┌─────────────────────────────────────────────────────────────┐
│                    DEV-TEAM OVERVIEW                         │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   "Team of Specialized AI Experts, Not One Generalist"      │
│                                                              │
│   ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐       │
│   │  Linus  │  │ Munger  │  │ Feynman │  │  Beck   │       │
│   │  Code   │  │  Risk   │  │ Explain │  │  Test   │       │
│   └────┬────┘  └────┬────┘  └────┬────┘  └────┬────┘       │
│        └───────────┬┴───────────┬┴────────────┘            │
│                    ▼            ▼                           │
│              ┌──────────────────────┐                       │
│              │      Maestro         │                       │
│              │    (Orchestrator)    │                       │
│              └──────────────────────┘                       │
│                         │                                   │
│                         ▼                                   │
│              ┌──────────────────────┐                       │
│              │   Solution Output    │                       │
│              └──────────────────────┘                       │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Số liệu chính

| Metric | Giá trị |
|--------|---------|
| Agents chuyên biệt | 43+ |
| Team patterns | 12+ |
| Canonical tools | 14 |
| Compliance levels | 3 |
| NPM package size | ~250KB |
| Supported platforms | Claude Code (current), VS Code, OpenCode (planned) |

---

## 1.2 Tầm nhìn & Sứ mệnh

### Tầm nhìn

> *"Mỗi developer đều có một đội ngũ AI experts sẵn sàng hỗ trợ - từ code review chuyên sâu đến architectural decisions."*

### Sứ mệnh

Xây dựng một framework **platform-agnostic** cho phép:

1. **Định nghĩa** AI agents với domain expertise
2. **Tổ chức** agents thành teams có thể phối hợp
3. **Phân phối** agent definitions qua package managers
4. **Chạy** agents trên bất kỳ AI coding assistant platform nào

### Nguyên tắc thiết kế

```yaml
design_principles:
  write_once_run_anywhere:
    description: "Định nghĩa agent một lần, chạy trên mọi platform"
    implementation: ".microai/ là portable, .{platform}/ là adapter"

  specialized_over_general:
    description: "Nhiều experts giỏi một thứ > Một generalist biết mọi thứ"
    implementation: "43+ agents với pre-loaded domain knowledge"

  human_readable_first:
    description: "Agent definitions phải đọc được, edit được bởi con người"
    implementation: "Markdown + YAML, không phải JSON/binary"

  persistent_learning:
    description: "AI agents nên nhớ và học từ sessions trước"
    implementation: "Memory system với context.md, learnings.md, decisions.md"
```

---

## 1.3 Bài toán cần giải quyết

### Thực trạng

AI coding assistants hiện tại có 4 hạn chế cốt lõi:

```
┌─────────────────────────────────────────────────────────────────┐
│                    CURRENT PROBLEMS                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. THIẾU CHUYÊN MÔN SÂU                                        │
│     ├── General AI biết mọi thứ nhưng không giỏi thứ gì        │
│     ├── Không có domain-specific best practices                 │
│     └── Thiếu institutional knowledge                           │
│                                                                  │
│  2. KHÔNG CÓ BỘ NHỚ                                             │
│     ├── Mỗi session bắt đầu từ đầu                              │
│     ├── Context lost khi session kết thúc                       │
│     └── Phải explain lại cùng một thứ nhiều lần                │
│                                                                  │
│  3. THIẾU KHẢ NĂNG PHỐI HỢP                                     │
│     ├── Single AI = single perspective                          │
│     ├── Không thể debate hoặc challenge ideas                   │
│     └── Blind spots không được phát hiện                        │
│                                                                  │
│  4. PLATFORM LOCK-IN                                             │
│     ├── Agents tied to specific tool                            │
│     ├── Cannot port to other platforms                          │
│     └── Ecosystem fragmentation                                 │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Giải pháp Dev-team

| Vấn đề | Giải pháp Dev-team | Implementation |
|--------|-------------------|----------------|
| Thiếu chuyên môn sâu | **Specialized Agents** | 43+ agents với pre-loaded knowledge |
| Không có bộ nhớ | **Persistent Memory** | context.md, learnings.md, decisions.md |
| Thiếu khả năng phối hợp | **Multi-Agent Teams** | 12+ team patterns với Maestro orchestrator |
| Platform lock-in | **Adapter Specification** | MicroAI spec với 3 compliance levels |

---

## 1.4 Giá trị cốt lõi

### Value Proposition Canvas

```
┌─────────────────────────────────────────────────────────────────┐
│                  VALUE PROPOSITION                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  GAINS CREATED                                                   │
│  ├── 10x faster code reviews với Linus agent                    │
│  ├── Consistent quality qua standardized agents                 │
│  ├── Reduced cognitive load - đúng agent cho đúng task          │
│  └── Team knowledge preservation qua memory system              │
│                                                                  │
│  PAINS RELIEVED                                                  │
│  ├── No more context re-explanation                             │
│  ├── No more "jack of all trades" AI responses                  │
│  ├── No more platform migration fears                           │
│  └── No more reinventing agent configurations                   │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Unique Selling Points

1. **"Expert Team in a Package"**
   - Install một lần, có ngay 43+ experts
   - Không cần prompt engineering knowledge
   - Ready-to-use cho common development tasks

2. **"Memory That Persists"**
   - Agents nhớ decisions từ sessions trước
   - Learning accumulates over time
   - Context không bị mất

3. **"Platform Freedom"**
   - Portable agent definitions
   - Migrate không mất agents
   - Future-proof investment

---

# Phần 2: Định nghĩa sản phẩm

## 2.1 Đối tượng người dùng

### Persona 1: Solo Developer

```yaml
persona: solo_developer
name: "Minh - Full-stack Developer"
description: |
  Developer làm việc một mình hoặc trong small team,
  cần AI support cho nhiều tasks khác nhau.

needs:
  - Code review khi không có peer
  - Debugging assistance
  - Architecture decision support
  - Testing guidance

pain_points:
  - Không có ai để review code
  - Phải context switch giữa nhiều domains
  - Thiếu feedback on technical decisions

how_devteam_helps:
  - Linus agent cho code review
  - Feynman agent cho debugging explanations
  - Deep Thinking Team cho architecture decisions
  - Beck agent cho TDD guidance

key_agents:
  - linus (code review)
  - feynman (explanations)
  - beck (testing)
  - polya (problem-solving)
```

### Persona 2: Team Lead

```yaml
persona: team_lead
name: "Hương - Engineering Manager"
description: |
  Quản lý team 5-10 developers, cần standardize
  AI workflows và đảm bảo quality across team.

needs:
  - Consistent code quality standards
  - Standardized AI workflows for team
  - Onboarding tools for new members
  - Architecture governance

pain_points:
  - Mỗi developer dùng AI khác nhau
  - Inconsistent code review quality
  - Khó onboard new members vào team practices

how_devteam_helps:
  - Shared agent configurations across team
  - Pre-configured code review standards
  - Knowledge bases với team conventions
  - Documented decision rationales

key_agents:
  - unclebob (clean code standards)
  - fowler (architecture patterns)
  - dev-qa team (testing workflows)
```

### Persona 3: Technical Architect

```yaml
persona: technical_architect
name: "Long - Solutions Architect"
description: |
  Architect đánh giá và thiết kế hệ thống,
  cần multiple perspectives cho complex decisions.

needs:
  - Multi-perspective analysis
  - Risk assessment
  - Trade-off evaluation
  - Documentation của decisions

pain_points:
  - Solo thinking leads to blind spots
  - Hard to challenge own assumptions
  - Decisions lack documented rationale

how_devteam_helps:
  - Deep Thinking Team với 20 agents
  - Munger agent cho inversion/risk analysis
  - ADR generation với dev-architect team
  - Documented decision trails

key_agents:
  - deep-thinking-team (full analysis)
  - munger (mental models)
  - grove (operational paranoia)
  - dijkstra (algorithmic correctness)
```

### Persona 4: Platform Developer

```yaml
persona: platform_developer
name: "Thành - Platform Engineer"
description: |
  Developer muốn port dev-team sang platforms khác
  hoặc customize framework deeply.

needs:
  - Clear specification để implement
  - Reference implementations
  - Compliance testing tools
  - Extension points

pain_points:
  - Undocumented behaviors
  - Missing edge cases in spec
  - No verification tools

how_devteam_helps:
  - MicroAI Adapter Specification (11 docs)
  - Minimal adapter example
  - Compliance checklist (70+ tests)
  - Clear level definitions (L1/L2/L3)

key_resources:
  - docs/adapter-spec/
  - docs/adapter-spec/examples/minimal-adapter/
  - docs/adapter-spec/11-compliance-checklist.md
```

---

## 2.2 Ma trận tính năng

### Core Features

| Feature | Mô tả | Trạng thái | Level |
|---------|-------|------------|-------|
| **Agent Definitions** | YAML+Markdown format cho agents | ✅ Done | L1 |
| **7 Core Tools** | Read, Write, Edit, Glob, Grep, Bash, AskUser | ✅ Done | L1 |
| **Settings System** | Permissions, plugins, model config | ✅ Done | L1 |
| **Reference Resolution** | @-notation cho file loading | ✅ Done | L1 |
| **Command System** | /namespace:command invocation | ✅ Done | L1 |
| **Knowledge Loading** | Selective loading via keyword index | ✅ Done | L2 |
| **Memory Persistence** | context.md, learnings.md, decisions.md | ✅ Done | L2 |
| **Team Coordination** | Multi-agent orchestration | ✅ Done | L2 |
| **Hooks System** | PreToolUse, PostToolUse, etc. | ✅ Done | L3 |
| **Web Tools** | WebFetch, WebSearch | ✅ Done | L3 |

### Agent Categories

```
┌─────────────────────────────────────────────────────────────────┐
│                    AGENT ECOSYSTEM                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  STANDALONE AGENTS (9)                                          │
│  ├── father-agent      Meta-agent creator                       │
│  ├── npm-agent         NPM package specialist                   │
│  ├── github-agent      GitHub operations                        │
│  ├── deep-question     Socratic questioning                     │
│  ├── ab-test-agent     A/B testing expert                       │
│  ├── go-dev-portable   Go development specialist                │
│  ├── go-refactor       Go refactoring specialist                │
│  ├── kanban-agent      Task management                          │
│  └── first-principles  First principles analysis                │
│                                                                  │
│  TEAM AGENTS (34+)                                              │
│  ├── deep-thinking-team (20 members)                            │
│  │   ├── Core: maestro, scribe                                  │
│  │   ├── Thinkers: socrates, aristotle, musk, feynman,         │
│  │   │             munger, polya, davinci                       │
│  │   ├── Builders: linus, dijkstra, knuth, carmack,            │
│  │   │             beck, fowler, unclebob, hickey               │
│  │   ├── Executors: bezos, jobs                                 │
│  │   └── Visionaries: jensen, grove, thiel                      │
│  ├── go-team (12+ members)                                      │
│  ├── project-team (18+ members)                                 │
│  ├── dev-qa team                                                │
│  ├── dev-architect team                                         │
│  ├── dev-security team                                          │
│  ├── pm-dev team                                                │
│  ├── dev-user team                                              │
│  ├── dev-algo team                                              │
│  ├── mining-team                                                │
│  └── deep-research team                                         │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 2.3 Các trường hợp sử dụng

### Use Case 1: Code Review với Linus Agent

```
┌─────────────────────────────────────────────────────────────────┐
│  USE CASE: Code Review                                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Actor: Solo Developer                                          │
│  Trigger: Hoàn thành PR, cần review trước khi merge             │
│                                                                  │
│  Flow:                                                          │
│  1. Developer gọi: /microai:go:go-review-linus                  │
│  2. Linus agent load Go knowledge base                          │
│  3. Linus reviews code với brutal honesty style                 │
│  4. Output: Detailed review với actionable feedback             │
│  5. Memory updated: patterns detected, decisions made           │
│                                                                  │
│  Outcome:                                                        │
│  - Code quality improved                                        │
│  - Patterns documented for future reference                     │
│  - Developer learns from Linus's feedback                       │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Use Case 2: Architecture Decision với Deep Thinking Team

```
┌─────────────────────────────────────────────────────────────────┐
│  USE CASE: Architecture Decision                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Actor: Technical Architect                                     │
│  Trigger: Cần quyết định giữa Redis vs Memcached cho caching    │
│                                                                  │
│  Flow:                                                          │
│  1. Architect gọi: /microai:deep-thinking                       │
│  2. Maestro classifies as "technical_architecture" problem      │
│  3. Phase 1: Socrates + Aristotle clarify requirements          │
│  4. Phase 2: Musk + Feynman analyze first principles            │
│  5. Phase 3: Munger + Grove assess risks                        │
│  6. Phase 4: Polya + Linus structure solution                   │
│  7. Phase 5: Da Vinci synthesizes final recommendation          │
│                                                                  │
│  Outcome:                                                        │
│  - Multi-perspective analysis                                   │
│  - Documented decision rationale                                │
│  - Risk assessment included                                     │
│  - Actionable recommendation                                    │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Use Case 3: Team Standardization

```
┌─────────────────────────────────────────────────────────────────┐
│  USE CASE: Team Workflow Standardization                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Actor: Team Lead                                               │
│  Trigger: Onboard new developer với team conventions            │
│                                                                  │
│  Flow:                                                          │
│  1. Team Lead đã install dev-team cho project                   │
│  2. New developer clones repo                                   │
│  3. .microai/ và .claude/ configs đã available                  │
│  4. Developer có access ngay đến:                               │
│     - Code review agents với team standards                     │
│     - Testing agents với team patterns                          │
│     - Knowledge bases với team conventions                      │
│                                                                  │
│  Outcome:                                                        │
│  - Instant onboarding với team AI tools                         │
│  - Consistent quality từ day 1                                  │
│  - Team knowledge preserved và shared                           │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Use Case 4: Platform Porting

```
┌─────────────────────────────────────────────────────────────────┐
│  USE CASE: Port Dev-team to VS Code                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Actor: Platform Developer                                      │
│  Trigger: Muốn dev-team agents chạy trong VS Code extension     │
│                                                                  │
│  Flow:                                                          │
│  1. Developer đọc MicroAI Adapter Spec                          │
│  2. Implement Level 1 compliance (core tools)                   │
│  3. Test với compliance checklist                               │
│  4. Implement Level 2 (knowledge, memory)                       │
│  5. Test again                                                  │
│  6. .microai/ agents chạy được trong VS Code                    │
│                                                                  │
│  Outcome:                                                        │
│  - Same agents work on VS Code                                  │
│  - No agent modifications needed                                │
│  - Users can switch platforms freely                            │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

# Phần 3: Kiến trúc kỹ thuật

## 3.1 Kiến trúc hệ thống

### 3-Layer Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         3-LAYER ARCHITECTURE                             │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  LAYER 3: RUNTIME STATE                                                 │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │  memory/           sessions/            workspace/               │   │
│  │  ├── context.md    ├── logs/            ├── current work        │   │
│  │  ├── learnings.md  └── checkpoints/     └── temp files          │   │
│  │  └── decisions.md                                                │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                              ▲                                          │
│                              │ Reads/Writes                             │
│                              │                                          │
│  LAYER 2: PLATFORM ADAPTERS                                             │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │  .claude/              .vscode/ (future)    .opencode/ (future) │   │
│  │  ├── settings.json     ├── settings.json   ├── settings.json   │   │
│  │  ├── commands/         ├── commands/       ├── commands/        │   │
│  │  └── skills/           └── tasks/          └── workflows/       │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                              ▲                                          │
│                              │ Activates                                │
│                              │                                          │
│  LAYER 1: CORE FRAMEWORK (Platform-Agnostic)                           │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │  .microai/                                                       │   │
│  │  ├── agents/           # Agent definitions                       │   │
│  │  │   ├── standalone/   # Individual agents                       │   │
│  │  │   └── teams/        # Multi-agent teams                       │   │
│  │  ├── knowledge/        # Shared knowledge bases                  │   │
│  │  ├── commands/         # Platform-agnostic commands              │   │
│  │  └── settings.json     # Core configuration                      │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Dependency Rules

```yaml
dependency_rules:
  layer_1_core:
    can_reference:
      - Own files within .microai/
    cannot_reference:
      - .claude/ or any platform adapter
      - External URLs or APIs

  layer_2_adapter:
    can_reference:
      - Layer 1 core files
      - Own platform-specific files
    cannot_reference:
      - Other platform adapters

  layer_3_runtime:
    can_reference:
      - Layer 1 and Layer 2 files
    is_modified_by:
      - Agent sessions
      - User actions
```

---

## 3.2 Hệ sinh thái Agent

### Agent Definition Format

```yaml
# Agent structure (YAML frontmatter + Markdown)
---
name: agent-id
description: |
  Mô tả ngắn gọn về agent
model: opus|sonnet
tools: [Bash, Read, Write, Edit, Glob, Grep, TodoWrite]
language: vi|en
color: purple|red|green|orange
icon: "emoji"
---

# Agent Title - Persona Name

## Activation Protocol
<activation critical="MANDATORY">
  <step n="1">Load persona</step>
  <step n="2">Load memory</step>
  <step n="3">Load knowledge</step>
  <step n="4">Display greeting</step>
</activation>

<persona>
  <role>Role description</role>
  <identity>Who I am</identity>
  <communication_style>How I communicate</communication_style>
  <principles>Core principles</principles>
</persona>

## Detailed Instructions
...markdown content...
```

### Agent Categories

| Category | Count | Examples | Use For |
|----------|-------|----------|---------|
| **Core Infrastructure** | 2 | maestro, scribe | Orchestration, Documentation |
| **Thinkers** | 7 | socrates, aristotle, musk, feynman, munger, polya, davinci | Analysis, Problem-solving |
| **Builders** | 8 | linus, dijkstra, knuth, carmack, beck, fowler, unclebob, hickey | Implementation, Quality |
| **Executors** | 2 | bezos, jobs | Strategy, Product |
| **Visionaries** | 3 | jensen, grove, thiel | Vision, Leadership |
| **Standalone** | 9 | father-agent, npm-agent, go-dev, etc. | Specific domains |

### Team Patterns

```
┌─────────────────────────────────────────────────────────────────┐
│                    TEAM PATTERNS                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  PATTERN 1: ORCHESTRATED PARALLEL                               │
│  (Deep Thinking Team)                                           │
│                                                                  │
│  ┌─────┐  ┌─────┐  ┌─────┐                                     │
│  │ A1  │  │ A2  │  │ A3  │   Phase 1 (parallel)                │
│  └──┬──┘  └──┬──┘  └──┬──┘                                     │
│     └────────┼────────┘                                         │
│              ▼                                                   │
│        ┌─────────┐                                              │
│        │ Maestro │   Orchestrate                                │
│        └────┬────┘                                              │
│             ▼                                                    │
│  ┌─────┐  ┌─────┐  ┌─────┐                                     │
│  │ B1  │  │ B2  │  │ B3  │   Phase 2 (parallel)                │
│  └──┬──┘  └──┬──┘  └──┬──┘                                     │
│     └────────┼────────┘                                         │
│              ▼                                                   │
│        ┌─────────┐                                              │
│        │ Da Vinci│   Synthesize                                 │
│        └─────────┘                                              │
│                                                                  │
│  PATTERN 2: TURN-BASED DIALOGUE                                 │
│  (Dev-QA, PM-Dev, Dev-Architect)                                │
│                                                                  │
│  ┌─────────┐        ┌─────────┐                                │
│  │ Agent A │◄──────►│ Agent B │                                │
│  └─────────┘        └─────────┘                                │
│       │                  │                                      │
│       ▼                  ▼                                      │
│  [Turn 1]           [Turn 2]                                    │
│       │                  │                                      │
│       ▼                  ▼                                      │
│  [Turn 3]           [Turn 4]                                    │
│       │                  │                                      │
│       └──────────────────┘                                      │
│              ▼                                                   │
│        ┌─────────┐                                              │
│        │ Output  │   Document generated                         │
│        └─────────┘                                              │
│                                                                  │
│  PATTERN 3: PIPELINE                                            │
│  (Go-Team, Project-Team)                                        │
│                                                                  │
│  ┌────┐    ┌────┐    ┌────┐    ┌────┐    ┌────┐              │
│  │ PM │───►│Arch│───►│Code│───►│Test│───►│ QA │              │
│  └────┘    └────┘    └────┘    └────┘    └────┘              │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 3.3 MicroAI Adapter Specification

### Tổng quan

MicroAI Adapter Specification định nghĩa cách xây dựng adapters để chạy .microai/ agents trên các platforms khác nhau.

**Tài liệu tham khảo:** [docs/adapter-spec/](./adapter-spec/)

### Compliance Levels

```
┌─────────────────────────────────────────────────────────────────┐
│                  COMPLIANCE LEVELS                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  LEVEL 1: MINIMAL (Required)                                    │
│  ├── 7 Core Tools (Read, Write, Edit, Glob, Grep, Bash, Ask)   │
│  ├── Agent Loading (YAML + Markdown parsing)                   │
│  ├── Settings Resolution (permissions, model)                  │
│  ├── Reference Resolution (@-notation)                         │
│  └── Command Execution (/namespace:command)                    │
│                                                                  │
│  LEVEL 2: STANDARD (Recommended)                                │
│  ├── All Level 1 features                                       │
│  ├── Knowledge System (selective loading)                       │
│  ├── Memory System (context, learnings, decisions)             │
│  ├── Agent Tool Restrictions                                    │
│  ├── settings.local.json support                               │
│  └── Additional Tools (TodoWrite, LSP)                         │
│                                                                  │
│  LEVEL 3: FULL                                                  │
│  ├── All Level 2 features                                       │
│  ├── Team Coordination (shared memory, handoffs)               │
│  ├── Hooks System (PreToolUse, PostToolUse, etc.)              │
│  ├── Web Tools (WebFetch, WebSearch)                           │
│  └── Session Archiving                                         │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Specification Documents

| # | Document | Nội dung |
|---|----------|----------|
| 01 | architecture.md | 3-Layer Architecture |
| 02 | agent-format.md | Agent definition format |
| 03 | tool-abstraction.md | Canonical tools |
| 04 | knowledge-system.md | Selective loading |
| 05 | memory-system.md | Persistence |
| 06 | team-coordination.md | Multi-agent |
| 07 | command-system.md | Invocation |
| 08 | permission-model.md | Security |
| 09 | hooks-system.md | Automation |
| 10 | implementation-guide.md | How to build |
| 11 | compliance-checklist.md | Verification |

---

## 3.4 Lớp trừu tượng công cụ

### Canonical Tools

Dev-team định nghĩa 14 canonical tools được abstract across platforms:

```yaml
canonical_tools:
  level_1_required:
    - name: Read
      signature: "Read(file_path, offset?, limit?)"
      purpose: "Đọc file content"

    - name: Write
      signature: "Write(file_path, content)"
      purpose: "Ghi file mới"

    - name: Edit
      signature: "Edit(file_path, old_string, new_string, replace_all?)"
      purpose: "Sửa file existing"

    - name: Glob
      signature: "Glob(pattern, path?)"
      purpose: "Tìm files theo pattern"

    - name: Grep
      signature: "Grep(pattern, path?, options)"
      purpose: "Tìm content trong files"

    - name: Bash
      signature: "Bash(command, timeout?)"
      purpose: "Chạy shell command"

    - name: AskUserQuestion
      signature: "AskUserQuestion(questions)"
      purpose: "Hỏi user để clarify"

  level_2_standard:
    - name: TodoWrite
      signature: "TodoWrite(todos)"
      purpose: "Quản lý task list"

    - name: LSP
      signature: "LSP(operation, filePath, line, character)"
      purpose: "Language server operations"

  level_3_extended:
    - name: WebFetch
      signature: "WebFetch(url, prompt)"
      purpose: "Fetch web content"

    - name: WebSearch
      signature: "WebSearch(query, options)"
      purpose: "Search web"
```

---

## 3.5 Hệ thống Knowledge & Memory

### Knowledge System

```yaml
knowledge_system:
  structure:
    knowledge/
      ├── knowledge-index.yaml    # Keyword → file mapping
      ├── 01-topic.md
      ├── 02-topic.md
      └── ...

  knowledge_index_format:
    topics:
      - name: "concurrency"
        keywords: ["goroutine", "channel", "mutex", "sync"]
        files: ["03-concurrency-patterns.md"]
      - name: "testing"
        keywords: ["test", "benchmark", "mock", "table-driven"]
        files: ["05-testing.md"]

  loading_strategy:
    - Scan user input for keywords
    - Match keywords to topics
    - Load only matched files
    - Reduces context by 50-80%
```

### Memory System

```yaml
memory_system:
  files:
    context.md:
      purpose: "Current session state"
      content:
        - Active problem
        - Current phase
        - Key decisions pending

    learnings.md:
      purpose: "Accumulated patterns"
      content:
        - Patterns discovered
        - Techniques that worked
        - Lessons learned

    decisions.md:
      purpose: "Decision log"
      content:
        - Decisions made
        - Rationales
        - Outcomes

  lifecycle:
    session_start: "Load memory files"
    during_session: "Reference and update"
    session_end: "Persist changes"
```

---

## 3.6 Mô hình bảo mật & phân quyền

### Permission Model

```yaml
permission_model:
  strategy: deny_first
  description: |
    Tất cả đều bị deny mặc định.
    Phải explicitly allow.

  pattern_types:
    - exact: "git status"           # Matches exactly
    - prefix: "git:"               # Matches git:*
    - glob: "npm *"                # Matches npm install, npm run, etc.
    - domain: "github.com"         # For web tools

  inheritance_chain:
    1. Team settings (settings.json)
    2. Local overrides (settings.local.json)
    3. Agent restrictions (tools field in agent.md)

  example:
    # settings.json
    allow:
      - "Bash(git:*)"             # Allow git commands
      - "Bash(npm:*)"             # Allow npm commands
    deny:
      - "Bash(rm -rf:*)"          # Never allow destructive commands
      - "Read(.env)"              # Never read secrets
```

### Sensitive Files Protection

```yaml
sensitive_patterns:
  - ".env"
  - ".env.*"
  - "credentials.json"
  - "secrets/*"
  - "*.key"
  - "*.pem"
```

---

# Phần 4: Triển khai

## 4.1 NPM Package & CLI

### Package Information

```json
{
  "name": "@microai.club/dev-team",
  "version": "1.0.0-alpha.2",
  "description": "Claude Code configuration framework for development teams",
  "bin": {
    "dev-team": "bin/cli.js"
  },
  "type": "module",
  "engines": {
    "node": ">=18"
  }
}
```

### CLI Commands

```bash
# Install dev-team to current project
dev-team install

# Options
dev-team install --no-interactive  # Skip prompts
dev-team install --force           # Overwrite existing
dev-team install --path ./mydir    # Custom path

# Future commands (planned)
dev-team update    # Update existing installation
dev-team list      # List available agents/teams
```

### What Gets Installed

```
your-project/
├── .claude/
│   ├── CLAUDE.md           # Project instructions
│   ├── settings.json       # Permissions
│   ├── agents/             # Claude-specific agents
│   ├── commands/           # Slash commands
│   └── skills/             # Skills
│
└── .microai/
    ├── agents/             # Portable agents
    │   ├── standalone/
    │   └── teams/
    ├── knowledge/          # Shared knowledge
    ├── commands/           # Platform-agnostic commands
    └── settings.json       # Core config
```

---

## 4.2 Cài đặt & Cấu hình

### Quick Start

```bash
# 1. Install package globally
npm install -g @microai.club/dev-team

# 2. Navigate to your project
cd your-project

# 3. Install dev-team configuration
dev-team install

# 4. Start using agents in Claude Code
claude code .
```

### Configuration Files

```yaml
# .microai/settings.json
{
  "model": "opus",
  "language": "vi",
  "permissions": {
    "allow": [
      "Bash(git:*)",
      "Bash(npm:*)"
    ]
  }
}

# .claude/settings.json
{
  "extends": "../.microai/settings.json",
  "permissions": {
    "allow": [
      "Bash(claude:*)"
    ]
  },
  "plugins": ["claude-mem", "context7"],
  "lspPlugins": ["go"]
}

# .claude/settings.local.json (gitignored)
{
  "permissions": {
    "allow": [
      "Bash(personal-script:*)"
    ]
  }
}
```

---

## 4.3 Platform Adapters

### Current: Claude Code Adapter

```
.claude/
├── CLAUDE.md              # Project-specific instructions
├── settings.json          # Permissions, plugins, model
├── agents/                # Claude-specific agent activations
│   └── README.md          # Agent listing
├── commands/              # Slash command definitions
│   └── microai/           # /microai:* namespace
│       ├── deep-thinking.md
│       ├── go/
│       │   ├── go-dev.md
│       │   └── go-refactor.md
│       └── ...
└── skills/                # Skill packages
    └── README.md
```

### Planned: VS Code Adapter

```
.vscode/           (future)
├── settings.json
├── tasks/
└── microai/
    └── activation.json
```

### Planned: OpenCode Adapter

```
.opencode/         (future)
├── config.yaml
└── agents/
```

---

## 4.4 Compliance Framework

### Compliance Testing

```yaml
compliance_testing:
  level_1_tests: 28
  level_2_tests: 24
  level_3_tests: 18
  total_tests: 70

  test_categories:
    - Settings Loading
    - Agent Discovery
    - Agent Loading
    - Reference Resolution
    - Tool Execution
    - Permission Checking
    - Knowledge Loading
    - Memory Persistence
    - Team Coordination
    - Hook Execution
```

### Example Compliance Checklist

```markdown
## Level 1: Minimal Compliance

### Settings Loading
- [ ] Load .microai/settings.json
- [ ] Parse permissions.allow
- [ ] Parse permissions.deny
- [ ] Apply deny-first resolution

### Agent Discovery
- [ ] Scan .microai/agents/ recursively
- [ ] Find agent.md files
- [ ] Parse YAML frontmatter
- [ ] Extract name, description, tools

### Core Tools
- [ ] Read: file content with line numbers
- [ ] Write: create new files
- [ ] Edit: string replacement
- [ ] Glob: pattern matching
- [ ] Grep: content search
- [ ] Bash: command execution
- [ ] AskUserQuestion: user interaction
```

---

# Phần 5: Lộ trình & Metrics

## 5.1 Lộ trình sản phẩm

### Phase 1: Foundation (Current - Alpha)

```yaml
phase_1_foundation:
  status: "In Progress"

  completed:
    - Claude Code adapter
    - 43+ agents defined
    - 12+ team patterns
    - MicroAI Adapter Specification
    - NPM package with CLI
    - Comprehensive documentation

  in_progress:
    - User feedback collection
    - Bug fixes
    - Documentation improvements

  deliverables:
    - v1.0.0-alpha stable release
    - Complete adapter spec
    - Reference implementation
```

### Phase 2: Stabilization (Beta)

```yaml
phase_2_stabilization:
  status: "Planned"

  goals:
    - Stabilize APIs
    - Improve error handling
    - Add more test coverage
    - Community feedback integration

  features:
    - dev-team update command
    - dev-team list command
    - Agent validation tool
    - Performance optimizations

  deliverables:
    - v1.0.0-beta release
    - Migration guide
    - Best practices guide
```

### Phase 3: Platform Expansion (v1.0)

```yaml
phase_3_expansion:
  status: "Planned"

  goals:
    - VS Code adapter
    - OpenCode adapter
    - Cursor adapter (TBD)

  features:
    - Cross-platform testing
    - Adapter SDK
    - Plugin marketplace

  deliverables:
    - v1.0.0 stable release
    - Multi-platform support
    - Contributor ecosystem
```

### Phase 4: Ecosystem Growth (v1.x)

```yaml
phase_4_ecosystem:
  status: "Future"

  goals:
    - Community agent marketplace
    - Enterprise features
    - Analytics and insights

  features:
    - Agent publishing workflow
    - Team management
    - Usage analytics
    - Custom model support
```

---

## 5.2 Metrics thành công

### Adoption Metrics

| Metric | Target (6 months) | Measurement |
|--------|-------------------|-------------|
| NPM Downloads | 1,000+ | npm stats |
| GitHub Stars | 100+ | GitHub |
| Active Projects | 50+ | Telemetry (opt-in) |
| Community Agents | 10+ | Contributions |

### Quality Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| Documentation Coverage | 100% | All features documented |
| Test Coverage | 80%+ | Compliance tests passing |
| Bug Resolution Time | < 1 week | Issue tracking |
| User Satisfaction | 4+/5 | Surveys |

### Engagement Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| Agent Invocations/User | 10+/week | Opt-in telemetry |
| Session Duration | 30+ min | Session logs |
| Repeat Usage | 70%+ | Return users |
| Feature Adoption | 60%+ | Feature usage |

---

## 5.3 Phụ lục

### Thuật ngữ

| Thuật ngữ | Định nghĩa |
|-----------|------------|
| **Agent** | AI persona với domain expertise, định nghĩa trong markdown |
| **Adapter** | Platform-specific layer kết nối .microai/ với coding tool |
| **Canonical Tool** | Tool abstraction được định nghĩa trong spec |
| **Compliance Level** | Mức độ implementation của adapter (L1/L2/L3) |
| **Knowledge Base** | Tập hợp domain knowledge được load selective |
| **Maestro** | Orchestrator agent điều phối multi-agent sessions |
| **Memory** | Persistent storage cho agent state across sessions |
| **MicroAI** | Platform-agnostic agent framework |
| **Team** | Nhóm agents phối hợp theo pattern cụ thể |

### Tham khảo

| Tài liệu | Vị trí |
|----------|--------|
| Adapter Specification | [docs/adapter-spec/](./adapter-spec/) |
| Getting Started | [docs/getting-started/](./getting-started/) |
| Guides | [docs/guides/](./guides/) |
| Agent Reference | [docs/agents/](./agents/) |
| CLI Reference | [docs/reference/](./reference/) |
| Contributing | [docs/contributing/](./contributing/) |

### Liên hệ

- **GitHub Issues**: [Report bugs and feature requests](https://github.com/microai-club/dev-team/issues)
- **Discussions**: [Community discussions](https://github.com/microai-club/dev-team/discussions)

---

*Tài liệu này được tạo bởi Deep Thinking Team với phương pháp 5-Phase Protocol.*

*Cập nhật lần cuối: 2025-12-31*
