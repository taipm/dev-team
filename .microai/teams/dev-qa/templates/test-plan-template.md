---
template_type: test-plan
version: "1.0"
---

# Test Plan Template

## Test Plan: {{feature_name}}

**Document ID:** {{plan_id}}
**Version:** {{version}}
**Created:** {{date}}
**Author:** {{author}}
**Status:** {{draft/approved/in_progress/completed}}

---

## 1. Overview

### 1.1 Feature Description
{{feature_description}}

### 1.2 User Story
As a **{{persona}}**,
I want **{{capability}}**,
So that **{{business_value}}**.

### 1.3 Scope

**In Scope:**
- {{in_scope_1}}
- {{in_scope_2}}
- {{in_scope_3}}

**Out of Scope:**
- {{out_scope_1}}
- {{out_scope_2}}

### 1.4 References
- **Requirements:** {{requirements_link}}
- **Design Doc:** {{design_link}}
- **API Spec:** {{api_link}}

---

## 2. Test Strategy

### 2.1 Test Approach
{{test_approach_description}}

### 2.2 Test Types

| Type | Coverage | Automation |
|------|----------|------------|
| Unit Tests | {{unit_coverage}}% | {{unit_auto}} |
| Integration Tests | {{int_coverage}}% | {{int_auto}} |
| E2E Tests | {{e2e_coverage}}% | {{e2e_auto}} |
| Security Tests | {{sec_coverage}}% | {{sec_auto}} |
| Performance Tests | {{perf_coverage}}% | {{perf_auto}} |

### 2.3 Coverage Targets
- **Code Coverage:** {{coverage_target}}%
- **Requirements Coverage:** 100%
- **Critical Path Coverage:** 100%

---

## 3. Test Cases

### 3.1 Happy Path Tests

#### TC-001: {{test_name_1}}
**Priority:** P1
**Type:** Happy Path

**Given** {{given_1}}
**When** {{when_1}}
**Then** {{then_1}}

#### TC-002: {{test_name_2}}
**Priority:** P1
**Type:** Happy Path

**Given** {{given_2}}
**When** {{when_2}}
**Then** {{then_2}}

---

### 3.2 Edge Case Tests

#### TC-003: {{edge_case_name_1}}
**Priority:** P2
**Type:** Edge Case

**Given** {{given_3}}
**When** {{when_3}}
**Then** {{then_3}}

#### TC-004: {{edge_case_name_2}}
**Priority:** P2
**Type:** Edge Case

**Given** {{given_4}}
**When** {{when_4}}
**Then** {{then_4}}

---

### 3.3 Negative Tests

#### TC-005: {{negative_test_1}}
**Priority:** P2
**Type:** Negative

**Given** {{given_5}}
**When** {{when_5}}
**Then** {{then_5}}

---

### 3.4 Security Tests

#### TC-006: {{security_test_1}}
**Priority:** P1
**Type:** Security

**Given** {{given_6}}
**When** {{when_6}}
**Then** {{then_6}}

---

## 4. Risk Assessment

### 4.1 Risk Matrix

| Risk | Impact | Likelihood | Mitigation | Owner |
|------|--------|------------|------------|-------|
| {{risk_1}} | High/Med/Low | High/Med/Low | {{mitigation_1}} | {{owner_1}} |
| {{risk_2}} | High/Med/Low | High/Med/Low | {{mitigation_2}} | {{owner_2}} |
| {{risk_3}} | High/Med/Low | High/Med/Low | {{mitigation_3}} | {{owner_3}} |

### 4.2 High Risk Areas
1. {{high_risk_area_1}} - {{reason_1}}
2. {{high_risk_area_2}} - {{reason_2}}

---

## 5. Test Data Requirements

### 5.1 Test Data Sets

| Data Set | Description | Source |
|----------|-------------|--------|
| {{dataset_1}} | {{desc_1}} | {{source_1}} |
| {{dataset_2}} | {{desc_2}} | {{source_2}} |

### 5.2 Data Preparation
{{data_preparation_instructions}}

### 5.3 Data Cleanup
{{data_cleanup_instructions}}

---

## 6. Environment Requirements

### 6.1 Test Environment

| Component | Specification |
|-----------|---------------|
| **Server** | {{server_spec}} |
| **Database** | {{db_spec}} |
| **Browser** | {{browser_spec}} |
| **OS** | {{os_spec}} |

### 6.2 Environment Setup
{{environment_setup_instructions}}

### 6.3 Access Requirements
- {{access_1}}
- {{access_2}}

---

## 7. Schedule

| Phase | Start | End | Status |
|-------|-------|-----|--------|
| Test Planning | {{plan_start}} | {{plan_end}} | {{plan_status}} |
| Test Case Development | {{dev_start}} | {{dev_end}} | {{dev_status}} |
| Test Execution | {{exec_start}} | {{exec_end}} | {{exec_status}} |
| Bug Fixing | {{fix_start}} | {{fix_end}} | {{fix_status}} |
| Regression | {{reg_start}} | {{reg_end}} | {{reg_status}} |

---

## 8. Entry/Exit Criteria

### 8.1 Entry Criteria
- [ ] Feature development complete
- [ ] Code review passed
- [ ] Test environment ready
- [ ] Test data prepared

### 8.2 Exit Criteria
- [ ] All P1 test cases passed
- [ ] 95% of P2 test cases passed
- [ ] No open Critical/High bugs
- [ ] Code coverage >= {{coverage_target}}%

---

## 9. Sign-off

| Role | Name | Signature | Date |
|------|------|-----------|------|
| QA Lead | {{qa_name}} | | {{date}} |
| Dev Lead | {{dev_name}} | | {{date}} |
| Product Owner | {{po_name}} | | {{date}} |

---

## 10. Appendix

### A. Test Case Summary

| ID | Name | Priority | Type | Status |
|----|------|----------|------|--------|
| TC-001 | {{name_1}} | P1 | Happy Path | {{status_1}} |
| TC-002 | {{name_2}} | P1 | Happy Path | {{status_2}} |
| TC-003 | {{name_3}} | P2 | Edge Case | {{status_3}} |

### B. Glossary
- **{{term_1}}:** {{definition_1}}
- **{{term_2}}:** {{definition_2}}
