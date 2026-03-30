import type { Guitar, Specifications } from '~/types'

export type SpecKey = keyof Specifications

export interface SpecSection {
  title: string
  keys: SpecKey[]
}

export const SPEC_SECTIONS: SpecSection[] = [
  {
    title: 'General',
    keys: ['body_wood', 'neck_wood', 'fretboard'],
  },
  {
    title: 'Electronics',
    keys: ['pickup_config'],
  },
  {
    title: 'Playability',
    keys: ['frets', 'scale_length'],
  },
  {
    title: 'Hardware',
    keys: ['bridge', 'tuners', 'hardware'],
  },
]

export const SPEC_LABELS: Record<SpecKey, string> = {
  body_wood: 'Body Wood',
  neck_wood: 'Neck Wood',
  fretboard: 'Fretboard',
  pickup_config: 'Pickup Config',
  frets: 'Frets',
  scale_length: 'Scale Length',
  hardware: 'Hardware',
  bridge: 'Bridge',
  tuners: 'Tuners',
}

export const useComparison = () => {
  const config = useRuntimeConfig()
  const apiUrl = config.public.apiUrl

  const guitars = ref<Guitar[]>([])
  const loading = ref(false)
  const error = ref<string | null>(null)

  const fetchGuitarsForComparison = async (ids: string[]) => {
    if (ids.length === 0) {
      guitars.value = []
      return
    }

    loading.value = true
    error.value = null

    try {
      const results = await Promise.all(
        ids.map(id =>
          $fetch<{ guitar: Guitar }>(`${apiUrl}/guitars/${id}`)
            .then(res => res.guitar)
            .catch(() => null)
        )
      )
      guitars.value = results.filter((g): g is Guitar => g !== null)
    } catch (e: any) {
      error.value = e.message || 'Failed to fetch guitars for comparison'
      console.error('Error fetching guitars:', e)
    } finally {
      loading.value = false
    }
  }

  const getDifferingKeys = (): SpecKey[] => {
    if (guitars.value.length < 2) return []

    const differing: SpecKey[] = []

    for (const section of SPEC_SECTIONS) {
      for (const key of section.keys) {
        const values = guitars.value.map(g => g.specifications?.[key])
        const firstValue = values[0]

        if (firstValue !== undefined && values.some(v => v !== firstValue)) {
          differing.push(key)
        }
      }
    }

    return differing
  }

  const getSpecValue = (guitar: Guitar, key: SpecKey): string | number | undefined => {
    return guitar.specifications?.[key]
  }

  const formatSpecValue = (value: string | number | undefined): string => {
    if (value === undefined || value === null) return '—'
    return String(value)
  }

  const extractPriceUSD = (priceRange: string | undefined): string => {
    if (!priceRange) return '—'
    const match = priceRange.match(/(\d[\d\s]*)\s*USD/i)
    return match ? match[1].replace(/\s/g, ' ') + ' USD' : '—'
  }

  const extractPriceRUB = (priceRange: string | undefined): string => {
    if (!priceRange) return '—'
    const match = priceRange.match(/(\d[\d\s]*)\s*RUB/i)
    return match ? match[1].replace(/\s/g, ' ') + ' RUB' : '—'
  }

  return {
    guitars,
    loading,
    error,
    fetchGuitarsForComparison,
    getDifferingKeys,
    getSpecValue,
    formatSpecValue,
    extractPriceUSD,
    extractPriceRUB,
    SPEC_SECTIONS,
    SPEC_LABELS,
  }
}
