#!/bin/sh

# Paths
UPLOAD_LOCATION="/mnt/ssd/immich_from_windows"
BACKUP_PATH="/mnt/ssd_backup/immich_backup"

# Home Assistant notify endpoint
HA_URL="http://192.168.1.21:8123/api/services/notify/mobile_app_iwojtyla"
HA_TOKEN=""

# Start timestamps
START_TIME=$(date +%s)
START_DATE=$(date "+%Y-%m-%d %H:%M:%S")

echo "$START_DATE Starting Immich local backup"

# Notify start
curl -s -X POST -H "Authorization: Bearer $HA_TOKEN" \
     -H "Content-Type: application/json" \
     -d "{\"message\": \"Local Immich backup started at $START_DATE\", \"title\": \"Immich Backup\"}" \
     $HA_URL

### Backup Immich database
docker exec -t immich_postgres pg_dumpall --clean --if-exists --username=postgres > "$UPLOAD_LOCATION"/database-backup/immich-database.sql

### Append to local Borg repository

# Create archive and check if it succeeds
if borg create "$BACKUP_PATH/immich-borg::{now}" "$UPLOAD_LOCATION" \
        --exclude "$UPLOAD_LOCATION"/thumbs/ \
        --exclude "$UPLOAD_LOCATION"/encoded-video/; then
    
    # If create succeeded, prune and compact
    borg prune --keep-weekly=4 --keep-monthly=3 "$BACKUP_PATH"/immich-borg
    borg compact "$BACKUP_PATH"/immich-borg

    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))

    NOW=$(date "+%Y-%m-%d %H:%M:%S")

    # Notify Home Assistant of success
    curl -s -X POST -H "Authorization: Bearer $HA_TOKEN" \
         -H "Content-Type: application/json" \
         -d "{\"message\": \"Local Immich backup completed successfully in ${DURATION}s (finished at $NOW)\", \"title\": \"Immich Backup\"}" \
         $HA_URL

    echo "$NOW Immich local backup finished in ${DURATION}s"

else

    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))

    NOW=$(date "+%Y-%m-%d %H:%M:%S")

    # Notify Home Assistant of failure
    curl -s -X POST -H "Authorization: Bearer $HA_TOKEN" \
         -H "Content-Type: application/json" \
         -d "{\"message\": \"Local Immich backup FAILED after ${DURATION}s (at $NOW)\", \"title\": \"Immich Backup\"}" \
         $HA_URL

    echo "$NOW Immich local backup FAILED after ${DURATION}s"

fi