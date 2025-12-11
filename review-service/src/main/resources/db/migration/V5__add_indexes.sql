-- Performance index for fetching reviews per product ordered by recency
CREATE INDEX IF NOT EXISTS idx_reviews_product_created_at
  ON reviews (product_id, created_at);





