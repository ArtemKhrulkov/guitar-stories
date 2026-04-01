import type { Guitar, Player } from '~/types';

export interface SearchResults {
  guitars: Guitar[];
  players: Player[];
}

export const useSearch = () => {
  const config = useRuntimeConfig();
  const apiUrl = config.public.apiUrl;

  const results = ref<SearchResults>({ guitars: [], players: [] });
  const loading = ref(false);
  const error = ref<string | null>(null);

  const search = async (query: string) => {
    if (!query.trim()) {
      results.value = { guitars: [], players: [] };
      return;
    }

    loading.value = true;
    error.value = null;

    try {
      const response = await $fetch<SearchResults>(
        `${apiUrl}/search?q=${encodeURIComponent(query)}`,
      );
      results.value = response;
    } catch (e) {
      error.value = e instanceof Error ? e.message : 'Search failed';
      console.error('Error searching:', e);
    } finally {
      loading.value = false;
    }
  };

  const clearResults = () => {
    results.value = { guitars: [], players: [] };
  };

  return {
    results,
    loading,
    error,
    search,
    clearResults,
  };
};
