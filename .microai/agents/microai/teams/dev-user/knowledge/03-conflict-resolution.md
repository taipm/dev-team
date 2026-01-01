# Conflict Resolution Protocol

> How to handle disagreements and deadlocks between Solo Dev and EndUser.

---

## Types of Conflicts

### 1. Scope Conflicts
**Symptom:** EndUser wants more, Solo Dev says too complex

**Resolution Pattern:**
```
1. Acknowledge both perspectives
2. Quantify the trade-off:
   "Adding X means delaying by Y days"
3. Offer alternatives:
   - Simplified version now, full version later
   - Different approach achieving same goal
   - Split into separate story
4. Let EndUser decide with clear trade-offs
```

**Facilitator Intervention:**
```
[Facilitator Note] 📋

Dường như có conflict về scope. Hãy làm rõ trade-off:

Solo Dev: Bạn có thể estimate effort cho cả 2 options?
EndUser: Với estimate đó, bạn sẽ prioritize thế nào?

Mục tiêu: Đạt agreement về MVP scope.
```

---

### 2. Technical vs Business Conflicts
**Symptom:** Solo Dev có concerns kỹ thuật, EndUser không hiểu impact

**Resolution Pattern:**
```
1. Solo Dev giải thích bằng business terms:
   "Approach này có risk X sẽ gây Y cho users"
2. Offer alternatives với trade-offs rõ ràng
3. If still conflict: Document concern, let business decide
```

**Example:**
```
Solo Dev: "Storing passwords in plain text là security risk."
EndUser: "Nhưng nhanh hơn mà?"
Solo Dev: "Nếu bị hack, tất cả user passwords bị lộ.
          Chi phí: 2 giờ thêm cho proper hashing.
          Risk nếu không làm: Có thể mất toàn bộ users."
EndUser: "OK, làm đúng cách đi."
```

---

### 3. Priority Conflicts
**Symptom:** Can't agree on what's most important

**Resolution Pattern:**
```
1. Use forced ranking:
   "Nếu CHỈ ĐƯỢC MỘT, chọn gì?"
2. Apply MoSCoW:
   - Must have (ship fails without)
   - Should have (painful without)
   - Could have (nice to have)
   - Won't have (explicitly deferred)
3. Time-box decision: "5 phút để rank top 3"
```

---

### 4. Understanding Conflicts
**Symptom:** Talking past each other, different interpretations

**Resolution Pattern:**
```
1. Pause and summarize:
   "Để tôi tóm tắt lại điều tôi hiểu..."
2. Use concrete examples:
   "Khi user làm X, bạn expect Y hay Z?"
3. Draw/diagram if needed:
   "Để tôi vẽ flow để confirm..."
4. Confirm explicitly:
   "Vậy chúng ta đồng ý là... đúng chưa?"
```

---

## Deadlock Breaker Protocol

When dialogue is stuck after 3+ turns on same topic:

### Step 1: Facilitator Intervention
```
[Facilitator] 🔄

Chúng ta dường như đang stuck. Hãy thử approach khác:

Option A: Defer điểm này, tiếp tục với những gì đã agree
Option B: Break thành 2 stories riêng
Option C: Time-box 2 phút, mỗi bên propose 1 compromise

Observer, bạn muốn chọn option nào?
```

### Step 2: Force Decision
If still stuck:
```
[Facilitator] ⚖️

Để tiến về phía trước, tôi đề xuất:
- Ghi nhận cả 2 perspectives trong story notes
- Chọn approach đơn giản hơn cho MVP
- Create follow-up story cho approach phức tạp nếu cần

Đồng ý tiến hành?
```

### Step 3: Document and Move On
```yaml
story_notes:
  unresolved_discussions:
    - topic: "{conflict topic}"
      enduser_position: "{summary}"
      dev_position: "{summary}"
      resolution: "Deferred - MVP uses {chosen approach}"
      follow_up: "Consider {alternative} in future iteration"
```

---

## Escalation Triggers

Auto-escalate to Observer when:

| Trigger | Threshold |
|---------|-----------|
| Same topic repeated | 3 turns without progress |
| Explicit disagreement | Either says "Tôi không đồng ý" |
| Complexity warning | Solo Dev flags "Điều này rất complex" |
| Scope explosion | 5+ new requirements added in one turn |
| Timeline conflict | Delivery date disagreement |

**Escalation Message:**
```
[Facilitator] 🚨

Cần Observer input. Situation:
- Topic: {topic}
- Solo Dev position: {summary}
- EndUser position: {summary}
- Turns spent: {n}

Observer, vui lòng:
@guide: {your direction}
hoặc @dev/@user: {inject specific message}
```

---

## Prevention Strategies

### Set Expectations Early
In session init, remind:
```
"Mục tiêu là tạo User Story mà CẢ HAI đồng ý.
Nếu có disagreement, ta sẽ:
1. Làm rõ trade-offs
2. Tìm compromise
3. Defer nếu không critical"
```

### Regular Check-ins
Every 5 turns:
```
[Facilitator] 📊

Quick check: Chúng ta đang ở turn {n}.
Đã agree: {list agreed items}
Còn pending: {list open items}

On track? Tiếp tục!
```

### Celebrate Agreements
When agreement reached:
```
[Facilitator] ✓

Noted: Đồng ý về "{topic}". Moving on!
```

---

## Quick Reference

| Conflict Type | First Response | Escalation |
|---------------|----------------|------------|
| Scope | Quantify trade-off | Defer to v2 |
| Technical | Business terms explanation | Document risk |
| Priority | Forced ranking | MoSCoW method |
| Understanding | Summarize back | Concrete example |
| Deadlock | Facilitator options | Observer decision |

---

*Reference for Facilitator during dialogue phase*
