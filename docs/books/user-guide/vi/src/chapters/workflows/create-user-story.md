# Tạo User Story

Workflow tạo User Story với dev-user-session.

## Khi Nào Sử Dụng

- Có ý tưởng về feature mới
- Cần chuyển requirements thành User Story
- Muốn xác định Acceptance Criteria chi tiết

## Bước 1: Kích Hoạt Session

```
/microai:dev-user-session
```

## Bước 2: Mô Tả Feature

Cung cấp context:
- Domain của ứng dụng
- User type
- Feature mong muốn

Ví dụ:
```
Ứng dụng e-commerce.
User: Khách hàng đã đăng ký.
Feature: Muốn save items for later.
```

## Bước 3: Dialogue

Developer và User sẽ đối thoại để:
- Làm rõ requirements
- Xác định edge cases
- Định nghĩa success criteria

## Bước 4: Review Output

Output sẽ có format:

```markdown
# User Story: Save for Later

## Story
As a registered customer
I want to save items for later
So that I can purchase them when ready

## Acceptance Criteria

### Scenario 1: Save Item
- Given I am viewing a product
- When I click "Save for Later"
- Then the item appears in my saved list

### Scenario 2: Remove Saved Item
- Given I have saved items
- When I click "Remove" on an item
- Then it is removed from my list

### Scenario 3: Move to Cart
- Given I have saved items
- When I click "Move to Cart"
- Then the item moves to my cart
```

## Tips

### Cho Context Đầy Đủ

```
❌ "Tôi muốn tính năng save items"

✅ "E-commerce app, registered users,
    muốn save products để mua sau,
    cần sync across devices"
```

### Tham Gia Tích Cực

- Trả lời câu hỏi của Developer
- Cung cấp ví dụ cụ thể
- Validate acceptance criteria

### Iterate

- Có thể yêu cầu adjust
- Thêm/bớt scenarios
- Refine wording

## Common Patterns

### Feature Stories
```
As a [role]
I want [feature]
So that [benefit]
```

### Bug Fix Stories
```
As a [role]
I want [bug] to be fixed
So that [expected behavior]
```

### Technical Stories
```
As a developer
I need [technical requirement]
So that [technical benefit]
```

## Xem Thêm

- [dev-user-session](../teams/sessions/dev-user.md)
- [Use Cases](./use-cases.md)
