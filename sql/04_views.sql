-- Kullanıcıların oturum sayısını, son oturum tarihini ve aktif anahtar bilgisini özetler
CREATE OR REPLACE VIEW v_user_security_summary AS
SELECT
    u.user_id,
    u.username,
    u.email,
    COUNT(DISTINCT s.session_id) AS total_sessions,
    MAX(s.recorded_at) AS last_session_at,
    ck.key_id AS active_key_id,
    ck.entropy_score AS active_key_entropy,
    ck.created_at AS active_key_created_at
FROM users u
LEFT JOIN eeg_sessions s ON s.user_id = u.user_id
LEFT JOIN crypto_keys ck ON ck.user_id = u.user_id AND ck.is_active = TRUE
GROUP BY
    u.user_id,
    u.username,
    u.email,
    ck.key_id,
    ck.entropy_score,
    ck.created_at;
