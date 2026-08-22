#!/bin/sh

# Paths
UPLOAD_LOCATION="/mnt/ssd/immich_from_windows"
BACKUP_PATH="/mnt/backup_on_windows/immich_backup"
METRICS_FILE="/home/raspberrypi/ApkiPawla/prometheus/node-exporter-textfile/immich_remote_backup.prom"

# Home Assistant notify endpoint
HA_URL="http://192.168.1.21:8123/api/services/notify/mobile_app_iwojtyla"
HA_TOKEN=""

export BORG_RELOCATED_REPO_ACCESS_IS_OK=yes

START_TIME=$(date +%s)
START_DATE=$(date "+%Y-%m-%d %H:%M:%S")

# Write Prometheus metrics
write_metrics() {
    STATUS=$1
    END_TIME=$2
    DURATION=$3

    cat > "$METRICS_FILE" <<EOF
immich_remote_backup_last_attempt_timestamp $END_TIME
immich_remote_backup_last_status $STATUS
immich_remote_backup_last_duration_seconds $DURATION
EOF

    if [ "$STATUS" -eq 1 ]; then
        echo "immich_remote_backup_last_success_timestamp $END_TIME" >> "$METRICS_FILE"
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
         -d "{\"message\": \"Immich remote backup FAILED during ${REASON} after ${DURATION}s (at $NOW)\", \"title\": \"Immich Backup\"}" \
         "$HA_URL"

    echo "$NOW Immich remote backup FAILED during $REASON after ${DURATION}s"

    exit 1
}

echo "$START_DATE Starting Immich remote backup"

# Notify start
curl -s -X POST \
     -H "Authorization: Bearer $HA_TOKEN" \
     -H "Content-Type: application/json" \
     -d "{\"message\": \"Immich remote backup started at $START_DATE\", \"title\": \"Immich Backup\"}" \
     "$HA_URL"

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
     -d "{\"message\": \"Immich remote backup completed successfully in ${DURATION}s (finished at $NOW)\", \"title\": \"Immich Backup\"}" \
     "$HA_URL"

echo "$NOW Immich remote backup finished in ${DURATION}s"