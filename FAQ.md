# FAQ — LifeOS

**Lupa password?** Seed: `aku@lifeos.local / Rahasia123`. Bila diganti dan lupa → reset DB ke seed (data hilang) atau update hash via sqlite.

**Keluar sendiri?** Token 24 jam (by design). Login ulang.

**PUT menghapus field?** By design (full-replace). UI selalu kirim objek penuh.

**Backup di mana?** `backups/lifeos-<TS>.db`, rotasi 7. Restore: matikan API dulu.

**Data saya aman?** `lifeos.db` lokal saja, tak terkirim ke mana pun. Jangan commit/paste isinya.

**Web blank?** Hard refresh dulu (cache), lalu cek `:5174` + build.
