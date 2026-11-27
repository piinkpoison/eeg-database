# EEG Veritabanı Projesi (`eeg-database`)

EEG sinyallerinden elde edilen öznitelik vektörlerinin (`JSONB`), kullanıcı oturumlarının, kriptografik anahtar yaşam döngüsünün ve denetim/log kayıtlarının [PostgreSQL](https://www.postgresql.org/) üzerinde tutulduğu veritabanı projesi.

## Proje Yapısı

* `sql/01_schema.sql`: Tablolar (`users`, `eeg_sessions`, `eeg_features`, `crypto_keys`, `system_logs`, `audit_trail`) ve kısıtlar.
* `sql/02_indexes.sql`: B-Tree ve `JSONB` için GIN indeksleri.
* `sql/03_triggers_procs.sql`: Yeni aktif anahtar eklendiğinde önceki aktif anahtarları pasife çeken tetikleyici ve `sp_write_system_log` saklı yordamı.
* `sql/04_views.sql`: Kullanıcı güvenlik ve oturum özetini sunan `v_user_security_summary` görünümü.
* `sql/05_seed.sql`: Başlangıç test verileri.
* `src/db_demo.py`: [Neon](https://neon.tech) PostgreSQL bağlantısı, oturum/`JSONB` kaydı, anahtar rotasyonu ve log yazma demosu.
* `src/queries.py`: Güvenlik özeti, `JSONB` öznitelikleri ve anahtar geçmişi sorguları.

## Kurulum ve Çalıştırma Sırası

1. [Neon](https://neon.tech) üzerinde bir PostgreSQL projesi oluşturup **SQL Editor** içinde `01_schema.sql` -> `05_seed.sql` dosyalarını sırayla çalıştır.
2. Proje kök dizininde `.env` dosyası oluştur ve bağlantı adresini ekle:
   ```env
   DATABASE_URL=postgresql://neondb_owner:npg_4iXkD6ygYwUO@ep-nameless-mouse-bdn7z1qb-pooler.c-8.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require