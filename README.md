# lifeos-ops

Operasional [LifeOS](https://github.com/RakhaYandra/lifeos): runbook,
skrip backup/restore teruji, troubleshooting matrix (perintah terverifikasi),
10 tiket simulasi + XLSX, SLA mini, FAQ.

## Isi

```
RUNBOOK.md          # install, .env, backup/restore/reset/restart, checklist login
scripts/            # lifeos-backup.sh + lifeos-restore.sh (rotasi 7, guard API)
TROUBLESHOOTING.md  # 15 entri: gejala → diagnosis → perintah (terverifikasi)
tickets.yaml        # 10 tiket simulasi (2 insiden nyata: CORS, restore)
tools/build_tickets.py -> LifeOS-Tickets.xlsx (cover, tiket, SLA COUNTIF + pie)
SLA.md, FAQ.md
```

## Bukti uji

* Roundtrip: backup → hapus tasks (0) → restore → 25 tasks + 19 goals kembali
* Guard restore menolak saat API jalan
* 15 perintah matrix dijalankan (output tercatat di commit message run)
