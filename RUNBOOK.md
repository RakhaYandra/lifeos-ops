# Runbook — LifeOS (API Go + SQLite + Web Vite)

Cakupan: install, konfigurasi, backup/restore, reset, restart, log.
Semua path relatif; contoh dijalankan dari direktori `lifeos/`.

## 1. Install & jalan pertama

```bash
cp .env.example .env            # isi JWT_SECRET prod yang kuat
goose -dir migrations sqlite lifeos.db up
sqlite3 lifeos.db < seed/seed.sql
go run ./cmd/api                # :8080 (PORT di .env)
cd ../lifeos-web && npm ci && npm run dev   # :5174
```

`.env` (jangan commit): `PORT`, `DB_PATH=lifeos.db`, `JWT_SECRET`, `FRONTEND_URL=http://localhost:5174`.

## 2. Operasi harian

| Tugas | Perintah |
|---|---|
| Cek sehat | `curl -s localhost:8080/healthz` → `{"status":"ok"}` |
| Lihat log | `tail -f /tmp/lifeos-run.log` (atau journal bila systemd) |
| Backup | `../lifeos-ops/scripts/lifeos-backup.sh . ./backups 7` |
| Restore | matikan API → `../lifeos-ops/scripts/lifeos-restore.sh backups/lifeos-<TS>.db .` |
| Reset demo | `rm lifeos.db && goose ... up && sqlite3 lifeos.db < seed/seed.sql` |
| Ganti secret | ubah `JWT_SECRET` → restart API (semua token lama hangus) |

## 3. Checklist gagal login (hapus satu per satu)

1. API hidup? (`/healthz`)
2. `FRONTEND_URL` = origin browser persis (dulu `:5173` vs `:5174` — insiden nyata T-001)?
3. Kredensial seed benar? (`aku@lifeos.local / Rahasia123`)
4. Token kedaluwarsa (>24 jam)? Login ulang.
5. DB terhapus/korup? Restore dari backup.

## 4. Retensi & keamanan

* Backup harian, simpan 7 (rotasi otomatis di skrip).
* `lifeos.db` berisi data pribadi — JANGAN commit, JANGan kirim mentah;
  untuk analisis pakai snapshot seed (`lifeos-data`).
* JWT_SECRET prod ≥ 32 char acak (`openssl rand -hex 32`).
