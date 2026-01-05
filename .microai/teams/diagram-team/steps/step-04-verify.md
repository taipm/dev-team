# Step 04: Verify Diagrams

## Metadata

```yaml
step: 4
name: verify
type: sequential
agent: validator-agent
trigger: all_diagrams_ready
signal_out: verification_complete
breakpoint: false
```

## Description

Validator agent cross-checks tất cả diagrams với codebase thực tế.

## Actions

1. **Load All Diagrams**
   - architecture.mmd
   - sequences.mmd
   - classes.mmd
   - erd.mmd
   - directory.mmd
   - logic.mmd
   - uiux.mmd

2. **Run Deep Verification**
   For each diagram:
   - V1: Entity exists
   - V2: Relationship valid
   - V3: Completeness
   - V4: Naming match
   - V5: API accuracy (sequences)
   - V6: ERD accuracy (erd)

3. **Calculate Scores**
   - Per-diagram score
   - Overall score

4. **Generate Report**
   - verification-report.md
   - Per-diagram YAML checks

## Input

```yaml
input:
  diagrams:
    - diagrams/architecture.mmd
    - diagrams/sequences.mmd
    - diagrams/classes.mmd
    - diagrams/erd.mmd
    - diagrams/directory.mmd
    - diagrams/logic.mmd
    - diagrams/uiux.mmd
  codebase: "{project_path}"
```

## Output

```yaml
output:
  files:
    - verification/verification-report.md
    - verification/architecture-check.yaml
    - verification/sequences-check.yaml
    - verification/classes-check.yaml
    - verification/erd-check.yaml
    - verification/directory-check.yaml
    - verification/logic-check.yaml
    - verification/uiux-check.yaml
```

## Exit Conditions

- [x] All diagrams loaded
- [x] All checks executed
- [x] Scores calculated
- [x] Report generated

## Signal

```yaml
signal:
  topic: verification_complete
  payload:
    overall_score: {percent}
    issues_count: {n}
    report_path: "{path}"
```

## Next Step

→ Step 05: Aggregate
