-- Optimize rating summary counts by rating
CREATE INDEX IF NOT EXISTS idx_reviews_product_rating ON reviews (product_id, rating);

