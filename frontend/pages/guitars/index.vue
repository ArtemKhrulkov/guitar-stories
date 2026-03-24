<template>
    <v-container fluid class="pa-6">
        <v-row>
            <!-- Filters Sidebar -->
            <v-col cols="12" md="3">
                <GuitarFilters
                    :brands="brands"
                    :loading="filtersLoading"
                    v-model:selected-brand="selectedBrand"
                    v-model:selected-type="selectedType"
                    v-model:search-query="searchQuery"
                    @apply-filters="applyFilters"
                    @clear-filters="clearFilters"
                />
            </v-col>

            <!-- Guitars Grid -->
            <v-col cols="12" md="9">
                <div class="d-flex align-center justify-space-between mb-6">
                    <h1 class="text-h4 font-weight-bold">
                        <IconifyIcon
                            icon="mdi-guitar-electric"
                            color="primary"
                            size="32px"
                            class="mr-2"
                        ></IconifyIcon>
                        Guitar Catalog
                    </h1>
                    <div class="text-body-2 text-medium-emphasis">
                        {{ total }} guitars found
                    </div>
                </div>

                <!-- Search Bar -->
                <v-text-field
                    v-model="searchQuery"
                    placeholder="Search by model or history..."
                    prepend-inner-icon="mdi-magnify"
                    variant="outlined"
                    density="compact"
                    hide-details
                    class="mb-6"
                    @input="onSearchInput"
                    clearable
                ></v-text-field>

                <!-- Loading State -->
                <v-row v-if="loading">
                    <v-col v-for="n in 9" :key="n" cols="12" sm="6" lg="4">
                        <v-skeleton-loader type="card"></v-skeleton-loader>
                    </v-col>
                </v-row>

                <!-- Empty State -->
                <v-card
                    v-else-if="guitars.length === 0"
                    class="text-center pa-12"
                >
                    <IconifyIcon
                        icon="mdi-guitar-electric"
                        size="64"
                        color="grey"
                    ></IconifyIcon>
                    <h3 class="text-h5 mt-4 mb-2">No guitars found</h3>
                    <p class="text-body-2 text-medium-emphasis mb-4">
                        Try adjusting your filters or search query
                    </p>
                    <v-btn @click="clearFilters" color="primary">
                        Clear Filters
                    </v-btn>
                </v-card>

                <!-- Guitars Grid -->
                <v-row v-else>
                    <v-col
                        v-for="guitar in guitars"
                        :key="guitar.id"
                        cols="12"
                        sm="6"
                        lg="4"
                    >
                        <GuitarCard :guitar="guitar" />
                    </v-col>
                </v-row>

                <!-- Pagination -->
                <v-pagination
                    v-if="totalPages > 1"
                    v-model="currentPage"
                    :length="totalPages"
                    :total-visible="totalVisibleElemets"
                    class="mt-8"
                    @update:model-value="changePage"
                ></v-pagination>
            </v-col>
        </v-row>
    </v-container>
</template>

<script setup lang="ts">
import type { Guitar, Brand, GuitarFilters } from "~/types";
import { useDisplay } from "vuetify";

const route = useRoute();
const router = useRouter();
const display = useDisplay();

const { guitars, total, loading, fetchGuitars } = useGuitars();
const { brands, loading: filtersLoading, fetchBrands } = useBrands();

const selectedBrand = ref<string>("");
const selectedType = ref<"electric" | "acoustic" | "bass" | "">("");
const searchQuery = ref<string>("");
const currentPage = ref<number>(1);
const itemsPerPage = 12;
const totalVisibleElemets = computed(() => (display.xs.value ? 3 : 6));

let searchDebounceTimer: NodeJS.Timeout | null = null;

const totalPages = computed(() => Math.ceil(total.value / itemsPerPage));

const applyFilters = async () => {
    currentPage.value = 1;
    await fetchGuitars({
        brand: selectedBrand.value || undefined,
        type: selectedType.value || undefined,
        search: searchQuery.value || undefined,
        page: currentPage.value,
        limit: itemsPerPage,
    });
};

const onSearchInput = () => {
    if (searchDebounceTimer) {
        clearTimeout(searchDebounceTimer);
    }
    searchDebounceTimer = setTimeout(() => {
        applyFilters();
    }, 500);
};

const clearFilters = async () => {
    selectedBrand.value = "";
    selectedType.value = "";
    searchQuery.value = "";
    currentPage.value = 1;
    await applyFilters();
};

const changePage = async (page: number) => {
    currentPage.value = page;
    await fetchGuitars({
        brand: selectedBrand.value || undefined,
        type: selectedType.value || undefined,
        search: searchQuery.value || undefined,
        page: currentPage.value,
        limit: itemsPerPage,
    });
    window.scrollTo({ top: 0, behavior: "smooth" });
};

useHead({
    title: "Guitars",
});

onMounted(async () => {
    await fetchBrands();

    // Check for query params
    if (route.query.search) {
        searchQuery.value = route.query.search as string;
    }
    if (route.query.brand) {
        selectedBrand.value = route.query.brand as string;
    }
    if (route.query.type) {
        selectedType.value = route.query.type as any;
    }
    if (route.query.page) {
        currentPage.value = parseInt(route.query.page as string);
    }

    await applyFilters();
});

watch(
    () => route.query,
    async (query) => {
        if (query.search !== undefined) {
            searchQuery.value = query.search as string;
        }
        if (query.brand !== undefined) {
            selectedBrand.value = query.brand as string;
        }
        if (query.type !== undefined) {
            selectedType.value = query.type as any;
        }
        if (query.page !== undefined) {
            currentPage.value = parseInt(query.page as string);
        }
        await applyFilters();
    },
);
</script>
