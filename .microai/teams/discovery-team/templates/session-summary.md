# Session Summary

## Session Info

| Field | Value |
|-------|-------|
| **Session ID** | {{session_id}} |
| **Date** | {{date}} |
| **Duration** | {{duration}} |
| **Scope** | {{scope}} |
| **Depth** | {{depth}} |

---

## Metrics

```
╔═══════════════════════════════════════════════════════════════╗
║  SESSION METRICS                                               ║
╠═══════════════════════════════════════════════════════════════╣
║                                                                ║
║  Questions                    Deepening                       ║
║  ├── Total: {{questions_total}}                     Iterations: {{iterations}}         ║
║  ├── Answered: {{questions_answered}}                  Derived Qs: {{derived_count}}         ║
║  └── Skipped: {{questions_skipped}}                                                  ║
║                                                                ║
║  Facts                        Confidence                      ║
║  ├── Extracted: {{facts_count}}                   High: {{confidence_high}}               ║
║  ├── Structure: {{facts_structure}}                 Medium: {{confidence_medium}}             ║
║  ├── Behavior: {{facts_behavior}}                                                   ║
║  ├── Relationship: {{facts_relationship}}                                               ║
║  └── Pattern: {{facts_pattern}}                                                     ║
║                                                                ║
║  Analysis                                                      ║
║  ├── Patterns: {{patterns_count}}                                                   ║
║  ├── Relationships: {{relationships_count}}                                            ║
║  └── Gaps: {{gaps_count}}                                                       ║
║                                                                ║
╚═══════════════════════════════════════════════════════════════╝
```

---

## Key Findings

### Top 5 Discoveries

{{#each top_findings}}
{{@index}}. **{{title}}**
   {{description}}
   - Evidence: `{{evidence}}`
   - Confidence: {{confidence}}

{{/each}}

---

## Patterns Identified

| Pattern | Type | Occurrences |
|---------|------|-------------|
{{#each patterns}}
| {{name}} | {{type}} | {{occurrences}} |
{{/each}}

---

## Open Questions

### For Next Session

{{#each open_questions}}
- [ ] {{question}}
  - Priority: {{priority}}
  - Reason: {{reason}}
{{/each}}

---

## Outputs Generated

| Output | Path | Status |
|--------|------|--------|
| Structured Report | `{{report_path}}` | ✓ |
| Knowledge Graph | `{{graph_path}}` | ✓ |
| Q&A Database | `{{qa_path}}` | ✓ |

---

## Comparison with Previous

{{#if has_previous}}
| Metric | Previous | Current | Change |
|--------|----------|---------|--------|
| Components | {{prev_components}} | {{curr_components}} | {{diff_components}} |
| Patterns | {{prev_patterns}} | {{curr_patterns}} | {{diff_patterns}} |
| Questions Answered | {{prev_answered}} | {{curr_answered}} | {{diff_answered}} |
| Coverage | {{prev_coverage}}% | {{curr_coverage}}% | {{diff_coverage}} |
{{else}}
*First session - no previous data*
{{/if}}

---

## Timeline

| Time | Event | Details |
|------|-------|---------|
{{#each timeline}}
| {{time}} | {{event}} | {{details}} |
{{/each}}

---

## Commands Used

```
{{#each commands}}
{{timestamp}} > {{command}}
{{/each}}
```

---

## Notes

{{notes}}

---

*Session archived to: `{{archive_path}}`*
*Next session: Run `/discovery` to continue*
