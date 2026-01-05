# Step 03b: Generate Sequence Diagrams

## Metadata

```yaml
step: 3b
name: sequence
type: parallel
group: diagram_generation
agent: sequencer-agent
trigger: exploration_complete
signal_out: diagram_created
```

## Description

Sequencer agent tạo sequence diagrams cho các API flows và user interactions.

## Actions

1. **Read Exploration Report**
   - Extract API endpoints
   - Identify key flows
   - Map handler-service-repo chains

2. **Create Sequence Diagrams**
   - Authentication flow
   - CRUD operations
   - Key business processes

3. **Write Output**
   - Save as sequences.mmd

## Input

```yaml
input:
  file: exploration-report.md
  sections:
    - relationships.api_calls
    - components.handlers
    - components.services
```

## Output

```yaml
output:
  file: sequences.mmd
  location: output/{project}/diagrams/diagrams/
  format: mermaid
  diagram_type: sequenceDiagram
```

## Exit Conditions

- [x] API endpoints identified
- [x] Key flows diagrammed
- [x] Mermaid syntax valid
- [x] File saved

## Signal

```yaml
signal:
  topic: diagram_created
  payload:
    type: sequence
    path: "{path}/sequences.mmd"
    flows_count: {n}
```

## Parallel Group

This step runs in parallel with other step-03* steps.
