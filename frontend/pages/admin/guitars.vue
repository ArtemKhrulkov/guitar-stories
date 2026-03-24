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
                    <h1 class="text-xl font-bold text-white">Browse Guitars</h1>
                </div>
            </div>
        </header>

        <main class="max-w-7xl mx-auto px-4 py-8">
            <v-text-field
                v-model="search"
                label="Search guitars by name or model"
                variant="outlined"
                prepend-inner-icon="mdi:magnify"
                class="mb-6"
                @update:model-value="debouncedSearch"
            />

            <div v-if="isLoading" class="text-center py-12">
                <v-progress-circular indeterminate color="primary" size="64" />
            </div>

            <div
                v-else-if="guitars.length === 0"
                class="text-center py-12 text-gray-400"
            >
                No guitars found. Try a different search term.
            </div>

            <div
                v-else
                class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6"
            >
                <v-card
                    v-for="guitar in guitars"
                    :key="guitar.id"
                    class="cursor-pointer"
                    @click="toggleExpanded(guitar.id)"
                >
                    <div class="relative">
                        <v-img
                            :src="
                                guitar.image_url ||
                                'https://via.placeholder.com/400x300?text=No+Image'
                            "
                            height="200"
                            cover
                            class="bg-gray-700"
                        />
                        <v-btn
                            icon="mdi:pencil"
                            size="small"
                            color="primary"
                            class="absolute top-2 right-2"
                            style="background: rgba(0, 0, 0, 0.5)"
                            @click.stop="showEditDialog(guitar)"
                        />
                    </div>

                    <v-card-title>
                        {{ guitar.brand?.name }} {{ guitar.model }}
                    </v-card-title>

                    <v-card-subtitle>
                        <v-chip size="small" class="mr-2">
                            {{ guitar.guitar_type }}
                        </v-chip>
                        <span v-if="guitar.price_range" class="text-gray-400">
                            {{ guitar.price_range.split(" / ")[0] }}
                        </span>
                    </v-card-subtitle>

                    <v-expand-transition>
                        <div v-if="expandedId === guitar.id" class="px-4 pb-4">
                            <v-divider class="my-3" />

                            <div class="flex items-center justify-between mb-2">
                                <span class="font-semibold"
                                    >Purchase Links</span
                                >
                                <div class="flex gap-2">
                                    <v-btn
                                        size="small"
                                        color="secondary"
                                        variant="tonal"
                                        @click.stop="showEditDialog(guitar)"
                                    >
                                        <IconifyIcon
                                            icon="mdi:pencil"
                                            class="mr-1"
                                        />
                                        Edit
                                    </v-btn>
                                    <v-btn
                                        size="small"
                                        color="primary"
                                        variant="tonal"
                                        @click.stop="showAddLinkDialog(guitar)"
                                    >
                                        <IconifyIcon
                                            icon="mdi:plus"
                                            class="mr-1"
                                        />
                                        Add Link
                                    </v-btn>
                                </div>
                            </div>

                            <div
                                v-if="guitarLinks[guitar.id]?.length === 0"
                                class="text-gray-400 text-sm"
                            >
                                No links yet
                            </div>

                            <div v-else class="space-y-2">
                                <div
                                    v-for="link in guitarLinks[guitar.id]"
                                    :key="link.id"
                                    class="flex items-center justify-between bg-gray-700 rounded px-3 py-2"
                                >
                                    <div class="flex items-center gap-2">
                                        <v-chip
                                            size="x-small"
                                            :color="
                                                getPlatformColor(link.platform)
                                            "
                                        >
                                            {{ link.platform }}
                                        </v-chip>
                                        <a
                                            :href="link.url"
                                            target="_blank"
                                            class="text-primary text-sm hover:underline"
                                        >
                                            {{ truncateUrl(link.url) }}
                                        </a>
                                    </div>
                                    <v-btn
                                        icon="mdi:delete"
                                        size="x-small"
                                        color="error"
                                        variant="text"
                                        @click.stop="handleDeleteLink(link.id)"
                                    />
                                </div>
                            </div>
                        </div>
                    </v-expand-transition>
                </v-card>
            </div>

            <div v-if="guitars.length > 0" class="mt-6 flex justify-center">
                <v-pagination
                    v-model="page"
                    :length="totalPages"
                    :total-visible="7"
                    @update:model-value="fetchGuitars"
                />
            </div>
        </main>

        <!-- Edit Guitar Dialog -->
        <v-dialog v-model="editDialog.show" max-width="600">
            <v-card>
                <v-card-title>Edit Guitar</v-card-title>
                <v-card-text>
                    <v-form ref="editForm">
                        <v-text-field
                            v-model="editDialog.data.model"
                            label="Model"
                            variant="outlined"
                            class="mb-4"
                        />

                        <v-text-field
                            v-model="editDialog.data.image_url"
                            label="Image URL"
                            variant="outlined"
                            class="mb-4"
                            @update:model-value="updateImagePreview"
                        />

                        <v-img
                            v-if="editDialog.data.image_url"
                            :src="editDialog.data.image_url"
                            height="150"
                            cover
                            class="bg-gray-700 rounded mb-4"
                        />

                        <v-select
                            v-model="editDialog.data.guitar_type"
                            :items="guitarTypes"
                            item-title="label"
                            item-value="value"
                            label="Guitar Type"
                            variant="outlined"
                            class="mb-4"
                        />

                        <v-label class="mb-2">Specifications (JSON)</v-label>
                        <v-textarea
                            v-model="editDialog.data.specifications"
                            label="Specifications"
                            variant="outlined"
                            rows="6"
                            placeholder='{"body_wood": "Mahogany", "neck_wood": "Maple"}'
                            hint="Enter as JSON object"
                            persistent-hint
                        />
                    </v-form>
                </v-card-text>
                <v-card-actions>
                    <v-spacer />
                    <v-btn @click="editDialog.show = false">Cancel</v-btn>
                    <v-btn
                        color="primary"
                        :loading="editDialog.loading"
                        @click="handleUpdateGuitar"
                    >
                        Save
                    </v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <!-- Add Link Dialog -->
        <v-dialog v-model="addLinkDialog.show" max-width="500">
            <v-card>
                <v-card-title
                    >Add Link to {{ addLinkDialog.guitar?.model }}</v-card-title
                >
                <v-card-text>
                    <v-select
                        v-model="addLinkDialog.data.platform"
                        :items="platforms"
                        item-title="label"
                        item-value="value"
                        label="Platform"
                        variant="outlined"
                        class="mb-4"
                    />

                    <v-text-field
                        v-model="addLinkDialog.data.url"
                        label="URL"
                        variant="outlined"
                        placeholder="https://..."
                        class="mb-4"
                    />

                    <div class="grid grid-cols-2 gap-4 mb-4">
                        <v-text-field
                            v-model.number="addLinkDialog.data.price_rub"
                            label="Price (RUB)"
                            variant="outlined"
                            type="number"
                        />
                        <v-text-field
                            v-model.number="addLinkDialog.data.price_usd"
                            label="Price (USD)"
                            variant="outlined"
                            type="number"
                        />
                    </div>

                    <v-switch
                        v-model="addLinkDialog.data.in_stock"
                        label="In Stock"
                        color="success"
                    />
                </v-card-text>
                <v-card-actions>
                    <v-spacer />
                    <v-btn @click="addLinkDialog.show = false">Cancel</v-btn>
                    <v-btn
                        color="primary"
                        :loading="addLinkDialog.loading"
                        @click="handleAddLink"
                    >
                        Add
                    </v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <v-snackbar v-model="snackbar.show" :color="snackbar.color">
            {{ snackbar.message }}
        </v-snackbar>
    </div>
</template>

<script setup lang="ts">
import type {
    Guitar,
    PurchaseLink,
    LinkInput,
    GuitarUpdate,
} from "~/composables/useAdminLinks";

definePageMeta({
    middleware: ["auth"],
    layout: "admin",
});

const config = useRuntimeConfig();
const API_BASE = config.public.apiUrl;

const { addLink, deleteLink, updateGuitar } = useAdminLinks();

const search = ref("");
const page = ref(1);
const limit = ref(12);
const isLoading = ref(false);
const guitars = ref<Guitar[]>([]);
const totalPages = ref(1);
const expandedId = ref<string | null>(null);
const guitarLinks = ref<Record<string, PurchaseLink[]>>({});

const platforms = [
    { label: "Ozon", value: "ozon" },
    { label: "Wildberries", value: "wildberries" },
    { label: "Sweetwater", value: "sweetwater" },
    { label: "Guitar Center", value: "guitarcenter" },
];

const guitarTypes = [
    { label: "Electric", value: "electric" },
    { label: "Acoustic", value: "acoustic" },
    { label: "Bass", value: "bass" },
];

const editDialog = ref<{
    show: boolean;
    guitar: Guitar | null;
    loading: boolean;
    data: {
        model: string;
        image_url: string;
        guitar_type: string;
        specifications: string;
    };
}>({
    show: false,
    guitar: null,
    loading: false,
    data: {
        model: "",
        image_url: "",
        guitar_type: "electric",
        specifications: "{}",
    },
});

const addLinkDialog = ref<{
    show: boolean;
    guitar: Guitar | null;
    loading: boolean;
    data: LinkInput;
}>({
    show: false,
    guitar: null,
    loading: false,
    data: {
        guitar_id: "",
        platform: "ozon",
        url: "",
        price_rub: undefined,
        price_usd: undefined,
        in_stock: true,
    },
});

const snackbar = ref({
    show: false,
    message: "",
    color: "success",
});

let searchTimeout: NodeJS.Timeout;
const debouncedSearch = () => {
    clearTimeout(searchTimeout);
    searchTimeout = setTimeout(() => {
        page.value = 1;
        fetchGuitars();
    }, 300);
};

const fetchGuitars = async () => {
    isLoading.value = true;
    try {
        const params = new URLSearchParams({
            page: page.value.toString(),
            limit: limit.value.toString(),
        });
        if (search.value) {
            params.set("search", search.value);
        }

        const response = await $fetch<{ guitars: Guitar[]; total: number }>(
            `${API_BASE}/guitars?${params}`,
            { credentials: "include" },
        );

        guitars.value = response.guitars;
        totalPages.value = Math.ceil(response.total / limit.value);
    } catch (e) {
        console.error("Failed to fetch guitars", e);
    } finally {
        isLoading.value = false;
    }
};

const toggleExpanded = async (guitarId: string) => {
    if (expandedId.value === guitarId) {
        expandedId.value = null;
        return;
    }

    expandedId.value = guitarId;

    if (!guitarLinks.value[guitarId]) {
        try {
            const response = await $fetch<{ purchase_links: PurchaseLink[] }>(
                `${API_BASE}/guitars/${guitarId}`,
                { credentials: "include" },
            );
            guitarLinks.value[guitarId] = response.purchase_links || [];
        } catch (e) {
            guitarLinks.value[guitarId] = [];
        }
    }
};

const showEditDialog = (guitar: Guitar) => {
    let specsStr = "{}";
    if (guitar.specifications) {
        specsStr = JSON.stringify(guitar.specifications, null, 2);
    }

    editDialog.value = {
        show: true,
        guitar,
        loading: false,
        data: {
            model: guitar.model,
            image_url: guitar.image_url || "",
            guitar_type: guitar.guitar_type,
            specifications: specsStr,
        },
    };
};

const updateImagePreview = () => {};

const handleUpdateGuitar = async () => {
    if (!editDialog.value.guitar) return;

    editDialog.value.loading = true;
    try {
        let specs: Record<string, any> | undefined;
        if (editDialog.value.data.specifications) {
            try {
                specs = JSON.parse(editDialog.value.data.specifications);
            } catch {
                snackbar.value = {
                    show: true,
                    message: "Invalid JSON in specifications",
                    color: "error",
                };
                editDialog.value.loading = false;
                return;
            }
        }

        const updateData: GuitarUpdate = {};
        if (editDialog.value.data.model !== editDialog.value.guitar?.model) {
            updateData.model = editDialog.value.data.model;
        }
        if (
            editDialog.value.data.image_url !==
            (editDialog.value.guitar?.image_url || "")
        ) {
            updateData.image_url = editDialog.value.data.image_url;
        }
        if (
            editDialog.value.data.guitar_type !==
            editDialog.value.guitar?.guitar_type
        ) {
            updateData.guitar_type = editDialog.value.data.guitar_type as
                | "electric"
                | "acoustic"
                | "bass";
        }
        if (specs) {
            updateData.specifications = specs;
        }

        await updateGuitar(editDialog.value.guitar.id, updateData);

        snackbar.value = {
            show: true,
            message: "Guitar updated successfully",
            color: "success",
        };

        editDialog.value.show = false;
        fetchGuitars();
    } catch (e: any) {
        snackbar.value = {
            show: true,
            message: e.data?.error || "Failed to update guitar",
            color: "error",
        };
    } finally {
        editDialog.value.loading = false;
    }
};

const showAddLinkDialog = (guitar: Guitar) => {
    addLinkDialog.value = {
        show: true,
        guitar,
        loading: false,
        data: {
            guitar_id: guitar.id,
            platform: "ozon",
            url: "",
            price_rub: undefined,
            price_usd: undefined,
            in_stock: true,
        },
    };
};

const handleAddLink = async () => {
    if (!addLinkDialog.value.guitar) return;

    addLinkDialog.value.loading = true;
    try {
        await addLink(addLinkDialog.value.data);

        snackbar.value = {
            show: true,
            message: "Link added successfully",
            color: "success",
        };

        guitarLinks.value[addLinkDialog.value.guitar.id] = [];

        addLinkDialog.value.show = false;
    } catch (e: any) {
        snackbar.value = {
            show: true,
            message: e.data?.error || "Failed to add link",
            color: "error",
        };
    } finally {
        addLinkDialog.value.loading = false;
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

        for (const guitarId in guitarLinks.value) {
            guitarLinks.value[guitarId] = guitarLinks.value[guitarId].filter(
                (l) => l.id !== linkId,
            );
        }
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
    if (url.length > 40) {
        return url.substring(0, 40) + "...";
    }
    return url;
};

onMounted(() => {
    fetchGuitars();
});
</script>
