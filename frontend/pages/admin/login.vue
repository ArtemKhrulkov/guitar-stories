<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-900">
    <v-card class="pa-6" width="400">
      <v-card-title class="text-h5 text-center mb-4"> Admin Login </v-card-title>

      <v-card-text>
        <v-form @submit.prevent="handleLogin">
          <v-text-field
            v-model="username"
            label="Username"
            variant="outlined"
            :error-messages="errors.username"
            class="mb-2"
          />

          <v-text-field
            v-model="password"
            label="Password"
            variant="outlined"
            type="password"
            :error-messages="errors.password"
            class="mb-4"
          />

          <v-alert v-if="errorMessage" type="error" variant="tonal" class="mb-4">
            {{ errorMessage }}
          </v-alert>

          <v-btn type="submit" color="primary" block size="large" :loading="isLoading">
            Login
          </v-btn>
        </v-form>
      </v-card-text>
    </v-card>
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  layout: false,
});

const { login, isLoading } = useAdminAuth();

const username = ref('');
const password = ref('');
const errors = ref<{ username?: string; password?: string }>({});
const errorMessage = ref('');

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

  try {
    await login(username.value, password.value);
    navigateTo('/admin');
  } catch (error) {
    errorMessage.value = error instanceof Error ? error.message : 'Login failed';
  }
};
</script>
