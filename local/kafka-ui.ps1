param([ValidateSet('start','stop','status','logs','update')][string]$Action = 'start')

$compose = Join-Path $PSScriptRoot 'docker-compose.yml'

docker info *> $null
if ($LASTEXITCODE -ne 0 -and $Action -ne 'stop') {
    Write-Host 'Starting Docker Desktop...'
    Start-Process 'C:\Program Files\Docker\Docker\Docker Desktop.exe'
    do { Start-Sleep 3; docker info *> $null } while ($LASTEXITCODE -ne 0)
}

switch ($Action) {
    'start'  {
        docker compose -f $compose up -d
        Write-Host 'Waiting for Kafka UI...'
        for ($i = 0; $i -lt 60; $i++) {
            try { Invoke-WebRequest 'http://localhost:8080/actuator/health' -UseBasicParsing -TimeoutSec 2 | Out-Null; break }
            catch { Start-Sleep 2 }
        }
        Start-Process 'http://localhost:8080'
    }
    'stop'   { docker compose -f $compose down }
    'status' { docker compose -f $compose ps }
    'logs'   { docker compose -f $compose logs -f kafka-ui }
    'update' { docker compose -f $compose pull; docker compose -f $compose up -d }
}
