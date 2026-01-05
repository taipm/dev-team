# Handoff Protocol

> Quy trình delegate tasks đến agents/teams với context đầy đủ.
> Đảm bảo continuity và quality across handoffs.

---

## Handoff Package Structure

Khi Taipm Agent delegate đến agent/team khác, LUÔN include:

```yaml
handoff_package:
  # 1. METADATA
  meta:
    from: taipm-agent
    to: {target_agent}
    timestamp: {ISO datetime}
    handoff_id: {uuid}
    priority: low | medium | high | urgent

  # 2. CONTEXT
  context:
    current_project: "{from .microai/memory/context.md}"
    recent_sessions: "{relevant recent sessions}"
    user_preferences: "{from preferences.yaml}"
    relevant_insights: "{from insights.md}"

  # 3. REQUEST
  request:
    original_input: "{exact user input}"
    detected_intent: "{intent analysis}"
    confidence: {0-100}
    routing_reason: "{why this agent}"

  # 4. INSTRUCTIONS
  instructions:
    language: vi  # Response language
    style: "{from preferences}"
    report_back: true | false
    update_memory: true | false

  # 5. CONSTRAINTS (if any)
  constraints:
    timeout: {minutes}
    scope: "{boundaries}"
    avoid: ["{things to avoid}"]
```

---

## Handoff Types

### 1. Full Delegation

Agent hoàn toàn xử lý, Taipm không cần intervene.

```yaml
type: full_delegation
when:
  - Clear intent match
  - Confident routing (>80%)
  - No special requirements

behavior:
  - Send handoff package
  - Wait for completion
  - Receive summary
  - Update memory
```

### 2. Supervised Delegation

Taipm monitors và có thể intervene.

```yaml
type: supervised
when:
  - Complex multi-step tasks
  - First time with this agent
  - User preference for oversight

behavior:
  - Send handoff package
  - Receive progress updates
  - Can redirect if needed
  - Final approval before completion
```

### 3. Collaborative Handoff

Multiple agents work together, Taipm coordinates.

```yaml
type: collaborative
when:
  - Cross-domain tasks
  - Workflow chaining
  - Team orchestration needed

behavior:
  - Orchestrate sequence
  - Pass context between agents
  - Merge outputs
  - Synthesize final result
```

---

## Pre-Handoff Checklist

Before every handoff, verify:

```
□ Intent detected correctly?
□ Target agent is appropriate?
□ Context loaded from memory?
□ User preferences applied?
□ Instructions clear?
□ Constraints defined?
□ Return path established?
```

---

## Handoff Examples

### Example 1: Simple Delegation

```yaml
# User: "Review code Go này"

handoff_package:
  meta:
    from: taipm-agent
    to: go-review-linus-agent
    priority: medium

  context:
    current_project: "dev-team evolution"
    user_preferences:
      code_review: brutal_honest

  request:
    original_input: "Review code Go này"
    detected_intent: go_code_review
    confidence: 95
    routing_reason: "Explicit Go review request + user preference"

  instructions:
    language: vi
    style: concise
    report_back: true
```

### Example 2: Team Delegation

```yaml
# User: "Tạo audiobook từ URL này: https://..."

handoff_package:
  meta:
    from: taipm-agent
    to: audiobook-production-team
    priority: medium

  context:
    current_project: "dev-team evolution"
    user_preferences:
      content_creation: audiobook-production-team
      tts_voice: vi-VN-female

  request:
    original_input: "Tạo audiobook từ URL này: https://..."
    detected_intent: url_to_audiobook
    confidence: 98
    routing_reason: "URL + audiobook keyword + user default"
    source_url: "https://..."

  instructions:
    language: vi
    update_memory: true
    output_dir: "output/audiobooks/{date}-{slug}/"
```

### Example 3: Collaborative Handoff

```yaml
# User: "Phân tích vấn đề này và đề xuất solution"

handoff_sequence:
  - step: 1
    to: deep-question-agent
    purpose: "Explore problem space"
    output: "Problem insights"

  - step: 2
    to: deep-thinking-team
    purpose: "Analyze and solve"
    input: "{output from step 1}"
    output: "Solution blueprint"

  - step: 3
    to: algo-function-agent
    purpose: "Design implementation"
    input: "{output from step 2}"
    output: "Implementation spec"

  coordination:
    orchestrator: taipm-agent
    pass_context: true
    merge_outputs: true
```

---

## Return Protocol

Khi agent/team hoàn thành, return:

```yaml
return_package:
  # Status
  status: success | partial | failed

  # Summary for memory
  summary:
    task_completed: "{brief description}"
    key_outputs: ["{list of outputs}"]
    insights_discovered: ["{any insights}"]

  # Artifacts (if any)
  artifacts:
    - path: "{file path}"
      type: "{file type}"
      description: "{what it is}"

  # Recommendations (if any)
  recommendations:
    - "{follow-up suggestion}"

  # Memory updates
  memory_updates:
    context: "{updates to context.md}"
    insights: "{updates to insights.md}"
```

---

## Error Handling

### Handoff Failed

```yaml
on_handoff_failure:
  - Log error to memory
  - Notify user: "Không thể route đến {agent}. Lý do: {reason}"
  - Suggest alternatives
  - Offer direct handling if possible
```

### Agent Timeout

```yaml
on_timeout:
  - Check partial results
  - Save progress to memory
  - Notify user
  - Offer to: retry | switch agent | cancel
```

### Agent Error

```yaml
on_agent_error:
  - Capture error details
  - Log to memory/errors.md
  - Notify user with context
  - Suggest recovery options
```

---

## Memory Sync Protocol

After successful handoff:

```
1. RECEIVE return_package from agent
2. UPDATE .microai/memory/context.md
   - Add session summary
   - Update active project
   - Record key outputs
3. UPDATE .microai/memory/insights.md (if new insights)
4. UPDATE routing statistics in learning.md
5. NOTIFY user of completion
```

---

## Quality Metrics

Track for continuous improvement:

| Metric | Target | Track In |
|--------|--------|----------|
| Handoff Success Rate | >95% | learning.md |
| Routing Accuracy | >90% | learning.md |
| User Satisfaction | >85% | preferences (feedback) |
| Context Preservation | 100% | memory sync logs |

---

*Protocol maintained by Taipm Agent. Last updated: 2026-01-04*
