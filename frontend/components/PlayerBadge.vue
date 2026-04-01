<template>
  <v-chip
    :to="`/players/${player.id}`"
    size="small"
    color="primary"
    variant="outlined"
    :aria-label="`View ${player.name}${player.genre ? `, ${player.genre}` : ''}`"
  >
    <v-avatar start size="20" class="mr-1" aria-hidden="true">
      <NuxtImg
        :src="player.image_url || 'https://via.placeholder.com/20'"
        :alt="''"
        width="20"
        height="20"
        loading="lazy"
        format="webp"
        quality="80"
      />
    </v-avatar>
    {{ player.name }}

    <v-tooltip v-if="player.genre" activator="parent" location="top">
      {{ player.genre }}
    </v-tooltip>
  </v-chip>
</template>

<script setup lang="ts">
import type { Player } from '~/types';

defineProps<{
  player: Player;
}>();
</script>
