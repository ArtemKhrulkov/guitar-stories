<template>
  <v-card>
    <v-card-title class="d-flex align-center">
      <IconifyIcon icon="mdi-shopping" color="secondary" class="mr-2" aria-hidden="true" />
      <span>Where to Buy</span>
    </v-card-title>

    <v-card-text>
      <v-row v-if="links.length === 0">
        <v-col cols="12">
          <div class="text-center text-medium-emphasis py-4">
            <IconifyIcon icon="mdi-cart-off" size="48" class="mb-2" aria-hidden="true" />
            <p class="mb-0" role="status">No purchase links available</p>
          </div>
        </v-col>
      </v-row>

      <v-list v-else density="compact" aria-label="Purchase links">
        <v-list-item
          v-for="link in groupedLinks"
          :key="link.id"
          :href="link.url"
          target="_blank"
          rel="noopener noreferrer"
          class="mb-2"
          :aria-label="`Buy on ${getPlatformName(link.platform)}${link.price_rub ? ` for ${formatPrice(link.price_rub, 'RUB')}` : ''}`"
        >
          <template #prepend>
            <v-avatar :color="getPlatformColor(link.platform)" size="40" aria-hidden="true">
              <IconifyIcon :icon="getPlatformIcon(link.platform)" size="24" />
            </v-avatar>
          </template>

          <v-list-item-title class="font-weight-bold">
            {{ getPlatformName(link.platform) }}
          </v-list-item-title>

          <v-list-item-subtitle>
            <div class="d-flex align-center flex-wrap gap-2">
              <span v-if="link.price_rub" class="text-body-2 font-weight-medium">
                {{ formatPrice(link.price_rub, 'RUB') }}
              </span>
              <span v-if="link.price_usd" class="text-body-2">
                {{ formatPrice(link.price_usd, 'USD') }}
              </span>

              <span
                :class="
                  link.in_stock
                    ? 'stock-badge stock-badge--in-stock'
                    : 'stock-badge stock-badge--out-of-stock'
                "
                role="status"
              >
                <span class="stock-indicator" aria-hidden="true" />
                {{ link.in_stock ? 'In Stock' : 'Out of Stock' }}
              </span>

              <span
                v-if="getPriceTrend(link)"
                class="price-trend"
                :class="getPriceTrend(link)!.direction"
              >
                <IconifyIcon
                  :icon="
                    getPriceTrend(link)!.direction === 'down'
                      ? 'mdi-trending-down'
                      : 'mdi-trending-up'
                  "
                  size="16"
                />
                <span>{{ getPriceTrend(link)!.percent }}%</span>
              </span>
            </div>
          </v-list-item-subtitle>

          <template #append>
            <span class="sr-only">(opens in new tab)</span>
            <IconifyIcon icon="mdi-open-in-new" size="18" aria-hidden="true" />
          </template>
        </v-list-item>
      </v-list>

      <div
        v-if="lastScraped"
        class="text-caption text-medium-emphasis mt-4 text-center"
        role="status"
      >
        Last updated: {{ formatDate(lastScraped) }}
      </div>
    </v-card-text>
  </v-card>
</template>

<script setup lang="ts">
import type { PurchaseLink } from '~/types';

const props = defineProps<{
  links: PurchaseLink[];
}>();

interface PriceTrend {
  direction: 'up' | 'down';
  percent: number;
}

const groupedLinks = computed(() => props.links);

const getPriceTrend = (link: PurchaseLink): PriceTrend | null => {
  if (!link.price_history || link.price_history.length < 2) return null;

  const sortedHistory = [...link.price_history].sort(
    (a, b) => new Date(b.recorded_at).getTime() - new Date(a.recorded_at).getTime(),
  );

  const currentPrice = link.price_rub;
  const previousPrice = sortedHistory[1]?.price_rub;

  if (!currentPrice || !previousPrice || previousPrice === 0) return null;

  const change = ((currentPrice - previousPrice) / previousPrice) * 100;

  if (Math.abs(change) < 1) return null;

  return {
    direction: change > 0 ? 'up' : 'down',
    percent: Math.abs(Math.round(change)),
  };
};

const getPlatformColor = (platform: string) => {
  const colors: Record<string, string> = {
    ozon: 'blue',
    wildberries: 'purple',
    sweetwater: 'orange',
    guitarcenter: 'teal',
  };
  return colors[platform] || 'grey';
};

const getPlatformIcon = (platform: string) => {
  const icons: Record<string, string> = {
    ozon: 'mdi-alpha-o-box',
    wildberries: 'mdi-shopping',
    sweetwater: 'mdi-music',
    guitarcenter: 'mdi-guitar-electric',
  };
  return icons[platform] || 'mdi-shopping';
};

const getPlatformName = (platform: string) => {
  const names: Record<string, string> = {
    ozon: 'Ozon',
    wildberries: 'Wildberries',
    sweetwater: 'Sweetwater',
    guitarcenter: 'Guitar Center',
  };
  return names[platform] || platform;
};

const formatPrice = (price: number, currency: string) => {
  return new Intl.NumberFormat('ru-RU', {
    style: 'currency',
    currency: currency,
    minimumFractionDigits: 0,
    maximumFractionDigits: 0,
  }).format(price);
};

const formatDate = (dateString: string) => {
  return new Date(dateString).toLocaleDateString('ru-RU', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  });
};

const lastScraped = computed(() => {
  const dates = props.links
    .filter((l) => l.last_scraped)
    .map((l) => new Date(l.last_scraped!))
    .sort((a, b) => b.getTime() - a.getTime());
  return dates[0]?.toISOString();
});
</script>

<style scoped>
.gap-2 {
  gap: 0.5rem;
}

.stock-badge {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  font-size: 0.75rem;
  padding: 2px 8px;
  border-radius: 4px;
}

.stock-badge--in-stock {
  background-color: #dcfce7;
  color: #166534;
}

.stock-badge--out-of-stock {
  background-color: #fee2e2;
  color: #991b1b;
}

.stock-indicator {
  width: 6px;
  height: 6px;
  border-radius: 50%;
}

.stock-badge--in-stock .stock-indicator {
  background-color: #22c55e;
}

.stock-badge--out-of-stock .stock-indicator {
  background-color: #ef4444;
}

.price-trend {
  display: inline-flex;
  align-items: center;
  gap: 2px;
  font-size: 0.75rem;
  font-weight: 500;
  padding: 2px 6px;
  border-radius: 4px;
}

.price-trend.up {
  background-color: #fee2e2;
  color: #dc2626;
}

.price-trend.down {
  background-color: #dcfce7;
  color: #16a34a;
}

.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}
</style>
