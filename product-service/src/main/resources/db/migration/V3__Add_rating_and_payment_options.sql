-- Product Service - Add Rating Columns and Payment Options Table
-- Migration: V3__Add_rating_and_payment_options.sql
-- Description: Adds rating columns to products table and creates payment_options table

-- Add rating columns to products table (cached from review-service)
ALTER TABLE products 
ADD COLUMN IF NOT EXISTS average_rating DECIMAL(3,1) DEFAULT 0.0 CHECK (average_rating >= 0.0 AND average_rating <= 5.0),
ADD COLUMN IF NOT EXISTS review_count INTEGER DEFAULT 0 CHECK (review_count >= 0),
ADD COLUMN IF NOT EXISTS last_rating_sync TIMESTAMP;

-- Create payment_options table
CREATE TABLE IF NOT EXISTS product_payment_options (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID NOT NULL,
    payment_type VARCHAR(50) NOT NULL CHECK (payment_type IN ('CREDIT_CARD', 'DEBIT_CARD', 'COD', 'INSTALLMENT')),
    installment_available BOOLEAN DEFAULT FALSE,
    max_installments INTEGER CHECK (max_installments >= 2 AND max_installments <= 12),
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_payment_options_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Indexes for payment_options
CREATE INDEX IF NOT EXISTS idx_payment_options_product_id ON product_payment_options(product_id);
CREATE INDEX IF NOT EXISTS idx_payment_options_payment_type ON product_payment_options(payment_type);
CREATE INDEX IF NOT EXISTS idx_payment_options_available ON product_payment_options(is_available);

-- Unique constraint: Bir ürün için aynı payment_type sadece bir kez olabilir
CREATE UNIQUE INDEX IF NOT EXISTS idx_payment_options_product_type_unique ON product_payment_options(product_id, payment_type);

