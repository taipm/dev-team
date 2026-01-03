# Common Weaknesses

> Điểm yếu phổ biến tìm thấy khi đánh giá agents.

---

## Overview

Dựa trên patterns từ nhiều agent reviews, đây là các weaknesses phổ biến nhất:

```
FREQUENCY OF WEAKNESSES
├── Reasoning (25%)
│   ├── Edge case handling ▓▓▓▓▓▓▓▓░░ 80%
│   ├── Circular logic     ▓▓▓▓▓░░░░░ 50%
│   └── Multi-step gaps    ▓▓▓▓▓▓░░░░ 60%
├── Knowledge (20%)
│   ├── Outdated info      ▓▓▓▓▓▓▓░░░ 70%
│   ├── Shallow depth      ▓▓▓▓▓▓░░░░ 60%
│   └── Missing examples   ▓▓▓▓▓▓▓▓░░ 80%
├── Adaptability (20%)
│   ├── No clarification   ▓▓▓▓▓▓▓▓▓░ 90%
│   ├── Poor error msgs    ▓▓▓▓▓▓▓░░░ 70%
│   └── Assumption heavy   ▓▓▓▓▓▓▓▓░░ 80%
├── Output (20%)
│   ├── Inconsistent fmt   ▓▓▓▓▓░░░░░ 50%
│   ├── Missing actionable ▓▓▓▓▓▓░░░░ 60%
│   └── Too verbose        ▓▓▓▓▓▓▓░░░ 70%
└── Compliance (15%)
    ├── Missing fields     ▓▓▓▓▓▓░░░░ 60%
    ├── Wrong structure    ▓▓▓▓░░░░░░ 40%
    └── No memory system   ▓▓▓▓▓▓▓░░░ 70%
```

---

## 1. Reasoning Weaknesses

### 1.1 Edge Case Blindness

**Problem**: Agent không xử lý được edge cases như empty input, null values, circular dependencies.

**Symptoms**:
- Crashes on empty arrays
- Infinite loops on cycles
- Wrong answers for boundary values

**Example**:
```
Input: "Sort this: []"
Bad:   "Sorted: [undefined]"
Good:  "Empty list, nothing to sort: []"
```

**Impact**: -5 to -10 points in Reasoning dimension

**Fix Pattern**:
```yaml
# Add to knowledge:
edge_cases:
  empty_input: "Check length/existence first"
  null_values: "Validate before processing"
  circular_deps: "Detect cycles before traversal"
```

---

### 1.2 Multi-step Reasoning Gaps

**Problem**: Agent giải quyết được step đầu nhưng "quên" context khi đến steps sau.

**Symptoms**:
- Correct step 1, wrong step 2+
- Loses track of constraints
- Contradicts earlier conclusions

**Example**:
```
Prompt: "A > B, B > C, C > D. Is A > D?"
Bad:   "B > C, so... (doesn't connect to A)"
Good:  "A > B > C > D by transitivity, so A > D"
```

**Impact**: -5 points in Reasoning

**Fix Pattern**:
- Add explicit "chain of thought" in persona
- Include multi-step examples in knowledge

---

### 1.3 Circular Logic

**Problem**: Agent kết luận A vì B, và B vì A.

**Symptoms**:
- Self-referential reasoning
- Tautologies as explanations
- No actual evidence

**Example**:
```
Bad:  "This is correct because it's the right approach"
Good: "This is correct because it satisfies constraints X, Y, Z"
```

**Impact**: -3 to -5 points

---

## 2. Knowledge Weaknesses

### 2.1 Outdated Information

**Problem**: Knowledge files chứa thông tin cũ, không còn relevant.

**Symptoms**:
- Recommends deprecated APIs
- References old versions
- Misses new features

**Example**:
```
Bad:  "Use componentWillMount in React" (deprecated)
Good: "Use useEffect hook for lifecycle events"
```

**Impact**: -3 to -5 points in Knowledge

**Fix Pattern**:
- Add "last_updated" to knowledge files
- Include version numbers in references

---

### 2.2 Shallow Depth

**Problem**: Knowledge chỉ ở level surface, không có deep expertise.

**Symptoms**:
- Generic answers
- Missing nuance
- No advanced patterns

**Example**:
```
Prompt: "When to use Redis vs Memcached?"
Bad:   "Both are caches"
Good:  "Redis for persistence, data structures, pub/sub. Memcached for simple key-value, multi-threaded."
```

**Impact**: -5 to -8 points

---

### 2.3 Missing Code Examples

**Problem**: Knowledge mô tả concepts nhưng không có runnable examples.

**Symptoms**:
- Theory without practice
- Users can't copy-paste
- Ambiguous implementation

**Impact**: -3 points

**Fix Pattern**:
- Every concept needs ≥1 code example
- Examples must be complete and runnable

---

## 3. Adaptability Weaknesses

### 3.1 No Clarification Protocol

**Problem**: Agent assume thay vì hỏi khi input ambiguous.

**Symptoms**:
- Wrong assumptions lead to wrong answers
- User frustration from misunderstanding
- Time wasted on wrong path

**Example**:
```
Prompt: "Fix the bug"
Bad:   *Starts modifying random code*
Good:  "Which bug? Can you share the error message or file location?"
```

**Impact**: -5 to -7 points in Adaptability

**Fix Pattern**:
```yaml
activation:
  clarification_protocol:
    - Check if prompt is ambiguous
    - If missing context, ask before acting
    - List specific questions needed
```

---

### 3.2 Poor Error Messages

**Problem**: Khi gặp lỗi, agent không cung cấp helpful information.

**Symptoms**:
- Generic "Error occurred"
- No suggestion for fix
- Missing context about what went wrong

**Example**:
```
Bad:  "Error: Something went wrong"
Good: "Error: File not found at /path/to/file.txt. Check if the path exists or try 'ls /path/to/' to list available files."
```

**Impact**: -3 to -5 points

---

### 3.3 Assumption Heavy

**Problem**: Agent làm quá nhiều assumptions mà không declare chúng.

**Symptoms**:
- Unstated requirements
- Surprise behaviors
- Hard to debug

**Example**:
```
Bad:  *Silently uses default config*
Good: "I'm assuming default config at ~/.config/app.yaml. Is this correct?"
```

**Impact**: -3 to -5 points

---

## 4. Output Weaknesses

### 4.1 Inconsistent Formatting

**Problem**: Output format thay đổi giữa các responses.

**Symptoms**:
- Sometimes markdown, sometimes plain
- Inconsistent heading levels
- Mixed list styles

**Impact**: -2 to -3 points

**Fix Pattern**:
```yaml
output:
  format: markdown
  headings: "## for sections, ### for subsections"
  lists: "- for bullets, 1. for numbered"
```

---

### 4.2 Missing Actionable Steps

**Problem**: Output mô tả vấn đề nhưng không có next steps.

**Symptoms**:
- Analysis without recommendations
- Problems without solutions
- User left hanging

**Example**:
```
Bad:  "The code has performance issues."
Good: "Performance issues found:
       1. N+1 query in line 45 → Use eager loading
       2. Missing index → Add index on user_id
       Next: Run these SQL migrations..."
```

**Impact**: -3 to -5 points

---

### 4.3 Verbosity

**Problem**: Output quá dài, không tập trung vào essentials.

**Symptoms**:
- Unnecessary repetition
- Obvious explanations
- Buried key information

**Impact**: -2 to -3 points

**Fix Pattern**:
- Lead with key information
- Use structured formats (tables, lists)
- Trim unnecessary words

---

## 5. Compliance Weaknesses

### 5.1 Missing Required Fields

**Problem**: Agent metadata thiếu required fields theo v2.0 spec.

**Common Missing Fields**:
- `language` (vi/en explicit)
- `persona.identity`
- `activation.critical`

**Impact**: -2 points per missing field

---

### 5.2 Wrong Directory Structure

**Problem**: Files không ở đúng location theo spec.

**Common Issues**:
- Knowledge outside `knowledge/`
- Missing `memory/` directory
- Workflows inline instead of external

**Impact**: -3 to -5 points

---

### 5.3 No Memory System

**Problem**: Agent không có memory implementation.

**Missing**:
- `memory/context.md`
- `memory/decisions.md`
- `memory/learnings.md`

**Impact**: -5 points

---

## Weakness Detection Checklist

```markdown
# Quick Weakness Scan

## Reasoning
- [ ] Can handle empty inputs?
- [ ] Detects circular dependencies?
- [ ] Maintains context across steps?
- [ ] Avoids logical fallacies?

## Knowledge
- [ ] All info current (check dates)?
- [ ] Has deep expertise, not just surface?
- [ ] Every concept has code example?
- [ ] References are valid?

## Adaptability
- [ ] Asks clarification for vague prompts?
- [ ] Error messages are helpful?
- [ ] States assumptions explicitly?
- [ ] Handles context switches?

## Output
- [ ] Format consistent across responses?
- [ ] Includes actionable next steps?
- [ ] Concise, not verbose?
- [ ] Well-structured (headers, lists)?

## Compliance
- [ ] All required fields present?
- [ ] Correct directory structure?
- [ ] Memory system implemented?
- [ ] Activation protocol complete?
```

---

## Severity Levels

| Level | Symbol | Score Impact | Action |
|-------|--------|--------------|--------|
| Critical | 🔴 | -10 to -15 | Must fix immediately |
| Major | 🟠 | -5 to -9 | Fix before production |
| Minor | 🟡 | -2 to -4 | Should fix |
| Advisory | 🟢 | -1 | Nice to fix |
