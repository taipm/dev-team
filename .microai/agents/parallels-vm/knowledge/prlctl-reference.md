# prlctl Command Reference

> Complete reference for Parallels Desktop CLI on Mac

## Overview

`prlctl` is the command-line utility for managing Parallels Desktop virtual machines.
Location: `/usr/local/bin/prlctl`

## VM Identification

VMs can be identified by:
- **Name**: Human-readable name (e.g., `microai-club`)
- **UUID**: Unique identifier (e.g., `{ca9c8c3c-c0d6-4198-9783-67c6634eb0a9}`)

## Basic Commands

### List VMs

```bash
# All VMs with status
prlctl list -a

# Only running VMs
prlctl list

# Detailed info for specific VM
prlctl list -i <vm-name>

# JSON output
prlctl list -a -j
```

### Power Operations

```bash
# Start VM
prlctl start <vm>

# Stop VM (graceful shutdown)
prlctl stop <vm>

# Force stop (like pulling power cord)
prlctl stop <vm> --kill

# Suspend (save state to disk)
prlctl suspend <vm>

# Resume from suspended state
prlctl resume <vm>

# Restart
prlctl restart <vm>

# Reset (hard reboot)
prlctl reset <vm>
```

## Configuration

### CPU & Memory

```bash
# Set CPU count
prlctl set <vm> --cpus <number>

# Set memory (in MB)
prlctl set <vm> --memsize <mb>

# Examples
prlctl set microai-club --cpus 4
prlctl set microai-club --memsize 8192
```

### Disk

```bash
# Resize disk
prlctl set <vm> --device-set hdd0 --size <size>

# Add new disk
prlctl set <vm> --device-add hdd --size 50G

# Example
prlctl set microai-club --device-set hdd0 --size 100G
```

### Network

```bash
# Shared networking (NAT)
prlctl set <vm> --device-set net0 --type shared

# Bridged networking
prlctl set <vm> --device-set net0 --type bridged

# Host-only
prlctl set <vm> --device-set net0 --type host-only
```

## Snapshots

```bash
# Create snapshot
prlctl snapshot <vm> -n "snapshot-name"
prlctl snapshot <vm> -n "Before update" -d "Description"

# List snapshots
prlctl snapshot-list <vm>

# Switch to snapshot
prlctl snapshot-switch <vm> -i <snapshot-id>

# Delete snapshot
prlctl snapshot-delete <vm> -i <snapshot-id>
```

## Cloning

```bash
# Clone VM
prlctl clone <vm> --name <new-name>

# Clone as template
prlctl clone <vm> --name <new-name> --template

# Clone with linked disk (saves space)
prlctl clone <vm> --name <new-name> --linked
```

## Execute Commands in VM

```bash
# Run single command
prlctl exec <vm> <command>

# Examples
prlctl exec microai-club uname -a
prlctl exec microai-club df -h
prlctl exec microai-club "apt update && apt upgrade -y"

# Interactive shell
prlctl enter <vm>
```

## Server Control (prlsrvctl)

```bash
# Parallels info
prlsrvctl info

# Network list
prlsrvctl net list

# User info
prlsrvctl user list
```

## Output Formats

```bash
# JSON output
prlctl list -a -j

# Full info
prlctl list -a -f

# Specific fields
prlctl list -a -o name,status,ip
```

## Common Workflows

### Start Development Environment

```bash
# Start VM and wait for network
prlctl start dev-server
sleep 10
prlctl exec dev-server "systemctl status docker"
```

### Create Backup Before Update

```bash
# Snapshot before dangerous operation
prlctl snapshot microai-club -n "Before-$(date +%Y%m%d)"
prlctl exec microai-club "apt update && apt upgrade -y"
```

### Clone for Testing

```bash
# Create test clone
prlctl clone production-db --name test-db --linked
prlctl start test-db
# ... run tests ...
prlctl stop test-db --kill
prlctl delete test-db
```

## Error Handling

| Error | Solution |
|-------|----------|
| VM not found | Check name with `prlctl list -a` |
| VM is locked | Another operation in progress, wait |
| Cannot stop | Use `--kill` flag |
| Not enough disk | Resize or clean up |

## Environment Variables

```bash
# Default paralells home
export PARALLELS_HOME="$HOME/Parallels"

# Backup location
export PRL_BACKUP_DIR="/Volumes/Backup/Parallels"
```
