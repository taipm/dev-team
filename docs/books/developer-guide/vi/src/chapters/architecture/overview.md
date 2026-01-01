# Kiến Trúc MicroAI

Tổng quan về kiến trúc của MicroAI framework.

## Triết Lý Thiết Kế

MicroAI được xây dựng với triết lý **"Write Once, Run Anywhere"** cho AI agents:

- **Portable**: Agents định nghĩa một lần, chạy trên nhiều platforms
- **Modular**: Mỗi component độc lập và có thể thay thế
- **Extensible**: Dễ dàng mở rộng với agents, teams, skills mới
- **Persistent**: Memory và knowledge được lưu trữ qua sessions

## Mô Hình 3 Lớp

```
┌─────────────────────────────────────────────────────────────┐
│                    LAYER 3: RUNTIME STATE                   │
│  ┌─────────────────────────────────────────────────────────┐│
│  │ Agent Memory │ Team Memory │ Session Logs │ Checkpoints ││
│  └─────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────┘
                              ▲
                              │ reads/writes
                              │
┌─────────────────────────────────────────────────────────────┐
│                 LAYER 2: PLATFORM ADAPTERS                  │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────────────┐ │
│  │    .claude/  │ │   .vscode/   │ │      .opencode/      │ │
│  │  (Hiện tại)  │ │   (Tương lai)│ │     (Tương lai)      │ │
│  │              │ │              │ │                      │ │
│  │ settings.json│ │ settings.json│ │    settings.json     │ │
│  │ commands/    │ │ commands/    │ │    commands/         │ │
│  │ skills/      │ │ extensions/  │ │    plugins/          │ │
│  └──────────────┘ └──────────────┘ └──────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                              │
                              │ references (one-way)
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                  LAYER 1: CORE FRAMEWORK                    │
│                        .microai/                            │
│  ┌─────────────────────────────────────────────────────────┐│
│  │                        agents/                          ││
│  │  ┌─────────────┐ ┌─────────────┐ ┌─────────────────┐   ││
│  │  │ agent.md    │ │ knowledge/  │ │ memory/         │   ││
│  │  │ (YAML+MD)   │ │ (selective) │ │ (persistent)    │   ││
│  │  └─────────────┘ └─────────────┘ └─────────────────┘   ││
│  ├─────────────────────────────────────────────────────────┤│
│  │                        teams/                           ││
│  │  ┌─────────────┐ ┌─────────────┐ ┌─────────────────┐   ││
│  │  │ workflow.md │ │ agents/     │ │ team-memory/    │   ││
│  │  └─────────────┘ └─────────────┘ └─────────────────┘   ││
│  ├─────────────────────────────────────────────────────────┤│
│  │ commands/ │ hooks/ │ knowledge/ │ kanban/              ││
│  └─────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────┘
```

## Chi Tiết Từng Lớp

### Layer 1: Core Framework (.microai/)

**Đặc điểm**:
- Platform-independent
- Chứa định nghĩa agents, teams, knowledge
- Portable giữa các dự án

**Cấu trúc**:

```
.microai/
├── agents/                    # Agent definitions
│   ├── npm-agent/
│   │   ├── agent.md          # Agent definition
│   │   ├── knowledge/        # Domain knowledge
│   │   │   ├── 01-topic.md
│   │   │   └── knowledge-index.yaml
│   │   └── memory/           # Agent memory
│   │       ├── context.md
│   │       ├── decisions.md
│   │       └── learnings.md
│   │
│   └── microai/teams/        # Team definitions
│       └── deep-thinking/
│           ├── workflow.md
│           ├── agents/
│           └── team-memory/
│
├── commands/                  # Platform-agnostic commands
├── hooks/                     # Automation scripts
├── knowledge/                 # Shared knowledge
│   └── shared/
└── kanban/                    # Task tracking
```

### Layer 2: Platform Adapters

**Đặc điểm**:
- Platform-specific settings và activation
- References đến Layer 1 (one-way dependency)
- Không chứa agent definitions

**Claude Code Adapter (.claude/)**:

```
.claude/
├── CLAUDE.md                  # Project context
├── settings.json              # Team configuration
├── settings.local.json        # Personal overrides (gitignored)
│
├── agents/                    # Agent shortcuts (optional)
│   └── README.md
│
├── commands/                  # Activation commands
│   └── microai/
│       ├── deep-thinking.md
│       └── npm.md
│
└── skills/                    # Skill definitions
    └── README.md
```

### Layer 3: Runtime State

**Đặc điểm**:
- Auto-generated
- Session-specific
- Thường gitignored

**Nội dung**:
- Agent memory files (context.md, decisions.md, learnings.md)
- Team memory (handoffs.md, blockers.md)
- Session logs (.microai/logs/)

## Dependency Rules

### Rule 1: One-Way Dependencies

```
.claude/  ──references──▶  .microai/
           (adapter)        (core)

.microai/ ──KHÔNG──▶  .claude/
          reference
```

### Rule 2: Core Is Portable

```
# Copy entire .microai/ to new project
cp -r project-a/.microai/ project-b/

# Works immediately with any adapter
```

### Rule 3: Adapters Are Platform-Specific

```
# Claude Code adapter
.claude/ → settings.json với Claude Code format

# VS Code adapter (future)
.vscode/ → settings.json với VS Code format

# OpenCode adapter (future)
.opencode/ → settings.json với OpenCode format
```

## Component Flow

### Agent Activation

```
1. User: /microai:npm

2. Claude Code reads:
   .claude/commands/microai/npm.md

3. Command references:
   @.microai/agents/npm-agent/agent.md

4. Claude loads:
   - agent.md (persona, rules)
   - knowledge/ (selective)
   - memory/ (context, decisions)

5. Agent is active with full context
```

### Team Activation

```
1. User: /microai:deep-thinking

2. Claude Code reads:
   .claude/commands/microai/deep-thinking.md

3. Command references:
   @.microai/agents/microai/teams/deep-thinking/workflow.md

4. Claude loads:
   - workflow.md (phases, protocol)
   - agents/ (all team members)
   - team-memory/ (shared state)

5. Team is active, workflow begins
```

## Nguyên Tắc Thiết Kế

### 1. Separation of Concerns

| Layer | Responsibility |
|-------|----------------|
| Core | Agent definitions, knowledge, memory |
| Adapter | Platform settings, activation |
| Runtime | Session state, logs |

### 2. Minimal Coupling

- Core không biết về adapter
- Adapter chỉ reference core
- Runtime được tạo tự động

### 3. Progressive Enhancement

| Level | Features |
|-------|----------|
| Minimal | Basic agent loading, core tools |
| Standard | Knowledge, memory, permissions |
| Full | Teams, hooks, full tool suite |

## Bước Tiếp Theo

- [Mô hình 3 lớp (chi tiết)](./three-layer-model.md)
- [Core vs Adapter](./core-vs-adapter.md)
- [Portable Agents](./portable-agents.md)
