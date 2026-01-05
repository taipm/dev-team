# User Preferences Guide

> Hướng dẫn capture, store, và apply user preferences.
> Taipm Agent sử dụng để personalize mọi interaction.

---

## Preference Categories

### 1. Communication Preferences

```yaml
communication:
  language:
    primary: vi | en | ...
    secondary: en | vi | ...
    code_comments: en  # Always English for code

  style:
    response_length: concise | balanced | detailed
    tone: professional | casual | formal
    emoji_usage: none | minimal | moderate | heavy

  format:
    output: markdown | plain | structured
    code_blocks: always | when_needed | minimal
    tables: prefer | avoid
```

**How to detect:**
- Explicit: User says "trả lời ngắn gọn thôi"
- Implicit: User's message length, formality level
- Historical: Track response satisfaction

### 2. Work Pattern Preferences

```yaml
work_patterns:
  active_hours: "09:00-22:00"
  session_length: short | medium | long
  interruption_tolerance: low | medium | high
  focus_mode: strict | flexible

  task_handling:
    parallel_tasks: yes | no
    context_switching: comfortable | avoid
    break_reminders: yes | no
```

**How to detect:**
- Time patterns: When user is most active
- Session behavior: How long sessions typically last
- Response patterns: Quick responses vs thoughtful pauses

### 3. Proactivity Preferences

```yaml
proactivity:
  suggestions:
    level: none | low | medium | high
    timing: immediate | end_of_task | on_request

  reminders:
    level: none | low | medium | high
    style: gentle | direct

  auto_actions:
    level: none | low | medium | high
    require_confirmation: always | sometimes | rarely
```

**How to detect:**
- Feedback on suggestions: "Hay đấy" vs "Không cần"
- Response to proactive offers
- Explicit settings

### 4. Domain Preferences

```yaml
domains:
  primary_focus:
    - golang
    - content_creation
    - research

  preferred_agents:
    coding: [go-dev-agent, go-review-linus-agent]
    content: [audiobook-production-team, youtube-team]
    thinking: [deep-thinking-team, deep-question-agent]

  routing_overrides:
    code_review: go-review-linus-agent
    url_content: audiobook-production-team
    analysis: deep-thinking-team
```

**How to detect:**
- Usage patterns: Which agents called most
- Explicit requests: "Luôn dùng X cho Y"
- Success rates: Which agents produce best results

### 5. Security & Privacy Preferences

```yaml
security:
  auto_approve:
    - read_files
    - search_codebase
    - generate_reports
    - create_drafts

  require_confirmation:
    - publish_content
    - commit_changes
    - send_external
    - delete_files
    - access_credentials

  never_allow:
    - share_env_vars
    - expose_api_keys
```

---

## Preference Learning Protocol

### Capture Methods

```
1. EXPLICIT CAPTURE
   User says: "Tôi thích trả lời ngắn gọn"
   → Update preferences.yaml immediately
   → Confirm: "Đã ghi nhận. Tôi sẽ trả lời concise."

2. IMPLICIT CAPTURE
   Pattern observed: User always edits long responses
   → Track in learning.md
   → After 3 occurrences: Suggest preference update
   → "Tôi nhận thấy bạn thường muốn câu trả lời ngắn hơn. Lưu preference này?"

3. FEEDBACK CAPTURE
   After routing: Track satisfaction
   → Success: Strengthen pattern
   → Failure: Weaken pattern, ask for correction
```

### Storage Locations

```
.microai/memory/
├── preferences.yaml      # Explicit preferences (user-confirmed)
├── context.md           # Current session state
└── insights.md          # Learned patterns (pending confirmation)

.microai/agents/taipm-agent/memory/
├── learning.md          # Routing patterns being learned
└── context.md           # Agent-specific state
```

### Apply Protocol

```
ON EVERY REQUEST:
1. Load preferences.yaml
2. Check for domain-specific overrides
3. Apply communication style
4. Adjust proactivity level
5. Respect security boundaries

ON ROUTING:
1. Check routing_overrides first
2. Apply preferred_agents weights
3. Consider domain focus
4. Log for pattern learning
```

---

## Preference Update Rules

### Immediate Updates (No Confirmation)
- Language preference stated explicitly
- Response style requested
- Agent preference stated

### Confirmation Required
- Inferred patterns (after 3 occurrences)
- Security-related preferences
- Routing overrides

### Never Auto-Update
- Security exceptions
- External integrations
- Deletion permissions

---

## Default Preferences (New User)

```yaml
# Safe defaults for new users
communication:
  primary_language: vi
  response_style: balanced
  emoji_usage: minimal

proactivity:
  suggestions: medium
  reminders: medium
  auto_actions: low

security:
  require_confirmation:
    - all_write_operations
    - external_actions
```

---

## Preference Conflicts Resolution

| Conflict | Resolution |
|----------|------------|
| Session vs Stored | Session preference wins |
| Explicit vs Implicit | Explicit wins |
| User vs System | User wins (except security) |
| Recent vs Old | Recent wins |

---

*Guide maintained by Taipm Agent. Last updated: 2026-01-04*
