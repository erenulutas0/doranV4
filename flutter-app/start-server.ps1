cd "C:\Users\pc\OneDrive\Masaüstü\java-microservices\flutter-app\build\web"
Write-Host "Sunucu başlatılıyor: $(Get-Location)"
python -m http.server 8086
