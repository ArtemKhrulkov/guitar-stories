export interface Brand {
  id: string;
  name: string;
  country: string;
  founded_year?: number;
  description?: string;
  logo_url?: string;
  created_at: string;
  updated_at: string;
}

export interface Specifications {
  body_wood?: string;
  neck_wood?: string;
  fretboard?: string;
  pickup_config?: string;
  frets?: number;
  scale_length?: string;
  hardware?: string;
  bridge?: string;
  tuners?: string;
}

export interface Guitar {
  id: string;
  brand_id: string;
  brand?: Brand;
  model: string;
  guitar_type: 'electric' | 'acoustic' | 'bass';
  price_range?: string;
  specifications?: Specifications;
  history?: string;
  image_url?: string;
  created_at: string;
  updated_at: string;
  players?: Player[];
  purchase_links?: PurchaseLink[];
}

export interface Player {
  id: string;
  name: string;
  genre?: string;
  bio?: string;
  image_url?: string;
  created_at: string;
  updated_at: string;
  guitars?: Guitar[];
}

export interface PriceHistory {
  id: string;
  purchase_link_id: string;
  price_rub?: number;
  price_usd?: number;
  recorded_at: string;
}

export interface PurchaseLink {
  id: string;
  guitar_id: string;
  platform: 'ozon' | 'wildberries' | 'sweetwater' | 'guitarcenter';
  url: string;
  price_rub?: number;
  price_usd?: number;
  in_stock: boolean;
  last_scraped?: string;
  created_at: string;
  updated_at: string;
  price_history?: PriceHistory[];
}

export interface GuitarFilters {
  brands?: string[];
  type?: 'electric' | 'acoustic' | 'bass';
  search?: string;
  min_price?: number;
  max_price?: number;
  in_stock?: boolean;
  sort?: 'newest' | 'model' | 'price';
  dir?: 'asc' | 'desc';
  page?: number;
  limit?: number;
}

export interface PaginatedResponse<T> {
  guitars?: T[];
  brands?: T[];
  players?: T[];
  total: number;
  page: number;
  limit: number;
}
