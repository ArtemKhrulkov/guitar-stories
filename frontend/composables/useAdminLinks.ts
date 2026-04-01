import type { Specifications } from '~/types';

export interface LinkInput {
  guitar_id: string;
  platform: 'ozon' | 'wildberries' | 'sweetwater' | 'guitarcenter';
  url: string;
  price_rub?: number;
  price_usd?: number;
  in_stock?: boolean;
}

export interface PurchaseLink {
  id: string;
  guitar_id: string;
  platform: string;
  url: string;
  price_rub?: number;
  price_usd?: number;
  in_stock: boolean;
  created_at: string;
  updated_at: string;
}

export interface Guitar {
  id: string;
  brand_id: string;
  model: string;
  guitar_type: string;
  price_range?: string;
  image_url?: string;
  history?: string;
  specifications?: Specifications;
  brand?: {
    id: string;
    name: string;
  };
}

export interface GuitarUpdate {
  model?: string;
  image_url?: string;
  guitar_type?: 'electric' | 'acoustic' | 'bass';
  price_range?: string;
  history?: string;
  specifications?: Specifications;
}

export interface GuitarCreate {
  brand_id: string;
  model: string;
  guitar_type: 'electric' | 'acoustic' | 'bass';
  price_range?: string;
  image_url?: string;
  history?: string;
  specifications?: Specifications;
}

export interface LinkUpdate {
  link_id: string;
  url?: string;
  price_rub?: number;
  price_usd?: number;
  in_stock?: boolean;
}

export interface Brand {
  id: string;
  name: string;
  country: string;
}

interface AdminLinksState {
  guitars: Ref<Guitar[]>;
  isLoading: Ref<boolean>;
  searchGuitars(query: string): Promise<void>;
  addLink(input: LinkInput): Promise<PurchaseLink>;
  updateLink(id: string, data: LinkUpdate): Promise<PurchaseLink>;
  deleteLink(linkId: string): Promise<void>;
  deleteGuitar(id: string): Promise<void>;
  updateGuitar(id: string, data: GuitarUpdate): Promise<Guitar>;
  createGuitar(data: GuitarCreate): Promise<Guitar>;
  getBrands(): Promise<Brand[]>;
}

export const useAdminLinks = (): AdminLinksState => {
  const config = useRuntimeConfig();
  const API_BASE = config.public.apiUrl;

  const guitars = useState<Guitar[]>('admin-guitars', () => []);
  const isLoading = useState<boolean>('admin-links-loading', () => false);

  const searchGuitars = async (query: string): Promise<void> => {
    if (!query || query.length < 2) {
      guitars.value = [];
      return;
    }
    isLoading.value = true;
    try {
      const response = await $fetch<{ guitars: Guitar[] }>(
        `${API_BASE}/guitars?search=${encodeURIComponent(query)}&limit=20`,
        {
          credentials: 'include',
        },
      );
      guitars.value = response.guitars;
    } catch (error) {
      console.error('Failed to search guitars:', error);
      guitars.value = [];
    } finally {
      isLoading.value = false;
    }
  };

  const addLink = async (input: LinkInput): Promise<PurchaseLink> => {
    const response = await $fetch<{ link: PurchaseLink }>(`${API_BASE}/admin/links`, {
      method: 'POST',
      credentials: 'include',
      body: input,
    });
    return response.link;
  };

  const deleteLink = async (linkId: string): Promise<void> => {
    await $fetch(`${API_BASE}/admin/links`, {
      method: 'DELETE',
      credentials: 'include',
      body: { link_id: linkId },
    });
  };

  const deleteGuitar = async (id: string): Promise<void> => {
    await $fetch(`${API_BASE}/admin/guitars/${id}`, {
      method: 'DELETE',
      credentials: 'include',
    });
  };

  const updateLink = async (id: string, data: Omit<LinkUpdate, 'link_id'>): Promise<PurchaseLink> => {
    const response = await $fetch<{ link: PurchaseLink }>(`${API_BASE}/admin/links`, {
      method: 'PATCH',
      credentials: 'include',
      body: { link_id: id, ...data },
    });
    return response.link;
  };

  const updateGuitar = async (id: string, data: GuitarUpdate): Promise<Guitar> => {
    const response = await $fetch<{ guitar: Guitar }>(`${API_BASE}/admin/guitars/${id}`, {
      method: 'PATCH',
      credentials: 'include',
      body: data,
    });
    return response.guitar;
  };

  const createGuitar = async (data: GuitarCreate): Promise<Guitar> => {
    const response = await $fetch<{ guitar: Guitar }>(`${API_BASE}/admin/guitars`, {
      method: 'POST',
      credentials: 'include',
      body: data,
    });
    return response.guitar;
  };

  const getBrands = async (): Promise<Brand[]> => {
    const response = await $fetch<{ brands: Brand[] }>(`${API_BASE}/brands`, {
      credentials: 'include',
    });
    return response.brands;
  };

  return {
    guitars,
    isLoading,
    searchGuitars,
    addLink,
    updateLink,
    deleteLink,
    deleteGuitar,
    updateGuitar,
    createGuitar,
    getBrands,
  };
};
