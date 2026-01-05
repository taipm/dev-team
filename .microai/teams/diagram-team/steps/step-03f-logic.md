# Step 03f: Generate Logic Flow Diagrams

## Metadata

```yaml
step: 3f
name: logic
type: parallel
group: diagram_generation
agent: logician-agent
trigger: exploration_complete
signal_out: diagram_created
```

## Description

Logician agent tạo flowcharts cho algorithms và logic flows.

## Actions

1. **Read Exploration Report**
   - Identify core algorithms
   - Find decision points
   - Map business logic

2. **Create Flowcharts**
   - Main process flow
   - Authentication logic
   - Error handling
   - Key algorithms

3. **Write Output**
   - Save as logic.mmd

## Input

```yaml
input:
  file: exploration-report.md
  sections:
    - components.services
    - entry_points
```

## Output

```yaml
output:
  file: logic.mmd
  location: output/{project}/diagrams/diagrams/
  format: mermaid
  diagram_type: flowchart
```

## Exit Conditions

- [x] Algorithms identified
- [x] Decision points mapped
- [x] Flowcharts created
- [x] Mermaid syntax valid
- [x] File saved

## Signal

```yaml
signal:
  topic: diagram_created
  payload:
    type: logic
    path: "{path}/logic.mmd"
    flows_count: {n}
```
