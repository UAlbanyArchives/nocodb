#!/bin/bash

BACKUP_DIR="/path/to/backups"
DATA_DIR="/path/to/nc_data"
DB_FILE="nocodb.sqlite3"

# Create directories if missing
mkdir -p "$BACKUP_DIR"
mkdir -p "$BACKUP_DIR/weekly"

# Today's date
TODAY=$(date +%F)

# Backup filename
BACKUP_FILE="$BACKUP_DIR/nocodb-$TODAY.sqlite3"

# Copy the DB file
cp "$DATA_DIR/$DB_FILE" "$BACKUP_FILE"

# --- Rotation ---

# Delete daily backups older than 7 days
find "$BACKUP_DIR" -maxdepth 1 -name "nocodb-*.sqlite3" -mtime +7 -type f -exec rm {} \;

# If today is Sunday (week day 0), copy today's backup to weekly folder
if [ "$(date +%u)" -eq 7 ]; then
    cp "$BACKUP_FILE" "$BACKUP_DIR/weekly/nocodb-week-$(date +%Y-%V).sqlite3"
fi

# Delete weekly backups older than 4 weeks
find "$BACKUP_DIR/weekly" -maxdepth 1 -name "nocodb-week-*.sqlite3" -mtime +28 -type f -exec rm {} \;
