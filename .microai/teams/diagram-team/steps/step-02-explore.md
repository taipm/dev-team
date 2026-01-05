# Step 02: Explore Codebase

## Metadata

```yaml
step: 2
name: explore
type: sequential
agent: explorer-agent
trigger: session_initialized
signal_out: exploration_complete
breakpoint: false
```

## Description

Explorer agent phân tích toàn bộ codebase, extract tech stack, components, và relationships.

## Actions

1. **Scan Directory Structure**
   ```bash
   tree -L 4 -I 'node_modules|.git|__pycache__|.venv|vendor' {project_path}
   ```

2. **Detect Tech Stack**
   - Check for package.json (Node.js)
   - Check for go.mod (Go)
   - Check for requirements.txt/pyproject.toml (Python)
   - Check for Cargo.toml (Rust)

3. **Extract Components**
   - Services
   - Handlers/Controllers
   - Models/Entities
   - Repositories

4. **Map Relationships**
   - Import statements
   - API routes
   - Database access

5. **Generate Report**
   - Write `exploration-report.md`
   - Include all findings

## Output

```yaml
output:
  file: exploration-report.md
  location: output/{project}/diagrams/
```

## Exit Conditions

- [x] Directory scanned
- [x] Tech stack identified
- [x] Components extracted
- [x] Relationships mapped
- [x] Report generated

## Signal

```yaml
signal:
  topic: exploration_complete
  payload:
    project_name: "{name}"
    tech_stack: ["{stack}"]
    components_count: {n}
    report_path: "{path}"
```

## Next Step

→ Steps 03a-03g (Parallel)
