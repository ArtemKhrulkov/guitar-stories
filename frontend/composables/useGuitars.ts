import type { Guitar, GuitarFilters, PaginatedResponse, Player, PurchaseLink } from '~/types';

interface GuitarDetailResponse {
  guitar: Guitar;
  players: Player[];
  purchase_links: PurchaseLink[];
}

export const useGuitars = () => {
  const config = useRuntimeConfig();
  const apiUrl = config.public.apiUrl;

  const guitars = ref<Guitar[]>([]);
  const currentGuitar = ref<Guitar | null>(null);
  const total = ref(0);
  const loading = ref(false);
  const error = ref<string | null>(null);

  const fetchGuitars = async (filters: GuitarFilters = {}) => {
    loading.value = true;
    error.value = null;

    try {
      const queryParams = new URLSearchParams();

      if (filters.brand) queryParams.set('brand', filters.brand);
      if (filters.type) queryParams.set('type', filters.type);
      if (filters.search) queryParams.set('search', filters.search);
      if (filters.page) queryParams.set('page', filters.page.toString());
      if (filters.limit) queryParams.set('limit', filters.limit.toString());

      const response = await $fetch<PaginatedResponse<Guitar>>(
        `${apiUrl}/guitars?${queryParams.toString()}`,
      );

      guitars.value = response.guitars || [];
      total.value = response.total;
    } catch (e) {
      error.value = e instanceof Error ? e.message : 'Failed to fetch guitars';
      console.error('Error fetching guitars:', e);
    } finally {
      loading.value = false;
    }
  };

  const fetchGuitarById = async (id: string) => {
    loading.value = true;
    error.value = null;

    try {
      const response = await $fetch<GuitarDetailResponse>(`${apiUrl}/guitars/${id}`);
      currentGuitar.value = response.guitar;
      return response;
    } catch (e) {
      error.value = e instanceof Error ? e.message : 'Failed to fetch guitar';
      console.error('Error fetching guitar:', e);
      return null;
    } finally {
      loading.value = false;
    }
  };

  return {
    guitars,
    currentGuitar,
    total,
    loading,
    error,
    fetchGuitars,
    fetchGuitarById,
  };
};
