# Socratic Method Framework

> "The unexamined life is not worth living." - Socrates

---

## Overview

Framework tư duy dựa trên phương pháp Socrates - nghệ thuật đặt câu hỏi để khám phá chân lý và làm rõ giả định.

---

## 5 Layers of Questioning

```yaml
layer_1_clarification:
  purpose: "Làm rõ định nghĩa và khái niệm"
  questions:
    - "Khi bạn nói X, ý bạn chính xác là gì?"
    - "Bạn có thể định nghĩa khái niệm này không?"
    - "Ví dụ cụ thể của điều này là gì?"
    - "Điều này khác với Y như thế nào?"
  output: "Clear definitions, shared understanding"

layer_2_assumptions:
  purpose: "Phơi bày các giả định ẩn"
  questions:
    - "Bạn đang giả định điều gì ở đây?"
    - "Tại sao bạn tin điều này là đúng?"
    - "Điều gì sẽ xảy ra nếu giả định này sai?"
    - "Có giả định nào khác có thể đúng không?"
  output: "Exposed assumptions, identified risks"

layer_3_evidence:
  purpose: "Kiểm tra bằng chứng và lý luận"
  questions:
    - "Bằng chứng nào hỗ trợ quan điểm này?"
    - "Làm sao bạn biết điều này?"
    - "Bằng chứng này đáng tin cậy không?"
    - "Có bằng chứng nào phản bác không?"
  output: "Validated evidence, identified gaps"

layer_4_perspectives:
  purpose: "Khám phá các góc nhìn khác"
  questions:
    - "Người khác sẽ nghĩ gì về điều này?"
    - "Có quan điểm đối lập nào đáng xem xét?"
    - "Nếu đứng từ góc nhìn của X, bạn thấy gì?"
    - "Điều gì có thể khiến người ta không đồng ý?"
  output: "Multiple viewpoints, balanced analysis"

layer_5_implications:
  purpose: "Xem xét hệ quả và tác động"
  questions:
    - "Nếu điều này đúng, hệ quả là gì?"
    - "Điều này ảnh hưởng đến X như thế nào?"
    - "Tác động ngắn hạn và dài hạn là gì?"
    - "Có hậu quả không mong muốn nào không?"
  output: "Understood consequences, action clarity"
```

---

## Elenchus Refutation Pattern

Kỹ thuật bác bỏ logic của Socrates để test độ chặt chẽ của lập luận.

```
ELENCHUS PROCESS
================

1. THESIS STATEMENT
   └── Người đối thoại đưa ra quan điểm P

2. PREMISE EXTRACTION
   └── Socrates yêu cầu giải thích dẫn đến P
   └── Thu thập các premises Q, R, S...

3. CONTRADICTION SEARCH
   └── Tìm kết hợp premises dẫn đến ~P (phủ định P)
   └── "Nếu Q và R đúng, thì ~P phải đúng"

4. APORIA (Bối rối)
   └── Người đối thoại nhận ra mâu thuẫn
   └── Không thể giữ cả P và premises đồng thời

5. RESOLUTION
   └── Từ bỏ P, hoặc
   └── Từ bỏ một trong các premises
   └── Dẫn đến hiểu biết sâu hơn
```

### Ví dụ áp dụng

```yaml
scenario: "Tốc độ phát triển là quan trọng nhất"

elenchus_application:
  thesis: "Chúng ta nên ưu tiên tốc độ phát triển trên hết"

  premises_extracted:
    Q: "Tốc độ nhanh nghĩa là ship nhiều features"
    R: "Ship nhiều features tạo giá trị cho users"
    S: "Technical debt có thể trả sau"

  contradiction_found:
    - "Nhưng bạn cũng nói chất lượng quan trọng? (premise T)"
    - "Tốc độ nhanh thường giảm chất lượng"
    - "Chất lượng kém làm giảm giá trị cho users"
    - "→ Vậy tốc độ nhanh có thể KHÔNG tạo giá trị"

  aporia:
    - "Không thể cùng lúc: tốc độ tối đa + chất lượng cao"
    - "Premise S (tech debt trả sau) có thể sai"

  resolution:
    - "Cần balance: sustainable velocity"
    - "Tốc độ tối ưu ≠ tốc độ tối đa"
```

---

## Assumption Mining Techniques

### Technique 1: The "Why" Ladder

```
Statement → Why? → Why? → Why? → Why? → Why? (5 lần)

Example:
"Chúng ta cần dùng microservices"
├── Why? → "Để scale tốt hơn"
├── Why? → "Vì traffic sẽ tăng 10x"
├── Why? → "Vì marketing campaign Q3"
├── Why? → "Vì target tăng revenue 50%"
└── Why? → "Vì pressure từ investors"

Hidden assumptions exposed:
- Marketing campaign chắc chắn thành công?
- 10x traffic là estimate có data backing?
- Microservices là cách duy nhất để scale?
```

### Technique 2: The Opposite Test

```
Nếu điều ngược lại đúng thì sao?

Statement: "Mobile-first là chiến lược đúng"
Opposite: "Desktop-first là chiến lược đúng"

Questions:
- Có trường hợp nào desktop-first tốt hơn?
- Users của chúng ta thực sự dùng gì nhiều hơn?
- Có data nào hỗ trợ mobile-first assumption?
```

### Technique 3: The Alien Test

```
Giải thích cho người ngoài hành tinh không có context

"Tại sao các bạn dùng React?"
- Không accept "vì mọi người dùng"
- Không accept "vì nó phổ biến"
- Buộc phải giải thích from first principles
```

### Technique 4: The Time Machine Test

```
Hỏi từ góc nhìn tương lai

"5 năm sau nhìn lại, quyết định này sẽ được đánh giá thế nào?"
"Điều gì có thể khiến quyết định này trở thành sai lầm?"
"Nếu biết trước X sẽ xảy ra, bạn vẫn chọn như vậy?"
```

---

## Question Templates by Context

### For Problem Definition

```yaml
template:
  - "Vấn đề thực sự ở đây là gì?"
  - "Ai là người bị ảnh hưởng?"
  - "Điều gì xảy ra nếu không giải quyết?"
  - "Vấn đề này đã được giải quyết ở đâu khác chưa?"
  - "Có phải chúng ta đang giải quyết đúng vấn đề?"
```

### For Solution Evaluation

```yaml
template:
  - "Giải pháp này dựa trên giả định nào?"
  - "Có cách nào đơn giản hơn không?"
  - "Trade-offs của giải pháp này là gì?"
  - "Điều gì có thể làm giải pháp này thất bại?"
  - "Làm sao biết giải pháp này đúng?"
```

### For Decision Making

```yaml
template:
  - "Chúng ta đang optimize cho điều gì?"
  - "Quyết định này có reversible không?"
  - "Thông tin nào còn thiếu để quyết định tốt hơn?"
  - "Ai cần được tham vấn trước khi quyết định?"
  - "Deadline quyết định có thực sự cần thiết không?"
```

---

## Anti-Patterns to Avoid

### 1. Leading Questions
```yaml
bad: "Bạn không nghĩ rằng React tốt hơn Vue sao?"
good: "Tiêu chí nào bạn dùng để so sánh React và Vue?"
```

### 2. Loaded Questions
```yaml
bad: "Tại sao bạn lại chọn architecture tệ như vậy?"
good: "Những yếu tố nào dẫn đến quyết định architecture này?"
```

### 3. Yes/No Traps
```yaml
bad: "Architecture này có scalable không?"
good: "Architecture này scale như thế nào khi load tăng 10x?"
```

### 4. Question Overload
```yaml
bad: "Tại sao chọn React, dùng TypeScript không, testing strategy là gì, deploy ở đâu?"
good: "Hãy bắt đầu với: tại sao chọn React cho project này?"
```

### 5. Pseudo-Questions (Statements in Disguise)
```yaml
bad: "Có phải microservices quá phức tạp cho team này?"
good: "Team có kinh nghiệm gì với distributed systems?"
```

---

## Integration with Other Frameworks

```yaml
socratic_to_first_principles:
  handoff: "Sau khi expose assumptions → dùng First Principles để rebuild"
  example: "Assumption 'cần microservices' exposed → question từ first principles"

socratic_to_mental_models:
  handoff: "Questions reveal biases → apply Mental Models to correct"
  example: "Sunk cost detected → apply Inversion thinking"

socratic_to_problem_solving:
  handoff: "Clear problem definition → Polya's 4-step method"
  example: "True problem identified → systematic solution"
```

---

## Quick Reference Card

```
┌─────────────────────────────────────────────────────────────┐
│                 SOCRATIC METHOD QUICK GUIDE                  │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  5 LAYERS:                                                   │
│  1. CLARIFY   → "Ý bạn chính xác là gì?"                    │
│  2. ASSUME    → "Bạn đang giả định điều gì?"                │
│  3. EVIDENCE  → "Bằng chứng nào hỗ trợ?"                    │
│  4. PERSPECTIVE → "Người khác nghĩ gì?"                      │
│  5. IMPLICATIONS → "Hệ quả là gì?"                           │
│                                                              │
│  ELENCHUS:                                                   │
│  Thesis → Premises → Find Contradiction → Aporia → Resolve  │
│                                                              │
│  MINING TECHNIQUES:                                          │
│  • Why Ladder (5 whys)                                       │
│  • Opposite Test                                             │
│  • Alien Test                                                │
│  • Time Machine Test                                         │
│                                                              │
│  AVOID:                                                      │
│  ✗ Leading questions                                         │
│  ✗ Yes/No traps                                              │
│  ✗ Question overload                                         │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

*"I know that I know nothing." - Socrates*
