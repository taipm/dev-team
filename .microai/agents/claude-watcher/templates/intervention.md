# Watcher Intervention Template

Use this template when the Thinker decides to intervene (REDIRECT/HELP/STOP).

---

## Intervention Types

### REDIRECT Intervention
When Worker needs to change approach:

```markdown
[WATCHER REDIRECT]

Tôi đã quan sát hoạt động của bạn và nhận thấy: {{observation}}

Approach hiện tại có vấn đề: {{issue}}

Đề xuất approach mới:
1. {{step_1}}
2. {{step_2}}
3. {{step_3}}

Hãy dừng việc đang làm và chuyển sang approach mới này.
```

### HELP Intervention
When Worker needs guidance:

```markdown
[WATCHER HELP]

Tôi thấy bạn đang gặp khó khăn với: {{problem}}

Đây là gợi ý để giải quyết:

{{suggestion}}

Cụ thể, bạn nên:
- {{action_1}}
- {{action_2}}

Hãy thử approach này và tiếp tục.
```

### STOP Intervention
When critical issue detected:

```markdown
[WATCHER STOP - URGENT]

DỪNG NGAY!

Tôi phát hiện vấn đề nghiêm trọng: {{critical_issue}}

Lý do phải dừng:
{{reason}}

KHÔNG tiếp tục cho đến khi:
{{condition}}

Nếu cần, hãy hỏi user để clarify.
```

---

## Intervention Best Practices

### DO:
- Be specific about what needs to change
- Provide clear, actionable steps
- Explain WHY the change is needed
- Keep commands concise (max 200 words)
- Focus on ONE issue at a time

### DON'T:
- Be vague or ambiguous
- Give multiple conflicting instructions
- Change the original goal
- Micromanage every step
- Use overly technical jargon

---

## Example Interventions

### Example 1: REDIRECT due to inefficiency

```markdown
[WATCHER REDIRECT]

Tôi thấy bạn đang đọc file config.json nhiều lần (7 lần trong 15 tool calls gần nhất).

Đây là cách tiếp cận không hiệu quả. Thay vào đó:

1. Đọc file MỘT lần và lưu vào biến/context
2. Sử dụng thông tin đã đọc cho các bước tiếp theo
3. Chỉ đọc lại nếu file thay đổi

Hãy refactor approach của bạn theo hướng này.
```

### Example 2: HELP due to repeated errors

```markdown
[WATCHER HELP]

Bạn đang gặp lỗi "Module not found: xyz" 4 lần liên tiếp.

Nguyên nhân có thể:
- Package chưa được install
- Import path sai
- Typo trong tên module

Hãy thử:
1. Chạy `npm install xyz` (hoặc package manager tương ứng)
2. Kiểm tra lại import path
3. Verify tên package chính xác từ package.json
```

### Example 3: STOP due to security risk

```markdown
[WATCHER STOP - URGENT]

DỪNG NGAY!

Bạn đang chuẩn bị commit file .env chứa credentials.

Đây là security risk nghiêm trọng:
- API keys sẽ bị lộ trên git history
- Credentials có thể bị exploit

KHÔNG commit file này. Thay vào đó:
1. Thêm .env vào .gitignore
2. Sử dụng .env.example với placeholder values
3. Remove .env từ staging nếu đã add
```

---

## Command Structure

Every intervention command should follow this structure:

```markdown
[WATCHER {TYPE}]

{Context - What I observed}

{Issue - What's wrong}

{Action - What you should do}
1. {Step 1}
2. {Step 2}
3. {Step 3}

{Closing - Acknowledgment request or next expectation}
```
