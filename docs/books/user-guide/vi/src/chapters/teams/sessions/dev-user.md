# dev-user-session

Dialogue giữa Developer và End User để tạo User Story.

## Kích Hoạt

```
/microai:dev-user-session
```

## Mục Đích

- Hiểu requirements từ góc độ user
- Tạo User Story theo format chuẩn
- Xác định Acceptance Criteria chi tiết
- Phát hiện edge cases

## Roles

### 👨‍💻 Developer
- Hỏi clarifying questions
- Đề xuất technical solutions
- Identify constraints
- Viết User Story format

### 👤 End-User
- Mô tả needs và pain points
- Provide use case examples
- Validate acceptance criteria
- Confirm understanding

## Dialogue Flow

```
Turn 1: Developer hỏi về need
Turn 2: End-User mô tả pain point
Turn 3: Developer clarify details
Turn 4: End-User provide examples
Turn 5: Developer đề xuất solution
Turn 6: End-User feedback
Turn 7: Developer viết User Story
Turn 8: End-User confirm
```

## Output Format

```markdown
# User Story

**Title**: [Tên tính năng]

**Story**:
As a [role]
I want [capability]
So that [benefit]

## Acceptance Criteria

### Scenario 1: [Happy path]
- Given: [context]
- When: [action]
- Then: [result]

### Scenario 2: [Edge case]
- Given: [context]
- When: [action]
- Then: [result]

## Notes
- [Additional notes]
```

## Ví Dụ Session

```
You: /microai:dev-user-session

Developer: 👨‍💻 Xin chào! Tôi sẽ giúp bạn biến ý tưởng
thành User Story rõ ràng. Bạn muốn có tính năng gì?

End-User: 👤 Tôi muốn nhận notification khi order
của tôi thay đổi trạng thái.

Developer: 👨‍💻 Tuyệt! Để hiểu rõ hơn:
1. Bạn muốn nhận qua kênh nào? (App, Email, SMS?)
2. Tất cả thay đổi hay chỉ quan trọng?

End-User: 👤 Push notification trên app,
và email cho những thay đổi quan trọng như ship và deliver.

Developer: 👨‍💻 Hiểu rồi. Vậy:
- Push: tất cả status changes
- Email: chỉ shipped và delivered
Đúng không?

End-User: 👤 Đúng! Và tôi muốn có thể tắt notifications nếu cần.

Developer: 👨‍💻 Got it! Đây là User Story:

📋 **User Story: Order Status Notifications**

As a customer
I want to receive notifications when my order status changes
So that I can stay informed without checking the app repeatedly

**Acceptance Criteria**:

✅ Scenario 1: Status Change
- Given I have an active order
- When the status changes
- Then I receive a push notification

✅ Scenario 2: Important Updates
- Given my order is shipped or delivered
- When the status updates
- Then I receive both push and email

✅ Scenario 3: Preferences
- Given I am in notification settings
- When I toggle off order notifications
- Then I stop receiving them

Bạn confirm nhé?

End-User: 👤 Hoàn hảo!
```

## Tips

- Cung cấp context về domain
- Trả lời như real user
- Đừng ngại nói "không hiểu"

## Xem Thêm

- [Session Teams Overview](../session-teams.md)
- [Tạo User Story Workflow](../../workflows/create-user-story.md)
