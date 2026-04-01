<template>
  <div class="min-h-screen bg-gray-900">
    <header class="bg-gray-800 border-b border-gray-700">
      <div class="max-w-7xl mx-auto px-4 py-4 flex justify-between items-center">
        <div class="flex items-center gap-4">
          <v-btn variant="text" @click="navigateTo('/admin')">
            <IconifyIcon icon="mdi:arrow-left" class="mr-2" />
            Back
          </v-btn>
          <h1 class="text-xl font-bold text-white">Manage Brands</h1>
        </div>
        <v-btn color="primary" @click="showCreateDialog">
          <IconifyIcon icon="mdi:plus" class="mr-2" />
          Create Brand
        </v-btn>
      </div>
    </header>

    <main class="max-w-7xl mx-auto px-4 py-8">
      <div v-if="isLoading" class="text-center py-12">
        <v-progress-circular indeterminate color="primary" size="64" />
      </div>

      <div v-else-if="brands.length === 0" class="text-center py-12 text-gray-400">
        No brands found. Create your first brand to get started.
      </div>

      <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <v-card v-for="brand in brands" :key="brand.id" class="brand-card">
          <div class="relative">
            <v-img
              v-if="brand.logo_url"
              :src="brand.logo_url"
              height="120"
              contain
              class="bg-white"
            />
            <div v-else class="h-24 bg-gray-700 d-flex align-center justify-center">
              <IconifyIcon icon="mdi:factory" size="48" color="grey" />
            </div>
            <v-btn
              icon="mdi-pencil"
              size="small"
              color="primary"
              class="absolute top-2 right-2"
              style="background: rgba(0, 0, 0, 0.5)"
              @click="showEditDialog(brand)"
            />
          </div>

          <v-card-title>{{ brand.name }}</v-card-title>
          <v-card-subtitle>
            <v-chip size="small" class="mr-2">{{ brand.country }}</v-chip>
            <span v-if="brand.founded_year" class="text-gray-400">{{ brand.founded_year }}</span>
          </v-card-subtitle>

          <v-card-text v-if="brand.description" class="text-gray-300 text-sm">
            {{ truncateText(brand.description, 100) }}
          </v-card-text>

          <v-card-actions>
            <v-spacer />
            <v-btn
              variant="text"
              color="error"
              size="small"
              @click="confirmDelete(brand)"
            >
              <IconifyIcon icon="mdi:delete" class="mr-1" />
              Delete
            </v-btn>
          </v-card-actions>
        </v-card>
      </div>
    </main>

    <v-dialog v-model="createDialog.show" max-width="600">
      <v-card>
        <v-card-title>Create New Brand</v-card-title>
        <v-card-text>
          <v-form ref="createForm">
            <v-text-field
              v-model="createDialog.data.name"
              label="Brand Name"
              variant="outlined"
              class="mb-4"
            />
            <v-text-field
              v-model="createDialog.data.country"
              label="Country"
              variant="outlined"
              placeholder="e.g., USA, Japan, Korea"
              class="mb-4"
            />
            <v-text-field
              v-model.number="createDialog.data.founded_year"
              label="Founded Year"
              variant="outlined"
              type="number"
              class="mb-4"
            />
            <v-textarea
              v-model="createDialog.data.description"
              label="Description"
              variant="outlined"
              rows="3"
              class="mb-4"
            />
            <v-text-field
              v-model="createDialog.data.logo_url"
              label="Logo URL"
              variant="outlined"
              class="mb-4"
            />
            <v-img
              v-if="createDialog.data.logo_url"
              :src="createDialog.data.logo_url"
              height="100"
              contain
              class="bg-gray-700 rounded"
            />
          </v-form>
        </v-card-text>
        <v-card-actions>
          <v-spacer />
          <v-btn @click="createDialog.show = false">Cancel</v-btn>
          <v-btn color="primary" :loading="createDialog.loading" @click="handleCreate">
            Create
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <v-dialog v-model="editDialog.show" max-width="600">
      <v-card>
        <v-card-title>Edit Brand</v-card-title>
        <v-card-text>
          <v-form ref="editForm">
            <v-text-field
              v-model="editDialog.data.name"
              label="Brand Name"
              variant="outlined"
              class="mb-4"
            />
            <v-text-field
              v-model="editDialog.data.country"
              label="Country"
              variant="outlined"
              class="mb-4"
            />
            <v-text-field
              v-model.number="editDialog.data.founded_year"
              label="Founded Year"
              variant="outlined"
              type="number"
              class="mb-4"
            />
            <v-textarea
              v-model="editDialog.data.description"
              label="Description"
              variant="outlined"
              rows="3"
              class="mb-4"
            />
            <v-text-field
              v-model="editDialog.data.logo_url"
              label="Logo URL"
              variant="outlined"
              class="mb-4"
            />
            <v-img
              v-if="editDialog.data.logo_url"
              :src="editDialog.data.logo_url"
              height="100"
              contain
              class="bg-gray-700 rounded"
            />
          </v-form>
        </v-card-text>
        <v-card-actions>
          <v-spacer />
          <v-btn @click="editDialog.show = false">Cancel</v-btn>
          <v-btn color="primary" :loading="editDialog.loading" @click="handleUpdate">
            Save
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <v-dialog v-model="deleteDialog.show" max-width="400">
      <v-card>
        <v-card-title>Delete Brand</v-card-title>
        <v-card-text>
          Are you sure you want to delete <strong>{{ deleteDialog.brand?.name }}</strong>?
          This action cannot be undone.
        </v-card-text>
        <v-card-actions>
          <v-spacer />
          <v-btn @click="deleteDialog.show = false">Cancel</v-btn>
          <v-btn color="error" :loading="deleteDialog.loading" @click="handleDelete">
            Delete
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
import type { Brand } from '~/types';
import type { BrandInput, BrandUpdate } from '~/composables/useAdminBrands';
import { useAdminBrands } from '~/composables/useAdminBrands';

definePageMeta({
  middleware: ['auth'],
  layout: 'admin',
});

const { brands, isLoading, fetchBrands, createBrand, updateBrand, deleteBrand } = useAdminBrands();

const createDialog = ref<{
  show: boolean;
  loading: boolean;
  data: BrandInput;
}>({
  show: false,
  loading: false,
  data: {
    name: '',
    country: '',
    founded_year: undefined,
    description: '',
    logo_url: '',
  },
});

const editDialog = ref<{
  show: boolean;
  loading: boolean;
  brand: Brand | null;
  data: BrandInput;
}>({
  show: false,
  loading: false,
  brand: null,
  data: {
    name: '',
    country: '',
    founded_year: undefined,
    description: '',
    logo_url: '',
  },
});

const deleteDialog = ref<{
  show: boolean;
  loading: boolean;
  brand: Brand | null;
}>({
  show: false,
  loading: false,
  brand: null,
});

const snackbar = ref({
  show: false,
  message: '',
  color: 'success',
});

const showCreateDialog = () => {
  createDialog.value = {
    show: true,
    loading: false,
    data: {
      name: '',
      country: '',
      founded_year: undefined,
      description: '',
      logo_url: '',
    },
  };
};

const showEditDialog = (brand: Brand) => {
  editDialog.value = {
    show: true,
    loading: false,
    brand,
    data: {
      name: brand.name,
      country: brand.country,
      founded_year: brand.founded_year,
      description: brand.description || '',
      logo_url: brand.logo_url || '',
    },
  };
};

const confirmDelete = (brand: Brand) => {
  deleteDialog.value = {
    show: true,
    loading: false,
    brand,
  };
};

const handleCreate = async () => {
  createDialog.value.loading = true;
  try {
    await createBrand(createDialog.value.data);
    snackbar.value = {
      show: true,
      message: 'Brand created successfully',
      color: 'success',
    };
    createDialog.value.show = false;
    fetchBrands();
  } catch (err: unknown) {
    const e = err as { data?: { error?: string } };
    snackbar.value = {
      show: true,
      message: e.data?.error || 'Failed to create brand',
      color: 'error',
    };
  } finally {
    createDialog.value.loading = false;
  }
};

const handleUpdate = async () => {
  if (!editDialog.value.brand) return;

  editDialog.value.loading = true;
  try {
    const data: BrandUpdate = {};
    if (editDialog.value.data.name !== editDialog.value.brand.name) {
      data.name = editDialog.value.data.name;
    }
    if (editDialog.value.data.country !== editDialog.value.brand.country) {
      data.country = editDialog.value.data.country;
    }
    if (editDialog.value.data.founded_year !== editDialog.value.brand.founded_year) {
      data.founded_year = editDialog.value.data.founded_year;
    }
    if (editDialog.value.data.description !== (editDialog.value.brand.description || '')) {
      data.description = editDialog.value.data.description;
    }
    if (editDialog.value.data.logo_url !== (editDialog.value.brand.logo_url || '')) {
      data.logo_url = editDialog.value.data.logo_url;
    }

    await updateBrand(editDialog.value.brand.id, data);
    snackbar.value = {
      show: true,
      message: 'Brand updated successfully',
      color: 'success',
    };
    editDialog.value.show = false;
    fetchBrands();
  } catch (err: unknown) {
    const e = err as { data?: { error?: string } };
    snackbar.value = {
      show: true,
      message: e.data?.error || 'Failed to update brand',
      color: 'error',
    };
  } finally {
    editDialog.value.loading = false;
  }
};

const handleDelete = async () => {
  if (!deleteDialog.value.brand) return;

  deleteDialog.value.loading = true;
  try {
    await deleteBrand(deleteDialog.value.brand.id);
    snackbar.value = {
      show: true,
      message: 'Brand deleted successfully',
      color: 'success',
    };
    deleteDialog.value.show = false;
    fetchBrands();
  } catch (err: unknown) {
    const e = err as { data?: { error?: string } };
    snackbar.value = {
      show: true,
      message: e.data?.error || 'Failed to delete brand',
      color: 'error',
    };
  } finally {
    deleteDialog.value.loading = false;
  }
};

const truncateText = (text: string, maxLength: number) => {
  if (text.length <= maxLength) return text;
  return text.substring(0, maxLength) + '...';
};

onMounted(() => {
  fetchBrands();
});
</script>

<style scoped>
.brand-card {
  transition: transform 0.2s;
}

.brand-card:hover {
  transform: translateY(-4px);
}
</style>
