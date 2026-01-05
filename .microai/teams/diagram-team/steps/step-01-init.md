# Step 01: Initialize Session

## Metadata

```yaml
step: 1
name: init
type: sequential
agent: maestro-agent
trigger: user_request
signal_out: session_initialized
breakpoint: true
```

## Description

Khởi tạo session diagram-team, validate project path, setup output directory.

## Actions

1. **Receive User Input**
   - Parse project path from user
   - Validate path exists
   - Extract project name

2. **Initialize Session State**
   ```yaml
   session:
     id: "DGT-{YYYY-MM-DD}-{SEQ}"
     project_path: "{path}"
     project_name: "{name}"
     current_phase: 1
     agents_status: {}
     diagrams_created: []
     start_time: "{timestamp}"
   ```

3. **Create Output Directory**
   ```bash
   mkdir -p output/{project_name}/diagrams/diagrams
   mkdir -p output/{project_name}/diagrams/verification
   ```

4. **Display Welcome**
   ```
   ╔═══════════════════════════════════════════════════════════════╗
   ║  DIAGRAM-TEAM SESSION STARTED                                  ║
   ╠═══════════════════════════════════════════════════════════════╣
   ║  Session ID: {id}                                              ║
   ║  Project: {project_name}                                       ║
   ║  Path: {project_path}                                          ║
   ╠═══════════════════════════════════════════════════════════════╣
   ║  Phase 1: Exploration → 7 Parallel Diagrams → Verify → Done   ║
   ╚═══════════════════════════════════════════════════════════════╝
   ```

## Exit Conditions

- [x] Project path validated
- [x] Session state initialized
- [x] Output directory created
- [x] Welcome displayed

## Breakpoint

```
Tiếp tục với Phase 1: Exploration? [Enter để tiếp tục]
```

## Next Step

→ Step 02: Explore
