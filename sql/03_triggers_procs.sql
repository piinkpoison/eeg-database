-- Yeni aktif anahtar eklendiğinde kullanıcının eski aktif anahtarlarını pasife çeker
CREATE OR REPLACE FUNCTION fn_deactivate_previous_keys()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.is_active = TRUE THEN
        UPDATE crypto_keys
        SET is_active = FALSE
        WHERE user_id = NEW.user_id
          AND key_id <> NEW.key_id
          AND is_active = TRUE;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_deactivate_previous_keys
AFTER INSERT ON crypto_keys
FOR EACH ROW
EXECUTE FUNCTION fn_deactivate_previous_keys();

-- Sistem logu eklemek için saklı yordam (Stored Procedure)
CREATE OR REPLACE PROCEDURE sp_write_system_log(
    p_user_id INT,
    p_action_type VARCHAR(60),
    p_description TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO system_logs (user_id, action_type, description)
    VALUES (p_user_id, p_action_type, p_description);
END;
$$;
