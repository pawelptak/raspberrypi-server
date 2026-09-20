#!/bin/sh

# Paths
UPLOAD_LOCATION="/mnt/ssd/immich_from_windows"
BACKUP_PATH="/mnt/ssd_backup/immich_backup"
METRICS_FILE="/home/raspberrypi/ApkiPawla/prometheus/node-exporter-textfile/immich_backup.prom"

# Home Assistant notify endpoint
HA_URL="http://192.168.1.21:8123/api/services/notify/mobile_app_iwojtyla"
HA_TOKEN=""
HA_TAG="immich-local-backup"
HA_ICON_URL="https://raw.githubusercontent.com/immich-app/immich/main/web/static/favicon.png"

# Start timestamps
START_TIME=$(date +%s)
START_DATE=$(date "+%Y-%m-%d %H:%M:%S")

# Write Prometheus metrics
write_metrics() {
    STATUS=$1
    END_TIME=$2
    DURATION=$3

    cat > "$METRICS_FILE" <<EOF
immich_backup_last_attempt_timestamp $END_TIME
immich_backup_last_status $STATUS
immich_backup_last_duration_seconds $DURATION
EOF

    # Only update last_success when the backup actually succeeded
    if [ "$STATUS" -eq 1 ]; then
        echo "immich_backup_last_success_timestamp $END_TIME" >> "$METRICS_FILE"
    fi
}

# Handle backup failure
fail() {
    REASON=$1
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))
    NOW=$(date "+%Y-%m-%d %H:%M:%S")

    write_metrics 0 "$END_TIME" "$DURATION"

    curl -s -X POST \
         -H "Authorization: Bearer $HA_TOKEN" \
         -H "Content-Type: application/json" \
             -d "{\"message\": \"Local Immich backup failed\\nStep: ${REASON}\\nDuration: ${DURATION}s\\nFinished: $NOW\", \"title\": \"Immich Backup\", \"data\": {\"tag\": \"$HA_TAG\", \"icon_url\": \"$HA_ICON_URL\"}}" \
         "$HA_URL"

    echo "$NOW Immich local backup FAILED during $REASON after ${DURATION}s"

    exit 1
}

# Make directories if they don't exist
mkdir -p "$UPLOAD_LOCATION/database-backup"
mkdir -p "$BACKUP_PATH/immich-borg"

echo "$START_DATE Starting Immich local backup"

# Notify start
curl -s -X POST \
     -H "Authorization: Bearer $HA_TOKEN" \
     -H "Content-Type: application/json" \
    -d "{\"message\": \"Local Immich backup started\\nStarted: $START_DATE\", \"title\": \"Immich Backup\", \"data\": {\"tag\": \"$HA_TAG\", \"icon_url\": \"$HA_ICON_URL\"}}" \
     "$HA_URL"

# Backup Immich database
if ! docker exec -t immich_postgres pg_dumpall \
        --clean \
        --if-exists \
        --username=postgres \
        > "$UPLOAD_LOCATION/database-backup/immich-database.sql"; then
    fail "database backup"
fi

# Create Borg archive
if ! borg create "$BACKUP_PATH/immich-borg::{now}" "$UPLOAD_LOCATION" \
        --exclude "$UPLOAD_LOCATION/thumbs/" \
        --exclude "$UPLOAD_LOCATION/encoded-video/"; then
    fail "borg create"
fi

# Remove old archives
if ! borg prune \
        --keep-weekly=4 \
        --keep-monthly=3 \
        "$BACKUP_PATH/immich-borg"; then
    fail "borg prune"
fi

# Compact repository
if ! borg compact "$BACKUP_PATH/immich-borg"; then
    fail "borg compact"
fi

# Backup completed successfully
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))
NOW=$(date "+%Y-%m-%d %H:%M:%S")

write_metrics 1 "$END_TIME" "$DURATION"

# Notify Home Assistant of success
curl -s -X POST \
     -H "Authorization: Bearer $HA_TOKEN" \
     -H "Content-Type: application/json" \
    -d "{\"message\": \"Local Immich backup completed\\nDuration: ${DURATION}s\\nFinished: $NOW\", \"title\": \"Immich Backup\", \"data\": {\"tag\": \"$HA_TAG\", \"icon_url\": \"$HA_ICON_URL\"}}" \
     "$HA_URL"

echo "$NOW Immich local backup finished in ${DURATION}s"