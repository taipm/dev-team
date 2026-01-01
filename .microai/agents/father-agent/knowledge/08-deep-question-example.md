# Deep Question Agent - Reference Example

> Ví dụ về một agent hoàn chỉnh với 7 thinking frameworks, smart topic detection, và framework transition.

---

## Overview

**Deep Question Agent (Socrates)** là một agent chuyên đặt câu hỏi cốt tử, được thiết kế với các best practices:

- 7 phương pháp tư duy tích hợp
- Smart topic detection với weighted scoring
- Framework transition suggestions
- Progressive disclosure UX
- Full memory system

**Location:** `templates/.microai/agents/deep-question-agent/`

---

## Key Design Patterns

### 1. Weighted Topic Detection

Thay vì simple keyword matching:

```yaml
# ❌ Old approach - simple keywords
indicators:
  - bug
  - error
  - issue

# ✅ New approach - weighted scoring
indicators:
  - pattern: "bug|error|exception|crash"
    weight: 10   # Strong signal
  - pattern: "issue|problem|vấn đề"
    weight: 7    # Medium signal
  - pattern: "wrong|sai"
    weight: 5    # Weak signal
```

**Benefits:**
- Handle multi-category inputs
- Có thể tune weights
- Supports disambiguation

### 2. Disambiguation Flow

Khi input match nhiều categories:

```
Score Analysis
     │
     ├── Clear winner (>15) → Use that framework
     ├── Ambiguous (multiple >10) → Ask user
     └── Unclear (all <10) → Default to 6W2H
```

**Example prompt:**
```
Tôi thấy vấn đề có thể approach từ nhiều góc:
1. 🔧 Technical Analysis (6W2H)
2. 🐛 Root Cause (5 Whys)
3. ⚖️ Decision Support (Pre-mortem)

Bạn muốn focus góc nào?
```

### 3. Framework Transition Protocol

Monitor sau mỗi 3 turns:

```
After Turn 3, 6, 9...
     │
     ├── Stuck Detection → Suggest switch
     ├── Opportunity Detection → Suggest relevant framework
     └── Natural Progression → Guide to next phase
```

**Example:**
```
💡 Đã tìm được root cause. Muốn thử Pre-mortem
để explore "điều gì có thể go wrong"?
```

### 4. Progressive Disclosure

Greeting đơn giản, details on-demand:

```
# Simplified greeting
🔮 Tôi giúp bạn đặt câu hỏi đúng.
- 🔍 Phân tích code
- 🐛 Tìm root cause
- ⚖️ Đánh giá quyết định

💡 Gõ *help để xem commands | *frameworks để xem 7 phương pháp
```

### 5. Layered Commands

```
Core:     *auto, *manual, *skip, *exit
Focus:    *focus:<topic>, *summary
Framework: *framework:<name>, *switch:<name>, *stay
Help:     *help, *frameworks
```

---

## Structure Reference

```
deep-question-agent/
├── agent.md                    # 500 lines - Full definition
├── README.md                   # Documentation
├── knowledge/
│   ├── 01-thinking-frameworks.md    # 450 lines - 7 frameworks
│   ├── 02-code-analysis-questions.md # 360 lines - Code questions
│   ├── 03-topic-analysis-questions.md # 360 lines - Topic questions
│   ├── 04-dialogue-patterns.md       # 600 lines - Dialogue system
│   └── knowledge-index.yaml          # 300 lines - Smart detection
└── memory/
    ├── context.md              # Session state
    ├── decisions.md            # Key insights
    └── learnings.md            # Patterns
```

---

## Reusable Components

### Topic Detection V2
Copy từ `knowledge-index.yaml` → `topic_detection_v2` section

### Framework Selection Guide
Copy từ `agent.md` → `Smart Topic Detection` section

### Dialogue Patterns
Copy từ `04-dialogue-patterns.md` → Session flow, turn format

### Memory System
Copy từ `memory/` folder → Standard structure

---

## Usage

### Để tạo agent tương tự:

```bash
# 1. Copy template
cp -r templates/.microai/agents/deep-question-agent/ .microai/agents/my-agent/

# 2. Modify agent.md
#    - Change name, description
#    - Customize frameworks/methods
#    - Update commands

# 3. Modify knowledge files
#    - Replace questions with domain-specific ones
#    - Update knowledge-index.yaml patterns

# 4. Create command entry
#    - Add .claude/commands/microai/my-agent.md
```

### Để học từ agent này:

1. **Weighted scoring pattern** → Áp dụng cho bất kỳ detection logic
2. **Disambiguation flow** → Khi cần user clarification
3. **Transition suggestions** → Khi agent có multiple modes/tools
4. **Progressive disclosure** → Cho complex agents

---

## Lessons Learned

### From Self-Analysis Session (2025-12-30)

| Issue Found | Solution Applied |
|-------------|------------------|
| Simple keyword matching fails | Weighted scoring |
| No multi-match handling | Disambiguation prompt |
| Fixed framework throughout | Transition suggestions |
| Overwhelming greeting | Progressive disclosure |
| User doesn't know frameworks | *help, *frameworks commands |

### Principles Validated

1. **Agent should detect, not assume** - Don't hardcode category mappings
2. **Give user control** - Commands to override auto-decisions
3. **Suggest, don't force** - Transition suggestions, not auto-switch
4. **Start simple, reveal depth** - Progressive disclosure pattern

---

*This agent demonstrates best practices for complex, multi-framework agents.*
*Use as reference when building similar agents.*
