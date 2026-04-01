import type { Player as PlayerType } from '~/types';

export interface PlayerInput {
  name: string;
  genre?: string;
  bio?: string;
  image_url?: string;
}

export interface PlayerUpdate {
  name?: string;
  genre?: string;
  bio?: string;
  image_url?: string;
}

interface AdminPlayersState {
  players: Ref<PlayerType[]>;
  isLoading: Ref<boolean>;
  fetchPlayers(): Promise<PlayerType[]>;
  createPlayer(data: PlayerInput): Promise<PlayerType>;
  updatePlayer(id: string, data: PlayerUpdate): Promise<PlayerType>;
  deletePlayer(id: string): Promise<void>;
}

export const useAdminPlayers = (): AdminPlayersState => {
  const config = useRuntimeConfig();
  const API_BASE = config.public.apiUrl;

  const players = useState<PlayerType[]>('admin-players', () => []);
  const isLoading = useState<boolean>('admin-players-loading', () => false);

  const fetchPlayers = async (): Promise<PlayerType[]> => {
    isLoading.value = true;
    try {
      const response = await $fetch<{ players: PlayerType[] }>(`${API_BASE}/players`, {
        credentials: 'include',
      });
      players.value = response.players;
      return response.players;
    } catch (error) {
      console.error('Failed to fetch players:', error);
      return [];
    } finally {
      isLoading.value = false;
    }
  };

  const createPlayer = async (data: PlayerInput): Promise<PlayerType> => {
    const response = await $fetch<{ player: PlayerType }>(`${API_BASE}/admin/players`, {
      method: 'POST',
      credentials: 'include',
      body: data,
    });
    return response.player;
  };

  const updatePlayer = async (id: string, data: PlayerUpdate): Promise<PlayerType> => {
    const response = await $fetch<{ player: PlayerType }>(`${API_BASE}/admin/players/${id}`, {
      method: 'PATCH',
      credentials: 'include',
      body: data,
    });
    return response.player;
  };

  const deletePlayer = async (id: string): Promise<void> => {
    await $fetch(`${API_BASE}/admin/players/${id}`, {
      method: 'DELETE',
      credentials: 'include',
    });
  };

  return {
    players,
    isLoading,
    fetchPlayers,
    createPlayer,
    updatePlayer,
    deletePlayer,
  };
};
