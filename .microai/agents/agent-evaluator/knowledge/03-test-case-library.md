# Test Case Library

> Thư viện test cases cho dynamic testing via Ollama/Claude.

---

## Test Configuration

```yaml
test_execution:
  provider: ollama
  model: "qwen3:1.7b"
  timeout: 30
  script: ".microai/skills/development-skills/ollama/scripts/ollama-run.sh"
  prefix: "/no_think"  # Disable reasoning output for speed

  fallback:
    provider: claude
    model: sonnet
    timeout: 60

  scoring:
    method: keyword_match  # keyword_match | llm_grading | hybrid
    threshold: 0.6         # Minimum match ratio for pass
```

---

## 1. Reasoning Tests

### 1.1 Logic Puzzles

```yaml
logic_tests:
  # Syllogism
  - id: LOGIC-001
    name: "Basic Syllogism"
    prompt: "All humans are mortal. Socrates is human. Is Socrates mortal?"
    expected: "Yes, Socrates is mortal"
    keywords: ["yes", "mortal", "đúng", "chết"]
    points: 2
    difficulty: easy

  - id: LOGIC-002
    name: "Transitivity"
    prompt: "If A > B and B > C, is A > C?"
    expected: "Yes, by transitivity"
    keywords: ["yes", "đúng", "lớn hơn", "transitive"]
    points: 2
    difficulty: easy

  - id: LOGIC-003
    name: "Logical Fallacy Detection"
    prompt: |
      "All birds can fly. Penguins are birds. Therefore penguins can fly."
      Is this argument valid?
    expected: "Invalid - premise 'all birds can fly' is false"
    keywords: ["invalid", "false", "sai", "không đúng", "penguin"]
    points: 3
    difficulty: medium

  - id: LOGIC-004
    name: "Modus Tollens"
    prompt: "If it rains, the ground is wet. The ground is dry. Did it rain?"
    expected: "No, it did not rain"
    keywords: ["no", "không", "did not", "không mưa"]
    points: 3
    difficulty: medium

  - id: LOGIC-005
    name: "Affirming Consequent Fallacy"
    prompt: "If it rains, the ground is wet. The ground is wet. Did it rain?"
    expected: "Cannot conclude - ground could be wet for other reasons"
    keywords: ["cannot", "not necessarily", "không thể kết luận", "other reasons"]
    points: 4
    difficulty: hard
```

### 1.2 Multi-step Reasoning

```yaml
multistep_tests:
  - id: MULTI-001
    name: "Dependency Chain"
    prompt: "Task A depends on B. B depends on C. C depends on D. What order to execute?"
    expected: "D → C → B → A"
    keywords: ["D", "C", "B", "A"]
    order_matters: true
    points: 3
    difficulty: easy

  - id: MULTI-002
    name: "Complex Dependencies"
    prompt: |
      Tasks: A, B, C, D, E
      - A depends on B and C
      - B depends on D
      - C depends on D
      - E has no dependencies
      What is a valid execution order?
    expected: "E and D first (parallel), then B and C (parallel), then A"
    keywords: ["D", "E", "B", "C", "A"]
    validate: "A must be last, D before B and C"
    points: 5
    difficulty: hard

  - id: MULTI-003
    name: "Spatial Reasoning"
    prompt: |
      5 people stand in a line: A, B, C, D, E
      - A is left of B
      - C is between B and D
      - E is rightmost
      What is the order from left to right?
    expected: "A, B, C, D, E"
    keywords: ["A", "B", "C", "D", "E"]
    order_matters: true
    points: 4
    difficulty: medium
```

### 1.3 Edge Cases

```yaml
edge_tests:
  - id: EDGE-001
    name: "Circular Dependency"
    prompt: "A depends on B. B depends on C. C depends on A. What happens?"
    expected: "Circular dependency detected - cannot execute"
    keywords: ["circular", "cycle", "error", "cannot", "vòng lặp"]
    points: 4
    difficulty: medium

  - id: EDGE-002
    name: "Empty Input"
    prompt: "Sort this list: []. What is the result?"
    expected: "Empty list []"
    keywords: ["empty", "[]", "rỗng", "nothing"]
    points: 2
    difficulty: easy

  - id: EDGE-003
    name: "Division by Zero"
    prompt: "What is 10 / 0?"
    expected: "Undefined or error - division by zero"
    keywords: ["undefined", "error", "không xác định", "chia cho 0"]
    points: 2
    difficulty: easy

  - id: EDGE-004
    name: "Contradictory Constraints"
    prompt: "X must be > 10 and X must be < 5. Is this possible?"
    expected: "No - contradictory constraints"
    keywords: ["no", "impossible", "contradiction", "mâu thuẫn"]
    points: 3
    difficulty: medium
```

---

## 2. Domain Knowledge Tests

### 2.1 Development Domain

```yaml
dev_knowledge_tests:
  - id: DEV-001
    name: "SOLID Principles"
    prompt: "What does SOLID stand for in software engineering?"
    expected: "Single responsibility, Open-closed, Liskov substitution, Interface segregation, Dependency inversion"
    keywords: ["single responsibility", "open-closed", "liskov", "interface segregation", "dependency inversion"]
    min_matches: 3
    points: 3
    difficulty: medium

  - id: DEV-002
    name: "Composition vs Inheritance"
    prompt: "When should you prefer composition over inheritance?"
    expected: "When you need flexibility, runtime behavior change, or has-a relationship"
    keywords: ["flexibility", "has-a", "is-a", "runtime", "coupling", "reuse"]
    min_matches: 2
    points: 3
    difficulty: medium

  - id: DEV-003
    name: "Design Patterns"
    prompt: "What is the Singleton pattern and when is it problematic?"
    expected: "Single instance pattern, problematic for testing and tight coupling"
    keywords: ["single instance", "testing", "coupling", "global state"]
    min_matches: 2
    points: 3
    difficulty: medium
```

### 2.2 QA Domain

```yaml
qa_knowledge_tests:
  - id: QA-001
    name: "Test Pyramid"
    prompt: "Explain the test pyramid concept"
    expected: "More unit tests at base, fewer integration in middle, minimal E2E at top"
    keywords: ["unit", "integration", "e2e", "end-to-end", "pyramid", "bottom", "top"]
    min_matches: 3
    points: 3
    difficulty: easy

  - id: QA-002
    name: "Boundary Value Analysis"
    prompt: "What is boundary value analysis in testing?"
    expected: "Testing at the edges of input ranges - min, max, just below, just above"
    keywords: ["boundary", "edge", "min", "max", "range", "limits"]
    min_matches: 3
    points: 3
    difficulty: medium
```

### 2.3 DevOps Domain

```yaml
devops_knowledge_tests:
  - id: OPS-001
    name: "CI/CD Pipeline"
    prompt: "What are the key stages of a CI/CD pipeline?"
    expected: "Build, test, deploy (and optionally: lint, security scan, staging)"
    keywords: ["build", "test", "deploy", "continuous", "integration", "delivery"]
    min_matches: 3
    points: 3
    difficulty: easy

  - id: OPS-002
    name: "Container vs VM"
    prompt: "What is the main difference between containers and virtual machines?"
    expected: "Containers share host OS kernel, VMs have full OS"
    keywords: ["kernel", "os", "lightweight", "isolation", "hypervisor"]
    min_matches: 2
    points: 3
    difficulty: medium
```

---

## 3. Adaptability Tests

### 3.1 Ambiguity Handling

```yaml
ambiguity_tests:
  - id: AMB-001
    name: "Vague Request"
    prompt: "Fix the bug"
    expected: "Ask for clarification: which bug, where, what symptoms"
    keywords: ["which", "what", "where", "clarify", "more information", "thêm thông tin"]
    min_matches: 1
    points: 3
    difficulty: easy

  - id: AMB-002
    name: "Incomplete Context"
    prompt: "Is this approach better?"
    expected: "Ask: which approach, better than what, for what criteria"
    keywords: ["which", "what approach", "compared to", "criteria", "clarify"]
    min_matches: 1
    points: 3
    difficulty: easy

  - id: AMB-003
    name: "Multiple Interpretations"
    prompt: "Make it faster"
    expected: "Clarify: execution speed, response time, development velocity"
    keywords: ["what", "which", "specify", "performance", "speed"]
    min_matches: 1
    points: 3
    difficulty: medium
```

### 3.2 Error Recovery

```yaml
recovery_tests:
  - id: REC-001
    name: "Invalid Command"
    prompt: "Run this command: xyz_not_a_real_command_123"
    expected: "Gracefully handle: command not found, suggest alternatives"
    keywords: ["not found", "error", "unknown", "try", "did you mean", "suggestion"]
    min_matches: 1
    points: 3
    difficulty: easy

  - id: REC-002
    name: "File Not Found"
    prompt: "Read the file at /this/path/does/not/exist.txt"
    expected: "Handle: file not found, suggest checking path"
    keywords: ["not exist", "not found", "check path", "verify", "error"]
    min_matches: 1
    points: 3
    difficulty: easy

  - id: REC-003
    name: "Syntax Error in Code"
    prompt: "Here is my code: `def foo( print('hello')`. Find the bug."
    expected: "Missing closing parenthesis on function definition"
    keywords: ["parenthesis", "syntax", "missing", ")", "def"]
    min_matches: 2
    points: 3
    difficulty: medium
```

---

## 4. Output Quality Tests

```yaml
output_tests:
  - id: OUT-001
    name: "Concise Explanation"
    prompt: "Explain recursion in exactly 2 sentences."
    criteria:
      sentence_count: 2
      must_include: ["function", "calls itself"]
    points: 2
    difficulty: medium

  - id: OUT-002
    name: "Structured List"
    prompt: "List exactly 5 benefits of version control."
    criteria:
      item_count: 5
      format: "list"
      topic: "version control"
    points: 2
    difficulty: easy

  - id: OUT-003
    name: "Code Output"
    prompt: "Write a function to check if a number is prime. Language: Python."
    criteria:
      has_code_block: true
      language: "python"
      has_function_def: true
    points: 3
    difficulty: medium
```

---

## 5. Test Execution Script

```bash
#!/bin/bash
# run-test.sh - Execute a single test case via Ollama

TEST_PROMPT="$1"
EXPECTED_KEYWORDS="$2"  # Comma-separated

# Run with /no_think prefix for speed
RESPONSE=$(.microai/skills/development-skills/ollama/scripts/ollama-run.sh \
  "/no_think $TEST_PROMPT")

# Check for keyword matches
MATCH_COUNT=0
IFS=',' read -ra KEYWORDS <<< "$EXPECTED_KEYWORDS"
for keyword in "${KEYWORDS[@]}"; do
  if echo "$RESPONSE" | grep -qi "$keyword"; then
    ((MATCH_COUNT++))
  fi
done

# Calculate match ratio
TOTAL_KEYWORDS=${#KEYWORDS[@]}
RATIO=$(echo "scale=2; $MATCH_COUNT / $TOTAL_KEYWORDS" | bc)

echo "Match ratio: $RATIO ($MATCH_COUNT/$TOTAL_KEYWORDS)"
echo "Response: $RESPONSE"
```

---

## 6. Batch Test Runner

```bash
#!/bin/bash
# run-benchmark.sh - Run all tests for an agent

AGENT_NAME="$1"
OUTPUT_DIR="./output/benchmarks/$AGENT_NAME-$(date +%Y%m%d-%H%M%S)"

mkdir -p "$OUTPUT_DIR"

# Run test categories
for category in logic multistep edge knowledge adaptability output; do
  echo "Running $category tests..."
  # Implementation depends on test runner
done

echo "Results saved to: $OUTPUT_DIR"
```
