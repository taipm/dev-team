---
template_type: bug-report
version: "1.0"
---

# Bug Report Template

## Bug Report: {{bug_id}}

**Title:** {{bug_title}}
**Severity:** {{severity}}
**Priority:** {{priority}}
**Status:** {{status}}
**Created:** {{date}}
**Reporter:** {{reporter}}
**Assignee:** {{assignee}}

---

## 1. Summary
{{one_line_summary}}

---

## 2. Environment

| Field | Value |
|-------|-------|
| **App Version** | {{app_version}} |
| **Browser** | {{browser}} |
| **OS** | {{os}} |
| **Device** | {{device}} |
| **Environment** | {{env}} |

---

## 3. Steps to Reproduce

### Prerequisites
- {{prerequisite_1}}
- {{prerequisite_2}}

### Steps
1. {{step_1}}
2. {{step_2}}
3. {{step_3}}
4. {{step_4}}

### Reproducibility
- [ ] Always (100%)
- [ ] Often (>50%)
- [ ] Sometimes (<50%)
- [ ] Rare (<10%)

---

## 4. Results

### Expected Result
{{expected_result}}

### Actual Result
{{actual_result}}

---

## 5. Evidence

### Screenshots
{{screenshot_links}}

### Videos
{{video_links}}

### Logs
```
{{relevant_logs}}
```

### Network Requests
{{har_file_or_requests}}

---

## 6. Root Cause Analysis

### Developer Analysis
{{root_cause_explanation}}

### Affected Components
- {{component_1}}
- {{component_2}}

### Impact Assessment
- **Users Affected:** {{user_count}}
- **Data Impact:** {{data_impact}}
- **Business Impact:** {{business_impact}}

---

## 7. Fix Approach

### Agreed Solution
{{fix_description}}

### Files to Modify
| File | Change |
|------|--------|
| `{{file_1}}` | {{change_1}} |
| `{{file_2}}` | {{change_2}} |

### Estimated Effort
- **Complexity:** {{simple/medium/complex}}
- **Time:** {{estimate}}

### Risks
- {{risk_1}}
- {{risk_2}}

---

## 8. Test Scenarios for Verification

### Scenario 1: Original Bug Fixed
**Given** {{given_1}}
**When** {{when_1}}
**Then** {{then_1}}

### Scenario 2: Regression Check
**Given** {{given_2}}
**When** {{when_2}}
**Then** {{then_2}}

### Scenario 3: Edge Cases
**Given** {{given_3}}
**When** {{when_3}}
**Then** {{then_3}}

---

## 9. Sign-off

| Role | Name | Status | Date |
|------|------|--------|------|
| QA Reporter | {{qa_name}} | {{status}} | {{date}} |
| Developer | {{dev_name}} | {{status}} | {{date}} |
| QA Verifier | {{verifier_name}} | {{status}} | {{date}} |

---

## 10. History

| Date | Action | By | Notes |
|------|--------|----|----- |
| {{date_1}} | Created | {{by_1}} | {{notes_1}} |
| {{date_2}} | Assigned | {{by_2}} | {{notes_2}} |
| {{date_3}} | Fixed | {{by_3}} | {{notes_3}} |
| {{date_4}} | Verified | {{by_4}} | {{notes_4}} |

---

## Related Items
- **Related Bugs:** {{related_bug_ids}}
- **User Story:** {{user_story_id}}
- **PR/Commit:** {{pr_link}}
