# Question Context

> Trạng thái của Question Bank qua các sessions

---

## Question Bank Status

```yaml
bank:
  version: "1.0"
  total_questions: 32
  categories: 9
```

---

## Answered Questions

*Câu hỏi đã được trả lời (tất cả sessions)*

| ID | Category | Question | Session | Confidence |
|----|----------|----------|---------|------------|
<!-- Answered questions will be logged here -->

<!-- Template:
| arch-01 | architecture | Codebase pattern? | session-001 | HIGH |
-->

---

## Pending Questions

*Câu hỏi chưa được trả lời*

| ID | Category | Question | Depth | Blocked By |
|----|----------|----------|-------|------------|
<!-- All questions start as pending -->

---

## Skipped Questions

*Câu hỏi bị bỏ qua với lý do*

| ID | Question | Session | Reason |
|----|----------|---------|--------|
<!-- Skipped questions with reasons -->

---

## Derived Questions

*Câu hỏi được sinh ra từ quá trình discovery*

| ID | Question | Parent | Session | Status |
|----|----------|--------|---------|--------|
<!-- Derived questions -->

<!-- Template:
| derived-001 | Cache invalidation? | arch-03 | session-001 | pending |
-->

---

## Dependencies

### Resolved

*Dependencies đã được resolve (prerequisites answered)*

| Question | Prerequisite | Resolved In |
|----------|--------------|-------------|
<!-- Resolved dependencies -->

### Unresolved

*Dependencies chưa resolve*

| Question | Waiting For |
|----------|-------------|
<!-- Unresolved dependencies -->

---

## Statistics

| Status | Count |
|--------|-------|
| Answered | 0 |
| Pending | 32 |
| Skipped | 0 |
| Derived | 0 |

---

*Last updated: Never*
