#!/bin/sh

# Paths
UPLOAD_LOCATION="/mnt/ssd/immich_from_windows"

# SSH to WSL/Windows
REMOTE_USER="pawel"
REMOTE_HOST="192.168.1.29"
REMOTE_PORT=2222
REMOTE_BACKUP_PATH="/mnt/p/backups_from_raspberry/immich_backup"
REPO_NAME="immich-borg"

# SSH options for non-interactive cron
export BORG_RSH="ssh -i /home/raspberrypi/.ssh/wsl_key -p 2222 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

# Backup Immich database - commented out since this is already done by the immich-borg-setup.sh
# docker exec -t immich_postgres pg_dumpall --clean --if-exists --username=postgres > "$UPLOAD_LOCATION"/database-backup/immich-database.sql

# Append to remote Borg repository
borg create "ssh://$REMOTE_USER@$REMOTE_HOST$REMOTE_BACKUP_PATH/$REPO_NAME::{now}" "$UPLOAD_LOCATION" \
    --exclude "$UPLOAD_LOCATION"/thumbs/ \
    --exclude "$UPLOAD_LOCATION"/encoded-video/

borg prune --keep-weekly=4 --keep-monthly=3 "ssh://$REMOTE_USER@$REMOTE_HOST$REMOTE_BACKUP_PATH/$REPO_NAME"
borg compact "ssh://$REMOTE_USER@$REMOTE_HOST$REMOTE_BACKUP_PATH/$REPO_NAME"