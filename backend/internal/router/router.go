package router

import (
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"

	"guitar-stock/internal/config"
	"guitar-stock/internal/handlers"
	"guitar-stock/internal/middleware"
	"guitar-stock/internal/repository"
	"guitar-stock/internal/scraper"
)

func Setup(db *gorm.DB, cfg *config.Config, scraperService *scraper.Service) *gin.Engine {
	r := gin.Default()

	r.Use(cors.New(cors.Config{
		AllowOrigins:     []string{cfg.AllowedOrigins},
		AllowMethods:     []string{"GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"},
		AllowHeaders:     []string{"Origin", "Content-Type", "Accept", "Authorization"},
		AllowCredentials: true,
	}))

	// Repositories
	brandRepo := repository.NewBrandRepository(db)
	guitarRepo := repository.NewGuitarRepository(db)
	playerRepo := repository.NewPlayerRepository(db)
	purchaseLinkRepo := repository.NewPurchaseLinkRepository(db)
	userRepo := repository.NewUserRepository(db)
	wishlistRepo := repository.NewWishlistRepository(db)

	// Handlers
	brandHandler := handlers.NewBrandHandler(brandRepo)
	guitarHandler := handlers.NewGuitarHandler(guitarRepo)
	playerHandler := handlers.NewPlayerHandler(playerRepo)
	authHandler := handlers.NewAuthHandler(cfg, userRepo, wishlistRepo)
	adminHandler := handlers.NewAdminHandler(purchaseLinkRepo, guitarRepo)
	scraperHandler := handlers.NewScraperHandler(scraperService)

	// Middleware
	authMiddleware := middleware.NewAuthMiddleware(userRepo)

	api := r.Group("/api")
	{
		// Public routes
		api.GET("/brands", brandHandler.GetAll)
		api.GET("/brands/:id", brandHandler.GetByID)

		api.GET("/guitars", guitarHandler.GetAll)
		api.GET("/guitars/:id", guitarHandler.GetByID)

		api.GET("/players", playerHandler.GetAll)
		api.GET("/players/:id", playerHandler.GetByID)

		// Auth routes (public)
		api.POST("/auth/register", authHandler.Register)
		api.POST("/auth/verify-email", authHandler.VerifyEmail)
		api.POST("/auth/request-password-reset", authHandler.RequestPasswordReset)
		api.POST("/auth/reset-password", authHandler.ResetPassword)
		api.POST("/auth/login", authHandler.Login)
		api.POST("/auth/logout", authHandler.Logout)
		api.GET("/auth/check", authHandler.Check)

		// User routes (requires auth)
		user := api.Group("")
		user.Use(authMiddleware.RequireAuth())
		{
			user.GET("/auth/me", authHandler.GetProfile)
			user.PUT("/auth/profile", authHandler.UpdateProfile)

			// Wishlist routes
			user.GET("/wishlist", authHandler.GetWishlist)
			user.POST("/wishlist", authHandler.AddToWishlist)
			user.DELETE("/wishlist/:guitar_id", authHandler.RemoveFromWishlist)
		}

		// Admin routes (Basic Auth + cookie-based)
		admin := api.Group("/admin")
		admin.Use(authMiddleware.RequireAdmin())
		{
			admin.POST("/scrape/:guitar_id", scraperHandler.ScrapeGuitar)
			admin.POST("/scrape/all", scraperHandler.ScrapeAll)
			admin.POST("/scrape/sync-price-ranges", scraperHandler.SyncPriceRanges)
			admin.GET("/links", adminHandler.GetLinks)
			admin.POST("/links", adminHandler.AddLink)
			admin.PATCH("/links", adminHandler.UpdateLink)
			admin.DELETE("/links", adminHandler.DeleteLink)
			admin.POST("/guitars", guitarHandler.Create)
			admin.PATCH("/guitars/:id", guitarHandler.Update)
			admin.DELETE("/guitars/:id", guitarHandler.Delete)
			admin.POST("/brands", brandHandler.Create)
			admin.PATCH("/brands/:id", brandHandler.Update)
			admin.DELETE("/brands/:id", brandHandler.Delete)
			admin.POST("/players", playerHandler.Create)
			admin.PATCH("/players/:id", playerHandler.Update)
			admin.DELETE("/players/:id", playerHandler.Delete)
		}
	}

	return r
}
