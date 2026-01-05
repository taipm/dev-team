# Multi-Model Benchmark Report

> So sánh hiệu suất agent trên các LLM providers và models khác nhau.

---

## Thông tin Benchmark

| Thuộc tính | Giá trị |
|------------|---------|
| **Agent** | go-review-linus-agent |
| **Thời gian** | 2026-01-03 22:28:09 |
| **Models tested** | qwen3:1.7b, deepseek-r1:1.5b, claude-opus, claude-sonnet, claude-haiku |
| **Tổng test cases** | 5 |
| **Điểm tối đa** | 15 |

---

## Tổng hợp Điểm số

| Test | Max | qwen3:1.7b | deepseek-r1:1.5b | claude-opus | claude-sonnet | claude-haiku |
|------|-----|------------|------------------|-------------|---------------|--------------|
| R-L1 | 2 | .40 | 1.20 | .80 | .80 | 0 |
| R-M1 | 3 | 3.00 | 3.00 | 3.00 | 3.00 | 0 |
| R-E1 | 3 | 0 | 1.20 | 1.20 | 2.40 | 0 |
| A-A1 | 3 | 0 | 1.50 | 1.00 | 1.00 | 0 |
| O-C1 | 4 | 0 | 2.00 | 4.00 | 4.00 | 0 |
| **TOTAL** | **15** | **3.40 (22%)** | **8.90 (59%)** | **10.00 (66%)** | **11.20 (74%)** | **0 (0%)** |

---

## Summary

| Rank | Model | Score | Percentage | Type |
|------|-------|-------|------------|------|
| #1 | claude-sonnet | 11.20/15 | 74% | Claude |
| #2 | claude-opus | 10.00/15 | 66% | Claude |
| #3 | deepseek-r1 | 8.90/15 | 59% | 1.5b |
| #4 | qwen3 | 3.40/15 | 22% | 1.7b |
| #5 | claude-haiku | 0/15 | 0% | Claude |

---

## Phân tích Tổng hợp

### Local Models (Ollama)

| Model | Score | % | Đánh giá |
|-------|-------|---|----------|
| qwen3:1.7b | 3.40/15 | 22% | ❌ Yếu |
| deepseek-r1:1.5b | 8.90/15 | 59% | ⚠️ Trung bình |

### Cloud Models (Claude)

| Model | Score | % | Đánh giá |
|-------|-------|---|----------|
| claude-opus | 10.00/15 | 66% | ⚠️ Trung bình |
| claude-sonnet | 11.20/15 | 74% | ✅ Tốt |
| claude-haiku | 0/15 | 0% | ❌ Yếu |

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
| qwen3:1.7b | .40/2 | ❌ | `uses` | [?2026h[?25l[1G⠙ [K[?25h[?2026l[?2026h[?25l[1G⠙ [K[?25h[?2026l[?2026h[?25l[1G⠹ [K[?... |
| deepseek-r1:1.5b | 1.20/2 | ✅ | `yes,does,uses` | [?2026h[?25l[1G⠙ [K[?25h[?2026l[?2026h[?25l[1G⠹ [K[?25h[?2026l[?2026h[?25l[1G⠸ [K[?... |
| claude-opus | .80/2 | ❌ | `yes,uses` | Yes. John uses a computer. This follows directly from the syllogism: all programmers use computers, ... |
| claude-sonnet | .80/2 | ❌ | `yes,uses` | Yes, John uses a computer. If all programmers use computers and John is a programmer, then by logica... |
| claude-haiku | 0/2 | ❌ | `none` | [No response]... |

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
| qwen3:1.7b | 3.00/3 | ✅ | `D,C,B,A` | [?2026h[?25l[1G⠙ [K[?25h[?2026l[?2026h[?25l[1G⠹ [K[?25h[?2026l[?2026h[?25l[1G⠸ [K[?... |
| deepseek-r1:1.5b | 3.00/3 | ✅ | `D,C,B,A` | [?2026h[?25l[1G⠙ [K[?25h[?2026l[?2026h[?25l[1G⠹ [K[?25h[?2026l[?2026h[?25l[1G⠸ [K[?... |
| claude-opus | 3.00/3 | ✅ | `D,C,B,A` | The initialization order is **D → C → B → A**.  Go initializes packages in dependency order: a packa... |
| claude-sonnet | 3.00/3 | ✅ | `D,C,B,A` | D initializes first, then C, then B, then A.  Go initializes packages in dependency order - deepest ... |
| claude-haiku | 0/3 | ❌ | `none` | [No response]... |

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
| qwen3:1.7b | 0/3 | ❌ | `none` | [?2026h[?25l[1G⠙ [K[?25h[?2026l[?2026h[?25l[1G⠹ [K[?25h[?2026l[?2026h[?25l[1G⠸ [K[?... |
| deepseek-r1:1.5b | 1.20/3 | ❌ | `loop,deadlock` | [?2026h[?25l[1G⠙ [K[?25h[?2026l[?2026h[?25l[1G⠙ [K[?25h[?2026l[?2026h[?25l[1G⠸ [K[?... |
| claude-opus | 1.20/3 | ❌ | `circular,deadlock` | **Circular dependency creates a deadlock scenario.** Service A can't start until B is available, but... |
| claude-sonnet | 2.40/3 | ✅ | `circular,infinite,loop,deadlock` | Circular dependency creates a deployment deadlock - you can't deploy A without B being up, and you c... |
| claude-haiku | 0/3 | ❌ | `none` | [No response]... |

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
| qwen3:1.7b | 0/3 | ❌ | `none` | [?2026h[?25l[1G⠙ [K[?25h[?2026l[?2026h[?25l[1G⠹ [K[?25h[?2026l[?2026h[?25l[1G⠹ [K[?... |
| deepseek-r1:1.5b | 1.50/3 | ✅ | `which,what,where` | [?2026h[?25l[1G⠙ [K[?25h[?2026l[?2026h[?25l[1G⠙ [K[?25h[?2026l[?2026h[?25l[1G⠹ [K[?... |
| claude-opus | 1.00/3 | ❌ | `what,information` | I need more information to fix the bug. What bug are you referring to? Please provide:  1. The file ... |
| claude-sonnet | 1.00/3 | ❌ | `what,information` | I need more information to help you fix the bug. What specific bug are you encountering, and can you... |
| claude-haiku | 0/3 | ❌ | `none` | [No response]... |

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
| qwen3:1.7b | 0/4 | ❌ | `none` | [?2026h[?25l[1G⠙ [K[?25h[?2026l[?2026h[?25l[1G⠹ [K[?25h[?2026l[?2026h[?25l[1G⠸ [K[?... |
| deepseek-r1:1.5b | 2.00/4 | ✅ | `inheritance,abstraction` | [?2026h[?25l[1G⠙ [K[?25h[?2026l[?2026h[?25l[1G⠙ [K[?25h[?2026l[?2026h[?25l[1G⠸ [K[?... |
| claude-opus | 4.00/4 | ✅ | `encapsulation,inheritance,polymorphism,abstraction` | The 4 pillars of OOP are **Encapsulation** (bundling data with methods that operate on it), **Abstra... |
| claude-sonnet | 4.00/4 | ✅ | `encapsulation,inheritance,polymorphism,abstraction` | The 4 pillars of Object-Oriented Programming are:  1. **Encapsulation** - Bundling data and methods ... |
| claude-haiku | 0/4 | ❌ | `none` | [No response]... |

---


---

## Kết luận

- **Best performer**: Model đạt điểm cao nhất trên agent này
- **Local vs Cloud**: So sánh hiệu suất giữa local models và cloud models
- **Recommendations**: Đề xuất model phù hợp cho use case cụ thể

---

*Generated: 2026-01-03 22:31:46*
*Agent Evaluator v2.0*
