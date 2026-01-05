# Step 05: Aggregate Outputs

## Metadata

```yaml
step: 5
name: aggregate
type: sequential
agent: maestro-agent
trigger: verification_complete
signal_out: aggregation_complete
breakpoint: false
```

## Description

Maestro agent tổng hợp tất cả outputs thành package hoàn chỉnh.

## Actions

1. **Collect All Outputs**
   - 7 Mermaid diagrams
   - Exploration report
   - Verification report

2. **Generate README**
   - Index of all diagrams
   - Quick links
   - How to view instructions

3. **Organize Files**
   ```
   output/{project}/diagrams/
   ├── README.md
   ├── exploration-report.md
   ├── diagrams/
   │   └── *.mmd
   └── verification/
       └── *.yaml, *.md
   ```

4. **Prepare Session Summary**
   - Statistics
   - Timeline
   - Issues summary

## Input

```yaml
input:
  diagrams: 7 files
  exploration: exploration-report.md
  verification: verification-report.md
```

## Output

```yaml
output:
  files:
    - README.md
    - session-summary.md
  location: output/{project}/diagrams/
```

## Exit Conditions

- [x] All files collected
- [x] README generated
- [x] Files organized
- [x] Summary prepared

## Signal

```yaml
signal:
  topic: aggregation_complete
  payload:
    total_files: {n}
    output_path: "{path}"
```

## Next Step

→ Step 06: Summary
