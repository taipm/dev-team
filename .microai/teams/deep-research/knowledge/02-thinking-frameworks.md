# Thinking Frameworks for Research Analysis

## Overview

7 phương pháp tư duy cốt lõi để phân tích papers một cách toàn diện và sâu sắc. Mỗi framework cung cấp một góc nhìn khác nhau, kết hợp lại tạo thành bức tranh hoàn chỉnh.

---

## Framework 1: First Principles Thinking

### Nguồn gốc
- **Aristotle**: "First principles are the first basis from which a thing is known"
- **Descartes**: Phương pháp hoài nghi có hệ thống
- **Elon Musk**: "Boil things down to the most fundamental truths and reason up from there"
- **Richard Feynman**: "The first principle is that you must not fool yourself"

### Quy trình

```
┌─────────────────────────────────────────────────┐
│ 1. IDENTIFY CLAIMS                              │
│    → What does the paper claim?                 │
└────────────────────┬────────────────────────────┘
                     ▼
┌─────────────────────────────────────────────────┐
│ 2. DECOMPOSE TO ASSUMPTIONS                     │
│    → What must be true for claims to hold?      │
└────────────────────┬────────────────────────────┘
                     ▼
┌─────────────────────────────────────────────────┐
│ 3. CLASSIFY ASSUMPTIONS                         │
│    → Fundamental Law / Convention / Arbitrary   │
└────────────────────┬────────────────────────────┘
                     ▼
┌─────────────────────────────────────────────────┐
│ 4. VERIFY FUNDAMENTALS                          │
│    → Are the "fundamentals" actually true?      │
└────────────────────┬────────────────────────────┘
                     ▼
┌─────────────────────────────────────────────────┐
│ 5. REBUILD UNDERSTANDING                        │
│    → What follows from verified truths only?    │
└─────────────────────────────────────────────────┘
```

### Assumption Categories

| Category | Definition | Example | Can Change? |
|----------|------------|---------|-------------|
| **Fundamental Law** | Physics, math, logic | "Attention is O(n²) in sequence length" | No |
| **Current Constraint** | Technology, resources | "GPUs have limited memory" | Slowly |
| **Convention** | Industry practice | "Papers must beat SOTA" | Yes |
| **Arbitrary** | Historical accident | "Batch size = 32" | Easily |

### Application to Papers

```yaml
for_each_major_claim:
  1. Extract the claim verbatim
  2. List assumptions (explicit and implicit)
  3. Classify each assumption
  4. Challenge conventions: "What if we didn't do X?"
  5. Verify fundamentals: "Is this actually a hard constraint?"

output:
  assumptions_map:
    claim_1:
      - assumption: "Large batch sizes are needed"
        type: convention
        challenge: "What if we used gradient accumulation?"
      - assumption: "More parameters = more capacity"
        type: fundamental
        verified: true
```

### Red Flags to Watch

- Treating conventions as fundamentals
- Assuming current tech limits are permanent
- Not questioning "obvious" requirements
- Confusing correlation with causation

---

## Framework 2: Socratic Questioning

### 5 Layers of Depth

```
Layer 1: CLARIFICATION
"Chính xác thì paper này nói gì?"
├── What exactly is the problem being solved?
├── What is the proposed solution, stripped of jargon?
├── What are the key terms? Are they well-defined?
└── What would success look like?

Layer 2: PROBING ASSUMPTIONS
"Paper giả định gì?"
├── What assumptions underlie the approach?
├── What is taken for granted without justification?
├── What if the opposite were true?
└── Are there hidden assumptions in the methodology?

Layer 3: PROBING EVIDENCE
"Bằng chứng có đủ không?"
├── What evidence supports the main claims?
├── How strong is this evidence?
├── Are there alternative explanations for the results?
├── What experiments are missing?
└── Are the baselines fair and up-to-date?

Layer 4: QUESTIONING VIEWPOINTS
"Còn cách nhìn nào khác?"
├── What alternative approaches exist?
├── Why didn't they try approach X?
├── How would others in the field view this?
├── What criticisms might reviewers raise?
└── Is there a simpler solution?

Layer 5: PROBING IMPLICATIONS
"Nếu đúng thì sao?"
├── If this works, what changes?
├── What are the practical implications?
├── What new problems does this create?
├── What doors does this open/close?
└── What are the ethical implications?
```

### Question Templates

```yaml
clarification:
  - "Bạn có thể giải thích {X} một cách đơn giản hơn?"
  - "Khi nói {term}, chính xác ý là gì?"
  - "Ví dụ cụ thể của {concept} là gì?"

assumptions:
  - "Tại sao assume rằng {X} đúng?"
  - "Điều gì xảy ra nếu {X} không đúng?"
  - "Có evidence nào cho assumption này?"

evidence:
  - "Làm sao biết {claim} là đúng?"
  - "Experiment nào prove điều này?"
  - "Có thể có explanation khác không?"

viewpoints:
  - "Người khác sẽ approach problem này thế nào?"
  - "Có counterargument nào cho approach này?"
  - "Community sẽ react thế nào?"

implications:
  - "Nếu đúng, điều gì thay đổi trong practice?"
  - "Long-term impact là gì?"
  - "Consequences không lường trước?"
```

---

## Framework 3: The 5 Whys

### Origin
Toyota Production System - root cause analysis technique

### Process

```
SURFACE OBSERVATION
       │
       ▼
┌──────────────────────────────────┐
│ WHY 1: Tại sao problem này?      │
│ → Câu trả lời thường obvious     │
└───────────────┬──────────────────┘
                ▼
┌──────────────────────────────────┐
│ WHY 2: Tại sao answer 1?         │
│ → Đi sâu hơn một level          │
└───────────────┬──────────────────┘
                ▼
┌──────────────────────────────────┐
│ WHY 3: Tại sao answer 2?         │
│ → Bắt đầu thấy patterns          │
└───────────────┬──────────────────┘
                ▼
┌──────────────────────────────────┐
│ WHY 4: Tại sao answer 3?         │
│ → Approaching root cause         │
└───────────────┬──────────────────┘
                ▼
┌──────────────────────────────────┐
│ WHY 5: Tại sao answer 4?         │
│ → Root cause / Core motivation   │
└──────────────────────────────────┘
```

### Application to Research Papers

```yaml
example_paper: "Efficient Transformers via Sparse Attention"

why_1: "Tại sao họ nghiên cứu efficient transformers?"
answer_1: "Vì standard attention quá costly"

why_2: "Tại sao standard attention costly?"
answer_2: "Vì O(n²) complexity với sequence length"

why_3: "Tại sao O(n²) là problem?"
answer_3: "Vì long sequences cần cho nhiều applications"

why_4: "Tại sao cần long sequences?"
answer_4: "Vì context length = reasoning capability"

why_5: "Tại sao context = reasoning?"
answer_5: "Vì many tasks require integrating distant information"

root_insight: |
  Core motivation là expanding what problems can be solved,
  không chỉ là making current tasks faster.
```

### Common Patterns

| Why Level | Typical Insight |
|-----------|-----------------|
| Why 1 | Technical problem statement |
| Why 2 | Root technical cause |
| Why 3 | Architectural constraint |
| Why 4 | Fundamental limitation |
| Why 5 | Core research motivation / value proposition |

---

## Framework 4: 6W2H Analysis

### Complete Coverage Framework

```
┌─────────────────────────────────────────────────────────────┐
│                         6W2H                                 │
├──────────────┬──────────────────────────────────────────────┤
│ WHAT         │ What is being done? What is the output?      │
├──────────────┼──────────────────────────────────────────────┤
│ WHY          │ Why is this important? Why now?              │
├──────────────┼──────────────────────────────────────────────┤
│ WHO          │ Who benefits? Who are the authors?           │
├──────────────┼──────────────────────────────────────────────┤
│ WHERE        │ Where applicable? Which domain?              │
├──────────────┼──────────────────────────────────────────────┤
│ WHEN         │ When relevant? Timing significance?          │
├──────────────┼──────────────────────────────────────────────┤
│ WHICH        │ Which approach chosen? Which tradeoffs?      │
├──────────────┼──────────────────────────────────────────────┤
│ HOW          │ How does it work? How to reproduce?          │
├──────────────┼──────────────────────────────────────────────┤
│ HOW MUCH     │ How much improvement? How much cost?         │
└──────────────┴──────────────────────────────────────────────┘
```

### Detailed Questions per Dimension

```yaml
WHAT:
  content:
    - "Paper làm gì cụ thể?"
    - "Novel contribution là gì?"
    - "Artifacts tạo ra: model, dataset, framework?"
  output:
    - "Deliverables chính là gì?"
    - "Có code/data release không?"

WHY:
  motivation:
    - "Tại sao problem này quan trọng?"
    - "Gap nào trong existing work?"
  timing:
    - "Tại sao bây giờ mới possible/relevant?"
    - "Depends on gì mới có gần đây?"

WHO:
  beneficiaries:
    - "Ai sẽ dùng work này?"
    - "Industry hay academia?"
  authors:
    - "Authors có track record trong area này?"
    - "Institutional backing?"

WHERE:
  domain:
    - "Applicable cho domains nào?"
    - "Limitations về context?"
  scope:
    - "Generalize được không?"
    - "Domain-specific assumptions?"

WHEN:
  temporal:
    - "Builds on work từ khi nào?"
    - "Predictions cho timeline adoption?"
  relevance:
    - "Sẽ còn relevant trong bao lâu?"
    - "Risk of obsolescence?"

WHICH:
  choices:
    - "Chọn approach nào trong alternatives?"
    - "Tại sao không approach khác?"
  tradeoffs:
    - "Tradeoffs được explicit acknowledge?"
    - "Hidden costs?"

HOW:
  methodology:
    - "Technical approach chi tiết?"
    - "Key innovations trong method?"
  reproducibility:
    - "Có đủ details để reproduce?"
    - "Hardware/software requirements?"

HOW_MUCH:
  improvements:
    - "Cải thiện bao nhiêu % so với baseline?"
    - "Metrics nào được improve?"
  costs:
    - "Computational cost?"
    - "Data requirements?"
    - "Engineering effort to adopt?"
```

---

## Framework 5: Pre-mortem Analysis

### Concept
Giả định project/paper ĐÃ THẤT BẠI, sau đó phân tích ngược: "Điều gì đã xảy ra?"

### Process

```
┌─────────────────────────────────────────────────────────────┐
│ IMAGINE: "6 tháng sau, paper này bị coi là failure. Tại sao?" │
└──────────────────────────┬──────────────────────────────────┘
                           ▼
┌─────────────────────────────────────────────────────────────┐
│ BRAINSTORM FAILURE MODES                                     │
│ - Methodological flaws?                                      │
│ - Reproducibility issues?                                    │
│ - Better alternatives emerged?                               │
│ - Assumptions proved wrong?                                  │
│ - Didn't scale in practice?                                  │
└──────────────────────────┬──────────────────────────────────┘
                           ▼
┌─────────────────────────────────────────────────────────────┐
│ ASSESS PROBABILITY & IMPACT                                  │
│ - P(failure mode) = ?                                        │
│ - Impact if it happens = ?                                   │
└──────────────────────────┬──────────────────────────────────┘
                           ▼
┌─────────────────────────────────────────────────────────────┐
│ IDENTIFY MITIGATIONS                                         │
│ - How would we verify/prevent each failure mode?             │
└─────────────────────────────────────────────────────────────┘
```

### Failure Categories for Research Papers

```yaml
methodological_failures:
  - "Experiments có fundamental flaw"
  - "Evaluation metrics misleading"
  - "Hyperparameters cherry-picked"
  - "Training data contamination"
  - "Statistical significance not established"

reproducibility_failures:
  - "Missing implementation details"
  - "Random seeds not fixed"
  - "Hardware-specific optimizations"
  - "Undocumented preprocessing"
  - "Dependencies version issues"

practical_failures:
  - "Doesn't scale to real-world sizes"
  - "Requires unavailable resources"
  - "Too slow for production"
  - "Edge cases not handled"
  - "Integration complexity too high"

theoretical_failures:
  - "Proofs have gaps"
  - "Assumptions too strong"
  - "Bounds too loose to be useful"
  - "Counter-examples exist"

external_failures:
  - "Better approach published soon after"
  - "Field direction shifted"
  - "Underlying technology changed"
  - "Ethical concerns emerged"
```

### Risk Assessment Matrix

| Risk | Probability | Impact | Priority | Mitigation |
|------|-------------|--------|----------|------------|
| High P, High I | Critical | Must address immediately |
| High P, Low I | Monitor | Track but don't block |
| Low P, High I | Prepare | Have contingency plan |
| Low P, Low I | Ignore | Not worth attention |

---

## Framework 6: Devil's Advocate

### Purpose
Deliberately take the opposite position to stress-test ideas

### Protocol

```yaml
for_each_major_claim:
  step_1: "State the claim clearly"
  step_2: "Formulate the strongest possible counter-argument"
  step_3: "Find evidence that supports the counter-argument"
  step_4: "Assess: does the original claim survive?"
  step_5: "If yes, document why. If no, document the weakness."
```

### Challenge Templates

```yaml
claim_challenges:
  - "Điều ngược lại có thể đúng không?"
  - "Ai sẽ disagree và tại sao?"
  - "Evidence nào sẽ disprove claim này?"
  - "Có selection bias trong evidence không?"

methodology_challenges:
  - "Có simpler approach achieve same results không?"
  - "Baselines có outdated không?"
  - "Ablations có sufficient không?"
  - "Metrics có gaming được không?"

impact_challenges:
  - "So what? Điều này matter thế nào?"
  - "Ai actually care về improvement này?"
  - "Có cheaper way to get similar results?"
  - "5 năm nữa còn relevant không?"
```

### Constructive Criticism Framework

```
┌─────────────────────────────────────────────────────────────┐
│ NOT: "This paper is wrong"                                   │
│ BUT: "Under what conditions would this NOT work?"            │
├─────────────────────────────────────────────────────────────┤
│ NOT: "This is a bad idea"                                    │
│ BUT: "What would make this idea fail in practice?"           │
├─────────────────────────────────────────────────────────────┤
│ NOT: "The authors missed X"                                  │
│ BUT: "What if X were also considered?"                       │
└─────────────────────────────────────────────────────────────┘
```

---

## Framework 7: Feynman Technique

### Core Principle
"If you can't explain it simply, you don't understand it well enough."

### Process

```
┌─────────────────────────────────────────────────────────────┐
│ 1. CHOOSE CONCEPT                                            │
│    → Select the core contribution of the paper               │
└──────────────────────────┬──────────────────────────────────┘
                           ▼
┌─────────────────────────────────────────────────────────────┐
│ 2. EXPLAIN TO A CHILD                                        │
│    → Write explanation in simple language                    │
│    → No jargon, no equations                                 │
│    → Use analogies from everyday life                        │
└──────────────────────────┬──────────────────────────────────┘
                           ▼
┌─────────────────────────────────────────────────────────────┐
│ 3. IDENTIFY GAPS                                             │
│    → Where did you struggle to explain?                      │
│    → What required falling back to jargon?                   │
└──────────────────────────┬──────────────────────────────────┘
                           ▼
┌─────────────────────────────────────────────────────────────┐
│ 4. RE-STUDY AND SIMPLIFY                                     │
│    → Go back to the paper for those gaps                     │
│    → Really understand, then try again                       │
└──────────────────────────┬──────────────────────────────────┘
                           ▼
┌─────────────────────────────────────────────────────────────┐
│ 5. FINAL EXPLANATION                                         │
│    → Crystal clear 3-sentence summary                        │
│    → Anyone can understand                                   │
└─────────────────────────────────────────────────────────────┘
```

### Templates

```yaml
3_sentence_template:
  sentence_1: "Problem/motivation in everyday terms"
  sentence_2: "Key insight/solution in simple analogy"
  sentence_3: "Why this matters / what changes"

example:
  paper: "Attention Is All You Need"
  explanation: |
    Sentence 1: "When reading a long text, you naturally focus more on some words
    than others depending on what you're looking for - that's attention."

    Sentence 2: "This paper showed that instead of reading word by word like
    traditional methods, we can let a model look at all words at once and
    learn which ones to focus on for any given task."

    Sentence 3: "This made language models much faster to train and eventually
    led to ChatGPT and other AI that can understand and generate text."
```

### Analogy Bank for Common Concepts

| Concept | Analogy |
|---------|---------|
| Attention | Spotlight on a stage |
| Embedding | Fingerprint for words |
| Transformer | Assembly line with quality control |
| GAN | Counterfeiter vs Detective |
| Reinforcement Learning | Training a dog with treats |
| Fine-tuning | Teaching specialist skills to a generalist |
| Prompt Engineering | Giving clear instructions to a new employee |

---

## Framework Selection Guide

### When to Use Which

| Situation | Primary Framework | Supporting |
|-----------|-------------------|------------|
| Understanding claims | First Principles | 5 Whys |
| Evaluating evidence | Socratic L3 | Devil's Advocate |
| Comprehensive coverage | 6W2H | Socratic All |
| Risk assessment | Pre-mortem | Devil's Advocate |
| Testing understanding | Feynman | Socratic L1 |
| Root cause analysis | 5 Whys | First Principles |
| Challenging ideas | Devil's Advocate | Pre-mortem |

### Minimum Viable Analysis

Khi thời gian limited, luôn dùng:
1. **Feynman** - Test understanding
2. **5 Whys** - Find root motivation
3. **Pre-mortem** - Identify risks

### Deep Dive Analysis

Khi cần thorough analysis:
1. All 7 frameworks
2. Multiple passes
3. Cross-framework synthesis
