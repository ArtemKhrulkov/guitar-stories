export interface User {
  id: string;
  email: string;
  name?: string;
  role: string;
  email_verified: boolean;
  created_at: string;
}

export interface AuthState {
  user: Ref<User | null>;
  isAuthenticated: Ref<boolean>;
  isLoading: Ref<boolean>;
  login(email: string, password: string): Promise<User>;
  register(email: string, password: string, name?: string): Promise<{ email: string }>;
  verifyEmail(email: string, code: string): Promise<User>;
  requestPasswordReset(email: string): Promise<void>;
  resetPassword(email: string, code: string, password: string): Promise<User>;
  logout(): Promise<void>;
  checkAuth(): Promise<User | null>;
  updateProfile(data: { name?: string }): Promise<User>;
}

export const useAuth = (): AuthState => {
  const config = useRuntimeConfig();
  const API_BASE = config.public.apiUrl;

  const user = useState<User | null>('auth_user', () => null);
  const isAuthenticated = useState<boolean>('auth_authenticated', () => false);
  const isLoading = useState<boolean>('auth_loading', () => false);

  const login = async (email: string, password: string): Promise<User> => {
    isLoading.value = true;
    try {
      const response = await $fetch<{ success: boolean; user: User }>(`${API_BASE}/auth/login`, {
        method: 'POST',
        credentials: 'include',
        body: { email, password },
      });
      user.value = response.user;
      isAuthenticated.value = true;
      return response.user;
    } finally {
      isLoading.value = false;
    }
  };

  const register = async (email: string, password: string, name?: string): Promise<{ email: string }> => {
    isLoading.value = true;
    try {
      const response = await $fetch<{ email: string }>(`${API_BASE}/auth/register`, {
        method: 'POST',
        credentials: 'include',
        body: { email, password, name },
      });
      return response;
    } finally {
      isLoading.value = false;
    }
  };

  const verifyEmail = async (email: string, code: string): Promise<User> => {
    isLoading.value = true;
    try {
      const response = await $fetch<{ user: User }>(`${API_BASE}/auth/verify-email`, {
        method: 'POST',
        credentials: 'include',
        body: { email, code },
      });
      user.value = response.user;
      isAuthenticated.value = true;
      return response.user;
    } finally {
      isLoading.value = false;
    }
  };

  const requestPasswordReset = async (email: string): Promise<void> => {
    await $fetch(`${API_BASE}/auth/request-password-reset`, {
      method: 'POST',
      credentials: 'include',
      body: { email },
    });
  };

  const resetPassword = async (email: string, code: string, password: string): Promise<User> => {
    isLoading.value = true;
    try {
      const response = await $fetch<{ user: User }>(`${API_BASE}/auth/reset-password`, {
        method: 'POST',
        credentials: 'include',
        body: { email, code, password },
      });
      user.value = response.user;
      isAuthenticated.value = true;
      return response.user;
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
      user.value = null;
      isAuthenticated.value = false;
    }
  };

  const checkAuth = async (): Promise<User | null> => {
    try {
      const response = await $fetch<{ authenticated: boolean; user: User }>(
        `${API_BASE}/auth/check`,
        { credentials: 'include' },
      );
      if (response.authenticated && response.user) {
        user.value = response.user;
        isAuthenticated.value = true;
        return response.user;
      }
      user.value = null;
      isAuthenticated.value = false;
      return null;
    } catch {
      user.value = null;
      isAuthenticated.value = false;
      return null;
    }
  };

  const updateProfile = async (data: { name?: string }): Promise<User> => {
    const response = await $fetch<{ user: User }>(`${API_BASE}/auth/profile`, {
      method: 'PUT',
      credentials: 'include',
      body: data,
    });
    user.value = response.user;
    return response.user;
  };

  return {
    user,
    isAuthenticated,
    isLoading,
    login,
    register,
    verifyEmail,
    requestPasswordReset,
    resetPassword,
    logout,
    checkAuth,
    updateProfile,
  };
};