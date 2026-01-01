# Agent vs Skill

> Hướng dẫn chi tiết để chọn đúng approach: khi nào dùng Agent, khi nào dùng Skill.

---

## Tổng quan

```
┌─────────────────────────────────────────────────────────────────┐
│                    AGENT vs SKILL                                │
├─────────────────────────────────────────────────────────────────┤
│  AGENT = Persona + Knowledge + Workflow                          │
│  SKILL = Focused Task + Instructions                             │
└─────────────────────────────────────────────────────────────────┘
```

---

## So sánh chi tiết

| Khía cạnh | **Agent** | **Skill** |
|-----------|-----------|-----------|
| **Bản chất** | Một "nhân vật" với chuyên môn | Một "kỹ năng" cụ thể |
| **Độ phức tạp** | Cao - multi-step workflows | Thấp/Trung - single task |
| **Persona** | Có (communication style, principles) | Không |
| **Knowledge base** | Có thể có nhiều files | Thường ít hoặc không có |
| **Memory** | Có thể có (context, decisions) | Không |
| **Kích hoạt** | `/agent-name` | `/skill-name` hoặc tự động |
| **Thời gian session** | Dài - giữ persona suốt session | Ngắn - chạy xong là xong |
| **Reusability** | Theo domain | Theo task |
| **Cấu trúc** | `agent.md` + `knowledge/` | `SKILL.md` + optional files |

---

## Khi nào dùng AGENT?

```
✅ Dùng AGENT khi:

1. CẦN PERSONA RÕ RÀNG
   → "Tôi cần một expert về Go với style như Linus Torvalds"
   → "Tôi cần một QA engineer để review code"

2. WORKFLOW PHỨC TẠP, NHIỀU BƯỚC
   → Tạo agent mới (Discovery → Structure → Generate → Verify)
   → Review code (Analyze → Score → Report → Fix)

3. CẦN KNOWLEDGE BASE
   → Patterns, anti-patterns, best practices
   → Domain-specific knowledge

4. CẦN MEMORY GIỮA SESSIONS
   → Nhớ decisions đã làm
   → Track context của project

5. INTERACTION KÉO DÀI
   → Làm việc với agent trong cả session
   → Hỏi đáp liên tục về một domain
```

### Ví dụ Agents

| Agent | Mục đích |
|-------|----------|
| `father-agent` | Tạo và quản lý agents |
| `go-dev-agent` | Go development expert |
| `deep-thinking-team` | Problem-solving với nhiều personas |
| `code-reviewer` | Review code với checklist |

---

## Khi nào dùng SKILL?

```
✅ Dùng SKILL khi:

1. TASK ĐƠN GIẢN, FOCUSED
   → "Commit code với format chuẩn"
   → "Tạo PR với template"

2. KHÔNG CẦN PERSONA
   → Chỉ cần instructions, không cần "nhân vật"
   → Output-driven, không cần style

3. TÁI SỬ DỤNG CAO
   → Dùng lặp đi lặp lại trong nhiều context
   → Không phụ thuộc domain cụ thể

4. CHẠY NHANH, XONG LÀ XONG
   → Không cần maintain state
   → One-shot execution

5. CÓ THỂ TỰ ĐỘNG TRIGGER
   → Dựa trên context/keywords
   → Claude tự biết khi nào dùng
```

### Ví dụ Skills

| Skill | Mục đích |
|-------|----------|
| `/commit` | Commit với format chuẩn |
| `/github` | GitHub operations |
| `/npm` | NPM package management |
| `/pdf` | Làm việc với PDF files |

---

## Decision Tree

```
                    Bạn cần gì?
                         │
          ┌──────────────┴──────────────┐
          │                             │
    Persona/Expert?                Task cụ thể?
          │                             │
          ▼                             ▼
   ┌─────────────┐              ┌─────────────┐
   │ Nhiều bước? │              │ One-shot?   │
   └──────┬──────┘              └──────┬──────┘
          │                            │
     ┌────┴────┐                  ┌────┴────┐
     ▼         ▼                  ▼         ▼
   Yes       No                 Yes        No
     │         │                  │         │
     ▼         ▼                  ▼         ▼
  AGENT    AGENT              SKILL     AGENT
           (simple)                    (complex)
```

### Flowchart chi tiết

```
START
  │
  ▼
┌─────────────────────────────────┐
│ Cần persona/communication style? │
└────────────────┬────────────────┘
                 │
        ┌────────┴────────┐
        │ YES             │ NO
        ▼                 ▼
┌───────────────┐  ┌───────────────┐
│ Workflow phức │  │ Task đơn giản │
│ tạp nhiều     │  │ one-shot?     │
│ bước?         │  └───────┬───────┘
└───────┬───────┘          │
        │           ┌──────┴──────┐
   ┌────┴────┐      │ YES         │ NO
   │YES  │NO │      ▼             ▼
   ▼     ▼   │   ┌──────┐    ┌──────┐
┌──────┐┌────┴─┐ │SKILL │    │AGENT │
│AGENT ││AGENT │ │      │    │      │
│(full)││simple│ └──────┘    └──────┘
└──────┘└──────┘
```

---

## Ví dụ thực tế

| Yêu cầu | Chọn | Lý do |
|---------|------|-------|
| "Review code như senior dev" | **Agent** | Cần persona, multi-step analysis |
| "Commit changes" | **Skill** | Task đơn giản, no persona |
| "Tạo agent mới cho testing" | **Agent** | Workflow phức tạp, cần knowledge |
| "Convert file sang PDF" | **Skill** | One-shot, focused task |
| "Debug Go code với best practices" | **Agent** | Cần knowledge base, persona |
| "Search trong GitHub" | **Skill** | Utility task, reusable |
| "Giải thích physics concept" | **Agent** | Cần teaching persona (Feynman) |
| "Format commit message" | **Skill** | Rules-based, no persona |

---

## Kết hợp Agent + Skill

Agents có thể gọi Skills trong workflow:

```
┌─────────────────────────────────┐
│  father-agent                   │
│  ├── *create workflow           │
│  │   └── gọi /commit khi xong   │
│  └── *review workflow           │
│       └── gọi /github tạo issue │
└─────────────────────────────────┘
```

### Cách reference skill trong agent

```yaml
# Trong agent.md
---
name: backend-dev
skills: api-designer, db-design
---

Khi thiết kế API, load skill api-designer.
Khi thiết kế database, load skill db-design.
```

### Cách gọi skill từ agent workflow

```markdown
## Workflow: Create Feature

1. Design API
   → Load skill: api-designer

2. Design Database
   → Load skill: db-design

3. Implement Code
   → Agent handles

4. Commit
   → Call skill: /commit
```

---

## Tổng kết

### Dùng AGENT khi

- Cần một "expert" với personality
- Workflow nhiều bước phức tạp
- Cần nhớ context giữa sessions
- Làm việc lâu dài trong một domain

### Dùng SKILL khi

- Task đơn giản, focused
- Không cần persona
- Tái sử dụng cao
- One-shot execution

### Kết hợp khi

- Agent cần specialized knowledge
- Workflow có các bước standard
- Muốn compose capabilities

---

## Tiếp theo

- [Cấu trúc Skill chi tiết](./03-skill-anatomy.md)
- [Tạo Skill step-by-step](./04-creating-skills.md)
