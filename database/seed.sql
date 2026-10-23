-- Carga sintética determinística: 200 clientes, 240 contas, 320 cartões,
-- 60 estabelecimentos e 2.000 transações.
-- Reexecutável: ON CONFLICT não duplica os registros.
INSERT INTO customers (customer_id, full_name, email)
SELECT i, 'Cliente Sintetico ' || lpad(i::text, 3, '0'),
       'cliente' || lpad(i::text, 3, '0') || '@example.test'
FROM generate_series(1, 200) AS gs(i)
ON CONFLICT (customer_id) DO NOTHING;

INSERT INTO accounts (account_id, customer_id, account_status, created_at)
SELECT 1000 + i, 1 + ((i - 1) % 200),
       CASE WHEN i % 25 = 0 THEN 'REVIEW' ELSE 'ACTIVE' END,
       TIMESTAMPTZ '2025-01-01 00:00:00+00' + (i * INTERVAL '1 hour')
FROM generate_series(1, 240) AS gs(i)
ON CONFLICT (account_id) DO NOTHING;

INSERT INTO cards (card_id, account_id, card_status, last_four)
SELECT 1000 + i, 1001 + ((i - 1) % 240),
       CASE WHEN i % 40 = 0 THEN 'BLOCKED' ELSE 'ACTIVE' END,
       lpad((i % 10000)::text, 4, '0')
FROM generate_series(1, 320) AS gs(i)
ON CONFLICT (card_id) DO NOTHING;

INSERT INTO merchants (merchant_id, merchant_name, category)
SELECT 5000 + i, 'Estabelecimento Sintetico ' || lpad(i::text, 2, '0'),
       (ARRAY['RETAIL','GROCERY','SERVICES','TRAVEL','DIGITAL'])[1 + ((i - 1) % 5)]
FROM generate_series(1, 60) AS gs(i)
ON CONFLICT (merchant_id) DO NOTHING;

-- Cenário explícito: três transações do cartão 1001 em 40 segundos.
INSERT INTO transactions
(transaction_id, account_id, card_id, merchant_id, amount, currency, transaction_status, transaction_time)
VALUES
(1, 1001, 1001, 5001, 125.50, 'BRL', 'APPROVED', TIMESTAMPTZ '2026-01-01 12:00:00+00'),
(2, 1001, 1001, 5002, 89.90,  'BRL', 'APPROVED', TIMESTAMPTZ '2026-01-01 12:00:20+00'),
(3, 1001, 1001, 5003, 45.00,  'BRL', 'APPROVED', TIMESTAMPTZ '2026-01-01 12:00:40+00')
ON CONFLICT (transaction_id) DO NOTHING;

INSERT INTO transactions
(transaction_id, account_id, card_id, merchant_id, amount, currency, transaction_status, transaction_time)
SELECT 100 + i,
       1001 + ((i - 1) % 240),
       1001 + ((i - 1) % 320),
       5001 + ((i - 1) % 60),
       (10 + ((i * 37) % 25000) / 100.0)::NUMERIC(15,2),
       'BRL',
       CASE WHEN i % 31 = 0 THEN 'DECLINED' ELSE 'APPROVED' END,
       TIMESTAMPTZ '2026-01-02 00:00:00+00' + (i * INTERVAL '17 seconds')
FROM generate_series(1, 1997) AS gs(i)
ON CONFLICT (transaction_id) DO NOTHING;
