$ErrorActionPreference = "Stop"
Get-Content ".\database\init.sql" | docker compose exec -T postgres psql -U app_user -d payments
if ($LASTEXITCODE -ne 0) { throw "Falha ao aplicar database/init.sql." }
Get-Content ".\database\seed.sql" | docker compose exec -T postgres psql -U app_user -d payments
if ($LASTEXITCODE -ne 0) { throw "Falha ao aplicar database/seed.sql." }
docker compose exec postgres psql -U app_user -d payments -c "SELECT 'customers' AS tabela, COUNT(*) FROM customers UNION ALL SELECT 'accounts', COUNT(*) FROM accounts UNION ALL SELECT 'cards', COUNT(*) FROM cards UNION ALL SELECT 'merchants', COUNT(*) FROM merchants UNION ALL SELECT 'transactions', COUNT(*) FROM transactions;"
