-- Runs once, the first time the pgdata volume is created.
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS users (
    id            SERIAL PRIMARY KEY,
    username      VARCHAR(50) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    role          VARCHAR(20) NOT NULL DEFAULT 'user' CHECK (role IN ('user', 'admin'))
);

CREATE TABLE IF NOT EXISTS products (
    id        SERIAL PRIMARY KEY,
    name      VARCHAR(100) UNIQUE NOT NULL,
    price     NUMERIC(10, 2) NOT NULL CHECK (price >= 0),
    image_url TEXT
);

CREATE TABLE IF NOT EXISTS orders (
    id            SERIAL PRIMARY KEY,
    user_id       INTEGER NOT NULL REFERENCES users(id),
    items         JSONB NOT NULL,              -- snapshot: product_id, name, price, quantity
    total         NUMERIC(10, 2) NOT NULL,
    slip_filename VARCHAR(255) NOT NULL,
    status        VARCHAR(20) NOT NULL DEFAULT 'pending_review',
    created_at    TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Sample data. Password is stored as a bcrypt hash (demo login: user1 / 1234).
INSERT INTO users (username, password_hash, role)
VALUES ('user1', crypt('1234', gen_salt('bf', 10)), 'user')
ON CONFLICT (username) DO NOTHING;

-- Demo admin account (demo login: admin / admin1234). Change this password before deploying.
INSERT INTO users (username, password_hash, role)
VALUES ('admin', crypt('admin1234', gen_salt('bf', 10)), 'admin')
ON CONFLICT (username) DO NOTHING;

INSERT INTO products (name, price, image_url) VALUES
    ('Mechanical Keyboard', 1290.00, 'https://placehold.co/400x400/DDE2EA/172033?text=Keyboard'),
    ('Gaming Mouse',         790.00, 'https://placehold.co/400x400/DDE2EA/172033?text=Mouse'),
    ('Gaming Headset',      1490.00, 'https://placehold.co/400x400/DDE2EA/172033?text=Headset'),
    ('XL Desk Mat',          450.00, 'https://placehold.co/400x400/DDE2EA/172033?text=Desk+Mat'),
    ('Webcam 1080p',         990.00, 'https://placehold.co/400x400/DDE2EA/172033?text=Webcam'),
    ('USB-C Hub',            590.00, 'https://placehold.co/400x400/DDE2EA/172033?text=USB-C+Hub'),
    ('Ram',            590.00, '/products/ram.jpg')
ON CONFLICT (name) DO NOTHING;
