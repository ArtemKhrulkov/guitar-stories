<template>
  <v-app>
    <v-container class="fill-height justify-center">
      <v-card class="text-center pa-8" max-width="600">
        <IconifyIcon :icon="errorIcon" size="80" :color="errorColor" class="mb-4"></IconifyIcon>
        
        <h1 class="text-h3 font-weight-bold mb-4">{{ errorTitle }}</h1>
        
        <p class="text-body-1 text-medium-emphasis mb-6">
          {{ errorMessage }}
        </p>

        <div class="d-flex justify-center gap-4">
          <v-btn color="primary" size="large" to="/">
            <IconifyIcon icon="mdi-home" class="mr-2"></IconifyIcon>
            Go Home
          </v-btn>
          <v-btn variant="outlined" size="large" @click="handleError">
            <IconifyIcon icon="mdi-refresh" class="mr-2"></IconifyIcon>
            Try Again
          </v-btn>
        </div>
      </v-card>
    </v-container>
  </v-app>
</template>

<script setup lang="ts">
const props = defineProps<{
  error: any
  statusCode?: number
}>()

const errorTitle = computed(() => {
  const titles: Record<number, string> = {
    404: 'Page Not Found',
    500: 'Server Error',
    403: 'Access Denied',
  }
  return titles[props.statusCode || 500] || 'Something Went Wrong'
})

const errorMessage = computed(() => {
  const messages: Record<number, string> = {
    404: 'The page you\'re looking for doesn\'t exist or has been moved.',
    500: 'Our servers are having trouble. Please try again later.',
    403: 'You don\'t have permission to access this resource.',
  }
  return messages[props.statusCode || 500] || props.error?.message || 'An unexpected error occurred.'
})

const errorIcon = computed(() => {
  const icons: Record<number, string> = {
    404: 'mdi-file-question',
    500: 'mdi-server-off',
    403: 'mdi-lock',
  }
  return icons[props.statusCode || 500] || 'mdi-alert-circle'
})

const errorColor = computed(() => {
  const colors: Record<number, string> = {
    404: 'warning',
    500: 'error',
    403: 'error',
  }
  return colors[props.statusCode || 500] || 'error'
})

const handleError = () => {
  clearError({ redirect: '/' })
}
</script>

<style scoped>
.gap-4 {
  gap: 1rem;
}
</style>
