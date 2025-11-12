# Review Service - Test Reviews Insert Script
# Bu script product-service'den product ID'lerini alıp review-service'e test review'ları ekler

Write-Host "`n🔄 Test review'ları ekleniyor...`n" -ForegroundColor Cyan

# API Gateway URL
$gatewayUrl = "http://localhost:8080"

# Test kullanıcı ID'leri (user-service'den)
$users = @(
    @{ id = "550e8400-e29b-41d4-a716-446655440002"; name = "John Doe" },
    @{ id = "550e8400-e29b-41d4-a716-446655440003"; name = "Jane Smith" },
    @{ id = "550e8400-e29b-41d4-a716-446655440004"; name = "Premium Customer" },
    @{ id = "550e8400-e29b-41d4-a716-446655440005"; name = "Test User" },
    @{ id = "550e8400-e29b-41d4-a716-446655440006"; name = "Alice Williams" },
    @{ id = "550e8400-e29b-41d4-a716-446655440007"; name = "Bob Johnson" },
    @{ id = "550e8400-e29b-41d4-a716-446655440008"; name = "Charlie Brown" },
    @{ id = "550e8400-e29b-41d4-a716-446655440009"; name = "Diana Prince" },
    @{ id = "550e8400-e29b-41d4-a716-446655440010"; name = "Emma Watson" },
    @{ id = "550e8400-e29b-41d4-a716-446655440011"; name = "Frank Miller" }
)

# Yorum metinleri
$comments = @(
    "Harika bir ürün! Çok memnun kaldım. Kesinlikle tavsiye ederim.",
    "Güzel ürün ama fiyat biraz yüksek. Yine de kaliteli.",
    "Mükemmel! Beklentilerimi aştı. Hızlı teslimat da harika.",
    "İyi bir ürün, beklentilerimi karşıladı. Tavsiye ederim.",
    "Çok kaliteli ve dayanıklı. Uzun süre kullanacağım.",
    "Fiyatına göre çok iyi. Beklediğimden daha iyi çıktı.",
    "Ürün güzel ama kargo biraz geç geldi. Yine de memnunum.",
    "Mükemmel kalite! Kesinlikle tekrar alırım.",
    "İyi bir ürün ama biraz daha ucuz olabilirdi.",
    "Harika! Çok memnun kaldım, herkese tavsiye ederim."
)

# Product ID'lerini al
Write-Host "📦 Product'lar alınıyor..." -ForegroundColor Yellow
try {
    $productsResponse = Invoke-RestMethod -Uri "$gatewayUrl/api/products" -Method Get -ErrorAction Stop
    $products = $productsResponse
    
    if ($products.Count -eq 0) {
        Write-Host "❌ Hiç product bulunamadı!" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "✅ $($products.Count) product bulundu`n" -ForegroundColor Green
} catch {
    Write-Host "❌ Product'lar alınamadı: $_" -ForegroundColor Red
    exit 1
}

# Her product için 3-8 arası review ekle
$totalReviews = 0
$random = New-Object System.Random

foreach ($product in $products) {
    $productId = $product.id
    $reviewCount = $random.Next(3, 9)  # 3-8 arası
    
    Write-Host "📝 $($product.name) için $reviewCount review ekleniyor..." -ForegroundColor Cyan
    
    $usedUserIds = @()
    
    for ($i = 0; $i -lt $reviewCount; $i++) {
        # Rastgele kullanıcı seç (her product için farklı kullanıcılar)
        $availableUsers = $users | Where-Object { $usedUserIds -notcontains $_.id }
        if ($availableUsers.Count -eq 0) {
            $availableUsers = $users
            $usedUserIds = @()
        }
        
        $user = $availableUsers[$random.Next($availableUsers.Count)]
        $usedUserIds += $user.id
        
        # Rastgele rating (çoğunlukla 4-5)
        $rating = if ($random.NextDouble() -lt 0.7) {
            $random.Next(4, 6)  # 70% şans 4-5
        } elseif ($random.NextDouble() -lt 0.9) {
            3  # 20% şans 3
        } else {
            $random.Next(1, 3)  # 10% şans 1-2
        }
        
        # Rastgele yorum
        $comment = $comments[$random.Next($comments.Count)]
        
        # Review oluştur
        $reviewBody = @{
            productId = $productId
            userId = $user.id
            userName = $user.name
            rating = $rating
            comment = $comment
            isApproved = $true
            helpfulCount = $random.Next(0, 10)
        } | ConvertTo-Json
        
        try {
            $response = Invoke-RestMethod -Uri "$gatewayUrl/api/reviews" -Method Post -Body $reviewBody -ContentType "application/json" -ErrorAction Stop
            $totalReviews++
        } catch {
            # Eğer kullanıcı zaten bu ürün için review yaptıysa, devam et
            if ($_.Exception.Response.StatusCode -eq 400) {
                Write-Host "  ⚠️  $($user.name) zaten bu ürün için review yapmış, atlanıyor..." -ForegroundColor Yellow
            } else {
                Write-Host "  ❌ Review eklenemedi: $_" -ForegroundColor Red
            }
        }
    }
}

Write-Host "`n✅ Toplam $totalReviews review eklendi!`n" -ForegroundColor Green

# Rating summary'leri kontrol et
Write-Host "📊 Rating summary'leri kontrol ediliyor...`n" -ForegroundColor Cyan
$sampleProduct = $products[0]
try {
    $summary = Invoke-RestMethod -Uri "$gatewayUrl/api/reviews/product/$($sampleProduct.id)/summary" -Method Get
    Write-Host "Örnek Product: $($sampleProduct.name)" -ForegroundColor Yellow
    Write-Host "  Ortalama Rating: $($summary.averageRating)" -ForegroundColor Green
    Write-Host "  Toplam Review: $($summary.totalReviews)" -ForegroundColor Green
    Write-Host "  5 Yıldız: $($summary.star5Count) | 4 Yıldız: $($summary.star4Count) | 3 Yıldız: $($summary.star3Count)" -ForegroundColor Cyan
} catch {
    Write-Host "⚠️  Rating summary alınamadı: $_" -ForegroundColor Yellow
}

Write-Host "`n🎉 İşlem tamamlandı!`n" -ForegroundColor Green

