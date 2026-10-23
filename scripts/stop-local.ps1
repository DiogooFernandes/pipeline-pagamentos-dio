$ErrorActionPreference = "Stop"
docker compose down
Write-Host "Containers parados/removidos. O volume de dados foi preservado."
Write-Host "Para apagar também os dados locais, execute manualmente: docker compose down -v"
