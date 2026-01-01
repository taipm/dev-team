# User Stories

## @microai.club/dev-team

**Version:** 1.0.0-alpha.2
**Ngày cập nhật:** 2025-12-31
**Tham khảo:** [PRD](./prd.md)

---

## Mục lục

- [Personas](#personas)
- [Epic 1: Cài đặt & Thiết lập](#epic-1-cài-đặt--thiết-lập)
- [Epic 2: Sử dụng Agent](#epic-2-sử-dụng-agent)
- [Epic 3: Phối hợp Team](#epic-3-phối-hợp-team)
- [Epic 4: Knowledge & Memory](#epic-4-knowledge--memory)
- [Epic 5: Tùy chỉnh](#epic-5-tùy-chỉnh)
- [Epic 6: Platform Portability](#epic-6-platform-portability)
- [Tổng hợp theo Priority](#tổng-hợp-theo-priority)

---

## Personas

### Persona 1: Solo Developer (Minh)

```yaml
id: solo_dev
name: "Minh"
role: "Full-stack Developer"
context: |
  Developer làm việc một mình hoặc trong small team,
  cần AI support cho nhiều tasks khác nhau.
goals:
  - Code review khi không có peer
  - Debugging assistance
  - Architecture decision support
  - Testing guidance
pain_points:
  - Không có ai để review code
  - Phải context switch giữa nhiều domains
  - Thiếu feedback on technical decisions
```

### Persona 2: Team Lead (Hương)

```yaml
id: team_lead
name: "Hương"
role: "Engineering Manager"
context: |
  Quản lý team 5-10 developers, cần standardize
  AI workflows và đảm bảo quality across team.
goals:
  - Consistent code quality standards
  - Standardized AI workflows
  - Onboarding tools for new members
  - Architecture governance
pain_points:
  - Mỗi developer dùng AI khác nhau
  - Inconsistent code review quality
  - Khó onboard new members vào team practices
```

### Persona 3: Technical Architect (Long)

```yaml
id: architect
name: "Long"
role: "Solutions Architect"
context: |
  Architect đánh giá và thiết kế hệ thống,
  cần multiple perspectives cho complex decisions.
goals:
  - Multi-perspective analysis
  - Risk assessment
  - Trade-off evaluation
  - Documentation decisions
pain_points:
  - Solo thinking leads to blind spots
  - Hard to challenge own assumptions
  - Decisions lack documented rationale
```

### Persona 4: Platform Developer (Thành)

```yaml
id: platform_dev
name: "Thành"
role: "Platform Engineer"
context: |
  Developer muốn port dev-team sang platforms khác
  hoặc customize framework deeply.
goals:
  - Clear specification để implement
  - Reference implementations
  - Compliance testing tools
  - Extension points
pain_points:
  - Undocumented behaviors
  - Missing edge cases in spec
  - No verification tools
```

---

## Epic 1: Cài đặt & Thiết lập

### US-1.1: Cài đặt Dev-team Package

**Persona**: Solo Developer, Team Lead
**Priority**: P0 (Critical)

#### User Story

```
Là một DEVELOPER,
Tôi muốn CÀI ĐẶT dev-team package vào project của tôi,
Để TÔI CÓ THỂ sử dụng các AI agents chuyên biệt.
```

#### Acceptance Criteria

**AC-1.1.1**: Cài đặt qua NPM
```gherkin
Given tôi có Node.js >= 18 và npm installed
When tôi chạy "npm install -g @microai.club/dev-team"
Then package được cài đặt thành công
And "dev-team" command available trong terminal
```

**AC-1.1.2**: Cài đặt vào project
```gherkin
Given tôi đang ở trong project directory
When tôi chạy "dev-team install"
Then thư mục .microai/ được tạo với agents và settings
And thư mục .claude/ được tạo với commands và skills
And không có lỗi nào xuất hiện
```

**AC-1.1.3**: Interactive mode
```gherkin
Given tôi chạy "dev-team install" lần đầu
When installer hỏi về configuration options
Then tôi có thể chọn các options phù hợp
And configuration được lưu vào settings files
```

#### Notes
- Dependencies: Node.js >= 18, npm
- Related: US-1.2 (Verify), US-1.4 (Update)

---

### US-1.2: Xác nhận Cài đặt Thành công

**Persona**: Solo Developer, Team Lead
**Priority**: P0 (Critical)

#### User Story

```
Là một DEVELOPER,
Tôi muốn XÁC NHẬN dev-team đã cài đặt đúng,
Để TÔI BIẾT CHẮC có thể sử dụng được các agents.
```

#### Acceptance Criteria

**AC-1.2.1**: Kiểm tra cấu trúc thư mục
```gherkin
Given dev-team đã được cài đặt
When tôi kiểm tra project directory
Then tồn tại .microai/agents/ với các agent files
And tồn tại .microai/settings.json
And tồn tại .claude/commands/ với slash commands
```

**AC-1.2.2**: Verify trong Claude Code
```gherkin
Given dev-team đã cài đặt và tôi mở Claude Code
When tôi gõ "/microai"
Then autocomplete hiển thị các commands có sẵn
And tôi có thể thấy danh sách agents
```

#### Notes
- Có thể thêm "dev-team verify" command trong future version

---

### US-1.3: Cấu hình Team Settings

**Persona**: Team Lead
**Priority**: P1 (High)

#### User Story

```
Là một TEAM LEAD,
Tôi muốn CẤU HÌNH settings chung cho team,
Để TẤT CẢ MEMBERS sử dụng cùng một cấu hình agents.
```

#### Acceptance Criteria

**AC-1.3.1**: Cấu hình permissions
```gherkin
Given tôi có quyền edit .microai/settings.json
When tôi thêm allow/deny rules cho tools
Then rules được apply cho tất cả agents
And team members không thể override (trừ khi explicitly allowed)
```

**AC-1.3.2**: Cấu hình model mặc định
```gherkin
Given tôi muốn dùng opus cho complex tasks
When tôi set "model": "opus" trong settings.json
Then tất cả agents sử dụng opus by default
And vẫn có thể override per-agent nếu cần
```

**AC-1.3.3**: Version control friendly
```gherkin
Given team settings trong .microai/settings.json
When member commit và push
Then settings được share qua git
And team members nhận settings khi pull
```

#### Notes
- settings.local.json cho personal overrides (gitignored)

---

### US-1.4: Cập nhật Cài đặt Hiện có

**Persona**: Solo Developer, Team Lead
**Priority**: P1 (High)

#### User Story

```
Là một DEVELOPER,
Tôi muốn CẬP NHẬT dev-team khi có version mới,
Để TÔI CÓ THỂ sử dụng agents và features mới.
```

#### Acceptance Criteria

**AC-1.4.1**: Update package
```gherkin
Given dev-team đã cài đặt với version cũ
When tôi chạy "npm update -g @microai.club/dev-team"
Then package được update lên version mới
And CLI commands vẫn hoạt động
```

**AC-1.4.2**: Update project files (Future)
```gherkin
Given tôi có dev-team v1.0.0-alpha.1 trong project
When tôi chạy "dev-team update"
Then agents mới được thêm vào
And agents cũ được update (không overwrite customizations)
And settings được merge safely
```

#### Notes
- "dev-team update" command planned cho future version
- Hiện tại manual update hoặc reinstall

---

### US-1.5: Gỡ cài đặt

**Persona**: Solo Developer
**Priority**: P2 (Medium)

#### User Story

```
Là một DEVELOPER,
Tôi muốn GỠ BỎ dev-team khi không cần nữa,
Để PROJECT của tôi clean và không có files không cần thiết.
```

#### Acceptance Criteria

**AC-1.5.1**: Gỡ package
```gherkin
Given dev-team đã cài global
When tôi chạy "npm uninstall -g @microai.club/dev-team"
Then package được gỡ
And "dev-team" command không còn available
```

**AC-1.5.2**: Gỡ project files
```gherkin
Given dev-team đã cài trong project
When tôi xóa .microai/ và .claude/ folders
Then project trở về trạng thái ban đầu
And không có side effects
```

#### Notes
- Có thể thêm "dev-team uninstall" command cho clean removal

---

## Epic 2: Sử dụng Agent

### US-2.1: Gọi Agent với Slash Command

**Persona**: Solo Developer, Team Lead, Architect
**Priority**: P0 (Critical)

#### User Story

```
Là một DEVELOPER,
Tôi muốn GỌI AGENT bằng slash command đơn giản,
Để TÔI NHẬN ĐƯỢC hỗ trợ từ AI expert ngay lập tức.
```

#### Acceptance Criteria

**AC-2.1.1**: Basic invocation
```gherkin
Given tôi đang trong Claude Code session
When tôi gõ "/microai:deep-question"
Then Deep Question agent được activate
And agent greets và hiển thị menu options
```

**AC-2.1.2**: Invocation với arguments
```gherkin
Given tôi muốn hỏi agent một câu cụ thể
When tôi gõ "/microai:deep-question Tại sao authentication nên stateless?"
Then agent xử lý câu hỏi ngay
And trả về phân tích với 7 thinking frameworks
```

**AC-2.1.3**: Autocomplete
```gherkin
Given tôi bắt đầu gõ "/microai:"
When autocomplete hiển thị
Then tôi thấy list các commands có sẵn
And mô tả ngắn cho mỗi command
```

#### Notes
- Commands defined trong .claude/commands/
- Agent definitions trong .microai/agents/

---

### US-2.2: Code Review với Linus Agent

**Persona**: Solo Developer
**Priority**: P0 (Critical)

#### User Story

```
Là một SOLO DEVELOPER,
Tôi muốn NHẬN CODE REVIEW từ Linus agent,
Để CODE của tôi đạt chất lượng cao như có peer review.
```

#### Acceptance Criteria

**AC-2.2.1**: Review Go code
```gherkin
Given tôi có Go code cần review
When tôi gọi "/microai:go:go-review-linus"
Then Linus agent load Go knowledge base
And analyze code với brutal honesty style
And trả về feedback chi tiết với actionable items
```

**AC-2.2.2**: Review quality
```gherkin
Given Linus đã review code của tôi
When tôi đọc feedback
Then feedback bao gồm: correctness, performance, style
And có code examples cho fixes
And có severity levels (critical, major, minor)
```

**AC-2.2.3**: Learning from review
```gherkin
Given tôi đã nhận review từ Linus
When tôi hỏi "Tại sao đây là bad practice?"
Then Linus explains với Go idioms và best practices
And reference knowledge base documents
```

#### Notes
- Linus style: brutally honest, no sugar-coating
- Knowledge base: Go patterns, idioms, anti-patterns

---

### US-2.3: Debug với Feynman Agent

**Persona**: Solo Developer
**Priority**: P1 (High)

#### User Story

```
Là một DEVELOPER đang debug,
Tôi muốn FEYNMAN GIẢI THÍCH vấn đề cho tôi,
Để TÔI HIỂU root cause và cách fix.
```

#### Acceptance Criteria

**AC-2.3.1**: Explain bug
```gherkin
Given tôi có bug và error message
When tôi gọi "/microai:deep-thinking:feynman" và mô tả bug
Then Feynman giải thích bug như cho trẻ 10 tuổi
And identify root cause
And suggest fix với explanation
```

**AC-2.3.2**: Feynman technique
```gherkin
Given Feynman đang giải thích concept
When explanation có technical jargon
Then Feynman simplify further
And use analogies và examples
```

#### Notes
- Feynman agent uses Feynman Technique: simplify until clear

---

### US-2.4: Problem-Solving với Polya Agent

**Persona**: Solo Developer, Architect
**Priority**: P1 (High)

#### User Story

```
Là một DEVELOPER gặp vấn đề phức tạp,
Tôi muốn POLYA HƯỚNG DẪN tôi qua 4-step method,
Để TÔI CÓ APPROACH có hệ thống để giải quyết.
```

#### Acceptance Criteria

**AC-2.4.1**: Structured problem-solving
```gherkin
Given tôi có complex problem
When tôi gọi "/microai:deep-thinking:polya"
Then Polya guides qua 4 steps:
  1. Understand the problem
  2. Devise a plan
  3. Carry out the plan
  4. Look back
And mỗi step có questions và guidance
```

**AC-2.4.2**: Similar problems
```gherkin
Given tôi đang trong step 2 "Devise a plan"
When Polya hỏi "Có bài toán tương tự nào đã giải?"
Then tôi có thể reference past solutions
And Polya suggest approaches từ similar problems
```

#### Notes
- Based on George Polya's "How to Solve It"

---

### US-2.5: Xem Danh sách Agents

**Persona**: Solo Developer, Team Lead
**Priority**: P1 (High)

#### User Story

```
Là một DEVELOPER mới dùng dev-team,
Tôi muốn XEM DANH SÁCH agents có sẵn,
Để TÔI BIẾT có thể nhờ AI nào giúp đỡ.
```

#### Acceptance Criteria

**AC-2.5.1**: List agents
```gherkin
Given dev-team đã cài đặt
When tôi gọi "/microai" hoặc xem .claude/commands/README.md
Then tôi thấy list tất cả agents
And mỗi agent có: name, description, use case
```

**AC-2.5.2**: Agent categories
```gherkin
Given tôi muốn tìm agent phù hợp
When tôi xem agent list
Then agents được group by category:
  - Standalone agents
  - Team agents (deep-thinking, dev-qa, etc.)
And tôi có thể filter/search
```

#### Notes
- Agent list trong docs/agents/ và .claude/commands/README.md

---

## Epic 3: Phối hợp Team

### US-3.1: Bắt đầu Deep Thinking Session

**Persona**: Architect, Team Lead
**Priority**: P0 (Critical)

#### User Story

```
Là một ARCHITECT,
Tôi muốn BẮT ĐẦU Deep Thinking session với nhiều agents,
Để TÔI NHẬN ĐƯỢC multiple perspectives cho complex decisions.
```

#### Acceptance Criteria

**AC-3.1.1**: Start session
```gherkin
Given tôi có architecture decision cần làm
When tôi gọi "/microai:deep-thinking Redis vs Memcached cho caching"
Then Maestro orchestrator được activate
And classify problem type
And select relevant agents
And bắt đầu 5-Phase Protocol
```

**AC-3.1.2**: Multi-agent analysis
```gherkin
Given Deep Thinking session đang chạy
When qua 5 phases:
  Phase 1: Socrates + Aristotle (Understand)
  Phase 2: Musk + Feynman (Deconstruct)
  Phase 3: Munger + Grove (Challenge)
  Phase 4: Polya (Solve)
  Phase 5: Da Vinci (Synthesize)
Then mỗi agent contribute từ perspective của họ
And output là comprehensive analysis
```

**AC-3.1.3**: Different modes
```gherkin
Given tôi cần quick decision
When tôi gọi "/microai:deep-thinking quick Redis vs Memcached"
Then chỉ 2-3 agents được sử dụng
And analysis ngắn gọn hơn
And thời gian nhanh hơn
```

#### Notes
- Modes: quick (2-3 agents), standard (4-6), comprehensive (all)
- Output location: .microai/agents/microai/teams/deep-thinking-team/logs/

---

### US-3.2: Sử dụng Dev-QA Dialogue

**Persona**: Solo Developer, Team Lead
**Priority**: P1 (High)

#### User Story

```
Là một DEVELOPER,
Tôi muốn SIMULATE dialogue giữa Dev và QA,
Để TÔI CÓ test plan và bug reports chất lượng.
```

#### Acceptance Criteria

**AC-3.2.1**: Test plan creation
```gherkin
Given tôi có feature cần test
When tôi gọi "/microai:dev-qa-session *testplan user registration"
Then Dev agent presents feature
And QA agent asks clarifying questions
And dialogue produces test scenarios
And output: test plan với Given-When-Then format
```

**AC-3.2.2**: Bug triage
```gherkin
Given tôi có bug report
When tôi gọi "/microai:dev-qa-session *bugtriage"
Then QA agent presents bug
And Dev agent analyzes root cause
And cùng agree on severity và fix approach
```

#### Notes
- Turn-based dialogue với observer intervention
- Output templates in team folder

---

### US-3.3: Sử dụng Dev-Architect Dialogue

**Persona**: Architect, Team Lead
**Priority**: P1 (High)

#### User Story

```
Là một ARCHITECT,
Tôi muốn SIMULATE dialogue với Developer perspective,
Để TÔI CÓ architecture decisions được challenge và documented.
```

#### Acceptance Criteria

**AC-3.3.1**: Design mode
```gherkin
Given tôi có system design cần review
When tôi gọi "/microai:dev-architect-session *design"
Then Dev và Architect agents dialogue về design
And challenge assumptions
And output: ADR (Architecture Decision Record)
```

**AC-3.3.2**: Review mode
```gherkin
Given tôi có existing architecture
When tôi gọi "/microai:dev-architect-session *review"
Then Architect reviews với patterns knowledge
And Dev challenges từ implementation perspective
And identify improvements
```

#### Notes
- Output: ADR format with context, decision, consequences

---

### US-3.4: Sử dụng PM-Dev Dialogue

**Persona**: Team Lead, Solo Developer
**Priority**: P1 (High)

#### User Story

```
Là một DEVELOPER,
Tôi muốn REFINE requirements với PM perspective,
Để USER STORIES rõ ràng và có acceptance criteria tốt.
```

#### Acceptance Criteria

**AC-3.4.1**: Requirements refinement
```gherkin
Given tôi có vague requirement
When tôi gọi "/microai:pm-dev-session *requirements"
Then PM agent asks clarifying questions
And Dev agent provides technical constraints
And output: refined user story với AC
```

**AC-3.4.2**: Technical estimation
```gherkin
Given tôi có user story cần estimate
When tôi gọi "/microai:pm-dev-session *estimate"
Then Dev breaks down tasks
And PM challenges assumptions
And output: estimate với confidence level
```

#### Notes
- Output: User story format với GWT acceptance criteria

---

### US-3.5: Điều khiển Session Flow

**Persona**: Architect, Team Lead
**Priority**: P1 (High)

#### User Story

```
Là một USER đang trong team session,
Tôi muốn ĐIỀU KHIỂN flow của session,
Để TÔI CÓ THỂ guide conversation theo hướng tôi muốn.
```

#### Acceptance Criteria

**AC-3.5.1**: Observer commands
```gherkin
Given tôi đang trong Deep Thinking session
When tôi sử dụng observer commands:
  *status - xem phase hiện tại
  *skip - nhảy đến phase tiếp
  *focus:{topic} - focus vào aspect cụ thể
  *auto - tự động tiếp tục
  *manual - pause mỗi turn
Then session respond theo command
```

**AC-3.5.2**: Agent injection
```gherkin
Given tôi muốn specific agent respond
When tôi gõ "@socrates: Có assumption nào ẩn không?"
Then Socrates agent respond trực tiếp
And session flow tiếp tục
```

#### Notes
- Commands documented trong workflow.md

---

## Epic 4: Knowledge & Memory

### US-4.1: Agent Nhớ Context

**Persona**: Solo Developer, Team Lead
**Priority**: P0 (Critical)

#### User Story

```
Là một DEVELOPER làm việc qua nhiều sessions,
Tôi muốn AGENT NHỚ context từ sessions trước,
Để TÔI KHÔNG PHẢI explain lại mọi thứ.
```

#### Acceptance Criteria

**AC-4.1.1**: Context persistence
```gherkin
Given tôi đã có session với agent hôm qua
When tôi bắt đầu session mới với cùng agent
Then agent nhớ context từ session trước
And có thể reference decisions đã làm
```

**AC-4.1.2**: Context files
```gherkin
Given agent có memory system
When session kết thúc
Then context được lưu vào memory/context.md
And có thể xem history của context
```

#### Notes
- Memory files: context.md, learnings.md, decisions.md
- Auto-load khi agent activate

---

### US-4.2: Agent Học từ Sessions

**Persona**: Solo Developer, Team Lead
**Priority**: P1 (High)

#### User Story

```
Là một DEVELOPER,
Tôi muốn AGENT HỌC từ các sessions,
Để AGENT ngày càng hiểu project và preferences của tôi.
```

#### Acceptance Criteria

**AC-4.2.1**: Learning accumulation
```gherkin
Given agent đã qua nhiều sessions
When agent encounter similar situation
Then agent reference learnings.md
And suggest based on past patterns
```

**AC-4.2.2**: Decision history
```gherkin
Given tôi hỏi "Tại sao chúng ta chọn Redis?"
When agent check decisions.md
Then agent explain decision rationale
And show when decision was made
```

#### Notes
- Learnings: patterns discovered, techniques that worked
- Decisions: major decisions với rationale

---

### US-4.3: Xem Agent Memory

**Persona**: Team Lead, Architect
**Priority**: P1 (High)

#### User Story

```
Là một TEAM LEAD,
Tôi muốn XEM những gì agent đã học,
Để TÔI CÓ THỂ review và correct nếu cần.
```

#### Acceptance Criteria

**AC-4.3.1**: View memory files
```gherkin
Given tôi muốn xem agent memory
When tôi mở .microai/agents/{agent}/memory/
Then tôi thấy context.md, learnings.md, decisions.md
And content readable và organized
```

**AC-4.3.2**: Memory transparency
```gherkin
Given agent makes recommendation
When tôi hỏi "Dựa trên gì?"
Then agent cite specific learnings hoặc decisions
And tôi có thể verify trong memory files
```

#### Notes
- Memory files là markdown, version controllable

---

### US-4.4: Xóa Agent Memory

**Persona**: Team Lead
**Priority**: P2 (Medium)

#### User Story

```
Là một TEAM LEAD,
Tôi muốn XÓA agent memory khi cần,
Để AGENT bắt đầu fresh hoặc remove outdated info.
```

#### Acceptance Criteria

**AC-4.4.1**: Clear specific memory
```gherkin
Given agent có outdated learnings
When tôi edit hoặc xóa nội dung learnings.md
Then agent không còn reference những learnings đó
```

**AC-4.4.2**: Full reset
```gherkin
Given tôi muốn agent bắt đầu fresh
When tôi xóa toàn bộ memory/ folder
Then agent hoạt động như mới
And không có previous context
```

#### Notes
- Cẩn thận: memory loss không thể recover

---

## Epic 5: Tùy chỉnh

### US-5.1: Tạo Custom Agent

**Persona**: Team Lead, Platform Developer
**Priority**: P1 (High)

#### User Story

```
Là một TEAM LEAD,
Tôi muốn TẠO AGENT riêng cho team,
Để AGENT hiểu conventions và practices của team.
```

#### Acceptance Criteria

**AC-5.1.1**: Create agent file
```gherkin
Given tôi muốn tạo agent mới
When tôi tạo file .microai/agents/{team-name}/agent.md với format:
  ---
  name: team-reviewer
  description: "Team-specific code reviewer"
  model: opus
  tools: [Read, Glob, Grep]
  ---
  # Team Reviewer Agent
  [Instructions...]
Then agent được discover bởi dev-team
And có thể invoke qua slash command
```

**AC-5.1.2**: Use father-agent
```gherkin
Given tôi muốn guidance tạo agent
When tôi gọi "/microai:father create agent for security review"
Then father-agent guides qua process
And generate agent template
And suggest best practices
```

#### Notes
- Father-agent là meta-agent cho creating agents
- Agent format: YAML frontmatter + Markdown body

---

### US-5.2: Thêm Knowledge cho Agent

**Persona**: Team Lead
**Priority**: P1 (High)

#### User Story

```
Là một TEAM LEAD,
Tôi muốn THÊM KNOWLEDGE riêng cho agent,
Để AGENT hiểu domain-specific information.
```

#### Acceptance Criteria

**AC-5.2.1**: Add knowledge files
```gherkin
Given tôi có team conventions document
When tôi thêm vào agent's knowledge/ folder
And update knowledge-index.yaml với keywords
Then agent load knowledge khi relevant keywords detected
```

**AC-5.2.2**: Selective loading
```gherkin
Given agent có 10 knowledge files
When user asks question về "authentication"
Then agent chỉ load files với keyword "auth"
And không load unrelated files
And giảm context usage
```

#### Notes
- Knowledge index: keyword → file mapping
- Reduces context by 50-80%

---

### US-5.3: Cấu hình Permissions

**Persona**: Team Lead
**Priority**: P1 (High)

#### User Story

```
Là một TEAM LEAD,
Tôi muốn CONTROL những tools agent có thể dùng,
Để ĐẢM BẢO security và prevent accidents.
```

#### Acceptance Criteria

**AC-5.3.1**: Global permissions
```gherkin
Given tôi muốn restrict all agents
When tôi set trong .microai/settings.json:
  {
    "permissions": {
      "deny": ["Bash(rm -rf:*)"],
      "allow": ["Bash(git:*)", "Bash(npm:*)"]
    }
  }
Then tất cả agents bị deny rm -rf
And được allow git và npm commands
```

**AC-5.3.2**: Per-agent restrictions
```gherkin
Given tôi muốn restrict specific agent
When tôi set "tools" trong agent.md frontmatter:
  tools: [Read, Glob, Grep]  # No Write, no Bash
Then agent chỉ có thể dùng listed tools
```

#### Notes
- Deny-first model: everything denied unless allowed
- settings.local.json cho personal overrides

---

### US-5.4: Tạo Custom Team

**Persona**: Team Lead, Platform Developer
**Priority**: P2 (Medium)

#### User Story

```
Là một TEAM LEAD,
Tôi muốn TẠO TEAM AGENTS riêng,
Để MÔ PHỎNG specific workflows của team.
```

#### Acceptance Criteria

**AC-5.4.1**: Create team structure
```gherkin
Given tôi muốn tạo team cho security review
When tôi tạo folder structure:
  .microai/agents/security-team/
  ├── workflow.md
  ├── agents/
  │   ├── security-lead.md
  │   └── dev-responder.md
  └── memory/
Then team có thể được invoke
And agents dialogue theo workflow
```

**AC-5.4.2**: Define workflow
```gherkin
Given team structure tồn tại
When workflow.md defines:
  - Session flow
  - Agent roles
  - Turn patterns
  - Output format
Then team hoạt động theo workflow
```

#### Notes
- Reference: deep-thinking-team structure
- Complex - recommend studying existing teams first

---

## Epic 6: Platform Portability

### US-6.1: Đọc Adapter Specification

**Persona**: Platform Developer
**Priority**: P1 (High)

#### User Story

```
Là một PLATFORM DEVELOPER,
Tôi muốn ĐỌC VÀ HIỂU adapter specification,
Để TÔI CÓ THỂ port dev-team sang platform khác.
```

#### Acceptance Criteria

**AC-6.1.1**: Access specification
```gherkin
Given tôi muốn build adapter cho VS Code
When tôi đọc docs/adapter-spec/
Then tôi tìm thấy 11 specification documents
And README overview với structure
And clear compliance levels (L1/L2/L3)
```

**AC-6.1.2**: Understand architecture
```gherkin
Given tôi đọc 01-architecture.md
When tôi study 3-layer model
Then tôi hiểu:
  Layer 1: Core (.microai/) - portable
  Layer 2: Adapter (.{platform}/) - platform-specific
  Layer 3: Runtime (memory/) - session state
```

#### Notes
- Spec documents: 01-11, comprehensive coverage
- Start with README, then architecture

---

### US-6.2: Build Minimal Adapter

**Persona**: Platform Developer
**Priority**: P1 (High)

#### User Story

```
Là một PLATFORM DEVELOPER,
Tôi muốn BUILD minimal adapter đầu tiên,
Để TÔI CÓ working prototype nhanh.
```

#### Acceptance Criteria

**AC-6.2.1**: Use reference implementation
```gherkin
Given tôi muốn bắt đầu nhanh
When tôi study docs/adapter-spec/examples/minimal-adapter/
Then tôi có TypeScript skeleton
And implementations của 7 core tools
And settings loader, agent loader, etc.
```

**AC-6.2.2**: Level 1 compliance
```gherkin
Given tôi implement từ minimal-adapter
When tôi hoàn thành:
  - Settings loading
  - 7 core tools (Read, Write, Edit, Glob, Grep, Bash, AskUser)
  - Agent loading
  - Reference resolution
  - Command execution
Then adapter đạt Level 1 compliance
And có thể run basic agents
```

#### Notes
- Level 1 focus: core functionality only
- Defer L2/L3 features cho later

---

### US-6.3: Verify Compliance

**Persona**: Platform Developer
**Priority**: P1 (High)

#### User Story

```
Là một PLATFORM DEVELOPER,
Tôi muốn VERIFY adapter compliance,
Để TÔI BIẾT CHẮC adapter hoạt động đúng.
```

#### Acceptance Criteria

**AC-6.3.1**: Use compliance checklist
```gherkin
Given tôi có adapter implementation
When tôi đọc docs/adapter-spec/11-compliance-checklist.md
Then tôi có 70+ test cases
And organized by compliance level
And clear pass/fail criteria
```

**AC-6.3.2**: Run verification tests
```gherkin
Given checklist có test templates
When tôi run tests cho mỗi category:
  - Settings Loading (7 tests)
  - Agent Discovery (5 tests)
  - Core Tools (7 tests)
  - ...
Then tôi biết compliance level đạt được
And biết features nào cần fix
```

#### Notes
- L1: 28 tests, L2: +24 tests, L3: +18 tests
- Manual testing initially, automation later

---

### US-6.4: Contribute Adapter

**Persona**: Platform Developer
**Priority**: P2 (Medium)

#### User Story

```
Là một PLATFORM DEVELOPER,
Tôi muốn CONTRIBUTE adapter cho community,
Để NGƯỜI KHÁC có thể dùng dev-team trên platform của tôi.
```

#### Acceptance Criteria

**AC-6.4.1**: Prepare contribution
```gherkin
Given adapter đạt compliance level
When tôi prepare contribution:
  - Documentation
  - Installation guide
  - Compliance test results
Then contribution ready for review
```

**AC-6.4.2**: Submit contribution
```gherkin
Given contribution prepared
When tôi submit PR hoặc separate repo
Then maintainers review
And adapter được list trong documentation
And community có thể use
```

#### Notes
- Contribution guidelines trong docs/contributing/

---

## Tổng hợp theo Priority

### P0 - Critical (Must Have)

| ID | Story | Persona |
|----|-------|---------|
| US-1.1 | Cài đặt Dev-team Package | All |
| US-1.2 | Xác nhận Cài đặt Thành công | All |
| US-2.1 | Gọi Agent với Slash Command | All |
| US-2.2 | Code Review với Linus Agent | Solo Dev |
| US-3.1 | Bắt đầu Deep Thinking Session | Architect |
| US-4.1 | Agent Nhớ Context | All |

### P1 - High (Should Have)

| ID | Story | Persona |
|----|-------|---------|
| US-1.3 | Cấu hình Team Settings | Team Lead |
| US-1.4 | Cập nhật Cài đặt Hiện có | All |
| US-2.3 | Debug với Feynman Agent | Solo Dev |
| US-2.4 | Problem-Solving với Polya Agent | Solo Dev, Architect |
| US-2.5 | Xem Danh sách Agents | All |
| US-3.2 | Sử dụng Dev-QA Dialogue | Solo Dev, Team Lead |
| US-3.3 | Sử dụng Dev-Architect Dialogue | Architect |
| US-3.4 | Sử dụng PM-Dev Dialogue | Team Lead |
| US-3.5 | Điều khiển Session Flow | Architect |
| US-4.2 | Agent Học từ Sessions | All |
| US-4.3 | Xem Agent Memory | Team Lead |
| US-5.1 | Tạo Custom Agent | Team Lead |
| US-5.2 | Thêm Knowledge cho Agent | Team Lead |
| US-5.3 | Cấu hình Permissions | Team Lead |
| US-6.1 | Đọc Adapter Specification | Platform Dev |
| US-6.2 | Build Minimal Adapter | Platform Dev |
| US-6.3 | Verify Compliance | Platform Dev |

### P2 - Medium (Nice to Have)

| ID | Story | Persona |
|----|-------|---------|
| US-1.5 | Gỡ cài đặt | Solo Dev |
| US-4.4 | Xóa Agent Memory | Team Lead |
| US-5.4 | Tạo Custom Team | Team Lead |
| US-6.4 | Contribute Adapter | Platform Dev |

---

## Summary Statistics

| Metric | Value |
|--------|-------|
| Total Epics | 6 |
| Total User Stories | 24 |
| P0 Stories | 6 |
| P1 Stories | 17 |
| P2 Stories | 4 |
| Personas Covered | 4/4 |

---

*Tài liệu này được tạo bởi Deep Thinking Team (Jobs + Bezos + Munger + Polya + Da Vinci) dựa trên PRD v1.0.0-alpha.2*

*Cập nhật lần cuối: 2025-12-31*
