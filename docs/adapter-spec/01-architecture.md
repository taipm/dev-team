# 01 - Architecture | Kiến trúc

> **Specification Version**: 1.0
>
> **Status**: Stable | Ổn định

---

## Overview | Tổng quan

MicroAI uses a **3-layer architecture** that separates portable agent definitions from platform-specific implementations.

MicroAI sử dụng **kiến trúc 3 lớp** tách biệt định nghĩa agent di động khỏi implementation riêng từng nền tảng.

---

## The Three Layers | Ba lớp kiến trúc

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                                                                             │
│  LAYER 1: CORE FRAMEWORK                                                    │
│  ════════════════════════                                                   │
│                                                                             │
│  Location: .microai/                                                        │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  agents/           → Agent definitions (YAML + Markdown)            │   │
│  │  ├── microai/                                                       │   │
│  │  │   ├── agents/   → Individual agents                              │   │
│  │  │   └── teams/    → Multi-agent teams                              │   │
│  │  └── {portable}/   → Portable agent packages                        │   │
│  │                                                                     │   │
│  │  commands/         → Platform-agnostic command definitions          │   │
│  │  hooks/            → Automation scripts                             │   │
│  │  knowledge/        → Shared knowledge bases                         │   │
│  │  kanban/           → Task management                                │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  Properties | Đặc điểm:                                                     │
│  • NO platform-specific code                                                │
│  • NO references to .claude/, .vscode/, etc.                               │
│  • FULLY self-contained                                                     │
│  • Can be shared across all platforms                                       │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      │ References (one-way)
                                      │ Tham chiếu (một chiều)
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                                                                             │
│  LAYER 2: PLATFORM ADAPTERS                                                 │
│  ══════════════════════════                                                 │
│                                                                             │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │  .claude/       │  │  .vscode/       │  │  .opencode/     │             │
│  │  ────────────── │  │  ────────────── │  │  ────────────── │             │
│  │  Claude Code    │  │  VS Code        │  │  OpenCode CLI   │             │
│  │  Adapter        │  │  Adapter        │  │  Adapter        │             │
│  │                 │  │                 │  │                 │             │
│  │  settings.json  │  │  settings.json  │  │  config.yaml    │             │
│  │  commands/      │  │  commands/      │  │  commands/      │             │
│  │  skills/        │  │  extensions/    │  │  plugins/       │             │
│  │                 │  │                 │  │                 │             │
│  │  ✅ IMPLEMENTED │  │  🔮 FUTURE      │  │  🔮 FUTURE      │             │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
│                                                                             │
│  Properties | Đặc điểm:                                                     │
│  • Platform-specific settings and permissions                               │
│  • Maps abstract tools to platform implementations                          │
│  • Activates agents from .microai/                                         │
│  • Contains platform-specific commands/skills                               │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      │ Reads/Writes
                                      │ Đọc/Ghi
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                                                                             │
│  LAYER 3: RUNTIME STATE                                                     │
│  ══════════════════════                                                     │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  Agent Memory         → .microai/agents/{agent}/memory/             │   │
│  │  ├── context.md       → Current session state                       │   │
│  │  ├── decisions.md     → Key decisions log                           │   │
│  │  └── learnings.md     → Patterns learned                            │   │
│  │                                                                     │   │
│  │  Team Memory          → .microai/agents/microai/teams/{team}/       │   │
│  │  └── team-memory/     → Shared team state                           │   │
│  │                                                                     │   │
│  │  Session Logs         → .microai/logs/                              │   │
│  │  └── YYYY-MM-DD-*.md  → Session archives                            │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  Properties | Đặc điểm:                                                     │
│  • Runtime data (not part of agent definition)                              │
│  • Typically gitignored (user-specific)                                     │
│  • Same format across all platforms                                         │
│  • Portable between sessions                                                │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Dependency Direction | Hướng phụ thuộc

```
                    DEPENDENCIES
                    ════════════

.microai/           .claude/            .vscode/            .opencode/
    │                   │                   │                   │
    │                   │                   │                   │
    ▼                   ▼                   ▼                   ▼
┌───────┐          ┌───────┐          ┌───────┐          ┌───────┐
│ CORE  │◄─────────│ADAPTER│          │ADAPTER│          │ADAPTER│
│       │◄─────────│       │          │       │          │       │
│       │◄─────────│       │──────────│       │──────────│       │
└───────┘          └───────┘          └───────┘          └───────┘

RULE: Adapters depend on Core. Core depends on NOTHING.
QUY TẮC: Adapters phụ thuộc Core. Core KHÔNG phụ thuộc gì.
```

**Critical Rule | Quy tắc quan trọng:**

```yaml
# ✅ CORRECT - Adapter references Core
# ĐÚNG - Adapter tham chiếu Core
.claude/commands/go-dev.md:
  content: "LOAD agent from @.microai/agents/go-dev/agent.md"

# ❌ WRONG - Core references Adapter
# SAI - Core tham chiếu Adapter
.microai/agents/go-dev/agent.md:
  content: "Use .claude/settings.json"  # NEVER DO THIS!
```

---

## Directory Structure | Cấu trúc thư mục

### Layer 1: Core (.microai/)

```
.microai/
├── agents/
│   ├── microai/                      # Core agent collection
│   │   ├── agents/                   # Individual agents
│   │   │   ├── go-dev-agent.md
│   │   │   ├── go-dev-agent/
│   │   │   │   ├── knowledge/        # Agent knowledge
│   │   │   │   └── memory/           # Agent memory (runtime)
│   │   │   └── ...
│   │   └── teams/                    # Multi-agent teams
│   │       ├── deep-thinking-team/
│   │       ├── dev-qa/
│   │       └── ...
│   ├── father-agent/                 # Meta-agent
│   ├── go-refactor-portable/         # Portable package
│   └── npm-agent/
│
├── commands/                         # Platform-agnostic commands
│   ├── go/
│   │   ├── go-dev.md
│   │   └── go-refactor.md
│   └── github.md
│
├── hooks/                            # Automation hooks
│   ├── pre-tool-use/
│   └── post-tool-use/
│
├── knowledge/                        # Shared knowledge
│   └── common-patterns.md
│
└── kanban/                           # Task management
    └── board.yaml
```

### Layer 2: Adapter (.claude/ example)

```
.claude/
├── settings.json                     # Platform permissions
├── settings.local.json               # Personal overrides (gitignored)
│
├── agents/
│   └── microai/                      # Reference structure (mostly empty)
│       └── README.md                 # Points to .microai/
│
├── commands/
│   └── microai/                      # Platform-specific activation
│       ├── go-dev.md                 # /go-dev command
│       └── deep-thinking.md          # /deep-thinking command
│
├── skills/                           # Platform-specific skills
│   └── README.md
│
└── CLAUDE.md                         # Project context
```

---

## Data Flow | Luồng dữ liệu

### Agent Activation Flow | Luồng kích hoạt agent

```
┌────────────────────────────────────────────────────────────────────────────┐
│  1. USER INVOKES COMMAND                                                   │
│     User: "/go-dev fix the race condition"                                 │
└────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      ▼
┌────────────────────────────────────────────────────────────────────────────┐
│  2. ADAPTER LOADS COMMAND                                                  │
│     Load: .claude/commands/microai/go-dev.md                              │
│     Extract: @.microai/agents/go-dev/agent.md reference                   │
└────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      ▼
┌────────────────────────────────────────────────────────────────────────────┐
│  3. ADAPTER RESOLVES REFERENCE                                             │
│     @.microai/agents/go-dev/agent.md                                      │
│         → {project_root}/.microai/agents/go-dev/agent.md                  │
└────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      ▼
┌────────────────────────────────────────────────────────────────────────────┐
│  4. ADAPTER LOADS AGENT                                                    │
│     Parse: YAML frontmatter (name, tools, model, language)                │
│     Parse: Activation protocol (<activation> XML block)                   │
│     Parse: Markdown body (instructions, knowledge refs)                   │
└────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      ▼
┌────────────────────────────────────────────────────────────────────────────┐
│  5. ADAPTER LOADS MEMORY                                                   │
│     Load: .microai/agents/go-dev/memory/context.md                        │
│     Load: .microai/agents/go-dev/memory/decisions.md                      │
└────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      ▼
┌────────────────────────────────────────────────────────────────────────────┐
│  6. ADAPTER LOADS KNOWLEDGE                                                │
│     Parse: knowledge/knowledge-index.yaml                                 │
│     Match: Keywords from task → relevant knowledge files                  │
│     Load: Selected knowledge files into context                           │
└────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      ▼
┌────────────────────────────────────────────────────────────────────────────┐
│  7. AGENT EXECUTES                                                         │
│     • Embody persona from activation protocol                             │
│     • Process user task with knowledge context                            │
│     • Use tools (mapped by adapter to platform implementations)           │
└────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      ▼
┌────────────────────────────────────────────────────────────────────────────┐
│  8. SESSION END                                                            │
│     Update: memory/context.md with new state                              │
│     Log: Decisions to memory/decisions.md                                 │
│     Save: Patterns to memory/learnings.md                                 │
└────────────────────────────────────────────────────────────────────────────┘
```

---

## Platform Adapter Contract | Hợp đồng adapter nền tảng

Each adapter MUST implement:

Mỗi adapter PHẢI implement:

### Required Capabilities | Khả năng bắt buộc

```typescript
interface MicroAIAdapter {
  // 1. Settings Management | Quản lý cài đặt
  loadSettings(path: string): Settings;
  mergeLocalSettings(base: Settings, local: Settings): Settings;

  // 2. Reference Resolution | Phân giải tham chiếu
  resolveReference(ref: string): string;  // @path → absolute path

  // 3. Agent System | Hệ thống agent
  discoverAgents(root: string): AgentPath[];
  loadAgent(path: string): Agent;
  parseYAMLFrontmatter(content: string): AgentConfig;
  parseActivationProtocol(content: string): ActivationSteps[];

  // 4. Tool System | Hệ thống tool
  registerTool(name: string, impl: ToolImpl): void;
  executeTool(name: string, params: any): Promise<ToolResult>;
  checkPermission(tool: string, params: any): boolean;

  // 5. Memory System | Hệ thống memory
  loadMemory(agent: Agent): Memory;
  saveMemory(agent: Agent, memory: Memory): void;

  // 6. Knowledge System | Hệ thống knowledge
  loadKnowledgeIndex(path: string): KnowledgeIndex;
  selectKnowledge(task: string, index: KnowledgeIndex): string[];
  loadKnowledgeFiles(paths: string[]): string;

  // 7. Command System | Hệ thống lệnh
  discoverCommands(root: string): Command[];
  executeCommand(cmd: Command, args: string): void;
}
```

---

## Portability Verification | Kiểm tra tính di động

To verify an agent is truly portable:

Để xác minh agent thực sự di động:

```bash
# Check 1: No platform references in .microai/
# Kiểm tra 1: Không có tham chiếu nền tảng trong .microai/
grep -r "\.claude\|\.vscode\|\.opencode" .microai/agents/
# Expected: No matches | Kỳ vọng: Không có kết quả

# Check 2: No absolute paths
# Kiểm tra 2: Không có đường dẫn tuyệt đối
grep -r "^/" .microai/agents/**/*.md
# Expected: No matches | Kỳ vọng: Không có kết quả

# Check 3: All tool references are abstract
# Kiểm tra 3: Tất cả tham chiếu tool đều trừu tượng
grep -r "tools:" .microai/agents/**/*.md | grep -v "Read\|Write\|Edit\|Bash\|Glob\|Grep"
# Expected: No non-canonical tools | Kỳ vọng: Không có tool không chuẩn
```

---

## Example: Same Agent, Different Platforms | Ví dụ: Cùng agent, khác nền tảng

### Core Agent (shared) | Agent lõi (dùng chung)

```markdown
# File: .microai/agents/go-dev/agent.md

---
name: go-dev
description: Go development specialist
model: sonnet
tools: [Read, Write, Edit, Bash, Glob, Grep]
language: vi
---

> "Talk is cheap. Show me the code."

<activation critical="MANDATORY">
  <step n="1">Load persona</step>
  <step n="2">Load memory/context.md</step>
  <step n="3">Ready for Go development tasks</step>
</activation>

## Capabilities
- Implement Go code following best practices
- Debug and fix issues
- Refactor for clarity and performance
```

### Claude Code Adapter | Adapter Claude Code

```markdown
# File: .claude/commands/microai/go-dev.md

---
name: 'go-dev'
description: 'Go development specialist'
---

<agent-activation CRITICAL="TRUE">
1. LOAD agent from @.microai/agents/go-dev/agent.md
2. Execute activation protocol
3. Apply Go best practices
</agent-activation>
```

### OpenCode Adapter (hypothetical) | Adapter OpenCode (giả định)

```yaml
# File: .opencode/commands/go-dev.yaml

name: go-dev
description: Go development specialist
agent: "@.microai/agents/go-dev/agent.md"
activation:
  - load_agent
  - execute_protocol
  - apply_context
```

### VS Code Adapter (hypothetical) | Adapter VS Code (giả định)

```json
// File: .vscode/microai/commands/go-dev.json
{
  "name": "go-dev",
  "description": "Go development specialist",
  "agent": "@.microai/agents/go-dev/agent.md",
  "keybinding": "ctrl+shift+g"
}
```

**Result | Kết quả:** Same agent definition works across all three platforms!

Cùng một định nghĩa agent hoạt động trên cả ba nền tảng!

---

## Summary | Tóm tắt

| Layer | Location | Purpose | Portable? |
|-------|----------|---------|-----------|
| **1. Core** | `.microai/` | Agent definitions, knowledge, teams | ✅ YES |
| **2. Adapter** | `.{platform}/` | Platform-specific activation | ❌ NO (per platform) |
| **3. Runtime** | `*/memory/`, `*/logs/` | Session state | ✅ YES (format is standard) |

**Key Takeaway | Điểm chính:**

> The value is in `.microai/`. Adapters are thin activation layers.
>
> Giá trị nằm ở `.microai/`. Adapters chỉ là lớp kích hoạt mỏng.

---

*Next: [02-agent-format.md](./02-agent-format.md) - Agent YAML + Markdown Format*
