package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"

	"guitar-stock/internal/repository"
)

type BrandHandler struct {
	repo *repository.BrandRepository
}

func NewBrandHandler(repo *repository.BrandRepository) *BrandHandler {
	return &BrandHandler{repo: repo}
}

func (h *BrandHandler) GetAll(c *gin.Context) {
	brands, err := h.repo.FindAll()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch brands"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"brands": brands})
}

func (h *BrandHandler) GetByID(c *gin.Context) {
	idStr := c.Param("id")
	id, err := uuid.Parse(idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid brand ID"})
		return
	}

	brand, guitars, err := h.repo.FindByIDWithGuitars(id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Brand not found"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"brand":   brand,
		"guitars": guitars,
	})
}
