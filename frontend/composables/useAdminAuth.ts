interface AuthState {
  isAuthenticated: Ref<boolean>;
  isLoading: Ref<boolean>;
  login(username: string, password: string): Promise<boolean>;
  logout(): Promise<void>;
  checkAuth(): Promise<boolean>;
}

export const useAdminAuth = (): AuthState => {
  const config = useRuntimeConfig();
  const API_BASE = config.public.apiUrl;

  const isAuthenticated = useState<boolean>('admin-auth', () => false);
  const isLoading = useState<boolean>('admin-auth-loading', () => false);

  const checkAuth = async (): Promise<boolean> => {
    try {
      const response = await $fetch<{ authenticated: boolean }>(`${API_BASE}/auth/check`, {
        credentials: 'include',
      });
      isAuthenticated.value = response.authenticated;
      return response.authenticated;
    } catch {
      isAuthenticated.value = false;
      return false;
    }
  };

  const login = async (username: string, password: string): Promise<boolean> => {
    isLoading.value = true;
    try {
      await $fetch(`${API_BASE}/auth/login`, {
        method: 'POST',
        credentials: 'include',
        body: { username, password },
      });
      isAuthenticated.value = true;
      return true;
    } catch (error: unknown) {
      isAuthenticated.value = false;
      const err = error as { data?: { error?: string } };
      throw err.data?.error || 'Login failed';
    } finally {
      isLoading.value = false;
    }
  };

  const logout = async (): Promise<void> => {
    try {
      await $fetch(`${API_BASE}/auth/logout`, {
        method: 'POST',
        credentials: 'include',
      });
    } finally {
      isAuthenticated.value = false;
      navigateTo('/admin/login');
    }
  };

  return {
    isAuthenticated,
    isLoading,
    login,
    logout,
    checkAuth,
  };
};
