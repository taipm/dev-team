---
story_id: "{{story_id}}"
story_type: "technical-debt"
created_date: "{{date}}"
session_subject: "{{subject}}"
status: "{{status}}"
debt_category: "{{category}}"
participants:
  - Solo Developer
  - End User
  - Observer: {{observer_name}}
---

# Technical Debt: {{debt_title}}

## Debt Description

**Category:** {{category}} (Code/Architecture/Testing/Documentation/Infrastructure)
**Introduced:** {{introduced_when}}
**Reason for debt:** {{reason_for_debt}}

### Current State
{{current_state}}

### Desired State
{{desired_state}}

---

## Business Justification

### Why Address Now?

| Factor | Current Impact | After Fix |
|--------|----------------|-----------|
| **Development Velocity** | {{velocity_current}} | {{velocity_after}} |
| **Bug Rate** | {{bug_rate_current}} | {{bug_rate_after}} |
| **Maintenance Cost** | {{maintenance_current}} | {{maintenance_after}} |
| **Developer Experience** | {{dx_current}} | {{dx_after}} |

### Cost of Delay
{{cost_of_delay}}

---

## Scope Definition

### In Scope
{{#each in_scope}}
- {{this}}
{{/each}}

### Explicitly Out of Scope
{{#each out_of_scope}}
- {{this}} — *Reason: {{this.reason}}*
{{/each}}

---

## Acceptance Criteria

{{#each acceptance_criteria}}
### AC{{@index_plus_one}}: {{this.title}}

| Element | Description |
|---------|-------------|
| **Given** | {{this.given}} |
| **When** | {{this.when}} |
| **Then** | {{this.then}} |

{{/each}}

---

## Implementation Approach

### Strategy
{{implementation_strategy}}

### Migration Plan
{{#if migration_needed}}
1. {{migration_step_1}}
2. {{migration_step_2}}
3. {{migration_step_3}}
{{else}}
No migration needed - clean refactor.
{{/if}}

### Rollback Plan
{{rollback_plan}}

---

## Technical Notes

### Affected Components
{{#each affected_components}}
- `{{this.path}}` — {{this.change_type}}
{{/each}}

### Dependencies
{{#each dependencies}}
- {{this}}
{{/each}}

### Breaking Changes
{{#if breaking_changes}}
{{#each breaking_changes}}
- ⚠️ {{this}}
{{/each}}
{{else}}
None - backward compatible.
{{/if}}

---

## Quality Gates

### Before Merge
- [ ] All existing tests pass
- [ ] New tests added for refactored code
- [ ] Code coverage maintained or improved
- [ ] Performance benchmarks pass
- [ ] Documentation updated

### After Deploy
- [ ] Monitor error rates for 24h
- [ ] Verify metrics unchanged
- [ ] Team walkthrough of changes

---

## Estimation

| Attribute | Value |
|-----------|-------|
| **Complexity** | {{complexity}} |
| **Estimated Effort** | {{effort}} |
| **Risk Level** | {{risk_level}} |
| **Confidence** | {{confidence}} |

---

## Sign-Off

| Role | Status | Notes |
|------|--------|-------|
| Solo Developer | {{#if dev_signoff}}✅ Confirmed{{else}}⏳ Pending{{/if}} | {{dev_notes}} |
| Tech Lead | {{#if techlead_signoff}}✅ Approved{{else}}⏳ Pending{{/if}} | {{techlead_notes}} |

---

## Tracking

| Metric | Before | Target | Actual |
|--------|--------|--------|--------|
| {{metric_1_name}} | {{metric_1_before}} | {{metric_1_target}} | - |
| {{metric_2_name}} | {{metric_2_before}} | {{metric_2_target}} | - |

---

*Generated from dev-user team session on {{date}}*
*Template: technical-debt*
