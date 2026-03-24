<template>
    <v-card class="sticky-sidebar" elevation="2">
        <v-card-title class="d-flex align-center justify-space-between">
            <span class="text-h6">Filters</span>
            <v-btn
                v-if="hasActiveFilters"
                variant="text"
                color="error"
                @click="$emit('clearFilters')"
            >
                Clear All
            </v-btn>
        </v-card-title>

        <v-divider></v-divider>

        <v-card-text class="pt-4">
            <!-- Guitar Type Filter -->
            <div class="mb-6">
                <h3
                    class="text-subtitle-2 font-weight-bold mb-3 flex items-center"
                >
                    <IconifyIcon
                        icon="mdi-guitar-electric"
                        class="mr-1"
                    ></IconifyIcon>
                    Guitar Type
                </h3>

                <v-radio-group
                    :model-value="selectedType"
                    @update:model-value="$emit('update:selectedType', $event)"
                    true-icon="mdi:radiobox-marked"
                    false-icon="mdi:radiobox-blank"
                >
                    <v-radio
                        label="All Types"
                        value=""
                        color="primary"
                    ></v-radio>
                    <v-radio label="Electric" value="electric" color="red">
                        <template v-slot:label>
                            <IconifyIcon
                                icon="mdi-guitar-electric"
                                color="red"
                                class="mr-1"
                            ></IconifyIcon>
                            Electric
                        </template>
                    </v-radio>
                    <v-radio label="Acoustic" value="acoustic" color="green">
                        <template v-slot:label>
                            <IconifyIcon
                                icon="mdi-guitar-acoustic"
                                color="green"
                                class="mr-1"
                            ></IconifyIcon>
                            Acoustic
                        </template>
                    </v-radio>
                    <v-radio label="Bass" value="bass" color="blue">
                        <template v-slot:label>
                            <IconifyIcon
                                icon="mdi-guitar-electric"
                                color="blue"
                                class="mr-1"
                            ></IconifyIcon>
                            Bass
                        </template>
                    </v-radio>
                </v-radio-group>
            </div>

            <v-divider class="mb-6"></v-divider>

            <!-- Brand Filter -->
            <div class="mb-6">
                <h3
                    class="text-subtitle-2 font-weight-bold mb-3 flex items-center"
                >
                    <IconifyIcon
                        icon="mdi-factory"
                        size="18"
                        class="mr-1"
                    ></IconifyIcon>
                    Brand
                </h3>

                <v-select
                    v-if="!loading"
                    :model-value="selectedBrand"
                    @update:model-value="$emit('update:selectedBrand', $event)"
                    :items="brandOptions"
                    label="Select Brand"
                    variant="outlined"
                    density="compact"
                    hide-details
                    clearable
                >
                    <template v-slot:item="{ item, props }">
                        <v-list-item v-bind="props">
                            <template v-slot:prepend>
                                <v-avatar size="24" color="primary">
                                    <IconifyIcon
                                        icon="mdi-guitar-electric"
                                    ></IconifyIcon>
                                </v-avatar>
                            </template>
                        </v-list-item>
                    </template>
                </v-select>

                <v-skeleton-loader
                    v-else
                    type="list-item-two-line"
                ></v-skeleton-loader>
            </div>

            <v-divider class="mb-6"></v-divider>

            <!-- Apply Button -->
            <v-btn
                color="primary"
                block
                size="large"
                @click="$emit('applyFilters')"
                :disabled="loading"
            >
                <IconifyIcon icon="mdi-magnify" class="mr-2"></IconifyIcon>
                Apply Filters
            </v-btn>
        </v-card-text>
    </v-card>
</template>

<script setup lang="ts">
import type { Brand } from "~/types";

const props = defineProps<{
    brands: Brand[];
    loading: boolean;
    selectedBrand: string;
    selectedType: string;
    searchQuery: string;
}>();

defineEmits<{
    (e: "update:selectedBrand", value: string): void;
    (e: "update:selectedType", value: string): void;
    (e: "update:searchQuery", value: string): void;
    (e: "applyFilters"): void;
    (e: "clearFilters"): void;
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
