-- Additional index for price sorting/filtering
CREATE INDEX IF NOT EXISTS idx_products_price_created_at ON products (price, created_at);

