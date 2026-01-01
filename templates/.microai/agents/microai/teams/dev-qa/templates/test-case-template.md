---
template_type: test-case
format: GWT
version: "1.0"
---

# Test Case Template

## Test Case: {{test_id}}

**Feature:** {{feature_name}}
**Priority:** {{priority}}
**Type:** {{test_type}}
**Created:** {{date}}
**Author:** {{author}}

---

### Description
{{test_description}}

---

### Preconditions
- {{precondition_1}}
- {{precondition_2}}

---

### Test Data
| Field | Value | Notes |
|-------|-------|-------|
| {{field_1}} | {{value_1}} | {{notes_1}} |
| {{field_2}} | {{value_2}} | {{notes_2}} |

---

### Test Steps

**Given** {{given_state}}
- {{given_detail_1}}
- {{given_detail_2}}

**When** {{when_action}}
- {{when_detail_1}}
- {{when_detail_2}}

**Then** {{then_expected}}
- {{then_detail_1}}
- {{then_detail_2}}

---

### Edge Cases
- [ ] Empty input: {{empty_input_behavior}}
- [ ] Max length: {{max_length_behavior}}
- [ ] Special characters: {{special_chars_behavior}}
- [ ] Concurrent access: {{concurrent_behavior}}

---

### Negative Tests
- [ ] Invalid input: {{invalid_input_expected}}
- [ ] Unauthorized access: {{unauthorized_expected}}
- [ ] Network failure: {{network_failure_expected}}

---

### Notes
**Developer Notes:**
{{dev_notes}}

**QA Notes:**
{{qa_notes}}

---

### Automation Status
- [ ] Can be automated
- [ ] Automation script: {{script_path}}
- [ ] Manual only - Reason: {{manual_reason}}

---

### Traceability
- **User Story:** {{user_story_id}}
- **Requirement:** {{requirement_id}}
- **Related Tests:** {{related_test_ids}}
