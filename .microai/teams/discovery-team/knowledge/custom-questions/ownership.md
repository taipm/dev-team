# Ownership & History Questions
<!-- category: ownership -->
<!-- icon: 👥 -->
<!-- author: discovery-team -->
<!-- created: 2026-01-02 -->

## Mô tả

Bộ câu hỏi về Team Ownership và Project History.
Đây là dimension **WHO** và **WHEN** bị thiếu trong question-bank gốc.

---

## Câu hỏi

### 1. Code Ownership
<!-- id: own-01 -->
<!-- depth: 1 -->

**Câu hỏi:** Ai là owner của các modules/packages chính?

**Tìm ở đâu:**
- `CODEOWNERS`
- `MAINTAINERS*`
- `OWNERS`
- `*.md` - README có thể mention owners

**Keywords:** owner, maintainer, team, contact, responsibility

---

### 2. Contribution Patterns
<!-- id: own-02 -->
<!-- depth: 2 -->
<!-- depends: own-01 -->

**Câu hỏi:** Ai là top contributors? Có bus factor concerns không?

**Tìm ở đâu:**
- `.git/` - Git history
- `AUTHORS*`
- `CONTRIBUTORS*`

**Keywords:** author, contributor, commit, blame

**Note:** Cần chạy `git shortlog -sn` để lấy stats

---

### 3. Project History
<!-- id: own-03 -->
<!-- depth: 2 -->

**Câu hỏi:** Project này đã evolve như thế nào theo thời gian?

**Tìm ở đâu:**
- `CHANGELOG*`
- `HISTORY*`
- `docs/adr/*` - Architecture Decision Records
- `docs/rfcs/*` - RFCs

**Keywords:** changelog, history, version, release, migration, breaking

---

### 4. Architecture Decisions
<!-- id: own-04 -->
<!-- depth: 3 -->
<!-- depends: own-03 -->

**Câu hỏi:** Có document về các architecture decisions không? ADRs?

**Tìm ở đâu:**
- `docs/adr/*`
- `docs/architecture/*`
- `ADR*`
- `**/*decision*.md`

**Keywords:** adr, decision, rationale, why, tradeoff, alternative

---

### 5. Deprecation & Migration
<!-- id: own-05 -->
<!-- depth: 2 -->

**Câu hỏi:** Có code/features đang bị deprecated không? Migration plans?

**Tìm ở đâu:**
- `**/*deprecated*`
- `**/*migration*`
- `**/*legacy*`

**Keywords:** deprecated, legacy, migration, sunset, eol, end-of-life

---

### 6. Documentation Ownership
<!-- id: own-06 -->
<!-- depth: 1 -->

**Câu hỏi:** Documentation được maintain bởi ai? Có up-to-date không?

**Tìm ở đâu:**
- `docs/`
- `README*`
- `.github/`

**Keywords:** docs, documentation, readme, wiki, guide

---

### 7. On-call & Incident Response
<!-- id: own-07 -->
<!-- depth: 2 -->

**Câu hỏi:** Ai on-call cho service này? Có runbook không?

**Tìm ở đâu:**
- `**/runbook*`
- `**/oncall*`
- `**/incident*`
- `docs/operations/*`

**Keywords:** oncall, on-call, runbook, playbook, incident, escalation, pager

---

*Bộ câu hỏi này cover WHO và WHEN dimensions.*
