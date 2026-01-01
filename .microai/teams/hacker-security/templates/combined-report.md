# Attack + Defense Security Report

---

## Document Information

| Field | Value |
|-------|-------|
| **Report Title** | Security Assessment - {TARGET_NAME} |
| **Date** | {DATE} |
| **Mode** | {pentest / red-team / threat-hunt} |
| **Session ID** | {SESSION_ID} |
| **Participants** | 🎭 White Hacker (Shadow), 🔒 Security Engineer |

---

## 1. Executive Summary

### Overall Assessment

```
┌─────────────────────────────────────────────────────────────┐
│                   SECURITY POSTURE                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   Initial State:    [ ] Critical  [ ] High  [ ] Medium     │
│   After Mitigations: [ ] Critical  [ ] High  [ ] Medium    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Findings Summary

| Severity | Found | Mitigated | Open | Bypassed |
|----------|-------|-----------|------|----------|
| Critical | 0 | 0 | 0 | 0 |
| High | 0 | 0 | 0 | 0 |
| Medium | 0 | 0 | 0 | 0 |
| Low | 0 | 0 | 0 | 0 |

### Key Outcomes

- **Vulnerabilities Discovered**: {n}
- **Successfully Mitigated**: {n}
- **Defense Bypass Attempts**: {n} attempted, {n} successful
- **Remaining Risks**: {summary}

---

## 2. Scope & Methodology

### Target

```yaml
target: {target_description}
type: {web_app / api / infrastructure / code_review}
scope:
  in_scope:
    - {item_1}
    - {item_2}
  out_of_scope:
    - {item_1}
```

### Methodology

**Adversarial Testing Approach**:
1. White Hacker identifies attack vectors
2. White Hacker demonstrates exploitation
3. Security Engineer validates and proposes fix
4. White Hacker attempts bypass
5. Iterate until robust defense achieved

---

## 3. Detailed Findings

### Finding Template

---

#### FINDING-{ID}: {Title}

| Attribute | Value |
|-----------|-------|
| **Severity** | {Critical/High/Medium/Low} |
| **CVSS** | {score} |
| **Status** | {Mitigated / Open / Partially Mitigated} |

##### 🎭 Attack Analysis (White Hacker)

**Discovery**:
{How the vulnerability was found}

**Attack Vector**:
{Technical description of the attack}

**Proof of Concept**:
```
{payload_or_code}
```

**Impact**:
{What an attacker could achieve}

##### 🔒 Defense Response (Security Engineer)

**Severity Assessment**:
{Validation of severity and business impact}

**Proposed Mitigation**:
```
{fix_code_or_configuration}
```

**Defense Layers**:
- {layer_1}
- {layer_2}

##### 🎭 Bypass Attempt (White Hacker)

**Bypass Techniques Tried**:
1. {technique_1} → {result}
2. {technique_2} → {result}

**Verdict**: {Fix is robust / Bypass found / Partial mitigation}

##### Final Status

| Aspect | Status |
|--------|--------|
| Primary Attack | {Blocked / Open} |
| Bypass Attempts | {All blocked / Some successful} |
| Defense Robustness | {Robust / Needs improvement} |

---

## 4. Attack Paths Explored

### Kill Chain Summary

```
┌────────────┐     ┌────────────┐     ┌────────────┐
│  Initial   │────→│  Exploit   │────→│  Impact    │
│  Access    │     │            │     │            │
└────────────┘     └────────────┘     └────────────┘
     │                  │                  │
   {vector}          {method}          {outcome}
```

### Attack Chains Tested

| Chain | Steps | Blocked At | Defense |
|-------|-------|------------|---------|
| {name} | {steps} | {step_n} | {defense} |

---

## 5. Defense Effectiveness

### Mitigation Success Rate

```
Proposed Fixes: {n}
├── Robust (no bypass):     {n} ({%})
├── Partial (bypass found): {n} ({%})
└── Ineffective:            {n} ({%})
```

### Defense Layers Implemented

| Layer | Coverage | Status |
|-------|----------|--------|
| Input Validation | {areas} | {implemented/pending} |
| Authentication | {areas} | {implemented/pending} |
| Authorization | {areas} | {implemented/pending} |
| Encryption | {areas} | {implemented/pending} |
| Logging | {areas} | {implemented/pending} |

---

## 6. Recommendations

### Immediate Actions (Critical/High)

| Priority | Finding | Action | Owner |
|----------|---------|--------|-------|
| 1 | {finding} | {action} | {team} |
| 2 | {finding} | {action} | {team} |

### Short-term Actions (Medium)

| Priority | Finding | Action | Owner |
|----------|---------|--------|-------|
| 1 | {finding} | {action} | {team} |

### Strategic Improvements

{Broader security program recommendations}

---

## 7. Session Insights

### What Worked Well

- {insight_1}
- {insight_2}

### Areas for Improvement

- {improvement_1}
- {improvement_2}

### Patterns Observed

| Pattern | Frequency | Recommendation |
|---------|-----------|----------------|
| {pattern} | {count} | {fix} |

---

## 8. Appendices

### A. Session Timeline

| Turn | Time | Speaker | Topic |
|------|------|---------|-------|
| 1 | {time} | {agent} | {topic} |
| 2 | {time} | {agent} | {topic} |

### B. Full Attack Payloads

```
{All payloads used in testing}
```

### C. Defense Code Samples

```
{All fix code proposed}
```

---

## Sign-off

| Role | Name | Signature | Date |
|------|------|-----------|------|
| White Hacker | Shadow | ☑️ | {date} |
| Security Engineer | - | ☑️ | {date} |
| Observer | - | ☑️ | {date} |

---

**CONFIDENTIAL**
*This report contains sensitive security information.*

---

*Generated by Hacker-Security Team*
*Mode: {mode} | Turns: {n} | Duration: {time}*
