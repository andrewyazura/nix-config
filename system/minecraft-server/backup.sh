#!/usr/bin/env bash
set -euo pipefail

# These variables are expected to be set in the environment:
# - SERVER_NAME
# - RCLONE_REMOTE
# - RETENTION_DAYS
# - RCLONE_SECRET_CONFIG (optional, path to read-only sops secret)

DATA_DIR="/srv/minecraft/$SERVER_NAME"
BACKUP_DIR="/tmp/minecraft-backup"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_FILE="$BACKUP_DIR/${SERVER_NAME}_backup_${DATE}.tar"

echo "Starting backup for server: $SERVER_NAME..."
mkdir -p "$BACKUP_DIR"

# Securely sync the read-only sops-nix secret (if provided via RCLONE_SECRET_CONFIG)
# to a writable copy inside our temporary backup directory (which is fully owned and
# writable by the minecraft user).
WRITABLE_RCLONE_CONFIG="$BACKUP_DIR/rclone.conf"

if [ -n "${RCLONE_SECRET_CONFIG:-}" ] && [ -f "$RCLONE_SECRET_CONFIG" ]; then
  if [ ! -f "$WRITABLE_RCLONE_CONFIG" ] || [ "$RCLONE_SECRET_CONFIG" -nt "$WRITABLE_RCLONE_CONFIG" ]; then
    echo "Syncing latest rclone configuration from secrets..."
    mkdir -p "$(dirname "$WRITABLE_RCLONE_CONFIG")"
    cp "$RCLONE_SECRET_CONFIG" "$WRITABLE_RCLONE_CONFIG"
    chmod 600 "$WRITABLE_RCLONE_CONFIG"
  fi
fi

# Export the standard RCLONE_CONFIG environment variable so rclone natively uses our writable copy.
# This permits rclone to successfully write back refreshed Google Drive OAuth tokens.
export RCLONE_CONFIG="$WRITABLE_RCLONE_CONFIG"

send_command() {
  local cmd="$1"
  if [ -S "/run/minecraft/$SERVER_NAME.sock" ]; then
    echo "Sending command to server console: $cmd"
    tmux -S "/run/minecraft/$SERVER_NAME.sock" send-keys "$cmd" Enter
  else
    echo "Server socket not found, cannot send command: $cmd"
  fi
}

SERVER_RUNNING=0
if systemctl is-active --quiet "minecraft-server-$SERVER_NAME.service"; then
  SERVER_RUNNING=1
fi

if [ "$SERVER_RUNNING" -eq 1 ]; then
  send_command "say Starting server backup. Server may lag briefly..."
  send_command "save-off"
  send_command "save-all flush"
  sleep 5
else
  echo "Server is not running. Backing up files offline."
fi

echo "Archiving world files..."
tar -cf "$BACKUP_FILE" -C "$DATA_DIR" "world"

if [ "$SERVER_RUNNING" -eq 1 ]; then
  send_command "save-on"
  send_command "say Backup finished successfully."
fi

echo "Uploading backup to remote: $RCLONE_REMOTE..."
# Since the config is copied to our writable temp path and exported via RCLONE_CONFIG,
# rclone will natively load and update it without requiring a custom --config flag.
# We pass --verbose to output upload progress/speed to journalctl logs.
rclone copy --verbose --drive-chunk-size 256M "$BACKUP_FILE" "$RCLONE_REMOTE/$SERVER_NAME"

echo "Backup uploaded successfully."

echo "Cleaning up local backups older than $RETENTION_DAYS days..."
find "$BACKUP_DIR" -name "${SERVER_NAME}_backup_*.tar" -mtime +"$RETENTION_DAYS" -type f -delete

echo "Cleaning up remote backups older than $RETENTION_DAYS days..."
rclone delete --verbose "$RCLONE_REMOTE/$SERVER_NAME" --min-age "${RETENTION_DAYS}d" --rmdirs

echo "Backup process completed!"
