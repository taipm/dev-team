---
story_id: "{{story_id}}"
story_type: "bug-fix"
created_date: "{{date}}"
session_subject: "{{subject}}"
status: "{{status}}"
severity: "{{severity}}"
participants:
  - Solo Developer
  - End User
  - Observer: {{observer_name}}
---

# Bug Fix: {{bug_title}}

## Bug Description

**Reported by:** {{reporter}}
**Environment:** {{environment}}
**First observed:** {{first_observed}}

### Current Behavior
{{current_behavior}}

### Expected Behavior
{{expected_behavior}}

### Steps to Reproduce
{{#each steps_to_reproduce}}
{{@index_plus_one}}. {{this}}
{{/each}}

---

## Impact Assessment

| Aspect | Details |
|--------|---------|
| **Severity** | {{severity}} (Critical/High/Medium/Low) |
| **Affected Users** | {{affected_users}} |
| **Workaround Available** | {{workaround_available}} |
| **Business Impact** | {{business_impact}} |

---

## Root Cause Analysis

### Hypothesis
{{root_cause_hypothesis}}

### Investigation Notes
{{investigation_notes}}

---

## Fix Acceptance Criteria

{{#each acceptance_criteria}}
### AC{{@index_plus_one}}: {{this.title}}

| Element | Description |
|---------|-------------|
| **Given** | {{this.given}} |
| **When** | {{this.when}} |
| **Then** | {{this.then}} |
{{#if this.and}}
| **And** | {{this.and}} |
{{/if}}

{{/each}}

---

## Regression Prevention

### Test Cases to Add
{{#each test_cases}}
- [ ] {{this}}
{{/each}}

### Monitoring to Add
{{#each monitoring}}
- [ ] {{this}}
{{/each}}

---

## Technical Notes

{{technical_notes}}

---

## Estimation

| Attribute | Value |
|-----------|-------|
| **Complexity** | {{complexity}} |
| **Estimated Effort** | {{effort}} |
| **Risk Level** | {{risk_level}} |

---

## Sign-Off

| Role | Status | Notes |
|------|--------|-------|
| End User | {{#if enduser_signoff}}✅ Approved{{else}}⏳ Pending{{/if}} | {{enduser_notes}} |
| Solo Developer | {{#if dev_signoff}}✅ Confirmed{{else}}⏳ Pending{{/if}} | {{dev_notes}} |

---

## Related

- **Original Issue:** {{issue_link}}
- **Related Stories:** {{related_stories}}
- **Affected Components:** {{affected_components}}

---

*Generated from dev-user team session on {{date}}*
*Template: bug-fix*
