# Thinking Methods - 5Why & 5W2H

> **5Why** và **5W2H** là PHƯƠNG PHÁP TƯ DUY để phân tích bugs.

---

## Philosophy

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         THINKING METHODS                                    │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   5W2H answers: "What exactly is the problem?"                             │
│   5Why answers: "Why does this problem exist?"                             │
│                                                                             │
│   Together: Complete understanding for effective solutions                  │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

# Part 1: 5W2H Method

## Purpose

5W2H là phương pháp tư duy để **document problem comprehensively**.

Giúp trả lời: "Chúng ta đang giải quyết vấn đề gì?"

## The 7 Questions

### WHAT - Cái gì?

```
Questions to ask:
- Bug là gì?
- Symptom là gì?
- Expected behavior là gì?
- Actual behavior là gì?
- Scope của bug là gì?
```

**Example:**
```markdown
### WHAT
- **Bug**: API trả về 500 error
- **Symptom**: Users thấy "Internal Server Error"
- **Expected**: API trả về user data JSON
- **Actual**: Panic trong handler, 500 response
- **Scope**: Ảnh hưởng endpoint /api/users/:id
```

### WHY - Tại sao?

```
Questions to ask:
- Tại sao bug này quan trọng?
- Tại sao cần fix ngay?
- Impact nếu không fix?
- Business value của fix?
```

**Example:**
```markdown
### WHY
- **Importance**: Core feature, 80% users dùng
- **Urgency**: Production down, users cannot work
- **Impact if not fixed**: Revenue loss, churn risk
- **Business value**: Restore normal operation
```

### WHERE - Ở đâu?

```
Questions to ask:
- Bug ở file nào?
- Function/method nào?
- Environment nào (dev/staging/prod)?
- Component/module nào?
- Line of code nào?
```

**Example:**
```markdown
### WHERE
- **File**: handlers/user_handler.go
- **Function**: GetUserByID()
- **Line**: 142
- **Environment**: Production
- **Component**: User Service
```

### WHEN - Khi nào?

```
Questions to ask:
- Bug xảy ra khi nào?
- First reported khi nào?
- Frequency: always/sometimes/rare?
- Trigger condition là gì?
- Sau change nào bug xuất hiện?
```

**Example:**
```markdown
### WHEN
- **Occurs**: When user ID contains special chars
- **First reported**: 2024-12-30 14:30
- **Frequency**: ~10% of requests
- **Trigger**: User ID with "+" character
- **After change**: Commit abc123 (URL decode removal)
```

### WHO - Ai?

```
Questions to ask:
- Ai report bug?
- Ai bị affect?
- Ai own code area này?
- Ai sẽ fix?
- Ai sẽ review?
```

**Example:**
```markdown
### WHO
- **Reporter**: Support team (via Jira)
- **Affected**: Enterprise customers (~500 users)
- **Code owner**: user-agent
- **Assignee**: user-agent
- **Reviewer**: backend-lead
```

### HOW - Như thế nào?

```
Questions to ask:
- Làm sao reproduce bug?
- Steps chi tiết?
- Làm sao verify fix?
- Làm sao test regression?
```

**Example:**
```markdown
### HOW
**Reproduce:**
1. Login với user có special chars trong ID
2. Navigate to profile page
3. Observe 500 error

**Verify fix:**
1. Same steps, expect profile loads
2. Check logs for no panic
3. Test với các special chars: +, %, @
```

### HOW MUCH - Bao nhiêu?

```
Questions to ask:
- Bao nhiêu users affected?
- Bao nhiêu files cần change?
- Effort estimate?
- Downtime cost?
```

**Example:**
```markdown
### HOW MUCH
- **Users affected**: ~500 enterprise users
- **Files to change**: 2 files
- **Effort**: S (1-2 hours)
- **Downtime cost**: ~$1000/hour
```

---

## 5W2H Template

```markdown
## 5W2H Analysis: BUG-{NNN}

### WHAT (Cái gì?)
- **Bug description**:
- **Expected behavior**:
- **Actual behavior**:
- **Scope**:

### WHY (Tại sao quan trọng?)
- **Business impact**:
- **User impact**:
- **Urgency**:

### WHERE (Ở đâu?)
- **File(s)**:
- **Function(s)**:
- **Line(s)**:
- **Environment**:
- **Component**:

### WHEN (Khi nào?)
- **First reported**:
- **Frequency**:
- **Trigger condition**:
- **After change**:

### WHO (Ai?)
- **Reporter**:
- **Affected users**:
- **Code owner**:
- **Assignee**:
- **Reviewer**:

### HOW (Như thế nào?)
**Steps to reproduce:**
1.
2.
3.

**Verification steps:**
1.
2.

### HOW MUCH (Bao nhiêu?)
- **Severity**:
- **Effort estimate**:
- **Files affected**:
- **Users affected**:
```

---

# Part 2: 5Why Method

## Purpose

5Why là phương pháp tư duy để **find root cause**.

Giúp trả lời: "Tại sao vấn đề này tồn tại?"

## Principle

```
Don't fix symptoms - fix root causes.

Symptom fix → Bug returns (rework)
Root cause fix → Bug eliminated (permanent)
```

## Process

```
OBSERVE symptom
    │
    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│ WHY #1: Tại sao symptom này xảy ra?                                         │
│ Answer: {immediate cause}                                                    │
└─────────────────────────────────────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│ WHY #2: Tại sao {immediate cause}?                                          │
│ Answer: {deeper cause}                                                       │
└─────────────────────────────────────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│ WHY #3: Tại sao {deeper cause}?                                             │
│ Answer: {underlying issue}                                                   │
└─────────────────────────────────────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│ WHY #4: Tại sao {underlying issue}?                                         │
│ Answer: {systemic problem}                                                   │
└─────────────────────────────────────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│ WHY #5: Tại sao {systemic problem}?                                         │
│ Answer: ROOT CAUSE (actionable)                                              │
└─────────────────────────────────────────────────────────────────────────────┘
    │
    ▼
IDENTIFY solution at root level
```

## Example

**Symptom**: API requests timing out

| # | Question | Answer |
|---|----------|--------|
| 1 | Tại sao API timeout? | Database queries slow |
| 2 | Tại sao queries slow? | Missing index on user_id |
| 3 | Tại sao missing index? | Not created in migration |
| 4 | Tại sao not in migration? | No index review process |
| 5 | Tại sao no review? | **No DB schema checklist** |

**Root Cause**: No database schema review checklist

**Solution**:
1. Add index (immediate fix)
2. Create DB schema review checklist (prevent recurrence)

---

## 5Why Best Practices

### DO

- **Focus on process/system**, not people
- **Verify each answer** before proceeding
- **Stop when actionable** - may be <5 or >5
- **Consider multiple branches** for complex bugs
- **Include data/evidence** in answers

### DON'T

- **Blame individuals** - "Bob didn't test"
- **Accept vague answers** - "It just happened"
- **Stop at symptoms** - "Network was slow"
- **Guess without evidence** - Verify first
- **Force exactly 5** - Natural stopping point

---

## 5Why Template

```markdown
## 5Why Analysis: BUG-{NNN}

**Symptom**: {What user/system observed}

**Date**: {Analysis date}
**Analyst**: {bugs-agent}

### Analysis

| # | Question | Answer | Evidence |
|---|----------|--------|----------|
| 1 | Tại sao {symptom}? | {answer1} | {log/code ref} |
| 2 | Tại sao {answer1}? | {answer2} | {log/code ref} |
| 3 | Tại sao {answer2}? | {answer3} | {log/code ref} |
| 4 | Tại sao {answer3}? | {answer4} | {log/code ref} |
| 5 | Tại sao {answer4}? | **{ROOT CAUSE}** | {evidence} |

### Root Cause
{Concise statement of root cause}

### Solutions

**Immediate fix** (address symptom):
- {what to do now}

**Root cause fix** (prevent recurrence):
- {systemic improvement}

### Verification
- [ ] Immediate fix verified
- [ ] Root cause fix implemented
- [ ] No regression in related areas
```

---

# Combined Workflow

## When to Use Each

```
NEW BUG arrives
    │
    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│ STEP 1: Apply 5W2H                                                          │
│ → Document comprehensively                                                   │
│ → Understand scope and impact                                                │
│ → Identify stakeholders                                                      │
└─────────────────────────────────────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│ STEP 2: Apply 5Why                                                          │
│ → Find root cause                                                            │
│ → Propose permanent solution                                                 │
│ → Prevent recurrence                                                         │
└─────────────────────────────────────────────────────────────────────────────┘
    │
    ▼
BUG ready for fixing (READY column)
```

## Quick Reference

| Method | Answers | Output |
|--------|---------|--------|
| **5W2H** | What is the problem? | Complete documentation |
| **5Why** | Why does problem exist? | Root cause + solution |

---

## Tips for Effective Analysis

1. **Start with 5W2H** to understand problem space
2. **Use 5Why** to dig into root cause
3. **Document everything** for future reference
4. **Timebox analysis** - don't over-analyze
5. **Validate with evidence** - logs, metrics, code
6. **Involve domain experts** when stuck
