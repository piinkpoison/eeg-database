import os
import json
import psycopg
from dotenv import load_dotenv

load_dotenv()
DATABASE_URL = os.getenv("DATABASE_URL")

if not DATABASE_URL:
    raise RuntimeError("DATABASE_URL bulunamadi. .env dosyasini kontrol edin.")

with psycopg.connect(DATABASE_URL) as conn:
    with conn.cursor() as cur:
        cur.execute("SELECT * FROM v_user_security_summary;")
        print("Mevcut ozet:", cur.fetchall())

        cur.execute(
            """
            INSERT INTO eeg_sessions (user_id, device_info, sampling_rate_hz, channel_count)
            SELECT user_id, 'OpenBCI Cyton (Simulasyon)', 250, 8
            FROM users WHERE username = 'test_kullanici'
            RETURNING session_id, user_id;
            """
        )
        session_id, user_id = cur.fetchone()

        features = {
            "alpha_mean": 10.85,
            "beta_mean": 19.40,
            "theta_power": 31.25,
            "gamma_std": 2.41,
            "channel_entropy_avg": 0.934
        }
        cur.execute(
            """
            INSERT INTO eeg_features (session_id, feature_vector)
            VALUES (%s, %s::jsonb);
            """,
            (session_id, json.dumps(features))
        )

        cur.execute(
            """
            INSERT INTO crypto_keys (user_id, session_id, key_hash, entropy_score, is_active)
            VALUES (%s, %s, %s, %s, TRUE)
            RETURNING key_id, is_active;
            """,
            (user_id, session_id, "sample_biometric_key_hash_003", 0.9720)
        )
        print("Yeni aktif anahtar:", cur.fetchone())

        cur.execute(
            "CALL sp_write_system_log(%s, %s, %s);",
            (user_id, "PYTHON_DEMO_RUN", f"Session {session_id} ve yeni anahtar eklendi.")
        )

    conn.commit()
print("Islem basariyla tamamlandi.")