const STORAGE_KEY = 'guest-wishlist';

interface WishlistState {
  guitarIds: Ref<string[]>;
  isLoading: Ref<boolean>;
  isAuthenticated: Ref<boolean>;
  fetchWishlist(): Promise<void>;
  addToWishlist(guitarId: string): Promise<void>;
  removeFromWishlist(guitarId: string): Promise<void>;
  getGuestWishlist(): string[];
  setGuestWishlist(guitarIds: string[]): void;
  mergeGuestWishlist(): Promise<void>;
}

export const useWishlist = (): WishlistState => {
  const config = useRuntimeConfig();
  const API_BASE = config.public.apiUrl;
  const { isAuthenticated } = useAuth();

  const guitarIds = useState<string[]>('wishlist_ids', () => []);
  const isLoading = useState<boolean>('wishlist_loading', () => false);

  const fetchWishlist = async (): Promise<void> => {
    if (!isAuthenticated.value) {
      // Load from localStorage for guests
      guitarIds.value = getGuestWishlist();
      return;
    }

    isLoading.value = true;
    try {
      const response = await $fetch<{ guitar_ids: string[]; count: number }>(
        `${API_BASE}/wishlist`,
        { credentials: 'include' },
      );
      guitarIds.value = response.guitar_ids || [];
    } catch (error) {
      console.error('Failed to fetch wishlist:', error);
      guitarIds.value = [];
    } finally {
      isLoading.value = false;
    }
  };

  const addToWishlist = async (guitarId: string): Promise<void> => {
    if (guitarIds.value.includes(guitarId)) return;

    if (isAuthenticated.value) {
      isLoading.value = true;
      try {
        await $fetch(`${API_BASE}/wishlist`, {
          method: 'POST',
          credentials: 'include',
          body: { guitar_id: guitarId },
        });
        guitarIds.value.push(guitarId);
      } catch (error) {
        console.error('Failed to add to wishlist:', error);
        throw error;
      } finally {
        isLoading.value = false;
      }
    } else {
      // Guest - add to localStorage
      const guestList = getGuestWishlist();
      if (!guestList.includes(guitarId)) {
        guestList.push(guitarId);
        setGuestWishlist(guestList);
        guitarIds.value = guestList;
      }
    }
  };

  const removeFromWishlist = async (guitarId: string): Promise<void> => {
    if (isAuthenticated.value) {
      isLoading.value = true;
      try {
        await $fetch(`${API_BASE}/wishlist/${guitarId}`, {
          method: 'DELETE',
          credentials: 'include',
        });
        guitarIds.value = guitarIds.value.filter((id) => id !== guitarId);
      } catch (error) {
        console.error('Failed to remove from wishlist:', error);
        throw error;
      } finally {
        isLoading.value = false;
      }
    } else {
      // Guest - remove from localStorage
      const guestList = getGuestWishlist().filter((id) => id !== guitarId);
      setGuestWishlist(guestList);
      guitarIds.value = guestList;
    }
  };

  const getGuestWishlist = (): string[] => {
    if (typeof window === 'undefined') return [];
    try {
      const stored = localStorage.getItem(STORAGE_KEY);
      return stored ? JSON.parse(stored) : [];
    } catch {
      return [];
    }
  };

  const setGuestWishlist = (guitarIds: string[]): void => {
    if (typeof window === 'undefined') return;
    try {
      localStorage.setItem(STORAGE_KEY, JSON.stringify(guitarIds));
    } catch {
      console.warn('Failed to save wishlist to localStorage');
    }
  };

  const mergeGuestWishlist = async (): Promise<void> => {
    if (!isAuthenticated.value) return;

    const guestList = getGuestWishlist();
    if (guestList.length === 0) return;

    isLoading.value = true;
    try {
      // Add each guest item to user's wishlist via API
      for (const guitarId of guestList) {
        await $fetch(`${API_BASE}/wishlist`, {
          method: 'POST',
          credentials: 'include',
          body: { guitar_id: guitarId },
        });
      }

      // Clear localStorage and fetch fresh list
      localStorage.removeItem(STORAGE_KEY);
      await fetchWishlist();
    } catch (error) {
      console.error('Failed to merge wishlist:', error);
    } finally {
      isLoading.value = false;
    }
  };

  return {
    guitarIds,
    isLoading,
    isAuthenticated,
    fetchWishlist,
    addToWishlist,
    removeFromWishlist,
    getGuestWishlist,
    setGuestWishlist,
    mergeGuestWishlist,
  };
};