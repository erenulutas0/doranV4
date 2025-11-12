-- ============================================
-- PostgreSQL Database Creation Script
-- Microservices için veritabanları oluşturur
-- ============================================
-- 
-- pgAdmin'de kullanım:
-- 1. PostgreSQL 17 server'ına SAĞ TIKLAYIN (veritabanına değil!)
-- 2. "Query Tool" seçin
-- 3. Bu script'i yapıştırın ve çalıştırın (F5)
-- 4. pgAdmin'de "Databases" üzerine sağ tıklayıp "Refresh" yapın
-- 
-- ============================================

-- Veritabanları oluştur (eğer yoksa)
DO $$
BEGIN
    -- User Service Database
    IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'user_db') THEN
        CREATE DATABASE user_db
            WITH 
            OWNER = postgres
            ENCODING = 'UTF8'
            TABLESPACE = pg_default
            CONNECTION LIMIT = -1;
        COMMENT ON DATABASE user_db IS 'User Service için veritabanı - Kullanıcı yönetimi';
    END IF;

    -- Product Service Database
    IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'product_db') THEN
        CREATE DATABASE product_db
            WITH 
            OWNER = postgres
            ENCODING = 'UTF8'
            TABLESPACE = pg_default
            CONNECTION LIMIT = -1;
        COMMENT ON DATABASE product_db IS 'Product Service için veritabanı - Ürün yönetimi';
    END IF;

    -- Order Service Database
    IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'order_db') THEN
        CREATE DATABASE order_db
            WITH 
            OWNER = postgres
            ENCODING = 'UTF8'
            TABLESPACE = pg_default
            CONNECTION LIMIT = -1;
        COMMENT ON DATABASE order_db IS 'Order Service için veritabanı - Sipariş yönetimi';
    END IF;

    -- Inventory Service Database
    IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'inventory_db') THEN
        CREATE DATABASE inventory_db
            WITH 
            OWNER = postgres
            ENCODING = 'UTF8'
            TABLESPACE = pg_default
            CONNECTION LIMIT = -1;
        COMMENT ON DATABASE inventory_db IS 'Inventory Service için veritabanı - Stok yönetimi';
    END IF;

    -- Notification Service Database
    IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'notification_db') THEN
        CREATE DATABASE notification_db
            WITH 
            OWNER = postgres
            ENCODING = 'UTF8'
            TABLESPACE = pg_default
            CONNECTION LIMIT = -1;
        COMMENT ON DATABASE notification_db IS 'Notification Service için veritabanı - Bildirim yönetimi';
    END IF;

    -- Review Service Database
    IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'review_db') THEN
        CREATE DATABASE review_db
            WITH 
            OWNER = postgres
            ENCODING = 'UTF8'
            TABLESPACE = pg_default
            CONNECTION LIMIT = -1;
        COMMENT ON DATABASE review_db IS 'Review Service için veritabanı - Ürün yorumları ve değerlendirmeleri';
    END IF;
END $$;

-- Veritabanlarını listele
SELECT datname, pg_size_pretty(pg_database_size(datname)) as size 
FROM pg_database 
WHERE datname IN ('user_db', 'product_db', 'order_db', 'inventory_db', 'notification_db', 'review_db') 
ORDER BY datname;

