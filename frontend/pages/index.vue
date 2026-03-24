<template>
    <div>
        <!-- Hero Section -->
        <v-sheet color="primary" class="pa-16 text-center">
            <v-container>
                <h1 class="text-h2 font-weight-bold text-white mb-4">
                    <IconifyIcon
                        icon="mdi-guitar-acoustic"
                        class="mr-3"
                        size="64"
                        aria-hidden="true"
                    ></IconifyIcon>
                    Discover Your Dream Guitar
                </h1>
                <p class="text-h6 text-white-darken-3 mb-6">
                    Browse our comprehensive catalog of electric, acoustic, and
                    bass guitars
                </p>
                <v-btn
                    to="/guitars"
                    size="x-large"
                    color="secondary"
                    elevation="4"
                >
                    <IconifyIcon
                        icon="mdi-magnify"
                        class="mr-2"
                        aria-hidden="true"
                    ></IconifyIcon>
                    Explore Catalog
                </v-btn>
            </v-container>
        </v-sheet>

        <!-- Featured Guitars Section -->
        <v-container class="my-12">
            <div class="d-flex align-center justify-space-between mb-6">
                <h2 class="text-h4 font-weight-bold">
                    <IconifyIcon
                        icon="mdi-star"
                        color="secondary"
                        class="mr-2"
                        aria-hidden="true"
                    ></IconifyIcon>
                    Featured Guitars
                </h2>
                <v-btn to="/guitars" variant="text" color="primary">
                    View All
                    <IconifyIcon
                        icon="mdi-arrow-right"
                        class="ml-1"
                        aria-hidden="true"
                    ></IconifyIcon>
                </v-btn>
            </div>

            <v-row v-if="loading">
                <v-col v-for="n in 6" :key="n" cols="12" sm="6" md="4">
                    <v-skeleton-loader type="card"></v-skeleton-loader>
                </v-col>
            </v-row>

            <v-row v-else>
                <v-col
                    v-for="guitar in featuredGuitars"
                    :key="guitar.id"
                    cols="12"
                    sm="6"
                    md="4"
                >
                    <GuitarCard :guitar="guitar" />
                </v-col>
            </v-row>
        </v-container>

        <!-- Brands Section -->
        <v-sheet color="surface" class="pa-12">
            <v-container>
                <div class="d-flex align-center justify-space-between mb-6">
                    <h2 class="text-h4 font-weight-bold">
                        <IconifyIcon
                            icon="mdi-factory"
                            color="secondary"
                            class="mr-2"
                            aria-hidden="true"
                        ></IconifyIcon>
                        Popular Brands
                    </h2>
                    <v-btn to="/brands" variant="text" color="primary">
                        All Brands
                        <IconifyIcon
                            icon="mdi-arrow-right"
                            class="ml-1"
                            aria-hidden="true"
                        ></IconifyIcon>
                    </v-btn>
                </div>

                <v-row v-if="brandsLoading">
                    <v-col v-for="n in 6" :key="n" cols="6" sm="4" md="2">
                        <v-skeleton-loader
                            type="avatar"
                            class="mx-auto"
                            style="width: 80px; height: 80px"
                        ></v-skeleton-loader>
                    </v-col>
                </v-row>

                <v-row v-else>
                    <v-col
                        v-for="brand in featuredBrands"
                        :key="brand.id"
                        cols="6"
                        sm="4"
                        md="2"
                    >
                        <v-card
                            :to="`/brands/${brand.id}`"
                            class="text-center pa-4"
                            hover
                        >
                            <v-avatar size="64" color="primary" class="mb-3">
                                <IconifyIcon
                                    icon="mdi-guitar-electric"
                                    size="32"
                                    aria-hidden="true"
                                ></IconifyIcon>
                            </v-avatar>
                            <div class="text-h6 font-weight-medium">
                                {{ brand.name }}
                            </div>
                            <div class="text-caption text-medium-emphasis">
                                {{ brand.country }}
                            </div>
                        </v-card>
                    </v-col>
                </v-row>
            </v-container>
        </v-sheet>

        <!-- Call to Action -->
        <v-container class="my-12 text-center">
            <v-card color="surface" class="pa-8" elevation="4">
                <h2 class="text-h4 font-weight-bold mb-4">
                    Ready to Find Your Perfect Guitar?
                </h2>
                <p class="text-body-1 text-medium-emphasis mb-6">
                    Explore our extensive catalog with detailed specifications,
                    famous player associations, and purchase links.
                </p>
                <div class="d-flex justify-center gap-4">
                    <v-btn to="/guitars" size="large" color="primary">
                        <IconifyIcon
                            icon="mdi-guitar-electric"
                            class="mr-2"
                            aria-hidden="true"
                        ></IconifyIcon>
                        Browse Guitars
                    </v-btn>
                    <v-btn
                        to="/brands"
                        size="large"
                        variant="outlined"
                        color="primary"
                    >
                        <IconifyIcon
                            icon="mdi-factory"
                            class="mr-2"
                            aria-hidden="true"
                        ></IconifyIcon>
                        Explore Brands
                    </v-btn>
                </div>
            </v-card>
        </v-container>
    </div>
</template>

<script setup lang="ts">
import type { Guitar, Brand } from "~/types";

const { guitars, loading: guitarsLoading, fetchGuitars } = useGuitars();
const { brands, loading: brandsLoading, fetchBrands } = useBrands();

const loading = computed(() => guitarsLoading.value);
const featuredGuitars = computed(() => guitars.value.slice(0, 6));
const featuredBrands = computed(() => brands.value.slice(0, 6));

useHead({
    title: "Home",
});

onMounted(async () => {
    await Promise.all([fetchGuitars({ limit: 6 }), fetchBrands()]);
});
</script>

<style scoped>
.gap-4 {
    gap: 1rem;
}
</style>
