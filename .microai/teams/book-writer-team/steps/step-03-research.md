# Step 03: Research

## Agent
🔍 **Researcher Agent** - Research & Fact-checking Specialist

## Trigger
Step 02 hoàn thành, outline approved

## Actions

### 1. Activate Researcher Agent
```
Load: ./agents/researcher-agent.md
Load knowledge: ./knowledge/researcher/research-methodology.md
Receive: Outline from Step 02
Update state: current_agent = "researcher"
```

### 2. Research Each Chapter
```
For each chapter in outline:
1. Research main topics
2. Find authoritative sources
3. Collect code examples
4. Verify technical accuracy
5. Compile research notes
```

### 3. Source Verification
```
For each source:
- Check recency (prefer < 2 years for tech topics)
- Check authority (official docs, reputable authors)
- Cross-reference claims
- Test code examples when possible
```

### 4. Code Example Collection
```
For each code example:
- Verify it compiles/runs
- Note version requirements
- Document any dependencies
- Create minimal working version
```

### 5. Create Research Report

```
🔍 **RESEARCH REPORT**

══════════════════════════════════════════════════════════════

CHAPTER 1: {Title}

Sources Found: {count}
Code Examples: {count}
Confidence: {High/Medium/Low}

KEY FINDINGS:
- {finding 1}
- {finding 2}

VERIFIED CODE EXAMPLES:
```{language}
// Example 1: {description}
{code}
```

REFERENCES:
1. {Official documentation URL}
2. {Authoritative book/article}
3. {Verified blog post}

NOTES FOR WRITER:
- {Note about tricky topics}
- {Note about common misconceptions}

══════════════════════════════════════════════════════════════

CHAPTER 2: {Title}
[...]

══════════════════════════════════════════════════════════════

RESEARCH SUMMARY:
- Total sources: {count}
- Total code examples: {count}
- Chapters fully researched: {count}/{total}
- Open questions: {list}

══════════════════════════════════════════════════════════════
```

## Communication
```yaml
publishes:
  topic: research
  message:
    type: research_complete
    data:
      chapters: [{research per chapter}]
      sources: [{all sources}]
      code_examples: [{verified examples}]
```

## Output
```yaml
outputs:
  research:
    chapters: [{research notes per chapter}]
    sources: [{all sources with URLs}]
    code_examples: [{verified code examples}]
    path: "./docs/books/{book_name}/research/"

quality_metrics:
  research_done: true
```

## Checkpoint
```
./checkpoints/step-03-research-{timestamp}.yaml
```

## Next Step
→ Step 04: Writing (Writer Agent)
