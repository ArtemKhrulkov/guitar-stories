<template>
  <v-container fluid class="pa-6">
    <div class="d-flex align-center justify-space-between mb-6">
      <h1 class="text-h4 font-weight-bold">
        <IconifyIcon icon="mdi-factory" color="primary" class="mr-2" aria-hidden="true"></IconifyIcon>
        Guitar Brands
      </h1>
      <div class="text-body-2 text-medium-emphasis">
        {{ brands.length }} brands
      </div>
    </div>

    <!-- Loading State -->
    <v-row v-if="loading">
      <v-col v-for="n in 12" :key="n" cols="6" sm="4" md="3" lg="2">
        <v-skeleton-loader type="card"></v-skeleton-loader>
      </v-col>
    </v-row>

    <!-- Empty State -->
    <v-card v-else-if="brands.length === 0" class="text-center pa-12">
      <IconifyIcon icon="mdi-factory" size="64" color="grey" aria-hidden="true"></IconifyIcon>
      <h3 class="text-h5 mt-4 mb-2">No brands found</h3>
      <p class="text-body-2 text-medium-emphasis">
        Please check back later
      </p>
    </v-card>

    <!-- Brands Grid -->
    <v-row v-else>
      <v-col
        v-for="brand in brands"
        :key="brand.id"
        cols="6"
        sm="4"
        md="3"
        lg="2"
      >
        <v-card
          :to="`/brands/${brand.id}`"
          class="text-center pa-4 h-100"
          hover
        >
          <v-avatar size="80" color="primary" class="mb-4">
            <NuxtImg
              v-if="brand.logo_url"
              :src="brand.logo_url"
              :alt="`${brand.name} logo`"
              width="80"
              height="80"
              loading="lazy"
              format="webp"
              quality="80"
              class="brand-logo-img"
            />
            <IconifyIcon v-else icon="mdi-guitar-electric" size="40" aria-hidden="true"></IconifyIcon>
          </v-avatar>
          
          <h3 class="text-h6 font-weight-bold mb-1">{{ brand.name }}</h3>
          
          <div class="text-body-2 text-medium-emphasis mb-2">
            {{ brand.country }}
          </div>
          
          <v-chip v-if="brand.founded_year" size="x-small" color="secondary">
            Est. {{ brand.founded_year }}
          </v-chip>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup lang="ts">
const { brands, loading, fetchBrands } = useBrands()

useHead({
  title: 'Brands',
})

onMounted(async () => {
  await fetchBrands()
})
</script>

<style scoped>
.brand-logo-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
</style>
