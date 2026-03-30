<template>
    <v-chip
        closable
        size="small"
        class="comparison-chip"
        @click:close="$emit('remove')"
    >
        <v-avatar start size="20" class="mr-1">
            <v-img
                v-if="guitar.image_url && !guitar.image_url.includes('placeholder')"
                :src="guitar.image_url"
                :alt="guitar.model"
            />
            <IconifyIcon v-else icon="mdi-guitar-electric" size="14" />
        </v-avatar>
        <span class="chip-text">{{ guitar.brand?.name }} {{ guitar.model }}</span>
    </v-chip>
</template>

<script setup lang="ts">
import type { Guitar } from '~/types'

defineProps<{
    guitar: Guitar
}>()

defineEmits<{
    remove: []
}>()
</script>

<style scoped>
.comparison-chip {
    background-color: rgb(var(--v-theme-surface));
    border: 1px solid rgb(var(--v-theme-outline));
}

.chip-text {
    max-width: 150px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}
</style>
