-- Performance indexes for common catalog queries
-- is_active + category + created_at supports listing/filters
CREATE INDEX IF NOT EXISTS idx_products_active_category_created_at
  ON products (is_active, category, created_at);





