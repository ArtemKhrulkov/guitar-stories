<template>
    <div class="min-h-screen bg-gray-900">
        <header class="bg-gray-800 border-b border-gray-700">
            <div
                class="max-w-7xl mx-auto px-4 py-4 flex justify-between items-center"
            >
                <h1 class="text-xl font-bold text-white">Admin Dashboard</h1>
                <v-btn
                    color="error"
                    variant="outlined"
                    size="small"
                    @click="handleLogout"
                >
                    Logout
                </v-btn>
            </div>
        </header>

        <main class="max-w-7xl mx-auto px-4 py-8">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
                <v-card class="pa-6">
                    <div class="flex items-center gap-4">
                        <IconifyIcon
                            icon="mdi:link-variant"
                            class="text-4xl text-primary"
                        />
                        <div>
                            <div class="text-3xl font-bold">
                                {{ totalLinks }}
                            </div>
                            <div class="text-gray-400">
                                Total Purchase Links
                            </div>
                        </div>
                    </div>
                </v-card>

                <v-card class="pa-6">
                    <div class="flex items-center gap-4">
                        <IconifyIcon
                            icon="mdi:guitar-acoustic"
                            class="text-4xl text-secondary"
                        />
                        <div>
                            <div class="text-3xl font-bold">
                                {{ totalGuitars }}
                            </div>
                            <div class="text-gray-400">Total Guitars</div>
                        </div>
                    </div>
                </v-card>
            </div>

            <h2 class="text-lg font-semibold text-white mb-4">Quick Actions</h2>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <v-card
                    class="pa-6 cursor-pointer hover:border-primary transition-colors"
                    @click="navigateTo('/admin/links')"
                >
                    <div class="flex items-center gap-4">
                        <IconifyIcon
                            icon="mdi:link-plus"
                            class="text-3xl text-primary"
                        />
                        <div>
                            <div class="font-semibold">Manage Links</div>
                            <div class="text-sm text-gray-400">
                                Add and remove purchase links
                            </div>
                        </div>
                    </div>
                </v-card>

                <v-card
                    class="pa-6 cursor-pointer hover:border-primary transition-colors"
                    @click="navigateTo('/admin/guitars')"
                >
                    <div class="flex items-center gap-4">
                        <IconifyIcon
                            icon="mdi:music-box-multiple"
                            class="text-3xl text-secondary"
                        />
                        <div>
                            <div class="font-semibold">Browse Guitars</div>
                            <div class="text-sm text-gray-400">
                                View and search all guitars
                            </div>
                        </div>
                    </div>
                </v-card>
            </div>
        </main>
    </div>
</template>

<script setup lang="ts">
definePageMeta({
    middleware: ["auth"],
    layout: "admin",
});

const { logout } = useAdminAuth();
const config = useRuntimeConfig();

const API_BASE = config.public.apiUrl;

const totalLinks = ref(0);
const totalGuitars = ref(0);

const fetchStats = async () => {
    try {
        const guitarsRes = await $fetch<{ guitars: any[]; total: number }>(
            `${baseURL}/guitars?limit=1`,
            {
                credentials: "include",
            },
        );
        totalGuitars.value = guitarsRes.total;
    } catch (e) {
        console.error("Failed to fetch stats", e);
    }
};

const handleLogout = async () => {
    await logout();
};

onMounted(() => {
    fetchStats();
});
</script>
