# Step 03g: Generate UI/UX Flow Diagrams

## Metadata

```yaml
step: 3g
name: uiux
type: parallel
group: diagram_generation
agent: designer-agent
trigger: exploration_complete
signal_out: diagram_created
```

## Description

Designer agent tạo UI/UX flow diagrams cho user journeys và screen navigation.

## Actions

1. **Read Exploration Report**
   - Find pages/screens
   - Map routes
   - Identify forms

2. **Create UI/UX Diagrams**
   - User journey
   - Screen navigation
   - Form states
   - Component states

3. **Write Output**
   - Save as uiux.mmd

## Input

```yaml
input:
  file: exploration-report.md
  sections:
    - components.handlers
    - file_structure
```

## Output

```yaml
output:
  file: uiux.mmd
  location: output/{project}/diagrams/diagrams/
  format: mermaid
  diagram_type: stateDiagram-v2
```

## Exit Conditions

- [x] Screens identified
- [x] Navigation mapped
- [x] States documented
- [x] Mermaid syntax valid
- [x] File saved

## Signal

```yaml
signal:
  topic: diagram_created
  payload:
    type: uiux
    path: "{path}/uiux.mmd"
    screens_count: {n}
```

## Sync Point

After all step-03* complete:
→ Signal: all_diagrams_ready
→ Next: Step 04 Verify
