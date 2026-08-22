#!/bin/sh

# Usage:
# rsync-backup.sh <backup_name> <source> <destination>

BACKUP_NAME="$1"
SOURCE="$2"
DESTINATION="$3"

METRICS_DIR="/home/raspberrypi/ApkiPawla/prometheus/node-exporter-textfile"
METRICS_FILE="$METRICS_DIR/${BACKUP_NAME}.prom"

if [ -z "$BACKUP_NAME" ] || [ -z "$SOURCE" ] || [ -z "$DESTINATION" ]; then
    echo "Usage: $0 <backup_name> <source> <destination>"
    exit 1
fi

START_TIME=$(date +%s)
START_DATE=$(date "+%Y-%m-%d %H:%M:%S")

echo "$START_DATE Starting $BACKUP_NAME"

# Run rsync
if ! rsync -av --delete "$SOURCE" "$DESTINATION"; then
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))
    NOW=$(date "+%Y-%m-%d %H:%M:%S")

    cat > "$METRICS_FILE" <<EOF
${BACKUP_NAME}_last_attempt_timestamp $END_TIME
${BACKUP_NAME}_last_status 0
${BACKUP_NAME}_last_duration_seconds $DURATION
EOF

    echo "$NOW $BACKUP_NAME FAILED after ${DURATION}s"

    exit 1
fi

# Backup succeeded
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))
NOW=$(date "+%Y-%m-%d %H:%M:%S")

cat > "$METRICS_FILE" <<EOF
${BACKUP_NAME}_last_attempt_timestamp $END_TIME
${BACKUP_NAME}_last_success_timestamp $END_TIME
${BACKUP_NAME}_last_status 1
${BACKUP_NAME}_last_duration_seconds $DURATION
EOF

echo "$NOW $BACKUP_NAME completed successfully in ${DURATION}s"