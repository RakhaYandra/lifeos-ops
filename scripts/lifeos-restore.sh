#!/usr/bin/env bash
# Restore SQLite LifeOS dari file backup. API harus MATI dulu (hindari DB locked).
# Pakai: ./lifeos-restore.sh <FILE_BACKUP> [DIR_APLIKASI]
set -euo pipefail
[ $# -ge 1 ] || { echo "pakai: $0 <file-backup> [dir-aplikasi]" >&2; exit 1; }
SRC="$1"
APP_DIR="${2:-.}"
[ -f "$SRC" ] || { echo "ERR: $SRC tak ada" >&2; exit 1; }
if pgrep -f 'lifeos-run|/cmd/api|go run ./cmd/api' >/dev/null 2>&1; then
  echo "ERR: API masih jalan — matikan dulu" >&2
  exit 1
fi
cp "$SRC" "$APP_DIR/lifeos.db"
echo "OK: restore ke $APP_DIR/lifeos.db (verifikasi: sqlite3 lifeos.db 'SELECT COUNT(*) FROM tasks;')"
