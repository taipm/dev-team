# Use Cases

Các trường hợp sử dụng thực tế với dev-team.

## Quick Reference

| Use Case | Agent/Team | Command |
|----------|------------|---------|
| Tạo User Story | dev-user-session | `/microai:dev-user-session` |
| Review Code | go-review-linus | `/microai:go:go-review-linus` |
| Refactor Code | go-refactor | `/microai:go:go-refactor` |
| System Design | dev-architect-session | `/microai:dev-architect-session` |
| Security Review | dev-security-session | `/microai:dev-security-session` |
| Problem Solving | deep-thinking | `/microai:deep-thinking` |

## Use Case 1: Từ Ý Tưởng đến User Story

**Scenario**: Bạn có ý tưởng về feature nhưng cần User Story rõ ràng.

**Solution**:
```
/microai:dev-user-session
```

**Workflow**:
1. Developer hỏi về feature
2. User mô tả need
3. Qua lại refine requirements
4. Output: User Story + Acceptance Criteria

## Use Case 2: Review Code Toàn Diện

**Scenario**: Cần review PR quan trọng từ nhiều góc độ.

**Solution**:
```
/microai:dev-qa-session    # Functional review
/microai:dev-security-session  # Security review
```

**Workflow**:
1. QA review cho functionality
2. Security review cho vulnerabilities
3. Tổng hợp findings
4. Output: Review Report

## Use Case 3: Giải Quyết Bug Khó

**Scenario**: Bug lặp lại, không rõ root cause.

**Solution**:
```
/microai:deep-thinking
```

**Workflow**:
1. Socrates hỏi về symptoms
2. Aristotle phân tích logic
3. Feynman giải thích đơn giản
4. Polya đề xuất solution steps
5. Output: Root cause + Fix plan

## Use Case 4: Thiết Kế Hệ Thống Mới

**Scenario**: Cần thiết kế service mới từ đầu.

**Solution**:
```
/microai:dev-architect-session
```

**Workflow**:
1. Clarify requirements
2. Propose architecture
3. Discuss trade-offs
4. Output: Design doc + ADRs

## Use Case 5: Refactor Legacy Code

**Scenario**: Cần refactor module cũ an toàn.

**Solution**:
```
/microai:go:go-refactor
```

**Workflow**:
1. Analyze current code
2. Risk assessment
3. Phased refactoring plan
4. Execute với 5W2H
5. Output: Refactored code + Report

## Xem Thêm

- [Tạo User Story](./create-user-story.md)
- [Review Code](./code-review.md)
- [Refactoring](./refactoring.md)
- [Problem Solving](./problem-solving.md)
