# Threat Modeling Guide

## Overview
Threat modeling là process để identify, communicate, và understand threats và mitigations trong context của protecting something of value.

---

## 1. Threat Modeling Basics

### Four Questions of Threat Modeling
1. **What are we working on?** → System model
2. **What can go wrong?** → Threats
3. **What are we going to do about it?** → Mitigations
4. **Did we do a good job?** → Validation

### When to Threat Model
- New feature development
- Architecture changes
- Security review
- After security incident
- Periodically (annual review)

---

## 2. STRIDE Framework

### Overview
```
S - Spoofing          → Impersonating something or someone
T - Tampering         → Modifying data or code
R - Repudiation       → Denying having performed an action
I - Information Disclosure → Exposing information to unauthorized party
D - Denial of Service → Denying or degrading service
E - Elevation of Privilege → Gaining unauthorized capabilities
```

### STRIDE to Security Property

| Threat | Security Property | Example |
|--------|------------------|---------|
| Spoofing | Authentication | Stolen credentials |
| Tampering | Integrity | SQL injection |
| Repudiation | Non-repudiation | Missing audit logs |
| Info Disclosure | Confidentiality | Data leak |
| Denial of Service | Availability | DDoS attack |
| Elevation of Privilege | Authorization | Broken access control |

### STRIDE Analysis Template

```markdown
## Component: {component_name}

### Spoofing
- [ ] Can an attacker impersonate a user?
- [ ] Can an attacker impersonate the system?
- Threats: {list}
- Mitigations: {list}

### Tampering
- [ ] Can data in transit be modified?
- [ ] Can data at rest be modified?
- Threats: {list}
- Mitigations: {list}

### Repudiation
- [ ] Can a user deny performing an action?
- [ ] Are actions logged with sufficient detail?
- Threats: {list}
- Mitigations: {list}

### Information Disclosure
- [ ] Can sensitive data be exposed?
- [ ] Is data encrypted appropriately?
- Threats: {list}
- Mitigations: {list}

### Denial of Service
- [ ] Can the service be overwhelmed?
- [ ] Are there resource limits?
- Threats: {list}
- Mitigations: {list}

### Elevation of Privilege
- [ ] Can a user gain admin privileges?
- [ ] Are permissions properly enforced?
- Threats: {list}
- Mitigations: {list}
```

---

## 3. Data Flow Diagram (DFD)

### Elements

```
┌──────────────┐
│   Process    │  → Circle/rounded rectangle
│  (transforms │
│     data)    │
└──────────────┘

╔══════════════╗
║  Data Store  ║  → Parallel lines
║ (persists    ║
║    data)     ║
╚══════════════╝

┌──────────────┐
│   External   │  → Square/rectangle
│    Entity    │
│ (outside     │
│   system)    │
└──────────────┘

       ───────────────►
       Data Flow (arrow with data label)

- - - - - - - - - - - -
       Trust Boundary (dashed line)
```

### Example DFD

```
                    Trust Boundary
- - - - - - - - - - - -│- - - - - - - - - - - - - - - -
                       │
┌─────────┐            │    ┌───────────┐      ╔═══════════╗
│  User   │ ──HTTP───► │ ►──│ Web Server│──SQL─►║  Database ║
│(Browser)│            │    │  (Node.js)│◄─────║(PostgreSQL)║
└─────────┘            │    └─────┬─────┘      ╚═══════════╝
                       │          │
                       │          │ API Call
                       │          ▼
                       │    ┌───────────┐
                       │    │ Auth Svc  │
                       │    │  (JWT)    │
                       │    └───────────┘
```

### Trust Boundaries
- Browser ↔ Server
- Server ↔ Database
- Internal ↔ External services
- User ↔ Admin zones

---

## 4. Attack Trees

### Structure
```
                    ┌────────────────────┐
                    │       Goal         │
                    │ (Attacker's aim)   │
                    └─────────┬──────────┘
                              │
              ┌───────────────┼───────────────┐
              │               │               │
        ┌─────┴─────┐   ┌─────┴─────┐   ┌─────┴─────┐
        │ Method 1  │   │ Method 2  │   │ Method 3  │
        │   (OR)    │   │   (OR)    │   │   (OR)    │
        └─────┬─────┘   └───────────┘   └───────────┘
              │
      ┌───────┴───────┐
      │               │
┌─────┴─────┐   ┌─────┴─────┐
│  Step 1   │   │  Step 2   │
│  (AND)    │   │  (AND)    │
└───────────┘   └───────────┘
```

### Example: Steal User Credentials

```
                    ┌────────────────────────┐
                    │   Steal User Creds     │
                    └───────────┬────────────┘
                                │
        ┌───────────────────────┼───────────────────────┐
        │                       │                       │
┌───────┴───────┐       ┌───────┴───────┐       ┌───────┴───────┐
│ Phishing      │       │ SQL Injection │       │ Brute Force   │
│ (Social Eng)  │       │ (Technical)   │       │ (Technical)   │
└───────┬───────┘       └───────────────┘       └───────┬───────┘
        │                                               │
        │                                       ┌───────┴───────┐
┌───────┴───────┐                               │               │
│               │                       ┌───────┴───┐   ┌───────┴───┐
│  Send fake    │                       │ Get user  │   │ Bypass    │
│  login page   │                       │ list      │   │ lockout   │
└───────────────┘                       └───────────┘   └───────────┘
```

---

## 5. Risk Assessment

### Likelihood × Impact Matrix

```
        │  Low Impact  │  Med Impact  │  High Impact │
────────┼──────────────┼──────────────┼──────────────┤
High    │    Medium    │     High     │   Critical   │
Likely  │              │              │              │
────────┼──────────────┼──────────────┼──────────────┤
Medium  │     Low      │    Medium    │     High     │
Likely  │              │              │              │
────────┼──────────────┼──────────────┼──────────────┤
Low     │  Acceptable  │     Low      │    Medium    │
Likely  │              │              │              │
────────┴──────────────┴──────────────┴──────────────┘
```

### DREAD Rating (Alternative)

| Factor | Description | Scale |
|--------|-------------|-------|
| **D**amage | How bad is the impact? | 1-10 |
| **R**eproducibility | How easy to reproduce? | 1-10 |
| **E**xploitability | How easy to exploit? | 1-10 |
| **A**ffected Users | How many users impacted? | 1-10 |
| **D**iscoverability | How easy to find? | 1-10 |

**Risk Score = (D + R + E + A + D) / 5**

---

## 6. Threat Modeling Session Template

### Session Info
```yaml
date: YYYY-MM-DD
participants:
  - Developer
  - Security Engineer
scope: "{feature/system being modeled}"
duration: "{estimated time}"
```

### Step 1: Scope Definition
```markdown
## System Overview
{Brief description of the system/feature}

## Assets to Protect
1. {Asset 1} - Sensitivity: {High/Medium/Low}
2. {Asset 2} - Sensitivity: {Level}

## Out of Scope
- {What we're not considering}
```

### Step 2: DFD Creation
```markdown
## Data Flow Diagram
{Diagram or description}

## Trust Boundaries
1. {Boundary 1}: {What it separates}
2. {Boundary 2}: {What it separates}

## Entry Points
1. {Entry point 1}: {Authentication required?}
2. {Entry point 2}: {Authentication required?}
```

### Step 3: Threat Identification (STRIDE)
```markdown
## Threats Identified

### T1: {Threat Name}
- **Category**: {S/T/R/I/D/E}
- **Component**: {affected component}
- **Description**: {what could happen}
- **Attack Vector**: {how attacker exploits}
- **Likelihood**: {High/Medium/Low}
- **Impact**: {High/Medium/Low}
- **Risk**: {Critical/High/Medium/Low}

### T2: {Next Threat}
...
```

### Step 4: Mitigation Planning
```markdown
## Mitigations

### M1: {Mitigation for T1}
- **Threat**: T1
- **Control Type**: {Preventive/Detective/Corrective}
- **Implementation**: {how to implement}
- **Status**: {Planned/In Progress/Implemented}
- **Owner**: {Dev/Security}

### M2: {Next Mitigation}
...
```

### Step 5: Summary
```markdown
## Risk Summary

| Threat | Risk | Mitigation | Status |
|--------|------|------------|--------|
| T1 | High | M1 | Planned |
| T2 | Medium | M2 | Implemented |

## Action Items
- [ ] {Action 1} - Owner: {name}
- [ ] {Action 2} - Owner: {name}
```

---

## 7. Common Threat Patterns

### Web Application
```
1. Injection attacks (SQL, Command, XSS)
2. Broken authentication
3. Sensitive data exposure
4. Broken access control
5. Security misconfiguration
6. CSRF/SSRF
```

### API
```
1. Broken object level authorization
2. Broken authentication
3. Excessive data exposure
4. Lack of resources & rate limiting
5. Broken function level authorization
6. Mass assignment
```

### Microservices
```
1. Service-to-service authentication
2. Secret management
3. API gateway security
4. Container vulnerabilities
5. Network segmentation
6. Data consistency
```

---

## References

- [Microsoft Threat Modeling](https://docs.microsoft.com/en-us/azure/security/develop/threat-modeling-tool)
- [OWASP Threat Modeling](https://owasp.org/www-community/Threat_Modeling)
- [Adam Shostack - Threat Modeling](https://shostack.org/books/threat-modeling-book)
