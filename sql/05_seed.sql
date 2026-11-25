-- Örnek kullanıcı
INSERT INTO users (username, email)
VALUES ('test_kullanici', 'test@example.com')
ON CONFLICT (username) DO NOTHING;

-- Örnek EEG oturumu
INSERT INTO eeg_sessions (user_id, device_info, sampling_rate_hz, channel_count)
SELECT user_id, 'Emotiv EPOC X (Simulasyon)', 256, 14
FROM users
WHERE username = 'test_kullanici';

-- Örnek EEG öznitelikleri (JSONB)
INSERT INTO eeg_features (session_id, feature_vector)
SELECT session_id, '{
  "alpha_mean": 11.42,
  "beta_mean": 18.75,
  "theta_power": 34.10,
  "gamma_std": 2.18,
  "channel_entropy_avg": 0.912
}'::jsonb
FROM eeg_sessions
ORDER BY session_id DESC
LIMIT 1;

-- Örnek şifreleme anahtarı kaydı
INSERT INTO crypto_keys (user_id, session_id, key_hash, entropy_score, is_active)
SELECT s.user_id, s.session_id, 'sample_sha256_or_biometric_key_hash_001', 0.9450, TRUE
FROM eeg_sessions s
JOIN users u ON u.user_id = s.user_id
WHERE u.username = 'test_kullanici'
ORDER BY s.session_id DESC
LIMIT 1;

-- Örnek sistem logu (Stored Procedure ile)
CALL sp_write_system_log(
    (SELECT user_id FROM users WHERE username = 'test_kullanici'),
    'SEED_INIT',
    'Baslangic test verileri eklendi.'
);
