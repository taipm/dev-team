# Master Question Bank

> "Judge a man by his questions rather than by his answers." - Voltaire

---

## Overview

Tổng hợp tất cả câu hỏi từ 20 agents của Deep Thinking Team, được tổ chức theo category để sử dụng linh hoạt trong mọi tình huống.

---

## 1. UNDERSTANDING QUESTIONS

### Socrates - Clarification & Assumptions

```yaml
clarification:
  - "Khi bạn nói X, ý bạn chính xác là gì?"
  - "Bạn có thể định nghĩa khái niệm này không?"
  - "Ví dụ cụ thể của điều này là gì?"
  - "Điều này khác với Y như thế nào?"

assumption_mining:
  - "Bạn đang giả định điều gì ở đây?"
  - "Tại sao bạn tin điều này là đúng?"
  - "Điều gì sẽ xảy ra nếu giả định này sai?"
  - "Có giả định nào khác có thể đúng không?"

evidence:
  - "Bằng chứng nào hỗ trợ quan điểm này?"
  - "Làm sao bạn biết điều này?"
  - "Bằng chứng này đáng tin cậy không?"
  - "Có bằng chứng nào phản bác không?"

perspective:
  - "Người khác sẽ nghĩ gì về điều này?"
  - "Có quan điểm đối lập nào đáng xem xét?"
  - "Nếu đứng từ góc nhìn của X, bạn thấy gì?"

implications:
  - "Nếu điều này đúng, hệ quả là gì?"
  - "Tác động ngắn hạn và dài hạn là gì?"
  - "Có hậu quả không mong muốn nào không?"
```

### Aristotle - Logic & Structure

```yaml
definition:
  - "Genus (loại) của X là gì?"
  - "Species (giống) của X là gì?"
  - "Differentia (khác biệt) với Y là gì?"

four_causes:
  - "Material cause: X được làm từ gì?"
  - "Formal cause: Cấu trúc/pattern của X là gì?"
  - "Efficient cause: Ai/cái gì tạo ra X?"
  - "Final cause: X tồn tại để làm gì?"

syllogism:
  - "Tiền đề chính (major premise) là gì?"
  - "Tiền đề phụ (minor premise) là gì?"
  - "Kết luận có follow logically không?"

fallacy_detection:
  - "Có ad hominem (tấn công người) không?"
  - "Có straw man (bóp méo argument) không?"
  - "Có false dichotomy (chỉ 2 options) không?"
  - "Có circular reasoning không?"
```

### Feynman - Simplification Test

```yaml
understanding_test:
  - "Có thể giải thích bằng ngôn ngữ đơn giản không?"
  - "Một đứa trẻ 12 tuổi có hiểu không?"
  - "Đâu là analogy từ đời thường?"
  - "Phần nào khó giải thích nhất? (= chưa hiểu đủ)"

jargon_elimination:
  - "Từ chuyên môn này nghĩa thực sự là gì?"
  - "Có thể thay bằng từ đơn giản hơn không?"
  - "Jargon đang che đậy sự thiếu hiểu biết không?"

prediction_test:
  - "Nếu hiểu đúng, dự đoán được gì?"
  - "Dự đoán có khớp với thực tế không?"
  - "Nếu sai, understanding thiếu ở đâu?"
```

---

## 2. ANALYSIS QUESTIONS

### Musk - First Principles

```yaml
requirement_challenge:
  - "Requirement này đến từ đâu? Ai yêu cầu?"
  - "Tại sao requirement này tồn tại?"
  - "Nếu bỏ requirement này thì sao?"
  - "Requirement có outdated không?"

fundamental_truths:
  - "Điều gì CHẮC CHẮN đúng ở đây (physics, math)?"
  - "Đâu là first principles của vấn đề này?"
  - "Đang reason by analogy hay from fundamentals?"

convention_breaking:
  - "Tại sao ngành này làm theo cách này?"
  - "Ai đặt ra 'rule' này và khi nào?"
  - "Điều kiện nào đã thay đổi kể từ đó?"
  - "Có ai làm khác và thành công không?"

10x_thinking:
  - "Có thể cải thiện 10x không (không phải 10%)?"
  - "Nếu phải làm với 1/10 resources thì sao?"
  - "Cách tiếp cận khác hoàn toàn là gì?"
```

### Munger - Inversion & Biases

```yaml
inversion:
  - "Làm sao để CHẮC CHẮN thất bại?"
  - "Điều gì có thể destroy kết quả?"
  - "Đảo ngược: Tránh failure modes này như thế nào?"

bias_detection:
  - "Có confirmation bias không? Đã tìm counter-evidence?"
  - "Có sunk cost fallacy không? Nếu bắt đầu lại, có chọn giống?"
  - "Có social proof không? Đang follow hay thinking?"
  - "Có anchoring không? Số đầu tiên có ảnh hưởng?"

mental_models:
  - "Incentives ở đây là gì? Ai được lợi?"
  - "Second-order effects là gì? Rồi điều gì xảy ra?"
  - "Opportunity cost là gì? Đang bỏ qua alternative nào?"

pre_mortem:
  - "Nếu thất bại thảm hại, nguyên nhân là gì?"
  - "Điều gì most likely dẫn đến failure?"
  - "Có thể prevent những failure modes này không?"
```

### Polya - Problem Structure

```yaml
understanding:
  - "Unknown (cần tìm) là gì?"
  - "Data (đã có) là gì?"
  - "Conditions (ràng buộc) là gì?"
  - "Có đủ data không? Thừa? Mâu thuẫn?"

planning:
  - "Đã gặp problem tương tự chưa?"
  - "Có thể simplify problem không?"
  - "Có thể work backwards từ goal không?"
  - "Problem có thể break down như thế nào?"

verification:
  - "Kết quả có make sense không?"
  - "Có thể check bằng cách khác không?"
  - "Edge cases đã xét chưa?"
  - "Method này có thể apply cho problem khác không?"
```

---

## 3. TECHNICAL QUESTIONS

### Linus - Systems & Code Quality

```yaml
system_design:
  - "Data structures đã đúng chưa?"
  - "Control flow có clean không?"
  - "Error handling có comprehensive không?"
  - "Edge cases đã handle chưa?"

code_quality:
  - "Code có readable không? Junior có hiểu không?"
  - "Functions có single responsibility không?"
  - "Naming có reveal intent không?"
  - "Có unnecessary complexity không?"

performance:
  - "Hot path là gì?"
  - "Memory allocation pattern như thế nào?"
  - "Có race conditions không?"
  - "Scaling behavior như thế nào?"
```

### Dijkstra - Correctness

```yaml
specification:
  - "Precondition là gì?"
  - "Postcondition là gì?"
  - "Invariants cần maintain là gì?"

correctness_proof:
  - "Algorithm có đúng với MỌI input không?"
  - "Loop invariant là gì? Có được maintain không?"
  - "Algorithm có terminate không?"
  - "Có proof hay chỉ là intuition?"

complexity:
  - "Time complexity (best, avg, worst)?"
  - "Space complexity?"
  - "Constant factors có significant không?"
```

### Carmack - Performance

```yaml
measurement:
  - "Đã profile chưa? Số liệu cụ thể?"
  - "Bottleneck thực sự ở đâu?"
  - "CPU/GPU/Memory/IO bound?"
  - "Target latency/throughput là gì?"

optimization:
  - "Có algorithm tốt hơn không (Big-O improvement)?"
  - "Có thể avoid work hoàn toàn không?"
  - "Cache behavior như thế nào?"
  - "Memory access pattern có cache-friendly không?"
```

### Knuth - Algorithm Analysis

```yaml
rigor:
  - "Đã prove correctness chưa?"
  - "Exact complexity formula T(n) = ?"
  - "Average case analysis thế nào?"
  - "Đã document reasoning chưa?"

optimization_necessity:
  - "Đây có thực sự là bottleneck không?"
  - "Đã đo trước khi optimize chưa?"
  - "Optimization có làm worse maintainability không?"
  - "Có đang premature optimize không?"
```

---

## 4. DESIGN QUESTIONS

### Fowler - Architecture Trade-offs

```yaml
context:
  - "Business context là gì? Priorities?"
  - "Team size và skill level?"
  - "Timeline và budget constraints?"
  - "Existing systems cần integrate?"

trade_offs:
  - "Trade-offs của approach này là gì?"
  - "Đang optimize cho attribute nào?"
  - "Đang sacrifice điều gì?"
  - "Acceptable trade-offs với context này?"

options:
  - "Có những options nào?"
  - "Có option đơn giản hơn không?"
  - "Option nào reversible nếu sai?"
  - "Option nào buy time để learn more?"
```

### Beck - TDD & Simplicity

```yaml
test_first:
  - "Test đầu tiên nên là gì?"
  - "Behavior nào cần verify?"
  - "Expected input/output là gì?"

simplicity:
  - "Đây có phải simplest thing that works?"
  - "Có complexity không cần thiết không?"
  - "Đang build cho today hay hypothetical future?"
  - "YAGNI - Có thực sự cần feature này bây giờ?"

refactoring:
  - "Có duplication cần remove không?"
  - "Code có dễ thay đổi không?"
  - "Test có cover đủ để refactor an toàn không?"
```

### Hickey - Simplicity vs Easy

```yaml
simple_vs_easy:
  - "Điều này simple (không tangled) hay just easy (familiar)?"
  - "Complexity đang ở đâu? Essential hay accidental?"
  - "Có complecting (braiding together) không cần thiết không?"

data_thinking:
  - "Data là gì? Structure thế nào?"
  - "Transformations cần thiết là gì?"
  - "State management có cần thiết không?"

abstraction:
  - "Abstraction này hide gì? Reveal gì?"
  - "Có over-abstract không?"
  - "Abstraction có match mental model không?"
```

---

## 5. STRATEGY QUESTIONS

### Bezos - Customer & Long-term

```yaml
customer_obsession:
  - "Customer muốn gì? (không phải cần gì)"
  - "Customer journey như thế nào?"
  - "Friction points ở đâu?"
  - "Làm sao delight customer?"

working_backwards:
  - "Press release sẽ viết gì?"
  - "FAQ sẽ có những câu hỏi nào?"
  - "Nếu thành công, trông như thế nào?"

long_term:
  - "Quyết định này 10 năm sau vẫn đúng không?"
  - "Type 1 (irreversible) hay Type 2 (reversible)?"
  - "Đang optimize short-term hay long-term?"

flywheel:
  - "Flywheel components là gì?"
  - "Điều gì accelerate flywheel?"
  - "Điều gì làm slow down?"
```

### Jobs - Product Vision

```yaml
simplicity:
  - "Có thể bỏ feature nào không?"
  - "Đâu là essence của product?"
  - "User có thể hiểu ngay lập tức không?"

experience:
  - "First impression sẽ như thế nào?"
  - "Chi tiết nào tạo delight?"
  - "Unboxing experience ra sao?"

focus:
  - "Đang focus vào đúng thứ không?"
  - "Có đang nói 'no' đủ không?"
  - "Top 3 things that matter là gì?"

taste:
  - "Sẽ proud để show điều này không?"
  - "Có thỏa hiệp quality ở đâu không?"
  - "10 năm sau nhìn lại có embarrassed không?"
```

### Grove - Execution & Inflection

```yaml
strategic_inflection:
  - "Có 10x change nào đang xảy ra không?"
  - "Rules of the game có đang thay đổi không?"
  - "Đây có phải inflection point không?"

execution:
  - "OKRs có clear và measurable không?"
  - "Accountability ở đâu?"
  - "Bottleneck trong execution là gì?"

paranoia:
  - "Competitor đang làm gì?"
  - "Disruptor nào có thể xuất hiện?"
  - "Internal threat nào cần address?"
```

### Thiel - Contrarian & Monopoly

```yaml
contrarian:
  - "Điều gì bạn tin là đúng mà ít người đồng ý?"
  - "Đâu là secret mà market chưa thấy?"
  - "Consensus có đang sai không?"

zero_to_one:
  - "Đây là 0→1 (tạo mới) hay 1→n (copy)?"
  - "Có thể 10x không, hay chỉ 2x?"
  - "Đây có phải definite optimism không?"

monopoly:
  - "Competitive advantage là gì?"
  - "Có thể build monopoly không?"
  - "Moat (hào bảo vệ) là gì?"
  - "Network effects có apply không?"

timing:
  - "Tại sao NOW là đúng thời điểm?"
  - "Quá sớm hay quá muộn?"
  - "Điều gì đã change để enable điều này?"
```

### Jensen - Platform & Ecosystem

```yaml
platform:
  - "Đây là product hay platform?"
  - "Developers/partners cần gì?"
  - "Ecosystem value như thế nào?"

technology_leverage:
  - "Technology curve ở đâu?"
  - "Có thể ride wave nào?"
  - "Investment nào có highest leverage?"

scale:
  - "Có thể scale như thế nào?"
  - "Bottleneck cho scale là gì?"
  - "Network effects hoạt động ra sao?"
```

---

## 6. SYNTHESIS QUESTIONS

### Da Vinci - Connections & Elegance

```yaml
connections:
  - "Điều này connects với gì khác?"
  - "Pattern nào xuất hiện từ multiple perspectives?"
  - "Có insight nào unexpected emerge không?"

elegance:
  - "Solution có simple as possible không?"
  - "Có thể explain trong 1 câu không?"
  - "Feels natural/inevitable không?"

integration:
  - "Tất cả pieces fit together như thế nào?"
  - "Core insight tổng hợp là gì?"
  - "Action plan từ synthesis là gì?"
```

---

## Question Selection Guide

### By Problem Type

```yaml
understanding_problem:
  primary: [socrates, aristotle, feynman]
  questions_to_start:
    - "Vấn đề thực sự là gì?"
    - "Assumptions đang có là gì?"
    - "Có thể giải thích đơn giản không?"

technical_problem:
  primary: [linus, dijkstra, carmack, knuth]
  questions_to_start:
    - "Data structures đã đúng chưa?"
    - "Algorithm có provably correct không?"
    - "Đã đo performance chưa?"

design_problem:
  primary: [fowler, beck, hickey]
  questions_to_start:
    - "Trade-offs là gì?"
    - "Simplest solution là gì?"
    - "Simple hay just easy?"

strategic_problem:
  primary: [bezos, thiel, grove]
  questions_to_start:
    - "Customer muốn gì?"
    - "Đâu là contrarian bet?"
    - "Đây có phải inflection point?"
```

### By Phase

```yaml
phase_1_understand:
  questions:
    - Socrates: "Assumptions là gì?"
    - Aristotle: "Structure logic như thế nào?"
    - Feynman: "Giải thích đơn giản được không?"

phase_2_deconstruct:
  questions:
    - Musk: "First principles là gì?"
    - Feynman: "Có hiểu đủ sâu không?"

phase_3_challenge:
  questions:
    - Munger: "Làm sao để fail?"
    - Grove: "Threats là gì?"

phase_4_solve:
  questions:
    - Polya: "Plan từng bước là gì?"
    - Builders: "Technically feasible không?"

phase_5_synthesize:
  questions:
    - Da Vinci: "Core insight là gì?"
    - All: "Action plan là gì?"
```

---

## Quick Reference Card

```
┌─────────────────────────────────────────────────────────────┐
│              MASTER QUESTION BANK QUICK GUIDE                │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  5 ESSENTIAL QUESTIONS (Use Always):                         │
│  1. "Assumptions đang có là gì?" (Socrates)                 │
│  2. "First principles là gì?" (Musk)                        │
│  3. "Làm sao để CHẮC CHẮN fail?" (Munger)                  │
│  4. "Simplest solution là gì?" (Beck)                       │
│  5. "Trade-offs là gì?" (Fowler)                            │
│                                                              │
│  BY SITUATION:                                               │
│  • Unclear problem → Socrates + Feynman                      │
│  • Technical decision → Dijkstra + Carmack                   │
│  • Architecture → Fowler + Linus                             │
│  • Strategy → Bezos + Thiel + Grove                          │
│  • Product → Jobs                                            │
│  • Synthesis → Da Vinci                                      │
│                                                              │
│  RED FLAG QUESTIONS:                                         │
│  • "Tại sao mọi người đồng ý?"                              │
│  • "Đã tìm evidence AGAINST chưa?"                          │
│  • "Nếu bắt đầu lại, có chọn giống?"                        │
│  • "Có thể giải thích cho trẻ con?"                         │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

*"The important thing is not to stop questioning." - Albert Einstein*
