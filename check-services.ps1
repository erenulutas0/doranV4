# Servis Durumu Kontrol Scripti
# Kullanım: .\check-services.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Microservices Durum Kontrolü" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Docker Compose durumu
Write-Host "Docker Compose Servisleri:" -ForegroundColor Yellow
docker-compose ps
Write-Host ""

# Health check'ler
Write-Host "Health Check'ler:" -ForegroundColor Yellow
Write-Host ""

$services = @(
    @{Name="Service Registry"; Url="http://localhost:8761/actuator/health"},
    @{Name="Config Server"; Url="http://localhost:8888/actuator/health"},
    @{Name="User Service"; Url="http://localhost:8081/actuator/health"},
    @{Name="Product Service"; Url="http://localhost:8082/actuator/health"},
    @{Name="Order Service"; Url="http://localhost:8083/actuator/health"},
    @{Name="Inventory Service"; Url="http://localhost:8084/actuator/health"},
    @{Name="Notification Service"; Url="http://localhost:8085/actuator/health"},
    @{Name="API Gateway"; Url="http://localhost:8080/actuator/health"}
)

foreach ($service in $services) {
    try {
        $response = Invoke-WebRequest -Uri $service.Url -Method GET -TimeoutSec 2 -ErrorAction Stop
        if ($response.StatusCode -eq 200) {
            Write-Host "✅ $($service.Name): " -ForegroundColor Green -NoNewline
            Write-Host "ÇALIŞIYOR" -ForegroundColor White
        }
    } catch {
        Write-Host "❌ $($service.Name): " -ForegroundColor Red -NoNewline
        Write-Host "ÇALIŞMIYOR" -ForegroundColor White
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Eureka Dashboard" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Tüm kayıtlı servisleri görmek için:" -ForegroundColor Yellow
Write-Host "  http://localhost:8761" -ForegroundColor White
Write-Host ""

