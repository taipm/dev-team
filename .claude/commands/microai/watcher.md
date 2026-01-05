---
name: 'watcher'
description: 'Claude Watcher - Meta-Agent tự động giám sát và điều khiển Claude Code'
---

# Claude Watcher Activation

Bạn là **Claude Watcher Controller** - interface để điều khiển hệ thống Meta-Agent giám sát Claude Code.

## Commands

Parse user input để xác định command:

| Input | Action |
|-------|--------|
| `/watcher init` | Khởi tạo hệ thống watcher |
| `/watcher start "goal"` | Bắt đầu watching với goal |
| `/watcher stop` | Dừng watching |
| `/watcher status` | Xem trạng thái hiện tại |
| `/watcher think` | Force Thinker analysis |
| `/watcher reset` | Reset toàn bộ data |

## Execution

<command-execution>

Dựa vào input của user, thực thi lệnh tương ứng:

### init
```bash
.microai/agents/claude-watcher/scripts/run.sh init
```

### start
```bash
.microai/agents/claude-watcher/scripts/run.sh start "{goal}"
```

### stop
```bash
.microai/agents/claude-watcher/scripts/run.sh stop
```

### status
```bash
.microai/agents/claude-watcher/scripts/run.sh status
```

### think
```bash
.microai/agents/claude-watcher/scripts/run.sh think
```

### reset
```bash
.microai/agents/claude-watcher/scripts/run.sh reset
```

</command-execution>

## Quick Start Guide

Khi user gọi `/watcher` lần đầu hoặc cần hướng dẫn:

```
╔═══════════════════════════════════════════════════════════════╗
║                    CLAUDE WATCHER                              ║
║         Meta-Agent tự động giám sát Claude Code                ║
╠═══════════════════════════════════════════════════════════════╣
║                                                                ║
║  Quick Start:                                                  ║
║  1. /watcher init          - Khởi tạo lần đầu                 ║
║  2. /watcher start "goal"  - Bắt đầu watching                 ║
║  3. Worker làm việc bình thường                               ║
║  4. Watcher tự động observe và can thiệp khi cần              ║
║                                                                ║
║  Commands:                                                     ║
║  • /watcher status  - Xem trạng thái                          ║
║  • /watcher think   - Force phân tích                         ║
║  • /watcher stop    - Dừng watching                           ║
║  • /watcher reset   - Xóa data, bắt đầu lại                   ║
║                                                                ║
╚═══════════════════════════════════════════════════════════════╝
```

## How It Works

```
┌─────────────────────────────────────────────────────────────────┐
│                    CLAUDE-WATCHER FLOW                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  YOU (User) ─────────────────────────────────────────────────┐  │
│       │                                                       │  │
│       │ "/watcher start 'Build REST API'"                     │  │
│       ↓                                                       │  │
│  ┌─────────────────────────────────────────────────────────┐ │  │
│  │               WORKER SESSION (This Claude)               │ │  │
│  │  - Thực hiện task theo yêu cầu                           │ │  │
│  │  - Mọi tool call được ghi nhận qua hooks                 │ │  │
│  └─────────────────────────────────────────────────────────┘ │  │
│           ↓ (Hooks observe)                                   │  │
│                                                               │  │
│  ┌─────────────────────────────────────────────────────────┐ │  │
│  │                    OBSERVER                              │ │  │
│  │  - Ghi log tool calls                                    │ │  │
│  │  - Track errors, patterns                                │ │  │
│  │  - Check trigger conditions                              │ │  │
│  └─────────────────────────────────────────────────────────┘ │  │
│           ↓ (Khi trigger)                                     │  │
│                                                               │  │
│  ┌─────────────────────────────────────────────────────────┐ │  │
│  │            THINKER (Another Claude Session)              │ │  │
│  │  - Phân tích observations                                │ │  │
│  │  - Quyết định: CONTINUE / REDIRECT / HELP / STOP         │ │  │
│  │  - Viết command nếu cần can thiệp                        │ │  │
│  └─────────────────────────────────────────────────────────┘ │  │
│           ↓ (Nếu can thiệp)                                   │  │
│                                                               │  │
│  ┌─────────────────────────────────────────────────────────┐ │  │
│  │                   COMMANDER                              │ │  │
│  │  - Gửi command đến Worker                                │ │  │
│  │  - Worker điều chỉnh approach                            │ │  │
│  └─────────────────────────────────────────────────────────┘ │  │
│           ↓                                                   │  │
│           ↻ LOOP                                              │  │
│                                                               │  │
└───────────────────────────────────────────────────────────────┘
```

## Trigger Conditions

Thinker được gọi khi:

| Condition | Threshold | Description |
|-----------|-----------|-------------|
| **Tool count** | 15 calls | Periodic review |
| **Repeated errors** | 3+ times | Same error keeps happening |
| **Stuck loop** | 5+ edits | Same file edited repeatedly |
| **Time interval** | 10 minutes | Periodic health check |

## Files

```
.microai/agents/claude-watcher/
├── agent.md                    # Agent definition
├── hooks/                      # Hook scripts
│   ├── pre-tool-use.sh
│   ├── post-tool-use.sh
│   └── user-prompt-submit.sh
├── scripts/                    # Orchestration
│   ├── run.sh
│   ├── observer.sh
│   ├── trigger.sh
│   └── commander.sh
├── memory/                     # Runtime data
│   ├── observations.jsonl
│   ├── state.yaml
│   ├── decisions.md
│   └── archive/
├── config/                     # Configuration
│   └── triggers.yaml
└── templates/                  # Prompt templates
    ├── thinker-prompt.md
    └── intervention.md
```
