package handlers

import (
	"encoding/json"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"

	"guitar-stock/internal/models"
	"guitar-stock/internal/repository"
)

type GuitarHandler struct {
	repo *repository.GuitarRepository
}

func NewGuitarHandler(repo *repository.GuitarRepository) *GuitarHandler {
	return &GuitarHandler{repo: repo}
}

func (h *GuitarHandler) GetAll(c *gin.Context) {
	filter := repository.GuitarFilter{}

	if brandID := c.Query("brand"); brandID != "" {
		id, err := uuid.Parse(brandID)
		if err == nil {
			filter.BrandID = &id
		}
	}

	if guitarType := c.Query("type"); guitarType != "" {
		gt := models.GuitarType(guitarType)
		filter.Type = &gt
	}

	if search := c.Query("search"); search != "" {
		filter.Search = &search
	}

	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	limit, _ := strconv.Atoi(c.DefaultQuery("limit", "12"))
	filter.Page = page
	filter.Limit = limit

	guitars, total, err := h.repo.FindAll(filter)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch guitars"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"guitars": guitars,
		"total":   total,
		"page":    page,
		"limit":   limit,
	})
}

func (h *GuitarHandler) GetByID(c *gin.Context) {
	idStr := c.Param("id")
	id, err := uuid.Parse(idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid guitar ID"})
		return
	}

	guitar, err := h.repo.FindByID(id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Guitar not found"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"guitar":         guitar,
		"players":        guitar.Players,
		"purchase_links": guitar.PurchaseLinks,
	})
}

type UpdateGuitarRequest struct {
	Model          *string                 `json:"model"`
	ImageURL       *string                 `json:"image_url"`
	GuitarType     *string                 `json:"guitar_type"`
	Specifications *map[string]interface{} `json:"specifications"`
}

func (h *GuitarHandler) Update(c *gin.Context) {
	idStr := c.Param("id")
	id, err := uuid.Parse(idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid guitar ID"})
		return
	}

	var req UpdateGuitarRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	guitar, err := h.repo.FindByID(id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Guitar not found"})
		return
	}

	if req.Model != nil {
		guitar.Model = *req.Model
	}

	if req.ImageURL != nil {
		guitar.ImageURL = req.ImageURL
	}

	if req.GuitarType != nil {
		validTypes := map[string]bool{
			"electric": true,
			"acoustic": true,
			"bass":     true,
		}
		if !validTypes[*req.GuitarType] {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid guitar_type. Must be one of: electric, acoustic, bass"})
			return
		}
		gt := models.GuitarType(*req.GuitarType)
		guitar.GuitarType = gt
	}

	if req.Specifications != nil {
		specJSON, err := json.Marshal(req.Specifications)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid specifications format"})
			return
		}
		var specs models.Specifications
		if err := json.Unmarshal(specJSON, &specs); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid specifications format"})
			return
		}
		guitar.Specifications = &specs
	}

	if err := h.repo.Update(guitar); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update guitar"})
		return
	}

	updatedGuitar, err := h.repo.FindByID(id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch updated guitar"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"guitar": updatedGuitar})
}
