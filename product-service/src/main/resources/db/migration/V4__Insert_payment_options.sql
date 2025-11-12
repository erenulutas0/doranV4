-- Product Service - Insert Payment Options for Products
-- Migration: V4__Insert_payment_options.sql
-- Description: Inserts payment options for all existing products

-- Tüm ürünlere standart ödeme seçenekleri ekle
INSERT INTO product_payment_options (product_id, payment_type, installment_available, max_installments, is_available, created_at, updated_at)
SELECT 
    id as product_id,
    'CREDIT_CARD' as payment_type,
    true as installment_available,
    12 as max_installments,
    true as is_available,
    CURRENT_TIMESTAMP as created_at,
    CURRENT_TIMESTAMP as updated_at
FROM products
ON CONFLICT (product_id, payment_type) DO NOTHING;

INSERT INTO product_payment_options (product_id, payment_type, installment_available, max_installments, is_available, created_at, updated_at)
SELECT 
    id as product_id,
    'DEBIT_CARD' as payment_type,
    false as installment_available,
    NULL as max_installments,
    true as is_available,
    CURRENT_TIMESTAMP as created_at,
    CURRENT_TIMESTAMP as updated_at
FROM products
ON CONFLICT (product_id, payment_type) DO NOTHING;

INSERT INTO product_payment_options (product_id, payment_type, installment_available, max_installments, is_available, created_at, updated_at)
SELECT 
    id as product_id,
    'COD' as payment_type,
    false as installment_available,
    NULL as max_installments,
    true as is_available,
    CURRENT_TIMESTAMP as created_at,
    CURRENT_TIMESTAMP as updated_at
FROM products
ON CONFLICT (product_id, payment_type) DO NOTHING;

INSERT INTO product_payment_options (product_id, payment_type, installment_available, max_installments, is_available, created_at, updated_at)
SELECT 
    id as product_id,
    'INSTALLMENT' as payment_type,
    true as installment_available,
    12 as max_installments,
    true as is_available,
    CURRENT_TIMESTAMP as created_at,
    CURRENT_TIMESTAMP as updated_at
FROM products
ON CONFLICT (product_id, payment_type) DO NOTHING;

