# 7 Phương pháp Tư duy Cốt lõi

> Tài liệu chi tiết về 7 framework tư duy mà Deep Question Agent sử dụng.

---

## 1. Socratic Questioning (Phương pháp Socrates)

### Triết lý
Socrates tin rằng wisdom không đến từ việc có câu trả lời, mà từ việc biết đặt câu hỏi đúng. Phương pháp này dẫn dắt người khác tự khám phá truth thông qua dialogue có định hướng.

### 5 Lớp Câu hỏi

#### Layer 1: Clarification (Làm rõ)
**Mục đích:** Đảm bảo hiểu đúng vấn đề trước khi đào sâu.

| Câu hỏi | Khi nào dùng |
|---------|--------------|
| "Bạn có thể giải thích thêm về...?" | Khi statement mơ hồ |
| "Ý bạn là gì khi nói...?" | Khi dùng từ có nhiều nghĩa |
| "Bạn có thể cho một ví dụ cụ thể?" | Khi concept quá abstract |
| "Điều này có nghĩa gì trong context của bạn?" | Khi cần context cụ thể |

#### Layer 2: Probing Assumptions (Thăm dò giả định)
**Mục đích:** Phát hiện những gì được taken for granted.

| Câu hỏi | Khi nào dùng |
|---------|--------------|
| "Tại sao bạn assume rằng...?" | Khi nghe implicit assumption |
| "Điều gì sẽ xảy ra nếu ngược lại?" | Để test assumption |
| "Giả định này dựa trên điều gì?" | Để trace origin |
| "Ai khác cũng assume như vậy? Tại sao?" | Để check validity |

#### Layer 3: Probing Evidence (Thăm dò bằng chứng)
**Mục đích:** Verify claims với facts.

| Câu hỏi | Khi nào dùng |
|---------|--------------|
| "Làm sao bạn biết điều này đúng?" | Khi claim chưa được verify |
| "Evidence nào support điều này?" | Để đòi hỏi proof |
| "Có data nào contradict không?" | Để check bias |
| "Nguồn thông tin này từ đâu?" | Để verify reliability |

#### Layer 4: Questioning Viewpoints (Đặt câu hỏi về góc nhìn)
**Mục đích:** Mở rộng perspective.

| Câu hỏi | Khi nào dùng |
|---------|--------------|
| "Có perspective nào khác không?" | Để mở rộng thinking |
| "Người X sẽ nghĩ gì về điều này?" | Để simulate other views |
| "Tại sao người khác có thể không đồng ý?" | Để anticipate objections |
| "Nếu bạn là [role], bạn sẽ nghĩ sao?" | Để shift perspective |

#### Layer 5: Probing Implications (Thăm dò hệ quả)
**Mục đích:** Think through consequences.

| Câu hỏi | Khi nào dùng |
|---------|--------------|
| "Nếu điều này đúng, thì...?" | Để trace implications |
| "Consequences của decision này là gì?" | Để think ahead |
| "Điều này ảnh hưởng đến X như thế nào?" | Để check ripple effects |
| "5 năm sau, điều này dẫn đến đâu?" | Long-term thinking |

### Workflow

```
START với Layer 1 (Clarification)
     │
     ├── Nếu clear → Layer 2 (Assumptions)
     │
     ├── Nếu phát hiện assumption → Layer 3 (Evidence)
     │
     ├── Nếu có evidence → Layer 4 (Viewpoints)
     │
     └── Khi đủ perspectives → Layer 5 (Implications)
```

---

## 2. First Principles Thinking (Tư duy Nguyên lý Gốc)

### Triết lý
"Boil things down to the most fundamental truths and reason up from there." — Elon Musk

Phương pháp này phá vỡ conventional wisdom bằng cách quay về những sự thật cơ bản nhất và rebuild solutions từ đó.

### 3 Bước Cốt lõi

#### Step 1: Identify Assumptions
**Mục đích:** List ra mọi thứ đang được assumed.

```
Câu hỏi then chốt:
- "Mọi người thường assume gì về vấn đề này?"
- "Industry standard nào đang được follow? Tại sao?"
- "Điều gì được coi là 'không thể' ở đây?"
```

**Phân loại Assumptions:**

| Loại | Định nghĩa | Ví dụ | Thay đổi được? |
|------|------------|-------|----------------|
| **Fundamental Laws** | Vật lý, toán, logic | Speed of light | Không |
| **Current Constraints** | Technology, regulations | Battery density | Có thể |
| **Conventions** | Industry norms, traditions | "Website cần nav bar" | Chắc chắn |

#### Step 2: Break Down to Fundamentals
**Mục đích:** Tìm ra những sự thật không thể tranh cãi.

```
Câu hỏi then chốt:
- "Những sự thật cơ bản nhất là gì?"
- "Điều gì là TRUE regardless of conventions?"
- "Physical/mathematical constraints thực sự là gì?"
```

#### Step 3: Rebuild from Scratch
**Mục đích:** Construct solutions chỉ từ fundamentals.

```
Câu hỏi then chốt:
- "Nếu bắt đầu từ zero, chúng ta sẽ làm thế nào?"
- "Biết những fundamentals này, approach tốt nhất là gì?"
- "Có solution nào bị bỏ qua vì 'không ai làm vậy'?"
```

### Ví dụ: Battery Cost

| Stage | Content |
|-------|---------|
| **Industry assumption** | "Batteries cost $600/kWh, that's just the price" |
| **Identify components** | Carbon, nickel, aluminum, polymers, steel |
| **First principles** | Material cost on exchange: ~$80/kWh |
| **Insight** | 7x markup do manufacturing process, not materials |
| **Solution** | Optimize manufacturing, not accept "market price" |

---

## 3. 5 Whys (5 Tại sao)

### Triết lý
Developed by Toyota, phương pháp này tin rằng hầu hết problems chỉ cần 5 lần hỏi "Tại sao?" để tìm ra root cause.

### Quy trình

```
Problem stated
     │
     └→ Why? ─────────────────→ Surface reason
           │
           └→ Why? ───────────→ Deeper reason
                 │
                 └→ Why? ─────→ Even deeper
                       │
                       └→ Why? → Getting to core
                             │
                             └→ Why? → ROOT CAUSE ✓
```

### Ví dụ: Server Outage

```
Problem: Server bị down

Why 1: Tại sao server down?
→ Memory exhausted

Why 2: Tại sao memory exhausted?
→ Memory leak trong application

Why 3: Tại sao có memory leak?
→ Objects không được garbage collected

Why 4: Tại sao không được GC?
→ Circular references trong cache

Why 5: Tại sao có circular references?
→ Không có cache eviction policy

ROOT CAUSE: Missing cache management strategy
```

### Best Practices

| Do | Don't |
|----|-------|
| Focus on process/system | Blame người |
| Verify mỗi answer trước khi hỏi tiếp | Assume answer đúng |
| Stop khi có actionable root cause | Hỏi quá deep (philosophical) |
| Document cả chain | Chỉ note root cause |

---

## 4. 6W2H Framework

### Triết lý
Đảm bảo coverage đầy đủ mọi khía cạnh của vấn đề bằng cách systematically hỏi 8 câu hỏi cơ bản.

### 8 Câu hỏi

| # | Question | Vietnamese | Purpose |
|---|----------|------------|---------|
| 1 | **What** | Cái gì? | Define scope, identify object |
| 2 | **Why** | Tại sao? | Understand motivation, purpose |
| 3 | **Who** | Ai? | Identify stakeholders, owners |
| 4 | **Where** | Ở đâu? | Locate context, environment |
| 5 | **When** | Khi nào? | Timing, deadlines, sequence |
| 6 | **Which** | Cái nào? | Alternatives, options, choices |
| 7 | **How** | Như thế nào? | Process, method, approach |
| 8 | **How much** | Bao nhiêu? | Scale, resources, cost |

### Ví dụ: Feature Request

| Question | Application |
|----------|-------------|
| **What** | Feature cụ thể là gì? Core functionality? |
| **Why** | Vì sao cần? Business value? |
| **Who** | Ai dùng? Ai affected? Ai build? |
| **Where** | Ở đâu trong product? Platform nào? |
| **When** | Timeline? Dependencies? Phased rollout? |
| **Which** | Approach nào? Tech stack nào? |
| **How** | Implementation như thế nào? Testing? |
| **How much** | Effort? Cost? Resources needed? |

---

## 5. Pre-mortem Analysis

### Triết lý
Thay vì chờ failure xảy ra rồi post-mortem, hãy imagine failure TRƯỚC và identify causes.

"Imagine it's 6 months from now. The project has FAILED spectacularly. What went wrong?"

### Quy trình

```
1. IMAGINE: Project đã thất bại hoàn toàn
     │
2. BRAINSTORM: Điều gì đã xảy ra?
     │
3. IDENTIFY: Dấu hiệu cảnh báo nào bị ignore?
     │
4. TRACE: Assumption nào sai?
     │
5. ANALYZE: Điều gì bị underestimate?
     │
6. EXTERNAL: Yếu tố bên ngoài nào gây hại?
     │
7. MITIGATE: Làm gì để prevent?
```

### Câu hỏi then chốt

| Category | Questions |
|----------|-----------|
| **Failure modes** | Cách nào project có thể fail? |
| **Warning signs** | Dấu hiệu nào cần watch? |
| **Assumptions** | Assumption nào nếu sai sẽ kill project? |
| **Underestimates** | Điều gì thường bị underestimate? |
| **Dependencies** | Dependency nào critical nhất? |
| **External** | Yếu tố ngoài control nào dangerous? |

### Output Format

```yaml
pre_mortem:
  failure_scenario: "..."
  likely_causes:
    - cause: "..."
      probability: "high|medium|low"
      impact: "catastrophic|significant|moderate"
      mitigation: "..."
  warning_signs:
    - sign: "..."
      monitoring: "..."
  critical_assumptions:
    - assumption: "..."
      validation_method: "..."
```

---

## 6. Devil's Advocate

### Triết lý
Chủ động challenge ideas bằng cách argue cho opposite position. Tìm holes trong logic trước khi reality finds them.

### 5-Step Protocol

#### Step 1: State Opposite Position
```
"Để tôi argue cho điều ngược lại..."
"Giả sử approach này hoàn toàn sai..."
```

#### Step 2: Find 3 Supporting Reasons
```
"3 lý do tại sao ngược lại có thể đúng:"
1. ...
2. ...
3. ...
```

#### Step 3: Find Evidence
```
"Evidence nào support quan điểm ngược?"
- Historical examples
- Data points
- Expert opinions
```

#### Step 4: Consider "What If Wrong?"
```
"Nếu chúng ta hoàn toàn sai, hậu quả là gì?"
- Immediate impact
- Long-term consequences
- Recovery difficulty
```

#### Step 5: Propose Safeguards
```
"Dù chọn cách nào, safeguards nào cần có?"
- Fallback plans
- Early warning systems
- Exit strategies
```

### Stress Testing Matrix

| Scenario | Question |
|----------|----------|
| 10x scale | "Nếu traffic tăng 10x?" |
| Key person quits | "Nếu [expert] nghỉ việc?" |
| Dependency fails | "Nếu [service] down?" |
| Requirement flip | "Nếu yêu cầu thay đổi 180°?" |
| Budget cut 50% | "Nếu mất nửa budget?" |
| Timeline halved | "Nếu deadline gấp đôi?" |

---

## 7. Feynman Technique

### Triết lý
"If you can't explain it simply, you don't understand it well enough." — Richard Feynman

Phương pháp này test understanding bằng cách yêu cầu giải thích cho người không chuyên.

### 4 Bước

#### Step 1: Choose Concept
```
"Bạn muốn giải thích điều gì?"
```

#### Step 2: Explain Simply
```
"Giải thích như cho một người hoàn toàn mới."
- Không jargon
- Không assume prior knowledge
- Dùng analogies đơn giản
```

#### Step 3: Identify Gaps
```
"Phần nào bạn struggle để explain?"
→ Gap trong explanation = gap trong understanding
```

#### Step 4: Review & Simplify
```
"Làm sao để đơn giản hơn nữa?"
- Shorter sentences
- Better analogies
- Clearer structure
```

### Câu hỏi Test

| Question | Purpose |
|----------|---------|
| "Giải thích cho bà của bạn?" | Test simplicity |
| "Giải thích cho đứa trẻ 10 tuổi?" | Remove jargon |
| "Dùng analogy từ đời thường?" | Test understanding depth |
| "Tóm gọn trong 1 câu?" | Force clarity |
| "Phần nào khó explain nhất?" | Find knowledge gaps |

---

## Framework Selection Guide

### By Topic Type

| Topic | Primary | Secondary | Why |
|-------|---------|-----------|-----|
| **Code/Architecture** | 6W2H | First Principles | Full coverage + challenge conventions |
| **Bug/Problem** | 5 Whys | Socratic | Root cause + understand deeply |
| **Decision/Strategy** | Pre-mortem | Devil's Advocate | Anticipate failure + test robustness |
| **Learning/Understanding** | Feynman | Socratic | Test depth + clarify gaps |
| **Planning/Project** | Pre-mortem | 6W2H | Risk awareness + coverage |
| **Innovation/Design** | First Principles | Devil's Advocate | Break conventions + stress test |

### By Situation

| Situation | Framework | Rationale |
|-----------|-----------|-----------|
| "Tôi không hiểu vấn đề" | Socratic L1-L3 | Clarify before deep dive |
| "Giải pháp có vẻ quá obvious" | First Principles | Challenge conventions |
| "Bug keeps coming back" | 5 Whys | Find true root cause |
| "Thiếu thông tin" | 6W2H | Systematic coverage |
| "Rủi ro cao" | Pre-mortem | Anticipate failures |
| "Team quá confident" | Devil's Advocate | Challenge groupthink |
| "Explain cho stakeholders" | Feynman | Force clarity |

---

## Combining Frameworks

### Recommended Combinations

```
COMPREHENSIVE ANALYSIS
├── Start: 6W2H (full coverage)
├── Deep: 5 Whys (root causes)
├── Challenge: Devil's Advocate (stress test)
└── Conclude: Pre-mortem (risk awareness)

PROBLEM SOLVING
├── Start: Socratic L1 (clarify)
├── Deep: 5 Whys (root cause)
├── Verify: Feynman (confirm understanding)
└── Plan: Pre-mortem (prevent recurrence)

INNOVATION
├── Start: First Principles (break conventions)
├── Test: Devil's Advocate (challenge new idea)
├── Verify: Feynman (can we explain simply?)
└── Risk: Pre-mortem (what could go wrong?)
```

---

*Document này là knowledge base cho Deep Question Agent. Load theo topic type và combine frameworks khi cần.*
