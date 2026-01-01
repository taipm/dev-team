# deep-research

Team chuyên deep research và analysis.

## Tổng Quan

deep-research team thực hiện nghiên cứu chuyên sâu về topics, technologies, hoặc problems.

## Use Cases

- Technology evaluation
- Competitive analysis
- Academic research
- Best practices research

## Kích Hoạt

```
/microai:research
```

## Workflow

```
┌───────────────┐
│  Topic        │
└───────┬───────┘
        │
┌───────▼───────┐
│  Literature   │ ← Collect sources
│  Review       │
└───────┬───────┘
        │
┌───────▼───────┐
│  Deep         │ ← Analyze with frameworks
│  Analysis     │
└───────┬───────┘
        │
┌───────▼───────┐
│  Synthesis    │ ← Generate insights
└───────────────┘
```

## Research Frameworks

Team sử dụng 7 thinking frameworks:

1. **First Principles** - Break down fundamentals
2. **Comparative Analysis** - Compare options
3. **Historical Analysis** - Learn from past
4. **Trend Analysis** - Predict future
5. **Cost-Benefit** - Evaluate trade-offs
6. **Risk Assessment** - Identify risks
7. **Implementation Feasibility** - Practical considerations

## Output Format

```markdown
# Research Report: [Topic]

## Executive Summary
[1-2 paragraph summary]

## Background
[Context and importance]

## Methodology
[How research was conducted]

## Findings

### Finding 1: [Title]
[Details, evidence, sources]

### Finding 2: [Title]
[Details, evidence, sources]

## Analysis
[Deep analysis using frameworks]

## Recommendations
1. [Recommendation]
2. [Recommendation]

## References
- [Source 1]
- [Source 2]
```

## Ví Dụ Session

```
You: /microai:research

Research Team: 🔬 Deep Research Team ready!
What topic would you like me to research?

You: Compare message queue technologies for microservices

Research Team: Starting deep research...

📚 **Literature Review**:
- Reviewed 15 technical papers
- Analyzed 8 case studies
- Examined 5 vendor docs

🔍 **Technologies Analyzed**:
1. Apache Kafka
2. RabbitMQ
3. AWS SQS
4. Redis Streams
5. NATS

📊 **Comparative Analysis**:

| Feature | Kafka | RabbitMQ | SQS | Redis | NATS |
|---------|-------|----------|-----|-------|------|
| Throughput | ⭐⭐⭐ | ⭐⭐ | ⭐⭐ | ⭐⭐ | ⭐⭐⭐ |
| Latency | ⭐⭐ | ⭐⭐⭐ | ⭐ | ⭐⭐⭐ | ⭐⭐⭐ |
| Durability | ⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐ | ⭐ | ⭐⭐ |
| Complexity | High | Medium | Low | Low | Low |

💡 **Key Insights**:
1. Kafka best for high-throughput event streaming
2. RabbitMQ best for complex routing patterns
3. SQS best for AWS-native, low ops overhead
4. Redis best for low-latency, simple use cases
5. NATS best for cloud-native, lightweight needs

📋 **Recommendation**:
For your microservices context, recommend:
- **Primary**: RabbitMQ (balanced features)
- **Alternative**: NATS (if simplicity priority)
- **Avoid**: Kafka (overkill for your scale)
```

## Xem Thêm

- [Specialized Teams Overview](../specialized-teams.md)
- [Problem Solving Workflow](../../workflows/problem-solving.md)
