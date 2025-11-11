# E-Commerce Flutter Mobile App

Modern, user-friendly ve responsive bir e-ticaret mobil uygulaması. Java microservices backend'i ile entegre çalışır.

## 🎨 Özellikler

### UI/UX Özellikleri
- ✅ Material Design 3 uyumlu modern tasarım
- ✅ Responsive ve adaptive layout
- ✅ Smooth animations ve transitions
- ✅ Dark mode desteği (hazır)
- ✅ Custom theme ve color palette
- ✅ Google Fonts entegrasyonu

### Sayfalar
1. **Splash Screen** - Uygulama başlangıç ekranı
2. **Home Page** - Ürün listesi, kategori filtreleri, banner carousel
3. **Product Detail** - Ürün detay sayfası, görseller, rating
4. **Cart** - Sepet yönetimi, miktar kontrolü
5. **Orders** - Sipariş geçmişi ve takibi
6. **Profile** - Kullanıcı profili ve ayarlar
7. **Auth** - Login ve Register sayfaları

### State Management
- Provider pattern kullanılıyor
- CartProvider - Sepet yönetimi
- ProductProvider - Ürün listesi ve filtreleme
- AuthProvider - Kullanıcı kimlik doğrulama

### API Entegrasyonu
- RESTful API ile backend entegrasyonu
- HTTP client (http package)
- Error handling
- Loading states

## 🚀 Kurulum

### Gereksinimler
- Flutter SDK 3.0.0 veya üzeri
- Dart SDK 3.0.0 veya üzeri
- Android Studio / VS Code
- Backend servislerinin çalışıyor olması (port 8080)

### Adımlar

1. **Bağımlılıkları yükleyin:**
```bash
cd flutter-app
flutter pub get
```

2. **Backend servislerini başlatın:**
```bash
# Ana dizinde
docker-compose up -d
```

3. **API base URL'ini kontrol edin:**
`lib/core/services/api_service.dart` dosyasında base URL'i düzenleyin:
```dart
static const String baseUrl = 'http://localhost:8080/api';
```

4. **Uygulamayı çalıştırın:**
```bash
flutter run
```

## 📱 Ekran Görüntüleri

### Ana Sayfa
- Üst kısımda arama çubuğu
- Banner carousel
- Kategori filtreleri (chips)
- Ürün grid görünümü
- Alt navigasyon bar

### Ürün Detay
- Büyük ürün görseli
- Ürün bilgileri
- Fiyat ve indirim gösterimi
- Rating ve yorumlar
- Sepete ekle butonu

### Sepet
- Ürün listesi
- Miktar kontrolü
- Toplam fiyat
- Checkout butonu

## 🎯 Gelecek Geliştirmeler

- [ ] Push notifications
- [ ] Favoriler (wishlist)
- [ ] Ürün arama
- [ ] Sipariş takibi (real-time)
- [ ] Ödeme entegrasyonu
- [ ] Sosyal medya login
- [ ] Ürün yorumları ve rating
- [ ] Image caching optimizasyonu
- [ ] Offline mode
- [ ] Unit ve widget tests

## 📦 Kullanılan Paketler

- `provider` - State management
- `go_router` - Navigation
- `http` - API calls
- `cached_network_image` - Image caching
- `google_fonts` - Custom fonts
- `intl` - Formatting
- `shared_preferences` - Local storage

## 🔧 Yapılandırma

### API Base URL
Backend servislerinizin çalıştığı URL'i `lib/core/services/api_service.dart` dosyasında güncelleyin.

### Theme
Tema renkleri ve stilleri `lib/core/theme/app_theme.dart` dosyasında özelleştirilebilir.

## 📝 Notlar

- Backend API Gateway'in CORS ayarlarının mobil uygulama için açık olması gerekir
- Android emulator için `10.0.2.2` IP adresini kullanın
- iOS simulator için `localhost` kullanılabilir
- Production için base URL'i güncelleyin

## 🤝 Katkıda Bulunma

1. Fork edin
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Commit edin (`git commit -m 'Add amazing feature'`)
4. Push edin (`git push origin feature/amazing-feature`)
5. Pull Request oluşturun

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır.

