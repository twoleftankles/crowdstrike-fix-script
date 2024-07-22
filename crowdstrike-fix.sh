#!/bin/bash

# Log file location
LOG_FILE="/home/<YOUR-USERNAME-HERE>/Desktop/CrowdStrikeScript-logs.txt"

# Function to log messages with a timestamp
log() {
    local message="$1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $message" >> "$LOG_FILE"
}

# List all partitions (excluding the root partition and the boot partition)
partitions=$(lsblk -lno NAME,TYPE | grep "part$" | awk '{print $1}')

log "Script started."

# Create mount points and mount each partition with read and write permissions
for part in $partitions; do
    log "Processing /dev/$part"

    # Create a mount point directory if it doesn't exist
    mount_point="/mnt/$part"
    sudo mkdir -p $mount_point

    # Check the filesystem type
    fs_type=$(blkid -o value -s TYPE /dev/$part)
    log "Filesystem type for /dev/$part is $fs_type"

    if [ "$fs_type" = "ntfs" ]; then
        # Unmount the partition if it's already mounted
        sudo umount $mount_point 2>/dev/null

        # Fix the NTFS partition
        sudo ntfsfix /dev/$part

        # Mount NTFS partition with read and write permissions
        sudo mount -t ntfs-3g -o rw /dev/$part $mount_point
    else
        # Mount other partitions with read and write permissions
        sudo mount -o rw /dev/$part $mount_point
    fi

    # Verify the mount
    if mountpoint -q $mount_point; then
        log "Mount point $mount_point is valid."

        # Find files matching the pattern and delete them
        find $mount_point/Windows/System32/drivers/CrowdStrike -name 'c-00000291*.sys' 2>/dev/null | while IFS= read -r file; do
            if [ -f "$file" ]; then
                sudo rm "$file"
                log "Deleted $file"
            else
                log "File $file does not exist."
            fi
        done
    else
        log "Mount point $mount_point is not valid or the directory does not exist."
    fi
done

log "Script finished."
