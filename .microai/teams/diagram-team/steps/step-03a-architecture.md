# Step 03a: Generate Architecture Diagram

## Metadata

```yaml
step: 3a
name: architecture
type: parallel
group: diagram_generation
agent: architect-agent
trigger: exploration_complete
signal_out: diagram_created
```

## Description

Architect agent tạo C4 Context và Container diagrams dựa trên exploration report.

## Actions

1. **Read Exploration Report**
   - Load exploration-report.md
   - Extract system components
   - Identify external systems

2. **Create C4 Context Diagram**
   - Main system
   - External actors (users, systems)
   - High-level relationships

3. **Create C4 Container Diagram**
   - Deployable units
   - Technology choices
   - Inter-container communication

4. **Write Output**
   - Save as architecture.mmd
   - Include both diagrams

## Input

```yaml
input:
  file: exploration-report.md
  sections:
    - components.services
    - components.handlers
    - relationships.imports
    - tech_stack
```

## Output

```yaml
output:
  file: architecture.mmd
  location: output/{project}/diagrams/diagrams/
  format: mermaid
  diagrams:
    - C4Context
    - C4Container
```

## Exit Conditions

- [x] Exploration report read
- [x] C4 Context created
- [x] C4 Container created
- [x] Mermaid syntax valid
- [x] File saved

## Signal

```yaml
signal:
  topic: diagram_created
  payload:
    type: architecture
    path: "{path}/architecture.mmd"
    entities_count: {n}
```

## Parallel Group

This step runs in parallel with:
- step-03b-sequence
- step-03c-class
- step-03d-erd
- step-03e-directory
- step-03f-logic
- step-03g-uiux
