-- Product Service - Test Data
-- Migration: V2__Insert_test_products.sql
-- Description: Inserts sample products for testing

INSERT INTO products (id, name, description, price, category, stock_quantity, sku, brand, image_url, is_active, created_at, updated_at)
VALUES
    -- Electronics
    (gen_random_uuid(), 'iPhone 15 Pro', 'Latest iPhone with A17 Pro chip, 48MP camera, and titanium design', 999.99, 'Electronics', 50, 'IPH15PRO-128', 'Apple', 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'Samsung Galaxy S24', 'Flagship Android phone with AI features and 200MP camera', 899.99, 'Electronics', 30, 'SGS24-256', 'Samsung', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'MacBook Pro 16"', 'M3 Max chip, 16-inch display, perfect for professionals', 2499.99, 'Electronics', 15, 'MBP16-M3', 'Apple', 'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=400', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'Sony WH-1000XM5', 'Industry-leading noise canceling wireless headphones', 399.99, 'Electronics', 75, 'SONY-WH1000', 'Sony', 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    
    -- Clothing
    (gen_random_uuid(), 'Classic White T-Shirt', '100% cotton, comfortable fit, perfect for everyday wear', 29.99, 'Clothing', 200, 'TSHIRT-WHITE', 'BasicWear', 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'Denim Jacket', 'Classic blue denim jacket, timeless style', 79.99, 'Clothing', 45, 'JACKET-DENIM', 'DenimCo', 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=400', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'Running Shoes', 'Lightweight running shoes with cushioned sole', 89.99, 'Clothing', 120, 'SHOE-RUN-001', 'SportMax', 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    
    -- Home & Garden
    (gen_random_uuid(), 'Smart LED Bulbs (Pack of 4)', 'WiFi enabled, color changing, voice control compatible', 49.99, 'Home & Garden', 80, 'LED-SMART-4', 'SmartHome', 'https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?w=400', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'Indoor Plant Set', 'Set of 3 easy-care houseplants with decorative pots', 39.99, 'Home & Garden', 60, 'PLANT-SET-3', 'GreenLife', 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=400', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    
    -- Sports
    (gen_random_uuid(), 'Yoga Mat Premium', 'Non-slip, eco-friendly, extra thick for comfort', 34.99, 'Sports', 90, 'YOGA-MAT-PRO', 'FitLife', 'https://images.unsplash.com/photo-1601925260368-ae2f83d5ab7f?w=400', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'Dumbbell Set 20kg', 'Adjustable weight dumbbells, perfect for home gym', 149.99, 'Sports', 25, 'DUMB-20KG', 'PowerFit', 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    
    -- Books
    (gen_random_uuid(), 'The Art of Clean Code', 'Best practices for writing maintainable code', 39.99, 'Books', 150, 'BOOK-CLEAN-CODE', 'TechBooks', 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'Design Patterns Guide', 'Comprehensive guide to software design patterns', 49.99, 'Books', 100, 'BOOK-PATTERNS', 'TechBooks', 'https://images.unsplash.com/photo-1532012197267-da84d127e765?w=400', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    
    -- Toys
    (gen_random_uuid(), 'LEGO Architecture Set', 'Build famous landmarks with this detailed set', 79.99, 'Toys', 40, 'LEGO-ARCH-001', 'LEGO', 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'Remote Control Drone', '4K camera, GPS, 30-minute flight time', 199.99, 'Toys', 20, 'DRONE-RC-4K', 'FlyTech', 'https://images.unsplash.com/photo-1473968512647-3e447244af8f?w=400', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT (id) DO NOTHING;

