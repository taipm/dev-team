# Claude Watcher - Meta-Agent for Claude Code

> "Observe, Think, Command - The autonomous overseer for Claude Code"

## Overview

Claude Watcher là một **Meta-Agent** hoạt động bên ngoài Claude Code session chính, có nhiệm vụ:

1. **Observe**: Theo dõi mọi hoạt động của Claude Code Worker thông qua hooks
2. **Think**: Phân tích observations để đánh giá Worker performance
3. **Command**: Can thiệp khi cần thiết bằng cách gửi commands đến Worker

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    CLAUDE-WATCHER SYSTEM                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  USER: "Build feature X"                                         │
│           ↓                                                      │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │               WORKER SESSION (Claude Code #1)            │    │
│  │  - Nhận task từ user hoặc Thinker                        │    │
│  │  - Thực thi: Read, Write, Edit, Bash, etc.               │    │
│  │  - Hooks gửi mọi activity → Observer                     │    │
│  └─────────────────────────────────────────────────────────┘    │
│           ↓ (Hooks: Pre/PostToolUse, UserPromptSubmit)          │
│                                                                  │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                    OBSERVER MODULE                        │    │
│  │  - Ghi log tất cả tool calls + outputs                   │    │
│  │  - Track metrics: tool count, errors, patterns           │    │
│  │  - Smart trigger → gọi Thinker khi cần                   │    │
│  └─────────────────────────────────────────────────────────┘    │
│           ↓ (Trigger conditions met)                            │
│                                                                  │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │            THINKER SESSION (Claude Code #2)              │    │
│  │  - Đọc observation logs + current state                  │    │
│  │  - Phân tích: On track? Stuck? Better approach?          │    │
│  │  - Quyết định: Continue / Intervene / Redirect           │    │
│  │  - Viết command cho Worker nếu cần                       │    │
│  └─────────────────────────────────────────────────────────┘    │
│           ↓ (Nếu có intervention)                               │
│                                                                  │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                   COMMANDER MODULE                        │    │
│  │  - Đọc Thinker decision                                  │    │
│  │  - Inject command vào Worker session                     │    │
│  │  - Track intervention history                            │    │
│  └─────────────────────────────────────────────────────────┘    │
│           ↓                                                      │
│           ↻ LOOP until task complete                            │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## Quick Start

### 1. Initialize

```bash
/watcher init
```

Hoặc chạy trực tiếp:
```bash
.microai/agents/claude-watcher/scripts/run.sh init
```

### 2. Start Watching

```bash
/watcher start "Build a REST API for user management"
```

### 3. Let Worker Work

Worker (Claude Code session chính) làm việc bình thường. Watcher sẽ:
- Observe mọi tool calls
- Track errors và patterns
- Tự động trigger Thinker khi cần

### 4. Check Status

```bash
/watcher status
```

### 5. Force Analysis (Optional)

```bash
/watcher think
```

### 6. Stop Watching

```bash
/watcher stop
```

## Commands

| Command | Description |
|---------|-------------|
| `/watcher init` | Khởi tạo hệ thống watcher |
| `/watcher start "goal"` | Bắt đầu watching với goal |
| `/watcher stop` | Dừng watching |
| `/watcher status` | Xem trạng thái hiện tại |
| `/watcher think` | Force Thinker analysis |
| `/watcher reset` | Reset toàn bộ data |

## Trigger Conditions

Thinker được invoke khi một trong các điều kiện sau xảy ra:

### 1. Tool Count Trigger
- **Threshold**: 15 tool calls
- **Purpose**: Periodic review để đảm bảo Worker on-track

### 2. Pattern Detection Triggers

| Pattern | Condition | Urgency |
|---------|-----------|---------|
| `repeated_errors` | Same error 3+ times | HIGH |
| `stuck_loop` | Same file edited 5+ times | HIGH |
| `long_running` | No progress 20+ tool calls | MEDIUM |

### 3. Time-based Trigger
- **Interval**: 10 minutes
- **Purpose**: Health check định kỳ

### Cooldown
- Minimum 60 giây giữa các lần think
- Sau intervention: 120 giây cooldown

## Decision Framework

Thinker sử dụng 4 loại quyết định:

| Decision | When to Use | Action |
|----------|-------------|--------|
| **CONTINUE** | Worker đang on-track | Không can thiệp |
| **REDIRECT** | Cần thay đổi approach | Gửi hướng đi mới |
| **HELP** | Worker bị stuck | Gửi gợi ý cụ thể |
| **STOP** | Vấn đề nghiêm trọng | Dừng ngay |

## Directory Structure

```
.microai/agents/claude-watcher/
├── agent.md                      # Thinker agent definition
├── README.md                     # This file
│
├── hooks/                        # Hook scripts for Worker
│   ├── pre-tool-use.sh          # Observe BEFORE tool execution
│   ├── post-tool-use.sh         # Observe AFTER tool execution
│   └── user-prompt-submit.sh    # Observe user prompts
│
├── scripts/
│   ├── run.sh                   # Main orchestration script
│   ├── observer.sh              # Process hook events
│   ├── trigger.sh               # Smart trigger logic
│   └── commander.sh             # Execute Thinker decisions
│
├── memory/
│   ├── observations.jsonl       # Tool call log (append-only)
│   ├── state.yaml               # Current state tracking
│   ├── decisions.md             # Thinker decisions history
│   ├── metrics.yaml             # Performance metrics
│   └── archive/                 # Archived commands
│
├── config/
│   └── triggers.yaml            # Trigger configuration
│
└── templates/
    ├── thinker-prompt.md        # Template for Thinker analysis
    └── intervention.md          # Template for Worker commands
```

## Configuration

Edit `config/triggers.yaml` để customize:

```yaml
triggers:
  tool_count:
    threshold: 15        # Adjust periodic review frequency

  patterns:
    rules:
      - name: repeated_errors
        condition: "3+ times"  # Adjust error tolerance

  time_based:
    interval_minutes: 10  # Adjust health check frequency

  cooldown:
    min_interval_seconds: 60
    after_intervention_seconds: 120
```

## Memory Files

### observations.jsonl
```json
{"ts":"2026-01-04T10:00:00Z","type":"pre","tool":"Edit","params":{...}}
{"ts":"2026-01-04T10:00:01Z","type":"post","tool":"Edit","output":"...","exit":0}
```

### state.yaml
```yaml
goal: "Build REST API"
started_at: "2026-01-04T10:00:00Z"
last_think_timestamp: "2026-01-04T10:05:00Z"
last_think_at_count: 15
total_interventions: 1
status: active
```

### decisions.md
```markdown
## Decision - 2026-01-04T10:05:00Z

**Trigger**: tool_count:15

### Analysis
Worker đang tạo API endpoints...

### Decision: CONTINUE
Worker đang on-track, không cần can thiệp.
```

## Hooks Integration

Để enable hooks, thêm vào `.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "*",
        "hooks": [{
          "type": "command",
          "command": ".microai/agents/claude-watcher/hooks/pre-tool-use.sh"
        }]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "*",
        "hooks": [{
          "type": "command",
          "command": ".microai/agents/claude-watcher/hooks/post-tool-use.sh"
        }]
      }
    ]
  }
}
```

## Troubleshooting

### Watcher không hoạt động
1. Check status: `/watcher status`
2. Verify hooks được enable trong settings
3. Check log files trong `memory/`

### Thinker không trigger
1. Check trigger thresholds trong `config/triggers.yaml`
2. Verify cooldown period đã qua
3. Check observations count: `wc -l memory/observations.jsonl`

### Commands không execute
1. Check `claude` CLI available
2. Check `memory/next-command.md` content
3. Review `memory/decisions.md` cho errors

## Safety & Limits

### Built-in Safeguards
- **Cooldown periods**: Tránh over-thinking
- **Loop prevention**: Skip observations về watcher chính nó
- **Error handling**: Hooks luôn exit 0, không block Worker

### Rate Limiting
- Max 1 think per minute
- Post-intervention cooldown: 2 minutes
- Observation log pruning: Keep last 1000 entries

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-01-04 | Initial release |

---

*Created by Deep Thinking Team - Session DTT-2026-01-04-AGENT-001*
