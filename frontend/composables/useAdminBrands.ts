import type { Brand as BrandType } from '~/types';

export interface BrandInput {
  name: string;
  country: string;
  founded_year?: number;
  description?: string;
  logo_url?: string;
}

export interface BrandUpdate {
  name?: string;
  country?: string;
  founded_year?: number;
  description?: string;
  logo_url?: string;
}

interface AdminBrandsState {
  brands: Ref<BrandType[]>;
  isLoading: Ref<boolean>;
  fetchBrands(): Promise<BrandType[]>;
  createBrand(data: BrandInput): Promise<BrandType>;
  updateBrand(id: string, data: BrandUpdate): Promise<BrandType>;
  deleteBrand(id: string): Promise<void>;
}

export const useAdminBrands = (): AdminBrandsState => {
  const config = useRuntimeConfig();
  const API_BASE = config.public.apiUrl;

  const brands = useState<BrandType[]>('admin-brands', () => []);
  const isLoading = useState<boolean>('admin-brands-loading', () => false);

  const fetchBrands = async (): Promise<BrandType[]> => {
    isLoading.value = true;
    try {
      const response = await $fetch<{ brands: BrandType[] }>(`${API_BASE}/brands`, {
        credentials: 'include',
      });
      brands.value = response.brands;
      return response.brands;
    } catch (error) {
      console.error('Failed to fetch brands:', error);
      return [];
    } finally {
      isLoading.value = false;
    }
  };

  const createBrand = async (data: BrandInput): Promise<BrandType> => {
    const response = await $fetch<{ brand: BrandType }>(`${API_BASE}/admin/brands`, {
      method: 'POST',
      credentials: 'include',
      body: data,
    });
    return response.brand;
  };

  const updateBrand = async (id: string, data: BrandUpdate): Promise<BrandType> => {
    const response = await $fetch<{ brand: BrandType }>(`${API_BASE}/admin/brands/${id}`, {
      method: 'PATCH',
      credentials: 'include',
      body: data,
    });
    return response.brand;
  };

  const deleteBrand = async (id: string): Promise<void> => {
    await $fetch(`${API_BASE}/admin/brands/${id}`, {
      method: 'DELETE',
      credentials: 'include',
    });
  };

  return {
    brands,
    isLoading,
    fetchBrands,
    createBrand,
    updateBrand,
    deleteBrand,
  };
};
