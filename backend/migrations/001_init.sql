-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create custom enum types
DO $$ BEGIN
    CREATE TYPE guitar_type AS ENUM ('electric', 'acoustic', 'bass');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE platform AS ENUM ('ozon', 'wildberries', 'sweetwater', 'guitarcenter');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Brands table
CREATE TABLE IF NOT EXISTS brands (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL UNIQUE,
    country VARCHAR(100) NOT NULL,
    founded_year INTEGER,
    description TEXT,
    logo_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Guitars table
CREATE TABLE IF NOT EXISTS guitars (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
    model VARCHAR(255) NOT NULL,
    guitar_type VARCHAR(50) NOT NULL,
    price_range VARCHAR(100),
    specifications JSONB,
    history TEXT,
    image_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Players table
CREATE TABLE IF NOT EXISTS players (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    genre VARCHAR(100),
    bio TEXT,
    image_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Guitar-Players junction table
CREATE TABLE IF NOT EXISTS guitar_players (
    guitar_id UUID NOT NULL REFERENCES guitars(id) ON DELETE CASCADE,
    player_id UUID NOT NULL REFERENCES players(id) ON DELETE CASCADE,
    note TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (guitar_id, player_id)
);

-- Purchase links table
CREATE TABLE IF NOT EXISTS purchase_links (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    guitar_id UUID NOT NULL REFERENCES guitars(id) ON DELETE CASCADE,
    platform VARCHAR(50) NOT NULL,
    url VARCHAR(500) NOT NULL,
    price_rub DECIMAL(10,2),
    price_usd DECIMAL(10,2),
    in_stock BOOLEAN DEFAULT true,
    last_scraped TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_guitars_brand_id ON guitars(brand_id);
CREATE INDEX IF NOT EXISTS idx_guitars_type ON guitars(guitar_type);
CREATE INDEX IF NOT EXISTS idx_guitars_created_at ON guitars(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_purchase_links_guitar_id ON purchase_links(guitar_id);
CREATE INDEX IF NOT EXISTS idx_guitar_players_guitar_id ON guitar_players(guitar_id);
CREATE INDEX IF NOT EXISTS idx_guitar_players_player_id ON guitar_players(player_id);

-- GIN index for JSONB specifications search
CREATE INDEX IF NOT EXISTS idx_guitars_specifications ON guitars USING GIN (specifications);

-- Full-text search index
CREATE INDEX IF NOT EXISTS idx_guitars_model_search ON guitars USING GIN (to_tsvector('russian', model));
CREATE INDEX IF NOT EXISTS idx_guitars_history_search ON guitars USING GIN (to_tsvector('russian', history));
