<template>
  <v-card class="sticky-sidebar" elevation="2">
    <v-card-title class="d-flex align-center justify-space-between">
      <span class="text-h6">Filters</span>
      <v-btn v-if="hasActiveFilters" variant="text" color="error" @click="$emit('clearFilters')">
        Clear All
      </v-btn>
    </v-card-title>

    <v-divider />

    <v-card-text class="pt-4">
      <!-- Guitar Type Filter -->
      <div class="mb-6">
        <h3 class="text-subtitle-2 font-weight-bold mb-3 flex items-center">
          <IconifyIcon icon="mdi-guitar-electric" class="mr-1" />
          Guitar Type
        </h3>

        <v-radio-group
          :model-value="selectedType"
          true-icon="mdi:radiobox-marked"
          false-icon="mdi:radiobox-blank"
          @update:model-value="$emit('update:selectedType', ($event ?? '') as string)"
        >
          <v-radio label="All Types" value="" color="primary" />
          <v-radio label="Electric" value="electric" color="red">
            <template #label>
              <IconifyIcon icon="mdi-guitar-electric" color="red" class="mr-1" />
              Electric
            </template>
          </v-radio>
          <v-radio label="Acoustic" value="acoustic" color="green">
            <template #label>
              <IconifyIcon icon="mdi-guitar-acoustic" color="green" class="mr-1" />
              Acoustic
            </template>
          </v-radio>
          <v-radio label="Bass" value="bass" color="blue">
            <template #label>
              <IconifyIcon icon="mdi-guitar-electric" color="blue" class="mr-1" />
              Bass
            </template>
          </v-radio>
        </v-radio-group>
      </div>

      <v-divider class="mb-6" />

      <!-- Brand Filter -->
      <div class="mb-6">
        <h3 class="text-subtitle-2 font-weight-bold mb-3 flex items-center">
          <IconifyIcon icon="mdi-factory" size="18" class="mr-1" />
          Brand
        </h3>

        <v-select
          v-if="!loading"
          :model-value="selectedBrand"
          :items="brandOptions"
          label="Select Brand"
          variant="outlined"
          density="compact"
          hide-details
          clearable
          @update:model-value="$emit('update:selectedBrand', $event)"
        >
          <template #item="{ props: itemProps }">
            <v-list-item v-bind="itemProps">
              <template #prepend>
                <v-avatar size="24" color="primary">
                  <IconifyIcon icon="mdi-guitar-electric" />
                </v-avatar>
              </template>
            </v-list-item>
          </template>
        </v-select>

        <v-skeleton-loader v-else type="list-item-two-line" />
      </div>

      <v-divider class="mb-6" />

      <!-- Apply Button -->
      <v-btn color="primary" block size="large" :disabled="loading" @click="$emit('applyFilters')">
        <IconifyIcon icon="mdi-magnify" class="mr-2" />
        Apply Filters
      </v-btn>
    </v-card-text>
  </v-card>
</template>

<script setup lang="ts">
import type { Brand } from '~/types';

const props = defineProps<{
  brands: Brand[];
  loading: boolean;
  selectedBrand: string;
  selectedType: string;
  searchQuery: string;
}>();

defineEmits<{
  'update:selectedBrand': [value: string];
  'update:selectedType': [value: string];
  'update:searchQuery': [value: string];
  applyFilters: [];
  clearFilters: [];
}>();

const brandOptions = computed(() => {
  return props.brands.map((brand) => ({
    title: `${brand.name} (${brand.country})`,
    value: brand.id,
  }));
});

const hasActiveFilters = computed(() => {
  return props.selectedBrand || props.selectedType || props.searchQuery;
});
</script>

<style scoped>
.sticky-sidebar {
  position: sticky;
  top: 80px;
}
</style>
