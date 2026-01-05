# Mental Models Library

> "You've got to have models in your head. And you've got to array your experience on this latticework of models." - Charlie Munger

---

## Overview

Thư viện Mental Models theo phong cách Charlie Munger - xây dựng "lưới" các mô hình tư duy từ nhiều lĩnh vực để có cái nhìn toàn diện và tránh bias.

---

## Core Mental Models by Domain

### Psychology & Behavioral Economics

```yaml
confirmation_bias:
  definition: "Xu hướng tìm kiếm thông tin xác nhận beliefs hiện tại"
  application: "Actively seek disconfirming evidence"
  question: "Bằng chứng nào sẽ thay đổi quyết định này?"

availability_heuristic:
  definition: "Đánh giá probability dựa trên examples dễ nhớ"
  application: "Don't confuse memorable with probable"
  question: "Data thực tế nói gì vs. what comes to mind?"

social_proof:
  definition: "Làm theo đám đông khi không chắc chắn"
  application: "Popularity ≠ correctness"
  question: "Mọi người đang follow hay actually thinking?"

loss_aversion:
  definition: "Losses hurt ~2x more than equivalent gains"
  application: "Frame decisions neutrally"
  question: "Nếu không đã có X, có chọn acquire X không?"

sunk_cost_fallacy:
  definition: "Tiếp tục vì đã đầu tư, không vì tương lai"
  application: "Only consider future costs/benefits"
  question: "Biết những gì biết bây giờ, có bắt đầu lại không?"

anchoring:
  definition: "First number heard influences all subsequent estimates"
  application: "Make estimates before hearing others'"
  question: "Estimate này dựa trên data hay first impression?"

commitment_consistency:
  definition: "Sau khi commit công khai, khó thay đổi"
  application: "Stay open to being wrong"
  question: "Có đang defend position vì ego không?"
```

### Economics & Incentives

```yaml
incentives:
  munger_quote: "Show me the incentive and I'll show you the outcome"
  application: "Look for hidden incentives behind behaviors"
  question: "Ai được lợi từ outcome này?"

opportunity_cost:
  definition: "Chi phí thực = giá trị của lựa chọn tốt nhất bị bỏ qua"
  application: "Consider what you're giving up"
  question: "Nếu không làm X, có thể làm gì với resources đó?"

comparative_advantage:
  definition: "Focus on what you do RELATIVELY better"
  application: "Don't try to be best at everything"
  question: "Điều gì tạo ra most value per unit effort?"

supply_demand:
  definition: "Price is where supply meets demand"
  application: "Scarcity increases value"
  question: "Điều gì ảnh hưởng supply và demand ở đây?"

diminishing_returns:
  definition: "Each additional unit adds less value"
  application: "Know when to stop optimizing"
  question: "Đang ở đâu trên curve? Có đáng tiếp tục?"

compound_interest:
  definition: "Small consistent gains multiply over time"
  application: "Prioritize sustainable growth"
  question: "Cái gì có thể compound? Cái gì là one-time?"
```

### Systems Thinking

```yaml
feedback_loops:
  types:
    positive: "Amplifies change (virtuous/vicious cycles)"
    negative: "Stabilizes (thermostats, regulators)"
  question: "Có feedback loop nào đang tạo behavior này?"

second_order_effects:
  definition: "Consequences of consequences"
  application: "Think beyond immediate effects"
  question: "Rồi điều gì sẽ xảy ra? Và sau đó?"

emergent_behavior:
  definition: "Complex behavior from simple rules"
  application: "System > sum of parts"
  question: "Behavior nào emerge từ interactions?"

bottlenecks:
  definition: "System limited by weakest point"
  application: "Fix bottleneck first"
  question: "Điều gì đang constrain toàn bộ system?"

leverage_points:
  definition: "Small changes with big effects"
  application: "Find high-leverage interventions"
  question: "Thay đổi nhỏ nào có impact lớn nhất?"

local_vs_global_optima:
  definition: "Best local choice ≠ best overall"
  application: "Zoom out before optimizing"
  question: "Có đang stuck ở local optimum không?"
```

### Physics & Engineering

```yaml
first_principles:
  definition: "Truths that cannot be deduced from other truths"
  application: "Reason from fundamentals, not analogies"
  question: "Đâu là điều undeniably true ở đây?"

critical_mass:
  definition: "Threshold for self-sustaining reaction"
  application: "Push past tipping point"
  question: "Cần bao nhiêu để đạt critical mass?"

entropy:
  definition: "Systems tend toward disorder"
  application: "Maintenance requires continuous effort"
  question: "Đang add order hay letting things decay?"

inertia:
  definition: "Objects resist change in motion"
  application: "Starting and stopping take energy"
  question: "Đang fight inertia hay use nó?"

margin_of_safety:
  definition: "Buffer against the unknown"
  application: "Build in redundancy"
  question: "Đủ buffer nếu assumptions sai?"
```

### Biology & Evolution

```yaml
evolution:
  definition: "Variation + Selection + Replication"
  application: "What gets selected gets more of"
  question: "Environment này đang select for what?"

adaptation:
  definition: "Organisms change to fit environment"
  application: "Adapt or die"
  question: "Đang adapt với reality hay fighting nó?"

red_queen_effect:
  definition: "Must keep running to stay in place"
  application: "Continuous improvement is table stakes"
  question: "Competition đang improve bao nhanh?"

survival_of_fittest:
  definition: "Best adapted (not strongest) survives"
  application: "Fit to environment, not generally strong"
  question: "Fit với environment này như thế nào?"

ecosystems:
  definition: "Interconnected web of dependencies"
  application: "Changes ripple through system"
  question: "Trong ecosystem này, depends on what?"
```

### Mathematics & Probability

```yaml
base_rates:
  definition: "Prior probability before new evidence"
  application: "Start with base rate, then adjust"
  question: "Base rate của điều này là bao nhiêu?"

regression_to_mean:
  definition: "Extreme results tend to be followed by average ones"
  application: "Don't overreact to outliers"
  question: "Đây là signal hay just noise/luck?"

law_of_large_numbers:
  definition: "More trials → closer to expected value"
  application: "Small samples are unreliable"
  question: "Sample size có đủ lớn không?"

pareto_principle:
  definition: "80% of effects from 20% of causes"
  application: "Focus on vital few"
  question: "20% nào tạo ra 80% value?"

normal_distribution:
  definition: "Most things cluster around average"
  application: "Extremes are rare"
  question: "Đang ở đâu trên distribution?"

power_laws:
  definition: "Few things dominate (winner take all)"
  application: "In power law domains, be #1 or niche"
  question: "Domain này follow power law không?"
```

---

## Inversion Thinking

### The Munger Method

```yaml
forward_thinking:
  question: "Làm sao để succeed?"
  limitation: "Miss blind spots"

inversion:
  question: "Làm sao để CHẮC CHẮN fail?"
  process:
    1: "List tất cả cách để fail"
    2: "Invert: avoid những cách fail đó"
    3: "What remains has higher chance of success"

example:
  goal: "Launch successful product"

  inversion_how_to_fail:
    - "Build without talking to customers"
    - "Ignore competition"
    - "Over-engineer before validating"
    - "Hire wrong people"
    - "Run out of money"

  inverted_strategy:
    - "Talk to customers first"
    - "Study competition deeply"
    - "MVP before scaling"
    - "Hire carefully"
    - "Conservative burn rate"
```

### Pre-Mortem Analysis

```yaml
process:
  step_1: "Imagine: 1 năm sau, project đã THẤT BẠI thảm hại"
  step_2: "Write story: Tại sao nó fail?"
  step_3: "List all reasons that led to failure"
  step_4: "Which of these can we prevent NOW?"

template:
  date: "[1 year from now]"
  headline: "Project X Failed Spectacularly"

  reasons_for_failure:
    technical:
      - "Architecture couldn't scale"
      - "Security breach"
      - "Integration failures"

    business:
      - "Market shifted"
      - "Competitor moved faster"
      - "Pricing wrong"

    team:
      - "Key person left"
      - "Communication breakdown"
      - "Burnout"

    external:
      - "Regulation changed"
      - "Economy crashed"
      - "Pandemic v2"

  preventive_actions:
    - "[For each reason, what can we do now?]"
```

---

## Bias Detection Checklist

### Before Making Decisions

```yaml
checklist:
  confirmation_bias:
    check: "Có tìm evidence AGAINST decision này không?"
    action: "Assign devil's advocate role"

  availability_bias:
    check: "Dựa trên data hay memorable examples?"
    action: "Look up actual statistics"

  anchoring:
    check: "First number có ảnh hưởng estimates không?"
    action: "Make estimates before seeing others'"

  sunk_cost:
    check: "Có continue vì đã invest không?"
    action: "Decide as if starting fresh"

  social_proof:
    check: "Có follow vì others doing it không?"
    action: "Think independently first"

  overconfidence:
    check: "Confidence level appropriate cho evidence?"
    action: "Ask: What would change my mind?"

  status_quo:
    check: "Có prefer current state vì comfortable không?"
    action: "Evaluate as if choosing fresh"
```

### Red Flags

```yaml
red_flags:
  - "This is obviously the right choice"
  - "Everyone agrees"
  - "We've always done it this way"
  - "The data confirms what we thought"
  - "This can't fail"
  - "There's no alternative"
  - "Trust me on this"
```

---

## Latticework Application

### Building Your Latticework

```yaml
step_1:
  action: "Learn models from multiple disciplines"
  minimum: "2-3 models per major discipline"

step_2:
  action: "Practice applying to real situations"
  method: "For each situation, ask: Which models apply?"

step_3:
  action: "Look for connections between models"
  insight: "Same underlying principle, different domains"

step_4:
  action: "Update and refine models"
  reality: "Models are approximations, improve them"
```

### Multi-Model Analysis

```yaml
example_situation: "Should we enter new market?"

models_applied:
  incentives:
    question: "What are the incentives in this market?"
    finding: "Incumbents have high switching costs"

  supply_demand:
    question: "What's supply/demand dynamic?"
    finding: "Oversupply of providers, price pressure"

  competitive_advantage:
    question: "What's our comparative advantage?"
    finding: "Technology, not market knowledge"

  red_queen:
    question: "How fast is market evolving?"
    finding: "Very fast, need constant innovation"

  pre_mortem:
    question: "How would we fail in this market?"
    finding: "Underestimate local knowledge needed"

synthesis:
  conclusion: "Enter via partnership, not direct"
  rationale: "Leverage tech advantage while gaining market knowledge"
```

---

## Quick Reference Card

```
┌─────────────────────────────────────────────────────────────┐
│               MENTAL MODELS QUICK GUIDE                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  TOP 10 MODELS TO ALWAYS CONSIDER:                           │
│  1. Incentives - "Who benefits?"                             │
│  2. Second-order effects - "Then what?"                      │
│  3. Inversion - "How to definitely fail?"                    │
│  4. Opportunity cost - "What am I giving up?"                │
│  5. Confirmation bias - "What's the counter-evidence?"       │
│  6. Base rates - "What's the prior probability?"             │
│  7. Feedback loops - "What's amplifying/dampening?"          │
│  8. Margin of safety - "What if assumptions wrong?"          │
│  9. Pareto (80/20) - "What's the vital few?"                │
│  10. Sunk cost - "Would I start this today?"                │
│                                                              │
│  INVERSION PROCESS:                                          │
│  Goal → How to fail? → Invert → Avoid failures               │
│                                                              │
│  PRE-MORTEM:                                                 │
│  "It's 1 year later and we failed. Why?"                     │
│                                                              │
│  BIAS CHECKLIST:                                             │
│  ✓ Sought disconfirming evidence?                            │
│  ✓ Used data, not just examples?                             │
│  ✓ Made independent estimate first?                          │
│  ✓ Ignored sunk costs?                                       │
│                                                              │
│  RED FLAGS:                                                  │
│  ✗ "Obviously right" ✗ "Everyone agrees"                     │
│  ✗ "Always done this way" ✗ "Can't fail"                    │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

*"Invert, always invert." - Carl Jacobi (via Charlie Munger)*
