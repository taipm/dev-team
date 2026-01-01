# mining-team

Team chuyên mining insights từ data và requirements.

## Tổng Quan

mining-team giúp extract insights, patterns, và hidden requirements từ various sources.

## Use Cases

- Mining requirements từ documents
- Extracting patterns từ logs
- Analyzing user feedback
- Finding insights trong data

## Kích Hoạt

```
/microai:mining
```

## Workflow

```
┌───────────────┐
│  Data Source  │
└───────┬───────┘
        │
┌───────▼───────┐
│  Extraction   │ ← Raw data parsing
└───────┬───────┘
        │
┌───────▼───────┐
│  Analysis     │ ← Pattern recognition
└───────┬───────┘
        │
┌───────▼───────┐
│  Synthesis    │ ← Insights generation
└───────────────┘
```

## Output Formats

### Insights Report

```markdown
# Mining Report: [Source]

## Summary
- Documents analyzed: X
- Key findings: Y

## Patterns Found
1. Pattern A (frequency: 80%)
2. Pattern B (frequency: 45%)

## Hidden Requirements
- Implicit requirement 1
- Implicit requirement 2

## Recommendations
- Based on analysis...
```

## Ví Dụ Session

```
You: /microai:mining

Mining Team: ⛏️ Mining Team ready!
What would you like to mine today?
- Documents for requirements
- Logs for patterns
- Feedback for insights

You: Analyze user feedback from support tickets

Mining Team: Processing 500 tickets...

📊 **Analysis Results**:

**Top Issues** (by frequency):
1. Login problems (23%)
2. Payment failures (18%)
3. Slow loading (15%)

**Hidden Patterns**:
- Login issues spike on Mondays
- Payment failures correlate with mobile users
- Loading issues mainly from region Asia

**Implicit Requirements**:
1. Need better mobile payment UX
2. Need CDN in Asia region
3. Need Monday morning capacity

**Recommended Actions**:
1. [High] Investigate mobile payment flow
2. [Medium] Add Asia CDN endpoint
3. [Low] Scale up Monday AM capacity
```

## Xem Thêm

- [Specialized Teams Overview](../specialized-teams.md)
- [Use Cases](../../workflows/use-cases.md)
