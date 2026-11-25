-- İlişki ve sık sorgulanan alanlar için B-Tree indeksleri
CREATE INDEX idx_sessions_user_id ON eeg_sessions(user_id);
CREATE INDEX idx_sessions_recorded_at ON eeg_sessions(recorded_at);
CREATE INDEX idx_features_session_id ON eeg_features(session_id);
CREATE INDEX idx_keys_user_id ON crypto_keys(user_id);
CREATE INDEX idx_keys_active ON crypto_keys(user_id, is_active);
CREATE INDEX idx_logs_user_id ON system_logs(user_id);
CREATE INDEX idx_audit_table_record ON audit_trail(table_name, record_id);

-- JSONB öznitelik vektöründe hızlı arama için GIN indeksi
CREATE INDEX idx_features_vector_gin ON eeg_features USING GIN (feature_vector);
