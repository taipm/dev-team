# Discovery Methodology

> Phương pháp luận cho việc khám phá codebase dựa trên sự thật

## Core Principles

### 1. Facts-Only Approach
```
╔═══════════════════════════════════════════════════════════════════╗
║  FACTS-ONLY PRINCIPLE                                              ║
╠═══════════════════════════════════════════════════════════════════╣
║                                                                    ║
║  ✓ FACT: "auth.go:15 defines AuthService struct"                 ║
║  ✗ ASSUMPTION: "This probably handles all auth"                   ║
║                                                                    ║
║  ✓ FACT: "import 'redis' found in cache.go:3"                    ║
║  ✗ ASSUMPTION: "They use Redis for caching"                       ║
║                                                                    ║
║  ✓ FACT: "No test files found matching *_test.go"                ║
║  ✗ ASSUMPTION: "This project has no tests"                        ║
║                                                                    ║
╚═══════════════════════════════════════════════════════════════════╝
```

**Rule:** Mọi statement về codebase PHẢI có evidence từ code thực tế.

### 2. Question-Driven Discovery

Discovery được guide bởi câu hỏi có cấu trúc:

```
Question Bank
     │
     ▼
Question Selection (filtered, prioritized)
     │
     ▼
Fact Gathering (search, read, extract)
     │
     ▼
Analysis (patterns, relationships)
     │
     ▼
Derived Questions (if gaps found)
     │
     └──────► Loop back or ──────► Synthesis
```

### 3. Context Continuity

Discovery là quá trình tích lũy:

```
Session 1          Session 2          Session 3
    │                  │                  │
    ▼                  ▼                  ▼
┌─────────┐       ┌─────────┐       ┌─────────┐
│ Findings│──────►│ Findings│──────►│ Findings│
│    +    │       │    +    │       │    +    │
│ Context │       │ Context │       │ Context │
└─────────┘       └─────────┘       └─────────┘
    │                  │                  │
    └─────────────────┴──────────────────┘
                      │
                      ▼
              Cumulative Knowledge
```

### 4. Progressive Deepening

Discovery có 3 levels:

| Level | Depth | Focus | Output |
|-------|-------|-------|--------|
| 1 - Surface | Shallow | Structure, entry points, major components | Overview map |
| 2 - Moderate | Medium | Patterns, relationships, data flow | Detailed analysis |
| 3 - Deep | Deep | Edge cases, hidden logic, full trace | Complete understanding |

## Discovery Process

### Phase 1: Initialize
1. Load previous context (if exists)
2. Determine scope và depth
3. Select questions from bank
4. Prepare for fact gathering

### Phase 2: Gather Facts
1. For each question:
   - Search for relevant files
   - Read và extract facts
   - Record evidence
   - Update context
2. Continue until all questions processed

### Phase 3: Analyze
1. Group facts by category
2. Identify patterns (2+ occurrences)
3. Map relationships
4. Identify gaps

### Phase 4: Deepen (Optional)
1. Evaluate: enough depth?
2. If gaps exist: generate derived questions
3. Loop back to Phase 2
4. Max 3 iterations

### Phase 5: Synthesize
1. Compile structured report
2. Build knowledge graph
3. Generate Q&A entries
4. Update contexts

## Evidence Requirements

### What Counts as Evidence

| Evidence Type | Example | Strength |
|--------------|---------|----------|
| Direct code | `func main() {...}` | HIGH |
| File existence | `config.yaml exists` | HIGH |
| Import statement | `import "redis"` | MEDIUM |
| Config value | `DB_TYPE=postgres` | MEDIUM |
| Comment/Doc | `// This handles auth` | LOW |
| Naming convention | `*_handler.go` | LOW |

### Evidence Format

```yaml
evidence:
  file: "relative/path/to/file.go"
  lines: "15-25"
  snippet: |
    actual code from file
  accessed_at: "timestamp"
  verified: true
```

## Quality Standards

### Fact Quality Checklist
- [ ] Has specific file:line reference
- [ ] Includes actual code snippet
- [ ] Confidence level assigned
- [ ] No words like "probably", "maybe", "likely"
- [ ] Can be independently verified

### Analysis Quality Checklist
- [ ] Patterns have 2+ evidence points
- [ ] Relationships are directional và typed
- [ ] Gaps are clearly defined
- [ ] Cross-referenced with history

### Report Quality Checklist
- [ ] Executive summary present
- [ ] All findings have evidence links
- [ ] Knowledge graph is complete
- [ ] Open questions documented
