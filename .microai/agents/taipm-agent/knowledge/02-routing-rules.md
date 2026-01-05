# Routing Rules - Intent to Agent Mapping

> Chi tiết logic routing từ user intent đến agent/team phù hợp.
> Taipm Agent sử dụng file này để quyết định delegate.

---

## Routing Algorithm

```
INPUT → TOKENIZE → MATCH PATTERNS → SCORE → SELECT → ROUTE
```

### Step 1: Tokenize Input

Extract key signals:
- **Action words**: tạo, review, phân tích, giải, viết, đăng, test...
- **Domain words**: Go, Python, code, video, audio, TOEIC, security...
- **Object words**: URL, file, function, project, agent, skill...
- **Modifiers**: sâu, nhanh, chi tiết, đơn giản...

### Step 2: Pattern Matching

Match against routing rules below. Higher score = better match.

---

## Routing Rules by Domain

### 1. Content Creation

```yaml
audiobook:
  patterns:
    - "audiobook" | "audio book" | "sách nói"
    - "tạo audio từ"
    - URL + ("đọc" | "nghe")
  route: audiobook-production-team
  confidence: high
  example: "Tạo audiobook từ URL này"

youtube:
  patterns:
    - "video" | "youtube" | "shorts"
    - "tạo video từ"
    - URL + "video"
  route: youtube-team
  confidence: high
  example: "Tạo video YouTube từ bài viết"

toeic:
  patterns:
    - "toeic" | "vocabulary" | "từ vựng tiếng anh"
    - "bài học" + "tiếng anh"
  route: toeic-content-team
  confidence: high
  example: "Tạo bài học TOEIC cho từ negotiate"

facebook:
  patterns:
    - "facebook" | "fb" | "đăng bài"
    - "post" + "facebook"
  route: fb-post-agent
  confidence: high
  example: "Đăng bài về chủ đề này lên Facebook"

book:
  patterns:
    - "sách" | "book" | "viết sách"
    - "chapter" | "chương"
  route: book-writer-team
  confidence: medium
  example: "Viết chapter về topic này"
```

### 2. Development

```yaml
go_implement:
  patterns:
    - ("go" | "golang") + ("implement" | "code" | "viết")
    - "tạo function go"
    - file.go + "implement"
  route: go-dev-agent
  confidence: high
  example: "Implement handler này bằng Go"

go_review:
  patterns:
    - ("go" | "golang") + "review"
    - "review code" + file.go
    - "đánh giá code go"
  route: go-review-linus-agent
  confidence: high
  example: "Review PR Go này theo phong cách Linus"

go_refactor:
  patterns:
    - ("go" | "golang") + "refactor"
    - "tái cấu trúc" + file.go
    - "cải thiện code go"
  route: go-refactor-agent
  confidence: high
  example: "Refactor function này với risk-based batching"

go_full:
  patterns:
    - "dự án go" | "go project"
    - "build go app"
  route: go-team
  confidence: high
  example: "Giúp tôi build một CLI tool bằng Go"

python:
  patterns:
    - "python" + ("implement" | "code" | "viết")
    - file.py
    - "script python"
  route: python-team
  confidence: high
  example: "Viết script Python cho task này"

algorithm:
  patterns:
    - "algorithm" | "thuật toán"
    - "thiết kế" + ("function" | "logic")
    - "pseudocode"
  route: algo-function-agent
  confidence: medium
  example: "Thiết kế algorithm cho bài toán sorting này"
```

### 3. Analysis & Thinking

```yaml
deep_thinking:
  patterns:
    - "phân tích sâu" | "deep analysis"
    - "strategic" | "chiến lược"
    - "quyết định quan trọng"
    - "nhiều góc nhìn"
  route: deep-thinking-team
  confidence: high
  example: "Phân tích sâu về kiến trúc microservices vs monolith"

deep_question:
  patterns:
    - "đặt câu hỏi" | "question"
    - "blind spots" | "assumptions"
    - "challenge thinking"
    - "socratic"
  route: deep-question-agent
  confidence: high
  example: "Giúp tôi đặt câu hỏi về quyết định này"

root_cause:
  patterns:
    - "root cause" | "nguyên nhân gốc"
    - "5 why" | "tại sao"
    - "vấn đề" + "tìm nguyên nhân"
  route: root-cause-agent
  confidence: high
  example: "Tìm root cause của bug này"

research:
  patterns:
    - "research" | "nghiên cứu"
    - "paper" | "arxiv" | "bài báo"
    - "tìm hiểu sâu về"
  route: deep-research
  confidence: medium
  example: "Nghiên cứu về RAG techniques mới nhất"

math:
  patterns:
    - "math" | "toán"
    - "giải bài" | "solve"
    - "IMO" | "olympiad"
    - số học, đại số, hình học
  route: math-team
  confidence: high
  example: "Giải bài toán IMO này"
```

### 4. Planning & Management

```yaml
project_planning:
  patterns:
    - "dự án" + ("lập kế hoạch" | "plan")
    - "project" + "planning"
    - "roadmap"
  route: project-team
  confidence: medium
  example: "Lập kế hoạch cho dự án mới"

one_page:
  patterns:
    - "one page" | "oppm"
    - "tóm tắt dự án"
    - "project overview"
  route: one-page-agent
  confidence: high
  example: "Tạo one-page summary cho project"

daily:
  patterns:
    - "daily" | "hàng ngày"
    - "morning" | "buổi sáng"
    - "task queue" | "việc cần làm"
    - "báo cáo ngày"
  route: daily-agent
  confidence: high
  example: "Chạy daily briefing"

kanban:
  patterns:
    - "kanban" | "board"
    - "task" + ("move" | "status")
    - "backlog"
  route: kanban-agent
  confidence: medium
  example: "Update kanban board"
```

### 5. Meta & Tools

```yaml
create_agent:
  patterns:
    - "tạo agent" | "create agent"
    - "agent mới"
    - "clone agent"
  route: father-agent
  confidence: high
  example: "Tạo agent mới cho domain X"

evaluate_agent:
  patterns:
    - "đánh giá agent" | "evaluate agent"
    - "test agent" | "benchmark"
    - "agent intelligence"
  route: agent-evaluator
  confidence: high
  example: "Đánh giá agent này"

create_skill:
  patterns:
    - "tạo skill" | "create skill"
    - "skill mới"
  route: skill-creator-agent
  confidence: high
  example: "Tạo skill cho task X"

npm:
  patterns:
    - "npm" | "package"
    - "publish" | "install"
    - "dependencies"
  route: npm-agent
  confidence: medium
  example: "Publish package lên npm"

github:
  patterns:
    - "github" | "git"
    - "PR" | "pull request"
    - "issue" | "branch"
  route: github-agent
  confidence: medium
  example: "Tạo PR cho changes này"
```

### 6. Security

```yaml
pentest:
  patterns:
    - "pentest" | "penetration test"
    - "security test" | "hack"
    - "vulnerability" | "exploit"
  route: white-hacker-agent
  confidence: high
  example: "Pentest API này"

security_review:
  patterns:
    - "security review" | "bảo mật"
    - "threat model"
    - "security audit"
  route: dev-security
  confidence: medium
  example: "Review security cho architecture này"
```

### 7. Collaboration Sessions

```yaml
dev_qa:
  patterns:
    - "test plan" | "QA"
    - "bug report"
    - "test cases"
  route: dev-qa
  confidence: medium
  example: "Tạo test plan cho feature này"

dev_architect:
  patterns:
    - "ADR" | "architecture decision"
    - "system design"
    - "technical design"
  route: dev-architect
  confidence: medium
  example: "Tạo ADR cho quyết định này"

pm_dev:
  patterns:
    - "requirements" | "yêu cầu"
    - "estimation" | "ước lượng"
    - "sprint planning"
  route: pm-dev
  confidence: medium
  example: "Estimate effort cho feature này"

dev_user:
  patterns:
    - "user story" | "acceptance criteria"
    - "user feedback"
    - "user interview"
  route: dev-user
  confidence: medium
  example: "Tạo user story từ feedback này"
```

---

## Ambiguity Resolution

Khi nhiều patterns match với score tương đương:

### Priority Rules

1. **Explicit domain mention wins**: "Go review" → go-review-linus-agent (not deep-thinking-team)
2. **Specificity wins**: "TOEIC video" → toeic-content-team (not youtube-team)
3. **Action verb priority**:
   - "tạo/create" → creation agents
   - "review/đánh giá" → review agents
   - "phân tích/analyze" → thinking agents
4. **File extension hints**:
   - `.go` → go-* agents
   - `.py` → python-team
   - URL → content teams

### Clarification Triggers

Ask user when:
- Score difference < 20%
- Multiple viable options
- Missing critical context

```markdown
Tôi thấy request có thể được xử lý bởi:
1. **{agent_1}** - {reason}
2. **{agent_2}** - {reason}

Bạn muốn đi theo hướng nào?
```

---

## Direct Handling (No Delegation)

Handle directly khi:
- Simple questions về hệ thống
- Status queries
- Navigation/listing requests
- Quick lookups
- Greeting/chitchat

```yaml
direct_handle:
  patterns:
    - "list agents" | "có những agent nào"
    - "status" | "trạng thái"
    - "help" | "hướng dẫn"
    - "hello" | "chào"
    - simple math/conversions
```

---

## Scoring Formula

```
SCORE = base_match + domain_bonus + action_bonus + context_bonus

base_match: 50 (pattern matches)
domain_bonus: +20 (explicit domain mention)
action_bonus: +15 (clear action verb)
context_bonus: +15 (file extension, URL, etc.)

THRESHOLD: 70 for confident routing
```

---

*Routing rules maintained by Taipm Agent. Last updated: 2026-01-04*
