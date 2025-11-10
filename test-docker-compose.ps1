# Docker Compose Test Script
# Bu script Docker Compose ile başlatılan servislerin durumunu kontrol eder

Write-Host "=== DOCKER COMPOSE TEST ===" -ForegroundColor Cyan
Write-Host ""

# 1. Docker Compose Durumu
Write-Host "1. DOCKER COMPOSE DURUMU" -ForegroundColor Yellow
Write-Host ""

try {
    $composeStatus = docker-compose ps 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✓ Docker Compose çalışıyor" -ForegroundColor Green
        Write-Host ""
        $composeStatus | ForEach-Object { Write-Host "    $_" -ForegroundColor Gray }
    } else {
        Write-Host "  ✗ Docker Compose hatası" -ForegroundColor Red
        Write-Host "    Hata: $composeStatus" -ForegroundColor Gray
    }
} catch {
    Write-Host "  ✗ Docker Compose bulunamadı" -ForegroundColor Red
    Write-Host "    Docker Compose yüklü olduğundan emin olun" -ForegroundColor Gray
    exit 1
}

Write-Host ""

# 2. Container'ların Durumu
Write-Host "2. CONTAINER DURUMLARI" -ForegroundColor Yellow
Write-Host ""

$containers = @(
    @{Name="postgres"; Port=5432},
    @{Name="rabbitmq"; Port=15672},
    @{Name="redis"; Port=6379},
    @{Name="zipkin"; Port=9411},
    @{Name="service-registry"; Port=8761},
    @{Name="config-server"; Port=8888},
    @{Name="api-gateway"; Port=8080},
    @{Name="user-service"; Port=8081},
    @{Name="product-service"; Port=8082},
    @{Name="order-service"; Port=8083},
    @{Name="inventory-service"; Port=8084},
    @{Name="notification-service"; Port=8085}
)

$allRunning = $true
foreach ($container in $containers) {
    $containerStatus = docker ps --filter "name=$($container.Name)" --format "{{.Status}}" 2>&1
    if ($containerStatus -and $containerStatus -notmatch "error") {
        Write-Host "  ✓ $($container.Name) çalışıyor" -ForegroundColor Green
        Write-Host "    Port: $($container.Port)" -ForegroundColor Gray
    } else {
        Write-Host "  ✗ $($container.Name) çalışmıyor" -ForegroundColor Red
        $allRunning = $false
    }
}

Write-Host ""

# 3. Health Check'ler
Write-Host "3. HEALTH CHECK'LER" -ForegroundColor Yellow
Write-Host ""

$healthServices = @(
    @{Name="service-registry"; Port=8761; Path="/actuator/health"},
    @{Name="config-server"; Port=8888; Path="/actuator/health"},
    @{Name="user-service"; Port=8081; Path="/actuator/health"},
    @{Name="product-service"; Port=8082; Path="/actuator/health"},
    @{Name="order-service"; Port=8083; Path="/actuator/health"},
    @{Name="inventory-service"; Port=8084; Path="/actuator/health"},
    @{Name="notification-service"; Port=8085; Path="/actuator/health"},
    @{Name="api-gateway"; Port=8080; Path="/actuator/health"}
)

$allHealthy = $true
foreach ($service in $healthServices) {
    try {
        $health = Invoke-RestMethod -Uri "http://localhost:$($service.Port)$($service.Path)" -Method Get -TimeoutSec 5 -ErrorAction Stop
        if ($health.status -eq "UP") {
            Write-Host "  ✓ $($service.Name) sağlıklı" -ForegroundColor Green
        } else {
            Write-Host "  ⚠ $($service.Name) sağlıksız (Status: $($health.status))" -ForegroundColor Yellow
            $allHealthy = $false
        }
    } catch {
        Write-Host "  ✗ $($service.Name) health check başarısız" -ForegroundColor Red
        Write-Host "    Hata: $($_.Exception.Message)" -ForegroundColor Gray
        $allHealthy = $false
    }
}

Write-Host ""

# 4. Infrastructure Services
Write-Host "4. INFRASTRUCTURE SERVİSLER" -ForegroundColor Yellow
Write-Host ""

# PostgreSQL
try {
    $pgTest = docker exec postgres pg_isready -U postgres 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✓ PostgreSQL çalışıyor" -ForegroundColor Green
    } else {
        Write-Host "  ✗ PostgreSQL çalışmıyor" -ForegroundColor Red
    }
} catch {
    Write-Host "  ✗ PostgreSQL kontrol edilemedi" -ForegroundColor Red
}

# RabbitMQ
try {
    $rmqHealth = Invoke-WebRequest -Uri "http://localhost:15672/api/overview" -Method Get -Headers @{Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("guest:guest"))} -UseBasicParsing -TimeoutSec 5 -ErrorAction Stop
    if ($rmqHealth.StatusCode -eq 200) {
        Write-Host "  ✓ RabbitMQ çalışıyor" -ForegroundColor Green
    }
} catch {
    Write-Host "  ✗ RabbitMQ çalışmıyor" -ForegroundColor Red
}

# Redis
try {
    $redisTest = docker exec redis redis-cli ping 2>&1
    if ($redisTest -match "PONG") {
        Write-Host "  ✓ Redis çalışıyor" -ForegroundColor Green
    } else {
        Write-Host "  ✗ Redis çalışmıyor" -ForegroundColor Red
    }
} catch {
    Write-Host "  ✗ Redis kontrol edilemedi" -ForegroundColor Red
}

# Zipkin
try {
    $zipkinHealth = Invoke-RestMethod -Uri "http://localhost:9411/health" -Method Get -TimeoutSec 5 -ErrorAction Stop
    Write-Host "  ✓ Zipkin çalışıyor" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Zipkin çalışmıyor" -ForegroundColor Red
}

Write-Host ""

# 5. Özet
Write-Host "=== ÖZET ===" -ForegroundColor Cyan
Write-Host ""

if ($allRunning -and $allHealthy) {
    Write-Host "✅ TÜM SERVİSLER ÇALIŞIYOR VE SAĞLIKLI!" -ForegroundColor Green
} else {
    Write-Host "⚠ BAZI SERVİSLER SORUNLU" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "💡 Çözüm önerileri:" -ForegroundColor Cyan
    Write-Host "   • docker-compose logs [service-name] ile logları kontrol edin" -ForegroundColor Gray
    Write-Host "   • docker-compose restart [service-name] ile yeniden başlatın" -ForegroundColor Gray
    Write-Host "   • docker-compose ps ile container durumlarını kontrol edin" -ForegroundColor Gray
}

Write-Host ""
Write-Host "📊 Erişim URL'leri:" -ForegroundColor Yellow
Write-Host "   • Eureka Dashboard: http://localhost:8761" -ForegroundColor Gray
Write-Host "   • API Gateway: http://localhost:8080" -ForegroundColor Gray
Write-Host "   • RabbitMQ Management: http://localhost:15672 (guest/guest)" -ForegroundColor Gray
Write-Host "   • Zipkin UI: http://localhost:9411" -ForegroundColor Gray
Write-Host ""

