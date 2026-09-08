-- Payment: Cash on Delivery for Iraq B2B
-- Since ZainCash/QiCard not yet configured, COD is the default payment method.
-- Orders are confirmed with COD and escrow logic is applied manually.

CREATE TABLE IF NOT EXISTS payment_methods (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,   -- 'COD', 'ZAINCASH', 'QICARD'
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO payment_methods (name, is_active) VALUES
    ('Cash on Delivery', TRUE),
    ('ZainCash', FALSE),    -- Will be activated when credentials arrive
    ('Qi Card', FALSE);     -- Will be activated when credentials arrive
