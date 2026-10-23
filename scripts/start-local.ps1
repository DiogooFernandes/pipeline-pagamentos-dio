$ErrorActionPreference = "Stop"
if (-not (Test-Path ".env")) {
    Copy-Item ".env.example" ".env"
    Write-Host "Criado .env a partir de .env.example. Revise os valores locais."
}
docker compose up -d postgres
if ($LASTEXITCODE -ne 0) { throw "Falha ao iniciar PostgreSQL com Docker Compose." }
docker compose ps
