<template>
  <v-app>
    <v-app-bar color="primary" elevation="2" role="banner">
      <v-app-bar-nav-icon
        class="d-md-none"
        aria-label="Open navigation menu"
        @click="drawer = !drawer"
      />

      <v-toolbar-title class="font-weight-bold justify-start">
        <NuxtLink to="/" class="text-white text-decoration-none flex items-center">
          <IconifyIcon icon="mdi-guitar-acoustic" class="mr-2" aria-hidden="true" />
          Guitar Stock
        </NuxtLink>
      </v-toolbar-title>

      <v-spacer />

      <v-btn to="/" variant="text" class="d-none d-md-flex" aria-label="Home">
        <IconifyIcon icon="mdi-home" class="mr-1" aria-hidden="true" />
        Home
      </v-btn>
      <v-btn to="/guitars" variant="text" class="d-none d-md-flex" aria-label="Browse guitars">
        <IconifyIcon icon="mdi-guitar-electric" class="mr-1" aria-hidden="true" />
        Guitars
      </v-btn>
      <v-btn to="/brands" variant="text" class="d-none d-md-flex" aria-label="Browse brands">
        <IconifyIcon icon="mdi-factory" class="mr-1" aria-hidden="true" />
        Brands
      </v-btn>

      <v-menu
        v-model="searchMenuOpen"
        :close-on-content-click="false"
        location="bottom end"
        class="search-menu"
      >
        <template #activator="{ props }">
          <v-btn icon="mdi-magnify" variant="text" v-bind="props" aria-label="Search guitars" />
        </template>
        <v-card min-width="300" class="pa-2">
          <v-text-field
            v-model="searchQuery"
            placeholder="Search guitars, players..."
            prepend-inner-icon="mdi-magnify"
            variant="solo"
            hide-details
            density="compact"
            autofocus
            aria-label="Search input"
            @update:model-value="performSearch"
          />
        </v-card>
      </v-menu>
    </v-app-bar>

    <v-navigation-drawer v-model="drawer" temporary aria-label="Main navigation menu">
      <v-list>
        <v-list-item title="Menu" subtitle="Navigation" />
        <v-divider />
        <v-list-item to="/" prepend-icon="mdi-home" title="Home" />
        <v-list-item to="/guitars" prepend-icon="mdi-guitar-electric" title="Guitars" />
        <v-list-item to="/brands" prepend-icon="mdi-factory" title="Brands" />
      </v-list>
    </v-navigation-drawer>

    <v-main id="main-content" class="bg-background pb-16">
      <v-container fluid class="pa-0">
        <slot />
      </v-container>
    </v-main>

    <ComparisonBar />

    <v-footer color="primary" class="py-4" role="contentinfo">
      <v-row justify="center" no-gutters>
        <v-col class="text-center" cols="12">
          <div class="text-body-2">
            <IconifyIcon icon="mdi-guitar-acoustic" size="16" class="mr-1" aria-hidden="true" />
            Guitar Stock - Your Guitar Catalog
          </div>
          <div class="text-caption mt-1">Built with Vue 3, Nuxt 3</div>
        </v-col>
      </v-row>
    </v-footer>
  </v-app>
</template>

<script setup lang="ts">
const drawer = ref(false);
const searchQuery = ref('');
const searchMenuOpen = ref(false);
const router = useRouter();

let searchDebounceTimer: NodeJS.Timeout | null = null;

const performSearch = (value: string) => {
  if (!value?.trim()) return;

  if (searchDebounceTimer) {
    clearTimeout(searchDebounceTimer);
  }

  if (!searchQuery.value.trim()) {
    return;
  }

  searchDebounceTimer = setTimeout(() => {
    router.push({ path: '/guitars', query: { search: searchQuery.value } });
    searchMenuOpen.value = false;
  }, 500);
};
</script>

<style scoped>
.bg-background {
  background-color: rgb(var(--v-theme-background));
}

.skip-link {
  position: absolute;
  top: -40px;
  left: 0;
  background: rgb(var(--v-theme-primary));
  color: white;
  padding: 8px 16px;
  z-index: 10000;
  transition: top 0.3s ease;
  text-decoration: none;
  font-weight: 500;
}

.skip-link:focus {
  top: 0;
}
</style>
