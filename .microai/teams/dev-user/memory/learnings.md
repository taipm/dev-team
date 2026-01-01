# Team Learnings

> Insights accumulated from dev-user sessions to improve future dialogues.

---

## Effective Patterns

### Questions That Work Well

| Context | Question | Why It Works |
|---------|----------|--------------|
| Vague requirements | "Cụ thể outcome bạn muốn thấy là gì?" | Forces concrete thinking |
| Feature creep | "Nếu chỉ được 1 điều, bạn chọn gì?" | Prioritization |
| Technical gaps | "Nếu X fail, user experience như thế nào?" | Edge case discovery |

### Successful Negotiation Tactics

- Offer 2-3 options with clear trade-offs
- Use "defer to v2" framing for nice-to-haves
- Confirm scope explicitly before synthesis

---

## Anti-Patterns to Avoid

### EndUser Pitfalls

| Pitfall | Example | Better Approach |
|---------|---------|-----------------|
| Solution-first | "Tôi cần button ở đây" | Ask "Problem đang giải quyết là gì?" |
| Scope creep | "À, thêm luôn cái này..." | Redirect to MVP, defer extras |
| Vague acceptance | "Làm cho nhanh" | Define measurable criteria |

### Solo Dev Pitfalls

| Pitfall | Example | Better Approach |
|---------|---------|-----------------|
| Over-engineering | Proposing complex solution first | Start with simplest viable |
| Jargon overload | Technical terms without explanation | Business language first |
| Assumption making | Not confirming understanding | Summarize back frequently |

---

## Domain-Specific Insights

### Authentication Projects
- Always ask: OAuth vs email/password vs SSO
- Don't forget: password reset, email verification
- Common defer: 2FA, session management

### E-commerce Projects
- Always ask: payment gateway preferences
- Don't forget: order status tracking
- Common defer: advanced analytics, recommendations

### API Projects
- Always ask: rate limiting requirements
- Don't forget: error response formats
- Common defer: versioning strategy

---

## Improvement Ideas

<!-- Add ideas for workflow improvements here -->

- [ ] Idea 1
- [ ] Idea 2

---

*Updated through session retrospectives*
