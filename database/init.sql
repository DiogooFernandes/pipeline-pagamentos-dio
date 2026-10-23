-- Esquema de pagamentos para demonstração de CDC.
CREATE TABLE IF NOT EXISTS customers (
    customer_id INTEGER PRIMARY KEY,
    full_name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS accounts (
    account_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id),
    account_status TEXT NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS cards (
    card_id INTEGER PRIMARY KEY,
    account_id INTEGER NOT NULL REFERENCES accounts(account_id),
    card_status TEXT NOT NULL DEFAULT 'ACTIVE',
    last_four CHAR(4) NOT NULL
);

CREATE TABLE IF NOT EXISTS merchants (
    merchant_id INTEGER PRIMARY KEY,
    merchant_name TEXT NOT NULL,
    category TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS transactions (
    transaction_id BIGINT PRIMARY KEY,
    account_id INTEGER NOT NULL REFERENCES accounts(account_id),
    card_id INTEGER NOT NULL REFERENCES cards(card_id),
    merchant_id INTEGER NOT NULL REFERENCES merchants(merchant_id),
    amount NUMERIC(15,2) NOT NULL CHECK (amount > 0),
    currency CHAR(3) NOT NULL DEFAULT 'BRL',
    transaction_status TEXT NOT NULL DEFAULT 'APPROVED',
    transaction_time TIMESTAMPTZ NOT NULL
);

-- Usuário local de referência. Troque a senha antes de qualquer uso além do laboratório.
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'cdc_user') THEN
    CREATE ROLE cdc_user WITH LOGIN PASSWORD 'cdc_local_change_me' REPLICATION;
  END IF;
END
$$;

GRANT CONNECT ON DATABASE payments TO cdc_user;
GRANT USAGE ON SCHEMA public TO cdc_user;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO cdc_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO cdc_user;

DROP PUBLICATION IF EXISTS payments_publication;
CREATE PUBLICATION payments_publication FOR TABLE customers, accounts, cards, merchants, transactions;

ALTER TABLE customers REPLICA IDENTITY FULL;
ALTER TABLE accounts REPLICA IDENTITY FULL;
ALTER TABLE cards REPLICA IDENTITY FULL;
ALTER TABLE merchants REPLICA IDENTITY FULL;
ALTER TABLE transactions REPLICA IDENTITY FULL;
