CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(120) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE eeg_sessions (
    session_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    device_info VARCHAR(120),
    sampling_rate_hz INT CHECK (sampling_rate_hz > 0),
    channel_count INT CHECK (channel_count > 0)
);

CREATE TABLE eeg_features (
    feature_id SERIAL PRIMARY KEY,
    session_id INT NOT NULL REFERENCES eeg_sessions(session_id) ON DELETE CASCADE,
    feature_vector JSONB NOT NULL,
    extracted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE crypto_keys (
    key_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    session_id INT NOT NULL REFERENCES eeg_sessions(session_id) ON DELETE CASCADE,
    key_hash VARCHAR(255) NOT NULL,
    entropy_score NUMERIC(5, 4) CHECK (entropy_score >= 0 AND entropy_score <= 1),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE system_logs (
    log_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE SET NULL,
    action_type VARCHAR(60) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE audit_trail (
    audit_id SERIAL PRIMARY KEY,
    table_name VARCHAR(60) NOT NULL,
    record_id INT NOT NULL,
    operation VARCHAR(15) NOT NULL,
    changed_by VARCHAR(60),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    details JSONB
);
