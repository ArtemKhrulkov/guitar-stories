-- Price history table for tracking price changes over time

CREATE TABLE IF NOT EXISTS price_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    purchase_link_id UUID NOT NULL REFERENCES purchase_links(id) ON DELETE CASCADE,
    price_rub DECIMAL(10,2),
    price_usd DECIMAL(10,2),
    recorded_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_price_history_link_id ON price_history(purchase_link_id);
CREATE INDEX IF NOT EXISTS idx_price_history_recorded_at ON price_history(recorded_at DESC);
