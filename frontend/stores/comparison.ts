import { defineStore } from 'pinia';
import type { Guitar } from '~/types';

const STORAGE_KEY = 'guitar-comparison';
const MAX_GUITARS = 4;

export const useComparisonStore = defineStore('comparison', () => {
  const selectedGuitars = ref<Guitar[]>([]);

  const loadFromStorage = () => {
    if (typeof window === 'undefined') return;
    try {
      const stored = localStorage.getItem(STORAGE_KEY);
      if (stored) {
        selectedGuitars.value = JSON.parse(stored);
      }
    } catch {
      selectedGuitars.value = [];
    }
  };

  const saveToStorage = () => {
    if (typeof window === 'undefined') return;
    try {
      localStorage.setItem(STORAGE_KEY, JSON.stringify(selectedGuitars.value));
    } catch {
      console.warn('Failed to save comparison to localStorage');
    }
  };

  const addGuitar = (guitar: Guitar): boolean => {
    if (selectedGuitars.value.length >= MAX_GUITARS) {
      return false;
    }
    if (selectedGuitars.value.some((g) => g.id === guitar.id)) {
      return true;
    }
    selectedGuitars.value.push(guitar);
    saveToStorage();
    return true;
  };

  const removeGuitar = (id: string) => {
    selectedGuitars.value = selectedGuitars.value.filter((g) => g.id !== id);
    saveToStorage();
  };

  const clearAll = () => {
    selectedGuitars.value = [];
    saveToStorage();
  };

  const isSelected = (id: string): boolean => {
    return selectedGuitars.value.some((g) => g.id === id);
  };

  const count = computed(() => selectedGuitars.value.length);
  const isFull = computed(() => selectedGuitars.value.length >= MAX_GUITARS);
  const isEmpty = computed(() => selectedGuitars.value.length === 0);

  if (typeof window !== 'undefined') {
    loadFromStorage();
  }

  return {
    selectedGuitars,
    addGuitar,
    removeGuitar,
    clearAll,
    isSelected,
    count,
    isFull,
    isEmpty,
    MAX_GUITARS,
    loadFromStorage,
  };
});
