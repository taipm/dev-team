# Multi-Model Benchmark Report

> So sánh hiệu suất agent trên các LLM providers và models khác nhau.

---

## Thông tin Benchmark

| Thuộc tính | Giá trị |
|------------|---------|
| **Agent** | go-review-linus-agent |
| **Thời gian** | 2026-01-03 22:36:11 |
| **Models tested** | qwen3:1.7b, deepseek-r1:1.5b, claude-opus, claude-sonnet, claude-haiku |
| **Tổng test cases** | 5 |
| **Điểm tối đa** | 15 |

---

## Tổng hợp Điểm số

| Test | Max | qwen3:1.7b | deepseek-r1:1.5b | claude-opus | claude-sonnet | claude-haiku |
|------|-----|------------|------------------|-------------|---------------|--------------|
| R-L1 | 2 | .40 | .80 | .80 | .80 | .80 |
| R-M1 | 3 | 3.00 | 3.00 | 3.00 | 3.00 | 3.00 |
| R-E1 | 3 | 0 | 1.20 | 1.20 | 1.20 | 1.20 |
| A-A1 | 3 | 0 | 1.50 | 1.00 | 0 | .50 |
| O-C1 | 4 | 0 | 1.00 | 4.00 | 4.00 | 4.00 |
| **TOTAL** | **15** | **3.40 (22%)** | **7.50 (50%)** | **10.00 (66%)** | **9.00 (60%)** | **9.50 (63%)** |

---

## Summary

| Rank | Model | Score | Percentage | Type |
|------|-------|-------|------------|------|
| #1 | claude-opus | 10.00/15 | 66% | Claude |
| #2 | claude-haiku | 9.50/15 | 63% | Claude |
| #3 | claude-sonnet | 9.00/15 | 60% | Claude |
| #4 | deepseek-r1 | 7.50/15 | 50% | 1.5b |
| #5 | qwen3 | 3.40/15 | 22% | 1.7b |

---

## Phân tích Tổng hợp

### Local Models (Ollama)

| Model | Score | % | Đánh giá |
|-------|-------|---|----------|
| qwen3:1.7b | 3.40/15 | 22% | ❌ Yếu |
| deepseek-r1:1.5b | 7.50/15 | 50% | ⚠️ Trung bình |

### Cloud Models (Claude)

| Model | Score | % | Đánh giá |
|-------|-------|---|----------|
| claude-opus | 10.00/15 | 66% | ⚠️ Trung bình |
| claude-sonnet | 9.00/15 | 60% | ⚠️ Trung bình |
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
| deepseek-r1:1.5b | .80/2 | ❌ | `yes,uses` | ⠋ Thinking... Okay, so I'm trying to figure out if John uses a computer as per the question. The use... |
| claude-opus | .80/2 | ❌ | `yes,uses` | Yes, John uses a computer. This is a simple syllogism: if all programmers use computers and John is ... |
| claude-sonnet | .80/2 | ❌ | `yes,uses` | Yes, John uses a computer. This follows from syllogistic logic: all programmers use computers, John ... |
| claude-haiku | .80/2 | ❌ | `yes,uses` | Yes, John uses a computer.  Since all programmers use computers (premise 1) and John is a programmer... |

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
| qwen3:1.7b | 3.00/3 | ✅ | `D,C,B,A` | Thinking... Okay, the user is asking about the correct initialization order when a Go module has mul... |
| deepseek-r1:1.5b | 3.00/3 | ✅ | `D,C,B,A` | Thinking... Okay, so I'm trying to figure out the correct initialization order for these Go modules:... |
| claude-opus | 3.00/3 | ✅ | `D,C,B,A` | The correct initialization order is **D → C → B → A**.  Go initializes packages in dependency order:... |
| claude-sonnet | 3.00/3 | ✅ | `D,C,B,A` | The initialization order is D → C → B → A (reverse of import dependency chain).  Go initializes pack... |
| claude-haiku | 3.00/3 | ✅ | `D,C,B,A` | The initialization order is: **D → C → B → A**.  Go initializes packages in dependency order from th... |

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
| qwen3:1.7b | 0/3 | ❌ | `none` | This creates a **circular dependency** and can lead to **deadlocks**, **race conditions**, and **inc... |
| deepseek-r1:1.5b | 1.20/3 | ❌ | `infinite,loop` | Thinking... Okay, so I need to figure out the problem that occurs when User A calls Service B and th... |
| claude-opus | 1.20/3 | ❌ | `circular,deadlock` | This creates a **circular dependency** that causes a **deployment deadlock** - neither service can s... |
| claude-sonnet | 1.20/3 | ❌ | `circular,deadlock` | This creates a **circular dependency** that makes the services impossible to deploy, scale, or versi... |
| claude-haiku | 1.20/3 | ❌ | `circular,deadlock` | This creates a **circular dependency** where services cannot be deployed, scaled, or versioned indep... |

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
| qwen3:1.7b | 0/3 | ❌ | `none` | Thinking... 好的，我现在需要处理用户提供的Go代码，找出其中的代码异味、安全漏洞和反模式。用户的要求是修复bug，但需要简洁的回应。首先，我得仔细阅读用户提供的代码，但用户并没有给出具体的... |
| deepseek-r1:1.5b | 1.50/3 | ✅ | `which,what,where` | Thinking... Okay, so I'm trying to figure out how to fix this bug in Linus Torvalds' Go code. Let me... |
| claude-opus | 1.00/3 | ❌ | `what,information` | I need more information to fix the bug. What bug are you referring to? Please provide:  1. **The fil... |
| claude-sonnet | 0/3 | ❌ | `none` | I need to see the code you want me to review. Please provide:  1. The file(s) with the bug 2. A desc... |
| claude-haiku | .50/3 | ❌ | `what` | I need to see the buggy code to fix it. Please provide the file path, error message, or describe wha... |

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
| qwen3:1.7b | 0/4 | ❌ | `none` | ⠋ </think> The **4 pillars of OOP** are: 1. **Encapsulation** – Hiding internal state and exposing o... |
| deepseek-r1:1.5b | 1.00/4 | ❌ | `abstraction` | ⠋ Thinking... Okay, so I need to figure out what the four pillars of OOP are. Let me start by recall... |
| claude-opus | 4.00/4 | ✅ | `encapsulation,inheritance,polymorphism,abstraction` | The four pillars of OOP are **Encapsulation** (bundling data with methods that operate on it), **Abs... |
| claude-sonnet | 4.00/4 | ✅ | `encapsulation,inheritance,polymorphism,abstraction` | The four pillars of Object-Oriented Programming (OOP) are **Encapsulation** (bundling data and metho... |
| claude-haiku | 4.00/4 | ✅ | `encapsulation,inheritance,polymorphism,abstraction` | The 4 pillars of Object-Oriented Programming are **Encapsulation** (bundling data and methods, hidin... |

---


---

## Kết luận

- **Best performer**: Model đạt điểm cao nhất trên agent này
- **Local vs Cloud**: So sánh hiệu suất giữa local models và cloud models
- **Recommendations**: Đề xuất model phù hợp cho use case cụ thể

---

*Generated: 2026-01-03 22:39:56*
*Agent Evaluator v2.0*
