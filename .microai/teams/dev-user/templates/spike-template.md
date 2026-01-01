---
story_id: "{{story_id}}"
story_type: "spike"
created_date: "{{date}}"
session_subject: "{{subject}}"
status: "{{status}}"
time_box: "{{time_box}}"
participants:
  - Solo Developer
  - End User
  - Observer: {{observer_name}}
---

# Spike: {{spike_title}}

## Spike Overview

**Type:** {{spike_type}} (Technical/Functional/Architecture)
**Time Box:** {{time_box}}
**Deadline:** {{deadline}}

### Question to Answer
{{primary_question}}

### Why This Spike?
{{justification}}

---

## Background

### Context
{{context}}

### What We Know
{{#each known_facts}}
- ✓ {{this}}
{{/each}}

### What We Don't Know
{{#each unknowns}}
- ? {{this}}
{{/each}}

---

## Spike Objectives

### Primary Objective
{{primary_objective}}

### Secondary Objectives
{{#each secondary_objectives}}
- {{this}}
{{/each}}

---

## Research Areas

{{#each research_areas}}
### {{@index_plus_one}}. {{this.area}}

**Questions:**
{{#each this.questions}}
- {{this}}
{{/each}}

**Potential Approaches:**
{{#each this.approaches}}
- {{this}}
{{/each}}

{{/each}}

---

## Success Criteria

### Spike is Successful If:
{{#each success_criteria}}
- [ ] {{this}}
{{/each}}

### Expected Deliverables
| Deliverable | Format | Required |
|-------------|--------|----------|
{{#each deliverables}}
| {{this.name}} | {{this.format}} | {{this.required}} |
{{/each}}

---

## Constraints

### Time Box
- **Maximum Duration:** {{time_box}}
- **Check-in Points:** {{check_in_points}}
- **Hard Stop:** {{hard_stop_date}}

### Resource Constraints
{{#each resource_constraints}}
- {{this}}
{{/each}}

### Technical Constraints
{{#each technical_constraints}}
- {{this}}
{{/each}}

---

## Approach

### Proposed Investigation Steps
{{#each investigation_steps}}
{{@index_plus_one}}. {{this.step}} — *Est: {{this.time}}*
{{/each}}

### POC Scope (if applicable)
{{#if poc_scope}}
**Build:**
{{#each poc_scope.build}}
- {{this}}
{{/each}}

**Don't Build:**
{{#each poc_scope.dont_build}}
- {{this}}
{{/each}}
{{else}}
No POC required - research only.
{{/if}}

---

## Decision Framework

### Options to Evaluate
| Option | Pros | Cons | Effort |
|--------|------|------|--------|
{{#each options}}
| {{this.name}} | {{this.pros}} | {{this.cons}} | {{this.effort}} |
{{/each}}

### Decision Criteria
{{#each decision_criteria}}
- **{{this.criterion}}** — Weight: {{this.weight}}
{{/each}}

---

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
{{#each risks}}
| {{this.risk}} | {{this.likelihood}} | {{this.impact}} | {{this.mitigation}} |
{{/each}}

---

## Expected Outcomes

### Best Case
{{best_case_outcome}}

### Worst Case
{{worst_case_outcome}}

### Most Likely
{{likely_outcome}}

---

## Follow-up Actions

### If Spike Succeeds:
{{#each success_followup}}
- {{this}}
{{/each}}

### If Spike Fails/Inconclusive:
{{#each failure_followup}}
- {{this}}
{{/each}}

---

## Sign-Off

| Role | Status | Notes |
|------|--------|-------|
| Solo Developer | {{#if dev_signoff}}✅ Committed{{else}}⏳ Pending{{/if}} | {{dev_notes}} |
| End User/PM | {{#if pm_signoff}}✅ Approved{{else}}⏳ Pending{{/if}} | {{pm_notes}} |

---

## Results (Fill after completion)

### Findings
<!-- To be filled after spike completion -->

### Recommendation
<!-- To be filled after spike completion -->

### Artifacts Produced
<!-- Links to POC code, documents, etc. -->

---

*Generated from dev-user team session on {{date}}*
*Template: spike*
