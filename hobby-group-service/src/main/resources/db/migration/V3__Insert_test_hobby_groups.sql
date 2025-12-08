-- Hobby Group Service - Test Hobby Groups
-- Migration: V3__Insert_test_hobby_groups.sql
-- Description: Inserts test hobby groups with realistic data and location coordinates

-- Test user IDs from user-service (creators)

INSERT INTO hobby_groups (id, creator_id, name, description, category, location, latitude, longitude, tags, rules, member_count, max_members, status, is_active, created_at, updated_at)
VALUES
    -- Sports Groups
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '550e8400-e29b-41d4-a716-446655440001', 'Ankara Futbol Kulübü', 'Ankara''da düzenli futbol maçları yapan amatör futbol kulübü. Hafta sonları maçlar düzenliyoruz.', 'Sports', 'Ankara, Turkey', 39.9334, 32.8597, '["football", "sports", "ankara"]', 'Düzenli katılım beklenir. Fair play önemlidir.', 15, 22, 'ACTIVE', true, CURRENT_TIMESTAMP - INTERVAL '10 days', CURRENT_TIMESTAMP),
    
    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '550e8400-e29b-41d4-a716-446655440002', 'İstanbul Koşu Grubu', 'İstanbul''da sabah koşuları yapan aktif grup. Her hafta sonu farklı parkurlarda koşuyoruz.', 'Sports', 'Istanbul, Turkey', 41.0082, 28.9784, '["running", "fitness", "istanbul"]', 'Uygun kıyafet ve su getirin.', 25, 30, 'ACTIVE', true, CURRENT_TIMESTAMP - INTERVAL '8 days', CURRENT_TIMESTAMP),
    
    -- Arts Groups
    ('cccccccc-cccc-cccc-cccc-cccccccccccc', '550e8400-e29b-41d4-a716-446655440003', 'Ankara Resim Atölyesi', 'Resim yapmayı sevenler için haftalık atölye çalışmaları. Farklı teknikler öğreniyoruz.', 'Arts', 'Ankara, Turkey', 39.9208, 32.8541, '["painting", "art", "workshop"]', 'Malzemeler paylaşılır. Yeni başlayanlar da katılabilir.', 12, 20, 'ACTIVE', true, CURRENT_TIMESTAMP - INTERVAL '6 days', CURRENT_TIMESTAMP),
    
    -- Music Groups
    ('dddddddd-dddd-dddd-dddd-dddddddddddd', '550e8400-e29b-41d4-a716-446655440004', 'İstanbul Müzik Grubu', 'Enstrüman çalan ve müzik yapmayı sevenler için jam session''lar düzenliyoruz.', 'Music', 'Istanbul, Turkey', 41.0122, 28.9759, '["music", "jam", "instruments"]', 'Kendi enstrümanınızı getirin.', 18, 25, 'ACTIVE', true, CURRENT_TIMESTAMP - INTERVAL '5 days', CURRENT_TIMESTAMP),
    
    -- Photography Groups
    ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', '550e8400-e29b-41d4-a716-446655440005', 'Doğa Fotoğrafçılığı Ankara', 'Doğa ve şehir fotoğrafçılığı yapanlar için bir grup. Haftalık geziler düzenliyoruz.', 'Photography', 'Ankara, Turkey', 39.9334, 32.8597, '["photography", "nature", "city"]', 'DSLR veya telefon kamerası yeterli.', 20, 30, 'ACTIVE', true, CURRENT_TIMESTAMP - INTERVAL '4 days', CURRENT_TIMESTAMP),
    
    -- Gaming Groups
    ('ffffffff-ffff-ffff-ffff-ffffffffffff', '550e8400-e29b-41d4-a716-446655440006', 'İstanbul Oyun Kulübü', 'Bilgisayar ve konsol oyunları oynayanlar için toplanma grubu. Turnuvalar düzenliyoruz.', 'Gaming', 'Istanbul, Turkey', 41.0151, 28.9795, '["gaming", "esports", "tournament"]', 'Fair play ve saygı önemlidir.', 30, 40, 'ACTIVE', true, CURRENT_TIMESTAMP - INTERVAL '3 days', CURRENT_TIMESTAMP),
    
    -- Reading Groups
    ('11111111-1111-1111-1111-111111111111', '550e8400-e29b-41d4-a716-446655440007', 'Ankara Kitap Kulübü', 'Aylık kitap okuma ve tartışma grubu. Her ay farklı bir kitap seçiyoruz.', 'Reading', 'Ankara, Turkey', 39.9208, 32.8541, '["books", "reading", "discussion"]', 'Kitabı okumadan toplantıya gelmeyin.', 10, 15, 'ACTIVE', true, CURRENT_TIMESTAMP - INTERVAL '2 days', CURRENT_TIMESTAMP),
    
    -- Cooking Groups
    ('22222222-2222-2222-2222-222222222222', '550e8400-e29b-41d4-a716-446655440008', 'İzmir Yemek Atölyesi', 'Farklı mutfaklardan yemekler yapmayı öğreniyoruz. Haftalık atölye çalışmaları.', 'Cooking', 'Izmir, Turkey', 38.4237, 27.1428, '["cooking", "food", "workshop"]', 'Malzemeler paylaşılır. Vejetaryen seçenekler mevcut.', 14, 18, 'ACTIVE', true, CURRENT_TIMESTAMP - INTERVAL '1 day', CURRENT_TIMESTAMP)
ON CONFLICT (id) DO UPDATE SET
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude,
    updated_at = EXCLUDED.updated_at;

