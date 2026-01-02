# SSH Configuration for Parallels VMs

> Guide for SSH access to VMs from Mac host

## Prerequisites

VMs need:
1. OpenSSH server installed
2. Network configured (shared/bridged)
3. SSH keys or password authentication

## Getting VM IP Address

### Method 1: prlctl

```bash
# Get VM IP
prlctl list -f | grep <vm-name>

# Detailed info
prlctl list -i <vm> | grep "net0"
```

### Method 2: Inside VM

```bash
prlctl exec <vm> "hostname -I"
```

### Method 3: ARP table

```bash
arp -a | grep parallels
```

## SSH Key Setup

### Generate key on Mac host

```bash
ssh-keygen -t ed25519 -C "parallels-vm" -f ~/.ssh/parallels_key
```

### Copy to VM

```bash
# Using prlctl
prlctl exec <vm> "mkdir -p ~/.ssh && chmod 700 ~/.ssh"
cat ~/.ssh/parallels_key.pub | prlctl exec <vm> "cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"

# Or using ssh-copy-id
ssh-copy-id -i ~/.ssh/parallels_key user@<vm-ip>
```

## SSH Config File

Add to `~/.ssh/config`:

```
# Parallels VMs
Host microai-club
    HostName 10.211.55.x
    User parallels
    IdentityFile ~/.ssh/parallels_key
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null

Host db-server
    HostName 10.211.55.y
    User root
    IdentityFile ~/.ssh/parallels_key

Host git-server
    HostName 10.211.55.z
    User git
    IdentityFile ~/.ssh/parallels_key

# Wildcard for all Parallels VMs
Host 10.211.55.*
    User parallels
    IdentityFile ~/.ssh/parallels_key
    StrictHostKeyChecking no
```

## Common SSH Commands

### Connect

```bash
ssh microai-club
ssh user@10.211.55.x
```

### Execute Command

```bash
ssh microai-club "df -h"
ssh microai-club "docker ps"
```

### File Transfer

```bash
# Copy to VM
scp file.txt microai-club:/home/user/

# Copy from VM
scp microai-club:/var/log/app.log ./

# Sync directory
rsync -avz ./project/ microai-club:/home/user/project/
```

### Port Forwarding

```bash
# Local port forward (access VM service from Mac)
ssh -L 8080:localhost:80 microai-club
# Now http://localhost:8080 → VM's port 80

# Remote port forward (expose Mac service to VM)
ssh -R 3000:localhost:3000 microai-club

# Dynamic SOCKS proxy
ssh -D 1080 microai-club
```

### Tunneling

```bash
# Access VM's database from Mac
ssh -L 5432:localhost:5432 db-server

# Access VM's web server
ssh -L 8080:localhost:80 microai-club
```

## Automation Scripts

### Start and SSH

```bash
#!/bin/bash
VM="microai-club"
prlctl start "$VM" 2>/dev/null
echo "Waiting for VM to boot..."
sleep 15
IP=$(prlctl exec "$VM" "hostname -I" | awk '{print $1}')
ssh -o ConnectTimeout=5 "$IP"
```

### Batch Execute

```bash
#!/bin/bash
for vm in microai-club db-server git-server; do
    echo "=== $vm ==="
    prlctl exec "$vm" "uptime"
done
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Connection refused | Check sshd running: `prlctl exec <vm> "systemctl status sshd"` |
| Permission denied | Check key permissions (600) and authorized_keys |
| Host key changed | Remove from known_hosts or use StrictHostKeyChecking=no |
| Timeout | Check VM network mode, might need bridged |

## Security Best Practices

1. Use SSH keys, disable password auth
2. Use non-default SSH port for production
3. Limit users in sshd_config
4. Use fail2ban on VMs
5. Keep separate keys for different VMs
