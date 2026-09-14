#!/usr/bin/env bash
# Backup SQLite LifeOS: copy + timestamp + rotasi (default simpan 7).
# Pakai: ./lifeos-backup.sh [DIR_APLIKASI] [DIR_BACKUP] [RETENSI]
# Default: direktori kerja saat ini, ./backups, 7.
set -euo pipefail
APP_DIR="${1:-.}"
BACKUP_DIR="${2:-$APP_DIR/backups}"
KEEP="${3:-7}"
DB="$APP_DIR/lifeos.db"
[ -f "$DB" ] || { echo "ERR: $DB tak ada" >&2; exit 1; }
mkdir -p "$BACKUP_DIR"
TS=$(date +%Y%m%d-%H%M%S)
cp "$DB" "$BACKUP_DIR/lifeos-$TS.db"
ls -t "$BACKUP_DIR"/lifeos-*.db | tail -n +$((KEEP + 1)) | xargs -r rm --
echo "OK: $BACKUP_DIR/lifeos-$TS.db"
