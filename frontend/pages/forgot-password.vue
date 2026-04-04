<template>
  <div class="auth-page">
    <v-container class="fill-height">
      <v-row justify="center" align="center">
        <v-col cols="12" sm="8" md="6" lg="4">
          <v-card class="pa-6" elevation="8">
            <div class="text-center mb-6">
              <IconifyIcon icon="mdi-lock-reset" size="48" color="primary" />
              <h1 class="text-h5 mt-2">Forgot Password</h1>
              <p class="text-body-2 text-medium-emphasis">
                Enter your email and we'll send you a reset code
              </p>
            </div>

            <v-form @submit.prevent="handleSubmit">
              <v-text-field
                v-model="form.email"
                label="Email"
                type="email"
                variant="outlined"
                prepend-inner-icon="mdi-email"
                :rules="[rules.required, rules.email]"
                class="mb-4"
              />

              <v-alert v-if="success" type="success" variant="tonal" class="mb-4">
                {{ success }}
              </v-alert>

              <v-alert v-if="error" type="error" variant="tonal" class="mb-4">
                {{ error }}
              </v-alert>

              <v-btn
                type="submit"
                color="primary"
                block
                size="large"
                :loading="loading"
              >
                Send Reset Code
              </v-btn>
            </v-form>

            <div class="text-center mt-4">
              <NuxtLink to="/login" class="text-body-2">Back to Login</NuxtLink>
            </div>
          </v-card>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  layout: 'default',
});

const router = useRouter();
const { requestPasswordReset } = useAuth();

const form = ref({ email: '' });
const loading = ref(false);
const error = ref('');
const success = ref('');

const rules = {
  required: (v: string) => !!v || 'Required',
  email: (v: string) => /.+@.+\..+/.test(v) || 'Invalid email',
};

const handleSubmit = async () => {
  error.value = '';
  success.value = '';

  if (!form.value.email) {
    error.value = 'Email is required';
    return;
  }

  loading.value = true;
  try {
    await requestPasswordReset(form.value.email);
    success.value = 'If the email exists and is verified, you will receive a reset code.';
    setTimeout(() => {
      router.push({
        path: '/verify',
        query: { email: form.value.email, type: 'password_reset' },
      });
    }, 2000);
  } catch (err: unknown) {
    const e = err as { data?: { error?: string } };
    error.value = e.data?.error || 'Failed to send reset code';
  } finally {
    loading.value = false;
  }
};
</script>

<style scoped>
.auth-page {
  min-height: calc(100vh - 200px);
  display: flex;
  align-items: center;
}
</style>