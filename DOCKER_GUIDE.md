# 🐳 Docker & Docker Compose Kılavuzu

## 📋 Genel Bakış

Bu proje Docker ve Docker Compose ile containerize edilmiştir. Tüm microservice'ler, veritabanları ve bağımlılıklar tek komutla başlatılabilir.

---

## 🚀 Hızlı Başlangıç

### 1. Tüm Servisleri Başlatma

```bash
docker-compose up -d
```

Bu komut şunları başlatır:
- ✅ PostgreSQL (5 database ile)
- ✅ RabbitMQ
- ✅ Redis
- ✅ Zipkin
- ✅ Service Registry (Eureka)
- ✅ Config Server
- ✅ User Service
- ✅ Product Service
- ✅ Order Service
- ✅ Inventory Service
- ✅ Notification Service
- ✅ API Gateway

### 2. Servisleri Durdurma

```bash
docker-compose down
```

### 3. Servisleri Durdurma ve Volume'ları Silme

```bash
docker-compose down -v
```

---

## 📦 Container'lar

### Infrastructure Services

| Service | Container Name | Port | URL |
|---------|---------------|------|-----|
| PostgreSQL | postgres | 5432 | `localhost:5432` |
| RabbitMQ | rabbitmq | 5672, 15672 | `http://localhost:15672` |
| Redis | redis | 6379 | `localhost:6379` |
| Zipkin | zipkin | 9411 | `http://localhost:9411` |

### Microservices

| Service | Container Name | Port | URL |
|---------|---------------|------|-----|
| Service Registry | service-registry | 8761 | `http://localhost:8761` |
| Config Server | config-server | 8888 | `http://localhost:8888` |
| API Gateway | api-gateway | 8080 | `http://localhost:8080` |
| User Service | user-service | 8081 | `http://localhost:8081` |
| Product Service | product-service | 8082 | `http://localhost:8082` |
| Order Service | order-service | 8083 | `http://localhost:8083` |
| Inventory Service | inventory-service | 8084 | `http://localhost:8084` |
| Notification Service | notification-service | 8085 | `http://localhost:8085` |

---

## 🔧 Komutlar

### Container Durumunu Kontrol Etme

```bash
docker-compose ps
```

### Logları Görüntüleme

```bash
# Tüm servislerin logları
docker-compose logs -f

# Belirli bir servisin logları
docker-compose logs -f user-service
```

### Container'ı Yeniden Başlatma

```bash
docker-compose restart user-service
```

### Container'ı Rebuild Etme

```bash
# Belirli bir servisi rebuild et
docker-compose build user-service

# Tüm servisleri rebuild et
docker-compose build
```

### Container'a Bağlanma

```bash
docker exec -it user-service sh
```

---

## 🏗️ Build İşlemi

### İlk Build

İlk kez çalıştırdığınızda, Docker image'ları build edilecektir:

```bash
docker-compose up -d --build
```

### Sadece Build (Çalıştırmadan)

```bash
docker-compose build
```

---

## 🌐 Network

Tüm servisler `microservices-network` adlı bir Docker network'ünde çalışır. Bu sayede:

- Servisler birbirlerine container name ile erişebilir (örn: `http://postgres:5432`)
- Port çakışması olmaz
- İzolasyon sağlanır

---

## 💾 Volumes

### PostgreSQL Data

PostgreSQL verileri `postgres_data` volume'unda saklanır. Container silinse bile veriler korunur.

Volume'u silmek için:
```bash
docker-compose down -v
```

---

## 🔍 Troubleshooting

### Port Zaten Kullanımda

Eğer bir port zaten kullanımdaysa:

1. Port'u kullanan process'i bulun:
   ```bash
   # Windows
   netstat -ano | findstr :8080
   
   # Linux/Mac
   lsof -i :8080
   ```

2. Process'i durdurun veya `docker-compose.yml`'de port'u değiştirin

### Container Başlamıyor

1. Logları kontrol edin:
   ```bash
   docker-compose logs service-name
   ```

2. Health check'i kontrol edin:
   ```bash
   docker-compose ps
   ```

3. Container'ı yeniden başlatın:
   ```bash
   docker-compose restart service-name
   ```

### Database Bağlantı Hatası

1. PostgreSQL'in hazır olduğundan emin olun:
   ```bash
   docker-compose ps postgres
   ```

2. Database'lerin oluşturulduğunu kontrol edin:
   ```bash
   docker exec -it postgres psql -U postgres -l
   ```

### Config Server Hatası

Config Server, local file system'den config okur. Volume mount'un doğru olduğundan emin olun:

```yaml
volumes:
  - C:/Users/pc/config-repo:/config-repo
```

**Not:** Windows'ta path formatı `C:/Users/pc/config-repo` şeklinde olmalıdır.

---

## 📊 Monitoring

### Container Resource Kullanımı

```bash
docker stats
```

### Health Check Durumu

```bash
docker-compose ps
```

Health check'ler her container için tanımlanmıştır. `healthy` durumunda olmalıdırlar.

---

## 🎯 Production İçin Notlar

1. **Environment Variables**: Production'da environment variable'ları `.env` dosyasından veya secret management'tan alın

2. **Resource Limits**: Production'da resource limit'leri ekleyin:
   ```yaml
   deploy:
     resources:
       limits:
         cpus: '0.5'
         memory: 512M
   ```

3. **Health Checks**: Tüm servislerde health check'ler tanımlıdır

4. **Logging**: Production'da logging driver kullanın:
   ```yaml
   logging:
     driver: "json-file"
     options:
       max-size: "10m"
       max-file: "3"
   ```

---

## 📚 Kaynaklar

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Spring Boot Docker Guide](https://spring.io/guides/gs/spring-boot-docker/)

---

## ✅ Avantajlar

- ✅ Tek komutla tüm sistem başlatılır
- ✅ Environment isolation
- ✅ Port çakışması yok
- ✅ Dependency management otomatik
- ✅ Production'a geçiş hazır
- ✅ Team collaboration kolaylaşır

