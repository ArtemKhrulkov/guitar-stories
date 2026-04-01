<template>
  <v-container fluid class="pa-6">
    <!-- Loading State -->
    <v-row v-if="loading">
      <v-col cols="12">
        <v-skeleton-loader type="article" />
      </v-col>
    </v-row>

    <!-- Error State -->
    <v-card v-else-if="error" color="error" class="pa-6 text-center" role="alert">
      <IconifyIcon icon="mdi-alert-circle" size="48" class="mb-4" aria-hidden="true" />
      <h2 class="text-h5 mb-2">Error Loading Brand</h2>
      <p class="mb-4">{{ error }}</p>
      <v-btn to="/brands" color="white" variant="flat"> Back to Brands </v-btn>
    </v-card>

    <!-- Brand Detail -->
    <template v-else-if="brand">
      <!-- Breadcrumbs -->
      <v-breadcrumbs :items="breadcrumbs" class="px-0 mb-4" aria-label="Breadcrumb navigation">
        <template #divider>
          <IconifyIcon icon="mdi-chevron-right" aria-hidden="true" />
        </template>
      </v-breadcrumbs>

      <!-- Brand Header -->
      <BrandHeader :brand="brand" />

      <!-- Guitars Section -->
      <v-row class="mt-8">
        <v-col cols="12">
          <h2 class="text-h5 font-weight-bold mb-6">
            <IconifyIcon
              icon="mdi-guitar-electric"
              color="primary"
              class="mr-2"
              aria-hidden="true"
            />
            Guitars by {{ brand.name }}
          </h2>
        </v-col>
      </v-row>

      <v-row v-if="guitars.length === 0">
        <v-col cols="12">
          <v-card class="text-center pa-12">
            <IconifyIcon icon="mdi-guitar-electric" size="64" color="grey" aria-hidden="true" />
            <h3 class="text-h5 mt-4 mb-2">No guitars found</h3>
            <p class="text-body-2 text-medium-emphasis">
              This brand doesn't have any guitars in our catalog yet
            </p>
          </v-card>
        </v-col>
      </v-row>

      <v-row v-else>
        <v-col v-for="guitar in guitars" :key="guitar.id" cols="12" sm="6" md="4" lg="3">
          <GuitarCard :guitar="guitar" />
        </v-col>
      </v-row>
    </template>
  </v-container>
</template>

<script setup lang="ts">
import type { Guitar } from '~/types';

const route = useRoute();
const { currentBrand: brand, loading, error, fetchBrandById } = useBrands();

const guitars = ref<Guitar[]>([]);

const breadcrumbs = computed(() => [
  { title: 'Home', to: '/', disabled: false },
  { title: 'Brands', to: '/brands', disabled: false },
  { title: brand.value?.name || 'Loading...', disabled: true },
]);

useHead({
  title: computed(() => (brand.value ? brand.value.name : 'Brand Details')),
});

const id = route.params.id as string;
const result = await fetchBrandById(id);
if (result) {
  guitars.value = result.guitars || [];
}
</script>
