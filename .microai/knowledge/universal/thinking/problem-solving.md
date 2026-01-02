# Problem-Solving Methodologies

> Universal problem-solving frameworks applicable to any domain.

---

## 1. Polya's 4-Step Method

George Polya's classic approach from "How to Solve It" (1945).

### Step 1: Understand the Problem

```
Questions to ask:
- What is the unknown?
- What are the data/conditions?
- Is the condition sufficient? Redundant? Contradictory?
- Can you draw a figure? Introduce notation?
- Can you separate the parts of the condition?
```

### Step 2: Devise a Plan

| Strategy | When to Use |
|----------|-------------|
| **Pattern Recognition** | Similar problem solved before |
| **Divide & Conquer** | Problem can be broken down |
| **Work Backwards** | End state is clearer than path |
| **Generalization** | Solve broader class first |
| **Specialization** | Solve simpler version first |
| **Auxiliary Elements** | Introduce helper constructs |

### Step 3: Carry Out the Plan

```
- Execute each step methodically
- Check each step as you proceed
- Prove correctness, don't assume
- Handle edge cases explicitly
```

### Step 4: Look Back (Review)

```
- Can you check the result?
- Can you derive the result differently?
- Can you use it for another problem?
- Can you simplify the solution?
```

---

## 2. PDSA Cycle (Deming Cycle)

Iterative improvement methodology.

```
    ┌─────────────┐
    │    PLAN     │
    │  (Design)   │
    └──────┬──────┘
           │
    ┌──────▼──────┐
    │     DO      │
    │ (Implement) │
    └──────┬──────┘
           │
    ┌──────▼──────┐
    │   STUDY     │
    │  (Analyze)  │
    └──────┬──────┘
           │
    ┌──────▼──────┐
    │    ACT      │
    │  (Adjust)   │
    └──────┬──────┘
           │
           └──────► (Next PLAN)
```

### PLAN
- Identify the problem
- Analyze current state
- Develop hypothesis
- Define success metrics

### DO
- Implement on small scale
- Document observations
- Collect data

### STUDY
- Compare results to expectations
- Identify learnings
- Determine root causes

### ACT
- Standardize if successful
- Adjust if not
- Start next cycle

---

## 3. Rubber Duck Debugging

Explain the problem to an inanimate object (or colleague).

### Process

1. **State the problem clearly**
   - What are you trying to do?
   - What's actually happening?

2. **Explain your code/logic line by line**
   - What does each part do?
   - Why is it there?

3. **Listen to yourself**
   - Often the explanation reveals the issue
   - "Wait, that doesn't make sense because..."

### Why It Works

- Forces verbalization of implicit assumptions
- Slows down thinking
- Activates different brain pathways
- Breaks tunnel vision

---

## 4. Divide and Conquer

Break complex problems into smaller, manageable sub-problems.

### Steps

```
1. DIVIDE: Split problem into sub-problems
           │
2. CONQUER: Solve each sub-problem
           │
3. COMBINE: Merge solutions
```

### Application Checklist

| Question | Purpose |
|----------|---------|
| Can I break this into independent parts? | Enable parallel solving |
| What's the smallest unit I can solve? | Find base case |
| How do partial solutions combine? | Design integration |
| Are sub-problems similar to main problem? | Identify recursion |

---

## 5. Root Cause Analysis (5 Whys)

Drill down to fundamental cause.

```
Problem: Server is slow
    │
    └─ Why? Database queries are slow
           │
           └─ Why? Missing indexes
                  │
                  └─ Why? Schema wasn't reviewed
                         │
                         └─ Why? No review process exists
                                │
                                └─ Why? Team unaware of importance
                                       │
                                       └─ ROOT CAUSE: Missing documentation/training
```

### Best Practices

| Do | Don't |
|----|-------|
| Focus on process | Blame people |
| Verify each answer | Assume correctness |
| Stop at actionable cause | Go too philosophical |
| Document the chain | Only note root cause |

---

## 6. Inversion

Solve the opposite problem to gain insights.

### Process

1. **Define desired outcome**: "How do I succeed?"
2. **Invert**: "How would I guarantee failure?"
3. **List failure modes**: Every way to fail
4. **Avoid those**: Prevention = success

### Example

```
Goal: Build reliable system

Inverted: How to build unreliable system?
- Skip testing
- No monitoring
- Ignore edge cases
- No backups
- Single point of failure

Solution: Do the opposite of each
```

---

## 7. Framework Selection Guide

| Problem Type | Primary Method | Secondary |
|--------------|----------------|-----------|
| **Bug/Issue** | 5 Whys | Rubber Duck |
| **Algorithm** | Polya 4-Step | Divide & Conquer |
| **Process Improvement** | PDSA | 5 Whys |
| **System Design** | Divide & Conquer | Inversion |
| **Understanding Code** | Rubber Duck | Polya Step 1 |
| **Optimization** | PDSA | Divide & Conquer |

---

## Quick Reference Card

```
Polya:     Understand → Plan → Execute → Review
PDSA:      Plan → Do → Study → Act → (repeat)
5 Whys:    Problem → Why? (5x) → Root Cause
Inversion: Success → How to fail? → Avoid
D&C:       Divide → Conquer → Combine
```

---

*Knowledge Forge: Universal Layer*
*Applicable to: All agents, all domains*
