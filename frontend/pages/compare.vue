<template>
  <div class="compare-page">
    <v-container fluid class="pa-6">
      <div class="d-flex align-center justify-space-between mb-6">
        <div>
          <v-btn variant="text" start to="/guitars" class="mb-2">
            <IconifyIcon icon="mdi-arrow-left" class="mr-1" />
            Back to Catalog
          </v-btn>
          <h1 class="text-h4 font-weight-bold">
            <IconifyIcon icon="mdi-compare-horizontal" color="primary" size="32px" class="mr-2" />
            Compare Guitars
          </h1>
          <p class="text-body-2 text-medium-emphasis mt-1">
            {{ comparisonStore.count }} of {{ comparisonStore.MAX_GUITARS }} guitars selected
          </p>
        </div>
        <div class="d-flex ga-2">
          <v-btn variant="outlined" color="primary" to="/guitars">
            <IconifyIcon icon="mdi-plus" class="mr-1" />
            Add More
          </v-btn>
          <v-btn v-if="!comparisonStore.isEmpty" variant="text" @click="comparisonStore.clearAll()">
            Clear All
          </v-btn>
        </div>
      </div>

      <v-row v-if="comparisonStore.isEmpty">
        <v-col cols="12">
          <v-card class="text-center pa-12">
            <IconifyIcon icon="mdi-compare-horizontal" size="64" color="grey" />
            <h3 class="text-h5 mt-4 mb-2">No guitars selected for comparison</h3>
            <p class="text-body-2 text-medium-emphasis mb-4">
              Browse the catalog and add guitars to compare their specifications
            </p>
            <v-btn color="primary" to="/guitars">
              Browse Guitars
              <IconifyIcon icon="mdi-arrow-right" class="ml-1" />
            </v-btn>
          </v-card>
        </v-col>
      </v-row>

      <template v-else>
        <v-card class="mb-6">
          <v-card-title class="d-flex align-center justify-space-between">
            <span>Comparison Table</span>
            <v-chip size="small" variant="outlined">
              <IconifyIcon icon="mdi-lightbulb" class="mr-1" />
              Yellow rows have different values
            </v-chip>
          </v-card-title>
          <v-card-text>
            <div v-if="loading" class="text-center pa-8">
              <v-progress-circular indeterminate color="primary" />
              <p class="mt-4">Loading guitar details...</p>
            </div>
            <ComparisonTable
              v-else
              :guitars="guitars"
              :differing-keys="differingKeys"
              @remove="handleRemove"
            />
          </v-card-text>
        </v-card>

        <v-card v-if="guitars.length > 0">
          <v-card-title>Summary</v-card-title>
          <v-card-text>
            <v-row>
              <v-col v-for="guitar in guitars" :key="guitar.id" cols="12" sm="6" md="4">
                <v-card variant="outlined" class="pa-4">
                  <div class="d-flex align-center mb-2">
                    <v-chip size="small" :color="getTypeColor(guitar.guitar_type)">
                      {{ guitar.guitar_type }}
                    </v-chip>
                  </div>
                  <h3 class="text-h6">{{ guitar.brand?.name }} {{ guitar.model }}</h3>
                  <p class="text-body-2 text-medium-emphasis mt-1">
                    {{ guitar.price_range || 'Price not available' }}
                  </p>
                  <v-btn
                    color="primary"
                    variant="text"
                    size="small"
                    :to="`/guitars/${guitar.id}`"
                    class="mt-2"
                  >
                    View Details
                    <IconifyIcon icon="mdi-arrow-right" class="ml-1" />
                  </v-btn>
                </v-card>
              </v-col>
            </v-row>
          </v-card-text>
        </v-card>
      </template>
    </v-container>
  </div>
</template>

<script setup lang="ts">
import { useComparisonStore } from '~/stores/comparison';
import { useComparison } from '~/composables/useComparison';
import type { SpecKey } from '~/composables/useComparison';

const comparisonStore = useComparisonStore();
const { guitars, loading, fetchGuitarsForComparison, getDifferingKeys } = useComparison();

const differingKeys = ref<SpecKey[]>([]);

const loadGuitars = async () => {
  const ids = comparisonStore.selectedGuitars.map((g) => g.id);
  if (ids.length > 0) {
    await fetchGuitarsForComparison(ids);
    differingKeys.value = getDifferingKeys();
  }
};

const handleRemove = (id: string) => {
  comparisonStore.removeGuitar(id);
};

const getTypeColor = (type: string) => {
  const colors: Record<string, string> = {
    electric: 'red',
    acoustic: 'green',
    bass: 'blue',
  };
  return colors[type] || 'grey';
};

useHead({
  title: 'Compare Guitars',
});

onMounted(() => {
  loadGuitars();
});

watch(
  () => comparisonStore.selectedGuitars,
  () => {
    loadGuitars();
  },
  { deep: true },
);
</script>

<style scoped>
.compare-page {
  min-height: calc(100vh - 200px);
}
</style>
