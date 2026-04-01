package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"

	"guitar-stock/internal/models"
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

type CreateBrandRequest struct {
	Name        string  `json:"name" binding:"required"`
	Country     string  `json:"country" binding:"required"`
	FoundedYear *int    `json:"founded_year"`
	Description *string `json:"description"`
	LogoURL     *string `json:"logo_url"`
}

type UpdateBrandRequest struct {
	Name        *string `json:"name"`
	Country     *string `json:"country"`
	FoundedYear *int    `json:"founded_year"`
	Description *string `json:"description"`
	LogoURL     *string `json:"logo_url"`
}

func (h *BrandHandler) Create(c *gin.Context) {
	var req CreateBrandRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	brand := &models.Brand{
		Name:    req.Name,
		Country: req.Country,
	}

	if req.FoundedYear != nil {
		brand.FoundedYear = req.FoundedYear
	}
	if req.Description != nil {
		brand.Description = req.Description
	}
	if req.LogoURL != nil {
		brand.LogoURL = req.LogoURL
	}

	if err := h.repo.Create(brand); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create brand"})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"brand": brand})
}

func (h *BrandHandler) Update(c *gin.Context) {
	idStr := c.Param("id")
	id, err := uuid.Parse(idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid brand ID"})
		return
	}

	brand, err := h.repo.FindByID(id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Brand not found"})
		return
	}

	var req UpdateBrandRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if req.Name != nil {
		brand.Name = *req.Name
	}
	if req.Country != nil {
		brand.Country = *req.Country
	}
	if req.FoundedYear != nil {
		brand.FoundedYear = req.FoundedYear
	}
	if req.Description != nil {
		brand.Description = req.Description
	}
	if req.LogoURL != nil {
		brand.LogoURL = req.LogoURL
	}

	if err := h.repo.Update(brand); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update brand"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"brand": brand})
}

func (h *BrandHandler) Delete(c *gin.Context) {
	idStr := c.Param("id")
	id, err := uuid.Parse(idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid brand ID"})
		return
	}

	if err := h.repo.Delete(id); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete brand"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Brand deleted successfully"})
}
