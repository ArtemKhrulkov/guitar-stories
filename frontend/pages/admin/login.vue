<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-900">
    <v-card class="pa-6" width="400">
      <div class="text-center mb-6">
        <IconifyIcon icon="mdi-shield-account" size="48" color="primary" />
        <h1 class="text-h5 mt-2">Admin Login</h1>
        <p class="text-body-2 text-medium-emphasis">Enter admin credentials</p>
      </div>

      <v-card-text>
        <v-form @submit.prevent="handleLogin">
          <v-text-field
            v-model="username"
            label="Username"
            variant="outlined"
            prepend-inner-icon="mdi-account"
            :error-messages="errors.username"
            class="mb-2"
            hint="Use admin credentials from .env"
            persistent-hint
          />

          <v-text-field
            v-model="password"
            label="Password"
            variant="outlined"
            type="password"
            prepend-inner-icon="mdi-lock"
            :error-messages="errors.password"
            class="mb-4"
          />

          <v-alert v-if="errorMessage" type="error" variant="tonal" class="mb-4">
            {{ errorMessage }}
          </v-alert>

          <v-btn type="submit" color="primary" block size="large" :loading="loading">
            Login
          </v-btn>
        </v-form>
      </v-card-text>

      <v-divider class="my-4" />

      <div class="text-center">
        <NuxtLink to="/login" class="text-body-2">
          <IconifyIcon icon="mdi-arrow-left" class="mr-1" />
          Back to User Login
        </NuxtLink>
      </div>
    </v-card>
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  layout: false,
});

const router = useRouter();
const { login } = useAuth();

const username = ref('');
const password = ref('');
const errors = ref<{ username?: string; password?: string }>({});
const errorMessage = ref('');
const loading = ref(false);

const handleLogin = async () => {
  errors.value = {};
  errorMessage.value = '';

  if (!username.value) {
    errors.value.username = 'Username is required';
    return;
  }

  if (!password.value) {
    errors.value.password = 'Password is required';
    return;
  }

  loading.value = true;
  try {
    const user = await login(username.value, password.value);
    if (user.role === 'admin') {
      router.push('/admin');
    } else {
      errorMessage.value = 'Admin access required';
    }
  } catch (error: unknown) {
    const e = error as { data?: { error?: string } };
    errorMessage.value = e.data?.error || 'Login failed';
  } finally {
    loading.value = false;
  }
};
</script>