# Step 02: Issue/Feature Presentation

## Objective
First speaker presents the topic for discussion.

## Presentation by Mode

### Test Plan Mode - Developer Presents

```markdown
[Turn 1 - Developer] 👨‍💻

Chào QA! Tôi có feature mới cần tạo test plan.

**Feature:** {feature_name}

**User Story:**
As a {persona}, I want {capability}, so that {business_value}.

**Scope:**
- In scope: {list}
- Out of scope: {list}

**Technical Approach:**
{brief_description}

**Key Areas Cần Testing:**
1. {area_1}
2. {area_2}
3. {area_3}

**Known Risks:**
- {risk_1}
- {risk_2}

[Chờ QA review và đặt câu hỏi...]

───────────────────────────────────────────────────────────────
Turn 1 | Mode: Test Plan | Speaker: Developer
```

### Bug Triage Mode - QA Presents

```markdown
[Turn 1 - QA Engineer] 🔍

Dev ơi, tôi phát hiện bug cần discuss.

**Bug Summary:** {one_liner}

**Severity:** {Critical/High/Medium/Low}
**Priority (proposed):** {P1/P2/P3/P4}

**Environment:**
- Version: {app_version}
- Browser: {browser}
- OS: {os}

**Steps to Reproduce:**
1. {step_1}
2. {step_2}
3. {step_3}

**Expected Result:**
{expected}

**Actual Result:**
{actual}

**Evidence:**
{screenshots/logs/video}

**Initial Analysis:**
{suspected_cause_if_any}

[Dev cần thêm info gì không?]

───────────────────────────────────────────────────────────────
Turn 1 | Mode: Bug Triage | Speaker: QA Engineer
```

### Code Review Mode - Developer Presents

```markdown
[Turn 1 - Developer] 👨‍💻

Chào QA! Tôi có PR cần QA review.

**PR/Change:** {pr_title}

**Purpose:**
{why_this_change}

**Files Changed:**
- `{file_1}` - {change_description}
- `{file_2}` - {change_description}

**Key Changes:**
1. {change_1}
2. {change_2}

**Test Coverage:**
- Unit tests: {status}
- Integration tests: {status}

**Areas Cần QA Focus:**
1. {area_1} - {why}
2. {area_2} - {why}

**Potential Risks:**
- {risk_1}

[QA có câu hỏi gì không?]

───────────────────────────────────────────────────────────────
Turn 1 | Mode: Code Review | Speaker: Developer
```

## State Update After Presentation

```yaml
session:
  turn_count: 1
  phase: "presentation"
  dialogue_history:
    - turn: 1
      speaker: "{first_speaker}"
      message: "{presentation_content}"
      timestamp: "{ISO_timestamp}"
      type: "presentation"
```

## Observer Prompt After Turn 1

```javascript
AskUserQuestion({
  questions: [{
    question: "Turn 1 complete. {speaker} đã present. Bạn muốn làm gì?",
    header: "Turn 1",
    options: [
      { label: "Tiếp tục", description: "{other_agent} sẽ respond" },
      { label: "Can thiệp", description: "Nhập message @qa/@dev/@guide" },
      { label: "Skip to synthesis", description: "Nhảy đến tạo output" },
      { label: "Kết thúc session", description: "Dừng và lưu progress" }
    ],
    multiSelect: false
  }]
})
```

## Transition

→ After Turn 1 and observer choice:
  - If "Tiếp tục" → Step 03: Dialogue Loop với other agent
  - If "Can thiệp" → Process intervention, then continue
  - If "Skip" → Step 04: Output Synthesis
  - If "Kết thúc" → Step 05: Session Close
