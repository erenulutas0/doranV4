-- Review Service - Insert Test Reviews
-- Migration: V2__Insert_test_reviews.sql
-- Description: Inserts test reviews for existing products
-- 
-- NOT: Bu migration product-service'deki product'lar eklendikten SONRA çalıştırılmalıdır.
-- Product ID'leri product-service'den alınacak, bu yüzden bu migration manuel olarak
-- veya bir script ile çalıştırılabilir. Alternatif olarak, review-service başladıktan
-- sonra API üzerinden test review'ları eklenebilir.
--
-- Bu migration şu anda boş bırakılmıştır çünkü cross-database sorgusu yapılamaz.
-- Review'ları eklemek için:
-- 1. Product-service'den product ID'lerini alın
-- 2. Bu migration'ı güncelleyin veya
-- 3. API üzerinden review'ları ekleyin

-- Test kullanıcı ID'leri (user-service'den)
-- Bu ID'ler user-service migration'ındaki ID'lerle eşleşmeli
-- 
-- NOT: Bu migration şu anda çalıştırılmıyor çünkü product ID'leri review_db'de yok.
-- Review'ları eklemek için product-service'den product ID'lerini alıp buraya ekleyin
-- veya API üzerinden ekleyin.

-- Örnek review ekleme (product ID'leri gerçek ID'lerle değiştirilmeli):
-- INSERT INTO reviews (id, product_id, user_id, user_name, rating, comment, is_approved, helpful_count, created_at, updated_at)
-- VALUES
--     (gen_random_uuid(), 'PRODUCT_ID_1', '550e8400-e29b-41d4-a716-446655440002', 'John Doe', 5, 'Harika bir ürün! Çok memnun kaldım.', true, 5, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
--     (gen_random_uuid(), 'PRODUCT_ID_1', '550e8400-e29b-41d4-a716-446655440003', 'Jane Smith', 4, 'Güzel ürün ama fiyat biraz yüksek.', true, 3, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Migration şu anda boş - review'lar API üzerinden veya manuel script ile eklenecek

