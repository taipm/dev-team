# Step 06: Display Summary

## Metadata

```yaml
step: 6
name: summary
type: sequential
agent: maestro-agent
trigger: aggregation_complete
signal_out: workflow_complete
breakpoint: false
```

## Description

Maestro agent hiển thị summary và kết thúc session.

## Actions

1. **Display Final Summary**

   ```
   ╔═══════════════════════════════════════════════════════════════════════════╗
   ║                    DIAGRAM-TEAM SESSION COMPLETE                          ║
   ╠═══════════════════════════════════════════════════════════════════════════╣
   ║  Session ID: {id}                                                         ║
   ║  Project: {project_name}                                                  ║
   ║  Duration: {duration}                                                     ║
   ╠═══════════════════════════════════════════════════════════════════════════╣
   ║  DIAGRAMS GENERATED                                                       ║
   ║  ├── 🏛️ architecture.mmd    ✅                                            ║
   ║  ├── ⏱️ sequences.mmd       ✅                                            ║
   ║  ├── 📦 classes.mmd         ✅                                            ║
   ║  ├── 🗄️ erd.mmd             ✅                                            ║
   ║  ├── 📂 directory.mmd       ✅                                            ║
   ║  ├── 🧠 logic.mmd           ✅                                            ║
   ║  └── 🎨 uiux.mmd            ✅                                            ║
   ╠═══════════════════════════════════════════════════════════════════════════╣
   ║  VERIFICATION                                                             ║
   ║  Overall Score: {score}%                                                  ║
   ║  Issues Found: {issues_count}                                             ║
   ╠═══════════════════════════════════════════════════════════════════════════╣
   ║  OUTPUT LOCATION                                                          ║
   ║  output/{project}/diagrams/                                               ║
   ╚═══════════════════════════════════════════════════════════════════════════╝
   ```

2. **Show File List**
   - List all generated files with sizes

3. **Offer Next Steps**
   - View diagrams: `open {path}`
   - Export to images: `mmdc -i {file} -o {file}.svg`

4. **Save Session State**
   - Archive session data
   - Update memory

## Exit Conditions

- [x] Summary displayed
- [x] Files listed
- [x] Next steps shown
- [x] Session archived

## Signal

```yaml
signal:
  topic: workflow_complete
  payload:
    session_id: "{id}"
    status: success
    output_path: "{path}"
```

## End

Session complete. User can:
- View diagrams
- Export to images
- Re-run for updates
