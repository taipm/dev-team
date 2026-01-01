# Deep Question Agent (Socrates)

> "The unexamined code is not worth shipping. The unexamined decision is not worth making."

Agent chuyên đặt câu hỏi cốt tử, trang bị 7 phương pháp tư duy hàng đầu để tìm blind spots, hidden assumptions, và root causes.

---

## Quick Start

```bash
# Invoke agent
/microai:deep-question

# Hoặc với topic cụ thể
/microai:deep-question "Phân tích architecture của microservice này"
```

---

## Features

### 7 Phương pháp Tư duy

| Framework | Mục đích | Command |
|-----------|----------|---------|
| **Socratic Questioning** | Đào sâu 5 lớp | `*framework:socratic` |
| **First Principles** | Phá vỡ assumptions | `*framework:firstprinciples` |
| **5 Whys** | Tìm root cause | `*framework:5whys` |
| **6W2H** | Coverage toàn diện | `*framework:6w2h` |
| **Pre-mortem** | Dự đoán failure | `*framework:premortem` |
| **Devil's Advocate** | Challenge thinking | `*framework:devil` |
| **Feynman Technique** | Test understanding | `*framework:feynman` |

### Smart Features

- **Auto Topic Detection:** Weighted scoring để chọn framework phù hợp
- **Disambiguation:** Hỏi user khi input match nhiều categories
- **Framework Transition:** Suggest switch framework sau 3 turns
- **Insight Tracking:** Ghi nhận insights với priority levels

### Commands

```
*help          - Xem tất cả commands
*frameworks    - Xem 7 frameworks với mô tả
*auto/*manual  - Chế độ tự động/thủ công
*skip          - Nhảy đến tổng hợp
*summary       - Xem insights hiện tại
*switch:<name> - Đổi framework
*exit          - Kết thúc session
```

---

## Use Cases

### 1. Code/Architecture Analysis
```
Input: "Phân tích architecture của codebase này"
Agent: Dùng 6W2H → First Principles
Output: Blind spots, assumptions, recommendations
```

### 2. Problem/Bug Analysis
```
Input: "API response chậm, không biết vì sao"
Agent: Dùng 5 Whys → Socratic
Output: Root cause, evidence chain
```

### 3. Decision Support
```
Input: "Nên chọn MongoDB hay PostgreSQL?"
Agent: Dùng Pre-mortem → Devil's Advocate
Output: Risks, trade-offs, recommendations
```

### 4. Learning/Understanding
```
Input: "Giải thích microservices cho tôi"
Agent: Dùng Feynman → Socratic
Output: Clear explanation, knowledge gaps identified
```

---

## Directory Structure

```
deep-question-agent/
├── agent.md                    # Agent definition
├── README.md                   # This file
├── knowledge/
│   ├── 01-thinking-frameworks.md    # 7 frameworks chi tiết
│   ├── 02-code-analysis-questions.md # Questions cho code
│   ├── 03-topic-analysis-questions.md # Questions cho topics
│   ├── 04-dialogue-patterns.md       # Dialogue patterns
│   └── knowledge-index.yaml          # Auto-load index
├── memory/
│   ├── context.md              # Session state
│   ├── decisions.md            # Key insights
│   └── learnings.md            # Patterns learned
└── templates/
    └── session-output.md       # Output template
```

---

## Output

Session logs được save tại: `docs/deep-question-sessions/`

Format: `{YYYY-MM-DD}-{topic-slug}.md`

Includes:
- Session metadata
- Key insights (critical/important/interesting)
- Assumptions analysis
- Open questions
- Recommended next steps

---

## Configuration

### Model
Default: `opus` (for deep thinking)

Có thể đổi sang `sonnet` trong agent.md nếu cần faster responses.

### Language
Default: Vietnamese (`vi`)

Agent giao tiếp bằng tiếng Việt với technical terms giữ nguyên tiếng Anh.

---

## Integration

### Với Dev-User Team
Agent có thể tích hợp với dev-user dialogue system:
- User đưa topic
- Socrates đặt câu hỏi
- Turn-based dialogue
- Synthesis output

### Với Mining Team
Agent là part của mining-team workflow:
1. Deep Question (Socrates) - tìm assumptions
2. Reverse Thinking (Contrarian) - challenge
3. Codebase Explorer (Sherlock) - evidence
4. Production Readiness - quality gate

---

## Changelog

### v1.1.0 (2025-12-30)
- Added: Priority scoring for topic detection
- Added: Disambiguation flow for multi-category inputs
- Added: Framework transition suggestions
- Added: `*help`, `*frameworks` commands
- Improved: Simplified greeting with progressive disclosure

### v1.0.0 (2025-12-30)
- Initial release
- 7 thinking frameworks
- Code & topic analysis question libraries
- Memory system
- Session logging

---

## Credits

Inspired by:
- Socrates (Socratic Method)
- Aristotle (First Principles)
- Taiichi Ohno (5 Whys - Toyota)
- Richard Feynman (Feynman Technique)
- Gary Klein (Pre-mortem)
- Charlie Munger (Inversion/Devil's Advocate)

---

## License

Part of MicroAI Agent Ecosystem.
