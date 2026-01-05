# Step 03e: Generate Directory Diagram

## Metadata

```yaml
step: 3e
name: directory
type: parallel
group: diagram_generation
agent: mapper-agent
trigger: exploration_complete
signal_out: diagram_created
```

## Description

Mapper agent tạo directory structure diagram cho project layout.

## Actions

1. **Read Exploration Report**
   - Extract directory structure
   - Identify key folders
   - Map file organization

2. **Create Directory Diagram**
   - Root structure
   - Key directories (src, tests, config)
   - Important files

3. **Write Output**
   - Save as directory.mmd

## Input

```yaml
input:
  file: exploration-report.md
  sections:
    - file_structure.directories
    - file_structure.key_files
```

## Output

```yaml
output:
  file: directory.mmd
  location: output/{project}/diagrams/diagrams/
  format: mermaid
  diagram_type: graph TD
```

## Exit Conditions

- [x] Structure extracted
- [x] Key folders identified
- [x] Diagram created
- [x] Mermaid syntax valid
- [x] File saved

## Signal

```yaml
signal:
  topic: diagram_created
  payload:
    type: directory
    path: "{path}/directory.mmd"
    directories_count: {n}
```
