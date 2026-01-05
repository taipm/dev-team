# Step 03c: Generate Class Diagrams

## Metadata

```yaml
step: 3c
name: class
type: parallel
group: diagram_generation
agent: classifier-agent
trigger: exploration_complete
signal_out: diagram_created
```

## Description

Classifier agent tạo class diagrams cho domain models, services, và interfaces.

## Actions

1. **Read Exploration Report**
   - Extract classes/structs
   - Identify interfaces
   - Map inheritance

2. **Create Class Diagrams**
   - Domain models
   - Service layer
   - Repository interfaces

3. **Write Output**
   - Save as classes.mmd

## Input

```yaml
input:
  file: exploration-report.md
  sections:
    - components.models
    - components.services
    - components.repositories
```

## Output

```yaml
output:
  file: classes.mmd
  location: output/{project}/diagrams/diagrams/
  format: mermaid
  diagram_type: classDiagram
```

## Exit Conditions

- [x] Classes extracted
- [x] Relationships mapped
- [x] Interfaces documented
- [x] Mermaid syntax valid
- [x] File saved

## Signal

```yaml
signal:
  topic: diagram_created
  payload:
    type: class
    path: "{path}/classes.mmd"
    classes_count: {n}
```
