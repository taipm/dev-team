# Agents Có Sẵn

Danh sách đầy đủ các agents được cung cấp sẵn trong dev-team framework.

## Tổng Quan

| Agent | Mục đích | Command |
|-------|----------|---------|
| father-agent | Tạo agents mới | `/microai:father` |
| npm-agent | Quản lý npm packages | `/microai:npm` |
| go-dev-portable | Phát triển Go | Task tool |
| go-refactor-portable | Refactor Go code | `/microai:go:go-refactor` |
| deep-question-agent | Đặt câu hỏi sâu | `/microai:deep-question` |

## father-agent

### Mô Tả

**Meta-agent** có khả năng tạo ra các agents, commands, knowledge files mới. Đây là agent "cha" của hệ thống.

### Khi Nào Dùng

- Tạo agent mới cho domain cụ thể
- Tạo command để kích hoạt agent
- Tạo knowledge files cho agent
- Clone agent hiện có và customize

### Cách Sử Dụng

```
/microai:father

Father Agent: Chào mừng! Tôi có thể giúp bạn:

*create-agent   - Tạo agent mới
*create-command - Tạo slash command
*create-knowledge - Tạo knowledge file
*clone-agent    - Clone và customize agent
*review-agent   - Review agent hiện có

Bạn muốn làm gì?
```

### Ví Dụ

```
You: *create-agent

Father: Tôi sẽ tạo agent mới. Hãy cho tôi biết:
1. Tên agent (lowercase, hyphenated)?
2. Mục đích chính của agent?
3. Domain/lĩnh vực?

You: database-migration-agent, giúp quản lý database migrations, PostgreSQL và MySQL

Father: Đang tạo agent với:
- Name: database-migration-agent
- Purpose: Quản lý database migrations
- Domain: PostgreSQL, MySQL

[Tạo file agent.md với đầy đủ persona, rules, workflow...]
```

## npm-agent

### Mô Tả

Chuyên gia về **npm ecosystem**: tạo installers, publish packages, quản lý dependencies.

### Khi Nào Dùng

- Tạo npm package mới
- Publish package lên registry
- Quản lý dependencies
- Setup monorepo với workspaces
- Troubleshoot npm issues

### Cách Sử Dụng

```
/microai:npm

npm-agent: Chào mừng! Tôi là npm specialist.

Tôi có thể giúp bạn với:
- Package creation & publishing
- Dependency management
- Monorepo setup
- npm scripts optimization
- Registry configuration

Bạn cần gì?
```

### Ví Dụ

```
You: Tôi muốn publish package đầu tiên

npm-agent: Tuyệt! Để publish package, cần:

1. **Kiểm tra package.json**:
   - name: unique trên npm
   - version: semver format
   - main: entry point
   - files: included files

2. **npm account**: Bạn đã có chưa?

3. **Test locally**:
   ```bash
   npm pack
   npm install ./your-package-1.0.0.tgz
   ```

Bạn đã có package.json chưa?
```

## go-dev-portable

### Mô Tả

Chuyên gia **phát triển Go** theo phong cách Linus Torvalds: tập trung vào systems thinking, performance, và code quality.

### Khi Nào Dùng

- Phát triển Go applications
- Debug Go code
- Optimize performance
- Design concurrent systems
- Review Go patterns

### Đặc Điểm

- Portable: có thể copy sang dự án khác
- Có knowledge base về Go best practices
- Có memory system để ghi nhớ decisions

### Cách Sử Dụng

Agent này thường được kích hoạt tự động qua Task tool khi làm việc với Go code.

```
You: Giúp tôi implement worker pool pattern trong Go

go-dev-portable: Worker pool pattern trong Go...

[Giải thích chi tiết với code examples từ knowledge base]
```

## go-refactor-portable

### Mô Tả

Chuyên gia **refactor Go code** với phương pháp có hệ thống: risk-based batching, 5W2H analysis, auto-report.

### Khi Nào Dùng

- Refactor large codebase
- Improve code quality
- Reduce technical debt
- Modernize legacy code

### Cách Sử Dụng

```
/microai:go:go-refactor

go-refactor: Chào mừng! Tôi giúp refactor Go code một cách có hệ thống.

Quy trình:
1. Phân tích codebase
2. Xác định refactoring opportunities
3. Đánh giá risk
4. Batch theo risk level
5. Thực hiện từng batch
6. Generate report

Bạn muốn refactor file/package nào?
```

### Ví Dụ

```
You: Refactor package handlers/

go-refactor: Đang phân tích handlers/...

📊 Phân tích:
- 15 files, 2500 LOC
- 8 refactoring opportunities identified

🎯 Opportunities (sorted by risk):

LOW RISK:
1. Rename inconsistent function names
2. Extract common error handling

MEDIUM RISK:
3. Split large functions (>50 LOC)
4. Extract middleware pattern

HIGH RISK:
5. Restructure package layout

Bắt đầu với LOW RISK batch?
```

## deep-question-agent

### Mô Tả

Agent giúp **đặt câu hỏi sâu** sử dụng 7 phương pháp tư duy khác nhau.

### Khi Nào Dùng

- Phân tích vấn đề phức tạp
- Tìm root cause
- Challenge assumptions
- Explore alternatives

### 7 Phương Pháp

1. **5 Why Analysis**: Hỏi "Tại sao?" 5 lần
2. **First Principles**: Phân tích về nguyên lý cơ bản
3. **Socratic Questioning**: Thách thức giả định
4. **Systems Thinking**: Xem xét tương tác hệ thống
5. **Inversion**: Đảo ngược vấn đề
6. **Analogical Thinking**: Tìm pattern tương tự
7. **Pre-mortem**: Giả định thất bại và phân tích

### Cách Sử Dụng

```
/microai:deep-question

deep-question: Chào mừng! Tôi sẽ giúp bạn đặt câu hỏi sâu.

Các phương pháp có sẵn:
*5why      - 5 Why Analysis
*first     - First Principles
*socratic  - Socratic Questioning
*systems   - Systems Thinking
*invert    - Inversion
*analogy   - Analogical Thinking
*premortem - Pre-mortem Analysis

Vấn đề bạn muốn khám phá?
```

### Ví Dụ

```
You: Tại sao hệ thống của tôi thường xuyên timeout?

deep-question: Áp dụng 5 Why Analysis:

❓ Why 1: Tại sao timeout?
→ Response time > threshold

❓ Why 2: Tại sao response time cao?
→ Database queries chậm

❓ Why 3: Tại sao queries chậm?
→ Thiếu indexes, full table scans

❓ Why 4: Tại sao thiếu indexes?
→ Không có query analysis trong development

❓ Why 5: Tại sao không có query analysis?
→ Thiếu tooling và process

🎯 Root Cause: Thiếu observability tooling trong development process

📋 Actions:
1. Add query logging
2. Setup slow query monitoring
3. Add index recommendations to CI
```

## So Sánh Agents

| Tiêu chí | father | npm | go-dev | go-refactor | deep-question |
|----------|--------|-----|--------|-------------|---------------|
| Domain | Meta | npm | Go | Go | Thinking |
| Model | opus | sonnet | opus | opus | sonnet |
| Knowledge | ✅ | ✅ | ✅ | ✅ | ✅ |
| Memory | ✅ | ❌ | ✅ | ✅ | ❌ |
| Portable | ❌ | ❌ | ✅ | ✅ | ❌ |

## Bước Tiếp Theo

- [father-agent chi tiết](./father-agent.md)
- [npm-agent chi tiết](./npm-agent.md)
- [go-dev-agent chi tiết](./go-dev-agent.md)
- [Agent Gallery](./gallery.md)
