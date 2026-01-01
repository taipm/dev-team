# Deep Thinking Team - Slash Commands

## Overview

Deep Thinking Team là super-team của 20+ legendary minds, được orchestrate bởi Maestro để giải quyết mọi vấn đề phức tạp.

## Main Command

### `/microai:deep-thinking [problem] [mode]`

Triệu tập Maestro và team để giải quyết vấn đề.

**Modes:**
- `quick` - 2-3 agents, 5-15 min
- `standard` (default) - 4-6 agents, 30-60 min
- `deep` / `comprehensive` - All relevant agents, 2-4 hours

**Examples:**
```
/microai:deep-thinking Startup có 80% churn rate
/microai:deep-thinking quick: Redis vs Memcached?
/microai:deep-thinking deep: Nên scale lên microservices không?
```

---

## Individual Agent Commands

Gọi riêng từng agent khi chỉ cần một góc nhìn cụ thể:

### Thinkers (7 Titans)

| Command | Agent | Specialty |
|---------|-------|-----------|
| `/microai:deep-thinking:socrates` | 🔮 Socrates | Deep Questions, Assumptions |
| `/microai:deep-thinking:musk` | ⚡ Musk | First Principles, 10x Thinking |
| `/microai:deep-thinking:munger` | 🎭 Munger | Mental Models, Inversion |
| `/microai:deep-thinking:polya` | 📐 Polya | Systematic Problem-Solving |
| `/microai:deep-thinking:davinci` | 🎨 Da Vinci | Synthesis, Connections |
| `/microai:deep-thinking:feynman` | 🔬 Feynman | Simplification |

### Builders (Legends)

| Command | Agent | Specialty |
|---------|-------|-----------|
| `/microai:deep-thinking:linus` | 🐧 Linus | Systems, Code Quality |
| `/microai:deep-thinking:dijkstra` | 🔷 Dijkstra | Algorithms, Correctness |

### Executors

| Command | Agent | Specialty |
|---------|-------|-----------|
| `/microai:deep-thinking:bezos` | 📦 Bezos | Execution, Customer Focus |
| `/microai:deep-thinking:jobs` | 🍎 Jobs | Product, Vision |

---

## Observer Commands (During Session)

| Command | Effect |
|---------|--------|
| `*status` | Xem phase hiện tại |
| `*skip` | Nhảy đến phase tiếp theo |
| `*focus:{topic}` | Focus vào khía cạnh cụ thể |
| `*add:{agent}` | Thêm agent vào session |
| `*auto` | Tự động chạy tiếp |
| `*manual` | Chờ user mỗi turn |
| `*exit` | Kết thúc, save output |

---

## 5-Phase Protocol

Khi dùng full team, Maestro sẽ orchestrate 5 phases:

```
Phase 1: UNDERSTAND (Socrates + Aristotle)
    ↓
Phase 2: DECONSTRUCT (Musk + Feynman)
    ↓
Phase 3: CHALLENGE (Munger + Grove)
    ↓
Phase 4: SOLVE (Polya + Builders)
    ↓
Phase 5: SYNTHESIZE (Da Vinci + All)
```

---

## Use Case Examples

### Strategic Decision
```
/microai:deep-thinking Nên raise Series A hay bootstrap tiếp?
```
→ Maestro calls: Munger (risk), Bezos (execution), Jobs (vision)

### Technical Architecture
```
/microai:deep-thinking Monolith vs Microservices cho startup stage?
```
→ Maestro calls: Linus (systems), Dijkstra (correctness), Musk (first principles)

### Problem Understanding
```
/microai:deep-thinking:socrates Tại sao user không dùng feature mới?
```
→ Socrates only: Deep questioning session

### Code Review
```
/microai:deep-thinking:linus Review caching layer này
```
→ Linus only: Systems-level code review

---

## Output Location

All session logs are saved to:
`.microai/agents/microai/teams/deep-thinking-team/logs/`
