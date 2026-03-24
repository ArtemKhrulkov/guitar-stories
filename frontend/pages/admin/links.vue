<template>
    <div class="min-h-screen bg-gray-900">
        <header class="bg-gray-800 border-b border-gray-700">
            <div
                class="max-w-7xl mx-auto px-4 py-4 flex justify-between items-center"
            >
                <div class="flex items-center gap-4">
                    <v-btn variant="text" @click="navigateTo('/admin')">
                        <IconifyIcon icon="mdi:arrow-left" class="mr-2" />
                        Back
                    </v-btn>
                    <h1 class="text-xl font-bold text-white">Manage Links</h1>
                </div>
            </div>
        </header>

        <main class="max-w-7xl mx-auto px-4 py-8">
            <v-card class="pa-6 mb-6">
                <h2 class="text-lg font-semibold mb-4">Add New Link</h2>

                <v-form @submit.prevent="handleAddLink">
                    <v-autocomplete
                        v-model="selectedGuitar"
                        :items="guitars"
                        item-title="displayName"
                        item-value="id"
                        label="Search Guitar"
                        variant="outlined"
                        :search-input="searchQuery"
                        :loading="isSearching"
                        return-object
                        class="mb-4"
                        @update:search-input="debouncedSearch"
                    >
                        <template v-slot:item="{ props, item }">
                            <v-list-item
                                v-bind="props"
                                :title="item.raw.brand?.name"
                                :subtitle="item.raw.model"
                            />
                        </template>
                    </v-autocomplete>

                    <v-select
                        v-model="newLink.platform"
                        :items="platforms"
                        item-title="label"
                        item-value="value"
                        label="Platform"
                        variant="outlined"
                        class="mb-4"
                    />

                    <v-text-field
                        v-model="newLink.url"
                        label="URL"
                        variant="outlined"
                        placeholder="https://..."
                        :error-messages="urlError"
                        class="mb-4"
                    />

                    <div class="grid grid-cols-2 gap-4 mb-4">
                        <v-text-field
                            v-model.number="newLink.price_rub"
                            label="Price (RUB)"
                            variant="outlined"
                            type="number"
                        />
                        <v-text-field
                            v-model.number="newLink.price_usd"
                            label="Price (USD)"
                            variant="outlined"
                            type="number"
                        />
                    </div>

                    <v-switch
                        v-model="newLink.in_stock"
                        label="In Stock"
                        color="success"
                        class="mb-4"
                    />

                    <v-btn
                        type="submit"
                        color="primary"
                        :loading="isAdding"
                        :disabled="!canAddLink"
                    >
                        Add Link
                    </v-btn>
                </v-form>
            </v-card>

            <v-card class="pa-6">
                <h2 class="text-lg font-semibold mb-4">Existing Links</h2>

                <v-text-field
                    v-model="linkSearch"
                    label="Search by guitar name"
                    variant="outlined"
                    prepend-inner-icon="mdi:magnify"
                    class="mb-4"
                    @update:model-value="debouncedLinkSearch"
                />

                <div v-if="isLoading" class="text-center py-8">
                    <v-progress-circular indeterminate color="primary" />
                </div>

                <div
                    v-else-if="guitarsWithLinks.length === 0"
                    class="text-center py-8 text-gray-400"
                >
                    No links found. Search for a guitar above to add links.
                </div>

                <div v-else>
                    <div
                        v-for="guitar in guitarsWithLinks"
                        :key="guitar.id"
                        class="mb-6"
                    >
                        <div class="flex items-center gap-2 mb-2">
                            <span class="font-semibold">{{
                                guitar.brand?.name
                            }}</span>
                            <span class="text-gray-400">{{
                                guitar.model
                            }}</span>
                        </div>

                        <v-table density="compact" class="bg-gray-800">
                            <thead>
                                <tr>
                                    <th>Platform</th>
                                    <th>URL</th>
                                    <th>Price</th>
                                    <th>Stock</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="link in guitar.links" :key="link.id">
                                    <td>
                                        <v-chip
                                            size="small"
                                            :color="
                                                getPlatformColor(link.platform)
                                            "
                                        >
                                            {{ link.platform }}
                                        </v-chip>
                                    </td>
                                    <td>
                                        <a
                                            :href="link.url"
                                            target="_blank"
                                            class="text-primary hover:underline"
                                        >
                                            {{ truncateUrl(link.url) }}
                                        </a>
                                    </td>
                                    <td>
                                        <span v-if="link.price_rub"
                                            >{{
                                                formatPrice(link.price_rub)
                                            }}
                                            RUB</span
                                        >
                                        <span
                                            v-if="link.price_usd"
                                            class="ml-2 text-gray-400"
                                            >({{
                                                formatPrice(link.price_usd)
                                            }}
                                            USD)</span
                                        >
                                    </td>
                                    <td>
                                        <v-icon
                                            :color="
                                                link.in_stock
                                                    ? 'success'
                                                    : 'error'
                                            "
                                            size="small"
                                        >
                                            {{
                                                link.in_stock
                                                    ? "mdi:check-circle"
                                                    : "mdi:close-circle"
                                            }}
                                        </v-icon>
                                    </td>
                                    <td>
                                        <v-btn
                                            icon="mdi:delete"
                                            size="small"
                                            color="error"
                                            variant="text"
                                            @click="handleDeleteLink(link.id)"
                                        />
                                    </td>
                                </tr>
                            </tbody>
                        </v-table>
                    </div>
                </div>
            </v-card>

            <v-snackbar v-model="snackbar.show" :color="snackbar.color">
                {{ snackbar.message }}
            </v-snackbar>
        </main>
    </div>
</template>

<script setup lang="ts">
import type {
    Guitar,
    PurchaseLink,
    LinkInput,
} from "~/composables/useAdminLinks";

definePageMeta({
    middleware: ["auth"],
    layout: "admin",
});

interface GuitarWithLinks extends Guitar {
    links: PurchaseLink[];
}
const config = useRuntimeConfig();
const API_BASE = config.public.apiUrl;

const { searchGuitars, addLink, deleteLink } = useAdminLinks();

const guitars = ref<Guitar[]>([]);
const selectedGuitar = ref<Guitar | null>(null);
const searchQuery = ref("");
const isSearching = ref(false);

const platforms = [
    { label: "Ozon", value: "ozon" },
    { label: "Wildberries", value: "wildberries" },
    { label: "Sweetwater", value: "sweetwater" },
    { label: "Guitar Center", value: "guitarcenter" },
];

const newLink = ref<LinkInput>({
    guitar_id: "",
    platform: "ozon",
    url: "",
    price_rub: undefined,
    price_usd: undefined,
    in_stock: true,
});

const urlError = ref("");
const isAdding = ref(false);

const linkSearch = ref("");
const isLoading = ref(false);
const guitarsWithLinks = ref<GuitarWithLinks[]>([]);

const snackbar = ref({
    show: false,
    message: "",
    color: "success",
});

let searchTimeout: NodeJS.Timeout;
const debouncedSearch = (value: string | null) => {
    clearTimeout(searchTimeout);
    searchTimeout = setTimeout(() => {
        if (value && value.length >= 2) {
            isSearching.value = true;
            searchGuitars(value).then(() => {
                guitars.value = useState<Guitar[]>("admin-guitars").value;
                isSearching.value = false;
            });
        } else {
            guitars.value = [];
        }
    }, 300);
};

let linkSearchTimeout: NodeJS.Timeout;
const debouncedLinkSearch = (value: string | null) => {
    clearTimeout(linkSearchTimeout);
    linkSearchTimeout = setTimeout(() => {
        fetchLinksWithGuitars(value || "");
    }, 300);
};

const fetchLinksWithGuitars = async (search?: string) => {
    isLoading.value = true;
    try {
        const url = search
            ? `${API_BASE}/guitars?search=${encodeURIComponent(search)}&limit=50`
            : `${API_BASE}/guitars?limit=50`;

        const response = await $fetch<{ guitars: Guitar[] }>(url, {
            credentials: "include",
        });

        const guitarsWithData: GuitarWithLinks[] = [];

        for (const guitar of response.guitars) {
            try {
                const detail = await $fetch<{ purchase_links: PurchaseLink[] }>(
                    `${API_BASE}/guitars/${guitar.id}`,
                    { credentials: "include" },
                );
                if (detail.purchase_links && detail.purchase_links.length > 0) {
                    guitarsWithData.push({
                        ...guitar,
                        links: detail.purchase_links,
                    });
                }
            } catch (e) {
                // Guitar detail fetch failed, skip
            }
        }

        guitarsWithLinks.value = guitarsWithData;
    } catch (e) {
        console.error("Failed to fetch links", e);
    } finally {
        isLoading.value = false;
    }
};

const canAddLink = computed(() => {
    return selectedGuitar.value && newLink.value.url;
});

const handleAddLink = async () => {
    urlError.value = "";

    if (
        !newLink.value.url.startsWith("http://") &&
        !newLink.value.url.startsWith("https://")
    ) {
        urlError.value = "URL must start with http:// or https://";
        return;
    }

    if (!selectedGuitar.value) return;

    isAdding.value = true;
    try {
        await addLink({
            guitar_id: selectedGuitar.value.id,
            platform: newLink.value.platform,
            url: newLink.value.url,
            price_rub: newLink.value.price_rub,
            price_usd: newLink.value.price_usd,
            in_stock: newLink.value.in_stock,
        });

        snackbar.value = {
            show: true,
            message: "Link added successfully",
            color: "success",
        };

        selectedGuitar.value = null;
        newLink.value = {
            guitar_id: "",
            platform: "ozon",
            url: "",
            price_rub: undefined,
            price_usd: undefined,
            in_stock: true,
        };
        guitars.value = [];

        fetchLinksWithGuitars(linkSearch.value);
    } catch (e: any) {
        snackbar.value = {
            show: true,
            message: e.data?.error || "Failed to add link",
            color: "error",
        };
    } finally {
        isAdding.value = false;
    }
};

const handleDeleteLink = async (linkId: string) => {
    try {
        await deleteLink(linkId);
        snackbar.value = {
            show: true,
            message: "Link deleted successfully",
            color: "success",
        };
        fetchLinksWithGuitars(linkSearch.value);
    } catch (e: any) {
        snackbar.value = {
            show: true,
            message: e.data?.error || "Failed to delete link",
            color: "error",
        };
    }
};

const getPlatformColor = (platform: string) => {
    const colors: Record<string, string> = {
        ozon: "blue",
        wildberries: "purple",
        sweetwater: "green",
        guitarcenter: "orange",
    };
    return colors[platform] || "grey";
};

const truncateUrl = (url: string) => {
    if (url.length > 50) {
        return url.substring(0, 50) + "...";
    }
    return url;
};

const formatPrice = (price: number) => {
    return new Intl.NumberFormat("ru-RU").format(price);
};

onMounted(() => {
    fetchLinksWithGuitars();
});
</script>
