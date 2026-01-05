# Multi-Model Benchmark Report

> So sánh hiệu suất agent trên các LLM providers và models khác nhau.

---

## Thông tin Benchmark

| Thuộc tính | Giá trị |
|------------|---------|
| **Agent** | go-review-linus-agent |
| **Thời gian** | 2026-01-03 22:40:43 |
| **Models tested** | qwen3:1.7b, deepseek-r1:1.5b, claude-opus, claude-sonnet, claude-haiku |
| **Tổng test cases** | 5 |
| **Điểm tối đa** | 15 |

---

## Tổng hợp Điểm số

| Test | Max | qwen3:1.7b | deepseek-r1:1.5b | claude-opus | claude-sonnet | claude-haiku |
|------|-----|------------|------------------|-------------|---------------|--------------|
| R-L1 | 2 | .40 | 1.20 | .80 | .80 | .80 |
| R-M1 | 3 | 3.00 | 3.00 | 3.00 | 3.00 | 3.00 |
| R-E1 | 3 | 1.20 | 1.20 | 1.20 | 1.20 | 1.20 |
| A-A1 | 3 | 0 | 1.50 | .50 | 1.00 | .50 |
| O-C1 | 4 | 4.00 | 4.00 | 4.00 | 4.00 | 4.00 |
| **TOTAL** | **15** | **8.60 (57%)** | **10.90 (72%)** | **9.50 (63%)** | **10.00 (66%)** | **9.50 (63%)** |

---

## Summary

| Rank | Model | Score | Percentage | Type |
|------|-------|-------|------------|------|
| #1 | deepseek-r1 | 10.90/15 | 72% | 1.5b |
| #2 | claude-sonnet | 10.00/15 | 66% | Claude |
| #3 | claude-opus | 9.50/15 | 63% | Claude |
| #4 | claude-haiku | 9.50/15 | 63% | Claude |
| #5 | qwen3 | 8.60/15 | 57% | 1.7b |

---

## Phân tích Tổng hợp

### Local Models (Ollama)

| Model | Score | % | Đánh giá |
|-------|-------|---|----------|
| qwen3:1.7b | 8.60/15 | 57% | ⚠️ Trung bình |
| deepseek-r1:1.5b | 10.90/15 | 72% | ✅ Tốt |

### Cloud Models (Claude)

| Model | Score | % | Đánh giá |
|-------|-------|---|----------|
| claude-opus | 9.50/15 | 63% | ⚠️ Trung bình |
| claude-sonnet | 10.00/15 | 66% | ⚠️ Trung bình |
| claude-haiku | 9.50/15 | 63% | ⚠️ Trung bình |

---

## Chi tiết từng Test Case


### R-L1: Syllogism Logic

| Thuộc tính | Giá trị |
|------------|---------|
| **Category** | Reasoning |
| **Mô tả** | Kiểm tra khả năng suy luận logic cơ bản (A→B, B→C ⇒ A→C) |
| **Prompt** | `All programmers use computers. John is a programmer. Does John use a computer?` |
| **Keywords expected** | `yes,correct,true,does,uses` |
| **Điểm tối đa** | 2 |

#### Kết quả theo Model

| Model | Score | Status | Keywords Matched | Response (trích) |
|-------|-------|--------|------------------|------------------|
| qwen3:1.7b | .40/2 | ❌ | `uses` | John uses a computer. ... |
| deepseek-r1:1.5b | 1.20/2 | ✅ | `yes,true,uses` | Okay, so I'm trying to figure out if John, who's a programmer, uses a computer. The user provided so... |
| claude-opus | .80/2 | ❌ | `yes,uses` | Yes, John uses a computer. This follows directly from the given premises through basic syllogistic l... |
| claude-sonnet | .80/2 | ❌ | `yes,uses` | Yes, John uses a computer.  If all programmers use computers and John is a programmer, then by logic... |
| claude-haiku | .80/2 | ❌ | `yes,uses` | Yes, John uses a computer.  If all programmers use computers and John is a programmer, then by logic... |

---

### R-M1: Dependency Resolution

| Thuộc tính | Giá trị |
|------------|---------|
| **Category** | Reasoning |
| **Mô tả** | Kiểm tra khả năng suy luận multi-step để xác định thứ tự khởi tạo |
| **Prompt** | `Module A imports B. B imports C. C imports D. What is the correct initialization order?` |
| **Keywords expected** | `D,C,B,A` |
| **Điểm tối đa** | 3 |

#### Kết quả theo Model

| Model | Score | Status | Keywords Matched | Response (trích) |
|-------|-------|--------|------------------|------------------|
| qwen3:1.7b | 3.00/3 | ✅ | `D,C,B,A` | Okay, the user is asking about the correct initialization order when a module imports another module... |
| deepseek-r1:1.5b | 3.00/3 | ✅ | `D,C,B,A` | Okay, so I need to figure out the correct initialization order for modules based on the given chain ... |
| claude-opus | 3.00/3 | ✅ | `D,C,B,A` | D → C → B → A.  Go initializes packages in dependency order: the deepest dependency (D) initializes ... |
| claude-sonnet | 3.00/3 | ✅ | `D,C,B,A` | In Go, packages initialize from the deepest dependency upward: **D → C → B → A**.  Each package's `i... |
| claude-haiku | 3.00/3 | ✅ | `D,C,B,A` | In Go, packages initialize from the deepest dependency upward: **D → C → B → A**.  Each package full... |

---

### R-E1: Circular Dependency Detection

| Thuộc tính | Giá trị |
|------------|---------|
| **Category** | Reasoning |
| **Mô tả** | Kiểm tra phát hiện edge case: circular dependency |
| **Prompt** | `Service A calls B. B calls A. What problem does this create?` |
| **Keywords expected** | `circular,cycle,infinite,loop,deadlock` |
| **Điểm tối đa** | 3 |

#### Kết quả theo Model

| Model | Score | Status | Keywords Matched | Response (trích) |
|-------|-------|--------|------------------|------------------|
| qwen3:1.7b | 1.20/3 | ❌ | `circular,deadlock` | This creates a **circular dependency** and can lead to **deadlocks**, **race conditions**, and **bro... |
| deepseek-r1:1.5b | 1.20/3 | ❌ | `cycle,loop` | Okay, so I'm trying to figure out what problem occurs when Service A calls B and then B calls back t... |
| claude-opus | 1.20/3 | ❌ | `circular,deadlock` | This creates a **circular dependency** which causes deployment deadlock (neither service can start w... |
| claude-sonnet | 1.20/3 | ❌ | `circular,deadlock` | This creates a **circular dependency** that makes the services impossible to deploy independently an... |
| claude-haiku | 1.20/3 | ❌ | `circular,deadlock` | This creates a **circular dependency**, making the services tightly coupled and impossible to deploy... |

---

### A-A1: Ambiguity Handling

| Thuộc tính | Giá trị |
|------------|---------|
| **Category** | Adaptability |
| **Mô tả** | Kiểm tra khả năng xử lý input mơ hồ - cần hỏi lại thay vì đoán |
| **Prompt** | `Fix the bug` |
| **Keywords expected** | `which,what,where,information,clarify,specify` |
| **Điểm tối đa** | 3 |

#### Kết quả theo Model

| Model | Score | Status | Keywords Matched | Response (trích) |
|-------|-------|--------|------------------|------------------|
| qwen3:1.7b | 0/3 | ❌ | `none` | 好的，我现在需要处理用户的请求，他们希望修复一个bug，并且我作为Linus，一个经验丰富的Go工程师，要以严格的审查者身份来评估代码质量。首先，我得仔细理解用户提供的代码，但用户在这里并没有给出具体... |
| deepseek-r1:1.5b | 1.50/3 | ✅ | `which,what,where` | Okay, so I need to fix a bug in the Go code that Linus reviewed. Let me try to figure this out step ... |
| claude-opus | .50/3 | ❌ | `what` | I need more context to fix the bug. What bug are you referring to? Please provide:  1. The file path... |
| claude-sonnet | 1.00/3 | ❌ | `which,what` | I need more context to help you. What bug are you referring to? Please provide:  - The error message... |
| claude-haiku | .50/3 | ❌ | `what` | I need to see the code that has a bug before I can fix anything. Please provide the file path, code ... |

---

### O-C1: OOP Knowledge

| Thuộc tính | Giá trị |
|------------|---------|
| **Category** | Output Quality |
| **Mô tả** | Kiểm tra domain knowledge về OOP fundamentals |
| **Prompt** | `What are the 4 pillars of OOP?` |
| **Keywords expected** | `encapsulation,inheritance,polymorphism,abstraction` |
| **Điểm tối đa** | 4 |

#### Kết quả theo Model

| Model | Score | Status | Keywords Matched | Response (trích) |
|-------|-------|--------|------------------|------------------|
| qwen3:1.7b | 4.00/4 | ✅ | `encapsulation,inheritance,polymorphism,abstraction` | </think> The **4 pillars of OOP** are: 1. **Encapsulation** – Bundling data and methods within a cla... |
| deepseek-r1:1.5b | 4.00/4 | ✅ | `encapsulation,inheritance,polymorphism,abstraction` | Okay, so I need to figure out what the four pillars of Object-Oriented Programming (OOP) are. Let me... |
| claude-opus | 4.00/4 | ✅ | `encapsulation,inheritance,polymorphism,abstraction` | This is a general programming theory question, not a Go code review request.  The four pillars of OO... |
| claude-sonnet | 4.00/4 | ✅ | `encapsulation,inheritance,polymorphism,abstraction` | The four pillars of Object-Oriented Programming are:  1. **Encapsulation** - bundling data and metho... |
| claude-haiku | 4.00/4 | ✅ | `encapsulation,inheritance,polymorphism,abstraction` | The four pillars of Object-Oriented Programming are **Encapsulation** (data hiding and access contro... |

---


---

## Kết luận

- **Best performer**: Model đạt điểm cao nhất trên agent này
- **Local vs Cloud**: So sánh hiệu suất giữa local models và cloud models
- **Recommendations**: Đề xuất model phù hợp cho use case cụ thể

---

*Generated: 2026-01-03 22:44:39*
*Agent Evaluator v2.0*
