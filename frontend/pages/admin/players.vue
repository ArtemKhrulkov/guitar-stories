<template>
  <div class="min-h-screen bg-gray-900">
    <header class="bg-gray-800 border-b border-gray-700">
      <div class="max-w-7xl mx-auto px-4 py-4 flex justify-between items-center">
        <div class="flex items-center gap-4">
          <v-btn variant="text" @click="navigateTo('/admin')">
            <IconifyIcon icon="mdi:arrow-left" class="mr-2" />
            Back
          </v-btn>
          <h1 class="text-xl font-bold text-white">Manage Players</h1>
        </div>
        <v-btn color="primary" @click="showCreateDialog">
          <IconifyIcon icon="mdi:plus" class="mr-2" />
          Create Player
        </v-btn>
      </div>
    </header>

    <main class="max-w-7xl mx-auto px-4 py-8">
      <div v-if="isLoading" class="text-center py-12">
        <v-progress-circular indeterminate color="primary" size="64" />
      </div>

      <div v-else-if="players.length === 0" class="text-center py-12 text-gray-400">
        No players found. Create your first player to get started.
      </div>

      <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <v-card v-for="player in players" :key="player.id" class="player-card">
          <div class="relative">
            <v-img
              v-if="player.image_url"
              :src="player.image_url"
              height="200"
              cover
              class="bg-gray-700"
            />
            <div v-else class="h-48 bg-gray-700 d-flex align-center justify-center">
              <IconifyIcon icon="mdi:account" size="64" color="grey" />
            </div>
            <v-btn
              icon="mdi-pencil"
              size="small"
              color="primary"
              class="absolute top-2 right-2"
              style="background: rgba(0, 0, 0, 0.5)"
              @click="showEditDialog(player)"
            />
          </div>

          <v-card-title>{{ player.name }}</v-card-title>
          <v-card-subtitle v-if="player.genre">
            <v-chip size="small" color="secondary">{{ player.genre }}</v-chip>
          </v-card-subtitle>

          <v-card-text v-if="player.bio" class="text-gray-300 text-sm">
            {{ truncateText(player.bio, 100) }}
          </v-card-text>

          <v-card-actions>
            <v-spacer />
            <v-btn
              variant="text"
              color="error"
              size="small"
              @click="confirmDelete(player)"
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
        <v-card-title>Create New Player</v-card-title>
        <v-card-text>
          <v-form ref="createForm">
            <v-text-field
              v-model="createDialog.data.name"
              label="Player Name"
              variant="outlined"
              class="mb-4"
            />
            <v-text-field
              v-model="createDialog.data.genre"
              label="Genre"
              variant="outlined"
              placeholder="e.g., Rock, Jazz, Metal"
              class="mb-4"
            />
            <v-textarea
              v-model="createDialog.data.bio"
              label="Biography"
              variant="outlined"
              rows="4"
              class="mb-4"
            />
            <v-text-field
              v-model="createDialog.data.image_url"
              label="Image URL"
              variant="outlined"
              class="mb-4"
            />
            <v-img
              v-if="createDialog.data.image_url"
              :src="createDialog.data.image_url"
              height="150"
              cover
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
        <v-card-title>Edit Player</v-card-title>
        <v-card-text>
          <v-form ref="editForm">
            <v-text-field
              v-model="editDialog.data.name"
              label="Player Name"
              variant="outlined"
              class="mb-4"
            />
            <v-text-field
              v-model="editDialog.data.genre"
              label="Genre"
              variant="outlined"
              class="mb-4"
            />
            <v-textarea
              v-model="editDialog.data.bio"
              label="Biography"
              variant="outlined"
              rows="4"
              class="mb-4"
            />
            <v-text-field
              v-model="editDialog.data.image_url"
              label="Image URL"
              variant="outlined"
              class="mb-4"
            />
            <v-img
              v-if="editDialog.data.image_url"
              :src="editDialog.data.image_url"
              height="150"
              cover
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
        <v-card-title>Delete Player</v-card-title>
        <v-card-text>
          Are you sure you want to delete <strong>{{ deleteDialog.player?.name }}</strong>?
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
import type { Player } from '~/types';
import type { PlayerInput, PlayerUpdate } from '~/composables/useAdminPlayers';
import { useAdminPlayers } from '~/composables/useAdminPlayers';

definePageMeta({
  middleware: ['auth'],
  layout: 'admin',
});

const { players, isLoading, fetchPlayers, createPlayer, updatePlayer, deletePlayer } = useAdminPlayers();

const createDialog = ref<{
  show: boolean;
  loading: boolean;
  data: PlayerInput;
}>({
  show: false,
  loading: false,
  data: {
    name: '',
    genre: '',
    bio: '',
    image_url: '',
  },
});

const editDialog = ref<{
  show: boolean;
  loading: boolean;
  player: Player | null;
  data: PlayerInput;
}>({
  show: false,
  loading: false,
  player: null,
  data: {
    name: '',
    genre: '',
    bio: '',
    image_url: '',
  },
});

const deleteDialog = ref<{
  show: boolean;
  loading: boolean;
  player: Player | null;
}>({
  show: false,
  loading: false,
  player: null,
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
      genre: '',
      bio: '',
      image_url: '',
    },
  };
};

const showEditDialog = (player: Player) => {
  editDialog.value = {
    show: true,
    loading: false,
    player,
    data: {
      name: player.name,
      genre: player.genre || '',
      bio: player.bio || '',
      image_url: player.image_url || '',
    },
  };
};

const confirmDelete = (player: Player) => {
  deleteDialog.value = {
    show: true,
    loading: false,
    player,
  };
};

const handleCreate = async () => {
  createDialog.value.loading = true;
  try {
    await createPlayer(createDialog.value.data);
    snackbar.value = {
      show: true,
      message: 'Player created successfully',
      color: 'success',
    };
    createDialog.value.show = false;
    fetchPlayers();
  } catch (err: unknown) {
    const e = err as { data?: { error?: string } };
    snackbar.value = {
      show: true,
      message: e.data?.error || 'Failed to create player',
      color: 'error',
    };
  } finally {
    createDialog.value.loading = false;
  }
};

const handleUpdate = async () => {
  if (!editDialog.value.player) return;

  editDialog.value.loading = true;
  try {
    const data: PlayerUpdate = {};
    if (editDialog.value.data.name !== editDialog.value.player.name) {
      data.name = editDialog.value.data.name;
    }
    if (editDialog.value.data.genre !== (editDialog.value.player.genre || '')) {
      data.genre = editDialog.value.data.genre;
    }
    if (editDialog.value.data.bio !== (editDialog.value.player.bio || '')) {
      data.bio = editDialog.value.data.bio;
    }
    if (editDialog.value.data.image_url !== (editDialog.value.player.image_url || '')) {
      data.image_url = editDialog.value.data.image_url;
    }

    await updatePlayer(editDialog.value.player.id, data);
    snackbar.value = {
      show: true,
      message: 'Player updated successfully',
      color: 'success',
    };
    editDialog.value.show = false;
    fetchPlayers();
  } catch (err: unknown) {
    const e = err as { data?: { error?: string } };
    snackbar.value = {
      show: true,
      message: e.data?.error || 'Failed to update player',
      color: 'error',
    };
  } finally {
    editDialog.value.loading = false;
  }
};

const handleDelete = async () => {
  if (!deleteDialog.value.player) return;

  deleteDialog.value.loading = true;
  try {
    await deletePlayer(deleteDialog.value.player.id);
    snackbar.value = {
      show: true,
      message: 'Player deleted successfully',
      color: 'success',
    };
    deleteDialog.value.show = false;
    fetchPlayers();
  } catch (err: unknown) {
    const e = err as { data?: { error?: string } };
    snackbar.value = {
      show: true,
      message: e.data?.error || 'Failed to delete player',
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
  fetchPlayers();
});
</script>

<style scoped>
.player-card {
  transition: transform 0.2s;
}

.player-card:hover {
  transform: translateY(-4px);
}
</style>
