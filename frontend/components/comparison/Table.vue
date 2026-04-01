<template>
  <div class="comparison-table-wrapper">
    <v-table density="comfortable" class="comparison-table">
      <thead>
        <tr>
          <th class="sticky-col spec-header">Specification</th>
          <th v-for="guitar in guitars" :key="guitar.id" class="guitar-header">
            <div class="d-flex flex-column align-center">
              <v-btn
                icon
                size="x-small"
                variant="text"
                class="remove-btn"
                @click="$emit('remove', guitar.id)"
              >
                <IconifyIcon icon="mdi-close" size="16" />
              </v-btn>
              <NuxtImg
                v-if="guitar.image_url && !guitar.image_url.includes('placeholder')"
                :src="guitar.image_url"
                :alt="`${guitar.brand?.name} ${guitar.model}`"
                width="120"
                height="90"
                class="guitar-thumb"
                format="webp"
              />
              <div v-else class="guitar-thumb-placeholder">
                <IconifyIcon icon="mdi-guitar-electric" size="32" />
              </div>
              <span class="brand-name">{{ guitar.brand?.name }}</span>
              <span class="model-name font-weight-bold">{{ guitar.model }}</span>
            </div>
          </th>
        </tr>
      </thead>
      <tbody>
        <!-- Price Row -->
        <tr class="section-header">
          <td colspan="100" class="section-cell">Price</td>
        </tr>
        <tr>
          <td class="spec-label">USD</td>
          <td v-for="guitar in guitars" :key="guitar.id">
            {{ extractPriceUSD(guitar.price_range) }}
          </td>
        </tr>
        <tr>
          <td class="spec-label">RUB</td>
          <td v-for="guitar in guitars" :key="guitar.id">
            {{ extractPriceRUB(guitar.price_range) }}
          </td>
        </tr>

        <!-- Type Row -->
        <tr class="section-header">
          <td colspan="100" class="section-cell">Type</td>
        </tr>
        <tr>
          <td class="spec-label">Type</td>
          <td v-for="guitar in guitars" :key="guitar.id" :class="{ 'diff-cell': isTypeDiffering }">
            <v-chip size="small" :color="getTypeColor(guitar.guitar_type)">
              {{ guitar.guitar_type }}
            </v-chip>
          </td>
        </tr>

        <!-- Spec Sections -->
        <template v-for="section in SPEC_SECTIONS" :key="section.title">
          <tr class="section-header">
            <td colspan="100" class="section-cell">{{ section.title }}</td>
          </tr>
          <tr v-for="key in section.keys" :key="key">
            <td class="spec-label">{{ SPEC_LABELS[key] }}</td>
            <td
              v-for="guitar in guitars"
              :key="guitar.id"
              :class="{ 'diff-cell': isDiffering(key) }"
            >
              {{ formatSpecValue(getSpecValue(guitar, key)) }}
            </td>
          </tr>
        </template>

        <!-- Famous Players -->
        <tr v-if="hasPlayers" class="section-header">
          <td colspan="100" class="section-cell">Famous Players</td>
        </tr>
        <tr v-if="hasPlayers">
          <td class="spec-label">Players</td>
          <td v-for="guitar in guitars" :key="guitar.id">
            <div class="players-cell">
              <template v-if="guitar.players && guitar.players.length > 0">
                <v-chip
                  v-for="player in guitar.players"
                  :key="player.id"
                  size="x-small"
                  class="mr-1 mb-1"
                >
                  {{ player.name }}
                </v-chip>
              </template>
              <span v-else class="text-medium-emphasis">—</span>
            </div>
          </td>
        </tr>
      </tbody>
    </v-table>
  </div>
</template>

<script setup lang="ts">
import type { Guitar } from '~/types';
import type { SpecKey } from '~/composables/useComparison';
import { useComparison, SPEC_SECTIONS, SPEC_LABELS } from '~/composables/useComparison';

const props = defineProps<{
  guitars: Guitar[];
  differingKeys: SpecKey[];
}>();

defineEmits<{
  remove: [id: string];
}>();

const { getSpecValue, formatSpecValue, extractPriceUSD, extractPriceRUB } = useComparison();

const isDiffering = (key: SpecKey): boolean => {
  return props.differingKeys.includes(key);
};

const isTypeDiffering = computed(() => {
  return false;
});

const hasPlayers = computed(() => {
  return true;
});

const getTypeColor = (type: string) => {
  const colors: Record<string, string> = {
    electric: 'red',
    acoustic: 'green',
    bass: 'blue',
  };
  return colors[type] || 'grey';
};
</script>

<style scoped>
.comparison-table-wrapper {
  overflow-x: auto;
  border-radius: 8px;
  border: 1px solid rgb(var(--v-theme-outline));
}

.comparison-table {
  min-width: 800px;
}

.sticky-col {
  position: sticky;
  left: 0;
  background: rgb(var(--v-theme-surface));
  z-index: 2;
  min-width: 150px;
  font-weight: 500;
}

.guitar-header {
  min-width: 180px;
  text-align: center;
  vertical-align: top;
}

.spec-header {
  z-index: 3;
}

.remove-btn {
  position: absolute;
  top: -8px;
  right: -8px;
  z-index: 1;
}

.guitar-header {
  position: relative;
  padding-top: 24px !important;
}

.guitar-thumb {
  width: 120px;
  height: 90px;
  object-fit: cover;
  border-radius: 4px;
  margin-bottom: 8px;
}

.guitar-thumb-placeholder {
  width: 120px;
  height: 90px;
  background: rgb(var(--v-theme-grey-lighten-3));
  border-radius: 4px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 8px;
}

.brand-name {
  font-size: 0.75rem;
  color: rgb(var(--v-theme-secondary));
}

.model-name {
  font-size: 0.875rem;
}

.section-header {
  background: rgb(var(--v-theme-surface-variant));
}

.section-cell {
  font-weight: 600;
  text-transform: uppercase;
  font-size: 0.75rem;
  letter-spacing: 0.5px;
  color: rgb(var(--v-theme-secondary));
  padding: 8px 16px !important;
}

.spec-label {
  font-weight: 500;
  color: rgb(var(--v-theme-on-surface));
  background: rgb(var(--v-theme-surface));
}

.diff-cell {
  background-color: rgba(255, 179, 0, 0.15);
}

.players-cell {
  display: flex;
  flex-wrap: wrap;
  gap: 4px;
}
</style>
