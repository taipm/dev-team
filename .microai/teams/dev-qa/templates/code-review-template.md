---
template_type: code-review
version: "1.0"
---

# Code Review Report Template

## Code Review: {{pr_title}}

**PR/Change:** {{pr_reference}}
**Author:** {{author}}
**Reviewer:** {{reviewer}}
**Date:** {{date}}
**Status:** {{approved/changes_requested/pending}}

---

## 1. Overview

### 1.1 Change Summary
{{change_summary}}

### 1.2 Purpose
{{why_this_change}}

### 1.3 Files Changed
| File | Lines Changed | Type |
|------|---------------|------|
| `{{file_1}}` | +{{added_1}} / -{{removed_1}} | {{type_1}} |
| `{{file_2}}` | +{{added_2}} / -{{removed_2}} | {{type_2}} |

### 1.4 Related Items
- **User Story:** {{user_story}}
- **Issue:** {{issue_link}}
- **Design Doc:** {{design_link}}

---

## 2. QA Assessment

### 2.1 Overall Verdict
**{{Approved / Approved with Comments / Changes Requested}}**

### 2.2 Summary
{{assessment_summary}}

---

## 3. Review Findings

### 3.1 Positive Findings

| # | Finding | File | Notes |
|---|---------|------|-------|
| 1 | {{positive_1}} | `{{file}}` | {{notes_1}} |
| 2 | {{positive_2}} | `{{file}}` | {{notes_2}} |

### 3.2 Concerns

#### Concern #1: {{concern_title_1}}
**Severity:** {{critical/major/minor/suggestion}}
**File:** `{{file}}:{{line}}`

**Issue:**
{{issue_description}}

**Code:**
```{{language}}
{{code_snippet}}
```

**Suggestion:**
{{suggestion}}

**Resolution:** {{fixed/acknowledged/wont_fix}}

---

#### Concern #2: {{concern_title_2}}
**Severity:** {{critical/major/minor/suggestion}}
**File:** `{{file}}:{{line}}`

**Issue:**
{{issue_description}}

**Suggestion:**
{{suggestion}}

**Resolution:** {{fixed/acknowledged/wont_fix}}

---

## 4. Testability Assessment

### 4.1 Score: {{score}}/5

### 4.2 Criteria Checklist

| Criterion | Status | Notes |
|-----------|--------|-------|
| Dependency Injection | ✅/⚠️/❌ | {{notes}} |
| Interface Usage | ✅/⚠️/❌ | {{notes}} |
| Error Handling | ✅/⚠️/❌ | {{notes}} |
| Edge Cases Covered | ✅/⚠️/❌ | {{notes}} |
| Logging Sufficient | ✅/⚠️/❌ | {{notes}} |
| No Hidden Dependencies | ✅/⚠️/❌ | {{notes}} |

### 4.3 Testability Concerns
{{testability_concerns}}

---

## 5. Security Review

### 5.1 Security Checklist

| Item | Status | Notes |
|------|--------|-------|
| Input Validation | ✅/⚠️/❌ | {{notes}} |
| Authentication | ✅/⚠️/❌/N/A | {{notes}} |
| Authorization | ✅/⚠️/❌/N/A | {{notes}} |
| Data Sanitization | ✅/⚠️/❌ | {{notes}} |
| Sensitive Data Handling | ✅/⚠️/❌ | {{notes}} |
| SQL Injection Prevention | ✅/⚠️/❌/N/A | {{notes}} |
| XSS Prevention | ✅/⚠️/❌/N/A | {{notes}} |

### 5.2 Security Concerns
{{security_concerns}}

---

## 6. Test Coverage

### 6.1 Current Coverage
- **Before:** {{before_coverage}}%
- **After:** {{after_coverage}}%
- **Delta:** {{delta}}%

### 6.2 Test Status

| Test Type | Status | Notes |
|-----------|--------|-------|
| Unit Tests | ✅/⚠️/❌ | {{unit_notes}} |
| Integration Tests | ✅/⚠️/❌ | {{int_notes}} |
| E2E Tests | ✅/⚠️/❌/N/A | {{e2e_notes}} |

### 6.3 Recommended Additional Tests

1. **{{test_rec_1}}**
   - Type: {{type}}
   - Priority: {{priority}}
   - Reason: {{reason}}

2. **{{test_rec_2}}**
   - Type: {{type}}
   - Priority: {{priority}}
   - Reason: {{reason}}

---

## 7. Risk Assessment

### 7.1 Risk Level: {{Low/Medium/High}}

### 7.2 Risk Areas

| Area | Risk | Mitigation |
|------|------|------------|
| {{area_1}} | {{risk_1}} | {{mitigation_1}} |
| {{area_2}} | {{risk_2}} | {{mitigation_2}} |

### 7.3 Regression Concerns
{{regression_concerns}}

---

## 8. Action Items

### 8.1 Required (Must Fix)
- [ ] {{required_action_1}}
- [ ] {{required_action_2}}

### 8.2 Recommended
- [ ] {{recommended_action_1}}
- [ ] {{recommended_action_2}}

### 8.3 Nice to Have
- [ ] {{nice_to_have_1}}

---

## 9. Sign-off

### 9.1 QA Sign-off
**Status:** {{Approved/Approved with Comments/Pending}}
**Conditions:** {{conditions_if_any}}
**Reviewer:** {{qa_name}}
**Date:** {{date}}

### 9.2 Developer Response
**Actions Taken:** {{dev_response}}
**Date:** {{date}}

---

## 10. Review History

| Date | Action | By | Notes |
|------|--------|----|----- |
| {{date_1}} | Review Started | {{reviewer}} | |
| {{date_2}} | Feedback Provided | {{reviewer}} | {{concern_count}} concerns |
| {{date_3}} | Changes Made | {{author}} | Addressed feedback |
| {{date_4}} | Approved | {{reviewer}} | |
