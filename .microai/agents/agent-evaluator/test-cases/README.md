# Test Cases Library v2.0

> Designed by Deep Thinking Team (Dijkstra, Linus, Polya, Munger)

## Structure

```
test-cases/
├── README.md                 # This file
├── easy/                     # Tier 1: All models should pass (70%+)
│   ├── _index.md            # Tier metadata
│   ├── error-handling.md    # Error handling basics
│   ├── dependency.md        # Simple dependency reasoning
│   ├── go-basics.md         # Go language fundamentals
│   └── concurrency-basics.md # Basic concurrency concepts
├── medium/                   # Tier 2: Local 40-60%, Cloud 70%+
│   ├── _index.md
│   ├── complex-dependency.md
│   ├── context-handling.md
│   ├── error-wrapping.md
│   ├── design-principles.md
│   └── race-conditions.md
├── hard/                     # Tier 3: Local 15-40%, Cloud 50-70%
│   ├── _index.md
│   ├── deadlock-analysis.md
│   ├── code-review.md
│   ├── api-design.md
│   ├── concurrency-patterns.md
│   └── security.md
├── expert/                   # Tier 4: Differentiates opus > sonnet > haiku
│   ├── _index.md
│   ├── system-design.md
│   ├── refactoring.md
│   └── advanced-cache.md
└── ambiguity/               # Tests clarification ability
    ├── _index.md
    ├── vague-requests.md
    ├── underspecified.md
    └── contradictory.md
```

## Test File Format

Each `.md` file follows this format:

```markdown
---
id: E-1
name: Test Name
category: Logic|Concurrency|Security|Design|...
difficulty: 1-10
points: 1-12
keywords:
  - keyword1
  - keyword2
---

# Test Name

## Prompt

<prompt>
The actual test prompt goes here.
Can be multi-line.
</prompt>

## Expected Behavior

Description of what a good answer should include.

## Rubric

| Score | Criteria |
|-------|----------|
| Full  | ... |
| 75%   | ... |
| 50%   | ... |
| 25%   | ... |

## Notes

Additional context for grading.
```

## Scoring Philosophy

**Quality of reasoning > Presence of keywords**

- Keywords are used for automated initial scoring
- Final score considers reasoning quality
- Partial credit for incomplete but correct reasoning

## Tier Expected Performance

| Tier | Local Models | Haiku | Sonnet | Opus |
|------|--------------|-------|--------|------|
| Easy (15 pts) | 70%+ | 85%+ | 90%+ | 95%+ |
| Medium (25 pts) | 40-60% | 60%+ | 75%+ | 85%+ |
| Hard (35 pts) | 15-40% | 30%+ | 50%+ | 70%+ |
| Expert (25 pts) | 5-15% | 10%+ | 30%+ | 50%+ |
| Ambiguity (10 pts) | 30-50% | 50%+ | 70%+ | 80%+ |

## Adding New Tests

1. Create a new `.md` file in the appropriate tier folder
2. Follow the test file format with YAML frontmatter
3. Update the tier's `_index.md` to include the new test
4. Run validation: `./scripts/validate-tests.sh`
