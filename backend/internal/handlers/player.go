package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"

	"guitar-stock/internal/models"
	"guitar-stock/internal/repository"
)

type PlayerHandler struct {
	repo *repository.PlayerRepository
}

func NewPlayerHandler(repo *repository.PlayerRepository) *PlayerHandler {
	return &PlayerHandler{repo: repo}
}

func (h *PlayerHandler) GetAll(c *gin.Context) {
	players, err := h.repo.FindAll()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch players"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"players": players})
}

func (h *PlayerHandler) GetByID(c *gin.Context) {
	idStr := c.Param("id")
	id, err := uuid.Parse(idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid player ID"})
		return
	}

	player, guitars, err := h.repo.FindByIDWithGuitars(id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Player not found"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"player":  player,
		"guitars": guitars,
	})
}

type CreatePlayerRequest struct {
	Name     string  `json:"name" binding:"required"`
	Genre    string  `json:"genre"`
	Bio      *string `json:"bio"`
	ImageURL *string `json:"image_url"`
}

type UpdatePlayerRequest struct {
	Name     *string `json:"name"`
	Genre    *string `json:"genre"`
	Bio      *string `json:"bio"`
	ImageURL *string `json:"image_url"`
}

func (h *PlayerHandler) Create(c *gin.Context) {
	var req CreatePlayerRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	player := &models.Player{
		Name:  req.Name,
		Genre: req.Genre,
	}

	{
		player.Genre = req.Genre
	}
	if req.Bio != nil {
		player.Bio = req.Bio
	}
	if req.ImageURL != nil {
		player.ImageURL = req.ImageURL
	}

	if err := h.repo.Create(player); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create player"})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"player": player})
}

func (h *PlayerHandler) Update(c *gin.Context) {
	idStr := c.Param("id")
	id, err := uuid.Parse(idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid player ID"})
		return
	}

	player, err := h.repo.FindByID(id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Player not found"})
		return
	}

	var req UpdatePlayerRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if req.Name != nil {
		player.Name = *req.Name
	}
	if req.Genre != nil {
		player.Genre = *req.Genre
	}
	if req.Bio != nil {
		player.Bio = req.Bio
	}
	if req.ImageURL != nil {
		player.ImageURL = req.ImageURL
	}

	if err := h.repo.Update(player); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update player"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"player": player})
}

func (h *PlayerHandler) Delete(c *gin.Context) {
	idStr := c.Param("id")
	id, err := uuid.Parse(idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid player ID"})
		return
	}

	if err := h.repo.Delete(id); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete player"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Player deleted successfully"})
}
