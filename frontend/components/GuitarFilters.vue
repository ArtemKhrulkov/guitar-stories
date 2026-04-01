<template>
  <v-card class="sticky-sidebar" elevation="2">
    <v-card-title class="d-flex align-center justify-space-between">
      <span class="text-h6">Filters</span>
      <v-btn v-if="hasActiveFilters" variant="text" color="error" size="small" @click="$emit('clearFilters')">
        Clear All
      </v-btn>
    </v-card-title>

    <v-divider />

    <v-card-text class="pt-4">
      <v-expansion-panels variant="accordion" :model-value="[0, 1, 2, 3, 4]" multiple>
        <v-expansion-panel value="sort">
          <v-expansion-panel-title>
            <template #default="{ expanded }">
              <div class="d-flex align-center">
                <IconifyIcon :icon="expanded ? 'mdi-chevron-down' : 'mdi-chevron-right'" class="mr-2" />
                <IconifyIcon icon="mdi-sort" class="mr-2" />
                Sort By
              </div>
            </template>
          </v-expansion-panel-title>
          <v-expansion-panel-text>
            <v-radio-group
              :model-value="selectedSort"
              hide-details
              @update:model-value="onSortChange"
            >
              <v-radio label="Newest First" value="newest" color="primary" />
              <v-radio label="Oldest First" value="oldest" color="primary" />
              <v-radio label="A-Z" value="model_asc" color="primary" />
              <v-radio label="Z-A" value="model_desc" color="primary" />
            </v-radio-group>
          </v-expansion-panel-text>
        </v-expansion-panel>

        <v-expansion-panel value="type">
          <v-expansion-panel-title>
            <template #default="{ expanded }">
              <div class="d-flex align-center">
                <IconifyIcon :icon="expanded ? 'mdi-chevron-down' : 'mdi-chevron-right'" class="mr-2" />
                <IconifyIcon icon="mdi-guitar-electric" class="mr-2" />
                Guitar Type
              </div>
            </template>
          </v-expansion-panel-title>
          <v-expansion-panel-text>
            <v-radio-group
              :model-value="selectedType"
              hide-details
              @update:model-value="onTypeChange"
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
                  <IconifyIcon icon="mdi-music-clef-bass" color="blue" class="mr-1" />
                  Bass
                </template>
              </v-radio>
            </v-radio-group>
          </v-expansion-panel-text>
        </v-expansion-panel>

        <v-expansion-panel value="brand">
          <v-expansion-panel-title>
            <template #default="{ expanded }">
              <div class="d-flex align-center">
                <IconifyIcon :icon="expanded ? 'mdi-chevron-down' : 'mdi-chevron-right'" class="mr-2" />
                <IconifyIcon icon="mdi-factory" class="mr-2" />
                Brands
                <v-chip v-if="selectedBrands.length > 0" size="x-small" class="ml-2" color="primary">
                  {{ selectedBrands.length }}
                </v-chip>
              </div>
            </template>
          </v-expansion-panel-title>
          <v-expansion-panel-text class="pa-0">
            <v-text-field
              v-model="brandSearch"
              placeholder="Search brands..."
              prepend-inner-icon="mdi-magnify"
              variant="outlined"
              density="compact"
              hide-details
              class="px-3 pt-2"
            />
            <v-list v-if="!loading" density="compact" class="brand-list">
              <v-list-item
                v-for="brand in filteredBrandOptions"
                :key="brand.value"
                :active="selectedBrands.includes(brand.value)"
                @click="toggleBrand(brand.value)"
              >
                <template #prepend>
                  <v-checkbox-btn
                    :model-value="selectedBrands.includes(brand.value)"
                    color="primary"
                  />
                </template>
                <v-list-item-title>{{ brand.title }}</v-list-item-title>
              </v-list-item>
              <v-list-item v-if="filteredBrandOptions.length === 0" class="text-center text-medium-emphasis">
                No brands found
              </v-list-item>
            </v-list>
            <v-skeleton-loader v-else type="list-item-three-line" class="mx-2" />
          </v-expansion-panel-text>
        </v-expansion-panel>

        <v-expansion-panel value="price">
          <v-expansion-panel-title>
            <template #default="{ expanded }">
              <div class="d-flex align-center">
                <IconifyIcon :icon="expanded ? 'mdi-chevron-down' : 'mdi-chevron-right'" class="mr-2" />
                <IconifyIcon icon="mdi-currency-rub" class="mr-2" />
                Price Range
              </div>
            </template>
          </v-expansion-panel-title>
          <v-expansion-panel-text>
            <div class="price-inputs">
              <v-text-field
                :model-value="minPrice"
                label="Min (RUB)"
                type="number"
                variant="outlined"
                density="compact"
                hide-details
                prefix="₽"
                @update:model-value="$emit('update:minPrice', $event ? Number($event) : undefined)"
              />
              <span class="mx-2">—</span>
              <v-text-field
                :model-value="maxPrice"
                label="Max (RUB)"
                type="number"
                variant="outlined"
                density="compact"
                hide-details
                prefix="₽"
                @update:model-value="$emit('update:maxPrice', $event ? Number($event) : undefined)"
              />
            </div>
            <div class="price-presets mt-3">
              <v-chip size="small" variant="outlined" @click="setPricePreset(0, 50000)">до 50K</v-chip>
              <v-chip size="small" variant="outlined" @click="setPricePreset(50000, 100000)">50K-100K</v-chip>
              <v-chip size="small" variant="outlined" @click="setPricePreset(100000, 200000)">100K-200K</v-chip>
              <v-chip size="small" variant="outlined" @click="setPricePreset(200000, undefined)">200K+</v-chip>
            </div>
          </v-expansion-panel-text>
        </v-expansion-panel>

        <v-expansion-panel value="stock">
          <v-expansion-panel-title>
            <template #default="{ expanded }">
              <div class="d-flex align-center">
                <IconifyIcon :icon="expanded ? 'mdi-chevron-down' : 'mdi-chevron-right'" class="mr-2" />
                <IconifyIcon icon="mdi-package-variant-closed" class="mr-2" />
                Availability
              </div>
            </template>
          </v-expansion-panel-title>
          <v-expansion-panel-text>
            <v-checkbox
              :model-value="inStock"
              label="In Stock Only"
              color="success"
              hide-details
              @update:model-value="$emit('update:inStock', $event || undefined)"
            />
          </v-expansion-panel-text>
        </v-expansion-panel>
      </v-expansion-panels>

      <v-divider class="my-4" />

      <v-btn color="primary" block size="large" @click="$emit('applyFilters')">
        <IconifyIcon icon="mdi-filter-check" class="mr-2" />
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
  selectedBrands: string[];
  selectedType: string;
  selectedSort: string;
  minPrice?: number;
  maxPrice?: number;
  inStock?: boolean;
  searchQuery: string;
}>();

const emit = defineEmits<{
  'update:selectedBrands': [value: string[]];
  'update:selectedType': [value: string];
  'update:selectedSort': [value: string];
  'update:minPrice': [value?: number];
  'update:maxPrice': [value?: number];
  'update:inStock': [value?: boolean];
  'update:searchQuery': [value: string];
  applyFilters: [];
  clearFilters: [];
}>();

const brandSearch = ref('');

const brandOptions = computed(() => {
  return props.brands.map((brand) => ({
    title: `${brand.name} (${brand.country})`,
    value: brand.id,
  }));
});

const filteredBrandOptions = computed(() => {
  if (!brandSearch.value) return brandOptions.value;
  const search = brandSearch.value.toLowerCase();
  return brandOptions.value.filter((b) => b.title.toLowerCase().includes(search));
});

const hasActiveFilters = computed(() => {
  return (
    props.selectedBrands.length > 0 ||
    props.selectedType ||
    props.minPrice !== undefined ||
    props.maxPrice !== undefined ||
    props.inStock !== undefined ||
    props.searchQuery
  );
});

const toggleBrand = (brandId: string) => {
  const newBrands = props.selectedBrands.includes(brandId)
    ? props.selectedBrands.filter((b) => b !== brandId)
    : [...props.selectedBrands, brandId];
  emit('update:selectedBrands', newBrands);
};

const setPricePreset = (min: number | undefined, max: number | undefined) => {
  emit('update:minPrice', min);
  emit('update:maxPrice', max);
};

const onSortChange = (value: unknown) => {
  emit('update:selectedSort', value as string);
};

const onTypeChange = (value: unknown) => {
  emit('update:selectedType', value as string);
};
</script>

<style scoped>
.sticky-sidebar {
  position: sticky;
  top: 80px;
}

.brand-list {
  max-height: 240px;
  overflow-y: auto;
}

.price-inputs {
  display: flex;
  align-items: center;
}

.price-presets {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}
</style>
