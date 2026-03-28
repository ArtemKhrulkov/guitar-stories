package scraper

import (
	"crypto/sha256"
	"encoding/hex"
	"sync"
	"time"
)

type ImageCache struct {
	mu        sync.RWMutex
	entries   map[string]*CacheEntry
	maxAge    time.Duration
	hitCount  int64
	missCount int64
}

type CacheEntry struct {
	URL       string
	Source    string
	Timestamp time.Time
}

func NewImageCache(ttl time.Duration) *ImageCache {
	cache := &ImageCache{
		entries: make(map[string]*CacheEntry),
		maxAge:  ttl,
	}

	go cache.cleanup()

	return cache
}

func (c *ImageCache) Get(brand, model string) (string, string, bool) {
	key := c.makeKey(brand, model)

	c.mu.RLock()
	entry, exists := c.entries[key]
	c.mu.RUnlock()

	if !exists {
		c.mu.Lock()
		c.missCount++
		c.mu.Unlock()
		return "", "", false
	}

	if time.Since(entry.Timestamp) > c.maxAge {
		c.mu.Lock()
		delete(c.entries, key)
		c.mu.Unlock()
		c.mu.Lock()
		c.missCount++
		c.mu.Unlock()
		return "", "", false
	}

	c.mu.Lock()
	c.hitCount++
	c.mu.Unlock()

	return entry.URL, entry.Source, true
}

func (c *ImageCache) Set(brand, model, url, source string) {
	key := c.makeKey(brand, model)

	c.mu.Lock()
	c.entries[key] = &CacheEntry{
		URL:       url,
		Source:    source,
		Timestamp: time.Now(),
	}
	c.mu.Unlock()
}

func (c *ImageCache) makeKey(brand, model string) string {
	hash := sha256.Sum256([]byte(brand + "|" + model))
	return hex.EncodeToString(hash[:8])
}

func (c *ImageCache) cleanup() {
	ticker := time.NewTicker(5 * time.Minute)
	defer ticker.Stop()

	for range ticker.C {
		c.mu.Lock()
		now := time.Now()
		for key, entry := range c.entries {
			if now.Sub(entry.Timestamp) > c.maxAge {
				delete(c.entries, key)
			}
		}
		c.mu.Unlock()
	}
}

func (c *ImageCache) Stats() (hits, misses int64, size int) {
	c.mu.RLock()
	defer c.mu.RUnlock()
	return c.hitCount, c.missCount, len(c.entries)
}
