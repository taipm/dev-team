# Verification Patterns

Patterns và strategies cho deep verification của diagrams với codebase.

---

## Verification Philosophy

### Goals
1. **Accuracy** - Diagrams reflect actual code
2. **Completeness** - No major components missing
3. **Currency** - Diagrams up-to-date
4. **Consistency** - Naming matches exactly

### Non-Goals
1. **100% coverage** - Focus on key elements
2. **Minor details** - Skip logging, utilities
3. **Style enforcement** - Focus on correctness

---

## Verification Checks

### V1: Entity Exists

**Purpose**: Verify entities in diagram exist in code

**Method**:
```bash
# For class/struct
grep -r "type {EntityName} struct\|class {EntityName}" --include="*.go" --include="*.py" --include="*.ts"

# For function/method
grep -r "func {FunctionName}\|def {FunctionName}\|function {FunctionName}" --include="*.go" --include="*.py" --include="*.ts"

# For interface
grep -r "type {InterfaceName} interface\|interface {InterfaceName}" --include="*.go" --include="*.ts"
```

**Status Values**:
- `verified` - Found exact match
- `missing` - Not found
- `similar` - Found similar name (possible typo)

### V2: Relationship Valid

**Purpose**: Verify connections between entities

**Method**:
```bash
# Check imports
grep -A50 "type {EntityA} struct" {file} | grep "{EntityB}"

# Check function calls
grep -r "{EntityA}.*{EntityB}\|{EntityB}.*{EntityA}" --include="*.go"
```

**Status Values**:
- `verified` - Relationship confirmed
- `invalid` - No connection found
- `reversed` - Connection exists but direction wrong

### V3: Completeness

**Purpose**: Ensure diagram covers key components

**Method**:
1. Load exploration-report.md
2. Extract component list
3. Compare with diagram entities
4. Calculate coverage percentage

**Thresholds**:
- `>90%` - Complete
- `70-90%` - Partial
- `<70%` - Incomplete

### V4: Naming Match

**Purpose**: Names match exactly (case-sensitive)

**Method**:
```python
def check_naming(diagram_name, code_name):
    if diagram_name == code_name:
        return "match"
    elif diagram_name.lower() == code_name.lower():
        return "case_mismatch"
    else:
        return "different"
```

### V5: API Accuracy

**Purpose**: Verify API endpoints exist

**Method**:
```bash
# Go Gin
grep -r "r\.\(GET\|POST\|PUT\|DELETE\)(\"/{path}\"" --include="*.go"

# Express
grep -r "app\.\(get\|post\|put\|delete\)(\"{path}\"" --include="*.js"

# FastAPI
grep -r "@app\.\(get\|post\|put\|delete\)(\"{path}\"" --include="*.py"
```

### V6: ERD Accuracy

**Purpose**: Verify database schema matches

**Method**:
```bash
# GORM models
grep -r "TableName()\|gorm:" --include="*.go"

# SQLAlchemy
grep -r "Column(\|relationship(" --include="*.py"

# Migration files
grep -r "CREATE TABLE\|ALTER TABLE" --include="*.sql"
```

---

## Scoring System

### Per-Check Scoring

```yaml
scores:
  verified: 1.0
  warning: 0.5
  missing: 0.0
  skipped: null  # Don't count
```

### Per-Diagram Score

```python
def calculate_score(checks):
    total_points = sum(check.score for check in checks if check.score is not None)
    total_checks = sum(1 for check in checks if check.score is not None)
    return (total_points / total_checks) * 100
```

### Overall Score

```python
def overall_score(diagrams):
    return sum(d.score for d in diagrams) / len(diagrams)
```

---

## Mismatch Categories

### Severity Levels

| Level | Description | Action |
|-------|-------------|--------|
| Critical | Core component missing | Block release |
| Warning | Minor mismatch | Report |
| Info | Suggestion | Note |

### Common Mismatches

1. **MISSING_ENTITY**
   - Entity in diagram not in code
   - Suggestion: Remove or fix name

2. **EXTRA_ENTITY**
   - Entity in code not in diagram
   - Suggestion: Consider adding

3. **INVALID_RELATIONSHIP**
   - Connection doesn't exist in code
   - Suggestion: Remove or verify

4. **NAME_MISMATCH**
   - Similar but not exact match
   - Suggestion: Use exact name

5. **OUTDATED**
   - Code changed since diagram
   - Suggestion: Update diagram

---

## Resolution Strategies

### For Missing Entities

```yaml
strategy:
  1. Search for similar names (fuzzy match)
  2. Check for renames/refactors
  3. Verify spelling
  4. If truly missing, remove from diagram
```

### For Invalid Relationships

```yaml
strategy:
  1. Trace actual import path
  2. Check for indirect connections
  3. Verify direction
  4. If invalid, remove or correct
```

### For Incomplete Coverage

```yaml
strategy:
  1. Review exploration report
  2. Identify key missing components
  3. Add to diagram if important
  4. Document why excluded if not
```

---

## Automated Verification Commands

### Quick Check Script

```bash
#!/bin/bash
# verify-diagram.sh

DIAGRAM=$1
PROJECT=$2

# Extract entities from Mermaid
entities=$(grep -oP '(?<=\[)[^\]]+' $DIAGRAM)

# Check each entity
for entity in $entities; do
    if grep -rq "$entity" $PROJECT --include="*.go" --include="*.py" --include="*.ts"; then
        echo "✅ $entity: found"
    else
        echo "❌ $entity: not found"
    fi
done
```

---

## Best Practices

1. **Run verification after generation** - Not before
2. **Focus on key entities** - Skip utilities
3. **Document exceptions** - Why something is skipped
4. **Automate where possible** - Use scripts
5. **Report clearly** - Actionable suggestions
