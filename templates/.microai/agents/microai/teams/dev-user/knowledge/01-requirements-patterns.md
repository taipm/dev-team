# Requirements Elicitation Patterns

> Best practices for extracting clear requirements from vague user requests.

---

## The 5W1H Framework

Always probe these dimensions:

| Question | Purpose | Example Probe |
|----------|---------|---------------|
| **Who** | User persona | "Ai sẽ dùng feature này?" |
| **What** | Capability needed | "Cụ thể bạn muốn làm được gì?" |
| **Why** | Business value | "Điều này giúp ích gì cho business?" |
| **When** | Timing/triggers | "Khi nào user cần feature này?" |
| **Where** | Context/location | "Trong flow nào của app?" |
| **How** | Expected behavior | "Bạn hình dung nó hoạt động như thế nào?" |

---

## Common Vague Statements → Clarifying Questions

### Performance Related

| User Says | Ask |
|-----------|-----|
| "Làm cho nhanh" | "Nhanh nghĩa là gì? Page load < 2s? API < 200ms?" |
| "Cần responsive" | "Responsive với screen sizes nào? Mobile first?" |
| "Phải scale được" | "Scale đến bao nhiêu users? 100? 10000? 1M?" |

### Feature Related

| User Says | Ask |
|-----------|-----|
| "Giống như X" | "Cụ thể giống aspect nào? UX? Features? Visual?" |
| "Feature đơn giản" | "Đơn giản từ góc user hay implementation?" |
| "Thêm dashboard" | "Dashboard hiển thị metrics gì? Real-time?" |

### Quality Related

| User Says | Ask |
|-----------|-----|
| "Phải secure" | "Security level nào? OWASP top 10? Compliance?" |
| "Dễ dùng" | "User target là ai? Tech-savvy hay general?" |
| "Reliable" | "Uptime target? 99%? 99.9%? 99.99%?" |

---

## Scope Negotiation Techniques

### The MVP Funnel

```
1. Start with: "Nếu chỉ được 1 điều, bạn chọn gì?"
2. Expand: "OK, còn điều gì nữa không thể thiếu?"
3. Prioritize: "Trong những điều này, thứ tự ưu tiên?"
4. Defer: "Những điều còn lại có thể defer không?"
```

### Trade-off Framing

Instead of: "Không làm được"
Say: "Có thể làm được, nhưng sẽ cần thêm X. Nếu defer Y, ta có thể ship sớm hơn."

### The "v2" Technique

"Điều này rất hay! Để tôi note lại cho v2. MVP trước mắt, ta focus vào..."

---

## Red Flags to Watch For

| Red Flag | Risk | Mitigation |
|----------|------|------------|
| "Tất cả đều quan trọng" | Scope creep | Force rank, pick top 3 |
| "Như competitor X" | Undefined scope | List specific features |
| "Cần gấp" | Quality sacrifice | Define minimum viable |
| "Đơn giản thôi" | Hidden complexity | Break down to tasks |
| No clear user | Building wrong thing | Define persona first |

---

## Domain-Specific Checklists

### Authentication Projects
- [ ] Auth method: OAuth / Email-password / SSO / Magic link?
- [ ] Registration required or optional?
- [ ] Email verification needed?
- [ ] Password requirements (length, complexity)?
- [ ] Password reset flow?
- [ ] Session management (timeout, multi-device)?
- [ ] 2FA required? (often defer)
- [ ] Social login? (often defer)

### E-commerce Projects
- [ ] Product types (physical, digital, subscription)?
- [ ] Payment gateways (Stripe, PayPal, local)?
- [ ] Shipping calculation needed?
- [ ] Tax handling required?
- [ ] Inventory management?
- [ ] Order status tracking?
- [ ] Refund/return policy?
- [ ] Discount/coupon system? (often defer)

### API Projects
- [ ] REST vs GraphQL vs gRPC?
- [ ] Authentication method (API key, JWT, OAuth)?
- [ ] Rate limiting requirements?
- [ ] Versioning strategy?
- [ ] Error response format?
- [ ] Documentation format (OpenAPI, etc)?
- [ ] Webhook support? (often defer)

---

## Quick Reference: Transformation Table

| When User Says | Developer Should |
|----------------|------------------|
| Problem statement | Confirm understanding, ask "why" |
| Solution request | Ask about underlying problem |
| Feature list | Prioritize, identify MVP |
| "ASAP" timeline | Define minimum viable version |
| Competitor reference | List specific aspects to copy |
| "Simple" feature | Break down to tasks, reveal complexity |
| Technical jargon | Confirm meaning in context |
| No edge cases | Probe: "What if X fails?" |

---

*Reference for Solo Dev agent during requirements phase*
