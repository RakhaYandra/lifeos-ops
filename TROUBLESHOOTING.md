# Troubleshooting Matrix — LifeOS

Tiap perintah di bawah **dijalankan beneran** saat penyusunan (env: API :8080,
Web :5174, SQLite). Gejala → diagnosis → perintah → hasil sehat.

| # | Gejala | Diagnosis | Perintah | Sehat bila |
|---|---|---|---|---|
| 1 | Web tak bisa apa-apa | API mati | `pgrep -f lifeos-run; curl -s localhost:8080/healthz` | `RUNNING` + `{"status":"ok"}` |
| 2 | `bind: address in use` | Port bentrok | `ss -ltnp \| grep 8080` | Hanya 1 proses; bunuh yang liar / ganti `PORT` |
| 3 | Login gagal, log hanya OPTIONS | CORS: origin ≠ FRONTEND_URL (insiden nyata `:5173` vs `:5174`) | `curl -s -D- -o /dev/null -X OPTIONS .../v1/auth/login -H 'Origin: http://localhost:5174' ... \| grep -i access-control-allow-origin` | Balas origin yang benar |
| 4 | 401 massal tiba-tiba | JWT_SECRET API beda dengan saat token terbit | Restart API dari `.env` yang sama; semua token lama hangus (by design) | Login ulang sukses |
| 5 | `database is locked` | Multi-writer SQLite | `fuser lifeos.db` → 1 PID wajar (WAL); jangan 2 API tulis bareng | 1 writer |
| 6 | 500 semua endpoint | DB hilang/korup | `ls -la lifeos.db` (sidik: 266240 bytes, 1 user) | File ada; bila tidak → restore |
| 7 | Migrasi gagal tengah jalan | Versi goose tak sinkron | `goose -dir migrations sqlite lifeos.db status \| grep Pending` | 0 baris Pending |
| 8 | Seed error UNIQUE | Seed dijalankan 2x | `sqlite3 lifeos.db "SELECT COUNT(*) FROM users;"` | = 1; reset bila perlu |
| 9 | Tulis gagal / backup 0 byte | Disk penuh | `df -h .` | Avail lega (terukur 41G) |
| 10 | Token ditolak padahal baru login | Jam server skew / exp 24 jam | Decode payload `exp` (tanpa verify) bandingkan `date +%s` | `exp` > sekarang |
| 11 | Web blank putih | Vite mati / build rusak | `curl -s localhost:5174/ \| grep title` + `npm run build` | `<title>lifeos…` + build hijau |
| 12 | 500 misterius | Lihat log dulu | `tail -n 50 /tmp/lifeos-run.log` (atau journal) | Stack/gin error terlihat |
| 13 | Endpoint baru 404 | Migrasi pending / binary lama | `goose status` + `git log --oneline -1` vs binary | v15, binary terbaru |
| 14 | Lupa kredensial seed | Seed tertimpa? | `POST /v1/auth/register` → 403 = seed ada; atau reset seed | 403 single_user_only |
| 15 | Ragu config aktif | `.env` vs default | `grep FRONTEND_URL .env` + restart dari dir app | Sama dengan origin browser |

Aturan umum: **log dulu (`tail`), tebak kemudian**. Jangan restart buta —
catat error persisnya untuk tiket.
