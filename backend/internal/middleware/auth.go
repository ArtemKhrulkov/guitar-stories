package middleware

import (
	"errors"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"

	"guitar-stock/internal/config"
	"guitar-stock/internal/repository"
)

func BasicAuth(cfg *config.Config) gin.HandlerFunc {
	return func(c *gin.Context) {
		user, pass, ok := c.Request.BasicAuth()
		if !ok || user != cfg.AdminUser || pass != cfg.AdminPass {
			c.Header("WWW-Authenticate", "Basic realm=Admin")
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
			c.Abort()
			return
		}
		c.Next()
	}
}

type AuthMiddleware struct {
	userRepo *repository.UserRepository
}

func NewAuthMiddleware(userRepo *repository.UserRepository) *AuthMiddleware {
	return &AuthMiddleware{userRepo: userRepo}
}

func (m *AuthMiddleware) RequireAuth() gin.HandlerFunc {
	return func(c *gin.Context) {
		userID, err := m.getUserIDFromCookie(c)
		if err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Authentication required"})
			c.Abort()
			return
		}

		user, err := m.userRepo.FindByID(userID)
		if err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "User not found"})
			c.Abort()
			return
		}

		if !user.EmailVerified {
			c.JSON(http.StatusForbidden, gin.H{"error": "Please verify your email"})
			c.Abort()
			return
		}

		// Set user info in context
		c.Set("user_id", user.ID)
		c.Set("user_role", user.Role)
		c.Set("user_email", user.Email)

		c.Next()
	}
}

func (m *AuthMiddleware) RequireAdmin() gin.HandlerFunc {
	return func(c *gin.Context) {
		// First check if it's a basic auth admin (backward compatibility)
		user, pass, ok := c.Request.BasicAuth()
		if ok && user == "admin" && pass == "changeme" {
			c.Next()
			return
		}

		// Then check for cookie-based admin
		userID, err := m.getUserIDFromCookie(c)
		if err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Authentication required"})
			c.Abort()
			return
		}

		userObj, err := m.userRepo.FindByID(userID)
		if err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "User not found"})
			c.Abort()
			return
		}

		if userObj.Role != "admin" {
			c.JSON(http.StatusForbidden, gin.H{"error": "Admin access required"})
			c.Abort()
			return
		}

		c.Set("user_id", userObj.ID)
		c.Set("user_role", userObj.Role)
		c.Set("user_email", userObj.Email)

		c.Next()
	}
}

func (m *AuthMiddleware) getUserIDFromCookie(c *gin.Context) (uuid.UUID, error) {
	cookie, err := c.Cookie("auth_token")
	if err != nil || cookie == "" {
		return uuid.Nil, errors.New("no cookie")
	}

	userID, err := uuid.Parse(cookie)
	if err != nil {
		return uuid.Nil, errors.New("invalid cookie")
	}

	return userID, nil
}
