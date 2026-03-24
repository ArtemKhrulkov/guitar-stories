package handlers

import (
	"net/http"
	"time"

	"github.com/gin-gonic/gin"

	"guitar-stock/internal/config"
)

type AuthHandler struct {
	cfg *config.Config
}

func NewAuthHandler(cfg *config.Config) *AuthHandler {
	return &AuthHandler{cfg: cfg}
}

type LoginRequest struct {
	Username string `json:"username" binding:"required"`
	Password string `json:"password" binding:"required"`
}

func (h *AuthHandler) Login(c *gin.Context) {
	var req LoginRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if req.Username != h.cfg.AdminUser || req.Password != h.cfg.AdminPass {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid credentials"})
		return
	}

	c.SetCookie(
		"admin_auth",
		"authenticated",
		86400,
		"/",
		"",
		false,
		true,
	)

	c.JSON(http.StatusOK, gin.H{"success": true})
}

func (h *AuthHandler) Logout(c *gin.Context) {
	c.SetCookie(
		"admin_auth",
		"",
		-1,
		"/",
		"",
		false,
		true,
	)

	c.JSON(http.StatusOK, gin.H{"success": true})
}

func (h *AuthHandler) Check(c *gin.Context) {
	cookie, err := c.Cookie("admin_auth")
	if err != nil || cookie != "authenticated" {
		c.JSON(http.StatusUnauthorized, gin.H{"authenticated": false})
		return
	}

	c.JSON(http.StatusOK, gin.H{"authenticated": true, "expires": time.Now().Add(24 * time.Hour).Unix()})
}
