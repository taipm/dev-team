# Verification Report

> **Session**: {{SESSION_ID}}
> **Project**: {{PROJECT_NAME}}
> **Verified**: {{TIMESTAMP}}
> **Agent**: Validator

---

## Summary

| Metric | Value |
|--------|-------|
| Diagrams Verified | {{DIAGRAM_COUNT}} |
| Overall Accuracy | **{{OVERALL_ACCURACY}}%** |
| Total Checks | {{TOTAL_CHECKS}} |
| Passed | {{PASSED_CHECKS}} |
| Failed | {{FAILED_CHECKS}} |
| Warnings | {{WARNING_COUNT}} |

### Status
{{#OVERALL_STATUS}}
**{{STATUS_EMOJI}} {{STATUS_TEXT}}**
{{/OVERALL_STATUS}}

---

## Diagram Results

{{#DIAGRAM_RESULTS}}
### {{DIAGRAM_TYPE_EMOJI}} {{DIAGRAM_TYPE}}

| Check Type | Status | Score |
|------------|--------|-------|
| Entity Exists | {{ENTITY_STATUS}} | {{ENTITY_SCORE}}% |
| Relationship Valid | {{RELATION_STATUS}} | {{RELATION_SCORE}}% |
| Completeness | {{COMPLETE_STATUS}} | {{COMPLETE_SCORE}}% |
| Naming Match | {{NAMING_STATUS}} | {{NAMING_SCORE}}% |
| **Overall** | **{{DIAGRAM_STATUS}}** | **{{DIAGRAM_SCORE}}%** |

#### Issues Found
{{#ISSUES}}
- **{{SEVERITY}}**: {{ISSUE_DESC}}
  - Location: `{{LOCATION}}`
  - Expected: {{EXPECTED}}
  - Found: {{FOUND}}
  - Suggestion: {{SUGGESTION}}
{{/ISSUES}}

{{#NO_ISSUES}}
No issues found.
{{/NO_ISSUES}}

---
{{/DIAGRAM_RESULTS}}

## Detailed Checks

### Entity Existence Verification

Verifies that all entities in diagrams exist in actual codebase.

{{#ENTITY_CHECKS}}
| Entity | Diagram | Exists | Path |
|--------|---------|--------|------|
{{#ENTITIES}}
| `{{ENTITY_NAME}}` | {{DIAGRAM}} | {{EXISTS_EMOJI}} | `{{FILE_PATH}}` |
{{/ENTITIES}}
{{/ENTITY_CHECKS}}

### Relationship Validation

Verifies that relationships between entities are accurate.

{{#RELATIONSHIP_CHECKS}}
| Source | Relation | Target | Valid | Evidence |
|--------|----------|--------|-------|----------|
{{#RELATIONS}}
| `{{SOURCE}}` | {{RELATION_TYPE}} | `{{TARGET}}` | {{VALID_EMOJI}} | `{{EVIDENCE}}` |
{{/RELATIONS}}
{{/RELATIONSHIP_CHECKS}}

### Completeness Check

Compares discovered entities vs. diagrammed entities.

{{#COMPLETENESS}}
| Category | Discovered | Diagrammed | Coverage |
|----------|------------|------------|----------|
{{#CATEGORIES}}
| {{CATEGORY_NAME}} | {{DISCOVERED}} | {{DIAGRAMMED}} | {{COVERAGE}}% |
{{/CATEGORIES}}
{{/COMPLETENESS}}

### Naming Accuracy

Verifies naming conventions match actual code.

{{#NAMING_CHECKS}}
| Diagram Name | Code Name | Match | Suggestion |
|--------------|-----------|-------|------------|
{{#NAMES}}
| `{{DIAGRAM_NAME}}` | `{{CODE_NAME}}` | {{MATCH_EMOJI}} | {{SUGGESTION}} |
{{/NAMES}}
{{/NAMING_CHECKS}}

---

## Specific Validations

### API Endpoint Verification (Sequence Diagrams)
{{#API_VERIFICATION}}
| Endpoint | Method | In Diagram | In Code | Match |
|----------|--------|------------|---------|-------|
{{#ENDPOINTS}}
| `{{PATH}}` | {{METHOD}} | {{IN_DIAGRAM}} | {{IN_CODE}} | {{MATCH_EMOJI}} |
{{/ENDPOINTS}}
{{/API_VERIFICATION}}

### Database Schema Verification (ERD)
{{#SCHEMA_VERIFICATION}}
| Table | Columns Match | Relations Match | Types Match |
|-------|---------------|-----------------|-------------|
{{#TABLES}}
| `{{TABLE_NAME}}` | {{COLUMNS_EMOJI}} | {{RELATIONS_EMOJI}} | {{TYPES_EMOJI}} |
{{/TABLES}}
{{/SCHEMA_VERIFICATION}}

### File Structure Verification (Directory Diagram)
{{#DIRECTORY_VERIFICATION}}
| Path | In Diagram | Exists | Correct |
|------|------------|--------|---------|
{{#PATHS}}
| `{{DIR_PATH}}` | {{IN_DIAGRAM}} | {{EXISTS}} | {{CORRECT_EMOJI}} |
{{/PATHS}}
{{/DIRECTORY_VERIFICATION}}

---

## Cross-Reference Matrix

Shows how entities appear across different diagram types.

| Entity | Architecture | Sequence | Class | ERD | Directory |
|--------|-------------|----------|-------|-----|-----------|
{{#CROSS_REFERENCE}}
| `{{ENTITY}}` | {{ARCH}} | {{SEQ}} | {{CLASS}} | {{ERD}} | {{DIR}} |
{{/CROSS_REFERENCE}}

---

## Issues Summary

### Critical Issues (Must Fix)
{{#CRITICAL_ISSUES}}
1. **[{{DIAGRAM}}]** {{ISSUE_DESC}}
   - Impact: {{IMPACT}}
   - Fix: {{FIX_ACTION}}
{{/CRITICAL_ISSUES}}

{{#NO_CRITICAL}}
No critical issues found.
{{/NO_CRITICAL}}

### Warnings (Should Fix)
{{#WARNINGS}}
1. **[{{DIAGRAM}}]** {{WARNING_DESC}}
   - Recommendation: {{RECOMMENDATION}}
{{/WARNINGS}}

{{#NO_WARNINGS}}
No warnings.
{{/NO_WARNINGS}}

### Suggestions (Nice to Have)
{{#SUGGESTIONS}}
- {{SUGGESTION}}
{{/SUGGESTIONS}}

---

## Recommendations

### Diagrams to Regenerate
{{#REGENERATE}}
- **{{DIAGRAM}}**: {{REASON}}
{{/REGENERATE}}

### Manual Review Needed
{{#MANUAL_REVIEW}}
- **{{ITEM}}**: {{REASON}}
{{/MANUAL_REVIEW}}

### Additional Diagrams Suggested
{{#ADDITIONAL}}
- **{{DIAGRAM_TYPE}}**: {{REASON}}
{{/ADDITIONAL}}

---

## Verification Metadata

```yaml
verification:
  session: {{SESSION_ID}}
  timestamp: {{TIMESTAMP}}
  duration: {{DURATION}}

  checks_performed:
    entity_exists: {{ENTITY_CHECK_COUNT}}
    relationship_valid: {{RELATION_CHECK_COUNT}}
    completeness: {{COMPLETE_CHECK_COUNT}}
    naming_match: {{NAMING_CHECK_COUNT}}
    api_verification: {{API_CHECK_COUNT}}
    schema_verification: {{SCHEMA_CHECK_COUNT}}

  scores:
    architecture: {{ARCH_SCORE}}
    sequence: {{SEQ_SCORE}}
    class: {{CLASS_SCORE}}
    erd: {{ERD_SCORE}}
    directory: {{DIR_SCORE}}
    logic: {{LOGIC_SCORE}}
    uiux: {{UIUX_SCORE}}
    overall: {{OVERALL_SCORE}}

  status: {{FINAL_STATUS}}
```

---

*Generated by Validator Agent - {{TIMESTAMP}}*
