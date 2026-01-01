# Step 04: Output Synthesis

## Objective
Tạo output document dựa trên dialogue và consensus đã đạt được.

## Output by Mode

### Test Plan Mode → Test Plan Document

```markdown
# Test Plan: {feature_name}

**Created:** {date}
**Session:** {session_id}
**Participants:** QA Engineer, Developer

---

## 1. Overview

**Feature:** {feature_description}
**User Story:** {user_story}
**Scope:** {scope_summary}

---

## 2. Test Strategy

**Approach:** {test_approach}
**Coverage Target:** {coverage_percentage}
**Test Types:**
- [ ] Unit Tests
- [ ] Integration Tests
- [ ] E2E Tests
- [ ] Security Tests
- [ ] Performance Tests

---

## 3. Test Cases

### TC-001: {test_case_name}
**Priority:** {P1/P2/P3}
**Type:** {Happy Path/Edge Case/Error Handling}

**Preconditions:**
- {precondition_1}

**Test Steps:**
**Given** {given_state}
**When** {when_action}
**Then** {then_expected}

**Notes:** {dev_notes}

---

### TC-002: {test_case_name}
...

---

## 4. Risk Assessment

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| {risk_1} | High/Med/Low | High/Med/Low | {mitigation} |

---

## 5. Test Data Requirements

{test_data_description}

---

## 6. Environment Requirements

{environment_setup}

---

## 7. Sign-off

- [ ] **QA Engineer:** Approved
- [ ] **Developer:** Approved
- [ ] **Observer:** Acknowledged

---

**Generated from Dev-QA Session**
```

### Bug Triage Mode → Bug Report Document

```markdown
# Bug Report: {bug_id}

**Created:** {date}
**Session:** {session_id}
**Participants:** QA Engineer, Developer

---

## 1. Summary

**Title:** {bug_title}
**Severity:** {Critical/High/Medium/Low}
**Priority:** {P1/P2/P3/P4}
**Status:** Triaged

---

## 2. Environment

- **App Version:** {version}
- **Browser:** {browser}
- **OS:** {os}
- **Device:** {device}

---

## 3. Description

### Steps to Reproduce
1. {step_1}
2. {step_2}
3. {step_3}

### Expected Result
{expected}

### Actual Result
{actual}

### Evidence
{attachments_description}

---

## 4. Root Cause Analysis

**Analysis by Developer:**
{root_cause_explanation}

**Affected Components:**
- {component_1}
- {component_2}

---

## 5. Fix Approach

**Agreed Approach:**
{fix_description}

**Files to Modify:**
- `{file_1}` - {change}
- `{file_2}` - {change}

**Estimated Effort:** {estimate}

---

## 6. Test Scenarios for Verification

### Scenario 1: Original Bug Fixed
**Given** {given}
**When** {when}
**Then** {then}

### Scenario 2: Regression Check
**Given** {given}
**When** {when}
**Then** {then}

---

## 7. Sign-off

- [ ] **QA Engineer:** Bug documented correctly
- [ ] **Developer:** Fix approach agreed
- [ ] **Observer:** Acknowledged

---

**Generated from Dev-QA Session**
```

### Code Review Mode → Review Report Document

```markdown
# Code Review Report: {pr_title}

**Created:** {date}
**Session:** {session_id}
**Participants:** QA Engineer, Developer

---

## 1. Overview

**PR/Change:** {pr_reference}
**Purpose:** {change_purpose}
**Files Changed:** {file_count}

---

## 2. QA Review Summary

**Overall Assessment:** {Approved/Approved with Comments/Changes Requested}

### Positive Findings
- {positive_1}
- {positive_2}

### Concerns Addressed
| # | Concern | Status | Resolution |
|---|---------|--------|------------|
| 1 | {concern} | Fixed/Acknowledged | {resolution} |
| 2 | {concern} | Fixed/Acknowledged | {resolution} |

---

## 3. Testability Assessment

**Score:** {1-5}/5

| Criterion | Status | Notes |
|-----------|--------|-------|
| Dependency Injection | ✅/⚠️/❌ | {notes} |
| Error Handling | ✅/⚠️/❌ | {notes} |
| Logging | ✅/⚠️/❌ | {notes} |
| Edge Cases | ✅/⚠️/❌ | {notes} |

---

## 4. Test Coverage

**Current Coverage:** {percentage}
**After Changes:** {percentage}

### Recommended Additional Tests
1. {test_recommendation_1}
2. {test_recommendation_2}

---

## 5. Risk Assessment

| Risk Area | Level | Mitigation |
|-----------|-------|------------|
| {area_1} | High/Med/Low | {mitigation} |

---

## 6. Sign-off

- [ ] **QA Engineer:** QA Approved
- [ ] **Developer:** Feedback addressed
- [ ] **Observer:** Acknowledged

---

**Generated from Dev-QA Session**
```

## Synthesis Flow

```
1. Collect all dialogue turns
2. Extract key decisions
3. Load appropriate template
4. Fill in template with collected data
5. Present to both agents for review
6. Request sign-off from each agent
7. Save final document
```

## Sign-off Protocol

### QA Sign-off
```markdown
[QA Engineer] 🔍

Tôi đã review output document.

✅ **Confirmed:**
- {aspect_1}
- {aspect_2}

**QA Sign-off:** Approved

───────────────────────────────────────────────────────────────
```

### Developer Sign-off
```markdown
[Developer] 👨‍💻

Tôi đã review output document.

✅ **Confirmed:**
- {aspect_1}
- {aspect_2}

**Developer Sign-off:** Approved

───────────────────────────────────────────────────────────────
```

## Iteration if Needed

If either agent requests changes:
```
1. Note the requested change
2. Update document
3. Re-present for review
4. Request sign-off again
```

## Transition

→ After both agents sign off:
   Proceed to Step 05: Session Close
