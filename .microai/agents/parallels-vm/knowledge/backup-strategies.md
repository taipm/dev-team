# Backup & Restore Strategies for Parallels VMs

> Comprehensive guide for VM backup and disaster recovery

## Backup Methods

### 1. Snapshots (Quick, In-place)

Best for: Quick state saves, before risky operations

```bash
# Create snapshot
prlctl snapshot <vm> -n "name" -d "description"

# List snapshots
prlctl snapshot-list <vm>

# Restore to snapshot
prlctl snapshot-switch <vm> -i <snapshot-id>

# Delete snapshot
prlctl snapshot-delete <vm> -i <snapshot-id>
```

**Pros**: Fast, minimal space, instant restore
**Cons**: Not portable, depends on parent VM

### 2. Clone (Full Copy)

Best for: Test environments, portable backups

```bash
# Full clone
prlctl clone <vm> --name <backup-name>

# Linked clone (smaller, shares base disk)
prlctl clone <vm> --name <backup-name> --linked
```

**Pros**: Independent copy, portable
**Cons**: Large size, takes time

### 3. Export/Archive (Portable)

Best for: Long-term archival, moving to different machines

```bash
# Export as .pvm bundle
# VM must be stopped first
prlctl stop <vm>
cp -R "~/Parallels/<vm>.pvm" "/backup/location/"

# Or compress
tar -czvf backup-$(date +%Y%m%d).tar.gz "~/Parallels/<vm>.pvm"
```

### 4. File-Level Backup (Inside VM)

Best for: Application data, configurations

```bash
# rsync from VM to host
rsync -avz user@vm:/important/data/ /backup/vm-data/

# Or using prlctl
prlctl exec <vm> "tar czf - /important/data" > backup.tar.gz
```

## Backup Automation

### Daily Snapshot Script

```bash
#!/bin/bash
# daily-snapshot.sh
VMS="microai-club db-server git-server"
DATE=$(date +%Y%m%d)

for vm in $VMS; do
    echo "Creating snapshot for $vm..."
    prlctl snapshot "$vm" -n "daily-$DATE" -d "Automated daily backup"
done

# Cleanup old snapshots (keep last 7)
for vm in $VMS; do
    prlctl snapshot-list "$vm" | grep "daily-" | head -n -7 | while read line; do
        snap_id=$(echo "$line" | grep -oE '\{[^}]+\}')
        [ -n "$snap_id" ] && prlctl snapshot-delete "$vm" -i "$snap_id"
    done
done
```

### Weekly Full Backup Script

```bash
#!/bin/bash
# weekly-backup.sh
BACKUP_DIR="/Volumes/Backup/Parallels"
DATE=$(date +%Y%m%d)
VMS="microai-club db-server"

mkdir -p "$BACKUP_DIR"

for vm in $VMS; do
    echo "Backing up $vm..."

    # Stop VM gracefully
    prlctl stop "$vm"
    sleep 10

    # Copy VM bundle
    VM_PATH="$HOME/Parallels/${vm}.pvm"
    if [ -d "$VM_PATH" ]; then
        tar -czf "$BACKUP_DIR/${vm}-${DATE}.tar.gz" -C "$HOME/Parallels" "${vm}.pvm"
        echo "Backup created: $BACKUP_DIR/${vm}-${DATE}.tar.gz"
    fi

    # Restart VM
    prlctl start "$vm"
done

# Cleanup old backups (keep last 4)
find "$BACKUP_DIR" -name "*.tar.gz" -mtime +28 -delete
```

### Cron Setup

```bash
# Edit crontab
crontab -e

# Daily snapshots at 2 AM
0 2 * * * /path/to/daily-snapshot.sh >> /var/log/prl-backup.log 2>&1

# Weekly full backup on Sunday at 3 AM
0 3 * * 0 /path/to/weekly-backup.sh >> /var/log/prl-backup.log 2>&1
```

## Restore Procedures

### From Snapshot

```bash
# List available snapshots
prlctl snapshot-list <vm>

# Restore (VM should be stopped)
prlctl stop <vm>
prlctl snapshot-switch <vm> -i <snapshot-id>
prlctl start <vm>
```

### From Full Backup

```bash
# Extract backup
tar -xzf backup-20240101.tar.gz -C ~/Parallels/

# Register VM
prlctl register "~/Parallels/vm-name.pvm"

# Start
prlctl start vm-name
```

### From Clone

```bash
# If original is broken, rename clone
prlctl stop original-vm
prlctl set clone-vm --name original-vm

# Or keep both and update configs
prlctl start clone-vm
```

## Best Practices

### Backup Strategy Matrix

| Data Type | Method | Frequency | Retention |
|-----------|--------|-----------|-----------|
| System state | Snapshot | Daily | 7 days |
| Full VM | Clone/Export | Weekly | 4 weeks |
| App data | File-level | Daily | 30 days |
| Configs | Git/rsync | On change | Forever |

### Before Major Changes

```bash
# Always snapshot before:
# - OS updates
# - Software installations
# - Configuration changes
# - Database migrations

prlctl snapshot <vm> -n "pre-update-$(date +%Y%m%d-%H%M)"
```

### Testing Restores

Periodically test restore:

```bash
# Clone and test
prlctl clone production --name test-restore --linked
prlctl start test-restore
# Verify functionality
prlctl stop test-restore --kill
prlctl delete test-restore
```

## Storage Considerations

### VM Size Check

```bash
# Check VM disk usage
du -sh ~/Parallels/*.pvm

# Check snapshot sizes
prlctl snapshot-list <vm> --tree
```

### Cleanup

```bash
# Remove old snapshots
prlctl snapshot-list <vm> | grep -E "^\s+\{" | head -n -3 | \
  xargs -I {} prlctl snapshot-delete <vm> -i {}

# Compact VM disk (reduces size)
prlctl stop <vm>
prl_disk_tool compact --hdd ~/Parallels/<vm>.pvm/harddisk.hdd
```

## Disaster Recovery Checklist

- [ ] Identify critical VMs
- [ ] Set up automated snapshots
- [ ] Set up weekly full backups
- [ ] Test restore procedures monthly
- [ ] Document VM configurations
- [ ] Store backups offsite (external drive, cloud)
- [ ] Monitor backup job success
