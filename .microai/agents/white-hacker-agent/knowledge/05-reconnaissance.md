# Reconnaissance Techniques

> Intelligence gathering and attack surface mapping - the foundation of successful penetration testing.

---

## OSINT (Open Source Intelligence)

### 1.1 Domain & Company Research

**Organizational OSINT**:
```bash
# WHOIS lookups
whois target.com
whois 1.2.3.4

# DNS enumeration
dig target.com any
dig target.com ns
dig target.com mx
dig target.com txt
host -t axfr target.com ns1.target.com  # Zone transfer attempt

# Reverse DNS
host 1.2.3.4
dig -x 1.2.3.4

# BGP & ASN info
whois -h whois.radb.net AS12345
curl https://api.bgpview.io/asn/12345/prefixes
```

**People & Employee Research**:
```bash
# LinkedIn (manual)
site:linkedin.com "target company"
site:linkedin.com/in "target company" "engineer"

# Email format discovery
hunter.io
phonebook.cz
emailformat.com

# Leaked credentials
haveibeenpwned.com (API)
dehashed.com
breachforums (use caution)
```

### 1.2 Google Dorking

**Basic Dorks**:
```
# Find subdomains
site:*.target.com

# Find login pages
site:target.com inurl:login
site:target.com inurl:admin
site:target.com intitle:"login"

# Find exposed files
site:target.com filetype:pdf
site:target.com filetype:doc
site:target.com filetype:xls
site:target.com filetype:sql
site:target.com filetype:log
site:target.com filetype:bak

# Find directories
site:target.com intitle:"index of"
site:target.com intitle:"directory listing"
```

**Advanced Dorks**:
```
# Find configuration files
site:target.com ext:xml | ext:conf | ext:cnf | ext:cfg | ext:ini

# Find backup files
site:target.com ext:bak | ext:backup | ext:old | ext:temp

# Find credentials in files
site:target.com filetype:txt password
site:target.com filetype:log username password

# Find exposed git
site:target.com ".git"
site:target.com inurl:.git

# Find error messages (info disclosure)
site:target.com "sql syntax" | "mysql_fetch" | "ORA-"
site:target.com "Warning:" | "Error:" | "exception"

# Find admin panels
site:target.com inurl:admin | inurl:adminpanel | inurl:administrator
site:target.com inurl:wp-admin | inurl:wp-login
```

### 1.3 Shodan & Censys

**Shodan Queries**:
```
# Find by organization
org:"Target Company"

# Find by hostname
hostname:target.com

# Find by SSL certificate
ssl.cert.subject.CN:target.com
ssl:"target.com"

# Find specific services
hostname:target.com port:22
hostname:target.com port:3389
hostname:target.com product:nginx
hostname:target.com product:Apache

# Find vulnerabilities
vuln:CVE-2021-44228 org:"Target"
http.title:"Dashboard" org:"Target"
```

**Censys Queries**:
```
# Search by domain
services.tls.certificates.leaf_data.names: target.com

# Search by IP range
ip: [1.2.3.0 TO 1.2.3.255]

# Search by organization
services.software.product: nginx AND autonomous_system.organization: "Target"
```

---

## Subdomain Enumeration

### 2.1 Passive Enumeration

**Certificate Transparency**:
```bash
# crt.sh
curl -s "https://crt.sh/?q=%.target.com&output=json" | jq -r '.[].name_value' | sort -u

# certspotter
curl -s "https://api.certspotter.com/v1/issuances?domain=target.com&include_subdomains=true" | jq -r '.[].dns_names[]' | sort -u
```

**Passive DNS Sources**:
```bash
# Subfinder (aggregates multiple sources)
subfinder -d target.com -silent

# Amass passive mode
amass enum -passive -d target.com

# theHarvester
theHarvester -d target.com -b all

# Combine results
subfinder -d target.com -silent | sort -u > subs.txt
amass enum -passive -d target.com -o amass.txt
cat subs.txt amass.txt | sort -u > all_subs.txt
```

### 2.2 Active Enumeration

**DNS Brute Force**:
```bash
# Using dnsrecon
dnsrecon -d target.com -D wordlist.txt -t brt

# Using gobuster
gobuster dns -d target.com -w wordlist.txt

# Using massdns (fast)
massdns -r resolvers.txt -t A -o S -w results.txt subdomains.txt
```

**Virtual Host Discovery**:
```bash
# ffuf for vhost discovery
ffuf -w wordlist.txt -u https://target.com -H "Host: FUZZ.target.com" -fs 0

# gobuster vhost
gobuster vhost -u https://target.com -w wordlist.txt
```

### 2.3 Subdomain Takeover

**Detection**:
```bash
# Check for dangling CNAMEs
dig subdomain.target.com CNAME

# Common takeover indicators
# - CNAME pointing to: github.io, herokuapp.com, s3.amazonaws.com, etc.
# - Service returns 404 or "This site can't be reached"

# Automated tools
subjack -w subs.txt -t 100 -timeout 30 -ssl -c fingerprints.json
nuclei -l subs.txt -t nuclei-templates/takeovers/
```

**Takeover Scenarios**:
```markdown
| Service | CNAME Example | Takeover Method |
|---------|---------------|-----------------|
| GitHub Pages | user.github.io | Create repo with matching name |
| Heroku | app.herokuapp.com | Create app with same name |
| AWS S3 | bucket.s3.amazonaws.com | Create bucket with same name |
| Azure | app.azurewebsites.net | Register app with same name |
| Shopify | shops.myshopify.com | Contact Shopify to claim |
```

---

## Technology Fingerprinting

### 3.1 Web Stack Detection

**Manual Detection**:
```bash
# HTTP headers
curl -I https://target.com

# Look for:
# - Server header (Apache, Nginx, IIS)
# - X-Powered-By (PHP, ASP.NET)
# - X-Generator (WordPress, Drupal)
# - Cookies (PHPSESSID, ASP.NET_SessionId)

# HTML source analysis
curl -s https://target.com | grep -i "generator\|powered\|framework"
```

**Automated Tools**:
```bash
# whatweb
whatweb -a 3 https://target.com

# wappalyzer-cli
wappalyzer https://target.com

# nikto
nikto -h https://target.com

# builtwith
# Use online tool: builtwith.com
```

### 3.2 Framework Detection

**WordPress**:
```bash
# Check common paths
curl -s https://target.com/wp-admin/ -o /dev/null -w "%{http_code}"
curl -s https://target.com/wp-content/ -o /dev/null -w "%{http_code}"
curl -s https://target.com/wp-includes/ -o /dev/null -w "%{http_code}"

# Get version
curl -s https://target.com/readme.html
curl -s https://target.com | grep -i "wp-content\|wordpress"

# Enumerate plugins/themes
wpscan --url https://target.com --enumerate ap,at,tt,cb,dbe
```

**Other Frameworks**:
```bash
# Drupal
curl -s https://target.com/CHANGELOG.txt
droopescan scan drupal -u https://target.com

# Joomla
curl -s https://target.com/administrator/manifests/files/joomla.xml
joomscan -u https://target.com

# Laravel/PHP
curl -s https://target.com/.env

# Node.js
curl -s https://target.com/package.json
```

### 3.3 API Detection

```bash
# Common API paths
curl -s https://target.com/api
curl -s https://target.com/api/v1
curl -s https://target.com/swagger.json
curl -s https://target.com/openapi.json
curl -s https://target.com/graphql

# GraphQL introspection
curl -X POST https://target.com/graphql \
  -H "Content-Type: application/json" \
  -d '{"query": "{__schema{types{name}}}"}'
```

---

## Secret Discovery

### 4.1 Git Repository Mining

**Exposed Git Directories**:
```bash
# Check for .git exposure
curl -s https://target.com/.git/HEAD
curl -s https://target.com/.git/config

# Dump entire .git
git-dumper https://target.com/.git/ output-dir

# Search git history
cd output-dir
git log --all --oneline
git diff HEAD~10 HEAD  # Recent changes
git log -p -- "*.env"  # Changes to env files
git log -p --all -S 'password' -- .  # Commits with password
```

**GitHub/GitLab Secret Search**:
```bash
# trufflehog
trufflehog git https://github.com/target/repo
trufflehog github --org=target

# gitleaks
gitleaks detect --source=/path/to/repo

# Manual GitHub search
# Go to github.com and search:
# "target.com" password
# org:target api_key
# org:target secret
```

### 4.2 JavaScript Analysis

**Extract Secrets from JS**:
```bash
# Download all JS files
curl -s https://target.com | grep -oP 'src="[^"]*\.js[^"]*"' | cut -d'"' -f2

# Search for sensitive patterns
grep -rn "api_key\|apikey\|secret\|password\|token" *.js

# LinkFinder for endpoints
python3 linkfinder.py -i https://target.com -d -o cli

# SecretFinder
python3 SecretFinder.py -i https://target.com -e
```

**Common Patterns**:
```javascript
// API keys
/api_key['"]?\s*[:=]\s*['"][a-zA-Z0-9]{16,}/
/apikey['"]?\s*[:=]\s*['"][a-zA-Z0-9]{16,}/

// AWS keys
/AKIA[0-9A-Z]{16}/
/[a-zA-Z0-9+/]{40}/

// Private keys
/-----BEGIN (?:RSA|DSA|EC|OPENSSH) PRIVATE KEY-----/

// Tokens
/bearer\s+[a-zA-Z0-9\-_.~+/]+=*/i
/jwt\s*[:=]\s*['"]eyJ[a-zA-Z0-9_-]*\.[a-zA-Z0-9_-]*\.[a-zA-Z0-9_-]*/
```

### 4.3 Cloud Storage Discovery

**S3 Bucket Enumeration**:
```bash
# Common naming patterns
target-com
target.com
target-backup
target-assets
target-static
target-prod
target-dev

# Check if bucket exists
aws s3 ls s3://target-bucket --no-sign-request

# Brute force bucket names
s3scanner scan --buckets-file buckets.txt

# Check bucket permissions
aws s3api get-bucket-acl --bucket target-bucket --no-sign-request
```

**Azure/GCP Storage**:
```bash
# Azure blob storage
# Format: https://{account}.blob.core.windows.net/{container}
curl https://target.blob.core.windows.net/public?restype=container&comp=list

# GCP Cloud Storage
# Format: https://storage.googleapis.com/{bucket}
curl https://storage.googleapis.com/target-bucket
```

---

## Network Reconnaissance

### 5.1 Port Scanning

**Nmap Techniques**:
```bash
# Host discovery
nmap -sn 192.168.1.0/24

# Fast port scan
nmap -F target.com

# Full port scan
nmap -p- target.com

# Service version detection
nmap -sV -sC -p 22,80,443 target.com

# UDP scan (slow but important)
nmap -sU --top-ports 50 target.com

# Stealth scan
nmap -sS -T2 -Pn target.com

# Script scan for vulnerabilities
nmap --script vuln target.com
```

**Masscan (Fast Scanning)**:
```bash
# Scan large ranges quickly
masscan -p1-65535 192.168.1.0/24 --rate=10000

# Output to file
masscan -p1-65535 target.com -oL results.txt
```

### 5.2 Service Enumeration

**Common Services**:
```bash
# SSH (22)
ssh -v target.com  # Banner grab
nmap --script ssh2-enum-algos target.com

# HTTP/HTTPS (80/443)
curl -I https://target.com
nmap --script http-enum target.com

# SMB (445)
nmap --script smb-enum-shares,smb-enum-users target.com
smbclient -L //target.com -N

# SNMP (161)
snmpwalk -v2c -c public target.com
onesixtyone target.com

# LDAP (389)
ldapsearch -x -h target.com -b "dc=target,dc=com"

# RDP (3389)
nmap --script rdp-enum-encryption target.com
```

---

## Quick Reference

### Recon Workflow

```
┌─────────────────────────────────────────────────────────────────────┐
│                     RECONNAISSANCE WORKFLOW                          │
├─────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  1. Passive OSINT                                                    │
│     ├── WHOIS, DNS, BGP research                                     │
│     ├── Google dorking                                               │
│     ├── Shodan/Censys                                                │
│     └── Social media, job postings                                   │
│                                                                       │
│  2. Subdomain Enumeration                                            │
│     ├── Certificate Transparency                                     │
│     ├── Passive DNS sources                                          │
│     ├── DNS brute force                                              │
│     └── VHost discovery                                              │
│                                                                       │
│  3. Technology Fingerprinting                                        │
│     ├── Web stack detection                                          │
│     ├── Framework identification                                     │
│     └── API discovery                                                │
│                                                                       │
│  4. Secret Discovery                                                 │
│     ├── Git repository analysis                                      │
│     ├── JavaScript secrets                                           │
│     └── Cloud storage enumeration                                    │
│                                                                       │
│  5. Network Recon                                                    │
│     ├── Port scanning                                                │
│     ├── Service enumeration                                          │
│     └── Network mapping                                              │
│                                                                       │
└─────────────────────────────────────────────────────────────────────┘
```

### Essential Tools

| Category | Tools |
|----------|-------|
| **OSINT** | theHarvester, maltego, spiderfoot |
| **Subdomain** | subfinder, amass, massdns |
| **Web Fingerprint** | whatweb, wappalyzer, nikto |
| **Secrets** | trufflehog, gitleaks, git-dumper |
| **Port Scan** | nmap, masscan, rustscan |
| **Content Discovery** | ffuf, gobuster, feroxbuster |

### Quick Commands

```bash
# All-in-one passive recon
subfinder -d target.com -silent | \
  httpx -silent | \
  nuclei -t nuclei-templates/

# Quick port scan with service detection
nmap -sV -sC --top-ports 1000 -oA scan target.com

# Subdomain + vhost discovery
subfinder -d target.com -silent > subs.txt
ffuf -w subs.txt -u https://FUZZ.target.com -o vhosts.txt

# Secret hunting in JS
katana -u https://target.com -jc -nc -silent | \
  grep "\.js$" | \
  httpx -silent | \
  nuclei -t nuclei-templates/exposures/
```
