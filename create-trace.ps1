# Trace Oluşturma Script'i
# Bu script bir sipariş oluşturarak tüm servisler arasında trace oluşturur

Write-Host "=== TRACE OLUŞTURMA ===" -ForegroundColor Cyan
Write-Host ""

# 1. Kullanıcı oluştur
Write-Host "1. Kullanıcı oluşturuluyor..." -ForegroundColor Yellow
try {
    $userBody = @{
        name = "Trace Test User $(Get-Date -Format 'HH:mm:ss')"
        email = "trace-test-$(Get-Random)@example.com"
        phone = "555$(Get-Random -Minimum 1000000 -Maximum 9999999)"
    } | ConvertTo-Json
    
    $userResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/users" -Method Post -Body $userBody -ContentType "application/json" -ErrorAction Stop
    $userId = $userResponse.id
    Write-Host "   ✓ Kullanıcı oluşturuldu (ID: $userId)" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Kullanıcı oluşturulamadı: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# 2. Ürün oluştur
Write-Host ""
Write-Host "2. Ürün oluşturuluyor..." -ForegroundColor Yellow
try {
    $productBody = @{
        name = "Trace Test Product $(Get-Date -Format 'HH:mm:ss')"
        description = "Distributed Tracing Test Product"
        price = 99.99
        category = "Test"
        stockQuantity = 100
    } | ConvertTo-Json
    
    $productResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/products" -Method Post -Body $productBody -ContentType "application/json" -ErrorAction Stop
    $productId = $productResponse.id
    Write-Host "   ✓ Ürün oluşturuldu (ID: $productId)" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Ürün oluşturulamadı: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# 3. Sipariş oluştur (TRACE OLUŞTURACAK)
Write-Host ""
Write-Host "3. Sipariş oluşturuluyor (TRACE OLUŞTURACAK)..." -ForegroundColor Yellow
try {
    $orderBody = @{
        userId = $userId
        items = @(
            @{
                productId = $productId
                quantity = 2
            }
        )
    } | ConvertTo-Json
    
    $orderResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/orders" -Method Post -Body $orderBody -ContentType "application/json" -ErrorAction Stop
    Write-Host "   ✓ Sipariş oluşturuldu!" -ForegroundColor Green
    Write-Host "     Order ID: $($orderResponse.id)" -ForegroundColor Gray
    Write-Host "     Status: $($orderResponse.status)" -ForegroundColor Gray
} catch {
    Write-Host "   ✗ Sipariş oluşturulamadı: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $responseBody = $reader.ReadToEnd()
        Write-Host "     Response: $responseBody" -ForegroundColor Gray
    }
    exit 1
}

Write-Host ""
Write-Host "=== TRACE BAŞARIYLA OLUŞTURULDU! ===" -ForegroundColor Green
Write-Host ""
Write-Host "🎯 Bu trace şu servisleri içerir:" -ForegroundColor Cyan
Write-Host "   • API Gateway (entry point)" -ForegroundColor White
Write-Host "   • Order Service" -ForegroundColor White
Write-Host "   • User Service (Feign Client - kullanıcı kontrolü)" -ForegroundColor White
Write-Host "   • Product Service (Feign Client - ürün kontrolü)" -ForegroundColor White
Write-Host "   • Inventory Service (Feign Client - stok kontrolü)" -ForegroundColor White
Write-Host "   • RabbitMQ (mesaj gönderme)" -ForegroundColor White
Write-Host "   • Notification Service (RabbitMQ consumer)" -ForegroundColor White
Write-Host ""
Write-Host "📊 Zipkin'de görüntülemek için:" -ForegroundColor Yellow
Write-Host "   1. Browser'da açın: http://localhost:9411" -ForegroundColor White
Write-Host "   2. Service Name: 'api-gateway' veya 'order-service' seçin" -ForegroundColor White
Write-Host "   3. 'Run Query' butonuna tıklayın" -ForegroundColor White
Write-Host "   4. En son trace'i göreceksiniz!" -ForegroundColor White
Write-Host ""
Write-Host "⏳ Trace'ler birkaç saniye içinde Zipkin'e gönderilecektir..." -ForegroundColor Cyan
Write-Host ""

