package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

type ScraperHandler struct{}

func NewScraperHandler() *ScraperHandler {
	return &ScraperHandler{}
}

func (h *ScraperHandler) ScrapeGuitar(c *gin.Context) {
	c.JSON(http.StatusServiceUnavailable, gin.H{
		"error": "Scraper is currently disabled. Please add purchase links manually via POST /api/admin/links",
		"links": []interface{}{},
	})
}

func (h *ScraperHandler) ScrapeAll(c *gin.Context) {
	c.JSON(http.StatusServiceUnavailable, gin.H{
		"error": "Scraper is currently disabled. Please add purchase links manually via POST /api/admin/links",
	})
}
