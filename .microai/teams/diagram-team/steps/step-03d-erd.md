# Step 03d: Generate ERD Diagram

## Metadata

```yaml
step: 3d
name: erd
type: parallel
group: diagram_generation
agent: modeler-agent
trigger: exploration_complete
signal_out: diagram_created
```

## Description

Modeler agent tạo Entity-Relationship diagram cho database schema.

## Actions

1. **Read Exploration Report**
   - Extract models/entities
   - Find ORM definitions
   - Parse migration files

2. **Create ERD Diagram**
   - Tables with columns
   - Primary/foreign keys
   - Relationships (1:1, 1:N, M:N)

3. **Write Output**
   - Save as erd.mmd

## Input

```yaml
input:
  file: exploration-report.md
  sections:
    - components.models
    - relationships.database_access
```

## Output

```yaml
output:
  file: erd.mmd
  location: output/{project}/diagrams/diagrams/
  format: mermaid
  diagram_type: erDiagram
```

## Exit Conditions

- [x] Tables identified
- [x] Columns documented
- [x] Relationships mapped
- [x] Mermaid syntax valid
- [x] File saved

## Signal

```yaml
signal:
  topic: diagram_created
  payload:
    type: erd
    path: "{path}/erd.mmd"
    tables_count: {n}
```
