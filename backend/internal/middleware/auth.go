package middleware

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"guitar-stock/internal/config"
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
