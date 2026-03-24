-- Allow multiple purchase links per platform
-- Add unique constraint on (guitar_id, url)

CREATE UNIQUE INDEX IF NOT EXISTS idx_purchase_links_guitar_url 
ON purchase_links(guitar_id, url);
