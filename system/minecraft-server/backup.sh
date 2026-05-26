#!/usr/bin/env bash
set -euo pipefail

# These variables are expected to be set in the environment:
# - SERVER_NAME
# - RCLONE_REMOTE
# - RETENTION_DAYS
# - RCLONE_CONFIG_FILE (optional)

DATA_DIR="/var/lib/minecraft/$SERVER_NAME"
BACKUP_DIR="/var/lib/minecraft/backups"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_FILE="$BACKUP_DIR/${SERVER_NAME}_backup_${DATE}.tar.gz"

echo "Starting backup for server: $SERVER_NAME..."
mkdir -p "$BACKUP_DIR"

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

echo "Compressing world files..."
tar --exclude='backups' --exclude='logs' -czf "$BACKUP_FILE" -C "/var/lib/minecraft" "$SERVER_NAME"

if [ "$SERVER_RUNNING" -eq 1 ]; then
  send_command "save-on"
  send_command "say Backup finished successfully."
fi

echo "Uploading backup to remote: $RCLONE_REMOTE..."
RCLONE_CMD=("rclone")
if [ -n "${RCLONE_CONFIG_FILE:-}" ]; then
  RCLONE_CMD+=("--config" "$RCLONE_CONFIG_FILE")
fi
RCLONE_CMD+=("copy" "$BACKUP_FILE" "$RCLONE_REMOTE/$SERVER_NAME")
"${RCLONE_CMD[@]}"

echo "Backup uploaded successfully."

echo "Cleaning up local backups older than $RETENTION_DAYS days..."
find "$BACKUP_DIR" -name "${SERVER_NAME}_backup_*.tar.gz" -mtime +"$RETENTION_DAYS" -type f -delete

echo "Cleaning up remote backups older than $RETENTION_DAYS days..."
RCLONE_DEL_CMD=("rclone")
if [ -n "${RCLONE_CONFIG_FILE:-}" ]; then
  RCLONE_DEL_CMD+=("--config" "$RCLONE_CONFIG_FILE")
fi
RCLONE_DEL_CMD+=("delete" "$RCLONE_REMOTE/$SERVER_NAME" "--min-age" "${RETENTION_DAYS}d" --rmdirs)
"${RCLONE_DEL_CMD[@]}"

echo "Backup process completed!"
