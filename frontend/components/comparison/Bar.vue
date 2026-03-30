<template>
    <Transition name="slide-up">
        <div v-if="!comparisonStore.isEmpty" class="comparison-bar">
            <v-container fluid class="py-2">
                <div class="d-flex align-center justify-space-between flex-wrap ga-2">
                    <div class="d-flex align-center ga-2 flex-wrap">
                        <span class="text-caption text-medium-emphasis mr-2">
                            {{ comparisonStore.count }}/{{ comparisonStore.MAX_GUITARS }} selected
                        </span>
                        <ComparisonChip
                            v-for="guitar in comparisonStore.selectedGuitars"
                            :key="guitar.id"
                            :guitar="guitar"
                            @remove="comparisonStore.removeGuitar(guitar.id)"
                        />
                    </div>
                    <div class="d-flex align-center ga-2">
                        <v-btn
                            variant="text"
                            size="small"
                            @click="comparisonStore.clearAll()"
                        >
                            Clear All
                        </v-btn>
                        <v-btn
                            color="primary"
                            variant="flat"
                            size="small"
                            :disabled="comparisonStore.count < 2"
                            @click="navigateToCompare"
                        >
                            <IconifyIcon icon="mdi-compare-horizontal" class="mr-1" />
                            Compare {{ comparisonStore.count }} Guitars
                        </v-btn>
                    </div>
                </div>
            </v-container>
        </div>
    </Transition>
</template>

<script setup lang="ts">
import { useComparisonStore } from '~/stores/comparison'

const router = useRouter()
const comparisonStore = useComparisonStore()

const navigateToCompare = () => {
    router.push('/compare')
}
</script>

<style scoped>
.comparison-bar {
    position: fixed;
    bottom: 0;
    left: 0;
    right: 0;
    background: rgb(var(--v-theme-surface));
    border-top: 1px solid rgb(var(--v-theme-outline));
    box-shadow: 0 -4px 12px rgba(0, 0, 0, 0.1);
    z-index: 100;
}

.slide-up-enter-active,
.slide-up-leave-active {
    transition: transform 0.3s ease, opacity 0.3s ease;
}

.slide-up-enter-from,
.slide-up-leave-to {
    transform: translateY(100%);
    opacity: 0;
}
</style>
