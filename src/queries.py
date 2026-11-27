import os
import psycopg
from dotenv import load_dotenv

load_dotenv()
DATABASE_URL = os.getenv("DATABASE_URL")

if not DATABASE_URL:
    raise RuntimeError("DATABASE_URL bulunamadi. .env dosyasini kontrol edin.")

with psycopg.connect(DATABASE_URL) as conn:
    with conn.cursor() as cur:
        print("=== KULLANICI GUVENLIK OZETI ===")
        cur.execute("SELECT * FROM v_user_security_summary;")
        for row in cur.fetchall():
            print(row)

        print("\n=== SON EEG OZNITELIKLERI (JSONB) ===")
        cur.execute(
            """
            SELECT
                ef.feature_id,
                ef.session_id,
                ef.feature_vector->>'alpha_mean' AS alpha_mean,
                ef.feature_vector->>'channel_entropy_avg' AS entropy_avg,
                ef.extracted_at
            FROM eeg_features ef
            ORDER BY ef.feature_id DESC
            LIMIT 5;
            """
        )
        for row in cur.fetchall():
            print(row)

        print("\n=== ANAHTAR GECMISI ===")
        cur.execute(
            """
            SELECT key_id, user_id, session_id, entropy_score, is_active, created_at
            FROM crypto_keys
            ORDER BY key_id DESC;
            """
        )
        for row in cur.fetchall():
            print(row)